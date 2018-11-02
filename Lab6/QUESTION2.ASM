LCD_DATA EQU P2    ;LCD DATA PORT
LCD_RS   EQU P0.0  ;LCD REGISTER SELECT
LCD_RW   EQU P0.1  ;LCD READ/WRITE
LCD_EN   EQU P0.2  ;LCD ENABLE
LCD_CLR 	EQU 001H
LED EQU P1
	
	
ORG 00H
LJMP KEY_DETECT	
ORG 03H
LCALL INTERRUPT


;------------------------DELAY--------------------
DELAY_SMALL:
		 PUSH 0
		 PUSH 1
         MOV R0,#1
LOOP4:
		MOV R1,#255
	 LOOP3:
		DJNZ R1, LOOP3
		DJNZ R0, LOOP4
	 POP 1
	 POP 0
RET

;----------------------------------------DELAY_BIG-------------------

DELAY_BIG:
	USING 0
	PUSH AR1
	PUSH AR2
	PUSH AR3
	PUSH PSW

	MOV R3,A        ;WILL GIVE THE DELAY OF A*50 MILISECOND
LOOP:
	MOV R2,#200
	BACK1:
	MOV R1,#0FFH
	BACK :
	DJNZ R1, BACK
	DJNZ R2, BACK1
	DJNZ R3,LOOP

	POP PSW
	POP AR3
	POP AR2
	POP AR1
RET
;-----------------------------LCD_INIT------------------------
LCD_INIT:
;INITIALIZES THE LCD

		MOV   LCD_DATA,#38H  ;FUNCTION SET: 2 LINE, 8-BIT, 5X7 DOTS
        CLR   LCD_RS         ;SELECTED COMMAND REGISTER
        CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
        SETB  LCD_EN         ;ENABLE H->L
		ACALL DELAY_SMALL
        CLR   LCD_EN
		ACALL DELAY_SMALL

        MOV   LCD_DATA,#0CH  ;DISPLAY ON, CURSON OFF
        CLR   LCD_RS         ;SELECTED INSTRUCTION REGISTER
        CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
        SETB  LCD_EN         ;ENABLE H->L
		ACALL DELAY_SMALL
        CLR   LCD_EN

		ACALL DELAY_SMALL
        MOV   LCD_DATA,#01H  ;CLEAR LCD
        CLR   LCD_RS         ;SELECTED COMMAND REGISTER
        CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
        SETB  LCD_EN         ;ENABLE H->L
		ACALL DELAY_SMALL
        CLR   LCD_EN
        ACALL DELAY_SMALL

        MOV   LCD_DATA,#06H  ;ENTRY MODE, AUTO INCREMENT WITH NO SHIFT
        CLR   LCD_RS         ;SELECTED COMMAND REGISTER
        CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
        SETB  LCD_EN         ;ENABLE H->L
		ACALL DELAY_SMALL
        CLR   LCD_EN
		ACALL DELAY_SMALL

   RET                  ;RETURN FROM ROUTINE

;------------------------LCD_COMMAND----------------------
LCD_COMMAND:
         MOV   LCD_DATA,A     ;MOVE THE COMMAND TO LCD PORT
         CLR   LCD_RS         ;SELECTED COMMAND REGISTER
         CLR   LCD_RW         ;WE ARE WRITING IN INSTRUCTION REGISTER
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY_SMALL
         CLR   LCD_EN
		 ACALL DELAY_SMALL
RET

;------------------------LCD_SENDDATA------------------
LCD_SENDDATA:
         MOV   LCD_DATA,A     ;MOVE THE COMMAND TO LCD PORT
         SETB  LCD_RS         ;SELECTED DATA REGISTER
         CLR   LCD_RW         ;WE ARE WRITING
         SETB  LCD_EN         ;ENABLE H->L
		 ACALL DELAY_SMALL
         CLR   LCD_EN
         ACALL DELAY_SMALL
		 ACALL DELAY_SMALL
RET	
	
;------- keypad configuration------------
mov p1,#0f0h		;LSB as row, MSB as column									
setb IE.7

mov a,0b1h		;IEN1, interrupt enable register
ORL a,#01		;changing only the required bit, without changing the other bits
mov 0b1h,a			

mov 9cH,#0Fh		;KBLS (level selector), LSB as row, MSB as column
mov 9dH,#0f0h		;KBE (Keyboard enable) LSB as interrupt, MSB as I/O

;----------------------------------------
ORG 200H
INTERRUPT:
	MOV A,P1
	LCALL DELAY_SMALL
	CJNE A,#0F0H,KEY_DETECT
RETI

KEY_DETECT:
	MOV A,P1
	ANL A,#0FH
	MOV R0,A   ;STORES THE COLUMN
	
	MOV A,P1
	ANL A,#0F0H
	MOV R1,A   ;STORES THE ROWS
	
	MOV R1,0FEH       ;ROW0 
	MOV A,R0
	ANL A,#0FH
	CJNE A,#0FH,ROW0
	
	MOV R1,#0FDH           ;ROW1
	MOV A,R0
	ANL A,0FH
	CJNE A,0FH,ROW1
	
	MOV R1,#0FCH    ;ROW2
	MOV A,R0
	ANL A,0FH
	CJNE A,0FH,ROW2
	
	MOV R1,#0FBH
	MOV A,R0
	ANL A,0FH
	CJNE A,0FH,ROW3
	
	LJMP DISPLAY
	
ROW0:
	MOV DPTR,#TABLE0
	SJMP COLM

ROW1:
	MOV DPTR,#TABLE1
	SJMP COLM
	
ROW2:
	MOV DPTR,#TABLE2
	SJMP COLM
	
ROW3:
	MOV DPTR,#TABLE3
	SJMP COLM
	
COLM:	
	RRC A
	JNC FIND
	INC DPTR
	SJMP FIND

FIND:
	CLR A
	MOVC A,@A+DPTR
	MOV R3,A
	LJMP DISPLAY
	

DISPLAY:
	LCALL LCD_INIT
	LCALL DELAY_SMALL
	MOV A,#80H
	LCALL LCD_COMMAND
	LCALL DELAY_SMALL
	MOV A,R3
	LCALL LCD_SENDDATA
	
ORG 300H
	TABLE0: DB 'A' ,'B' ,'C'  ,'D'
	TABLE1: DB 'E' ,'F' ,'G'  ,'H'
	TABLE2: DB 'I' ,'J' ,'K'  ,'L'
	TABLE3: DB 'M' ,'N' ,'O'  ,'P'
		
END		