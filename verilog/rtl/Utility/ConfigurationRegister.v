module ConfigurationRegister #(
		parameter WIDTH = 32,
		parameter ADDRESS = 32'b0
	)(
		input wire clk,
		input wire rst,

		// RW interface
		input wire we,
		input wire oe,
		input wire[31:0] interfaceAddress,
		inout wire[31:0] interfaceData,

		output wire[WIDTH-1:0] currentValue
	);
	
reg[WIDTH-1:0] registerValue;

wire registerSelect = interfaceAddress == ADDRESS;

always @(posedge clk) begin
	if (rst) begin
		registerValue <= 'b0;
	end else begin
		if (registerSelect && we && !oe) registerValue <= WIDTH'(interfaceData);
	end
end

assign interfaceData = registerSelect && oe && !we ? 32'(registerValue) : 32'bz;
assign currentValue = registerValue;

endmodule