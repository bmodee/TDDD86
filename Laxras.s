
; LAX som rasmus gjorde, tända lampor  
; PIAA - utgångar till lampor
; MSB - lampa vänster
; CA1 - avbrott vänster
; CA2 - avbrott höger

MAIN
		LEA $8000,A7
		CLR.L D0 			; det som skickas från PIAA till lampa
		JSR SETUPPIA
		MOVE.L #LEFT,$74
		MOVE.L #RIGHT,$68
		AND.W #$F8FF,SR
		
LOOP	JSR LOOP

SETUPPIA
		CLR.B $10084
		MOVE.B #$FF,$10080 ; PIAA utgångar
		MOVE.B #$05,$10084 ; Avbrott på CA1
		CLR.B $10086
		MOVE.B #$FF,$10082 ; PIAB utgångar (spelar ingen roll, används inte)
		MOVE.B #$05,$10086 ; Avbrott på CB1
		RTS

LEFT
; minska
; ASL
		TST.B $10080     	;
		ASL.B #$1,D0		; Shift left 1100 -> 1000
		JMP END				;

RIGHT
; öka
; ASR om MSB är 1
		TST.B $10082
		CMP.L #$0,D0		; kolla om lamporna är 0000 0000
		BNE SKIP
		MOVE.B #$80,D0		; ja, sätt om så att det blir 1000 0000 annars hoppa
		JMP END
SKIP	ASR.B #$01,D0		; ASR -> 1100000 -> 11100000 osv
		JMP END

END
		MOVE.B D0,$10080
		RTE