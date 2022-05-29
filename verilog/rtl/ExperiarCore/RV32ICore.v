module RV32ICore(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		// SRAM interface
		output wire[31:0] memoryAddress,
		output wire[3:0] memoryByteSelect,
		output wire memoryWriteEnable,
		output wire memoryReadEnable,
		output wire[31:0] memoryDataWrite,
		input wire[31:0] memoryDataRead,
		input wire memoryBusy,

		// Management interface
		input wire management_run,
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

		// Logic probes
		output wire[1:0] probe_state,
		output wire[31:0] probe_programCounter,
		output wire[6:0] probe_opcode,
		output wire[3:0] probe_errorCode,
		output wire probe_isBranch,
		output wire probe_takeBranch,
		output wire probe_isStore,
		output wire probe_isLoad,
		output wire probe_isCompressed
    );

	localparam STATE_HALT 	 = 2'b00;
	localparam STATE_FETCH   = 2'b10;
	localparam STATE_EXECUTE = 2'b11;

	// System registers
	reg[1:0] state = STATE_HALT;
	reg[3:0] currentError = 4'b0;
	reg[31:0] programCounter = 32'b0;
	reg[31:0] currentInstruction = 32'b0;
	reg[31:0] registers [0:31];

	// Management control
	localparam MANAGMENT_ADDRESS_SYSTEM	   = 2'b00;
	localparam MANAGMENT_ADDRESS_REGISTERS = 2'b01;
	localparam MANAGMENT_ADDRESS_CSR 	   = 2'b10;

	wire management_selectProgramCounter      = (management_address[15:14] == MANAGMENT_ADDRESS_SYSTEM) && (management_address[13:4] == 10'h000);
	wire management_selectInstructionRegister = (management_address[15:14] == MANAGMENT_ADDRESS_SYSTEM) && (management_address[13:4] == 10'h001);
	wire management_selectRegister            = (management_address[15:14] == MANAGMENT_ADDRESS_REGISTERS) && (management_address[13:7] == 7'h00);
	wire management_selectCSR 				  = management_address[15:14] == MANAGMENT_ADDRESS_CSR;

	wire management_writeValid = !management_run && management_writeEnable;
	wire management_writeProgramCounter = management_writeValid && management_selectProgramCounter;
	wire management_writeProgramCounter_set = management_writeProgramCounter && (management_address[3:0] == 4'h0);
	wire management_writeProgramCounter_jump = management_writeProgramCounter && (management_address[3:0] == 4'h4);
	wire management_writeProgramCounter_step = management_writeProgramCounter && (management_address[3:0] == 4'h8);
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
	wire[31:0] management_jumpTarget = programCounter + management_writeData;

	reg[31:0] management_dataOut;

	always @(*) begin
		case (1'b1)
			management_readProgramCounter: management_dataOut <= programCounter;
			management_readInstructionRegister : management_dataOut <= currentInstruction;
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

	// CSR
	// Core interface
	wire coreCSRWrite;
	wire coreCSRRead;
	wire[11:0] coreCSRIndex = currentInstruction[31:20];
	reg[32:0] coreCSRWriteData;

	// Combined interface
	wire csrWriteEnable = management_writeCSR || (management_run && coreCSRWrite);
	wire csrReadEnable = management_readCSR || (management_run && coreCSRRead);
	wire[11:0] csrAddress = !management_run ? management_csrIndex : coreCSRIndex;
	wire[31:0] csrWriteData = !management_run ? management_writeData : coreCSRWriteData;
	wire[31:0] csrReadData;
	CSR csr(
		.clk(clk),
		.rst(rst),
		.csrWriteEnable(csrWriteEnable),
		.csrReadEnable(csrReadEnable),
		.csrAddress(csrAddress),
		.csrWriteData(csrWriteData),
		.csrReadData(csrReadData),
		.coreIndex(coreIndex),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.extensions(extensions),
		.instructionCompleted(instructionCompleted));

	// Immediate Decode
	wire[31:0] imm_I = {currentInstruction[31] ? 21'h1F_FFFF : 21'h00_0000, currentInstruction[30:25], currentInstruction[24:21], currentInstruction[20]};
	wire[31:0] imm_S = {currentInstruction[31] ? 21'h1F_FFFF : 21'h00_0000, currentInstruction[30:25], currentInstruction[11:8] , currentInstruction[7]};
	wire[31:0] imm_B = {currentInstruction[31] ? 20'hF_FFFF  : 20'h0_0000 , currentInstruction[7]    , currentInstruction[30:25], currentInstruction[11:8] , 1'b0};
	wire[31:0] imm_U = {currentInstruction[31]							  , currentInstruction[30:20], currentInstruction[19:12], 12'h000};
	wire[31:0] imm_J = {currentInstruction[31] ? 12'hFFF : 12'h000 		  , currentInstruction[19:12], currentInstruction[20]	, currentInstruction[30:25], currentInstruction[24:21], 1'b0};

	// Instruction decode
	wire[6:0] opcode = currentInstruction[6:0];
	wire[4:0] rdIndex = currentInstruction[11:7];
	wire[4:0] rs1Index = currentInstruction[19:15];
	wire[4:0] rs2Index = currentInstruction[24:20];
	wire[2:0] funct3 = currentInstruction[14:12];
	wire[6:0] funct7 = currentInstruction[31:25];
	wire isCompressed = opcode[1:0] != 2'b11;

	// Instruction decode
	wire isLUI 	  = (opcode == 7'b0110111);
	wire isAUIPC  = (opcode == 7'b0010111);
	wire isJAL 	  = (opcode == 7'b1101111);
	wire isJALR   = (opcode == 7'b1100111) && (funct3 == 3'b000);
	wire isBranch = (opcode == 7'b1100011) && (funct3 != 3'b010) && (funct3 != 3'b011);
	wire isLoad   = (opcode == 7'b0000011) && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010 || funct3 == 3'b100 || funct3 == 3'b101);
	wire isStore  = (opcode == 7'b0100011) && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010);
	wire isALUImmBase = (opcode == 7'b0010011);
	wire isALUImmNormal = isALUImmBase && funct3 != 3'b001 && funct3 != 3'b101;
	wire isALUImmShift = isALUImmBase && ((funct3 == 3'b001 && funct7 == 7'b0000000) || (funct3 == 3'b101 && (funct7 == 7'b0000000 || funct7 == 7'b0100000)));
	wire isALUImm = isALUImmShift || isALUImmNormal;
	wire isALU 	  = (opcode == 7'b0110011) && (funct7 == 7'b0000000 || ((funct7 == 7'b0100000) && (funct3 == 3'b000 || funct3 == 3'b101)));
	wire isFENCE  = (opcode == 7'b0001111) && (funct3 == 3'b000);
	wire isSystem = (opcode == 7'b1110011);
	
	// System commands
	wire isCSR = isSystem && (funct3 != 3'b000);
	wire isCSRIMM = isCSR && funct3[2];
	wire isCSRRW = isCSR && (funct3[1:0] == 2'b01);
	wire isCSRRS = isCSR && (funct3[1:0] == 2'b10);
	wire isCSRRC = isCSR && (funct3[1:0] == 2'b11);
	wire isECALL  = isSystem && (currentInstruction[31:7] == 25'b0000000000000000000000000);
	wire isEBREAK = isSystem && (currentInstruction[31:7] == 25'b0000000000010000000000000);

	reg invalidInstruction;

	always @(*) begin
		case ({ isLUI, isAUIPC, isJAL, isJALR, isBranch, isLoad, isStore, isALUImm, isALU, isFENCE, isSystem })
			'b00000000001: invalidInstruction <= 1'b0;
			'b00000000010: invalidInstruction <= 1'b0;
			'b00000000100: invalidInstruction <= 1'b0;
			'b00000001000: invalidInstruction <= 1'b0;
			'b00000010000: invalidInstruction <= 1'b0;
			'b00000100000: invalidInstruction <= 1'b0;
			'b00001000000: invalidInstruction <= 1'b0;
			'b00010000000: invalidInstruction <= 1'b0;
			'b00100000000: invalidInstruction <= 1'b0;
			'b01000000000: invalidInstruction <= 1'b0;
			'b10000000000: invalidInstruction <= 1'b0;
			default: invalidInstruction <= 1'b1;
		endcase
	end

	// Integer Registers
	wire[31:0] rs1 = |rs1Index ? registers[rs1Index] : 32'b0;
	wire[31:0] rs2 = |rs2Index ? registers[rs2Index] : 32'b0;

	// Setup inputs for ALU and branch control
	wire[31:0] inputA = isAUIPC ? programCounter : rs1;
	wire[31:0] inputB = isAUIPC  ? imm_U : 
						isALUImm ? imm_I :
						isLoad   ? imm_I : 
						isStore  ? imm_S :
								   rs2;

	// The use of A-B for comparison is based on https://github.com/BrunoLevy/learn-fpga/tree/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV#from-blinker-to-risc-v
	wire[31:0] aluAPlusB = inputA + inputB;
	wire[32:0] aluACompareB = { 1'b0, inputA } - { 1'b0, inputB };
	wire[31:0] aluAMinusB = aluACompareB[31:0];
	wire aluAEqualsB = aluAMinusB == 32'b0;
	wire aluALessThanB = inputA[31] ^ inputB[31] ? inputA[31] : aluACompareB[32];
	wire aluALessThanBUnsigned = aluACompareB[32];

	// Jump and branch control
	reg takeBranch;
	always @(*) begin
		case (funct3)
			/*BEQ*/  3'b000: takeBranch <= aluAEqualsB;
			/*BNE*/  3'b001: takeBranch <= !aluAEqualsB;
			//*None*/ 3'b010: takeBranch <= 1'b0;
			//*None*/ 3'b011: takeBranch <= 1'b0;
			/*BLT*/  3'b100: takeBranch <= aluALessThanB;
			/*BGE*/  3'b101: takeBranch <= !aluALessThanB;
			/*BLTU*/ 3'b110: takeBranch <= aluALessThanBUnsigned;
			/*BGEU*/ 3'b111: takeBranch <= !aluALessThanBUnsigned;
					default: takeBranch <= 1'b0;
		endcase
	end

	wire[31:0] programCounterLink = programCounter + (isCompressed ? 2 : 4);
	wire[31:0] nextProgramCounterBase = isJAL 					 ? programCounter :
										isJALR		  			 ? rs1 			  :
										(isBranch && takeBranch) ? programCounter :
																   programCounterLink;
	wire[31:0] nextProgramCounterOffset = isJAL 				   ? imm_J :
										  isJALR		  		   ? imm_I :
										  (isBranch && takeBranch) ? imm_B :
																     32'b0;
	wire[31:0] nextProgramCounterFull = nextProgramCounterBase + nextProgramCounterOffset;
	wire[31:0] nextProgramCounterCompressed = programCounterLink; // TODO: Need to implement compressed branch and jump instructions
	wire[31:0] nextProgramCounter = isCompressed ? nextProgramCounterCompressed : nextProgramCounterFull;

	// ALU	
	wire aluAlt = funct7 == 7'b0100000 && (isALU || isALUImmShift);
	
	// Using only a single shifter also from https://github.com/BrunoLevy/learn-fpga/tree/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV#from-blinker-to-risc-v
	// Although I feel like there is an easier way to flip bit orderings
	function [31:0] flipBits32 (input [31:0] x);
		flipBits32 = { x[ 0], x[ 1], x[ 2], x[ 3], x[ 4], x[ 5], x[ 6], x[ 7], 
					   x[ 8], x[ 9], x[10], x[11], x[12], x[13], x[14], x[15], 
					   x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23],
					   x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31] };
	endfunction

	wire isLeftShift = funct3 == 3'b001;
	wire[31:0] shiftInput = isLeftShift ? flipBits32(inputA) : inputA;
	wire[31:0] aluShifter = $signed({ aluAlt && shiftInput[31] && !isLeftShift, shiftInput } >>> inputB[4:0]);
	wire[31:0] rightShift = aluShifter[31:0];
	wire[31:0] leftShift = flipBits32(rightShift);

	reg[31:0] aluValue;
	always @(*) begin
		case (funct3)
			/*ADD*/  3'b000: aluValue <= aluAlt ? aluAMinusB : aluAPlusB;
			/*SLL*/  3'b001: aluValue <= leftShift;
			/*SLT*/  3'b010: aluValue <= {31'b0, aluALessThanB};
			/*SLTU*/ 3'b011: aluValue <= {31'b0, aluALessThanBUnsigned};
			/*XOR*/  3'b100: aluValue <= inputA ^ inputB;
			/*SRL*/  3'b101: aluValue <= rightShift;
			/*OR*/   3'b110: aluValue <= inputA | inputB;
			/*AND*/  3'b111: aluValue <= inputA & inputB;
					default: aluValue <= 32'b0;
		endcase
	end

	// CSR data connections
	assign coreCSRWrite = isCSRRW || (isCSR && |rs1Index);
	assign coreCSRRead = isCSRRC || isCSRRS || (isCSR && |rdIndex);

	wire csrRS1Data = isCSRIMM ? { 27'b0, rs1Index} : rs1;

	always @(*) begin
		if (isCSR) begin			
			if (isCSRRW) coreCSRWriteData <= csrRS1Data;
			else if (isCSRRS) coreCSRWriteData <= csrReadData | csrRS1Data;
			else if (isCSRRC) coreCSRWriteData <= csrReadData & ~csrRS1Data;
			else coreCSRWriteData <= 32'b0;
		end else begin
			coreCSRWriteData <= 32'b0;
		end 
	end

	// Memory connections
	wire[31:0] targetMemoryAddress = state == STATE_FETCH   ? programCounter : 
									 state == STATE_EXECUTE ? aluAPlusB:
									 						  32'b0;
	wire loadSigned    = (funct3 == 3'b100) || (funct3 == 3'b101);
	wire loadStoreWord = funct3 == 3'b010;
	wire loadStoreHalf = funct3[1:0] == 3'b01;
	wire loadStoreByte = funct3[1:0] == 2'b00;
	reg[3:0] baseByteMask;
	always @(*) begin
		if (state == STATE_FETCH) baseByteMask <= 4'b1111;
		else if ((isLoad || isStore) && state == STATE_EXECUTE) begin
			if (loadStoreWord) baseByteMask <= 4'b1111;
			else if (loadStoreHalf) baseByteMask <= 4'b0011;
			else if (loadStoreByte) baseByteMask <= 4'b0001;
			else baseByteMask <= 4'b0000;
		end else baseByteMask <= 4'b0000;
	end

	wire[6:0] loadStoreByteMask = {3'b0, baseByteMask} << targetMemoryAddress[1:0];
	wire loadStoreByteMaskValid = |(loadStoreByteMask[3:0]);
	wire addressMissaligned = |loadStoreByteMask[6:4];
	wire shouldLoad  = loadStoreByteMaskValid && !addressMissaligned && ((state == STATE_FETCH) || ((state == STATE_EXECUTE) && isLoad));
	wire shouldStore = loadStoreByteMaskValid && !addressMissaligned && ((state == STATE_EXECUTE) && isStore);
	assign memoryAddress = shouldLoad || shouldStore ? { targetMemoryAddress[31:2], 2'b00 } : 32'b0;

	assign memoryByteSelect = shouldStore || shouldLoad  ? loadStoreByteMask[3:0] : 4'b0000;

	wire[31:0] loadData  = shouldLoad && !shouldStore ? dataIn : 32'b0;
	wire[31:0] storeData = shouldStore && !shouldLoad ? rs2    : 32'b0;

	wire[31:0] dataIn = {
		loadStoreByteMask[3] ? memoryDataRead[31:24] : 8'h00,
		loadStoreByteMask[2] ? memoryDataRead[23:16] : 8'h00,
		loadStoreByteMask[1] ? memoryDataRead[15:8]  : 8'h00,
		loadStoreByteMask[0] ? memoryDataRead[7:0]   : 8'h00
	};

	assign memoryDataWrite = {
		loadStoreByteMask[3] ? storeData[31:24] : 8'h00,
		loadStoreByteMask[2] ? storeData[23:16] : 8'h00,
		loadStoreByteMask[1] ? storeData[15:8]  : 8'h00,
		loadStoreByteMask[0] ? storeData[7:0]   : 8'h00
	};

	assign memoryWriteEnable = shouldStore;
	assign memoryReadEnable = shouldLoad;

	wire memoryReadReady = shouldLoad ? !memoryBusy : 1'b0;
	wire memoryWriteDone = shouldStore ? !memoryBusy : 1'b0;

	// Register Write
	wire integerRegisterWriteEn = isLUI || isAUIPC || isJAL || isJALR || isALU || isALUImm || isLoad;
	wire[31:0] integerRegisterWriteData = isLUI 			  ? imm_U			   :
										  isAUIPC 			  ? aluAPlusB 		   :
										  isJAL 			  ? programCounterLink :
										  isJALR 			  ? programCounterLink :
										  isLoad 			  ? loadData		   :
										  (isALU || isALUImm) ? aluValue 		   :
																32'b0;

	wire progressExecute = isStore ? memoryWriteDone :
						   isLoad  ? memoryReadReady : 
							 		 1'b1;

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_HALT;
			programCounter <= 32'b0;
			currentError <= 4'b0;
			programCounter <= 32'b0;
			currentInstruction <= 32'b0;
		end else begin
			if (!(|currentError)) begin
				case (state)
					STATE_HALT: begin
						if (management_allowInstruction) state <= STATE_FETCH;
						else begin
							if (management_writeProgramCounter_set) programCounter <= { management_writeData[31:1] , 1'b0};
							else if (management_writeProgramCounter_jump) programCounter <= { management_jumpTarget[31:1] , 1'b0};
							else if (management_writeRegister) registers[management_registerIndex] <= management_writeData;
						end
					end

					STATE_FETCH: begin
						if (memoryReadReady) begin
							currentInstruction <= dataIn;
							state <= STATE_EXECUTE;
						end
					end

					STATE_EXECUTE: begin
						if (addressMissaligned || invalidInstruction) begin
							currentError <= { 1'b0, 1'b0, addressMissaligned, invalidInstruction };
						end else begin
							if (progressExecute) begin
								if (integerRegisterWriteEn && |rdIndex) registers[rdIndex] <= integerRegisterWriteData;

								programCounter <= { nextProgramCounter[31:1] , 1'b0};

								if (management_allowInstruction) state <= STATE_FETCH;
								else state <= STATE_HALT;
							end
						end
					end

					default: state <= STATE_HALT;
				endcase
			end
		end
	end

	// Debug
	assign probe_state = state;
	assign probe_programCounter = programCounter;
	assign probe_opcode = opcode;
	assign probe_errorCode = currentError;
	assign probe_isBranch = isBranch;
	assign probe_takeBranch = takeBranch;
	assign probe_isStore = isStore;
	assign probe_isLoad = isLoad;
	assign probe_isCompressed = isCompressed;

endmodule
