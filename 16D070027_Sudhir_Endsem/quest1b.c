#include "at89c5131.h"
#include "stdio.h"

void timer_init();
void ISR_serial();
void init_serial();
void transmit_value();
unsigned char outchar;
unsigned char inchar;
void transmit_string();
void transmit_data();
unsigned char received;
	


unsigned char value[5] = {
1.555,3.110,4.665,6.220,7.775
};
unsigned char valStr[5];
unsigned int i=0;


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
		ACC=outchar;
		ACC=ACC+0;
		TB8=PSW^0;
		P1_7 = PSW^0;
		P1_6 = ~PSW^0;
		//TB8 = 0;
		SBUF=outchar;
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

void transmit_string(char* str, n)
{
	int i;
	for(i=0; i<n; i++){
		transmit_data(&str);
		str++;
}



void main(){
	P1 = 0;
	init_serial();
	timer_init();
	REN=0;
	RI=0;
	TI=0;
	TR1=1;
	
	received = transmit_value();
	transmit_string(received,5);

}



