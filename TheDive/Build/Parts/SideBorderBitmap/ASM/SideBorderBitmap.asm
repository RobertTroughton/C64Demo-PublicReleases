//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = SBB_BASE "Side Border Bitmap"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp SBB_Init								//; Init
		jmp SBB_MainThreadFunc						//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-1fff Music
//; - $3c00-3fff Sintables
//; - $4000-467f Sideborder Sprites
//; ---- $4680-49bf Scroller Sprites
//; ---- $5800-5bff Screen 0
//; ---- $5c00-5fff Screen 1
//; - $6000-7fff Bitmap
//; - $8000-b50d Code
//; - $c000-cc7a 24px Font Data
//; - $e000-e37f Bitmap Screen Data
//; - $e400-e77f Bitmap Colour Data
//; - $f000-f05f Scrolltext

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3fe7]
	.var ScreenBank0 = 6 //; Bank+[1800,1bff]
	.var ScreenBank1 = 7 //; Bank+[1c00,1fff]
	.var ScreenAddress0 = (Base_BankAddress + (ScreenBank0 * $400))
	.var ScreenAddress1 = (Base_BankAddress + (ScreenBank1 * $400))
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))
	.var Bank_SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var Bank_SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var SBB_ScreenMemoryForCopying = $e000
	.var SBB_ColourMemoryForCopying = $e400

	.var SBB_ScreenColour = $00

	.var VICBankValue = (3 - BitmapBank)

	.var SideBorderLeftFirstSpriteValue = 0
	.var SideBorderRightFirstSpriteValue = 13

	.var FirstSpriteValueForScroller = 26
	.var ScrollerSpriteDataAddress = (Base_BankAddress + FirstSpriteValueForScroller * 64)

	.var BlankSpriteValue = 39

	.var SpriteXSintable_X0 = $3c00
	.var SpriteXSintable_X1 = $3e00

	.var ScrollText = $f000

	.var ZP_SpriteX0Values = $30
	.var ZP_SpriteX1Values = $94

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank * 8)
	.var D016_Value_SingleColour = $10
	.var D016_Value_MultiColour = $10
	.var D016_Value_38Rows = $00
	.var D016_Value_40Rows = $08
	.var D011_Value_CharScreen = $10
	.var D011_Value_Bitmap = $30
	.var D011_Value_24Rows = $03
	.var D011_Value_25Rows = $0b

	.var MainRasterIRQLine = $30
	.var SpriteStartYPos = $31

//; SBB_LocalData -------------------------------------------------------------------------------------------------------
SBB_LocalData:

ScrollerNextBytes:
	.byte $00, $00, $00, $00, $00, $00

SBB_Mul3:
	.fill 85, (i * 3)

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $00									//; D008: VIC_Sprite4X
	.byte SpriteStartYPos						//; D009: VIC_Sprite4Y
	.byte 28									//; D00a: VIC_Sprite5X
	.byte SpriteStartYPos						//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte SpriteStartYPos						//; D00d: VIC_Sprite6Y
	.byte $58									//; D00e: VIC_Sprite7X
	.byte SpriteStartYPos						//; D00f: VIC_Sprite7Y
	.byte $80									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte $10									//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $00									//; D020: VIC_BorderColour
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
	.byte $01									//; D02B: VIC_Sprite4Colour
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $06									//; D02D: VIC_Sprite6Colour
	.byte $06									//; D02E: VIC_Sprite7Colour

SpriteMSBTable:
	.byte $00, $20

//; SBB_Init() -------------------------------------------------------------------------------------------------------
SBB_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		ldy #$00
		tya
	SBB_ClearScrollerSprites:
		sta ScrollerSpriteDataAddress + (0 * 256), y
		sta ScrollerSpriteDataAddress + (1 * 256), y
		sta ScrollerSpriteDataAddress + (2 * 256), y
		sta ScrollerSpriteDataAddress + (3 * 256), y
		iny
		bne SBB_ClearScrollerSprites

		ldy #$00
		lda #$00
	FillScreenBufferLoop:
		.for(var Page = 0; Page < 4; Page++)
		{
			sta ScreenAddress0 + (Page * 256), y
			sta ScreenAddress1 + (Page * 256), y
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillScreenBufferLoop

		jsr SBB_UpdateXPositions

		bit	VIC_D011
		bpl	*-3
		bit	VIC_D011
		bmi	*-3

		sei
		jsr SBB_SetTB0IRQ
		asl VIC_D019
		cli
	
		rts

SBB_SetTB0IRQ:
		lda VIC_D011
		and #$7f
		sta VIC_D011

		lda #$f8
		sta VIC_D012
		lda #<SBB_IRQ_OpenTopBottomBorders0
		sta $fffe
		lda #>SBB_IRQ_OpenTopBottomBorders0
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SBB_SetTB1IRQ:

		lda #$fe
		sta VIC_D012
		lda #<SBB_IRQ_OpenTopBottomBorders1
		sta $fffe
		lda #>SBB_IRQ_OpenTopBottomBorders1
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SBB_SetMainIRQ:

		lda VIC_D011
		and #$3f
		sta VIC_D011
		lda #MainRasterIRQLine
		sta VIC_D012
		lda #<SBB_IRQ_Main
		sta $fffe
		lda #>SBB_IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SBB_IRQ_OpenTopBottomBorders0:

		:IRQManager_BeginIRQ(0, 0)
		
		lda #$33
		sta VIC_D011

		jsr SBB_SetTB1IRQ

		:IRQManager_EndIRQ()
		rti


SBB_IRQ_OpenTopBottomBorders1:

		:IRQManager_BeginIRQ(0, 0)

		lda #$3b
		sta VIC_D011

		jsr BASECODE_PlayMusic

		jsr SBB_InitialSpriteSetup

		jsr SBB_SetMainIRQ

		:IRQManager_EndIRQ()
		rti


SBB_IRQ_Main:
		
		:IRQManager_BeginIRQ(1, 0)

		nop $ff
		nop

		jsr SBB_IRQ_GeneratedMainCode

		jsr BASECODE_PlayMusic

		jsr SBB_DoScrollText

		jsr SBB_UpdateXPositions

		lda #$3b
		sta VIC_D011

		jsr SBB_PreScroll

		inc Signal_VBlank

		jsr SBB_SetMainIRQ
		:IRQManager_EndIRQ()
		rti

SBB_DoScrollText:

		lda #$00
		sta ScrollerNextBytes + 0
		sta ScrollerNextBytes + 1
		sta ScrollerNextBytes + 2
		sta ScrollerNextBytes + 3
		sta ScrollerNextBytes + 4
		sta ScrollerNextBytes + 5

	Scroll_SpacingAmount:
		ldx #$40
		beq Scroll_CurrentCharYPos
		dex
		stx Scroll_SpacingAmount + 1
		rts

	Scroll_CurrentCharYPos:
		ldy #$00
		ldx #$00
	Scroll_CurrentCharPtr:
		lda CharData_0, y
		sta ScrollerNextBytes, x
		inx
		iny
		cpx #$06
		bne Scroll_CurrentCharPtr

//;	Scroll_SkipCharRead:
		lda Scroll_CurrentCharYPos + 1
		clc
		adc #$06
	Scroll_CurrentCharHeight:
		cmp #(6 * 3)
		bne Scroll_NotFinishedChar

		ldx #$00
		lda SBB_FadeOutIndex + 1
		bpl SkipScrollTextAdvancer

	Scroll_ScrollTextRead:
		ldx ScrollText
		cpx #$ff
		bne Scroll_NotEndOfScrollText

	StartTheFadeOut:
		lda #12
		sta SBB_FadeOutIndex + 1
		ldx #$00
		jmp SkipScrollTextAdvancer

	Scroll_NotEndOfScrollText:
		inc Scroll_ScrollTextRead + 1
		bne SkipScrollTextAdvancer
		inc Scroll_ScrollTextRead + 2

	SkipScrollTextAdvancer:
		lda CharDataLookups_Lo, x
		sta Scroll_CurrentCharPtr + 1
		lda CharDataLookups_Hi, x
		sta Scroll_CurrentCharPtr + 2

		ldy CharDataHeights, x
		lda SBB_Mul3, y
		sta Scroll_CurrentCharHeight + 1

		lda #$03
		sta Scroll_SpacingAmount + 1
		lda #$00
		sta Scroll_CurrentCharYPos + 1

		rts

	Scroll_NotFinishedChar:
		sta Scroll_CurrentCharYPos + 1
		rts

.import source "..\..\..\..\Intermediate\Built\SideBorderBitmap\24pxFont.asm"
.import source "..\..\..\..\Intermediate\Built\SideBorderBitmap\rastercode.asm"

SBB_MainThreadFunc:
		lda SBB_FadeInIndex + 1
		bmi FadeInFinished
		jmp SBB_FadeIn
	FadeInFinished:

		lda SBB_FadeOutIndex + 1
		bmi FadeOutFinished
		jmp SBB_FadeOut
	FadeOutFinished:

		rts

SBB_SpriteValsLeftTableLo:
	.byte <( SBB_BorderSpriteValueL0 + 1), <( SBB_BorderSpriteValueL1 + 1), <( SBB_BorderSpriteValueL2 + 1), <( SBB_BorderSpriteValueL3 + 1), <( SBB_BorderSpriteValueL4 + 1)
	.byte <( SBB_BorderSpriteValueL5 + 1), <( SBB_BorderSpriteValueL6 + 1), <( SBB_BorderSpriteValueL7 + 1), <( SBB_BorderSpriteValueL8 + 1), <( SBB_BorderSpriteValueL9 + 1)
	.byte <(SBB_BorderSpriteValueL10 + 1), <(SBB_BorderSpriteValueL11 + 1), <(SBB_BorderSpriteValueL12 + 1)
SBB_SpriteValsLeftTableHi:
	.byte >( SBB_BorderSpriteValueL0 + 1), >( SBB_BorderSpriteValueL1 + 1), >( SBB_BorderSpriteValueL2 + 1), >( SBB_BorderSpriteValueL3 + 1), >( SBB_BorderSpriteValueL4 + 1)
	.byte >( SBB_BorderSpriteValueL5 + 1), >( SBB_BorderSpriteValueL6 + 1), >( SBB_BorderSpriteValueL7 + 1), >( SBB_BorderSpriteValueL8 + 1), >( SBB_BorderSpriteValueL9 + 1)
	.byte >(SBB_BorderSpriteValueL10 + 1), >(SBB_BorderSpriteValueL11 + 1), >(SBB_BorderSpriteValueL12 + 1)

SBB_SpriteValsRightTableLo:
	.byte <( SBB_BorderSpriteValueR0 + 1), <( SBB_BorderSpriteValueR1 + 1), <( SBB_BorderSpriteValueR2 + 1), <( SBB_BorderSpriteValueR3 + 1), <( SBB_BorderSpriteValueR4 + 1)
	.byte <( SBB_BorderSpriteValueR5 + 1), <( SBB_BorderSpriteValueR6 + 1), <( SBB_BorderSpriteValueR7 + 1), <( SBB_BorderSpriteValueR8 + 1), <( SBB_BorderSpriteValueR9 + 1)
	.byte <(SBB_BorderSpriteValueR10 + 1), <(SBB_BorderSpriteValueR11 + 1), <(SBB_BorderSpriteValueR12 + 1)
SBB_SpriteValsRightTableHi:
	.byte >( SBB_BorderSpriteValueR0 + 1), >( SBB_BorderSpriteValueR1 + 1), >( SBB_BorderSpriteValueR2 + 1), >( SBB_BorderSpriteValueR3 + 1), >( SBB_BorderSpriteValueR4 + 1)
	.byte >( SBB_BorderSpriteValueR5 + 1), >( SBB_BorderSpriteValueR6 + 1), >( SBB_BorderSpriteValueR7 + 1), >( SBB_BorderSpriteValueR8 + 1), >( SBB_BorderSpriteValueR9 + 1)
	.byte >(SBB_BorderSpriteValueR10 + 1), >(SBB_BorderSpriteValueR11 + 1), >(SBB_BorderSpriteValueR12 + 1)

SBB_SpriteValLeftTable:
	.fill 13, SideBorderLeftFirstSpriteValue + i
SBB_SpriteValRightTable:
	.fill 13, SideBorderRightFirstSpriteValue + i

SBB_ScreenPtrsTableLo:
	.fill 13, (i * 80)
SBB_ScreenCopyPtrsTableHi:
	.fill 13, >(SBB_ScreenMemoryForCopying + (i * 80))
SBB_ColourCopyPtrsTableHi:
	.fill 13, >(SBB_ColourMemoryForCopying + (i * 80))
SBB_ScreenPtrsTableHi:
	.byte >(ScreenAddress0 + ( 0 * 80))
	.byte >(ScreenAddress1 + ( 1 * 80))
	.byte >(ScreenAddress0 + ( 2 * 80))
	.byte >(ScreenAddress1 + ( 3 * 80))
	.byte >(ScreenAddress0 + ( 4 * 80))
	.byte >(ScreenAddress1 + ( 5 * 80))
	.byte >(ScreenAddress0 + ( 6 * 80))
	.byte >(ScreenAddress1 + ( 7 * 80))
	.byte >(ScreenAddress0 + ( 8 * 80))
	.byte >(ScreenAddress1 + ( 9 * 80))
	.byte >(ScreenAddress0 + (10 * 80))
	.byte >(ScreenAddress1 + (11 * 80))
	.byte >(ScreenAddress0 + (12 * 80))
SBB_ColourPtrsTableHi:
	.fill 13, >(VIC_ColourMemory + (i * 80))
SBB_StartYCount:
	.fill 12, 79
	.byte 39

SBB_FadeIn:

	SBB_FadeInIndex:
		ldx #12

		lda SBB_SpriteValsLeftTableLo, x
		sta FI_OutputSprValueLeft + 1
		lda SBB_SpriteValsLeftTableHi, x
		sta FI_OutputSprValueLeft + 2
		lda SBB_SpriteValsRightTableLo, x
		sta FI_OutputSprValueRight + 1
		lda SBB_SpriteValsRightTableHi, x
		sta FI_OutputSprValueRight + 2

		lda SBB_ScreenPtrsTableLo, x
		sta FI_InputScrCopy + 1
		sta FI_InputColCopy + 1
		sta FI_OutputScrCopy + 1
		sta FI_OutputColCopy + 1

		lda SBB_ScreenCopyPtrsTableHi, x
		sta FI_InputScrCopy + 2
		lda SBB_ColourCopyPtrsTableHi, x
		sta FI_InputColCopy + 2

		lda SBB_ScreenPtrsTableHi, x
		sta FI_OutputScrCopy + 2
		lda SBB_ColourPtrsTableHi, x
		sta FI_OutputColCopy + 2

		ldy SBB_StartYCount, x

	FI_InputScrCopyLoop:
	FI_InputScrCopy:
		lda $ff00, y
	FI_OutputScrCopy:
		sta $ff00, y
	FI_InputColCopy:
		lda $ff00, y
	FI_OutputColCopy:
		sta $d800, y
		dey
		bpl FI_InputScrCopyLoop

		lda SBB_SpriteValLeftTable, x
	FI_OutputSprValueLeft:
		sta $ffff

		lda SBB_SpriteValRightTable, x
	FI_OutputSprValueRight:
		sta $ffff

		dex
		stx SBB_FadeInIndex + 1

		rts

SBB_FadeOut:

	SBB_FadeOutIndex:
		ldx #$ff
		lda SBB_SpriteValsLeftTableLo, x
		sta FO_OutputSprValueLeft + 1
		lda SBB_SpriteValsLeftTableHi, x
		sta FO_OutputSprValueLeft + 2
		lda SBB_SpriteValsRightTableLo, x
		sta FO_OutputSprValueRight + 1
		lda SBB_SpriteValsRightTableHi, x
		sta FO_OutputSprValueRight + 2

		lda SBB_ScreenPtrsTableLo, x
		sta FO_OutputScrFill + 1
		sta FO_OutputColFill + 1
		lda SBB_ScreenPtrsTableHi, x
		sta FO_OutputScrFill + 2
		lda SBB_ColourPtrsTableHi, x
		sta FO_OutputColFill + 2

		lda #BlankSpriteValue
	FO_OutputSprValueLeft:
		sta $ffff
	FO_OutputSprValueRight:
		sta $ffff

		ldy SBB_StartYCount, x
		lda #$00

	FO_InputScrFillLoop:
	FO_OutputScrFill:
		sta $ff00, y
	FO_OutputColFill:
		sta $d800, y
		dey
		bpl FO_InputScrFillLoop

		dex
		stx SBB_FadeOutIndex + 1
		bne NotFinishedThisDemoPart

		inc Signal_CurrentEffectIsFinished
	NotFinishedThisDemoPart:

		rts
