module LocalMemoryInterface #(
		parameter SRAM_ADDRESS_SIZE = 9
	)(
		input wire clk,

		// Core interface
		input wire[23:0] coreAddress,
		input wire[3:0] coreByteSelect,
		input wire coreWriteEnable,
		input wire coreReadEnable,
		input wire[31:0] coreDataWrite,
		output wire[31:0] coreDataRead,
		output wire coreBusy,

		// WB interface
		input wire[23:0] wbAddress,
		input wire[3:0] wbByteSelect,
		input wire wbWriteEnable,
		input wire wbReadEnable,
		input wire[31:0] wbDataWrite,
		output wire[31:0] wbDataRead,
		output wire wbWriteBusy,

		// Flash interface
		output wire[27:0] flashAddress,
		output wire[3:0] flashByteSelect,
		output wire flashWriteEnable,
		output wire flashReadEnable,
		output wire[31:0] flashDataWrite,
		input wire[31:0] flashDataRead,
		input wire flashBusy,

		// SRAM rw port
		output wire clk0, // Port clock
		output wire csb0, // active low chip select
		output wire web0, // active low write control
		output wire[3:0] wmask0, // write mask
		output wire[SRAM_ADDRESS_SIZE-1:0] addr0,
		output wire[31:0] din0,
		input  wire[31:0] dout0,

		// SRAM r port
		output wire clk1,
		output wire csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] addr1,
		input  wire[31:0] dout1
	);
	
	localparam SRAM_ADDRESS = 4'b0000;

	wire coreSRAMEnable = coreAddress[23:20] == SRAM_ADDRESS && coreAddress[19:SRAM_ADDRESS_SIZE+2] == 'b0 && (coreWriteEnable || coreReadEnable);
	wire coreSRAMWriteEnable = coreSRAMEnable && coreWriteEnable && !coreReadEnable;

	wire wbSRAMEnable = wbAddress[23:20] == SRAM_ADDRESS && wbAddress[19:SRAM_ADDRESS_SIZE+2] == 'b0 && (wbWriteEnable || wbReadEnable);
	wire wbSRAMWriteEnable = wbSRAMEnable && wbWriteEnable && !wbReadEnable;

	wire rwPortEnable = coreSRAMEnable || wbSRAMWriteEnable; // Core can perform reads and writes, but only writes are valid from wb
	wire rwWriteEnable = coreSRAMWriteEnable || (!coreSRAMEnable && wbSRAMWriteEnable);

	assign clk0 = clk;
	assign csb0 = !rwPortEnable;
	assign web0 = !rwWriteEnable;
	assign wmask0 = coreSRAMEnable 	  ? coreByteSelect :
					wbSRAMWriteEnable ? wbByteSelect   :
										4'b0;
	assign addr0 = coreSRAMEnable 	 ? coreAddress[SRAM_ADDRESS_SIZE+1:2] :
				   wbSRAMWriteEnable ? wbAddress[SRAM_ADDRESS_SIZE+1:2]   :
				   					   'b0;
	assign din0 = coreSRAMWriteEnable ? coreDataWrite : 
				  wbSRAMWriteEnable   ? wbDataWrite   :
				  						32'b0;
	assign coreDataRead = dout0;

	assign clk1 = clk;
	assign csb1 = !(wbSRAMEnable && !wbSRAMWriteEnable);
	assign addr1 = wbAddress[SRAM_ADDRESS_SIZE+1:2];
	assign wbDataRead = dout1;

	assign wbWriteBusy = wbSRAMEnable && wbSRAMWriteEnable;

endmodule