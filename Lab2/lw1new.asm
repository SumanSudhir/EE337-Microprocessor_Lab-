LED EQU P1
ORG 00H
LJMP MAIN
ORG 100H
DELAY:	
		MOV R3,#20
	LOOP:	
	
		MOV R2,#200
		BACK1:
		MOV R4,#0FFH
		BACK:
		DJNZ R4, BACK
		DJNZ R2, BACK1
		DJNZ R3,LOOP
RET

DISPLAY:
		MOV R0,50H
		MOV R1,#51H
	LOOP2:
		MOV A,@R1   
		ANL A,#0FH
		SWAP A
		MOV LED,A
		LCALL DELAY
		INC R1
		DJNZ R0,LOOP2
RET

MAIN:
	MOV R0,50H
	MOV R1,#51H
	MOV 50H,#6
	MOV 51H,#10101010B
	MOV 52H,#01010101B
	MOV 53H,#10101010B
	MOV 54H,#01010101B
	MOV 55H,#10101010B
	MOV 56H,#01010101B
	LCALL DISPLAY
	
END		
		
		
    
   

