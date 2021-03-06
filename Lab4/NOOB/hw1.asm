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

	  mov r0,#0bfh
	  lcall shift
	  mov a,r3
	  add a,#80h
	 ; mov a,r3		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   r1,#0bfH   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring1	   ;call text strings sending routine
	  acall delay   
	 
	  mov r0,#81h
	  lcall shift
	  mov a,r3
	  add a,#0c0h
	  ;mov a,r3		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   r0,#81h
	  acall lcd_sendstring2
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
main:                              ;used to store the string to memory location

        mov r0,#81h            ;Stored data form memory location 81H (in upper RAM)
        mov @r0,#"S"
		inc r0
        mov @r0,#"U"
		inc r0
        mov @r0,#"D"         ;**Note the indirect addressing method used**
		inc r0
        mov @r0,#"H"
		inc r0
		mov @r0,#"I"
		inc r0
		mov @r0,#"R"
		inc r0
		mov @r0,#" "
		inc r0
		mov @r0,#"S"
		inc r0
		mov @r0,#"U"
		inc r0
		mov @r0,#"M"
		inc r0
		mov @r0,#"A"
		inc r0
		mov @r0,#"N"
		inc r0
		mov @r0,#00H        ;Explicity defined zero to end lcd_sendstring2 loop
		
		;--------------------------------------------
		
		
		;---------------------------------------
		mov r1,#0bfH   ;191
		mov @r1,#"E"
		inc r1
		mov @r1,#"E"
		inc r1
		mov @r1,#"3"
		inc r1
		mov @r1,#"3"
		inc r1
		mov @r1,#"7"
		inc r1
		mov @r1,#" "
		inc r1
		mov @r1,#"-"
		inc r1
		mov @r1,#" "
		inc r1
		mov @r1,#"L"
		inc r1
		mov @r1,#"a"
		inc r1
		mov @r1,#"b"
		inc r1
		mov @r1,#" "
		inc r1
		mov @r1,#"4"
		inc r1
		mov @r1,#00H
			
/*lcall string_length1
		mov a,#16
		subb a,r3
		mov b,#2
		div ab
		add a,#81H
		mov r0,a
	*/	
		
/*lcall string_length2
		mov a,#16
		subb a,r4
		mov b,#2
		div ab
		add a,#0c1H
		mov r1,a*/
		
		lcall start
end

