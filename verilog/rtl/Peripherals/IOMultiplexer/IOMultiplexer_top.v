module IOMultiplexer (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		// IO Modules
		// UART
		input wire[3:1] uart_en,
		output wire[3:1] uart_rx,
		input  wire[3:1] uart_tx,

		// SPI
		input wire[0:0] spi_en,
		input wire[0:0] spi_clk,
		input wire[0:0] spi_mosi,
		output wire[0:0] spi_miso,
		input  wire[0:0] spi_cs,

		// PWM
		input wire[7:0] pwm_en,
		input wire[7:0] pwm_out,

		// GPIO
		output wire[`MPRJ_IO_PADS-1:0] gpio_input,
		input  wire[`MPRJ_IO_PADS-1:0] gpio_output,
		input  wire[`MPRJ_IO_PADS-1:0] gpio_oe,

		// IO Pads
    	input  wire[`MPRJ_IO_PADS-1:0] io_in,
    	output wire[`MPRJ_IO_PADS-1:0] io_out,
    	output wire[`MPRJ_IO_PADS-1:0] io_oeb,

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
		input wire irq_en,
		output wire irq_in,

		// VGA
		input wire[1:0] vga_r,
		input wire[1:0] vga_g,
		input wire[1:0] vga_b,
		input wire vga_vsync,
		input wire vga_hsync,

		output wire[1:0] probe_blink
	);

	// Test blink
	localparam BLINK_CLOCK_DIV = 26;
	reg blinkEnabled = 1'b1;
	wire[1:0] blink;
	Counter #(.WIDTH(2), .DIV(BLINK_CLOCK_DIV), .TOP(0)) ctr(.clk(clk), .rst(rst), .halt(1'b0), .value(blink));

	always @(posedge clk) begin
		if (rst) blinkEnabled <= 1'b1;
		else if (gpio_oe[PIN_BLINK0]) blinkEnabled <= 1'b0;
	end

	assign probe_blink = blink;

	wire jtag;
	wire sdo;
	wire sdi;
	wire csb;
	wire sck;

	assign jtag_tck = sck;
	assign jtag_tms = csb;
	assign jtag_tdi = sdi;
	assign sdo = jtag_tdo;

	//-------------------------------------------------//
	//----------------Pin Mapping Start----------------//
	//-------------Start of Generated Code-------------//

	// Interface IO mapping
	// GPIO0 (user1 side)
	// IO00: JTAG
	// IO01: SDO
	// IO02: SDI
	// IO03: CSB
	// IO04: SCK
	// IO05: GPIO05 or UART1_RX
	// IO06: GPIO06 or UART1_TX
	// IO07: GPIO07 or IRQ
	// IO08: FLASH_CSB
	// IO09: FLASH_SCK
	// IO10: FLASH_IO0
	// IO11: FLASH_IO1
	// IO12: GPIO12 or PWM0
	// IO13: GPIO13 or PWM1
	// IO14: GPIO14 or PWM2
	// IO15: GPIO15 or PWM3
	// IO16: GPIO16 or PWM4
	// IO17: GPIO17 or PWM5
	// IO18: GPIO18 or PWM6

	// GPIO1 (user2 side)
	// IO19: GPIO19 or UART2_RX
	// IO20: GPIO20 or UART2_TX
	// IO21: GPIO21 or PWM7
	// IO22: GPIO22 or SPI0_CLK
	// IO23: GPIO23 or SPI0_MOSI
	// IO24: GPIO24 or SPI0_MISO
	// IO25: GPIO25 or SPI0_CS
	// IO26: GPIO26 or UART3_RX
	// IO27: GPIO27 or UART3_TX
	// IO28: GPIO28 or BLINK0
	// IO29: GPIO29 or BLINK1
	// IO30: VGA_R0
	// IO31: VGA_R1
	// IO32: VGA_G0
	// IO33: VGA_G1
	// IO34: VGA_B0
	// IO35: VGA_B1
	// IO36: VGA_VSYNC
	// IO37: VGA_HSYNC
	
	// IO00-PIN_JTAG: Input
	localparam PIN_JTAG = 0;
	assign gpio_input[PIN_JTAG] = 1'b0;
	assign io_out[PIN_JTAG] = 1'b0;
	assign io_oeb[PIN_JTAG] = 1'b1;
	assign jtag = io_in[PIN_JTAG];
	
	// IO01-PIN_SDO: Output
	localparam PIN_SDO = 1;
	assign gpio_input[PIN_SDO] = 1'b0;
	assign io_out[PIN_SDO] = sdo;
	assign io_oeb[PIN_SDO] = 1'b0;
	
	// IO02-PIN_SDI: Input
	localparam PIN_SDI = 2;
	assign gpio_input[PIN_SDI] = 1'b0;
	assign io_out[PIN_SDI] = 1'b0;
	assign io_oeb[PIN_SDI] = 1'b1;
	assign sdi = io_in[PIN_SDI];
	
	// IO03-PIN_CSB: Input
	localparam PIN_CSB = 3;
	assign gpio_input[PIN_CSB] = 1'b0;
	assign io_out[PIN_CSB] = 1'b0;
	assign io_oeb[PIN_CSB] = 1'b1;
	assign csb = io_in[PIN_CSB];
	
	// IO04-PIN_SCK: Input
	localparam PIN_SCK = 4;
	assign gpio_input[PIN_SCK] = 1'b0;
	assign io_out[PIN_SCK] = 1'b0;
	assign io_oeb[PIN_SCK] = 1'b1;
	assign sck = io_in[PIN_SCK];
	
	// IO05-PIN_UART1_RX: Input
	localparam PIN_UART1_RX = 5;
	assign gpio_input[PIN_UART1_RX] = uart_en[1] ? 1'b0 : (gpio_oe[PIN_UART1_RX] ? io_in[PIN_UART1_RX] : 1'b0);
	assign io_out[PIN_UART1_RX] = uart_en[1] ? 1'b0 : gpio_output[PIN_UART1_RX];
	assign io_oeb[PIN_UART1_RX] = uart_en[1] ? 1'b1 : gpio_oe[PIN_UART1_RX];
	assign uart_rx[1] = uart_en[1] ? io_in[PIN_UART1_RX] : 1'b1;
	
	// IO06-PIN_UART1_TX: Output
	localparam PIN_UART1_TX = 6;
	assign gpio_input[PIN_UART1_TX] = uart_en[1] ? 1'b0 : (gpio_oe[PIN_UART1_TX] ? io_in[PIN_UART1_TX] : 1'b0);
	assign io_out[PIN_UART1_TX] = uart_en[1] ? uart_tx[1] : gpio_output[PIN_UART1_TX];
	assign io_oeb[PIN_UART1_TX] = uart_en[1] ? 1'b0 : gpio_oe[PIN_UART1_TX];
	
	// IO07-PIN_IRQ: Input
	localparam PIN_IRQ = 7;
	assign gpio_input[PIN_IRQ] = irq_en ? 1'b0 : (gpio_oe[PIN_IRQ] ? io_in[PIN_IRQ] : 1'b0);
	assign io_out[PIN_IRQ] = irq_en ? 1'b0 : gpio_output[PIN_IRQ];
	assign io_oeb[PIN_IRQ] = irq_en ? 1'b1 : gpio_oe[PIN_IRQ];
	assign irq_in = irq_en ? io_in[PIN_IRQ] : 1'b0;
	
	// IO08-PIN_FLASH_CSB: Output
	localparam PIN_FLASH_CSB = 8;
	assign gpio_input[PIN_FLASH_CSB] = 1'b0;
	assign io_out[PIN_FLASH_CSB] = flash_csb;
	assign io_oeb[PIN_FLASH_CSB] = 1'b0;
	
	// IO09-PIN_FLASH_SCK: Output
	localparam PIN_FLASH_SCK = 9;
	assign gpio_input[PIN_FLASH_SCK] = 1'b0;
	assign io_out[PIN_FLASH_SCK] = flash_sck;
	assign io_oeb[PIN_FLASH_SCK] = 1'b0;
	
	// IO10-PIN_FLASH_IO0: InOut
	localparam PIN_FLASH_IO0 = 10;
	assign gpio_input[PIN_FLASH_IO0] = 1'b0;
	assign io_out[PIN_FLASH_IO0] = flash_io0_write;
	assign io_oeb[PIN_FLASH_IO0] = !flash_io0_we;
	assign flash_io0_read = !flash_io0_we ? io_in[PIN_FLASH_IO0] : 1'b0;
	
	// IO11-PIN_FLASH_IO1: InOut
	localparam PIN_FLASH_IO1 = 11;
	assign gpio_input[PIN_FLASH_IO1] = 1'b0;
	assign io_out[PIN_FLASH_IO1] = flash_io1_write;
	assign io_oeb[PIN_FLASH_IO1] = !flash_io1_we;
	assign flash_io1_read = !flash_io1_we ? io_in[PIN_FLASH_IO1] : 1'b0;
	
	// IO12-PIN_PWM0: Output
	localparam PIN_PWM0 = 12;
	assign gpio_input[PIN_PWM0] = pwm_en[0] ? 1'b0 : (gpio_oe[PIN_PWM0] ? io_in[PIN_PWM0] : 1'b0);
	assign io_out[PIN_PWM0] = pwm_en[0] ? pwm_out[0] : gpio_output[PIN_PWM0];
	assign io_oeb[PIN_PWM0] = pwm_en[0] ? 1'b0 : gpio_oe[PIN_PWM0];
	
	// IO13-PIN_PWM1: Output
	localparam PIN_PWM1 = 13;
	assign gpio_input[PIN_PWM1] = pwm_en[1] ? 1'b0 : (gpio_oe[PIN_PWM1] ? io_in[PIN_PWM1] : 1'b0);
	assign io_out[PIN_PWM1] = pwm_en[1] ? pwm_out[1] : gpio_output[PIN_PWM1];
	assign io_oeb[PIN_PWM1] = pwm_en[1] ? 1'b0 : gpio_oe[PIN_PWM1];
	
	// IO14-PIN_PWM2: Output
	localparam PIN_PWM2 = 14;
	assign gpio_input[PIN_PWM2] = pwm_en[2] ? 1'b0 : (gpio_oe[PIN_PWM2] ? io_in[PIN_PWM2] : 1'b0);
	assign io_out[PIN_PWM2] = pwm_en[2] ? pwm_out[2] : gpio_output[PIN_PWM2];
	assign io_oeb[PIN_PWM2] = pwm_en[2] ? 1'b0 : gpio_oe[PIN_PWM2];
	
	// IO15-PIN_PWM3: Output
	localparam PIN_PWM3 = 15;
	assign gpio_input[PIN_PWM3] = pwm_en[3] ? 1'b0 : (gpio_oe[PIN_PWM3] ? io_in[PIN_PWM3] : 1'b0);
	assign io_out[PIN_PWM3] = pwm_en[3] ? pwm_out[3] : gpio_output[PIN_PWM3];
	assign io_oeb[PIN_PWM3] = pwm_en[3] ? 1'b0 : gpio_oe[PIN_PWM3];
	
	// IO16-PIN_PWM4: Output
	localparam PIN_PWM4 = 16;
	assign gpio_input[PIN_PWM4] = pwm_en[4] ? 1'b0 : (gpio_oe[PIN_PWM4] ? io_in[PIN_PWM4] : 1'b0);
	assign io_out[PIN_PWM4] = pwm_en[4] ? pwm_out[4] : gpio_output[PIN_PWM4];
	assign io_oeb[PIN_PWM4] = pwm_en[4] ? 1'b0 : gpio_oe[PIN_PWM4];
	
	// IO17-PIN_PWM5: Output
	localparam PIN_PWM5 = 17;
	assign gpio_input[PIN_PWM5] = pwm_en[5] ? 1'b0 : (gpio_oe[PIN_PWM5] ? io_in[PIN_PWM5] : 1'b0);
	assign io_out[PIN_PWM5] = pwm_en[5] ? pwm_out[5] : gpio_output[PIN_PWM5];
	assign io_oeb[PIN_PWM5] = pwm_en[5] ? 1'b0 : gpio_oe[PIN_PWM5];
	
	// IO18-PIN_PWM6: Output
	localparam PIN_PWM6 = 18;
	assign gpio_input[PIN_PWM6] = pwm_en[6] ? 1'b0 : (gpio_oe[PIN_PWM6] ? io_in[PIN_PWM6] : 1'b0);
	assign io_out[PIN_PWM6] = pwm_en[6] ? pwm_out[6] : gpio_output[PIN_PWM6];
	assign io_oeb[PIN_PWM6] = pwm_en[6] ? 1'b0 : gpio_oe[PIN_PWM6];
	
	// IO19-PIN_UART2_RX: Input
	localparam PIN_UART2_RX = 19;
	assign gpio_input[PIN_UART2_RX] = uart_en[2] ? 1'b0 : (gpio_oe[PIN_UART2_RX] ? io_in[PIN_UART2_RX] : 1'b0);
	assign io_out[PIN_UART2_RX] = uart_en[2] ? 1'b0 : gpio_output[PIN_UART2_RX];
	assign io_oeb[PIN_UART2_RX] = uart_en[2] ? 1'b1 : gpio_oe[PIN_UART2_RX];
	assign uart_rx[2] = uart_en[2] ? io_in[PIN_UART2_RX] : 1'b1;
	
	// IO20-PIN_UART2_TX: Output
	localparam PIN_UART2_TX = 20;
	assign gpio_input[PIN_UART2_TX] = uart_en[2] ? 1'b0 : (gpio_oe[PIN_UART2_TX] ? io_in[PIN_UART2_TX] : 1'b0);
	assign io_out[PIN_UART2_TX] = uart_en[2] ? uart_tx[2] : gpio_output[PIN_UART2_TX];
	assign io_oeb[PIN_UART2_TX] = uart_en[2] ? 1'b0 : gpio_oe[PIN_UART2_TX];
	
	// IO21-PIN_PWM7: Output
	localparam PIN_PWM7 = 21;
	assign gpio_input[PIN_PWM7] = pwm_en[7] ? 1'b0 : (gpio_oe[PIN_PWM7] ? io_in[PIN_PWM7] : 1'b0);
	assign io_out[PIN_PWM7] = pwm_en[7] ? pwm_out[7] : gpio_output[PIN_PWM7];
	assign io_oeb[PIN_PWM7] = pwm_en[7] ? 1'b0 : gpio_oe[PIN_PWM7];
	
	// IO22-PIN_SPI0_CLK: Output
	localparam PIN_SPI0_CLK = 22;
	assign gpio_input[PIN_SPI0_CLK] = spi_en[0] ? 1'b0 : (gpio_oe[PIN_SPI0_CLK] ? io_in[PIN_SPI0_CLK] : 1'b0);
	assign io_out[PIN_SPI0_CLK] = spi_en[0] ? spi_clk[0] : gpio_output[PIN_SPI0_CLK];
	assign io_oeb[PIN_SPI0_CLK] = spi_en[0] ? 1'b0 : gpio_oe[PIN_SPI0_CLK];
	
	// IO23-PIN_SPI0_MOSI: Output
	localparam PIN_SPI0_MOSI = 23;
	assign gpio_input[PIN_SPI0_MOSI] = spi_en[0] ? 1'b0 : (gpio_oe[PIN_SPI0_MOSI] ? io_in[PIN_SPI0_MOSI] : 1'b0);
	assign io_out[PIN_SPI0_MOSI] = spi_en[0] ? spi_mosi[0] : gpio_output[PIN_SPI0_MOSI];
	assign io_oeb[PIN_SPI0_MOSI] = spi_en[0] ? 1'b0 : gpio_oe[PIN_SPI0_MOSI];
	
	// IO24-PIN_SPI0_MISO: Input
	localparam PIN_SPI0_MISO = 24;
	assign gpio_input[PIN_SPI0_MISO] = spi_en[0] ? 1'b0 : (gpio_oe[PIN_SPI0_MISO] ? io_in[PIN_SPI0_MISO] : 1'b0);
	assign io_out[PIN_SPI0_MISO] = spi_en[0] ? 1'b0 : gpio_output[PIN_SPI0_MISO];
	assign io_oeb[PIN_SPI0_MISO] = spi_en[0] ? 1'b1 : gpio_oe[PIN_SPI0_MISO];
	assign spi_miso[0] = spi_en[0] ? io_in[PIN_SPI0_MISO] : 1'b0;
	
	// IO25-PIN_SPI0_CS: Output
	localparam PIN_SPI0_CS = 25;
	assign gpio_input[PIN_SPI0_CS] = spi_en[0] ? 1'b0 : (gpio_oe[PIN_SPI0_CS] ? io_in[PIN_SPI0_CS] : 1'b0);
	assign io_out[PIN_SPI0_CS] = spi_en[0] ? spi_cs[0] : gpio_output[PIN_SPI0_CS];
	assign io_oeb[PIN_SPI0_CS] = spi_en[0] ? 1'b0 : gpio_oe[PIN_SPI0_CS];
	
	// IO26-PIN_UART3_RX: Input
	localparam PIN_UART3_RX = 26;
	assign gpio_input[PIN_UART3_RX] = uart_en[3] ? 1'b0 : (gpio_oe[PIN_UART3_RX] ? io_in[PIN_UART3_RX] : 1'b0);
	assign io_out[PIN_UART3_RX] = uart_en[3] ? 1'b0 : gpio_output[PIN_UART3_RX];
	assign io_oeb[PIN_UART3_RX] = uart_en[3] ? 1'b1 : gpio_oe[PIN_UART3_RX];
	assign uart_rx[3] = uart_en[3] ? io_in[PIN_UART3_RX] : 1'b1;
	
	// IO27-PIN_UART3_TX: Output
	localparam PIN_UART3_TX = 27;
	assign gpio_input[PIN_UART3_TX] = uart_en[3] ? 1'b0 : (gpio_oe[PIN_UART3_TX] ? io_in[PIN_UART3_TX] : 1'b0);
	assign io_out[PIN_UART3_TX] = uart_en[3] ? uart_tx[3] : gpio_output[PIN_UART3_TX];
	assign io_oeb[PIN_UART3_TX] = uart_en[3] ? 1'b0 : gpio_oe[PIN_UART3_TX];
	
	// IO28-PIN_BLINK0: Output
	localparam PIN_BLINK0 = 28;
	assign gpio_input[PIN_BLINK0] = blinkEnabled ? 1'b0 : (gpio_oe[PIN_BLINK0] ? io_in[PIN_BLINK0] : 1'b0);
	assign io_out[PIN_BLINK0] = blinkEnabled ? blink[0] : gpio_output[PIN_BLINK0];
	assign io_oeb[PIN_BLINK0] = blinkEnabled ? 1'b0 : gpio_oe[PIN_BLINK0];
	
	// IO29-PIN_BLINK1: Output
	localparam PIN_BLINK1 = 29;
	assign gpio_input[PIN_BLINK1] = blinkEnabled ? 1'b0 : (gpio_oe[PIN_BLINK1] ? io_in[PIN_BLINK1] : 1'b0);
	assign io_out[PIN_BLINK1] = blinkEnabled ? blink[1] : gpio_output[PIN_BLINK1];
	assign io_oeb[PIN_BLINK1] = blinkEnabled ? 1'b0 : gpio_oe[PIN_BLINK1];
	
	// IO30-PIN_VGA_R0: Output
	localparam PIN_VGA_R0 = 30;
	assign gpio_input[PIN_VGA_R0] = 1'b0;
	assign io_out[PIN_VGA_R0] = vga_r[0];
	assign io_oeb[PIN_VGA_R0] = 1'b0;
	
	// IO31-PIN_VGA_R1: Output
	localparam PIN_VGA_R1 = 31;
	assign gpio_input[PIN_VGA_R1] = 1'b0;
	assign io_out[PIN_VGA_R1] = vga_r[1];
	assign io_oeb[PIN_VGA_R1] = 1'b0;
	
	// IO32-PIN_VGA_G0: Output
	localparam PIN_VGA_G0 = 32;
	assign gpio_input[PIN_VGA_G0] = 1'b0;
	assign io_out[PIN_VGA_G0] = vga_g[0];
	assign io_oeb[PIN_VGA_G0] = 1'b0;
	
	// IO33-PIN_VGA_G1: Output
	localparam PIN_VGA_G1 = 33;
	assign gpio_input[PIN_VGA_G1] = 1'b0;
	assign io_out[PIN_VGA_G1] = vga_g[1];
	assign io_oeb[PIN_VGA_G1] = 1'b0;
	
	// IO34-PIN_VGA_B0: Output
	localparam PIN_VGA_B0 = 34;
	assign gpio_input[PIN_VGA_B0] = 1'b0;
	assign io_out[PIN_VGA_B0] = vga_b[0];
	assign io_oeb[PIN_VGA_B0] = 1'b0;
	
	// IO35-PIN_VGA_B1: Output
	localparam PIN_VGA_B1 = 35;
	assign gpio_input[PIN_VGA_B1] = 1'b0;
	assign io_out[PIN_VGA_B1] = vga_b[1];
	assign io_oeb[PIN_VGA_B1] = 1'b0;
	
	// IO36-PIN_VGA_VSYNC: Output
	localparam PIN_VGA_VSYNC = 36;
	assign gpio_input[PIN_VGA_VSYNC] = 1'b0;
	assign io_out[PIN_VGA_VSYNC] = vga_vsync;
	assign io_oeb[PIN_VGA_VSYNC] = 1'b0;
	
	// IO37-PIN_VGA_HSYNC: Output
	localparam PIN_VGA_HSYNC = 37;
	assign gpio_input[PIN_VGA_HSYNC] = 1'b0;
	assign io_out[PIN_VGA_HSYNC] = vga_hsync;
	assign io_oeb[PIN_VGA_HSYNC] = 1'b0;
	
	//--------------End of Generated Code--------------//
	//-----------------Pin Mapping End-----------------//
	//-------------------------------------------------//

endmodule