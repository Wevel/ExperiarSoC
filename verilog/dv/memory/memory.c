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

#define CORE0_SRAM ((uint32_t*)0x30000000)
#define CORE1_SRAM ((uint32_t*)0x31000000)
#define VGA_SRAM ((uint32_t*)0x32000000)
#define SRAM_BANK_SIZE 0x200

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

void wbWriteByte (uint8_t* location, uint8_t value)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	*((volatile uint8_t*)writeAddress) = value;
}

void wbWriteHalf (uint16_t* location, uint16_t value)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	*((volatile uint16_t*)writeAddress) = value;
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

uint8_t wbReadByte (uint8_t* location)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	return *((volatile uint8_t*)writeAddress);
}

uint16_t wbReadHalf (uint16_t* location)
{
	// Write the address
	uint32_t locationData = (uint32_t)location;
	MPRJ_WB_ADDRESS = locationData & 0xFFFF8000;

	// Write the data
	uint32_t writeAddress = (locationData & 0x00007FFF) | MPRJ_WB_DATA_LOCATION;
	return *((volatile uint16_t*)writeAddress);
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

#define RANDOM_NUMBER_SEED 0xB466941D // Must be a non-zero value
uint32_t randomNumberState = RANDOM_NUMBER_SEED;
uint32_t xorShift32 ()
{
	uint32_t x = randomNumberState;
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	randomNumberState = x;
	return randomNumberState;
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

	// Read/write to core0 SRAM
	randomNumberState = RANDOM_NUMBER_SEED + 0x1234;
	wbWrite (CORE0_SRAM, xorShift32 ());
	wbWrite (CORE0_SRAM + 1, xorShift32 ());
	wbWrite (CORE0_SRAM + SRAM_BANK_SIZE, xorShift32 ());
	wbWrite (CORE0_SRAM + SRAM_BANK_SIZE + 1, xorShift32 ());

	randomNumberState = RANDOM_NUMBER_SEED + 0x1234;
	if (wbRead (CORE0_SRAM) != xorShift32 ()) testPass = false;
	if (wbRead (CORE0_SRAM + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	if (wbRead (CORE0_SRAM + SRAM_BANK_SIZE) != xorShift32 ()) testPass = false;
	if (wbRead (CORE0_SRAM + SRAM_BANK_SIZE + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	// Read/write to core1 SRAM
	randomNumberState = RANDOM_NUMBER_SEED + 0x3456;
	wbWrite (CORE1_SRAM, xorShift32 ());
	wbWrite (CORE1_SRAM + 1, xorShift32 ());
	wbWrite (CORE1_SRAM + SRAM_BANK_SIZE, xorShift32 ());
	wbWrite (CORE1_SRAM + SRAM_BANK_SIZE + 1, xorShift32 ());

	randomNumberState = RANDOM_NUMBER_SEED + 0x3456;
	if (wbRead (CORE1_SRAM) != xorShift32 ()) testPass = false;
	if (wbRead (CORE1_SRAM + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	if (wbRead (CORE1_SRAM + SRAM_BANK_SIZE) != xorShift32 ()) testPass = false;
	if (wbRead (CORE1_SRAM + SRAM_BANK_SIZE + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	// Read/write to video SRAM
	randomNumberState = RANDOM_NUMBER_SEED + 0x5678;
	wbWrite (VGA_SRAM, xorShift32 ());
	wbWrite (VGA_SRAM + 1, xorShift32 ());
	wbWrite (VGA_SRAM + SRAM_BANK_SIZE, xorShift32 ());
	wbWrite (VGA_SRAM + SRAM_BANK_SIZE + 1, xorShift32 ());
	wbWrite (VGA_SRAM + (SRAM_BANK_SIZE * 2), xorShift32 ());
	wbWrite (VGA_SRAM + (SRAM_BANK_SIZE * 2) + 1, xorShift32 ());
	wbWrite (VGA_SRAM + (SRAM_BANK_SIZE * 3), xorShift32 ());
	wbWrite (VGA_SRAM + (SRAM_BANK_SIZE * 3) + 1, xorShift32 ());

	randomNumberState = RANDOM_NUMBER_SEED + 0x5678;
	if (wbRead (VGA_SRAM) != xorShift32 ()) testPass = false;
	if (wbRead (VGA_SRAM + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	if (wbRead (VGA_SRAM + SRAM_BANK_SIZE) != xorShift32 ()) testPass = false;
	if (wbRead (VGA_SRAM + SRAM_BANK_SIZE + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	if (wbRead (VGA_SRAM + (SRAM_BANK_SIZE * 2)) != xorShift32 ()) testPass = false;
	if (wbRead (VGA_SRAM + (SRAM_BANK_SIZE * 2) + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	if (wbRead (VGA_SRAM + (SRAM_BANK_SIZE * 3)) != xorShift32 ()) testPass = false;
	if (wbRead (VGA_SRAM + (SRAM_BANK_SIZE * 3) + 1) != xorShift32 ()) testPass = false;
	nextTest (testPass);

	// Read/write byte
	randomNumberState = RANDOM_NUMBER_SEED + 0xABCD;
	uint32_t byteWriteData = xorShift32 ();
	wbWriteByte ((uint8_t*)CORE0_SRAM + 12, (uint8_t)byteWriteData);
	wbWriteByte ((uint8_t*)CORE0_SRAM + 13, (uint8_t)(byteWriteData >> 8));
	wbWriteByte ((uint8_t*)CORE0_SRAM + 14, (uint8_t)(byteWriteData >> 16));
	wbWriteByte ((uint8_t*)CORE0_SRAM + 15, (uint8_t)(byteWriteData >> 24));
	if (wbRead (CORE0_SRAM + 3) != byteWriteData) testPass = false;
	if (wbReadByte ((uint8_t*)CORE0_SRAM + 12) != (uint8_t)byteWriteData) testPass = false;
	if (wbReadByte ((uint8_t*)CORE0_SRAM + 13) != (uint8_t)(byteWriteData >> 8)) testPass = false;
	if (wbReadByte ((uint8_t*)CORE0_SRAM + 14) != (uint8_t)(byteWriteData >> 16)) testPass = false;
	if (wbReadByte ((uint8_t*)CORE0_SRAM + 15) != (uint8_t)(byteWriteData >> 24)) testPass = false;
	nextTest (testPass);

	// Read/write half
	uint32_t halfWriteData0 = xorShift32 ();
	uint32_t halfWriteData1 = xorShift32 ();
	uint32_t halfWriteData2 = xorShift32 ();
	wbWriteHalf ((uint16_t*)CORE0_SRAM + 32, (uint16_t)halfWriteData0);
	wbWriteHalf ((uint16_t*)CORE0_SRAM + 33, (uint16_t)(halfWriteData0 >> 16));
	wbWriteHalf ((uint16_t*)CORE0_SRAM + 34, (uint16_t)halfWriteData1);
	wbWriteHalf ((uint16_t*)CORE0_SRAM + 35, (uint16_t)(halfWriteData1 >> 16));
	// wbWriteHalf ((uint16_t*)((uint8_t*)CORE0_SRAM + 113), (uint16_t)halfWriteData2);
	// wbWriteHalf ((uint16_t*)((uint8_t*)CORE0_SRAM + 115), (uint16_t)(halfWriteData2 >> 16));
	if (wbReadHalf ((uint16_t*)CORE0_SRAM + 32) != (uint16_t)halfWriteData0) testPass = false;
	if (wbReadHalf ((uint16_t*)CORE0_SRAM + 33) != (uint16_t)(halfWriteData0 >> 16)) testPass = false;
	if (wbReadHalf ((uint16_t*)CORE0_SRAM + 34) != (uint16_t)halfWriteData1) testPass = false;
	if (wbReadHalf ((uint16_t*)CORE0_SRAM + 35) != (uint16_t)(halfWriteData1 >> 16)) testPass = false;
	nextTest (testPass);

	// Read/write half unaligned
	// The management core doesn't seem to be capable of doing the writes for this
	// Not really testing anything useful anyway
	// if (wbReadHalf ((uint16_t*)((uint8_t*)CORE0_SRAM + 113)) != (uint16_t)halfWriteData2) testPass = false;
	// if (wbReadHalf ((uint16_t*)((uint8_t*)CORE0_SRAM + 115)) != (uint16_t)(halfWriteData2 >> 16)) testPass = false;
	// nextTest (testPass);

	// Read unused from wishbone
	if (wbRead ((uint32_t*)0x3A001234) != 0xFFFFFFFF) testPass = false;
	nextTest (testPass);

	// Read unused from peripherals
	if (wbRead ((uint32_t*)0x33080000) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x33000A00) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x33010A00) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x33020A00) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x33030A00) != 0xFFFFFFFF) testPass = false;
	nextTest (testPass);

	// Read unused from core0 and core1
	if (wbRead ((uint32_t*)0x30400000) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x308A0000) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x31400000) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x318A0000) != 0xFFFFFFFF) testPass = false;
	nextTest (testPass);

	// Read unused from video
	if (wbRead ((uint32_t*)0x32400000) != 0xFFFFFFFF) testPass = false;
	if (wbRead ((uint32_t*)0x328A0000) != 0xFFFFFFFF) testPass = false;
	nextTest (testPass);

	// Read unused from caravel host management
	if (wbRead ((uint32_t*)0x328A0000) != 0xFFFFFFFF) testPass = false;
	nextTest (testPass);

	// Finish test
	// There will be some testing after this to check that
	nextTest (testPass);
}
