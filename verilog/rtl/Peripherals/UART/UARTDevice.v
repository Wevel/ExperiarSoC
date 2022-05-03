module UARTDevice  #(
		parameter ID = 4'h0
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
		
		// PWM output
		output wire uart_en,
		input wire uart_rx,
		output wire uart_tx
	);

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Register
	// Configuration register Default 0x01047
	// b00-b15: cyclesPerBit  Default 0x1047	((CLK_FREQ + BAUD) / BAUD) - 1 => Default uses CLK_FREQ=40MHz BAUD=9600(Actually 9599.2)
	// b16: waitForTxSpace	  Default 0x0
	// b17: enable 			  Default 0x0
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	wire[17:0] configuration;
	ConfigurationRegister #(.WIDTH(18), .ADDRESS(12'h000), .DEFAULT(18'h01047)) configurationRegister(
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

	wire[15:0] cyclesPerBit = configuration[15:0];
	wire waitForTxSpace = configuration[16];
	assign uart_en = configuration[17];

	// Clear register
	wire[3:0] clearWriteData;
	wire clearWriteEnable;
	DataRegister #(.WIDTH(4), .ADDRESS(12'h004)) clearRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(),
		.requestOutput(),
		.writeData(clearWriteData),
		.writeData_en(clearWriteEnable),
		.writeData_busy(1'b0),
		.readData('b0),
		.readData_en(),
		.readData_busy(1'b0));

	// Status register
	// b00: rxDataAvailable
	// b01: rxBufferFull
	// b02: rxDataLost
	// b03: txByteOutAvailable
	// b04: txBufferFull
	// b05: txDataLost
	wire txDataLost;
	wire txBufferFull;
	wire txByteOutAvailable;
	wire rxDataLost;
	wire rxBufferFull;
	wire rxDataAvailable;
	wire[31:0] statusRegisterOutputData;
	wire statusRegisterOutputRequest;
	DataRegister #(.WIDTH(6), .ADDRESS(12'h008)) statusRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(statusRegisterOutputData),
		.requestOutput(statusRegisterOutputRequest),
		.writeData(),
		.writeData_en(),
		.writeData_busy(1'b0),
		.readData({ txDataLost, txBufferFull, txByteOutAvailable, rxDataLost, rxBufferFull, rxDataAvailable }),
		.readData_en(),
		.readData_busy(1'b0));

	// Rx register
	wire[31:0] rxRegisterOutputData;
	wire rxRegisterOutputRequest;
	wire[7:0] rxReadData;
	wire rxReadDataEnable;
	DataRegister #(.WIDTH(8), .ADDRESS(12'h010)) rxRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(rxRegisterOutputData),
		.requestOutput(rxRegisterOutputRequest),
		.writeData(),
		.writeData_en(),
		.writeData_busy(1'b0),
		.readData(rxDataAvailable ? rxReadData : 8'h0),
		.readData_en(rxReadDataEnable),
		.readData_busy(1'b0));

	// Tx register
	wire[31:0] txRegisterOutputData;
	wire txRegisterOutputRequest;
	wire[7:0] txWriteData;	
	wire txWriteDataEnable;
	wire txBusy;
	DataRegister #(.WIDTH(8), .ADDRESS(12'h014)) txRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(txBusy),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(txRegisterOutputData),
		.requestOutput(txRegisterOutputRequest),
		.writeData(txWriteData),
		.writeData_en(txWriteDataEnable),
		.writeData_busy(waitForTxSpace && txBufferFull && uart_en),
		.readData('b0),
		.readData_en(),
		.readData_busy(1'b0));

	wire [7:0] rxByteIn;
	wire rxOutAvailable;
	UART_rx #(.CLOCK_SCALE_BITS(16)) uartRx(
		.clk(clk),
		.rst(rst || (clearWriteData[0] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.cyclesPerBit(cyclesPerBit),
		.rx(uart_rx),
		.dataOut(rxByteIn),
		.dataAvailable(rxOutAvailable));
	
	wire txSendBusy;
	wire[7:0] txByteOut;
	UART_tx #(.CLOCK_SCALE_BITS(16)) uartTx(
		.clk(clk),
		.rst(rst || (clearWriteData[1] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.cyclesPerBit(cyclesPerBit),
		.tx(uart_tx),
		.blockTransmition(1'b0),
    	.busy(txSendBusy),
    	.dataIn(txByteOut),
    	.dataAvailable(txByteOutAvailable));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(16)) rxBuffer(
		.clk(clk),
		.rst(rst || (clearWriteData[2] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.dataIn(rxByteIn),
		.we(rxOutAvailable && uart_en),
		.dataOut(rxReadData),
		.oe(rxReadDataEnable),		
		.isData(rxDataAvailable),
		.bufferFull(rxBufferFull),
		.dataLost(rxDataLost));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(16)) txBuffer(
		.clk(clk),
		.rst(rst || (clearWriteData[3] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.dataIn(txWriteData),
		.we(txWriteDataEnable && peripheralBus_byteSelect[0] && (!waitForTxSpace || !txBufferFull)),
		.dataOut(txByteOut),
		.oe(txByteOutAvailable && uart_en && !txSendBusy),		
		.isData(txByteOutAvailable),
		.bufferFull(txBufferFull),
		.dataLost(txDataLost));

	assign requestOutput = configurationRegisterOutputRequest || statusRegisterOutputRequest || rxRegisterOutputRequest || txRegisterOutputRequest;
	assign peripheralBus_dataRead = configurationRegisterOutputRequest ? configurationRegisterOutputData :
									statusRegisterOutputRequest		   ? statusRegisterOutputData :
								    rxRegisterOutputRequest 		   ? rxRegisterOutputData :
									txRegisterOutputRequest 		   ? txRegisterOutputData :
													   					 32'b0;
	assign peripheralBus_busy = txBusy;


endmodule