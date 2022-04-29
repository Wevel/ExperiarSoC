module WBPeripheralBusInterface #(
		parameter ID = 4'h1
	)(
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		// Wishbone Slave ports
		input wire wb_clk,
		input wire wb_rst,
		input wire wb_stb,
		input wire wb_cyc,
		input wire wb_we,
		input wire[3:0] wb_sel,
		input wire[31:0] wb_dataIn,
		input wire[31:0] wb_address,
		output wire wb_ack,
		output wire[31:0] wb_dataOut,

		// Peripheral Bus
		output wire peripheralBus_we,
		output wire peripheralBus_oe,
		input wire peripheralBus_busy,
		output wire[23:0] peripheralBus_address,
		inout wire[31:0] peripheralBus_data
	);
	
endmodule