module ShiftRegister #(
		parameter WIDTH = 8
	)(
		input wire clk,
		input wire rst,

		input wire loadEnable,
		input wire shiftInEnable,
		input wire shiftOutEnable,
		input wire msbFirst,

		input  wire[WIDTH-1:0] parallelIn,
		output wire[WIDTH-1:0] parallelOut,
		input  wire serialIn,
		output wire serialOut
	);

	reg[WIDTH-1:0] data;
	reg outputBit = 1'b0;
	wire[WIDTH-1:0] nextData;

	generate
		if (WIDTH == 1) begin
			assign nextData = serialIn;
		end else begin
			assign nextData = msbFirst ? { data[WIDTH-2:0], serialIn } : { serialIn, data[WIDTH-1:1] };
		end
	endgenerate
	

	always @(posedge clk) begin
		if (rst) begin
			data <= {WIDTH{1'b0}};
			outputBit <= 1'b0;
		end else if (loadEnable) begin
			data <= parallelIn;
			outputBit <= msbFirst ? parallelIn[WIDTH-1] : parallelIn[0];
		end	else if (shiftInEnable) begin
			data <= nextData;
			if (shiftOutEnable) outputBit <= msbFirst ? nextData[WIDTH-1] : nextData[0];
		end else if (shiftOutEnable) outputBit <= msbFirst ? data[WIDTH-1] : data[0];

	end
		
	assign parallelOut = data;
	assign serialOut = outputBit;

endmodule