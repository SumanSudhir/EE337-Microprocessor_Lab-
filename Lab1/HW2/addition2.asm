org 0h
ljmp main
org 100h
		
		main : 
			mov 50h, #05h
			mov R1, 50h
			mov R2, #00h
			mov R0, #51h
			mov A, #00h
	  loop:
			inc R2
			add A,R2
			mov @R0, A
			inc R0
			djnz R1, loop
			HERE: sjmp HERE
	    end
