//; TODO: make the bob-plot so that we only write to actually affected bytes .. get rid of the top/bottom padding completely!

//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "InfiniteBobsBase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $1000-1fff Music
//; - $2000-29ff Code
//; - $3700-37ff FlipBits
//; - $3800-3fff SinTables
//; - $4000-77ff CharSets 0
//; - $7800-7bff Screen 0
//; - $8000-b7ff Image Data
//; - $c000-f7ff CharSets 1
//; - $f800-fbff Screen 0

	.var ColourBG = 0
	.var ColourLight = 1
	.var ColourMid = 14
	.var ColourDark = 11

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

	.var ZP_CharScroll = $c0

	.var ADDR_SinTables = $3800
	.var ADDR_SinTable_ScreenX =		ADDR_SinTables + (0 * 256)
	.var ADDR_SinTable_ScreenY =		ADDR_SinTables + (1 * 256)
	.var ADDR_SinTable_ScreenYPix =		ADDR_SinTables + (2 * 256)
	.var ADDR_SinTable_BobX =			ADDR_SinTables + (3 * 256)
	.var ADDR_SinTable_BobXPix =		ADDR_SinTables + (4 * 256)
	.var ADDR_SinTable_BobY =			ADDR_SinTables + (5 * 256)
	.var ADDR_SinTable_BobYPix =		ADDR_SinTables + (6 * 256)
	.var ADDR_SinTable_ScreenY_Clear =	ADDR_SinTables + (7 * 256)

	.var ADDR_FlipY =					$3600
	.var ADDR_FlipBits =				$3700

	.var ADDR_ImageData =				$8000

	.var ZP_ScreenWriteStartIndex0 = $40
	.var ZP_ScreenWriteStartIndex1 = $41
	.var ZP_ScreenWriteStartIndex2 = $42
	.var ZP_ScreenWriteStartIndex3 = $43

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:
	.byte $18									//; D000: VIC_Sprite0X
	.byte 250-32								//; D001: VIC_Sprite0Y
	.byte $48									//; D002: VIC_Sprite1X
	.byte 250-32								//; D003: VIC_Sprite1Y
	.byte $78									//; D004: VIC_Sprite2X
	.byte 250-32								//; D005: VIC_Sprite2Y
	.byte $a8									//; D006: VIC_Sprite3X
	.byte 250-32								//; D007: VIC_Sprite3Y
	.byte $d8									//; D008: VIC_Sprite4X
	.byte 250-32								//; D009: VIC_Sprite4Y
	.byte $08									//; D00a: VIC_Sprite5X
	.byte 250-32								//; D00b: VIC_Sprite5Y
	.byte $38									//; D00c: VIC_Sprite6X
	.byte 250-32								//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $60									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $7f									//; D015: VIC_SpriteEnable
	.byte D016_38ColsMC							//; D016: VIC_D016
	.byte $7f									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $7f									//; D01D: VIC_SpriteDoubleWidth
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

FrameCounterLo:		.byte $80
FrameCounterHi:		.byte $fe

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

		dec $01
		jsr SetupWholeScreen
		inc $01

		MACRO_SetVICBank(BaseBank0)

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

		ldy #$00
		lda #$ff
	FillSpriteDataLoop:
		sta Base_BankAddress0 + $3e00, y
		sta Base_BankAddress1 + $3e00, y
		sta Base_BankAddress0 + $3ec0, y
		sta Base_BankAddress1 + $3ec0, y
		iny
		bne FillSpriteDataLoop

		vsync()

		lda #ColourDark
		sta VIC_ScreenColour
		lda #ColourLight
		sta VIC_MultiColour0
		lda #ColourMid
		sta VIC_MultiColour1

		sei	

		lda #$f8
		sta VIC_D012
		lda #$17
		sta VIC_D011
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		lda #ColourBG
		sta VIC_BorderColour

		cli

	WaitForVSSignal:
		lda PART_Done
		beq NotFinishedDemoPart
		rts

	NotFinishedDemoPart:
		lda VSynced
		beq WaitForVSSignal
		dec VSynced

		lda #$04
		sta VIC_BorderColour

		dec $01

		lda FrameX + 1
		sta BlitBob0_SinIndexX + 1
		lda FrameY + 1
		sta BlitBob0_SinIndexY + 1
		jsr BlitBob0

		lda FrameX + 1
		clc
		adc #(1 * 2)
		sta BlitBob0_SinIndexX + 1
		lda FrameY + 1
		sec
		sbc #(1 * 1)
		sta BlitBob0_SinIndexY + 1
		jsr BlitBob0

		lda FrameX + 1
		clc
		adc #(2 * 2)
		sta BlitBob0_SinIndexX + 1
		lda FrameY + 1
		sec
		sbc #(2 * 1)
		sta BlitBob0_SinIndexY + 1
		jsr BlitBob0

		lda FrameX + 1
		clc
		adc #(3 * 2)
		sta BlitBob0_SinIndexX + 1
		lda FrameY + 1
		sec
		sbc #(3 * 1)
		sta BlitBob0_SinIndexY + 1
		jsr BlitBob0

		lda FrameX + 1
		clc
		adc #(4 * 2)
		sta BlitBob0_SinIndexX + 1
		lda FrameY + 1
		sec
		sbc #(4 * 1)
		sta BlitBob0_SinIndexY + 1
		jsr BlitBob0

		inc $01
		lda #$05
		sta VIC_BorderColour
		dec $01

		jsr RestoreHorizontalLine

		inc $01

		lda #$00
		sta VIC_BorderColour

		jmp WaitForVSSignal

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

		jsr BASE_PlayMusic

		lda #$fe
		ldx #<IRQ_Main
		ldy #>IRQ_Main
		bne EndIRQ

	AllGood:
		lda NextD012 + 1

	EndIRQ:
		sta VIC_D012
		stx $fffe
		sty $ffff

		IRQManager_EndIRQ()
		rti

IRQ_Main:

		IRQManager_BeginIRQ(0, 0)

		inc VSynced

	FrameX:
		ldx #$00
		inx
		cpx #219
		bne NotEndOfSineX
		ldx #0
	NotEndOfSineX:
		stx FrameX + 1

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
		tax
		jsr FillVerticalScreenLine
		jmp NoVSPLineUpdate

	PicMovingLeft:
		lda VSPDistance + 1
		clc
		adc #39
		tax
		jsr FillVerticalScreenLine

	NoVSPLineUpdate:
		ldx FrameX + 1
		lda ADDR_SinTable_ScreenX, x
		and #$07
		eor #$17
		sta VIC_D016



	FrameY:
		ldx #$33
		inx
		stx FrameY + 1

		lda ADDR_SinTable_ScreenYPix, x
		eor #$57
		sta SetD011Value + 1

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

		bit ADDR_FullDemoMarker
		bpl NotLastFrame

		inc PART_Done
	NotLastFrame:

		lda #$57
		sta VIC_D011
		lda #47
		sta VIC_D012
		lda #<IRQ_AGSP
		sta $fffe
		lda #>IRQ_AGSP
		sta $ffff

		IRQManager_EndIRQ()
		rti

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
		and #$17

		ldx #$3f
	WaitFor3F:
		cpx VIC_D012
		bne WaitFor3F
		sta VIC_D011

	FirstIndex:
		ldy #1
		lda D018Values, y
		sta NextD018Value + 1
		lda DD02Values, y
		sta NextDD02Value + 1
		iny
		sty NextIndex + 1

	FirstD018Value:
		lda #$00
	FirstDD02Value:
		ldy #$00
	SetD012Value:
		ldx #$00
	WaitForFirstD012:
		cpx VIC_D012
		bne WaitForFirstD012
		.for (var i = 0; i < 24; i++)
		{
			nop
		}
		sta VIC_D018
		sty VIC_DD02

		txa
		clc
		adc #32
		sta NextD012 + 1
		sta VIC_D012
		ldx #<IRQ_UpdateD018
		ldy #>IRQ_UpdateD018
		stx $fffe
		sty $ffff

		IRQManager_EndIRQ()
		rti


BlitBob0:

	BlitBob0_SinIndexX:
		ldy #$00
		ldx ADDR_SinTable_BobX, y
		lda ADDR_SinTable_BobXPix, y

	BlitBob0_SinIndexY:
		ldy #$00
		ora ADDR_SinTable_BobYPix, y
		sta BobYPix0 + 1
		lda ADDR_SinTable_BobY, y
		tay
	
		lda OutXCharTableLo, x
		sta BlitBob0_CharOffset + 1
		clc
		adc #8
		sta BlitBob0_CharOffsetPlus8 + 1


		lda OutXCharTableHi + 0, x
		ora OutYCharTableHi + 0, y
//; 0,0
		sta BlitBob0_CharAddr_00A + 2
		sta BlitBob0_CharAddr_00B + 2
//; 1, 0
		sta BlitBob0_CharAddr_10A + 2
		sta BlitBob0_CharAddr_10B + 2
//; 2,0
		sta BlitBob0_CharAddr_20A + 2
		sta BlitBob0_CharAddr_20B + 2

//; 0,1
		lda OutXCharTableHi + 0, x
		ora OutYCharTableHi + 1, y
		sta BlitBob0_CharAddr_01A + 2
		sta BlitBob0_CharAddr_01B + 2
//; 1,1
		sta BlitBob0_CharAddr_11A + 2
		sta BlitBob0_CharAddr_11B + 2
//; 2,1
		sta BlitBob0_CharAddr_21A + 2
		sta BlitBob0_CharAddr_21B + 2
//; 0,2
		lda OutXCharTableHi + 0, x
		ora OutYCharTableHi + 2, y
		sta BlitBob0_CharAddr_02A + 2
		sta BlitBob0_CharAddr_02B + 2
//; 1,2
		sta BlitBob0_CharAddr_12A + 2
		sta BlitBob0_CharAddr_12B + 2
//; 2,2
		sta BlitBob0_CharAddr_22A + 2
		sta BlitBob0_CharAddr_22B + 2




	BlitBob0_CharOffset:
		ldx #0
	BobYPix0:
		ldy #$00

	BlitBob0Loop:

	BlitBob0_CharAddr_00A:
		lda $ab00 + (0 * 8), x
		and Bob0_Mask_Shift0_X0 + (0 * 8), y
		eor Bob0_Data_Shift0_X0 + (0 * 8), y
	BlitBob0_CharAddr_00B:
		sta $ab00 + (0 * 8), x

	BlitBob0_CharAddr_10A:
		lda $ab00 + (1 * 8), x
		and Bob0_Mask_Shift0_X1 + (0 * 8), y
		eor Bob0_Data_Shift0_X1 + (0 * 8), y
	BlitBob0_CharAddr_10B:
		sta $ab00 + (1 * 8), x

	BlitBob0_CharAddr_20A:
		lda $ab00 + (2 * 8), x
		and Bob0_Mask_Shift0_X2 + (0 * 8), y
		eor Bob0_Data_Shift0_X2 + (0 * 8), y
	BlitBob0_CharAddr_20B:
		sta $ab00 + (2 * 8), x



	BlitBob0_CharAddr_01A:
		lda $ab00 + (0 * 8), x
		and Bob0_Mask_Shift0_X0 + (1 * 8), y
		eor Bob0_Data_Shift0_X0 + (1 * 8), y
	BlitBob0_CharAddr_01B:
		sta $ab00 + (0 * 8), x

	BlitBob0_CharAddr_11A:
		lda $ab00 + (1 * 8), x
		and Bob0_Mask_Shift0_X1 + (1 * 8), y
		eor Bob0_Data_Shift0_X1 + (1 * 8), y
	BlitBob0_CharAddr_11B:
		sta $ab00 + (1 * 8), x

	BlitBob0_CharAddr_21A:
		lda $ab00 + (2 * 8), x
		and Bob0_Mask_Shift0_X2 + (1 * 8), y
		eor Bob0_Data_Shift0_X2 + (1 * 8), y
	BlitBob0_CharAddr_21B:
		sta $ab00 + (2 * 8), x



	BlitBob0_CharAddr_02A:
		lda $ab00 + (0 * 8), x
		and Bob0_Mask_Shift0_X0 + (2 * 8), y
		eor Bob0_Data_Shift0_X0 + (2 * 8), y
	BlitBob0_CharAddr_02B:
		sta $ab00 + (0 * 8), x

	BlitBob0_CharAddr_12A:
		lda $ab00 + (1 * 8), x
		and Bob0_Mask_Shift0_X1 + (2 * 8), y
		eor Bob0_Data_Shift0_X1 + (2 * 8), y
	BlitBob0_CharAddr_12B:
		sta $ab00 + (1 * 8), x

	BlitBob0_CharAddr_22A:
		lda $ab00 + (2 * 8), x
		and Bob0_Mask_Shift0_X2 + (2 * 8), y
		eor Bob0_Data_Shift0_X2 + (2 * 8), y
	BlitBob0_CharAddr_22B:
		sta $ab00 + (2 * 8), x

		iny

		inx
	BlitBob0_CharOffsetPlus8:
		cpx #8
		bne BlitBob0Loop

		rts



FillVerticalScreenLine:

		sta ScreenAddress0 + ( 5 * 40), x
		sta ScreenAddress0 + ( 9 * 40), x
		sta ScreenAddress0 + (13 * 40), x
		sta ScreenAddress0 + (17 * 40), x
		sta ScreenAddress0 + (21 * 40), x
		sta ScreenAddress1 + ( 5 * 40), x
		sta ScreenAddress1 + ( 9 * 40), x
		sta ScreenAddress1 + (13 * 40), x
		sta ScreenAddress1 + (17 * 40), x
		sta ScreenAddress1 + (21 * 40), x

		eor #$40
		sta ScreenAddress0 + ( 2 * 40), x
		sta ScreenAddress0 + ( 6 * 40), x
		sta ScreenAddress0 + (10 * 40), x
		sta ScreenAddress0 + (14 * 40), x
		sta ScreenAddress0 + (18 * 40), x
		sta ScreenAddress0 + (22 * 40), x
		sta ScreenAddress1 + ( 2 * 40), x
		sta ScreenAddress1 + ( 6 * 40), x
		sta ScreenAddress1 + (10 * 40), x
		sta ScreenAddress1 + (14 * 40), x
		sta ScreenAddress1 + (18 * 40), x
		sta ScreenAddress1 + (22 * 40), x

		eor #$c0
		sta ScreenAddress0 + ( 3 * 40), x
		sta ScreenAddress0 + ( 7 * 40), x
		sta ScreenAddress0 + (11 * 40), x
		sta ScreenAddress0 + (15 * 40), x
		sta ScreenAddress0 + (19 * 40), x
		sta ScreenAddress0 + (23 * 40), x
		sta ScreenAddress1 + ( 3 * 40), x
		sta ScreenAddress1 + ( 7 * 40), x
		sta ScreenAddress1 + (11 * 40), x
		sta ScreenAddress1 + (15 * 40), x
		sta ScreenAddress1 + (19 * 40), x
		sta ScreenAddress1 + (23 * 40), x


		eor #$40
		sta ScreenAddress0 + ( 4 * 40), x
		sta ScreenAddress0 + ( 8 * 40), x
		sta ScreenAddress0 + (12 * 40), x
		sta ScreenAddress0 + (16 * 40), x
		sta ScreenAddress0 + (20 * 40), x
		sta ScreenAddress0 + (24 * 40), x
		sta ScreenAddress1 + ( 4 * 40), x
		sta ScreenAddress1 + ( 8 * 40), x
		sta ScreenAddress1 + (12 * 40), x
		sta ScreenAddress1 + (16 * 40), x
		sta ScreenAddress1 + (20 * 40), x
		sta ScreenAddress1 + (24 * 40), x

		rts

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
		ldy #39
		lda ADDR_SinTable_ScreenX + 0
		lsr
		lsr
		lsr
		tax
	FillScreenLoop:
		txa
		jsr FillVerticalScreenLine
		inx
		dey
		bpl FillScreenLoop

		rts

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

.import source "../../Link/InfiniteBobs/bob0.asm"
