
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable



ORG 00H
LJMP MAIN

ORG 003H 							;ISR FOR TIMER 0
LJMP ISR1

ORG 00BH
LJMP TIMER

ORG 100H
	

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

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 
	 
	 ret
	 
my_string1:
         DB   " COUNT IS", 00H
			 
	;-----------------------------------------------------------
BIN2ASCII:
		PUSH 60H
		PUSH 61H
		;PUSH AR0

		MOV R0,#30H

		MOV 60H,A
		ANL A,#0FH
		SUBB A,#10
		MOV A,60H
		ANL A,#0FH
		JNC SKIP
		LCALL LOOOP2
		SJMP SKIP2
SKIP:
		ANL A,#0FH
		LCALL LOOOP1

SKIP2:
		MOV A,60H
		ANL A,#0F0H
		SWAP A
		MOV 61H,A
		CLR C
		SUBB A,#10
		MOV A,61H
		JNC SKIP3
		LCALL LOOOP2
		SKIP3:LCALL LOOOP1
		;POP AR0
		POP 61H
		POP 60H
RET
;SKIP3:LCALL LOOP1
LOOOP1:
		ADD A,#37H
		MOV @R0,A
		INC R0
		CLR C
RET

LOOOP2:
		ADD A,#30H
		MOV @R0,A
		INC R0
		CLR C
RET


;----------------------------------------------------
	
ISR1:
	MOV R1,TH0
	MOV R2,TL0
	MOV A,R3
	MOV R4,A
	
DJNZ R5,NEXT
	lcall lcd_init
	mov a,#80h		 ;Put cursor on first row,5 column
	lcall lcd_command	
	
	mov   dptr,#my_string1   
	Lcall lcd_sendstring	   
	

	LCALL DELAY
	MOV A,#0C3H
	lcall lcd_command
	
	LCALL DELAY
	
	
	;---------------------------------------------------
	MOV A,R4
	LCALL BIN2ASCII
	MOV A,31H
	LCALL lcd_senddata

	MOV  A,30H
	LCALL lcd_senddata
	
	;---------------------------------------
	MOV A,R1
	LCALL BIN2ASCII
	MOV A,31H
	LCALL lcd_senddata

	MOV  A,30H
	LCALL lcd_senddata
	
	
	;-------------------------------------------
	MOV A,R2
	LCALL BIN2ASCII
	MOV A,31H
	LCALL lcd_senddata

	MOV  A,30H
	LCALL lcd_senddata
	
	LCALL DELAY
	MOV R5,#6
	
	NEXT:
	MOV R3,#0
	MOV TH0,#00H
	MOV TL0,#00H
	
	
RETI

TIMER:
	INC R3
RETI

ORG 500H

MAIN:
	
	MOV TMOD,#09H              
	MOV IE,#83H                ;timer0 and external0 interrupt
	MOV TCON,#01H             ;interrupt by falling edge
	
	MOV R5,#06
	mov A,80H
	
	MOV TH0,#00H
	MOV TL0,#00H
	MOV R3,#0
	
	LCALL LCD_INIT
	CLR TF0
	SETB TR0;
	HERE:SJMP HERE
	
END	
