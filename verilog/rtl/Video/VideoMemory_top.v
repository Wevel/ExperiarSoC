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
		output wire[31:0] peripheralBus_dataRead,
		output wire requestOutput,

		// Video interface
		input wire video_fetchData,
		input wire[SRAM_ADDRESS_SIZE+3:0] video_address,
		output reg[31:0] video_data,

		// Left Video SRAM rw port
		output wire[1:0] sram0_csb0,
		output wire sram0_web0,
		output wire[3:0] sram0_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram0_addr0,
		output wire[31:0] sram0_din0,
		input wire[63:0] sram0_dout0,

		// Left Video SRAM r port
		output wire[1:0] sram0_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram0_addr1,
		input wire[63:0] sram0_dout1,

		// Right Video SRAM rw port
		output wire[1:0] sram1_csb0,
		output wire sram1_web0,
		output wire[3:0] sram1_wmask0,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram1_addr0,
		output wire[31:0] sram1_din0,
		input wire[63:0] sram1_dout0,

		// Right Video SRAM r port
		output wire[1:0] sram1_csb1,
		output wire[SRAM_ADDRESS_SIZE-1:0] sram1_addr1,
		input wire[63:0] sram1_dout1
	);

	localparam SRAM_ADDRESS_SIZE = 9;

	localparam SRAM_PERIPHERAL_BUS_ADDRESS = 11'h000;

	// Merge two ports into one
	reg[3:0] sram_csb0;
	wire sram_web0;
	wire[3:0] sram_wmask0;
	wire[SRAM_ADDRESS_SIZE-1:0] sram_addr0;
	wire[31:0] sram_din0;
	wire[127:0] sram_dout0;
	reg[3:0] sram_csb1;
	wire[SRAM_ADDRESS_SIZE-1:0] sram_addr1;
	wire[127:0] sram_dout1;

	assign sram0_csb0 = sram_csb0[1:0];
	assign sram0_web0 = sram_web0;
	assign sram0_wmask0 = sram_wmask0;
	assign sram0_addr0 = sram_addr0;
	assign sram0_din0 = sram_din0;
	assign sram0_csb1 = sram_csb1[1:0];
	assign sram0_addr1 = sram_addr1;
	assign sram1_csb0 = sram_csb0[3:2];
	assign sram1_web0 = sram_web0;
	assign sram1_wmask0 = sram_wmask0;
	assign sram1_addr0 = sram_addr0;
	assign sram1_din0 = sram_din0;
	assign sram1_csb1 = sram_csb1[3:2];
	assign sram1_addr1 = sram_addr1;

	assign sram_dout0 = { sram1_dout0, sram0_dout0 };
	assign sram_dout1 = { sram1_dout1, sram0_dout1 };

	wire peripheralBusValidAddress = peripheralBus_address[23:SRAM_ADDRESS_SIZE+4] == SRAM_PERIPHERAL_BUS_ADDRESS;
	wire peripheralBusReadEnable = peripheralBus_oe && peripheralBusValidAddress;
	wire peripheralBusWriteEnable = peripheralBus_we && peripheralBusValidAddress;
	wire peripheralBusEnableSRAM = peripheralBusReadEnable || peripheralBusWriteEnable;
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

	// Read data only valid the clock cycle after the address is sent
	reg wbReadReady = 1'b0;
	always @(posedge clk) begin
		if (rst) wbReadReady <= 1'b0;
		else if (peripheralBusReadEnable) wbReadReady <= 1'b1;
		else wbReadReady <= 1'b0;
	end

	reg[31:0] readData;
	assign peripheralBus_dataRead = {
		peripheralBus_byteSelect[3] && wbReadReady ? readData[31:24] : 8'h00,
		peripheralBus_byteSelect[2] && wbReadReady ? readData[23:16] : 8'h00,
		peripheralBus_byteSelect[1] && wbReadReady ? readData[15:8]  : 8'h00,
		peripheralBus_byteSelect[0] && wbReadReady ? readData[7:0]   : 8'h00
	};

	assign peripheralBus_busy = peripheralBusReadEnable && !wbReadReady;
	assign requestOutput = peripheralBusReadEnable;

	assign sram_web0 	= !peripheralBusWriteEnable;
	assign sram_wmask0 	= peripheralBus_byteSelect;
	assign sram_addr0 	= peripheralBus_address[SRAM_ADDRESS_SIZE+1:2];
	assign sram_din0 	= peripheralBus_dataWrite;

	// Select return data for peripheral bus port
	always @(*) begin
		if (peripheralBusReadEnable) begin
			case (peripheralBusSRAMBank)
				2'b00: readData <= sram_dout0[31:0];
				2'b01: readData <= sram_dout0[63:32];
				2'b10: readData <= sram_dout0[95:64];
				2'b11: readData <= sram_dout0[127:96];
			endcase
		end else begin
			readData <= ~32'b0;
		end
	end

	wire[1:0] videoSRAMBank = video_address[SRAM_ADDRESS_SIZE+3:SRAM_ADDRESS_SIZE+2];

	// Set enable bit for video port (active low)
	always @(*) begin
		if (video_fetchData) begin
			case (videoSRAMBank)
				2'b00: sram_csb1 <= 4'b1110;
				2'b01: sram_csb1 <= 4'b1101;
				2'b10: sram_csb1 <= 4'b1011;
				2'b11: sram_csb1 <= 4'b0111;
			endcase
		end else begin
			sram_csb1 <= 4'b1111;
		end
	end

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