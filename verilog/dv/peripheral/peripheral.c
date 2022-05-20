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

/*
	IO Test:
		- Configures MPRJ lower 8-IO pins as outputs
		- Observes counter value through the MPRJ lower 8 IO pins (in the testbench)
*/

// #define GPIO0_OE (*(volatile uint32_t*)0x33031000)
// #define GPIO0_OUTPUT (*(volatile uint32_t*)0x33031004)
// #define GPIO0_INPUT (*(volatile uint32_t*)0x33031008)

#define GPIO0_OE_ADDR ((uint32_t*)0x33031000)
#define GPIO0_OUTPUT_ADDR ((uint32_t*)0x33031004)
#define GPIO0_INPUT_ADDR ((uint32_t*)0x33031008)

#define GPIO0_OE (*GPIO0_OE_ADDR)
#define GPIO0_OUTPUT (*GPIO0_OUTPUT_ADDR)
#define GPIO0_INPUT (*GPIO0_INPUT_ADDR)

//#define test (*(volatile uint32_t*)0x3F001000)
#define test (*(volatile uint32_t*)0x30000000)

#define MPRJ_WB_IENA_OUT (*(volatile uint32_t*)0xf0003800)

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

void digitalWrite (int pin, int state)
{
	if (state)
	{
		if (pin == 12)
			GPIO0_OUTPUT |= 0x01000;
		else if (pin == 13)
			GPIO0_OUTPUT |= 0x02000;
		else if (pin == 14)
			GPIO0_OUTPUT |= 0x04000;
		else if (pin == 15)
			GPIO0_OUTPUT |= 0x08000;
	}
	else
	{
		if (pin == 12)
			GPIO0_OUTPUT &= ~0x01000;
		else if (pin == 13)
			GPIO0_OUTPUT &= ~0x02000;
		else if (pin == 14)
			GPIO0_OUTPUT &= ~0x04000;
		else if (pin == 15)
			GPIO0_OUTPUT &= ~0x08000;
	}
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

	// reg_spi_enable = 1;
	// reg_spimaster_cs = 0x10001;
	// reg_spimaster_control = 0x0801;

	// reg_spimaster_control = 0xa002; // Enable, prescaler = 2,
	// connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

	// https://github.com/efabless/caravel/blob/main/docs/other/gpio.txt

	reg_wb_enable = 1;

	// Enable GPIO
	reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;

	// Enable blink
	// reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;

	// // VGA
	// reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

	// // Debug
	// reg_mprj_io_0 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_1 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_2 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_3 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_4 = GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_5 = GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1) {}

	// reg_uart_enable = 1;
	// print ("hi\n");

	// MPRJ_WB_IENA_OUT = 1;

	// // Remove Wishbone Reset
	// // reg_mprj_wbhost_reg0 = 0x1;

	// // Remove All Reset
	// // reg_pinmux_gbl_cfg0 = 0x11F;

	// // uint32_t value = test;
	// test = 0x1;

	wbWrite (GPIO0_OE_ADDR, ~0x0F000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x01000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x03000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x07000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x0F000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x0E000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x0C000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x08000);
	wbWrite (GPIO0_OUTPUT_ADDR, 0x00000);

	// MPRJ_WB_ADDRESS = 0x33030000;

	// GPIO0_OE = ~0x0F000;
	// digitalWrite (12, 1);
	// digitalWrite (13, 1);
	// digitalWrite (14, 1);
	// digitalWrite (15, 1);
	// digitalWrite (12, 0);
	// digitalWrite (13, 0);
	// digitalWrite (14, 0);
	// digitalWrite (15, 0);

	// GPIO0_OUTPUT = 0x01000;
	// GPIO0_OUTPUT = 0x03000;
	// GPIO0_OUTPUT = 0x07000;
	// GPIO0_OUTPUT = 0x0F000;
	// GPIO0_OUTPUT = 0x0E000;
	// GPIO0_OUTPUT = 0x0C000;
	// GPIO0_OUTPUT = 0x08000;
	// GPIO0_OUTPUT = 0x00000;
}
