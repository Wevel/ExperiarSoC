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

#define CARAVEL_UART_CONFIGURATION_ADDR ((uint32_t*)0x3F001000)
#define CARAVEL_UART_CLEAR_ADDR ((uint32_t*)0x3F001004)
#define CARAVEL_UART_STATUS_ADDR ((uint32_t*)0x3F001008)
#define CARAVEL_UART_RX_ADDR ((uint32_t*)0x3F001010)
#define CARAVEL_UART_TX_ADDR ((uint32_t*)0x3F001014)

#define SOC_UART0_CONFIGURATION_ADDR ((uint32_t*)0x33001000)
#define SOC_UART0_CLEAR_ADDR ((uint32_t*)0x33001004)
#define SOC_UART0_STATUS_ADDR ((uint32_t*)0x33001008)
#define SOC_UART0_RX_ADDR ((uint32_t*)0x33001010)
#define SOC_UART0_TX_ADDR ((uint32_t*)0x33001014)

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

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1) {}

	// Setup test output
	bool testPass = true;
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, 0x01000);
	wbWrite (GPIO0_OE_WRITE_ADDR, ~0x03000);

	// Write caravel device config and clear
	uint32_t enabledDeviceConfig = 0x20014; // This effectively has baudrate of ~2MHz
	uint32_t disabledDeviceConfig = 0x00014; // This effectively has baudrate of ~2MHz
	wbWrite (CARAVEL_UART_CONFIGURATION_ADDR, disabledDeviceConfig);
	wbWrite (CARAVEL_UART_CLEAR_ADDR, 0xF);

	// Read that the config was set correctly
	if (wbRead (CARAVEL_UART_CONFIGURATION_ADDR) != disabledDeviceConfig) testPass = false;
	if (wbRead (CARAVEL_UART_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Write peripheral device config and clear
	wbWrite (SOC_UART0_CONFIGURATION_ADDR, enabledDeviceConfig);
	wbWrite (SOC_UART0_CLEAR_ADDR, 0xF);

	// Read that the config was set correctly
	if (wbRead (SOC_UART0_CONFIGURATION_ADDR) != enabledDeviceConfig) testPass = false;
	if (wbRead (SOC_UART0_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Send data from caravel
	uint32_t testData[] = { 0xCD, 0x55, 0xBE, 0xEF };

	// Write one byte with the device still disabled to make sure it doesn't send
	wbWrite (CARAVEL_UART_TX_ADDR, testData[0]);

	// Check that the data is there
	if (wbRead (CARAVEL_UART_STATUS_ADDR) != 0x8) testPass = false;
	nextTest (testPass);

	// Check that no data has arrived at the SoC UART device
	if (wbRead (SOC_UART0_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Now enable the device and send the remaining data
	wbWrite (CARAVEL_UART_CONFIGURATION_ADDR, enabledDeviceConfig);

	wbWrite (CARAVEL_UART_TX_ADDR, testData[1]);
	wbWrite (CARAVEL_UART_TX_ADDR, testData[2]);
	wbWrite (CARAVEL_UART_TX_ADDR, testData[3]);

	// Make sure all of the data has been sent
	if (wbRead (CARAVEL_UART_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Read back data from peripheral
	if (wbRead (SOC_UART0_RX_ADDR) != (0x100 | testData[0])) testPass = false;
	if (wbRead (SOC_UART0_RX_ADDR) != (0x100 | testData[1])) testPass = false;
	if (wbRead (SOC_UART0_RX_ADDR) != (0x100 | testData[2])) testPass = false;
	if (wbRead (SOC_UART0_RX_ADDR) != (0x100 | testData[3])) testPass = false;
	nextTest (testPass);

	// Try reading an extra time and make sure there is no data
	if (wbRead (SOC_UART0_RX_ADDR) != 0x0) testPass = false;
	nextTest (testPass);

	// Make sure all of the data is marked as read
	if (wbRead (SOC_UART0_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Send data from peripheral
	wbWrite (SOC_UART0_TX_ADDR, testData[0]);
	wbWrite (SOC_UART0_TX_ADDR, testData[1]);
	wbWrite (SOC_UART0_TX_ADDR, testData[2]);
	wbWrite (SOC_UART0_TX_ADDR, testData[3]);

	// Make sure all of the data has been sent
	if (wbRead (SOC_UART0_STATUS_ADDR) != 0) testPass = false;
	nextTest (testPass);

	// Read back data from caravel
	if (wbRead (CARAVEL_UART_RX_ADDR) != (0x100 | testData[0])) testPass = false;
	if (wbRead (CARAVEL_UART_RX_ADDR) != (0x100 | testData[1])) testPass = false;
	if (wbRead (CARAVEL_UART_RX_ADDR) != (0x100 | testData[2])) testPass = false;
	if (wbRead (CARAVEL_UART_RX_ADDR) != (0x100 | testData[3])) testPass = false;
	nextTest (testPass);

	// Try reading an extra time and make sure there is no data
	if (wbRead (CARAVEL_UART_RX_ADDR) != 0x0) testPass = false;
	nextTest (testPass);

	// Make sure all of the data is marked as read
	if (wbRead (CARAVEL_UART_STATUS_ADDR) != 0) testPass = false;

	// Finish test
	nextTest (testPass);
}
