module Flash (
	`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire wb_clk_i,
		input wire wb_rst_i,

		// Wishbone interface
		input wire wb_cyc_i,
		input wire wb_stb_i,
		input wire wb_we_i,
		input wire[3:0] wb_sel_i,
		input wire[31:0] wb_data_i,
		input wire[23:0] wb_adr_i,
		output wire wb_ack_o,
		output wire wb_stall_o,
		output wire wb_error_o,
		output wire[31:0] wb_data_o,

		// Flash QSPI
		output wire flash_csb,
		output wire flash_sck,
		output wire flash_io0_we,
		output wire flash_io0_write,
		input wire flash_io0_read,
		output wire flash_io1_we,
		output wire flash_io1_write,
		input wire flash_io1_read,

		// Flash controller SRAM rw port
		output wire sram_clk0,
		output wire sram_csb0,
		output wire sram_web0,
		output wire[3:0] sram_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0,
		output wire[31:0] sram_din0,
		input wire[31:0] sram_dout0,

		// Wishbone SRAM r port
		output wire sram_clk1,
		output wire sram_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1,
		input wire[31:0] sram_dout1
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	localparam STATE_STARTUP 	   	 = 2'b00;
	localparam STATE_WRITE_COMMAND 	 = 2'b01;
	localparam STATE_CHANGE_ADDRESS  = 2'b11;
	localparam STATE_READ_CONTINUOUS = 2'b11;
	
	// Wishbone interface
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
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(peripheralBus_dataRead),
		.peripheralBus_busy(peripheralBus_busy));

	// Flash cache
	wire qspi_enable;
	wire[23:0] qspi_address;
	wire qspi_changeAddress;
	wire qspi_requestData;
	wire[31:0] qspi_readData;
	wire qspi_readDataValid;

	FlashBuffer #(.SRAM_ADDRESS_SIZE(SRAM_ADDRESS_SIZE)) flashBuffer(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(peripheralBus_dataRead),
		.peripheralBus_busy(peripheralBus_busy),
		.qspi_enable(qspi_enable),
		.qspi_address(qspi_address),
		.qspi_changeAddress(qspi_changeAddress),
		.qspi_requestData(qspi_requestData),
		.qspi_readData(qspi_readData),
		.qspi_readDataValid(qspi_readDataValid),
		.sram_clk0(sram_clk0),
		.sram_csb0(sram_csb0),
		.sram_web0(sram_web0),
		.sram_wmask0(sram_wmask0),
		.sram_addr0(sram_addr0),
		.sram_din0(sram_din0),
		.sram_dout0(sram_dout0),
		.sram_clk1(sram_clk1),
		.sram_csb1(sram_csb1),
		.sram_addr1(sram_addr1),
		.sram_dout1(sram_dout1));

	// QSPI controller
	QSPIDevice qspiDevice (
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.qspi_enable(qspi_enable),
		.qspi_address(qspi_address),
		.qspi_changeAddress(qspi_changeAddress),
		.qspi_requestData(qspi_requestData),
		.qspi_readData(qspi_readData),
		.qspi_readDataValid(qspi_readDataValid),
		.flash_csb(flash_csb),
		.flash_sck(flash_sck),
		.flash_io0_we(flash_io0_we),
		.flash_io0_write(flash_io0_write),
		.flash_io0_read(flash_io0_read),
		.flash_io1_we(flash_io1_we),
		.flash_io1_write(flash_io1_write),
		.flash_io1_read(flash_io1_read));

endmodule