module Flash (
	`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire clk,
		input wire rst,

		// Flash QSPI
		output wire flash_csb,
		output wire flash_sck,
		output wire flash_io0_we,
		output wire flash_io0_write,
		input wire flash_io0_read,
		output wire flash_io1_we,
		output wire flash_io1_write,
		input wire flash_io1_read,

		// Core 0 interface
		input wire[27:0] core0Address,
		input wire[3:0] core0ByteSelect,
		input wire core0WriteEnable,
		input wire core0ReadEnable,
		input wire[31:0] core0DataWrite,
		output wire[31:0] core0DataRead,
		output wire core0Busy,

		// Core 1 interface
		input wire[27:0] core1Address,
		input wire[3:0] core1ByteSelect,
		input wire core1WriteEnable,
		input wire core1ReadEnable,
		input wire[31:0] core1DataWrite,
		output wire[31:0] core1DataRead,
		output wire core1Busy
	);

	assign flash_csb = 1'b0;
	assign flash_sck = 1'b0;
	assign flash_io0_we = 1'b0;
	assign flash_io0_write = 1'b0;
	//flash_io0_read
	assign flash_io1_we = 1'b0;
	assign flash_io1_write = 1'b0;
	//flash_io1_read
	
endmodule