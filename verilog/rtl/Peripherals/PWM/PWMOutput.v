module PWMOutput #(
		parameter WIDTH = 16
	)(
		input wire clk,
		input wire rst,
		
		input wire[WIDTH-1:0] compareValue,
		input wire enable,

		input wire[WIDTH-1:0] counterValue,
		output wire pwm_out,
		
		output reg compareRise,
		output reg compareFall
	);

	reg [WIDTH-1:0] currentCompareValue = {WIDTH{1'b0}};
	wire equality = counterValue == currentCompareValue;

	reg state = 1'b0;

	always @(posedge clk) begin
		if (rst) begin
			currentCompareValue <= {WIDTH{1'b0}};
			state <= 1'b0;
		end else begin
			if (enable) begin
				if (counterValue == 0) begin
					state <= 1'b0;
					currentCompareValue <= compareValue;
				end	else if (equality) begin
					state <= 1'b1;
				end
			end else begin
				state <= 1'b0;
				currentCompareValue <= compareValue;
			end
		end
	end

	reg lastState = 1'b0;
	always @(posedge clk) begin
		if (rst) begin
			lastState <= 1'b0;
			compareRise <= 1'b0;
			compareFall <= 1'b0;
		end	else begin 
			lastState <= state;

			if (state != state) begin
				compareRise <= state;
				compareFall <= !state;
			end else begin
				compareRise <= 1'b0;
				compareFall <= 1'b0;
			end
		end
	end
	
	assign pwm_out = state;

endmodule