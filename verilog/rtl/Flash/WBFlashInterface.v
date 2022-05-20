module WBFlashInterface (
		// Wishbone Slave ports
		input wire wb_clk_i,
		input wire wb_rst_i,
		input wire wb_stb_i,
		input wire wb_cyc_i,
		input wire wb_we_i,
		input wire[3:0] wb_sel_i,
		input wire[31:0] wb_data_i,
		input wire[23:0] wb_adr_i,
		output wire wb_ack_o,
		output wire wb_stall_o,
		output wire wb_error_o,
		output wire[31:0] wb_data_o,

		// Flash cache interface
		output wire flashCache_readEnable,
		output wire[23:0] flashCache_address,
		output wire[3:0] flashCache_byteSelect,
		input wire[31:0] flashCache_dataRead,
		input wire flashCache_busy
	);

	localparam STATE_IDLE  		  = 2'h0;
	localparam STATE_WRITE_SINGLE = 2'h1;
	localparam STATE_READ_SINGLE  = 2'h2;
	localparam STATE_FINISH 	  = 2'h3;
	
	reg[1:0] state = STATE_IDLE;
	reg[23:0] currentAddress;
	reg[3:0] currentByteSelect;
	reg[31:0] currentDataIn;

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
					// Not allowed to write, so just acknowledge so the bus doesn't hang
					state <= STATE_FINISH;
					acknowledge <= 1'b1;
				end

				STATE_READ_SINGLE: begin
					if (!flashCache_busy) begin
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

	// Connect peripheral bus signals
	assign flashCache_readEnable = state == STATE_READ_SINGLE;

	assign flashCache_address = state != STATE_IDLE ? currentAddress : 24'b0;
	assign flashCache_byteSelect = state != STATE_IDLE ? currentByteSelect : 4'b0;

	assign wb_data_o = state == STATE_READ_SINGLE ? flashCache_dataRead : 32'b0;
	
endmodule