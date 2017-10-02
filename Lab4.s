;
; Spelet "Sänka fartyg"
; Labskelett att komplettera
; Version 1.1
; Programstrukturen är given. Några rutiner saknas.
; Det som måste kompletteras är markerat med '***'
; PIA:n skall anslutas/konfigureras enligt följande:

; PIAA 	b7-b6 A/D-omvandlare i X-led
; 		b5-b4 A/D-omvandlare i Y-led
; 		b3 Används inte
; 		b2-b0 Styr diodmatrisens multiplexingångar
;
; CA 	b2 Signal till högtalare
; 		b1 Avbrottssignal för MUX-rutinen
;
; PIAB 	b7 Används inte
; 		b6-b0 Diodmatrisens bitmönster
;
; CB 	b2 Starta omvandling hos A/D-omvandlare
; 		b1 Används inte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; jump to program
		jmp COLDSTART
		; game variables
		; define x- and y-coordinates of game area
		; movable cursor position
POSX 	dc.b 0 				; rightmost column (0..6)
POSY	dc.b 0 				; middle row (0..4)

		; fixed target position
TPOSX 	dc.b 0				; target position (0..6)
TPOSY 	dc.b 0 				; target position (0..4)

		; line shown for multiplexing
LINE 	dc.b 0 				; current line 0..4 shown on display

		; random number
RND 	dc.b 0 				; random number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COLDSTART

		*** ; set stack pointer
		jsr PIAINIT 		; setup I/O
		jsr INSTALLINTS 	; install and enable interrupts
							; short CB1 to GND for now unless
							; you really want interrupts
WARMSTART
		move.b #0,POSX 		; we always start from here
		move.b #2,POSY 		;
		jsr RANDOMTARGET 	; positon target
GAME
		; sense joystick and update POSX, POSY
		jsr JOYSTICK
		; update videomem with POSX, POSY and target
		jsr VIDEOINIT 		; clear it to draw a new frame
		move.b POSY,d0
		and.l #$000000ff,d0
		lea $900,a0
		add.l d0,a0
		move.b POSX,d0
		bset d0,(a0)
		; target position also
		move.b TPOSY,d0
		and.l #$7,d0
		lea $900,a0
		add.l d0,a0
		move.b TPOSX,d0
		bset d0,(a0)
		; wait a bit
		move.l #10000,d7
DLY		sub.l #1,d7
		bne DLY
		; analyze situation
		; we have a hit if POSX=TPOSX and POSY=TPOSY

*** skriv rutinen som kollar om vi har träff ***
*** om inte träff börjar programmet om från GAME ***

		; we have a hit! Sound the alarm!
		jsr BEEP
		; and restart
		jmp WARMSTART

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Joystick sensing routine
		; also sets X- and Y-coords
		;
JOYSTICK

*** starta en omvandling hos A/D-omvandlarna ***

XCOORD
		move.b $10080,d0 	; read both A/D:s

*** skriv kod som ökar eller minskar POSX beroende ***
*** på insignalen från A/D-omvandlaren i X-led ***

YCOORD
		move.b $10080,d0 	; what was it now again?

*** skriv kod som ökar eller minskar POSY beroende ***
*** på insignalen från A/D-omvandlaren i Y-led ***

		jsr LIMITS 			; bounds check before leaving
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; LIMITS keeps us from falling off the edge of the world
		; Allowed: 	POSX 0..6
		; 			POSY 0..4

LIMITS
		move.b POSX,d0 		; get current (updated) X-coord
		bpl LIM1 			; too much to right?
		move.b #0,POSX 		; not any longer
LIM1
		cmp.b #7,d0 		; too much to left?
		bne LIMY 			; nope, check Y-coord
		move.b #6,POSX 		; stick to left border
LIMY
		move.b POSY,d0 		; get current (updated) Y-coord
		bpl LIM2 			; below arena?
		move.b #0,POSY 		; keep on arena
LIM2
		cmp.b #5,d0 		; above arena?
		bne LIM_EXIT 		; no.
		move.b #4,POSY 		; keep on arena
LIM_EXIT
		; both coords within bounds here
		rts 				; done


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Interrupt routine for multiplexing
		; Installed as IRQA
		;
		
MUX

*** skriv rutin som handhar multiplexningen och ***
*** utskriften till diodmatrisen ***

		add.b #1,RND ; update random number
		rte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Videoinit clears video mem
		;

VIDEOINIT
		clr.b $900 			; clear memory
		clr.b $901 			; ... ditto
		clr.b $902 			;
		clr.b $903 			;
		clr.b $904 			; done
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Simple (crude!) random generator for target
		;
RANDOMTARGET
		move.b RND,d0 		; get random number
*** skriv kod som överför RND-värdet till önskat intervall ***
		move.b d0,TPOSX 	; TPOSX now in interval
		move.b RND,d0 		; get random number
*** skriv kod som överför RND-värdet till önskat intervall ***
		move.b d0,TPOSY
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Init PIA
		;
PIAINIT

*** skriv kod som initierar PIA:n ***

		rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;
		; Install and enable ints
		;
INSTALLINTS

*** skriv kod som installerar avbrottsrutinen och ***
*** sänker processorns IPL så att avbrott accepteras ***

		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		;
		; Make a silly sound
		;
BEEP

*** skriv kod för en utsignal med lämlig frekvens som ***
*** ska markera träff ***
		rts
		END


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












