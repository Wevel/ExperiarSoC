module ExperiarCore (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire wb_clk_i,
		input wire wb_rst_i,

		input wire[7:0] coreIndex,
		input wire[10:0] manufacturerID,
		input wire[15:0] partID,
		input wire[3:0] versionID,

		// JTAG interface
		input wire jtag_tck,
		input wire jtag_tms,
		input wire jtag_tdi,
		output wire jtag_tdo,

		// Interrupts
		//input wire[15:0] userInterrupts,

		// Wishbone master interface from core
		output wire core_wb_cyc_o,
		output wire core_wb_stb_o,
		output wire core_wb_we_o,
		output wire[3:0] core_wb_sel_o,
		output wire[31:0] core_wb_data_o,
		output wire[27:0] core_wb_adr_o,
		input wire core_wb_ack_i,
		input wire core_wb_stall_i,
		input wire core_wb_error_i,
		input wire[31:0] core_wb_data_i,

		// Wishbone slave interface to sram
		input wire localMemory_wb_cyc_i,
		input wire localMemory_wb_stb_i,
		input wire localMemory_wb_we_i,
		input wire[3:0] localMemory_wb_sel_i,
		input wire[31:0] localMemory_wb_data_i,
		input wire[23:0] localMemory_wb_adr_i,
		output wire localMemory_wb_ack_o,
		output wire localMemory_wb_stall_o,
		output wire localMemory_wb_error_o,
		output wire[31:0] localMemory_wb_data_o,

		// SRAM rw port
		output wire clk0, // Port clock
		output wire[1:0] csb0, // active low chip select
		output wire web0, // active low write control
		output wire[3:0] wmask0, // write mask
		output wire[SRAM_ADDRESS_SIZE-1:0] addr0,
		output wire[31:0] din0,
		input  wire[63:0] dout0,

		// SRAM r port
		output wire clk1,
		output wire[1:0] csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] addr1,
		input  wire[63:0] dout1,

		// Logic probes
		output wire[1:0] probe_state,
		output wire[1:0] probe_env,
		output wire[31:0] probe_programCounter,
		output wire[6:0] probe_opcode,
		output wire[1:0] probe_errorCode,
		output wire probe_isBranch,
		output wire probe_takeBranch,
		output wire probe_isStore,
		output wire probe_isLoad,
		output wire probe_isCompressed,
		output wire[4:0] probe_jtagInstruction
	);
	
	localparam SRAM_ADDRESS_SIZE = 9;

	// Management
	// Shortened form of misa register
	// Modified extensions encounding
	// Origional Bit | New Bit | Character | Description
	// --------------|---------|-----------|------------------------------------------------------
	// 0 			 | 0 	   | A 		   | Atomic extension
	// 1 			 | 1 	   | B 		   | Tentatively reserved for Bit-Manipulation extension
	// 2 			 | 2 	   | C 		   | Compressed extension
	// 3 			 | 3 	   | D 		   | Double-precision floating-point extension
	// 4 			 | 4 	   | E 		   | RV32E base ISA
	// 5 			 | 5 	   | F 		   | Single-precision floating-point extension
	// 6 			 | 6 	   | G 		   | Additional standard extensions present
	// 7 			 | 7 	   | H 		   | Hypervisor extension
	// 8 			 | 8 	   | I 		   | RV32I/64I/128I base ISA
	// 12			 | 9 	   | M 		   | Integer Multiply/Divide extension
	// 13			 | 10 	   | N 		   | User-level interrupts supported
	// 16			 | 11 	   | Q 		   | Quad-precision floating-point extension
	// 18			 | 12 	   | S 		   | Supervisor mode implemented
	// 20			 | 13 	   | U 		   | User mode implemented
	localparam CORE_MXL = 2'h1;
	localparam CORE_EXTENSIONS = 26'b00_0000_0000_0000_0001_0000_0000;
	localparam CORE_EXTENSIONS_SHORT = 14'b00_0001_0000_0000;
	localparam CORE_VERSION = 8'h00;

	// Core
	// Memory interface from core
	wire coreMemoryWriteEnable;
	wire coreMemoryReadEnable;
	wire[31:0] coreMemoryAddress;
	wire[3:0] coreMemoryByteSelect;
	wire[31:0] coreMemoryDataWrite;
	wire[31:0] coreMemoryDataRead;
	wire coreMemoryBusy;

	// Memory interface from core to local memory
	wire coreLocalMemoryWriteEnable;
	wire coreLocalMemoryReadEnable;
	wire[23:0] coreLocalMemoryAddress;
	wire[3:0] coreLocalMemoryByteSelect;
	wire[31:0] coreLocalMemoryDataWrite;
	wire[31:0] coreLocalMemoryDataRead;
	wire coreLocalMemoryBusy;

	// Memory interface from core to wb
	wire coreWBWriteEnable;
	wire coreWBReadEnable;
	wire[27:0] coreWBAddress;
	wire[3:0] coreWBByteSelect;
	wire[31:0] coreWBDataWrite;
	wire[31:0] coreWBDataRead;
	wire coreWBBusy;

	// Memory interface from wb to local memory
	wire wbLocalMemoryWriteEnable;
	wire wbLocalMemoryReadEnable;
	wire[23:0] wbLocalMemoryAddress;
	wire[3:0] wbLocalMemoryByteSelect;
	wire[31:0] wbLocalMemoryDataWrite;
	wire[31:0] wbLocalMemoryDataRead;
	wire wbLocalMemoryBusy;

	// Core management
	wire management_run;
	wire management_trapEnable;
	wire management_writeEnable;
	wire[3:0] management_byteSelect;
	wire[15:0] management_address;
	wire[31:0] management_writeData;
	wire[31:0] management_readData;

	wire jtag_management_writeEnable;
	wire jtag_management_readEnable;
	wire[3:0] jtag_management_byteSelect;
	wire[19:0] jtag_management_address;
	wire[31:0] jtag_management_writeData;
	wire[31:0] jtag_management_readData;

	wire wb_management_writeEnable;
	wire wb_management_readEnable;
	wire[3:0] wb_management_byteSelect;
	wire[19:0] wb_management_address;
	wire[31:0] wb_management_writeData;
	wire[31:0] wb_management_readData;
	wire wb_management_busy;

	JTAG jtag(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.coreID({ coreIndex, CORE_VERSION, CORE_MXL, CORE_EXTENSIONS_SHORT }),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.jtag_tck(jtag_tck),
		.jtag_tms(jtag_tms),
		.jtag_tdi(jtag_tdi),
		.jtag_tdo(jtag_tdo),
		.management_writeEnable(jtag_management_writeEnable),
		.management_readEnable(jtag_management_readEnable),
		.management_byteSelect(jtag_management_byteSelect),
		.management_address(jtag_management_address),
		.management_writeData(jtag_management_writeData),
		.management_readData(jtag_management_readData),
		.probe_jtagInstruction(probe_jtagInstruction));

	wire isAddressBreakpoint;
	CoreManagement coreManagement(
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.management_run(management_run),
		.management_trapEnable(management_trapEnable),
		.management_writeEnable(management_writeEnable),
		.management_byteSelect(management_byteSelect),
		.management_address(management_address),
		.management_writeData(management_writeData),
		.management_readData(management_readData),
		.isAddressBreakpoint(isAddressBreakpoint),
		.coreAddress(coreMemoryAddress),
		.core_env(probe_env),
		.core_errorCode(probe_errorCode),
		.jtag_management_writeEnable(jtag_management_writeEnable),
		.jtag_management_readEnable(jtag_management_readEnable),
		.jtag_management_byteSelect(jtag_management_byteSelect),
		.jtag_management_address(jtag_management_address),
		.jtag_management_writeData(jtag_management_writeData),
		.jtag_management_readData(jtag_management_readData),
		.wb_management_writeEnable(wb_management_writeEnable),
		.wb_management_readEnable(wb_management_readEnable),
		.wb_management_byteSelect(wb_management_byteSelect),
		.wb_management_address(wb_management_address),
		.wb_management_writeData(wb_management_writeData),
		.wb_management_readData(wb_management_readData),
		.wb_management_busy(wb_management_busy));

	// Core
	wire[15:0] userInterrupts = 16'b0;
	RV32ICore core(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.memoryWriteEnable(coreMemoryWriteEnable),
		.memoryReadEnable(coreMemoryReadEnable),
		.memoryAddress(coreMemoryAddress),
		.memoryByteSelect(coreMemoryByteSelect),
		.memoryDataWrite(coreMemoryDataWrite),
		.memoryDataRead(coreMemoryDataRead),
		.memoryBusy(coreMemoryBusy),
		.management_run(management_run),
		.management_trapEnable(management_trapEnable),
		.management_writeEnable(management_writeEnable),
		.management_byteSelect(management_byteSelect),
		.management_address(management_address),
		.management_writeData(management_writeData),
		.management_readData(management_readData),
		.coreIndex(coreIndex),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID),
		.extensions(CORE_EXTENSIONS),
		.eCall(eCall),
		.eBreak(eBreak),
		.isAddressBreakpoint(isAddressBreakpoint),
		.userInterrupts(userInterrupts),
		.probe_state(probe_state),
		.probe_env(probe_env),
		.probe_programCounter(probe_programCounter),
		.probe_opcode(probe_opcode),
		.probe_errorCode(probe_errorCode),
		.probe_isBranch(probe_isBranch),
		.probe_takeBranch(probe_takeBranch),
		.probe_isStore(probe_isStore),
		.probe_isLoad(probe_isLoad),
		.probe_isCompressed(probe_isCompressed));

	MemoryController memoryController(
		.coreAddress(coreMemoryAddress),
		.coreByteSelect(coreMemoryByteSelect),
		.coreWriteEnable(coreMemoryWriteEnable),
		.coreReadEnable(coreMemoryReadEnable),
		.coreDataWrite(coreMemoryDataWrite),
		.coreDataRead(coreMemoryDataRead),
		.coreBusy(coreMemoryBusy),
		.localMemoryAddress(coreLocalMemoryAddress),
		.localMemoryByteSelect(coreLocalMemoryByteSelect),
		.localMemoryWriteEnable(coreLocalMemoryWriteEnable),
		.localMemoryReadEnable(coreLocalMemoryReadEnable),
		.localMemoryDataWrite(coreLocalMemoryDataWrite),
		.localMemoryDataRead(coreLocalMemoryDataRead),
		.localMemoryBusy(coreLocalMemoryBusy),
		.wbAddress(coreWBAddress),
		.wbByteSelect(coreWBByteSelect),
		.wbWriteEnable(coreWBWriteEnable),
		.wbReadEnable(coreWBReadEnable),
		.wbDataWrite(coreWBDataWrite),
		.wbDataRead(coreWBDataRead),
		.wbBusy(coreWBBusy));

	LocalMemoryInterface #(.SRAM_ADDRESS_SIZE(SRAM_ADDRESS_SIZE)) localMemoryInterface (
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.coreAddress(coreLocalMemoryAddress),
		.coreByteSelect(coreLocalMemoryByteSelect),
		.coreWriteEnable(coreLocalMemoryWriteEnable),
		.coreReadEnable(coreLocalMemoryReadEnable),
		.coreDataWrite(coreLocalMemoryDataWrite),
		.coreDataRead(coreLocalMemoryDataRead),
		.coreBusy(coreLocalMemoryBusy),
		.wbAddress(wbLocalMemoryAddress),
		.wbByteSelect(wbLocalMemoryByteSelect),
		.wbWriteEnable(wbLocalMemoryWriteEnable),
		.wbReadEnable(wbLocalMemoryReadEnable),
		.wbDataWrite(wbLocalMemoryDataWrite),
		.wbDataRead(wbLocalMemoryDataRead),
		.wbBusy(wbLocalMemoryBusy),
		.clk0(clk0),
		.csb0(csb0),
		.web0(web0),
		.wmask0(wmask0),
		.addr0(addr0),
		.din0(din0),
		.dout0(dout0),
		.clk1(clk1),
		.csb1(csb1),
		.addr1(addr1),
		.dout1(dout1));

	Core_WBInterface coreWBInterface(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_cyc_o(core_wb_cyc_o),
		.wb_stb_o(core_wb_stb_o),
		.wb_we_o(core_wb_we_o),
		.wb_sel_o(core_wb_sel_o),
		.wb_data_o(core_wb_data_o),
		.wb_adr_o(core_wb_adr_o),
		.wb_ack_i(core_wb_ack_i),
		.wb_stall_i(core_wb_stall_i),
		.wb_error_i(core_wb_error_i),
		.wb_data_i(core_wb_data_i),
		.wbAddress(coreWBAddress),
		.wbByteSelect(coreWBByteSelect),
		.wbWriteEnable(coreWBWriteEnable),
		.wbReadEnable(coreWBReadEnable),
		.wbDataWrite(coreWBDataWrite),
		.wbDataRead(coreWBDataRead),
		.wbBusy(coreWBBusy));

	WB_SRAMInterface wbSRAMInterface(
		.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_cyc_i(localMemory_wb_cyc_i),
		.wb_stb_i(localMemory_wb_stb_i),
		.wb_we_i(localMemory_wb_we_i),
		.wb_sel_i(localMemory_wb_sel_i),
		.wb_data_i(localMemory_wb_data_i),
		.wb_adr_i(localMemory_wb_adr_i),
		.wb_ack_o(localMemory_wb_ack_o),
		.wb_stall_o(localMemory_wb_stall_o),
		.wb_error_o(localMemory_wb_error_o),
		.wb_data_o(localMemory_wb_data_o),
		.localMemoryAddress(wbLocalMemoryAddress),
		.localMemoryByteSelect(wbLocalMemoryByteSelect),
		.localMemoryWriteEnable(wbLocalMemoryWriteEnable),
		.localMemoryReadEnable(wbLocalMemoryReadEnable),
		.localMemoryDataWrite(wbLocalMemoryDataWrite),
		.localMemoryDataRead(wbLocalMemoryDataRead),
		.localMemoryBusy(wbLocalMemoryBusy),
		.management_writeEnable(wb_management_writeEnable),
		.management_readEnable(wb_management_readEnable),
		.management_byteSelect(wb_management_byteSelect),
		.management_address(wb_management_address),
		.management_writeData(wb_management_writeData),
		.management_readData(wb_management_readData),
		.management_busy(wb_management_busy));

endmodule