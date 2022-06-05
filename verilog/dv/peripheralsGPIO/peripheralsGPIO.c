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
	reg_mprj_io_7 = GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_18 = GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_19 = GPIO_MODE_USER_STD_INPUT_NOPULL;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1) {}

	// Setup test output
	bool testPass = true;
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, 0x01000);

	wbWrite (GPIO0_OE_WRITE_ADDR, ~0x3F000);
	wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x04000);
	wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x08000);
	wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x10000);
	wbWrite (GPIO0_OUTPUT_SET_ADDR, 0x20000);
	wbWrite (GPIO0_OUTPUT_TOGGLE_ADDR, 0x3C000);
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, 0x3C000 | 0x01000); // Need to write to testPass pin as well, otherwise to goes low temporarily
	wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x04000);
	wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x08000);
	wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x10000);
	wbWrite (GPIO0_OUTPUT_CLEAR_ADDR, 0x20000);
	nextTest (testPass);

	wbWrite (GPIO0_OE_SET_ADDR, 0x00080);
	uint32_t ioData = wbRead (GPIO0_INPUT_ADDR);
	if (ioData != 0x80) testPass = false; // input = 1'b1
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, (testPass ? 0x01000 : 0) | (((ioData >> 7) & 0xF) << 14));
	nextTest (testPass);

	wbWrite (GPIO1_OE_WRITE_ADDR, ~0x00000);
	ioData = wbRead (GPIO1_INPUT_ADDR);
	if (ioData != 0x2) testPass = false; // input = 2'b10
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, (testPass ? 0x01000 : 0) | ((ioData & 0xF) << 14));
	nextTest (testPass);

	ioData = wbRead (GPIO1_INPUT_ADDR);
	if (ioData != 0x1) testPass = false; // input = 2'b01
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, (testPass ? 0x01000 : 0) | ((ioData & 0xF) << 14));
	nextTest (testPass);

	ioData = wbRead (GPIO1_INPUT_ADDR);
	if (ioData != 0x3) testPass = false; // input = 2'b11
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, (testPass ? 0x01000 : 0) | ((ioData & 0xF) << 14));
	nextTest (testPass);

	ioData = wbRead (GPIO1_INPUT_ADDR);
	if (ioData != 0x0) testPass = false; // input = 2'b00
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, (testPass ? 0x01000 : 0) | ((ioData & 0xF) << 14));

	// Finish test
	nextTest (testPass);
}
