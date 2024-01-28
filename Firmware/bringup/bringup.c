#include <defs.h>
#include <stdint.h>
#include <stub.h>

// --------------------------------------------------------
// Firmware routines
// --------------------------------------------------------

void configure_io ()
{

	//  ======= Useful GPIO mode values =============

	//      GPIO_MODE_MGMT_STD_INPUT_NOPULL
	//      GPIO_MODE_MGMT_STD_INPUT_PULLDOWN
	//      GPIO_MODE_MGMT_STD_INPUT_PULLUP
	//      GPIO_MODE_MGMT_STD_OUTPUT
	//      GPIO_MODE_MGMT_STD_BIDIRECTIONAL
	//      GPIO_MODE_MGMT_STD_ANALOG

	//      GPIO_MODE_USER_STD_INPUT_NOPULL
	//      GPIO_MODE_USER_STD_INPUT_PULLDOWN
	//      GPIO_MODE_USER_STD_INPUT_PULLUP
	//      GPIO_MODE_USER_STD_OUTPUT
	//      GPIO_MODE_USER_STD_BIDIRECTIONAL
	//      GPIO_MODE_USER_STD_ANALOG

	//  ======= set each IO to the desired configuration =============

	//  GPIO 0 is turned off to prevent toggling the debug pin; For debug, make this an output and
	//  drive it externally to ground.

	reg_mprj_io_0 = GPIO_MODE_MGMT_STD_ANALOG;

	// Changing configuration for IO[1-4] will interfere with programming flash. if you change them,
	// You may need to hold reset while powering up the board and initiating flash to keep the process
	// configuring these IO from their default values.

	reg_mprj_io_1 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_2 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_3 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;
	reg_mprj_io_4 = GPIO_MODE_MGMT_STD_INPUT_NOPULL;

	// -------------------------------------------

	reg_mprj_io_5 = GPIO_MODE_MGMT_STD_INPUT_NOPULL; // UART Rx
	reg_mprj_io_6 = GPIO_MODE_MGMT_STD_OUTPUT; // UART Tx
	reg_mprj_io_7 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_8 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_9 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;

	reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

	// Initiate the serial transfer to configure IO
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1)
		;
}

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

#define SOC_UART1_CONFIGURATION_ADDR ((uint32_t*)0x33002000)
#define SOC_UART1_CLEAR_ADDR ((uint32_t*)0x33002004)
#define SOC_UART1_STATUS_ADDR ((uint32_t*)0x33002008)
#define SOC_UART1_RX_ADDR ((uint32_t*)0x33002010)
#define SOC_UART1_TX_ADDR ((uint32_t*)0x33002014)

#define SOC_CORE0_SRAM ((uint32_t*)0x30000000)
#define SOC_CORE0_CONTROL ((uint32_t*)0x30800000)
#define SOC_CORE0_STATE ((uint32_t*)0x30800004)
#define SOC_CORE0_REGISTERS_PC ((uint32_t*)0x30810000)
#define SOC_CORE0_REGISTERS_RELATIVE_JUMP ((uint32_t*)0x30810004)
#define SOC_CORE0_REGISTERS_STEP ((uint32_t*)0x30810008)
#define SOC_CORE0_REGISTERS_CURRENT_INSTRUCTION ((uint32_t*)0x30810010)
#define SOC_CORE0_REGISTERS_CLEAR_ERROR ((uint32_t*)0x30810020)
#define SOC_CORE0_REGISTERS_REGISTER ((uint32_t*)0x30814000)
#define SOC_CORE0_REGISTERS_CSR ((uint32_t*)0x30818000)

#define SOC_CORE1_SRAM ((uint32_t*)0x31000000)
#define SOC_CORE1_CONTROL ((uint32_t*)0x31800000)
#define SOC_CORE1_STATE ((uint32_t*)0x31800004)
#define SOC_CORE1_REGISTERS_PC ((uint32_t*)0x31810000)
#define SOC_CORE1_REGISTERS_RELATIVE_JUMP ((uint32_t*)0x31810004)
#define SOC_CORE1_REGISTERS_STEP ((uint32_t*)0x31810008)
#define SOC_CORE1_REGISTERS_CURRENT_INSTRUCTION ((uint32_t*)0x31810010)
#define SOC_CORE1_REGISTERS_CLEAR_ERROR ((uint32_t*)0x31810020)
#define SOC_CORE1_REGISTERS_REGISTER ((uint32_t*)0x31814000)
#define SOC_CORE1_REGISTERS_CSR ((uint32_t*)0x31818000)

#define SOC_VIDEO_SRAM ((uint32_t*)0x32000000)
#define SOC_VIDEO_CONFIG ((uint32_t*)0x32800000)
#define SOC_VIDEO_CONFIG_HORIZONTAL_VISIBLE_AREA ((uint32_t*)0x32800010)
#define SOC_VIDEO_CONFIG_HORIZONTAL_FRONT_PORCH ((uint32_t*)0x32800014)
#define SOC_VIDEO_CONFIG_HORIZONTAL_SYNC_PULSE ((uint32_t*)0x32800018)
#define SOC_VIDEO_CONFIG_HORIZONTAL_WHOLE_LINE ((uint32_t*)0x3280001C)
#define SOC_VIDEO_CONFIG_VERTICAL_VISIBLE_AREA ((uint32_t*)0x32800020)
#define SOC_VIDEO_CONFIG_VERTICAL_FRONT_PORCH ((uint32_t*)0x32800024)
#define SOC_VIDEO_CONFIG_VERTICAL_SYNC_PULSE ((uint32_t*)0x32800028)
#define SOC_VIDEO_CONFIG_VERTICAL_WHOLE_LINE ((uint32_t*)0x3280002C)
#define SOC_VIDEO_CONFIG_VGA_SCREEN_STATE ((uint32_t*)0x32800030)

#define VGA_5PIXELS(p0, p1, p2, p3, p4) ((p4 << 24) | (p3 << 18) | (p2 << 12) | (p1 << 6) | p0)
#define VGA_COLOR_RED 0b110000
#define VGA_COLOR_GREEN 0b001100
#define VGA_COLOR_BLUE 0b000011
#define VGA_COLOR_CYAN (VGA_COLOR_GREEN | VGA_COLOR_BLUE)
#define VGA_COLOR_MAGENTA (VGA_COLOR_RED | VGA_COLOR_BLUE)
#define VGA_COLOR_YELLOW (VGA_COLOR_RED | VGA_COLOR_GREEN)
#define VGA_COLOR_BLACK 0b000000
#define VGA_COLOR_WHITE (VGA_COLOR_RED | VGA_COLOR_GREEN | VGA_COLOR_BLUE)

#define MPRJ_WB_ADDRESS (*(volatile uint32_t*)0x30000000)
#define MPRJ_WB_DATA_LOCATION 0x30008000

extern void core0 ();

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

void delay (const int d)
{
	/* Configure timer for a single-shot countdown */
	reg_timer0_config = 0;
	reg_timer0_data = d;
	reg_timer0_config = 1;

	// Loop, waiting for value to reach zero
	reg_timer0_update = 1; // latch current value
	while (reg_timer0_value > 0)
	{
		reg_timer0_update = 1;
	}
}

int testIndex = 0;
int testStatus = 1;
char messageBuffer[16];

void printWrite (uint32_t* address, uint32_t value)
{
	print_hex ((uint32_t)address, 8);
	print (" <- ");
	wbWrite (address, value);
	print_hex (value, 8);
	print ("\n");
}

uint32_t printFetch (uint32_t* address)
{
	print_hex ((uint32_t)address, 8);
	print (" -> ");
	int data = wbRead (address);
	print_hex (data, 8);
	print ("\n");
	return data;
}

uint32_t printWriteFetch (uint32_t* address, uint32_t value)
{
	printWrite (address, value);
	return printFetch (address);
}

void testWrite (uint32_t* address, uint32_t value)
{
	if (printWriteFetch (address, value) != value)
	{
		testStatus = 0;
		print ("Test failed\n");
	}
	else
	{
		print ("Test passed\n");
	}

	testIndex++;
}

void testRead (uint32_t* address, uint32_t value)
{
	if (printFetch (address) != value)
	{
		testStatus = 0;
		print ("Test failed\n");
	}
	else
	{
		print ("Test passed\n");
	}

	testIndex++;
}

void testWriteRead (uint32_t* address, uint32_t writeValue, uint32_t expectedValue)
{
	if (printWriteFetch (address, writeValue) != expectedValue)
	{
		testStatus = 0;
		print ("Test failed\n");
	}
	else
	{
		print ("Test passed\n");
	}

	testIndex++;
}

void UART_Transmit (uint32_t* uart, const char* p)
{
	while (*p)
		printWrite (uart, *(p++));
}

void UART_Receive (uint32_t* uart, char* p)
{
	while (1)
	{
		uint32_t status = printFetch (uart);
		if (status & 0x100)
		{
			*p = status & 0xFF;
			p++;
		}
		else
		{
			break;
		}
	}

	*p = 0;
}

void CompareBuffers (const char* expected, char* actual)
{
	while (*expected)
	{
		if (*expected != *actual)
		{
			testStatus = 0;
			print ("Test failed\n");
			return;
		}

		expected++;
		actual++;
	}

	print ("Test passed\n");
}

void testUART ()
{
	print ("Start UART test\n");
	// Test caravel uart configuration
	testWrite (CARAVEL_UART_CONFIGURATION_ADDR, 0x21047);
	testRead (CARAVEL_UART_STATUS_ADDR, 0x0);

	// Test internal soc uart configuration
	testWrite (SOC_UART0_CONFIGURATION_ADDR, 0x21047);
	testRead (SOC_UART0_STATUS_ADDR, 0x0);

	// Test simple write
	printWrite (CARAVEL_UART_TX_ADDR, (int)'H');
	testRead (CARAVEL_UART_STATUS_ADDR, 0x0);
	testRead (SOC_UART0_STATUS_ADDR, 0x1);
	testRead (SOC_UART0_RX_ADDR, 0x100 | (int)'H');

	// Test full message write from caravel to soc
	const char* message = "Hello SoC\n";
	UART_Transmit (CARAVEL_UART_TX_ADDR, message);
	UART_Receive (SOC_UART0_RX_ADDR, messageBuffer);
	CompareBuffers (message, messageBuffer);
	print ("Internal UART Received: ");
	print (messageBuffer);

	// Test full message write from soc to caravel
	const char* message2 = "Hello Caravel :)\n";
	UART_Transmit (SOC_UART0_TX_ADDR, message2);
	UART_Receive (CARAVEL_UART_RX_ADDR, messageBuffer);
	CompareBuffers (message2, messageBuffer);
	print ("Caravel UART Received: ");
	print (messageBuffer);
}

void printCore0Stats ()
{
	print ("STATE: ");
	printFetch (SOC_CORE0_STATE);
	print ("PC: ");
	printFetch (SOC_CORE0_REGISTERS_PC);
	print ("IR: ");
	printFetch (SOC_CORE0_REGISTERS_CURRENT_INSTRUCTION);
	print ("Time: ");
	printFetch (SOC_CORE0_REGISTERS_CSR + 0xC00);
	print ("Count: ");
	printFetch (SOC_CORE0_REGISTERS_CSR + 0xC02);
}

uint32_t runInstruction (uint32_t instruction)
{
	uint32_t* pc = SOC_CORE1_REGISTERS_REGISTER;
	testWrite (pc, instruction);
	testWrite (SOC_CORE0_REGISTERS_PC, (uint32_t)pc & 0x1FFFFFFF);
	printWrite (SOC_CORE0_REGISTERS_STEP, 0x1);
	uint32_t offset = printFetch (SOC_CORE0_REGISTERS_PC) - (uint32_t)pc;
	printCore0Stats ();
	return offset;
}

void testCore ()
{
	print ("Start Core 0 test\n");
	testRead (SOC_CORE0_STATE, 0x0);

	uint32_t* pc = SOC_CORE1_REGISTERS_REGISTER;
	uint32_t instructionAddress = (uint32_t)pc & 0x1FFFFFFF;

	// Use a random register for the pc to test
	// testWrite (pc, 0x6F); // Jump with zero offset
	testWrite (pc, 0x63); // Branch always with zero offset
	// testWrite (pc, 0x200 | 0x63); // Branch always with 0x4 offset
	//  testWrite (pc, 0x200 | 0x63); // Branch always with 0x4 offset

	// testWrite (pc, 0x0040006F); // Jump with 0x4 offset
	//  testWrite (pc + 1, 0xFFDFF06F); // Jump with -0x4 offset

	// uint32_t pc

	testWrite (SOC_CORE0_REGISTERS_REGISTER, 0xabcd1234);
	// for (int i = 0; i < 4; i++)
	// 	testWrite (SOC_CORE0_REGISTERS_REGISTER + i, 0xabcd1234 + i);

	printCore0Stats ();

	testWrite (SOC_CORE0_REGISTERS_PC, instructionAddress);

	printCore0Stats ();

	for (int i = 0; i < 4; i++)
	{
		testWriteRead (SOC_CORE0_REGISTERS_STEP, 0x1, instructionAddress);
		printCore0Stats ();
	}

	testWrite (SOC_CORE0_CONTROL, 0x0);
	printCore0Stats ();

	// print ("C01: \n");
	// printFetch (SOC_CORE0_REGISTERS_CSR + 0xC01);

	// print ("C04: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC04, 0x12345678);

	// print ("C05: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC05, 0x12345678);

	// print ("C40: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC40, 0x12345678);

	// print ("C41: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC41, 0x12345678);

	// print ("C42: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC42, 0x12345678);

	// print ("C43: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC43, 0x12345678);

	// print ("C44: \n");
	// testWrite (SOC_CORE0_REGISTERS_CSR + 0xC44, 0x12345678);

	// while (true)
	// {
	// 	// print ("Time: \n");
	// 	// printFetch (SOC_CORE0_REGISTERS_CSR + 0xC00);
	// 	// printFetch (SOC_CORE0_REGISTERS_CSR + 0xC80);
	// 	testWrite (SOC_CORE0_CONTROL, 0x0);
	// 	printCore0Stats ();
	// 	testWrite (SOC_CORE0_CONTROL, 0x1);

	// 	delay (20000000);
	// }

	// BEQ r0 r0 0
	runInstruction (0x63); // Branch always with zero offset

	// LI instructionAddress
	runInstruction (0x000B7 | (instructionAddress & 0xFFFFF000)); // LUI r1 ((instructionAddress >> 12)
	runInstruction (0x08093 | (uint32_t)((instructionAddress & 0xFFF) << 20)); // ADDI r0 r1 (instructionAddress & 0xFFF)

	// SW r1, 0(r1)
	runInstruction (0x10A023);

	print ("Result: ");
	testRead (pc, instructionAddress);

	// LI 0x123
	runInstruction (0x00113 | (uint32_t)((0x123 & 0xFFF) << 20)); // ADDI r0 r2 0x123

	// SW r2, 0(r1)
	runInstruction (0x20A023);

	print ("Result: ");
	testRead (pc, 0x123);

	testWrite (SOC_CORE0_CONTROL, 0x0);

	uint32_t* code = (uint32_t*)core0;
	print ("Running code at: ");
	print_hex ((uint32_t)code, 8);
	print ("\n");

	uint32_t virtualProgramCounter = 0;
	uint32_t state;

	while (true)
	{
		uint32_t instruction = code[virtualProgramCounter];
		uint32_t offset = runInstruction (instruction);
		virtualProgramCounter += offset;

		state = printFetch (SOC_CORE0_STATE);
		if ((state & 0b11) != 0)
		{
			print ("Entered Error State\n");
			break;
		}
		else if ((state & 0b1100) != 0)
		{
			print ("Entered Halt State\n");
			break;
		}
	}
}

void testSRAM ()
{
	print ("Start SRAM test\n");

	// testWrite (SOC_VIDEO_SRAM, 0xabc);
	// testWrite (SOC_VIDEO_SRAM + 1, 0x12345678);
	// testWrite (SOC_VIDEO_SRAM + 2, 0xdeadbeef);
	// testWrite (SOC_VIDEO_SRAM + 3, 0xabcd1234);

	testWrite (SOC_VIDEO_SRAM, 0);
	testWrite (SOC_VIDEO_SRAM + 1, 0);
	testWrite (SOC_VIDEO_SRAM + 2, 0);
	testWrite (SOC_VIDEO_SRAM + 3, 0);

	testRead (SOC_VIDEO_SRAM, 0xabc);
	testRead (SOC_VIDEO_SRAM + 1, 0x12345678);
	testRead (SOC_VIDEO_SRAM + 2, 0xdeadbeef);
	testRead (SOC_VIDEO_SRAM + 3, 0xabcd1234);

	testRead (SOC_VIDEO_SRAM, 0xabc);
	testRead (SOC_VIDEO_SRAM + 1, 0x12345678);
	testRead (SOC_VIDEO_SRAM + 2, 0xdeadbeef);
	testRead (SOC_VIDEO_SRAM + 3, 0xabcd1234);

	testRead (SOC_VIDEO_SRAM, 0xabc);
	testRead (SOC_VIDEO_SRAM + 1, 0x12345678);
	testRead (SOC_VIDEO_SRAM + 2, 0xdeadbeef);
	testRead (SOC_VIDEO_SRAM + 3, 0xabcd1234);

	// testWrite (SOC_VIDEO_SRAM, VGA_5PIXELS (VGA_COLOR_RED, VGA_COLOR_GREEN, VGA_COLOR_BLUE, VGA_COLOR_BLACK, VGA_COLOR_WHITE));
	// testWrite (SOC_VIDEO_SRAM + 1, VGA_5PIXELS (VGA_COLOR_CYAN, VGA_COLOR_MAGENTA, VGA_COLOR_YELLOW, VGA_COLOR_BLACK, VGA_COLOR_WHITE));
	// testWrite (SOC_VIDEO_SRAM + 2, VGA_5PIXELS (0b110111, 0b011000, 0b100001, 0b011110, 0b111111));
	// testWrite (SOC_VIDEO_SRAM + 3, VGA_5PIXELS (0b000000, 0b010000, 0b000100, 0b000001, 0b010101));

	// for (int i = 0; i < 16; i++)
	// {
	// 	// testWrite (SOC_CORE0_SRAM + i, 0xbeaf + i);
	// 	// testRead (SOC_CORE0_SRAM + i, 0xbeaf + i);
	// 	// testWrite (SOC_CORE1_SRAM + i, 0x21047 + i);
	// 	// testRead (SOC_CORE1_SRAM + i, 0x21047 + i);
	// 	testWrite (SOC_VIDEO_SRAM + i, 0x21047 + i);
	// 	testRead (SOC_VIDEO_SRAM + i, 0x21047 + i);
	// }
}

void main ()
{
	reg_gpio_mode1 = 1;
	reg_gpio_mode0 = 0;
	reg_gpio_ien = 1;
	reg_gpio_oe = 1;

	configure_io ();

	reg_uart_enable = 1;
	reg_wb_enable = 1;

	// Configure All LA probes as inputs to the cpu
	reg_la0_oenb = reg_la0_iena = 0x00000000; // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000; // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000; // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000; // [127:96]

	// write data to la output
	//	reg_la0_data = 0x00;
	//	reg_la1_data = 0x00;
	//	reg_la2_data = 0x00;
	//	reg_la3_data = 0x00;

	// read data from la input
	//	data0 = reg_la0_data;
	//	data1 = reg_la1_data;
	//	data2 = reg_la2_data;
	//	data3 = reg_la3_data;

	print ("\nHello World !!\n");

	// wbWrite (GPIO0_OE_WRITE_ADDR, ~0x00000);
	// wbWrite (GPIO1_OE_WRITE_ADDR, ~0x00000);

	testUART ();
	testCore ();
	// testSRAM ();

	if (testStatus == 0)
	{
		print ("Some tests failed :(\n");
	}
	else
	{
		print ("All Test passed :)\n");
	}

	while (1)
	{
		reg_gpio_out = 1; // OFF
		reg_mprj_datal = 0x00000000;
		reg_mprj_datah = 0x00000000;

		// wbWrite (GPIO0_OE_TOGGLE_ADDR, 0x00000);
		// wbWrite (GPIO1_OE_TOGGLE_ADDR, 0x00000);

		delay (200000);

		reg_gpio_out = 0; // ON
		reg_mprj_datah = 0x0000003f;
		reg_mprj_datal = 0xffffffff;

		// wbWrite (GPIO0_OE_TOGGLE_ADDR, ~0x00000);
		// wbWrite (GPIO1_OE_TOGGLE_ADDR, ~0x00000);

		delay (200000);
	}
}
