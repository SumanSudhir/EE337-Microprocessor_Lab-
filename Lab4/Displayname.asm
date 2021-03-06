; THIS SUBROUTINE WRITES CHARACTERS ON THE LCD
LCD_DATA EQU P2    ;LCD DATA PORT
LCD_RS   EQU P0.0  ;LCD REGISTER SELECT
LCD_RW   EQU P0.1  ;LCD READ/WRITE
LCD_EN   EQU P0.2  ;LCD ENABLE

ORG 0000H
LJMP MAIN

ORG 200H
START:
	USING 0
		PUSH AR0
		PUSH AR1
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

	  MOV R0,#0BFH
	  LCALL SHIFT
	  MOV A,R3
	  ADD A,#80H
	 ; MOV A,R3		 ;PUT CURSOR ON FIRST ROW,5 COLUMN
	  ACALL LCD_COMMAND	 ;SEND COMMAND TO LCD
	  ACALL DELAY
	  MOV   R1,#0BFH   ;LOAD DPTR WITH SRING1 ADDR
	  ACALL LCD_SENDSTRING1	   ;CALL TEXT STRINGS SENDING ROUTINE
	  ACALL DELAY   
	 
	  MOV R0,#81H
	  LCALL SHIFT
	  MOV A,R3
	  ADD A,#0C0H
	  ;MOV A,R3		  ;PUT CURSOR ON SECOND ROW,3 COLUMN
	  ACALL LCD_COMMAND
	  ACALL DELAY
	  MOV   R0,#81H
	  ACALL LCD_SENDSTRING2
	  POP AR1
	POP AR0
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


LCD_SENDSTRING1:              ;INCASE MEM. LOCATION IS DEFINED TO R0
         MOV A,@R1
		 JZ EXIT1
		 ACALL LCD_SENDDATA
		 INC R1
		 SJMP LCD_SENDSTRING1

EXIT1:
 	     RET

LCD_SENDSTRING2:              ;INCASE MEM. LOCATION IS DEFINED TO R0
         MOV A,@R0
		 JZ EXIT2
		 ACALL LCD_SENDDATA
		 INC R0
		 SJMP LCD_SENDSTRING2
EXIT2:
 	     RET


;------------------------------------------------------------------------------------
;LCD_SENDSTRING:
;	 PUSH 0E0H
;	 REPEAT:
 ;        CLR   A                 ;CLEAR ACCUMULATOR FOR ANY PREVIOUS DATA
  ;       MOVC  A,@A+DPTR         ;LOAD THE FIRST CHARACTER IN ACCUMULATOR
   ;      JZ    EXIT              ;GO TO EXIT IF ZERO
    ;     ACALL LCD_SENDDATA      ;SEND FIRST CHAR
     ;    INC   DPTR              ;INCREMENT DATA POINTER
      ;   SJMP  REPEAT    ;JUMP BACK TO SEND THE NEXT CHARACTER
;EXIT:    POP 0E0H
 ;        RET                     ;END OF ROUTINE

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
RET

SHIFT:              ;INCASE MEM. LOCATION IS DEFINED TO R0
		PUSH AR0
		MOV R3,#0
	STR_LEN:
         MOV A,@R0
		 JZ EXT1
		 INC R3
		 INC R0
		 SJMP STR_LEN
EXT1:
POP AR0
MOV A,#16
SUBB A,R3
MOV B,#2
DIV AB
MOV R3,A
RET
 
/*STRING_LENGTH2:              ;INCASE MEM. LOCATION IS DEFINED TO R0
		PUSH AR1
		MOV R1,#0
		MOV R4,#0
STR_LEN1:
         MOV A,@R1
		 JZ EXITT1
		 INC R4
		 ACALL LCD_SENDDATA
		 INC R1
		 SJMP STR_LEN1
EXITT1:
	POP AR1
 RET
		
*/
MAIN:                              ;USED TO STORE THE STRING TO MEMORY LOCATION

        MOV R0,#81H            ;STORED DATA FORM MEMORY LOCATION 81H (IN UPPER RAM)
        MOV @R0,#"S"
		INC R0
        MOV @R0,#"U"
		INC R0
        MOV @R0,#"D"         ;**NOTE THE INDIRECT ADDRESSING METHOD USED**
		INC R0
        MOV @R0,#"H"
		INC R0
		MOV @R0,#"I"
		INC R0
		MOV @R0,#"R"
		INC R0
		MOV @R0,#" "
		INC R0
		MOV @R0,#"S"
		INC R0
		MOV @R0,#"U"
		INC R0
		MOV @R0,#"M"
		INC R0
		MOV @R0,#"A"
		INC R0
		MOV @R0,#"N"
		INC R0
		MOV @R0,#00H        ;EXPLICITY DEFINED ZERO TO END LCD_SENDSTRING2 LOOP
		
		;--------------------------------------------
		
		
		;---------------------------------------
		MOV R1,#0BFH   ;191
		MOV @R1,#"E"
		INC R1
		MOV @R1,#"E"
		INC R1
		MOV @R1,#"3"
		INC R1
		MOV @R1,#"3"
		INC R1
		MOV @R1,#"7"
		INC R1
		MOV @R1,#" "
		INC R1
		MOV @R1,#"-"
		INC R1
		MOV @R1,#" "
		INC R1
		MOV @R1,#"L"
		INC R1
		MOV @R1,#"A"
		INC R1
		MOV @R1,#"B"
		INC R1
		MOV @R1,#" "
		INC R1
		MOV @R1,#"4"
		INC R1
		MOV @R1,#00H
			
/*LCALL STRING_LENGTH1
		MOV A,#16
		SUBB A,R3
		MOV B,#2
		DIV AB
		ADD A,#81H
		MOV R0,A
	*/	
		
/*LCALL STRING_LENGTH2
		MOV A,#16
		SUBB A,R4
		MOV B,#2
		DIV AB
		ADD A,#0C1H
		MOV R1,A*/
		
		LCALL START
END

