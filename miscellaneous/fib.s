	.equ SWI_Exit, 0x11
	.text

@ n in r1
	mov r1,#8;
	str r1,[sp,#-4]!;
	bl fib;
	ldr r1,[sp],#4;
	swi SWI_Exit;

fib:
	ldr r1,[sp],#4;
	cmp r1,#2;
	movle r1,#1;
	strle r1,[sp,#-4]!;
	movle pc,lr;

	str lr,[sp,#-4]!;
	str r1,[sp,#-4]!;
	sub r1,r1,#1;
	str r1,[sp,#-4]!;
	
	bl fib;
	
	ldr r2,[sp],#4;
	ldr r1,[sp],#4;
	str r2,[sp,#-4]!;
	sub r1,r1,#2;
	str r1,[sp,#-4]!;

	bl fib;

	ldr r1,[sp],#4;
	ldr r2,[sp],#4;
	add r1,r1,r2;
	ldr lr,[sp],#4;
	str r1,[sp,#-4]!;
	mov pc,lr;

	.data
