#include "at89c5131.h"
#include "stdio.h"
#include "lcd_test.c"
#include "Keypad_Updated.c"

unsigned char z;


void ISR_keypad(void) interrupt 7{
	lcd_cmd(0x80);
	lcd_write_string("Key Pressed:");
	z = read_keypad();
	lcd_char(z);
	msdelay(10);
}


void main(void){
	keypad_init();
	port_init();	
	lcd_init();
	while(1);

}
