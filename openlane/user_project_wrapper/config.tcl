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
set ::env(FP_PDN_MACRO_HOOKS) "\
	caravelHost vccd1 vssd1, \
	experiarSoC/wishboneInterconnect vccd1 vssd1, \
	experiarSoC/core0 vccd1 vssd1, \
	experiarSoC/core1 vccd1 vssd1, \
	experiarSoC/flash vccd1 vssd1, \
	experiarSoC/peripherals vccd1 vssd1, \
	experiarSoC/video vccd1 vssd1, \
	experiarSoC/core0SRAM0 vccd1 vssd1, \
	experiarSoC/core0SRAM1 vccd1 vssd1, \
	experiarSoC/core1SRAM0 vccd1 vssd1, \
	experiarSoC/core1SRAM1 vccd1 vssd1, \
	experiarSoC/videoSRAM0 vccd1 vssd1, \
	experiarSoC/videoSRAM1 vccd1 vssd1, \
	experiarSoC/videoSRAM2 vccd1 vssd1, \
	experiarSoC/videoSRAM3 vccd1 vssd1, \
	experiarSoC/flashSRAM vccd1 vssd1, \
	art vccd1 vssd1"

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
	li1   750 2285 1166.54 2933.1,\
 	met1  750 2285 1166.54 2933.1,\
 	met2  750 2285 1166.54 2933.1,\
 	met3  750 2285 1166.54 2933.1,\
  	li1   200 2285  616.54 2933.1,\
  	met1  200 2285  616.54 2933.1,\
  	met2  200 2285  616.54 2933.1,\
  	met3  200 2285  616.54 2933.1,\
  	li1   750  160 1166.54  576.54,\
  	met1  750  160 1166.54  576.54,\
  	met2  750  160 1166.54  576.54,\
  	met3  750  160 1166.54  576.54,\
  	li1   200  160  416.54  843.1,\
  	met1  200  160  416.54  843.1,\
  	met2  200  160  416.54  843.1,\
  	met3  200  160  416.54  843.1,\
 	li1  1970 1900 2653.1  2316.54,\
 	met1 1970 1900 2653.1  2316.54,\
 	met2 1970 1900 2653.1  2316.54,\
 	met3 1970 1900 2653.1  2316.54,\
 	li1  1970 2440 2653.1  2856.54,\
 	met1 1970 2440 2653.1  2856.54,\
 	met2 1970 2440 2653.1  2856.54,\
 	met3 1970 2440 2653.1  2856.54,\
 	li1  1970 2970 2653.1  3386.54,\
 	met1 1970 2970 2653.1  3386.54,\
 	met2 1970 2970 2653.1  3386.54,\
 	met3 1970 2970 2653.1  3386.54,\
 	li1  1366 2730 1782.54 3413.1,\
 	met1 1366 2730 1782.54 3413.1,\
 	met2 1366 2730 1782.54 3413.1,\
 	met3 1366 2730 1782.54 3413.1,\
 	li1  1930  120 2613.1   536.54,\
 	met1 1930  120 2613.1   536.54,\
 	met2 1930  120 2613.1   536.54,\
 	met3 1930  120 2613.1   536.54,\
	li1  340 3090 1090 3390,\
	met1 340 3090 1090 3390,\
	met2 340 3090 1090 3390,\
	met3 340 3090 1090 3390"

#set ::env(GLB_RT_OBS) "\
#	li1   400  175 683.1 416.54,\
#	met1  400  175 683.1 416.54,\
#	met2  400  175 683.1 416.54,\
#	met3  400  175 683.1 416.54,\
#	li1   400 2100 683.1 416.54,\
#	met1  400 2100 683.1 416.54,\
#	met2  400 2100 683.1 416.54,\
#	met3  400 2100 683.1 416.54,\
#	li1  1870 2050 683.1 416.54,\
#	met1 1870 2050 683.1 416.54,\
#	met2 1870 2050 683.1 416.54,\
#	met3 1870 2050 683.1 416.54,\
#	li1  1870 2600 683.1 416.54,\
#	met1 1870 2600 683.1 416.54,\
#	met2 1870 2600 683.1 416.54,\
#	met3 1870 2600 683.1 416.54,\
#	li1   100 2700 500   500,\
#	met1  100 2700 500   500,\
#	met2  100 2700 500   500,\
#	met3  100 2700 500   500"

# Allow top level to use metal4 for routing
set ::env(RT_MAX_LAYER) {met5}

# disable pdn check nodes becuase it hangs with multiple power domains.
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
set ::env(FP_PDN_HORIZONTAL_HALO) 5

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

# Save a .png after each SYNTH_TOP_LEVEL
# This doesn't work right now :(
#set ::env(TAKE_LAYOUT_SCROT) 1

# Disable running XOR tests as it is very slow
# This should be reenabled before submission
set ::env(RUN_KLAYOUT_XOR) 0

# Defaults to 0.3. Set lower to give more space to routing
# This can help reduce congestion
set ::env(GLB_RT_ADJUSTMENT) 0.25

# If there is congestion allow it in the build, then look at the .guide files
set ::env(GLB_RT_ALLOW_CONGESTION) 1