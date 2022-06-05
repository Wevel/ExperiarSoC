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
		output reg[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,
		
		// PWM output
		output wire[OUTPUTS-1:0] pwm_en,
		output wire[OUTPUTS-1:0] pwm_out,
		output wire pwm_irq
	);

	localparam CLOCK_BITS = $clog2(CLOCK_WIDTH);

	wire counterEnable;
	wire[CLOCK_BITS-1:0] clockScale;
	wire[OUTPUTS-1:0] compareEnable;
	wire[OUTPUTS-1:0] outputEnable;
	wire[OUTPUTS-1:0] riseInterruptEnable;
	wire[OUTPUTS-1:0] fallInterruptEnable;

	// Counter control
	reg[CLOCK_WIDTH + WIDTH - 1:0] baseCounter = 'b0;
	wire[CLOCK_WIDTH + WIDTH - 1:0] nextCounter = baseCounter + 1;
	wire[WIDTH-1:0] counterValue = baseCounter >> clockScale;

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Register
	// Configuration register 	 Default 0x000003 (for .CLOCK_WIDTH(32))
	// b00-b04: clockScale		 Default 0x03
	// b05: counterEnable		 Default 0x0
	// b06: compareEnable0		 Default 0x0
	// b07: compareEnable1		 Default 0x0
	// b08: compareEnable2		 Default 0x0
	// b09: compareEnable3		 Default 0x0
	// b10: outputEnable0		 Default 0x0
	// b11: outputEnable1		 Default 0x0
	// b12: outputEnable2		 Default 0x0
	// b13: outputEnable3		 Default 0x0
	// b14: riseInterruptEnable0 Default 0x0
	// b15: riseInterruptEnable1 Default 0x0
	// b16: riseInterruptEnable2 Default 0x0
	// b17: riseInterruptEnable3 Default 0x0
	// b18: fallInterruptEnable0 Default 0x0
	// b19: fallInterruptEnable1 Default 0x0
	// b20: fallInterruptEnable2 Default 0x0
	// b21: fallInterruptEnable3 Default 0x0
	localparam CONFIG_WIDTH = 1 + CLOCK_BITS + (OUTPUTS * 4);
	wire[CONFIG_WIDTH-1:0] configuration;
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(CONFIG_WIDTH), .ADDRESS(12'h000), .DEFAULT({ {(CONFIG_WIDTH-5){1'b0}}, 5'h0E })) configurationRegister(
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

	assign clockScale = configuration[CLOCK_BITS-1:0];
	assign counterEnable = configuration[CLOCK_BITS];
	assign compareEnable = configuration[(1 + CLOCK_BITS + OUTPUTS)-1:1 + CLOCK_BITS];
	assign outputEnable = configuration[(1 + CLOCK_BITS + (OUTPUTS * 2))-1:1 + CLOCK_BITS + OUTPUTS];
	assign riseInterruptEnable = configuration[(1 + CLOCK_BITS + (OUTPUTS * 3))-1:1 + CLOCK_BITS + (OUTPUTS * 2)];
	assign fallInterruptEnable = configuration[(1 + CLOCK_BITS + (OUTPUTS * 4))-1:1 + CLOCK_BITS + (OUTPUTS * 3)];

	// Counter top compare Default 0x1387 (for .WIDTH(16))
	// With clockScale=0x03, this gives a 1kHz signal with a 200ns resolution
	localparam DEFAULT_TOP_COMPARE_VALUE = 'h1387;
	wire[31:0] topCompareRegisterOutputData;
	wire topCompareRegisterOutputRequest;
	wire topCompareRegisterBusBusy_nc;
	wire[WIDTH-1:0] topCompareRegisterWriteData;
	wire topCompareRegisterWriteDataEnable;
	wire topCompareRegisterReadDataEnable_nc;
	reg[WIDTH-1:0] topCompare;
	DataRegister #(.WIDTH(WIDTH), .ADDRESS(12'h004)) topCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(topCompareRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(topCompareRegisterOutputData),
		.requestOutput(topCompareRegisterOutputRequest),
		.writeData(topCompareRegisterWriteData),
		.writeData_en(topCompareRegisterWriteDataEnable),
		.writeData_busy(1'b0),
		.readData(topCompare),
		.readData_en(topCompareRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	// Current data register (for .WIDTH(16), .OUTPUTS(4))
	// b00-b15: counterValue
	// b16-b19: output
	reg[WIDTH+OUTPUTS-1:0] dataRegisterBuffered;
	wire[OUTPUTS-1:0] outputs;
	wire[31:0] dataRegisterOutputData;
	wire dataRegisterOutputRequest;
	wire dataRegisterBusBusy_nc;
	wire[WIDTH+OUTPUTS-1:0] dataRegisterWriteData_nc;
	wire dataRegisterWriteDataEnable_nc;
	wire dataRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(WIDTH + OUTPUTS), .ADDRESS(12'h008)) dataRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(dataRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(dataRegisterOutputData),
		.requestOutput(dataRegisterOutputRequest),
		.writeData(dataRegisterWriteData_nc),
		.writeData_en(dataRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(dataRegisterBuffered),
		.readData_en(dataRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	always @(posedge clk) begin
		if (rst) dataRegisterBuffered <= {(WIDTH + OUTPUTS){1'b0}};
		else dataRegisterBuffered <= { outputs, counterValue };
	end

	always @(posedge clk) begin
		if (rst) begin
			baseCounter <= 'b0;
			topCompare <= DEFAULT_TOP_COMPARE_VALUE;
		end else begin
			if (topCompareRegisterWriteDataEnable) begin
				baseCounter <= 'b0;
				topCompare <= topCompareRegisterWriteData;
			end else begin
				if (counterEnable) begin
					if (counterValue == topCompare) baseCounter <= 'b0;
					else baseCounter <= nextCounter;
				end else begin
					baseCounter <= 'b0;
				end
			end
		end
	end

	wire[OUTPUTS-1:0] compareRegisterOutputRequest;
	wire[(32 * OUTPUTS) - 1:0] compareRegisterOutputData;
	wire[31:0] compareValuesOutputData;
	wire compareValuesOutputRequest;
	Mux #(.WIDTH(32), .INPUTS(OUTPUTS), .DEFAULT(~32'b0)) mux(
		.select(compareRegisterOutputRequest),
		.in(compareRegisterOutputData),
		.out(compareValuesOutputData),
		.outputEnable(compareValuesOutputRequest));

	assign requestOutput = configurationRegisterOutputRequest || topCompareRegisterOutputRequest || dataRegisterOutputRequest || compareValuesOutputRequest;

	always @(*) begin
		case (1'b1)
			configurationRegisterOutputRequest: peripheralBus_dataRead <= configurationRegisterOutputData;
			topCompareRegisterOutputRequest: peripheralBus_dataRead <= topCompareRegisterOutputData;
			dataRegisterOutputRequest: peripheralBus_dataRead <= dataRegisterOutputData;
			compareValuesOutputRequest: peripheralBus_dataRead <= compareValuesOutputData;
			default: peripheralBus_dataRead <= 32'b0;
		endcase
	end

	wire[OUTPUTS-1:0] compareRise;
	wire[OUTPUTS-1:0] compareFall;

	// Outputs
	genvar i;
	generate
		for (i = 0; i < OUTPUTS; i = i + 1) begin
			// Compare value register
			wire[WIDTH-1:0] compareValue;
			ConfigurationRegister #(.WIDTH(WIDTH), .ADDRESS(12'h010 + (i * 12'h004)), .DEFAULT('b0)) compareRegister(
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
				.enable(compareEnable[i]),
				.counterValue(counterValue),
				.pwm_out(outputs[i]),
				.compareRise(compareRise[i]),
				.compareFall(compareFall[i]));
		end
	endgenerate

	assign peripheralBus_busy = 1'b0;

	assign pwm_en = compareEnable & outputEnable;
	assign pwm_out = outputs;

	wire[OUTPUTS-1:0] comparatorIRQ = (riseInterruptEnable & compareRise) || (fallInterruptEnable & compareFall);
	assign pwm_irq = |comparatorIRQ;

endmodule
