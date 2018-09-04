ORG 0000H
ljmp main
org 200h	

DELAY1:
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
	;MOV A,P1
	
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
	MOV P1,A
	
	MOV A,#100
	LCALL DELAY
	
	
	LCALL LOADING_A       ;VERIFY
	CJNE A,#0FH,READNIBBLE	
RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
	MOV R2, A
RET
STORE:
	
	MOV R1,50H
	MOV R2,51H
read_bytes:
	MOV R0, #4EH
	LCALL READNIBBLE
	MOV R0, #4FH
	LCALL READNIBBLE
	LCALL PACKNIBBLE
	INC R2
	DJNZ R1,read_bytes
	
RET

