ORG 00H
LJMP MAIN
ORG 100H
BIN2ASCII:
	MOV R2,50H
	MOV R1,51H
	MOV R0,52H
	   
	LOOP:
		MOV A,@R1
		ANL A,#00001111B
		SUBB A,#10
		MOV A,@R1
		JNC SKIP
		LCALL LOOP2
		SJMP SKIP2
	SKIP:LCALL LOOP1
		
	SKIP2:
		MOV A,@R1
		ANL A,#11110000B
		SWAP A
		MOV R4,A
		SUBB A,#10
		MOV A,R4
		JNC SKIP3
		LCALL LOOP2
		SJMP SKIP4
	SKIP3:LCALL LOOP1
	SKIP4:
	    INC R1
		DJNZ R2,LOOP
RET
	LOOP1:
		ADD A,#37H
		MOV @R0,A
		INC R0
		CLR C
	RET
	
	LOOP2:
		ADD A,#30H
		MOV @R0,A
		INC R0
RET	

MAIN:
MOV 50H,#2
MOV 51H,#60H
MOV 52H,#65H
MOV 60H,#2
MOV 61H,#3
LCALL BIN2ASCII

END
	
	
	