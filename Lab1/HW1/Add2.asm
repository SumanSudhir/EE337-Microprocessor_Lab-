org 0h
ljmp main
org 100h
		
		main : 
			mov 50h,#80
			mov 60h,#80
			
			mov A, 50h
			add A, 60h
			mov 70h, A

			mov 00h, C
			mov 71h, 20h
			HERE: sjmp HERE
		end