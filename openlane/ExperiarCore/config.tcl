set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) "12"

set ::env(DESIGN_NAME) ExperiarCore

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/ExperiarCore/ExperiarCore_top.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CoreManagement.v \
	$script_dir/../../verilog/rtl/ExperiarCore/RV32ICore.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Pipe/PipeFetch.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Pipe/PipeOperation.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Pipe/PipeStage.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Pipe/PipeStore.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Utility/InstructionDecode.v\
	$script_dir/../../verilog/rtl/ExperiarCore/Utility/MisalignedMemoryController.v\
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/CSR.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/CSR_ConfigurationRegister.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/CSR_DataRegister.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/CSR_ReadRegister.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/CSR_TimerRegister.v \
	$script_dir/../../verilog/rtl/ExperiarCore/CSR/Traps/Traps.v \
	$script_dir/../../verilog/rtl/ExperiarCore/JTAG.v \
	$script_dir/../../verilog/rtl/ExperiarCore/JTAGRegister.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Memory/LocalMemoryInterface.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Memory/MemoryController.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Wishbone/Core_WBInterface.v \
	$script_dir/../../verilog/rtl/ExperiarCore/Wishbone/WB_SRAMInterface.v \
	$script_dir/../../verilog/rtl/Peripherals/Registers/ConfigurationRegister.v \
	$script_dir/../../verilog/rtl/Peripherals/Registers/DataRegister.v"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) "25"

# CTS BUFFER
set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8"
set ::env(CTS_SINK_CLUSTERING_SIZE) "16"
set ::env(CLOCK_BUFFER_FANOUT) "8"

# Absolute module size
# Modules should be bigger than 200x200
# Also generally best to leave bottom left as 0,0
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) "0 0 500 800"
#set ::env(DIE_AREA) "0 0 500 1000"

# Alternatively use an adaptive size
#set ::env(FP_SIZING) "relative"
#set ::env(FP_CORE_UTIL) 20
#set ::env(FP_ASPECT_RATIO) 1.0

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.375
#set ::env(PL_TARGET_DENSITY) 0.275

# Margin for max slew as percentage
# Not sure what the limits of this value should be
# But it can be changed to remove slew violations
#set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 15
#set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) 5

# If this cell is placed in the top level (user_project_wrapper), then it can't have anything on metal layer 5 as this is used for PDN
# If this cell is placed in another macro, then we can't have anything on metal layer 4 as the parent macro will add the PDN
set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1

set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 10
set ::env(DIODE_INSERTION_STRATEGY) 3

# Save a .png after each SYNTH_TOP_LEVEL
# This doesn't work right now :(
#set ::env(TAKE_LAYOUT_SCROT) 1

set ::env(GLB_RT_ALLOW_CONGESTION) 1