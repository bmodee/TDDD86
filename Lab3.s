				
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN: 
		LEA $8000,A7		; Sätt stackpekaren
		JSR PIAINIT		; Programmera PIA: nollställ CRA
		MOVE.L #BCD,$74
		MOVE.L #MUX,$68
		AND.W #$F8FF,SR		; Sätter statusregister IP2,1,0 till 0
		CLR.B $900
		CLR.B $901
		CLR.B $902
		CLR.B $903
		MOVE.B #0,D4		; Sätter index till 0 


LOOP		JMP LOOP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PIAINIT:   		MOVE.B  #0,$10084       ; Välj datariktningsregistret (DDRA)
            	MOVE.B  #$7F,$10080     ; 7-seg: Sätt pinne 0-6 utgång, 7 ingång
            	MOVE.B  #7,$10084       ; CA-2,1,0 till 1
            	MOVE.B  #0,$10086       ; Välj datariktningsregistret (DDRB)
            	MOVE.B  #$3,$10082      ; Muxsignaler: PIAB 0-1 utgång, resten ingångar
            	MOVE.B  #7,$10086       ; CB-2,1,0 till 1
				MOVE.B  #0,$10080
				MOVE.B	#0,$10082
            	RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



MUX:		TST.B $10082 		;Testar b-porten PIA	
		ADD.B #1,D4		;Räknar upp indexet
		CMP.B #4,D4		;Jämför om index är 4
		BNE NEXT		;Om index != 4, gå till next
		MOVE.B #0,D4		;Nollställ index om indexet är 4
NEXT		MOVE.B D4,$10082	;Skickar ut vilken display som skall användas
		LEA SJUSEGTAB,A0
		CMP.B #0,D4		;Om index 0, ladda utregistret med sekunder
		BEQ SECOND
		CMP.B #1,D4		;Om index 1, ladda utregistret med tiotals sekunder
		BEQ TENSSECOND		
		CMP.B #2,D4		;Om index 2, ladda utregistret med minuter
		BEQ MINUTE
		CMP.B #3,D4		;Om index 3, ladda utregistret med tiotals minuter
		BEQ TENSMINUTE
		RTE

SECOND		MOVE.B (A0,$900),$10080
		RTS
TENSSECOND	MOVE.B (A0,$901),$10080
		RTS
MINUTE		MOVE.B (A0,$902),$10080
		RTS
TENSMINUTE	MOVE.B (A0,$903),$10080
		RTS
		



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BCD:		TST.B $10080		
		ADD.B #1,$900
		CMP.B #10,$900
		BNE END
		MOVE.B #0,$900
		ADD.B #1,$901
		CMP.B #6,$901
		BNE END
		MOVE.B #0,$901
		ADD.B #1,$902
		CMP.B #10,$902
		BNE END
		MOVE.B #0,$902
		ADD.B #1,$903
		CMP.B #6,$903
		BNE END
		MOVE.B #0,$903
END		RTE
		



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





SJUSEGTAB   DC.B    $3F ;0
            DC.B    $06 ;1
            DC.B    $5B ;2
            DC.B    $4F ;3
            DC.B    $66 ;4
            DC.B    $6D ;5
            DC.B    $7D ;6
            DC.B    $07 ;7
            DC.B    $7F ;8
            DC.B    $6F ;9












