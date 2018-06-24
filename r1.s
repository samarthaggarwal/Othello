	.equ SWI_Exit, 0x11
	.equ SEG_A,0x80
	.equ SEG_B,0x40
	.equ SEG_C,0x20
	.equ SEG_D,0x08
	.equ SEG_E,0x04
	.equ SEG_F,0x02
	.equ SEG_G,0x01
	.equ SEG_P,0x10

	.equ SWI_SETSEG8,0x200
	.equ DispStr,0x204
	.equ DispInt,0x205
	.equ DispChar,0x207
	.equ ClearDisp,0x204
	.equ ClearLine,0x204	@r0 = column number

	.text
	ldr r10,=Digits;

	bl print;

	mov r1,#8;
	bl numdisp;

@	ldr r2,=P;	
@	mov r0,#30;
@	mov r1,#10;
@	swi DispStr;
@	swi ClearLine;
@	mov r0,#3;
@	mov r1,#1;
@	swi DispStr;
	b last;

print:	@address to be printed in r2
	mov r0,#1;
	mov r1,#42;
	swi DispInt;
	mov pc,lr;

numdisp:
	@ number to be displayed in r1, Digits address in r10
	ldr r0,[r10,r1,LSL#2];
	swi SWI_SETSEG8;
	mov pc,lr;

last:
	swi SWI_Exit

	.data
Digits:
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
.word SEG_B|SEG_C @1
.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
.word SEG_G|SEG_F|SEG_B|SEG_C @4
.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
.word SEG_A|SEG_B|SEG_C @7
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
.word 0 @blank display

P:	.asciz "Hello World\nyo\0hi"
game: .space 64
extra: .space 64
NewL: .ascii "\n"
Blank: .ascii " "
	.end

	cmp r1,#1;
	moveq r3,[r2 #4];
	moveq r0,r2;
	moveq r3,[r2 #8];
	moveq r0,r2;
	swi 8segdisp;