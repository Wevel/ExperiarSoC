module PipeStore (
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

		// Memory control
		output wire expectingLoad,

		// Store inputs
		input wire[31:0] memoryDataRead,
		input wire[31:0] aluResultData,
		input wire[31:0] csrData,

		// Register store control
		output wire[4:0] registerWriteAddress,
		output wire[31:0] registerWriteData,
		output wire registerWriteEnable,

		// CSR store control
		output wire[11:0] csrWriteAddress,
		output wire[31:0] csrWriteData,
		output wire csrWriteEnable,

		// Stall control
		output wire isJump,
		output wire isFence,
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
	wire isECALL; wire isEBREAK;
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

	// Memory connections
	wire[31:0] targetMemoryAddress = aluResultData;
	wire loadSigned    = (funct3 == 3'b000) || (funct3 == 3'b001);
	wire loadStoreByte = funct3[1:0] == 2'b00;
	wire loadStoreHalf = funct3[1:0] == 2'b01;
	wire loadStoreWord = funct3 == 3'b010;
	reg[3:0] baseByteMask;
	always @(*) begin
		if (isLoad || isStore) begin
			if (loadStoreWord) baseByteMask <= 4'b1111;
			else if (loadStoreHalf) baseByteMask <= 4'b0011;
			else if (loadStoreByte) baseByteMask <= 4'b0001;
			else baseByteMask <= 4'b0000;
		end else begin
			baseByteMask <= 4'b0000;
		end
	end

	reg signExtend;
	always @(*) begin
		if (loadSigned) begin
			if (loadStoreByte) begin
				case (targetMemoryAddress[1:0])
					2'b00: signExtend <= memoryDataRead[7];
					2'b01: signExtend <= memoryDataRead[15];
					2'b10: signExtend <= memoryDataRead[23];
					2'b11: signExtend <= memoryDataRead[31];
				endcase
			end else if (loadStoreHalf) begin
				case (targetMemoryAddress[1:0])
					2'b00: signExtend <= memoryDataRead[15];
					2'b01: signExtend <= memoryDataRead[23];
					2'b10: signExtend <= memoryDataRead[31];
					2'b11: signExtend <= 1'b0;
				endcase
			end else begin
				signExtend <= 1'b0;
			end
		end else begin
			signExtend <= 1'b0;
		end
	end

	wire[7:0] signExtendByte = signExtend ? 8'hFF : 8'h00;

	wire[6:0] loadStoreByteMask = {3'b0, baseByteMask} << targetMemoryAddress[1:0];
	wire loadStoreByteMaskValid = |(loadStoreByteMask[3:0]);
	wire addressMissaligned = |loadStoreByteMask[6:4];
	wire shouldLoad  = loadStoreByteMaskValid && !addressMissaligned && isLoad;

	reg[31:0] dataIn;
	always @(*) begin
		case (targetMemoryAddress[1:0])
			2'b00: dataIn = {
					loadStoreByteMask[3] ? memoryDataRead[31:24] : signExtendByte,
					loadStoreByteMask[2] ? memoryDataRead[23:16] : signExtendByte,
					loadStoreByteMask[1] ? memoryDataRead[15:8]  : signExtendByte,
					loadStoreByteMask[0] ? memoryDataRead[7:0]   : 8'h00
				};

			2'b01: dataIn = {
					signExtendByte,
					loadStoreByteMask[3] ? memoryDataRead[31:24] : signExtendByte,
					loadStoreByteMask[2] ? memoryDataRead[23:16] : signExtendByte,
					loadStoreByteMask[1] ? memoryDataRead[15:8]  : 8'h00
				};

			2'b10: dataIn = {
					signExtendByte,
					signExtendByte,
					loadStoreByteMask[3] ? memoryDataRead[31:24] : signExtendByte,
					loadStoreByteMask[2] ? memoryDataRead[23:16] : 8'h00
				};

			2'b11: dataIn = {
					signExtendByte,
					signExtendByte,
					signExtendByte,
					loadStoreByteMask[3] ? memoryDataRead[31:24] : 8'h00
				};
		endcase
	end

	// Register Write
	wire csrWrite = isCSRRW || (isCSR && |rdIndex);
	wire integerRegisterWriteEn = isLUI || isAUIPC || isJAL || isJALR || isALU || isALUImm || isLoad || csrWrite;
	reg[31:0] integerRegisterWriteData;
	always @(*) begin
		case (1'b1)
			isLUI			   : integerRegisterWriteData <= aluResultData;
			isAUIPC			   : integerRegisterWriteData <= aluResultData;
			isJAL			   : integerRegisterWriteData <= aluResultData;
			isJALR	   		   : integerRegisterWriteData <= aluResultData;
			shouldLoad  	   : integerRegisterWriteData <= dataIn;
			(isALU || isALUImm): integerRegisterWriteData <= aluResultData;
			csrWrite   		   : integerRegisterWriteData <= csrData;
			default: integerRegisterWriteData <= 32'b0;
		endcase
	end

	// Memory control
	assign expectingLoad = shouldLoad;
	
	// Register write control
	assign registerWriteAddress = rdIndex;
	assign registerWriteData = integerRegisterWriteData;
	assign registerWriteEnable = integerRegisterWriteEn && !pipeStall;

	// CSR write control
	assign csrWriteAddress = currentInstruction[31:20];
	assign csrWriteData = aluResultData;
	assign csrWriteEnable = csrWrite && !pipeStall;

	// Stall control
	assign isJump = isJAL || isJALR || isBranch;

endmodule