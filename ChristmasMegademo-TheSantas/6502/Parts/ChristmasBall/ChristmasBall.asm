//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

* = ChristmasBall_BASE "ChristmasBallbase"

		jmp ChristmasBall_Init
		jmp ChristmasBall_Go
		jmp ChristmasBall_EaseOut

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music

//; - $2000-9fff Code
//; - $b800-bfff SinTables
//; - $c000-df7f Bitmap
//; - $e000-e3e7 Screen
//; - $e400-e8bf Logo Sprites
//; - $ec00-efff Flip Disk Sprites
//; - $f000-f3e7 Bitmap Screen Src
//; - $f400-f7e7 Bitmap Colour Src

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var ScreenBank = 8 //; Bank+[2000,23ff]
	.var BitmapBank = 0 //; Bank+[0000,1f3f]
	.var ScreenAddress = Base_BankAddress + ScreenBank * $400
	.var SpriteVals = ScreenAddress + $3f8
	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D016_Value_40Chars = $18

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var SpriteIndex_HiResTop = $90
	.var SpriteIndex_Logo_XMas = SpriteIndex_HiResTop + 2
	.var SpriteIndex_TopLogo_The = SpriteIndex_Logo_XMas + 4
	.var SpriteIndex_TopLogo_Santas = SpriteIndex_TopLogo_The + 3
	.var SpriteIndex_Logo_2020 = SpriteIndex_TopLogo_Santas + 6

	.var SpriteIndex_FlipDiskSprites = $b0
	.var FlipDiskSpriteAddress = Base_BankAddress + (SpriteIndex_FlipDiskSprites * 64)

	.var TopSinTablesADDR = $b800
	.var TopSinTables_Santas_X = TopSinTablesADDR + (0 * 256)
	.var TopSinTables_Santas_XMSB = TopSinTablesADDR + (1 * 256)
	.var TopSinTables_The_X = TopSinTablesADDR + (2 * 256)
	.var TopSinTables_The_XMSB = TopSinTablesADDR + (3 * 256)

	.var BottomSinTablesADDR = $bc00
	.var BottomSinTables_2020_X = BottomSinTablesADDR + (0 * 256)
	.var BottomSinTables_2020_XMSB = BottomSinTablesADDR + (1 * 256)
	.var BottomSinTables_XMAS_X = BottomSinTablesADDR + (2 * 256)
	.var BottomSinTables_XMAS_XMSB = BottomSinTablesADDR + (3 * 256)

	.var PartDone = $087f

	.var FADE_NOFADE = 0
	.var FADE_FADEIN = 1
	.var FADE_FADEOUT = 2

	.var BitmapScreenSrcAddr = $f000
	.var BitmapColourSrcAddr = $f400

	.var ColourFadeTableLoad = $b700
	.var ColourFadeTableAddr = $f800
	.var ColourFadeTable1Addr = ColourFadeTableAddr + (0 * 256)
	.var ColourFadeTable2Addr = ColourFadeTableAddr + (1 * 256)
	.var ColourFadeTable3Addr = ColourFadeTableAddr + (2 * 256)
	.var ColourFadeTable4Addr = ColourFadeTableAddr + (3 * 256)
	.var ColourFadeTable5Addr = ColourFadeTableAddr + (4 * 256)
	.var ColourFadeTable6Addr = ColourFadeTableAddr + (5 * 256)

	.var ZP_FadeTablePtr = $40 //; +$41

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
	.byte D016_Value_40Chars					//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $00									//; D021: VIC_ScreenColour
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

ScreenEaseMode:	.byte $01

.var ColSet0_A = $00
.var ColSet0_B = $09
.var ColSet0_C = $02
.var ColSet0_D = $04
.var ColSet0_E = $0e
.var ColSet0_F = $01

.var ColSet1_A = $00
.var ColSet1_B = $09
.var ColSet1_C = $04
.var ColSet1_D = $03
.var ColSet1_E = $0d
.var ColSet1_F = $01

.var ColSet2_A = $00
.var ColSet2_B = $09
.var ColSet2_C = $02
.var ColSet2_D = $08
.var ColSet2_E = $0a
.var ColSet2_F = $01

FlipDiskColours:
	//; ColSet0: 24 + 37 + 24 = 85
	.byte ColSet0_A, ColSet0_A, ColSet0_A
	.byte ColSet0_A, ColSet0_A, ColSet0_A
	.byte ColSet0_B, ColSet0_C, ColSet0_B
	.byte ColSet0_C, ColSet0_D, ColSet0_C
	.byte ColSet0_D, ColSet0_E, ColSet0_D
	.byte ColSet0_E, ColSet0_F, ColSet0_E
	.byte ColSet0_F, ColSet0_F, ColSet0_F
	.byte ColSet0_E, ColSet0_F, ColSet0_E
	.fill 37, ColSet0_E
	.byte ColSet0_E, ColSet0_F, ColSet0_E
	.byte ColSet0_F, ColSet0_F, ColSet0_F
	.byte ColSet0_E, ColSet0_F, ColSet0_E
	.byte ColSet0_D, ColSet0_E, ColSet0_D
	.byte ColSet0_C, ColSet0_D, ColSet0_C
	.byte ColSet0_B, ColSet0_C, ColSet0_B
	.byte ColSet0_A, ColSet0_A, ColSet0_A
	.byte ColSet0_A, ColSet0_A, ColSet0_A

	//; ColSet1: 24 + 37 + 24 = 85
	.byte ColSet1_A, ColSet1_A, ColSet1_A
	.byte ColSet1_A, ColSet1_A, ColSet1_A
	.byte ColSet1_B, ColSet1_C, ColSet1_B
	.byte ColSet1_C, ColSet1_D, ColSet1_C
	.byte ColSet1_D, ColSet1_E, ColSet1_D
	.byte ColSet1_E, ColSet1_F, ColSet1_E
	.byte ColSet1_F, ColSet1_F, ColSet1_F
	.byte ColSet1_E, ColSet1_F, ColSet1_E
	.fill 37, ColSet1_E
	.byte ColSet1_E, ColSet1_F, ColSet1_E
	.byte ColSet1_F, ColSet1_F, ColSet1_F
	.byte ColSet1_E, ColSet1_F, ColSet1_E
	.byte ColSet1_D, ColSet1_E, ColSet1_D
	.byte ColSet1_C, ColSet1_D, ColSet1_C
	.byte ColSet1_B, ColSet1_C, ColSet1_B
	.byte ColSet1_A, ColSet1_A, ColSet1_A
	.byte ColSet1_A, ColSet1_A, ColSet1_A

	//; ColSet2: 24 + 38 + 24 = 86
	.byte ColSet2_A, ColSet2_A, ColSet2_A
	.byte ColSet2_A, ColSet2_A, ColSet2_A
	.byte ColSet2_B, ColSet2_C, ColSet2_B
	.byte ColSet2_C, ColSet2_D, ColSet2_C
	.byte ColSet2_D, ColSet2_E, ColSet2_D
	.byte ColSet2_E, ColSet2_F, ColSet2_E
	.byte ColSet2_F, ColSet2_F, ColSet2_F
	.byte ColSet2_E, ColSet2_F, ColSet2_E
	.fill 38, ColSet2_E
	.byte ColSet2_E, ColSet2_F, ColSet2_E
	.byte ColSet2_F, ColSet2_F, ColSet2_F
	.byte ColSet2_E, ColSet2_F, ColSet2_E
	.byte ColSet2_D, ColSet2_E, ColSet2_D
	.byte ColSet2_C, ColSet2_D, ColSet2_C
	.byte ColSet2_B, ColSet2_C, ColSet2_B
	.byte ColSet2_A, ColSet2_A, ColSet2_A
	.byte ColSet2_A, ColSet2_A, ColSet2_A

//; ChristmasBall_Go() -------------------------------------------------------------------------------------------------------
ChristmasBall_Go:

		ldy #$00
		tya
	FillScreenColourMemoryLoop:
		.for (var i = 0; i < 4; i++)
		{
			sta VIC_ColourMemory + (i * 256), y
			sta ScreenAddress + (i * 256), y
			sta FlipDiskSpriteAddress + (i * 256), y
		}
		iny
		bne FillScreenColourMemoryLoop

		jsr InitColourTables

		vsync()

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$fa
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #D011_Value_25Rows
		sta VIC_D011

		lda #$00
		sta VIC_BorderColour

		lda #$ff
		sta VIC_SpriteEnable

		rts

ChristmasBall_EaseOut:

		lda #$02
		sta ScreenEaseMode
		rts

//; ChristmasBall_Init() -------------------------------------------------------------------------------------------------------
ChristmasBall_Init:

		stx MusicVolumeAddr + 1
		sty MusicVolumeAddr + 2

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		MACRO_SetVICBank(BaseBank)

		rts

//; IRQ_Main() -------------------------------------------------------------------------------------------------------
IRQ_Main:
		IRQManager_BeginIRQ(0, 0)

		lda #D011_Value_24Rows
		sta VIC_D011

		lda PartDone
		beq NotFinishedYet
		lda #$02
		sta ScreenEaseMode
	NotFinishedYet:

		jsr BASE_PlayMusic

		lda ScreenEaseMode
		beq SkipScreenEase

		cmp #2
		beq LetsEaseOut
		jsr EaseInScreen
		jmp SkipSprites
	LetsEaseOut:
		jsr EaseOutScreen
	VolumeFade:
		lda #$40
		sec
		sbc #$01
		sta VolumeFade + 1
		bne NotFinishedVolumeFade
		sta PartDone
		jmp SkipSprites
	NotFinishedVolumeFade:
		lsr
		lsr
	MusicVolumeAddr:
		sta $abcd
		jmp SkipSprites

	SkipScreenEase:

		jsr PrepSprites_Row0
		jsr PrepSprites_Row2

	WaitForBlank:
		lda VIC_D011
		bpl WaitForBlank

		lda #D011_Value_25Rows
		sta VIC_D011

	WaitForBlank2:
		lda VIC_D011
		bmi WaitForBlank2

		jsr SetSpriteY_Row0
		jsr SetSpritesRow0

		lda #$14
	WaitForRow1A:
		cmp VIC_D012
		bne WaitForRow1A
		jsr SetSpriteY_Row1

		lda #$29
	WaitForRow1:
		cmp VIC_D012
		bne WaitForRow1

		jsr SetSpritesRow1

		lda #$50
	WaitForRow2:
		cmp VIC_D012
		bne WaitForRow2
		
		lda #$6e
		sta VIC_Sprite0X
		sta VIC_Sprite4X
		lda #$86
		sta VIC_Sprite1X
		sta VIC_Sprite5X
		lda #$9e
		sta VIC_Sprite2X
		sta VIC_Sprite6X
		lda #$b6
		sta VIC_Sprite3X
		sta VIC_Sprite7X
		lda #$00
		sta VIC_SpriteXMSB
		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight

	FlipDiskDelay:
		ldy #$b0
		beq FlipDiskColourIndex
		dey
		sty FlipDiskDelay + 1
		lda #$00
		sta VIC_SpriteEnable
		beq SkipFlipDiskSprites

	FlipDiskColourIndex:
		ldy #$00
		lda FlipDiskColours, y
		iny
		sty FlipDiskColourIndex + 1
	SkipIndexedColour:
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour
		lda #$00
		sta VIC_SpriteMulticolourMode
		lda #$ff
		sta VIC_SpriteEnable
		sta VIC_SpriteDrawPriority
	SkipFlipDiskSprites:

	//; Row 0 and 1
		lda #$79
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		lda #$8e
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y
		ldx #SpriteIndex_FlipDiskSprites
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1
		inx
		stx SpriteVals + 2
		inx
		stx SpriteVals + 3
		inx
		stx SpriteVals + 4
		inx
		stx SpriteVals + 5
		inx
		stx SpriteVals + 6
		inx
		stx SpriteVals + 7

		jsr BlitSprite

	//; Row 2
		lda #$a0
	WaitForSpriteRow2:
		cmp VIC_D012
		bne WaitForSpriteRow2

		lda #$a3
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		ldx #SpriteIndex_FlipDiskSprites + 8
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1
		inx
		stx SpriteVals + 2
		inx
		stx SpriteVals + 3

	//; Row 3
		lda #$b5
	WaitForSpriteRow3:
		cmp VIC_D012
		bne WaitForSpriteRow3

		lda #$b8
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		ldx #SpriteIndex_FlipDiskSprites + 12
		stx SpriteVals + 4
		inx
		stx SpriteVals + 5
		inx
		stx SpriteVals + 6
		inx
		stx SpriteVals + 7

	//; Set bottom-border sprites
		lda #$ca
	WaitForBottomBorderSafe:
		cmp VIC_D012
		bne WaitForBottomBorderSafe

		lda #$ff
		sta VIC_SpriteEnable
		lda #$00
		sta VIC_SpriteDrawPriority

		jsr SetSpriteY_Row2
		jsr SetSpritesRow2

	SkipSprites:

		IRQManager_EndIRQ()
		rti

PrepSprites_Row0:

	TheLogo_XIndex:
		ldx #$00
		inx
		stx TheLogo_XIndex + 1
	SantasLogo_XIndex:
		ldy #$35
		iny
		sty SantasLogo_XIndex + 1

		lda TopSinTables_Santas_XMSB, x
		sta Set_SpriteXMSB_TheSantas_Bottom + 1
		and #$f8
		ora TopSinTables_The_XMSB, y
		sta Set_SpriteXMSB_TheSantas_Top + 1

		lda TopSinTables_Santas_X, x
		sta Set_Santas_SpriteXPos0 + 1
		clc
		adc #$1c
		sta Set_Santas_SpriteXPos1 + 1
		clc
		adc #$1c
		sta Set_Santas_SpriteXPos2 + 1
		clc
		adc #$1c
		sta Set_Santas_SpriteXPos3 + 1
		clc
		adc #$1c
		sta Set_Santas_SpriteXPos4 + 1
		clc
		adc #$1c
		sta Set_Santas_SpriteXPos5 + 1

		lda TopSinTables_The_X, y
		sta Set_The_SpriteXPos0 + 1
		clc
		adc #$1c
		sta Set_The_SpriteXPos1 + 1
		clc
		adc #$1c
		sta Set_The_SpriteXPos2 + 1

		rts


PrepSprites_Row2:

		ldx #$00
		inx
		stx PrepSprites_Row2 + 1

		lda BottomSinTables_2020_X, x
		sta Set_SpriteXPos0_Row2 + 1
		clc
		adc #$1c
		sta Set_SpriteXPos1_Row2 + 1
		clc
		adc #$1c
		sta Set_SpriteXPos2_Row2 + 1
		clc
		adc #$1c
		sta Set_SpriteXPos3_Row2 + 1

		lda BottomSinTables_XMAS_X, x
		sta Set_SpriteXPos4_Row2 + 1
		clc
		adc #$34
		sta Set_SpriteXPos5_Row2 + 1
		clc
		adc #$34
		sta Set_SpriteXPos6_Row2 + 1
		clc
		adc #$34
		sta Set_SpriteXPos7_Row2 + 1

		lda BottomSinTables_2020_XMSB, x
		ora BottomSinTables_XMAS_XMSB, x
		sta Set_SpriteXMSB_Row2 + 1

		rts


SetSpriteY_Row0:

		lda #$13
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y

		lda #$2b
		sta VIC_Sprite3Y
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y

		lda #$1d
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		rts

SetSpriteY_Row1:

		lda #$2b
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y

		rts

SetSpriteY_Row2:

		lda #$ff
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		rts

SetSpritesRow0:

		lda #$ff
		sta VIC_SpriteEnable

	Set_The_SpriteXPos0:
		lda #$ff
		sta VIC_Sprite0X
	Set_The_SpriteXPos1:
		lda #$ff
		sta VIC_Sprite1X
	Set_The_SpriteXPos2:
		lda #$ff
		sta VIC_Sprite2X

	Set_Santas_SpriteXPos3:
		lda #$ff
		sta VIC_Sprite3X
	Set_Santas_SpriteXPos4:
		lda #$ff
		sta VIC_Sprite4X
	Set_Santas_SpriteXPos5:
		lda #$ff
		sta VIC_Sprite5X

	Set_SpriteXMSB_TheSantas_Top:
		lda #$ff
		sta VIC_SpriteXMSB

		lda #$48
		sta VIC_Sprite6X
		lda #$78
		sta VIC_Sprite7X

		ldx #SpriteIndex_TopLogo_The
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1
		inx
		stx SpriteVals + 2

		ldx #SpriteIndex_TopLogo_Santas + 3
		stx SpriteVals + 3
		inx
		stx SpriteVals + 4
		inx
		stx SpriteVals + 5

		ldx #SpriteIndex_HiResTop
		stx SpriteVals + 6
		inx
		stx SpriteVals + 7

		lda #$02
		sta VIC_SpriteExtraColour0
		lda #$0a
		sta VIC_SpriteExtraColour1

		lda #$c0
		sta VIC_SpriteDoubleWidth

		lda #$3f
		sta VIC_SpriteMulticolourMode

		lda #$0f
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour

		lda #$06
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

		rts

SetSpritesRow1:

	Set_Santas_SpriteXPos0:
		lda #$ff
		sta VIC_Sprite0X
	Set_Santas_SpriteXPos1:
		lda #$ff
		sta VIC_Sprite1X
	Set_Santas_SpriteXPos2:
		lda #$ff
		sta VIC_Sprite2X

	Set_SpriteXMSB_TheSantas_Bottom:
		lda #$ff
		sta VIC_SpriteXMSB

		ldx #SpriteIndex_TopLogo_Santas + 0
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1
		inx
		stx SpriteVals + 2

		lda #$01
		sta VIC_SpriteExtraColour0
		lda #$07
		sta VIC_SpriteExtraColour1

		rts

SetSpritesRow2:

	Set_SpriteXPos0_Row2:
		lda #$ff
		sta VIC_Sprite0X
	Set_SpriteXPos1_Row2:
		lda #$ff
		sta VIC_Sprite1X
	Set_SpriteXPos2_Row2:
		lda #$ff
		sta VIC_Sprite2X
	Set_SpriteXPos3_Row2:
		lda #$ff
		sta VIC_Sprite3X
	Set_SpriteXPos4_Row2:
		lda #$ff
		sta VIC_Sprite4X
	Set_SpriteXPos5_Row2:
		lda #$ff
		sta VIC_Sprite5X
	Set_SpriteXPos6_Row2:
		lda #$ff
		sta VIC_Sprite6X
	Set_SpriteXPos7_Row2:
		lda #$ff
		sta VIC_Sprite7X
	Set_SpriteXMSB_Row2:
		lda #$ff
		sta VIC_SpriteXMSB

		lda #$0f
		sta VIC_SpriteMulticolourMode

		lda #$f0
		sta VIC_SpriteDoubleWidth

		ldx #SpriteIndex_Logo_2020
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1
		inx
		stx SpriteVals + 2
		inx
		stx SpriteVals + 3

		ldx #SpriteIndex_Logo_XMas
		stx SpriteVals + 4
		inx
		stx SpriteVals + 5
		inx
		stx SpriteVals + 6
		inx
		stx SpriteVals + 7

		lda #$0f
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour

		lda #$02
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

		rts

* = * "BlitSprite"
.import source "../../../Out/6502/Parts/ChristmasBall/BlitSprite.asm"

BlitSprite:
		ldy #$00

		lda #>(FlipDiskSpriteAddress + (0 * 256))
		sta BlitSpriteWriteAddress + 2

		lda AnimFramePtrsLo, y
		sta BlitReadAddress0 + 1
		sta BlitReadAddress1 + 1
		lda AnimFramePtrsHi, y
		sta BlitReadAddress0 + 2
		sta BlitReadAddress1 + 2
		iny
		cpy #96
		bne Not96
		ldy #0
	Not96:
		sty BlitSprite + 1

	BlitRowOuterLoop:
		ldy #$00
	BlitRowLoop:
	BlitReadAddress0:
		lda $abcd, y
		iny
		cmp #$ff
		beq FinishedBlittingRow
		tax
	BlitReadAddress1:
		lda $abcd, y
	BlitSpriteWriteAddress:
		sta FlipDiskSpriteAddress + (0 * 256), x
		iny
		bne BlitRowLoop
	FinishedBlittingRow:
		tya
		clc
		adc BlitReadAddress0 + 1
		sta BlitReadAddress0 + 1
		sta BlitReadAddress1 + 1
		lda BlitReadAddress0 + 2
		adc #$00
		sta BlitReadAddress0 + 2
		sta BlitReadAddress1 + 2
		inc BlitSpriteWriteAddress + 2
		lda BlitSpriteWriteAddress + 2
		cmp #>(FlipDiskSpriteAddress + (4 * 256))
		bne BlitRowOuterLoop

		rts

EaseInScreen_Fade0:

		.for (var i = 0; i < 25; i++)
		{
			lda BitmapColourSrcAddr + (i * 40), y
			sta VIC_ColourMemory + (i * 40), y

			lda BitmapScreenSrcAddr + (i * 40), y
			sta ScreenAddress + (i * 40), y
		}
		rts

		.for (var i = 0; i < 25; i++)
		{
			lda BitmapColourSrcAddr + (i * 40), x
			sta VIC_ColourMemory + (i * 40), x

			lda BitmapScreenSrcAddr + (i * 40), x
			sta ScreenAddress + (i * 40), x
		}
		rts

EaseInScreen:

EaseInScreen_RowIndex:
		ldx #24
		ldy #6

	EaseIn_LoopRows:
		cpx #$00
		bmi EaseIn_SkipRow

		stx EaseIn_XStore + 1
		sty EaseIn_YStore + 1

		jsr DoScreenRow

	EaseIn_XStore:
		ldx #$ab
	EaseIn_YStore:
		ldy #$ab

	EaseIn_SkipRow:
		dey
		bmi EaseIn_FinishedAllRows
		inx
		cpx #25
		bne EaseIn_LoopRows

	EaseIn_FinishedAllRows:
		lda EaseInScreen_RowIndex + 1
		sec
		sbc #$01
		sta EaseInScreen_RowIndex + 1
		cmp #$f9
		bne EaseIn_NotFinished
		lda #$00
		sta ScreenEaseMode
	EaseIn_NotFinished:

		rts

EaseOutScreen:

EaseOutScreen_RowIndex:
		ldx #0
		ldy #1

	EaseOut_LoopRows:
		cpx #25
		bcs EaseOut_SkipRow

		stx EaseOut_XStore + 1
		sty EaseOut_YStore + 1

		jsr DoScreenRow

	EaseOut_XStore:
		ldx #$ab
	EaseOut_YStore:
		ldy #$ab

	EaseOut_SkipRow:
		iny
		cpy #8
		beq EaseOut_FinishedAllRows
		dex
		bpl EaseOut_LoopRows

	EaseOut_FinishedAllRows:
		lda EaseOutScreen_RowIndex + 1
		clc
		adc #$01
		cmp #25 + 7
		bne EaseOut_NotFinished
		rts
	EaseOut_NotFinished:
		sta EaseOutScreen_RowIndex + 1

		rts

ScreenPtrLo:			.fill 25, <(i * 40)
ScreenPtrHi:			.fill 25, >(i * 40)

DoScreenRow:

//; x = screen row
//; y = fade amount (0 - 6)

		cpy #$00
		bne NotScreenRowFill
		jmp DoScreenRowFill
	NotScreenRowFill:
		cpy #$07
		bne DoScreenRowFade

	IsScreenRowBlank:

		lda ScreenPtrLo, x
		sta OutCOLPtr2 + 1
		sta OutSCRPtr2 + 1
		lda ScreenPtrHi, x
		ora #>VIC_ColourMemory
		sta OutCOLPtr2 + 2
		lda ScreenPtrHi, x
		ora #>ScreenAddress
		sta OutSCRPtr2 + 2

		ldx #$27
		lda #$00
	UpdateRowLoop2:
	OutCOLPtr2:
		sta $abcd, x
	OutSCRPtr2:
		sta $abcd, x

		dex
		bpl UpdateRowLoop2

		rts


	DoScreenRowFade:

		lda ScreenPtrLo, x
		sta InCOLPtr0 + 1
		sta OutCOLPtr0 + 1
		sta InSCRPtr0 + 1
		sta OutSCRPtr0 + 1
		lda ScreenPtrHi, x
		ora #>BitmapColourSrcAddr
		sta InCOLPtr0 + 2
		lda ScreenPtrHi, x
		ora #>BitmapScreenSrcAddr
		sta InSCRPtr0 + 2
		lda ScreenPtrHi, x
		ora #>VIC_ColourMemory
		sta OutCOLPtr0 + 2
		lda ScreenPtrHi, x
		ora #>ScreenAddress
		sta OutSCRPtr0 + 2

		tya
		clc
		adc #>ColourFadeTableAddr - 1
		sta ScreenFadePtr0A + 2
		sta ScreenFadePtr0B + 2

		ldx #$27

	UpdateRowLoop0:

	InCOLPtr0:
		ldy BitmapColourSrcAddr, x
	ScreenFadePtr0A:
		lda $0000, y
	OutCOLPtr0:
		sta $abcd, x
		
	InSCRPtr0:
		ldy BitmapScreenSrcAddr, x
	ScreenFadePtr0B:
		lda $0000, y
	OutSCRPtr0:
		sta $abcd, x

		dex
		bpl UpdateRowLoop0

		rts		

	DoScreenRowFill:

		lda ScreenPtrLo, x
		sta InCOLPtr1 + 1
		sta OutCOLPtr1 + 1
		sta InSCRPtr1 + 1
		sta OutSCRPtr1 + 1
		lda ScreenPtrHi, x
		ora #>BitmapColourSrcAddr
		sta InCOLPtr1 + 2
		lda ScreenPtrHi, x
		ora #>BitmapScreenSrcAddr
		sta InSCRPtr1 + 2
		lda ScreenPtrHi, x
		ora #>VIC_ColourMemory
		sta OutCOLPtr1 + 2
		lda ScreenPtrHi, x
		ora #>ScreenAddress
		sta OutSCRPtr1 + 2

		ldx #$27

	UpdateRowLoop1:

	InCOLPtr1:
		lda BitmapColourSrcAddr, x
	OutCOLPtr1:
		sta $abcd, x
		
	InSCRPtr1:
		lda BitmapScreenSrcAddr, x
	OutSCRPtr1:
		sta $abcd, x

		dex
		bpl UpdateRowLoop1

		rts		

InitColourTables:

		ldx #$00
	MainLoop:
		txa
		asl
		asl
		asl
		asl
		sta ColFadeTabReadA + 1
		sta ColFadeTabReadB + 1

		ldy #$00
	YLoop:
		ldx #15
	XLoop:

	ColFadeTabReadA:
		lda ColourFadeTableLoad + (0 * 16), y
		asl
		asl
		asl
		asl
	ColFadeTabReadB:
		ora ColourFadeTableLoad + (0 * 16), x
	OutColourFadePtr:
		sta ColourFadeTableAddr + (0 * 256), x

		dex
		bpl XLoop
		
		lda OutColourFadePtr + 1
		clc
		adc #$10
		sta OutColourFadePtr + 1
		bne NotIncHi
		inc OutColourFadePtr + 2
	NotIncHi:

		iny
		cpy #16
		bne YLoop

	MainIndex:
		ldx #$00
		inx
		stx MainIndex + 1
		cpx #6
		bne MainLoop

		rts

		
