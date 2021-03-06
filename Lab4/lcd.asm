; THIS SUBROUTINE WRITES CHARACTERS ON THE LCD
LCD_DATA EQU P2    ;LCD DATA PORT
LCD_RS   EQU P0.0  ;LCD REGISTER SELECT
LCD_RW   EQU P0.1  ;LCD READ/WRITE
LCD_EN   EQU P0.2  ;LCD ENABLE

ORG 0000H
LJMP START

ORG 200H
START:
      MOV P2,#00H
      MOV P1,#00H
	  ;INITIAL DELAY FOR LCD POWER UP

	;HERE1:SETB P1.0
      	  ACALL DELAY
	;CLR P1.0
	  ACALL DELAY
	;SJMP HERE1


	  ACALL LCD_INIT      ;INITIALISE LCD

	  ACALL DELAY
	  ACALL DELAY
	  ACALL DELAY
	  MOV A,#85H		 ;PUT CURSOR ON FIRST ROW,5 COLUMN
	  ACALL LCD_COMMAND	 ;SEND COMMAND TO LCD
	  ACALL DELAY
	  MOV   DPTR,#MY_STRING1   ;LOAD DPTR WITH SRING1 ADDR
	  ACALL LCD_SENDSTRING	   ;CALL TEXT STRINGS SENDING ROUTINE
	  ACALL DELAY

	  MOV A,#0C3H		  ;PUT CURSOR ON SECOND ROW,3 COLUMN
	  ACALL LCD_COMMAND
	  ACALL DELAY
	  MOV   DPTR,#MY_STRING2
	  ACALL LCD_SENDSTRING

HERE: SJMP HERE				//STAY HERE

;------------------------LCD INITIALISATION ROUTINE----------------------------------------------------
LCD_INIT:
         MOV   LCD_DATA,#38H  ;FUNCTION SET: 2 LINE, 8-BIT, 5X7 DOTS
         CLR   LCD_RS         ;SELECTED COMMAND REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN
	     ACALL DELAY

         MOV   LCD_DATA,#0CH  ;DISPLAY ON, CURSON OFF
         CLR   LCD_RS         ;SELECTED INSTRUCTION REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN

		 ACALL DELAY
         MOV   LCD_DATA,#01H  ;CLEAR LCD
         CLR   LCD_RS         ;SELECTED COMMAND REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN

		 ACALL DELAY

         MOV   LCD_DATA,#06H  ;ENTRY MODE, AUTO INCREMENT WITH NO SHIFT
         CLR   LCD_RS         ;SELECTED COMMAND REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN

		 ACALL DELAY

         RET                  ;RETURN FROM ROUTINE

;-----------------------COMMAND SENDING ROUTINE-------------------------------------
 LCD_COMMAND:
         MOV   LCD_DATA,A     ;MOVE THE COMMAND TO LCD PORT
         CLR   LCD_RS         ;SELECTED COMMAND REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN
		 ACALL DELAY

         RET
;-----------------------DATA SENDING ROUTINE-------------------------------------
 LCD_SENDDATA:
         MOV   LCD_DATA,A     ;MOVE THE COMMAND TO LCD PORT
         SETB  LCD_RS         ;SELECTED DATA REGISTER
         CLR   LCD_RW         ;WE ARE WRITING
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY
         CLR   LCD_EN
         ACALL DELAY
		 ACALL DELAY
         RET                  ;RETURN FROM BUSY ROUTINE

;-----------------------TEXT STRINGS SENDING ROUTINE-------------------------------------
LCD_SENDSTRING:
	 PUSH 0E0H
	 READ:
         CLR   A                 ;CLEAR ACCUMULATOR FOR ANY PREVIOUS DATA
         MOVC  A,@A+DPTR         ;LOAD THE FIRST CHARACTER IN ACCUMULATOR
         JZ    EXIT              ;GO TO EXIT IF ZERO
         ACALL LCD_SENDDATA      ;SEND FIRST CHAR
         INC   DPTR              ;INCREMENT DATA POINTER
         SJMP  READ    ;JUMP BACK TO SEND THE NEXT CHARACTER
EXIT:    POP 0E0H
         RET                     ;END OF ROUTINE

;----------------------DELAY ROUTINE-----------------------------------------------------
DELAY:	 PUSH 0
	 PUSH 1
         MOV R0,#1
LOOP2:	 MOV R1,#255
	 LOOP1:	 DJNZ R1, LOOP1
	 DJNZ R0, LOOP2
	 POP 1
	 POP 0
	 RET

;------------- ROM TEXT STRINGS---------------------------------------------------------------
ORG 300H
MY_STRING1:
         DB   "PT-51", 00H
MY_STRING2:
		 DB   "IIT BOMBAY", 00H
END
