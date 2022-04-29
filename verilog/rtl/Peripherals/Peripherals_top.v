module Peripherals (
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

		// IOs
		input  [`MPRJ_IO_PADS-1:0] io_in,
		output [`MPRJ_IO_PADS-1:0] io_out,
		output [`MPRJ_IO_PADS-1:0] io_oeb,

		// Logic Analyzer Signals
		output wire[1:0] la_blink
	);

wire peripheralBus_we;
wire peripheralBus_oe;
wire peripheralBus_busy;
wire[23:0] peripheralBus_address;
wire[31:0] peripheralBus_data;
WBPeripheralBusInterface wbPeripheralBusInterface #(
	.ID(4'h3)
)(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.wb_clk(wb_clk),
	.wb_rst(wb_rst),
	.wb_stb(wb_stb),
	.wb_cyc(wb_cyc),
	.wb_we(wb_we),
	.wb_sel(wb_sel),
	.wb_dataIn(wb_dataIn),
	.wb_address(wb_address),
	.wb_ack(wb_ack),
	.wb_dataOut(wb_dataOut),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_data(peripheralBus_data),
);

wire[3:0] uart_en;	
wire[3:0] uart_rx;
wire[3:0] uart_tx;
UART uart #(
	.ID(8'h00)
)(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_data(peripheralBus_data),
	.uart_en(uart_en),
	.uart_rx(uart_rx),
	.uart_tx(uart_tx)
);

wire[1:0] spi_en;
wire[1:0] spi_clk;
wire[1:0] spi_mosi;
wire[1:0] spi_miso;
wire[1:0] spi_cs;
SPI spi #(
	.ID(8'h01)
)(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_data(peripheralBus_data),
	.spi_en(spi_en),
	.spi_clk(spi_clk),
	.spi_mosi(spi_mosi),
	.spi_miso(spi_miso),
	.spi_cs(spi_cs)
);

wire[15:0] pwm_en;
wire[15:0] pwm_out;
PWM pwm #(
	.ID(8'h02)
)(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_data(peripheralBus_data),
	.pwm_out(pwm_en),
	.pwm_out(pwm_out)
);

wire[`MPRJ_IO_PADS_1-1:0] gpio0_input;
wire[`MPRJ_IO_PADS_1-1:0] gpio0_output;
wire[`MPRJ_IO_PADS_1-1:0] gpio0_oe;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_input;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_output;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_oe;
GPIO gpio #(
	.ID(8'h03)
)(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_data(peripheralBus_data),
	.gpio0_input(gpio0_input),
	.gpio0_output(gpio0_output),
	.gpio0_oe(gpio0_oe),
	.gpio1_input(gpio1_input),
	.gpio1_output(gpio1_output),
	.gpio1_oe(gpio1_oe)
);

IOMultiplexer ioMux(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(clk),
    .rst(rst),
	.uart_en(uart_en),
	.uart_rx(uart_rx),
	.uart_tx(uart_tx),
	.spi_en(spi_en),
	.spi_clk(spi_clk),
	.spi_mosi(spi_mosi),
	.spi_miso(spi_miso),
	.spi_cs(spi_cs),
	.pwm_en(pwm_en),
	.pwm_out(pwm_out),
	.gpio0_input(gpio0_input),
	.gpio0_output(gpio0_output),
	.gpio0_oe(gpio0_oe),
	.gpio1_input(gpio1_input),
	.gpio1_output(gpio1_output),
	.gpio1_oe(gpio1_oe),
    .io_in(io_in),
    .io_out(io_out),
    .io_oeb(io_oeb),
	.la_blink(la_blink)
);

endmodule