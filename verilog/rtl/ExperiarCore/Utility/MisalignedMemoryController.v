module MisalignedMemoryController (
		input wire clk,
		input wire rst,

		// External memory interface
		output wire[31:0] external_memoryAddress,
		output wire[3:0] external_memoryByteSelect,
		output wire external_memoryWriteEnable,
		output wire external_memoryReadEnable,
		output wire[31:0] external_memoryDataWrite,
		input wire[31:0] external_memoryDataRead,
		input wire external_memoryBusy,
		input wire external_memoryAccessFault,
		input wire external_addressBreakpoint,
		
		// Internal memory interface
		output wire[31:0] internal_memoryAddress,
		output wire[3:0] internal_memoryByteSelect,
		output wire internal_memoryWriteEnable,
		output wire internal_memoryReadEnable,
		output wire[31:0] internal_memoryDataWrite,
		input wire[31:0] internal_memoryDataRead,
		input wire internal_memoryBusy,
		input wire internal_memoryAccessFault,
		input wire internal_addressBreakpoint
	);
	


endmodule