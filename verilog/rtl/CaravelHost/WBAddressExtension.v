module WBAddressExtension (
		input wire wb_clk_i,
		input wire wb_rst_i,
		
		// Wishbone Slave port from caravel
		input wire wbs_cyc_i,
		input wire wbs_stb_i,
		input wire wbs_we_i,
		input wire[3:0] wbs_sel_i,
		input wire[31:0] wbs_adr_i,
		input wire[31:0] wbs_data_i,
		output wire wbs_ack_o,
		output wire[31:0] wbs_data_o,

		// Wishbone connection to user space
		output wire userSpace_wb_cyc_i,
		output wire userSpace_wb_stb_i,
		output wire userSpace_wb_we_i,
		output wire[3:0] userSpace_wb_sel_i,
		output wire[31:0] userSpace_wb_adr_i,
		output wire[31:0] userSpace_wb_data_i,
		input wire userSpace_wb_ack_o,
		input wire[31:0] userSpace_wb_data_o
	);
	
	reg[31:0] currentAddress = 32'b0;

	// Connect user space wishbone bus
	wire userSpaceSelect = wbs_adr_i[15];
	wire[14:0] addressOffset = wbs_adr_i[14:0];

	assign userSpace_wb_cyc_i = wbs_cyc_i && userSpaceSelect;
	assign userSpace_wb_stb_i = wbs_stb_i;
	assign userSpace_wb_we_i = wbs_we_i;
	assign userSpace_wb_sel_i = wbs_sel_i;
	assign userSpace_wb_adr_i = { currentAddress[31:15], addressOffset };
	assign userSpace_wb_data_i = wbs_data_i;

	// Wishbone interface to allow setting current addres
	localparam STATE_IDLE  		  = 2'h0;
	localparam STATE_WRITE_SINGLE = 2'h1;
	localparam STATE_READ_SINGLE  = 2'h2;
	localparam STATE_FINISH 	  = 2'h3;
	
	reg[1:0] state = STATE_IDLE;
	reg[3:0] currentByteSelect;
	reg[31:0] currentDataIn;

	reg acknowledge = 1'b0;
	reg[31:0] dataRead_buffered = ~32'b0;

	always @(posedge wb_clk_i) begin
		if (wb_rst_i) begin
			state <= STATE_IDLE;
			acknowledge <= 1'b0;
			dataRead_buffered <= ~32'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					acknowledge <= 1'b0;
					dataRead_buffered <= ~32'b0;

					if (wbs_cyc_i && !userSpaceSelect) begin
						if (wbs_stb_i) begin
							if (wbs_we_i) begin
								state <= STATE_WRITE_SINGLE;
							end else begin
								state <= STATE_READ_SINGLE;
							end
						end
					end
				end

				STATE_WRITE_SINGLE: begin
					state <= STATE_FINISH;
					acknowledge <= 1'b1;
					if (wbs_sel_i[0]) currentAddress[7:0]   <= wbs_data_i[7:0];
					if (wbs_sel_i[1]) currentAddress[15:8]  <= wbs_data_i[15:8];
					if (wbs_sel_i[2]) currentAddress[23:16] <= wbs_data_i[23:16];
					if (wbs_sel_i[3]) currentAddress[31:24] <= wbs_data_i[31:24];
				end

				STATE_READ_SINGLE: begin
					state <= STATE_FINISH;
					acknowledge <= 1'b1;
					dataRead_buffered <= currentAddress;
				end

				STATE_FINISH: begin
					state <= STATE_IDLE;
					acknowledge <= 1'b0;
					dataRead_buffered <= ~32'b0;
				end

				default: begin
					state <= STATE_IDLE;
					acknowledge <= 1'b0;
				end				
			endcase
		end
	end

	// Connect wishbone return signals
	assign wbs_ack_o = userSpaceSelect ? userSpace_wb_ack_o : acknowledge;
	assign wbs_data_o = userSpaceSelect ? userSpace_wb_data_o : dataRead_buffered;
	
endmodule