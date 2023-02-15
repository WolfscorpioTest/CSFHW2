/* Hexdump main function, assembly language version */
	.section .rodata
		newline:
			.string "\n"
		space:
			.string " "
		three_space:
			.string "   "
		test:
			.string "Hello, world"

	.section .text

	.globl main
main:
	/* offset %r9 */
	mov $0, %r9
	jmp .Lloop

.Lloop:
	/* save variables here */

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


	/* insert space padding */
	mov $2, %rdi
	call write_spaces
	

	/* insert ascii data */
	/*mov %rsp, %rdi
	call hex_write_string */

	/* if we have less than 16 add newline */
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
	/* restore stack frame */
	addq $32, %rsp
	popq %rbp

	/* restore variables here */

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

