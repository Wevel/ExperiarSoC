/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include <defs.h>
#include <stub.c>

#define GPIO0_OE_WRITE_ADDR ((uint32_t*)0x33031000)
#define GPIO0_OE_SET_ADDR ((uint32_t*)0x33031004)
#define GPIO0_OE_CLEAR_ADDR ((uint32_t*)0x33031008)
#define GPIO0_OE_TOGGLE_ADDR ((uint32_t*)0x3303100C)
#define GPIO0_OUTPUT_WRITE_ADDR ((uint32_t*)0x33031010)
#define GPIO0_OUTPUT_SET_ADDR ((uint32_t*)0x33031014)
#define GPIO0_OUTPUT_CLEAR_ADDR ((uint32_t*)0x33031018)
#define GPIO0_OUTPUT_TOGGLE_ADDR ((uint32_t*)0x3303101C)
#define GPIO0_INPUT_ADDR ((uint32_t*)0x33031020)
#define GPIO1_OE_WRITE_ADDR ((uint32_t*)0x33032000)
#define GPIO1_OE_SET_ADDR ((uint32_t*)0x33032004)
#define GPIO1_OE_CLEAR_ADDR ((uint32_t*)0x33032008)
#define GPIO1_OE_TOGGLE_ADDR ((uint32_t*)0x3303200C)
#define GPIO1_OUTPUT_WRITE_ADDR ((uint32_t*)0x33032010)
#define GPIO1_OUTPUT_SET_ADDR ((uint32_t*)0x33032014)
#define GPIO1_OUTPUT_CLEAR_ADDR ((uint32_t*)0x33032018)
#define GPIO1_OUTPUT_TOGGLE_ADDR ((uint32_t*)0x3303201C)
#define GPIO1_INPUT_ADDR ((uint32_t*)0x33032020)

#define VGA_SRAM ((uint32_t*)0x32000000)
#define VGA_CONFIGURATION_REGISTER ((uint32_t*)0x32800000)
#define VGA_HORIZONTAL_VISIBLE_AREA_COMPARE ((uint32_t*)0x32800010)
#define VGA_HORIZONTAL_FRONT_PORCH_COMPARE ((uint32_t*)0x32800014)
#define VGA_HORIZONTAL_SYNC_PULSE_COMPARE ((uint32_t*)0x32800018)
#define VGA_HORIZONTAL_WHOLE_LINE_COMPARE ((uint32_t*)0x3280001C)
#define VGA_VERTICAL_VISIBLE_AREA_COMPARE ((uint32_t*)0x32800020)
#define VGA_VERTICAL_FRONT_PORCH_COMPARE ((uint32_t*)0x32800024)
#define VGA_VERTICAL_SYNC_PULSE_COMPARE ((uint32_t*)0x32800028)
#define VGA_VERTICAL_WHOLE_LINE_COMPARE ((uint32_t*)0x3280002C)
#define VGA_STATE ((uint32_t*)0x32800030)

#define VGA_COLOR_RED 0b110000
#define VGA_COLOR_GREEN 0b001100
#define VGA_COLOR_BLUE 0b000011
#define VGA_COLOR_CYAN (VGA_COLOR_GREEN | VGA_COLOR_BLUE)
#define VGA_COLOR_MAGENTA (VGA_COLOR_RED | VGA_COLOR_BLUE)
#define VGA_COLOR_YELLOW (VGA_COLOR_RED | VGA_COLOR_GREEN)
#define VGA_COLOR_BLACK 0b000000
#define VGA_COLOR_WHITE (VGA_COLOR_RED | VGA_COLOR_GREEN | VGA_COLOR_BLUE)

#define VGA_5PIXELS(p0, p1, p2, p3, p4) ((p4 << 24) | (p3 << 18) | (p2 << 12) | (p1 << 6) | p0)

#define MPRJ_WB_ADDRESS (*(volatile uint32_t*)0x30000000)
#define MPRJ_WB_DATA_LOCATION 0x30008000

void wbWrite (uint32_t* location, uint32_t value)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	*((volatile uint32_t*)writeAddress) = value;
}

uint32_t wbRead (uint32_t* location)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	return *((volatile uint32_t*)writeAddress);
}

void nextTest (bool testPassing)
{
	if (testPassing)
	{
		wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x03000);
	}
	else
	{
		wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x01000);
		wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x02000);
	}

	wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x02000);
}

void main ()
{
	/*
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |


	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

	*/

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

	// https://github.com/efabless/caravel/blob/main/docs/other/gpio.txt

	// Enable the wishbone bus
	reg_wb_enable = 1;

	// Enable GPIO
	reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;

	// Enable vga output
	reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1) {}

	// Setup test output
	bool testPass = true;
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, 0x01000);
	wbWrite (GPIO0_OE_WRITE_ADDR, ~0x03000);

	// http://tinyvga.com/vga-timing/800x600@60Hz
	// This should generate a valid VGA signal for a 5MHz pixel clock
	// As the clock is actually 40MHz, it should just run faster so the simulation doesn't take ages

	// Write some test pixel data to video sram
	uint32_t testPixel0 = VGA_5PIXELS (VGA_COLOR_RED, VGA_COLOR_GREEN, VGA_COLOR_BLUE, VGA_COLOR_BLACK, VGA_COLOR_WHITE);
	uint32_t testPixel1 = VGA_5PIXELS (VGA_COLOR_CYAN, VGA_COLOR_MAGENTA, VGA_COLOR_YELLOW, VGA_COLOR_BLACK, VGA_COLOR_WHITE);
	uint32_t testPixel2 = VGA_5PIXELS (0b110111, 0b011000, 0b100001, 0b011110, 0b111111);
	uint32_t testPixel3 = VGA_5PIXELS (0b000000, 0b010000, 0b000100, 0b000001, 0b010101);
	wbWrite (VGA_SRAM, testPixel0);
	wbWrite (VGA_SRAM + 1, testPixel1);
	wbWrite (VGA_SRAM + 2, testPixel2);
	wbWrite (VGA_SRAM + 3, testPixel3);

	wbWrite (VGA_SRAM + 0x10, testPixel0);
	wbWrite (VGA_SRAM + 0x11, testPixel1);
	wbWrite (VGA_SRAM + 0x12, testPixel2);
	wbWrite (VGA_SRAM + 0x13, testPixel3);
	wbWrite (VGA_SRAM + 0x14, testPixel0);

	// Make sure some of the data has been written properly
	// Don't bother testing everything as that would take even longer
	if (wbRead (VGA_SRAM) != testPixel0) testPass = false;
	if (wbRead (VGA_SRAM + 1) != testPixel1) testPass = false;
	if (wbRead (VGA_SRAM + 2) != testPixel2) testPass = false;
	if (wbRead (VGA_SRAM + 3) != testPixel3) testPass = false;
	nextTest (testPass);

	uint32_t horizontalVisibleAreaCompare = 99;
	wbWrite (VGA_HORIZONTAL_VISIBLE_AREA_COMPARE, horizontalVisibleAreaCompare);
	if (wbRead (VGA_HORIZONTAL_VISIBLE_AREA_COMPARE) != horizontalVisibleAreaCompare) testPass = false;
	nextTest (testPass);

	uint32_t horizontalFrontPorchCompare = 104;
	wbWrite (VGA_HORIZONTAL_FRONT_PORCH_COMPARE, horizontalFrontPorchCompare);
	if (wbRead (VGA_HORIZONTAL_FRONT_PORCH_COMPARE) != horizontalFrontPorchCompare) testPass = false;
	nextTest (testPass);

	uint32_t horizontalSyncPulseCompare = 120;
	wbWrite (VGA_HORIZONTAL_SYNC_PULSE_COMPARE, horizontalSyncPulseCompare);
	if (wbRead (VGA_HORIZONTAL_SYNC_PULSE_COMPARE) != horizontalSyncPulseCompare) testPass = false;
	nextTest (testPass);

	uint32_t horizontalWholeLineCompare = 131;
	wbWrite (VGA_HORIZONTAL_WHOLE_LINE_COMPARE, horizontalWholeLineCompare);
	if (wbRead (VGA_HORIZONTAL_WHOLE_LINE_COMPARE) != horizontalWholeLineCompare) testPass = false;
	nextTest (testPass);

	uint32_t verticalVisibleAreaCompare = 599;
	wbWrite (VGA_VERTICAL_VISIBLE_AREA_COMPARE, verticalVisibleAreaCompare);
	if (wbRead (VGA_VERTICAL_VISIBLE_AREA_COMPARE) != verticalVisibleAreaCompare) testPass = false;
	nextTest (testPass);

	uint32_t verticalFrontPorchCompare = 600;
	wbWrite (VGA_VERTICAL_FRONT_PORCH_COMPARE, verticalFrontPorchCompare);
	if (wbRead (VGA_VERTICAL_FRONT_PORCH_COMPARE) != verticalFrontPorchCompare) testPass = false;
	nextTest (testPass);

	uint32_t verticalSyncPulseCompare = 604;
	wbWrite (VGA_VERTICAL_SYNC_PULSE_COMPARE, verticalSyncPulseCompare);
	if (wbRead (VGA_VERTICAL_SYNC_PULSE_COMPARE) != verticalSyncPulseCompare) testPass = false;
	nextTest (testPass);

	uint32_t verticalWholeLineCompare = 627;
	wbWrite (VGA_VERTICAL_WHOLE_LINE_COMPARE, verticalWholeLineCompare);
	if (wbRead (VGA_VERTICAL_WHOLE_LINE_COMPARE) != verticalWholeLineCompare) testPass = false;
	nextTest (testPass);

	// Enable default VGA output
	uint32_t enableVGARaw = 0x4AA;
	wbWrite (VGA_CONFIGURATION_REGISTER, enableVGARaw);
	if (wbRead (VGA_CONFIGURATION_REGISTER) != enableVGARaw) testPass = false;
	nextTest (testPass);

	// Wait for two vsync pulses
	// Ideally wait for the vsync signal
	// As we don't have interrupts, and the time between checks is so long this won't work
	// uint32_t vsyncMask = 0x4;
	// while ((wbRead (VGA_STATE) & vsyncMask) != vsyncMask) {}
	// while ((wbRead (VGA_STATE) & vsyncMask) != vsyncMask) {}
	// Instead just do a number of reads that should give enough time for the timing test to take place
	for (uint32_t i = 0; i < 24; i++) wbRead (VGA_STATE);

	// Enable VGA output in tight memory mode
	uint32_t enableVGATight = 0x5AA;
	wbWrite (VGA_CONFIGURATION_REGISTER, enableVGATight);
	if (wbRead (VGA_CONFIGURATION_REGISTER) != enableVGATight) testPass = false;
	nextTest (testPass);

	// Wait for two vsync pulses
	// while ((wbRead (VGA_STATE) & vsyncMask) != vsyncMask) {}
	// while ((wbRead (VGA_STATE) & vsyncMask) != vsyncMask) {}
	for (uint32_t i = 0; i < 24; i++) wbRead (VGA_STATE);

	// Finish test
	// There will be some testing after this to check that
	nextTest (testPass);
}
