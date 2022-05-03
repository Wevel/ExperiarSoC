set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) "8"

set ::env(DESIGN_NAME) Peripherals

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/Peripherals/Peripherals_top.v"

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) "10"

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
	wbPeripheralBusInterface vccd1 vssd1 \
	gpio vccd1 vssd1 \
	ioMux vccd1 vssd1 \
	pwm vccd1 vssd1 \
	spi vccd1 vssd1 \
	uart vccd1 vssd1"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/Peripherals/WBPeripheralBusInterface/WBPeripheralBusInterface_top.v \
	$script_dir/../../verilog/rtl/Peripherals/GPIO/GPIO_top.v \
	$script_dir/../../verilog/rtl/Peripherals/IOMultiplexer/IOMultiplexer_top.v \
	$script_dir/../../verilog/rtl/Peripherals/PWM/PWM_top.v \
	$script_dir/../../verilog/rtl/Peripherals/SPI/SPI_top.v \
	$script_dir/../../verilog/rtl/Peripherals/UART/UART_top.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/WBPeripheralBusInterface.lef \
	$script_dir/../../lef/GPIO.lef \
	$script_dir/../../lef/IOMultiplexer.lef \
	$script_dir/../../lef/PWM.lef \
	$script_dir/../../lef/SPI.lef \
	$script_dir/../../lef/UART.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/WBPeripheralBusInterface.gds \
	$script_dir/../../gds/GPIO.gds \
	$script_dir/../../gds/IOMultiplexer.gds \
	$script_dir/../../gds/PWM.gds \
	$script_dir/../../gds/SPI.gds \
	$script_dir/../../gds/UART.gds"

# Absolute module size
# Modules should be bigger than 200x200
# Also generally best to leave bottom left as 0,0
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) "0 0 1000 1500"

# Alternatively use an adaptive size
#set ::env(FP_SIZING) "relative"
#set ::env(FP_CORE_UTIL) 20
#set ::env(FP_ASPECT_RATIO) 1.0

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.01

# Use to prevent standard cells being generated
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

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
