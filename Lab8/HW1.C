#include "at89c5131.h"

void main(void)
{
	TMOD = 0x20;
	TH1 = 0xCC;


	while(1){
	while(TF1==0){
	}
	TF1 = 0;
	}
}
