				

; MS 6000 ’HEJ HOPP’ 00
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN: 
		LEA $8000,A7		; Sätt stackpekaren
		JSR SETUPPIA		; Programmera PIA: nollställ CRA
		MOVE.B #$04,$10084 	; Inga avbrott skall genereras,
		MOVE.B #$04,$10086 	; varken från port A eller port B
		MOVE.B #$0,$10080	; Sätt utbiten till 0
		MOVE.L #218,$7100	; T för DELAY, #218 tar ungefär en ms
		MOVE.L #50,$7104	; N för BEEP, 50 ms
		LEA $6000,A0	 	; Sätt A0 till att peka på strängen
NEXTCH:		MOVE.B (A0)+,D0 	; Hämta nästa tecken
		CMP.B #0,D0		; Om D0=0: sträng slut, 
		BEQ END			; gå till END
		JSR LOOKUP		; Annars: anropa LOOKUP
		CMP.B #0,D0		; Kolla det returnerade värdet i D0
		BEQ NEXTCH		; Om D0=0: gå till NEXTCH
		JSR SEND		; Annars: anropa SEND
		JMP NEXTCH		; Gå till NEXTCH för nästa tecken
END:		MOVE.B #228,D7	 	; Gå tillbaka till
		TRAP #14 		; monitorn i TUTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SETUPPIA   	MOVE.B  #0,$10084       ; Välj datariktningsregistret (DDRA)
            	MOVE.B  #1,$10080       ; Sätt pinne 0 på PIAA som utgång
            	MOVE.B  #4,$10084       ; Välj in/utgångsregistret
            	MOVE.B  #0,$10086       ; Välj datariktningsregistret (DDRB)
            	MOVE.B  #0,$10082       ; Sätt alla pinnar som ingångar
            	MOVE.B  #4,$10086       ; Välj in/utgångsregistret
            	RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



LOOKUP: 	LEA TABLE1,A1 		; Peka på tabellen
		AND.W #$00FF,D0 	; Gör D0 till 16 bitar
		MOVE.B (A1,D0.W),D0 	; Hämta Morsekoden
		RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DELAY:		MOVE.L $7100,D3 	; Hämta fördröjning T
WAIT: 		SUBQ.L #1,D3 		; Räkna ned med 1
		BNE WAIT 		; Om D3<>0: räkna vidare
		RTS 			; Hoppa tillbaka



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



BEEP: 		CMP.B #1,D2		; Om D2=1:
		SEQ.B $10080		; ettställ utbiten om D2 = 1, annars nollställ utbiten. (MOVE.B D2, $10080)
		BSR DELAY 		; Vänta en halv period
		MOVE.B #0,$10080	; Nollställ utbiten
		BSR DELAY 		; Vänta en halv period
		SUBQ.L #1,D1 		; Räkna ned D1
		BNE BEEP 		; Om D1>0: fortsätt pipa
		RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




SEND: 		MOVE.L $7104,D1 	; Hämta antal perioder N för prick
		LSL.B #1,D0 		; Skifta upp nästa symbol i Morsekoden
		BEQ READY 		; Om D0=0 är tecknet slut
		BCC DOT 		; C=0: prick, C=1: streck
DASH:		MULU #3,D1 		; Multiplicera D1 med 3
DOT: 		MOVE.B #1,D2 		; Ladda D2 med 1 för ton
		BSR BEEP 		; Sänd ut prick/streck
		MOVE.L $7104,D1 	; Hämta N igen
		MOVE.B #0,D2   		; Ladda D2 med 0 för paus
		BSR BEEP 		; Sänd paus efter prick/streck
		BRA SEND 		; Sänd ut nästa prick/streck
READY: 		ASL.L #1,D1 		; Öka D1 till 2N
		MOVE.B #0,D2 		; Ladda D2 med 0 för paus
		BSR BEEP 		; Sänd ut extra paus efter tecknet
		RTS 			; Hoppa tillbaka från subrutinen


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



BLANK: 		MOVE.L $7104,D1		; Ladda D1 med N
		ASL.L #2,D1		; Öka D1 till 4N
		MOVE.B #0,D2		; Ladda D2 med 0 för paus
		BSR BEEP		; Sänd ut extra paus efter ord 
		JMP NEXTCH		; Gå till NEXTCH för nästa tecken


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




TABLE1 		DC.B 	$60,$88,$A8,$90,$40,$28,$D0,$08,$20,$78
		DC.B	$B0,$48,$E0,$A0,$F0,$68,$D8,$50,$10,$C0
		DC.B	$30,$18,$70,$98,$B8,$C8,$6C,$58,$E8












