# Experiar Core Tests
A number of tests can (when they have been implemented) be run on both the managment core and user core, to ensure all aspects of the SoC work correctly. All tests should be compatible with fabricated hardware, with success measurable from changes to GPIO states.

## Peripheral: verify-peripheral-rtl (-gl)
- GPIO
	- Try outputs
	- Try inputs
- UART
	- Send byte from caravel to uart0
	- Sent byte from uart0 to caravel
	- Set GPIO high if pass
- SPI
	- Connect test device as a 16 bit shift register
	- Set SPI output (will need a high frequency)
	- Write 3 bytes
	- Check that 3 bytes back are correct
	- Set GPIO high if pass
- PWM
	- Set PWM output on two different devices
	- Check that they alternate
		- Maybe also check frequency and on time
	- Read counter
	- Read PWM value register
	- Set GPIO high if pass

## Memory verify-memory-rtl (-gl)
- Write data to each SRAM macro
- Read back from each SRAM macro and compare data
- Set GPIO high if pass

## Video verify-video-rtl (-gl)
- Write to all configs to make screen refresh happen much faster
- Write to start of frame buffer to have some pixel data
- Check that output is as expected

## Core (these will run for both cores) verify-core-rtl (-gl)
- Program Counter			
	- Write to program counter
	- Check that the program counter is correct
	- Step core
	- Check that program counter is correct
	- Set GPIO high if pass
- Registers				
	- Write to r0, r1, r2
	- Check that r0==0, and r1, and r2 have correct data
	- Set GPIO high if pass
- Basic register instructions
	- Write basic program to memory
	- Set program counter to start
	- Step through instructions
	- Read back register values
	- Set GPIO high if pass
- Store/Load instructions
	- Write basic program to memory
		- Write to location in local memory, then read back
	- Set program counter
	- Step through instructions
	- Read back register values
	- Set GPIO high if pass
- Jump instructions
	- Write basic program to memory
		- Check conditional and unconditional jumps
	- Set program counter
	- Step through instructions
	- Read back program counter
	- Set GPIO high if pass
- Mempory access
	- Run managment memory test on user core
- Peripheral access
	- Run managment peripheral test on user core
		- UART test modified so user core transferes data to managment core, which transferes data back 
- Video access
	- Run managment video test on user core
- riscv-arch-test
	- Integrate test into makefile