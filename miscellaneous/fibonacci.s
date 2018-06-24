.text

mov r1,#8;
bl fib;
swi 0x6b;
swi 0x11;

fib:
	str lr,[sp,#-4]!;
	cmp r1,#0;
	moveq r0,#0;
	ldreq pc,[sp],#4;
	cmp r1,#1;
	moveq r0,#1;
	ldreq pc,[sp],#4;

	sub r1,r1,#1;
	
	str r1,[sp,#-4]!;
	bl fib;
	ldr r1,[sp],#4;
	
	str r0,[sp,#-4]!;
	sub r1,r1,#1;
	
	str r1,[sp,#-4]!;
	bl fib;
	ldr r1,[sp],#4;

	ldr r2,[sp],#4;
	add r0,r0,r2;
	ldr pc,[sp],#4;
