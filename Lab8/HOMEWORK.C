#include <AT89C5131.h> // All SFR declarations for AT89C5131

sbit LED = P1^4; //assigning label to P1^4 as "LED"
sbit PARITY = PSW^0;

//void delay_ms(int delay);

void ISR_Serial(void) interrupt 4 {
	LED = ~LED;
	TI = 0;               //transfer interrupt
	SBUF = 0x41;           //
}

void init_serial() {
	TMOD = 0x20;    //MODE 2
	TH1 = 0xCC;    //BAUD RATE 1200 ====204

	SCON = SCON||0xC0;
									// setting of mode

	ES = 1;    //SERIAL PORT interrupt
	ET1 = 0;       //SET TO ENABLE TIMER Overflow
	ACC = 0x41;
								// doing parity check

	ACC += 1;
	ACC -= 1;
	TB8 = PARITY;
	EA = 1;      						//enable interrupt
	SBUF = 0x41;

	
										// starting timer
	TR1 = 1;          //setting timer1
}

void main (void) {
	LED = 0;
	init_serial();
	while(1);
	//delay_ms(5);
}


/*
void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}

*/
