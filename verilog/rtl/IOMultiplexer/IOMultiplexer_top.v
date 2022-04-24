module IOMultiplexer (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,

		// Config register interface
		input wire config_we,
		input wire config_oe,
		input wire[31:0] config_address,
		inout wire[31:0] config_data,

		// IO Modules
		// UART
		output wire[3:0] uart_rx,
		input  wire[3:0] uart_tx,

		// SPI
		input wire[1:0] spi_clk,
		input wire[1:0] spi_mosi,
		output wire[1:0] spi_miso,
		input  wire[1:0] spi_cs,

		// PWM
		input wire[15:0] pwm_out,

		// GPIO
		output wire[`MPRJ_IO_PADS_1-1:0] gpio0_input,
		input  wire[`MPRJ_IO_PADS_1-1:0] gpio0_output,
		input  wire[`MPRJ_IO_PADS_1-1:0] gpio0_oe,

		output wire[`MPRJ_IO_PADS_2-1:0] gpio1_input,
		input  wire[`MPRJ_IO_PADS_2-1:0] gpio1_output,
		input  wire[`MPRJ_IO_PADS_2-1:0] gpio1_oe,

		// IO Pads
    	input  wire[`MPRJ_IO_PADS-1:0] io_in,
    	output wire[`MPRJ_IO_PADS-1:0] io_out,
    	output wire[`MPRJ_IO_PADS-1:0] io_oeb,

		output wire[1:0] la_blink
	);

// Interface IO mapping
// GPIO0 (user1 side)
// IO00: uart0_rx
// IO01: uart0_tx
// IO02: pwm0
// IO03: pwm1
// IO04: pwm2
// IO05: pwm3
// IO06: spi0_clk
// IO07: spi0_mosi
// IO08: spi0_miso
// IO09: spi0_cs
// IO10: uart1_rx
// IO11: uart1_tx
// IO12: pwm4
// IO13: pwm5
// IO14: pwm6
// IO15: pwm7
// IO16: blink
// IO17: None
// IO18: None

// GPIO1 (user2 side)
// IO19: uart2_rx
// IO20: uart2_tx
// IO21: pwm8
// IO22: pwm9
// IO23: pwm10
// IO24: pwm11
// IO25: spi1_clk
// IO26: spi1_mosi
// IO27: spi1_miso
// IO28: spi1_cs
// IO29: uart3_rx
// IO30: uart3_tx
// IO31: pwm12
// IO32: pwm13
// IO33: pwm14
// IO34: pwm15
// IO35: None
// IO36: None
// IO37: None

// Test blink
reg blinkEnabled = 1'b1;
wire[1:0] blink;
counter #(.WIDTH(2), .DIV(23), .TOP(0)) ctr(.clk(clk), .rst(rst), .halt(1'b0), .value(blink));

always @(posedge clk) begin
	if (rst) begin
		blinkEnabled <= 1'b1;
	end else begin
		if (gpio0_oe[12]) blinkEnabled <= 1'b0;
	end
end

// Configuration register
// b00: uart0_en
// b01: uart1_en
// b02: uart2_en
// b03: uart3_en
// b04: spi0_en
// b05: spi1_en
// b06: pwm0_en
// b07: pwm1_en
// b08: pwm2_en
// b09: pwm3_en
// b10: pwm4_en
// b11: pwm5_en
// b12: pwm6_en
// b13: pwm7_en
// b14: pwm8_en
// b15: pwm9_en
// b16: pwm10_en
// b17: pwm11_en
// b18: pwm12_en
// b19: pwm13_en
// b20: pwm14_en
// b21: pwm15_en
// b22: 
// b23: 
// b24: 
// b25: 
// b26: 
// b27: 
// b28: 
// b29: 
// b30: 
// b31: 

wire[31:0] configuration;
ConfigurationRegister #(.WIDTH(32), .ADDRESS(32'h0000_0000)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.we(config_we),
		.oe(config_oe),
		.interfaceAddress(config_address),
		.interfaceData(config_data),
		.currentValue(configuration));

wire[3:0] uart_en = configuration[3:0];
wire[1:0] spi_en  = configuration[5:4];
wire[15:0] pwm_en = configuration[21:6];

// IO multiplexer
assign gpio1_input = { 
	io_in[`MPRJ_IO_PADS_1 + `MPRJ_IO_PADS_2 - 1 : `MPRJ_IO_PADS_1 + 12],
	pwm_en[15]   ? 1'b0 		: io_in[`MPRJ_IO_PADS_1 + 15],
	pwm_en[14]   ? 1'b0 		: io_in[`MPRJ_IO_PADS_1 + 14],
	pwm_en[13]   ? 1'b0 		: io_in[`MPRJ_IO_PADS_1 + 13],
	pwm_en[12]   ? 1'b0 		: io_in[`MPRJ_IO_PADS_1 + 12],
	uart_en[3]   ? 1'b0         : io_in[`MPRJ_IO_PADS_1 + 11],
	uart_en[3]   ? uart_rx[3]   : io_in[`MPRJ_IO_PADS_1 + 10],
	spi_en[1]    ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  9],
	spi_en[1]    ? spi1_miso[1] : io_in[`MPRJ_IO_PADS_1 +  8],
	spi_en[1]    ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  7],
	spi_en[1]    ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  6],
	pwm_en[11]   ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  5],
	pwm_en[10]   ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  4],
	pwm_en[9]    ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  3],
	pwm_en[8]    ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  2],
	uart_en[2]   ? 1'b0         : io_in[`MPRJ_IO_PADS_1 +  1],
	uart_en[2]   ? uart_rx[2]   : io_in[`MPRJ_IO_PADS_1 +  0]
};

assign gpio0_input = {
	io_in[`MPRJ_IO_PADS_1-1:17],
	blinkEnabled ? 1'b0         : io_in[16],
	pwm_en[7]    ? 1'b0 		: io_in[15],
	pwm_en[6]    ? 1'b0 		: io_in[14],
	pwm_en[5]    ? 1'b0 		: io_in[13],
	pwm_en[4]    ? 1'b0 		: io_in[12],
	uart_en[1]   ? 1'b0         : io_in[11],
	uart_en[1]   ? uart_rx[1]   : io_in[10],
	spi_en[0]    ? 1'b0         : io_in[9],
	spi_en[0]    ? spi1_miso[0] : io_in[8],
	spi_en[0]    ? 1'b0         : io_in[7],
	spi_en[0]    ? 1'b0         : io_in[6],
	pwm_en[3]    ? 1'b0         : io_in[5],
	pwm_en[2]    ? 1'b0         : io_in[4],
	pwm_en[1]    ? 1'b0         : io_in[3],
	pwm_en[0]    ? 1'b0         : io_in[2],
	uart_en[0]   ? 1'b0         : io_in[1],
	uart_en[0]   ? uart_rx[0]   : io_in[0]
};

assign io_out = { 
	gpio1_output[`MPRJ_IO_PADS_2-1:16], 
	pwm_en[15]   ? pwm_out[15]  : gpio1_output[15],
	pwm_en[14]   ? pwm_out[14]  : gpio1_output[14],
	pwm_en[13]   ? pwm_out[13]  : gpio1_output[13],
	pwm_en[12]   ? pwm_out[12]  : gpio1_output[12],
	uart_en[3]   ? uart_tx[3]   : gpio1_output[11],
	uart_en[3]   ? 1'b0 		: gpio1_output[10],
	spi_en[1]    ? spi_cs[1]    : gpio1_output[9],
	spi_en[1]    ? 1'b0 		: gpio1_output[8],
	spi_en[1]    ? spi1_mosi[1] : gpio1_output[7],
	spi_en[1]    ? spi_clk[1]   : gpio1_output[6],
	pwm_en[11]   ? pwm_out[11]  : gpio1_output[5],
	pwm_en[10]   ? pwm_out[10]  : gpio1_output[4],
	pwm_en[9]    ? pwm_out[9]   : gpio1_output[3],
	pwm_en[8]    ? pwm_out[8]   : gpio1_output[2],
	uart_en[2]   ? uart_tx[2]   : gpio1_output[1],
	uart_en[2]   ? 1'b0 		: gpio1_output[0],
	gpio0_output[`MPRJ_IO_PADS_1-1:17],
	blinkEnabled ? blink[0] : gpio0_output[16],
	pwm_en[7]    ? pwm_out[7]   : gpio0_output[15],
	pwm_en[6]    ? pwm_out[6]   : gpio0_output[14],
	pwm_en[5]    ? pwm_out[5]   : gpio0_output[13],
	pwm_en[4]    ? pwm_out[4]   : gpio0_output[12],
	uart_en[1]   ? uart_tx[1]   : gpio0_output[11],
	uart_en[1]   ? 1'b0 		: gpio0_output[10],
	spi_en[0]    ? spi_cs[0]    : gpio0_output[9],
	spi_en[0]    ? 1'b0         : gpio0_output[8],
	spi_en[0]    ? spi1_mosi[0] : gpio0_output[7],
	spi_en[0]    ? spi_clk[0]   : gpio0_output[6],
	pwm_en[3]    ? pwm_out[3]   : gpio0_output[5],
	pwm_en[2]    ? pwm_out[2]   : gpio0_output[4],
	pwm_en[1]    ? pwm_out[1]   : gpio0_output[3],
	pwm_en[0]    ? pwm_out[0]   : gpio0_output[2],
	uart_en[0]   ? uart_tx[0]   : gpio0_output[1],
	uart_en[0]   ? 1'b0 		: gpio0_output[0]
};

assign io_oeb  = { 
	gpio1_oe[`MPRJ_IO_PADS_2-1:16],
	pwm_en[15]   ? 1'b1 : gpio1_oe[15],
	pwm_en[14]   ? 1'b1 : gpio1_oe[14],
	pwm_en[13]   ? 1'b1 : gpio1_oe[13],
	pwm_en[12]   ? 1'b1 : gpio1_oe[12],
	uart_en[3]   ? 1'b1 : gpio1_oe[11],
	uart_en[3]   ? 1'b0 : gpio1_oe[10],
	spi_en[1]    ? 1'b1 : gpio1_oe[9],
	spi_en[1]    ? 1'b0 : gpio1_oe[8],
	spi_en[1]    ? 1'b1 : gpio1_oe[7],
	spi_en[1]    ? 1'b1 : gpio1_oe[6],
	pwm_en[11]   ? 1'b1 : gpio1_oe[5],
	pwm_en[10]   ? 1'b1 : gpio1_oe[4],
	pwm_en[9]    ? 1'b1 : gpio1_oe[3],
	pwm_en[8]    ? 1'b1 : gpio1_oe[2],
	uart_en[2]   ? 1'b1 : gpio1_oe[1],
	uart_en[2]   ? 1'b0 : gpio1_oe[0],
	gpio0_oe[`MPRJ_IO_PADS_1-1:17],
	blinkEnabled ? 1'b1 : gpio0_oe[16],
	pwm_en[7]    ? 1'b1 : gpio0_oe[15],
	pwm_en[6]    ? 1'b1 : gpio0_oe[14],
	pwm_en[5]    ? 1'b1 : gpio0_oe[13],
	pwm_en[4]    ? 1'b1 : gpio0_oe[12],
	uart_en[1]   ? 1'b1 : gpio0_oe[11],
	uart_en[1]   ? 1'b0 : gpio0_oe[10],
	spi_en[0]    ? 1'b1 : gpio0_oe[9],
	spi_en[0]    ? 1'b0 : gpio0_oe[8],
	spi_en[0]    ? 1'b1 : gpio0_oe[7],
	spi_en[0]    ? 1'b1 : gpio0_oe[6],
	pwm_en[3]    ? 1'b1 : gpio0_oe[5],
	pwm_en[2]    ? 1'b1 : gpio0_oe[4],
	pwm_en[1]    ? 1'b1 : gpio0_oe[3],
	pwm_en[0]    ? 1'b1 : gpio0_oe[2],
	uart_en[0]   ? 1'b1 : gpio0_oe[1],
	uart_en[0]   ? 1'b0 : gpio0_oe[0]
};

assign la_blink = blink;

endmodule