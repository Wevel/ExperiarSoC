module FlashBuffer #(
		parameter SRAM_ADDRESS_SIZE = 9
	)(
		input wire clk,
		input wire rst,

		// Flash cache interface		
		input wire flashCache_readEnable,
		input wire[23:0] flashCache_address,
		input wire[3:0] flashCache_byteSelect,
		output wire[31:0] flashCache_dataRead,
		output wire flashCache_busy,

		// QSPI device
		output wire[23:0] dataRequest_address,
		output wire dataRequest_enable,
		input wire[31:0] dataRequest_data,
		input wire dataRequest_dataValid,

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
	
	//TODO: Flash cache control
	assign dataRequest_address = flashCache_address;
	assign dataRequest_enable = 1'b0;

	// Remember that the read data is only valid on the next clock cycle
	reg flashCacheReadReady = 1'b0;
	always @(posedge clk) begin
		if (rst) flashCacheReadReady <= 1'b0;
		else if (flashCache_readEnable) flashCacheReadReady <= 1'b1;
		else flashCacheReadReady <= 1'b0;
	end

	assign flashCache_dataRead = {
		flashCache_byteSelect[3] && flashCacheReadReady ? sram_dout1[31:24] : 8'h00,
		flashCache_byteSelect[2] && flashCacheReadReady ? sram_dout1[23:16] : 8'h00,
		flashCache_byteSelect[1] && flashCacheReadReady ? sram_dout1[15:8]  : 8'h00,
		flashCache_byteSelect[0] && flashCacheReadReady ? sram_dout1[7:0]   : 8'h00
	};

	assign flashCache_busy = flashCache_readEnable && !flashCacheReadReady;

	assign sram_clk0 = clk;
	assign sram_csb0 = 1'b1;	// Active low chip enable
	assign sram_web0 = 1'b1;	// Active low write enable (probably keep as always write)
	assign sram_wmask0 = 4'b1111;
	assign sram_addr0 = {SRAM_ADDRESS_SIZE{1'b0}};
	assign sram_din0 = 32'b0;

	// Read port
	wire validAddress = flashCache_address[23:SRAM_ADDRESS_SIZE+1] == 'b0;
	assign sram_clk1 = clk;
	assign sram_csb1 = !(validAddress && flashCache_readEnable);
	assign sram_addr1 = flashCache_address[SRAM_ADDRESS_SIZE+1:2];

endmodule