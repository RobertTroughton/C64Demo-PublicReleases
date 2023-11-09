.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\KefrensPlus\KefrensPlus.sym"

.const ToCol1		= $06
.const ToCol2		= $0e
.const RasterMs		= $00
.const RasterBr		= $fa

.const RasterLo		= $1a
.const RasterHi		= $1b
.const RasterTmp	= $1c

*=$4000 "Fade-in code"

KefrensFadeIn_Go:

		lda $d020
		sta FromCol +1
		lda #$06
		sta $d021

		ldx #$07
		lda #$00
		sta $3fff
	ClrCharLoop:
		sta $2000,x
		dex
		bpl	ClrCharLoop

		ldx #$00
	ClrScrLoop:
		lda #$00
		sta $0400,x
		sta $0500,x
		sta $0600,x
		sta $0700,x
		sta $3800,x
		sta $3900,x
		sta $3a00,x
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $db00,x
		//lda #$11			//#$20
		sta $3400,x
		sta $34b8,x
		sta $3630,x
		sta $36e8,x
		inx
		bne ClrScrLoop

		lda #$34
		sta RasterLo
		lda #$80
		sta RasterHi
		
		nsync()

		lda #$18
		sta $d018
		lda #$08
		sta $d016

		lda RasterLo
		sta $d012
		lda #<IRQUp
		sta $fffe
		lda #>IRQUp
		sta $ffff
		lda #$0b
		ora RasterHi
		sta $d011
		rts

IRQUp:	dec $00
		sta IRQUpA+1
		:compensateForJitter(1)
		stx IRQUpX+1
		sty IRQUpY+1

		nop $ea

		lda #ToCol1
		sta $d020

		lax RasterLo
		bne SkipUp0
		stx RasterHi
	SkipUp0:
		axs #$04
		stx RasterLo

		ldy RasterHi
		bne SetIRQMsUp
		cpx #$1c
		bcs SetIRQMsUp

	IRQUp_Play:

		inc MUSIC_FrameLo
		bne !+
		inc MUSIC_FrameHi

!:		jsr $f003

		lda RasterLo
		ora RasterHi
		cmp #$08
		bne SetIRQMsUp

		lda #<IRQRstr
		sta IRQLo+1
		lda #>IRQRstr
		sta IRQHi+1
		lda RasterLo
		sta RasterTmp
		lda #146
		sta RasterLo
		lda #$0b
		sta $d011
		lda #$06
		sta FromCol+1

	SetIRQMsUp:
		lda #$0b
		sta $d011
		lda #RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff

	IRQUpEnd:
		asl $d019
		inc $00
	IRQUpY:
		ldy #$00
	IRQUpX:
		ldx #$00
	IRQUpA:
		lda #$00
		rti

//--------------------------------------

IRQMs:	dec $00
		sta IRQMsA+1
		stx IRQMsX+1
		sty IRQMsY+1
	D011:
		lda #$0b
		ora RasterHi
		sta $d011

	FromCol:
		lda #$06
		sta $d020
		
		lda RasterLo
		ora RasterHi
		cmp #$20
		bcc SkipMusic

		inc MUSIC_FrameLo
		bne !+
		inc MUSIC_FrameHi

!:		jsr $f003
	
	SkipMusic:
		lda RasterLo
		sta $d012
	IRQLo:
		lda #<IRQUp
		sta $fffe
	IRQHi:
		lda #>IRQUp
		sta $ffff

		asl $d019
		inc $00

	IRQMsY:
		ldy #$00
	IRQMsX:
		ldx #$00
	IRQMsA:
		lda #$00
		rti

//--------------------------------------

.align $100

IRQRstr:
		dec $00
		sta IRQRstrA+1
		:compensateForJitter(1)
		stx IRQRstrX+1

		nop $ea
irrst0:
		ldx #$00
		lda ColTab,x
		sta $d020
		lda #$de
		sta $d018

		ldx #$09
		dex
		bne *-1
		nop $ea
		nop

		lda #$06
		sta $d020
		lda #$de
		sta $d018

		ldx irrst0+1
		cpx #$1f
		bne !+
		lda #<IRQOpen
		sta IRQLo+1
		lda #>IRQOpen
		sta IRQHi+1
		dec RasterLo

!:		inc irrst0+1

		lda #RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff
	
	IRQRstrDone:
		asl $d019
	IRQRstrX:
		ldx #$00
	IRQRstrA:
		lda #$00
		inc $00
		rti

ColTab:
.byte $06,$06,$06,$06,$06,$04,$04,$0e,$0e,$03,$03,$0d,$0d,$07,$07,$01
.byte $01,$07,$07,$0d,$0d,$03,$03,$0e,$0e,$04,$04,$06,$06,$00,$00,$00

//--------------------------------------

IRQOpen:
		dec $00
		sta IRQOpenA+1
		:compensateForJitter(1)
		stx IRQOpenX+1
		sty IRQOpenY+1
		nop $ea

		lda #$00
		sta $d020

		ldx #$0a
		dex
		bne *-1
		nop
		nop
iro00:	ldy #$01

		lda #$00
		sta $d020

		nop $ea

		jmp	!++
!:		cmp ($00,x)
		cmp ($00,x)
		nop $ea
		nop
!:		ldx #$08
		dex
		bne *-1
		dey
		bne !--
		cmp ($00,x)

		lda #$00
		sta $d020

		ldx #$0a
		dex
		bne *-1
		cmp ($00,x)

		lda #$06
		sta $d020

		lda RasterLo
		cmp #119
		bne !+
		lda #<IRQTxt
		sta IRQLo+1
		lda #>IRQTxt
		sta IRQHi+1
		lda #$1b
		sta D011+1
		lda #$de
		sta $d018
		jmp !++

!:		dec RasterLo
		inc iro00+1
		inc iro00+1

!:		lda #<RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff

	IRQOpenDone:
		asl $d019
	IRQOpenY:
		ldy #$00
	IRQOpenX:
		ldx #$00
	IRQOpenA:
		lda #$00
		inc $00
		rti

//--------------------------------------

.align $100

IRQTxt:
		dec $00
		sta IRQTxtA+1
		:compensateForJitter(1)
		stx IRQTxtX+1
		sty IRQTxtY+1
		nop $ea

		lda #$00
		sta $d020
		sta $d021
		lda #$de
		sta $d018

		ldx #$06
		dex
		bne *-1
		nop
		nop
		nop

		ldy #$00
		ldx #$dc
		lda RasterColTab,y
		stx $d018
		sty $d020
		sta $d021
		
		ldx $d012
!:		lda RasterColTab+1,y
		cpx $d012
		beq *-3
		sta $d021
		inx
		iny
		cpy #<RasterColors-RasterColTab
		bne !-

		lda #$00
		ldx #$de

		ldy #$be
		dey
		bne *-1
		nop

		stx $d018
		sta $d020
		sta $d021

		lda #$06
		
		ldx #$0a
		dex
		bne *-1
		nop
		
		sta $d020
		sta $d021

ColCtr:	ldx #$00
		cpx #$7e
		bne NextColor

		lda #<IRQClose
		sta IRQLo+1
		lda #>IRQClose
		sta IRQHi+1
		lda #$0b
		sta D011+1
		lda iro00+1
		sta irc00+1

NextColor:
		inc ColCtr+1

		ldx #$00
		ldy RasterColTab,x
!:		lda RasterColTab+1,x
		sta RasterColTab,x
		inx
		cpx #<RCEnd-RasterColTab
		bne !-
		sty RCEnd-1

ColorsDone:

		lda #<RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff

	IRQTxtDone:
		asl $d019
	IRQTxtY:
		ldy #$00
	IRQTxtX:
		ldx #$00
	IRQTxtA:
		lda #$00
		inc $00
		rti
		
RasterColTab:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
RasterColors:
.byte $0b,$0c,$0d,$0c,$0b,$06,$04,$0e,$05,$03,$0d,$01,$07,$0f,$0a,$08,$02,$09
.byte $0b,$0c,$0d,$0c,$0b,$06,$04,$0e,$05,$03,$0d,$01,$07,$0f,$0a,$08,$02,$09
.byte $0b,$0c,$0d,$0c,$0b,$06,$04,$0e,$05,$03,$0d,$01,$07,$0f,$0a,$08,$02,$09
.byte $0b,$0c,$0d,$0c,$0b,$06,$04,$0e,$05,$03,$0d,$01,$07,$0f,$0a,$08,$02,$09
.byte $0b,$0c,$0d,$0c,$0b,$06,$04,$0e,$05,$03,$0d,$01,$07,$0f,$0a,$08,$02,$09
RCEnd:

//--------------------------------------

IRQClose:
		dec $00
		sta IRQCloseA+1
		:compensateForJitter(1)
		stx IRQCloseX+1
		sty IRQCloseY+1
		nop $ea

		lda #$00
		sta $d020

		ldx #$0a
		dex
		bne *-1
		nop
		nop
irc00:	ldy #$01

		lda #$00
		sta $d020

		nop $ea

		jmp	!++
!:		cmp ($00,x)
		cmp ($00,x)
		nop $ea
		nop
!:		ldx #$08
		dex
		bne *-1
		dey
		bne !--
		cmp ($00,x)

		lda #$00
		sta $d020

		ldx #$0a
		dex
		bne *-1
		cmp ($00,x)

		lda #$06
		sta $d020

		lda RasterLo
		cmp #145
		bne !+
		lda #<IRQRstO
		sta IRQLo+1
		lda #>IRQRstO
		sta IRQHi+1
		lda #$0b
		sta D011+1

!:		inc RasterLo
		dec irc00+1
		dec irc00+1

!:		lda #<RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff

	IRQCloseDone:
		asl $d019
	IRQCloseY:
		ldy #$00
	IRQCloseX:
		ldx #$00
	IRQCloseA:
		lda #$00
		inc $00
		rti

//--------------------------------------

IRQRstO:
		dec $00
		sta IRQRstOA+1
		:compensateForJitter(1)
		stx IRQRstOX+1

		nop $ea
irrso0:
		ldx #$1f
		lda ColTabO,x
		sta $d020
		lda #$de
		lda $d018

		ldx #$09
		dex
		bne *-1
		nop $ea
		nop

		lda #$06
		sta $d020
		lda #$de
		lda $d018

		ldx irrso0+1
		bne !+
		lda #<IRQDn
		sta IRQLo+1
		lda #>IRQDn
		sta IRQHi+1
		lda #ToCol2
		sta FromCol+1
		lda RasterTmp
		sta RasterLo
		lda #$18
		sta $d018
		
		inc PART_Done

!:		dec irrso0+1

		lda #RasterMs
		sta $d012
		lda #<IRQMs
		sta $fffe
		lda #>IRQMs
		sta $ffff
	
	IRQRstODone:
		asl $d019
	IRQRstOX:
		ldx #$00
	IRQRstOA:
		lda #$00
		inc $00
		rti

ColTabO:
.byte $06,$06,$06,$06,$06,$04,$04,$0e,$0e,$03,$03,$0d,$0d,$07,$07,$01
.byte $01,$07,$07,$0d,$0d,$03,$03,$0e,$0e,$04,$04,$06,$06,$00,$00,$00

//--------------------------------------

* = $2600 "IntroFinish"

IRQDn:	dec $00
		sta IRQDnA+1
		:compensateForJitter(1)
		stx IRQDnX+1
		sty IRQDnY+1

		nop $ea
	ColDn:
		lda #ToCol1
		sta $d020
		sta $d021

		lax RasterLo
	RasterInc:
		axs #$fc
		stx RasterLo
		bne SkipDn0
		lda #$80
		sta RasterHi
	SkipDn0:

		ldy RasterHi
		bne SetIRQMsDn
		cpx #$24
		bcs SetIRQMsDn

		inc MUSIC_FrameLo
		bne !+
		inc MUSIC_FrameHi

!:		jsr $f003

	SetIRQMsDn:
		lda	RasterHi
		bmi	SetIRQMs2
		lda RasterLo
		cmp	#$fc
		beq OpenBorder
		bcs SetIRQMs2

	SetIRQBr_Dn:
		lda #<IRQBr
		ldx #>IRQBr
		ldy #RasterBr
		jmp IRQDnDone
	
	OpenBorder:
		lda	$d011
		and	#$77
		sta $d011
		jmp	SetIRQMs3
		
	SetIRQMs2:
		lda	$d011
		and	#$77
		ora #$18
		sta $d011
	SetIRQMs3:
		lda #<IRQMs2
		ldx #>IRQMs2
		ldy #RasterMs
		
	IRQDnDone:
		sta $fffe
		stx $ffff
		sty $d012
		jmp FinishIRQDn

//--------------------------------------
* = $2700

IRQMs2:	sta IRQMs2A+1
		stx IRQMs2X+1
		sty IRQMs2Y+1
		dec $00

		lda #$1b
		sta $d011

		lda #ToCol1
		sta $d020
		lda #ToCol2
		sta $d021
		
		lda RasterLo
		ora RasterHi
		cmp #$20
		bcc SkipMusic2

		inc MUSIC_FrameLo
		bne !+
		inc MUSIC_FrameHi

!:		jsr $f003
	
	SkipMusic2:
		lda	RasterHi
		bmi	SetIRQBr
		lda	RasterLo
		cmp	#$fc
		bcs	SetIRQBr
		
		lda #<IRQDn					//IRQDn raster < #$fc, it preceds IRQBr, next IRQ is IRQDn
		ldx #>IRQDn
		ldy RasterLo
		jmp IRQMs2Done

	SetIRQBr:
	IRQBrLo:
		lda	#<IRQBr					//IRQDn raster >= #$fc, it follows IRQBr, next IRQ is IRQBr
	IRQBrHi:
		ldx #>IRQBr
		ldy	#RasterBr

	IRQMs2Done:
		sta $fffe
		stx $ffff
		sty $d012

		asl $d019
		inc $00
	IRQMs2Y:
		ldy #$00
	IRQMs2X:
		ldx #$00
	IRQMs2A:
		lda #$00
		rti

//--------------------------------------

IRQBr:	sta IRQBrA+1
		stx IRQBrX+1
		sty IRQBrY+1
		dec $00
		
		lda	$d011
		and	#$77
		ora	RasterHi
		sta $d011
		
		lda	RasterHi
		bmi	SetIRQDn_Br
		lda	RasterLo
		cmp	#$fc
		beq	SetIRQDn_Br

		lda	#<IRQMs2			//IRQDn raster < #$fc, it preceded IRQBr, next IRQ is IRQMs2
		ldx	#>IRQMs2
		ldy	#<RasterMs
		jmp IRQBrDone
	
	SetIRQDn_Br:				//IRQDn raster >= #$fc, it follows IRQBr, next IRQ is IRQDn
		jmp FinishIRQBr

//--------------------------------------
 * = $2800

IRQBr2:	sta IRQBr2A+1
		dec $00

		lda	$d011
		and	#$77
		sta $d011
		
		lda	#<IRQMs2			//IRQDn raster < #$fc, it preceded IRQBr, next IRQ is IRQMs2
		sta	$fffe
		lda	#>IRQMs2
		sta $ffff
		lda	#<RasterMs
		sta $d012
		
		asl $d019
		inc $00

	IRQBr2A:
		lda #$00
		rti

FinishIRQDn:

		lda RasterHi
		beq IRQDnEnd
		lda RasterLo
		cmp #$30
		bcc IRQDnEnd

		inc PART_Done
		lda #$00
		sta RasterInc+1
		lda	#<IRQBr2
		sta	IRQBrLo+1
		lda	#>IRQBr2
		sta	IRQBrHi+1

	IRQDnEnd:
		asl $d019
		inc $00
	IRQDnY:
		ldy #$00
	IRQDnX:
		ldx #$00
	IRQDnA:
		lda #$00
		rti

FinishIRQBr:
		lda	RasterHi
		ora	$d011
		sta $d011
		lda	#<IRQDn
		ldx #>IRQDn
		ldy RasterLo
	IRQBrDone:
		sta	$fffe
		stx $ffff
		sty $d012
		
		asl $d019
		inc $00
	IRQBrY:
		ldy #$00
	IRQBrX:
		ldx #$00
	IRQBrA:
		lda #$00
		rti
