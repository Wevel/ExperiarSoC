module WB_SRAMInterface (
		input wire[3:0] coreID,

		// Wishbone slave interface to sram
		input wire wb_clk_i,
		input wire wb_rst_i,
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

		// Memory interface
		output wire[23:0] localMemoryAddress,
		output wire[3:0] localMemoryByteSelect,
		output wire localMemoryWriteEnable,
		output wire localMemoryReadEnable,
		output wire[31:0] localMemoryDataWrite,
		input wire[31:0] localMemoryDataRead,
		input wire localMemoryBusy,

		// Management interface
		output wire management_writeEnable,
		output wire management_readEnable,
		output wire[3:0] management_byteSelect,
		output wire[19:0] management_address,
		output wire[31:0] management_writeData,
		input wire[31:0] management_readData,
		input wire management_busy
	);
	
	localparam STATE_IDLE  		  = 2'h0;
	localparam STATE_WRITE_SINGLE = 2'h1;
	localparam STATE_READ_SINGLE  = 2'h2;
	localparam STATE_FINISH 	  = 2'h3;
	
	reg[1:0] state = STATE_IDLE;
	reg[23:0] currentAddress;
	reg[3:0] currentByteSelect;
	reg[31:0] currentDataIn;

	wire isStateReadSingle = state == STATE_READ_SINGLE;
	wire isStateWriteSingle = state == STATE_WRITE_SINGLE;
	wire isStateIdle = state == STATE_IDLE;

	wire peripheralBus_busy;

	reg stall = 1'b0;
	reg acknowledge = 1'b0;
	
	always @(posedge wb_clk_i) begin
		if (wb_rst_i) begin
			state <= STATE_IDLE;
			stall <= 1'b0;
			acknowledge <= 1'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					stall <= 1'b0;
					acknowledge <= 1'b0;

					if (wb_cyc_i) begin
						if (wb_stb_i) begin
							currentAddress <= wb_adr_i;
							currentByteSelect <= wb_sel_i;
							currentDataIn <= wb_data_i;
							stall <= 1'b1;

							if (wb_we_i) begin
								state <= STATE_WRITE_SINGLE;
							end else begin
								state <= STATE_READ_SINGLE;
							end
						end
					end
				end

				STATE_WRITE_SINGLE: begin
					if (!peripheralBus_busy) begin
						state <= STATE_FINISH;
						acknowledge <= 1'b1;
					end
				end

				STATE_READ_SINGLE: begin
					if (!peripheralBus_busy) begin
						state <= STATE_FINISH;
						acknowledge <= 1'b1;
					end
				end

				STATE_FINISH: begin
					state <= STATE_IDLE;
					acknowledge <= 1'b0;
				end

				default: begin
					state <= STATE_IDLE;
					stall <= 1'b0;
					acknowledge <= 1'b0;
				end
			endcase
		end
	end

	// Connect wishbone bus signals
	assign wb_ack_o = acknowledge;
	assign wb_stall_o = stall;
	assign wb_error_o = 1'b0;

	// Connect to local peripheral bus
	wire peripheralBus_we = isStateWriteSingle;
	wire peripheralBus_oe = isStateReadSingle;
	wire[19:0] peripheralBus_address = !isStateIdle ? currentAddress : 24'b0;
	wire[3:0] peripheralBus_byteSelect = !isStateIdle ? currentByteSelect : 4'b0;
	wire[31:0] peripheralBus_dataWrite = isStateWriteSingle ? wb_data_i : 32'b0;
	wire[31:0] peripheralBus_dataRead;
	assign wb_data_o = isStateReadSingle ? peripheralBus_dataRead : 32'b0;

	// Connect local memory and management interface signals
	wire localMemoryEnable = wb_adr_i[23] == 1'b0;
	wire managementEnable = wb_adr_i[23:20] == 4'h8;

	assign peripheralBus_dataRead = localMemoryEnable ? localMemoryDataRead : 
									managementEnable   ? management_readData : 32'b0;
	assign peripheralBus_busy = (localMemoryEnable && localMemoryBusy) || (managementEnable && management_busy);

	assign localMemoryWriteEnable = localMemoryEnable && peripheralBus_we;
	assign localMemoryReadEnable = localMemoryEnable && peripheralBus_oe;
	assign localMemoryAddress = peripheralBus_address;
	assign localMemoryByteSelect = peripheralBus_byteSelect;
	assign localMemoryDataWrite = peripheralBus_dataWrite;
	assign wb_data_o = isStateReadSingle ? localMemoryDataRead : 32'b0;

	assign management_writeEnable = managementEnable && peripheralBus_we;
	assign management_readEnable = managementEnable && peripheralBus_oe;
	assign management_address = peripheralBus_address;
	assign management_byteSelect = peripheralBus_byteSelect;
	assign management_writeData = peripheralBus_dataWrite;

endmodule