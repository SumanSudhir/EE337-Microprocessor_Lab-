N EQU 3
ORG 0H
LJMP MAIN
ORG 100H
	zeroOut:
		USING 0
		PUSH AR0
		PUSH AR1
		
		MOV R0,51H
		MOV R1,50H
		
		LOOP: 
		    MOV @R0,#0H
			INC R0
			DJNZ R1,LOOP
			
		POP AR1
		POP AR0
		RET
	
	
	MAIN:
		MOV 50H,#N
		MOV 51H,#60H
		ACALL zeroOut
		HERE: SJMP HERE
	END
		
		
		
		