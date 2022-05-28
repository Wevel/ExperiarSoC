module LocalMemoryInterface #(
		parameter SRAM_ADDRESS_SIZE = 9
	)(
		input wire clk,
		input wire rst,

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

	// Core enable pins
	wire coreSRAMEnable = coreAddress[23:SRAM_ADDRESS_SIZE+3] == 'b0 && (coreWriteEnable || coreReadEnable);
	wire coreSRAMWriteEnable = coreSRAMEnable && coreWriteEnable && !coreReadEnable;
	wire coreSRAMReadEnable = coreSRAMEnable && !coreSRAMWriteEnable;

	// Wishbone enable pins
	wire wbSRAMEnable = wbAddress[23:SRAM_ADDRESS_SIZE+3] == 'b0 && (wbWriteEnable || wbReadEnable);
	wire wbSRAMWriteEnable = wbSRAMEnable && wbWriteEnable && !wbReadEnable;
	wire wbSRAMReadEnable = wbSRAMEnable && !wbSRAMWriteEnable;

	// Generate SRAM control signals
	// Core can always read from read only port
	// Core can always write to read/write port
	// Wishbone can read/write to read/write port, but only if core is not writing to it
	wire[31:0] rwPortReadData;
	wire[31:0] rPortReadData;

	// Busy signals
	reg coreReadReady = 1'b0;
	always @(posedge clk) begin
		if (rst) coreReadReady <= 1'b0;
		else if (coreSRAMReadEnable) coreReadReady <= 1'b1;
		else coreReadReady <= 1'b0;
	end

	reg wbReadReady = 1'b0;
	always @(posedge clk) begin
		if (rst) wbReadReady <= 1'b0;
		else if (wbSRAMReadEnable) wbReadReady <= 1'b1;
		else wbReadReady <= 1'b0;
	end

	assign coreBusy = coreSRAMReadEnable && !coreReadReady;
	assign wbBusy = (wbSRAMEnable && coreSRAMWriteEnable) || (wbSRAMReadEnable && !wbReadReady);

	// Read/Write port
	wire rwPortEnable = coreSRAMWriteEnable || wbSRAMWriteEnable || (wbSRAMReadEnable && !wbReadReady);
	wire rwWriteEnable = coreSRAMWriteEnable || (!coreSRAMWriteEnable && wbSRAMWriteEnable);
	wire[SRAM_ADDRESS_SIZE:0] rwAddress = coreSRAMWriteEnable ? coreAddress[SRAM_ADDRESS_SIZE+2:2] :
				   						  wbSRAMEnable        ?   wbAddress[SRAM_ADDRESS_SIZE+2:2] : 'b0;
	wire rwBankSelect = rwAddress[SRAM_ADDRESS_SIZE];

	assign wbDataRead = {
		wbByteSelect[3] && wbReadReady ? rwPortReadData[31:24] : ~8'h00,
		wbByteSelect[2] && wbReadReady ? rwPortReadData[23:16] : ~8'h00,
		wbByteSelect[1] && wbReadReady ? rwPortReadData[15:8]  : ~8'h00,
		wbByteSelect[0] && wbReadReady ? rwPortReadData[7:0]   : ~8'h00
	};

	// Read port
	wire rPortEnable = coreSRAMReadEnable && !coreReadReady;
	wire[SRAM_ADDRESS_SIZE:0] rAddress = coreAddress[SRAM_ADDRESS_SIZE+2:2];
	wire rBankSelect = rAddress[SRAM_ADDRESS_SIZE];

	assign coreDataRead = {
		coreByteSelect[3] && coreReadReady ? rPortReadData[31:24] : ~8'h00,
		coreByteSelect[2] && coreReadReady ? rPortReadData[23:16] : ~8'h00,
		coreByteSelect[1] && coreReadReady ? rPortReadData[15:8]  : ~8'h00,
		coreByteSelect[0] && coreReadReady ? rPortReadData[7:0]   : ~8'h00
	};

	// SRAM connections
	assign clk0 = clk;
	assign csb0 = { !(rwPortEnable && rwBankSelect), !(rwPortEnable && !rwBankSelect) };
	assign web0 = !rwWriteEnable;
	assign wmask0 = coreSRAMWriteEnable ? coreByteSelect : 
					wbSRAMWriteEnable   ? wbByteSelect   : 4'b0;
	assign addr0 = rwAddress[SRAM_ADDRESS_SIZE-1:0];
	assign din0 = coreSRAMWriteEnable ? coreDataWrite : 
				  wbSRAMWriteEnable   ? wbDataWrite   : 32'b0;
	assign rwPortReadData = rwBankSelect ? dout0[63:32] : dout0[31:0];

	assign clk1 = clk;
	assign csb1 = { !(rPortEnable && rBankSelect), !(rPortEnable && !rBankSelect) };
	assign addr1 = rAddress[SRAM_ADDRESS_SIZE-1:0];
	assign rPortReadData = rBankSelect ? dout1[63:32] : dout1[31:0];

endmodule