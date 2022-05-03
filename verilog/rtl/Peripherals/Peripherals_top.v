module Peripherals (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		// Wishbone Slave ports
		input wire wb_clk_i,
		input wire wb_rst_i,
		input wire wb_stb_i,
		input wire wb_cyc_i,
		input wire wb_we_i,
		input wire[3:0] wb_sel_i,
		input wire[31:0] wb_data_i,
		input wire[23:0] wb_adr_i,
		output wire wb_ack_o,
		output wire wb_stall_o,
		output wire[31:0] wb_data_o,

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
wire[3:0] peripheralBus_byteSelect;
reg[31:0] peripheralBus_dataRead;
wire[31:0] peripheralBus_dataWrite;

WBPeripheralBusInterface #(.ID(4'h3)) wbPeripheralBusInterface(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i),
	.wb_stb_i(wb_stb_i),
	.wb_cyc_i(wb_cyc_i),
	.wb_we_i(wb_we_i),
	.wb_sel_i(wb_sel_i),
	.wb_data_i(wb_data_i),
	.wb_adr_i(wb_adr_i),
	.wb_ack_o(wb_ack_o),
	.wb_stall_o(wb_stall_o),
	.wb_data_o(wb_data_o),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	.peripheralBus_dataRead(peripheralBus_dataRead),
	.peripheralBus_dataWrite(peripheralBus_dataWrite)
);

wire[31:0] uart_peripheralBus_dataRead;
wire uart_requestOutput;
wire[3:0] uart_en;	
wire[3:0] uart_rx;
wire[3:0] uart_tx;
UART #(.ID(8'h00)) uart(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(wb_clk_i),
    .rst(wb_rst_i),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	.peripheralBus_dataRead(uart_peripheralBus_dataRead),
	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	.requestOutput(uart_requestOutput),
	.uart_en(uart_en),
	.uart_rx(uart_rx),
	.uart_tx(uart_tx)
);

wire[31:0] spi_peripheralBus_dataRead;
wire spi_requestOutput;
wire[1:0] spi_en;
wire[1:0] spi_clk;
wire[1:0] spi_mosi;
wire[1:0] spi_miso;
wire[1:0] spi_cs;
SPI #(.ID(8'h01)) spi(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(wb_clk_i),
    .rst(wb_rst_i),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	.peripheralBus_dataRead(spi_peripheralBus_dataRead),
	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	.requestOutput(spi_requestOutput),
	.spi_en(spi_en),
	.spi_clk(spi_clk),
	.spi_mosi(spi_mosi),
	.spi_miso(spi_miso),
	.spi_cs(spi_cs)
);

wire[31:0] pwm_peripheralBus_dataRead;
wire pwm_requestOutput;
wire[15:0] pwm_en;
wire[15:0] pwm_out;
PWM #(.ID(8'h02)) pwm(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(wb_clk_i),
    .rst(wb_rst_i),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	.peripheralBus_dataRead(pwm_peripheralBus_dataRead),
	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	.requestOutput(pwm_requestOutput),
	.pwm_en(pwm_en),
	.pwm_out(pwm_out)
);

wire[31:0] gpio_peripheralBus_dataRead;
wire gpio_requestOutput;
wire[`MPRJ_IO_PADS_1-1:0] gpio0_input;
wire[`MPRJ_IO_PADS_1-1:0] gpio0_output;
wire[`MPRJ_IO_PADS_1-1:0] gpio0_oe;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_input;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_output;
wire[`MPRJ_IO_PADS_2-1:0] gpio1_oe;
GPIO #(.ID(8'h03)) gpio(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .clk(wb_clk_i),
    .rst(wb_rst_i),
	.peripheralBus_we(peripheralBus_we),
	.peripheralBus_oe(peripheralBus_oe),
	.peripheralBus_busy(peripheralBus_busy),
	.peripheralBus_address(peripheralBus_address),
	.peripheralBus_byteSelect(peripheralBus_byteSelect),
	.peripheralBus_dataRead(gpio_peripheralBus_dataRead),
	.peripheralBus_dataWrite(peripheralBus_dataWrite),
	.requestOutput(gpio_requestOutput),
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

    .clk(wb_clk_i),
    .rst(wb_rst_i),
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

always @(*) begin
	case (1'b1)
		uart_requestOutput: peripheralBus_dataRead <= uart_peripheralBus_dataRead;
		spi_requestOutput:  peripheralBus_dataRead <= spi_peripheralBus_dataRead;
		pwm_requestOutput:  peripheralBus_dataRead <= pwm_peripheralBus_dataRead;
		gpio_requestOutput: peripheralBus_dataRead <= gpio_peripheralBus_dataRead;
		default: 			peripheralBus_dataRead <= 'b0;
	endcase
end

endmodule