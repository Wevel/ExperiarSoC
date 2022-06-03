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

module coreArch_tb;
	reg clock;
	reg RSTB;
	reg power1, power2;
	reg power3, power4;

	wire[31:0] memoryAddress;
	wire[3:0] memoryByteSelect;
	wire memoryWriteEnable;
	wire memoryReadEnable;
	wire[31:0] memoryDataWrite;
	wire[31:0] memoryDataRead;
	wire memoryBusy = 1'b0;
	wire memoryAccessFault = 1'b0;
	
	wire management_run = 1'b1;
	wire management_trapEnable = 1'b1;
	wire management_interruptEnable = 1'b1;
	wire management_writeEnable = 1'b0;
	wire[3:0] management_byteSelect = 4'b0000;
	wire[15:0] management_address = 'b0;
	wire[31:0] management_writeData = 'b0;
	wire[31:0] management_readData;

	wire isAddressBreakpoint = 1'b0;
	wire[15:0] userInterrupts = 16'b0;

	wire[1:0] probe_state;
	wire[1:0] probe_env;
	wire[31:0] probe_programCounter;
	wire[6:0] probe_opcode;
	wire[1:0] probe_errorCode;
	wire probe_isBranch;
	wire probe_takeBranch;
	wire probe_isStore;
	wire probe_isLoad;
	wire probe_isCompressed;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.
	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	integer fd;
	integer i;

	initial begin
		$display("SIGNATURE_START: 0x%h", 32'h`SIGNATURE_START);
		$display("SIGNATURE_END: 0x%h", 32'h`SIGNATURE_END);
		$display("CODE_END: 0x%h", 32'h`CODE_END);

		wait((probe_programCounter == 32'h`CODE_END) || (|probe_errorCode));

		#50

		if (|probe_errorCode) begin
			$display("%c[1;31m",27);
			`ifdef GL
				$display ("Monitor: Core Arch Test (GL) Failed");
			`else
				$display ("Monitor: Core Arch Test (RTL) Failed");
			`endif
			$display("%c[0m",27);
		end else begin
			$display("%c[1;92m",27);
			`ifdef GL
				$display ("Monitor: Core Arch Test (GL) Completed");
			`else
				$display ("Monitor: Core Arch Test (RTL) Completed");
			`endif
			$display("%c[0m",27);
		end

		$display("Writing memory dump to memory.hex");

		fd = $fopen("DUT-ExperiarSoC.signature", "w");
		
		for (i = 32'h`SIGNATURE_START; i < 32'h`SIGNATURE_END; i = i + 4) begin
			$fdisplayh(fd, { memory[i + 3], memory[i + 2], memory[i + 1], memory[i + 0] });
		end

		$fclose(fd);

		$finish;
	end

	initial begin
		$dumpfile("coreArch.vcd");

`ifdef SIM
		$dumpvars(0, coreArch_tb);
`else
		$dumpvars(2, coreArch_tb);
`endif

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (20) begin
			repeat (1000) @(posedge clock);
		end
		
		$display("%c[1;35m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Core Arch Test (GL) Failed");
		`else
			$display ("Monitor: Timeout, Core Arch Test (RTL) Failed");
		`endif
		$display("%c[0m",27);

		$display("Writing memory dump to memory.hex");

		fd = $fopen("DUT-ExperiarSoC.signature", "w");
		
		for (i = 32'h`SIGNATURE_START; i < 32'h`SIGNATURE_END; i = i + 4) begin
			$fdisplayh(fd, { memory[i + 3], memory[i + 2], memory[i + 1], memory[i + 0] });
		end

		$fclose(fd);

		$finish;
	end

	initial begin
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1; // Release reset
	end

	initial begin // Power-up sequence
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

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	localparam CORE_EXTENSIONS = 26'b00_0000_0000_0000_0001_0000_0000;

	RV32ICore core(
		.vccd1 (VDD1V8),	// User area 1 1.8V supply
		.vssd1 (VSS),		// User area 1 digital ground
		.clk(clock),
		.rst(!RSTB),
		.memoryAddress(memoryAddress),
		.memoryByteSelect(memoryByteSelect),
		.memoryWriteEnable(memoryWriteEnable),
		.memoryReadEnable(memoryReadEnable),
		.memoryDataWrite(memoryDataWrite),
		.memoryDataRead(memoryDataRead),
		.memoryBusy(memoryBusy),
		.memoryAccessFault(memoryAccessFault),
		.management_run(management_run),
		.management_trapEnable(management_trapEnable),
		.management_interruptEnable(management_interruptEnable),
		.management_writeEnable(management_writeEnable),
		.management_byteSelect(management_byteSelect),
		.management_address(management_address),
		.management_writeData(management_writeData),
		.management_readData(management_readData),
		.coreIndex(8'h00),
		.manufacturerID(11'h000),
		.partID(16'hCD55),
		.versionID(4'h0),
		.extensions(CORE_EXTENSIONS),
		.isAddressBreakpoint(isAddressBreakpoint),
		.userInterrupts(userInterrupts),
		.probe_state(probe_state),
		.probe_env(probe_env),
		.probe_programCounter(probe_programCounter),
		.probe_opcode(probe_opcode),
		.probe_errorCode(probe_errorCode),
		.probe_isBranch(probe_isBranch),
		.probe_takeBranch(probe_takeBranch),
		.probe_isStore(probe_isStore),
		.probe_isLoad(probe_isLoad),
		.probe_isCompressed(probe_isCompressed));

	// Emulate SRAM for test
	// 16MiB SRAM
	reg[7:0] memory [0:(16 * 1024 * 1024)-1];

	initial begin
		$display("Reading from coreArch.hex");
		$readmemh("coreArch.hex", memory);
		$display("%s loaded into memory", "coreArch.hex");
		$display("Memory 5 bytes = 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x", memory[0], memory[1], memory[2], memory[3], memory[4]);
	end

	wire sramEnable = RSTB && ((memoryAddress[31:24] == 8'h00) || (memoryAddress[31:24] == 8'h80));
	wire sramWriteEnable = sramEnable && memoryWriteEnable;
	wire sramReadEnable = sramEnable && memoryReadEnable;
	wire[23:0] localAddress = memoryAddress[23:0];

	always @(posedge clock) begin
		if (sramWriteEnable) begin
			if (memoryByteSelect[0]) memory[localAddress] <= memoryDataWrite[7:0];
			if (memoryByteSelect[1]) memory[localAddress + 1] <= memoryDataWrite[15:8];
			if (memoryByteSelect[2]) memory[localAddress + 2] <= memoryDataWrite[23:16];
			if (memoryByteSelect[3]) memory[localAddress + 3] <= memoryDataWrite[31:24];
			$display("Write of 0x%h to 0x%h", memoryDataWrite, localAddress);
		end
	end

	assign memoryDataRead = {
		memoryByteSelect[3] && sramReadEnable ? memory[localAddress + 3] : 8'b0,
		memoryByteSelect[2] && sramReadEnable ? memory[localAddress + 2] : 8'b0,
		memoryByteSelect[1] && sramReadEnable ? memory[localAddress + 1] : 8'b0,
		memoryByteSelect[0] && sramReadEnable ? memory[localAddress] : 8'b0 
	};

endmodule
`default_nettype wire
