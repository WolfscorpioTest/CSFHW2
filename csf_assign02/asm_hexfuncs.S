/* Assembly language implementation of hexdump functions */

	.section .rodata

	/* TODO: add read-only data such as strings here */
	/* define HEX_DIGITS */
	HEX_DIGITS:
		.ascii "0123456789abcdef"


	.section .text

		.globl hex_read
    hex_read:
		push %rdi
		movq $0, %rdi
		pop %rsi
		movq $16, %rdx
		call read

    	/* TODO: implement */
    	ret

		.globl hex_write_string
    hex_write_string:
    	/* TODO: implement */
    	ret
		
	 /*
	  * rdi *sbuf
	  * returns length in rax
	  */
		.globl string_length
	string_length:
		subq $8, %rsp
		movq $0, %rax
	.Lstring_length_loop:
		cmpb $0, (%rdi)
		jz .Lstring_length_done
		inc %rax
		inc %rdi
		jmp .Lstring_length_loop
	.Lstring_length_done:
		add $8, %rsp
		ret

	 /*
	  * rdi offset
	  * rsi *sbuf
	  * destroys rax, rcx, r9, r10, r11
	  */
		.globl hex_format_offset
    hex_format_offset:
		movq $3, %r9 /* i = 3 */
    	jmp .Lcheckcond
	.Ltop:
		/* extracts a byte from rdi*/
		movq %rdi, %rax
		movq %r9, %rcx
		imul $8, %rcx 
		shrq %cl, %rax 
		andb $0xFF, %al

		/* save registers*/
		mov %rsi, %r10
	    mov %rdi, %r11


		/* make a buffer on the stack here */
		push %rbp
		mov %rsp, %rbp
		subq $16, %rsp


		mov %al, %dil
		mov %rsp, %rsi
		call hex_format_byte_as_hex

		/* restore registers*/
		mov %r10, %rsi
		mov %r11, %rdi

		movb 1(%rsp), %al /* %al will contain the upper hex character*/
		movq %r9, %r10     /* move index into %r10 to do math */
		sal $1, %r10        /* %r10 is doubled */
		mov $7, %r11	   /* %r11 = 7 */
		subq %r10, %r11    /* %r11 = %r11 - %r10 */
		movb %al, (%rsi,%r11)

		movb (%rsp), %al /* %al will contain the lower hex character*/
		movb %al, -1(%rsi,%r11)

		addq $16, %rsp
		pop %rbp

		decq %r9
	.Lcheckcond:
		cmpq $0, %r9
		jge .Ltop
		movb $0, 8(%rsi) /*add null terminator */
		ret
	/*
	 * dil byteval
	 * rsi *sbuf
	 * destroys %rcx, %rax
	 */
		.globl hex_format_byte_as_hex
    hex_format_byte_as_hex:
		/* load HEX_DIGITS */
		mov $HEX_DIGITS, %rcx
		/* upper half */
		movzb %dil, %rax
		shrb $0x4, %al
		andb $0x0F, %al
		/* %al = (%r9 + %al) */
		movb (%rcx, %rax), %al
		movb %al, (%rsi)
		/* lower half */
		movb %dil, %al
		andb $0x0F, %al
		/* %al = (%r9 + %al) */
		movb (%rcx, %rax), %al
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
