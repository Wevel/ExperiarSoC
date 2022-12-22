module MemoryController (
		input wire clk,
		input wire rst,

		// Instruction cache interface
		input wire[31:0] coreInstructionAddress,
		input wire coreInstructionEnable,
		output reg[31:0] coreInstructionDataRead,
		output reg coreInstructionBusy,

		// Data cache interface
		input wire[31:0] coreDataAddress,
		input wire[3:0] coreDataByteSelect,
		input wire coreDataEnable,
		input wire coreDataWriteEnable,
		input wire[31:0] coreDataDataWrite,
		output reg[31:0] coreDataDataRead,
		output reg coreDataBusy,

		// Local memory interface
		output reg[23:0] localMemoryAddress,
		output reg[3:0] localMemoryByteSelect,
		output reg localMemoryEnable,
		output reg localMemoryWriteEnable,
		output reg[31:0] localMemoryDataWrite,
		input wire[31:0] localMemoryDataRead,
		input wire localMemoryBusy,

		// WB interface
		output reg[27:0] wbAddress,
		output reg[3:0] wbByteSelect,
		output reg wbEnable,
		output reg wbWriteEnable,
		output reg[31:0] wbDataWrite,
		input wire[31:0] wbDataRead,
		input wire wbBusy
	);
	
	localparam LOCAL_MEMORY_ADDRESS = 4'b0000;
	localparam WB_ADDRESS 		    = 4'b0001;

	wire instruction_enableLocalMemory = coreInstructionAddress[31:24] == { LOCAL_MEMORY_ADDRESS, 4'b0000 };
	wire data_enableLocalMemory 	   = coreDataAddress[31:24] == { LOCAL_MEMORY_ADDRESS, 4'b0000 };
	wire instruction_enableWB 		   = coreInstructionAddress[31:28] == WB_ADDRESS;
	wire data_enableWB 		  		   = coreDataAddress[31:28] == WB_ADDRESS;

	reg last_instruction_enableLocalMemory;
	reg last_data_enableLocalMemory;
	reg last_instruction_enableWB;
	reg last_data_enableWB;

	always @(posedge clk) begin
		if (rst) begin
			last_instruction_enableLocalMemory <= 1'b0;
			last_data_enableLocalMemory <= 1'b0;
			last_instruction_enableWB <= 1'b0;
			last_data_enableWB <= 1'b0;
		end else begin
			last_instruction_enableLocalMemory <= instruction_enableLocalMemory;
			last_data_enableLocalMemory <= data_enableLocalMemory;
			last_instruction_enableWB <= instruction_enableWB;
			last_data_enableWB <= data_enableWB;
		end
	end

	always @(*) begin
		case (1'b1)
			instruction_enableLocalMemory: begin
				localMemoryAddress 	   <= coreInstructionAddress[23:0];
				localMemoryByteSelect  <= 4'b1111;
				localMemoryEnable  	   <= coreInstructionEnable;
				localMemoryWriteEnable <= 1'b0;
				localMemoryDataWrite   <= 32'b0;
			end

			data_enableLocalMemory: begin
				localMemoryAddress 	   <= coreDataAddress[23:0];
				localMemoryByteSelect  <= coreDataByteSelect;
				localMemoryEnable  	   <= coreDataEnable;
				localMemoryWriteEnable <= coreDataWriteEnable;
				localMemoryDataWrite   <= coreDataDataWrite;
			end

			default: begin
				localMemoryAddress 	   <= 24'b0;
				localMemoryByteSelect  <=  4'b0;
				localMemoryEnable  	   <=  1'b0;
				localMemoryWriteEnable <=  1'b0;
				localMemoryDataWrite   <= 32'b0;
			end
		endcase
	end

	always @(*) begin
		case (1'b1)
			instruction_enableWB: begin
				wbAddress 	  <= coreInstructionAddress[27:0];
				wbByteSelect  <= 4'b1111;
				wbEnable  	  <= coreInstructionEnable;
				wbWriteEnable <= 1'b0;
				wbDataWrite   <= 32'b0;
			end

			data_enableWB: begin
				wbAddress 	  <= coreDataAddress[27:0];
				wbByteSelect  <= coreDataByteSelect;
				wbEnable  	  <= coreDataEnable;
				wbWriteEnable <= coreDataWriteEnable;
				wbDataWrite   <= coreDataDataWrite;
			end

			default: begin
				wbAddress 	  <= 28'b0;
				wbByteSelect  <=  4'b0;
				wbEnable  	  <=  1'b0;
				wbWriteEnable <=  1'b0;
				wbDataWrite   <= 32'b0;
			end
		endcase
	end

	always @(*) begin
		case (1'b1)
			last_instruction_enableLocalMemory: begin
				coreInstructionDataRead <= localMemoryDataRead;
				coreInstructionBusy 	<= localMemoryBusy;
			end
			
			last_instruction_enableWB: begin
				coreInstructionDataRead <= wbDataRead;
				coreInstructionBusy 	<= wbBusy;
			end

			default: begin
				coreInstructionDataRead <= ~32'b0;
				coreInstructionBusy 	<= 1'b0;
			end
		endcase
	end

	always @(*) begin
		case (1'b1)
			last_data_enableLocalMemory: begin
				coreDataDataRead <= localMemoryDataRead;
				coreDataBusy 	 <= localMemoryBusy || last_instruction_enableLocalMemory;
			end
			
			last_data_enableWB: begin
				coreDataDataRead <= wbDataRead;
				coreDataBusy  	 <= wbBusy || last_instruction_enableWB;
			end

			default: begin
				coreDataDataRead <= ~32'b0;
				coreDataBusy 	 <= 1'b0;
			end
		endcase
	end

endmodule