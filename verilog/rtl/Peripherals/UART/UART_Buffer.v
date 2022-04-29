(*keep_hierarchy = "yes"*) module UART_Buffer
	#(
		parameter BAUD = 1000000,
		parameter CLK_FREQ = 100000000
	)(
		input wire clk,
		input wire rst,
		input wire RWClock,
		input wire RWReset,

		input wire oe,
		input wire we,
		
		input wire [7:0] inputData,
		output wire [7:0] outputData,
		output wire dataAvailable,
		output wire rxBufferFull,
		output wire txBufferFull,
		
		input wire blockTransmition,
		input wire rx,
		output wire tx
    );

	reg [7:0] inputData_buffered = 'b0;
	reg we_buffered = 'b0;
	reg oe_buffered = 'b0;

	wire [7:0] rx_out;
	wire rx_out_available;
	UART_rx #(.BAUD(BAUD), .CLK_FREQ(CLK_FREQ)) uart_rx(
		.clk(clk),
		.rst(rst),
		.rx(rx),
		.data_out(rx_out),
		.dataAvailable(rx_out_available));
	
	wire tx_busy;
	wire [7:0] tx_in;
	wire tx_in_available;
	UART_tx #(.BAUD(BAUD), .CLK_FREQ(CLK_FREQ)) uart_tx(
		.clk(clk),
		.rst(rst),
		.tx(tx),
		.blockTransmition(blockTransmition),
    	.busy(tx_busy),
    	.data_in(tx_in),
    	.dataAvailable(tx_in_available));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(256)) rxBuffer(
		.clk(clk),
		.rst(rst),
		.data_in(rx_out),
		.we(rx_out_available),
		.data_out(outputData),
		.oe(oe_buffered),		
		.isData(dataAvailable),
		.bufferFull(rxBufferFull));

	FIFO #(.WORD_SIZE(8), .BUFFER_SIZE(256)) txBuffer(
		.clk(clk),
		.rst(rst),
		.data_in(inputData_buffered),
		.we(we_buffered),
		.data_out(tx_in),
		.oe(tx_in_available && !tx_busy),		
		.isData(tx_in_available),
		.bufferFull(txBufferFull));

	always @(posedge RWClock) begin
		if (rst || RWReset) begin
			inputData_buffered = 'b0;
			we_buffered = 'b0;
			oe_buffered = 'b0;
		end else begin
			inputData_buffered = inputData;
			we_buffered = we;
			oe_buffered = oe;
		end
	end

endmodule
