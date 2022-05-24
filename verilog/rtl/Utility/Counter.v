module Counter #(
		parameter WIDTH = 8, 	// Width of the output
		parameter DIV = 0, 		// number of bits to use as divisor
		parameter TOP = 0, 		// max value, 0 = none		
		parameter UP = 1 		// direction to count, use 1 for up and 0 for down
	)(
		input wire clk,
		input wire rst,
		input wire halt,
		output reg [WIDTH-1:0] value
	);
  
	reg [WIDTH + DIV - 1:0] counter = 'b0;

	always @(posedge clk) begin		
		if (TOP != 'b0) begin
			if (rst || (counter[WIDTH + DIV - 1:DIV] == TOP)) counter = 'b0;
			else begin
				if (!halt) begin
					if (UP) counter = counter + 1;
					else counter = counter - 1;
				end
			end
		end else begin
			if (rst) begin
				counter = 'b0;
			end else begin
				if (!halt) begin
					if (UP) counter = counter + 1;
					else counter = counter - 1;
				end
			end
		end
		
		value = counter[WIDTH + DIV - 1:DIV];
	end

endmodule
