module VGA #(
		parameter ADDRESS_BITS = 13
	)(
`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
`endif
		input wire clk,
		input wire rst,

		// Peripheral bus for configuration
		input wire peripheralBus_we,
		input wire peripheralBus_oe,
		output wire peripheralBus_busy,
		input wire[23:0] peripheralBus_address,
		input wire[3:0] peripheralBus_byteSelect,
		input wire[31:0] peripheralBus_dataWrite,
		output reg[31:0] peripheralBus_dataRead,
		output wire requestOutput,

		// Memory interface
		input wire vga_clk,
		output reg[ADDRESS_BITS-1:0] vga_address,
		input wire[31:0] vga_data,

		// VGA output
		output wire[1:0] vga_r,
		output wire[1:0] vga_g,
		output wire[1:0] vga_b,
		output reg vga_vsync,
		output reg vga_hsync
	);
	
	// MAX_ROW_WIDTH = 2^ROW_BITS = 64;
	// MAX_COLUMN_WIDTH = 2^COLUMN_BITS * (MAX_SUB_PIXEL_VALUE+1) = 80;

	localparam VERTICAL_BITS = 7;
	localparam HORIZONTAL_BITS = 4;
	localparam MAX_SUB_PIXEL_VALUE = 3'h4;

	localparam DRAW_MODE_RAW 	 	  	= 2'b00;
	localparam DRAW_MODE_RAW_TIGHT_MEM 	= 2'b01;
	localparam DRAW_MODE_COLOUR_PALETTE = 2'b10;
	localparam DRAW_MODE_SPRITES 	  	= 2'b11;

	localparam CONFIG_ADDRESS = 12'h010;

	wire configEnable = peripheralBus_address[23:12] == CONFIG_ADDRESS;
	wire[11:0] configRegisterAddress = peripheralBus_address[11:0];

	//  Registers
	// Configuration 	Default 0x0AA
	// b00-b03: horizontalPixelSize		Default 0xA
	// b04-b07: verticalPixelSize		Default 0xA
	// b08-b09: drawMode 				Default 0b00
	wire[9:0] configuration;
	wire[31:0] configurationRegisterOutputData;
	wire configurationRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(10), .ADDRESS(12'h020), .DEFAULT(10'h0AA)) configurationRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(configurationRegisterOutputData),
		.requestOutput(configurationRegisterOutputRequest),
		.currentValue(configuration));
	
	wire[3:0] horizontalPixelSize = configuration[3:0];
	wire[3:0] verticalPixelSize   = configuration[7:4];
	wire[1:0] drawMode 			  = configuration[9:8];

	// Defaults are timing for 800 x 600 at 60Hz
	// http://tinyvga.com/vga-timing/800x600@60Hz
	// Horizontal visible area compare 	Default 799=0x31F
	wire[10:0] horizontalVisibleAreaCompare;
	wire[31:0] horizontalVisibleAreaCompareRegisterOutputData;
	wire horizontalVisibleAreaCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(11), .ADDRESS(12'h000), .DEFAULT(11'h31F)) horizontalVisibleAreaCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(horizontalVisibleAreaCompareRegisterOutputData),
		.requestOutput(horizontalVisibleAreaCompareRegisterOutputRequest),
		.currentValue(horizontalVisibleAreaCompare));

	// Horizontal front porch compare 	Default 839=0x347
	wire[10:0] horizontalFrontPorchCompare;
	wire[31:0] horizontalFrontPorchCompareRegisterOutputData;
	wire horizontalFrontPorchCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(11), .ADDRESS(12'h004), .DEFAULT(11'h347)) horizontalFrontPorchCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(horizontalFrontPorchCompareRegisterOutputData),
		.requestOutput(horizontalFrontPorchCompareRegisterOutputRequest),
		.currentValue(horizontalFrontPorchCompare));

	// Horizontal sync pulse compare 	Default 967=0x3C7
	wire[10:0] horizontalSyncPulseCompare;
	wire[31:0] horizontalSyncPulseCompareRegisterOutputData;
	wire horizontalSyncPulseCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(11), .ADDRESS(12'h008), .DEFAULT(11'h3C7)) horizontalSyncPulseCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(horizontalSyncPulseCompareRegisterOutputData),
		.requestOutput(horizontalSyncPulseCompareRegisterOutputRequest),
		.currentValue(horizontalSyncPulseCompare));

	// Horizontal whole line compare 	Default 1055=0x41F
	wire[10:0] horizontalWholeLineCompare;
	wire[31:0] horizontalWholeLineCompareRegisterOutputData;
	wire horizontalWholeLineCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(11), .ADDRESS(12'h00C), .DEFAULT(11'h41F)) horizontalWholeLineCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(horizontalWholeLineCompareRegisterOutputData),
		.requestOutput(horizontalWholeLineCompareRegisterOutputRequest),
		.currentValue(horizontalWholeLineCompare));

	// Vertical visible area compare 	Default 599=0x257
	wire[9:0] verticalVisibleAreaCompare;
	wire[31:0] verticalVisibleAreaCompareRegisterOutputData;
	wire verticalVisibleAreaCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(10), .ADDRESS(12'h010), .DEFAULT(11'h257)) verticalVisibleAreaCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(verticalVisibleAreaCompareRegisterOutputData),
		.requestOutput(verticalVisibleAreaCompareRegisterOutputRequest),
		.currentValue(verticalVisibleAreaCompare));

	// Vertical front porch compare 	Default 600=0x258
	wire[9:0] verticalFrontPorchCompare;
	wire[31:0] verticalFrontPorchCompareRegisterOutputData;
	wire verticalFrontPorchCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(10), .ADDRESS(12'h014), .DEFAULT(11'h258)) verticalFrontPorchCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(verticalFrontPorchCompareRegisterOutputData),
		.requestOutput(verticalFrontPorchCompareRegisterOutputRequest),
		.currentValue(verticalFrontPorchCompare));

	// Vertical sync pulse compare 	Default 604=0x25C
	wire[9:0] verticalSyncPulseCompare;
	wire[31:0] verticalSyncPulseCompareRegisterOutputData;
	wire verticalSyncPulseCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(10), .ADDRESS(12'h018), .DEFAULT(11'h25C)) verticalSyncPulseCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(verticalSyncPulseCompareRegisterOutputData),
		.requestOutput(verticalSyncPulseCompareRegisterOutputRequest),
		.currentValue(verticalSyncPulseCompare));

	// Vertical whole line compare 	Default 627=0x273
	wire[9:0] verticalWholeLineCompare;
	wire[31:0] verticalWholeLineCompareRegisterOutputData;
	wire verticalWholeLineCompareRegisterOutputRequest;
	ConfigurationRegister #(.WIDTH(10), .ADDRESS(12'h01C), .DEFAULT(11'h273)) verticalWholeLineCompareRegister(
		.clk(clk),
		.rst(rst),
		.enable(configEnable),
		.peripheralBus_we(peripheralBus_we),
		.peripheralBus_oe(peripheralBus_oe),
		.peripheralBus_address(configRegisterAddress),
		.peripheralBus_byteSelect(peripheralBus_byteSelect),
		.peripheralBus_dataWrite(peripheralBus_dataWrite),
		.peripheralBus_dataRead(verticalWholeLineCompareRegisterOutputData),
		.requestOutput(verticalWholeLineCompareRegisterOutputRequest),
		.currentValue(verticalWholeLineCompare));

	assign peripheralBus_busy = 1'b0;
	assign requestOutput = configurationRegisterOutputRequest
						|| horizontalVisibleAreaCompareRegisterOutputRequest
						|| horizontalFrontPorchCompareRegisterOutputRequest
						|| horizontalSyncPulseCompareRegisterOutputRequest
						|| horizontalWholeLineCompareRegisterOutputRequest
						|| verticalVisibleAreaCompareRegisterOutputRequest
						|| verticalFrontPorchCompareRegisterOutputRequest
						|| verticalSyncPulseCompareRegisterOutputRequest
						|| verticalWholeLineCompareRegisterOutputRequest;

	always @(*) begin
		case (1'b1)
			configurationRegisterOutputRequest:
				peripheralBus_dataRead <= configurationRegisterOutputData;
			horizontalVisibleAreaCompareRegisterOutputRequest:
				peripheralBus_dataRead <= horizontalVisibleAreaCompareRegisterOutputData;
			horizontalFrontPorchCompareRegisterOutputRequest:
				peripheralBus_dataRead <= horizontalFrontPorchCompareRegisterOutputData;
			horizontalSyncPulseCompareRegisterOutputRequest:
				peripheralBus_dataRead <= horizontalSyncPulseCompareRegisterOutputData;
			horizontalWholeLineCompareRegisterOutputRequest:
				peripheralBus_dataRead <= horizontalWholeLineCompareRegisterOutputData;
			verticalVisibleAreaCompareRegisterOutputRequest:
				peripheralBus_dataRead <= verticalVisibleAreaCompareRegisterOutputData;
			verticalFrontPorchCompareRegisterOutputRequest:
				peripheralBus_dataRead <= verticalFrontPorchCompareRegisterOutputData;
			verticalSyncPulseCompareRegisterOutputRequest:
				peripheralBus_dataRead <= verticalSyncPulseCompareRegisterOutputData;
			verticalWholeLineCompareRegisterOutputRequest:
				peripheralBus_dataRead <= verticalWholeLineCompareRegisterOutputData;
			default: peripheralBus_dataRead <= 32'b0;
		endcase
	end

	// VGA sync signal generations
	reg[10:0] horizontalCounter;
	wire isEndHorizontalVisibleArea = horizontalCounter == horizontalVisibleAreaCompare;
	wire isEndHorizontalFrontPorch = horizontalCounter == horizontalFrontPorchCompare;
	wire isEndHorizontalSyncPulse = horizontalCounter == horizontalSyncPulseCompare;
	wire isEndHorizontalWholeLine = horizontalCounter == horizontalWholeLineCompare;
	reg inHorizontalVisibleArea = 1'b1;

	always @(posedge vga_clk) begin
		if (isEndHorizontalWholeLine) horizontalCounter <= 10'b0;
		else horizontalCounter <= horizontalCounter + 1;

		if (isEndHorizontalVisibleArea) inHorizontalVisibleArea <= 1'b0;
		else if (isEndHorizontalWholeLine) inHorizontalVisibleArea <= 1'b1;

		if (isEndHorizontalFrontPorch) vga_hsync <= 1'b0;
		else if (isEndHorizontalSyncPulse) vga_hsync <= 1'b1;
	end
	
	reg[9:0] verticalCounter;
	wire isEndVerticalVisibleArea = verticalCounter == verticalVisibleAreaCompare;
	wire isEndVerticalFrontPorch = verticalCounter == verticalFrontPorchCompare;
	wire isEndVerticalSyncPulse = verticalCounter == verticalSyncPulseCompare;
	wire isEndVerticalWholeLine = verticalCounter == verticalWholeLineCompare;
	reg inVerticalVisibleArea = 1'b1;

	always @(posedge vga_clk) begin
		if (isEndVerticalWholeLine) verticalCounter <= 10'b0;
		else verticalCounter <= verticalCounter + 1;

		if (isEndVerticalVisibleArea) inVerticalVisibleArea <= 1'b0;
		else if (isEndVerticalWholeLine) inVerticalVisibleArea <= 1'b1;

		if (isEndVerticalFrontPorch) vga_vsync <= 1'b0;
		else if (isEndVerticalSyncPulse) vga_vsync <= 1'b1;
	end

	// VGA pixel address select
	reg[17:0] raw_directPixelCounter;
	wire[17:0] raw_nextDirectPixelCounter = raw_directPixelCounter + 1;
	reg[8:0] raw_horizontalPixelCounter;
	reg[9:0] raw_verticalPixelCounter;
	reg[2:0] raw_subPixelCounter;

	reg[3:0] raw_horizontalPixelStretchCounter = 4'b0;
	wire[3:0] raw_nextHorizontalPixelStretchCounter = raw_horizontalPixelStretchCounter + 1;
	reg[3:0] raw_verticalPixelStretchCounter;
	wire[3:0] raw_nextVerticalPixelStretchCounter = raw_verticalPixelStretchCounter + 1;

	// Raw draw mode
	always @(posedge vga_clk) begin
		if (inHorizontalVisibleArea) begin
			if (raw_horizontalPixelStretchCounter == horizontalPixelSize) begin
				if (raw_subPixelCounter == MAX_SUB_PIXEL_VALUE) begin
					raw_subPixelCounter <= 3'b0;
					raw_horizontalPixelCounter <= raw_horizontalPixelCounter + 1;
					raw_directPixelCounter <= raw_nextDirectPixelCounter;
				end	else begin
					raw_subPixelCounter <= raw_subPixelCounter + 1;
				end

				raw_horizontalPixelStretchCounter <= 4'b0;
			end else begin
				raw_horizontalPixelStretchCounter <= raw_nextHorizontalPixelStretchCounter;
			end
		end else begin
			raw_subPixelCounter <= 3'b0;
			raw_horizontalPixelCounter <= 9'b0;
			raw_horizontalPixelStretchCounter <= 4'b0;

			if (inVerticalVisibleArea) raw_directPixelCounter <= raw_nextDirectPixelCounter;
			else raw_directPixelCounter <= 18'b0;
		end

		if (inVerticalVisibleArea) begin
			if (raw_verticalPixelStretchCounter == verticalPixelSize) begin
				raw_verticalPixelCounter <= raw_verticalPixelCounter + 1;
				raw_verticalPixelStretchCounter <= 4'b0;
			end else begin
				raw_verticalPixelStretchCounter <= raw_nextVerticalPixelStretchCounter;
			end
		end else begin
			raw_verticalPixelCounter <= 9'b0;
			raw_verticalPixelStretchCounter <= 4'b0;			
		end
	end

	always @(posedge vga_clk) begin
		case (drawMode)
			// Use Seperate horizontal and vertical portions of address
			// This means that for some resolutions portions of memory are not used by the video device
			DRAW_MODE_RAW: begin
				vga_address <= { raw_verticalPixelCounter[VERTICAL_BITS-1:0], raw_horizontalPixelCounter[HORIZONTAL_BITS-1:0], 2'b00 };
			end

			// Directly use the pixel index to access memory
			// This better uses memory, but is also slightly more complex for the cpu to write to the frame buffer
			DRAW_MODE_RAW_TIGHT_MEM: begin
				vga_address <= { raw_directPixelCounter[ADDRESS_BITS-1:0], 2'b00 };
			end

			// TODO: Use some portion of memory to store colours, then index them with the frame buffer
			// This will require loading the pixel information ahead of time, so that the correct colour can be found
			// Is this really helpful, as we use 6-bit colour, so probably need to use 4-bit colour palette index
			DRAW_MODE_COLOUR_PALETTE: begin
				vga_address <= { raw_verticalPixelCounter[VERTICAL_BITS-1:0], raw_horizontalPixelCounter[HORIZONTAL_BITS-1:0], 2'b00 };
			end

			// TODO: Use some portion of memory to store sprites
			// Then use a sprite index rather than colour data or a colour index
			// How many sprites do we want to allow
			// How big will sprites be
			// How configurable should this be
			// We have very little video memory, so this may not work very well at all
			DRAW_MODE_SPRITES: begin
				vga_address <= { raw_verticalPixelCounter[VERTICAL_BITS-1:0], raw_horizontalPixelCounter[HORIZONTAL_BITS-1:0], 2'b00 };
			end

			default: begin
				vga_address <= { raw_verticalPixelCounter[VERTICAL_BITS-1:0], raw_horizontalPixelCounter[HORIZONTAL_BITS-1:0], 2'b00 };
			end
		endcase
		
	end

	reg[5:0] raw_currentPixel;
	
	always @(*) begin
		case (raw_subPixelCounter)
			4'h0: raw_currentPixel <= vga_data[5:0];
			4'h1: raw_currentPixel <= vga_data[11:6];
			4'h2: raw_currentPixel <= vga_data[17:12];
			4'h3: raw_currentPixel <= vga_data[23:18];
			4'h4: raw_currentPixel <= vga_data[29:24];
			default: raw_currentPixel <= vga_data[5:0];
		endcase
	end

	assign vga_r = raw_currentPixel[1:0];
	assign vga_g = raw_currentPixel[3:2];
	assign vga_b = raw_currentPixel[5:4];

endmodule
