module CoreManagement (
		input wire clk,
		input wire rst,

		// Interface to core
		output wire management_run,
		output wire management_interruptEnable,
		output wire management_writeEnable,
		output wire[3:0] management_byteSelect,
		output wire[15:0] management_address,
		output wire[31:0] management_writeData,
		input wire[31:0] management_readData,

		// Address breakpoint
		output wire isInstructionAddressBreakpoint,
		output wire isDataAddressBreakpoint,
		input wire[31:0] coreInstructionAddress,
		input wire[31:0] coreDataAddress,

		// Interface from jtag
		input wire jtag_management_enable,
		input wire jtag_management_writeEnable,
		input wire[3:0] jtag_management_byteSelect,
		input wire[19:0] jtag_management_address,
		input wire[31:0] jtag_management_writeData,
		output wire[31:0] jtag_management_readData,

		// Interface from wishbone
		input wire wb_management_enable,
		input wire wb_management_writeEnable,
		input wire[3:0] wb_management_byteSelect,
		input wire[19:0] wb_management_address,
		input wire[31:0] wb_management_writeData,
		output wire[31:0] wb_management_readData,
		output wire wb_management_busy
	);

	// TODO instruction breakpoints
	assign isInstructionAddressBreakpoint = 0;
	assign isDataAddressBreakpoint = 0;
	//assign isInstructionAddressBreakpoint = coreInstructionAddress == instructionBreakpointAddress;
	//assign isDataAddressBreakpoint = coreDataAddress == dataBreakpointAddress;

	// Master select
	wire jtagSelect = jtag_management_enable;
	wire wbRequest = wb_management_enable;
	wire wbSelect = wbRequest && !jtagSelect;

	wire peripheralBus_we = jtag_management_writeEnable || (!jtagSelect && wb_management_writeEnable);
	wire peripheralBus_oe = (jtag_management_enable && !jtag_management_writeEnable)  || (!jtagSelect && wb_management_enable && !wb_management_writeEnable);
	wire[19:0] peripheralBus_address = jtagSelect ? jtag_management_address : 
								   	   wbSelect   ? wb_management_address   : 20'b0;
	wire[3:0] peripheralBus_byteSelect = jtagSelect ? jtag_management_byteSelect : 
								   	     wbSelect   ? wb_management_byteSelect   : 4'h0;
	wire[31:0] peripheralBus_dataWrite = jtag_management_writeEnable ? jtag_management_writeData :
									 	 wb_management_writeEnable   ? wb_management_writeData   : 32'b0;

	wire[31:0] peripheralBus_dataRead;
	assign jtag_management_readData = peripheralBus_dataRead;
	assign wb_management_readData = peripheralBus_dataRead;
	assign wb_management_busy = jtagSelect && wbRequest;

	wire registerEnable = peripheralBus_address[19:12] == 8'h00;
	wire coreEnable = peripheralBus_address[19:16] == 4'h1 && !management_run;

	// Registers
	// Control register: Default 0x0
	// b00: run
	// b01: unused
	// b02: interruptEnable
	wire[2:0] control;
	wire[31:0] controlOutputData;
	wire controlOutputRequest;
	ConfigurationRegister #(.WIDTH(3), .ADDRESS(12'h000), .DEFAULT(3'b0)) controlRegister(
		.clk(clk),
		.rst(rst),
		.enable(registerEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(peripheralBus_address[11:0]),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(controlOutputData),
		.requestOutput(controlOutputRequest),
		.currentValue(control));

	// Core
	assign management_run = control[0];
	assign management_interruptEnable = control[2];
	assign management_writeEnable = coreEnable && peripheralBus_we;
	assign management_byteSelect = peripheralBus_byteSelect;
	assign management_address = peripheralBus_address[15:0];
	assign management_writeData = peripheralBus_dataWrite;

	assign peripheralBus_dataRead = coreEnable 			 ? management_readData :
									controlOutputRequest ? controlOutputData   : ~32'b0;
	
endmodule