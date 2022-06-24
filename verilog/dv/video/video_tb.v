// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module video_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;

	wire succesOutput = mprj_io[12];
	wire nextTestOutput = mprj_io[13];
	
	wire[5:0] vgaPixel = mprj_io[35:30];
	wire vgaVSync = mprj_io[36];
	wire vgaHSync = mprj_io[37];

	pullup(mprj_io[3]);
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;

	reg timingValid = 1'b1;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.
	always #12.5 clock <= (clock === 1'b0);

	// Need to add pulls (can be up or down) to all unsed io so that input data is known
	assign mprj_io[2:0] = 3'b0;
	assign mprj_io[11:4] = 8'b0;
	assign mprj_io[29:14] = 16'b0;

	initial begin
		clock = 0;
		timingValid = 1'b1;
	end

	initial begin
		$dumpfile("video.vcd");

`ifdef SIM
		$dumpvars(0, video_tb);
`else
		$dumpvars(1, video_tb);
		$dumpvars(2, video_tb.uut.mprj);
`endif

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (1000) begin
			repeat (1000) @(posedge clock);
			//$display("+1000 cycles");
		end
		$display("%c[1;35m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Peripherals Video Test (GL) Failed");
		`else
			$display ("Monitor: Timeout, Peripherals Video Test (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	realtime timerStart;
	realtime timerLength;

	initial begin
		$timeformat(-6, 3, "us", 8);

		// Wait for tests
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);
		@(posedge nextTestOutput);

		// Test default vga mode
		@(negedge vgaHSync);
		timerStart = $realtime;
		
		// Measure hsync pulse length
		@(posedge vgaHSync);
		timerLength = $realtime - timerStart;
		$display("H Sync pulse period: %t", timerLength);
		if (timerLength < 390 || timerLength > 410) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 0.390us and 0.410us");
		end

		// Measure hsync period
		@(negedge vgaHSync);
		timerLength = $realtime - timerStart;
		$display("H Sync period: %t", timerLength);
		if (timerLength < 3290 || timerLength > 3310) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 3.290us and 3.310us");
		end

		@(negedge vgaVSync);
		timerStart = $realtime;
		
		// Measure hsync pulse length
		@(posedge vgaVSync);
		timerLength = $realtime - timerStart;
		$display("V Sync pulse period: %t", timerLength);
		if (timerLength < 13190 || timerLength > 13210) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 13.190us and 13.210us");
		end

		// Measure vsync period
		@(negedge vgaVSync);
		timerLength = $realtime - timerStart;
		$display("V Sync period: %t", timerLength);
		if (timerLength < 2072390 || timerLength > 2072410) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 2072.390us and 2072.410us");
		end

		// Test tight memory mode
		@(posedge nextTestOutput);

		@(negedge vgaHSync);
		timerStart = $realtime;
		
		// Measure hsync pulse length
		@(posedge vgaHSync);
		timerLength = $realtime - timerStart;
		$display("H Sync pulse period: %t", timerLength);
		if (timerLength < 390 || timerLength > 410) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 0.390us and 0.410us");
		end

		// Measure hsync period
		@(negedge vgaHSync);
		timerLength = $realtime - timerStart;
		$display("H Sync period: %t", timerLength);
		if (timerLength < 3290 || timerLength > 3310) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 3.290us and 3.310us");
		end

		@(negedge vgaVSync);
		timerStart = $realtime;
		
		// Measure hsync pulse length
		@(posedge vgaVSync);
		timerLength = $realtime - timerStart;
		$display("V Sync pulse period: %t", timerLength);
		if (timerLength < 13190 || timerLength > 13210) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 13.190us and 13.210us");
		end

		// Measure vsync period
		@(negedge vgaVSync);
		timerLength = $realtime - timerStart;
		$display("V Sync period: %t", timerLength);
		if (timerLength < 2072390 || timerLength > 2072410) begin
			timingValid = 1'b0;
			$display("Invalid time, should be between 2072.390us and 2072.410us");
		end

		// Wait for test to finish
		@(posedge nextTestOutput);
		
		if (!timingValid) begin
			$display("%c[1;31m",27);
			`ifdef GL
				$display ("Monitor: Video Test VGA Timing (GL) Failed");
			`else
				$display ("Monitor: Video Test VGA Timing (RTL) Failed");
			`endif
			$display("%c[0m",27);
		end else if (succesOutput) begin
			$display("%c[1;92m",27);
			`ifdef GL
				$display("Monitor: Video Test (GL) Passed");
			`else
				$display("Monitor: Video Test (RTL) Passed");
			`endif
			$display("%c[0m",27);
		end else begin
			$display("%c[1;31m",27);
			`ifdef GL
				$display ("Monitor: Video Test (GL) Failed");
			`else
				$display ("Monitor: Video Test (RTL) Failed");
			`endif
			$display("%c[0m",27);
		end
	    $finish;
	end

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#300000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end

	always @(succesOutput, nextTestOutput, timingValid) begin
		#1 $display("Success:0b%b Timing Valid:0b%b Next test:0b%b", succesOutput, timingValid, nextTestOutput);
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("video.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
