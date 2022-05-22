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
		input wire[3:0] peripheralBus_byteSelect,
		output wire[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,

		output wire[WIDTH-1:0] writeData,
		output wire writeData_en,
		input wire writeData_busy,
		input wire[WIDTH-1:0] readData,
		output wire readData_en,
		input wire readData_busy
	);
	
	wire[31:0] dataMask = {
		peripheralBus_byteSelect[3] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[2] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[1] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[0] ? 8'hFF : 8'h00
	};

	wire registerSelect = enable && ({ peripheralBus_address[11:2], 2'b00 } == ADDRESS);
	wire we = registerSelect && peripheralBus_we && !peripheralBus_oe;
	wire oe = registerSelect && peripheralBus_oe && !peripheralBus_we;

	assign writeData = we ? peripheralBus_dataWrite[WIDTH-1:0] : {WIDTH{1'b0}};
	assign writeData_en = we;

	wire[31:0] baseReadData;
	generate
		if (WIDTH == 32) begin
			assign baseReadData = readData;
		end else begin
			wire[32-WIDTH-1:0] zeroPadding = 'b0;
			assign baseReadData = { zeroPadding, readData };
		end
	endgenerate

	assign peripheralBus_dataRead = oe ? baseReadData & dataMask : 32'b0;
	assign peripheralBus_busy = registerSelect && ((we && writeData_busy) | (oe && readData_busy));
	assign requestOutput = oe;
	assign readData_en = oe;

endmodule