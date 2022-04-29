module GPIO #(
		parameter ID = 8'h03
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

		input wire[`MPRJ_IO_PADS_1-1:0] gpio0_input,
		output wire[`MPRJ_IO_PADS_1-1:0] gpio0_output,
		output wire[`MPRJ_IO_PADS_1-1:0] gpio0_oe,
		input wire[`MPRJ_IO_PADS_2-1:0] gpio1_input,
		output wire[`MPRJ_IO_PADS_2-1:0] gpio1_output,
		output wire[`MPRJ_IO_PADS_2-1:0] gpio1_oe
	);
	
endmodule