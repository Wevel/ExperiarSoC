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
		output wire[IO_COUNT-1:0] gpio_oe
	);

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
	ConfigurationRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h000), .DEFAULT(~{IO_COUNT{1'b0}})) oeRegister(
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
	ConfigurationRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h004), .DEFAULT({IO_COUNT{1'b0}})) outputRegister(
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
	DataRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h008)) inputRegister(
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
		.readData(gpio_input),
		.readData_en(inputRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	assign requestOutput = oeRegisterOutputRequest || outputRegisterOutputRequest || inputRegisterOutputRequest;
	assign peripheralBus_dataRead = oeRegisterOutputRequest 	? oeRegisterOutputData :
								    outputRegisterOutputRequest ? outputRegisterOutputData :
								    inputRegisterOutputRequest  ? inputRegisterOutputData :
								   								  ~32'b0;
	assign peripheralBus_busy = 1'b0;
	
endmodule