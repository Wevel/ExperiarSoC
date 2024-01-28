
#TOOLCHAIN_PATH=/usr/bin/
TOOLCHAIN_PATH=/opt/riscv32i/bin/
#TOOLCHAIN_PATH=/opt/riscv32imc/bin/
# TOOLCHAIN_PATH=/ef/apps/bin/

# Set the prefix for `riscvXX-unknown-elf-*`
# On installations using `multilib`, this will be `riscv64` even for compiling to 32-bit targets
TOOLCHAIN_PREFIX=riscv32-unknown-elf
#TOOLCHAIN_PREFIX=riscv32
ARCH=rv32i
#ARCH=rv32i_zicsr

SDK_PATH=/mnt/f/Git/caravel_board/firmware/chipignite

# ---- Test patterns for project raven ----

.SUFFIXES:

PATTERN = bringup

hex:  ${PATTERN:=.hex}

%.elf: %.c $(SDK_PATH)/sections.lds $(SDK_PATH)/crt0_vex.S
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-gcc -I$(SDK_PATH)/ -I$(SDK_PATH)/generated/ -O0 -mabi=ilp32 -march=$(ARCH) -D__vexriscv__ -Wl,-Map=$(@:.elf=.map) -Wl,-Bstatic,-T,$(SDK_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(SDK_PATH)/crt0_vex.S $(SDK_PATH)/isr.c $(SDK_PATH)/stub.c core.S $<
	${TOOLCHAIN_PATH}$(TOOLCHAIN_PREFIX)-size $@
	${TOOLCHAIN_PATH}$(TOOLCHAIN_PREFIX)-objdump -D bringup.elf > bringup.lst

%.hex: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O verilog $< $@
	sed -ie 's/@1000/@0000/g' $@

%.bin: %.elf
	$(TOOLCHAIN_PATH)$(TOOLCHAIN_PREFIX)-objcopy -O binary $< $@

client: client.c
	gcc client.c -o client

flash: bringup.hex
	python3 $(SDK_PATH)/util/caravel_hkflash.py bringup.hex

flash2: bringup.hex
	python3 $(SDK_PATH)/util/caravel_flash.py bringup.hex

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd

.PHONY: clean hex all flash

