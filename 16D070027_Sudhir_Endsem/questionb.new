#include <at89c5131.h>
#include <Keypad_updated.c>
unsigned char read_keypad(void);
void keypad_init(void);
void transmit_data(unsigned char str);
unsigned char receive_data(void);

sbit par = PSW^0;
bit enable = 0;
bit stop = 0;
unsigned char received = 0x00;

void ISR_keypad(void) interrupt 7
{
	P1 = ~P1;
	received = read_keypad();
	if (enable ==1){
		transmit_data(received);
	}
}

																										// Functions to be used for UARTs
void ISR_serial(void) interrupt 4
{
receive_data()	;																		//ISR for serial interrupt
}


void init_serial()
{
																										//Initialize serial communication and interrupts
	SCON = 0xD0;
	TH1 = 204;
	TMOD = 0x20;
	TR1 = 1;
	EA = 1;
	ES = 1;
}

unsigned char receive_data(void)
{
if(RI == 1){
		RI = 0;
		received = SBUF;
		P1=~P1;
		if (enable == 1){
			if (received == 'N'){
				enable=0;
			}
		}
		else {
			if (received == 'Y'){
				enable = 1;
			}
		}
	}
	if(TI == 1) {
		TI = 0;
	}																								//function to receive data over RxD pin.
}

void transmit_data(unsigned char str)
{
																									//function to transmit data over TxD pin.
	ACC = str;
	ACC = ACC + 0;
	TB8 = par;
	SBUF = ACC;
}


void transmit_string(char* str, n)
{
	int i;
	for(i=0; i<n; i++){
		transmit_data(&str);
		str++;
}
																									//function to transmit string of size n over TxD pin.
}

void main(){
	keypad_init();
	init_serial();
	while(1);
}
