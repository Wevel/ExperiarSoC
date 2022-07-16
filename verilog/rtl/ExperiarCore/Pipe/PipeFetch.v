module PipeFetch #(
	 	parameter PROGRAM_COUNTER_RESET = 32'b0
	)(
		input wire clk,
		input wire rst,

		// Pipe control
		input wire stepPipe,
		input wire pipeStall,
		output reg currentPipeStall,
		input wire[31:0] programCounter,

		// Control
		output wire addressMisaligned,

		// Memory access
		output wire[31:0] fetchAddress,
		output wire fetchEnable
	);

	always @(posedge clk) begin
		if (rst) begin
			currentPipeStall <= 1'b0;
		end else begin
			if (stepPipe) begin
				currentPipeStall <= pipeStall;
			end
		end
	end

	assign addressMisaligned = |programCounter[1:0];

	assign fetchAddress = programCounter;
	assign fetchEnable = stepPipe;

endmodule