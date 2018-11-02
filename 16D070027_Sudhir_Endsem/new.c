#include "at89c5131.h"
#include "stdio.h"

void timer_init();
void ISR_serial();
void init_serial();
unsigned char outchar;
unsigned char inchar;
void transmit_value();
unsigned char trans;
unsigned char valStr[5];
void transmit_data();


void init_serial(){
	EA=1;
	ES=1;
	ET1=0;
	SCON = 0xc0;
}

void timer_init(){
	TMOD=TMOD | 0x20;
	TH1=0xfe;	
	PCON = PCON | 0x80;
}

void ISR_serial(void) interrupt 4{
	unsigned char temp;
	temp=PSW;
	if(TI==1){
		TI=0;
		P1_7 = PSW^0;
		P1_6 = ~PSW^0;
		//TB8 = 0;
	}
	PSW=temp;
}

void transmit_value()
{
sprintf(valStr,"%1.3f\n",1.555);
	
}

void transmit_data(unsigned char str)
{
																									//function to transmit data over TxD pin.
	ACC = str;
	ACC = ACC + 0;
	TB8 = PSW^0;
	SBUF = ACC;
}

void main(){
	P1 = 0;
	init_serial();
	timer_init();
	REN=0;
	RI=0;
	TI=0;
	TR1=1;
	trans = valStr[0]; 
	transmit_data(trans);
}


