ORG 0H
LJMP MAIN
ORG 100H
		
		MAIN : 
		    
			MOV A,61H	
			ADD A,71H
			
			MOV 64H,A
			MOV A,60H
			
			ADDC A,70H
			
			MOV 63H,A
			ANL 60H,#80H
			MOV A,60H
			RL A
			MOV 66H,A
			ANL 70H,#80H
			MOV A,70H
			RL A
			ADDC A,66H
			ANL A,#01H
			MOV 62H,A
			
			HERE: SJMP HERE
		END