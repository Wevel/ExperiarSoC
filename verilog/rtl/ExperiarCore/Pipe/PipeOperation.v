module PipeOperation (
		input wire clk,
		input wire rst,

		// Pipe control
		input wire stepPipe,
		input wire pipeStall,
		output wire currentPipeStall,
		output wire active,
		input wire[31:0] currentInstruction,
		output wire[31:0] lastInstruction,
		output wire invalidInstruction,

		// CSR read control
		output wire[11:0] csrReadAddress,
		input wire[31:0] csrReadData,
		output wire csrReadEnable,

		// Operation inputs
		input wire[31:0] programCounter,
		output wire[4:0] rs1Address,
		input wire[31:0] rs1Data,
		output wire[4:0] rs2Address,
		input wire[31:0] rs2Data,

		// Operation outputs
		output wire operationResultStoreEnable,
		output wire[31:0] operationResult,
		output wire isJump,
		output wire isFence,
		output wire jumpEnable,
		output wire failedBranch,
		output wire[31:0] nextProgramCounter,
		output wire jumpMissaligned,
		output wire addressMisaligned_load,
		output wire addressMisaligned_store,

		// Load/Store control
		output wire memoryEnable,
		output wire memoryWriteEnable,
		output wire[3:0] memoryByteSelect,
		output wire[31:0] memoryAddress,
		output wire[31:0] memoryWriteData,
		output wire[31:0] fullMemoryAddress,

		// System operations
		output wire isECALL,
		output wire isEBREAK,
		output wire isRET
	);

	// Pipe control
	PipeStage pipeStage(
		.clk(clk),
		.rst(rst),
		.stepPipe(stepPipe),
		.pipeStall(pipeStall),
		.currentPipeStall(currentPipeStall),
		.active(active),
		.currentInstruction(currentInstruction),
		.lastInstruction(lastInstruction));

	// Instruction decode
	wire[6:0] opcode;
	wire[4:0] rdIndex; wire[4:0] rs1Index; wire[4:0] rs2Index;
	wire[2:0] funct3; wire[6:0] funct7;
	wire isCompressed;
	wire isLUI; wire isAUIPC; wire isJAL; wire isJALR; wire isBranch; wire isLoad; wire isStore;
	wire isALUImmBase; wire isALUImmNormal; wire isALUImmShift; wire isALUImm; wire isALU;
	wire isSystem; 
	wire isCSR; wire isCSRIMM; wire isCSRRW; wire isCSRRS; wire isCSRRC; 
	InstructionDecode decode(
		.currentInstruction(currentInstruction),
		.stall(pipeStall),
		.opcode(opcode),
		.rdIndex(rdIndex), .rs1Index(rs1Index), .rs2Index(rs2Index),
		.funct3(funct3), .funct7(funct7),
		.isCompressed(isCompressed),
		.isLUI(isLUI), .isAUIPC(isAUIPC), .isJAL(isJAL), .isJALR(isJALR), .isBranch(isBranch), .isLoad(isLoad), .isStore(isStore),
		.isALUImmBase(isALUImmBase), .isALUImmNormal(isALUImmNormal), .isALUImmShift(isALUImmShift), .isALUImm(isALUImm), .isALU(isALU),
		.isFence(isFence), .isSystem(isSystem),
		.isCSR(isCSR), .isCSRIMM(isCSRIMM), .isCSRRW(isCSRRW), .isCSRRS(isCSRRS), .isCSRRC(isCSRRC),
		.isECALL(isECALL), .isEBREAK(isEBREAK), .isRET(isRET),
		.invalidInstruction(invalidInstruction)
	);

	// Immediate Decode
	wire[31:0] imm_I = {currentInstruction[31] ? 21'h1F_FFFF : 21'h00_0000, currentInstruction[30:25], currentInstruction[24:21], currentInstruction[20]};
	wire[31:0] imm_S = {currentInstruction[31] ? 21'h1F_FFFF : 21'h00_0000, currentInstruction[30:25], currentInstruction[11:8] , currentInstruction[7]};
	wire[31:0] imm_B = {currentInstruction[31] ? 20'hF_FFFF  : 20'h0_0000 , currentInstruction[7]    , currentInstruction[30:25], currentInstruction[11:8] , 1'b0};
	wire[31:0] imm_U = {currentInstruction[31]							  , currentInstruction[30:20], currentInstruction[19:12], 12'h000};
	wire[31:0] imm_J = {currentInstruction[31] ? 12'hFFF : 12'h000 		  , currentInstruction[19:12], currentInstruction[20]	, currentInstruction[30:25], currentInstruction[24:21], 1'b0};


	// Setup inputs for ALU and branch control
	wire[31:0] inputA = isAUIPC ? programCounter : rs1Data;
	reg[31:0] inputB;
	always @(*) begin
		case (1'b1)
			isAUIPC : inputB <= imm_U;
			isALUImm: inputB <= imm_I;
			isLoad 	: inputB <= imm_I;
			isStore : inputB <= imm_S;
			default: inputB <= rs2Data;
		endcase
	end

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
		if (isBranch) begin
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
		end else begin
			takeBranch <= 1'b0;
		end
	end

	wire[31:0] programCounterLink = programCounter + (isCompressed ? 2 : 4);

	reg[31:0] nextProgramCounterBase;
	always @(*) begin
		case (1'b1)
			isJAL 	   : nextProgramCounterBase <= programCounter;
			isJALR     : nextProgramCounterBase <= rs1Data;
			takeBranch : nextProgramCounterBase <= programCounter;
			default    : nextProgramCounterBase <= programCounterLink;
		endcase
	end

	reg[31:0] nextProgramCounterOffset;
	always @(*) begin
		case (1'b1)
			isJAL 	   : nextProgramCounterOffset <= imm_J;
			isJALR     : nextProgramCounterOffset <= imm_I;
			takeBranch : nextProgramCounterOffset <= imm_B;
			default    : nextProgramCounterOffset <= 32'b0;
		endcase
	end

	wire[31:0] nextProgramCounterWord = nextProgramCounterBase + nextProgramCounterOffset;
	wire[31:0] nextProgramCounterCompressed = programCounterLink; // TODO: Need to implement compressed branch and jump instructions
	wire[31:0] nextProgramCounterFull = isCompressed ? nextProgramCounterCompressed : nextProgramCounterWord;
	assign isJump = isJAL || isJALR || isBranch;
	assign jumpEnable = isJAL || isJALR || takeBranch;
	assign failedBranch = isBranch && !takeBranch;
	assign nextProgramCounter = { nextProgramCounterFull[31:1] , 1'b0};
	assign jumpMissaligned = !isCompressed && |nextProgramCounter[1:0] && (isJAL || isJALR || takeBranch);

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
	wire signed[32:0] signedShiftInput = { aluAlt && shiftInput[31] && !isLeftShift, shiftInput };
	wire[32:0] aluShifter = $signed(signedShiftInput >>> inputB[4:0]);
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

	wire[31:0] csrRS1Data = isCSRIMM ? { 27'b0, rs1Index} : rs1Data;

	reg[31:0] csrWriteData;
	always @(*) begin
		if (isCSR) begin			
			if (isCSRRW) csrWriteData <= csrRS1Data;
			else if (isCSRRS) csrWriteData <= csrReadData | csrRS1Data;
			else if (isCSRRC) csrWriteData <= csrReadData & ~csrRS1Data;
			else csrWriteData <= 32'b0;
		end else begin
			csrWriteData <= 32'b0;
		end 
	end

	wire csrRead = isCSRRC || isCSRRS || (isCSR && |rdIndex);
	wire needStore = isLUI || isAUIPC || isJAL || isJALR || isALU || isALUImm || isLoad || csrRead;

	reg[31:0] currentData;
	always @(*) begin
		case (1'b1)
			isLUI			   : currentData <= imm_U;
			isAUIPC			   : currentData <= aluAPlusB;
			isJAL			   : currentData <= programCounterLink;
			isJALR	   		   : currentData <= programCounterLink;
			(isALU || isALUImm): currentData <= aluValue;
			isLoad 			   : currentData <= aluAPlusB;
			csrRead	   		   : currentData <= csrWriteData;
			default: currentData <= 32'b0;
		endcase
	end

	// Memory interface
	wire[31:0] targetMemoryAddress = aluAPlusB;
	wire loadSigned    = (funct3 == 3'b000) || (funct3 == 3'b001);
	wire loadStoreByte = funct3[1:0] == 2'b00;
	wire loadStoreHalf = funct3[1:0] == 2'b01;
	wire loadStoreWord = funct3 == 3'b010;
	reg[3:0] baseByteMask;
	always @(*) begin
		if ((isLoad || isStore)) begin
			if (loadStoreWord) baseByteMask <= 4'b1111;
			else if (loadStoreHalf) baseByteMask <= 4'b0011;
			else if (loadStoreByte) baseByteMask <= 4'b0001;
			else baseByteMask <= 4'b0000;
		end else begin
			baseByteMask <= 4'b0000;
		end
	end

	wire[6:0] loadStoreByteMask = {3'b0, baseByteMask} << targetMemoryAddress[1:0];
	wire loadStoreByteMaskValid = |(loadStoreByteMask[3:0]);
	wire isAddressMisaligned = |loadStoreByteMask[6:4] || (loadStoreHalf && targetMemoryAddress[1:0] == 2'h1);
	assign fullMemoryAddress = targetMemoryAddress;
	assign addressMisaligned_load = isAddressMisaligned && isLoad;
	assign addressMisaligned_store = isAddressMisaligned && isStore;
	wire shouldLoad  = loadStoreByteMaskValid && !isAddressMisaligned && isLoad;
	wire shouldStore = loadStoreByteMaskValid && !isAddressMisaligned && isStore;
	wire shouldLoadOrStore = shouldLoad || shouldStore;

	reg[31:0] dataOut;
	always @(*) begin
		case (targetMemoryAddress[1:0])
			2'b00: dataOut = {
					baseByteMask[3] ? rs2Data[31:24] : 8'h00,
					baseByteMask[2] ? rs2Data[23:16] : 8'h00,
					baseByteMask[1] ? rs2Data[15:8]  : 8'h00,
					baseByteMask[0] ? rs2Data[7:0]   : 8'h00
				};

			2'b01: dataOut = {
					baseByteMask[2] ? rs2Data[23:16] : 8'h00,
					baseByteMask[1] ? rs2Data[15:8]  : 8'h00,
					baseByteMask[0] ? rs2Data[7:0]   : 8'h00,
					8'h00
				};

			2'b10: dataOut = {
					baseByteMask[1] ? rs2Data[15:8]  : 8'h00,
					baseByteMask[0] ? rs2Data[7:0]   : 8'h00,
					8'h00,
					8'h00
				};

			2'b11: dataOut = {
					baseByteMask[0] ? rs2Data[7:0]   : 8'h00,
					8'h00,
					8'h00,
					8'h00
				};
		endcase
	end

	// Register read control
	assign rs1Address = rs1Index;
	assign rs2Address = rs2Index;

	// CSR read control
	assign csrReadAddress = currentInstruction[31:20];
	assign csrReadEnable = csrRead && !pipeStall;

	// Result register control
	assign operationResultStoreEnable = needStore && !pipeStall;
	assign operationResult = currentData;

	// Load/Store control
	assign memoryEnable = shouldLoadOrStore && !pipeStall;
	assign memoryWriteEnable = shouldStore && !pipeStall;
	assign memoryByteSelect = shouldLoadOrStore ? loadStoreByteMask[3:0] : 4'b0000;
	assign memoryAddress = shouldLoadOrStore ? { targetMemoryAddress[31:2], 2'b00 } : 32'b0;
	assign memoryWriteData = dataOut;

endmodule