module PWMOutput #(
		parameter WIDTH = 16
	)(
		input wire clk,
		input wire rst,
		
		input wire[WIDTH-1:0] compareValue,
		input wire enable,

		input wire[WIDTH-1:0] counterValue,
		output wire pwm_out
	);

	reg [WIDTH-1:0] currentCompareValue;
	reg state = 1'b0;	

	always @(posedge clk) begin
		if (rst) begin
			currentCompareValue <= 'b0;
			state <= 1'b0; 
		end else begin
			if (!enable || counterValue == 0) begin
				state <= 1'b0;
				currentCompareValue <= compareValue;
			end	else if (counterValue == currentCompareValue) begin
				state <= 1'b1;
			end
		end
	end
	
	assign pwm_out = state;

endmodule