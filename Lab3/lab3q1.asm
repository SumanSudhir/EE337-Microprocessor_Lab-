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
	MOV R2,#200 											;;;DELAY OF 50MS*A
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
	MAIN:
			SETB P1.0
			SETB P1.1
			SETB P1.2
			SETB P1.3
			
			TOGGLE:
					MOV A, P1                        ;20*50MS = 1SEC/4
					ANL A,#0FH
					MOV B, #5
					MUL AB
					
					LCALL DELAY
					CPL P1.5      ;D/4
					
					LCALL DELAY
					CPL P1.5			
					CPL P1.6 
					
					LCALL DELAY
					CPL P1.5       ;3D/4
					
					LCALL DELAY
					CPL P1.5
					CPL P1.6        ;D
					CPL P1.7         ;D
					
					SJMP TOGGLE
END
			
	
	