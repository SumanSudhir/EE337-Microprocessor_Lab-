ORG 00H
LJMP MAIN
ORG 100H
MEMCPY:
	MOV A,R0
	CLR C
	SUBB A,R1
	JC NEXT
	JNC NEXT2
	NEXT:LCALL LOOP2
	NEXT2:LCALL LOOP
	
RET


LOOP:
	LOOP1:
		MOV A,@R0
		MOV @R1,A
		INC R0
		INC R1
		DJNZ R2,LOOP1
RET
		

LOOP2:	
		MOV A,R1
		ADD A,R2
		MOV R1,A
		
		MOV A,R0
		ADD A,R2
		MOV R0,A	
LOOP3:
		MOV A,@R0
		MOV @R1,A
		DEC R0
		DEC R1
		DJNZ R2,LOOP3
RET
		
MAIN:
	MOV R2,50H
	MOV R0,51H
	MOV R1,52H
	LCALL MEMCPY
	HERE:SJMP HERE
END