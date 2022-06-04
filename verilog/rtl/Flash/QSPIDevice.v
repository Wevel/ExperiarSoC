module QSPIDevice #(
		parameter CLOCK_WIDTH = 8
	)(
		input wire clk,
		input wire rst,

		// Cache interface
		input wire[23:0] dataRequest_address,
		input wire dataRequest_enable,
		output wire[31:0] dataRequest_data,
		output wire dataRequest_dataValid,

		// QSPI interface
		output wire flash_csb,
		output wire flash_sck,
		output wire flash_io0_we,
		output wire flash_io0_write,
		input wire flash_io0_read, 	// Unused
		output wire flash_io1_we,
		output wire flash_io1_write,  // Unused (constant 1'b0)
		input wire flash_io1_read
	);
	
	// Have this running at the system clock rate
	// This will probably be 40MHz
	assign flash_sck = clk;

	assign flash_csb = 1'b0;
	assign flash_io0_we = 1'b1;
	assign flash_io0_write = 1'b0;
	assign flash_io1_we = 1'b0;
	assign flash_io1_write = 1'b0;
	//assign in = flash_io1_read;

	assign dataRequest_data = 32'b0;
	assign dataRequest_dataValid = 1'b1;

	// localparam CLOCK_BITS = $clog2(CLOCK_WIDTH);

	// localparam STATE_IDLE  = 2'b00;
	// localparam STATE_SETUP = 2'b01;
	// localparam STATE_SHIFT = 2'b10;
	// localparam STATE_END   = 2'b11;

	// // Device select
	// wire[11:0] localAddress;
	// wire deviceEnable;
	// DeviceSelect #(.ID(ID)) select(
	// 	.peripheralEnable(peripheralEnable),
	// 	.peripheralBus_address(peripheralBus_address),
	// 	.localAddress(localAddress),
	// 	.deviceEnable(deviceEnable));

	// // Register
	// // Configuration register 	Default 0x064
	// // b00-b02: clockScale 		Default 0x4
	// // b03-04: spiMode 			Default 0x0
	// // b05: msbFirst 			Default 0x1
	// // b06: useCS 				Default 0x1
	// // b07: activeHighCS		Default 0x0
	// // b08: enable				Default 0x0
	// wire[31:0] configurationRegisterOutputData;
	// wire configurationRegisterOutputRequest;
	// wire[8:0] configuration;
	// ConfigurationRegister #(.WIDTH(9), .ADDRESS(12'h000), .DEFAULT(9'h064)) configurationRegister(
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.enable(deviceEnable),
	// 	.peripheralBus_we(peripheralBus_we),
	// 	.peripheralBus_oe(peripheralBus_oe),
	// 	.peripheralBus_address(localAddress),
	// 	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	// 	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	// 	.peripheralBus_dataRead(configurationRegisterOutputData),
	// 	.requestOutput(configurationRegisterOutputRequest),
	// 	.currentValue(configuration));

	// wire[2:0] clockScale = configuration[2:0];
	// wire[1:0] spiMode = configuration[4:3];
	// wire msbFirst = configuration[5];
	// wire useCS = configuration[6];
	// wire activeHighCS = configuration[7];
	// assign spi_en = configuration[8];
	// wire spiClockPolarity = spiMode[1];
	// wire spiSampleMode = spiMode[0];

	// // Input and Output register
	// wire[31:0] dataRegisterOutputData;
	// wire dataRegisterOutputRequest;
	// wire[7:0] readData;
	// wire[7:0] writeData;	
	// wire writeData_en;
	// wire dataRegisterBusBusy_nc;
	// wire dataRegisterReadDataEnable_nc;
	// DataRegister #(.WIDTH(8), .ADDRESS(12'h004)) dataRegister(
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.enable(deviceEnable),
	// 	.peripheralBus_we(peripheralBus_we),
	// 	.peripheralBus_oe(peripheralBus_oe),
	// 	.peripheralBus_busy(dataRegisterBusBusy_nc),
	// 	.peripheralBus_address(localAddress),
	// 	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	// 	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	// 	.peripheralBus_dataRead(dataRegisterOutputData),
	// 	.requestOutput(dataRegisterOutputRequest),
	// 	.writeData(writeData),
	// 	.writeData_en(writeData_en),
	// 	.writeData_busy(1'b0),
	// 	.readData(readData),
	// 	.readData_en(dataRegisterReadDataEnable_nc),
	// 	.readData_busy(1'b0));

	// // State control
	// reg[1:0] state = STATE_IDLE;
	// wire busy = state != STATE_IDLE;
	
	// reg[2:0] bitCounter = 3'b0;
	// wire[2:0] nextBitCounter = bitCounter + 1;

	// reg[CLOCK_WIDTH-1:0] clockCounter = {CLOCK_WIDTH{1'b0}};
	// wire nextClockCounter = clockCounter + 1;
	// wire[CLOCK_WIDTH-1:0] clockScaleHalfMask = {(CLOCK_WIDTH-1){1'b0}, 1'b1} << clockScale;
	// wire[CLOCK_WIDTH-1:0] clockScaleMask 	 = { clockScaleMask[CLOCK_WIDTH-2:0], 1'b0 };
	// wire spiHalfClock = clockCounter == (clockScaleHalfMask - 1);//|(clockCounter & clockScaleHalfMask);
	// wire spiClock 	  = clockCounter == (clockScaleMask - 1);

	// reg spiClockRise = 1'b0;
	// reg spiClockFall = 1'b0;

	// wire shiftInEnable  = spiSampleMode ? spiClockFall : spiClockRise;
	// wire shiftOutEnable = spiSampleMode ? spiClockRise : spiClockFall;

	// reg loadEnable;
	// ShiftRegister #(.WIDTH(8)) register (
	// 	.clk(clk),
	// 	.rst(rst),
	// 	.loadEnable(loadEnable),
	// 	.shiftInEnable(shiftInEnable),
	// 	.shiftOutEnable(shiftOutEnable),
	// 	.msbFirst(msbFirst),
	// 	.parallelIn(writeData),
	// 	.parallelOut(readData),
	// 	.serialIn(spi_miso),
	// 	.serialOut(spi_mosi));

	// always @(posedge clk) begin
	// 	if (rst) begin
	// 		state <= STATE_IDLE;
	// 		bitCounter <= 3'b0;
	// 		clockCounter <= {CLOCK_WIDTH{1'b0}};
	// 		loadEnable <= 1'b0;
	// 		spiClockRise <= 1'b0;
	// 		spiClockFall <= 1'b0;
	// 	end else begin
	// 		case (state)
	// 			STATE_IDLE: begin
	// 				bitCounter <= 3'b0;
	// 				clockCounter <= {CLOCK_WIDTH{1'b0}};
	// 				loadEnable <= 1'b0;

	// 				if (writeData_en && peripheralBus_byteSelect[0]) begin 
	// 					state <= STATE_SETUP;
	// 					loadEnable <= 1'b1;
	// 				end
	// 			end

	// 			STATE_SETUP: begin
	// 				loadEnable <= 1'b0;

	// 				if (spiHalfClock) begin
	// 					clockCounter <= {CLOCK_WIDTH{1'b0}};
	// 					bitCounter <= 1'b0;
	// 					state <= STATE_SHIFT;
	// 				end else begin
	// 					clockCounter <= nextClockCounter;
	// 				end
	// 			end

	// 			STATE_SHIFT: begin
	// 				if (spiClock) begin
	// 					if (spiClockPolarity) begin
	// 						spiClockRise <= 1'b0;
	// 						spiClockFall <= 1'b1;
	// 					end else begin
	// 						spiClockRise <= 1'b1;
	// 						spiClockFall <= 1'b0;
	// 					end

	// 					clockCounter <= {CLOCK_WIDTH{1'b0}};
	// 					if (bitCounter == 3'h7) state <= STATE_END;
	// 					else bitCounter <= nextBitCounter;
	// 				end else if (spiHalfClock) begin
	// 					if (spiClockPolarity) begin
	// 						spiClockRise <= 1'b1;
	// 						spiClockFall <= 1'b0;
	// 					end else begin
	// 						spiClockRise <= 1'b0;
	// 						spiClockFall <= 1'b1;
	// 					end
						
	// 				end else begin
	// 					spiClockRise <= 1'b0;
	// 					spiClockFall <= 1'b0;
	// 					clockCounter <= nextClockCounter;
	// 				end
	// 			end

	// 			STATE_END: begin
	// 				spiClockRise <= 1'b0;
	// 				spiClockFall <= 1'b0;
					
	// 				if (spiClock) state <= STATE_IDLE;
	// 				else clockCounter <= nextClockCounter;
	// 			end

	// 			default: begin
	// 				state <= STATE_IDLE;
	// 				bitCounter <= 3'b0;
	// 				clockCounter <= {CLOCK_WIDTH{1'b0}};
	// 				loadEnable <= 1'b0;
	// 				spiClockRise <= 1'b0;
	// 				spiClockFall <= 1'b0;
	// 			end
	// 		endcase
	// 	end
	// end

	// assign requestOutput = configurationRegisterOutputRequest || dataRegisterOutputRequest;
	// assign peripheralBus_dataRead = configurationRegisterOutputRequest ? configurationRegisterOutputData :
	// 							    dataRegisterOutputRequest 		   ? dataRegisterOutputData :
	// 												   					 32'b0;																			
	// assign peripheralBus_busy = busy;

	// assign spi_clk = spiClockPolarity ? !(spiClock && busy) : spiClock && busy;
	// assign spi_cs = useCS ? (activeHighCS ? busy : !busy) : 1'b0;

endmodule