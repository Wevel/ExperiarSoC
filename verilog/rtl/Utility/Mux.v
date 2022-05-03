module Mux #(
		WIDTH = 1,
		INPUTS = 2
	)(
		input wire[INPUTS-1:0] select,
		input wire[(WIDTH*INPUTS)-1:0] in,
		output reg[WIDTH-1:0] out,
		output wire outputEnable,
	);
	
	integer i;
	always @(*) begin
		for (i = 0; i < INPUTS; i = i + 1) begin
			if (select[i]) out <= in[(i * WIDTH) + WIDTH - 1:i * WIDTH];
		end
	end

	assign outputEnable = |select;

endmodule