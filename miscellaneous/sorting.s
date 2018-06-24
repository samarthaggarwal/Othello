	.equ SWI_Exit, 0x11
	.text

	mov r6, #8
	ldr r7, =P
mn:
	sub r6,r6,#1
	mov r9,r6
	ldr r0,=P

inner:
	sub r9,r9,#1
	add r1,r0,#4

	ldr r4,[r0]
	ldr r5,[r1]
	cmp r4,r5
	bgt swap

sret:
	mov r0,r1
	cmp r9,#0
	bgt inner

	cmp r6,#0
	bne mn
	b last

@ r0,r1,r2,r3,r12 can be changed
swap:
	ldr r2,[r0]
	ldr r3,[r1]
	str r3,[r0]
	str r2,[r1]
	b sret
	@mov pc,lr

last:
	swi SWI_Exit
	.data
P: .word 4,10,6,19,3,12,67,35
	.end