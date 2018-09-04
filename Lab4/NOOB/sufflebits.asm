
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

;---------------------------SUFFLE BITS------------------
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
	
;---------------------DELAY------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop4:	 mov r1,#255
	 loop3:	 djnz r1, loop3
	 djnz r0, loop4
	 pop 1
	 pop 0 
	 ret
	
	
;------------------------------------------------------
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

READNIBBLE:
	
	MOV P1,#0FFH 
	MOV A,#60
	LCALL DELAY1   
	
	MOV A,P1
	ANL A,#0FH
	MOV @R0,A
	SWAP A
	MOV P1,A   ;will show input on led
	
	MOV A,#60
	LCALL DELAY1   ;wait for 5 sec

	CLR P1.7
	CLR P1.6 
	CLR P1.5
	CLR P1.4
	
	;LCALL LOADING_A       ;VERIFY   ;give input 0fh to verify
	;CJNE A,#0FH,READNIBBLE

RET

PACKNIBBLE:
	MOV A, 4EH
	SWAP A
	ADD A, 4FH
RET

READVALUES:
	MOV R1,#60H
	MOV R2,#2
	
	STORE:
		MOV R0, #4EH
		LCALL READNIBBLE
		MOV R0, #4FH
		LCALL READNIBBLE
		LCALL PACKNIBBLE
		MOV @R1,A
		INC R1
		DJNZ R2,STORE
RET
	;---------------------BIN1ASCII-----------------------------

BIN2ASCII:
		MOV R0,#90H
		
		MOV 93H,A
		ANL A,#0FH
		SUBB A,#10
		MOV A,93H
		ANL A,#0FH
		JNC SKIP
		LCALL LOOP2
		SJMP SKIP2
	SKIP:
		ANL A,#0FH
		LCALL LOOP1
		
	SKIP2:
		MOV A,93H
		ANL A,#0F0H
		SWAP A
		MOV 94H,A
		CLR C
		SUBB A,#10
		MOV A,94H
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
;----------------DISPLAY---------------------------
DISPLAY:
		MOV A,P1
		ANL A,#0FH
		MOV 40H,A    ;STORE THE INPUT TO CHECK LATER 
		SUBB A,#3
		JC SHOW
		JNC CLEAR
		
SHOW:
		push ar0
	
		MOV A,40H
		ADD A,#70H
		ACALL DELAY
		ACALL DELAY
		
		MOV R0,A
		MOV A,@R0
		
		ACALL BIN2ASCII
		
		ACALL DELAY
		ACALL DELAY
		
		
		MOV A,#85H
		ACALL LCD_COMMAND
		MOV A,91H
		ACALL LCD_SENDDATA
		LCALL DELAY
		MOV A,90H
		ACALL LCD_SENDDATA
		
		pop ar0
	CLEAR:
		MOV A,#85H
		ACALL LCD_COMMAND
		MOV A,#00H
		ACALL LCD_SENDDATA
		
RET
;-------------------------------------------------------
MAIN:
		MOV SP,#0CFH;-----------------------Initialize STACK POINTER
		MOV 50H,#3;------------------------Set value of K
		MOV 51H,#60H;------------------------Array A start location
		MOV 4FH,#00H;------------------------Clear location 4FH
		LCALL readValues
		
		MOV 50H,#3;------------------------Value of K
		MOV 51H,#60H;------------------------Array A start location
		MOV 52H,#70H;------------------------Array B start location
		LCALL shuffleBits

		MOV 50H,#3;------------------------Value of K
		MOV 51H,#70H;------------------------Array B start Location
		
	
	HERE:
		ACALL DELAY
		ACALL LCD_INIT
		ACALL DELAY
		ACALL DELAY
		LCALL DISPLAY;----------------Display the last four bits of elements on LCD
		ACALL DELAY
		SJMP HERE
		
		
		;here:SJMP here;---------------------WHILE loop(Infinite Loop)
END
	
	