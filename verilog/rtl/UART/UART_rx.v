(*keep_hierarchy = "yes"*) module UART_rx
	#(
		parameter BAUD = 1000000,
		parameter CLK_FREQ = 100000000
	)(
		input wire clk,
		input wire rst,
		input wire rx,
		output wire [7:0] data_out,
    	output wire dataAvailable
    );

	localparam CLK_PER_BIT = (CLK_FREQ + BAUD) / BAUD - 1; // clock cycles per bit
  	localparam CTR_SIZE = $clog2(CLK_PER_BIT); // bits required to store CLK_PER_BIT - 1
	
	localparam STATE_IDLE		= 2'b00;
	localparam STATE_WAIT_HALF 	= 2'b01;
	localparam STATE_WAIT_FULL 	= 2'b10;
	localparam STATE_WAIT_HIGH 	= 2'b11;

	reg [1:0] state = STATE_IDLE;
	reg [CTR_SIZE-1:0] delayCounter = 'b0;
	reg [2:0] bitCounter = 3'b0;
	reg [7:0] savedData = 8'b0;
	reg newData = 1'b0;

	always @(posedge clk) begin
		if (rst) begin
			state = STATE_IDLE;
			delayCounter = 'b0;
			bitCounter = 3'b0;
			savedData = 8'b0;
			newData = 1'b0;
		end else begin
			newData = 1'b0;

			 /* When a new byte is being received, the input goes low. This is the
				start bit. When the beginning of this bit is detected we need to wait
				one and a half bit widths before reading in the first data bit. The
				half cycle is so that we read in the middle of the bit for the most
				accurate result. WAIT_HALF waits this half cycle and WAIT_FULL waits
				a full cycle then reads in a bit. After 8 bits are read, the data is
				output and the FSM waits for the RX input to go high again to signal
				the end of the transmission. The FSM then returns to IDLE ready to
				receive the next byte.                                               */
			case (state)
				STATE_IDLE: begin
					bitCounter = 3'b0;
					delayCounter = 'b0;
					if (!rx) state = STATE_WAIT_HALF;
				end

				STATE_WAIT_HALF: begin
					if (delayCounter == (CLK_PER_BIT >> 1)) begin						
						delayCounter = 0;
						state = STATE_WAIT_FULL;
					end else begin
						delayCounter = delayCounter + 1;
					end
				end

				STATE_WAIT_FULL: begin
					if (delayCounter == CLK_PER_BIT - 1) begin
						savedData = {rx, savedData[7:1]};
						delayCounter = 0;
						if (bitCounter == 7) begin
							state = STATE_WAIT_HIGH;
							newData = 1'b1;
						end else bitCounter = bitCounter + 1;
					end else begin
						delayCounter = delayCounter + 1;
					end
				end

				STATE_WAIT_HIGH: begin
					 if (rx) state = STATE_IDLE;
				end

				default: state = STATE_IDLE;				
			endcase
		end
	end

	assign data_out = savedData;
	assign dataAvailable = newData;
endmodule
