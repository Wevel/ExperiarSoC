module CaravelHost (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire wb_clk_i,
		input wire wb_rst_i,

		// Wishbone Slave port from caravel
		input wbs_stb_i,
		input wbs_cyc_i,
		input wbs_we_i,
		input [3:0] wbs_sel_i,
		input [31:0] wbs_data_i,
		input [31:0] wbs_adr_i,
		output wbs_ack_o,
		output [31:0] wbs_data_o,

		// Caravel wishbone master
		output wire caravel_wb_cyc_o,
		output wire caravel_wb_stb_o,
		output wire caravel_wb_we_o,
		output wire[3:0] caravel_wb_sel_o,
		output wire[31:0] caravel_wb_data_o,
		output wire[27:0] caravel_wb_adr_o,
		input wire caravel_wb_ack_i,
		input wire caravel_wb_stall_i,
		input wire caravel_wb_error_i,
		input wire[31:0] caravel_wb_data_i,
		
		// Caravel UART
		input wire caravel_uart_rx,
		output wire caravel_uart_tx,

		// Caravel IRQ
		output wire[3:0] caravel_irq,

		// Configuration constants
		output wire[7:0] core0Index,
		output wire[7:0] core1Index,
		output wire[10:0] manufacturerID,
		output wire[15:0] partID,
		output wire[3:0] versionID
	);

	localparam USER_SPACE_ADDRESS = 4'h3;
	localparam HOST_PERIPHERAL_ADDRESS = 4'hF;

	assign core0Index = 8'h00;
	assign core1Index = 8'h01;
	assign manufacturerID = 11'h000;
	assign partID = 16'hCD55;
	assign versionID = 4'h0;

	wire userSpace_wb_cyc_i;
	wire userSpace_wb_stb_i;
	wire userSpace_wb_we_i;
	wire[3:0] userSpace_wb_sel_i;
	wire[31:0] userSpace_wb_data_i;
	wire[31:0] userSpace_wb_adr_i;
	wire userSpace_wb_ack_o;
	wire[31:0] userSpace_wb_data_o;

	WBAddressExtension wbAddressExtension(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wbs_cyc_i(wbs_cyc_i),
		.wbs_stb_i(wbs_stb_i),
		.wbs_we_i(wbs_we_i),
		.wbs_sel_i(wbs_sel_i),
		.wbs_adr_i(wbs_adr_i),
		.wbs_data_i(wbs_data_i),
		.wbs_ack_o(wbs_ack_o),
		.wbs_data_o(wbs_data_o),
		.userSpace_wb_cyc_i(userSpace_wb_cyc_i),
		.userSpace_wb_stb_i(userSpace_wb_stb_i),
		.userSpace_wb_we_i(userSpace_wb_we_i),
		.userSpace_wb_sel_i(userSpace_wb_sel_i),
		.userSpace_wb_adr_i(userSpace_wb_adr_i),
		.userSpace_wb_data_i(userSpace_wb_data_i),
		.userSpace_wb_ack_o(userSpace_wb_ack_o),
		.userSpace_wb_data_o(userSpace_wb_data_o));

	wire userSpaceEnable = userSpace_wb_adr_i[31:28] == USER_SPACE_ADDRESS;
	reg hostConfigLatch = 1'b0;
	wire hostConfigSelect = userSpaceEnable && userSpace_wb_adr_i[27:24] == HOST_PERIPHERAL_ADDRESS;
	wire hostConfigEnable = hostConfigLatch || hostConfigSelect;

	wire caravelHost_wb_ack_o;
	wire caravelHost_wb_stall_o;
	wire caravelHost_wb_error_o;
	wire[31:0] caravelHost_wb_data_o;

	always @(posedge wb_clk_i) begin
		if (wb_rst_i || !userSpace_wb_cyc_i) hostConfigLatch <= 1'b0;
		else if (hostConfigSelect && userSpace_wb_cyc_i) hostConfigLatch <= 1'b1;
	end

	// Caravel wishbone master
	wire caravelEnable = userSpace_wb_cyc_i && userSpaceEnable && !hostConfigEnable;
	assign caravel_wb_cyc_o = caravelEnable;
	assign caravel_wb_stb_o = userSpace_wb_stb_i && caravelEnable;
	assign caravel_wb_we_o = userSpace_wb_we_i && caravelEnable;
	assign caravel_wb_sel_o = caravelEnable ? userSpace_wb_sel_i : 4'b0000;
	assign caravel_wb_data_o = caravelEnable ? userSpace_wb_data_i : ~32'b0;
	assign caravel_wb_adr_o = caravelEnable ? userSpace_wb_adr_i[27:0] : 28'b0;

	assign userSpace_wb_ack_o   = hostConfigEnable ? caravelHost_wb_ack_o : caravel_wb_ack_i || caravel_wb_error_i;
	//assign userSpace_wb_stall_i = hostConfigEnable ? caravelHost_wb_stall_o : caravel_wb_stall_i;
	//assign userSpace_wb_error_i = hostConfigEnable ? caravelHost_wb_error_o : caravel_wb_error_i;
	assign userSpace_wb_data_o  = hostConfigEnable ? caravelHost_wb_data_o : caravel_wb_data_i;

	// Peripheral bus
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
		.wb_stb_i(userSpace_wb_stb_i && hostConfigEnable),
		.wb_cyc_i(userSpace_wb_cyc_i && hostConfigEnable),
		.wb_we_i(userSpace_wb_we_i),
		.wb_sel_i(userSpace_wb_sel_i),
		.wb_data_i(userSpace_wb_data_i),
		.wb_adr_i(userSpace_wb_adr_i[23:0]),
		.wb_ack_o(caravelHost_wb_ack_o),
		.wb_stall_o(caravelHost_wb_stall_o),
		.wb_error_o(caravelHost_wb_error_o),
		.wb_data_o(caravelHost_wb_data_o),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(peripheralBus_busy),
		.peripheralBus_address(peripheralBus_address),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataRead(peripheralBus_dataRead),
		.peripheralBus_dataWrite(peripheralBus_dataWrite));

	// Peripheral select
	wire[15:0] localAddress;
	wire peripheralEnable;
	PeripheralSelect #(.ID(4'h0)) select(
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.peripheralEnable(peripheralEnable));

	// UART host
	wire uartOutputRequest_nc;
	wire uartEnable_nc;
	UARTDevice #(.ID(4'h1)) device(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.peripheralEnable(peripheralEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(peripheralBus_busy),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(peripheralBus_dataRead),
		.requestOutput(uartOutputRequest_nc),
		.uart_en(uartEnable_nc),
		.uart_rx(caravel_uart_rx),
		.uart_tx(caravel_uart_tx));
	
	assign caravel_irq = 3'b0;
	
endmodule