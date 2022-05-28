module Mux #(
		parameter WIDTH = 1,
		parameter INPUTS = 2,
		parameter DEFAULT = 'b0
	)(
		input wire[INPUTS-1:0] select,
		input wire[(WIDTH*INPUTS)-1:0] in,
		output reg[WIDTH-1:0] out,
		output wire outputEnable
	);
	
	generate
		if (INPUTS == 1) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 2) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 3) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 4) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					select[3]: out <= in[(3 * WIDTH) + WIDTH - 1:3 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 5) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					select[3]: out <= in[(3 * WIDTH) + WIDTH - 1:3 * WIDTH];
					select[4]: out <= in[(4 * WIDTH) + WIDTH - 1:4 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 6) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					select[3]: out <= in[(3 * WIDTH) + WIDTH - 1:3 * WIDTH];
					select[4]: out <= in[(4 * WIDTH) + WIDTH - 1:4 * WIDTH];
					select[5]: out <= in[(5 * WIDTH) + WIDTH - 1:5 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 7) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					select[3]: out <= in[(3 * WIDTH) + WIDTH - 1:3 * WIDTH];
					select[4]: out <= in[(4 * WIDTH) + WIDTH - 1:4 * WIDTH];
					select[5]: out <= in[(5 * WIDTH) + WIDTH - 1:5 * WIDTH];
					select[6]: out <= in[(6 * WIDTH) + WIDTH - 1:6 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else if (INPUTS == 8) begin
			always @(*) begin
				case (1'b1)
					select[0]: out <= in[WIDTH-1:0];
					select[1]: out <= in[(1 * WIDTH) + WIDTH - 1:1 * WIDTH];
					select[2]: out <= in[(2 * WIDTH) + WIDTH - 1:2 * WIDTH];
					select[3]: out <= in[(3 * WIDTH) + WIDTH - 1:3 * WIDTH];
					select[4]: out <= in[(4 * WIDTH) + WIDTH - 1:4 * WIDTH];
					select[5]: out <= in[(5 * WIDTH) + WIDTH - 1:5 * WIDTH];
					select[6]: out <= in[(6 * WIDTH) + WIDTH - 1:6 * WIDTH];
					select[7]: out <= in[(7 * WIDTH) + WIDTH - 1:7 * WIDTH];
					default: out <= DEFAULT;
				endcase
			end
		end else begin
			// integer i;
			// always @(*) begin
			// 	for (i = 0; i < INPUTS; i = i + 1) begin
			// 		if (select[i]) out <= in[(i * WIDTH) + WIDTH - 1:i * WIDTH];
			// 	end
			// end
		end
	endgenerate

	assign outputEnable = |select;

endmodule