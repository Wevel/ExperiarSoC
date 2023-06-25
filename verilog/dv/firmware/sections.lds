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

        KEEP(*(.vectors*))
        *(.rodata*)  
		*(.srodata*)		
		*(.text*)
		*(.plt*)
		*(.interp*)
		*(.dynsym*)
		*(.dynstr*)
		*(.hash*)
		*(.gnu*)
		*(.eh_frame_hdr*)
		*(.rela*)

		. = ALIGN(4);
        _etext = .;
    } > ROM

    .data : 
    {
		. = ALIGN(4);
        _sdata = .;

		PROVIDE(_global_pointer$ = . + (4K / 2));
		
		*(.ramtext*)
		*(.sdata*)
		*(.rdata*) 
        *(.data*);

		. = ALIGN(4);
        _edata = .;
    } > RAM AT > ROM
	_sidata = LOADADDR(.data);

	.bss (NOLOAD) :
    {
		. = ALIGN(4);
        _sbss = .;
		
		*(.sbss*)
        *(.bss*)
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