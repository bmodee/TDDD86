; lax3 demo
;
; PIAB 0-7 - utgång till 7-seg
; PIAA 0 ingång vänsterknapp
; PIAA 1	ingång högerknapp
; D0 = MODE 0STOP 1COUNT
; D1 = räknare 
;

MAIN	
		LEA $8000,A7
		JSR SETUPPIA
		CLR.L D0
		CLR.L D1
		CLR.L D2
		MOVE.L #COUNTER,$74	; IRQA avbrott
		AND.W #$F8FF,SR 	; höjer avbrottsnivån

LOOP
		MOVE.B D1,$10082
		BTST #0,$10080
		BNE LEFT
		BTST #1,$10080
		BNE RIGHT
		JMP LOOP

LEFT		
;Timern ska nollstallas och startas 
		CMP.B #1,D0
		BEQ SKIPLEFT
		CLR.B D1
		MOVE.B #1,D0
SKIPLEFT   	JMP LOOP

RIGHT
;stoppas
		CLR.B D0
		JMP LOOP
		
COUNTER
		TST.B $10080
		CMP.B #1,D0 
		BNE SKIPCOUNT
		ADD.B #1,D0
SKIPCOUNT	RTE
	
		

SETUPPIA	
		CLR.B $10084
		MOVE.B #$00,10080 	; alla ingångar på PIAA
		MOVE.B #$05,10084 	; avbrott in CA1
		CLR.B $10086
		MOVE.B #$FF,10082 	; alla utgångar på PIAB
		MOVE.B #$04,10086
		RTS
