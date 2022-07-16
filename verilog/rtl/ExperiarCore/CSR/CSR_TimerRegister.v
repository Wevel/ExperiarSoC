module CSR_TimerRegister #(
		parameter ADDRESS_LOWER = 12'h000,
		parameter ADDRESS_UPPER = 12'h000
	)(
		input wire clk,
		input wire rst,

		// CSR interface
		input wire csrReadEnable,
		input wire[11:0] csrReadAddress,
		output reg[31:0] csrReadData,
		output wire csrRequestOutput,

		// System interface
		input wire count,
		output wire[63:0] value
	);
	
	wire csrReadEnabledLower = csrReadAddress == ADDRESS_LOWER;
	wire csrReadEnabledUpper = csrReadAddress == ADDRESS_UPPER;

	reg[63:0] currentValue = 64'b0;

	always @(posedge clk) begin
		if (rst) begin
			currentValue <= 64'b0;
		end else begin
			if (count) currentValue <= currentValue + 1;
		end
	end

	always @(*) begin
		if (csrReadEnable) begin
			if (csrReadEnabledLower) csrReadData <= currentValue[31:0];
			else if (csrReadEnabledUpper) csrReadData <= currentValue[63:32];
			else csrReadData <= 32'b0;
		end else begin
			csrReadData <= 32'b0;
		end 
	end

	assign csrRequestOutput = (csrReadEnabledLower || csrReadEnabledUpper) && csrReadEnable;
	
	assign value = currentValue;
	
endmodule