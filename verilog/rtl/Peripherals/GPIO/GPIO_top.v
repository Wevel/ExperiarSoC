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
		input wire[3:0] peripheralBus_byteSelect,
		output wire[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,

		input wire[`MPRJ_IO_PADS_1-1:0] gpio0_input,
		output wire[`MPRJ_IO_PADS_1-1:0] gpio0_output,
		output wire[`MPRJ_IO_PADS_1-1:0] gpio0_oe,
		input wire[`MPRJ_IO_PADS_2-1:0] gpio1_input,
		output wire[`MPRJ_IO_PADS_2-1:0] gpio1_output,
		output wire[`MPRJ_IO_PADS_2-1:0] gpio1_oe
	);
	
	// Peripheral select
	wire[15:0] localAddress;
	wire peripheralEnable;
	PeripheralSelect #(.ID(ID)) select(
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.peripheralEnable(peripheralEnable));

	wire[31:0] device0OutputData;
	wire device0OutputRequest;
	GPIODevice #(.ID(4'h1), .IO_COUNT(`MPRJ_IO_PADS_1)) device0(
		.clk(clk),
		.rst(rst),
		.peripheralEnable(peripheralEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(device0OutputData),
		.requestOutput(device0OutputRequest),
		.gpio_input(gpio0_input),
		.gpio_output(gpio0_output),
		.gpio_oe(gpio0_oe));

	wire[31:0] device1OutputData;
	wire device1OutputRequest;
	GPIODevice #(.ID(4'h2), .IO_COUNT(`MPRJ_IO_PADS_2)) device1(
		.clk(clk),
		.rst(rst),
		.peripheralEnable(peripheralEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(device1OutputData),
		.requestOutput(device1OutputRequest),
		.gpio_input(gpio1_input),
		.gpio_output(gpio1_output),
		.gpio_oe(gpio1_oe));

	assign requestOutput = device1OutputRequest || device1OutputRequest;
	assign peripheralBus_dataRead = device0OutputRequest ? device0OutputData :
								    device1OutputRequest ? device1OutputData :
													       32'b0;
	assign peripheralBus_busy = 1'b0;

endmodule