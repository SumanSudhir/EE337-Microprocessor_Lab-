#include "at89c5131.h"
#include "stdio.h"

void timer_init();
int x = 0,y = 0,p = 0,q = 2500;
int i =0;

unsigned int m = 0;

void timer_init()
{
 TMOD=1;
             //CREATING TIME PERIOD OF 130 MICRO SEC SO THAT WE CAN GIVE 32 VALUE IN 1/240 HZ
	TL0 =0x21;
	TH0 =0xCF;
	EA=1;
	ET0=1;
	TR0=1;
}



void TIMER0_ISR (void) interrupt 1
{
	TR0 = 0;
	P3_7 = ~P3_7;
	m++;
	if(m<=32){
	x = ((0.98078)*p)+((0.19509)*q);
	y = ((0.98078)*q)-((0.19509)*p);
	p = x;
	q = y;
	i = p+2500;
	
}

if(m==32){
	m = 0;
	x = 0;
	y = 0;
	p = 0;
	q = 2500;
}

	TL0 =0x21;
	TH0 =0xCF;
	TR0 = 1;
	
}

void main(void){
timer_init();
while(1);
}