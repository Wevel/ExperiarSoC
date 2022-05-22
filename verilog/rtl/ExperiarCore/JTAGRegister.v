module JTAGRegister #(
		parameter WIDTH = 8
	)(
		input wire clk,
		input wire rst,

		input wire loadEnable,
		input wire shiftEnable,

		input  wire[WIDTH-1:0] parallelIn,
		output wire[WIDTH-1:0] parallelOut,
		input  wire serialIn,
		output wire serialOut
	);

	reg[WIDTH-1:0] data = {WIDTH{1'b0}};
	wire[WIDTH-1:0] nextData;

	generate
		if (WIDTH == 1) begin
			assign nextData = serialIn;
		end else begin
			assign nextData = { data[WIDTH-2:0], serialIn };
		end
	endgenerate

	always @(posedge clk) begin
		if (rst) data <= {WIDTH{1'b0}};
		else if (loadEnable) data <= parallelIn;
		else if (shiftEnable) data <= nextData;
	end
		
	assign parallelOut = data;
	assign serialOut = data[WIDTH-1];

endmodule