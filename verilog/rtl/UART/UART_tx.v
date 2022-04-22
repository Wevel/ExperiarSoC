(*keep_hierarchy = "yes"*) module UART_tx
	#(
		parameter BAUD = 1000000,
		parameter CLK_FREQ = 100000000
	)(
		input wire clk,
		input wire rst,		
		output wire tx,
		input wire blockTransmition,
    	output reg busy,
    	input wire [7:0] data_in,
    	input wire dataAvailable
    );

  	localparam CLK_PER_BIT = (CLK_FREQ + BAUD) / BAUD - 1; // clock cycles per bit
  	localparam CTR_SIZE = $clog2(CLK_PER_BIT); // bits required to store CLK_PER_BIT - 1
	
	localparam STATE_IDLE		= 2'b00;
	localparam STATE_START_BIT 	= 2'b01;
	localparam STATE_DATA 		= 2'b10;
	localparam STATE_STOP_BIT 	= 2'b11;

	reg [1:0] state = STATE_IDLE;
	reg [CTR_SIZE-1:0] delayCounter = 'b0;
	reg [2:0] bitCounter = 3'b0;
	reg [7:0] savedData = 8'b0;
	reg outputBuffer = 1'b0;

	always @(posedge clk) begin
		if (rst) begin
			state = STATE_IDLE;
			delayCounter = 'b0;
			bitCounter = 3'b0;
			savedData = 8'b0;
			outputBuffer = 1'b0;
		end else begin
			busy = 1'b1;
			
			/*  When a new byte is presnted to send, that byte is saved so that
				if the input changes the correct data is still sent. We first
				have to send a 0, which is the start bit. Once the start bit
				is sent, each data bit is sent out. The counter ctr is used to
				delay between bits to get the correct baud rate. The counter
				bitCounter is used to keep track of what bit to send. After
				all eight bits are sent, we need to send 1, the stop bit.
				This bit ensures that the line goes high between transmissions.
				When the transmistter is sending out data, the output busy is
				set to 1. To prevent the transmitter from sending data, set
				block to 1. This can be used for flow control.                  */
			case (state)
				STATE_IDLE: begin
					outputBuffer = 1'b1; // UART standard is to default to high

					if (!blockTransmition) begin
						busy = 1'b0;
						delayCounter = 'b0;
						bitCounter = 3'b0;

						if (dataAvailable) begin
							savedData = data_in;
							state = STATE_START_BIT;
						end
					end
				end

				STATE_START_BIT: begin
					outputBuffer = 1'b0;

					if (delayCounter == CLK_PER_BIT - 1) begin
						delayCounter = 0;
						state = STATE_DATA;
					end else begin
						delayCounter = delayCounter + 1;
					end
				end

				STATE_DATA: begin
					outputBuffer = savedData[bitCounter];

					if (delayCounter == CLK_PER_BIT - 1) begin
						delayCounter = 0;
						if (bitCounter == 7) state = STATE_STOP_BIT;
						else bitCounter = bitCounter + 1;
					end else begin
						delayCounter = delayCounter + 1;
					end
				end

				STATE_STOP_BIT: begin
					outputBuffer = 1'b1;

					if (delayCounter == CLK_PER_BIT - 1) begin
						state = STATE_IDLE;
					end else begin
						delayCounter = delayCounter + 1;
					end
				end
				
				default: state = STATE_IDLE;				
			endcase
		end
	end

	assign tx = outputBuffer;

endmodule
