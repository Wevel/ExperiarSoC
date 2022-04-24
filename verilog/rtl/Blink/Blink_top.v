module Blink (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		output wire[1:0] blink
	);

counter #(.WIDTH(2), .DIV(23), .TOP(0)) ctr(.clk(clk), .rst(rst), .halt(1'b0), .value(blink));
	
endmodule