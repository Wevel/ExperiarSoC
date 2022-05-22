module WishboneMultiMasterSlave (
		input wire wb_clk_i,
		input wire wb_rst_i,

		// Master 0
		input wire master0_wb_cyc_o,
		input wire master0_wb_stb_o,
		input wire master0_wb_we_o,
		input wire[3:0] master0_wb_sel_o,
		input wire[31:0] master0_wb_data_o,
		input wire[23:0] master0_wb_adr_o,
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
		input wire[23:0] master1_wb_adr_o,
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
		input wire[23:0] master2_wb_adr_o,
		output wire master2_wb_ack_i,
		output wire master2_wb_stall_i,
		output wire master2_wb_error_i,
		output wire[31:0] master2_wb_data_i,

		// Master 3
		input wire master3_wb_cyc_o,
		input wire master3_wb_stb_o,
		input wire master3_wb_we_o,
		input wire[3:0] master3_wb_sel_o,
		input wire[31:0] master3_wb_data_o,
		input wire[23:0] master3_wb_adr_o,
		output wire master3_wb_ack_i,
		output wire master3_wb_stall_i,
		output wire master3_wb_error_i,
		output wire[31:0] master3_wb_data_i,

		// Slave
		output wire slave_cyc_i,
		output wire slave_stb_i,
		output wire slave_we_i,
		output wire[3:0] slave_sel_i,
		output wire[31:0] slave_data_i,
		output wire[23:0] slave_adr_i,
		input wire slave_ack_o,
		input wire slave_stall_o,
		input wire slave_error_o,
		input wire[31:0] slave_data_o,

		output wire[1:0] probe_currentMaster
	);

	wire[1:0] currentMaster;
	MasterArbiter arbiter(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.request({ master3_wb_cyc_o, master2_wb_cyc_o, master1_wb_cyc_o, master0_wb_cyc_o }),
		.masterSelected(currentMaster));
	
	wire master0Select = currentMaster == 2'h0;
	wire master1Select = currentMaster == 2'h1;
	wire master2Select = currentMaster == 2'h2;
	wire master3Select = currentMaster == 2'h3;
	
	assign slave_cyc_i =  master1Select ? master1_wb_cyc_o : 
						  master2Select ? master2_wb_cyc_o : 
						  master3Select ? master3_wb_cyc_o :
							  			  master0_wb_cyc_o;
	assign slave_stb_i =  master1Select ? master1_wb_stb_o : 
						  master2Select ? master2_wb_stb_o : 
						  master3Select ? master3_wb_stb_o :
							  			  master0_wb_stb_o;
	assign slave_we_i =   master1Select ? master1_wb_we_o : 
						  master2Select ? master2_wb_we_o : 
						  master3Select ? master3_wb_we_o :
							  			  master0_wb_we_o;
	assign slave_sel_i =  master1Select ? master1_wb_sel_o : 
						  master2Select ? master2_wb_sel_o : 
						  master3Select ? master3_wb_sel_o :
							  			  master0_wb_sel_o;
	assign slave_data_i = master1Select ? master1_wb_data_o : 
						  master2Select ? master2_wb_data_o : 
						  master3Select ? master3_wb_data_o :
							  			  master0_wb_data_o;
	assign slave_adr_i =  master1Select ? master1_wb_adr_o : 
						  master2Select ? master2_wb_adr_o : 
						  master3Select ? master3_wb_adr_o :
							  			  master0_wb_adr_o;

	// Master 0
	assign master0_wb_ack_i   = slave_ack_o;
	assign master0_wb_stall_i = slave_stall_o;
	assign master0_wb_error_i = slave_error_o;
	assign master0_wb_data_i  = slave_data_o;

	// Master 1
	assign master1_wb_ack_i   = slave_ack_o;
	assign master1_wb_stall_i = slave_stall_o;
	assign master1_wb_error_i = slave_error_o;
	assign master1_wb_data_i  = slave_data_o;

	// Master 2
	assign master2_wb_ack_i   = slave_ack_o;
	assign master2_wb_stall_i = slave_stall_o;
	assign master2_wb_error_i = slave_error_o;
	assign master2_wb_data_i  = slave_data_o;

	// Master 3
	assign master3_wb_ack_i   = slave_ack_o;
	assign master3_wb_stall_i = slave_stall_o;
	assign master3_wb_error_i = slave_error_o;
	assign master3_wb_data_i  = slave_data_o;

	// Assign logic probes
	assign probe_currentMaster = currentMaster;
endmodule