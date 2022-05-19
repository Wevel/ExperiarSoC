module VideoMemory (
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire clk,
		input wire rst,

		// Peripheral bus interface
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[23:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		input wire[31:0] peripheralBus_dataWrite,
		output reg[31:0] peripheralBus_dataRead,
		output wire requestOutput,

		// Video interface
		input wire video_clk,
		input wire[SRAM_ADDRESS_SIZE+3:0] video_address,
		output reg[31:0] video_data,

		// Video SRAM rw port
		output wire sram_clk0,
		output reg[3:0] sram_csb0,
		output wire sram_web0,
		output wire[3:0] sram_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0,
		output wire[31:0] sram_din0,
		input wire[127:0] sram_dout0,

		// Video SRAM r port
		output wire sram_clk1,
		output reg[3:0] sram_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1,
		input wire[127:0] sram_dout1
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	wire peripheralBusEnableSRAM = (peripheralBus_we || peripheralBus_oe);
	wire[1:0] peripheralBusSRAMBank = peripheralBus_address[SRAM_ADDRESS_SIZE+3:SRAM_ADDRESS_SIZE+2];

	// Set enable bit for peripheral bus port (active low)
	always @(*) begin
		if (peripheralBusEnableSRAM) begin
			case (peripheralBusSRAMBank)
				2'b00: sram_csb0 <= 4'b1110;
				2'b01: sram_csb0 <= 4'b1101;
				2'b10: sram_csb0 <= 4'b1011;
				2'b11: sram_csb0 <= 4'b0111;
			endcase
		end else begin
			sram_csb0 <= 4'b1111;
		end
	end

	assign sram_clk0 	= clk;
	assign sram_web0 	= !peripheralBus_we;
	assign sram_wmask0 	= peripheralBus_byteSelect;
	assign sram_addr0 	= peripheralBus_address[SRAM_ADDRESS_SIZE+1:2];
	assign sram_din0 	= peripheralBus_dataWrite;
	assign peripheralBus_busy = 1'b0;
	assign requestOutput = peripheralBus_oe;

	// Select return data for peripheral bus port
	always @(*) begin
		if (peripheralBusEnableSRAM) begin
			case (peripheralBusSRAMBank)
				2'b00: peripheralBus_dataRead <= sram_dout0[31:0];
				2'b01: peripheralBus_dataRead <= sram_dout0[63:32];
				2'b10: peripheralBus_dataRead <= sram_dout0[95:64];
				2'b11: peripheralBus_dataRead <= sram_dout0[127:96];
			endcase
		end else begin
			peripheralBus_dataRead <= 32'b0;
		end
	end

	wire[1:0] videoSRAMBank = video_address[SRAM_ADDRESS_SIZE+3:SRAM_ADDRESS_SIZE+2];

	// Set enable bit for video port (active low)
	always @(*) begin
		case (videoSRAMBank)
			2'b00: sram_csb1 <= 4'b1110;
			2'b01: sram_csb1 <= 4'b1101;
			2'b10: sram_csb1 <= 4'b1011;
			2'b11: sram_csb1 <= 4'b0111;
		endcase
	end

	assign sram_clk1 	= video_clk;
	assign sram_addr1 	= video_address[SRAM_ADDRESS_SIZE+1:2];

	// Select return data for video port
	always @(*) begin
		case (videoSRAMBank)
			2'b00: video_data <= sram_dout1[31:0];
			2'b01: video_data <= sram_dout1[63:32];
			2'b10: video_data <= sram_dout1[95:64];
			2'b11: video_data <= sram_dout1[127:96];
		endcase
	end

endmodule