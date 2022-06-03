# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0


# ---- Include Partitioned Makefiles ----

CONFIG = caravel_user_project
BLOCKS := coreArch

#######################################################################
## Caravel Verilog for Integration Tests
#######################################################################

export DESIGNS ?= /mnt/f/WSL/ASIC/ExperiarSoC
export USER_PROJECT_VERILOG ?=  $(DESIGNS)/verilog
export CARAVEL_ROOT ?= /mnt/f/WSL/ASIC/ExperiarSoC/caravel
export IVERILOG_DUMPER = fst


GCC_PATH?=/opt/riscv32i/bin
GCC_PREFIX?=riscv32-unknown-elf

# RTL/GL/GL_SDF
SIM?=RTL

SIGNATURE_START=$(shell readelf -s coreArch.elf | grep begin_signature | awk '{print $$2}')
SIGNATURE_END=$(shell readelf -s coreArch.elf | grep end_signature | awk '{print $$2}')
CODE_END=$(shell readelf -s coreArch.elf | grep write_tohost | awk '{print $$2}')

.SUFFIXES:
all:  ${BLOCKS:=.lst} ${BLOCKS:=.disass} ${BLOCKS:=.vcd}
hex:  ${BLOCKS:=.hex}

coreArch.lst: coreArch.elf
	${GCC_PATH}/${GCC_PREFIX}-objdump -d -S $< > $@

coreArch.disass: coreArch.elf
	${GCC_PATH}/${GCC_PREFIX}-objdump -D $< > $@

coreArch.hex: coreArch.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	
##############################################################################
# Runing the simulations
##############################################################################

coreArch.vvp: coreArch_tb.v coreArch.hex
## RTL
ifeq ($(SIM),RTL)
	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	-DSIGNATURE_START=$(SIGNATURE_START) -DSIGNATURE_END=$(SIGNATURE_END) -DCODE_END=$(CODE_END) \
	-f$(USER_PROJECT_VERILOG)/includes/includes.rtl.$(CONFIG) -o $@ $<
endif 

## GL
ifeq ($(SIM),GL)
	iverilog -Ttyp -DFUNCTIONAL -DGL -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	-DSIGNATURE_START=$(SIGNATURE_START) -DSIGNATURE_END=$(SIGNATURE_END) -DCODE_END=$(CODE_END) \
	-f$(USER_PROJECT_VERILOG)/includes/includes.gl.$(CONFIG) -o $@ $<
endif 

## GL+SDF
ifeq ($(SIM),GL_SDF)
	cvc64  +interp \
	+define+SIM +define+FUNCTIONAL +define+GL +define+USE_POWER_PINS +define+UNIT_DELAY +define+ENABLE_SDF \
	+change_port_type +dump2fst +fst+parallel2=on   +nointeractive +notimingchecks +mipdopt \
	-f $(USER_PROJECT_VERILOG)/includes/includes.gl+sdf.$(CONFIG) $<
endif

coreArch.vcd: coreArch.vvp
ifeq ($(SIM),RTL)
	vvp  $<
	 mv $@ RTL-$@
endif
ifeq ($(SIM),GL)
	vvp  $<
	 mv $@ GL-$@
endif

.PHONY: hex

#      - name: Run RISC-V architecture tests
#        run: |
#		   pip install riscv_config  # Might not be needed
#		   pip install riscof
#		   docker pull registry.gitlab.com/incoresemi/docker-images/compliance
#			Needs riscv gcc 
#				sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev \
#				libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
#				patchutils bc zlib1g-dev libexpat-dev
#				git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
#				git clone --recursive https://github.com/riscv/riscv-opcodes.git
#				cd riscv-gnu-toolchain
#				./configure --prefix=/path/to/install --with-arch=rv32gc --with-abi=ilp32
#				sudo make
# 			Go to correct dir
#			riscof --verbose info arch-test --clone
# 			riscof validateyaml --config=config.ini
#			riscof testlist --config=config.ini --suite=riscv-arch-test/riscv-test-suite/ --env=riscv-arch-test/riscv-test-suite/env
#			riscof run --config=config.ini --suite=riscv-arch-test/riscv-test-suite/ --env=riscv-arch-test/riscv-test-suite/env
#		# I think this is the old way
#		   export RISCV_ARCH_TESTS=$PWD/riscv-arch-test # 
#          git clone https://github.com/riscv-non-isa/riscv-arch-test.git          