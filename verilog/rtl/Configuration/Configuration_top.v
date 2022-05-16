module Configuration (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire clk, // Not acutally needed for anything, except to keep openlane happy

		output wire[7:0] core0Index,
		output wire[7:0] core1Index,

		output wire[10:0] manufacturerID,
		output wire[15:0] partID,
		output wire[3:0] versionID
	);
	
	assign core0Index = 8'h00;
	assign core1Index = 8'h01;

	assign manufacturerID = 11'h000;
	assign partID = 16'hCD55;
	assign versionID = 4'h0;

endmodule