	ldr r10,=game;
	ldr r9,=extra;

	bl blueloop;
	b l5;

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

	stmfd sp!,{r0-r3};
	mov r0,#0;
	mov r1,#12;
	ldr r2,=enterxy;
	swi DispStr;

	mov r0,#25;
	mov r2,r8;
	swi PrInt;
	ldmfd sp!,{r0-r3};

	swi SWI_Exit;

@initialisation
	mov r0,#1;
	strb r0,[r10,#27];
	strb r0,[r10,#36];
	mov r0,#2;
	strb r0,[r10,#28];
	strb r0,[r10,#35];
@	strb r0,[r10,#1];
@	mov r0,#2;
@	strb r0,[r10];

@	mov r0,#1;
@	strb r0,[r10];
@	strb r0,[r10,#1];
@	strb r0,[r10,#8];
@	mov r0,#2;
@	strb r0,[r10,#9];

	bl print;

@	mov r0,#25;
@	mov r4,#3;
@	mov r5,#3;
@	mov r6,#1;
@	mov r7,#1;
@	mov r8,#1;
@	mov r9,#2;
@	bl isValid;


@	mov r8,#1;
@	mov r9,#2;
@	bl possible;
@	bl print;

@	bl print;
@	bl count;
@	swi 0x6b;

@	bl print;
@	mov r10,r9;
@	bl print;
@	ldr r10,=game;
@	bl copy;
@	mov r10,r9;
@	bl print;

	swi SWI_Exit;