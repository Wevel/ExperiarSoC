module Flash (
	`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire wb_clk_i,
		input wire wb_rst_i,

		// Wishbone interface
		input wire wb_cyc_i,
		input wire wb_stb_i,
		input wire wb_we_i,
		input wire[3:0] wb_sel_i,
		input wire[31:0] wb_data_i,
		input wire[23:0] wb_adr_i,
		output wire wb_ack_o,
		output wire wb_stall_o,
		output wire wb_error_o,
		output wire[31:0] wb_data_o,

		// Flash QSPI
		output wire flash_csb,
		output wire flash_sck,
		output wire flash_io0_we,
		output wire flash_io0_write,
		input wire flash_io0_read,
		output wire flash_io1_we,
		output wire flash_io1_write,
		input wire flash_io1_read,

		// Flash controller SRAM rw port
		output wire sram_clk0,
		output wire sram_csb0,
		output wire sram_web0,
		output wire[3:0] sram_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0,
		output wire[31:0] sram_din0,
		input wire[31:0] sram_dout0,

		// Wishbone SRAM r port
		output wire sram_clk1,
		output wire sram_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1,
		input wire[31:0] sram_dout1
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	localparam STATE_STARTUP 	   	 = 2'b00;
	localparam STATE_WRITE_COMMAND 	 = 2'b01;
	localparam STATE_CHANGE_ADDRESS  = 2'b11;
	localparam STATE_READ_CONTINUOUS = 2'b11;
	
	// Wishbone interface
	wire flashCache_readEnable;
	wire[23:0] flashCache_address;
	wire[3:0] flashCache_byteSelect;
	wire[31:0] flashCache_dataRead;
	wire flashCache_busy;

	WBFlashInterface wbFlashInterface(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_stb_i(wb_stb_i),
		.wb_cyc_i(wb_cyc_i),
		.wb_we_i(wb_we_i),
		.wb_sel_i(wb_sel_i),
		.wb_data_i(wb_data_i),
		.wb_adr_i(wb_adr_i),
		.wb_ack_o(wb_ack_o),
		.wb_stall_o(wb_stall_o),
		.wb_error_o(wb_error_o),
		.wb_data_o(wb_data_o),
		.flashCache_readEnable(flashCache_readEnable),
		.flashCache_address(flashCache_address),
		.flashCache_byteSelect(flashCache_byteSelect),
		.flashCache_dataRead(flashCache_dataRead),
		.flashCache_busy(flashCache_busy));

	// Flash cache
	wire[23:0] dataRequest_address;
	wire dataRequest_enable;
	wire[31:0] dataRequest_data;
	wire dataRequest_dataValid;

	FlashBuffer flashBuffer(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.flashCache_readEnable(flashCache_readEnable),
		.flashCache_address(flashCache_address),
		.flashCache_byteSelect(flashCache_byteSelect),
		.flashCache_dataRead(flashCache_dataRead),
		.flashCache_busy(flashCache_busy),
		.dataRequest_address(dataRequest_address),
		.dataRequest_enable(dataRequest_enable),
		.dataRequest_data(dataRequest_data),
		.dataRequest_dataValid(dataRequest_dataValid),
		.sram_clk0(sram_clk0),
		.sram_csb0(sram_csb0),
		.sram_web0(sram_web0),
		.sram_wmask0(sram_wmask0),
		.sram_addr0(sram_addr0),
		.sram_din0(sram_din0),
		.sram_dout0(sram_dout0),
		.sram_clk1(sram_clk1),
		.sram_csb1(sram_csb1),
		.sram_addr1(sram_addr1),
		.sram_dout1(sram_dout1));

	// QSPI controller
	QSPIDevice #(.CLOCK_WIDTH(8)) qspiDevice (
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.dataRequest_address(dataRequest_address),
		.dataRequest_enable(dataRequest_enable),
		.dataRequest_data(dataRequest_data),
		.dataRequest_dataValid(dataRequest_dataValid),
		.flash_csb(flash_csb),
		.flash_sck(flash_sck),
		.flash_io0_we(flash_io0_we),
		.flash_io0_write(flash_io0_write),
		.flash_io0_read(flash_io0_read),
		.flash_io1_we(flash_io1_we),
		.flash_io1_write(flash_io1_write),
		.flash_io1_read(flash_io1_read));

	// Flash controller
	// wire doneTransferByte = 1'b0;
	// reg[1:0] state = STATE_STARTUP;
	
	// reg[7:0] dataBuffer [0:3];
	// reg[1:0] bufferPointer = 2'h0;
	// wire[2:0] nextBufferPointer = bufferPointer + 1;

	// reg[31:0] currentAddress = 32'b0;
	// wire[31:0] nextAddress = currentAddress + 1;

	// reg[31:0] outputData;

	// always @(*) begin
	// 	case (bufferPointer)
	// 		2'h0: outputData <= { dataBuffer[3], dataBuffer[2], dataBuffer[1], dataBuffer[0] };
	// 		2'h1: outputData <= { dataBuffer[2], dataBuffer[1], dataBuffer[0], dataBuffer[3] };
	// 		2'h2: outputData <= { dataBuffer[1], dataBuffer[0], dataBuffer[3], dataBuffer[2] };
	// 		2'h3: outputData <= { dataBuffer[0], dataBuffer[3], dataBuffer[2], dataBuffer[1] };
	// 	endcase
	// end

	// // Parallel interface
	// wire writeEnable;
	// wire readEnable;
	// wire[7:0] writeData;
	// wire[7:0] readData;
	// wire busy;

	
		
	// always @(posedge clk) begin
	// 	if (rst) begin
	// 		state <= STATE_STARTUP;
	// 		bufferPointer <= 3'h0;
	// 		dataBuffer[0] <= 8'hFF;
	// 		dataBuffer[1] <= 8'hAB;
	// 		dataBuffer[2] <= 8'h03;
	// 		dataBuffer[3] <= 8'h00;
	// 	end else begin
	// 		case (state)
	// 			STATE_STARTUP: begin
	// 				if (doneTransferByte) begin
	// 					if (bufferPointer == 3'h1) begin 
	// 						state <= STATE_CHANGE_ADDRESS;
	// 						dataBuffer[0] <= 8'h03;
	// 						dataBuffer[1] <= 8'h00;
	// 						dataBuffer[2] <= 8'h00;
	// 						dataBuffer[3] <= 8'h00;
	// 						bufferPointer <= 3'h0;
	// 					end	else begin
	// 						bufferPointer <= nextBufferPointer;
	// 					end
	// 				end
	// 			end

	// 			STATE_WRITE_COMMAND: begin
	// 				if (doneTransferByte) begin
	// 					dataBuffer[bufferPointer] <= readData;
	// 					bufferPointer <= nextBufferPointer;
	// 					currentAddress <= nextAddress;
	// 				end
	// 			end

	// 			STATE_CHANGE_ADDRESS: begin
	// 				if (doneTransferByte) begin
	// 					if (bufferPointer == 3'h1) begin 
	// 						state <= STATE_READ_CONTINUOUS;
	// 						dataBuffer[0] <= 8'h00;
	// 						dataBuffer[1] <= 8'h00;
	// 						dataBuffer[2] <= 8'h00;
	// 						dataBuffer[3] <= 8'h00;
	// 						bufferPointer <= 3'h0;
	// 					end	else begin
	// 						bufferPointer <= nextBufferPointer;
	// 					end
	// 				end
	// 			end

	// 			STATE_READ_CONTINUOUS: begin
					
	// 			end

	// 			default:  begin
	// 				state <= STATE_STARTUP;
	// 				bufferPointer <= 3'h0;
	// 				dataBuffer[0] <= 8'hFF;
	// 				dataBuffer[1] <= 8'hAB;
	// 				dataBuffer[2] <= 8'h03;
	// 				dataBuffer[3] <= 8'h00;
	// 			end
	// 		endcase
	// 	end
	// end

	// assign writeData = dataBuffer[bufferPointer];

endmodule