	.equ SWI_Exit, 0x11
	.text
	mov r1, #1000
	mov r2, #1
	ldr r3, =AA 
Lab1:
	str r2, [r3]
	add r3, r3, #4
	add r2, r2, #1
	sub r1, r1, #1
	cmp r1, #0
	bne Lab1
	mov r1, #1000
	mov r4, #0
	ldr r3, =AA 
Lab2:
	ldr r2, [r3]
	add r4, r4, r2
	add r3, r3, #4
	sub r1, r1, #1
	cmp r1, #0
	bne Lab2
	add r5, r4, r4
	swi SWI_Exit
	.data
AA:	.space 400
	.end