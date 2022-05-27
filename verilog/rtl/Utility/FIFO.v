module FIFO
	#(
		parameter WORD_SIZE = 8,
		parameter BUFFER_SIZE = 256	// If this is not a power of two, the actual buffer size will be the smallest power of two greater than BUFFER_SIZE
	)(
		input wire clk,
		input wire rst,
		input wire [WORD_SIZE-1:0] dataIn,
		input wire we,

		output wire [WORD_SIZE-1:0] dataOut,
		input wire oe,
		
		output wire isData,
		output wire bufferFull,
		output wire dataLost
    );

	localparam ADDRESS_SIZE = $clog2(BUFFER_SIZE);
	localparam DEPTH = 1 << ADDRESS_SIZE;

	reg we_buffered = 1'b0;
	reg oe_buffered = 1'b0;
	reg[WORD_SIZE-1:0] dataIn_buffered = {WORD_SIZE{1'b0}};
	reg[WORD_SIZE-1:0] dataOut_buffered;

	reg[ADDRESS_SIZE-1:0] startPointer = {ADDRESS_SIZE{1'b0}};
	reg[ADDRESS_SIZE-1:0] endPointer = {ADDRESS_SIZE{1'b0}};
	reg[WORD_SIZE-1:0] buffer [0:DEPTH-1];

	wire[ADDRESS_SIZE-1:0] nextStartPointer = startPointer + 1;
	wire[ADDRESS_SIZE-1:0] nextEndPointer = endPointer + 1;

	reg lastWriteLostData = 1'b0;


	always @(posedge clk) begin
		if (rst) begin
			we_buffered <= 1'b0;
			oe_buffered <= 1'b0;
			dataIn_buffered <= {WORD_SIZE{1'b0}};
		end else begin
			we_buffered <= we;
			oe_buffered <= oe;
			dataIn_buffered <= dataIn;
		end
	end

	always @(negedge clk) begin
		if (rst) begin
			startPointer <= {ADDRESS_SIZE{1'b0}};
			endPointer <= {ADDRESS_SIZE{1'b0}};
			lastWriteLostData <= 1'b0;
			dataOut_buffered <= {WORD_SIZE{1'b0}};
		end else begin
			if (oe_buffered) begin
				if (isData) begin
					startPointer <= nextStartPointer;
					dataOut_buffered <= buffer[nextStartPointer];
				end else begin
					dataOut_buffered <= {WORD_SIZE{1'b0}};
				end
			end

			if (we_buffered) begin
				// TODO: Should we allow the buffer to overwrite itself when a write occurs and it is already full
				if (!bufferFull) begin
					buffer[endPointer] <= dataIn_buffered;					
					endPointer <= nextEndPointer;
					lastWriteLostData <= 1'b0;

					if (!isData) dataOut_buffered <= dataIn_buffered;
				end else begin
					lastWriteLostData <= 1'b1;
				end
			end
		end
	end

	assign dataOut = dataOut_buffered;

	assign isData = startPointer != endPointer;
	assign bufferFull = nextEndPointer == startPointer;
	assign dataLost = lastWriteLostData;	

endmodule
