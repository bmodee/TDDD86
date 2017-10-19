
; lax som rasmus gjorde, tända lampor  
; PIAA - utgångar till lampor
; MSB - lampa vänster
; CA1 - avbrott vänster
; CA2 - avbrott höger
MAIN
		LEA $8000,A7
		CLR.B D0 ; det som skickas från PIAA till lampa
		CLR.B D1
		MOVE.L #LEFT,$74
		MOVE.L #RIGHT,$68
		AND.W #$F8FF,SR
		JSR SETUPPIA
LOOP	JSR LOOP

SETUPPIA
		CLR.B $10084
		MOVE.B #$FF,$10080 ; PIAA utgångar
		MOVE.B #$05,$10084 ; Avbrott på CA1
		CLR.B $10086
		MOVE.B #$FF,$10082 ; PIAB utgångar (spelar ingen roll, används inte)
		MOVE.B #$05,$10086 ; Avbrott på CB1


LEFT
; minska
; ASL
		TST.B $10084
		ASL.B #$01,D0
		RTE

RIGHT
; öka
; ASR om MSB är 1
		TST.B $10086
		CMP.L #$0,D0		; kolla om lamporna är 000000
		BNE SKIP
		MOVE.B #10000,D0	; ja, sätt om så att det blir 100000 annars hoppa
SKIP	ASR.B #$01,D0		; ASR -> 1100000 osv
		RTE