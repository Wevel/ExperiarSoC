module PWMDevice #(
		parameter ID = 4'h0,
		parameter OUTPUTS = 4,
		parameter WIDTH = 16,
		parameter CLOCK_WIDTH = 32
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
		output requestOutput,
		
		// PWM output
		output wire[OUTPUTS-1:0] pwm_en,
		output wire[OUTPUTS-1:0] pwm_out
	);

	localparam WIDTH_BITS = $clog2(WIDTH);
	localparam CLOCK_BITS = $clog2(CLOCK_WIDTH);

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Register
	// Configuration register 	Default 0x3DC (for .WIDTH(16), .CLOCK_WIDTH(32))
	// b00: counterEnable		Default 0x0
	// b01-b05: clockScale		Default 0x0E
	// b06-09: top 				Default 0xF
	// b10: outputEnable0		Default 0x0
	// b11: outputEnable1		Default 0x0
	// b12: outputEnable2		Default 0x0
	// b13: outputEnable3		Default 0x0
	localparam CONFIG_WIDTH = 1 + CLOCK_BITS + WIDTH_BITS + OUTPUTS;
	wire[CONFIG_WIDTH-1:0] configuration;
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(CONFIG_WIDTH), .ADDRESS(12'h000), .DEFAULT(CONFIG_WIDTH'h3DC)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(configurationRegisterOutputData),
		.requestOutput(configurationRegisterOutputRequest),
		.currentValue(configuration));

	wire counterEnable = configuration[0];
	wire[CLOCK_BITS-1:0] clockScale = configuration[CLOCK_BITS:1];
	wire[WIDTH_BITS-1:0] topBit = configuration[CLOCK_BITS + WIDTH_BITS:1 + CLOCK_BITS];
	wire[OUTPUTS-1:0] outputEnable = configuration[(1 + CLOCK_BITS + WIDTH_BITS + OUTPUTS)-1:1 + CLOCK_BITS + WIDTH_BITS];

	// Current data register (for .WIDTH(16), .OUTPUTS(4))
	// b00-b15: counterValue
	// b16-b19: output
	wire[OUTPUTS-1:0] outputs;
	wire[31:0] dataRegisterOutputData;
	wire dataRegisterOutputRequest;
	DataRegister #(.WIDTH(WIDTH + OUTPUTS), .ADDRESS(12'h004)) dataRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(dataRegisterOutputData),
		.requestOutput(dataRegisterOutputRequest),
		.writeData(),
		.writeData_en(),
		.writeData_busy(1'b0),
		.readData({ outputs, counterValue }),
		.readData_en(),
		.readData_busy(1'b0));

	// Counter control
	reg[CLOCK_WIDTH + WIDTH - 1:0] baseCounter = 'b0;
	wire[CLOCK_WIDTH + WIDTH - 1:0] nextCounter = baseCounter + 1;
	wire[WIDTH-1:0] counterValue = baseCounter >> clockScale;
	wire[WIDTH:0] topBitMaskFull = { WIDTH_BITS'h1 << topBit, 1'b0 };
	wire[WIDTH-1:0] topBitMask = topBitMaskFull[WIDTH-1:0];

	always @(posedge clk) begin
		if (rst || |(counterValue & topBitMask) || !counterEnable) baseCounter <= 'b0;
		else if (counterEnable) baseCounter <= nextCounter;
	end

	wire[OUTPUTS-1:0] compareRegisterOutputRequest;
	wire[(32 * OUTPUTS) - 1:0] compareRegisterOutputData;
	Mux #(.WIDTH(32), .INPUTS(OUTPUTS)) mux(
		.select(compareRegisterOutputRequest),
		.in(compareRegisterOutputData),
		.out(peripheralBus_dataRead),
		.outputEnable(requestOutput));

	// Outputs
	genvar i;
	generate
		for (i = 0; i < OUTPUTS; i = i + 1) begin
			// Compare value register
			wire[WIDTH-1:0] compareValue;
			ConfigurationRegister #(.WIDTH(WIDTH), .ADDRESS(12'h008 + (i * 12'h004)), .DEFAULT('b0)) compareRegister(
				.clk(clk),
				.rst(rst),
				.enable(deviceEnable),
				.peripheralBus_we(peripheralBus_we),
				.peripheralBus_oe(peripheralBus_oe),
				.peripheralBus_address(localAddress),
				.peripheralBus_byteSelect(peripheralBus_byteSelect),
				.peripheralBus_dataWrite(peripheralBus_dataWrite),
				.peripheralBus_dataRead(compareRegisterOutputData[(i * 32) + 31:i * 32]),
				.requestOutput(compareRegisterOutputRequest[i]),
				.currentValue(compareValue));
			PWMOutput #(.WIDTH(WIDTH)) outputPort(
				.clk(clk),
				.rst(rst),
				.compareValue(compareValue),
				.enable(outputEnable[i]),
				.counterValue(counterValue),
				.pwm_out(outputs[i]));
		end
	endgenerate

	assign peripheralBus_busy = 1'b0;

	assign pwm_en = outputEnable;
	assign pwm_out = outputs;

endmodule
