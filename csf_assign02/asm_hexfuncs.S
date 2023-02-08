/* Assembly language implementation of hexdump functions */

	.section .rodata

	/* TODO: add read-only data such as strings here */



	.section .text

		.globl hex_read
    hex_readt:
    	/* TODO: implement */
    	ret

		.globl hex_write_string
    hex_write_string:
    	/* TODO: implement */
    	ret

		.globl hex_format_offset
    hex_format_offset:
    	/* TODO: implement */
    	ret

		.globl hex_format_byte_as_hex
    hex_format_byte_as_hex:
    	/* TODO: implement */
    	ret

	/*
	 * rdi byteval
	 * TODO: maybe change quads to bytes
	 */
		.globl hex_to_printable
    hex_to_printable:
		/* if byteval < 38*/
		cmpq $38,%rdi
		jl non_hex
		/* if byteval > 126*/
		cmpq $126,%rdi
		jg non_hex
		/* return byteval as is */
		movq %rdi, %rax
    	ret
	non_hex:
		/* '.' is 46 decimal. return 'a' */
		movq $46,%rax
		ret

/* vim:ft=gas:assembly
 */
