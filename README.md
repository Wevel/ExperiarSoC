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
  <img alt="Experiar SoC macro layout with detailed routing guide overlay" src="docs/Scripts/detailed.guide.jpg" width = 49% />
</p>

## Build Status
- CaravelHost: Success
- ExperiarCore: Success
- Flash: Success
- Peripherals: Success
- Video: Success
- WishboneInterconnect: Success
- user_project_wrapper: Success

Several macros have max slew violations.

# Tests
## RTL
### verify-peripheralsGPIO-rtl: Success
### verify-peripheralsUART-rtl: Success
### verify-peripheralsSPI-rtl: Not implemented
### verify-peripheralsPWM-rtl: Not implemented
### verify-memory-rtl: Not implemented
### verify-video-rtl: Success (Not validating correct pixel data)
### verify-corePC-rtl: Success
### verify-coreMem-rtl: Not implemented
### verify-coreArch-rtl: Not implemented

## GL
### verify-peripheralsGPIO-gl: Failed
### verify-peripheralsUART-gl: Failed
### verify-peripheralsSPI-gl: Not implemented
### verify-peripheralsPWM-gl: Not implemented
### verify-memory-gl: Not implemented
### verify-video-gl: Not run
### verify-corePC-gl: Failed
### verify-coreMem-gl: Not implemented
### verify-coreArch-gl: Not implemented

# Need to do
- Write remaining tests (and fix everything until they pass)
- Fix timing violations
- Make version of art which passes prechecks

# Could do
- Add uart pin swapping
- Flash controller
- JTAG core management controller
- CSRs
- More tests
- Tile map rendering 
- Change peripheral bus design to have a read ready signal
- Fetch next instruction a clock cycle earlier so instructions only take 2 cycles

# Reference work and inspiration
- [Zero to ASIC Course](https://www.zerotoasiccourse.com/): Complete course on ASIC design. Also has useful references and terminology definitions.
- [Openlane Documentation](https://openlane-docs.readthedocs.io/en/rtd-develop/index.html): Reference for a lot of configuration. The [Variables](https://openlane-docs.readthedocs.io/en/rtd-develop/configuration/README.html) and [Hardening Macros](https://openlane-docs.readthedocs.io/en/rtd-develop/doc/hardening_macros.html#) pages have been particularity useful.
- [Caravel Documentation](https://caravel-harness.readthedocs.io/en/latest/index.html): Reference for caravel and configuration. This seems slightly out of date, but an alternate version can be found in the [github repository](https://github.com/efabless/caravel/tree/main/docs/pdf).
- [Riscduino](https://github.com/dineshannayya/riscduino): Used for inspiration and as a reference for using openlane. There are a number of similar aspects to this project, but all have been reimplemented rather than copied.