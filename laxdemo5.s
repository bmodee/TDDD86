MAIN		
			LEA $8000,A7		; Sätter stackpekare
			JSR SETUPPIA 		; initierar PIA
			CLR.L D0			; Input
			CLR.L D1			; Toggle 0 = norm 1 = inverterat
			CLR.L D2
			MOVE.L #STROBE,$74 	
			AND.W #$F8FF,SR 	; sänker avbrottsnivån , måste finnas om avbrott är med

LOOP		JMP LOOP

STROBE		TST.B $10080



SETUPPIA
			CLR.B $10084  		; Välj DDRA
			MOVE.B #0,$10080 	; alla pinnar är ingångar
			MOVE.B #$05,$10084	; Välj PORTA
			CLR.B $10086  		; Välj DDRB
			MOVE.B #$FF,$10082 	; alla pinnar är utgångar
			MOVE.B #$04,$10086	; Välj PORTB
			RTS		
