module FlashBuffer #(
		parameter SRAM_ADDRESS_SIZE = 9
	)(
		input wire clk,
		input wire rst,

		// Peripheral Bus
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		input wire[23:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		input wire[31:0] peripheralBus_dataWrite,
		output reg[31:0] peripheralBus_dataRead,
		output wire peripheralBus_busy,

		// QSPI device
		output wire qspi_enable,
		output wire[23:0] qspi_address,
		output wire qspi_changeAddress,
		output reg qspi_requestData,
		input wire[31:0] qspi_readData,
		input wire qspi_readDataValid,

		// Flash controller SRAM rw port
		output wire sram_clk0,
		output wire sram_csb0,
		output wire sram_web0,
		output wire[3:0] sram_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0,
		output wire[31:0] sram_din0,
		input wire[31:0] sram_dout0,

		// Wishbone SRAM r port
		output wire sram_clk1,
		output wire sram_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1,
		input wire[31:0] sram_dout1
	);

	reg[23:0] cachedAddress;
	reg[SRAM_ADDRESS_SIZE:0] cachedCount;
	wire[SRAM_ADDRESS_SIZE:0] nextCachedCount = cachedCount + 1;
	wire[SRAM_ADDRESS_SIZE:0] cachedCountFinal = { 1'b1, {(SRAM_ADDRESS_SIZE){1'b0}} };

	// Select
	wire sramEnable = peripheralBus_address[23:SRAM_ADDRESS_SIZE+2] == {(22-SRAM_ADDRESS_SIZE){1'b0}};
	wire registersEnable = peripheralBus_address[23:12] == 12'h001;
	wire[11:0] localAddress = peripheralBus_address[11:0];

	// Register
	// Configuration register 	Default 0x0
	// b00: enable				Default 0x0
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	wire configuration;
	ConfigurationRegister #(.WIDTH(1), .ADDRESS(12'h000), .DEFAULT(1'b0)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.enable(registersEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(configurationRegisterOutputData),
		.requestOutput(configurationRegisterOutputRequest),
		.currentValue(configuration));

	assign qspi_enable = configuration;

	// Base address register 	 Default 0x0
	reg[23:0] baseAddress;
	wire[31:0] baseAddressRegisterOutputData;
	wire baseAddressRegisterOutputRequest;
	wire baseAddressRegisterBusBusy_nc;
	wire[23:0] baseAddressRegisterWriteData;
	wire baseAddressRegisterWriteDataEnable;
	wire baseAddressRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(24), .ADDRESS(12'h004)) baseAddressRegister(
		.clk(clk),
		.rst(rst),
		.enable(registersEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(baseAddressRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(baseAddressRegisterOutputData),
		.requestOutput(baseAddressRegisterOutputRequest),
		.writeData(baseAddressRegisterWriteData),
		.writeData_en(baseAddressRegisterWriteDataEnable),
		.writeData_busy(1'b0),
		.readData(baseAddress),
		.readData_en(baseAddressRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	always @(posedge clk) begin
		if (rst) baseAddress <= 24'b0;
		else if (baseAddressRegisterWriteDataEnable) baseAddress <= baseAddressRegisterWriteData;
	end

	// Cached address register
	wire[31:0] cachedAddressRegisterOutputData;
	wire cachedAddressRegisterOutputRequest;
	wire cachedAddressRegisterBusBusy_nc;
	wire[23:0] cachedAddressRegisterWriteData_nc;
	wire cachedAddressRegisterWriteDataEnable_nc;
	wire cachedAddressRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(24), .ADDRESS(12'h008)) cachedAddressRegister(
		.clk(clk),
		.rst(rst),
		.enable(registersEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(cachedAddressRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(cachedAddressRegisterOutputData),
		.requestOutput(cachedAddressRegisterOutputRequest),
		.writeData(cachedAddressRegisterWriteData_nc),
		.writeData_en(cachedAddressRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(cachedAddress),
		.readData_en(cachedAddressRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	// Remember that the read data is only valid on the next clock cycle
	reg flashCacheReadReady = 1'b0;
	always @(posedge clk) begin
		if (rst) flashCacheReadReady <= 1'b0;
		else if (peripheralBus_oe && sramEnable) flashCacheReadReady <= 1'b1;
		else flashCacheReadReady <= 1'b0;
	end

	// Assign peripheral read
	always @(*) begin
		case (1'b1)
			configurationRegisterOutputRequest: peripheralBus_dataRead <= configurationRegisterOutputData;
			baseAddressRegisterOutputRequest: peripheralBus_dataRead <= baseAddressRegisterOutputData;
			cachedAddressRegisterOutputRequest: peripheralBus_dataRead <= cachedAddressRegisterOutputData;
			flashCacheReadReady: peripheralBus_dataRead <= sram_dout1;
			default: peripheralBus_dataRead <= 32'b0;
		endcase
	end

	assign peripheralBus_busy = peripheralBus_oe && sramEnable && !flashCacheReadReady;

	// QSPI interface
	always @(posedge clk) begin
		if (rst) begin
			cachedAddress <= 32'b0;
			cachedCount <= {SRAM_ADDRESS_SIZE{1'b0}};
			qspi_requestData <= 1'b0;
		end	else if (baseAddressRegisterWriteDataEnable) begin
			cachedAddress <= { baseAddressRegisterWriteData[23:2], 2'b00 };
			cachedCount <= {SRAM_ADDRESS_SIZE{1'b0}};
			qspi_requestData <= 1'b1;
		end else if (qspi_requestData && qspi_readDataValid) begin
			cachedAddress <= cachedAddress + 4;
			cachedCount <= nextCachedCount;
			qspi_requestData <= nextCachedCount != cachedCountFinal;
		end
	end

	assign qspi_address = baseAddressRegisterWriteData;
	assign qspi_changeAddress = baseAddressRegisterWriteDataEnable;

	// Assign sram port
	// Read/write port
	assign sram_clk0 = clk;
	assign sram_csb0 = !(qspi_requestData && qspi_readDataValid);	// Active low chip enable
	assign sram_web0 = 1'b0;	// Active low write enable (probably keep as always write)
	assign sram_wmask0 = 4'b1111;
	assign sram_addr0 = cachedAddress[SRAM_ADDRESS_SIZE+1:2];
	assign sram_din0 = qspi_readData;

	// Read port
	assign sram_clk1 = clk;
	assign sram_csb1 = !(sramEnable && peripheralBus_oe);
	assign sram_addr1 = peripheralBus_address[SRAM_ADDRESS_SIZE+1:2];

endmodule