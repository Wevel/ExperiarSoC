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
		output wire wbBusy,

		// Flash interface
		output wire[22:0] flashAddress,
		output wire[3:0] flashByteSelect,
		output wire flashWriteEnable,
		output wire flashReadEnable,
		output wire[31:0] flashDataWrite,
		input wire[31:0] flashDataRead,
		input wire flashBusy,

		// SRAM rw port
		output wire clk0, // Port clock
		output wire[1:0] csb0, // active low chip select
		output wire web0, // active low write control
		output wire[3:0] wmask0, // write mask
		output wire[SRAM_ADDRESS_SIZE-1:0] addr0,
		output wire[31:0] din0,
		input  wire[63:0] dout0,

		// SRAM r port
		output wire clk1,
		output wire[1:0] csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] addr1,
		input  wire[63:0] dout1
	);
	
	assign coreBusy = 1'b0;

	// SRAM
	wire coreSRAMEnable = coreAddress[23:SRAM_ADDRESS_SIZE+3] == 'b0 && (coreWriteEnable || coreReadEnable);
	wire coreSRAMWriteEnable = coreSRAMEnable && coreWriteEnable && !coreReadEnable;

	wire wbSRAMEnable = wbAddress[23:SRAM_ADDRESS_SIZE+3] == 'b0 && (wbWriteEnable || wbReadEnable);
	wire wbSRAMWriteEnable = wbSRAMEnable && wbWriteEnable && !wbReadEnable;

	wire rwPortEnable = coreSRAMEnable || wbSRAMWriteEnable; // Core can perform reads and writes, but only writes are valid from wb
	wire rwWriteEnable = coreSRAMWriteEnable || (!coreSRAMEnable && wbSRAMWriteEnable);
	wire[SRAM_ADDRESS_SIZE+2:0] rwAddress = coreSRAMEnable 	  ? coreAddress[SRAM_ADDRESS_SIZE+2:2] :
				   							wbSRAMWriteEnable ?   wbAddress[SRAM_ADDRESS_SIZE+2:2] : 'b0;
	wire rwBankSelect = rwAddress[SRAM_ADDRESS_SIZE+2];

	wire rPortEnable = wbSRAMEnable && !wbSRAMWriteEnable;
	wire[SRAM_ADDRESS_SIZE+2:0] rAddress = wbAddress[SRAM_ADDRESS_SIZE+2:2];
	wire rBankSelect = rAddress[SRAM_ADDRESS_SIZE+2];


	assign clk0 = clk;
	assign csb0 = { !(rwPortEnable && rwBankSelect), !(rwPortEnable && !rwBankSelect) };
	assign web0 = !rwWriteEnable;
	assign wmask0 = coreSRAMEnable 	  ? coreByteSelect :
					wbSRAMWriteEnable ? wbByteSelect   : 4'b0;
	assign addr0 = rwAddress[SRAM_ADDRESS_SIZE+1:2];
	assign din0 = coreSRAMWriteEnable ? coreDataWrite : 
				  wbSRAMWriteEnable   ? wbDataWrite   : 32'b0;
	assign coreDataRead = rwBankSelect ? dout0[63:32] : dout0[31:0];

	assign clk1 = clk;
	assign csb1 = { !(rPortEnable && rBankSelect), !(rPortEnable && !rBankSelect) };
	assign addr1 = rAddress[SRAM_ADDRESS_SIZE+1:2];
	assign wbDataRead = rBankSelect ? dout1[63:32] : dout1[31:0];

	assign wbBusy = wbSRAMEnable && wbSRAMWriteEnable;

endmodule