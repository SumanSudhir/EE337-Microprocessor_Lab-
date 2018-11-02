#include "led.asm"


ORG 00H
LJMP MAIN

ORG 000BH 							;ISR FOR TIMER 0
LJMP ISR_T0

ORG 30H

ISR_T0:
	DJNZ R2,CONTINUE
	CPL P1.7                    ;MONITOR WHICH FREQUENCY TO TAKE
	MOV R2,#40
CONTINUE:
	CLR TR0
	LCALL TWOS_T0               ;DELAY OF 1S
	SETB TR0
RETI

TWOS_T0:
	USING 0
		PUSH AR0
		MOV R0,#51H         ;INDIRECT READ FROM MEMORY LOCATION 81H
		MOV A,@R0
		CPL A    			;COMPLEMENT OF A
		CLR C
		ADD A,#01    		;ADD 1 TO MAKE IT 2'S COMPLEMENT
		MOV TL0,A          
		INC R0              ;CARRY FLAG IS NOT AFFECTED BY INC
		MOV A,@R0
		CPL A               ;COMPLEMENT OF ANOTHER BYTE
		ADDC A,#00H         ;WILL ADD CARRY IF GENERATED FROM LOWER BYTE
		MOV TH0,A      
		POP AR0
RET



MAIN:

	MOV TMOD,#01H 				;                   TIMER 0, MODE 1
	;MOV IE,#82H 

	SETB EA
	SETB ET0
	

	MOV R0,#51H
	MOV @R0,#50H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 50,000  FOR GETTING DELAY = 25MSEC
	MOV @R0,#0C3H
	
	LCALL TWOS_T0
	MOV R2,#40
	SETB P0.7
	SETB TR0
	HERE:SJMP HERE
END