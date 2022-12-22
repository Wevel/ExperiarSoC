module PipeFetch #(
	 	parameter PROGRAM_COUNTER_RESET = 32'b0
	)(
		input wire clk,
		input wire rst,

		// Pipe control
		input wire stepPipe,
		input wire pipeStall,
		output reg currentPipeStall,
		output wire active,
		input wire[31:0] currentInstruction,
		output reg[31:0] lastInstruction,

		// Control
		input wire[31:0] programCounter,
		output reg[31:0] lastProgramCounter,
		output wire addressMisaligned,		

		// Memory access
		output wire[31:0] fetchAddress,
		output wire fetchEnable
	);

	// Pipe control
	always @(posedge clk) begin
		if (rst) begin
			currentPipeStall <= 1'b1;
			lastInstruction <= 32'b0;
		end else begin
			if (stepPipe) begin
				currentPipeStall <= pipeStall;
				if (!currentPipeStall) lastInstruction <= currentInstruction;
			end
		end
	end

	assign active = !currentPipeStall;

	always @(posedge clk) begin
		if (rst) lastProgramCounter <= 32'b0;
		else lastProgramCounter <= programCounter;
	end

	assign addressMisaligned = |programCounter[1:0];

	assign fetchAddress = programCounter;
	assign fetchEnable = stepPipe;

endmodule