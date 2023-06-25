[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/Wevel/ExperiarSoC/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/Wevel/ExperiarSoC/actions/workflows/user_project_ci.yml) 
<!-- [![Caravel Build](https://github.com/Wevel/ExperiarSoC/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/Wevel/ExperiarSoC/actions/workflows/caravel_build.yml) -->

# ExperiarSoC
RISC-V SoC designed for the Efabless Open MPW Program. This project 

![Block diagram of Experiar SoC](docs/Design/ExperiarSoC.png "Block diagram of Experiar SoC")

## Features
- Dual RV32I cores
- Per core SRAM
- JTAG interface
- External flash controller
- Shared video SRAM
- Configurable VGA output
- 3x UART ports + 1 internal to caravel
- 1x SPI ports
- 4x PWM counters with 4x separate outputs (2 are internal read only)

## Memory Map

![Memory map for Experiar SoC](docs/Design/MemoryMap.png "Memory map for Experiar SoC")

## Macro Layout

<p float="left">
  <img alt="Experiar SoC macro layout" src="docs/Design/MacrosPlacement.png" width = 49% />
   <img alt="Experiar SoC routed layout" src="docs/Images/user_project_wrapper.png" width = 49% />
</p>

## Build Status
- CaravelHost: ~
- ExperiarCore: ~
- Flash: ~
- Peripherals: ~
- Video: ~
- WishboneInterconnect: ~
- user_project_wrapper: ~

# Tests
## RTL
### verify-coreArch-rtl: ~
### verify-corePC-rtl: ~
### verify-coreMemory-rtl: ~
### verify-flash-rtl: ~
### verify-memory-rtl: ~
### verify-peripheralsGPIO-rtl: ~
### verify-peripheralsPWM-rtl: ~
### verify-peripheralsSPI-rtl: ~
### verify-peripheralsUART-rtl: ~
### verify-video-rtl: ~

## GL
### verify-corePC-gl: ~
### verify-coreMemory-rtl: ~
### verify-flash-gl: ~
### verify-memory-gl: ~
### verify-peripheralsGPIO-gl: ~
### verify-peripheralsPWM-gl: ~
### verify-peripheralsSPI-gl: ~
### verify-peripheralsUART-gl: ~
### verify-video-gl: ~

# Roadmap
## Versions
- 0.2.3: Initial MPW-6 design
- 0.3.0(Current): MPW-9????
	- Flash controller
		- Automatic paging selection
		- Multiple active flash pages
	- Pipeline CPU

## Issues
- Flash controller needs to be enabled in manual page mode and have a page selected before it can work with automatic page selection

## Need to do
- Update probe values
- Add stall signal if two wishbone masters read from the same location at the same time
- Fix some writes not correctly using byte mask
- Fix interrupt cause signals not being gated by mie meaning that the wrong interrupt cause could be set

## Could do
- Misaligned architecture instructions 
- Look into simulation with CVC
- Write macro level simulations to get more coverage due to shorter simulations
- Add JTAG test
- Add interrupt test
- Add uart pin swapping
- Tile map rendering
- Allow JTAG to read from wishbone bus
- Only wait for write if trying to load/store again

# Reference work and inspiration
- [Zero to ASIC Course](https://www.zerotoasiccourse.com/): Complete course on ASIC design. Also has useful references and terminology definitions.
- [Openlane Documentation](https://openlane.readthedocs.io/en/latest/index.html): Reference for a lot of configuration. The [Variables](https://openlane.readthedocs.io/en/latest/reference/configuration.html) and [Hardening Macros](https://openlane.readthedocs.io/en/latest/usage/hardening_macros.html) pages have been particularity useful.
- [Caravel Documentation](https://caravel-harness.readthedocs.io/en/latest/index.html): Reference for caravel and configuration. This seems slightly out of date, but an alternate version can be found in the [github repository](https://github.com/efabless/caravel/tree/main/docs/pdf).
- [Riscduino](https://github.com/dineshannayya/riscduino): Used for inspiration and as a reference for using openlane. There are a number of similar aspects to this project, but all have been reimplemented rather than copied.