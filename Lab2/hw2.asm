N EQU 3
ORG 0H
LJMP MAIN
ORG 100H
	DELAY:
		USING 0
		PUSH AR1
		PUSH AR2
		PUSH AR3
		
		MOV R3,#20
		LOOP:	
			MOV R2,#200
			BACK1:
			MOV R1,#0FFH
			BACK:
			DJNZ R1, BACK
			DJNZ R2, BACK1
			DJNZ R3,LOOP
		POP AR2
		POP AR1
		POP AR0
		RET
		
	MAIN:
	
		MOV 4FH,#10    ;location for D
		ACALL DELAY
		HERE: SJMP HERE
	END	
		
	
		