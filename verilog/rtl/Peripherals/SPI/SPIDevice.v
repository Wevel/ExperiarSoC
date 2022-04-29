module SPIDevice #(
		parameter ID = 4'h0,
		parameter WIDTH = 8,
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
		inout wire[31:0] peripheralBus_data,

		// SPI interface
		output wire spi_en,
		output wire spi_clk,
		output wire spi_mosi,
		input  wire spi_miso,
		output wire spi_cs
	);

	localparam WIDTH_BITS = $clog2(WIDTH);
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
	// Configuration register 	Default 0x64
	// b00-b02: clockScale 		Default 0x4
	// b03-04: spiMode 			Default 0x0
	// b05: msbFirst 			Default 0x1
	// b06: useCS 				Default 0x1
	// b07: activeHighCS		Default 0x0
	wire[7:0] configuration;
	ConfigurationRegister #(.WIDTH(8), .ADDRESS(12'h000), .DEFAULT(8'h64)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_data(peripheralBus_data),
		.currentValue(configuration));

	// Input and Output register
	wire[WIDTH-1:0] readData;
	wire[WIDTH-1:0] writeData;
	wire writeData_en;
	DataRegister #(.WIDTH(WIDTH), .ADDRESS(12'h004)) dataRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(peripheralBus_busy),
		.peripheralBus_address(localAddress),
		.peripheralBus_data(peripheralBus_data),
		.writeData(writeData),
		.writeData_en(writeData_en),
		.writeData_busy(),
		.readData(readData),
		.readData_en(),
		.readData_busy());

	wire[2:0] clockScale = configuration[2:0];
	wire[1:0] spiMode = configuration[4:3];
	wire msbFirst = configuration[5];
	wire useCS = configuration[6];
	wire activeHighCS = configuration[7];
	wire spiClockPolarity = spiMode[1];
	wire spiSampleMode = spiMode[0];

	// State control
	reg[1:0] state = STATE_IDLE;
	wire busy = state != STATE_IDLE;
	
	reg[WIDTH_BITS-1:0] bitCounter = 'b0;
	wire[WIDTH_BITS-1:0] nextBitCounter = bitCounter + 1;

	reg[CLOCK_WIDTH-1:0] clockCounter = 'b0;
	wire nextClockCounter = clockCounter + 1;
	wire[CLOCK_WIDTH-1:0] clockScaleHalfMask = CLOCK_BITS'b1 << clockScale;
	wire[CLOCK_WIDTH-1:0] clockScaleMask 	 = { clockScaleMask[CLOCK_WIDTH-2:0], 1'b0 };
	wire spiHalfClock = clockCounter == (clockScaleHalfMask - 1);//|(clockCounter & clockScaleHalfMask);
	wire spiClock 	  = clockCounter == (clockScaleMask - 1);

	reg spiClockRise = 1'b0;
	reg spiClockFall = 1'b0;

	wire shiftInEnable  = spiSampleMode ? spiClockFall : spiClockRise;
	wire shiftOutEnable = spiSampleMode ? spiClockRise : spiClockFall;

	reg loadEnable;
	ShiftRegister #(.WIDTH(WIDTH)) register (
		.clk(clk),
		.rst(rst),
		.loadEnable(loadEnable),
		.shiftInEnable(shiftInEnable),
		.shiftOutEnable(shiftOutEnable),
		.msbFirst(msbFirst),
		.parallelIn(writeData),
		.parallelOut(readData),
		.serialIn(spi_miso),
		.serialOut(spi_mosi));

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_IDLE;
			bitCounter <= 'b0;
			clockCounter <= 1'b0;
			loadEnable <= 1'b0;
			spiClockRise <= 1'b0;
			spiClockFall <= 1'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					bitCounter <= 'b0;
					clockCounter <= 1'b0;
					loadEnable <= 1'b0;

					if (writeData_en) begin 
						state <= STATE_SETUP;
						loadEnable <= 1'b1;
					end
				end

				STATE_SETUP: begin
					loadEnable <= 1'b0;

					if (spiHalfClock) begin
						clockCounter <= 1'b0;
						bitCounter <= 1'b0;
						state <= STATE_SHIFT;
					end else begin
						clockCounter <= nextClockCounter;
					end
				end

				STATE_SHIFT: begin
					if (spiClock) begin
						if (spiClockPolarity) begin
							spiClockRise <= 1'b0;
							spiClockFall <= 1'b1;
						end else begin
							spiClockRise <= 1'b1;
							spiClockFall <= 1'b0;
						end

						clockCounter <= 1'b0;
						if (bitCounter == (WIDTH_BITS - 1)) state <= STATE_END;
						else bitCounter <= nextBitCounter;
					end else if (spiHalfClock) begin
						if (spiClockPolarity) begin
							spiClockRise <= 1'b1;
							spiClockFall <= 1'b0;
						end else begin
							spiClockRise <= 1'b0;
							spiClockFall <= 1'b1;
						end
						
					end else begin
						spiClockRise <= 1'b0;
						spiClockFall <= 1'b0;
						clockCounter <= nextClockCounter;
					end
				end

				STATE_END: begin
					spiClockRise <= 1'b0;
					spiClockFall <= 1'b0;
					
					if (spiClock) state <= STATE_IDLE;
					else clockCounter <= nextClockCounter;
				end

				default: begin
					state <= STATE_IDLE;
					bitCounter <= 'b0;
					clockCounter <= 1'b0;
					loadEnable <= 1'b0;
					spiClockRise <= 1'b0;
					spiClockFall <= 1'b0;
				end
			endcase
		end
	end

	assign peripheralBus_busy = busy;
	assign spi_clk = spiClockPolarity ? !(spiClock && busy) : spiClock && busy;
	assign spi_cs = useCS ? (activeHighCS ? busy : !busy) : 1'b0;

endmodule