module CSR (
		input wire clk,
		input wire rst,

		// CSR interface
		input wire csrWriteEnable,
		input wire csrReadEnable,
		input wire[11:0] csrWriteAddress,
		input wire[11:0] csrReadAddress,
		input wire[31:0] csrWriteData,
		output reg[31:0] csrReadData,

		// System interface
		input wire[7:0] coreIndex,
		input wire[10:0] manufacturerID,
		input wire[15:0] partID,
		input wire[3:0] versionID,
		input wire[25:0] extensions,
		input wire instructionCompleted,

		// System trap interface
		input wire[31:0] programCounter,
		input wire[31:0] currentInstruction,
		input wire[31:0] instruction_memoryAddress,
		input wire[31:0] data_memoryAddress,
		input wire isMachineTimerInterrupt,
		input wire isMachineExternalInterrupt,
		input wire isMachineSoftwareInterrupt,
		input wire isFetchAddressMisaligned,
		input wire isDataAddressMisaligned_load,
		input wire isDataAddressMisaligned_store,
		input wire isJumpMissaligned,
		input wire isFetchAccessFault,
		input wire isDataAccessFault_load,
		input wire isDataAccessFault_store,
		input wire isInvalidInstruction,
		input wire isEBREAK,
		input wire isECALL,
		input wire isFetchAddressBreakpoint,
		input wire isDataAddressBreakpoint,
		input wire[15:0] userInterrupts,
		input wire trapReturn,
		output wire inTrap,
		output wire[31:0] trapVector,
		output wire[31:0] trapReturnVector
	);

	// Cylce
	wire[63:0] cycleCount;
	wire[31:0] cycleTimerReadData;
	wire cycleTimerRequestOutput;
	CSR_TimerRegister #(.ADDRESS_LOWER(12'hC00), .ADDRESS_UPPER(12'hC80)) cycleTimer (
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(cycleTimerReadData),
		.csrRequestOutput(cycleTimerRequestOutput),
		.count(1'b1),
		.value(cycleCount));

	// Time
	// Time register is duplicate of cycle register
	wire[31:0] timeTimerReadDataLower;
	wire timeTimerRequestOutputLower;
	CSR_ReadRegister #(.ADDRESS(12'hC01)) timeTimerLower(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(timeTimerReadDataLower),
		.csrRequestOutput(timeTimerRequestOutputLower),
		.value(cycleCount[31:0]));

	wire[31:0] timeTimerReadDataUpper;
	wire timeTimerRequestOutputUpper;
	CSR_ReadRegister #(.ADDRESS(12'hC81)) timeTimerUpper(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(timeTimerReadDataUpper),
		.csrRequestOutput(timeTimerRequestOutputUpper),
		.value(cycleCount[63:32]));

	// Instret
	wire[31:0] instretTimerReadData;
	wire instretTimerRequestOutput;
	CSR_TimerRegister #(.ADDRESS_LOWER(12'hC02), .ADDRESS_UPPER(12'hC82)) instretTimer (
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(instretTimerReadData),
		.csrRequestOutput(instretTimerRequestOutput),
		.count(instructionCompleted));

	// Vendor ID
	wire[31:0] vendorIDReadData;
	wire vendorIDRequestOutput;
	CSR_ReadRegister #(.ADDRESS(12'hF11)) vendorID(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(vendorIDReadData),
		.csrRequestOutput(vendorIDRequestOutput),
		.value({ 21'b0, manufacturerID }));

	// Architecture ID
	wire[31:0] archIDReadData;
	wire archIDRequestOutput;
	CSR_ReadRegister #(.ADDRESS(12'hF12)) archID(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(archIDReadData),
		.csrRequestOutput(archIDRequestOutput),
		.value({ 16'b0, partID }));

	// Implementation ID
	wire[31:0] implIDReadData;
	wire implIDRequestOutput;
	CSR_ReadRegister #(.ADDRESS(12'hF13)) implID(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(implIDReadData),
		.csrRequestOutput(implIDRequestOutput),
		.value({ 28'b0, versionID }));

	// Hardware thread ID
	wire[31:0] coreIDReadData;
	wire coreIDRequestOutput;
	CSR_ReadRegister #(.ADDRESS(12'hF14)) coreID(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(coreIDReadData),
		.csrRequestOutput(coreIDRequestOutput),
		.value({ 24'b0, coreIndex }));

	// Pointer to configuration data structure
	wire[31:0] configPointerReadData;
	wire configPointerRequestOutput;
	wire[31:0] configPointerValue_nc;
	CSR_ConfigurationRegister #(.ADDRESS(12'hF15)) mconfigptr(
		.clk(clk),
		.rst(rst),
		.csrWriteEnable(csrWriteEnable),
		.csrReadEnable(csrReadEnable),
		.csrWriteAddress(csrWriteAddress),
		.csrReadAddress(csrReadAddress),
		.csrWriteData(csrWriteData),
		.csrReadData(configPointerReadData),
		.csrRequestOutput(configPointerRequestOutput),
		.value(configPointerValue_nc));

	// ISA
	wire[31:0] misaReadData;
	wire misaRequestOutput;
	CSR_ReadRegister #(.ADDRESS(12'h301)) misa(
		.clk(clk),
		.rst(rst),
		.csrReadEnable(csrReadEnable),
		.csrReadAddress(csrReadAddress),
		.csrReadData(misaReadData),
		.csrRequestOutput(misaRequestOutput),
		.value({ 2'b01, 4'b0, extensions }));

	// Trap handling
	wire[31:0] trapsReadData;
	wire trapsRequestOutput;
	Traps traps(
		.clk(clk),
		.rst(rst),
		.csrWriteEnable(csrWriteEnable),
		.csrReadEnable(csrReadEnable),
		.csrWriteAddress(csrWriteAddress),
		.csrReadAddress(csrReadAddress),
		.csrWriteData(csrWriteData),
		.csrReadData(trapsReadData),
		.requestOutput(trapsRequestOutput),
		.programCounter(programCounter),
		.currentInstruction(currentInstruction),
		.instruction_memoryAddress(instruction_memoryAddress),
		.data_memoryAddress(data_memoryAddress),
		.isMachineTimerInterrupt(isMachineTimerInterrupt),
		.isMachineExternalInterrupt(isMachineExternalInterrupt),
		.isMachineSoftwareInterrupt(isMachineSoftwareInterrupt),
		.isFetchAddressMisaligned(isFetchAddressMisaligned),
		.isDataAddressMisaligned_load(isDataAddressMisaligned_load),
		.isDataAddressMisaligned_store(isDataAddressMisaligned_store),
		.isJumpMissaligned(isJumpMissaligned),
		.isFetchAccessFault(isFetchAccessFault),
		.isDataAccessFault_load(isDataAccessFault_load),
		.isDataAccessFault_store(isDataAccessFault_store),
		.isInvalidInstruction(isInvalidInstruction),
		.isEBREAK(isEBREAK),
		.isECALL(isECALL),
		.isFetchAddressBreakpoint(isFetchAddressBreakpoint),
		.isDataAddressBreakpoint(isDataAddressBreakpoint),
		.userInterrupts(userInterrupts),
		.trapReturn(trapReturn),
		.inTrap(inTrap),
		.trapVector(trapVector),
		.trapReturnVector(trapReturnVector));

	always @(*) begin
		case (1'b1)
			// Timers
			cycleTimerRequestOutput: csrReadData <= cycleTimerReadData;
			timeTimerRequestOutputLower: csrReadData <= timeTimerReadDataLower;
			timeTimerRequestOutputUpper: csrReadData <= timeTimerReadDataUpper;
			instretTimerRequestOutput: csrReadData <= instretTimerReadData;
			
			// Machine info
			vendorIDRequestOutput: csrReadData <= vendorIDReadData;
			archIDRequestOutput: csrReadData <= archIDReadData;
			implIDRequestOutput: csrReadData <= implIDReadData;
			coreIDRequestOutput: csrReadData <= coreIDReadData;
			configPointerRequestOutput: csrReadData <= configPointerReadData;
			misaRequestOutput: csrReadData <= misaReadData;

			// Traps
			trapsRequestOutput: csrReadData <= trapsReadData;

			default: csrReadData <= 32'b0;
		endcase
	end

endmodule