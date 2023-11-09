//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "TinyCircleScrollbase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0280-$03ff Sparkle (ALWAYS)
//; - $0400-04ff SinTable
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-67ff Code
//; - $a800-afff FontData
//; - $b800-b8ff Sprite X Sintables
//; - $b900-bfff Scrolltext
//; - $c000-c3ff Screen 0
//; - $c400-c7ff Screen 1
//; - $c800-cbff Screen 2
//; - $cc00-cfff Screen 3
//; - $d000-dbff Sprites
//; - $e000-e3ff Screen 4
//; - $e400-e7ff Screen 5
//; - $e800-ebff Screen 6
//; - $ec00-efff Screen 7
//; - $f000-f3ff Screen 8
//; - $f400-f7ff Screen 9
//; ---- $f800-ffff CharSet

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank0 =  0 //; Bank+[0000,03ff]
	.var ScreenBank1 =  1 //; Bank+[0400,07ff]
	.var ScreenBank2 =  2 //; Bank+[0800,0bff]
	.var ScreenBank3 =  3 //; Bank+[0c00,0fff]
	.var ScreenBank4 =  8 //; Bank+[2000,23ff]
	.var ScreenBank5 =  9 //; Bank+[2400,27ff]
	.var ScreenBank6 =  10 //; Bank+[2800,2bff]
	.var ScreenBank7 =  11 //; Bank+[2c00,2fff]
	.var ScreenBank8 =  12 //; Bank+[3000,33ff]
	.var ScreenBank9 =  13 //; Bank+[3400,37ff]
	.var CharBank0 = 7 //; Bank+[3800,3fff]
	.var ScreenAddress0 = Base_BankAddress0 + ScreenBank0 * $400
	.var ScreenAddress1 = Base_BankAddress0 + ScreenBank1 * $400
	.var ScreenAddress2 = Base_BankAddress0 + ScreenBank2 * $400
	.var ScreenAddress3 = Base_BankAddress0 + ScreenBank3 * $400
	.var ScreenAddress4 = Base_BankAddress0 + ScreenBank4 * $400
	.var ScreenAddress5 = Base_BankAddress0 + ScreenBank5 * $400
	.var ScreenAddress6 = Base_BankAddress0 + ScreenBank6 * $400
	.var ScreenAddress7 = Base_BankAddress0 + ScreenBank7 * $400
	.var ScreenAddress8 = Base_BankAddress0 + ScreenBank8 * $400
	.var ScreenAddress9 = Base_BankAddress0 + ScreenBank9 * $400
	.var CharAddress0 = Base_BankAddress0 + CharBank0 * $800
	.var SpriteVals0	= ScreenAddress0 + $3f8
	.var SpriteVals1	= ScreenAddress1 + $3f8
	.var SpriteVals2	= ScreenAddress2 + $3f8
	.var SpriteVals3	= ScreenAddress3 + $3f8
	.var SpriteVals4	= ScreenAddress4 + $3f8
	.var SpriteVals5	= ScreenAddress5 + $3f8
	.var SpriteVals6	= ScreenAddress6 + $3f8
	.var SpriteVals7	= ScreenAddress7 + $3f8
	.var SpriteVals8	= ScreenAddress8 + $3f8
	.var SpriteVals9	= ScreenAddress9 + $3f8
	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank1 * 16) + (CharBank0 * 2)
	.var D018Value2 = (ScreenBank2 * 16) + (CharBank0 * 2)
	.var D018Value3 = (ScreenBank3 * 16) + (CharBank0 * 2)
	.var D018Value4 = (ScreenBank4 * 16) + (CharBank0 * 2)
	.var D018Value5 = (ScreenBank5 * 16) + (CharBank0 * 2)
	.var D018Value6 = (ScreenBank6 * 16) + (CharBank0 * 2)
	.var D018Value7 = (ScreenBank7 * 16) + (CharBank0 * 2)
	.var D018Value8 = (ScreenBank8 * 16) + (CharBank0 * 2)
	.var D018Value9 = (ScreenBank9 * 16) + (CharBank0 * 2)

	.var FontWriteAddress = CharAddress0

	.var D016_Value_40Cols = $08

	.var NUM_CHARS = 128

	.var SinTable = $0400
	.var SinTableLen = 128
	.var ScrollText = $b900

	.var Sprite0XSin = $b800
	.var SpriteXMSBSin = Sprite0XSin + 128

	.var ScreenColour = $0b
	.var BackgroundSpriteColour = $0d
	.var BackgroundSpriteColour2 = $03

	.label Decompress = $b000

	.var FONTBIN_ADDR = $a800

	.var SIDVolume_ADDR	= $1018

	.var ZP_ScreenSRC = $40
	.var ZP_ScreenDST = $48

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $00									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Cols						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $ff									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte ScreenColour							//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $00									//; D029: VIC_Sprite2Colour
	.byte $00									//; D02A: VIC_Sprite3Colour
	.byte $00									//; D02B: VIC_Sprite4Colour
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

FrameCounterLo:								.byte $00
FrameCounterHi:								.byte $00

D018Values:			.byte	D018Value0, D018Value1, D018Value2, D018Value3, D018Value4, D018Value5, D018Value6, D018Value7, D018Value8, D018Value9
D011Values:			.fill 8, $17 - i
D016Values:			.fill 8, $07 - i
SpriteValsPtrHi:		.byte >SpriteVals0, >SpriteVals1, >SpriteVals2, >SpriteVals3, >SpriteVals4, >SpriteVals5, >SpriteVals6, >SpriteVals7, >SpriteVals8, >SpriteVals9

.var NumSpriteRows = 4
SpriteYValues:		.fill NumSpriteRows, 108 + (i * 21)
SpriteValues:		.fill NumSpriteRows, $44 + (i * 8)
D012Values:			.fill NumSpriteRows, 108 + (i * 20) + 15
NextXModded:		.fill NumSpriteRows, i + 1
					.byte 0

SpriteCols_Text:
					.fill 17, ScreenColour
					.byte $04, $0e, $03, $0d, $01
					.fill 36, $0d
					.byte $01, $0d, $03, $0e, $04
					.fill 17, ScreenColour

ScreenAddresses_Hi:
		.byte >ScreenAddress0, >ScreenAddress1, >ScreenAddress2, >ScreenAddress3, >ScreenAddress4, >ScreenAddress5, >ScreenAddress6, >ScreenAddress7, >ScreenAddress8, >ScreenAddress9





.import source "../../Build/6502/TinyCircleScroll/FontData.asm"
.import source "../../Build/6502/TinyCircleScroll/PlotCode.asm"
.import source "../../Build/6502/TinyCircleScroll/UpdatePlot.asm"






//; TinyCircleScroll_Go() -------------------------------------------------------------------------------------------------------
TinyCircleScroll_Go:

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #$00
	FillCharMemory:
		sta CharAddress0 + (0 * 256), y
		sta CharAddress0 + (1 * 256), y
		sta CharAddress0 + (2 * 256), y
		sta CharAddress0 + (3 * 256), y
		sta CharAddress0 + (4 * 256), y
		sta CharAddress0 + (5 * 256), y
		sta CharAddress0 + (6 * 256), y
		iny
		bne FillCharMemory

		jsr SetupScreens

		ldy #$00
		lda #$01
	FillColMemory:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillColMemory

		jsr ShiftFontData

		vsync()

		sei

		lda #ScreenColour
		sta VIC_BorderColour

//; play the music for a few frames, easing it toward the right rasterline
	!vb:
		bit VIC_D011
		bpl !vb-
	!wait:
		lda #$20
		cmp VIC_D012
		bne !wait-
		jsr BASE_PlayMusic	//; call 0 at $120
	!vb:
		bit VIC_D011
		bmi !vb-
	!vb:
		bit VIC_D011
		bpl !vb-
	!wait:
		lda #$00
		cmp VIC_D012
		bne !wait-
		jsr BASE_PlayMusic	//; call 1 at $100
	!vb:
		bit VIC_D011
		bmi !vb-
	!wait:
		lda #233
		cmp VIC_D012
		bne !wait-
		jsr BASE_PlayMusic	//; call 2 at $e9

		sei

		lda #210
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #$13
		sta VIC_D011

		rts

//; DoMainScreenUpdate() -------------------------------------------------------------------------------------------------------
DoMainScreenUpdate:

		ldy FrameCounterLo
		lda SinTable, y
		and #$07
		tax
		lda D011Values, x
		sta VIC_D011
		lda D016Values, x
		sta VIC_D016

		lda SinTable, y
		lsr
		lsr
		lsr
		tax
		lda D018Values, x
		sta VIC_D018
		lda SpriteValsPtrHi, x
		.for (var i = 0; i < 4; i++)
		{
			sta SpriteValPtrsLoop + (i * 7) + 2
			sta SpriteValPtrsLoop + (i * 7) + 5
			sta SpriteValPtrs_Disk + (i * 4) + 2
		}

		lda FrameCounterLo
		and #$7f
		tay
		
		lda Sprite0XSin, y
		sta VIC_Sprite0X
		clc
		adc #$18
		sta VIC_Sprite1X
		clc
		adc #$18
		sta VIC_Sprite2X
		clc
		adc #$18
		sta VIC_Sprite3X
		clc
		adc #$18
		sta VIC_Sprite4X
		clc
		adc #$18
		sta VIC_Sprite5X
		clc
		adc #$18
		sta VIC_Sprite6X
		clc
		adc #$18
		sta VIC_Sprite7X
		lda SpriteXMSBSin, y
		sta VIC_SpriteXMSB

		jsr DoSpriteColours

		lda PART_Done
		beq DiskNotFlipped
		//; normally should fadeout first ...

	FadeOutStarted:
		lda #$00							//; Disk flipped - wait for word to finish then jump to space char loop
		bne DiskNotFlipped

		ldx CharHere + 1
		lda CharHere + 2
		sta CharCheck + 2
	CharCheck:
		lda ScrollText,x
		bne DiskNotFlipped

		lda #$ff							//; Change the very first character to $ff - this will force the scroller to output space chars
		sta ScrollText
		
		lda #<ScrollText
		sta CharHere + 1
		lda #>ScrollText
		sta CharHere + 2
		
		inc FadeOutStarted + 1
	
	DiskNotFlipped:

		rts


//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		pha
		txa
		pha
		tya
		pha
		lda $01
		pha

		lda #$20
		sta VIC_D012
		lda #<IRQ_SpriteRows
		sta $fffe
		lda #>IRQ_SpriteRows
		sta $ffff
		dec VIC_D019
		cli

		jsr BASE_PlayMusic

		lda FadeOutStarted + 1
		beq NoMusicFadeOut

	MusicFadeOut:
		lda #$77
		beq NoMusicFadeOut
		lsr
		lsr
		lsr
		sta SIDVolume_ADDR

		ldx $101c
		lda $145e,x
		asl
		asl
		asl
		asl
		ora SIDVolume_ADDR
		sta $d418								//; The SID doesn't update volume in each frame so we need this hack to make sure it gets updated...

	BufferCtr:
		ldx #$03
		dex
		bne SkipNext
		dec MusicFadeOut + 1
		ldx #$03
	SkipNext:
		stx BufferCtr + 1

	NoMusicFadeOut:

		lda VIC_D011
		bmi AllClearToContinue

		lda #$f6
	!Wait:
		cmp VIC_D012
		bcs !Wait-

	AllClearToContinue:
		jsr DoMainScreenUpdate

		lda PART_Done						//; Disk flipped - wait for ScrollText to finish loop and SID volume to decrease to 0
		beq DoUpdate

		lda SIDVolume_ADDR					//; Once volume = 0 we are done
		bne DoUpdate
		
		lda #$00
		sta PART_Done

	DoUpdate:
		jsr UpdatePlot

		inc FrameCounterLo
		bne FrameNot256
		inc FrameCounterHi
	FrameNot256:


		pla
		sta $01
		pla
		tay
		pla
		tax
		pla

		rti


//; IRQ_SpriteRows() -------------------------------------------------------------------------------------------------------

IRQ_SpriteRows:

		IRQManager_BeginIRQ(1, -6)

	CurrentIRQRow:
		ldx #NumSpriteRows
		ldy NextXModded, x
		sty CurrentIRQRow + 1

	NotFirstLine:

		cpx #0
		bne NotZerothFrame
		jmp NotFinalLine
	NotZerothFrame:

		cpx #NumSpriteRows
		bne NotFinalLine

		lda #ScreenColour

		ldy #$22
	TurnOffSpritesDelay:
		dey
		bne TurnOffSpritesDelay

		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		lda #195
		sta VIC_D012
		lda #<IRQ_DiskSprites
		sta $fffe
		lda #>IRQ_DiskSprites
		sta $ffff
		jmp EndTheIRQ

	NotFinalLine:
		stx RestoreX + 1
		lda SpriteYValues, x
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

		ldy #$14
	DelaySpriteVals:
		dey
		bne DelaySpriteVals

		lda SpriteValues, x
		tax

		lda #$fb
	SpriteValPtrsLoop:
		.for (var SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			sax SpriteVals0 + SpriteIndex
			stx SpriteVals0 + SpriteIndex + 4
			.if (SpriteIndex != 3)
				inx
		}

	RestoreX:
		ldx #$00
	SkipSpriteYUpdate:
		lda D012Values, x
		sta VIC_D012

	EndTheIRQ:
		IRQManager_EndIRQ()
		rti


//; IRQ_DiskSprites() -------------------------------------------------------------------------------------------------------

IRQ_DiskSprites:

		IRQManager_BeginIRQ(0, 0)

		lda FrameCounterHi
		and #$01
		beq NoDiskToShow

	FadeOutNoDisk:
		lda #$00
		bne NoDiskToShow

		lda FrameCounterLo
		lsr
		lsr
		tay
		lda SpriteCols_Text + 0, y
		cmp #ScreenColour
		beq NoDiskToShow

		.for (var i = 0; i < 4; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		lda #200
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		lda #221
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y

		lda FrameCounterLo
		clc
		adc #$25
		and #$7f
		tay
		lda Sprite0XSin, y
		clc
		adc #$48
		sta VIC_Sprite0X
		sta VIC_Sprite2X
		clc
		adc #$18
		sta VIC_Sprite1X
		sta VIC_Sprite3X
		lda #$00
		sta VIC_SpriteXMSB

		ldx #$60
	SpriteValPtrs_Disk:
		stx SpriteVals0 + 0
		inx
		stx SpriteVals0 + 1
		inx
		stx SpriteVals0 + 2
		inx
		stx SpriteVals0 + 3

	NoDiskToShow:

		lda VIC_Sprite0Colour				//; Disk flipped - finish showing sprites if on screen then don't show them again
		and #$0f
		cmp #<ScreenColour
		bne SkipFadeOutCheck
		
		lda PART_Done
		beq SkipFadeOutCheck
		sta FadeOutNoDisk + 1

	SkipFadeOutCheck:
		lda #210
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti

		
//; DoSpriteColours() -------------------------------------------------------------------------------------------------------

DoSpriteColours:

		lda FrameCounterHi
		and #$01
		beq NoColour

		lda FrameCounterLo
		lsr
		lsr
		tay
		ldx SpriteCols_Text + 16, y
	FadeOutNoText:
		lda #$00
		beq NoFadeOut
		ldx #<ScreenColour
	NoFadeOut:
		.for (var i = 0; i < 8; i++)
		{
			stx VIC_Sprite0Colour + i
		}
		lda #$ff
		sta VIC_SpriteEnable

	NoColour:

		lda VIC_Sprite0Colour				//; Disk flipped - finish showing sprites if on screen then don't show them again
		and #$0f
		cmp #<ScreenColour
		bne SpriteColoursDone
		
		lda PART_Done
		beq SpriteColoursDone
		sta FadeOutNoText + 1
	
	SpriteColoursDone:
		rts


//; SetupScreens() -------------------------------------------------------------------------------------------------------

SetupScreens:

		ldx #41
		lda #0
		.for (var i = 0; i < 4; i++)
		{
			stx ZP_ScreenSRC + (i * 2) + 0
			sta ZP_ScreenDST + (i * 2) + 0
		}

		ldx #0

	MainScreenLoop:
		ldy ScreenAddresses_Hi, x
		.for (var i = 0; i < 4; i++)
		{
			sty ZP_ScreenSRC + (i * 2) + 1
			.if (i != 3)
			{
				iny
			}
		}

		ldy ScreenAddresses_Hi + 1, x
		.for (var i = 0; i < 4; i++)
		{
			sty ZP_ScreenDST + (i * 2) + 1
			.if (i != 3)
			{
				iny
			}
		}

		ldy #0
	CopyScreenLoop:
		.for (var i = 0; i < 4; i++)
		{
			lda (ZP_ScreenSRC + (i * 2)), y
			sta (ZP_ScreenDST + (i * 2)), y
		}
		iny
		bne CopyScreenLoop

		lda #0
		.for (var i = 0; i < 10; i++)
		{
			.if (i == 0)
			{
				ldy #960
			}
			.if (i > 0)
			{
				iny
			}
			sta (ZP_ScreenDST + 6), y
		}
		.for (var i = 0; i < 10; i++)
		{
			.var j = i * 40 + 39

			ldy #j
			.var k = 0
			.if (j >= 256)
			{
				.eval k = 1
			}
			.if (j >= 512)
			{
				.eval k = 2
			}
			.if (j >= 768)
			{
				.eval k = 3
			}
			sta (ZP_ScreenDST + k * 2), y
		}

		.for (var i = 0; i < 15; i++)
		{
			.var srcj = i * 40 + 29
			.var dstj = (i + 10) * 40 + 39

			.var srck = 0
			.if (srcj >= 256)
			{
				.eval srck = 1
			}
			.if (srcj >= 512)
			{
				.eval srck = 2
			}
			.if (srcj >= 768)
			{
				.eval srck = 3
			}

			.var dstk = 0
			.if (dstj >= 256)
			{
				.eval dstk = 1
			}
			.if (dstj >= 512)
			{
				.eval dstk = 2
			}
			.if (dstj >= 768)
			{
				.eval dstk = 3
			}

			ldy #srcj
			lda (ZP_ScreenSRC + srck * 2), y
			ldy #dstj
			sta (ZP_ScreenDST + dstk * 2), y
		}

		.for (var i = 0; i < 30; i++)
		{
			.var srcj = (14 * 40) + i
			.var dstj = (24 * 40) + 10 + i

			.var srck = 0
			.if (srcj >= 256)
			{
				.eval srck = 1
			}
			.if (srcj >= 512)
			{
				.eval srck = 2
			}
			.if (srcj >= 768)
			{
				.eval srck = 3
			}

			.var dstk = 0
			.if (dstj >= 256)
			{
				.eval dstk = 1
			}
			.if (dstj >= 512)
			{
				.eval dstk = 2
			}
			.if (dstj >= 768)
			{
				.eval dstk = 3
			}

			ldy #srcj
			lda (ZP_ScreenSRC + srck * 2), y
			ldy #dstj
			sta (ZP_ScreenDST + dstk * 2), y
		}

		inx
		cpx #9
		bne NotFinishedMainScreenLoop
		rts

	NotFinishedMainScreenLoop:
		jmp MainScreenLoop


//; ShiftFontData() -------------------------------------------------------------------------------------------------------

ShiftFontData:

		ldy #$00

	ShiftFontDataLoop:

		lda FONTBIN_ADDR, y
		lsr
		sta Font_Y0_Shift1_Side0, y
		lsr
		sta Font_Y0_Shift2_Side0, y
		lsr
		sta Font_Y0_Shift3_Side0, y
		lsr
		sta Font_Y0_Shift4_Side0, y
		lsr
		sta Font_Y0_Shift5_Side0, y
		lsr
		sta Font_Y0_Shift6_Side0, y
		lsr
		sta Font_Y0_Shift7_Side0, y

		lda FONTBIN_ADDR, y
		asl
		sta Font_Y0_Shift7_Side1, y
		asl
		sta Font_Y0_Shift6_Side1, y
		asl
		sta Font_Y0_Shift5_Side1, y
		asl
		sta Font_Y0_Shift4_Side1, y

		iny
		cpy #(32 * 5)
		bne ShiftFontDataLoop
	
		rts

