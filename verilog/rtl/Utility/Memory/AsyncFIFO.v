/******************************************************************************
   
   The MIT License (MIT)
   
   Copyright (c) 2019 Alchitry
   
   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:
   
   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.
   
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
   
   *****************************************************************************
   
   This is an asynchronous fifo. That means it has two independently clocked
   interfaces that allow you to write data from one clock domain and read
   it from another.
   
   This is a first-word-fall-through fifo meaning that dout is valid whenever
   empty is 0. If you want to perform a read, simply check if empty is 0 and
   if it is read the value of dout and set rget high to advance to the next
   value.
*/

module AsyncFIFO 
	#(
		parameter SIZE = 4, 			// Size of the data
		parameter DEPTH = 8 			// DEPTH must be a power of 2
	)(
		input wire wclk, 				// write clock
		input wire wrst, 				// write reset
		input wire [SIZE-1:0] din, 		// write data
		input wire wput, 				// write flag (1 = write)
		output reg full, 				// full flag (1 = full)

		input wire rclk, 				// read clock
		input wire rrst, 				// read reset
		output wire [SIZE-1:0] dout, 	// read data
		input wire rget, 				// data read flag (1 = get next entry)
		output reg empty 				// empty flag (1 = empty)
	);
  
	localparam ADDR_SIZE = $clog2(DEPTH); // size of RAM address

	// write clock domain
	reg [ADDR_SIZE-1:0] waddr;			// write address
	reg [ADDR_SIZE-1:0] wsync [2:0];	// write sync dffs
	reg [ADDR_SIZE-1:0] gwsync;

	// read clock domain
	reg [ADDR_SIZE-1:0] raddr;			// read address
	reg [ADDR_SIZE-1:0] rsync [2:0];	// read sync dffs
	reg [ADDR_SIZE-1:0] grsync;

	// dual port RAM
	reg write_en;
	reg [ADDR_SIZE-1:0] ram_raddr;
	AsyncRAM #(.SIZE(SIZE), .DEPTH(DEPTH)) ram(
		.wclk(wclk),
		.waddr(waddr),
		.write_data(din),
		.write_en(write_en),
		.rclk(rclk),
		.raddr(ram_raddr),
		.read_data(dout));

	reg [ADDR_SIZE-1:0] waddr_gray;	// gray-encoded version of waddr
	reg [ADDR_SIZE-1:0] wnext_gray;	// gray-encoded version of waddr + 1
	reg [ADDR_SIZE-1:0] raddr_gray;	// gray-encoded version of raddr
	reg wrdy, rrdy;					// write and read ready flags

	reg [ADDR_SIZE-1:0] wnext;
	reg [ADDR_SIZE-1:0] read_sync;

	always @(*) begin
		write_en = 0; // default to not writing

		// convert the various values to their gray-encoded versions
		wnext = waddr + 1;

		// This doesn't seem to compile
		// waddr_gray = waddr[ADDR_SIZE-1:1] ^ waddr;
		// wnext_gray = wnext[ADDR_SIZE-1:1] ^ wnext;
		// raddr_gray = raddr[ADDR_SIZE-1:1] ^ raddr;

		// From https://en.wikipedia.org/wiki/Gray_code
		waddr_gray = waddr ^ (waddr >> 1);
		wnext_gray = wnext ^ (wnext >> 1);
		raddr_gray = raddr ^ (raddr >> 1);

		// if next write address isn't the read address we can write
		wrdy = wnext_gray != wsync[2];
		read_sync = wsync[2];

		// if the current read address isn't the write address we can read
		rrdy = raddr_gray != rsync[2];

		// invert ready signals for full and empty
		full = !wrdy;
		empty = !rrdy;

		// connect RAM ports
		ram_raddr = raddr;

		// if we have space and should write
		if (wput && wrdy) begin
			write_en = 1; // set write flag
		end

		// if we have data and a read request
		if (rget && rrdy) begin
			ram_raddr = raddr + 1; // set to next address to keep up with reads
		end
	end

	always @(posedge wclk) begin
		if (wrst) begin
			waddr <= ADDR_SIZE'b0;
			wsync[0] <= ADDR_SIZE'b0;
			wsync[1] <= ADDR_SIZE'b0;
			wsync[2] <= ADDR_SIZE'b0;
			gwsync <= ADDR_SIZE'b0;
		end else begin
			gwsync <= waddr_gray;	

			// cross clock domains with synchronizers
			wsync[0] <= grsync;
			wsync[1] <= wsync[0];
			wsync[2] <= wsync[1];

			// if we have space and should write increment write address
			if (wput && wrdy) waddr <= waddr + 1;
		end
	end

	always @(posedge rclk) begin
		if (rrst) begin
			raddr <= ADDR_SIZE'b0;
			rsync[0] <= ADDR_SIZE'b0;
			rsync[1] <= ADDR_SIZE'b0;
			rsync[2] <= ADDR_SIZE'b0;
			grsync <= ADDR_SIZE'b0;
		end else begin
			grsync <= raddr_gray;

			// cross clock domains with synchronizers
			rsync[0] <= gwsync;
			rsync[1] <= rsync[0];
			rsync[2] <= rsync[1];

			// if we have data and a read request increment read address
			if (rget && rrdy) raddr <= raddr + 1;
		end
	end

endmodule