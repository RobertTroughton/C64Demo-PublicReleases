//; TODO: make the bob-plot so that we only write to actually affected bytes .. get rid of the top/bottom padding completely!

//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "InfiniteBobsBase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-3aff Code
//; - $3d00-3dff FlipBits
//; - $3e00-3eff FlipY
//; - $4000-77ff CharSets 0
//; - $7800-7bff Screen 0
//; - $7c00-7dff Sprites
//; - $8000-b7ff Image Data
//; - $b800-bfff SinTables
//; - $c000-f7ff CharSets 1
//; - $f800-fbff Screen 1

	.var ColourBG = 0
	.var ColourLight = 10
	.var ColourMid = 5
	.var ColourDark = 0
	.var ColourSideBorders = 12
	.var ColourTopBottomBorders = 11

ColourDarkFades:		.byte $00, $09, $02, $04, $0c, $03, $0e, $06	//$06, $0e, $03, $01, $03, $0e, $06, $06
ColourMidFades:			.byte $00, $09, $02, $04, $0c ,$03 ,$0d ,$01	//$06, $0e, $03, $01, $01, $01, $01, $01
ColourLightFades:		.byte $09, $02, $04, $0c, $03, $0d, $03, $0e	//$06, $0e, $03, $01, $03, $0e, $0e, $0e

BlitBobJumpPtrsLo:					.byte <BlitBob_Shift0, <BlitBob_Shift1, <BlitBob_Shift2, <BlitBob_Shift3
BlitBobJumpPtrsHi:					.byte >BlitBob_Shift0, >BlitBob_Shift1, >BlitBob_Shift2, >BlitBob_Shift3

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff

	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1

	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)

	.var ScreenBank0 = 14 //; Bank+[3800,3bff]
	.var ScreenBank1 = 14 //; Bank+[3800,3bff]
	
	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharBank1 = 1 //; Bank+[0800,0f3f]
	.var CharBank2 = 2 //; Bank+[1000,17ff]
	.var CharBank3 = 3 //; Bank+[1800,1fff]
	.var CharBank4 = 4 //; Bank+[2000,27ff]
	.var CharBank5 = 5 //; Bank+[2800,2fff]
	.var CharBank6 = 6 //; Bank+[3000,37ff]
	.var CharBank7 = 0 //; Bank+[3000,37ff]
	.var CharBank8 = 1 //; Bank+[3800,3fff]
	.var CharBank9 = 2 //; Bank+[3000,37ff]
	.var CharBank10 = 3 //; Bank+[3800,3fff]
	.var CharBank11 = 4 //; Bank+[3000,37ff]
	.var CharBank12 = 5 //; Bank+[3800,3fff]
	.var CharBank13 = 6 //; Bank+[3000,37ff]

	.var CharAddress0 = (Base_BankAddress0 + (CharBank0 * 2048))
	.var CharAddress1 = (Base_BankAddress0 + (CharBank1 * 2048))
	.var CharAddress2 = (Base_BankAddress0 + (CharBank2 * 2048))
	.var CharAddress3 = (Base_BankAddress0 + (CharBank3 * 2048))
	.var CharAddress4 = (Base_BankAddress0 + (CharBank4 * 2048))
	.var CharAddress5 = (Base_BankAddress0 + (CharBank5 * 2048))
	.var CharAddress6 = (Base_BankAddress0 + (CharBank6 * 2048))
	.var CharAddress7 = (Base_BankAddress1 + (CharBank7 * 2048))
	.var CharAddress8 = (Base_BankAddress1 + (CharBank8 * 2048))
	.var CharAddress9 = (Base_BankAddress1 + (CharBank9 * 2048))
	.var CharAddress10 = (Base_BankAddress1 + (CharBank10 * 2048))
	.var CharAddress11 = (Base_BankAddress1 + (CharBank11 * 2048))
	.var CharAddress12 = (Base_BankAddress1 + (CharBank12 * 2048))
	.var CharAddress13 = (Base_BankAddress1 + (CharBank13 * 2048))

	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))

	.var SpriteVals0 = (ScreenAddress0 + $3F8)
	.var SpriteVals1 = (ScreenAddress1 + $3F8)

	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank0 * 16) + (CharBank1 * 2)
	.var D018Value2 = (ScreenBank0 * 16) + (CharBank2 * 2)
	.var D018Value3 = (ScreenBank0 * 16) + (CharBank3 * 2)
	.var D018Value4 = (ScreenBank0 * 16) + (CharBank4 * 2)
	.var D018Value5 = (ScreenBank0 * 16) + (CharBank5 * 2)
	.var D018Value6 = (ScreenBank0 * 16) + (CharBank6 * 2)
	.var D018Value7 = (ScreenBank1 * 16) + (CharBank7 * 2)
	.var D018Value8 = (ScreenBank1 * 16) + (CharBank8 * 2)
	.var D018Value9 = (ScreenBank1 * 16) + (CharBank9 * 2)
	.var D018Value10 = (ScreenBank1 * 16) + (CharBank10 * 2)
	.var D018Value11 = (ScreenBank1 * 16) + (CharBank11 * 2)
	.var D018Value12 = (ScreenBank1 * 16) + (CharBank12 * 2)
	.var D018Value13 = (ScreenBank1 * 16) + (CharBank13 * 2)
	
	.var D016_38ColsMC = $10

	.var ZP_FlipBit = $3f

	.var ZP_IRQVECTOR = $40

	.var ZP_CharScroll = $c0

	.var ADDR_SinTables = $b800
	.var ADDR_SinTable_ScreenX =		ADDR_SinTables + (0 * 256)
	.var ADDR_SinTable_ScreenY =		ADDR_SinTables + (1 * 256)
	.var ADDR_SinTable_ScreenYPix =		ADDR_SinTables + (2 * 256)
	.var ADDR_SinTable_BobX =			ADDR_SinTables + (3 * 256)
	.var ADDR_SinTable_BobXPix =		ADDR_SinTables + (4 * 256)
	.var ADDR_SinTable_BobY =			ADDR_SinTables + (5 * 256)
	.var ADDR_SinTable_BobYPix =		ADDR_SinTables + (6 * 256)
	.var ADDR_SinTable_ScreenY_Clear =	ADDR_SinTables + (7 * 256)

	.var ADDR_FlipBits =				$3d00
	.var ADDR_FlipY =					$3e00

	.var ADDR_ImageData =				$8000

	.var ZP_NumBobsToDraw =				$4e
	.var ZP_NumBobsCounter =			$4f

	.var ZP_XCharHiValue =				$50

	.var ZP_BobOutYMinus7 =				$60 - (7  * 2)
	.var ZP_BobOutYMinus6 =				$60 - (6  * 2)
	.var ZP_BobOutYMinus5 =				$60 - (5  * 2)
	.var ZP_BobOutYMinus4 =				$60 - (4  * 2)
	.var ZP_BobOutYMinus3 =				$60 - (3  * 2)
	.var ZP_BobOutYMinus2 =				$60 - (2  * 2)
	.var ZP_BobOutYMinus1 =				$60 - (1  * 2)
	.var ZP_BobOutY0 =					$60 + (0  * 2)
	.var ZP_BobOutY1 =					$60 + (1  * 2)
	.var ZP_BobOutY2 =					$60 + (2  * 2)
	.var ZP_BobOutY3 =					$60 + (3  * 2)
	.var ZP_BobOutY4 =					$60 + (4  * 2)
	.var ZP_BobOutY5 =					$60 + (5  * 2)
	.var ZP_BobOutY6 =					$60 + (6  * 2)
	.var ZP_BobOutY7 =					$60 + (7  * 2)
	.var ZP_BobOutY8 =					$60 + (8  * 2)
	.var ZP_BobOutY9 =					$60 + (9  * 2)
	.var ZP_BobOutY10 =					$60 + (10 * 2)
	.var ZP_BobOutY11 =					$60 + (11 * 2)
	.var ZP_BobOutY12 =					$60 + (12 * 2)
	.var ZP_BobOutY13 =					$60 + (13 * 2)
	.var ZP_BobOutY14 =					$60 + (14 * 2)


	.var MaxNumBobsToDraw =			7

	.var OPC_STA_ABS = $8d

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:
	.byte $f0									//; D000: VIC_Sprite0X
	.byte 250-27								//; D001: VIC_Sprite0Y
	.byte $28									//; D002: VIC_Sprite1X
	.byte 250-27								//; D003: VIC_Sprite1Y
	.byte $58									//; D004: VIC_Sprite2X
	.byte 250-27								//; D005: VIC_Sprite2Y
	.byte $88									//; D006: VIC_Sprite3X
	.byte 250-27								//; D007: VIC_Sprite3Y
	.byte $b8									//; D008: VIC_Sprite4X
	.byte 250-27								//; D009: VIC_Sprite4Y
	.byte $e8									//; D00a: VIC_Sprite5X
	.byte 250-27								//; D00b: VIC_Sprite5Y
	.byte $18									//; D00c: VIC_Sprite6X
	.byte 250-27								//; D00d: VIC_Sprite6Y
	.byte $48									//; D00c: VIC_Sprite6X
	.byte 250-27								//; D00d: VIC_Sprite6Y
	.byte $c1									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_38ColsMC							//; D016: VIC_D016
	.byte $ff									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $ff									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $0b									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $0b									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $01									//; D027: VIC_Sprite0Colour
	.byte $01									//; D028: VIC_Sprite1Colour
	.byte $01									//; D029: VIC_Sprite2Colour
	.byte $01									//; D02A: VIC_Sprite3Colour
	.byte $01									//; D02B: VIC_Sprite4Colour
	.byte $01									//; D02C: VIC_Sprite5Colour
	.byte $01									//; D02D: VIC_Sprite6Colour
	.byte $01									//; D02E: VIC_Sprite7Colour

FrameCounterLo:		.byte $84
FrameCounterHi:		.byte $fc

D018Values:
		.byte D018Value0, D018Value1, D018Value2, D018Value3, D018Value4, D018Value5, D018Value6, D018Value7, D018Value8, D018Value9, D018Value10, D018Value11, D018Value12, D018Value13, D018Value13
DD02Values:
		.byte DD02Value0, DD02Value0, DD02Value0, DD02Value0, DD02Value0, DD02Value0, DD02Value0, DD02Value1, DD02Value1, DD02Value1, DD02Value1, DD02Value1, DD02Value1, DD02Value1, DD02Value1

VSynced:			.byte $00

Scr0JumpTable:
		.fill 4, 0
		.fill 25, i
		.fill 19, $ff
Scr1JumpTable:
		.fill 4, $ff
		.fill 25, 24 - i
		.fill 19, 0

OutYCharTableHi:
		.byte >(CharAddress0  + (0 * 64 * 8)), >(CharAddress0  + (1 * 64 * 8)), >(CharAddress0  + (2 * 64 * 8)), >(CharAddress0  + (3 * 64 * 8))
		.byte >(CharAddress1  + (0 * 64 * 8)), >(CharAddress1  + (1 * 64 * 8)), >(CharAddress1  + (2 * 64 * 8)), >(CharAddress1  + (3 * 64 * 8))
		.byte >(CharAddress2  + (0 * 64 * 8)), >(CharAddress2  + (1 * 64 * 8)), >(CharAddress2  + (2 * 64 * 8)), >(CharAddress2  + (3 * 64 * 8))
		.byte >(CharAddress3  + (0 * 64 * 8)), >(CharAddress3  + (1 * 64 * 8)), >(CharAddress3  + (2 * 64 * 8)), >(CharAddress3  + (3 * 64 * 8))
		.byte >(CharAddress4  + (0 * 64 * 8)), >(CharAddress4  + (1 * 64 * 8)), >(CharAddress4  + (2 * 64 * 8)), >(CharAddress4  + (3 * 64 * 8))
		.byte >(CharAddress5  + (0 * 64 * 8)), >(CharAddress5  + (1 * 64 * 8)), >(CharAddress5  + (2 * 64 * 8)), >(CharAddress5  + (3 * 64 * 8))
		.byte >(CharAddress6  + (0 * 64 * 8)), >(CharAddress6  + (1 * 64 * 8)), >(CharAddress6  + (2 * 64 * 8)), >(CharAddress6  + (3 * 64 * 8))
		.byte >(CharAddress7  + (0 * 64 * 8)), >(CharAddress7  + (1 * 64 * 8)), >(CharAddress7  + (2 * 64 * 8)), >(CharAddress7  + (3 * 64 * 8))
		.byte >(CharAddress8  + (0 * 64 * 8)), >(CharAddress8  + (1 * 64 * 8)), >(CharAddress8  + (2 * 64 * 8)), >(CharAddress8  + (3 * 64 * 8))
		.byte >(CharAddress9  + (0 * 64 * 8)), >(CharAddress9  + (1 * 64 * 8)), >(CharAddress9  + (2 * 64 * 8)), >(CharAddress9  + (3 * 64 * 8))
		.byte >(CharAddress10 + (0 * 64 * 8)), >(CharAddress10 + (1 * 64 * 8)), >(CharAddress10 + (2 * 64 * 8)), >(CharAddress10 + (3 * 64 * 8))
		.byte >(CharAddress11 + (0 * 64 * 8)), >(CharAddress11 + (1 * 64 * 8)), >(CharAddress11 + (2 * 64 * 8)), >(CharAddress11 + (3 * 64 * 8))
		.byte >(CharAddress12 + (0 * 64 * 8)), >(CharAddress12 + (1 * 64 * 8)), >(CharAddress12 + (2 * 64 * 8)), >(CharAddress12 + (3 * 64 * 8))
		.byte >(CharAddress13 + (0 * 64 * 8)), >(CharAddress13 + (1 * 64 * 8)), >(CharAddress13 + (2 * 64 * 8)), >(CharAddress13 + (3 * 64 * 8))

OutXCharTableLo:
		.fill 32, i * 8
		.fill 32, i * 8

OutXCharTableHi:
		.fill 32, 0
		.fill 32, 1

CallCount:
		.byte 0

LastVSPDistance:
		.byte 0

ModdedXAdd:
		.fill 253, i
		.fill 64, i

SpriteData:
		.fill 8 * 3, $ff
		.fill 8 * 3, $55
		.fill 5 * 3, $00

StartFinalEaseOut:
		.byte $00

SideBorderColourTable:

		.byte $0c, $0c, $0f, $01, $0f, $0c, $0b, $0b

.import source "../../Build/6502/InfiniteBobs/anim.asm"


//; InfiniteBobs_Go() -------------------------------------------------------------------------------------------------------

InfiniteBobs_Go:

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		ldy #$00
	SetFlipYLoop:
		tya
		eor #$f8
		sta ADDR_FlipY, y
		iny
		bne SetFlipYLoop

		ldy #$00
	SetFlipBitsLoop:
//; step 1: 01234567 -> 76543210
		sty ZP_FlipBit
		ldx #8
	FlipAll8Bits:
		lsr ZP_FlipBit
		rol
		dex
		bne FlipAll8Bits
//; step 2: 76543210 -> 67452301 by making -7-5-3-1 and or'ing it with 6-4-2-0-
		pha
		and #$55
		asl
		sta V0 + 1
		pla
		and #$aa
		lsr
	V0:
		ora #$00
		sta ADDR_FlipBits, y
		iny
		bne SetFlipBitsLoop
		
		lda #$4c
		sta ZP_IRQVECTOR

		lda #$00
		sta $7fff

		ldy #$00
		lda #ColourBG
		ora #8
	FillColLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillColLoop

		ldy #7
		lda #$fe
	SetSpriteValsLoop:
		sta SpriteVals0, y
		sta SpriteVals1, y
		dey
		bpl SetSpriteValsLoop

		ldy #$3e
	FillSpriteDataLoop:
		lda SpriteData, y
		sta Base_BankAddress0 + $3f80, y
		sta Base_BankAddress1 + $3f80, y
		dey
		bpl FillSpriteDataLoop

		lda #$00
		sta ZP_NumBobsToDraw

//; --- EASE IN SETUP --------
		ldy #$00
		lda #$ff
	Fill0400ScreenLoop:
		sta $0400, y
		sta $0500, y
		sta $0600, y
		sta $0700, y
		iny
		bne Fill0400ScreenLoop

		ldy #$07
		lda #$00
	Fill07F8CharLoop:
		sta $07f8, y
		dey
		bpl Fill07F8CharLoop

		lda #$00
		sta $3fff
//; --- EASE IN SETUP --------

		dec $01
		jsr SetupWholeScreen
		inc $01

		ldy #$00
		jsr DoAnimation

		vsync()

		sei	
		lda #$f8
		sta VIC_D012
		lda #$00
		sta VIC_D011
		lda #<IRQ_EaseIn
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_EaseIn
		sta ZP_IRQVECTOR + 2
		lda #<ZP_IRQVECTOR
		sta $fffe
		lda #>ZP_IRQVECTOR
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019
		cli

	WaitTillFinishedEaseIn:
		lda #$00
		beq WaitTillFinishedEaseIn

	LoopForever:
		lda PART_Done				//;Wait for final fade
		beq LoopForever

	!w:
		bit VIC_D011
		bpl !w-

	!w:
		bit VIC_D011
		bmi !w-

		jsr IRQLoader_LoadNext		//; Load final fadeout code

		jmp $0400

//; IRQ_EaseIn() -------------------------------------------------------------------------------------------------------

IRQ_EaseIn:

		IRQManager_BeginIRQ(0, 0)

	SetD011A:
		lda #$10
		sta VIC_D011

 		//jsr BASE_PlayMusic

	WaitForVB:
		lda VIC_D011
		bpl WaitForVB

		lda #$20
	WaitForAfterSprites:
		cmp VIC_D012
		bne WaitForAfterSprites

		lda #(1 * 16) + (0 * 2) //; screen1 ($0400), charset0 ($0000)
		sta VIC_D018

		lda #60 + 0
		sta VIC_DD02

	SetD011B:
		lda #$18
		sta VIC_D011
		lda #0
		sta VIC_D012
		lda #<IRQ_EaseIn_SetSideBorderColours
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_EaseIn_SetSideBorderColours
		sta ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_EaseIn_SetSideBorderColours() -------------------------------------------------------------------------------------------------------

IRQ_EaseIn_SetSideBorderColours:

		IRQManager_BeginIRQ(1, 0)

	SetBorderColour_00:
		lda #$0b
		sta VIC_BorderColour
		
 		jsr BASE_PlayMusic

	EaseInY0:
		lda #141
		sta VIC_D012
		lda #<IRQ_EaseIn_SetBlackScreen_Top
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_EaseIn_SetBlackScreen_Top
		sta ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_EaseIn_SetBlackScreen_Top() -------------------------------------------------------------------------------------------------------

IRQ_EaseIn_SetBlackScreen_Top:

		IRQManager_BeginIRQ(1, 0)

	SetBlack:
		lda #ColourDark
		sta VIC_ScreenColour

	EaseInY1:
		lda #145
		sta VIC_D012
	EaseIn_SetIRQVecLo:
		lda #<IRQ_EaseIn_SetBlackScreen_Bottom
		sta ZP_IRQVECTOR + 1
	EaseIn_SetIRQVecHi:
		lda #>IRQ_EaseIn_SetBlackScreen_Bottom
		sta ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_EaseIn_SetBlackScreen_Bottom() -------------------------------------------------------------------------------------------------------

IRQ_EaseIn_SetBlackScreen_Bottom:

		IRQManager_BeginIRQ(1, 0)

 		lda #ColourTopBottomBorders
		sta VIC_ScreenColour


	SideBorderColourIndex_EaseIn:
		lda #$1f
		beq SkipSideBorderUpdate_EaseIn
		lsr
		lsr
		tay
		lda SideBorderColourTable, y
		sta SetBorderColour_00 + 1
		dec SideBorderColourIndex_EaseIn + 1
	SkipSideBorderUpdate_EaseIn:

		lda EaseInY0 + 1
		sec
		sbc #2
		sta EaseInY0 + 1
		lda EaseInY1 + 1
		clc
		adc #2
		sta EaseInY1 + 1

		cmp #239
		bne NotFinishedEaseInYet

		inc WaitTillFinishedEaseIn + 1

		lda #$ff
		sta VIC_SpriteEnable
		lda #<IRQ_Main
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_Main
		sta ZP_IRQVECTOR + 2
		bne EndThisIRQ

	NotFinishedEaseInYet:
		lda #<IRQ_EaseIn
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_EaseIn
		sta ZP_IRQVECTOR + 2

	EndThisIRQ:
		lda #$f8
		sta VIC_D012

		IRQManager_EndIRQ()
		rti


//; IRQ_EaseIn_SetBlackScreen_Bottom() -------------------------------------------------------------------------------------------------------

IRQ_EaseOut_SetBlackScreen_Bottom_FirstFrame:

		IRQManager_BeginIRQ(0, 0)

 		lda #ColourTopBottomBorders
		sta VIC_ScreenColour

		lda #$00
		sta VIC_SpriteEnable

		jmp ContinueHere


IRQ_EaseOut_SetBlackScreen_Bottom:

		IRQManager_BeginIRQ(1, 0)

 		lda #ColourTopBottomBorders
		sta VIC_ScreenColour

	ShouldWeMoveRaster:
		lda PART_Done
		bne EndThisIRQ2

	ContinueHere:

	SideBorderColourIndex_EaseOut:
		lda #$00
		cmp #$20
		beq SkipSideBorderUpdate_EaseOut
		lsr
		lsr
		tay
		lda SideBorderColourTable, y
		sta SetBorderColour_00 + 1
		inc SideBorderColourIndex_EaseOut + 1
	SkipSideBorderUpdate_EaseOut:

		lda EaseInY0 + 1
		clc
		adc #2
		sta EaseInY0 + 1
		lda EaseInY1 + 1
		sec
		sbc #2
		sta EaseInY1 + 1

		cmp #145
		bne NotFinishedEaseOutYet
		inc PART_Done
		lda #$00
		sta SetD011A + 1
		sta SetD011B + 1
 		lda #ColourTopBottomBorders
		sta SetBlack + 1

	NotFinishedEaseOutYet:
		lda #<IRQ_EaseIn
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_EaseIn
		sta ZP_IRQVECTOR + 2

	//; EndThisIRQ2:
		lda #$f8
		sta VIC_D012

		IRQManager_EndIRQ()
		rti

	EndThisIRQ2:
		lda #$00
		jsr BASE_RestoreIRQ

		IRQManager_EndIRQ()
		rti

//; UpdateNewFrame() -------------------------------------------------------------------------------------------------------

UpdateNewFrame:

		ldx FrameX + 1
		lda ADDR_SinTable_ScreenX, x
		and #$07
		eor #$17
		sta VIC_D016

	FrameY:
		ldx #$10
		inx
		inx
	FrameY_STX:
		ldx FrameY + 1

		lda ADDR_SinTable_ScreenYPix, x
		eor #$5f
		sta SetD011Value + 1
		and #$1f
		sta SetD011ValueB + 1

		lda ADDR_SinTable_ScreenY, x
		and #$03
		sta _lineCrunch + 1

		lda ADDR_SinTable_ScreenY, x
		lsr
		lsr
		sta D018Index + 1

		lda ADDR_SinTable_ScreenY, x
		and #$03
		asl
		asl
		asl
		ora ADDR_SinTable_ScreenYPix, x
		eor #$1f
		clc
		adc #63
		sta SetD012Value + 1

	D018Index:
		ldy #$00
		lda D018Values, y
		sta VIC_D018
		lda DD02Values, y
		sta VIC_DD02
		lda D018Values + 1, y
		sta FirstD018Value + 1
		lda DD02Values + 1, y
		sta FirstDD02Value + 1
		lda #4
		sta CallCount
		iny
		iny
		sty FirstIndex + 1

		inc FrameCounterLo
		bne NotLastFrame
		inc FrameCounterHi
		bne NotLastFrame

		:BranchIfNotFullDemo(NotLastFrame)

		lda #$1f
		sta EaseOutFrame + 1
	NotLastFrame:
		rts


//; IRQ_UpdateD018() -------------------------------------------------------------------------------------------------------

.align 128

IRQ_UpdateD018:

		IRQManager_BeginIRQ(1, 0)

	NextD018Value:
		ldx #D018Value1
		stx VIC_D018
	NextDD02Value:
		lda #DD02Value0
		sta VIC_DD02

	NextIndex:
		ldy #1
		lda D018Values, y
		sta NextD018Value + 1
		lda DD02Values, y
		sta NextDD02Value + 1
		inc NextIndex + 1

		ldx #<IRQ_UpdateD018
		ldy #>IRQ_UpdateD018

	NextD012:
		lda #$00
		clc
		adc #32
		sta NextD012 + 1

		dec CallCount
		bne AllGood

		//jsr BASE_PlayMusic

		lda StartFinalEaseOut
		beq DontStartFinalEaseOut

		lda #<IRQ_EaseOut_SetBlackScreen_Bottom
		sta EaseIn_SetIRQVecLo + 1
		lda #>IRQ_EaseOut_SetBlackScreen_Bottom
		sta EaseIn_SetIRQVecHi + 1

		lda #237
		ldx #<IRQ_EaseOut_SetBlackScreen_Bottom_FirstFrame
		ldy #>IRQ_EaseOut_SetBlackScreen_Bottom_FirstFrame
		bne EndIRQ

	DontStartFinalEaseOut:
		lda #$f8
		ldx #<IRQ_Main
		ldy #>IRQ_Main
		bne EndIRQ

	AllGood:
		lda NextD012 + 1

	EndIRQ:
		sta VIC_D012
		stx ZP_IRQVECTOR + 1
		sty ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_MainControl() -------------------------------------------------------------------------------------------------------

IRQ_MainControl:

		pha
		txa
		pha
		tya
		pha
		lda $01
		pha
		lda #$35
		sta $01

		lda #$1b
		sta VIC_D011
		lda #$2f
		sta VIC_D012
		lda #<IRQ_AGSP
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_AGSP
		sta ZP_IRQVECTOR + 2
		dec VIC_D019
		cli

		jsr BASE_PlayMusic

	EaseInFrame:
		lda #$e0
		beq FinishedEaseIn
		and #$1f
		lsr
		lsr
		tax

		lda ColourDarkFades, x
		sta SetScreenColour + 1
		lda ColourLightFades, x
		sta VIC_MultiColour0
		lda ColourMidFades, x
		sta VIC_MultiColour1

		inc EaseInFrame + 1
		jmp SkipDrawingBobs

	FinishedEaseIn:

	ClosingEyesFrame:
		lda #$a0
		beq FinishedClosingEyes
		sec
		sbc #$a0
		lsr
		lsr
		lsr
		tay
		jsr DoAnimation

		inc ClosingEyesFrame + 1
		bne FinishedClosingEyes

		lda #STX_ABS
		sta FrameY_STX

	FinishedClosingEyes:
		ldx #$c8
		beq EaseOutFrame

		dex
		stx FinishedClosingEyes + 1
		bne EaseOutFrame

		lda #STX_ABS
		sta FrameX_STX

	EaseOutFrame:
		lda #$00
		beq DoneEaseOut

		lsr
		lsr
		tax

		lda ColourDarkFades, x
		sta SetScreenColour + 1
		lda ColourLightFades, x
		sta VIC_MultiColour0
		lda ColourMidFades, x
		sta VIC_MultiColour1

		dec EaseOutFrame + 1
		bne DoneEaseOut

		inc StartFinalEaseOut

		lda #0
		sta SetScreenColour + 1
		sta VIC_MultiColour0
		sta VIC_MultiColour1

	DoneEaseOut:

		lda ClosingEyesFrame + 1
		bne DontDrawBobs
		lda FinishedClosingEyes + 1
		beq TryDrawingBobs
	DontDrawBobs:
		jmp SkipDrawingBobs

	TryDrawingBobs:
		ldx #$40
		beq YesLetsDrawTheBobs
		dex
		stx TryDrawingBobs + 1
		bne DontDrawBobs
	YesLetsDrawTheBobs:

		dec $01

		lda ZP_NumBobsToDraw
		cmp #MaxNumBobsToDraw
		beq DontIncreaseBobCount

	BobIncreaseEaseIndex:
		ldy #$ec
		iny
		bne !NotZero+
		inc ZP_NumBobsToDraw
		lda ZP_NumBobsToDraw
		cmp #MaxNumBobsToDraw
		bne MoreBobsToCome
	MoreBobsToCome:
		ldy #$ec
	!NotZero:
		sty BobIncreaseEaseIndex + 1
	DontIncreaseBobCount:

		sta ZP_NumBobsCounter

		dec ZP_NumBobsCounter
		bpl DrawTheBobs
		jmp FinishedDoingBobs

	DrawTheBobs:
		lda FrameX + 1
		sta BlitBob_SinIndexX + 1
		lda FrameY + 1
		sec
		sbc #3
		sta BlitBob_SinIndexY + 1
		jsr BlitBob

		.for (var i = 0; i < MaxNumBobsToDraw - 1; i++)
		{
			dec ZP_NumBobsCounter
			bmi FinishedDoingBobs
			ldx BlitBob_SinIndexX + 1
			lda ModdedXAdd + 2, x
			sta BlitBob_SinIndexX + 1
			dec BlitBob_SinIndexY + 1
			jsr BlitBob
		}

	FinishedDoingBobs:

		jsr RestoreHorizontalLine

	SkipDrawingBobs:

		pla
		sta $01
		pla
		tay
		pla
		tax
		pla
		rti


//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		IRQManager_BeginIRQ(0, 0)

		lda #$10
		sta VIC_D011

 		lda #ColourTopBottomBorders
	Main_ScreenColourWrite:
		nop VIC_ScreenColour

		lda #OPC_STA_ABS
		sta Main_ScreenColourWrite

		inc VSynced

	FrameX:
		ldy #$46
		ldx ModdedXAdd + 2, y
	FrameX_STX:
		ldx FrameX + 1

		lda VSPDistance + 1
		sta LastVSPDistance
		lda ADDR_SinTable_ScreenX, x
		lsr
		lsr
		lsr
		sta VSPDistance + 1

		lda LastVSPDistance
		bmi NoVSPLineUpdate
		cmp VSPDistance + 1
		beq NoVSPLineUpdate
		bcc PicMovingLeft

	PicMovingRight:
		lda VSPDistance + 1
		jmp DoVertLineFill

	PicMovingLeft:
		lda VSPDistance + 1
		clc
		adc #39
	DoVertLineFill:
		tax
		jsr FillVerticalScreenLine

	NoVSPLineUpdate:

		jsr UpdateNewFrame

		lda #$97
		sta VIC_D011
		lda #$08
		sta VIC_D012

		lda #<IRQ_MainControl
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_MainControl
		sta ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_AGSP() -------------------------------------------------------------------------------------------------------

.align 256

IRQ_AGSP:

		IRQManager_BeginIRQ(1, 0)

		lda #$57
		ldy #$51
		nop
		nop $ff

	_lineCrunch:
		ldx #0
	loop0:
		beq endloop0
		sty $d011
		iny
		nop
		nop
		nop
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		lda #$57
		dex
		bpl loop0
	endloop0:
		sta $d011

	VSPDistance:
		ldx #$ff
		stx VSPDist + 1
		nop
		bit $ff

		lda #$36
	WaitD012:
		cmp $d012
		bne WaitD012

	VSPDist:
		beq Next
	Next:

		.for (var i = 0; i < 19; i++)
		{
			lda #$a9
		}

		lda #$a5
		nop
		dec $d011
		inc $d011

	SetD011Value:
		lda #$00
		sta VIC_D011

	SetScreenColour:
		lda #ColourDark
		sta VIC_ScreenColour
		lda #$3d
		sta VIC_D012
		lda #<IRQ_AGSPB
		sta ZP_IRQVECTOR + 1
		lda #>IRQ_AGSPB
		sta ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; IRQ_AGSPB() -------------------------------------------------------------------------------------------------------

.align 128

IRQ_AGSPB:

		IRQManager_BeginIRQ(1, 0)

	SetD011ValueB:
		lda #$00

		ldx #$3f
	D012WaitToShowScreen:
		cpx VIC_D012
		bne D012WaitToShowScreen

		sta VIC_D011

	SetD012Value:
		ldx #$00
	WaitForFirstD012:
		cpx VIC_D012
		bne WaitForFirstD012


	FirstIndex:
		ldy #1
		lda D018Values, y
		sta NextD018Value + 1
		lda DD02Values, y
		sta NextDD02Value + 1
		iny
		sty NextIndex + 1
		
		compensateForJitter(-9)

	FirstDD02Value:
		ldy #$00

	FirstD018Value:
		lda #$00

		sta VIC_D018
		sty VIC_DD02
		stx RestX + 1

	RestX:
		lda #$00
		clc
		adc #32
		sta NextD012 + 1
		sta VIC_D012
		ldx #<IRQ_UpdateD018
		ldy #>IRQ_UpdateD018
		stx ZP_IRQVECTOR + 1
		sty ZP_IRQVECTOR + 2

		IRQManager_EndIRQ()
		rti


//; FillVerticalScreenLine() -------------------------------------------------------------------------------------------------------

FillVerticalScreenLine:

		.for (var i = 0; i < 24; i += 4)
		{
			sta ScreenAddress0 + ( i * 40), x
			sta ScreenAddress1 + ( i * 40), x
		}
		eor #$40
		.for (var i = 1; i < 24; i += 4)
		{
			sta ScreenAddress0 + ( i * 40), x
			sta ScreenAddress1 + ( i * 40), x
		}
		eor #$c0
		.for (var i = 2; i < 24; i += 4)
		{
			sta ScreenAddress0 + ( i * 40), x
			sta ScreenAddress1 + ( i * 40), x
		}
		eor #$40
		.for (var i = 3; i < 24; i += 4)
		{
			sta ScreenAddress0 + ( i * 40), x
			sta ScreenAddress1 + ( i * 40), x
		}

		rts


//; SetupWholeScreen() -------------------------------------------------------------------------------------------------------

SetupWholeScreen:

//; pre-fill charset data
		ldy #$00
		sty NumCharLinesDone + 1

	SetupWholeScreenLoop:
		jsr RestoreHorizontalLine_FromSetup
	NumCharLinesDone:
		ldy #$00
		iny
		sty NumCharLinesDone + 1
		cpy #56
		bne SetupWholeScreenLoop

//; pre-fill screen data
		ldx FrameX + 1
		lda ADDR_SinTable_ScreenX, x
		lsr
		lsr
		lsr
		tax

		ldy #39
	FillScreenLoop:
		txa
		jsr FillVerticalScreenLine
		inx
		dey
		bpl FillScreenLoop

		rts


//; RestoreHorizontalLine() -------------------------------------------------------------------------------------------------------

RestoreHorizontalLine:

		ldx FrameY + 1
		ldy ADDR_SinTable_ScreenY_Clear, x
		bmi SkipClear

RestoreHorizontalLine_FromSetup:

		tya
		clc
		adc #>ADDR_ImageData
		sta RestoreReadAddr + 2

		lda OutYCharTableHi, y
		sta RestoreWriteAddrLeft + 2
		ora #$01
		sta RestoreWriteAddrRight + 2

		ldy #$00
	RestoreLineLoop:
	RestoreReadAddr:
		lax ADDR_ImageData + (12 * 256), y
	RestoreWriteAddrLeft:
		sta $ab00, y
		lda ADDR_FlipBits, x

		ldx ADDR_FlipY, y
	RestoreWriteAddrRight:
		sta $ab00, x
		iny
		bne RestoreLineLoop

	SkipClear:
		rts


//; BlitBob() -------------------------------------------------------------------------------------------------------

BlitBob:

	BlitBob_SinIndexX:
		ldy #$00
		ldx ADDR_SinTable_BobXPix, y

		lda BlitBobJumpPtrsLo, x
		sta BlitBob_JSR + 1
		lda BlitBobJumpPtrsHi, x
		sta BlitBob_JSR + 2

	BlitBob_SinIndexY:
		ldy #$00
		lda ADDR_SinTable_BobYPix, y
		asl
		sta PixYMul2 + 1
		lda ADDR_SinTable_BobY, y
		pha

		ldx BlitBob_SinIndexX + 1
		lda ADDR_SinTable_BobX, x
		tax

		ldy OutXCharTableLo + 0, x
		sty ZP_BobOutYMinus7 + 0, x

		lda OutXCharTableHi + 0, x
		sta ZP_XCharHiValue

	PixYMul2:
		ldx #$00

		sty ZP_BobOutYMinus7 + 0, x
		sty ZP_BobOutY1 + 0, x
		sty ZP_BobOutY9 + 0, x
		iny
		sty ZP_BobOutYMinus6 + 0, x
		sty ZP_BobOutY2 + 0, x
		sty ZP_BobOutY10 + 0, x
		iny
		sty ZP_BobOutYMinus5 + 0, x
		sty ZP_BobOutY3 + 0, x
		sty ZP_BobOutY11 + 0, x
		iny
		sty ZP_BobOutYMinus4 + 0, x
		sty ZP_BobOutY4 + 0, x
		sty ZP_BobOutY12 + 0, x
		iny
		sty ZP_BobOutYMinus3 + 0, x
		sty ZP_BobOutY5 + 0, x
		sty ZP_BobOutY13 + 0, x
		iny
		sty ZP_BobOutYMinus2 + 0, x
		sty ZP_BobOutY6 + 0, x
		sty ZP_BobOutY14 + 0, x
		iny
		sty ZP_BobOutYMinus1 + 0, x
		sty ZP_BobOutY7 + 0, x
		iny
		sty ZP_BobOutY0 + 0, x
		sty ZP_BobOutY8 + 0, x

		pla
		tay

		lda ZP_XCharHiValue
		ora OutYCharTableHi + 0, y

		ldx PixYMul2 + 1
		sta ZP_BobOutYMinus7 + 1, x
		sta ZP_BobOutYMinus6 + 1, x
		sta ZP_BobOutYMinus5 + 1, x
		sta ZP_BobOutYMinus4 + 1, x
		sta ZP_BobOutYMinus3 + 1, x
		sta ZP_BobOutYMinus2 + 1, x
		sta ZP_BobOutYMinus1 + 1, x
		sta ZP_BobOutY0 + 1, x

		lda ZP_XCharHiValue
		ora OutYCharTableHi + 1, y

		sta ZP_BobOutY1 + 1, x
		sta ZP_BobOutY2 + 1, x
		sta ZP_BobOutY3 + 1, x
		sta ZP_BobOutY4 + 1, x
		sta ZP_BobOutY5 + 1, x
		sta ZP_BobOutY6 + 1, x
		sta ZP_BobOutY7 + 1, x
		sta ZP_BobOutY8 + 1, x

		lda ZP_XCharHiValue
		ora OutYCharTableHi + 2, y

		ldx PixYMul2 + 1
		sta ZP_BobOutY9 + 1, x
		sta ZP_BobOutY10 + 1, x
		sta ZP_BobOutY11 + 1, x
		sta ZP_BobOutY12 + 1, x
		sta ZP_BobOutY13 + 1, x
		sta ZP_BobOutY14 + 1, x

	BlitBob_JSR:
		jmp $abcd


.import source "../../Build/6502/InfiniteBobs/bob.asm"
