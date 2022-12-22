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
	
	reg run = 1'b1;

	// Instruction cache interface
	wire[31:0] instruction_memoryAddress;
	wire instruction_memoryEnable;
	reg[31:0] instruction_memoryDataRead;
	wire instruction_memoryBusy = 1'b0;
	wire instruction_memoryAccessFault = 1'b0;

	// Data cache interface
	wire[31:0] data_memoryAddress;
	wire[3:0] data_memoryByteSelect;
	wire data_memoryEnable;
	wire data_memoryWriteEnable;
	wire[31:0] data_memoryDataWrite;
	reg[31:0] data_memoryDataRead;
	wire data_memoryBusy = 1'b0;
	wire data_memoryAccessFault = 1'b0;

	wire management_run = 1'b1;
	wire management_interruptEnable = 1'b1;
	wire management_writeEnable = 1'b0;
	wire[3:0] management_byteSelect = 4'b0000;
	wire[15:0] management_address = 'b0;
	wire[31:0] management_writeData = 'b0;
	wire[31:0] management_readData;

	wire coreInstructionAddressBreakpoint = 1'b0;
	wire coreDataAddressBreakpoint = 1'b0;
	wire[15:0] userInterrupts = 16'b0;

	wire probe_state;
	wire[1:0] probe_env;
	wire[31:0] probe_programCounter;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.
	always #12.5 clock <= (clock === 1'b0);

	initial begin
		run = 1'b1;
		clock = 0;
	end

	integer fd;
	integer i;

	initial begin
		$display("SIGNATURE_START: 0x%h", 32'h`SIGNATURE_START);
		$display("SIGNATURE_END: 0x%h", 32'h`SIGNATURE_END);
		$display("CODE_END: 0x%h", 32'h`CODE_END);

		wait((probe_programCounter == 32'h`CODE_END));
		
		run = 1'b0;

		$display("%c[1;92m",27);
		`ifdef GL
			$display ("Monitor: Core Arch Test (GL) Completed");
		`else
			$display ("Monitor: Core Arch Test (RTL) Completed");
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

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (20) begin
			repeat (1000) @(posedge clock);
		end
		
		run = 1'b0;

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
		.instruction_memoryAddress(instruction_memoryAddress),
		.instruction_memoryEnable(instruction_memoryEnable),
		.instruction_memoryDataRead(instruction_memoryDataRead),
		.instruction_memoryBusy(instruction_memoryBusy),
		.instruction_memoryAccessFault(instruction_memoryAccessFault),
		.instruction_memoryAddressBreakpoint(coreInstructionAddressBreakpoint),
		.data_memoryAddress(data_memoryAddress),
		.data_memoryByteSelect(data_memoryByteSelect),
		.data_memoryEnable(data_memoryEnable),
		.data_memoryWriteEnable(data_memoryWriteEnable),
		.data_memoryDataWrite(data_memoryDataWrite),
		.data_memoryDataRead(data_memoryDataRead),
		.data_memoryBusy(data_memoryBusy),
		.data_memoryAccessFault(data_memoryAccessFault),
		.data_memoryAddressBreakpoint(coreDataAddressBreakpoint),
		.management_run(management_run),
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
		.userInterrupts(userInterrupts),
		.probe_state(probe_state),
		.probe_env(probe_env),
		.probe_programCounter(probe_programCounter));

	// Emulate SRAM for test
	// 16MiB SRAM
	reg[7:0] memory [0:(16 * 1024 * 1024)-1];

	initial begin
		$dumpfile("coreArch.vcd");

`ifdef SIM
		$dumpvars(0, coreArch_tb);
`else
		$dumpvars(2, coreArch_tb);
`endif

		$display("Reading from coreArch.hex");
		$readmemh("coreArch.hex", memory);
		$display("%s loaded into memory", "coreArch.hex");
		$display("Memory 5 bytes = 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x", memory[0], memory[1], memory[2], memory[3], memory[4]);
	end

	wire instruction_sramEnable = RSTB && ((instruction_memoryAddress[31:24] == 8'h00) || (instruction_memoryAddress[31:24] == 8'h80)) && instruction_memoryEnable;
	wire[23:0] instruction_localAddress = instruction_memoryAddress[23:0];

	always @(posedge clock) begin
		if (!RSTB) begin
			instruction_memoryDataRead <= 32'b0;
		end if (run) begin
			instruction_memoryDataRead <= {
				instruction_sramEnable ? memory[instruction_localAddress + 3] : 8'b0,
				instruction_sramEnable ? memory[instruction_localAddress + 2] : 8'b0,
				instruction_sramEnable ? memory[instruction_localAddress + 1] : 8'b0,
				instruction_sramEnable ? memory[instruction_localAddress] : 8'b0 
			};
		end
	end

	wire data_sramEnable = RSTB && ((data_memoryAddress[31:24] == 8'h00) || (data_memoryAddress[31:24] == 8'h80)) && data_memoryEnable;
	wire[23:0] data_localAddress = data_memoryAddress[23:0];

	always @(posedge clock) begin
		if (!RSTB) begin
			data_memoryDataRead <= 32'b0;
		end if (run) begin
			if (data_sramEnable && data_memoryWriteEnable) begin
				if (data_memoryByteSelect[0]) memory[data_localAddress] <= data_memoryDataWrite[7:0];
				if (data_memoryByteSelect[1]) memory[data_localAddress + 1] <= data_memoryDataWrite[15:8];
				if (data_memoryByteSelect[2]) memory[data_localAddress + 2] <= data_memoryDataWrite[23:16];
				if (data_memoryByteSelect[3]) memory[data_localAddress + 3] <= data_memoryDataWrite[31:24];
				$display("Write of 0x%h to 0x%h", data_memoryDataWrite, data_localAddress);
			end

			if (data_sramEnable && !data_memoryWriteEnable) begin
				data_memoryDataRead <= {
					data_memoryByteSelect[3] ? memory[data_localAddress + 3] : 8'b0,
					data_memoryByteSelect[2] ? memory[data_localAddress + 2] : 8'b0,
					data_memoryByteSelect[1] ? memory[data_localAddress + 1] : 8'b0,
					data_memoryByteSelect[0] ? memory[data_localAddress] 	 : 8'b0 
				};
			end else begin
				data_memoryDataRead <= 32'b0;
			end
		end
	end

endmodule
`default_nettype wire
