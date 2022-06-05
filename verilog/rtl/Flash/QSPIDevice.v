module QSPIDevice (
		input wire clk,
		input wire rst,

		// Cache interface
		input wire qspi_enable,
		input wire[23:0] qspi_address,
		input wire qspi_changeAddress,
		input wire qspi_requestData,
		output wire[31:0] qspi_readData,
		output reg qspi_readDataValid,

		// QSPI interface
		output wire flash_csb,
		output reg flash_sck,
		output wire flash_io0_we,
		output wire flash_io0_write,
		input wire flash_io0_read, 	// Unused
		output wire flash_io1_we,
		output wire flash_io1_write,  // Unused (constant 1'b0)
		input wire flash_io1_read
	);
	
	localparam STATE_IDLE = 2'h0;
	localparam STATE_SETUP = 2'h1;
	localparam STATE_SHIFT = 2'h2;
	localparam STATE_END = 2'h3;

	localparam RESET_NONE = 2'h0;
	localparam RESET_START = 2'h1;
	localparam RESET_WAKE = 2'h2;

	// Assign these as constants to be in a default spi mode
	assign flash_io0_we = 1'b1;
	assign flash_io1_we = 1'b0;
	assign flash_io1_write = 1'b0;

	// State control
	reg[1:0] state = STATE_IDLE;
	wire deviceBusy = state != STATE_IDLE;
	reg[1:0] resetState = RESET_NONE;
	wire resetDevice = resetState != RESET_NONE;
	reg settingAddress = 1'b0;

	reg outputClock = 1'b0;	
	reg[4:0] bitCounter = 5'b0;
	wire[4:0] nextBitCounter = bitCounter + 1;
	
	wire shiftInEnable  = outputClock && deviceBusy;
	wire shiftOutEnable = !outputClock && deviceBusy;

	reg[31:0] registerLoadData;
	wire serialOut;
	wire[31:0] flashData;
	ShiftRegister #(.WIDTH(32)) register (
		.clk(clk),
		.rst(rst),
		.loadEnable((!deviceBusy && qspi_changeAddress) || ((state == STATE_SETUP) && resetDevice)),
		.shiftInEnable(shiftInEnable),
		.shiftOutEnable(shiftOutEnable),
		.msbFirst(1'b1),
		.parallelIn(registerLoadData),
		.parallelOut(flashData),
		.serialIn(flash_io1_read),
		.serialOut(serialOut));

	// Reorder bytes
	assign qspi_readData = { flashData[7:0], flashData[15:8], flashData[23:16], flashData[31:24] };

	always @(*) begin
		case (1'b1)
			resetState == RESET_START: registerLoadData <= { 8'hFF, 8'h00, 8'h00, 8'h00 };
			resetState == RESET_WAKE: registerLoadData <= { 8'hAB, 8'h00, 8'h00, 8'h00 };
			qspi_changeAddress: registerLoadData <= { 8'h03, qspi_address };
			default: registerLoadData <= 32'b0;
		endcase
	end

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_IDLE;
			outputClock <= 1'b0;
			bitCounter <= 5'b0;
			resetState <= RESET_START;
			settingAddress <= 1'b0;
			qspi_readDataValid <= 1'b0;
		end else begin
			case (state)
				STATE_IDLE: begin
					outputClock <= 1'b0;
					bitCounter <= 5'b0;

					if (qspi_enable) begin
						if (resetDevice || qspi_changeAddress) begin
							state <= STATE_SETUP;
							settingAddress <= qspi_changeAddress;
						end
					end
				end

				STATE_SETUP: begin
					state <= STATE_SHIFT;
					bitCounter <= 5'b0;
					outputClock <= 1'b1;
					qspi_readDataValid <= 1'b0;		
				end

				STATE_SHIFT: begin
					if (!outputClock) begin
						if ((resetDevice && bitCounter == 5'h07) || (bitCounter == 5'h1F)) begin
							state <= STATE_END;
							qspi_readDataValid <= !settingAddress;
						end	else begin
							bitCounter <= nextBitCounter;
							outputClock <= 1'b1;
						end
					end else begin
						outputClock <= 1'b0;
					end

					if (qspi_changeAddress) state <= STATE_IDLE;
				end

				STATE_END: begin
					if (qspi_requestData) state <= STATE_SETUP;
					else state <= STATE_IDLE;

					outputClock <= 1'b0;
					settingAddress <= 1'b0;
					qspi_readDataValid <= 1'b0;
					
					if (resetState == RESET_START) resetState <= RESET_WAKE;
					else resetState <= RESET_NONE;
				end

				default: begin
					state <= STATE_IDLE;
					bitCounter <= 5'b0;
					outputClock <= 1'b0;
					settingAddress <= 1'b0;
					qspi_readDataValid <= 1'b0;
					resetState <= RESET_START;
				end
			endcase
		end
	end

	// Buffer the spi clock by one cycle so that it lines up with when data is sampled
	always @(posedge clk) begin
		if (rst) flash_sck <= 1'b0;
		else flash_sck <= outputClock;
	end

	assign flash_io0_write = serialOut & deviceBusy;
	assign flash_csb = !deviceBusy;

endmodule