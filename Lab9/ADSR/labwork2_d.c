//Sinusoidal Wave

#include "at89c5131.h"


void timer_init();
void SPI_Init();
//void sine_wave();
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS = P3^5;
bit transmit_completed= 0;							// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;


unsigned short voltage = 0;                                                            // 16 bit

unsigned int m = 0;

unsigned char serial_data,MSB = 0,LSB = 0;

unsigned char count=0, i=0;
float fweight=0;

unsigned short sine[] = {

	0x0800
	,0x098f
	,0x0b0f
	,0x0c71
	,0x0da8
	,0x0ea6
	,0x0f64
	,0x0fd8
	,0x0fff
	,0x0fd8
	,0x0f64
	,0x0ea6
	,0x0da8
	,0x0c71
	,0x0b0f
	,0x098f
	,0x0800
	,0x0670
	,0x04f0
	,0x038e
	,0x0258
	,0x0159
	,0x009b,0x0027,0x0000,0x0027,0x009b,0x0158,0x0257,0x038d,0x04ef,0x0670};

void main(void)
{
	CS_BAR = 1;
	FS = 1;
	SPI_Init();
	timer_init();
	while(1)
	{
		CS_BAR = 0;
		FS = 0;																		// falling edge of CS bar

		SPDAT= MSB;															// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag
		transmit_completed = 0;    								// make the flag 0

		SPDAT = LSB;
		while(!transmit_completed);
		transmit_completed = 0;

		CS_BAR = 1;
		FS = 1;
													// save the 10 bits in one variable
	}
}

void timer_init()
{
 TMOD=1;
 TL0 =0x7D;             //CREATING TIME PERIOD OF 130 MICRO SEC SO THAT WE CAN GIVE 32 VALUE IN 1/240 HZ
 TH0 =0xFF;
	EA=1;
	ET0=1;
	TR0=1;
}


void TIMER0_ISR (void) interrupt 1
{
	TR0 = 0;
	m++;
	if(m<=32){
		voltage = sine[m-1];
	}

	if(m==32){
	m = 0;
	}

	LSB = voltage;
	MSB = voltage/256;
	
	TL0 =0x7D;
	TH0 =0xFF;
	TR0 = 1;
	
}


void SPI_Init()
{
	FS = 1;
	CS_BAR = 1;	                  	// DISABLE ADC SLAVE SELECT-CS
	SPCON |= 0x20;               	 	// P1.1(SSBAR) is available as standard I/O pin
	SPCON |= 0x01;                	// Fclk Periph/4 AND Fclk Periph=12MHz ,HENCE SCK IE. BAUD RATE=3000KHz
	SPCON |= 0x10;               	 	// Master mode
	SPCON |= 0x08;               	// CPOL=0; transmit mode example|| SCK is 0 at idle state
	SPCON &= ~0x04;                	// CPHA=1; transmit mode example
	IEN1 |= 0x04;                	 	// enable spi interrupt
	EA=1;                         	// enable interrupts
	SPCON |= 0x40;                	// run spi;ENABLE SPI INTERFACE SPEN= 1
}

void it_SPI(void) interrupt 9 /* interrupt address is 0x004B, (Address -3)/8 = interrupt no.*/
{
	switch	( SPSTA )         /* read and clear spi status register */
	{
		case 0x80:
			serial_data=SPDAT;   /* read receive data */
			transmit_completed=1;/* set software flag */
 		break;

		case 0x10:

		break;

		case 0x40:
		break;
	}
}


