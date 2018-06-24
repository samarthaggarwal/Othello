	.equ SWI_Exit, 0x11
	.equ SWI_Open, 0x66
	.equ SWI_Close, 0x68
	.equ SWI_PrInt, 0x6b
	.equ SWI_PrStr, 0x69
	.text

	ldr r9,=A	@r9 for looping
	ldr r10,=B	@r10 for loop end
	ldr r11,=one
	ldr r8,=extra
	ldr r7,=seven

mn:
	mov r1,r9;
	mov r0,r8;
	bl copy;

	mov r1,r8;
	bl check_happy;
	cmp r0,#1;
	mov r1,r9;
	bleq print;

	mov r0,r9;
	mov r1,r11;
	bl addreg;
	mov r1,r10;
	bl compare;
	cmp r0,#1;
	blt mn;
	swi SWI_Exit

copy:		@copies from r1 to r0;
	mov r12,#12;
	l4:
	ldr r2,[r1,r12];
	str r2,[r0,r12];
	sub r12,r12,#4;
	cmp r12,#0;
	bge l4;
	mov pc,lr;

compare:		@input addresses in r0,r1  , output in r0
	mov r12,#12;
	lp1:
	ldr r2,[r0,r12];
	ldr r3,[r1,r12];
	cmp r2,r3;
	movlt r0,#0;
	movgt r0,#2;
	movne pc,lr;
	sub r12,r12,#4;
	cmp r12,#0;
	bge lp1;
	mov r0,#1;
	mov pc,lr;
	
addreg:		@input addresses in r0,r1 , output in r0
	ldr r2,[r0];
	ldr r3,[r1];
	add r2,r2,r3;
	cmp r2,#9
	subgt r2,r2,#10;
	str r2,[r0];

	ldr r2,[r0,#4];
	ldr r3,[r1,#4];
	add r2,r2,r3;
	addgt r2,r2,#1;
	cmp r2,#9
	subgt r2,r2,#10;
	str r2,[r0,#4];

	ldr r2,[r0,#8];
	ldr r3,[r1,#8];
	add r2,r2,r3;
	addgt r2,r2,#1;
	cmp r2,#9
	subgt r2,r2,#10;
	str r2,[r0,#8];

	ldr r2,[r0,#12];
	ldr r3,[r1,#12];
	add r2,r2,r3;
	addgt r2,r2,#1;
	cmp r2,#9
	subgt r2,r2,#10;
	str r2,[r0,#12];

	mov pc,lr


check_happy:	@input in r1, output in r0
	mov r0,#0;
	mov r12,#12;
squaresum:
	ldr r2,[r1, r12];
	mov r3,r2;
	mul r2,r3,r3;
	add r0,r0,r2;
	sub r12,r12,#4;
	cmp r12,#0;
	bge squaresum;

	cmp r0,#10;
	blt l3;
	
	@sum of squares in r0, split to r1
	mov r12,#0;
	str r12,[r1];
	str r12,[r1,#4];
	str r12,[r1,#8];
	str r12,[r1,#12];
	mov r3,#0;
l5:
	cmp r0,#10;
	subge r0,r0,#10;
	addge r3,r3,#1;
	bge l5;
	str r0,[r1,r12];
	mov r0,r3;
	mov r3,#0;

	add r12,r12,#4;
	cmp r12,#12;
	blt l5;

	b check_happy;

l3:
	cmp r0,#1;
	moveq r0,#1;
	moveq pc,lr;
	cmp r0,#7;
	moveq r0,#1;
	moveq pc,lr;
	
	mov r0,#0;
	mov pc,lr


print:			@input in r3
	ldr r0,=outfilename
	mov r1,#2
	swi SWI_Open
@	bcs NoFileFound
	ldr r1,=outfilehandle;
	str r0,[r1];
	ldr r0,=outfilehandle;
	ldr r0,[r0];

	ldr r1,[r9,#12];
	swi SWI_PrInt;
	ldr r1,[r9,#8];
	swi SWI_PrInt;
	ldr r1,[r9,#4];
	swi SWI_PrInt;
	ldr r1,[r9];
	swi SWI_PrInt;
	ldr r1,=newline;
	swi SWI_PrStr;

	swi SWI_Close;
	mov pc,lr

	.data

A:	.word 1,0,0,0	@big-endian format
B:	.word 9,9,9,9
one:	.word 1,0,0,0
extra:	.word 0,0,0,0
seven:	.word 7,0,0,0
newline:	.ascii	"\n"
outfilehandle:	.word	0
outfilename:	.asciz	"output.txt"

	.end


@print:			@input in r3, print for stdout
@	mov r0,#1;
@	ldr r1,[r9,#12];
@	swi 0x6b;
@	ldr r1,[r9,#8];
@	swi 0x6b;
@	ldr r1,[r9,#4];
@	swi 0x6b;
@	ldr r1,[r9];
@	swi 0x6b;
@	ldr r0,=newline;
@	swi 0x02;
@	mov pc,lr