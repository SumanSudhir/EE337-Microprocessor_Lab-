
ORG 0XXXH
MAIN:
MOV SP,#0CFH;-----------------------Initialize STACK POINTER
MOV 50H,#XX;------------------------No of memory locations of Array A
MOV 51H,#XX;------------------------Array A start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#XX;------------------------No of memory locations of Array B
MOV 51H,#XX;------------------------Array B start location
LCALL zeroOut;----------------------Clear memory
MOV 50H,#XX;------------------------No of memory locations of source array
MOV 51H,#XX;------------------------Source array start location
MOV 52H,#XX;------------------------Destination array(A) start location
LCALL bin2ascii;--------------------Write at memory location
MOV 50H,#XX;------------------------No of elements of Array A to be copied in Array B
MOV 51H,#XX;------------------------Array A start location
MOV 52H,#XX;------------------------Array B start location
LCALL memcpy;-----------------------Copy block of memory to other location
MOV 50H,#XX;------------------------No of memory locations of Array B
MOV 51H,#XX;------------------------Array B start location
MOV 4FH,#XX;------------------------User defined delay value
LCALL display;----------------------Display the last four bits of elements on LEDs
here:SJMP here;---------------------WHILE loop(Infinite Loop)
END