//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = GPLogo_BASE "Startup GP Logo"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp GPLOGO_Init								//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0200-023f Demo Main Driver
//; - $0800-08ff Disk Side Driver
//; - $0a00-0bff Nucrunch
//; - $0c00-0dff Spindle
//; - $0e00-0eff Spindle (used while loading)
//; - $0f00-0fbf Base Code
//; ---- $0fc0-0fff Global Variables

//; - $1000-1fff Music

//; - $4000-5111 Main code
//; - $ac00-afff Scroller Font (backup)
//; - $b000-bfff ScrollText
//; - $c000-dbff Bitmap Image Data
//; - $dc00-dfff Scroller Font
//; ---- $e000-e3ff Screen
//; - $e400-efff Fish SubPixel Animation Sprites
//; - $f000-f1ff Fish sinwaves Sprite Vals
//; - $f200-f3ff Fish sinwaves X Vals + XMSB
//; - $f400-f47f Fish sinwaves Y Vals
//; - $f800-f8ff Scroller Side Border Sprites

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))
	.var ScreenBank = 8 //; Bank+[2000,23ff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)
	.var CharBank = 3 //; Bank+[1800,1fff]	//; nb. we only use the top half - so that we don't intersect bitmap memory!
	.var CharAddress = (Base_BankAddress + (CharBank * 2048))

	.var ScrollTextADDR = $b000
	.var ZP_ColourTablePtr = $f0
	.var ZP_ScrollPtr = $f2
	.var ZP_ScrollPtr2 = $f4
	.var ZP_TopBorderColour = $f6
	.var ZP_BottomBorderColour = $f7

	.var FontDataADDR = $ac00

	.var D016Value = $18
	.var D018ValueBitmap = (ScreenBank * 16) + (BitmapBank * 8)
	.var D018ValueChar = (ScreenBank * 16) + (CharBank * 2)

	.var SpriteDataOffset = $2400
	.var FirstSpriteIndex = (SpriteDataOffset / 64)
	.var SpriteDataAddress = (Base_BankAddress + SpriteDataOffset)
	.var NumSpriteAnims = 14

	.var Split0 = 82	//; blue border
	.var Split1 = 218	//; black border

	.var FishSineWavesSpriteVal = $f000
	.var FishSineWavesX = $f200
	.var FishSineWavesY = $f400

	.var SideBorderSpriteDataOffset = $3800
	.var SideBorderSpriteData = (Base_BankAddress + SideBorderSpriteDataOffset)
	.var SideBorderSpriteVal = (SideBorderSpriteDataOffset / 64)

	.var Fish_Sprite0X = $40
	.var Fish_Sprite1X = $58
	.var Fish_Sprite2X = $70
	.var Fish_Sprite3X = $4c
	.var Fish_Sprite4X = $64

	.var Fish_Sprite0Y = $89
	.var Fish_Sprite1Y = $90
	.var Fish_Sprite2Y = $97
	.var Fish_Sprite3Y = $9c
	.var Fish_Sprite4Y = $a1

	.var SplitNumFrames = 56
	Split0TableLo:
		.fill 48, i + 7
		.fill SplitNumFrames - 48, 55
	Split1TableLo:
		.fill SplitNumFrames, <(296 - (i * 2))
	Split1TableHi:
		.fill SplitNumFrames - 1, (>(296 - (i * 2))) * 128
		.byte $3b
	SplitFrame:
		.byte $00

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $60									//; D000: VIC_Sprite0X
	.byte $aa									//; D001: VIC_Sprite0Y
	.byte $50									//; D002: VIC_Sprite1X
	.byte $ae									//; D003: VIC_Sprite1Y
	.byte $80									//; D004: VIC_Sprite2X
	.byte $b2									//; D005: VIC_Sprite2Y
	.byte $70									//; D006: VIC_Sprite3X
	.byte $b6									//; D007: VIC_Sprite3Y
	.byte $74									//; D008: VIC_Sprite4X
	.byte $ba									//; D009: VIC_Sprite4Y
	.byte $88									//; D00a: VIC_Sprite5X
	.byte $be									//; D00b: VIC_Sprite5Y
	.byte $68									//; D00c: VIC_Sprite6X
	.byte $c2									//; D00d: VIC_Sprite6Y
	.byte $54									//; D00e: VIC_Sprite7X
	.byte $c6									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016Value								//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018ValueBitmap						//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $09									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $06									//; D021: VIC_ScreenColour
	.byte $06									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $0a									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $0e									//; D027: VIC_Sprite0Colour
	.byte $0e									//; D028: VIC_Sprite1Colour
	.byte $0e									//; D029: VIC_Sprite2Colour
	.byte $0e									//; D02A: VIC_Sprite3Colour
	.byte $0e									//; D02B: VIC_Sprite4Colour
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

.align 8
SubMod8:
	.byte 6, 7, 0, 1, 2, 3, 4, 5
ShouldScroll:
	.byte 1, 1, 0, 0, 0, 0, 0, 0

.align 256
GPLOGO_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		lda #<(ScrollTextADDR + 12)
		sta ZP_ScrollPtr2 + 0
		lda #>(ScrollTextADDR + 12)
		sta ZP_ScrollPtr2 + 1
		lda #<ScrollTextADDR
		sta ZP_ScrollPtr + 0
		lda #>ScrollTextADDR
		sta ZP_ScrollPtr + 1

		ldy #$00
	FillColourMemoryLoop:
		lda #$00
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		lda #$fe
		sta ScreenAddress + (0 * 256), y
		sta ScreenAddress + (1 * 256), y
		sta ScreenAddress + (2 * 256), y
		sta ScreenAddress + (840 - 256), y
		iny
		bne FillColourMemoryLoop

		ldy #39
	FillColourMemoryLoop2:
		lda #$00
		sta ScreenAddress + 840, y
		lda #$a0
		sta ScreenAddress + 880, y
		sta ScreenAddress + 920, y
		sta ScreenAddress + 960, y
		lda #$00
		sta VIC_ColourMemory + 840, y
		sta VIC_ColourMemory + 880, y
		sta VIC_ColourMemory + 920, y
		sta VIC_ColourMemory + 960, y
		dey
		bpl FillColourMemoryLoop2

		jsr ResetPlotColours
		jsr ClearScrollSprites

		lda #$06
		sta ZP_TopBorderColour
		lda #$00
		sta ZP_BottomBorderColour

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda Split0TableLo
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split0
		sta $fffe
		lda #>IRQ_Split0
		sta $ffff
		asl VIC_D019
		cli
		rts

ClearScrollSprites:
		ldy #$00
		lda #$ff
	FillScrollSpriteLoop:
		sta SideBorderSpriteData, y
		iny
		bne FillScrollSpriteLoop
		rts

.align 256
IRQ_Split0:
		:IRQManager_BeginIRQ(1, 0)

		lda ZP_TopBorderColour
		sta VIC_BorderColour
		sta VIC_ScreenColour

		lda #$1f
		sta VIC_SpriteEnable
		lda #$0e
		sta VIC_Sprite4Colour
		lda #$00
		sta VIC_SpriteXMSB

		jsr DoSpriteAnimations

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

		inc Signal_VBlank

		jsr BASECODE_PlayMusic

		ldx SplitFrame
		lda Split1TableLo, x
		sta VIC_D012
		lda VIC_D011
		and #$7f
		ora Split1TableHi, x
		sta VIC_D011

		inx
		cpx #SplitNumFrames
		beq DontIncrementSplitFrame
		stx SplitFrame
	DontIncrementSplitFrame:

		lda #<IRQ_Split1
		sta $fffe
		lda #>IRQ_Split1
		sta $ffff

		:IRQManager_EndIRQ()

		rti
	
.align 256
IRQ_Split1:
		:IRQManager_BeginIRQ(1, 0)

		lda ZP_BottomBorderColour
		sta VIC_BorderColour

		ldx SplitFrame
		cpx #(SplitNumFrames - 1)
		bne WaitForSafeVB

		lda #225
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split2
		sta $fffe
		lda #>IRQ_Split2
		sta $ffff
		jmp EndSplit1

	WaitForSafeVB:
		lda VIC_D011
		bpl WaitForSafeVB

		lda #$00
		sta VIC_ScreenColour

		lda Split0TableLo, x
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split0
		sta $fffe
		lda #>IRQ_Split0
		sta $ffff
	EndSplit1:

		:IRQManager_EndIRQ()

		rti

.align 256
IRQ_Split2:
		:IRQManager_BeginIRQ(1, 0)

		lda VIC_D011
		and #$1f
		sta VIC_D011
		lda #$00
		sta VIC_ScreenColour
		lda #D018ValueChar
		sta VIC_D018
	ScrollValue:
		lda #$00
		sta VIC_D016
		lda #$0e
		sta VIC_ScreenColour

		lda #230
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y
		lda ScrollValue + 1
		sta VIC_Sprite5X
		ora #$e0
		sta VIC_Sprite4X
		lda ScrollValue + 1
		ora #<(344)
		sta VIC_Sprite6X
		lda ScrollValue + 1
		ora #<(344 + 24)
		sta VIC_Sprite7X
		lda #$d0
		sta VIC_SpriteXMSB
		lda #$f0
		sta VIC_SpriteEnable
		lda #$00
		sta VIC_Sprite4Colour

		ldx #SideBorderSpriteVal
		stx Bank_SpriteVals + 4
		inx
		stx Bank_SpriteVals + 5
		inx
		stx Bank_SpriteVals + 6
		inx
		stx Bank_SpriteVals + 7

		lda #250 - 17
	WaitForSafeScrollPos:
		cmp VIC_D012
		bne WaitForSafeScrollPos

		lda ScrollValue + 1
		ora #$08
		tay
		lda #$00

		jsr OpenTheBorders

	WaitForSafeVB2:
		lda VIC_D011
		bpl WaitForSafeVB2

		lda #$18
		sta VIC_D016
		lda #$3b
		sta VIC_D011
		lda #D018ValueBitmap
		sta VIC_D018

		jsr DoPlotColours

	ScrollIndex:
		ldx ScrollValue + 1
		lda SubMod8, x
		sta ScrollValue + 1
		lda ShouldScroll, x
		beq DontScroll
		jsr DoScrollerScroll
	DontScroll:

		lda Split0TableLo + (SplitNumFrames - 1)
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split0
		sta $fffe
		lda #>IRQ_Split0
		sta $ffff

		:IRQManager_EndIRQ()

		rti
	
.align 256
ColourValues:
	.fill 2, $a1
	.fill 2, $ad
	.fill 2, $a3
	.fill 2, $ac
	.fill 192, $a4
	.fill 2, $ac
	.fill 2, $a3
	.fill 2, $ad
	.fill 2, $a1
	.fill 2, $11

	.fill 2, $17
	.fill 2, $77
	.fill 2, $7f
	.fill 2, $ff
	.fill 192, $fc
	.fill 2, $ff
	.fill 2, $7f
	.fill 2, $77
	.fill 2, $17
	.fill 2, $11

	.fill 2, $17
	.fill 2, $af
	.fill 2, $aa
	.fill 2, $a8
	.fill 192, $a2
	.fill 2, $a8
	.fill 2, $aa
	.fill 2, $af
	.fill 2, $17
	.fill 2, $11

	.fill 2, $d1
	.fill 2, $dd
	.fill 2, $3d
	.fill 2, $33
	.fill 192, $3e
	.fill 2, $33
	.fill 2, $3d
	.fill 2, $dd
	.fill 2, $d1
	.fill 2, $11

	.fill 2, $71
	.fill 2, $7d
	.fill 2, $d3
	.fill 192, $d5
	.fill 2, $d3
	.fill 2, $7d
	.fill 2, $71
	.fill 2, $11

	.fill 2, $17
	.fill 2, $1f
	.fill 2, $7f
	.fill 192, $7a
	.fill 2, $7f
	.fill 2, $1f
	.fill 2, $17
	.fill 2, $11

ColourValuesLoopPoint:
	.fill 2, $a1
	.fill 2, $ad
	.fill 2, $a3
	.fill 2, $ac
	.fill 192, $a4
	.fill 2, $ac
	.fill 2, $a3
	.fill 2, $ad
	.fill 2, $a1
	.fill 2, $11

.align 256
.import source "..\..\..\..\Intermediate\Built\GPLogo\ColourPlot.asm"

.align 256
DoSpriteAnimations:
		lda FrameOf256
		tax
		and #$3f
		tay

		lda #Fish_Sprite0X
		clc
		adc FishSineWavesX + (51 * 0), x
		sta VIC_Sprite0X
		lda #Fish_Sprite1X
		clc
		adc FishSineWavesX + (51 * 1), x
		sta VIC_Sprite1X
		lda #Fish_Sprite2X
		clc
		adc FishSineWavesX + (51 * 2), x
		sta VIC_Sprite2X
		lda #Fish_Sprite3X
		clc
		adc FishSineWavesX + (51 * 3), x
		sta VIC_Sprite3X
		lda #Fish_Sprite4X
		clc
		adc FishSineWavesX + (51 * 4), x
		sta VIC_Sprite4X

		lda #FirstSpriteIndex
		clc
		adc FishSineWavesSpriteVal + (51 * 0), x
		sta Bank_SpriteVals + 0
		lda #FirstSpriteIndex
		clc
		adc FishSineWavesSpriteVal + (51 * 1), x
		sta Bank_SpriteVals + 1
		lda #FirstSpriteIndex
		clc
		adc FishSineWavesSpriteVal + (51 * 2), x
		sta Bank_SpriteVals + 2
		lda #FirstSpriteIndex
		clc
		adc FishSineWavesSpriteVal + (51 * 3), x
		sta Bank_SpriteVals + 3
		lda #FirstSpriteIndex
		clc
		adc FishSineWavesSpriteVal + (51 * 4), x
		sta Bank_SpriteVals + 4

		lda #Fish_Sprite0Y
		clc
		adc FishSineWavesY + (12 * 0), y
		sta VIC_Sprite0Y
		lda #Fish_Sprite1Y
		clc
		adc FishSineWavesY + (12 * 1), y
		sta VIC_Sprite1Y
		lda #Fish_Sprite2Y
		clc
		adc FishSineWavesY + (12 * 2), y
		sta VIC_Sprite2Y
		lda #Fish_Sprite3Y
		clc
		adc FishSineWavesY + (12 * 3), y
		sta VIC_Sprite3Y
		lda #Fish_Sprite4Y
		clc
		adc FishSineWavesY + (12 * 4), y
		sta VIC_Sprite4Y

		rts

.align 256
DoPlotColours:
		jsr PlotColours

		lda ZP_ColourTablePtr + 0
		clc
		adc #$01
		sta ZP_ColourTablePtr + 0
		lda ZP_ColourTablePtr + 1
		adc #$00
		sta ZP_ColourTablePtr + 1
		cmp #>ColourValuesLoopPoint
		bne NotFinalColour
		lda ZP_ColourTablePtr + 0
		cmp #<ColourValuesLoopPoint
		bne NotFinalColour

	ResetPlotColours:
		lda #<ColourValues
		sta ZP_ColourTablePtr + 0
		lda #>ColourValues
		sta ZP_ColourTablePtr + 1

	NotFinalColour:
		rts

.align 256
DoScrollerScroll:
		lda ScreenAddress + (23 * 40) + 0
		and #$7f
		sta CharVal0
		lda ScreenAddress + (24 * 40) + 0
		and #$7f
		sta CharVal1

		ldy #$00
	ScrollerLoop:
		lda ScreenAddress + (23 * 40) + 1, y
		sta ScreenAddress + (23 * 40) + 0, y
		lda ScreenAddress + (24 * 40) + 1, y
		sta ScreenAddress + (24 * 40) + 0, y
		iny
		cpy #39
		bne ScrollerLoop

		ldy #$00
		lda (ZP_ScrollPtr), y
		bmi FinishedScrollText
		ora #$80
		sta ScreenAddress + (23 * 40) + 39
		iny
		lda (ZP_ScrollPtr), y
		ora #$80
		sta ScreenAddress + (24 * 40) + 39

		clc
		lda ZP_ScrollPtr + 0
		adc #$02
		sta ZP_ScrollPtr + 0
		lda ZP_ScrollPtr + 1
		adc #$00
		sta ZP_ScrollPtr + 1

		jmp ScrollSpriteData

	FinishedScrollText:
		lda #$a0
		sta ScreenAddress + (23 * 40) + 39
		sta ScreenAddress + (24 * 40) + 39
		jmp ScrollSpriteData

.align 256
OpenTheBorders:
		ldx #2
	Delay000:
		dex
		bne Delay000
		nop
		nop
		nop
		nop
		nop
		sta VIC_D016
		sty VIC_D016

		.for(var Line = 0; Line < 17; Line++)
		{
			.if(Line == 8)
			{
				stx VIC_ScreenColour
				nop
			}
			.if(Line != 1 && Line != 9)
			{
				ldx #7
				dex
				bne * - 1
				.if((Line != 8) && (Line != 16))
				{
					nop
					nop
					nop
				}
				.if (Line == 7)
				{
					ldx #$06
				}
				else
				{
					ldx #$40
				}
				sta VIC_D016
				sty VIC_D016
			}
			else
			{
				sta VIC_D016 - $40, x
				sty VIC_D016
			}
		}
		stx VIC_ScreenColour
		rts

.var SpriteDataYStart = 4
CharVal0: .byte $0e
CharVal1: .byte $0f
CharVal2: .byte $1c
CharVal3: .byte $1d

.align 128
CharSetLookupLo:
	.fill 128, <(FontDataADDR + i * 8)
CharSetLookupHi:
	.fill 128, >(FontDataADDR + i * 8)

.align 256
ScrollSpriteData:
		.for (var YVal = 0; YVal < 16; YVal++)
		{
			lda SideBorderSpriteData + (0 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (0 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (0 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (0 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (1 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (0 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (1 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (1 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (1 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (1 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)

			lda SideBorderSpriteData + (2 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (2 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (2 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (2 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (3 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (2 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (3 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (3 * 64) + 0 + ((YVal + SpriteDataYStart) * 3)
			lda SideBorderSpriteData + (3 * 64) + 2 + ((YVal + SpriteDataYStart) * 3)
			sta SideBorderSpriteData + (3 * 64) + 1 + ((YVal + SpriteDataYStart) * 3)
		}

		ldy #$00
		lda (ZP_ScrollPtr2), y
		bpl GoodScrollText

		lda #$20
		sta CharVal2
		sta CharVal3
		jmp DoneScrollText

	GoodScrollText:
		sta CharVal2
		iny
		lda (ZP_ScrollPtr2), y
		sta CharVal3

		clc
		lda ZP_ScrollPtr2 + 0
		adc #$02
		sta ZP_ScrollPtr2 + 0
		lda ZP_ScrollPtr2 + 1
		adc #$00
		sta ZP_ScrollPtr2 + 1
	DoneScrollText:

		ldx CharVal0
		lda CharSetLookupLo, x
		sta CopyChar0 + 1
		lda CharSetLookupHi, x
		sta CopyChar0 + 2

		ldx CharVal1
		lda CharSetLookupLo, x
		sta CopyChar1 + 1
		lda CharSetLookupHi, x
		sta CopyChar1 + 2

		ldx CharVal2
		lda CharSetLookupLo, x
		sta CopyChar2 + 1
		lda CharSetLookupHi, x
		sta CopyChar2 + 2

		ldx CharVal3
		lda CharSetLookupLo, x
		sta CopyChar3 + 1
		lda CharSetLookupHi, x
		sta CopyChar3 + 2

		ldy #$00
		ldx #$00
	CopyCharLoop:

	CopyChar0:
		lda $ffff, y
		sta SideBorderSpriteData + (1 * 64) + 2 + (SpriteDataYStart * 3), x

	CopyChar1:
		lda $ffff, y
		sta SideBorderSpriteData + (1 * 64) + 2 + ((SpriteDataYStart + 8) * 3), x

	CopyChar2:
		lda $ffff, y
		sta SideBorderSpriteData + (3 * 64) + 2 + (SpriteDataYStart * 3), x

	CopyChar3:
		lda $ffff, y
		sta SideBorderSpriteData + (3 * 64) + 2 + ((SpriteDataYStart + 8) * 3), x

		inx
		inx
		inx
		iny
		cpy #$08
		bne CopyCharLoop

		rts

