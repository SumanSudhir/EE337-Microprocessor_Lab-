ORG 0H
LJMP MAIN
ORG 100H
MAIN:
		MOV 6FH,60H
		MOV 70H,61H
		MOV 71H,62H
		MOV 72H,63H
		MOV 73H,64H
			
MOV R4,#5
AGAIN: MOV R3,#5
	MOV R0,#6FH
	CLR C
UP: MOV A,@R0
	MOV R1,A
	INC R0
	MOV A,@R0
	SUBB A,R1
	JNC SKIP    ;if carry is zero
	MOV A,@R0
	DEC R0
	MOV @R0,A
	MOV A,R1
	INC R0
	MOV @R0,A
SKIP:DJNZ R3,UP
	DJNZ R4,AGAIN
	
	HERE:SJMP HERE
END