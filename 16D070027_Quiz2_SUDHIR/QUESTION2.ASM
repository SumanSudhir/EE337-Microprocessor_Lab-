ORG 00H
LJMP MAIN

ORG 003H 							;ISR FOR TIMER 0
LJMP ISR1

ORG 00BH
LJMP TIMER

ORG 100H
	
ISR1:
	MOV R1,TH0
	MOV R2,TL0
	MOV A,R3
	MOV R4,A
	MOV R3,#0
	MOV TH0,#00H
	MOV TL0,#00H
	
RETI

TIMER:
	INC R3
RETI

ORG 200H
	
MAIN:
	MOV TMOD,#09H              
	MOV IE,#83H                ;timer0 and external0 interrupt
	MOV TCON,#01H             ;interrupt by falling edge
	
	MOV TH0,#00H
	MOV TL0,#00H
	MOV R3,#0
	CLR TF0
	SETB TR0;
	HERE:SJMP HERE
	
END	
