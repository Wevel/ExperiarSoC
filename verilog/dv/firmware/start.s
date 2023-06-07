.section .vectors, "ax"
.global _start
.type _start, @function
_start:
    .cfi_startproc 
    .cfi_undefined ra

    .option push
    .option norelax
    la gp, _global_pointer$
    .option pop

    la sp, _stack_top
    add s0, sp, zero

	la a0, _sidata
	la a1, _sdata
	la a2, _edata
	bge a1, a2, end_init_data
loop_init_data:
	lw a3, 0(a0)
	sw a3, 0(a1)
	addi a0, a0, 4
	addi a1, a1, 4
	blt a1, a2, loop_init_data
end_init_data:

	la a0, _sbss
	la a1, _ebss
	bge a0, a1, end_init_bss
loop_init_bss:
	sw zero, 0(a0)
	addi a0, a0, 4
	blt a0, a1, loop_init_bss
end_init_bss:

	la a0, _trap
	csrrw zero, mtvec, a0

    jal main

	ecall

_trap:
	ebreak
	j _trap

_exit:
	jal _exit

    .cfi_endproc

.end
