module CSR_ConfigurationRegister #(
		parameter ADDRESS = 12'h000,
		parameter DEFAULT = 32'b0
	)(
		input wire clk,
		input wire rst,

		// CSR interface
		input wire csrWriteEnable,
		input wire csrReadEnable,
		input wire[11:0] csrAddress,
		input wire[31:0] csrWriteData,
		output reg[31:0] csrReadData,
		output wire csrRequestOutput,

		// System interface
		output wire[31:0] value
	);
	
	wire csrEnabled = csrAddress == ADDRESS;

	reg[31:0] currentValue = DEFAULT;

	always @(posedge clk) begin
		if (rst) begin
			currentValue <= DEFAULT;
		end else begin
			if (csrEnabled && csrWriteEnable) currentValue <= csrWriteData;
		end
	end

	assign csrReadData = csrEnabled && csrReadEnable ? currentValue : 32'b0;
	assign csrRequestOutput = csrEnabled && csrReadEnable;

	assign value = currentValue;
	
endmodule