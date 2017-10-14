
; LAX-demo2
; A0 : left button
; PA1 : right button
; PB3-0 : 7-seg display

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN		LEA $8000,a7		; Sätter stackpekare
			JSR SETUPPIA		; initiarar pia
			CLR.B D0			; nollställ räknaren?


LOOP							; loop
			BTST 				; kollar om vi klickar vänster
			BNE LEFTCLICK		; hoppar till vänster funktionen
			BTST				; kollar om vi klickar höger
			BNE RIGHTCLICK		; hoppar till höger funktionen
			JMP LOOP			; loop

LEFTCLICK
			CMP.B #15,D0		; är vi på max?
			BEQ SKIP			; Ja, hoppa över addering
			ADD.B #1,D0			; Addera
SKIP		JMP WAITREL
								
RIGHTCLICK						
			MOVE.B D0,$10082 	; skicka till displayen
			CLR.B D0			; nollställ
WAITREL
			MOVE.B $10080,D1	; läs PORTA
			AND.B  #$03,D1	 	; maska knapp bit
			CMP.B #0,D1			; någpn knapp som fortfarande trycks ner?
			BNE WAITREL			; Ja, vänta på att släppas
			JMP LOOP			; Loop


SETUPPIA	
		; två ingångar för att registrera knapparna
		; 4 utgångar för att visa upp vår räknare
			MOVE.B #0,$10084 	; DDRA
			MOVE.B #$0,$10080 	; alla pinnar är ingångar
			MOVE.B #4,$10084	; CA-2? Välj in/utgångsregistret
			MOVE.B #0,$10086  	; DDRB
			MOVE.B #$FF,$10080 	; alla pinnar är utgångar
			MOVE.B #4,$10086	; CB-2? Välj in/utgångsregistret
			RTS					; tillbaka

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
