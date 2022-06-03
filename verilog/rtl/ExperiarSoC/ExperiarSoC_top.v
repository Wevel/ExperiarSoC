module ExperiarSoC (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire wb_clk_i,
		input wire wb_rst_i,

		// Caravel wishbone master
		input wire caravel_wb_cyc_o,
		input wire caravel_wb_stb_o,
		input wire caravel_wb_we_o,
		input wire[3:0] caravel_wb_sel_o,
		input wire[31:0] caravel_wb_data_o,
		input wire[27:0] caravel_wb_adr_o,
		output wire caravel_wb_ack_i,
		output wire caravel_wb_stall_i,
		output wire caravel_wb_error_i,
		output wire[31:0] caravel_wb_data_i,

		// IOs
		input  wire[`MPRJ_IO_PADS-1:0] io_in,
		output wire[`MPRJ_IO_PADS-1:0] io_out,
		output wire[`MPRJ_IO_PADS-1:0] io_oeb,
		
		// Caravel
		input wire caravel_uart_rx,
		output wire caravel_uart_tx,
		input wire[3:0] caravel_irq,

		// Logic Analyzer Signals
		input wire[127:0] la_data_in,
		output wire[127:0] la_data_out,
		input wire[127:0] la_oenb,

		// Configuration constants
		input wire[7:0] core0Index,
		input wire[7:0] core1Index,
		input wire[10:0] manufacturerID,
		input wire[15:0] partID,
		input wire[3:0] versionID
	);
	
	localparam SRAM_ADDRESS_SIZE = 9;
	
	// JTAG
	wire jtag_tck;
	wire jtag_tms;
	wire jtag_tdi;
	wire jtag_tdo;

	// Flash
	wire flash_csb;
	wire flash_sck;
	wire flash_io0_we;
	wire flash_io0_write;
	wire flash_io0_read;
	wire flash_io1_we;
	wire flash_io1_write;
	wire flash_io1_read;

	// IRQ
	// wire irq_en;
	// wire irq_in;
	wire[15:0] irq;

	// Wishbone wires
	// Master 0: Caravel

	// Master 1: Core 0
	wire core0_wb_cyc_o;
	wire core0_wb_stb_o;
	wire core0_wb_we_o;
	wire[3:0] core0_wb_sel_o;
	wire[31:0] core0_wb_data_o;
	wire[27:0] core0_wb_adr_o;
	wire core0_wb_ack_i;
	wire core0_wb_stall_i;
	wire core0_wb_error_i;
	wire[31:0] core0_wb_data_i;

	// Master 2: Core 1
	wire core1_wb_cyc_o;
	wire core1_wb_stb_o;
	wire core1_wb_we_o;
	wire[3:0] core1_wb_sel_o;
	wire[31:0] core1_wb_data_o;
	wire[27:0] core1_wb_adr_o;
	wire core1_wb_ack_i;
	wire core1_wb_stall_i;
	wire core1_wb_error_i;
	wire[31:0] core1_wb_data_i;

	// Master 3: dma
	// wire dma_wb_cyc_o = 1'b0;
	// wire dma_wb_stb_o = 1'b0;
	// wire dma_wb_we_o = 1'b0;
	// wire[3:0] dma_wb_sel_o = 4'b0;
	// wire[31:0] dma_wb_data_o = 32'b0;
	// wire[27:0] dma_wb_adr_o = 28'b0;
	// wire dma_wb_ack_i;
	// wire dma_wb_stall_i;
	// wire dma_wb_error_i;
	// wire[31:0] dma_wb_data_i;

	// Slave 0
	wire core0Memory_wb_cyc_i;
	wire core0Memory_wb_stb_i;
	wire core0Memory_wb_we_i;
	wire[3:0] core0Memory_wb_sel_i;
	wire[31:0] core0Memory_wb_data_i;
	wire[23:0] core0Memory_wb_adr_i;
	wire core0Memory_wb_ack_o;
	wire core0Memory_wb_stall_o;
	wire core0Memory_wb_error_o;
	wire[31:0] core0Memory_wb_data_o;

	// Slave 1
	wire core1Memory_wb_cyc_i;
	wire core1Memory_wb_stb_i;
	wire core1Memory_wb_we_i;
	wire[3:0] core1Memory_wb_sel_i;
	wire[31:0] core1Memory_wb_data_i;
	wire[23:0] core1Memory_wb_adr_i;
	wire core1Memory_wb_ack_o;
	wire core1Memory_wb_stall_o;
	wire core1Memory_wb_error_o;
	wire[31:0] core1Memory_wb_data_o;

	// Slave 2
	wire videoMemory_wb_cyc_i;
	wire videoMemory_wb_stb_i;
	wire videoMemory_wb_we_i;
	wire[3:0] videoMemory_wb_sel_i;
	wire[31:0] videoMemory_wb_data_i;
	wire[23:0] videoMemory_wb_adr_i;
	wire videoMemory_wb_ack_o;
	wire videoMemory_wb_stall_o;
	wire videoMemory_wb_error_o;
	wire[31:0] videoMemory_wb_data_o;

	// Slave 3
	wire peripherals_wb_cyc_i;
	wire peripherals_wb_stb_i;
	wire peripherals_wb_we_i;
	wire[3:0] peripherals_wb_sel_i;
	wire[31:0] peripherals_wb_data_i;
	wire[23:0] peripherals_wb_adr_i;
	wire peripherals_wb_ack_o;
	wire peripherals_wb_stall_o;
	wire peripherals_wb_error_o;
	wire[31:0] peripherals_wb_data_o;

	// Slave 4
	wire flash_wb_cyc_i;
	wire flash_wb_stb_i;
	wire flash_wb_we_i;
	wire[3:0] flash_wb_sel_i;
	wire[31:0] flash_wb_data_i;
	wire[23:0] flash_wb_adr_i;
	wire flash_wb_ack_o;
	wire flash_wb_stall_o;
	wire flash_wb_error_o;
	wire[31:0] flash_wb_data_o;

	// wire[2:0] probe_master0_currentSlave;
	// wire[2:0] probe_master1_currentSlave;
	// wire[2:0] probe_master2_currentSlave;
	// wire[2:0] probe_master3_currentSlave;
	// wire[1:0] probe_slave0_currentMaster;
	// wire[1:0] probe_slave1_currentMaster;
	// wire[1:0] probe_slave2_currentMaster;
	// wire[1:0] probe_slave3_currentMaster;
	// wire[1:0] probe_slave4_currentMaster;

	// wire[15:0] probe_wishboneInterconnect = {
	// 	probe_slave3_currentMaster,
	// 	probe_slave2_currentMaster,
	// 	probe_slave1_currentMaster,
	// 	probe_slave0_currentMaster,
	// 	probe_master3_currentSlave[1:0],
	// 	probe_master2_currentSlave[1:0],
	// 	probe_master1_currentSlave[1:0],
	// 	probe_master0_currentSlave[1:0]
	// };

	wire[1:0] probe_master0_currentSlave;
	wire[1:0] probe_master1_currentSlave;
	wire[1:0] probe_master2_currentSlave;
	wire[1:0] probe_master3_currentSlave;
	wire[1:0] probe_slave0_currentMaster;
	wire[1:0] probe_slave1_currentMaster;
	wire[1:0] probe_slave2_currentMaster;
	wire[1:0] probe_slave3_currentMaster;

	wire[15:0] probe_wishboneInterconnect = {
		probe_slave3_currentMaster,
		probe_slave2_currentMaster,
		probe_slave1_currentMaster,
		probe_slave0_currentMaster,
		probe_master3_currentSlave,
		probe_master2_currentSlave,
		probe_master1_currentSlave,
		probe_master0_currentSlave
	};

	//-------------------------------------------------//
	//---------------------Wishbone--------------------//
	//-------------------------------------------------//

	WishboneInterconnect wishboneInterconnect(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.master0_wb_cyc_o(caravel_wb_cyc_o),
		.master0_wb_stb_o(caravel_wb_stb_o),
		.master0_wb_we_o(caravel_wb_we_o),
		.master0_wb_sel_o(caravel_wb_sel_o),
		.master0_wb_data_o(caravel_wb_data_o),
		.master0_wb_adr_o(caravel_wb_adr_o),
		.master0_wb_ack_i(caravel_wb_ack_i),
		.master0_wb_stall_i(caravel_wb_stall_i),
		.master0_wb_error_i(caravel_wb_error_i),
		.master0_wb_data_i(caravel_wb_data_i),
		.master1_wb_cyc_o(core0_wb_cyc_o),
		.master1_wb_stb_o(core0_wb_stb_o),
		.master1_wb_we_o(core0_wb_we_o),
		.master1_wb_sel_o(core0_wb_sel_o),
		.master1_wb_data_o(core0_wb_data_o),
		.master1_wb_adr_o(core0_wb_adr_o),
		.master1_wb_ack_i(core0_wb_ack_i),
		.master1_wb_stall_i(core0_wb_stall_i),
		.master1_wb_error_i(core0_wb_error_i),
		.master1_wb_data_i(core0_wb_data_i),
		.master2_wb_cyc_o(core1_wb_cyc_o),
		.master2_wb_stb_o(core1_wb_stb_o),
		.master2_wb_we_o(core1_wb_we_o),
		.master2_wb_sel_o(core1_wb_sel_o),
		.master2_wb_data_o(core1_wb_data_o),
		.master2_wb_adr_o(core1_wb_adr_o),
		.master2_wb_ack_i(core1_wb_ack_i),
		.master2_wb_stall_i(core1_wb_stall_i),
		.master2_wb_error_i(core1_wb_error_i),
		.master2_wb_data_i(core1_wb_data_i),
		// .master3_wb_cyc_o(dma_wb_cyc_o),
		// .master3_wb_stb_o(dma_wb_stb_o),
		// .master3_wb_we_o(dma_wb_we_o),
		// .master3_wb_sel_o(dma_wb_sel_o),
		// .master3_wb_data_o(dma_wb_data_o),
		// .master3_wb_adr_o(dma_wb_adr_o),
		// .master3_wb_ack_i(dma_wb_ack_i),
		// .master3_wb_stall_i(dma_wb_stall_i),
		// .master3_wb_error_i(dma_wb_error_i),
		// .master3_wb_data_i(dma_wb_data_i),
		.slave0_wb_cyc_i(core0Memory_wb_cyc_i),
		.slave0_wb_stb_i(core0Memory_wb_stb_i),
		.slave0_wb_we_i(core0Memory_wb_we_i),
		.slave0_wb_sel_i(core0Memory_wb_sel_i),
		.slave0_wb_data_i(core0Memory_wb_data_i),
		.slave0_wb_adr_i(core0Memory_wb_adr_i),
		.slave0_wb_ack_o(core0Memory_wb_ack_o),
		.slave0_wb_stall_o(core0Memory_wb_stall_o),
		.slave0_wb_error_o(core0Memory_wb_error_o),
		.slave0_wb_data_o(core0Memory_wb_data_o),
		.slave1_wb_cyc_i(core1Memory_wb_cyc_i),
		.slave1_wb_stb_i(core1Memory_wb_stb_i),
		.slave1_wb_we_i(core1Memory_wb_we_i),
		.slave1_wb_sel_i(core1Memory_wb_sel_i),
		.slave1_wb_data_i(core1Memory_wb_data_i),
		.slave1_wb_adr_i(core1Memory_wb_adr_i),
		.slave1_wb_ack_o(core1Memory_wb_ack_o),
		.slave1_wb_stall_o(core1Memory_wb_stall_o),
		.slave1_wb_error_o(core1Memory_wb_error_o),
		.slave1_wb_data_o(core1Memory_wb_data_o),
		.slave2_wb_cyc_i(videoMemory_wb_cyc_i),
		.slave2_wb_stb_i(videoMemory_wb_stb_i),
		.slave2_wb_we_i(videoMemory_wb_we_i),
		.slave2_wb_sel_i(videoMemory_wb_sel_i),
		.slave2_wb_data_i(videoMemory_wb_data_i),
		.slave2_wb_adr_i(videoMemory_wb_adr_i),
		.slave2_wb_ack_o(videoMemory_wb_ack_o),
		.slave2_wb_stall_o(videoMemory_wb_stall_o),
		.slave2_wb_error_o(videoMemory_wb_error_o),
		.slave2_wb_data_o(videoMemory_wb_data_o),
		.slave3_wb_cyc_i(peripherals_wb_cyc_i),
		.slave3_wb_stb_i(peripherals_wb_stb_i),
		.slave3_wb_we_i(peripherals_wb_we_i),
		.slave3_wb_sel_i(peripherals_wb_sel_i),
		.slave3_wb_data_i(peripherals_wb_data_i),
		.slave3_wb_adr_i(peripherals_wb_adr_i),
		.slave3_wb_ack_o(peripherals_wb_ack_o),
		.slave3_wb_stall_o(peripherals_wb_stall_o),
		.slave3_wb_error_o(peripherals_wb_error_o),
		.slave3_wb_data_o(peripherals_wb_data_o),
		.slave4_wb_cyc_i(flash_wb_cyc_i),
		.slave4_wb_stb_i(flash_wb_stb_i),
		.slave4_wb_we_i(flash_wb_we_i),
		.slave4_wb_sel_i(flash_wb_sel_i),
		.slave4_wb_data_i(flash_wb_data_i),
		.slave4_wb_adr_i(flash_wb_adr_i),
		.slave4_wb_ack_o(flash_wb_ack_o),
		.slave4_wb_stall_o(flash_wb_stall_o),
		.slave4_wb_error_o(flash_wb_error_o),
		.slave4_wb_data_o(flash_wb_data_o),
		.probe_master0_currentSlave(probe_master0_currentSlave),
		.probe_master1_currentSlave(probe_master1_currentSlave),
		.probe_master2_currentSlave(probe_master2_currentSlave),
		.probe_master3_currentSlave(probe_master3_currentSlave),
		.probe_slave0_currentMaster(probe_slave0_currentMaster),
		.probe_slave1_currentMaster(probe_slave1_currentMaster),
		.probe_slave2_currentMaster(probe_slave2_currentMaster),
		.probe_slave3_currentMaster(probe_slave3_currentMaster));//,
		//.probe_slave4_currentMaster(probe_slave4_currentMaster));

	//-------------------------------------------------//
	//----------------------CORE0----------------------//
	//-------------------------------------------------//
	
	// JTAG interface
	wire core0_tdi;
	wire core0_tdo;

	// SRAM rw port
	wire core0SRAM_clk0;
	wire[1:0] core0SRAM_csb0;
	wire core0SRAM_web0;
	wire[3:0] core0SRAM_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] core0SRAM_addr0;
	wire[31:0] core0SRAM_din0;
	wire[63:0] core0SRAM_dout0;

	// SRAM r port
	wire core0SRAM_clk1;
	wire[1:0] core0SRAM_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] core0SRAM_addr1;
	wire[63:0] core0SRAM_dout1;

	// Logic probes
	wire[1:0] probe_core0_state;
	wire[1:0] probe_core0_env;
	wire[31:0] probe_core0_programCounter;
	wire[6:0] probe_core0_opcode;
	wire[1:0] probe_core0_errorCode;
	wire probe_core0_isBranch;
	wire probe_core0_takeBranch;
	wire probe_core0_isStore;
	wire probe_core0_isLoad;
	wire probe_core0_isCompressed;
	wire[4:0] probe_core0_jtagInstruction;

	wire[54:0] probe_core0 = {
		probe_core0_state,
		probe_core0_env,
		probe_core0_programCounter,
		probe_core0_opcode,
		probe_core0_errorCode,
		probe_core0_isBranch,
		probe_core0_takeBranch,
		probe_core0_isStore,
		probe_core0_isLoad,
		probe_core0_isCompressed,
		probe_core0_jtagInstruction
	};

	ExperiarCore core0 (
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.coreIndex(core0Index),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.jtag_tck(jtag_tck),
		.jtag_tms(jtag_tms),
		.jtag_tdi(core0_tdi),
		.jtag_tdo(core0_tdo),
		.irq(irq),
		.core_wb_cyc_o(core0_wb_cyc_o),
		.core_wb_stb_o(core0_wb_stb_o),
		.core_wb_we_o(core0_wb_we_o),
		.core_wb_sel_o(core0_wb_sel_o),
		.core_wb_data_o(core0_wb_data_o),
		.core_wb_adr_o(core0_wb_adr_o),
		.core_wb_ack_i(core0_wb_ack_i),
		.core_wb_stall_i(core0_wb_stall_i),
		.core_wb_error_i(core0_wb_error_i),
		.core_wb_data_i(core0_wb_data_i),
		.localMemory_wb_cyc_i(core0Memory_wb_cyc_i),
		.localMemory_wb_stb_i(core0Memory_wb_stb_i),
		.localMemory_wb_we_i(core0Memory_wb_we_i),
		.localMemory_wb_sel_i(core0Memory_wb_sel_i),
		.localMemory_wb_data_i(core0Memory_wb_data_i),
		.localMemory_wb_adr_i(core0Memory_wb_adr_i),
		.localMemory_wb_ack_o(core0Memory_wb_ack_o),
		.localMemory_wb_stall_o(core0Memory_wb_stall_o),
		.localMemory_wb_error_o(core0Memory_wb_error_o),
		.localMemory_wb_data_o(core0Memory_wb_data_o),
		.clk0(core0SRAM_clk0),
		.csb0(core0SRAM_csb0),
		.web0(core0SRAM_web0),
		.wmask0(core0SRAM_wmask0),
		.addr0(core0SRAM_addr0),
		.din0(core0SRAM_din0),
		.dout0(core0SRAM_dout0),
		.clk1(core0SRAM_clk1),
		.csb1(core0SRAM_csb1),
		.addr1(core0SRAM_addr1),
		.dout1(core0SRAM_dout1),
		.probe_state(probe_core0_state),
		.probe_env(probe_core0_env),
		.probe_programCounter(probe_core0_programCounter),
		.probe_opcode(probe_core0_opcode),
		.probe_errorCode(probe_core0_errorCode),
		.probe_isBranch(probe_core0_isBranch),
		.probe_takeBranch(probe_core0_takeBranch),
		.probe_isStore(probe_core0_isStore),
		.probe_isLoad(probe_core0_isLoad),
		.probe_isCompressed(probe_core0_isCompressed),
		.probe_jtagInstruction(probe_core0_jtagInstruction));

	wire[31:0] core0SRAM0_dout0;
	wire[31:0] core0SRAM0_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 core0SRAM0(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(core0SRAM_clk0),
		.csb0(core0SRAM_csb0[0]),
		.web0(core0SRAM_web0),
		.wmask0(core0SRAM_wmask0),
		.addr0(core0SRAM_addr0),
		.din0(core0SRAM_din0),
		.dout0(core0SRAM0_dout0),
		.clk1(core0SRAM_clk1),
		.csb1(core0SRAM_csb1[0]),
		.addr1(core0SRAM_addr1),
		.dout1(core0SRAM0_dout1));

	wire[31:0] core0SRAM1_dout0;
	wire[31:0] core0SRAM1_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 core0SRAM1(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(core0SRAM_clk0),
		.csb0(core0SRAM_csb0[1]),
		.web0(core0SRAM_web0),
		.wmask0(core0SRAM_wmask0),
		.addr0(core0SRAM_addr0),
		.din0(core0SRAM_din0),
		.dout0(core0SRAM1_dout0),
		.clk1(core0SRAM_clk1),
		.csb1(core0SRAM_csb1[1]),
		.addr1(core0SRAM_addr1),
		.dout1(core0SRAM1_dout1));

	assign core0SRAM_dout0 = { core0SRAM1_dout0, core0SRAM0_dout0 };
	assign core0SRAM_dout1 = { core0SRAM1_dout1, core0SRAM0_dout1 };

	//-------------------------------------------------//
	//----------------------CORE1----------------------//
	//-------------------------------------------------//
	
	// JTAG interface
	wire core1_tdi;
	wire core1_tdo;
	
	// SRAM rw port
	wire core1SRAM_clk0;
	wire[1:0] core1SRAM_csb0;
	wire core1SRAM_web0;
	wire[3:0] core1SRAM_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] core1SRAM_addr0;
	wire[31:0] core1SRAM_din0;
	wire[63:0] core1SRAM_dout0;

	// SRAM r port
	wire core1SRAM_clk1;
	wire[1:0] core1SRAM_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] core1SRAM_addr1;
	wire[63:0] core1SRAM_dout1;

	// Logic probes
	wire[1:0] probe_core1_state;
	wire[1:0] probe_core1_env;
	wire[31:0] probe_core1_programCounter;
	wire[6:0] probe_core1_opcode;
	wire[1:0] probe_core1_errorCode;
	wire probe_core1_isBranch;
	wire probe_core1_takeBranch;
	wire probe_core1_isStore;
	wire probe_core1_isLoad;
	wire probe_core1_isCompressed;
	wire[4:0] probe_core1_jtagInstruction;

	wire[54:0] probe_core1 = {
		probe_core1_state,
		probe_core1_env,
		probe_core1_programCounter,
		probe_core1_opcode,
		probe_core1_errorCode,
		probe_core1_isBranch,
		probe_core1_takeBranch,
		probe_core1_isStore,
		probe_core1_isLoad,
		probe_core1_isCompressed,
		probe_core1_jtagInstruction
	};

	ExperiarCore core1 (
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.coreIndex(core1Index),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.jtag_tck(jtag_tck),
		.jtag_tms(jtag_tms),
		.jtag_tdi(core1_tdi),
		.jtag_tdo(core1_tdo),
		.irq(irq),
		.core_wb_cyc_o(core1_wb_cyc_o),
		.core_wb_stb_o(core1_wb_stb_o),
		.core_wb_we_o(core1_wb_we_o),
		.core_wb_sel_o(core1_wb_sel_o),
		.core_wb_data_o(core1_wb_data_o),
		.core_wb_adr_o(core1_wb_adr_o),
		.core_wb_ack_i(core1_wb_ack_i),
		.core_wb_stall_i(core1_wb_stall_i),
		.core_wb_error_i(core1_wb_error_i),
		.core_wb_data_i(core1_wb_data_i),
		.localMemory_wb_cyc_i(core1Memory_wb_cyc_i),
		.localMemory_wb_stb_i(core1Memory_wb_stb_i),
		.localMemory_wb_we_i(core1Memory_wb_we_i),
		.localMemory_wb_sel_i(core1Memory_wb_sel_i),
		.localMemory_wb_data_i(core1Memory_wb_data_i),
		.localMemory_wb_adr_i(core1Memory_wb_adr_i),
		.localMemory_wb_ack_o(core1Memory_wb_ack_o),
		.localMemory_wb_stall_o(core1Memory_wb_stall_o),
		.localMemory_wb_error_o(core1Memory_wb_error_o),
		.localMemory_wb_data_o(core1Memory_wb_data_o),
		.clk0(core1SRAM_clk0),
		.csb0(core1SRAM_csb0),
		.web0(core1SRAM_web0),
		.wmask0(core1SRAM_wmask0),
		.addr0(core1SRAM_addr0),
		.din0(core1SRAM_din0),
		.dout0(core1SRAM_dout0),
		.clk1(core1SRAM_clk1),
		.csb1(core1SRAM_csb1),
		.addr1(core1SRAM_addr1),
		.dout1(core1SRAM_dout1),
		.probe_state(probe_core1_state),
		.probe_env(probe_core1_env),
		.probe_programCounter(probe_core1_programCounter),
		.probe_opcode(probe_core1_opcode),
		.probe_errorCode(probe_core1_errorCode),
		.probe_isBranch(probe_core1_isBranch),
		.probe_takeBranch(probe_core1_takeBranch),
		.probe_isStore(probe_core1_isStore),
		.probe_isLoad(probe_core1_isLoad),
		.probe_isCompressed(probe_core1_isCompressed),
		.probe_jtagInstruction(probe_core1_jtagInstruction));

	wire[31:0] core1SRAM0_dout0;
	wire[31:0] core1SRAM0_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 core1SRAM0(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(core1SRAM_clk0),
		.csb0(core1SRAM_csb0[0]),
		.web0(core1SRAM_web0),
		.wmask0(core1SRAM_wmask0),
		.addr0(core1SRAM_addr0),
		.din0(core1SRAM_din0),
		.dout0(core1SRAM0_dout0),
		.clk1(core1SRAM_clk1),
		.csb1(core1SRAM_csb1[0]),
		.addr1(core1SRAM_addr1),
		.dout1(core1SRAM0_dout1));

	wire[31:0] core1SRAM1_dout0;
	wire[31:0] core1SRAM1_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 core1SRAM1(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(core1SRAM_clk0),
		.csb0(core1SRAM_csb0[1]),
		.web0(core1SRAM_web0),
		.wmask0(core1SRAM_wmask0),
		.addr0(core1SRAM_addr0),
		.din0(core1SRAM_din0),
		.dout0(core1SRAM1_dout0),
		.clk1(core1SRAM_clk1),
		.csb1(core1SRAM_csb1[1]),
		.addr1(core1SRAM_addr1),
		.dout1(core1SRAM1_dout1));

	assign core1SRAM_dout0 = { core1SRAM1_dout0, core1SRAM0_dout0 };
	assign core1SRAM_dout1 = { core1SRAM1_dout1, core1SRAM0_dout1 };

	//-------------------------------------------------//
	//----------------------Flash----------------------//
	//-------------------------------------------------//

	// Video SRAM rw port
	wire flashSRAM_clk0;
	wire flashSRAM_csb0;
	wire flashSRAM_web0;
	wire[3:0] flashSRAM_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] flashSRAM_addr0;
	wire[31:0] flashSRAM_din0;
	wire[31:0] flashSRAM_dout0;

	// Video SRAM r port
	wire flashSRAM_clk1;
	wire flashSRAM_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] flashSRAM_addr1;
	wire[31:0] flashSRAM_dout1;

	Flash flash(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_stb_i(flash_wb_stb_i),
		.wb_cyc_i(flash_wb_cyc_i),
		.wb_we_i(flash_wb_we_i),
		.wb_sel_i(flash_wb_sel_i),
		.wb_data_i(flash_wb_data_i),
		.wb_adr_i(flash_wb_adr_i),
		.wb_ack_o(flash_wb_ack_o),
		.wb_stall_o(flash_wb_stall_o),
		.wb_error_o(flash_wb_error_o),
		.wb_data_o(flash_wb_data_o),
		.flash_csb(flash_csb),
		.flash_sck(flash_sck),
		.flash_io0_we(flash_io0_we),
		.flash_io0_write(flash_io0_write),
		.flash_io0_read(flash_io0_read),
		.flash_io1_we(flash_io1_we),
		.flash_io1_write(flash_io1_write),
		.flash_io1_read(flash_io1_read),
		.sram_clk0(flashSRAM_clk0),
		.sram_csb0(flashSRAM_csb0),
		.sram_web0(flashSRAM_web0),
		.sram_wmask0(flashSRAM_wmask0),
		.sram_addr0(flashSRAM_addr0),
		.sram_din0(flashSRAM_din0),
		.sram_dout0(flashSRAM_dout0),
		.sram_clk1(flashSRAM_clk1),
		.sram_csb1(flashSRAM_csb1),
		.sram_addr1(flashSRAM_addr1),
		.sram_dout1(flashSRAM_dout1));

		sky130_sram_2kbyte_1rw1r_32x512_8 flashSRAM(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(flashSRAM_clk0),
		.csb0(flashSRAM_csb0),
		.web0(flashSRAM_web0),
		.wmask0(flashSRAM_wmask0),
		.addr0(flashSRAM_addr0),
		.din0(flashSRAM_din0),
		.dout0(flashSRAM_dout0),
		.clk1(flashSRAM_clk1),
		.csb1(flashSRAM_csb1),
		.addr1(flashSRAM_addr1),
		.dout1(flashSRAM_dout1)
	);

	//-------------------------------------------------//
	//----------------------Video----------------------//
	//-------------------------------------------------//

	// VGA
	wire[1:0] vga_r;
	wire[1:0] vga_g;
	wire[1:0] vga_b;
	wire vga_vsync;
	wire vga_hsync;

	// Left Video SRAM rw port
	wire videoSRAMLeft_clk0;
	wire[1:0] videoSRAMLeft_csb0;
	wire videoSRAMLeft_web0;
	wire[3:0] videoSRAMLeft_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] videoSRAMLeft_addr0;
	wire[31:0] videoSRAMLeft_din0;
	wire[63:0] videoSRAMLeft_dout0;

	// Left Video SRAM r port
	wire videoSRAMLeft_clk1;
	wire[1:0] videoSRAMLeft_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] videoSRAMLeft_addr1;
	wire[63:0] videoSRAMLeft_dout1;

	// Right Video SRAM rw port
	wire videoSRAMRight_clk0;
	wire[1:0] videoSRAMRight_csb0;
	wire videoSRAMRight_web0;
	wire[3:0] videoSRAMRight_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] videoSRAMRight_addr0;
	wire[31:0] videoSRAMRight_din0;
	wire[63:0] videoSRAMRight_dout0;

	// Right Video SRAM r port
	wire videoSRAMRight_clk1;
	wire[1:0] videoSRAMRight_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] videoSRAMRight_addr1;
	wire[63:0] videoSRAMRight_dout1;

	wire[1:0] video_irq;
	Video video(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_stb_i(videoMemory_wb_stb_i),
		.wb_cyc_i(videoMemory_wb_cyc_i),
		.wb_we_i(videoMemory_wb_we_i),
		.wb_sel_i(videoMemory_wb_sel_i),
		.wb_data_i(videoMemory_wb_data_i),
		.wb_adr_i(videoMemory_wb_adr_i),
		.wb_ack_o(videoMemory_wb_ack_o),
		.wb_stall_o(videoMemory_wb_stall_o),
		.wb_error_o(videoMemory_wb_error_o),
		.wb_data_o(videoMemory_wb_data_o),
		.video_irq(video_irq),
		.sram0_clk0(videoSRAMLeft_clk0),
		.sram0_csb0(videoSRAMLeft_csb0),
		.sram0_web0(videoSRAMLeft_web0),
		.sram0_wmask0(videoSRAMLeft_wmask0),
		.sram0_addr0(videoSRAMLeft_addr0),
		.sram0_din0(videoSRAMLeft_din0),
		.sram0_dout0(videoSRAMLeft_dout0),
		.sram0_clk1(videoSRAMLeft_clk1),
		.sram0_csb1(videoSRAMLeft_csb1),
		.sram0_addr1(videoSRAMLeft_addr1),
		.sram0_dout1(videoSRAMLeft_dout1),
		.sram1_clk0(videoSRAMRight_clk0),
		.sram1_csb0(videoSRAMRight_csb0),
		.sram1_web0(videoSRAMRight_web0),
		.sram1_wmask0(videoSRAMRight_wmask0),
		.sram1_addr0(videoSRAMRight_addr0),
		.sram1_din0(videoSRAMRight_din0),
		.sram1_dout0(videoSRAMRight_dout0),
		.sram1_clk1(videoSRAMRight_clk1),
		.sram1_csb1(videoSRAMRight_csb1),
		.sram1_addr1(videoSRAMRight_addr1),
		.sram1_dout1(videoSRAMRight_dout1),
		//.vga_clk(wb_clk_i),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync));

	wire[31:0] videoSRAM0_dout0;
	wire[31:0] videoSRAM0_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 videoSRAM0(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(videoSRAMLeft_clk0),
		.csb0(videoSRAMLeft_csb0[0]),
		.web0(videoSRAMLeft_web0),
		.wmask0(videoSRAMLeft_wmask0),
		.addr0(videoSRAMLeft_addr0),
		.din0(videoSRAMLeft_din0),
		.dout0(videoSRAM0_dout0),
		.clk1(videoSRAMLeft_clk1),
		.csb1(videoSRAMLeft_csb1[0]),
		.addr1(videoSRAMLeft_addr1),
		.dout1(videoSRAM0_dout1)
	);

	wire[31:0] videoSRAM1_dout0;
	wire[31:0] videoSRAM1_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 videoSRAM1(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(videoSRAMLeft_clk0),
		.csb0(videoSRAMLeft_csb0[1]),
		.web0(videoSRAMLeft_web0),
		.wmask0(videoSRAMLeft_wmask0),
		.addr0(videoSRAMLeft_addr0),
		.din0(videoSRAMLeft_din0),
		.dout0(videoSRAM1_dout0),
		.clk1(videoSRAMLeft_clk1),
		.csb1(videoSRAMLeft_csb1[1]),
		.addr1(videoSRAMLeft_addr1),
		.dout1(videoSRAM1_dout1)
	);

	assign videoSRAMLeft_dout0 = { videoSRAM1_dout0, videoSRAM0_dout0 };
	assign videoSRAMLeft_dout1 = { videoSRAM1_dout1, videoSRAM0_dout1 };

	wire[31:0] videoSRAM2_dout0;
	wire[31:0] videoSRAM2_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 videoSRAM2(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(videoSRAMRight_clk0),
		.csb0(videoSRAMRight_csb0[0]),
		.web0(videoSRAMRight_web0),
		.wmask0(videoSRAMRight_wmask0),
		.addr0(videoSRAMRight_addr0),
		.din0(videoSRAMRight_din0),
		.dout0(videoSRAM2_dout0),
		.clk1(videoSRAMRight_clk1),
		.csb1(videoSRAMRight_csb1[0]),
		.addr1(videoSRAMRight_addr1),
		.dout1(videoSRAM2_dout1)
	);

	wire[31:0] videoSRAM3_dout0;
	wire[31:0] videoSRAM3_dout1;
	sky130_sram_2kbyte_1rw1r_32x512_8 videoSRAM3(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk0(videoSRAMRight_clk0),
		.csb0(videoSRAMRight_csb0[1]),
		.web0(videoSRAMRight_web0),
		.wmask0(videoSRAMRight_wmask0),
		.addr0(videoSRAMRight_addr0),
		.din0(videoSRAMRight_din0),
		.dout0(videoSRAM3_dout0),
		.clk1(videoSRAMRight_clk1),
		.csb1(videoSRAMRight_csb1[1]),
		.addr1(videoSRAMRight_addr1),
		.dout1(videoSRAM3_dout1)
	);

	assign videoSRAMRight_dout0 = { videoSRAM3_dout0, videoSRAM2_dout0 };
	assign videoSRAMRight_dout1 = { videoSRAM3_dout1, videoSRAM2_dout1 };

	//-------------------------------------------------//
	//-------------------Peripherals-------------------//
	//-------------------------------------------------//
	wire[1:0] probe_blink;
	wire[9:0] peripheral_irq;
	Peripherals peripherals(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_stb_i(peripherals_wb_stb_i),
		.wb_cyc_i(peripherals_wb_cyc_i),
		.wb_we_i(peripherals_wb_we_i),
		.wb_sel_i(peripherals_wb_sel_i),
		.wb_data_i(peripherals_wb_data_i),
		.wb_adr_i(peripherals_wb_adr_i),
		.wb_ack_o(peripherals_wb_ack_o),
		.wb_stall_o(peripherals_wb_stall_o),
		.wb_error_o(peripherals_wb_error_o),
		.wb_data_o(peripherals_wb_data_o),
		.io_in(io_in),
		.io_out(io_out),
		.io_oeb(io_oeb),
		.internal_uart_rx(caravel_uart_rx),
		.internal_uart_tx(caravel_uart_tx),
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
		//.irq_en(irq_en),
		//.irq_in(irq_in),
		.peripheral_irq(peripheral_irq),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync),
		.probe_blink(probe_blink));

	//-------------------------------------------------//
	//-----------------------DMA-----------------------//
	//-------------------------------------------------//

	//DMA dma();

	assign core0_tdi = jtag_tdi;
	assign core1_tdi = core0_tdo;
	assign jtag_tdo = core1_tdo;

	assign la_data_out = {
		probe_core1,				// 55
		probe_core0,				// 55
		probe_wishboneInterconnect,	// 16
		probe_blink					// 2
	};

	//-------------------------------------------------//
	//-----------------------IRQ-----------------------//
	//-------------------------------------------------//

	assign irq = { caravel_irq, video_irq, peripheral_irq };

endmodule