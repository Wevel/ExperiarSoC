module ExperiarCore(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire nrst,

		//input wire[31:0] coreID,

		output wire[3:0] loadEnableByteMask,
		output wire[3:0] storeEnableByteMask,
		output reg[31:0] memoryAddress,
		inout wire[31:0] memoryData,

		output wire[31:0] probe_programCounter,
		output wire[1:0] probe_state,
		output wire[3:0] probe_errorCode,
		output wire probe_isBranch,
		output wire probe_takeBranch
    );

	localparam STATE_FETCH   = 2'b00;
	localparam STATE_EXECUTE = 2'b01;
	localparam STATE_ERROR   = 2'b11;

	// System registers
	reg[31:0] programCounter;
	reg[1:0] state;
	reg[3:0] currentError;
	reg[31:0] currentInstruction;
	reg[31:0] registers [0:31];

	// Immediate Decode
	wire[31:0] imm_I = {inputValue[31] ? 21'h1F_FFFF : 21'h00_0000, inputValue[30:25], inputValue[24:21], inputValue[20]};
	wire[31:0] imm_S = {inputValue[31] ? 21'h1F_FFFF : 21'h00_0000, inputValue[30:25], inputValue[11:8] , inputValue[7]};
	wire[31:0] imm_B = {inputValue[31] ? 20'hF_FFFF  : 20'h0_0000 , inputValue[7]    , inputValue[30:25], inputValue[11:8] , 1'b0};
	wire[31:0] imm_U = {inputValue[31]							  , inputValue[30:20], inputValue[19:12], 12'h000};
	wire[31:0] imm_J = {inputValue[31] ? 12'hFFF : 12'h000 		  , inputValue[19:12], inputValue[20]	, inputValue[30:25], inputValue[24:21], 1'b0};

	// Instruction decode
	wire[6:0] opcode = currentInstruction[6:0];
	wire[4:0] rdIndex = currentInstruction[11:7];
	wire[4:0] rs1Index = currentInstruction[19:15];
	wire[4:0] rs2Index = currentInstruction[24:20];
	wire[2:0] funct3 = currentInstruction[14:12];
	wire[6:0] funct7 = currentInstruction[31:25];
	wire isCompressed = !(opcode[0] && opcode[1]);

	// Instruction decode
	wire isLUI 	  = (opcode == 7'b0110111);
	wire isAUIPC  = (opcode == 7'b0010111);
	wire isJAL 	  = (opcode == 7'b1101111);
	wire isJALR   = (opcode == 7'b1100111) && (funct3 == 3'b000);
	wire isBranch = (opcode == 7'b1100011) && (funct3 != 3'b010) && (funct3 != 3'b011);
	wire isLoad   = (opcode == 7'b0000011) && (funct3 != 3'b010) && (funct3 != 3'b011);
	wire isStore  = (opcode == 7'b0100011) && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010);
	wire isALUImm = (opcode == 7'b0010011) && (funct3 != 3'b001 || funct7 == 7'b0000000) && (funct3 != 3'b101 || funct7 == 7'b0000000 || funct7 == 7'b0100000);
	wire isALU 	  = (opcode == 7'b0110011) && (funct7 == 7'b0000000 || ((funct7 == 7'b0100000) && (funct3 == 3'b000 || funct3 == 3'b101)));
	wire isFENCE  = (opcode == 7'b0001111) && (funct3 == 3'b000);
	wire isSystem = (opcode == 7'b1110011);

	wire isECALL  = isSystem && (currentInstruction == 32'b00000000000000000000000001110011);
	wire isEBREAK = isSystem && (currentInstruction == 32'b00000000000100000000000001110011);

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
	wire[31:0] inputA = rs1;
	wire[31:0] inputB = isAUIPC  ? imm_U : 
						isALUImm ? imm_I : 
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
	wire aluAlt = funct7 == 7'b0100000;
	
	// Using only a single shifter also from https://github.com/BrunoLevy/learn-fpga/tree/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV#from-blinker-to-risc-v
	// Although I feel like there is an easier way to flip bit orderings
	function [31:0] flipBits32;
		input wire[31:0] x;
		 flipBits32 = { x[ 0], x[ 1], x[ 2], x[ 3], x[ 4], x[ 5], x[ 6], x[ 7], 
						x[ 8], x[ 9], x[10], x[11], x[12], x[13], x[14], x[15], 
						x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23],
				    	x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31] };
	endfunction

	wire isLeftShift = funct3 == 3'b001;
	wire[31:0] shiftInput = isLeftShift ? flipBits32(inputA) : inputA;
	wire[31:0] aluShifter = $signed({ alt && shiftInput[31] && !isLeftShift, shiftInput } >>> inputB[4:0]);
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
					default: aluValue <= 'b0;
		endcase
	end

	// Memory connections
	reg[3:0] loadStoreByteMask;
	reg loadSigned;
	wire shouldLoad  = |loadStoreByteMask && ((state == STATE_FETCH) || ((state == STATE_EXECUTE) && isLoad));
	wire shouldStore = |loadStoreByteMask && ((state == STATE_EXECUTE) && isStore);

	wire[31:0] loadData  = shouldLoad  ? memoryData : 32'b0;
	wire[31:0] storeData = shouldStore ? rs2 		: 32'b0;

	always @(*) begin
		case (state)
			STATE_FETCH: begin
				memoryAddress <= programCounter;
				loadStoreByteMask <= 4'b1111;
				loadSigned <= 1'b0;
			end
			STATE_EXECUTE: begin
				if (isLoad || isStore) memoryAddress <= aluAPlusB;
				else memoryAddress <= 32'b0;

				loadSigned <= (funct3 == 3'b100) || (funct3 == 3'b101);

				case (funct3)
					/*LBSB*/ 3'b000: loadStoreByteMask <= 4'b0001;
					/*LHSH*/ 3'b001: loadStoreByteMask <= 4'b0011;
					/*LWSW*/ 3'b010: loadStoreByteMask <= 4'b1111;
					//*None*/ 3'b011: loadStoreByteMask <= 4'b0000;
					/*LBU*/  3'b100: loadStoreByteMask <= 4'b0001;
					/*LHU*/  3'b101: loadStoreByteMask <= 4'b0011;
					//*None*/ 3'b110: loadStoreByteMask <= 4'b0000;
					//*None*/ 3'b111: loadStoreByteMask <= 4'b0000;
							default: loadStoreByteMask <= 4'b0000;
				endcase
			end
			default: memoryAddress <= 32'b0;
		endcase
	end

	assign loadEnableByteMask  = !shouldStore &&  shouldLoad ? loadStoreByteMask : 4'b0000;
	assign storeEnableByteMask =  shouldStore && !shouldLoad ? loadStoreByteMask : 4'b0000;
	assign memoryData 		   =  shouldStore && !shouldLoad ? storeData 		 : 32'bZ;

	// Register Write
	wire integerRegisterWriteEn = isLUI || isAUIPC || isJAL || isJALR || isALU || isALUImm || isLoad;
	wire[31:0] integerRegisterWriteData = isLUI 			  ? imm_U			   :
										  isAUIPC 			  ? aluAPlusB 		   :
										  isJAL 			  ? programCounterLink :
										  isJALR 			  ? programCounterLink :
										  isLoad 			  ? loadData		   :
										  (isALU || isALUImm) ? aluValue 		   :
																32'b0;

	always @(posedge clk) begin
		if (!nrst) begin
			programCounter <= 32'b0;
			state <= STATE_FETCH;
			currentError <= 'b0;
		end else begin
			case (state)
				STATE_FETCH: begin
					currentInstruction <= memoryData;
					state <= STATE_EXECUTE;
				end
				STATE_EXECUTE: begin
					if (integerRegisterWriteEn && |rdIndex) registers[rdIndex] = integerRegisterWriteData;

					programCounter <= { nextProgramCounter[31:1] , 0};
					state <= STATE_FETCH;
				end
				STATE_ERROR: begin
					currentError <= { 1'b0, 1'b0, addressMissaligned, invalidInstruction };
				end
				default: state <= STATE_FETCH;
			endcase
		end
	end

	assign probe_programCounter = programCounter;
	assign probe_state = state;
	assign probe_errorCode = currentError;
	assign probe_isBranch = isBranch;
	assign probe_takeBranch = takeBranch;

endmodule
