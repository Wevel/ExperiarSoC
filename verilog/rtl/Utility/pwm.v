// /******************************************************************************

//    The MIT License (MIT)

//    Copyright (c) 2019 Alchitry

//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:

//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.

//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

//    *****************************************************************************

//    PWM: This module can be used to produce a PWM
//    (pulse width modulated) output. That means it
//    will output a continuous chain of pulses whose
//    duty cycle (percent of time high) is
//    proportional to the input value.
   
//    When you want to set the PWM value, pull update
//    high. The input value will then be saved and
//    applied on the next pulse. This way you will
//    not get glitches due to updates in the middle
//    of a cycle. This is important when working
//    with servos since they will see these glitches
//    and twitch.
   
//    You can set WIDTH to the resolution you need.
   
//    If you need a specific period (i.e. for servos),
//    you can use DIV to divide the clock in powers
//    of 2 and TOP to set the max value.
   
//    If TOP is 0, 2^WIDTH is used for TOP.
   
//    Note that if WIDTH isn't big enough to store the
//    TOP value, TOP will never be reached and 2^WIDTH
//    will be used instead.
   
//    The duty cycle is: TOP / value
//    The period is: TOP / (CLK_FREQ / 2^DIV)
   
//    For a servo, you typically want a frequency of
//    50Hz, or a period of 0.02 seconds. With a
//    clock frequency of 50MHz, you should use
//    TOP = 244, DIV = 12, and WIDTH = 8. If you
//    want more resolution you can use
//    TOP = 62500, DIV = 4, and WIDTH = 16.
// */

// module pwm (
//     input clk,          // clock
//     input rst,          // reset
//     input value[WIDTH], // duty cycle value
//     input update,       // new value flag
//     output pulse        // PWM output
//   ){
  
//   .clk(clk) {
//     .rst(rst) {
//       counter ctr(#SIZE(WIDTH), #DIV(DIV), #TOP(TOP));
//       dff curValue[WIDTH];
//       dff needUpdate;
//     }
//     // nextValue doesn't need reset
//     dff nextValue[WIDTH];
//   }
  
//   always {
//     // if ctr.value is 0 and we need to update
//     if (!|ctr.value && needUpdate.q) {
//       curValue.d = nextValue.q; // set our new value
//       needUpdate.d = 0;         // don't need update now
//     }
    
//     // if value is valid
//     if (update) {
//       nextValue.d = value; // save it
//       needUpdate.d = 1;    // flag for update
//     }
    
//     // if the counter is less than the set 
//     // value output 1, otherwise output 0
//     pulse = ctr.value < curValue.q;
//   }
// }
module pwm #(
 		parameter WIDTH = 8, 	// resolution of PWM counter
 		parameter DIV = 16,   	// clock pre-scaler
 		parameter TOP = 0  		// max value of counter
 	)(
		input clk,
		input rst,
		input [WIDTH-1:0] compareValue,
		output pwm
	);

	wire [WIDTH-1:0] counterValue;
	counter #(.WIDTH(WIDTH), .DIV(DIV), .TOP(TOP)) ctr(.clk(clk), .rst(rst), .halt(1'b0), .value(counterValue));

	reg [WIDTH-1:0] currentCompareValue;
	assign pwm = counterValue < currentCompareValue;

	always @(posedge clk) begin
		if (counterValue == 0) currentCompareValue = compareValue;
	end
  
endmodule
