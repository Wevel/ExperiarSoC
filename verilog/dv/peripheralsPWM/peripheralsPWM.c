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

#define PWM0_CONFIGURATION_REGISTER ((uint32_t*)0x33021000)
#define PWM0_COUNTER_TOP_VALUE ((uint32_t*)0x33021004)
#define PWM0_COUNTER_VALUE ((uint32_t*)0x33021008)
#define PWM0_OUTPUT0_COMPARE ((uint32_t*)0x33021010)
#define PWM0_OUTPUT1_COMPARE ((uint32_t*)0x33021014)
#define PWM0_OUTPUT2_COMPARE ((uint32_t*)0x33021018)
#define PWM0_OUTPUT3_COMPARE ((uint32_t*)0x3302101C)
#define PWM1_CONFIGURATION_REGISTER ((uint32_t*)0x33022000)
#define PWM1_COUNTER_TOP_VALUE ((uint32_t*)0x33022004)
#define PWM1_COUNTER_VALUE ((uint32_t*)0x33022008)
#define PWM1_OUTPUT0_COMPARE ((uint32_t*)0x33022010)
#define PWM1_OUTPUT1_COMPARE ((uint32_t*)0x33022014)
#define PWM1_OUTPUT2_COMPARE ((uint32_t*)0x33022018)
#define PWM1_OUTPUT3_COMPARE ((uint32_t*)0x3302201C)
#define PWM2_CONFIGURATION_REGISTER ((uint32_t*)0x33023000)
#define PWM2_COUNTER_TOP_VALUE ((uint32_t*)0x33023004)
#define PWM2_COUNTER_VALUE ((uint32_t*)0x33023008)
#define PWM2_OUTPUT0_COMPARE ((uint32_t*)0x33023010)
#define PWM2_OUTPUT1_COMPARE ((uint32_t*)0x33023015)
#define PWM2_OUTPUT2_COMPARE ((uint32_t*)0x33023018)
#define PWM2_OUTPUT3_COMPARE ((uint32_t*)0x3302301C)
#define PWM3_CONFIGURATION_REGISTER ((uint32_t*)0x33024000)
#define PWM3_COUNTER_TOP_VALUE ((uint32_t*)0x33024004)
#define PWM3_COUNTER_VALUE ((uint32_t*)0x33024008)
#define PWM3_OUTPUT0_COMPARE ((uint32_t*)0x33024010)
#define PWM3_OUTPUT1_COMPARE ((uint32_t*)0x33024014)
#define PWM3_OUTPUT2_COMPARE ((uint32_t*)0x33024018)
#define PWM3_OUTPUT3_COMPARE ((uint32_t*)0x3302401C)

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

uint32_t tryGetPWMState (uint32_t* address, uint32_t valueMask, uint32_t state, uint32_t maxTries)
{
	uint32_t tries = maxTries;
	while (tries > 0 && (wbRead (address) & valueMask) != state) tries--;
	return tries;
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
	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1) {}

	// Setup test output
	bool testPass = true;
	wbWrite (GPIO0_OUTPUT_WRITE_ADDR, 0x01000);
	wbWrite (GPIO0_OE_WRITE_ADDR, ~0x03000);

	// Check device 0 config
	uint32_t device0Config = (0b11001100 << 6) | (0x1 << 5) | 0x03;
	wbWrite (PWM0_CONFIGURATION_REGISTER, device0Config);
	if (wbRead (PWM0_CONFIGURATION_REGISTER) != device0Config) testPass = false;
	nextTest (testPass);

	// Check device 0 counter top value
	uint32_t device0TopValue = 0x1388 - 1;
	wbWrite (PWM0_COUNTER_TOP_VALUE, device0TopValue);
	if (wbRead (PWM0_COUNTER_TOP_VALUE) != device0TopValue) testPass = false;
	nextTest (testPass);

	// Check device 1 config
	uint32_t device1Config = (0b00010001 << 6) | (0x1 << 5) | 0x02;
	wbWrite (PWM1_CONFIGURATION_REGISTER, device1Config);
	if (wbRead (PWM1_CONFIGURATION_REGISTER) != device1Config) testPass = false;
	nextTest (testPass);

	// Check device 1 counter top value
	uint32_t device1TopValue = 0x2710 - 1;
	wbWrite (PWM1_COUNTER_TOP_VALUE, device1TopValue);
	if (wbRead (PWM1_COUNTER_TOP_VALUE) != device1TopValue) testPass = false;
	nextTest (testPass);

	// Check device 0 ouput value 2 compare value
	uint32_t device0Output2Compare = 0x09C4 - 1; // 2500 -> 0.5ms off 0.5ms on
	wbWrite (PWM0_OUTPUT2_COMPARE, device0Output2Compare);
	if (wbRead (PWM0_OUTPUT2_COMPARE) != device0Output2Compare) testPass = false;
	nextTest (testPass);

	// Check device 0 ouput value 3 compare value
	uint32_t device0Output3Compare = 0x0DAC - 1; // 4500 -> 0.7ms off 0.3ms on
	wbWrite (PWM0_OUTPUT3_COMPARE, device0Output3Compare);
	if (wbRead (PWM0_OUTPUT3_COMPARE) != device0Output3Compare) testPass = false;
	nextTest (testPass);

	// Check device 1 ouput value 0 compare value
	uint32_t device1Output0Compare = 0x07D0 - 1; // 2000 -> 0.2ms off 0.8ms on
	wbWrite (PWM1_OUTPUT0_COMPARE, device1Output0Compare);
	if (wbRead (PWM1_OUTPUT0_COMPARE) != device1Output0Compare) testPass = false;
	nextTest (testPass);

	// Check device 0 counter changes
	uint32_t counterValue = wbRead (PWM0_COUNTER_VALUE) & 0xFFFF;
	// Check twice to make absolutely sure that it wasn't just an unlucky coincidence that they where the same
	if ((wbRead (PWM0_COUNTER_VALUE) & 0xFFFF) == counterValue && (wbRead (PWM0_COUNTER_VALUE) & 0xFFFF) == counterValue) testPass = false;
	nextTest (testPass);

	// Check internal value goes high
	uint32_t tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x40000, 0x40000, 20);
	if (tries == 0) testPass = false;
	nextTest (testPass);

	// Check internal value goes low
	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x40000, 0x00000, 20);
	if (tries == 0) testPass = false;
	nextTest (testPass);

	//----------------Device 0 ouput value 2----------------//
	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x40000, 0x00000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x40000, 0x40000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x40000, 0x00000, 20);
	if (tries == 0) testPass = false;
	nextTest (testPass);

	//----------------Device 0 ouput value 3----------------//
	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x80000, 0x00000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x80000, 0x80000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM0_COUNTER_VALUE, 0x80000, 0x00000, 20);
	if (tries == 0) testPass = false;
	nextTest (testPass);

	//----------------Device 1 ouput value 0----------------//
	tries = tryGetPWMState (PWM1_COUNTER_VALUE, 0x10000, 0x00000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM1_COUNTER_VALUE, 0x10000, 0x10000, 20);
	if (tries == 0) testPass = false;

	tries = tryGetPWMState (PWM1_COUNTER_VALUE, 0x10000, 0x00000, 20);
	if (tries == 0) testPass = false;

	// Finish test
	nextTest (testPass);
}
