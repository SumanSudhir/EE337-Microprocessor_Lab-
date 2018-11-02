//Generate waveform at P3_6

#include "at89c5131.h"


void timer_init();
void SPI_Init();
sbit CS_BAR = P3^4;									// Chip Select for the ADC
sbit FS = P3^5;
bit transmit_completed= 0;							// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;

unsigned long adcVal=0, voltage= 0 , sum = 0,tempadcVal=0 ,temp_low,temp_high,try0=0;
unsigned int avgVal=0, initVal=0, adcValue = 0 , temp=0 ;

unsigned char serial_data;
unsigned char data_save_high;
unsigned char data_save_low;
unsigned char count=0, i=0;
float fweight=0;


void main(void)
{
	CS_BAR = 1;
	FS = 1;
	SPI_Init();
	while(1)
	{
		CS_BAR = 0;
		FS = 0;																		// falling edge of CS bar

		SPDAT= 0x04;															// first 4 bits will be address of the channel
		while(!transmit_completed);								// wait for the transmit complete flag
		transmit_completed = 0;    								// make the flag 0
		
		SPDAT =0x00;	
		while(!transmit_completed);
		transmit_completed = 0;
		
		CS_BAR = 1;
		FS = 1;
													// save the 10 bits in one variable
	}
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
//	IPH0 |=0x10;
//	IPL0 |=0x10;
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
