module PipeStage (
		input wire clk,
		input wire rst,

		// Pipe control
		input wire stepPipe,
		input wire pipeStall,
		output reg currentPipeStall,
		output wire active,
		input wire[31:0] currentInstruction,
		output reg[31:0] lastInstruction
	);

	always @(posedge clk) begin
		if (rst) begin
			currentPipeStall <= 1'b1;
			lastInstruction <= 32'b0;
		end else begin
			if (stepPipe) begin
				currentPipeStall <= pipeStall;
				if (!pipeStall) lastInstruction <= currentInstruction;
			end
		end
	end

	assign active = !currentPipeStall;
	
endmodule