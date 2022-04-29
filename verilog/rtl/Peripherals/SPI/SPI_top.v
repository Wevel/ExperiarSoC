module SPI #(
		parameter ID = 8'h01
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

		output wire[DEVICE_COUNT-1:0] spi_en,
		output wire[DEVICE_COUNT-1:0] spi_clk,
		output wire[DEVICE_COUNT-1:0] spi_mosi,
		input  wire[DEVICE_COUNT-1:0] spi_miso,
		output wire[DEVICE_COUNT-1:0] spi_cs
	);

localparam DEVICE_COUNT = 2;

// Peripheral select
wire[15:0] localAddress;
wire peripheralEnable;
PeripheralSelect #(.ID(ID)) select(
	.peripheralBus_address(peripheralBus_address),
	.localAddress(localAddress),
	.peripheralEnable(peripheralEnable));

wire[DEVICE_COUNT-1:0] device_busy;

genvar i;
generate
	for (i = 0; i < DEVICE_COUNT; i = i + 1) begin
		SPIDevice #(.ID(4'(i+1)), .WIDTH(8), .CLOCK_WIDTH(8)) device(
			.clk(clk),
			.rst(rst),
			.peripheralEnable(peripheralEnable),
			.peripheralBus_we(peripheralBus_we),
			.peripheralBus_oe(peripheralBus_oe),
			.peripheralBus_busy(device_busy[i]),
			.peripheralBus_address(localAddress),
			.peripheralBus_data(peripheralBus_data),
			.spi_en(spi_en[i]),
			.spi_clk(spi_clk[i]),
			.spi_mosi(spi_mosi[i]),
			.spi_miso(spi_miso[i]),
			.spi_cs(spi_cs[i]));
	end
endgenerate

assign peripheralBus_busy = |device_busy;

endmodule