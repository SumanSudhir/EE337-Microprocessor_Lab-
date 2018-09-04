ORG 0000H
LED EQU P1
ljmp MAIN

org 100h

;------------------------------------------------------------
shuffleBits:

;Location of A[0]	: @51H
;Location of B[0]	: @52H
;Location of K		: 50H
USING 0
	PUSH 0
	PUSH 1
	PUSH ACC
	
	MOV R0, 51H		;Source Array Pointer
	MOV R1, 52H		;Desination Array Pointer
	MOV R2, 50H		;Array Length
	
	DEC R2
	SHUFFLE_LOOP:
		MOV A, @R0	;ACC = A[k]
		INC R0		;k = k+1
		XRL A, @R0	;ACC = A[k] XOR A[k+1]
		MOV @R1, A	;Store the result
		INC R1
		DJNZ R2, SHUFFLE_LOOP
	
	MOV A, @R0	;ACC = A[N]	
	MOV R0, 51H	;k = 0
	XRL A, @R0	;ACC = A[N] XOR A[0]
	MOV @R1, A	;Store result
	
	POP ACC
	POP 1
	POP 0
RET

main:

mov 50h,#3
mov 51h,#60h
mov 52h,#70H

lcall shufflebits

here:sjmp here
end
