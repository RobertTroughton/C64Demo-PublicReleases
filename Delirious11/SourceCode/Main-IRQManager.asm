
//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

* = IRQManager_BASE "IRQ Manager"

		jmp InitMainIRQRoutine
		jmp IRQList_RestoreDefault
		jmp IRQList_Set
		jmp IRQList_Next

//; IRQList_Next_RTI() -------------------------------------------------------------------------------------------------------
IRQList_Next_RTI:
		ldx #$00
		ldy Multiply4,x
		lda $d011
		and #$7f
	IRQList_Next_Index0:
		ora $ffff,y
		sta $d011
	IRQList_Next_Index1:
		lda $ffff + 1,y
		sta $d012
	IRQList_Next_Index2:
		lda $ffff + 2,y
		sta $fffe
	IRQList_Next_Index3:
		lda $ffff + 3,y
		sta $ffff
		lda #$01
		sta $d01a
		inx
	IRQList_Next_NumIRQs:
		cpx #$ff
		bne NotTheLast
		ldx #$00
	NotTheLast:
		stx IRQList_Next_RTI + 1
	
		asl $d019 //; Acknowledge VIC interrupts

	IRQList_RTS_Injection:
		lda	IRQ_RestoreA
		ldx IRQ_RestoreX
		ldy IRQ_RestoreY
		
		inc 0
		rti

		.print "* $" + toHexString(IRQList_Next_RTI) + "-$" + toHexString(EndIRQList_Next_RTI - 1) + " IRQList_Next_RTI"
EndIRQList_Next_RTI:

//; IRQList_Next() -------------------------------------------------------------------------------------------------------
IRQList_Next:
		lda #$60
		sta IRQList_RTS_Injection
		jsr IRQList_Next_RTI
		lda #$ad
		sta IRQList_RTS_Injection
		rts

		.print "* $" + toHexString(IRQList_Next) + "-$" + toHexString(EndIRQList_Next - 1) + " IRQList_Next"
EndIRQList_Next:


SpindleIRQInit:
//; Spindle by lft, www.linusakesson.net/software/spindle/
//; Prepare CIA #1 timer B to compensate for interrupt jitter.
//; Also initialise d01a and dc02.
//; This code is inlined into prgloader, and also into the
//; first effect driver by pefchain.
		bit	$d011
		bmi	*-3

		bit	$d011
		bpl	*-3

		ldx	$d012
		inx
resync:
		cpx	$d012
		bne	*-3
		//; at cycle 4 or later
		ldy	#0		//; 4
		sty	$dc07	//; 6
		lda	#62		//; 10
		sta	$dc06	//; 12
		iny			//; 16
		sty	$d01a	//; 18
		dey			//; 22
		dey			//; 24
		sty	$dc02	//; 26
		cmp	(0,x)	//; 30
		cmp	(0,x)	//; 36
		cmp	(0,x)	//; 42
		lda	#$11	//; 48
		sta	$dc0f	//; 50
		txa			//; 54
		inx			//; 56
		inx			//; 58
		cmp	$d012	//; 60	still on the same line?
		bne	resync
		rts
		
//; InitMainIRQRoutine() -------------------------------------------------------------------------------------------------------
InitMainIRQRoutine:
		jsr SpindleIRQInit

		lda #$7f
		sta $dc0d //; Turn off CIA 1 interrupts
		sta $dd0d //; Turn off CIA 2 interrupts
		lda $dc0d //; Acknowledge CIA 1 interrupts
		lda $dd0d //; Acknowledge CIA 2 interrupts

		lda #$01
		sta $d01a //; Turn on raster interrupts

		lda #$00
		sta Signal_VBlank
		
		lda #$1b
		sta ValueD011

		jmp IRQList_RestoreDefault

IRQList_RestoreDefault:
		sei
		lda ValueD011
		ora #$80
		sta $d011
		lda #$00
		sta $d012
		lda #<MainIRQRoutine
		sta $fffe
		lda #>MainIRQRoutine
		sta $ffff
		lda #$00
		sta Signal_VBlank
		cli
		rts

//; IRQList_Set() -------------------------------------------------------------------------------------------------------
IRQList_Set:

		sta IRQList_Next_NumIRQs + 1
		
		stx IRQList_Next_Index0 + 1
		sty IRQList_Next_Index0 + 2
		inx
		bne DontIncY0
		iny
	DontIncY0:
		stx IRQList_Next_Index1 + 1
		sty IRQList_Next_Index1 + 2
		inx
		bne DontIncY1
		iny
	DontIncY1:
		stx IRQList_Next_Index2 + 1
		sty IRQList_Next_Index2 + 2
		inx
		bne DontIncY2
		iny
	DontIncY2:
		stx IRQList_Next_Index3 + 1
		sty IRQList_Next_Index3 + 2
		
		lda #$00
		sta IRQList_Next_RTI + 1
		
		jmp IRQList_Next
	
		.print "* $" + toHexString(IRQList_Set) + "-$" + toHexString(EndIRQList_Set - 1) + " IRQList_Set"
EndIRQList_Set:
		
//; MainIRQRoutine() -------------------------------------------------------------------------------------------------------
MainIRQRoutine:
		dec 0
		sta IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
 		lda ValueD011
 		sta $d011
		lda ValueD018
 		sta $d018
 		lda ValueD016
 		sta $d016
 		lda ValueD021
 		sta $d021
 		lda ValueD022
 		sta $d022
 		lda ValueD023
 		sta $d023
 		lda ValueSpriteEnable
 		sta spriteEnable
		lda ValueDD02
		sta $dd02

		inc FrameOf256
		bne MI_Skip256Counter
		inc Frame_256Counter
	MI_Skip256Counter:
		lda FrameOf256
		and #$7F
		sta FrameOf128
		and #$3F
		sta FrameOf64
		and #$1f
		sta FrameOf32
		and #$0f
		sta FrameOf16
		and #$07
		sta FrameOf8
		and #$03
		sta FrameOf4
		and #$01
		sta FrameOf2

	 	jsr Music_Play

		lda #$01
		sta Signal_VBlank
		
		asl $d019 //; Acknowledge VIC interrupts
		lda IRQ_RestoreA
		ldx IRQ_RestoreX
		ldy IRQ_RestoreY
		inc 0
		rti


Multiply4:
		.byte $00,$04,$08,$0c,$10,$14,$18,$1c
		.byte $20,$24,$28,$2c,$30,$34,$38,$3c
