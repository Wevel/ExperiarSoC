module WishboneInterconnect (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire wb_clk_i,
		input wire wb_rst_i,

		// Master 0
		input wire master0_wb_cyc_o,
		input wire master0_wb_stb_o,
		input wire master0_wb_we_o,
		input wire[3:0] master0_wb_sel_o,
		input wire[31:0] master0_wb_data_o,
		input wire[27:0] master0_wb_adr_o,
		output wire master0_wb_ack_i,
		output wire master0_wb_stall_i,
		output wire master0_wb_error_i,
		output wire[31:0] master0_wb_data_i,

		// Master 1
		input wire master1_wb_cyc_o,
		input wire master1_wb_stb_o,
		input wire master1_wb_we_o,
		input wire[3:0] master1_wb_sel_o,
		input wire[31:0] master1_wb_data_o,
		input wire[27:0] master1_wb_adr_o,
		output wire master1_wb_ack_i,
		output wire master1_wb_stall_i,
		output wire master1_wb_error_i,
		output wire[31:0] master1_wb_data_i,

		// Master 2
		input wire master2_wb_cyc_o,
		input wire master2_wb_stb_o,
		input wire master2_wb_we_o,
		input wire[3:0] master2_wb_sel_o,
		input wire[31:0] master2_wb_data_o,
		input wire[27:0] master2_wb_adr_o,
		output wire master2_wb_ack_i,
		output wire master2_wb_stall_i,
		output wire master2_wb_error_i,
		output wire[31:0] master2_wb_data_i,

		// Master 3
		// input wire master3_wb_cyc_o,
		// input wire master3_wb_stb_o,
		// input wire master3_wb_we_o,
		// input wire[3:0] master3_wb_sel_o,
		// input wire[31:0] master3_wb_data_o,
		// input wire[27:0] master3_wb_adr_o,
		// output wire master3_wb_ack_i,
		// output wire master3_wb_stall_i,
		// output wire master3_wb_error_i,
		// output wire[31:0] master3_wb_data_i,

		// Slave 0
		output wire slave0_wb_cyc_i,
		output wire slave0_wb_stb_i,
		output wire slave0_wb_we_i,
		output wire[3:0] slave0_wb_sel_i,
		output wire[31:0] slave0_wb_data_i,
		output wire[23:0] slave0_wb_adr_i,
		input wire slave0_wb_ack_o,
		input wire slave0_wb_stall_o,
		input wire slave0_wb_error_o,
		input wire[31:0] slave0_wb_data_o,

		// Slave 1
		output wire slave1_wb_cyc_i,
		output wire slave1_wb_stb_i,
		output wire slave1_wb_we_i,
		output wire[3:0] slave1_wb_sel_i,
		output wire[31:0] slave1_wb_data_i,
		output wire[23:0] slave1_wb_adr_i,
		input wire slave1_wb_ack_o,
		input wire slave1_wb_stall_o,
		input wire slave1_wb_error_o,
		input wire[31:0] slave1_wb_data_o,

		// Slave 2
		output wire slave2_wb_cyc_i,
		output wire slave2_wb_stb_i,
		output wire slave2_wb_we_i,
		output wire[3:0] slave2_wb_sel_i,
		output wire[31:0] slave2_wb_data_i,
		output wire[23:0] slave2_wb_adr_i,
		input wire slave2_wb_ack_o,
		input wire slave2_wb_stall_o,
		input wire slave2_wb_error_o,
		input wire[31:0] slave2_wb_data_o,

		// Slave 3
		output wire slave3_wb_cyc_i,
		output wire slave3_wb_stb_i,
		output wire slave3_wb_we_i,
		output wire[3:0] slave3_wb_sel_i,
		output wire[31:0] slave3_wb_data_i,
		output wire[23:0] slave3_wb_adr_i,
		input wire slave3_wb_ack_o,
		input wire slave3_wb_stall_o,
		input wire slave3_wb_error_o,
		input wire[31:0] slave3_wb_data_o,

		output wire[1:0] probe_master0_currentSlave,
		output wire[1:0] probe_master1_currentSlave,
		output wire[1:0] probe_master2_currentSlave,
		output wire[1:0] probe_master3_currentSlave,
		output wire[1:0] probe_slave0_currentMaster,
		output wire[1:0] probe_slave1_currentMaster,
		output wire[1:0] probe_slave2_currentMaster,
		output wire[1:0] probe_slave3_currentMaster
	);

	localparam SLAVE0_ADDRESS = 4'h0;
	localparam SLAVE1_ADDRESS = 4'h1;
	localparam SLAVE2_ADDRESS = 4'h2;
	localparam SLAVE3_ADDRESS = 4'h3;

	// Disble master3
	wire master3_wb_cyc_o = 1'b0;
	wire master3_wb_stb_o = 1'b0;
	wire master3_wb_we_o = 1'b0;
	wire[3:0] master3_wb_sel_o = 4'b0;
	wire[31:0] master3_wb_data_o = 32'b0;
	wire[27:0] master3_wb_adr_o = 28'b0;
	wire master3_wb_ack_i;
	wire master3_wb_stall_i;
	wire master3_wb_error_i;
	wire[31:0] master3_wb_data_i;

	// Master select signals
	// Master 0
	wire master0_slave0_select = master0_wb_adr_o[27:24] == SLAVE0_ADDRESS;
	wire master0_slave1_select = master0_wb_adr_o[27:24] == SLAVE1_ADDRESS;
	wire master0_slave2_select = master0_wb_adr_o[27:24] == SLAVE2_ADDRESS;
	wire master0_slave3_select = master0_wb_adr_o[27:24] == SLAVE3_ADDRESS;

	// Master 1
	wire master1_slave0_select = master1_wb_adr_o[27:24] == SLAVE0_ADDRESS;
	wire master1_slave1_select = master1_wb_adr_o[27:24] == SLAVE1_ADDRESS;
	wire master1_slave2_select = master1_wb_adr_o[27:24] == SLAVE2_ADDRESS;
	wire master1_slave3_select = master1_wb_adr_o[27:24] == SLAVE3_ADDRESS;

	// Master 2
	wire master2_slave0_select = master2_wb_adr_o[27:24] == SLAVE0_ADDRESS;
	wire master2_slave1_select = master2_wb_adr_o[27:24] == SLAVE1_ADDRESS;
	wire master2_slave2_select = master2_wb_adr_o[27:24] == SLAVE2_ADDRESS;
	wire master2_slave3_select = master2_wb_adr_o[27:24] == SLAVE3_ADDRESS;

	// Master 3
	wire master3_slave0_select = master3_wb_adr_o[27:24] == SLAVE0_ADDRESS;
	wire master3_slave1_select = master3_wb_adr_o[27:24] == SLAVE1_ADDRESS;
	wire master3_slave2_select = master3_wb_adr_o[27:24] == SLAVE2_ADDRESS;
	wire master3_slave3_select = master3_wb_adr_o[27:24] == SLAVE3_ADDRESS;

	// Slave return signals
	// Master 0
	wire master0_slave0_wb_ack_i;
	wire master0_slave0_wb_stall_i;
	wire master0_slave0_wb_error_i;
	wire[31:0] master0_slave0_wb_data_i;
	wire master0_slave1_wb_ack_i;
	wire master0_slave1_wb_stall_i;
	wire master0_slave1_wb_error_i;
	wire[31:0] master0_slave1_wb_data_i;
	wire master0_slave2_wb_ack_i;
	wire master0_slave2_wb_stall_i;
	wire master0_slave2_wb_error_i;
	wire[31:0] master0_slave2_wb_data_i;
	wire master0_slave3_wb_ack_i;
	wire master0_slave3_wb_stall_i;
	wire master0_slave3_wb_error_i;
	wire[31:0] master0_slave3_wb_data_i;

	// Master 1
	wire master1_slave0_wb_ack_i;
	wire master1_slave0_wb_stall_i;
	wire master1_slave0_wb_error_i;
	wire[31:0] master1_slave0_wb_data_i;
	wire master1_slave1_wb_ack_i;
	wire master1_slave1_wb_stall_i;
	wire master1_slave1_wb_error_i;
	wire[31:0] master1_slave1_wb_data_i;
	wire master1_slave2_wb_ack_i;
	wire master1_slave2_wb_stall_i;
	wire master1_slave2_wb_error_i;
	wire[31:0] master1_slave2_wb_data_i;
	wire master1_slave3_wb_ack_i;
	wire master1_slave3_wb_stall_i;
	wire master1_slave3_wb_error_i;
	wire[31:0] master1_slave3_wb_data_i;

	// Master 2
	wire master2_slave0_wb_ack_i;
	wire master2_slave0_wb_stall_i;
	wire master2_slave0_wb_error_i;
	wire[31:0] master2_slave0_wb_data_i;
	wire master2_slave1_wb_ack_i;
	wire master2_slave1_wb_stall_i;
	wire master2_slave1_wb_error_i;
	wire[31:0] master2_slave1_wb_data_i;
	wire master2_slave2_wb_ack_i;
	wire master2_slave2_wb_stall_i;
	wire master2_slave2_wb_error_i;
	wire[31:0] master2_slave2_wb_data_i;
	wire master2_slave3_wb_ack_i;
	wire master2_slave3_wb_stall_i;
	wire master2_slave3_wb_error_i;
	wire[31:0] master2_slave3_wb_data_i;

	// Master 3
	wire master3_slave0_wb_ack_i;
	wire master3_slave0_wb_stall_i;
	wire master3_slave0_wb_error_i;
	wire[31:0] master3_slave0_wb_data_i;
	wire master3_slave1_wb_ack_i;
	wire master3_slave1_wb_stall_i;
	wire master3_slave1_wb_error_i;
	wire[31:0] master3_slave1_wb_data_i;
	wire master3_slave2_wb_ack_i;
	wire master3_slave2_wb_stall_i;
	wire master3_slave2_wb_error_i;
	wire[31:0] master3_slave2_wb_data_i;
	wire master3_slave3_wb_ack_i;
	wire master3_slave3_wb_stall_i;
	wire master3_slave3_wb_error_i;
	wire[31:0] master3_slave3_wb_data_i;

	// Slave 0
	WishboneMultiMasterSlave slave0MultiMaster(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.master0_wb_cyc_o(master0_wb_cyc_o && master0_slave0_select),
		.master0_wb_stb_o(master0_wb_stb_o),
		.master0_wb_we_o(master0_wb_we_o),
		.master0_wb_sel_o(master0_wb_sel_o),
		.master0_wb_data_o(master0_wb_data_o),
		.master0_wb_adr_o(master0_wb_adr_o[23:0]),
		.master0_wb_ack_i(master0_slave0_wb_ack_i),
		.master0_wb_stall_i(master0_slave0_wb_stall_i),
		.master0_wb_error_i(master0_slave0_wb_error_i),
		.master0_wb_data_i(master0_slave0_wb_data_i),
		.master1_wb_cyc_o(master1_wb_cyc_o && master1_slave0_select),
		.master1_wb_stb_o(master1_wb_stb_o),
		.master1_wb_we_o(master1_wb_we_o),
		.master1_wb_sel_o(master1_wb_sel_o),
		.master1_wb_data_o(master1_wb_data_o),
		.master1_wb_adr_o(master1_wb_adr_o[23:0]),
		.master1_wb_ack_i(master1_slave0_wb_ack_i),
		.master1_wb_stall_i(master1_slave0_wb_stall_i),
		.master1_wb_error_i(master1_slave0_wb_error_i),
		.master1_wb_data_i(master1_slave0_wb_data_i),
		.master2_wb_cyc_o(master2_wb_cyc_o && master2_slave0_select),
		.master2_wb_stb_o(master2_wb_stb_o),
		.master2_wb_we_o(master2_wb_we_o),
		.master2_wb_sel_o(master2_wb_sel_o),
		.master2_wb_data_o(master2_wb_data_o),
		.master2_wb_adr_o(master2_wb_adr_o[23:0]),
		.master2_wb_ack_i(master2_slave0_wb_ack_i),
		.master2_wb_stall_i(master2_slave0_wb_stall_i),
		.master2_wb_error_i(master2_slave0_wb_error_i),
		.master2_wb_data_i(master2_slave0_wb_data_i),
		.master3_wb_cyc_o(master3_wb_cyc_o && master3_slave0_select),
		.master3_wb_stb_o(master3_wb_stb_o),
		.master3_wb_we_o(master3_wb_we_o),
		.master3_wb_sel_o(master3_wb_sel_o),
		.master3_wb_data_o(master3_wb_data_o),
		.master3_wb_adr_o(master3_wb_adr_o[23:0]),
		.master3_wb_ack_i(master3_slave0_wb_ack_i),
		.master3_wb_stall_i(master3_slave0_wb_stall_i),
		.master3_wb_error_i(master3_slave0_wb_error_i),
		.master3_wb_data_i(master3_slave0_wb_data_i),
		.slave_cyc_i(slave0_wb_cyc_i),
		.slave_stb_i(slave0_wb_stb_i),
		.slave_we_i(slave0_wb_we_i),
		.slave_sel_i(slave0_wb_sel_i),
		.slave_data_i(slave0_wb_data_i),
		.slave_adr_i(slave0_wb_adr_i),
		.slave_ack_o(slave0_wb_ack_o),
		.slave_stall_o(slave0_wb_stall_o),
		.slave_error_o(slave0_wb_error_o),
		.slave_data_o(slave0_wb_data_o),
		.probe_currentMaster(probe_slave0_currentMaster));

	// Slave 1
	WishboneMultiMasterSlave slave1MultiMaster(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.master0_wb_cyc_o(master0_wb_cyc_o && master0_slave1_select),
		.master0_wb_stb_o(master0_wb_stb_o),
		.master0_wb_we_o(master0_wb_we_o),
		.master0_wb_sel_o(master0_wb_sel_o),
		.master0_wb_data_o(master0_wb_data_o),
		.master0_wb_adr_o(master0_wb_adr_o[23:0]),
		.master0_wb_ack_i(master0_slave1_wb_ack_i),
		.master0_wb_stall_i(master0_slave1_wb_stall_i),
		.master0_wb_error_i(master0_slave1_wb_error_i),
		.master0_wb_data_i(master0_slave1_wb_data_i),
		.master1_wb_cyc_o(master1_wb_cyc_o && master1_slave1_select),
		.master1_wb_stb_o(master1_wb_stb_o),
		.master1_wb_we_o(master1_wb_we_o),
		.master1_wb_sel_o(master1_wb_sel_o),
		.master1_wb_data_o(master1_wb_data_o),
		.master1_wb_adr_o(master1_wb_adr_o[23:0]),
		.master1_wb_ack_i(master1_slave1_wb_ack_i),
		.master1_wb_stall_i(master1_slave1_wb_stall_i),
		.master1_wb_error_i(master1_slave1_wb_error_i),
		.master1_wb_data_i(master1_slave1_wb_data_i),
		.master2_wb_cyc_o(master2_wb_cyc_o && master2_slave1_select),
		.master2_wb_stb_o(master2_wb_stb_o),
		.master2_wb_we_o(master2_wb_we_o),
		.master2_wb_sel_o(master2_wb_sel_o),
		.master2_wb_data_o(master2_wb_data_o),
		.master2_wb_adr_o(master2_wb_adr_o[23:0]),
		.master2_wb_ack_i(master2_slave1_wb_ack_i),
		.master2_wb_stall_i(master2_slave1_wb_stall_i),
		.master2_wb_error_i(master2_slave1_wb_error_i),
		.master2_wb_data_i(master2_slave1_wb_data_i),
		.master3_wb_cyc_o(master3_wb_cyc_o && master3_slave1_select),
		.master3_wb_stb_o(master3_wb_stb_o),
		.master3_wb_we_o(master3_wb_we_o),
		.master3_wb_sel_o(master3_wb_sel_o),
		.master3_wb_data_o(master3_wb_data_o),
		.master3_wb_adr_o(master3_wb_adr_o[23:0]),
		.master3_wb_ack_i(master3_slave1_wb_ack_i),
		.master3_wb_stall_i(master3_slave1_wb_stall_i),
		.master3_wb_error_i(master3_slave1_wb_error_i),
		.master3_wb_data_i(master3_slave1_wb_data_i),
		.slave_cyc_i(slave1_wb_cyc_i),
		.slave_stb_i(slave1_wb_stb_i),
		.slave_we_i(slave1_wb_we_i),
		.slave_sel_i(slave1_wb_sel_i),
		.slave_data_i(slave1_wb_data_i),
		.slave_adr_i(slave1_wb_adr_i),
		.slave_ack_o(slave1_wb_ack_o),
		.slave_stall_o(slave1_wb_stall_o),
		.slave_error_o(slave1_wb_error_o),
		.slave_data_o(slave1_wb_data_o),
		.probe_currentMaster(probe_slave1_currentMaster));

	// Slave 2
	WishboneMultiMasterSlave slave2MultiMaster(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.master0_wb_cyc_o(master0_wb_cyc_o && master0_slave2_select),
		.master0_wb_stb_o(master0_wb_stb_o),
		.master0_wb_we_o(master0_wb_we_o),
		.master0_wb_sel_o(master0_wb_sel_o),
		.master0_wb_data_o(master0_wb_data_o),
		.master0_wb_adr_o(master0_wb_adr_o[23:0]),
		.master0_wb_ack_i(master0_slave2_wb_ack_i),
		.master0_wb_stall_i(master0_slave2_wb_stall_i),
		.master0_wb_error_i(master0_slave2_wb_error_i),
		.master0_wb_data_i(master0_slave2_wb_data_i),
		.master1_wb_cyc_o(master1_wb_cyc_o && master1_slave2_select),
		.master1_wb_stb_o(master1_wb_stb_o),
		.master1_wb_we_o(master1_wb_we_o),
		.master1_wb_sel_o(master1_wb_sel_o),
		.master1_wb_data_o(master1_wb_data_o),
		.master1_wb_adr_o(master1_wb_adr_o[23:0]),
		.master1_wb_ack_i(master1_slave2_wb_ack_i),
		.master1_wb_stall_i(master1_slave2_wb_stall_i),
		.master1_wb_error_i(master1_slave2_wb_error_i),
		.master1_wb_data_i(master1_slave2_wb_data_i),
		.master2_wb_cyc_o(master2_wb_cyc_o && master2_slave2_select),
		.master2_wb_stb_o(master2_wb_stb_o),
		.master2_wb_we_o(master2_wb_we_o),
		.master2_wb_sel_o(master2_wb_sel_o),
		.master2_wb_data_o(master2_wb_data_o),
		.master2_wb_adr_o(master2_wb_adr_o[23:0]),
		.master2_wb_ack_i(master2_slave2_wb_ack_i),
		.master2_wb_stall_i(master2_slave2_wb_stall_i),
		.master2_wb_error_i(master2_slave2_wb_error_i),
		.master2_wb_data_i(master2_slave2_wb_data_i),
		.master3_wb_cyc_o(master3_wb_cyc_o && master3_slave2_select),
		.master3_wb_stb_o(master3_wb_stb_o),
		.master3_wb_we_o(master3_wb_we_o),
		.master3_wb_sel_o(master3_wb_sel_o),
		.master3_wb_data_o(master3_wb_data_o),
		.master3_wb_adr_o(master3_wb_adr_o[23:0]),
		.master3_wb_ack_i(master3_slave2_wb_ack_i),
		.master3_wb_stall_i(master3_slave2_wb_stall_i),
		.master3_wb_error_i(master3_slave2_wb_error_i),
		.master3_wb_data_i(master3_slave2_wb_data_i),
		.slave_cyc_i(slave2_wb_cyc_i),
		.slave_stb_i(slave2_wb_stb_i),
		.slave_we_i(slave2_wb_we_i),
		.slave_sel_i(slave2_wb_sel_i),
		.slave_data_i(slave2_wb_data_i),
		.slave_adr_i(slave2_wb_adr_i),
		.slave_ack_o(slave2_wb_ack_o),
		.slave_stall_o(slave2_wb_stall_o),
		.slave_error_o(slave2_wb_error_o),
		.slave_data_o(slave2_wb_data_o),
		.probe_currentMaster(probe_slave2_currentMaster));

	// Slave 3
	WishboneMultiMasterSlave slave3MultiMaster(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.master0_wb_cyc_o(master0_wb_cyc_o && master0_slave3_select),
		.master0_wb_stb_o(master0_wb_stb_o),
		.master0_wb_we_o(master0_wb_we_o),
		.master0_wb_sel_o(master0_wb_sel_o),
		.master0_wb_data_o(master0_wb_data_o),
		.master0_wb_adr_o(master0_wb_adr_o[23:0]),
		.master0_wb_ack_i(master0_slave3_wb_ack_i),
		.master0_wb_stall_i(master0_slave3_wb_stall_i),
		.master0_wb_error_i(master0_slave3_wb_error_i),
		.master0_wb_data_i(master0_slave3_wb_data_i),
		.master1_wb_cyc_o(master1_wb_cyc_o && master1_slave3_select),
		.master1_wb_stb_o(master1_wb_stb_o),
		.master1_wb_we_o(master1_wb_we_o),
		.master1_wb_sel_o(master1_wb_sel_o),
		.master1_wb_data_o(master1_wb_data_o),
		.master1_wb_adr_o(master1_wb_adr_o[23:0]),
		.master1_wb_ack_i(master1_slave3_wb_ack_i),
		.master1_wb_stall_i(master1_slave3_wb_stall_i),
		.master1_wb_error_i(master1_slave3_wb_error_i),
		.master1_wb_data_i(master1_slave3_wb_data_i),
		.master2_wb_cyc_o(master2_wb_cyc_o && master2_slave3_select),
		.master2_wb_stb_o(master2_wb_stb_o),
		.master2_wb_we_o(master2_wb_we_o),
		.master2_wb_sel_o(master2_wb_sel_o),
		.master2_wb_data_o(master2_wb_data_o),
		.master2_wb_adr_o(master2_wb_adr_o[23:0]),
		.master2_wb_ack_i(master2_slave3_wb_ack_i),
		.master2_wb_stall_i(master2_slave3_wb_stall_i),
		.master2_wb_error_i(master2_slave3_wb_error_i),
		.master2_wb_data_i(master2_slave3_wb_data_i),
		.master3_wb_cyc_o(master3_wb_cyc_o && master3_slave3_select),
		.master3_wb_stb_o(master3_wb_stb_o),
		.master3_wb_we_o(master3_wb_we_o),
		.master3_wb_sel_o(master3_wb_sel_o),
		.master3_wb_data_o(master3_wb_data_o),
		.master3_wb_adr_o(master3_wb_adr_o[23:0]),
		.master3_wb_ack_i(master3_slave3_wb_ack_i),
		.master3_wb_stall_i(master3_slave3_wb_stall_i),
		.master3_wb_error_i(master3_slave3_wb_error_i),
		.master3_wb_data_i(master3_slave3_wb_data_i),
		.slave_cyc_i(slave3_wb_cyc_i),
		.slave_stb_i(slave3_wb_stb_i),
		.slave_we_i(slave3_wb_we_i),
		.slave_sel_i(slave3_wb_sel_i),
		.slave_data_i(slave3_wb_data_i),
		.slave_adr_i(slave3_wb_adr_i),
		.slave_ack_o(slave3_wb_ack_o),
		.slave_stall_o(slave3_wb_stall_o),
		.slave_error_o(slave3_wb_error_o),
		.slave_data_o(slave3_wb_data_o),
		.probe_currentMaster(probe_slave3_currentMaster));

	// Multiplex the connections back from the slave
	// Master 0
	assign master0_wb_ack_i = 	master0_slave0_select ? master0_slave0_wb_ack_i : 
								master0_slave1_select ? master0_slave1_wb_ack_i : 
								master0_slave2_select ? master0_slave2_wb_ack_i : 
								master0_slave3_select ? master0_slave3_wb_ack_i : master0_wb_cyc_o;
	assign master0_wb_stall_i = master0_slave0_select ? master0_slave0_wb_stall_i : 
								master0_slave1_select ? master0_slave1_wb_stall_i : 
								master0_slave2_select ? master0_slave2_wb_stall_i : 
								master0_slave3_select ? master0_slave3_wb_stall_i : 1'b0;
	assign master0_wb_error_i = master0_slave0_select ? master0_slave0_wb_error_i : 
								master0_slave1_select ? master0_slave1_wb_error_i : 
								master0_slave2_select ? master0_slave2_wb_error_i : 
								master0_slave3_select ? master0_slave3_wb_error_i : 1'b0;
	assign master0_wb_data_i = 	master0_slave0_select ? master0_slave0_wb_data_i : 
								master0_slave1_select ? master0_slave1_wb_data_i : 
								master0_slave2_select ? master0_slave2_wb_data_i : 
								master0_slave3_select ? master0_slave3_wb_data_i : 32'b0;

	// Master 1
	assign master1_wb_ack_i = 	master1_slave0_select ? master1_slave0_wb_ack_i : 
								master1_slave1_select ? master1_slave1_wb_ack_i : 
								master1_slave2_select ? master1_slave2_wb_ack_i : 
								master1_slave3_select ? master1_slave3_wb_ack_i : master1_wb_cyc_o;
	assign master1_wb_stall_i = master1_slave0_select ? master1_slave0_wb_stall_i : 
								master1_slave1_select ? master1_slave1_wb_stall_i : 
								master1_slave2_select ? master1_slave2_wb_stall_i : 
								master1_slave3_select ? master1_slave3_wb_stall_i : 1'b0;
	assign master1_wb_error_i = master1_slave0_select ? master1_slave0_wb_error_i : 
								master1_slave1_select ? master1_slave1_wb_error_i : 
								master1_slave2_select ? master1_slave2_wb_error_i : 
								master1_slave3_select ? master1_slave3_wb_error_i : 1'b0;
	assign master1_wb_data_i = 	master1_slave0_select ? master1_slave0_wb_data_i : 
								master1_slave1_select ? master1_slave1_wb_data_i : 
								master1_slave2_select ? master1_slave2_wb_data_i : 
								master1_slave3_select ? master1_slave3_wb_data_i : 32'b0;

	// Master 2
	assign master2_wb_ack_i = 	master2_slave0_select ? master2_slave0_wb_ack_i : 
								master2_slave1_select ? master2_slave1_wb_ack_i : 
								master2_slave2_select ? master2_slave2_wb_ack_i : 
								master2_slave3_select ? master2_slave3_wb_ack_i : master2_wb_cyc_o;
	assign master2_wb_stall_i = master2_slave0_select ? master2_slave0_wb_stall_i : 
								master2_slave1_select ? master2_slave1_wb_stall_i : 
								master2_slave2_select ? master2_slave2_wb_stall_i : 
								master2_slave3_select ? master2_slave3_wb_stall_i : 1'b0;
	assign master2_wb_error_i = master2_slave0_select ? master2_slave0_wb_error_i : 
								master2_slave1_select ? master2_slave1_wb_error_i : 
								master2_slave2_select ? master2_slave2_wb_error_i : 
								master2_slave3_select ? master2_slave3_wb_error_i : 1'b0;
	assign master2_wb_data_i = 	master2_slave0_select ? master2_slave0_wb_data_i : 
								master2_slave1_select ? master2_slave1_wb_data_i : 
								master2_slave2_select ? master2_slave2_wb_data_i : 
								master2_slave3_select ? master2_slave3_wb_data_i : 32'b0;

	// Master 3
	assign master3_wb_ack_i = 	master3_slave0_select ? master3_slave0_wb_ack_i : 
								master3_slave1_select ? master3_slave1_wb_ack_i : 
								master3_slave2_select ? master3_slave2_wb_ack_i : 
								master3_slave3_select ? master3_slave3_wb_ack_i : master3_wb_cyc_o;
	assign master3_wb_stall_i = master3_slave0_select ? master3_slave0_wb_stall_i : 
								master3_slave1_select ? master3_slave1_wb_stall_i : 
								master3_slave2_select ? master3_slave2_wb_stall_i : 
								master3_slave3_select ? master3_slave3_wb_stall_i : 1'b0;
	assign master3_wb_error_i = master3_slave0_select ? master3_slave0_wb_error_i : 
								master3_slave1_select ? master3_slave1_wb_error_i : 
								master3_slave2_select ? master3_slave2_wb_error_i : 
								master3_slave3_select ? master3_slave3_wb_error_i : 1'b0;
	assign master3_wb_data_i = 	master3_slave0_select ? master3_slave0_wb_data_i : 
								master3_slave1_select ? master3_slave1_wb_data_i : 
								master3_slave2_select ? master3_slave2_wb_data_i : 
								master3_slave3_select ? master3_slave3_wb_data_i : 32'b0;

	assign probe_master0_currentSlave = master0_wb_adr_o[25:24];
	assign probe_master1_currentSlave = master1_wb_adr_o[25:24];
	assign probe_master2_currentSlave = master2_wb_adr_o[25:24];
	assign probe_master3_currentSlave = master3_wb_adr_o[25:24];

endmodule