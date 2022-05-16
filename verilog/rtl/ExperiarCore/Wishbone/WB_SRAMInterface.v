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

		output wire[23:0] localMemoryAddress,
		output wire[3:0] localMemoryByteSelect,
		output wire localMemoryWriteEnable,
		output wire localMemoryReadEnable,
		output wire[31:0] localMemoryDataWrite,
		input wire[31:0] localMemoryDataRead,
		input wire localMemoryBusy
	);
	
	localparam STATE_IDLE  = 2'h0;
	localparam STATE_WRITE_SINGLE = 2'h1;
	localparam STATE_READ_SINGLE  = 2'h2;
	
	reg[1:0] state = STATE_IDLE;
	reg[23:0] currentAddress;
	reg[3:0] currentByteSelect;
	reg[31:0] currentDataIn;

	wire isStateReadSingle = state == STATE_READ_SINGLE;
	wire isStateWriteSingle = state == STATE_WRITE_SINGLE;
	wire isStateIdle = state == STATE_IDLE;

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
					if (!localMemoryBusy) begin
						state <= STATE_IDLE;
						acknowledge <= 1'b1;
					end
				end

				STATE_READ_SINGLE: begin
					if (!localMemoryBusy) begin
						state <= STATE_IDLE;
						acknowledge <= 1'b1;
					end
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

	// Connect local memory interface signals
	assign localMemoryAddress = !isStateIdle ? currentAddress : 24'b0;
	assign localMemoryByteSelect = !isStateIdle ? currentByteSelect : 4'b0;
	assign localMemoryWriteEnable = isStateWriteSingle;
	assign localMemoryReadEnable = isStateReadSingle;
	assign localMemoryDataWrite = isStateWriteSingle ? wb_data_i : 32'b0;
	assign wb_data_o = isStateReadSingle ? localMemoryDataRead : 32'b0;

endmodule