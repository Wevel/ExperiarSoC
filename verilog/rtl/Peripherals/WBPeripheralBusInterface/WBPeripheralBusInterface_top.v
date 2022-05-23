module WBPeripheralBusInterface (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

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

		// Peripheral Bus
		output wire peripheralBus_we,
		output wire peripheralBus_oe,
		input wire peripheralBus_busy,
		output wire[23:0] peripheralBus_address,
		output wire[3:0] peripheralBus_byteSelect,
		input wire[31:0] peripheralBus_dataRead,
		output wire[31:0] peripheralBus_dataWrite
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
	reg[31:0] dataRead_buffered;

	always @(posedge wb_clk_i) begin
		if (wb_rst_i) begin
			state <= STATE_IDLE;
			stall <= 1'b0;
			acknowledge <= 1'b0;
			dataRead_buffered <= ~32'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					stall <= 1'b0;
					acknowledge <= 1'b0;
					dataRead_buffered <= ~32'b0;

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
						dataRead_buffered <= peripheralBus_dataRead;
					end
				end

				STATE_FINISH: begin
					state <= STATE_IDLE;
					stall <= 1'b0;
					acknowledge <= 1'b0;
					dataRead_buffered <= ~32'b0;
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
	assign peripheralBus_we = state == STATE_WRITE_SINGLE;
	assign peripheralBus_oe = state == STATE_READ_SINGLE;

	assign peripheralBus_address = state != STATE_IDLE ? currentAddress : 24'b0;
	assign peripheralBus_byteSelect = state != STATE_IDLE ? currentByteSelect : 4'b0;

	assign wb_data_o = dataRead_buffered;
	assign peripheralBus_dataWrite = state == STATE_WRITE_SINGLE ? wb_data_i : 32'b0;

endmodule