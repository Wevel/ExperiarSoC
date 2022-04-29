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
		inout wire[31:0] peripheralBus_data,

		output wire[15:0] pwm_en,
		output wire[15:0] pwm_out
	);

	localparam DEVICE_COUNT = 4;
	localparam OUTPUTS_PER_DEVICE = 4;

	// Peripheral select
	wire[15:0] localAddress;
	wire peripheralEnable;
	//(*keep_hierarchy = "yes"*)
	PeripheralSelect #(.ID(ID)) select(
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.peripheralEnable(peripheralEnable));

	genvar i;
	generate
		for (i = 0; i < DEVICE_COUNT; i = i + 1) begin
			PWMDevice #(.ID(4'(i+1)), .OUTPUTS(OUTPUTS_PER_DEVICE), .WIDTH(16), .CLOCK_WIDTH(32)) device(
				.clk(clk),
				.rst(rst),
				.peripheralEnable(peripheralEnable),
				.peripheralBus_we(peripheralBus_we),
				.peripheralBus_oe(peripheralBus_oe),
				.peripheralBus_busy(),
				.peripheralBus_address(localAddress),
				.peripheralBus_data(peripheralBus_data),
				.pwm_en(pwm_en[(i * OUTPUTS_PER_DEVICE) + OUTPUTS_PER_DEVICE - 1:i * OUTPUTS_PER_DEVICE]),
				.pwm_out(pwm_out[(i * OUTPUTS_PER_DEVICE) + OUTPUTS_PER_DEVICE - 1:i * OUTPUTS_PER_DEVICE]));
		end
	endgenerate

	assign peripheralBus_busy = 1'b0;

endmodule