	.equ SWI_Exit, 0x11
	.text
	@ dividend in r1, divisor in r2, quotient in r0,remainder in r1

	mov r1,#100;
	mov r2,#3;
	mov r0,#0;
lp:
	cmp r1,r2;
	blt end;
	sub r1,r1,r2;
	add r0,r0,#1;
	b lp;

end:
	swi SWI_Exit;

	.data