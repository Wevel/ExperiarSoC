module RV32ICore(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		// Instruction cache interface
		output wire[31:0] instruction_memoryAddress,
		output wire instruction_memoryEnable,
		input wire[31:0] instruction_memoryDataRead,
		input wire instruction_memoryBusy,
		input wire instruction_memoryAccessFault,
		input wire instruction_memoryAddressBreakpoint,

		// Data cache interface
		output wire[31:0] data_memoryAddress,
		output wire[3:0] data_memoryByteSelect,
		output wire data_memoryEnable,
		output wire data_memoryWriteEnable,
		output wire[31:0] data_memoryDataWrite,
		input wire[31:0] data_memoryDataRead,
		input wire data_memoryBusy,
		input wire data_memoryAccessFault,
		input wire data_memoryAddressBreakpoint,

		// Management interface
		input wire management_run,
		input wire management_interruptEnable,
		input wire management_writeEnable,
		input wire[3:0] management_byteSelect,
		input wire[15:0] management_address,
		input wire[31:0] management_writeData,
		output wire[31:0] management_readData,

		// System info
		input wire[7:0] coreIndex,
		input wire[10:0] manufacturerID,
		input wire[15:0] partID,
		input wire[3:0] versionID,
		input wire[25:0] extensions,

		// Traps
		input wire[15:0] userInterrupts,

		// Logic probes
		output wire probe_state,
		output wire[1:0] probe_env,
		output wire[31:0] probe_programCounter
    );

	localparam STATE_HALT 	 	= 1'b0;
	localparam STATE_EXECUTE 	= 1'b1;

	//localparam STATE_HALT 	 	= 2'b00;
	//localparam STATE_FETCH   	= 2'b10;
	//localparam STATE_EXECUTE 	= 2'b11;

	// System registers
	reg state = STATE_HALT;
	reg[31:0] fetchProgramCounter = 32'b0;
	reg[31:0] executeProgramCounter = 32'b0;
	reg[31:0] registers [0:31];

	// Management control
	localparam MANAGMENT_ADDRESS_SYSTEM	   = 2'b00;
	localparam MANAGMENT_ADDRESS_REGISTERS = 2'b01;
	localparam MANAGMENT_ADDRESS_CSR 	   = 2'b10;

	wire management_selectProgramCounter      = (management_address[15:14] == MANAGMENT_ADDRESS_SYSTEM) && (management_address[13:4] == 10'h000);
	wire management_selectInstructionRegister = (management_address[15:14] == MANAGMENT_ADDRESS_SYSTEM) && (management_address[13:4] == 10'h001);
	wire management_selectClearError		  = (management_address[15:14] == MANAGMENT_ADDRESS_SYSTEM) && (management_address[13:4] == 10'h002);
	wire management_selectRegister            = (management_address[15:14] == MANAGMENT_ADDRESS_REGISTERS) && (management_address[13:7] == 7'h00);
	wire management_selectCSR 				  = management_address[15:14] == MANAGMENT_ADDRESS_CSR;

	wire management_writeValid = !management_run && management_writeEnable;
	wire management_writeProgramCounter = management_writeValid && management_selectProgramCounter;
	wire management_writeProgramCounter_set = management_writeProgramCounter && (management_address[3:0] == 4'h0);
	wire management_writeProgramCounter_jump = management_writeProgramCounter && (management_address[3:0] == 4'h4);
	wire management_writeProgramCounter_step = management_writeProgramCounter && (management_address[3:0] == 4'h8);
	wire management_writeClearError = management_writeValid && management_selectClearError;
	wire management_writeRegister = management_writeValid && management_selectRegister;
	wire management_writeCSR = management_writeValid && management_selectCSR;

	wire management_readValid = !management_run && !management_writeEnable;
	wire management_readProgramCounter = management_readValid && management_selectProgramCounter;
	wire management_readInstructionRegister = management_readValid && management_selectInstructionRegister;
	wire management_readRegister = management_readValid && management_selectRegister;
	wire management_readCSR = management_readValid && management_selectCSR;

	wire management_allowInstruction = management_run || management_writeProgramCounter_step;

	wire[4:0] management_registerIndex = management_address[6:2];
	wire[11:0] management_csrIndex = management_address[13:2];
	wire[31:0] management_jumpTarget = executeProgramCounter + management_writeData;

	reg[31:0] management_dataOut;

	wire[31:0] csrReadData;

	always @(*) begin
		case (1'b1)
			management_readProgramCounter: management_dataOut <= executeProgramCounter;
			management_readInstructionRegister : management_dataOut <= pipe1_currentInstruction;
			management_readRegister: management_dataOut <= !management_registerIndex ? registers[management_registerIndex] : 32'b0;
			management_readCSR: management_dataOut <= csrReadData;
			default: management_dataOut <= 32'b0;
		endcase
	end

	assign management_readData = {
		management_byteSelect[3] ? management_dataOut[31:24] : 8'h00,
		management_byteSelect[2] ? management_dataOut[23:16] : 8'h00,
		management_byteSelect[1] ? management_dataOut[15:8]  : 8'h00,
		management_byteSelect[0] ? management_dataOut[7:0]   : 8'h00
	};

	wire[31:0] trapVector;
	wire[31:0] trapReturnVector;
	wire inTrap;

	// ----------Pipe----------
	wire pipe1_shouldStall;
	wire pipe2_shouldStall;
	wire shouldStore;
	wire shouldLoad;

	reg cancelStall;

	wire loadStoreBusy = shouldStore || shouldLoad ? data_memoryBusy : 1'b0;
	wire stepPipe = state == STATE_EXECUTE && !instruction_memoryBusy && !loadStoreBusy;
	wire stallPipe = !management_allowInstruction || pipe1_shouldStall || pipe2_shouldStall;
	wire stallIncrementProgramCounter = !management_allowInstruction || pipe1_shouldStall;

	// 0: Request instruction
	wire pipe0_stall;
	wire pipe0_active;
	wire[31:0] pipe0_currentInstruction;
	wire[31:0] pipe0_programCounter;
	wire pipe0_addressMisaligned;
	wire[31:0] pipe0_instructionFetchAddress;
	wire pipe0_instructionFetchEnable;
	PipeFetch pipe0_fetch (
		.clk(clk),
		.rst(rst),
		.stepPipe(stepPipe),
		.pipeStall(stallPipe),
		.currentPipeStall(pipe0_stall),
		.active(pipe0_active),
		.currentInstruction(instruction_memoryDataRead),
		.lastInstruction(pipe0_currentInstruction),
		.programCounter(fetchProgramCounter),
		.lastProgramCounter(pipe0_programCounter),
		.addressMisaligned(pipe0_addressMisaligned),
		.fetchAddress(pipe0_instructionFetchAddress),
		.fetchEnable(pipe0_instructionFetchEnable));

	// 1: Request data/Write data/ALU operation
	reg[31:0] pipe1_resultRegister;
	reg[31:0] pipe1_csrData;

	wire pipe1_stall;
	wire pipe1_active;
	wire pipe1_invalidInstruction;
	wire[31:0] pipe1_currentInstruction;
	wire[11:0] pipe1_csrReadAddress;
	wire pipe1_csrReadEnable;

	wire[4:0] pipe1_rs1Address;
	wire[4:0] pipe1_rs2Address;
	reg[31:0] pipe1_rs1Data;
	reg[31:0] pipe1_rs2Data;
	wire pipe1_operationResultStoreEnable;
	wire[31:0] pipe1_operationResult;
	wire pipe1_isJump;
	wire pipe1_isFence;
	wire pipe1_jumpEnable;
	wire pipe1_failedBranch;
	wire[31:0] pipe1_nextProgramCounter;
	wire pipe1_jumpMissaligned;
	wire pipe1_addressMisaligned_load;
	wire pipe1_addressMisaligned_store;
	wire pipe1_memoryEnable;
	wire pipe1_memoryWriteEnable;
	wire[3:0] pipe1_memoryByteSelect;
	wire[31:0] pipe1_memoryAddress;
	wire[31:0] pipe1_memoryWriteData;
	wire[31:0] pipe1_fullMemoryAddress;
	wire pipe1_isECALL;
	wire pipe1_isEBREAK;
	wire pipe1_isRET;
	PipeOperation pipe1_operation (
		.clk(clk),
		.rst(rst),
		.stepPipe(stepPipe),
		.pipeStall(pipe0_stall && !cancelStall),
		.currentPipeStall(pipe1_stall),
		.active(pipe1_active),
		.currentInstruction(pipe0_currentInstruction),
		.lastInstruction(pipe1_currentInstruction),
		.invalidInstruction(pipe1_invalidInstruction),
		.csrReadAddress(pipe1_csrReadAddress),
		.csrReadData(csrReadData),
		.csrReadEnable(pipe1_csrReadEnable),
		.programCounter(executeProgramCounter),
		.rs1Address(pipe1_rs1Address),
		.rs1Data(pipe1_rs1Data),
		.rs2Address(pipe1_rs2Address),
		.rs2Data(pipe1_rs2Data),
		.operationResultStoreEnable(pipe1_operationResultStoreEnable),
		.operationResult(pipe1_operationResult),
		.isJump(pipe1_isJump),
		.isFence(pipe1_isFence),
		.jumpEnable(pipe1_jumpEnable),
		.failedBranch(pipe1_failedBranch),
		.nextProgramCounter(pipe1_nextProgramCounter),
		.jumpMissaligned(pipe1_jumpMissaligned),
		.addressMisaligned_load(pipe1_addressMisaligned_load),
		.addressMisaligned_store(pipe1_addressMisaligned_store),
		.memoryEnable(pipe1_memoryEnable),
		.memoryWriteEnable(pipe1_memoryWriteEnable),
		.memoryByteSelect(pipe1_memoryByteSelect),
		.memoryAddress(pipe1_memoryAddress),
		.memoryWriteData(pipe1_memoryWriteData),
		.fullMemoryAddress(pipe1_fullMemoryAddress),
		.isECALL(pipe1_isECALL),
		.isEBREAK(pipe1_isEBREAK),
		.isRET(pipe1_isRET));

	assign pipe1_shouldStall = pipe1_isJump || pipe1_isFence || pipe1_isRET;

	always @(posedge clk) begin
		if (rst) begin
			pipe1_resultRegister <= 32'b0;
			pipe1_csrData <= 32'b0;
			cancelStall <= 1'b0;
		end else begin
			if (state == STATE_EXECUTE) begin
				if (pipe1_operationResultStoreEnable) pipe1_resultRegister <= pipe1_operationResult;
				if (pipe1_csrReadEnable) pipe1_csrData <= csrReadData;
				cancelStall <= pipe1_failedBranch;
			end
		end
	end

	// 3: Store data
	wire pipe2_stall;
	wire pipe2_active;
	wire pipe2_invalidInstruction;
	wire[31:0] pipe2_currentInstruction;
	wire pipe2_expectingLoad;
	wire[4:0] pipe2_rdAddress;
	wire[31:0] pipe2_registerWriteData;
	wire pipe2_registerWriteEnable;
	wire[11:0] pipe2_csrWriteAddress;
	wire[31:0] pipe2_csrWriteData;
	wire pipe2_csrWriteEnable;
	wire pipe2_isJump;
	wire pipe2_isFence;
	wire pipe2_isRET;
	PipeStore pipe2_store (
		.clk(clk),
		.rst(rst),
		.stepPipe(stepPipe),
		.pipeStall(pipe1_stall),
		.currentPipeStall(pipe2_stall),
		.active(pipe2_active),
		.currentInstruction(pipe1_currentInstruction),
		.lastInstruction(pipe2_currentInstruction),
		.invalidInstruction(pipe2_invalidInstruction),
		.expectingLoad(pipe2_expectingLoad),
		.memoryDataRead(data_memoryDataRead),
		.aluResultData(pipe1_resultRegister),
		.csrData(pipe1_csrData),
		.registerWriteAddress(pipe2_rdAddress),
		.registerWriteData(pipe2_registerWriteData),
		.registerWriteEnable(pipe2_registerWriteEnable),
		.csrWriteAddress(pipe2_csrWriteAddress),
		.csrWriteData(pipe2_csrWriteData),
		.csrWriteEnable(pipe2_csrWriteEnable),
		.isJump(pipe2_isJump),
		.isFence(pipe2_isFence),
		.isRET(pipe2_isRET));

	assign pipe2_shouldStall = pipe2_isJump || pipe2_isFence || pipe2_isRET;

	// Integer restister control
	// Check if pipe1 needs the value being written by pipe2
	always @(*) begin
		if (pipe2_registerWriteEnable && pipe2_rdAddress == pipe1_rs1Address) begin
			pipe1_rs1Data <= |pipe1_rs1Address ? pipe2_registerWriteData : 32'b0;
		end else begin
			pipe1_rs1Data <= |pipe1_rs1Address ? registers[pipe1_rs1Address] : 32'b0;
		end

		if (pipe2_registerWriteEnable && pipe2_rdAddress == pipe1_rs2Address) begin
			pipe1_rs2Data <= |pipe1_rs2Address ? pipe2_registerWriteData : 32'b0;
		end else begin
			pipe1_rs2Data <= |pipe1_rs2Address ? registers[pipe1_rs2Address] : 32'b0;
		end
	end

	always @(posedge clk) begin
		if (rst) begin
		end else begin
			if (state == STATE_EXECUTE) begin
				if (pipe2_registerWriteEnable && |pipe2_rdAddress) registers[pipe2_rdAddress] <= pipe2_registerWriteData;
			end
		end
	end

	assign shouldStore = pipe1_memoryEnable && pipe1_memoryWriteEnable;
	assign shouldLoad = (pipe1_memoryEnable && !pipe1_memoryWriteEnable) || pipe2_expectingLoad;

	wire pipeActive = pipe0_active || pipe1_active || pipe2_active;

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_HALT;
			fetchProgramCounter <= 32'b0;
			executeProgramCounter <= 32'b0;
		end else begin
			case (state)
				STATE_HALT: begin
					if (management_allowInstruction) state <= STATE_EXECUTE;
				end

				STATE_EXECUTE: begin
					if (stepPipe) begin
						if (!pipeActive && !management_allowInstruction) state <= STATE_HALT;

						if (inTrap) fetchProgramCounter <= trapVector;
						else if (pipe1_isRET) fetchProgramCounter <= trapReturnVector;
						else if (pipe1_jumpEnable) fetchProgramCounter <= pipe1_nextProgramCounter;
						else if (!stallIncrementProgramCounter) fetchProgramCounter <= fetchProgramCounter + 4;

						executeProgramCounter <= pipe0_programCounter;
					end
				end

				default: state <= STATE_HALT;
			endcase
		end
	end

	// Memory control
	assign instruction_memoryAddress = pipe0_instructionFetchAddress;
	assign instruction_memoryEnable = pipe0_instructionFetchEnable;

	assign data_memoryAddress = pipe1_memoryAddress;
	assign data_memoryByteSelect = pipe1_memoryByteSelect;
	assign data_memoryEnable = pipe1_memoryEnable;
	assign data_memoryWriteEnable = pipe1_memoryWriteEnable;
	assign data_memoryDataWrite = pipe1_memoryWriteData;

	// System commands 
	wire eCall = pipe1_isECALL && (state == STATE_EXECUTE);
	wire eBreak = pipe1_isEBREAK && (state == STATE_EXECUTE);
	wire trapReturn = pipe1_isRET && (state == STATE_EXECUTE);

	wire isMachineTimerInterrupt = 1'b0;
	wire isMachineExternalInterrupt = 1'b0;
	wire isMachineSoftwareInterrupt = 1'b0;

	// CSRs
	// CSR interface
	wire csrWriteEnable = management_writeCSR || (management_run && pipe2_csrWriteEnable && (state == STATE_EXECUTE));
	wire csrReadEnable = management_readCSR || (management_run && pipe1_csrReadEnable && (state == STATE_EXECUTE));
	wire[11:0] csrWriteAddress = !management_run ? management_csrIndex : pipe2_csrWriteAddress;
	wire[11:0] csrReadAddress = !management_run ? management_csrIndex : pipe1_csrReadAddress;
	wire[31:0] csrWriteData = !management_run ? management_writeData : pipe2_csrWriteData;
	
	wire instructionCompleted = !pipe2_stall;
	CSR csr(
		.clk(clk),
		.rst(rst),
		.csrWriteEnable(csrWriteEnable),
		.csrReadEnable(csrReadEnable),
		.csrWriteAddress(csrWriteAddress),
		.csrReadAddress(csrReadAddress),
		.csrWriteData(csrWriteData),
		.csrReadData(csrReadData),
		.coreIndex(coreIndex),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.extensions(extensions),
		.instructionCompleted(instructionCompleted),
		.programCounter(executeProgramCounter),
		.currentInstruction(pipe1_currentInstruction),
		.instruction_memoryAddress(instruction_memoryAddress),
		.data_memoryAddress(pipe1_fullMemoryAddress),
		.isMachineTimerInterrupt(isMachineTimerInterrupt),
		.isMachineExternalInterrupt(isMachineExternalInterrupt),
		.isMachineSoftwareInterrupt(isMachineSoftwareInterrupt),
		.isFetchAddressMisaligned(pipe0_addressMisaligned),
		.isDataAddressMisaligned_load(pipe1_addressMisaligned_load),
		.isDataAddressMisaligned_store(pipe1_addressMisaligned_store),
		.isJumpMissaligned(pipe1_jumpMissaligned),
		.isFetchAccessFault(instruction_memoryAccessFault),
		.isDataAccessFault_load(data_memoryAccessFault && data_memoryEnable && !data_memoryWriteEnable),
		.isDataAccessFault_store(data_memoryAccessFault && data_memoryEnable && data_memoryWriteEnable),
		.isInvalidInstruction(pipe1_invalidInstruction),
		.isEBREAK(eBreak),
		.isECALL(eCall),
		.isFetchAddressBreakpoint(instruction_memoryAddressBreakpoint),
		.isDataAddressBreakpoint(data_memoryAddressBreakpoint),
		.userInterrupts(management_interruptEnable ? userInterrupts : 16'b0),
		.trapReturn(trapReturn),
		.inTrap(inTrap),
		.trapVector(trapVector),
		.trapReturnVector(trapReturnVector));

	// Debug
	assign probe_state = state;
	assign probe_env = { eCall, eBreak };
	assign probe_programCounter = executeProgramCounter;

endmodule
