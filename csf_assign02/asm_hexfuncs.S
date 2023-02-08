/* Assembly language implementation of hexdump functions */

	.section .rodata

	/* TODO: add read-only data such as strings here */
	/* define HEX_DIGITS */
	HEX_DIGITS:
		.ascii "0123456789abcdef"

	.section .text

		.globl hex_read
    hex_read:
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

	/*
	 * dil byteval
	 * rsi *sbuf
	 */
		.globl hex_format_byte_as_hex
    hex_format_byte_as_hex:
		/* load HEX_DIGITS */
		mov $HEX_DIGITS, %r9
		/* upper half */
		movzb %dil, %rax
		shrb $0x4, %al
		andb $0x0F, %al
		/* %al = (%r9 + %al) */
		movb (%r9, %rax), %al
		movb %al, (%rsi)
		/* lower half */
		movb %dil, %al
		andb $0x0F, %al
		movb (%r9, %rax), %al
		movb %al, 1(%rsi)
		/* add null-terminator */
		movb $0, 2(%rsi)
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
