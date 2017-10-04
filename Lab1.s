MAIN        lea     $7000,a7            ; Init stackpekare
            jsr     setuppia		; Init PIA
            jsr     clearinput
            jsr     deactivatealarm
	    move.b  #1,$4010		; Sätter koden till 1234	
	    move.b  #2,$4011
	    move.b  #3,$4012
	    move.b  #4,$4013

waitfora    jsr     getkey
            cmp.b   #$A,d4              ; Jämför d4 med A
            bne     waitfora            ; Loop för att vänta på ett A
            jsr     activatealarm	; Aktivera larmet när vi fått ett A

waitnum     jsr     getkey
            cmp.b   #$F,d4              ; Jämför d4 med F
            beq     tryunlock           ; Försöker låsa upp om vi fått ett F
            cmp.b   #$9,d4              ; Jämför d4 med 9
            bhi     waitnum             ; Om d4>9 så går vi tillbaka och läser in en ny tangent
            jsr     addkey              ; När vi har fått en siffra 0-9 kör vi addkey
            jmp     waitnum             ; Loopar om och plockar in fler siffror

tryunlock   jsr     validatecode
            tst.b   d4                  ; Kollar output från validatecode
            beq     wrongcode
            jsr     deactivatealarm     ; Rätt kod -> Avlarmning
            jsr     clearinput
            jmp     waita               ; Åter till att vänta på ett A
     
wrongcode   move.b  #13,d5   		; Längden av ordet
            jsr     printstring         ; Skriv ut texten
            jmp     waitnum             ; Väntar på input

printchar   move.b  d5,-(a7)            ; Spara undan d5 (bit 7-0) på stacken

waittx      move.b  $10040,d5           ; Serieportens statusregister
            and.b   #2,d5               ; Isolera bit 1 (Ready to transmit)
            beq     waittx              ; Vänta tills serieporten är klar att sända
            move.b  d4,$10042           ; Skicka ut
            move.b  (a7)+,d5            ; Återställ d5
            rts

setuppia    move.b  #0,$10084           ; Välj datariktningsregistret (DDRA)
            move.b  #1,$10080           ; Sätt pinne 0 på PIAA som utgång
            move.b  #4,$10084           ; Välj in/utgångsregistret
            move.b  #0,$10086           ; Välj datariktningsregistret (DDRB)
            move.b  #0,$10082           ; Sätt alla pinnar som ingångar
            move.b  #4,$10086           ; Välj in/utgångsregistret
            rts

printstring move.b  (a4)+,d4
            jsr     printchar		; Printar den första bokstaven i ordet
            sub.b   #1,d5		; Minskar längden av ordet
            bne     printstring		; Loopar till nästa bokstav
            rts

   
deactivatealarm 			; Släcker lysdioden kopplad till PIAA
            move.b  #0,$10080           
            rts

   
activatealarm				; Tänder lysdioden kopplad till PIAA
            move.b  #1,$10080           
            rts

    					
getkey      btst    #4,$10082           ; Kollar om stroben är släckt
            beq     getkey              ; Om stroben är släckt, loopa
            move.b  $10082,d4           ; Om stroben är tänd, flytta inmatad tangent till d4
            and.b   #$F,d4              ; Maskar bort stroben
release     btst    #4,$10082           ; Kollar om stroben är tänd
            bne     release             ; Om stroben är tänd, loopar vi tills tangenten släppts
            rts

    
addkey      move.b  $4001,$4000		; Flyttar $4001-$4003 till $4000-$4002, d4 till $4003.
            move.b  $4002,$4001
            move.b  $4003,$4002
            move.b  d4,$4003
            rts

    
clearinput  move.l  #$FFFFFFFF,$4000	; Sätter innehållet på $4000-$4003 till $FF
            rts

validatecode   
	    move.l  $4000,d2            ; Flyttar inmatad kombination till d2
	    move.l  $4010,d3            ; Flyttar den rätta koden till d3
            cmp.l   d2,d3               ; Jämför inmatad kod mot rätt kod
            bne     notequal            ; Koden är fel, hoppa
            move.b  #1,d4               ; Koden är rätt, sätt en 1:a i d4
            rts
notequal    move.b  #0,d4               ; Fel kod sätter en 0:a i d4
            rts

