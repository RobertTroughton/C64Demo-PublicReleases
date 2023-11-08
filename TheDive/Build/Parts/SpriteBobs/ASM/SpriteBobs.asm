//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = SpriteBobs_BASE "Sprite Bobs"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp SB_Init									//; Init
		jmp	SB_Draw									//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-29ff Music
//; - $3000-833f Code+Data
//; - $c000-dfff Bitmap
//; - $e000-e3ff Screen
//; ---- $eb00-f3ff Sprites (frame 0)
//; ---- $f400-fdff Sprites (frame 1)
//; - $c000-df3f Bitmap

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var ScreenBank = 8 //; Bank+[2000,23ff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D016_Value_38Rows = $10
	.var D016_Value_40Rows = $18

	.var SpriteCircleBaseSprite0 = 172
	.var SpriteCircleBaseSprite1 = 208
	.var CircleSpriteWriteAddress0 = Base_BankAddress + (SpriteCircleBaseSprite0 * 64)
	.var CircleSpriteWriteAddress1 = Base_BankAddress + (SpriteCircleBaseSprite1 * 64)

	.var SB_NUMFramesPerChar = 2

	.var ZP_ScrollText = $20
	.var ZP_Jump0 = $1a
	.var ZP_Jump1 = $1d

	.var FirstFadeSpriteValue = ($2400 / 64)
	.var NumFadeSprites = 28

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

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
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $ff									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $ff									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $03									//; D020: VIC_BorderColour
	.byte $03									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $03									//; D027: VIC_Sprite0Colour
	.byte $03									//; D028: VIC_Sprite1Colour
	.byte $03									//; D029: VIC_Sprite2Colour
	.byte $03									//; D02A: VIC_Sprite3Colour
	.byte $03									//; D02B: VIC_Sprite4Colour
	.byte $03									//; D02C: VIC_Sprite5Colour
	.byte $03									//; D02D: VIC_Sprite6Colour
	.byte $03									//; D02E: VIC_Sprite7Colour

	SB_InvertedFrameCounter:
		.byte $00
	SB_ShouldAdvanceCircleText:
		.byte $00
	XSpriteCircleMovement:
		.byte $40
	XDiskLogoMovementBytes:
		.byte $00
	XDiskLogoMovementBits:
		.byte $00
	SpriteMSBValue:
		.byte $00
	SB_ScrollTextRead_Temp_Store:
		.byte $00
		
	ScrollText:
		.import binary "..\..\..\..\Intermediate\Built\SpriteBobs\ScrollText.bin"

	DrawSpriteJumpTable_Lo:
		.byte <DrawSprites_Frame1, <DrawSprites_Frame0
	DrawSpriteJumpTable_Hi:
		.byte >DrawSprites_Frame1, >DrawSprites_Frame0

	SB_MulByFrameCount:
		.fill 16, (i * SB_NUMFramesPerChar)
	
.macro SB_NextIRQ(IRQLine, Stage)
{
		.if(Stage == 0) //; First
		{
			lda #IRQLine
			sta VIC_D012

			lda #<ZP_Jump0
			sta $fffe

			lda #$01
			sta VIC_D01A
		}
		.if(Stage == 1) //; Middle - no need to set fffe/ffff
		{
			lda #IRQLine
			sta VIC_D012
		}
		.if(Stage == 2) //; last
		{
			lda #$03
			sta VIC_ScreenColour

			lda Signal_CustomSignal0
			beq DoBorderOpening
			ldx Signal_CustomSignal0
			inx
			stx Signal_CustomSignal0
			cpx #4
			bne SkipBorderOpening
			jmp SB_StartFadeOut

		DoBorderOpening:
			lda #$f8
		WaitForF8:
			cmp VIC_D012
			bne WaitForF8
		
			lda #$30
			sta VIC_D011

		SkipBorderOpening:
			lda VIC_D011
			bpl SkipBorderOpening

			lda #$98
			sta VIC_D011

			lda #$20
			sta VIC_D012

			lda #<ZP_Jump1
			sta $fffe

			lda #$01
			sta VIC_D01A
		}

		:IRQManager_EndIRQ()
		rti
}

SB_StartFadeOut:

	FADEWaitForVB:
		lda VIC_D011
		bpl FADEWaitForVB

		lda #DEX
		sta FadeINXorDEX
		lda #(FirstFadeSpriteValue + NumFadeSprites - 1)
		sta FadeSpriteValue + 1
		lda #(FirstFadeSpriteValue - 1)
		sta FadeEndValue + 1
		lda #LDA_IMM
		sta FadeBEQorLDA

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		lda #$00
		sta VIC_ScreenColour

		lda #<SB_IRQ_FadeIn_Line0
		sta.zp ZP_Jump1 + 1
		lda #>SB_IRQ_FadeIn_Line0
		sta.zp ZP_Jump1 + 2
		lda #<SB_IRQ_FadeIn_LineN
		sta.zp ZP_Jump0 + 1
		lda #>SB_IRQ_FadeIn_LineN
		sta.zp ZP_Jump0 + 2

		lda #<ZP_Jump1
		sta $fffe

		lda VIC_D011
		and #$07
		ora #$30
		sta VIC_D011
		lda #$00
		sta VIC_D012
		
		lda #$01
		sta VIC_D01A

		:IRQManager_EndIRQ()
		rti


//; SB_Init() -------------------------------------------------------------------------------------------------------
SB_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		//; clear out the initial sprite data
		lda #<CircleSpriteWriteAddress0
		sta ClearSpritesLoop0+1
		sta ClearSpritesLoop1+1
		lda #>CircleSpriteWriteAddress0
		sta ClearSpritesLoop0+2
		lda #>CircleSpriteWriteAddress1
		sta ClearSpritesLoop1+2

		ldx #((40 * 64) / 256)
		ldy #$00
	ClearSpritesLoop:
		lda #$00
	ClearSpritesLoop0:
		sta $0000, y
	ClearSpritesLoop1:
		sta $0000, y
		iny
		bne ClearSpritesLoop0
		inc ClearSpritesLoop0+2
		inc ClearSpritesLoop1+2
		dex
		bne ClearSpritesLoop

		lda #JMP_ABS
		sta.zp ZP_Jump1 + 0
		lda #<SB_IRQ_FadeIn_Line0
		sta.zp ZP_Jump1 + 1
		lda #>SB_IRQ_FadeIn_Line0
		sta.zp ZP_Jump1 + 2

		lda #JMP_ABS
		sta.zp ZP_Jump0 + 0
		lda #<SB_IRQ_FadeIn_LineN
		sta.zp ZP_Jump0 + 1
		lda #>SB_IRQ_FadeIn_LineN
		sta.zp ZP_Jump0 + 2
		
		MACRO_SetVICBank(BaseBank)

		lda #$00
		tay
	SB_ClearScrollTextZP:
		sta ZP_ScrollText, y
		iny
		cpy #212
		bne SB_ClearScrollTextZP

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$00
		sta VIC_D012
		lda #<ZP_Jump0
		sta $fffe
		lda #$00
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli
		rts

SB_PrevColourIndex:
	.byte $00
	.fill 8, i
SB_SpriteColours:
	.byte $0b
	.byte $06, $0c, $0e, $04, $0f, $03, $07, $01

//; SB_IRQ_FadeIn_Line0() -------------------------------------------------------------------------------------------------------
SB_IRQ_FadeIn_Line0:
		:IRQManager_BeginIRQ(0, 0)

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

		inc Signal_VBlank
	
		lda #$38			//; Should be 38 .. but I get black lines on last frame :-(
		sta VIC_D011
		lda #$00
		sta VIC_ScreenColour

		jsr BASECODE_PlayMusic

	FadeSpriteValue:
		ldx #FirstFadeSpriteValue
		stx Bank_SpriteVals + 0
		stx Bank_SpriteVals + 1
		stx Bank_SpriteVals + 2
		stx Bank_SpriteVals + 3
		stx Bank_SpriteVals + 4
		stx Bank_SpriteVals + 5
		stx Bank_SpriteVals + 6

		lda #$7f
		sta VIC_SpriteEnable

		lda FrameOf256
		and #$01
		bne DontAdvanceFade
	FadeINXorDEX:
		inx
		stx FadeSpriteValue + 1
	FadeEndValue:
		cpx #(FirstFadeSpriteValue + NumFadeSprites)
		bne NotFinishedFade

	FadeBEQorLDA:
		beq FinishedFade
		inc Signal_CurrentEffectIsFinished
		lda #$00
		sta VIC_D011
		jmp FinishedIRQ0

	FinishedFade:
		lda #$00
		sta VIC_SpriteEnable

		lda #$60
	WaitForFC:
		cmp VIC_D012
		bne WaitForFC

		lda #$10
		sta VIC_D012
		lda #$30
		sta VIC_D011
		sta VIC_D011
		lda #<SB_Multiplex
		sta.zp ZP_Jump0 + 1
		lda #>SB_Multiplex
		sta.zp ZP_Jump0 + 2
		lda #<SB_IRQ_VBlank
		sta.zp ZP_Jump1 + 1
		lda #>SB_IRQ_VBlank
		sta.zp ZP_Jump1 + 2
		lda #<ZP_Jump1
		sta $fffe
		jmp FinishedIRQ0
	NotFinishedFade:

	DontAdvanceFade:
		ldx #$07
		ldy #$0e
	SpriteLine0Loop:
		lda #$32
		sta VIC_Sprite0Y, y
		dey
		dey
		bpl SpriteLine0Loop

		clc
		adc #$04
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<ZP_Jump0
		sta $fffe
	FinishedIRQ0:
		lda #$01
		sta VIC_D01A
		:IRQManager_EndIRQ()
		rti

//; SB_IRQ_FadeIn_Line0() -------------------------------------------------------------------------------------------------------
SB_IRQ_FadeIn_LineN:
		:IRQManager_BeginIRQ(0, 0)

		ldx #$07
		ldy #$0e
		lda VIC_Sprite0Y
		clc
		adc #42
	SpriteLineNLoop:
		sta VIC_Sprite0Y, y
		dey
		dey
		bpl SpriteLineNLoop

	LineIndex:
		ldx #0
		inx
		cpx #4
		bne NotLastLine
		lda #<ZP_Jump1
		sta $fffe

		lda #00
		tax
		jmp IsLastLine

	NotLastLine:
		lda #<ZP_Jump0
		sta $fffe

		lda VIC_Sprite0Y
		clc
		adc #$04

	IsLastLine:
		stx LineIndex + 1
		sta VIC_D012
		lda VIC_D011
		and #$77
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		:IRQManager_EndIRQ()
		rti

//; SB_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SB_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		lda #$38
		sta VIC_D011
		
		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight

		jsr BASECODE_PlayMusic

		lda #$ff
 		sta VIC_SpriteEnable

		lda #$0b
		ldx #7
	SetSpriteColourLoop:
		sta VIC_Sprite0Colour, x
		dex
		bpl SetSpriteColourLoop

		inc FrameOf256

		lda SB_InvertedFrameCounter
		sec
	SB_ScrollSpeed:
		sbc #$01
		and #$01
		sta SB_InvertedFrameCounter
		beq XSpriteMover

		inc SB_ShouldAdvanceCircleText

	XSpriteMover:
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		lda #$00
		sta SB_Multiplex_Index + 1
		jmp SB_Multiplex_Index

//; SB_Draw() -------------------------------------------------------------------------------------------------------
SB_Draw:

	NormalDraw:
		ldy SB_InvertedFrameCounter
		lda DrawSpriteJumpTable_Lo, y
		sta Sprite_SelfModifiedJump+1
		lda DrawSpriteJumpTable_Hi, y
		sta Sprite_SelfModifiedJump+2
	Sprite_SelfModifiedJump:
		jsr $ffff

		lda SB_ShouldAdvanceCircleText
		bne SB_AdvanceCircleText
	JustReturn:
		rts

	SB_AdvanceCircleText:
		lda #$00
		sta SB_ShouldAdvanceCircleText
		jmp AdvanceCircleText

//; SB_Multiplex() -------------------------------------------------------------------------------------------------------
SB_Multiplex:

		:IRQManager_BeginIRQ(0, 0)

	SB_Multiplex_Index:
		ldx #$01
		lda SB_MulByFrameCount, x
		clc
		adc SB_InvertedFrameCounter
		tay
		lda SpriteMultiplexJumpTable_Lo, y
		sta SpriteMultiplex_SelfModifiedJump+1
		lda SpriteMultiplexJumpTable_Hi, y
		sta SpriteMultiplex_SelfModifiedJump+2
		inc SB_Multiplex_Index + 1
	SpriteMultiplex_SelfModifiedJump:
		jmp $FFFF


SpriteBobsMultiplexASM:
		.import source "..\..\..\..\Intermediate\Built\SpriteBobs\Multiplex.asm"
ScrollTextUpdateASM:
		.import source "..\..\..\..\Intermediate\Built\SpriteBobs\ScrollTextUpdate.asm"
DrawASM:
		.import source "..\..\..\..\Intermediate\Built\SpriteBobs\Draw-Frame0.asm"
		.import source "..\..\..\..\Intermediate\Built\SpriteBobs\Draw-Frame1.asm"
SpriteBobsFontsDataASM:
		.import source "..\..\..\..\Intermediate\Built\SpriteBobs\FontsData.asm"
