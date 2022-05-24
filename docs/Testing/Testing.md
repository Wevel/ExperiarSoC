# Experiar Core Tests
A number of tests can (when they have been implemented) be run on both the management core and user core, to ensure all aspects of the SoC work correctly. All tests should be compatible with fabricated hardware, with success measurable from changes to GPIO states.

## Peripherals
- GPIO verify-peripheralsGPIO-rtl (-gl)
	- Try outputs
	- Try inputs
- UART verify-peripheralsUART-rtl (-gl)
	- Configure devices
	- Verify config is set
	- Send bytes from caravel to uart0
	- Sent bytes from uart0 to caravel
	- Set GPIO high if pass
- SPI verify-peripheralsSPI-rtl (-gl)
	- Connect test device as a 16 bit shift register
	- Set SPI output (will need a high frequency)
	- Write 3 bytes
	- Check that 3 bytes back are correct
	- Set GPIO high if pass
- PWM verify-peripheralsPWM-rtl (-gl)
	- Set PWM output on two different devices
	- Check that they alternate
		- Maybe also check frequency and on time
	- Read counter
	- Read PWM value register
	- Set GPIO high if pass

## Memory verify-memory-rtl (-gl)
- Write data to each SRAM macro
- Read back from each SRAM macro and compare data
- Read back as byte and half values and compare data
- Read back byte and half with offset and compare data
- Read from unused memory on wishbone and check that the data back is -1
- Read from unused memory in peripheral bus and check that the data back is -1
- Read from unused memory in a core and check that the data back is -1
- Read from unused memory in video config and check that the data back is -1
- Set GPIO high if pass

## Video verify-video-rtl (-gl)
- Write to all configs to make screen refresh happen much faster
- Write to start of frame buffer to have some pixel data
- Check that output is as expected

## Core (these will run for both cores) verify-core-rtl (-gl)
- Program Counter and management
	- Write to program counter
	- Check that the program counter is correct
	- Write NOP for step (this does require instruction reads to work)
	- Step core
	- Check that the program counter is correct
	- Jump the program counter
	- Check that the program counter is correct
	- Free run the program counter
	- Check that the program counter increases
	- Set GPIO high if pass
- Store/Load instructions
	- Write basic program to memory
		- Write to location in local memory, then read back
	- Set program counter
	- Step through instructions
	- Read back register values
	- Run management memory test on user core
	- Run management peripheral test on user core
		- UART test modified so user core transfers data to management core, which transfers data back 
	- Run management video test on user core
	- Set GPIO high if pass
- riscv-arch-test
	- Integrate test into makefile