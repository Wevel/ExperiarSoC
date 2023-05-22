CPU=vexriscv
CPUFAMILY=riscv
RISCV_ARCH := rv32i
CPUFLAGS=-march=rv32i      -mabi=ilp32
CPUENDIANNESS=little
CLANG=0
CSTD := c18
CPPSTD := gnu++17

LINKER_SCRIPT?=$(TARGET_PATH)/verilog/dv/firmware/sections.lds
SOURCE_FILES?=$(TARGET_PATH)/verilog/dv/firmware/start.s 
VERILOG_FILES=

DEFINES = \
	-D__riscv=1 \
	-D__riscv_cmodel_medlow=1 \
	-D__riscv_float_abi_soft=1 \
	-D__riscv_xlen=32

# C flags common to all targets
CFLAGS += -Og -ggdb3
CFLAGS += $(DEFINES)
CFLAGS += -fno-builtin
CFLAGS += -fno-unroll-loops
CFLAGS += -march=$(RISCV_ARCH)
CFLAGS += -mabi=ilp32

CFLAGS += -Wall
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin -fshort-enums
CFLAGS += -fdiagnostics-color=always

# Linker flags
CFLAGS += -Wl,-Bstatic,-T$(LINKER_SCRIPT),--strip-debug
CFLAGS += -nostartfiles -ffreestanding -Wl,--gc-sections
CFLAGS += -static-libgcc

.SUFFIXES:
all:  ${BLOCKS:=.lst}
hex:  ${BLOCKS:=.hex}
#.SUFFIXES:

##############################################################################
# Compile firmware
##############################################################################
%.elf: %.c $(LINKER_SCRIPT) $(SOURCE_FILES)
	${GCC_PATH}/${GCC_PREFIX}-gcc -g $(CPUFLAGS) -std=$(CSTD) $(CFLAGS) -Wl,-Map=$(@:.elf=.map) -o $@ $(SOURCE_FILES) $<
	@${GCC_PATH}/${GCC_PREFIX}-size $@

%.lst: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objdump -d -S $< > $@

%.hex: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy --set-start 0x14000000 -O verilog $< $@
	sed -ie 's/@14/@00/g' $@

%.bin: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

.PHONY: hex