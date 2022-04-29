module UART #(
		parameter ID = 8'h00
	)(
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,
		
		// Peripheral Bus
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[23:0] peripheralBus_address,
		inout wire[31:0] peripheralBus_data,

		output wire[3:0] uart_en,	
		output wire[3:0] uart_rx,
		output wire[3:0] uart_tx
	);

endmodule