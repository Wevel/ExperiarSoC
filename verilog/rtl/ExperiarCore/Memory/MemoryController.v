module MemoryController (
		// Core interface
		input wire[31:0] coreAddress,
		input wire[3:0] coreByteSelect,
		input wire coreWriteEnable,
		input wire coreReadEnable,
		input wire[31:0] coreDataWrite,
		output wire[31:0] coreDataRead,
		output wire coreBusy,
		
		// Local memory interface
		output wire[23:0] localMemoryAddress,
		output wire[3:0] localMemoryByteSelect,
		output wire localMemoryWriteEnable,
		output wire localMemoryReadEnable,
		output wire[31:0] localMemoryDataWrite,
		input wire[31:0] localMemoryDataRead,
		input wire localMemoryBusy,

		// WB interface
		output wire[27:0] wbAddress,
		output wire[3:0] wbByteSelect,
		output wire wbWriteEnable,
		output wire wbReadEnable,
		output wire[31:0] wbDataWrite,
		input wire[31:0] wbDataRead,
		input wire wbBusy
	);
	
	localparam LOCAL_MEMORY_ADDRESS = 4'b0000;
	localparam WB_ADDRESS 		    = 4'b0001;

	wire enableLocalMemory = coreAddress[31:24] == { LOCAL_MEMORY_ADDRESS, 4'b0000 };
	wire enableWB 		   = coreAddress[31:28] == WB_ADDRESS;

	assign localMemoryAddress 	  = enableLocalMemory ? coreAddress[23:0] : 26'b0;
	assign localMemoryByteSelect  = enableLocalMemory ? coreByteSelect 	  : 4'b0;
	assign localMemoryWriteEnable = enableLocalMemory ? coreWriteEnable   : 1'b0;
	assign localMemoryReadEnable  = enableLocalMemory ? coreReadEnable    : 1'b0;
	assign localMemoryDataWrite   = enableLocalMemory ? coreDataWrite 	  : 32'b0;

	assign wbAddress 	 = enableWB ? coreAddress[27:0] : 26'b0;
	assign wbByteSelect  = enableWB ? coreByteSelect 	: 4'b0;
	assign wbWriteEnable = enableWB ? coreWriteEnable   : 1'b0;
	assign wbReadEnable  = enableWB ? coreReadEnable    : 1'b0;
	assign wbDataWrite 	 = enableWB ? coreDataWrite	    : 32'b0;

	assign coreDataRead = enableLocalMemory ? localMemoryDataRead :
						  enableWB 	 		? wbDataRead 		  : 
						  			   		  ~32'b0;

	assign coreBusy = enableLocalMemory ? localMemoryBusy :
					  enableWB		    ? wbBusy 		  : 
							   			  1'b0;

endmodule