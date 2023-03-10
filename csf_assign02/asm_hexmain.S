/* Hexdump main function, assembly language version */
	.section .rodata
		newline:
			.string "\n"
		space:
			.string " "
		three_space:
			.string "   "
		colon:
			.string ": "
		test:
			.string "Hello, world"
	.section .text

	.globl main
main:
	/* save variables here */

    # movl %esp, %ebp # for correct debugging - who added this?? - mac
	/* offset %r9 */
	mov $0, %r9
.Lloop:
	/* create buffer */
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp // stack moved 5*8
	/* call read */
	movq %rsp, %rdi
	call hex_read
	mov %rax, %r10
	/* if we read nothing leave early*/
	cmpq $0, %r10 
	je .Lend // remember to restore stack frame if we leave early
	
	/* call write_offset */
	movq %r9, %rdi
	call write_offset

	/* insert hex data */
	mov %rsp, %rdi
	mov %r10, %rsi
	call write_hex

	/* insert space padding */
	mov %r10, %rdi
	call write_spaces
	

	/* insert ascii data */
	mov %rsp, %rdi
	mov %r10, %rsi
	call write_printable

	# we are done with the buffer by this point
	/* restore stack frame */
	addq $32, %rsp
	popq %rbp
	
	/* if we have less than 16 add newline and break early */
	cmpq $16, %r10 
	jl .Lnewline

	/* write a newline */
	mov $newline, %rdi
	call hex_write_string
	/* increment offset by 16 */
	addq $16, %r9
	jmp .Lloop

.Lnewline:
	/* write a newline and then return*/
	mov $newline, %rdi
	call hex_write_string
	movq $0, %rax
	ret // everything should be cleaned up by this point
.Lend:
	/* restore stack frame if we exit early */
	addq $32, %rsp
	popq %rbp
	movq $0, %rax
	ret


	/*
	 * %rdi *buf
	 * %rsi number_of_characters
	 */
write_printable:
	push %r9
	push %r11

	mov	$0, %r9 # intitialize counter
.Lprint_loop:
	push %rdi

	# make a hex buffer
	push %rbp
	movq %rsp, %rbp
	subq $16, %rsp // rsp moved 5*8 bytes


	movb (%rdi, %r9, 1), %r11b
	movq $0, %rdi
	movb %r11b, %dil // load byte from data
	call hex_to_printable

	movq %rax, (%rsp) // create string of one ASCI character
	movq $0, 1(%rsp)

	movq %rsp, %rdi
	call hex_write_string

	# clean up the buffer
	addq $16, %rsp
	pop %rbp

	pop %rdi
	inc %r9
	cmpq %rsi, %r9
	jb .Lprint_loop
	pop %r11
	pop %r9
	ret

	/*
	 * %rdi *buf
	 * %rsi number_of_characters
	 */
write_hex:
	push %r9
	push %r11


	mov	$0, %r9 # intitialize counter
.Lhex_loop:
	push %rsi
	push %rdi

	# make a hex buffer
	push %rbp
	movq %rsp, %rbp
	subq $16, %rsp 
	mov %rsp, %rsi //rsp moved 7*8

	movq (%rdi,%r9,1), %r11
	movb %r11b, %dil
	call hex_format_byte_as_hex # takes %dil and $rsi

	mov %rsi, %rdi
	call hex_write_string
	
	# clean up the buffer
	addq $16, %rsp
	pop %rbp

	mov $space, %rdi
	call hex_write_string

	pop %rdi
	pop %rsi

	inc %r9
	cmpq %rsi, %r9
	jb .Lhex_loop


	pop %r11
	pop %r9
	ret


	/*
	 *	%rdi offset
	 */
write_offset:
	push %r10
	/* create buffer */
	push %rbp
	mov %rsp, %rbp
	subq $24, %rsp // stack moved 5*8

	/* generate the hex offseet string */
	mov %rsp, %rsi
	call hex_format_offset

	/* write the offset */
	mov %rsi, %rdi
	call hex_write_string

	mov $colon, %rdi
	call hex_write_string
	
	addq $24, %rsp
	popq %rbp
	pop %r10
	ret


	/*
	 * rdi number of bytes twritten
	 */
write_spaces:
	push %r9
	mov $16, %r9
	push %rdi // align stack?

	cmp $16, %rdi
	jge .Lwoffset_end
	subq %rdi, %r9 
.Lspaces_loop:
	mov $three_space, %rdi
	call hex_write_string
	dec %r9
	cmp $0, %r9
	jg .Lspaces_loop
.Lwoffset_end:
	mov $space, %rdi
	call hex_write_string
	pop %rdi
	pop %r9
	ret


; vim:ft=asm

