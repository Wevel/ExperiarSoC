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
		output wire uart_tx,
		output wire uart_irq
	);

	localparam RX_BUFFER_SIZE = 32;
	localparam TX_BUFFER_SIZE = 32;

	// Buffer values used for interrupts and status register
	wire txDataLost;
	wire txBufferFull;
	wire txDataAvailable;
	wire rxDataLost;
	wire rxBufferFull;
	wire rxDataAvailable;

	reg txDataLostBuffered;
	reg txBufferFullBuffered;
	reg txDataAvailableBuffered;
	reg rxDataLostBuffered;
	reg rxBufferFullBuffered;
	reg rxDataAvailableBuffered;

	always @(posedge clk) begin
		if (rst) begin
			txDataLostBuffered <= 1'b0;
			txBufferFullBuffered <= 1'b0;
			txDataAvailableBuffered <= 1'b0;
			rxDataLostBuffered <= 1'b0;
			rxBufferFullBuffered <= 1'b0;
			rxDataAvailableBuffered <= 1'b0;
		end else begin
			txDataLostBuffered <= txDataLost;
			txBufferFullBuffered <= txBufferFull;
			txDataAvailableBuffered <= txDataAvailable;
			rxDataLostBuffered <= rxDataLost;
			rxBufferFullBuffered <= rxBufferFull;
			rxDataAvailableBuffered <= rxDataAvailable;
		end
	end

	// Device select
	wire[11:0] localAddress;
	wire deviceEnable;
	DeviceSelect #(.ID(ID)) select(
		.peripheralEnable(peripheralEnable),
		.peripheralBus_address(peripheralBus_address),
		.localAddress(localAddress),
		.deviceEnable(deviceEnable));

	// Register
	// Configuration register 				Default 0x01047
	// b00-b15: cyclesPerBit  				Default 0x1047	((CLK_FREQ + BAUD) / BAUD) - 1 => Default uses CLK_FREQ=40MHz BAUD=9600(Actually 9599.2)
	// b16: waitForTxSpace	  				Default 0x0
	// b17: enable 			  				Default 0x0
	// b18: dataLostInterruptEnable			Default 0x0
	// b19: rxDataAvaliableInterruptEnable	Default 0x0
	// b20: txDataSentInterruptEnable		Default 0x0
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	wire[20:0] configuration;
	ConfigurationRegister #(.WIDTH(21), .ADDRESS(12'h000), .DEFAULT(21'h001047)) configurationRegister(
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
	wire dataLostInterruptEnable = configuration[18];
	wire rxDataAvaliableInterruptEnable = configuration[19];
	wire txDataSentInterruptEnable = configuration[20];

	// Clear register
	wire[3:0] clearWriteData;
	wire clearWriteEnable;
	wire clearRegisterBusyBusy_nc;
	wire[31:0] clearRegisterDataOut;
	wire clearRegisterRequestOutput_nc;
	wire clearRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(4), .ADDRESS(12'h004)) clearRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(clearRegisterBusyBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(clearRegisterDataOut),
		.requestOutput(clearRegisterRequestOutput_nc),
		.writeData(clearWriteData),
		.writeData_en(clearWriteEnable),
		.writeData_busy(1'b0),
		.readData(4'b0),
		.readData_en(clearRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	// Status register
	// b00: rxDataAvailable
	// b01: rxBufferFull
	// b02: rxDataLost
	// b03: txDataAvailable
	// b04: txBufferFull
	// b05: txDataLost
	reg[5:0] statusRegisterBuffered;
	wire[31:0] statusRegisterOutputData;
	wire statusRegisterOutputRequest;
	wire statusRegisterBusBusy_nc;
	wire[5:0] statusRegisterWriteData_nc;
	wire statusRegisterWriteDataEnable_nc;
	wire statusRegisterReadDataEnable_nc;
	DataRegister #(.WIDTH(6), .ADDRESS(12'h008)) statusRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(statusRegisterBusBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(statusRegisterOutputData),
		.requestOutput(statusRegisterOutputRequest),
		.writeData(statusRegisterWriteData_nc),
		.writeData_en(statusRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(statusRegisterBuffered),
		.readData_en(statusRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	always @(posedge clk) begin
		if (rst) statusRegisterBuffered <= 6'b0;
		else begin
			statusRegisterBuffered <= { 
				txDataLostBuffered, 
				txBufferFullBuffered, 
				txDataAvailableBuffered, 
				rxDataLostBuffered, 
				rxBufferFullBuffered, 
				rxDataAvailableBuffered
			};
		end
	end

	// Rx register
	reg[8:0] rxRegisterBuffered;
	wire[31:0] rxRegisterOutputData;
	wire rxRegisterOutputRequest;
	wire[7:0] rxReadData;
	wire rxReadDataEnable;
	wire rxRegisterBusyBusy_nc;
	wire[8:0] rxRegisterWriteData_nc;
	wire rxRegisterWriteDataEnable_nc;
	DataRegister #(.WIDTH(9), .ADDRESS(12'h010)) rxRegister(
		.clk(clk),
		.rst(rst),
		.enable(deviceEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_busy(rxRegisterBusyBusy_nc),
		.peripheralBus_address(localAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(rxRegisterOutputData),
		.requestOutput(rxRegisterOutputRequest),
		.writeData(rxRegisterWriteData_nc),
		.writeData_en(rxRegisterWriteDataEnable_nc),
		.writeData_busy(1'b0),
		.readData(rxRegisterBuffered),
		.readData_en(rxReadDataEnable),
		.readData_busy(1'b0));

	always @(posedge clk) begin
		if (rst) rxRegisterBuffered <= 9'b0;
		else rxRegisterBuffered <= rxDataAvailable ? { 1'b1, rxReadData } : 9'h0;
	end

	// Tx register
	wire[31:0] txRegisterOutputData;
	wire txRegisterOutputRequest;
	wire[7:0] txWriteData;	
	wire txWriteDataEnable;
	wire txBusy;
	wire txRegisterReadDataEnable_nc;
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
		.readData(8'b0),
		.readData_en(txRegisterReadDataEnable_nc),
		.readData_busy(1'b0));

	wire [7:0] rxByteIn;
	wire rxOutAvailable;
	UART_rx #(.CLOCK_SCALE_BITS(16)) uartRx(
		.clk(clk),
		.rst(rst || (clearWriteData[0] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.cyclesPerBit(cyclesPerBit),
		.rx(uart_en ? uart_rx : 1'b1),
		.dataOut(rxByteIn),
		.dataAvailable(rxOutAvailable));
	
	wire txSendBusy;
	wire[7:0] txByteOut;
	UART_tx #(.CLOCK_SCALE_BITS(16)) uartTx(
		.clk(clk),
		.rst(rst || (clearWriteData[1] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.cyclesPerBit(cyclesPerBit),
		.tx(uart_tx),
		.blockTransmition(!uart_en),
    	.busy(txSendBusy),
    	.dataIn(txByteOut),
    	.dataAvailable(txDataAvailable));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(RX_BUFFER_SIZE)) rxBuffer(
		.clk(clk),
		.rst(rst || (clearWriteData[2] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.dataIn(rxByteIn),
		.we(rxOutAvailable && uart_en),
		.dataOut(rxReadData),
		.oe(rxReadDataEnable),		
		.isData(rxDataAvailable),
		.bufferFull(rxBufferFull),
		.dataLost(rxDataLost));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(TX_BUFFER_SIZE)) txBuffer(
		.clk(clk),
		.rst(rst || (clearWriteData[3] && clearWriteEnable && peripheralBus_byteSelect[0])),
		.dataIn(txWriteData),
		.we(txWriteDataEnable && peripheralBus_byteSelect[0] && (!waitForTxSpace || !txBufferFull)),
		.dataOut(txByteOut),
		.oe(txDataAvailable && uart_en && !txSendBusy),		
		.isData(txDataAvailable),
		.bufferFull(txBufferFull),
		.dataLost(txDataLost));

	assign requestOutput = configurationRegisterOutputRequest || statusRegisterOutputRequest || rxRegisterOutputRequest || txRegisterOutputRequest;
	assign peripheralBus_dataRead = configurationRegisterOutputRequest ? configurationRegisterOutputData :
									statusRegisterOutputRequest		   ? statusRegisterOutputData :
								    rxRegisterOutputRequest 		   ? rxRegisterOutputData :
									txRegisterOutputRequest 		   ? txRegisterOutputData :
													   					 ~32'b0;
	assign peripheralBus_busy = txBusy;

	reg sendingData = 1'b0;
	always @(posedge clk) begin
		if (rst) sendingData <= 1'b0;
		else sendingData <= txDataAvailableBuffered;
	end

	assign uart_irq = (dataLostInterruptEnable && (rxDataLostBuffered || txDataLostBuffered))
				   || (rxDataAvaliableInterruptEnable && rxDataAvailableBuffered)
				   || (txDataSentInterruptEnable && sendingData && !txDataAvailableBuffered);

endmodule