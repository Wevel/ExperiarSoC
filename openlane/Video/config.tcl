set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) "8"

set ::env(DESIGN_NAME) Video

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/Video/Video_top.v \
	$script_dir/../../verilog/rtl/Video/VideoMemory_top.v \
	$script_dir/../../verilog/rtl/Video/VGA_top.v \
	$script_dir/../../verilog/rtl/Peripherals/WBPeripheralBusInterface/WBPeripheralBusInterface_top.v \
	$script_dir/../../verilog/rtl/Peripherals/Registers/ConfigurationRegister.v"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) "25"

set ::env(PL_TIME_DRIVEN) 0

# Absolute module size
# Modules should be bigger than 200x200
# Also generally best to leave bottom left as 0,0
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) "0 0 350 500"

# Alternatively use an adaptive size
#set ::env(FP_SIZING) "relative"
#set ::env(FP_CORE_UTIL) 20
#set ::env(FP_ASPECT_RATIO) 1.0

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.30

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
# set ::env(GLB_RT_MAXLAYER) 5
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