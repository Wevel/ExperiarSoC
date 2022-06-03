module Video (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire wb_clk_i,
		input wire wb_rst_i,

		// Wishbone Slave ports
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

		// IRQ
		output wire[1:0] video_irq,

		// Left Video SRAM rw port
		output wire sram0_clk0,
		output wire[1:0] sram0_csb0,
		output wire sram0_web0,
		output wire[3:0] sram0_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram0_addr0,
		output wire[31:0] sram0_din0,
		input wire[63:0] sram0_dout0,

		// Left Video SRAM r port
		output wire sram0_clk1,
		output wire[1:0] sram0_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram0_addr1,
		input wire[63:0] sram0_dout1,

		// Right Video SRAM rw port
		output wire sram1_clk0,
		output wire[1:0] sram1_csb0,
		output wire sram1_web0,
		output wire[3:0] sram1_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram1_addr0,
		output wire[31:0] sram1_din0,
		input wire[63:0] sram1_dout0,

		// Right Video SRAM r port
		output wire sram1_clk1,
		output wire[1:0] sram1_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram1_addr1,
		input wire[63:0] sram1_dout1,

		// VGA
		//input wire vga_clk,
		output wire[1:0] vga_r,
		output wire[1:0] vga_g,
		output wire[1:0] vga_b,
		output wire vga_vsync,
		output wire vga_hsync
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	wire vga_clk = wb_clk_i;

	wire peripheralBus_we;
	wire peripheralBus_oe;
	wire peripheralBus_busy;
	wire[23:0] peripheralBus_address;
	wire[3:0] peripheralBus_byteSelect;
	wire[31:0] peripheralBus_dataRead;
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
	
	wire video_fetchData;
	wire[SRAM_ADDRESS_SIZE+3:0] vga_address;
	wire[31:0] vga_data;

	wire videoMemoryBusBusy;
	wire[31:0] videoMemoryDataRead;
	wire videoMemoryRequestOutput;
	wire vga_fetchData;
	VideoMemory videoMemory(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(videoMemoryBusBusy),
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataRead(videoMemoryDataRead),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.requestOutput(videoMemoryRequestOutput),
		.video_fetchData(vga_fetchData),
		.video_address(vga_address),
		.video_data(vga_data),
		.sram0_csb0(sram0_csb0),
		.sram0_web0(sram0_web0),
		.sram0_wmask0(sram0_wmask0),
		.sram0_addr0(sram0_addr0),
		.sram0_din0(sram0_din0),
		.sram0_dout0(sram0_dout0),
		.sram0_csb1(sram0_csb1),
		.sram0_addr1(sram0_addr1),
		.sram0_dout1(sram0_dout1),
		.sram1_csb0(sram1_csb0),
		.sram1_web0(sram1_web0),
		.sram1_wmask0(sram1_wmask0),
		.sram1_addr0(sram1_addr0),
		.sram1_din0(sram1_din0),
		.sram1_dout0(sram1_dout0),
		.sram1_csb1(sram1_csb1),
		.sram1_addr1(sram1_addr1),
		.sram1_dout1(sram1_dout1));

	assign sram0_clk0 = vga_clk;
	assign sram0_clk1 = vga_clk;
	assign sram1_clk0 = vga_clk;
	assign sram1_clk1 = vga_clk;

	wire vgaBusBusy;
	wire[31:0] vgaDataRead;
	wire vgaRequestOutput;
	VGA #(.ADDRESS_BITS(SRAM_ADDRESS_SIZE + 4)) vga(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(vgaBusBusy),
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataRead(vgaDataRead),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.requestOutput(vgaRequestOutput),
		.vga_clk(vga_clk),
		.vga_fetchData(vga_fetchData),
		.vga_address(vga_address),
		.vga_data(vga_data),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync),
		.vga_irq(video_irq));

	assign peripheralBus_busy = videoMemoryBusBusy || vgaBusBusy;
	assign peripheralBus_dataRead = videoMemoryRequestOutput ? videoMemoryDataRead : 
									vgaRequestOutput ? vgaDataRead : ~32'b0;

endmodule