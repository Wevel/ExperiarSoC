module InstructionDecode (
		input wire[31:0] currentInstruction,
		input wire stall,
		output reg[6:0] opcode,
		output reg[4:0] rdIndex,
		output reg[4:0] rs1Index,
		output reg[4:0] rs2Index,
		output reg[2:0] funct3,
		output reg[6:0] funct7,
		output reg isCompressed,
		output reg isLUI,
		output reg isAUIPC,
		output reg isJAL,
		output reg isJALR,
		output reg isBranch,
		output reg isLoad,
		output reg isStore,
		output reg isALUImmBase,
		output reg isALUImmNormal,
		output reg isALUImmShift,
		output reg isALUImm,
		output reg isALU,
		output reg isFence,
		output reg isSystem,
		output reg isCSR,
		output reg isCSRIMM,
		output reg isCSRRW,
		output reg isCSRRS,
		output reg isCSRRC,
		output reg isECALL,
		output reg isEBREAK,
		output reg isRET,
		output reg invalidInstruction
	);
	
	

	// Instruction decode
	always @(*) begin
		if (stall) begin
			opcode <= 7'b0;
			rdIndex <= 5'b0;
			rs1Index <= 5'b0;
			rs2Index <= 5'b0;
			funct3 <= 3'b0;
			funct7 <= 7'b0;
			isCompressed <= 1'b0;
		end else begin
			opcode <= currentInstruction[6:0];
			rdIndex <= currentInstruction[11:7];
			rs1Index <= currentInstruction[19:15];
			rs2Index <= currentInstruction[24:20];
			funct3 <= currentInstruction[14:12];
			funct7 <= currentInstruction[31:25];
			isCompressed <= opcode[1:0] != 2'b11;
		end
	end

	// Instruction decode
	always @(*) begin
		if (stall) begin
			isLUI 		   <= 1'b0;
			isAUIPC 	   <= 1'b0;
			isJAL 		   <= 1'b0;
			isJALR   	   <= 1'b0;
			isBranch 	   <= 1'b0;
			isLoad   	   <= 1'b0;
			isStore  	   <= 1'b0;
			isALUImmBase   <= 1'b0;
			isALUImmNormal <= 1'b0;
			isALUImmShift  <= 1'b0;
			isALUImm 	   <= 1'b0;
			isALU 	 	   <= 1'b0;
			isFence  	   <= 1'b0;
			isSystem 	   <= 1'b0;
		end else begin
			isLUI 		   <= (opcode == 7'b0110111);
			isAUIPC 	   <= (opcode == 7'b0010111);
			isJAL 		   <= (opcode == 7'b1101111);
			isJALR   	   <= (opcode == 7'b1100111) && (funct3 == 3'b000);
			isBranch 	   <= (opcode == 7'b1100011) && (funct3 != 3'b010) && (funct3 != 3'b011);
			isLoad   	   <= (opcode == 7'b0000011) && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010 || funct3 == 3'b100 || funct3 == 3'b101);
			isStore  	   <= (opcode == 7'b0100011) && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010);
			isALUImmBase   <= (opcode == 7'b0010011);
			isALUImmNormal <= isALUImmBase && funct3 != 3'b001 && funct3 != 3'b101;
			isALUImmShift  <= isALUImmBase && ((funct3 == 3'b001 && funct7 == 7'b0000000) || (funct3 == 3'b101 && (funct7 == 7'b0000000 || funct7 == 7'b0100000)));
			isALUImm 	   <= isALUImmShift || isALUImmNormal;
			isALU 	 	   <= (opcode == 7'b0110011) && (funct7 == 7'b0000000 || ((funct7 == 7'b0100000) && (funct3 == 3'b000 || funct3 == 3'b101)));
			isFence  	   <= (opcode == 7'b0001111) && (funct3 == 3'b000);
			isSystem 	   <= (opcode == 7'b1110011);
		end
	end
	
	
	// System commands
	always @(*) begin
		if (stall) begin
			isCSR 	 <= 1'b0;
			isCSRIMM <= 1'b0;
			isCSRRW  <= 1'b0;
			isCSRRS  <= 1'b0;
			isCSRRC  <= 1'b0;
			isECALL  <= 1'b0;
			isEBREAK <= 1'b0;
			isRET 	 <= 1'b0;
		end else begin
			isCSR 	 <= isSystem && (funct3 != 3'b000);
			isCSRIMM <= isCSR && funct3[2];
			isCSRRW  <= isCSR && (funct3[1:0] == 2'b01);
			isCSRRS  <= isCSR && (funct3[1:0] == 2'b10);
			isCSRRC  <= isCSR && (funct3[1:0] == 2'b11);
			isECALL  <= isSystem && (currentInstruction[31:7] == 25'b0000000000000000000000000);
			isEBREAK <= isSystem && (currentInstruction[31:7] == 25'b0000000000010000000000000);
			isRET 	 <= isSystem && (currentInstruction[31:7] == 25'b0011000000100000000000000);
		end
	end

	wire validSystemCommand = isCSR || isECALL || isEBREAK || isRET;

	always @(*) begin
		if (stall) begin
			invalidInstruction <= 1'b0;
		end else begin
			case ({ isLUI, isAUIPC, isJAL, isJALR, isBranch, isLoad, isStore, isALUImm, isALU, isFence, isSystem })
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
				'b10000000000: invalidInstruction <= validSystemCommand;
				default: invalidInstruction <= 1'b1;
			endcase
		end
	end

endmodule