module JTAG (
		input wire clk,
		input wire rst,

		input wire[31:0] coreID,
		input wire[10:0] manufacturerID,
		input wire[15:0] partID,
		input wire[3:0] versionID,

		// JTAG interface
		input wire jtag_tck,
		input wire jtag_tms,
		input wire jtag_tdi,
		output wire jtag_tdo,

		// // Core interface
		// output wire dataAvaliable,
		// output wire[WIDTH:0] dataRead,
		// input wire[WIDTH:0] dataWrite,
		// input wire writeEnable

		output wire[4:0] probe_jtagInstruction
	);
	
	wire[31:0] idcode = { versionID, partID, manufacturerID, 1'b1 };

	// TAP states
	localparam STATE_TEST_LOGIC_RESET = 4'h0;
	localparam STATE_RUN_TEST_IDLE 	  = 4'h1;
	localparam STATE_DR_SELECT_SCAN   = 4'h2;
	localparam STATE_DR_CAPTURE 	  = 4'h3;
	localparam STATE_DR_SHIFT 		  = 4'h4;
	localparam STATE_DR_EXIT_1 		  = 4'h5;
	localparam STATE_DR_PAUSE 		  = 4'h6;
	localparam STATE_DR_EXIT_2 		  = 4'h7;
	localparam STATE_DR_UPDATE 		  = 4'h8;
	localparam STATE_IR_SELECT_SCAN   = 4'h9;
	localparam STATE_IR_CAPTURE 	  = 4'hA;
	localparam STATE_IR_SHIFT 		  = 4'hB;
	localparam STATE_IR_EXIT_1 		  = 4'hC;
	localparam STATE_IR_PAUSE 		  = 4'hD;
	localparam STATE_IR_EXIT_2 		  = 4'hE;
	localparam STATE_IR_UPDATE 		  = 4'hF;

	// https://www.microsemi.com/document-portal/doc_download/130050-ac160-ieee-standard-1149-1-jtag-in-the-sx-rtsx-sx-a-ex-rt54sx-s-families-app-note
	localparam INSTRUCTION_EXTEST 	= 5'b00000;
	localparam INSTRUCTION_SAMPLE 	= 5'b00001;
	localparam INSTRUCTION_INTEST 	= 5'b00010;
	localparam INSTRUCTION_USERCODE = 5'b00011;
	localparam INSTRUCTION_IDCODE 	= 5'b00100;
	localparam INSTRUCTION_BYPASS 	= 5'b11111;
	
	reg tckState = 1'b0;
	reg tckRisingEdge = 1'b0;
	reg tckFallingEdge = 1'b0;

	always @(posedge clk) begin
		if (rst) begin
			tckState <= 1'b0;
			tckRisingEdge = 1'b0;
			tckFallingEdge = 1'b0;
		end else begin
			if (jtag_tck != tckState) begin
				if (jtag_tck) tckRisingEdge = 1'b1;
				else tckFallingEdge = 1'b1;

				tckState <= jtag_tck;
			end else begin
				tckRisingEdge = 1'b0;
				tckFallingEdge = 1'b0;
			end
		end
	end

	reg[3:0] state = STATE_TEST_LOGIC_RESET;
	wire testReset 	   = state == STATE_TEST_LOGIC_RESET;
	wire irCapture 	   = state == STATE_IR_CAPTURE;
	wire drCapture 	   = state == STATE_DR_CAPTURE;
	wire irShiftEnable = state == STATE_IR_SHIFT;
	wire drShiftEnable = state == STATE_DR_SHIFT;
	wire irUpdate 	   = state == STATE_IR_UPDATE;
	wire drUpdate 	   = state == STATE_DR_UPDATE;

	// Instruction register
	reg[4:0] currentInstruction = INSTRUCTION_IDCODE;
	wire irDataOut;
	wire[4:0] irDataRead;
	JTAGRegister #(.WIDTH(5)) instructionRegister (
		.clk(clk),
		.rst(rst),
		.loadEnable(irCapture && tckRisingEdge),
		.shiftEnable(irShiftEnable && tckRisingEdge),
		.parallelIn(currentInstruction),
		.parallelOut(irDataRead),
		.serialIn(jtag_tdi),
		.serialOut(irDataOut));

	always @(posedge clk) begin
		if (rst) currentInstruction <= INSTRUCTION_IDCODE;
		else if ((irUpdate || testReset) && tckRisingEdge) currentInstruction <= irDataRead;
	end

	// Data registers
	// Boundary scan register
	wire drBSRSelect = currentInstruction == INSTRUCTION_SAMPLE;
	wire drBSRDataOut;
	wire[31:0] bsrDataWrite = 32'b0;
	wire[31:0] bsrDataRead;
	JTAGRegister #(.WIDTH(32)) dataBSRRegister (
		.clk(clk),
		.rst(rst),
		.loadEnable(drBSRSelect && drCapture && tckRisingEdge),
		.shiftEnable(drBSRSelect && drShiftEnable && tckRisingEdge),
		.parallelIn(bsrDataWrite),
		.parallelOut(bsrDataRead),
		.serialIn(jtag_tdi),
		.serialOut(drBSRDataOut));

	// Bypass register
	wire drBypassSelect = currentInstruction == INSTRUCTION_BYPASS;
	wire drBypassDataOut;
	wire dataBypassRegisterParallelOut_nc;
	JTAGRegister #(.WIDTH(1)) dataBypassRegister (
		.clk(clk),
		.rst(rst),
		.loadEnable(drBypassSelect && drCapture && tckRisingEdge),
		.shiftEnable(drBypassSelect && drShiftEnable && tckRisingEdge),
		.parallelIn(1'b0),
		.parallelOut(dataBypassRegisterParallelOut_nc),
		.serialIn(jtag_tdi),
		.serialOut(drBypassDataOut));

	// ID code register
	wire drIDUserCode = (currentInstruction == INSTRUCTION_USERCODE);
	wire drIDBaseCode = (currentInstruction == INSTRUCTION_IDCODE);
	wire drIDSelect = drIDUserCode || drIDBaseCode;
	wire[31:0] drIDDataIn = drIDUserCode ? coreID : idcode;
	wire drIDDataOut;
	wire[31:0] dataIDRegisterParallelOut_nc;
	JTAGRegister #(.WIDTH(32)) dataIDRegister (
		.clk(clk),
		.rst(rst),
		.loadEnable(drIDSelect && drCapture && tckRisingEdge),
		.shiftEnable(drIDSelect && drShiftEnable && tckRisingEdge),
		.parallelIn(drIDDataIn),
		.parallelOut(dataIDRegisterParallelOut_nc),
		.serialIn(jtag_tdi),
		.serialOut(drIDDataOut));

	wire drDataOut = drBSRSelect 	? drBSRDataOut : 
					 drBypassSelect ? drBypassDataOut : 
					 drIDSelect 	? drIDDataOut :
					 				  1'b0;

	assign jtag_tdo = drShiftEnable ? drDataOut :
				 	  irShiftEnable ? irDataOut :
				 				 	  1'b0;

	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_TEST_LOGIC_RESET;
		end else begin
			if (tckRisingEdge) begin
				case (state)
					STATE_TEST_LOGIC_RESET:	state <= jtag_tms ? STATE_TEST_LOGIC_RESET : STATE_RUN_TEST_IDLE;
					STATE_RUN_TEST_IDLE:	state <= jtag_tms ? STATE_DR_SELECT_SCAN   : STATE_RUN_TEST_IDLE;
					STATE_DR_SELECT_SCAN:	state <= jtag_tms ? STATE_IR_SELECT_SCAN   : STATE_DR_CAPTURE;
					STATE_DR_CAPTURE:		state <= jtag_tms ? STATE_DR_EXIT_1 	   : STATE_DR_SHIFT;
					STATE_DR_SHIFT:			state <= jtag_tms ? STATE_DR_EXIT_1 	   : STATE_DR_SHIFT;
					STATE_DR_EXIT_1:		state <= jtag_tms ? STATE_DR_UPDATE 	   : STATE_DR_PAUSE;
					STATE_DR_PAUSE:			state <= jtag_tms ? STATE_DR_EXIT_2 	   : STATE_DR_PAUSE;
					STATE_DR_EXIT_2:		state <= jtag_tms ? STATE_DR_UPDATE 	   : STATE_DR_SHIFT;
					STATE_DR_UPDATE:		state <= jtag_tms ? STATE_DR_SELECT_SCAN   : STATE_RUN_TEST_IDLE;
					STATE_IR_SELECT_SCAN:	state <= jtag_tms ? STATE_TEST_LOGIC_RESET : STATE_IR_CAPTURE;
					STATE_IR_CAPTURE:		state <= jtag_tms ? STATE_IR_EXIT_1 	   : STATE_IR_SHIFT;
					STATE_IR_SHIFT:			state <= jtag_tms ? STATE_IR_EXIT_1 	   : STATE_IR_SHIFT;
					STATE_IR_EXIT_1:		state <= jtag_tms ? STATE_IR_UPDATE 	   : STATE_IR_PAUSE;
					STATE_IR_PAUSE:			state <= jtag_tms ? STATE_IR_EXIT_2 	   : STATE_IR_PAUSE;
					STATE_IR_EXIT_2:		state <= jtag_tms ? STATE_IR_UPDATE 	   : STATE_IR_SHIFT;
					STATE_IR_UPDATE:		state <= jtag_tms ? STATE_DR_SELECT_SCAN   : STATE_RUN_TEST_IDLE;
					default:				state <= STATE_TEST_LOGIC_RESET;
				endcase
			end
		end
	end

	assign probe_jtagInstruction = currentInstruction;
endmodule