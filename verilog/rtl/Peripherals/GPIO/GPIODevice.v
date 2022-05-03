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
	ConfigurationRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h000), .DEFAULT(IO_COUNT'h0)) oeRegister(
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
	ConfigurationRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h004), .DEFAULT(IO_COUNT'h0)) outputRegister(
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
	DataRegister #(.WIDTH(IO_COUNT), .ADDRESS(12'h008)) inputRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(inputRegisterOutputData),
		.requestOutput(inputRegisterOutputRequest),
		.writeData(),
		.writeData_en(),
		.writeData_busy(1'b0),
		.readData(gpio_input),
		.readData_en(),
		.readData_busy(1'b0));

	assign requestOutput = oeRegisterOutputRequest || outputRegisterOutputRequest || inputRegisterOutputRequest;
	assign peripheralBus_dataRead = oeRegisterOutputRequest 	? oeRegisterOutputData :
								    outputRegisterOutputRequest ? outputRegisterOutputData :
								    inputRegisterOutputRequest  ? inputRegisterOutputData :
								   								  32'b0;
	assign peripheralBus_busy = 1'b0;
	
endmodule