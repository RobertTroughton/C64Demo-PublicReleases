//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $4000 "BASICFadeBase"

		jmp BASICFade_Go

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-27ff CharSet
//; - $2800-2bff Sprites
//; - $2f00-2fff CurveTable
//; - $3000-37ff FontData
//; - $4000-57ff Code

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 0 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank0 =  1 //; Bank+[0400,07ff]
	.var CharBank0 =  4 //; Bank+[2000,27ff]
	.var ScreenAddress0 = Base_BankAddress0 + ScreenBank0 * $400
	.var CharAddress0 = Base_BankAddress0 + CharBank0 * $800
	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var SpriteVals0 = ScreenAddress0 + $3f8
	
	.var FirstSpriteIndex = 160
	.var SpriteDataAddress0 = Base_BankAddress0 + (FirstSpriteIndex * 64)

	.var D016_Value_40Cols = $08

	.var ADDR_CurveTable = $2f00

	.var ADDR_FontData_Y0 = $3000
	.var ADDR_FontData_Y1 = $3100
	.var ADDR_FontData_Y2 = $3200
	.var ADDR_FontData_Y3 = $3300
	.var ADDR_FontData_Y4 = $3400
	.var ADDR_FontData_Y5 = $3500
	.var ADDR_FontData_Y6 = $3600
	.var ADDR_FontData_Y7 = $3700

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
	.byte D000_SkipValue						//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $0e									//; D020: VIC_BorderColour
	.byte D000_SkipValue						//; D021: VIC_ScreenColour
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
	
FrameOf32:						.byte 0
SpriteIndices:					.fill 12, FirstSpriteIndex + 11
								.fill 12, FirstSpriteIndex + i
SpriteXIndex:					.byte 0

SpriteXColumnUpdates_Col0:		.byte $05, $1d, $0e, $ff, $20, $1a, $26, $02, $11, $08, $17, $0b, $14, $23
SpriteXColumnUpdates_Col1:		.byte $06, $1e, $0f, $00, $21, $1b, $27, $03, $12, $09, $18, $0c, $15, $24
SpriteXColumnUpdates_Col2:		.byte $07, $1f, $10, $01, $22, $1c, $ff, $04, $13, $0a, $19, $0d, $16, $25
SpriteXValues:					.byte $40, $00, $88, $10, $18, $e8, $48, $28, $a0, $58, $d0, $70, $b8, $30
SpriteXMSBValues:				.byte $00, $ff, $00, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $ff
SpriteX_ScreenXStart:			.byte $05, $1d, $0e, $00, $20, $1a, $26, $02, $11, $08, $17, $0b, $14, $23
SpriteX_ScreenXWidth:			.byte $03, $03, $03, $02, $03, $03, $02, $03, $03, $03, $03, $03, $03, $03

InitialDelay:					.byte 64

.align 256

//; BASICFade_Go() -------------------------------------------------------------------------------------------------------
BASICFade_Go:

		jsr FadeToStandardColours

		vsync()

		sei

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		lda #$00
		sta Base_BankAddress0 + $3fff //; MagicByte

		jsr CopyCharsetData

		ldy #$00
		lda #$00
	ClearSpriteDataLoop:
		.for (var i = 0; i < 3; i++)
		{
			sta SpriteDataAddress0 + (i * 256), y
		}
		iny
		bne ClearSpriteDataLoop

		ldx SpriteXColumnUpdates_Col0 + 0
		jsr UpdateSpriteAndScreenData_X0
		ldx SpriteXColumnUpdates_Col1 + 0
		jsr UpdateSpriteAndScreenData_X1
		ldx SpriteXColumnUpdates_Col2 + 0
		jsr UpdateSpriteAndScreenData_X2

	WaitForSafeD800Update:
		lda VIC_D011
		bpl WaitForSafeD800Update

		lda #$0e
		sta VIC_ScreenColour

		lda #D018Value0
		sta VIC_D018
		lda #DD02Value0
		sta VIC_DD02

		ldy #$00
		lda #$06
	FillColMemPart1:
		.for (var i = 0; i < 2; i++)
		{
			sta VIC_ColourMemory + (i * 256), y
		}
		iny
		bne FillColMemPart1
	FillColMemPart2:
		.for (var i = 2; i < 4; i++)
		{
			sta VIC_ColourMemory + (i * 256), y
		}
		iny
		bne FillColMemPart2

		jsr SetSpriteXValues

		//vsync()


		lda #$f8
		sta VIC_D012
		lda #<IRQ_TopBottomBorder0
		sta $fffe
		lda #>IRQ_TopBottomBorder0
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		rts

IRQ_TopBottomBorder0:

		IRQManager_BeginIRQ(0, 0)

		lda #$13
		sta VIC_D011

		lda #$ff
		sta VIC_D012
		lda #<IRQ_TopBottomBorder1
		sta $fffe
		lda #>IRQ_TopBottomBorder1
		sta $ffff

		IRQManager_EndIRQ()
		rti

DoSparkleSprites:

		lda #$20
		sta VIC_Sprite0X
		sta VIC_Sprite2X
		sta VIC_Sprite4X
		sta VIC_Sprite6X
		lda #$38
		sta VIC_Sprite1X
		sta VIC_Sprite3X
		sta VIC_Sprite5X
		sta VIC_Sprite7X
		lda #$ff
		sta VIC_SpriteXMSB

		lda #200
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		lda #221					//; we need a 1-pixel gap between the sprite rows
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		lda #$00
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		lda #$02
		sta VIC_Sprite2Colour
		sta VIC_Sprite7Colour
		lda #$0e
		sta VIC_Sprite3Colour
		sta VIC_Sprite6Colour

		ldx #176
		stx SpriteVals0 + 0
		inx
		stx SpriteVals0 + 1
		inx
		stx SpriteVals0 + 2
		inx
		stx SpriteVals0 + 3
		inx
		stx SpriteVals0 + 4
		inx
		stx SpriteVals0 + 5
		inx
		stx SpriteVals0 + 6
		inx
		stx SpriteVals0 + 7

		rts

IRQ_TopBottomBorder1:

		IRQManager_BeginIRQ(0, 0)

		jsr BASE_PlayMusic

		lda FrameOf32
		cmp #29
		bcc DoneSpriteUpdates

	DoSpriteUpdates:
		cmp #30
		beq SpriteUpdate_Frame1
		cmp #31
		beq SpriteUpdate_Frame2
	SpriteUpdate_Frame0:
		ldy SpriteXIndex
		ldx SpriteXColumnUpdates_Col0 + 1, y
		bmi DoneSpriteUpdates
		jsr UpdateSpriteAndScreenData_X0
		jmp DoneSpriteUpdates

	SpriteUpdate_Frame1:
		ldy SpriteXIndex
		ldx SpriteXColumnUpdates_Col1 + 1, y
		jsr UpdateSpriteAndScreenData_X1
		jmp DoneSpriteUpdates

	SpriteUpdate_Frame2:
		ldy SpriteXIndex
		bmi DoneSpriteUpdates
		ldx SpriteXColumnUpdates_Col2 + 1, y
		jsr UpdateSpriteAndScreenData_X2

	DoneSpriteUpdates:

		lda #$1b				//; #$9b - DMC SID takes more time and occasionally this IRQ ends beyond raster line 300. Next IRQ moved to raster line 8
		sta VIC_D011
		lda #$08				//; #(300 - 256)
		sta VIC_D012
		lda #<IRQ_CloseToTheVeryBottom
		sta $fffe
		lda #>IRQ_CloseToTheVeryBottom
		sta $ffff
		
		lda PART_Done			//; this is needed for the demo to be able to continue with the raster transition
		bne SkipD011

	!vb:
		lda VIC_D011
		bmi !vb-
	SkipD011:

		lda #$0e
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		IRQManager_EndIRQ()
		rti

IRQ_CloseToTheVeryBottom:

		IRQManager_BeginIRQ(0, 0)

		lda InitialDelay
		beq DoSprites0
		jsr DoSparkleSprites
		jmp SkipSprites0

	DoSprites0:
		jsr SetSpriteXValues

		ldx FrameOf32
		ldy ADDR_CurveTable + 32, x
		.for (var i = 0; i < 8; i++)
		{
			lda SpriteIndices + i, y
			sta SpriteVals0 + i
		}

		ldy FrameOf32
		lda ADDR_CurveTable, y
		clc
		adc #50
		sta VIC_Sprite0Y
		.for (var i = 1; i < 8; i++)
		{
			clc
			adc #21
			sta VIC_Sprite0Y + (i * 2)
		}
	SkipSprites0:

		lda #$1b
		sta VIC_D011
		lda #$30
		sta VIC_D012
		lda #<IRQ_JustBeforeTheScreen
		sta $fffe
		lda #>IRQ_JustBeforeTheScreen
		sta $ffff

		IRQManager_EndIRQ()
		rti

IRQ_JustBeforeTheScreen:

		IRQManager_BeginIRQ(0, 0)

		lda InitialDelay
		bne DontClearSprites
		lda #$06
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Colour + i
		}
	DontClearSprites:

		lda #$ff
		sta VIC_SpriteEnable

		lda #160
		sta VIC_D012
		lda #<IRQ_SpriteSet2
		sta $fffe
		lda #>IRQ_SpriteSet2
		sta $ffff

		IRQManager_EndIRQ()
		rti

IRQ_SpriteSet2:

		IRQManager_BeginIRQ(0, 0)

		lda InitialDelay
		beq DoSprites_Set2
		dec InitialDelay
		jmp SkipSprites_Set2
	DoSprites_Set2:

		//jsr SetSpriteXValues

		lda VIC_Sprite0Y
		clc
		adc #(21 * 8)
		sta VIC_Sprite0Y
		clc
		adc #21
		sta VIC_Sprite1Y
		clc
		adc #21
		sta VIC_Sprite2Y
		clc
		adc #21				//; + an extra 5 here...
		sta VIC_Sprite3Y

		ldx FrameOf32
		ldy ADDR_CurveTable + 32, x
		.for (var i = 0; i < 4; i++)
		{
			ldx SpriteIndices + 8 + i, y
			stx SpriteVals0 + i
		}

		ldx FrameOf32
		inx
		cpx #32
		bne NotRep

		ldy SpriteXIndex
		iny
		cpy #14
		bne Not14
		inc MoveToNextPart + 1
		ldy #0
	Not14:
		sty SpriteXIndex
		jsr SetSpriteXValues

		ldx #0

	NotRep:
		stx FrameOf32

		cpx #1
		bne DontClearScreenColumns

		ldy SpriteXIndex
		ldx SpriteX_ScreenXWidth, y
		lda SpriteX_ScreenXStart, y
		tay
		jsr ClearScreenColumns
	DontClearScreenColumns:

	MoveToNextPart:
		lda #$00
		beq DontMoveToNextPart
		lda #$00
		sta VIC_SpriteEnable
		sta VIC_D011
		inc PART_Done
		//; signal finished!

	SkipSprites_Set2:
	DontMoveToNextPart:
		lda #$f8
		sta VIC_D012
		lda #<IRQ_TopBottomBorder0
		sta $fffe
		lda #>IRQ_TopBottomBorder0
		sta $ffff

		IRQManager_EndIRQ()
		rti


SetSpriteXValues:

		ldy SpriteXIndex
		lda SpriteXValues, y
		sta VIC_Sprite0X
		sta VIC_Sprite1X
		sta VIC_Sprite2X
		sta VIC_Sprite3X
		sta VIC_Sprite4X
		sta VIC_Sprite5X
		sta VIC_Sprite6X
		sta VIC_Sprite7X

		lda SpriteXMSBValues, y
		sta VIC_SpriteXMSB
		rts

ClearScreenColumns:

		lda #$a0
	
	FillLoop:
		.for (var i = 0; i < 25; i++)
		{
			sta ScreenAddress0 + (i * 40), y
		}

		iny
		dex
		bne FillLoop

		rts

.import source "../../Build/6502/BASICFade/SpriteUpdate.asm"

CopyCharsetData:

		lda #$33
		sta $01

		ldx #$00
	CopyCharsetLoop0:
		.for (var i = 0; i < 8; i++)
		{
			lda $d000 + (i * 256), x
			eor #$ff
			sta CharAddress0 + (i * 256), x
		}
		inx
		bne CopyCharsetLoop0

		ldx #$00
		ldy #$00
		lda #$00
		sta $c0
		lda #>CharAddress0
		sta $c1
	CopyCharsetLoop1:
		.for (var i = 0; i < 8; i++)
		{
			lda ($c0), y
			sta ADDR_FontData_Y0 + (i * 256), x
			iny
		}
		bne NotCrossPage
		inc $c1
	NotCrossPage:
		inx
		bne CopyCharsetLoop1

		lda #$35
		sta $01

		rts

FadeToStandardColours:

		lda #$00
		sta $dbff				//; Last byte of ColRAM is used as a flag byte. Fading from black to white takes the most steps (7)
								//; so we can be sure the rest of the ColRAM gets faded to white too
		ldy #$04
ColChkLoop:
		ldx #$00
Src:	lda $d800,x				//; Colour RAM check
		and #$0f
		cmp #$0e
		bne CTWEntry
		inx
		cpx #$fa
		bne Src
		lda Src+1
		clc
		adc #$fa
		sta Src+1
		lda Src+2
		adc #$00
		sta Src+2
		dey
		bne ColChkLoop
		
		lda #$0e				//; Resetting ColRAM flag byte to light blue - all ColRAM bytes are $0e.
		sta $dbff

		lda VIC_BorderColour
		and #$0f
		tax
		lda VIC_ScreenColour
		and #$0f
		tay
		cpx #$0e
		bne ColToWhite
		cpy #$06
		beq FadeNotNeeded		//; All colors are standard colors - fade is not needed

ColToWhite:
		vsync()
		vsync()
		
		lda FadeToWhite,x
		sta VIC_BorderColour
		lda FadeToWhite,y
		sta VIC_ScreenColour

		jsr ColRAMToWhite

CTWEntry:
		lda VIC_BorderColour
		and #$0f
		tax
		lda VIC_ScreenColour
		and #$0f
		tay
		lda $dbff
		and #$0f
		cmp #$01
		bne ColToWhite
		cpx #$01
		bne ColToWhite
		cpy #$01
		bne ColToWhite

		ldx #$05
ColToBlue:
		vsync()
		vsync()
		lda WhiteTo06,x
		sta VIC_ScreenColour
		lda WhiteTo0e,x
		sta VIC_BorderColour

		ldy #$00
!:		sta $d800,y
		sta $d900,y
		iny
		bne !-
!:		sta $da00,y
		sta $db00,y
		iny
		bne !-

		dex
		bpl ColToBlue
FadeNotNeeded:
		rts

ColRAMToWhite:

		ldx #$00
!:		ldy $d800,x
		lda FadeToWhite,y
		sta $d800,x
		ldy $d801,x
		lda FadeToWhite,y
		sta $d801,x
		ldy $d802,x
		lda FadeToWhite,y
		sta $d802,x
		ldy $d803,x
		lda FadeToWhite,y
		sta $d803,x
		ldy $d804,x
		lda FadeToWhite,y
		sta $d804,x
		ldy $d805,x
		lda FadeToWhite,y
		sta $d805,x
		ldy $d806,x
		lda FadeToWhite,y
		sta $d806,x
		ldy $d807,x
		lda FadeToWhite,y
		sta $d807,x
		txa
		axs #$f8
		bne !-

!:		ldy $d900,x
		lda FadeToWhite,y
		sta $d900,x
		ldy $d901,x
		lda FadeToWhite,y
		sta $d901,x
		ldy $d902,x
		lda FadeToWhite,y
		sta $d902,x
		ldy $d903,x
		lda FadeToWhite,y
		sta $d903,x
		ldy $d904,x
		lda FadeToWhite,y
		sta $d904,x
		ldy $d905,x
		lda FadeToWhite,y
		sta $d905,x
		ldy $d906,x
		lda FadeToWhite,y
		sta $d906,x
		ldy $d907,x
		lda FadeToWhite,y
		sta $d907,x
		txa
		axs #$f8
		bne !-

!:		ldy $da00,x
		lda FadeToWhite,y
		sta $da00,x
		ldy $da01,x
		lda FadeToWhite,y
		sta $da01,x
		ldy $da02,x
		lda FadeToWhite,y
		sta $da02,x
		ldy $da03,x
		lda FadeToWhite,y
		sta $da03,x
		ldy $da04,x
		lda FadeToWhite,y
		sta $da04,x
		ldy $da05,x
		lda FadeToWhite,y
		sta $da05,x
		ldy $da06,x
		lda FadeToWhite,y
		sta $da06,x
		ldy $da07,x
		lda FadeToWhite,y
		sta $da07,x
		txa
		axs #$f8
		bne !-

!:		ldy $db00,x
		lda FadeToWhite,y
		sta $db00,x
		ldy $db01,x
		lda FadeToWhite,y
		sta $db01,x
		ldy $db02,x
		lda FadeToWhite,y
		sta $db02,x
		ldy $db03,x
		lda FadeToWhite,y
		sta $db03,x
		ldy $db04,x
		lda FadeToWhite,y
		sta $db04,x
		ldy $db05,x
		lda FadeToWhite,y
		sta $db05,x
		ldy $db06,x
		lda FadeToWhite,y
		sta $db06,x
		ldy $db07,x
		lda FadeToWhite,y
		sta $db07,x
		txa
		axs #$f8
		bne !-
		rts

.align $100

FadeToWhite:
.for (var i = 0; i < 16; i++)
{
//		 00, 01, 02, 03, 04, 05, 06, 07
.byte	$09,$01,$08,$0d,$0c,$03,$0b,$01
//		 08, 09, 0a, 0b, 0c, 0d, 0e, 0f
.byte	$0a,$02,$0f,$04,$03,$01,$03,$07
}

WhiteTo06:
.byte	$06,$0b,$04,$0c,$03,$0d

WhiteTo0e:
.byte	$0e,$0e,$03,$0d,$07,$01