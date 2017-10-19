MAIN		
			LEA $8000,A7		; Sätter stackpekare
			JSR SETUPPIA 		; initierar PIA
			CLR.B D0			; Nollställ dataregister
			(CLR.B D1 osv)
			;;;;;;;;;;;

			; vid avbrott:

			MOVE.B #IRQA,$74 (/$68)
			AND.W #$F8FF,SR 	; sänker avbrottsnivån , måste finnas om avbrott är med

			;;;;;;;;;;;

LOOP		JMP LOOP

SETUPPIA
			CLR.B $10084  		; Välj DDRA
			MOVE.B #0,$10080 	; alla pinnar är ingångar
			MOVE.B #$04(/05 om avbrott används),$10084	; Välj PORTA
			CLR.B $10086  		; Välj DDRB
			MOVE.B #$FF,$10082 	; alla pinnar är utgångar
			MOVE.B #$04(/05 om avbrott används),$10086	; Välj PORTB
			RTS		
