module PWM #(
		parameter ID = 8'h02
	)(
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif

		input wire clk,
		input wire rst,
		
		// Peripheral Bus
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[23:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		output wire[31:0] peripheralBus_dataRead,
		input wire[31:0] peripheralBus_dataWrite,
		output wire requestOutput,

		output wire[15:0] pwm_en,
		output wire[15:0] pwm_out,
		output wire[3:0] pwm_irq
	);

	localparam DEVICE_COUNT = 4;
	localparam OUTPUTS_PER_DEVICE = 4;

	// Peripheral select
	wire[15:0] localAddress;
	wire peripheralEnable;
	PeripheralSelect #(.ID(ID)) select(
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.peripheralEnable(peripheralEnable));
	
	wire[DEVICE_COUNT-1:0] deviceOutputRequest;
	wire[(32 * DEVICE_COUNT) - 1:0] deviceOutputData;
	Mux #(.WIDTH(32), .INPUTS(DEVICE_COUNT), .DEFAULT(~32'b0)) mux(
		.select(deviceOutputRequest),
		.in(deviceOutputData),
		.out(peripheralBus_dataRead),
		.outputEnable(requestOutput));

	wire[DEVICE_COUNT-1:0] deviceBusy_nc;

	genvar i;
	generate
		for (i = 0; i < DEVICE_COUNT; i = i + 1) begin			
			PWMDevice #(.ID(i+1), .OUTPUTS(OUTPUTS_PER_DEVICE), .WIDTH(16), .CLOCK_WIDTH(32)) device(
				.clk(clk),
				.rst(rst),
				.peripheralEnable(peripheralEnable),
				.peripheralBus_we(peripheralBus_we),
				.peripheralBus_oe(peripheralBus_oe),
				.peripheralBus_busy(deviceBusy_nc[i]),
				.peripheralBus_address(localAddress),
				.peripheralBus_byteSelect(peripheralBus_byteSelect),
				.peripheralBus_dataWrite(peripheralBus_dataWrite),
				.peripheralBus_dataRead(deviceOutputData[(i * 32) + 31:i * 32]),
				.requestOutput(deviceOutputRequest[i]),
				.pwm_en(pwm_en[(i * OUTPUTS_PER_DEVICE) + OUTPUTS_PER_DEVICE - 1:i * OUTPUTS_PER_DEVICE]),
				.pwm_out(pwm_out[(i * OUTPUTS_PER_DEVICE) + OUTPUTS_PER_DEVICE - 1:i * OUTPUTS_PER_DEVICE]),
				.pwm_irq(pwm_irq[i]));
		end
	endgenerate

	assign peripheralBus_busy = 1'b0;

endmodule