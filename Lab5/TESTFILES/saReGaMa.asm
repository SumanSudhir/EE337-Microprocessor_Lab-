ORG 00H
LJMP MAIN

DELAY:
		USING 0
		PUSH ACC
		PUSH AR0
		MOV R0,#81H         ;INDIRECT READ FROM MEMORY LOCATION 81H
		MOV A,@R0
		CPL A    			;COMPLEMENT OF A
		ADD A,#01    		;ADD 1 TO MAKE IT 2'S COMPLEMENT
		MOV TL0,A          
		INC R0              ;CARRY FLAG IS NOT AFFECTED BY INC
		MOV A,@R0
		CPL A               ;COMPLEMENT OF ANOTHER BYTE
		ADDC A,#00H         ;WILL ADD CARRY IF GENERATED FROM LOWER BYTE
		MOV TH0,A      
						;2'S COMPLEMENT OF THE 16BIT NO. IS NOW STORED IN T0
		MOV TMOD,#01
		SETB TR0             ;ENABLE TIMER 0
START_COUNT:
		JNB TF0,START_COUNT    ;Jump if Bit Not Set
		CLR TR0              ;STOP TIMER
		CLR TF0              ;CLEAR OVERFLOW BIT
		POP AR0
		POP ACC
RET

DELAY_T1:
		USING 0
		PUSH ACC
		PUSH AR0
		MOV R0,#70H         ;INDIRECT READ FROM MEMORY LOCATION 81H
		MOV A,@R0
		CPL A    			;COMPLEMENT OF A
		ADD A,#01    		;ADD 1 TO MAKE IT 2'S COMPLEMENT
		MOV TL1,A          
		INC R0              ;CARRY FLAG IS NOT AFFECTED BY INC
		MOV A,@R0
		CPL A               ;COMPLEMENT OF ANOTHER BYTE
		ADDC A,#00H         ;WILL ADD CARRY IF GENERATED FROM LOWER BYTE
		MOV TH1,A      
						;2'S COMPLEMENT OF THE 16BIT NO. IS NOW STORED IN T0
		MOV TMOD,#01
		SETB TR1             ;ENABLE TIMER 0
;START_COUNT:
;		JNB TF1,START_COUNT    ;Jump if Bit Not Set
;		CLR TR1              ;STOP TIMER
;		CLR TF1              ;CLEAR OVERFLOW BIT
		POP AR0
		POP ACC
RET



DELAY_1S:
	USING 0
		PUSH AR0
		PUSH 50H
	MOV R0,#81H
	MOV @R0,#050H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 50,000  FOR GETTING DELAY = 25MSEC
	MOV @R0,#0C3H        		;DELAY CORRESPONDING TO 3EFFH WOULD BE GENERATED
	
		MOV 50H,#40	
		LOOP:
		LCALL DELAY 
		DJNZ 50H,LOOP
		POP 50H
		POP AR0
RET

;---------------------------------------------------------


;--------------------------------------SA----------------------

SA:
	PUSH AR0
	MOV R0,#81H
	MOV @R0,#47H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#10H
	MOV 70H,#0F0H
	MOV 71H,#00H

	SALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		ACALL DELAY_T1
		JNB TF1,SALOOP
		CLR TR1
		CLR TF1
		
	POP AR0
RET

;------------------------KOMALRE----------------------

KOMALRE:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	MOV 50H,#16
	MOV 51H,#16
	
	MOV R0,#81H
	MOV @R0,#43H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0FH        		


KOMALRELOOP1:
	KOMALRELOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H,KOMALRELOOP
		DJNZ 51H,KOMALRELOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;------------------RE-------------------------
RE:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	MOV R0,#81H
	MOV @R0,#78H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0EH
	MOV 50H,#135      ;270
	MOV 51H,#2

	RELOOP1:
	RELOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H,RELOOP
		DJNZ 51H,RELOOP1
	POP 51H
	POP 50H
	POP AR0
RET


;-----------------------------KOMALGA----------------------
KOMALGA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 50H,#144   ;288
	MOV 51H,#2
	
	MOV R0,#81H
	MOV @R0,#91H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0DH        		

	KOMALGALOOP1:
	KOMALGALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, KOMALGALOOP
		DJNZ 51H, KOMALGALOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------GA----------------------
GA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 50H,#150     ;300
	MOV 51H,#2
	
	MOV R0,#81H
	MOV @R0,#05H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0DH        		
	
	
	GALOOP1:             	    
	GALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, GALOOP
		DJNZ 51H, GALOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------MA----------------------
MA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 50H,#160       ;320
	MOV 51H,#2
	
	MOV R0,#81H
	MOV @R0,#35H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0CH        		


MALOOP1:
	MALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, MALOOP
		DJNZ 51H, MALOOP1
	POP 51H	
	POP 50H
	POP AR0
RET


;-----------------------------TIVRAMA----------------------
TIVRAMA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 50H,#170
	MOV 51H,#2
	
	MOV R0,#81H
	MOV @R0,#72H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0BH        		

TIVRAMALOOP1:             	    
	TIVRAMALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, TIVRAMALOOP
		DJNZ 51H, TIVRAMALOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------PA----------------------
PA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 50H,#180     ;360
	MOV 51H,#2
	
	MOV R0,#81H
	MOV @R0,#0DAH				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0AH        		

PALOOP1:             	    
	PALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, PALOOP
		DJNZ 51H, PALOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------KOMALDHA----------------------
KOMALDHA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 51H,#2
	MOV 50H,#192    ;384
	
	MOV R0,#81H
	MOV @R0,#02CH				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#0AH        		


KOMALDHALOOP1:             	    
	KOMALDHALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, KOMALDHALOOP
		DJNZ 51H, KOMALDHALOOP1
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------DHA----------------------
DHA:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 51H,#2
	MOV 50H,#200

	MOV R0,#81H
	MOV @R0,#0C4H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#09H        		


DHALOOP1:
	DHALOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, DHALOOP
		DJNZ 51H, DHALOOP1
	
	POP 51H
	POP 50H
	POP AR0
RET

;-----------------------------KOMALNI----------------------
KOMALNI:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 51H,#2
	MOV 50H,#214
	MOV R0,#81H
	MOV @R0,#028H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#09H        		

KOMALNILOOP1:
	KOMALNILOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H, KOMALNILOOP
		DJNZ 51H, KOMALNILOOP1
	POP 51H
	POP 50H
	POP AR0
RET


;-----------------------------NI----------------------
NI:
	PUSH AR0
	PUSH 50H
	PUSH 51H
	
	MOV 51H,#2
	MOV 50H,#225
	MOV R0,#81H
	MOV @R0,#028H				;MAX N = 65,536   FFFFH
	INC R0						;SETTING N = 8334/2 = 4167  FOR GETTING DELAY = 1/240SEC
	MOV @R0,#09H        		

NILOOP1:             	    
	NILOOP:             	    ;TO SHOW ON LED
		SETB P0.3
		LCALL DELAY 
		CPL P0.3
		LCALL DELAY
		DJNZ 50H,NILOOP
		DJNZ 51H,NILOOP1
	POP 51H
	POP 50H
	POP AR0
RET
;--------------------------------------------------------------------

MAIN:

	ACALL SA
	ACALL KOMALRE
	ACALL RE
	ACALL KOMALGA
	ACALL GA
	ACALL MA
	ACALL TIVRAMA
	ACALL PA
	ACALL KOMALDHA
	ACALL DHA
	ACALL KOMALNI
	ACALL NI
	ACALL DELAY_1S
	
	HERE:SJMP HERE
END