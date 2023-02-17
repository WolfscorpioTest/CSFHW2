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
	subq $32, %rsp
	/* call read */
	movq %rsp, %rdi
	call hex_read
	mov %rax, %r10
	/* if we read nothing leave early*/
	cmpq $0, %r10 
	je .Lend
	
	/* call write_offset */
	movq %r9, %rdi
	call write_offset

	/* insert hex data */
	mov %rsp, %rdi
	mov %r10, %rsi
	call write_hex


	/* insert space padding */
	mov $2, %rdi
	call write_spaces
	

	/* insert ascii data */
	/*mov %rsp, %rdi
	call hex_write_string */

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
.Lend:
	/* restore variables here */

	ret

	/*
	 * %rdi *buf
	 * %rsi number_of_characters
	 */
write_hex:
	push %r9
	push %r10
	# make a hex buffer
	push %rbp
	movq %rbp, %rsp
	subq $8, %rsp

	mov	0, %r9 # intitialize counter
.Lhex_loop:
	push %rsi
	push %rdi
	mov %rsp, %rsi

	movb (%rdi,%r9), %r10b
	movb %r10b, %dil
	call hex_format_byte_as_hex # takes %dil and $rsi

	mov %rsi, %rdi
	call hex_write_string

	mov $space, %rdi
	call hex_write_string

	pop %rdi
	pop %rsi

	inc %r9
	cmpq %rsi, %r9
	jb .Lhex_loop

	# clean up the buffer
	addq $8, %rsp
	pop %rbp
	pop %r10
	pop %r9
	ret

	/*
	 *	%rdi offset
	 */
write_offset:
	/* create buffer */
	push %rbp
	mov %rsp, %rbp
	subq $16, %rsp

	/* generate the hex offseet string */
	mov %rsp, %rsi
	call hex_format_offset

	/* write the offset */
	mov %rsi, %rdi
	call hex_write_string

	mov $colon, %rdi
	call hex_write_string
	
	addq $16, %rsp
	popq %rbp
	ret


	/*
	 * rdi number of bytes to fill in
	 */
write_spaces:
	push %r9
	mov %rdi, %r9
	push %rdi
.Lspaces_loop:
	mov $three_space, %rdi
	call hex_write_string
	dec %r9
	cmp $0, %r9
	jge .Lspaces_loop
.Lwoffset_end:
    mov $space, %rdi
    call hex_write_string
	pop %rdi
	pop %r9
	ret


; vim:ft=asm

