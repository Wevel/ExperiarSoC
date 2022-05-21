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

![Experiar SoC Macro Layout](docs/Design/MacrosPlacement.png "Experiar SoC Macro Layout")

## Build Status
- CaravelHost: Success
- ExperiarCore: Success (Seem to be missing much of the core from the gds)
- Flash: Success
- Peripherals: Success
- Video: Success
- WishboneInterconnect: Success
- user_project_wrapper: Rotated SRAM macoros not connected to power

# Tests
## RTL
### verify-peripheralsGPIO-rtl: Success
### verify-peripheralsUART-rtl: Not implemented
### verify-peripheralsSPI-rtl: Not implemented
### verify-peripheralsPWM-rtl: Not implemented
### verify-memory-rtl: Not implemented
### verify-video-rtl: Not implemented
### verify-core-rtl: Not implemented

## GL
### verify-peripheralsGPIO-gl: Failed
### verify-peripheralsUART-gl: Not implemented
### verify-peripheralsSPI-gl: Not implemented
### verify-peripheralsPWM-gl: Not implemented
### verify-memory-gl: Not implemented
### verify-video-gl: Not implemented
### verify-core-gl: Not implemented

# ToDo
- Get it to build
- Flash controller
- JTAG core management controller
- CSRs
- Write more tests
- Fix all of the errors

# Reference work and inspiration
- [Zero to ASIC Course](https://www.zerotoasiccourse.com/): Complete course on ASIC design. Also has useful references and terminology definitions.
- [Openlane Documentation](https://openlane-docs.readthedocs.io/en/rtd-develop/index.html): Reference for a lot of configuration. The [Variables](https://openlane-docs.readthedocs.io/en/rtd-develop/configuration/README.html) and [Hardening Macros](https://openlane-docs.readthedocs.io/en/rtd-develop/doc/hardening_macros.html#) pages have been particularity useful.
- [Caravel Documentation](https://caravel-harness.readthedocs.io/en/latest/index.html): Reference for caravel and configuration. This seems slightly out of date, but an alternate version can be found in the [github repository](https://github.com/efabless/caravel/tree/main/docs/pdf).
- [Riscduino](https://github.com/dineshannayya/riscduino): Used for inspiration and as a reference for using openlane. There are a number of similar aspects to this project, but all have been reimplemented rather than copied.