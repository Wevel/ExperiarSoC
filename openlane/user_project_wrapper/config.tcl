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
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) "12"

set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/ExperiarSoC/ExperiarSoC_top.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "wb_clk_i"
 # user_clock2

set ::env(CLOCK_PERIOD) "25"

## Internal Macros
### Macro PDN Connections
# This only seems to be needed for the newer version of openlane
#set ::env(FP_PDN_MACRO_HOOKS) "\
#	art vccd1 vssd1, \
#	caravelHost vccd1 vssd1, \
#	experiarSoC/core0 vccd1 vssd1, \
#	experiarSoC/core1 vccd1 vssd1, \
#	experiarSoC/flash vccd1 vssd1, \
#	experiarSoC/peripherals vccd1 vssd1, \
#	experiarSoC/video vccd1 vssd1, \
#	experiarSoC/wishboneInterconnect vccd1 vssd1, \
#	experiarSoC/core0SRAM0 vccd1 vssd1, \
#	experiarSoC/core0SRAM1 vccd1 vssd1, \
#	experiarSoC/core1SRAM0 vccd1 vssd1, \
#	experiarSoC/core1SRAM1 vccd1 vssd1, \
#	experiarSoC/videoSRAM0 vccd1 vssd1, \
#	experiarSoC/videoSRAM1 vccd1 vssd1, \
#	experiarSoC/videoSRAM2 vccd1 vssd1, \
#	experiarSoC/videoSRAM3 vccd1 vssd1, \
#	experiarSoC/flashSRAM vccd1 vssd1"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/Art/Art_top.v \
	$script_dir/../../verilog/rtl/CaravelHost/CaravelHost_top.v \
	$script_dir/../../verilog/rtl/ExperiarCore/ExperiarCore_top.v \
	$script_dir/../../verilog/rtl/Flash/Flash_top.v \
	$script_dir/../../verilog/rtl/Peripherals/Peripherals_top.v \
	$script_dir/../../verilog/rtl/Video/Video_top.v \
	$script_dir/../../verilog/rtl/WishboneInterconnect/WishboneInterconnect_top.v \
	$::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/Art.lef \
	$script_dir/../../lef/CaravelHost.lef \
	$script_dir/../../lef/ExperiarCore.lef \
	$script_dir/../../lef/Flash.lef \
	$script_dir/../../lef/Peripherals.lef \
	$script_dir/../../lef/Video.lef \
	$script_dir/../../lef/WishboneInterconnect.lef \
	$::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/Art.gds \
	$script_dir/../../gds/CaravelHost.gds \
	$script_dir/../../gds/ExperiarCore.gds \
	$script_dir/../../gds/Flash.gds \
	$script_dir/../../gds/Peripherals.gds \
	$script_dir/../../gds/Video.gds \
	$script_dir/../../gds/WishboneInterconnect.gds \
	$::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds"

# Exclude regions for Art and SRAM
set ::env(GLB_RT_OBS) "\
        met5 0.0 0.0 2920.0 3520.0,\
        li1 210.0 2508.0 515.0 3258.0,\
        met1 210.0 2508.0 515.0 3258.0,\
        met2 210.0 2508.0 515.0 3258.0,\
        met3 210.0 2508.0 515.0 3258.0,\
        met4 210.0 2508.0 515.0 3258.0,\
        met5 210.0 2508.0 515.0 3258.0,\
        met4 140.0 150.0 823.1 566.54,\
        met5 140.0 150.0 823.1 566.54,\
        met4 140.0 715.0 823.1 1131.54,\
        met5 140.0 715.0 823.1 1131.54,\
        met4 140.0 1300.0 823.1 1716.54,\
        met5 140.0 1300.0 823.1 1716.54,\
        met4 140.0 1865.0 823.1 2281.54,\
        met5 140.0 1865.0 823.1 2281.54,\
        met4 717.0 2400.0 1400.1 2816.54,\
        met5 717.0 2400.0 1400.1 2816.54,\
        met4 717.0 2950.0 1400.1 3366.54,\
        met5 717.0 2950.0 1400.1 3366.54,\
        met4 2050.0 2400.0 2733.1 2816.54,\
        met5 2050.0 2400.0 2733.1 2816.54,\
        met4 2050.0 2950.0 2733.1 3366.54,\
        met5 2050.0 2950.0 2733.1 3366.54,\
        met4 2050.0 150.0 2733.1 566.54,\
        met5 2050.0 150.0 2733.1 566.54"

# Allow top level to use metal4 for routing
set ::env(RT_MAX_LAYER) {met5}

# disable pdn check nodes because it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 1

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0

# Extend halo at top and bottom of each macro so that vertical power stripes
# don't get placed between macros. These tend to not be connected to anything
# and so throw an error
set ::env(FP_PDN_VERTICAL_HALO) 125

#set ::env(FP_PDN_HORIZONTAL_HALO) 5

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

# Save a .png after each SYNTH_TOP_LEVEL
# This doesn't work right now :(
#set ::env(TAKE_LAYOUT_SCROT) 1

# Disable running XOR test as it is very slow
# This should be reenabled before submission
set ::env(RUN_KLAYOUT_XOR) 0

# Disable running DRC test as it is very slow and seems to run out of memory and crash
# This should be reenabled before submission
set ::env(RUN_MAGIC_DRC) 0

# Defaults to 0.3. Set lower to give more space to routing
# This can help reduce congestion
set ::env(GLB_RT_ADJUSTMENT) 0.25

# If there is congestion allow it in the build, then look at the .guide files
#set ::env(GLB_RT_ALLOW_CONGESTION) 1