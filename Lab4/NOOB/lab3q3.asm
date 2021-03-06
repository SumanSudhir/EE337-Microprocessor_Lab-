LED EQU P1
ORG 00H
LJMP MAIN
ORG 100H
	
DELAY:
	USING 0
	PUSH AR1
	PUSH AR2
	PUSH AR3
	PUSH PSW

	MOV R3,A
LOOP:
	MOV R2,#200
	BACK1:
	MOV R1,#0FFH
	BACK :
	DJNZ R1, BACK
	DJNZ R2, BACK1
	DJNZ R3,LOOP
	
	POP PSW
	POP AR3
	POP AR2
	POP AR1
RET

LOADING_A:
	MOV P1,#0FFH    ;LED HIGH
	
	MOV A,#100       ;DELAY OF 5S 
	LCALL DELAY
	
	CLR P1.7
	CLR P1.6 
	CLR P1.5
	CLR P1.4
	
	MOV A,#20
	LCALL DELAY         ;DELAY OF 1S
	
	MOV A,P1
RET
READNIBBLE:
	LCALL LOADING_A
	
	MOV @R0,A
	SWAP A
	MOV P1,A   ;will show input on led
	
	MOV A,#100
	LCALL DELAY   ;wait for 5 sec
	
	
	LCALL LOADING_A       ;VERIFY   ;give input 0fh to verify
	CJNE A,#0FH,READNIBBLE
	SWAP A
	MOV P1,A   ;KEEP SHOWING VALUE OF READ NIBBLE
RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
	MOV 50H, A
RET

MAIN:
	MOV R0, #4EH
	LCALL READNIBBLE
	MOV R0, #4FH
	LCALL READNIBBLE
	LCALL PACKNIBBLE
	
	HERE: SJMP HERE	
END
	

