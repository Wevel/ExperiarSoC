OUTPUT_ARCH(riscv)

MEMORY
{
	ROM (rx)  : ORIGIN = 0x14000000, LENGTH = 0x00800000
	RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00001000
}

ENTRY(_start)

SECTIONS
{
	_stack_size = DEFINED(_stack_size) ? _stack_size : 512;

	/* https://interrupt.memfault.com/blog/how-to-write-linker-scripts-for-firmware */

	.text :
    {
		. = ALIGN(4);
		PROVIDE (_stext = .);

        KEEP(*(.vectors .vectors.*))
        *(.rodata .rodata.*)  
		*(.srodata .srodata.*)		
		*(.text .text.*)
		*(.plt .plt.*)
		*(.interp .interp.*)
		*(.dynsym .dynsym.*)
		*(.dynstr .dynstr.*)
		*(.hash .hash.*)
		*(.gnu .gnu.*)
		*(.eh_frame_hdr .eh_frame_hdr.*)
		*(.rela .rela.*)

		. = ALIGN(4);
        _etext = .;
		_sidata = _etext;
    } > ROM

    .data : AT (_sidata)
    {
		. = ALIGN(4);
        _sdata = .;

		PROVIDE(_global_pointer$ = . + (4K / 2));

		*(.sdata .sdata.*)
		*(.rdata .rdata.*) 
        *(.data .data.*);

		. = ALIGN(4);
        _edata = .;
    } > RAM
	
    .bss (NOLOAD) :
    {
		. = ALIGN(4);
        _sbss = .;
		
		*(.sbss .sbss.*)
        *(.bss .bss.*)
        *(COMMON)

		. = ALIGN(4);
        _ebss = .;
    } > RAM

	.heap (NOLOAD) :
    {
        . = ALIGN(4);
        _heap_start = .;
    } > RAM

	.stack ORIGIN(RAM) + LENGTH(RAM) - _stack_size (NOLOAD) :
	{
		PROVIDE( _heap_end = . ); 
		. = _stack_size;  
		 _stack_top = .;
	} > RAM

	PROVIDE (_end = .);
}