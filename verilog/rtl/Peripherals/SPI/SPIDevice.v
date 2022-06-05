module SPIDevice #(
		parameter ID = 4'h0,
		parameter CLOCK_WIDTH = 8
	)(
		input wire clk,
		input wire rst,

		// Peripheral bus
		input wire peripheralEnable,
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[15:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		output reg[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,

		// SPI interface
		output wire spi_en,
		output reg spi_clk,
		output wire spi_mosi,
		input  wire spi_miso,
		output wire spi_cs
	);

	localparam CLOCK_BITS = $clog2(CLOCK_WIDTH);

	localparam STATE_IDLE  = 2'b00;
	localparam STATE_SETUP = 2'b01;
	localparam STATE_SHIFT = 2'b10;
	localparam STATE_END   = 2'b11;

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Register
	// Configuration register 	Default 0x064
	// b00-b02: clockScale 		Default 0x4
	// b03-04: spiMode 			Default 0x0
	// b05: msbFirst 			Default 0x1
	// b06: useCS 				Default 0x1
	// b07: activeHighCS		Default 0x0
	// b08: enable				Default 0x0
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	wire[8:0] configuration;
	ConfigurationRegister #(.WIDTH(9), .ADDRESS(12'h000), .DEFAULT(9'h064)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(configurationRegisterOutputData),
		.requestOutput(configurationRegisterOutputRequest),
		.currentValue(configuration));

	wire[2:0] clockScale = configuration[2:0];
	wire[1:0] spiMode = configuration[4:3];
	wire msbFirst = configuration[5];
	wire useCS = configuration[6];
	wire activeHighCS = configuration[7];
	assign spi_en = configuration[8];
	wire spiClockPolarity = spiMode[1];
	wire spiSampleMode = spiMode[0];

	// Status register
	wire deviceBusy = state != STATE_IDLE;
	wire[31:0] statusRegisterOutputData;
	wire statusRegisterOutputRequest;
	wire statusRegisterWriteData_nc;
	wire statusRegisterWriteDataEnable_nc;
	wire statusRegisterReadDataEnable_nc;
	wire statusRegisterBusBusy_nc;
	DataRegister #(.WIDTH(1), .ADDRESS(12'h004)) statusRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(statusRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(statusRegisterOutputData),
		.requestOutput(statusRegisterOutputRequest),
		.writeData(statusRegisterWriteData_nc),
		.writeData_en(statusRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(deviceBusy),
		.readData_en(statusRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	// Input and Output register
	wire[31:0] dataRegisterOutputData;
	wire dataRegisterOutputRequest;
	wire[7:0] dataRegisterReadData;
	wire[7:0] dataRegisterWriteData;	
	wire dataRegisterWriteDataEnable;
	wire dataRegisterBusBusy;
	wire dataRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(8), .ADDRESS(12'h008)) dataRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(dataRegisterBusBusy),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(dataRegisterOutputData),
		.requestOutput(dataRegisterOutputRequest),
		.writeData(dataRegisterWriteData),
		.writeData_en(dataRegisterWriteDataEnable),
		.writeData_busy(deviceBusy),
		.readData(dataRegisterReadData),
		.readData_en(dataRegisterReadDataEnable_nc),
		.readData_busy(deviceBusy));

	// State control
	reg[1:0] state = STATE_IDLE;
	
	reg[2:0] bitCounter = 3'b0;
	wire[2:0] nextBitCounter = bitCounter + 1;

	reg[CLOCK_WIDTH-1:0] clockCounter = {CLOCK_WIDTH{1'b0}};
	wire[CLOCK_WIDTH-1:0] nextClockCounter = clockCounter + 1;
	wire[CLOCK_WIDTH-1:0] clockScaleCompare = { {(CLOCK_WIDTH-1){1'b0}}, 1'b1 } << clockScale;
	wire[CLOCK_WIDTH-1:0] clockScaleHalfCompare = { 1'b0, clockScaleCompare[CLOCK_WIDTH-1:1] };
	wire halfClockCounterMatch = nextClockCounter == clockScaleHalfCompare;
	wire clockCounterMatch     = nextClockCounter == clockScaleCompare;

	reg spiClockRise = 1'b0;
	reg spiClockFall = 1'b0;
	reg spiClock;

	wire shiftInEnable  = spiSampleMode ? spiClockFall : spiClockRise;
	wire shiftOutEnable = spiSampleMode ? spiClockRise : spiClockFall;
	
	wire serialOut;
	ShiftRegister #(.WIDTH(8)) register (
		.clk(clk),
		.rst(rst),
		.loadEnable(dataRegisterWriteDataEnable),
		.shiftInEnable(shiftInEnable),
		.shiftOutEnable(shiftOutEnable),
		.msbFirst(msbFirst),
		.parallelIn(dataRegisterWriteData),
		.parallelOut(dataRegisterReadData),
		.serialIn(spi_miso),
		.serialOut(serialOut));

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_IDLE;
			bitCounter <= 3'b0;
			clockCounter <= {CLOCK_WIDTH{1'b0}};
			spiClockRise <= 1'b0;
			spiClockFall <= 1'b0;
			spiClock <= 1'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					bitCounter <= 3'b0;
					clockCounter <= {CLOCK_WIDTH{1'b0}};
					spiClockRise <= 1'b0;
					spiClockFall <= 1'b0;
					spiClock <= 1'b0;

					if (dataRegisterWriteDataEnable && peripheralBus_byteSelect[0]) begin 
						state <= STATE_SETUP;
					end
				end

				STATE_SETUP: begin
					clockCounter <= nextClockCounter;

					if (halfClockCounterMatch) begin
						bitCounter <= 1'b0;
						spiClock <= 1'b1;
						state <= STATE_SHIFT;

						if (spiClockPolarity) begin
							spiClockRise <= 1'b0;
							spiClockFall <= 1'b1;
						end else begin
							spiClockRise <= 1'b1;
							spiClockFall <= 1'b0;
						end	
					end					
				end

				STATE_SHIFT: begin
					if (clockCounterMatch) begin
						clockCounter <= {CLOCK_WIDTH{1'b0}};
						spiClock <= 1'b0;

						if (spiClockPolarity) begin
							spiClockRise <= 1'b1;
							spiClockFall <= 1'b0;
						end else begin
							spiClockRise <= 1'b0;
							spiClockFall <= 1'b1;
						end

						if (bitCounter == 3'h7) begin
							state <= STATE_END;
						end	else begin
							bitCounter <= nextBitCounter;
						end
					end else if (halfClockCounterMatch) begin
						if (spiClockPolarity) begin
							spiClockRise <= 1'b0;
							spiClockFall <= 1'b1;
						end else begin
							spiClockRise <= 1'b1;
							spiClockFall <= 1'b0;
						end	

						spiClock <= 1'b1;
						clockCounter <= nextClockCounter;
					end else begin
						spiClockRise <= 1'b0;
						spiClockFall <= 1'b0;
						clockCounter <= nextClockCounter;
					end
				end

				STATE_END: begin
					spiClockRise <= 1'b0;
					spiClockFall <= 1'b0;
					spiClock <= 1'b0;
					
					if (clockCounterMatch) state <= STATE_IDLE;
					else clockCounter <= nextClockCounter;
				end

				default: begin
					state <= STATE_IDLE;
					bitCounter <= 3'b0;
					clockCounter <= {CLOCK_WIDTH{1'b0}};
					spiClockRise <= 1'b0;
					spiClockFall <= 1'b0;
					spiClock <= 1'b0;
				end
			endcase
		end
	end

	// Buffer the spi clock by one cycle so that it lines up with when data is sampled
	always @(posedge clk) begin
		if (rst) spi_clk <= 1'b0;
		else spi_clk <= spiClockPolarity ? !spiClock : spiClock;
	end

	assign requestOutput = configurationRegisterOutputRequest || statusRegisterOutputRequest || dataRegisterOutputRequest;

	always @(*) begin
		case (1'b1)
			configurationRegisterOutputRequest: peripheralBus_dataRead <= configurationRegisterOutputData;
			statusRegisterOutputRequest: peripheralBus_dataRead <= statusRegisterOutputData;
			dataRegisterOutputRequest: peripheralBus_dataRead <= dataRegisterOutputData;
			default: peripheralBus_dataRead <=  ~32'b0;
		endcase
	end

	assign peripheralBus_busy = dataRegisterBusBusy;

	assign spi_mosi = serialOut & deviceBusy;
	assign spi_cs = useCS ? (activeHighCS ? deviceBusy : !deviceBusy) : 1'b0;

endmodule