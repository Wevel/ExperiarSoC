module Blink (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire nrst,

		output wire blink
	);

counter #(.WIDTH(1), .DIV(24), .TOP(0)) ctr(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V supply
	.vssd1(vssd1),	// User area 1 digital ground
`endif
	.clk(clk),
	.rst(!nrst),
	.halt(1'b0),
	.value(blink));
	
endmodule