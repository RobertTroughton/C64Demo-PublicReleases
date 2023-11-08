//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

* = ProudlyPresent_BASE "ProudlyPresentBase"

		jmp ProudlyPresent_Go

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - $0800-1fff Music + Disk Driver
//; - $c000-c1ff Code
//; - $cc00-cfff Screen
//; - $e000-ff7f Bitmap

//; Local Defines -------------------------------------------------------------------------------------------------------

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var ScreenBank = 12 //; Bank+[3000,33ff]
	.var BitmapBank = 0 //; Bank+[0000,1f3f]
	.var ScreenAddress = Base_BankAddress + ScreenBank * $400
	.var SpriteVals = ScreenAddress + $3f8

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D016_Value_40Chars = $18

	.var D011_Value_25Rows = $3b

	.var PartDone = $087f

	.var SCRCOLDataLoadAddress = $f800
	.var ScreenLoadAddr0 =	SCRCOLDataLoadAddress + ((10 * 40) * 0)
	.var ScreenLoadAddr1 =	SCRCOLDataLoadAddress + ((10 * 40) * 1)
	.var ColourLoadAddr =	SCRCOLDataLoadAddress + ((10 * 40) * 2)

	.var ZP_ColourFadePtr = $40

	.var SnowSprites_StartIndex = ($3400 / 64)

	.var SineTableAddr = $ff00
	.var SineTable0 = SineTableAddr + (0 * 64)
	.var SineTable1 = SineTableAddr + (1 * 64)

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $18									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $48									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $78									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $a8									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $d8									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $08									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $38									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $60									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Chars					//; D016: VIC_D016
	.byte $7f									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
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
	.byte $01									//; D027: VIC_Sprite0Colour
	.byte $01									//; D028: VIC_Sprite1Colour
	.byte $01									//; D029: VIC_Sprite2Colour
	.byte $01									//; D02A: VIC_Sprite3Colour
	.byte $01									//; D02B: VIC_Sprite4Colour
	.byte $01									//; D02C: VIC_Sprite5Colour
	.byte $01									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

FrameOf256:								.byte $00

EaseMode:								.byte $01 //; 1= Ease in rasters, 2 = ease in bitmap, 3 = ease out bitmap, 4 = ease out rasters, 5 = done
EaseTopLine:							.byte 142
EaseBottomLine:							.byte 144
bShowBitmap:							.byte $00

//; ProudlyPresent_Go() -------------------------------------------------------------------------------------------------------
ProudlyPresent_Go:

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

		ldy #$00
		lda #$11
	FillColourScreenMemoryLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		sta ScreenAddress + (0 * 256), y
		sta ScreenAddress + (1 * 256), y
		sta ScreenAddress + (2 * 256), y
		sta ScreenAddress + (1000 - 256), y
		iny
		bne FillColourScreenMemoryLoop

		vsync()

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$00
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		rts

//; IRQ_Main() -------------------------------------------------------------------------------------------------------
IRQ_Main:
		IRQManager_BeginIRQ(0, 0)

		jsr BASE_PlayMusic

	D011Value:
		lda #$00
		sta VIC_D011

		ldx #$00
		lda bShowBitmap
		beq SkipSnowfallSpriteAnim
		jsr SetSnowfallSpritesRow1
		ldx #$7f
	SkipSnowfallSpriteAnim:
		stx VIC_SpriteEnable

		inc FrameOf256
		lda FrameOf256
		cmp #$f0
		bne NotFinishedYet

		lda #3
		sta EaseMode

	NotFinishedYet:

		lda #<IRQ_EaseTop
		sta $fffe
		lda #>IRQ_EaseTop
		sta $ffff
		lda EaseTopLine
		sta VIC_D012

		IRQManager_EndIRQ()
		rti

//; IRQ_EaseTop() -------------------------------------------------------------------------------------------------------
IRQ_EaseTop:

		IRQManager_BeginIRQ(1, 0)

		lda #$01
		sta VIC_BorderColour
		sta VIC_ScreenColour

		lda bShowBitmap
		beq DontUpdateSnowfall
		lda #107
	WaitForRow2:
		cmp VIC_D012
		bcs WaitForRow2
		jsr SetSnowfallSpritesRow2
	DontUpdateSnowfall:

		lda #<IRQ_EaseBottom
		sta $fffe
		lda #>IRQ_EaseBottom
		sta $ffff
		lda EaseBottomLine
		sta VIC_D012

		IRQManager_EndIRQ()
		rti

DoEaseInBitmap:
		jsr Bitmap_DoEaseIn
		jmp FinishedEase

DoEaseOutBitmap:
		jsr Bitmap_DoEaseOut
		jmp FinishedEase


OuterColours:	.byte $0f, $0c, $0b, $00

//; IRQ_EaseBottom() -------------------------------------------------------------------------------------------------------
IRQ_EaseBottom:

		IRQManager_BeginIRQ(1, 0)
	BottomBorderColour:
		lda #$00
		sta VIC_BorderColour
		sta VIC_ScreenColour

		lda EaseMode
		beq FinishedEase

		cmp #1
		beq DoEaseIn
		cmp #2
		beq DoEaseInBitmap
		cmp #3
		beq DoEaseOutBitmap

	DoEaseOut:
		ldx #$3f
		lda SineTable0, x
		sta EaseTopLine
		lda SineTable1, x
		sta EaseBottomLine

		txa
		lsr
		lsr
		lsr
		lsr
		tay
		lda OuterColours, y
		sta BottomBorderColour + 1

		dex
		bpl NotFinishedEaseOut

		lda #$00
		sta EaseMode

		inc PartDone
		jmp FinishedEase

	NotFinishedEaseOut:
		stx DoEaseOut + 1
		jmp FinishedEase

	DoEaseIn:
		ldx #$00
		lda SineTable0, x
		sta EaseTopLine
		lda SineTable1, x
		sta EaseBottomLine
		inx
		cpx #$40
		bne FinishedEase

		inc EaseMode
		lda #$3b
		sta D011Value + 1
		sta bShowBitmap
		ldx #$3f

	FinishedEase:
		stx DoEaseIn + 1

		lda #$00
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti


.align 128
ColourFadeTables:
	.fill 16, i
	.byte  6,  1,  8, 13, 12,  3, 11,  1, 10,  2, 15,  4,  3,  1,  3,  7
	.byte 11,  1, 10,  1,  3, 13,  4,  1, 15,  8,  7, 12, 13,  1, 13,  1
	.byte  4,  1, 15,  1, 13,  1, 12,  1,  7, 10,  1,  3,  1,  1,  1,  1
	.byte 12,  1,  7,  1,  1,  1,  3,  1,  1, 15,  1, 13,  1,  1,  1,  1
	.byte  3,  1,  1,  1,  1,  1, 13,  1,  1,  7,  1,  1,  1,  1,  1,  1
	.byte 13,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
	.fill 16, 1

Bitmap_DoEaseIn:

		ldx #39
		ldy #6

	EaseIn_Loop:
		cpx #$00
		bmi EaseIn_SkipColumn

		stx EaseIn_RestoreX + 1
		sty EaseIn_RestoreY + 1
		jsr CopyScreenColourColumn

	EaseIn_RestoreX:
		ldx #$ab
	EaseIn_RestoreY:
		ldy #$ab

	EaseIn_SkipColumn:
		inx
		cpx #40
		beq EaseIn_FinishedFrame

		dey
		bpl EaseIn_Loop

	EaseIn_FinishedFrame:
		dec Bitmap_DoEaseIn + 1
		lda Bitmap_DoEaseIn + 1
		cmp #$f9
		bne EaseIn_NotFinished

		lda #$00
		sta EaseMode

	EaseIn_NotFinished:
		rts

Bitmap_DoEaseOut:

		ldx #39
		ldy #1

	EaseOut_Loop:
		cpx #$00
		bmi EaseOut_SkipColumn

		stx EaseOut_RestoreX + 1
		sty EaseOut_RestoreY + 1
		jsr CopyScreenColourColumn

	EaseOut_RestoreX:
		ldx #$ab
	EaseOut_RestoreY:
		ldy #$ab

	EaseOut_SkipColumn:
		inx
		cpx #40
		beq EaseOut_FinishedFrame

		iny
		cpy #8
		bne EaseOut_Loop

	EaseOut_FinishedFrame:

		dec Bitmap_DoEaseOut + 1
		lda Bitmap_DoEaseOut + 1
		cmp #$f9
		bne EaseOut_NotFinished

		inc EaseMode

		lda #$00
		sta D011Value + 1
		sta bShowBitmap

	EaseOut_NotFinished:
		rts



CopyScreenColourColumn:

		tya
		asl
		asl
		asl
		asl
		ora #<ColourFadeTables
		sta ZP_ColourFadePtr + 0
		lda #>ColourFadeTables
		sta ZP_ColourFadePtr + 1

		.for (var i = 0; i < 10; i++)
		{
			ldy ScreenLoadAddr1 + (i * 40) ,x
			lda (ZP_ColourFadePtr), y
			asl
			asl
			asl
			asl
			ldy ScreenLoadAddr0 + (i * 40), x
			ora (ZP_ColourFadePtr), y
			sta ScreenAddress + ((i + 7) * 40), x
		}

		.for (var i = 0; i < 10; i++)
		{
			ldy ColourLoadAddr + (i * 40), x
			lda (ZP_ColourFadePtr), y
			sta VIC_ColourMemory + ((i + 7) * 40), x
		}

		rts

XModded:					.fill 16, i
							.fill 16, i
SnowAnimSpriteIndices:		.fill 16, SnowSprites_StartIndex + i

SetSnowfallSpritesRow1:

	SetSnowfallSpritesIndex:
		ldx #$00

		lda SnowAnimSpriteIndices, x
		sta SpriteVals + 0
		ldy XModded + 3, x

		lda SnowAnimSpriteIndices, y
		sta SpriteVals + 1
		ldx XModded + 3, y

		lda SnowAnimSpriteIndices, x
		sta SpriteVals + 2
		ldy XModded + 3, x

		lda SnowAnimSpriteIndices, y
		sta SpriteVals + 3
		ldx XModded + 3, y

		lda SnowAnimSpriteIndices, x
		sta SpriteVals + 4
		ldy XModded + 3, x

		lda SnowAnimSpriteIndices, y
		sta SpriteVals + 5
		ldx XModded + 3, y

		lda SnowAnimSpriteIndices, x
		sta SpriteVals + 6

		lda #106
		.for (var i = 0; i < 7; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

		lda FrameOf256
		and #$01
		bne DontAnimate
		ldx SetSnowfallSpritesIndex + 1
		ldy XModded + 1, x
		sty SetSnowfallSpritesIndex + 1
	DontAnimate:

		rts

SetSnowfallSpritesRow2:
		lda #106 + 42
		.for (var i = 0; i < 7; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

		rts

