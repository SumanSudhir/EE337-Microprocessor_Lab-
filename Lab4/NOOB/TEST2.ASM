; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
LCD_CLR 	EQU 001H
	
ORG 0000H
LED EQU P1
ljmp MAIN

org 100h
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop4:	 mov r1,#255
	 loop3:	 djnz r1, loop3
	 djnz r0, loop4
	 pop 1
	 pop 0 
	 ret
;-----------------------------------------------------------------------------------


BIN2ASCII:
		MOV R0,#70H
		
		MOV 60H,A
		ANL A,#0FH
		SUBB A,#10
		MOV A,60H
		ANL A,#0FH
		JNC SKIP
		LCALL LOOP2
		SJMP SKIP2
	SKIP:
		ANL A,#0FH
		LCALL LOOP1
		
	SKIP2:
		MOV A,60H
		ANL A,#0F0H
		SWAP A
		MOV 61H,A
		CLR C
		SUBB A,#10
		MOV A,61H
		JNC SKIP3
		LCALL LOOP2
RET
	
	SKIP3:LCALL LOOP1


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
		
RET	

MAIN:
	
	MOV P1,#0FFH
	ACALL DELAY
	ACALL DELAY
	ACALL DELAY
	MOV A,#48H
		
		ACALL BIN2ASCII
		
		ACALL LCD_INIT
	    MOV A,85H
		ACALL LCD_COMMAND
		MOV A,70H
		ACALL LCD_SENDDATA
		
		;MOV A,85H
		;ACALL LCD_COMMAND
		MOV A,71H
		ACALL LCD_SENDDATA
		
	
	
	HERE:SJMP HERE
	END
	
	
	