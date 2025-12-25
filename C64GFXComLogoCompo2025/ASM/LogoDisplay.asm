//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* = $e800 "main"

		jmp Entry
		
.import source "sparkle.inc"

.import source "picdata.inc"

.import source "dali.inc"

.import source "GPLogoData.inc"

	.var MusicInit = $1000
	.var MusicPlay = $1003

	.var COLData0 = $ac00
	.var COLData1 = $bc00

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

	INITIAL_D000Values:

		.byte $cc, 250 - 21							//; D000-1: VIC_Sprite0X, Y
		.byte $e4, 250 - 21							//; D002-3: VIC_Sprite1X, Y
		.byte $fc, 250 - 21							//; D004-5: VIC_Sprite2X, Y
		.byte $14, 250 - 21							//; D006-7: VIC_Sprite3X, Y
		.byte $2c, 250 - 21							//; D008-9: VIC_Sprite4X, Y
		.byte $c0, 250 - 21							//; D00A-B: VIC_Sprite5X, Y
		.byte $f0, 250 - 21							//; D00C-D: VIC_Sprite6X, Y
		.byte $20, 250 - 21							//; D00E-F: VIC_Sprite7X, Y
		.byte $98									//; D010: VIC_SpriteXMSB
		.byte D000_SkipValue						//; D011: VIC_D011
		.byte D000_SkipValue						//; D012: VIC_D012
		.byte D000_SkipValue						//; D013: VIC_LightPenX
		.byte D000_SkipValue						//; D014: VIC_LightPenY
		.byte $00									//; D015: VIC_SpriteEnable
		.byte D000_SkipValue						//; D016: VIC_D016
		.byte $00									//; D017: VIC_SpriteDoubleHeight
		.byte D000_SkipValue						//; D018: VIC_D018
		.byte D000_SkipValue						//; D019: VIC_D019
		.byte D000_SkipValue						//; D01A: VIC_D01A
		.byte $00									//; D01B: VIC_SpriteDrawPriority
		.byte $00									//; D01C: VIC_SpriteMulticolourMode
		.byte $e0									//; D01D: VIC_SpriteDoubleWidth
		.byte $00									//; D01E: VIC_SpriteSpriteCollision
		.byte $00									//; D01F: VIC_SpriteBackgroundCollision
		.byte D000_SkipValue						//; D020: VIC_BorderColour
		.byte $00									//; D021: VIC_ScreenColour
		.byte D000_SkipValue						//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
		.byte D000_SkipValue						//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
		.byte D000_SkipValue						//; D024: VIC_ExtraBackgroundColour2
		.byte D000_SkipValue						//; D025: VIC_SpriteExtraColour0
		.byte D000_SkipValue						//; D026: VIC_SpriteExtraColour1
		.byte $01									//; D027: VIC_Sprite0Colour
		.byte $01									//; D028: VIC_Sprite1Colour
		.byte $01									//; D029: VIC_Sprite2Colour
		.byte $01									//; D02A: VIC_Sprite3Colour
		.byte $01									//; D02B: VIC_Sprite4Colour
		.byte $00									//; D02C: VIC_Sprite5Colour
		.byte $00									//; D02D: VIC_Sprite6Colour
		.byte $00									//; D02E: VIC_Sprite7Colour
		
	D018Values:			.byte $a8, $ec, $a4, $e4, $a6, $e6
		
	SpriteValsToSet0:	.byte $35, $36, $37, $38, $39, $3f, $3f, $3f
	SpriteValsToSet1:	.byte $3a, $3b, $3c, $3d, $3e, $3f, $3f, $3f
		
	LastLoadIndex:		.byte $ff
	
	LogoFrame0_Lo:		.byte $00
	LogoFrame1_Lo:		.byte $c0
	LogoFrame2_Lo:		.byte $60
	LogoFrame0_Hi:		.byte $01
	LogoFrame1_Hi:		.byte $00
	LogoFrame2_Hi:		.byte $00

	FrameCounterLo: 	.byte $00
	FrameCounterHi: 	.byte $00
	D011Current:		.byte $ff
	D020Current:		.byte $ff
	
	SpriteSinTable:		.fill 32, 0
						.fill 96, 250-40*sin(toRadians(i/96*180))
						.fill 128, 0
						
	LogoDB:				.byte $00
	
	LogoDisplayDir:		.byte $00
	
	D011Value:			.byte $00
	D016Value0:			.byte $00
	D016Value1:			.byte $00
	D016Value2:			.byte $00
	D020Value:			.byte $00
	D021Value:			.byte $00
	D022Value:			.byte $00
	D023Value:			.byte $00
	D024Value:			.byte $00

	D021Value1:			.byte $00
	D021Value2:			.byte $00
	D021Value3:			.byte $00
	
	Screen0FadeA:		.byte $00, $00, $00, $0b
	Screen0FadeB:		.byte $00, $00, $0b, $0c
	Screen0FadeC:		.byte $00, $0b, $0c, $0f

	Screen1FadeA:		.byte $00, $00, $00, $0b
	Screen1FadeB:		.byte $06, $0e, $03, $01
	Screen1FadeC1:		.byte $00, $06, $0e, $03
	Screen1FadeC2:		.byte $00, $02, $0a, $07
	Screen1FadeC3:		.byte $00, $00, $09, $05

	Screen2Fade:		.byte $09, $05, $0d, $01
	
	ShouldDrawLogo:		.byte $00
	Logo0_XSin:			.byte $00
	Logo1_XSin:			.byte $00
	Logo2_XSin:			.byte $00

	FinishedIntroScreens:	.byte $00


//; Entry() -------------------------------------------------------------------------------------------------------

	Entry:
	
		sei
 
	!wait:
		lda $d011
		bpl !wait-
	!wait:
		lda $d011
		bmi !wait-
		
		lda #$00
		sta $d011
		sta $d020
		jsr MusicInit
		sei

	!wait:
		lda $d011
		bpl !wait-
	!wait:
		lda $d011
		bmi !wait-

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta $d000, y
	SkipThisOne:
		dey
		bpl !Loop-
		
//; new version
		lda #$7f
		sta $dc0d //; Turn off CIA 1 interrupts
		sta $dd0d //; Turn off CIA 2 interrupts
		lda $dc0d //; Acknowledge CIA 1 interrupts
		lda $dd0d //; Acknowledge CIA 2 interrupts

		lda #$3e
		sta $dd02

		lda #$00
		sta	$d012
		lda	#<MainIRQ
		sta	$fffe
		lda	#>MainIRQ
		sta	$ffff

		lda #$01
		sta $d01a
		asl $d019
		cli
		
		ldy #$00
		lda #$00
	!loop:
		.for (var i = 0; i < 4; i++)
		{
			sta $b800 + (i * $100), y
		}
		iny
		bne !loop-

		lda #$08
		jsr FillColData
		lda #$00
		sta D020Value

		lda #$ec
		sta $d018
		lda #$18
		sta D016Value0
		sta D016Value1
		sta D016Value2
		lda #$00
		sta D021Value
		sta D022Value
		sta D023Value
		lda #$1b
		sta D011Value

		lda #$60
		jsr FrameDelay

		inc ShouldDrawLogo

	!wait:
		lda FrameCounterHi
		bne !finished+

		lda #$0b
		sta D022Value
		lda #$0c
		sta D023Value
		lda #$0f
		sta D021Value
		jmp !wait-

	!finished:
		
		lda #$00
		jsr SetD011AndWait
		
		dec ShouldDrawLogo

		lda #$40
		jsr FrameDelay
		
		lda #$a8
		sta $d018
		lda #$1b
		sta D011Value
		lda #$18
		sta D016Value0

	!wait:
		lda FrameCounterHi
		bne !finished+

		lda FrameCounterLo
		cmp #$10
		bcc !fadeIn+
		cmp #$f0
		bcc !wait-
		eor #$ff
	!fadeIn:
		and #$0f
		lsr
		lsr
		tax
		lda Screen1FadeA, x
		sta D022Value
		lda Screen1FadeB, x
		sta D023Value
		lda Screen1FadeC1, x
		sta D021Value1
		lda Screen1FadeC2, x
		sta D021Value2
		lda Screen1FadeC3, x
		sta D021Value3
		jmp !wait-
	!finished:
		
		lda #$00
		jsr SetD011AndWait
		
		lda #$40
		jsr FrameDelay
		
		lda #$00
		jsr FillColData
		lda #$20
		sta $d018
		lda #$08
		sta D016Value0
		lda #$1b
		sta D011Value

		jsr ClearFrameCounters

		inc FinishedIntroScreens

	!wait:
		lda FrameCounterLo
		cmp #$10
		bcs !finished+
		lsr
		lsr
		tax
		lda Screen2Fade, x
		sta D021Value
		jmp !wait-
	!finished:
		
	!wait:
		lda #$7f
		sta $dc00
		lda $dc01
		and #$09
		cmp #$09
		beq !wait-
		
		ldx #$00
		ldy #00
	
		cmp #$08
		beq !skip+

		ldx #$01
		ldy #NumLogos - 1

	!skip:
		stx LogoDisplayDir
		sty LogoIndex + 1

		jsr ClearFrameCounters

	!wait:
		lda FrameCounterLo
		cmp #$10
		bcs !finished+
		eor #$0f
		lsr
		lsr
		tax
		lda Screen2Fade, x
		sta D021Value
		jmp !wait-
	
	!finished:

	OuterLoop:
	
		lda #$00
		sta D020Value
		jsr SetD011AndWait
		
		lda #$ff
		sta $d015
		
		jsr ClearFrameCounters
		
	LogoIndex:
		lda #0
		and #1
		sta LogoDB

		lda LogoIndex + 1
		lsr
		sta DALIIndex + 1
		clc
		adc #1
		cmp LastLoadIndex
		beq !skipLoad+
		sta LastLoadIndex

		jsr LoadFile

	DALIIndex:	
		ldx #$00
		lda DALIAddrLo, x
		sta $f1
		lda DALIAddrHi, x
		sta $f2
		lda #$00
		sta $f3
		lda #$a0
		sta $f4
		jsr DaliDecompress
		
		ldy #$07
	!loop:
		lda SpriteValsToSet0, y
		sta $abf8, y
		lda SpriteValsToSet1, y
		sta $bbf8, y
		dey
		bpl !loop-

	!skipLoad:
	
		lda #$50
		jsr FrameDelay_NoClear

		lda LogoDB
		bne SecondBuffer
		
		jsr UpdateColData0
		jmp DoWait
		
	SecondBuffer:
		jsr UpdateColData1
		
	DoWait:

		ldx LogoIndex + 1
		lda D020Values, x
		sta D020Value
		lda D011Values, x
		sta D011Value

		lda D016Values, x
		sta D016Value0
		lda D021Values, x
		sta D021Value
		lda D022Values, x
		sta D022Value
		lda D023Values, x
		sta D023Value
		lda D024Values, x
		sta D024Value
		
		lda D018Indices, x
		ora LogoDB
		tay
		lda D018Values, y
		sta $d018

		lda #$c0
		jsr FrameDelay
		
		lda LogoDisplayDir
		bne LogoBackwards
		
		ldx LogoIndex + 1
		inx
		cpx #NumLogos
		bne !skip+
		ldx #0
	!skip:
		stx LogoIndex + 1

		jmp OuterLoop

	LogoBackwards:

		ldx LogoIndex + 1
		dex
		cpx #$ff
		bne !skip+
		ldx #NumLogos - 1
	!skip:
		stx LogoIndex + 1

		jmp OuterLoop
		
MainIRQ:

		pha
		txa
		pha
		tya
		pha
		
		lda D011Value
		sta $d011
		sta D011Current

		lda D016Value0
		sta $d016

		lda D020Value
		sta $d020
		lda D021Value
		sta $d021
		lda D022Value
		sta $d022
		lda D023Value
		sta $d023
		lda D024Value
		sta $d024
		
		ldx FrameCounterLo
		lda SpriteSinTable, x
		ldy #$0e
	!loop:
		sta $d001, y
		dey
		dey
		bpl !loop-
		
		jsr MusicPlay

		lda ShouldDrawLogo
		bne drawLogo
		jmp secondLogoIRQ

	drawLogo:

		jsr DrawLogo_Part2
		
		lda #50 + (6 * 8) + 1
	!wait:
		cmp $d012
		bne !wait-

		lda D016Value1
		sta $d016
		
		jsr DrawLogo_Part3

		lda #50 + (14 * 8) + 1
	!wait:
		cmp $d012
		bne !wait-

		lda D016Value2
		sta $d016

		lda LogoFrame0_Hi
		cmp #$01
		bne !skip+
		ldy LogoFrame0_Lo
		lda LogoSinValsLo, y
		ora #$10
		sta D016Value0
		lda LogoSinValsHi, y
		sta Logo0_XSin
	!skip:
		inc LogoFrame0_Lo
		bne !skip+
		inc LogoFrame0_Hi
	!skip:

		lda LogoFrame1_Hi
		cmp #$01
		bne !skip+
		ldy LogoFrame1_Lo
		lda LogoSinValsLo, y
		ora #$10
		sta D016Value1
		lda LogoSinValsHi, y
		sta Logo1_XSin
	!skip:
		inc LogoFrame1_Lo
		bne !skip+
		inc LogoFrame1_Hi
	!skip:

		lda LogoFrame2_Hi
		cmp #$01
		bne !skip+
		ldy LogoFrame2_Lo
		lda LogoSinValsLo, y
		ora #$10
		sta D016Value2
		lda LogoSinValsHi, y
		sta Logo2_XSin
	!skip:
		inc LogoFrame2_Lo
		bne !skip+
		inc LogoFrame2_Hi
	!skip:
		
		jsr DrawLogo_Part1

		ldx #$00
		lda LogoFrame2_Hi
		beq !skip+
		sec
		sbc #1
		ldx LogoFrame2_Lo
	!skip:
		sta FrameCounterHi
		stx FrameCounterLo
		jmp !skip+

	skipLogoDraw:
	
		inc FrameCounterLo
		bne !skip+
		inc FrameCounterHi
	!skip:
	
		pla
		tay
		pla
		tax
		pla
		
		asl $d019
		
		rti

secondLogoIRQ:

		lda FinishedIntroScreens
		beq !doSplits+

		lda D021Value
		sta $d021
		jmp skipLogoDraw

	!doSplits:

		lda D021Value1
		sta $d021

		lda #50 + 117
	!wait:
		cmp $d012
		bne !wait-

		lda D021Value2
		sta $d021

		lda #50 + 149
	!wait:
		cmp $d012
		bne !wait-

		lda D021Value3
		sta $d021

		jmp skipLogoDraw


UpdateColData0:

		ldy #$00
	!loop:
		.for (var i = 0; i < 4; i++)
		{
			lda COLData0 + (i * $100), y
			sta $d800 + (i * $100), y
		}
		iny
		bne !loop-
		
		rts
		
UpdateColData1:

		ldy #$00
	!loop:
		.for (var i = 0; i < 4; i++)
		{
			lda COLData1 + (i * $100), y
			sta $d800 + (i * $100), y
		}
		iny
		bne !loop-
		
		rts		
		
FillColData:

		ldy #$00
	!loop:
		.for (var i = 0; i < 4; i++)
		{
			sta $d800 + (i * $100), y
		}
		iny
		bne !loop-
		
		rts
		
FrameDelay:

		jsr ClearFrameCounters

	FrameDelay_NoClear:
	
	!wait:
		cmp FrameCounterLo
		bcs !wait-
		
	ClearFrameCounters:
		ldx #$00
		stx FrameCounterLo
		stx FrameCounterHi
		
		rts
		
SetD011AndWait:

		sta D011Value
		
	!wait:
		cmp D011Current
		bne !wait-
		
		rts

DrawLogo_Part1:

		ldy Logo0_XSin
		ldx #0
	!loop:
		lda Logo_Line0, y
		sta $b800 + (0 * 40), x
		lda Logo_Line1, y
		sta $b800 + (1 * 40), x
		lda Logo_Line2, y
		sta $b800 + (2 * 40), x
		lda Logo_Line3, y
		sta $b800 + (3 * 40), x
		lda Logo_Line4, y
		sta $b800 + (4 * 40), x
		lda Logo_Line5, y
		sta $b800 + (5 * 40), x
		iny
		inx
		cpx #39
		bne !loop-

		rts
		
DrawLogo_Part2:

		ldy Logo1_XSin
		ldx #0
	!loop:
		lda Logo_Line7, y
		sta $b800 + (7 * 40), x
		lda Logo_Line8, y
		sta $b800 + (8 * 40), x
		lda Logo_Line9, y
		sta $b800 + (9 * 40), x
		lda Logo_Line10, y
		sta $b800 + (10 * 40), x
		lda Logo_Line11, y
		sta $b800 + (11 * 40), x
		lda Logo_Line12, y
		sta $b800 + (12 * 40), x
		iny
		inx
		cpx #39
		bne !loop-

		rts
		
DrawLogo_Part3:

		ldy Logo2_XSin
		ldx #0
	!loop:
		lda Logo_Line18, y
		sta $b800 + (18 * 40), x
		lda Logo_Line19, y
		sta $b800 + (19 * 40), x
		lda Logo_Line20, y
		sta $b800 + (20 * 40), x
		lda Logo_Line21, y
		sta $b800 + (21 * 40), x
		lda Logo_Line22, y
		sta $b800 + (22 * 40), x
		lda Logo_Line23, y
		sta $b800 + (23 * 40), x
		iny
		inx
		cpx #39
		bne !loop-
		
		rts

LoadFile:
		tax
		dex
	BundleCounter:
		cpx #$ff
		sta BundleCounter + 1
		beq LoadNext
		jmp Sparkle_LoadA
	LoadNext:
		jmp Sparkle_LoadNext