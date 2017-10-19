; 
; Laxdemo4
; PIAA ingång från hexknap
; PIAB utgång till displaeyerna
; CA1 - strobe avbrott
;

MAIN
		LEA $8000,A7		; sätter stackpekare
		CLR.B D0 			; 0 = vänster display, 1 = höger display
		CLR.B D1			; Sparar vilken knapp jag trycker ner
		CLR.B D2			; RES
		JSR SETUPPIA		
		MOVE.B #STROBE,74	; IRQA STROBE
		AND.W #$F8FF,SR 	;

LOOP 	JMP LOOP


SETUPPIA
		CLR.B $10084
		MOVE.B #$F0,$10080 	; PIAA ingångar
		MOVE.B #$05,$10084 	; Avbrott på CA1
		CLR.B $10086		
		MOVE.B #$FF,$10082	; PIAB utgångar
		MOVE.B #$04,$10086 	; inga avbrott


STROBE
; när vi trycker ner godtycklig knapp:
		TST.B $10080
		MOVE.B $10080,D1	; Flyttar det vi får in till D1
		CMP.B #$F, D1		; kolla om F knappen trycks ner
		BEQ	DISPLAY			; JA, byt display
		CMP.B #$10,D1		; högre än 9
		BGE END				; Avsluta
		CMP.B #1,D0
		BNE DZERO
		AND.B #$F0,D2
		ADD.B D1,D2
		JMP END

DZERO	
		ASL.B #4,D1
		AND.B #$0F,D2
		ADD.B D1,D2
		JMP END
		
DISPLAY
		BCHG #0,D0
		RTE
				
END 
		MOVE.B D1,$10082
		RTE






