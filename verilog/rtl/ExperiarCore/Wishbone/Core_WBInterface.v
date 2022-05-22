module Core_WBInterface (
		// Wishbone master interface
		input wire wb_clk_i,
		input wire wb_rst_i,
		output wire wb_cyc_o,
		output wire wb_stb_o,
		output wire wb_we_o,
		output wire[3:0] wb_sel_o,
		output wire[31:0] wb_data_o,
		output wire[27:0] wb_adr_o,
		input wire wb_ack_i,
		input wire wb_stall_i,
		input wire wb_error_i,
		input wire[31:0] wb_data_i,

		// Memory interface from core
		input wire[27:0] wbAddress,
		input wire[3:0] wbByteSelect,
		input wire wbWriteEnable,
		input wire wbReadEnable,
		input wire[31:0] wbDataWrite,
		output wire[31:0] wbDataRead,
		output wire wbBusy
	);

	localparam STATE_IDLE  		  = 2'h0;
	localparam STATE_WRITE_SINGLE = 2'h1;
	localparam STATE_READ_SINGLE  = 2'h2;
	
	reg[1:0] state = STATE_IDLE;

	reg stb = 1'b0;

	always @(posedge wb_clk_i) begin
		if (wb_rst_i || (wb_error_i && state != STATE_IDLE)) begin
			state <= STATE_IDLE;
			stb <= 1'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					if (wbWriteEnable) begin
						state <= STATE_WRITE_SINGLE;
						stb <= 1'b1;
					end else if (wbReadEnable) begin
						state <= STATE_READ_SINGLE;
						stb <= 1'b1;
					end
				end

				STATE_WRITE_SINGLE: begin
					stb <= 1'b0;
					
					if (wb_ack_i) begin
						state <= STATE_IDLE;
					end
				end

				STATE_READ_SINGLE: begin
					stb <= 1'b0;

					if (wb_ack_i) begin
						state <= STATE_IDLE;
					end
				end
				
				default: begin
					state <= STATE_IDLE;
					stb <= 1'b0;
				end
			endcase
		end
	end

	assign wb_cyc_o = state != STATE_IDLE;
	assign wb_stb_o = stb;

	assign wb_we_o = state == STATE_WRITE_SINGLE;
	assign wb_sel_o = stb ? wbByteSelect : 4'b0;
	assign wb_data_o = stb ? wbDataWrite : 32'b0;
	assign wb_adr_o = stb ? wbAddress : 28'b0;
	
	assign wbDataRead = wb_ack_i ? wb_data_i : 32'b0;
	assign wbBusy = state != STATE_IDLE;

endmodule