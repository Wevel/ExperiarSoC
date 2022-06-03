module CSR_ReadRegister #(
		parameter ADDRESS = 12'h000
	)(
		input wire clk,
		input wire rst,

		// CSR interface
		input wire csrReadEnable,
		input wire[11:0] csrAddress,
		output wire[31:0] csrReadData,
		output wire csrRequestOutput,

		// System interface
		input wire[31:0] value
	);
	
	wire csrEnabled = csrAddress == ADDRESS;
	assign csrReadData = csrEnabled && csrReadEnable ? value : 32'b0;
	assign csrRequestOutput = csrEnabled && csrReadEnable;

endmodule