module CoreManagement (
		input wire clk,
		input wire rst,

		// Interface to core
		output wire management_run,
		output wire management_trapEnable,
		output wire management_interruptEnable,
		output wire management_writeEnable,
		output wire[3:0] management_byteSelect,
		output wire[15:0] management_address,
		output wire[31:0] management_writeData,
		input wire[31:0] management_readData,

		// Core state
		input wire[1:0] core_env,
		input wire[1:0] core_errorCode,

		// Address breakpoint
		output wire isAddressBreakpoint,
		input wire[31:0] coreAddress,

		// Interface from jtag
		input wire jtag_management_writeEnable,
		input wire jtag_management_readEnable,
		input wire[3:0] jtag_management_byteSelect,
		input wire[19:0] jtag_management_address,
		input wire[31:0] jtag_management_writeData,
		output wire[31:0] jtag_management_readData,

		// Interface from wishbone
		input wire wb_management_writeEnable,
		input wire wb_management_readEnable,
		input wire[3:0] wb_management_byteSelect,
		input wire[19:0] wb_management_address,
		input wire[31:0] wb_management_writeData,
		output wire[31:0] wb_management_readData,
		output wire wb_management_busy
	);

	// TODO instruction breakpoints
	assign isAddressBreakpoint = 0;
	//assign isAddressBreakpoint = coreAddress == instructionBreakpointAddress;

	// Master select
	wire jtagSelect = jtag_management_writeEnable || jtag_management_readEnable;
	wire wbRequest = wb_management_writeEnable || wb_management_readEnable;
	wire wbSelect = wbRequest && !jtagSelect;

	wire peripheralBus_we = jtag_management_writeEnable || (!jtagSelect && wb_management_writeEnable);
	wire peripheralBus_oe = jtag_management_readEnable  || (!jtagSelect && wb_management_readEnable);
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
	// b01: trapEnable
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

	// State register
	// b00-b03: probe_errorCode
	// b04: isRunning
	reg[4:0] stateBuffered;
	wire[31:0] stateOutputData;
	wire stateOutputRequest;
	wire stateBusBusy_nc;
	wire[4:0] stateWriteData_nc;
	wire stateWriteDataEnable_nc;
	wire stateReadDataEnable_nc;
	DataRegister #(.WIDTH(5), .ADDRESS(12'h004)) stateRegister(
		.clk(clk),
		.rst(rst),
		.enable(registerEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(stateBusBusy_nc),
		.peripheralBus_address(peripheralBus_address[11:0]),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(stateOutputData),
		.requestOutput(stateOutputRequest),
		.writeData(stateWriteData_nc),
		.writeData_en(stateWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(stateBuffered),
		.readData_en(stateReadDataEnable_nc),
		.readData_busy(1'b0));

	always @(posedge clk) begin
		if (rst) stateBuffered <= 3'b0;
		else stateBuffered <= { management_run, core_env, core_errorCode };
	end

	// Core
	assign management_run = control[0];
	assign management_trapEnable = control[1];
	assign management_interruptEnable = control[2];
	assign management_writeEnable = coreEnable && peripheralBus_we;
	assign management_byteSelect = peripheralBus_byteSelect;
	assign management_address = peripheralBus_address[15:0];
	assign management_writeData = peripheralBus_dataWrite;

	assign peripheralBus_dataRead = coreEnable 			 ? management_readData :
									controlOutputRequest ? controlOutputData   :
									stateOutputRequest   ? stateOutputData     : ~32'b0;
	
endmodule