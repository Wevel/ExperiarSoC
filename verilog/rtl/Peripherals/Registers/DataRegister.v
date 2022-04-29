module DataRegister #(
		parameter WIDTH = 32,
		parameter ADDRESS = 12'b0
	)(
		input wire clk,
		input wire rst,

		// Peripheral Bus
		input wire enable,
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[11:0] peripheralBus_address,
		inout wire[31:0] peripheralBus_data,

		input wire[WIDTH-1:0] writeData,
		output wire writeData_en,
		input wire writeData_busy,
		output wire[WIDTH-1:0] readData,
		output wire readData_en,
		input wire readData_busy
	);
	
wire registerSelect = enable && (peripheralBus_address == ADDRESS);
wire we = registerSelect && peripheralBus_we && !peripheralBus_oe;
wire oe = registerSelect && peripheralBus_oe && !peripheralBus_we;

assign writeData = we ? peripheralBus_data[WIDTH-1:0] : 'b0;
assign writeData_en = we;

generate
	if (WIDTH == 32) begin
		assign peripheralBus_data = oe ? readData : 32'bz;
	end else begin
		wire[32-WIDTH-1:0] zeroPadding = 'b0;
		assign peripheralBus_data = oe ? { zeroPadding, readData } : 32'bz;
	end
endgenerate

assign readData_en = oe;

assign peripheralBus_busy = registerSelect && ((we && writeData_busy) | (oe && readData_busy));

endmodule