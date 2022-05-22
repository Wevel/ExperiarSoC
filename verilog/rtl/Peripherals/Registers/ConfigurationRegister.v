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
		input wire[3:0] peripheralBus_byteSelect,
		output wire[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,

		output wire[WIDTH-1:0] currentValue
	);
	
	wire[31:0] dataMask = {
		peripheralBus_byteSelect[3] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[2] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[1] ? 8'hFF : 8'h00,
		peripheralBus_byteSelect[0] ? 8'hFF : 8'h00
	};

	reg[WIDTH-1:0] registerValue;
	wire[31:0] maskedWriteData = (peripheralBus_dataWrite & dataMask) | (registerValue & ~dataMask);

	wire registerSelect = enable && ({ peripheralBus_address[11:2], 2'b00 } == ADDRESS);
	wire we = registerSelect && peripheralBus_we && !peripheralBus_oe;
	wire oe = registerSelect && peripheralBus_oe && !peripheralBus_we;

	always @(posedge clk) begin
		if (rst) begin
			registerValue <= DEFAULT;
		end else begin
			if (we) registerValue <= maskedWriteData[WIDTH-1:0];
		end
	end

	wire[31:0] baseReadData;
	generate
		if (WIDTH == 32) begin
			assign baseReadData = registerValue;
		end else begin
			wire[32-WIDTH-1:0] zeroPadding = 'b0;
			assign baseReadData = { zeroPadding, registerValue };
		end
	endgenerate

	assign peripheralBus_dataRead = oe ? baseReadData & dataMask : 32'b0;
	assign requestOutput = oe;
	assign currentValue = registerValue;

endmodule