
;------------------------------------------
; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp main

org 200h
start:
	using 0
		push ar0
		push ar1
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay

	  mov A,#81h
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   a,50h  ;Load DPTR with sring1 Addr
	  acall lcd_senddata	   ;call text strings sending routine
	  acall delay   
	
	  pop ar1
	pop ar0
here: sjmp here				//stay here 

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

;-----------------------text strings sending routine-------------------------------------


lcd_sendstring1:              ;incase mem. location is defined to r0
         mov a,@r1
		 jz exit1
		 acall lcd_senddata
		 inc r1
		 sjmp lcd_sendstring1

exit1:
 	     ret

lcd_sendstring2:              ;incase mem. location is defined to r0
         mov a,@r0
		 jz exit2
		 acall lcd_senddata
		 inc r0
		 sjmp lcd_sendstring2
exit2:
 	     ret


;------------------------------------------------------------------------------------
;lcd_sendstring:
;	 push 0e0h
;	 repeat:
 ;        clr   a                 ;clear Accumulator for any previous data
  ;       movc  a,@a+dptr         ;load the first character in accumulator
   ;      jz    exit              ;go to exit if zero
    ;     acall lcd_senddata      ;send first char
     ;    inc   dptr              ;increment data pointer
      ;   sjmp  repeat    ;jump back to send the next character
;exit:    pop 0e0h
 ;        ret                     ;End of routine

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

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "Pt-51", 00H
my_string2:
		 DB   "IIT Bombay", 00H
ret

shift:              ;incase mem. location is defined to r0
		push ar0
		mov r3,#0
	str_len:
         mov a,@r0
		 jz ext1
		 inc r3
		 inc r0
		 sjmp str_len
ext1:
pop ar0
mov a,#16
subb a,r3
mov b,#2
div ab
mov r3,a
ret


ORG 0000H
ljmp main
org 200h
	
DELAY1:
	USING 0
	PUSH AR1
	PUSH AR2
	PUSH AR3
	PUSH PSW

	MOV R3,A
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

LOADING_A:
	MOV P1,#0FFH    ;LED HIGH
	;MOV A,P1
	
	MOV A,#100       ;DELAY OF 5S 
	LCALL DELAY1
	
	CLR P1.7
	CLR P1.6
	CLR P1.5
	CLR P1.4
	
	MOV A,#20
	LCALL DELAY1        ;DELAY OF 1S
	
	MOV A,P1
RET
READNIBBLE:
	LCALL LOADING_A
	
	MOV @R0,A
	SWAP A
	MOV P1,A
	
	MOV A,#100
	LCALL DELAY1
	
	
	LCALL LOADING_A       ;VERIFY
	CJNE A,#0FH,READNIBBLE	
RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
	MOV @R1, A
RET
STORE:
	
	MOV R2,50H
	MOV R1,51H
read_bytes:
	MOV R0, #4EH
	LCALL READNIBBLE
	MOV R0, #4FH
	LCALL READNIBBLE
	LCALL PACKNIBBLE
	INC R1
	DJNZ R2,read_bytes
	
RET
main:

mov a,p1 
anl a,#0fh
mov 50h,a
SWAP A
MOV P1,A
mov a,#100
lcall delay1
MOV P1,#0FFH


mov a,p1 
anl a,#0fh
mov 51h,a
SWAP A
MOV P1,A
mov a,#100
lcall delay1

lcall store
lcall start

end

















 
/*string_length2:              ;incase mem. location is defined to r0
		push ar1
		mov r1,#0
		mov r4,#0
str_len1:
         mov a,@r1
		 jz exitt1
		 inc r4
		 acall lcd_senddata
		 inc r1
		 sjmp str_len1
exitt1:
	pop ar1
 ret
		
*/
	
/*DELAY1:
	USING 0
	PUSH AR1
	PUSH AR2
	PUSH AR3
	PUSH PSW

	MOV R3,A
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

LOADING_A:
	MOV P1,#0FFH    ;LED HIGH
	;MOV A,P1
	
	MOV A,#100       ;DELAY OF 5S 
	LCALL DELAY1
	
	CLR P1.7
	CLR P1.6
	CLR P1.5
	CLR P1.4
	
	MOV A,#20
	LCALL DELAY1         ;DELAY OF 1S
	
	MOV A,P1
RET
READNIBBLE:
	LCALL LOADING_A
	
	MOV @R0,A
	SWAP A
	MOV P1,A
	
	MOV A,#100
	LCALL DELAY1
	
	
	LCALL LOADING_A       ;VERIFY
	CJNE A,#0FH,READNIBBLE	
RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
	MOV 50H, A
RET

MAIN:
	MOV R0, #4EH
	LCALL READNIBBLE
	
	MOV R0, #4FH
	LCALL READNIBBLE
	LCALL PACKNIBBLE
	lcall start
		
END
	
	
	
	
	
	
	
	
	
	
	
	
	*/
	
	
	
	
	
/*DELAY1:
	USING 0
	PUSH AR1
	PUSH AR2
	PUSH AR3
	PUSH PSW

	MOV R3,A
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

LOADING_A:
	MOV P1,#0FFH    ;LED HIGH
	;MOV A,P1
	
	MOV A,#100       ;DELAY OF 5S 
	LCALL DELAY
	
	CLR P1.7
	CLR P1.6
	CLR P1.5
	CLR P1.4
	
	MOV A,#20
	LCALL DELAY         ;DELAY OF 1S
	
	MOV A,P1
RET
READNIBBLE:
	LCALL LOADING_A
	
	MOV @R0,A
	SWAP A
	MOV P1,A
	
	MOV A,#100
	LCALL DELAY
	
	
	LCALL LOADING_A       ;VERIFY
	CJNE A,#0FH,READNIBBLE	
RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
	MOV R2, A
RET
STORE:
	MOV R2,51H
read_bytes:
	MOV R0, #4EH
	LCALL READNIBBLE
	MOV R0, #4FH
	LCALL READNIBBLE
	LCALL PACKNIBBLE
	INC R2
	DJNZ R1,read_bytes
	
RET
MAIN:
	MOV A,P1
	ANL A,#0FH
	MOV R1,A
	LCALL STORE
	
	MOV A,P1
	ANL A,#0FH
	ADD A,51H
	MOV R3,A
	LCALL START

end
*/


	

