//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "NoBoundsBase"

.var NumBitmapSegments = 17			//; each chunk gets loaded separately

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $1000-1fff Music
//; - $2000-71ff Code
//; - $7400-7bff Stream Data 1
//; - $7c00-83ff Stream Data 0
//; - $8400-8bff Sprites 0
//; - $8c00-8fff Screen 0
//; - $9000-97ff Stream Data 4
//; - $9800-9fff Stream Data 3
//; - $a000-bf3f Bitmap 0
//; - $c000-c3ff Coldata (for init)
//; - $c400-cbff Sprites 1
//; - $cc00-cfff Screen 1
//; - $e000-ff3f Bitmap 1

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var ScreenBank0 = 3 //; Bank+[0c00,0fff]
	.var ScreenBank1 = 3 //; Bank+[0c00,0fff]
	.var BitmapBank0 = 1 //; Bank+[2000,3f3f]
	.var BitmapBank1 = 1 //; Bank+[2000,3f3f]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var SpriteVals0 = (ScreenAddress0 + $3F8)
	.var SpriteVals1 = (ScreenAddress1 + $3F8)
	.var BitmapAddress0 = Base_BankAddress0 + BitmapBank0 * $2000
	.var BitmapAddress1 = Base_BankAddress1 + BitmapBank1 * $2000

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank0 * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank1 * 8)
	
	.var ScreenColour = $00

	.var D016_38ColsMC = $10

	.var ADDR_COLData = $c000

	.var ADDR_LoadSignal = $0400

	.var ADDR_StreamBuffer0 = $7c00			//; new buffer order
	.var ADDR_StreamBuffer1 = $7400
	.var ADDR_StreamBuffer2 = $9800
	.var ADDR_StreamBuffer3 = $9000

	.var ADDR_BarSpriteData = $7200

	.var FirstSpriteIndex = ($0400 / 64)

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:

	.byte $00, $00								//; D000-1: VIC_Sprite0X,Y
	.byte $00, $00								//; D002-3: VIC_Sprite1X,Y
	.byte $00, $00								//; D004-5: VIC_Sprite2X,Y
	.byte $00, $00								//; D006-7: VIC_Sprite3X,Y
	.byte $98, $32								//; D008-9: VIC_Sprite4X,Y
	.byte $c8, $32								//; D00a-b: VIC_Sprite5X,Y
	.byte $f8, $32								//; D00c-d: VIC_Sprite6X,Y
	.byte $28, $32								//; D00e-f: VIC_Sprite7X,Y
	.byte $80									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_38ColsMC							//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $f0									//; D01C: VIC_SpriteMulticolourMode
	.byte $f0									//; D01D: VIC_SpriteDoubleWidth
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
	.byte $04									//; D02B: VIC_Sprite4Colour
	.byte $05									//; D02C: VIC_Sprite5Colour
	.byte $06									//; D02D: VIC_Sprite6Colour
	.byte $07									//; D02E: VIC_Sprite7Colour


IRQPtrsLo:						.byte <IRQ_Main0, <IRQ_Main1, <IRQ_Main0, <IRQ_Main1, <IRQ_Main2
IRQPtrsHi:						.byte >IRQ_Main0, >IRQ_Main1, >IRQ_Main0, >IRQ_Main1, >IRQ_Main2
DD02Values:						.byte DD02Value0, DD02Value1, DD02Value0, DD02Value1

CurrentDBuffer:					.byte 3

FrameLo:						.byte $c4
FrameHi:						.byte $fb

FadeInSpriteTable:
		.fill 6 * 3 + 1, FirstSpriteIndex + 0
		.fill 16, FirstSpriteIndex + i + 0
		.fill 6 * 3 + 1, FirstSpriteIndex + 16

FrameToIndex:
		.byte $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $01, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $02, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $03, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $04, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $05, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $06, $ff, $ff, $ff, $ff, $ff, $ff
		.byte $ff, $07, $ff, $ff, $ff, $ff, $ff, $ff

FrameToIndex_ScreenCopy:
		.byte $ff, $00, $01, $02, $03, $ff, $ff, $ff
		.byte $ff, $04, $05, $06, $07, $ff, $ff, $ff
		.byte $ff, $08, $09, $0a, $0b, $ff, $ff, $ff
		.byte $ff, $0c, $0d, $0e, $0f, $ff, $ff, $ff
		.byte $ff, $10, $11, $12, $13, $ff, $ff, $ff
		.byte $ff, $14, $15, $16, $17, $ff, $ff, $ff
		.byte $ff, $18, $19, $1a, $1b, $ff, $ff, $ff
		.byte $ff, $1c, $1d, $1e, $1f, $ff, $ff, $ff

NumSegmentsLoaded:		.byte $0

//; NoBounds_Go() -------------------------------------------------------------------------------------------------------
NoBounds_Go:

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
	CopyCOLLoop:
		.for (var i = 0; i < 4; i++)
		{
			lda ADDR_COLData + (i * 256), y
			sta VIC_ColourMemory + (i * 256), y
		}
		iny
		bne CopyCOLLoop

		ldy #$00
	CopyFadeSpritesLoop:
		.for (var i = 0; i < 8; i++)
		{
			lda $c400 + (i * 256), y
			sta $8400 + (i * 256), y
		}
		iny
		bne CopyFadeSpritesLoop

		ldy #3
		lda FadeInSpriteTable + 0
	SetFadeInSpritesLoop:
		sta SpriteVals0 + 4, y
		sta SpriteVals1 + 4, y
		dey
		bpl SetFadeInSpritesLoop

		vsync()

	WaitForBottomOfScreen:
		bit VIC_D011
		bpl WaitForBottomOfScreen

		sei
		
		lda #$3b
		sta VIC_D011
		lda #$00
		sta VIC_D012
		lda #<IRQ_Bottom
		sta $fffe
		lda #>IRQ_Bottom
		sta $ffff

		lda #$f0
		sta VIC_SpriteEnable

		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #$00
		sta ADDR_LoadSignal

		rts

ScrollScreenAndFinishIRQ:

	FrameCount:
		lda #$ff
		clc
	FrameCountAdd:
		adc #1
		and #$3f
		sta FrameCount + 1
		lsr
		lsr
		lsr
		sta VSP_Distance0 + 1
		sta VSP_Distance1 + 1
		sta VSP_Distance2 + 1

		lda FrameCount + 1
		and #$07
		eor #$17
		sta VIC_D016

		lda FrameCount + 1
		bne NotAtEndOfScroll

		lda CurrentDBuffer
		clc
		adc #1
		and #3
		sta CurrentDBuffer
		tay
		lda DD02Values, y
		sta VIC_DD02
	NotAtEndOfScroll:

	JSR_ToUpdateFromBuffer:
		jsr UpdateFromBuffer

		lda #50
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		jsr UpdateSprites

		ldy CurrentDBuffer
		lda FrameCount + 1
		cmp #63
		bne NotNewFrame

		inc ADDR_LoadSignal
		inc NumSegmentsLoaded

		lda NumSegmentsLoaded
		cmp #NumBitmapSegments
		bcc NotLastLoad

		dec ADDR_LoadSignal				//; cancel that last load!
	NotLastLoad:

		ldy #4
	NotNewFrame:
		
		sty NextFrameIRQ + 1

		inc FrameLo
		bne DontStartEaseOut
		inc FrameHi
		bne DontStartEaseOut

		lda #((6 * 3) + 16) * 4 - 1
		sta FadeOutSpritesIndex + 1
		inc ADDR_LoadSignal				//; to load in the fade-stuff..

	DontStartEaseOut:

		lda #$00
		sta VIC_D012
		lda #<IRQ_Bottom
		sta $fffe
		lda #>IRQ_Bottom
		sta $ffff
		
		:IRQManager_EndIRQ()
		rti


IRQ_Bottom:

		:IRQManager_BeginIRQ(0,0)

		lda #$03
		sta VIC_BorderColour

		jsr BASE_PlayMusic

	NextFrameIRQ:
		ldy #$00
		lda #48
		sta VIC_D012
		lda IRQPtrsLo, y
		sta $fffe
		lda IRQPtrsHi, y
		sta $ffff

		:IRQManager_EndIRQ()
		rti



.import source "../../Build/6502/NoBounds/RasterCode.asm"

DBUpdatesLo:		.byte <(UpdateDB0_BitmapFromBuffer0 - 1), <(UpdateDB1_BitmapFromBuffer1 - 1), <(UpdateDB0_BitmapFromBuffer2 - 1), <(UpdateDB1_BitmapFromBuffer3 - 1)
DBUpdatesHi:		.byte >(UpdateDB0_BitmapFromBuffer0 - 1), >(UpdateDB1_BitmapFromBuffer1 - 1), >(UpdateDB0_BitmapFromBuffer2 - 1), >(UpdateDB1_BitmapFromBuffer3 - 1)

UpdateFromBuffer:
		ldy FrameCount + 1
		ldx CurrentDBuffer
	
	//; set the return address as a fast way to indirect jump :-)
		lda DBUpdatesHi, x
		pha
		lda DBUpdatesLo, x
		pha
		rts

	UpdateDB0_BitmapFromBuffer0:
		jsr UpdateDB0_DoBitmapCopy

		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer0 + (Row * 8 * 8), y
			sta BitmapAddress0 + ((Row + 1) * 320), y
			sta BitmapAddress1 + (Row * 320) + 256, y
		}

		ldx FrameToIndex, y
		bpl UpdateDB0_ScreenAndColourFromBuffer0
		rts

	UpdateDB0_ScreenAndColourFromBuffer0:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer0 + (25 * 8 * 8) + (Row * 8), x
			sta ScreenAddress0 + ((Row + 1) * 40), x
			sta ScreenAddress1 + (Row * 40) + 32, x
			lda ADDR_StreamBuffer0 + (25 * 8 * 8) + (25 * 8) + (Row * 8), x
			sta VIC_ColourMemory + ((Row + 1) * 40), x
		}
		rts

	UpdateDB1_BitmapFromBuffer1:
		jsr UpdateDB1_DoBitmapCopy

		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer1 + (Row * 8 * 8), y
			sta BitmapAddress1 + ((Row + 1) * 320), y
			sta BitmapAddress0 + (Row * 320) + 256, y
		}

		ldx FrameToIndex, y
		bpl UpdateDB1_ScreenAndColourFromBuffer1
		rts

	UpdateDB1_ScreenAndColourFromBuffer1:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer1 + (25 * 8 * 8) + (Row * 8), x
			sta ScreenAddress1 + ((Row + 1) * 40), x
			sta ScreenAddress0 + (Row * 40) + 32, x
			lda ADDR_StreamBuffer1 + (25 * 8 * 8) + (25 * 8) + (Row * 8), x
			sta VIC_ColourMemory + ((Row + 1) * 40), x
		}
		rts

	UpdateDB0_BitmapFromBuffer2:
		jsr UpdateDB0_DoBitmapCopy

		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer2 + (Row * 8 * 8), y
			sta BitmapAddress0 + ((Row + 1) * 320), y
			sta BitmapAddress1 + (Row * 320) + 256, y
		}

		ldx FrameToIndex, y
		bpl UpdateDB0_ScreenAndColourFromBuffer2
		rts

	UpdateDB0_ScreenAndColourFromBuffer2:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer2 + (25 * 8 * 8) + (Row * 8), x
			sta ScreenAddress0 + ((Row + 1) * 40), x
			sta ScreenAddress1 + (Row * 40) + 32, x
			lda ADDR_StreamBuffer2 + (25 * 8 * 8) + (25 * 8) + (Row * 8), x
			sta VIC_ColourMemory + ((Row + 1) * 40), x
		}
		rts

	UpdateDB1_BitmapFromBuffer3:
		jsr UpdateDB1_DoBitmapCopy

		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer3 + (Row * 8 * 8), y
			sta BitmapAddress1 + ((Row + 1) * 320), y
			sta BitmapAddress0 + (Row * 320) + 256, y
		}

		ldx FrameToIndex, y
		bpl UpdateDB1_ScreenAndColourFromBuffer3
		rts

	UpdateDB1_ScreenAndColourFromBuffer3:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ADDR_StreamBuffer3 + (25 * 8 * 8) + (Row * 8), x
			sta ScreenAddress1 + ((Row + 1) * 40), x
			sta ScreenAddress0 + (Row * 40) + 32, x
			lda ADDR_StreamBuffer3 + (25 * 8 * 8) + (25 * 8) + (Row * 8), x
			sta VIC_ColourMemory + ((Row + 1) * 40), x
		}
		rts



	UpdateDB0_DoBitmapCopy:
		.for (var Row = 0; Row < 25; Row++)
		{
			.for (var Col = 0; Col < 4; Col++)
			{
				lda BitmapAddress0 + (64 * (Col + 1)) + (320 * Row), y
				sta BitmapAddress1 + (64 * (Col + 0)) + (320 * Row), y
			}
		}
	UpdateDB0_DoScreenCopy:
		ldx FrameToIndex_ScreenCopy, y
		bpl Yes_UpdateDB0_DoScreenCopy
		rts
	Yes_UpdateDB0_DoScreenCopy:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ScreenAddress0 + 8 + (40 * Row), x
			sta ScreenAddress1 + 0 + (40 * Row), x
		}
		rts


	UpdateDB1_DoBitmapCopy:
		.for (var Row = 0; Row < 25; Row++)
		{
			.for (var Col = 0; Col < 4; Col++)
			{
				lda BitmapAddress1 + (64 * (Col + 1)) + (320 * Row), y
				sta BitmapAddress0 + (64 * (Col + 0)) + (320 * Row), y
			}
		}
	UpdateDB1_DoScreenCopy:
		ldx FrameToIndex_ScreenCopy, y
		bpl Yes_UpdateDB1_DoScreenCopy
		rts
	Yes_UpdateDB1_DoScreenCopy:
		.for (var Row = 0; Row < 25; Row++)
		{
			lda ScreenAddress1 + 8 + (40 * Row), x
			sta ScreenAddress0 + 0 + (40 * Row), x
		}
		rts



UpdateSprites:

		lda #$f0
		sta VIC_SpriteDoubleWidth

	FadeInSpritesIndex:
		lda #1
		beq FadeOutSprites
		lsr
		lsr
		tax

		ldy FadeInSpritesIndex + 1
		iny
		cpy #((6 * 3) + 16) * 4
		bne NotFinalFadeInSprite
		ldy #0
	NotFinalFadeInSprite:
		sty FadeInSpritesIndex + 1

		lda #$98		//; sprite x
		ldy #$80		//; xmsb

	SetFadeSpriteVals:
		sta VIC_Sprite4X
		clc
		adc #$30
		sta VIC_Sprite5X
		clc
		adc #$30
		sta VIC_Sprite6X
		clc
		adc #$30
		sta VIC_Sprite7X
		sty VIC_SpriteXMSB

		lda FadeInSpriteTable + (6 * 3), x
		sta SpriteVals0 + 4
		sta SpriteVals1 + 4
		lda FadeInSpriteTable + (6 * 2), x
		sta SpriteVals0 + 5
		sta SpriteVals1 + 5
		lda FadeInSpriteTable + (6 * 1), x
		sta SpriteVals0 + 6
		sta SpriteVals1 + 6
		lda FadeInSpriteTable + (6 * 0), x
		sta SpriteVals0 + 7
		sta SpriteVals1 + 7
		rts

	FadeOutSprites:
	FadeOutSpritesIndex:
		lda #0
		beq DoMainSpriteEffect
		lsr
		lsr
		tax

		lda #$18		//; sprite x
		ldy #$00		//; xmsb

		dec FadeOutSpritesIndex + 1
		bne SetFadeSpriteVals
		inc FadeOutSpritesIndex + 1
		sty FrameCountAdd + 1
		inc PART_Done
		jmp SetFadeSpriteVals

	DoMainSpriteEffect:

	MoveFrame:
		ldy #$88
		lda ADDR_BarSpriteData + (9 * 0), y
		sta VIC_Sprite4X
		lda ADDR_BarSpriteData + (9 * 1), y
		sta VIC_Sprite5X
		lda ADDR_BarSpriteData + (9 * 2), y
		sta VIC_Sprite6X
		lda ADDR_BarSpriteData + (9 * 3), y
		sta VIC_Sprite7X
		lda #$00
		sta VIC_SpriteDoubleWidth

		lda ADDR_BarSpriteData + (1 * 256), y
		sta VIC_SpriteXMSB

		ldx MoveFrame + 1
	MoveFrameINX:
		inx
		cpx #200
		bne GoodMoveFrame
		ldx #0
	GoodMoveFrame:
		stx MoveFrame + 1

		cpx #30
		bne AnimFrame
		inc LoopCount
		lda LoopCount
		cmp #5
		bne AnimFrame
		lda #NOP
		sta MoveFrameINX

	AnimFrame:
		lda #$00
		clc
		adc #FirstSpriteIndex + 17
		sta SpriteVals0 + 4
		sta SpriteVals1 + 4
		sta SpriteVals0 + 5
		sta SpriteVals1 + 5
		sta SpriteVals0 + 6
		sta SpriteVals1 + 6
		sta SpriteVals0 + 7
		sta SpriteVals1 + 7

		ldx AnimFrame + 1
		dex
		bpl GoodAnimFrame
		ldx #14
	GoodAnimFrame:
		stx AnimFrame + 1

		rts

LoopCount:
		.byte $00