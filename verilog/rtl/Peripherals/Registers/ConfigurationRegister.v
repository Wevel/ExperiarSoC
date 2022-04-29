module ConfigurationRegister #(
		parameter WIDTH = 32,
		parameter ADDRESS = 12'b0,
		parameter DEFAULT = 32'b0
	)(
		input wire clk,
		input wire rst,

		// Peripheral Bus
		input wire enable,
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		input wire[11:0] peripheralBus_address,
		inout wire[31:0] peripheralBus_data,

		output wire[WIDTH-1:0] currentValue
	);
	
reg[WIDTH-1:0] registerValue;

wire registerSelect = enable && (peripheralBus_address == ADDRESS);
wire we = registerSelect && peripheralBus_we && !peripheralBus_oe;
wire oe = registerSelect && peripheralBus_oe && !peripheralBus_we;

always @(posedge clk) begin
	if (rst) begin
		registerValue <= DEFAULT;
	end else begin
		if (we) registerValue <= peripheralBus_data[WIDTH-1:0];
	end
end

generate
	if (WIDTH == 32) begin
		assign peripheralBus_data = oe ? registerValue : 32'bz;
	end else begin
		wire[32-WIDTH-1:0] zeroPadding = 'b0;
		assign peripheralBus_data = oe ? { zeroPadding, registerValue } : 32'bz;
	end
endgenerate

assign currentValue = registerValue;

endmodule