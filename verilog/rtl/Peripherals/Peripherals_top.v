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
		output wire wb_error_o,
		output wire[31:0] wb_data_o,

		// IOs
		input  wire[`MPRJ_IO_PADS-1:0] io_in,
		output wire[`MPRJ_IO_PADS-1:0] io_out,
		output wire[`MPRJ_IO_PADS-1:0] io_oeb,

		// Caravel UART
		input wire internal_uart_rx,
		output wire internal_uart_tx,

		// JTAG
		output wire jtag_tck,
		output wire jtag_tms,
		output wire jtag_tdi,
		input wire jtag_tdo,

		// Flash
		input wire flash_csb,
		input wire flash_sck,
		input wire flash_io0_we,
		input wire flash_io0_write,
		output wire flash_io0_read,
		input wire flash_io1_we,
		input wire flash_io1_write,
		output wire flash_io1_read,

		// IRQ
		// input wire irq_en,
		// output wire irq_in,
		output wire[9:0] peripheral_irq,

		// VGA
		input wire[1:0] vga_r,
		input wire[1:0] vga_g,
		input wire[1:0] vga_b,
		input wire vga_vsync,
		input wire vga_hsync,

		// Logic Analyzer Signals
		output wire[1:0] probe_blink
	);

	wire irq_en = 1'b0;
	wire irq_in;

	wire peripheralBus_we;
	wire peripheralBus_oe;
	wire peripheralBus_busy;
	wire[23:0] peripheralBus_address;
	wire[3:0] peripheralBus_byteSelect;
	reg[31:0] peripheralBus_dataRead;
	wire[31:0] peripheralBus_dataWrite;

	WBPeripheralBusInterface wbPeripheralBusInterface(
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
		.wb_error_o(wb_error_o),
		.wb_data_o(wb_data_o),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(peripheralBus_busy),
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataRead(peripheralBus_dataRead),
		.peripheralBus_dataWrite(peripheralBus_dataWrite));

	wire[31:0] uart_peripheralBus_dataRead;
	wire uart_requestOutput;
	wire[3:0] uart_en;	
	wire[3:0] uart_rx;
	wire[3:0] uart_tx;
	wire[3:0] uart_irq;
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
		.uart_tx(uart_tx),
		.uart_irq(uart_irq));

	assign uart_rx[0] = internal_uart_rx;
	assign internal_uart_tx = uart_tx[0];

	wire[31:0] spi_peripheralBus_dataRead;
	wire spi_requestOutput;
	wire[0:0] spi_en;
	wire[0:0] spi_clk;
	wire[0:0] spi_mosi;
	wire[0:0] spi_miso;
	wire[0:0] spi_cs;
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
		.spi_cs(spi_cs));

	wire[31:0] pwm_peripheralBus_dataRead;
	wire pwm_requestOutput;
	wire[15:0] pwm_en;
	wire[15:0] pwm_out;
	wire[3:0] pwm_irq;
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
		.pwm_out(pwm_out),
		.pwm_irq(pwm_irq));

	wire[31:0] gpio_peripheralBus_dataRead;
	wire gpio_requestOutput;
	wire[`MPRJ_IO_PADS-1:0] gpio_input;
	wire[`MPRJ_IO_PADS-1:0] gpio_output;
	wire[`MPRJ_IO_PADS-1:0] gpio_oe;
	wire[1:0] gpio_irq;
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
		.gpio_input(gpio_input),
		.gpio_output(gpio_output),
		.gpio_oe(gpio_oe),
		.gpio_irq(gpio_irq));

	IOMultiplexer ioMux(
	`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
	`endif
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.uart_en(uart_en[3:1]),
		.uart_rx(uart_rx[3:1]),
		.uart_tx(uart_tx[3:1]),
		.spi_en(spi_en),
		.spi_clk(spi_clk),
		.spi_mosi(spi_mosi),
		.spi_miso(spi_miso),
		.spi_cs(spi_cs),
		.pwm_en(pwm_en[7:0]),
		.pwm_out(pwm_out[7:0]),
		.gpio_input(gpio_input),
		.gpio_output(gpio_output),
		.gpio_oe(gpio_oe),
		.io_in(io_in),
		.io_out(io_out),
		.io_oeb(io_oeb),
		.jtag_tck(jtag_tck),
		.jtag_tms(jtag_tms),
		.jtag_tdi(jtag_tdi),
		.jtag_tdo(jtag_tdo),
		.flash_csb(flash_csb),
		.flash_sck(flash_sck),
		.flash_io0_we(flash_io0_we),
		.flash_io0_write(flash_io0_write),
		.flash_io0_read(flash_io0_read),
		.flash_io1_we(flash_io1_we),
		.flash_io1_write(flash_io1_write),
		.flash_io1_read(flash_io1_read),
		.irq_en(irq_en),
		.irq_in(irq_in),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync),
		.probe_blink(probe_blink));

	always @(*) begin
		case (1'b1)
			uart_requestOutput: peripheralBus_dataRead <= uart_peripheralBus_dataRead;
			spi_requestOutput:  peripheralBus_dataRead <= spi_peripheralBus_dataRead;
			pwm_requestOutput:  peripheralBus_dataRead <= pwm_peripheralBus_dataRead;
			gpio_requestOutput: peripheralBus_dataRead <= gpio_peripheralBus_dataRead;
			default: 			peripheralBus_dataRead <= ~32'b0;
		endcase
	end

	assign peripheral_irq = { pwm_irq, uart_irq, gpio_irq };

endmodule