/* Hexdump main function, assembly language version */
	.section .roData
		newline:
			.ascii "\n"
		space:
			.ascii " "
		three_space:
			.ascii "   "

	.section .text

	.globl main
main:
	/* offset %r8 */
	mov 0, %r8
	jmp .Lloop

.Lloop
	/* save variables here */

	/* create buffer */
	push %rbp
	mov %rsp, %rbp
	subq $32, %rsp
	/* call read */
	mov %rsp, %rdi
	call hex_read
	/* if we read nothing leave early*/
	cmp $0, %rax /* change byte register from %rax to something else*/
	je .Lend

	/* insert offset */
	/* pass offset */
	/* pass buffer maybe */
	call write_offset


	/* insert hex data */

	/* insert space padding */

	/* insert ascii data */

	/* if we have less than 16 add newline */
	cmp $16, $rax /* change byte register from %rax to something else*/
	jl .Lnewline

	/* write a newline */
	/* increment offset by 16 */
	add $0x10, %r8
	jmp .Lloop

.Lnewline
	/* write a newline and then return*/
.Lend
	/* restore stack frame */
	addq $32, $rsp
	popq %rbp

	/* restore variables here */

	ret



write_offset:
	ret



/* vim:ft=gas:
 */
