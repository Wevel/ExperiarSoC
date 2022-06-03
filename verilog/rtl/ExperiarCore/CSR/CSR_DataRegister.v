module CSR_DataRegister #(
		parameter ADDRESS = 12'h000
	)(
		input wire clk,
		input wire rst,

		// CSR interface
		input wire csrWriteEnable,
		input wire csrReadEnable,
		input wire[11:0] csrAddress,
		input wire[31:0] csrWriteData,
		output wire[31:0] csrReadData,
		output wire csrRequestOutput,

		// System interface
		input wire[31:0] readData,
		output wire readDataEnable,
		output wire[31:0] writeData,
		output wire writeDataEnable
	);
	
	wire csrEnabled = csrAddress == ADDRESS;

	assign csrReadData = csrEnabled && csrReadEnable ? readData : 32'b0;
	assign readDataEnable = csrEnabled && csrReadEnable;
	assign writeData = csrWriteData;
	assign writeDataEnable = csrEnabled && csrWriteEnable;

	assign csrRequestOutput = csrEnabled && csrReadEnable;
	
endmodule