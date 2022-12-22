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

		// Management interface
		output wire management_enable,
		output wire management_writeEnable,
		output wire[3:0] management_byteSelect,
		output wire[19:0] management_address,
		output wire[31:0] management_writeData,
		input wire[31:0] management_readData,

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
	wire bsrReadEnable = drBSRSelect && drCapture && tckRisingEdge;
	wire bsrWriteEnable = drBSRSelect && drUpdate && tckRisingEdge;
	wire drBSRDataOut;
	wire[31:0] bsrDataWrite;
	wire[31:0] bsrDataRead;
	JTAGRegister #(.WIDTH(32)) dataBSRRegister (
		.clk(clk),
		.rst(rst),
		.loadEnable(bsrReadEnable),
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

	// Core managment control
	localparam MANAGEMENT_STATE_IDLE = 3'h0;
	localparam MANAGEMENT_STATE_READ = 3'h1;
	localparam MANAGEMENT_STATE_RETURN_DATA = 3'h2;
	localparam MANAGEMENT_STATE_GET_DATA = 3'h3;
	localparam MANAGEMENT_STATE_WRITE = 3'h4;

	reg[2:0] managementState = MANAGEMENT_STATE_IDLE;
	reg[31:0] managementReadData = 32'b0;
	reg[25:0] managementAddress = 20'b0;
	reg[31:0] managementWriteData = 32'b0;
	reg[3:0] managementByteSelect = 4'h0;

	wire managementCommandByteSelect = bsrDataRead[29:26];
	wire managementCommandWriteEnable = bsrDataRead[30];
	wire managementCommandReadEnable = bsrDataRead[31];

	always @(posedge clk) begin
		if (rst) begin
			managementState <= MANAGEMENT_STATE_IDLE;
			managementReadData <= 32'b0;
			managementAddress <= 26'b0;
			managementWriteData <= 32'b0;
			managementByteSelect <= 4'h0;
		end else begin
			case (managementState)
				MANAGEMENT_STATE_IDLE: begin
					managementReadData <= 32'b0;
					
					if (bsrWriteEnable) begin
						if (!managementCommandByteSelect) begin
							managementAddress <= bsrDataRead[19:0];
							managementByteSelect <= managementCommandByteSelect;

							if (managementCommandWriteEnable) managementState <= MANAGEMENT_STATE_GET_DATA; 
							if (managementCommandReadEnable) managementState <= MANAGEMENT_STATE_READ;
						end
					end
				end

				MANAGEMENT_STATE_READ: begin
					managementReadData <= management_readData;
					managementState <= MANAGEMENT_STATE_RETURN_DATA;
				end

				MANAGEMENT_STATE_RETURN_DATA: begin
					if (bsrReadEnable) managementState <= MANAGEMENT_STATE_IDLE;
				end

				MANAGEMENT_STATE_GET_DATA: begin
					if (bsrWriteEnable) begin
						managementWriteData <= bsrDataRead;
						managementState <= MANAGEMENT_STATE_WRITE; 
					end
				end

				MANAGEMENT_STATE_WRITE: begin
					managementState <= MANAGEMENT_STATE_IDLE;
				end				

				default: begin
					managementState <= MANAGEMENT_STATE_IDLE;
				end
			endcase
		end
	end

	assign bsrDataWrite = managementReadData;

	assign management_writeEnable = managementState == MANAGEMENT_STATE_WRITE;
	assign management_enable = (managementState == MANAGEMENT_STATE_READ) || (managementState == MANAGEMENT_STATE_WRITE);
	assign management_byteSelect = managementByteSelect;
	assign management_address = managementAddress[19:0];
	assign management_writeData = managementState == MANAGEMENT_STATE_WRITE ? managementReadData : 32'b0;

endmodule