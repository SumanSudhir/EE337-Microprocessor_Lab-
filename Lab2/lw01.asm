LED EQU P1

ORG 00H
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
			
			POP AR3
			POP AR2
			POP AR1
RET

DISPLAY:
		MOV R0,50H
		MOV R1,51H
	LOOP1:
		USING 0
		   PUSH AR0
			PUSH AR1
		
		   MOV A,@R1   
		   ANL A,#0FH
		   MOV LED,A
		   LCALL DELAY
		   MOV A,@R1
		   SWAP A
		   ANL A,#0FH
		   MOV LED,A
		   ;MOV LED,A
		   ;LCALL DELAY
		   
		   ;MOV A,@R1
		   ;ANL A,#00000010B
		   ;MOV LED,A
		   ;LCALL DELAY
		   
		   
		   ;MOV A,@R1
		   ;ANL A,#00000100B
		   ;MOV LED,A
		   ;LCALL DELAY
		   
		   
		   ;MOV A,@R1
		   ;ANL A,#00001000B
		   ;MOV LED,A
		   ;LCALL DELAY
		   
		   INC R1
		   DJNZ R0,LOOP1
		   
		   POP AR1
		   POP AR0	   
RET
	
	
MAIN:	
		MOV 50H,#5
		MOV 51H,#60H
		LCALL DISPLAY
		BACK3:SJMP BACK3		;INFINITE LOOP
END
	
	