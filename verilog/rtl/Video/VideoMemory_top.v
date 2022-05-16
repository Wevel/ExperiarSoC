module VideoMemory (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire clk,
		input wire rst,

		// Peripheral bus interface
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[23:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		input wire[31:0] peripheralBus_dataWrite,
		output wire[31:0] peripheralBus_dataRead,
		output wire requestOutput,

		// Video interface
		input wire video_clk,
		input wire[SRAM_ADDRESS_SIZE+2:0] video_address,
		output wire[31:0] video_data,

		// Video SRAM rw port
		output wire sram_clk0,
		output wire sram0_csb0,
		output wire sram1_csb0,
		output wire sram_web0,
		output wire[3:0] sram_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0,
		output wire[31:0] sram_din0,
		input wire[31:0] sram0_dout0,
		input wire[31:0] sram1_dout0,

		// Video SRAM r port
		output wire sram_clk1,
		output wire sram0_csb1,
		output wire sram1_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1,
		input wire[31:0] sram0_dout1,
		input wire[31:0] sram1_dout1
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	wire peripheralBusEnableSRAM0 = !peripheralBus_address[SRAM_ADDRESS_SIZE+2] && (peripheralBus_we || peripheralBus_oe);
	wire peripheralBusEnableSRAM1 =  peripheralBus_address[SRAM_ADDRESS_SIZE+2] && (peripheralBus_we || peripheralBus_oe);

	assign sram_clk0 	= clk;
	assign sram0_csb0 	= !peripheralBusEnableSRAM0;
	assign sram1_csb0 	= !peripheralBusEnableSRAM1;
	assign sram_web0 	= peripheralBus_we;
	assign sram_wmask0 	= peripheralBus_byteSelect;
	assign sram_addr0 	= peripheralBus_address[SRAM_ADDRESS_SIZE+1:2];
	assign sram_din0 	= peripheralBus_dataWrite;
	assign peripheralBus_dataRead = peripheralBusEnableSRAM1 ? sram1_dout0 : sram0_dout0;
	assign peripheralBus_busy = 1'b0;
	assign requestOutput = peripheralBus_oe;

	wire videoEnableSRAM0 = !video_address[SRAM_ADDRESS_SIZE+2];
	wire videoEnableSRAM1 =  video_address[SRAM_ADDRESS_SIZE+2];

	assign sram_clk1 	= video_clk;
	assign sram0_csb1 	= !videoEnableSRAM0;
	assign sram1_csb1 	= !videoEnableSRAM1;
	assign sram_addr1 	= video_address[SRAM_ADDRESS_SIZE+1:2];
	assign video_data = videoEnableSRAM1 ? sram1_dout1 : sram0_dout1;
	
endmodule