	.equ SWI_Exit, 0x11
	.equ PrInt, 0x205
	.equ DispStr, 0x204
	.equ ClearDisp, 0x206
	.equ ClearLine, 0x208
	.equ SWI_CheckBlue, 0x203

	.equ BLUE_KEY_00, 0x01 @button(0)
	.equ BLUE_KEY_01, 0x02 @button(1)
	.equ BLUE_KEY_02, 0x04 @button(2)
	.equ BLUE_KEY_03, 0x08 @button(3)
	.equ BLUE_KEY_04, 0x10 @button(4)
	.equ BLUE_KEY_05, 0x20 @button(5)
	.equ BLUE_KEY_06, 0x40 @button(6)
	.equ BLUE_KEY_07, 0x80 @button(7)
	.equ BLUE_KEY_08, 1<<8 @button(8) - different way to set
	.equ BLUE_KEY_09, 1<<9 @button(9)
	.equ BLUE_KEY_10, 1<<10 @button(10)
	.equ BLUE_KEY_11, 1<<11 @button(11)
	.equ BLUE_KEY_12, 1<<12 @button(12)
	.equ BLUE_KEY_13, 1<<13 @button(13)
	.equ BLUE_KEY_14, 1<<14 @button(14)
	.equ BLUE_KEY_15, 1<<15 @button(15)

	.text

	b mn;

mn:
	ldr r10,=game;
	@initialisation
	mov r0,#1;
	strb r0,[r10,#27];
	strb r0,[r10,#36];
	mov r0,#2;
	strb r0,[r10,#28];
	strb r0,[r10,#35];

	mov r8,#1;	@r8 as p,r9 as q,r12 as miss
	mov r9,#2;
	mov r12,#0;

lp6:
	stmfd sp!,{r12};
	bl possible;
	ldmfd sp!,{r12};
	cmp r0,#1;
	bleq l2;
	@code for cout<<"player "<<p<<" has no choice\n";
	stmfd sp!,{r0-r4}
	mov r0,#0;
	mov r1,#11;
	ldr r2,=player;
	swi DispStr;
	
	mov r0,#7;
	mov r2,r8;
	swi PrInt;

	mov r0,#8;
	ldr r2,=nochoice;
	swi DispStr;

	ldmfd sp!,{r0-r4}

	add r12,r12,#1;
	b l3;

l2:		@if part
	stmfd sp!,{r0-r10};
	bl print;
	ldmfd sp!,{r0-r10};
	mov r12,#0;
	@code for cout<<"enter x and y for player "<<p<<endl;
	stmfd sp!,{r0-r3};
	mov r0,#0;
	mov r1,#12;
	ldr r2,=enterxy;
	swi DispStr;

	mov r0,#25;
	mov r2,r8;
	swi PrInt;
	ldmfd sp!,{r0-r3};

	stmfd sp!,{r0};
	@code for cin>>x>>y; x in r4, y in r5;
	bl blueloop;
	mov r4,r0;
	bl blueloop;
	mov r5,r0;
	swi ClearDisp;1
	ldmfd sp!,{r0};

	stmfd sp!,{r12};
	bl isValid;
	ldmfd sp!,{r12};
	cmp r0,#1;
	beq l3;
	@code for if r0 is #0 then cout<<"invalid move";
	mov r0,#0;
	mov r1,#10;
	ldr r2,=invalid;
	swi DispStr;

l3:
	mov r9,r8;
	rsb r8,r8,#3;
	cmp r12,#2;
	blt lp6;

	ldr r10,=game;
	bl print;
	bl count;
l5:	cmp r0,#1;
	@code for (if r0 has #0 cout<<"draw\n"; else cout<<"player "<<p<<" wins\n");
	bge l4;
	mov r0,#13
	swi ClearLine;
	mov r0,#0;
	mov r1,#13;
	ldr r2,=draw;
	swi DispStr;
	swi SWI_Exit; 

l4:
	mov r3,r0;
	mov r0,#13
	swi ClearLine;
	mov r0,#0;
	mov r1,#13;
	ldr r2,=player;
	swi DispStr;
	mov r0,#7;
	mov r2,r3;
	swi PrInt;
	mov r0,#9;
	ldr r2,=wins;
	swi DispStr;

	swi SWI_Exit;


print:		@game in r10;
	@swi ClearDisp;
	mov r0,#0;
	mov r1,#0;
lp1:
	cmp r1,#8;
	movge pc,lr;

	add r3,r0,r1,LSL#3;
	ldrb r2,[r10,r3];
	swi PrInt;
	
	cmp r0,#7;
	addlt r0,r0,#1;
	blt lp1;
	mov r0,#0;
	add r1,r1,#1;
	b lp1;

count:	@game in r10, output in r0;
	stmfd sp!,{r4,lr};
	mov r1,#0;
	mov r2,#0;
	mov r3,#0;
lp2:
	ldrb r4,[r10,r3];
	cmp r4,#1;
	addeq r1,r1,#1;
	addgt r2,r2,#1;
	add r3,r3,#1;
	cmp r3,#64;
	blt lp2;
	cmp r1,r2;
	moveq r0,#0;
	movlt r0,#2;
	movgt r0,#1;
	ldmfd sp!,{r4,pc};

copy:	@game in r10, extra in r9;
	stmfd sp!,{r1-r10,lr};
	mov r1,#0;
lp3:
	ldrb r2,[r10,r1];
	strb r2,[r9,r1];
	add r1,r1,#1;
	cmp r1,#64;
	blt lp3;
	ldmfd sp!,{r1-r10,pc};

dircheck:	@game in r10,x in r4,y in r5,dx in r6,dy in r7,p in r8,q in r9,		result in r0
	stmfd sp!,{r1-r10,lr};
	add r1,r4,r6;
	add r2,r5,r7;

	cmp r1,#0;
	blt ret_false;
	
	cmp r1,#7;
	bgt ret_false;
	
	cmp r2,#0;
	blt ret_false;
	
	cmp r2,#7;
	bgt ret_false;
	
	add r3,r1,r2,LSL#3;
	ldrb r12,[r10,r3];
	cmp r12,#0;
	beq ret_false;

	cmp r12,r9;
	mov r4,r1;
	mov r5,r2;
	bleq dircheck;

	sub r4,r4,r6;
	sub r5,r5,r7;
	add r3,r1,r2,LSL#3;
	ldrb r12,[r10,r3];
	cmp r12,r8;
	bne ret_false;
	add r3,r4,r5,LSL#3;
	strb r8,[r10,r3];
	mov r0,#1;
	ldmfd sp!,{r1-r10,pc};

ret_false:
	mov r0,#0;
	ldmfd sp!,{r1-r10,pc};

isValid:	@game in r10,x in r4,y in r5,p in r8,q in r9,		result in r0
	stmfd sp!,{r1-r10,lr};
	cmp r4,#0;
	blt ret_false;
	cmp r4,#7;
	bgt ret_false;
	cmp r5,#0;
	blt ret_false;
	cmp r5,#7;
	bgt ret_false;

	add r3,r4,r5,LSL#3;
	ldrb r12,[r10,r3];
	cmp r12,#0;
	bne ret_false;

	mov r7,#-1;		@r6 as dx,r7 as dy
	mov r6,#-1;
lp4:
	add r1,r4,r6;
	add r2,r5,r7;
	cmp r1,#0;
	blt l1;
	cmp r1,#7;
	bgt l1;
	cmp r2,#0;
	blt l1;
	cmp r2,#7;
	bgt l1;
	add r3,r1,r2,LSL#3;
	ldrb r12,[r10,r3];
	cmp r12,r9;
	bne l1;

	mov r4,r1;
	mov r5,r2;
	bl dircheck;
	sub r4,r4,r6;
	sub r5,r5,r7;
	cmp r0,#1;
	bne l1;
	add r3,r4,r5,LSL#3;
	strb r8,[r10,r3];

l1:	cmp r7,#0;
	addne r6,r6,#1;	
	addeq r6,r6,#2;
	cmp r6,#2;
	blt lp4;
	movge r6,#-1;
	addge r7,r7,#1;
	cmp r7,#2;
	blt lp4;

	add r3,r4,r5,LSL#3;
	ldrb r12,[r10,r3];
	cmp r12,r8;
	moveq r0,#1;
	movne r0,#0;
	ldmfd sp!,{r1-r10,pc};

possible:	@game in r10,p in r8	result in r0
	stmfd sp!,{r1-r10,lr};
	mov r2,#0;	@r2 as i, r3 as j
	mov r3,#0;
lp5:
	ldr r9,=extra;
	ldr r10,=game;
	bl copy;
	mov r4,r2;
	mov r5,r3;
	ldr r10,=extra;
	rsb r9,r8,#3;
	bl isValid;
	cmp r0,#1;
	beq ret_true;

	add r3,r3,#1;
	cmp r3,#8;
	blt lp5;
	mov r3,#0;
	add r2,r2,#1;
	cmp r2,#8;
	blt lp5;
	b ret_false;

ret_true:
	mov r0,#1;
	ldmfd sp!,{r1-r10,pc};

blueloop:	@
	mov r0,#0;
BB1:
	swi SWI_CheckBlue @get button press into R0
	cmp r0,#0
	beq BB1 @ if zero, no button pressed
	cmp r0,#BLUE_KEY_15
	moveq r0,#15;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_14
	moveq r0,#14;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_13
	moveq r0,#13;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_12
	moveq r0,#12;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_11
	moveq r0,#11;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_10
	moveq r0,#10;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_09
	moveq r0,#9;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_08
	moveq r0,#8;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_07
	moveq r0,#7;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_06
	moveq r0,#6;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_05
	moveq r0,#5;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_04
	moveq r0,#4;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_03
	moveq r0,#3;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_02
	moveq r0,#2;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_01
	moveq r0,#1;
	moveq pc,lr;
	cmp r0,#BLUE_KEY_00
	moveq r0,#0;
	moveq pc,lr;
	

@ckdslm

	.data
game: .space 64
extra: .space 64
@game: .byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
NewL: .ascii "\n"
player: .asciz "player ";
nochoice: .asciz " has no choice";
enterxy: .asciz "enter x and y for player ";
invalid: .asciz "invalid move";
draw: .asciz "draw";
wins: .asciz " wins";
	.end