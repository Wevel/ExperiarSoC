module GPIODevice #(
		parameter ID = 4'h0,
		parameter IO_COUNT = 16
	)(
		input wire clk,
		input wire rst,

		// Peripheral bus
		input wire peripheralEnable,
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[15:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		output wire[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,
		
		// GPIO
		input wire[IO_COUNT-1:0] gpio_input,
		output wire[IO_COUNT-1:0] gpio_output,
		output wire[IO_COUNT-1:0] gpio_oe,
		output reg gpio_irq
	);

	reg[IO_COUNT-1:0] inputBuffered;
	always @(posedge clk) begin
		if (rst) inputBuffered <= {IO_COUNT{1'b0}};
		else inputBuffered <= gpio_input;
	end

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Registers
	// OE register: Default 0x0
	wire[31:0] oeRegisterOutputData;
	wire oeRegisterOutputRequest;
	OutputRegister #(.WIDTH(IO_COUNT), .ADDRESS(8'h00), .DEFAULT(~{IO_COUNT{1'b0}})) oeRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(oeRegisterOutputData),
		.requestOutput(oeRegisterOutputRequest),
		.currentValue(gpio_oe));

	// Output data register: Default 0x0
	wire[31:0] outputRegisterOutputData;
	wire outputRegisterOutputRequest;
	OutputRegister #(.WIDTH(IO_COUNT), .ADDRESS(8'h01), .DEFAULT({IO_COUNT{1'b0}})) outputRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(outputRegisterOutputData),
		.requestOutput(outputRegisterOutputRequest),
		.currentValue(gpio_output));

	// Input data register
	wire[31:0] inputRegisterOutputData;
	wire inputRegisterOutputRequest;
	wire inputRegisterBusBusy_nc;
	wire[IO_COUNT-1:0] inputRegisterWriteData_nc;
	wire inputRegisterWriteDataEnable_nc;
	wire inputRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h020)) inputRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(inputRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(inputRegisterOutputData),
		.requestOutput(inputRegisterOutputRequest),
		.writeData(inputRegisterWriteData_nc),
		.writeData_en(inputRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(inputBuffered),
		.readData_en(inputRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	// IRQ register: Default 0x0
	wire[31:0] irqEnableRegisterOutputData;
	wire irqEnableRegisterOutputRequest;
	wire[IO_COUNT-1:0] irqEnable;
	OutputRegister #(.WIDTH(IO_COUNT), .ADDRESS(8'h03), .DEFAULT({IO_COUNT{1'b0}})) irqEnableRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(irqEnableRegisterOutputData),
		.requestOutput(irqEnableRegisterOutputRequest),
		.currentValue(irqEnable));

	assign requestOutput = oeRegisterOutputRequest || outputRegisterOutputRequest || inputRegisterOutputRequest || irqEnableRegisterOutputRequest;
	assign peripheralBus_dataRead = oeRegisterOutputRequest 	   ? oeRegisterOutputData :
								    outputRegisterOutputRequest    ? outputRegisterOutputData :
								    inputRegisterOutputRequest     ? inputRegisterOutputData :
									irqEnableRegisterOutputRequest ? irqEnableRegisterOutputData :
								   								     ~32'b0;
	assign peripheralBus_busy = 1'b0;
	

	wire[IO_COUNT-1:0] pinIRQ = irqEnable & gpio_oe & inputBuffered;

	always @(posedge clk) begin
		if (rst) gpio_irq <= 1'b0;
		else gpio_irq <= |pinIRQ;
	end

endmodule