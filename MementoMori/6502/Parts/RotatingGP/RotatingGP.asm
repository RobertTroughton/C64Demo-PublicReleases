//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= RotatingGP_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00								//; Pre-Init
		jmp RotatingGP_Init								//; Init
		jmp RotatingGP_Blit								//; MainThreadFunc
		jmp RotatingGP_Finished							//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $2000-4eff Code
//; - $5000-bfff Data
//; - $c000-df3f Bitmap MAP
//; - $e000-f3ff Sprite Data
//; - $f400-f7ff XPos Sintable
//; - $f800-fbff Bitmap Screen

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; $0000-1f3f
	.var ScreenBank = 14 //; Bank+[3800,3bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_38Rows = $17
	.var D016_Value_40Rows = $18

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var RotatingLogoColour = $01

	.var BlitDataAddress = $5000
	.var XPosSinTableAddress = $f400

	.var FirstSpriteValue = $80

	.var SpriteMem = Base_BankAddress + (FirstSpriteValue * 64)

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $40									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $58									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $70									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $88									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $a0									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $b8									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $d0									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $e8									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $ff									//; D015: VIC_SpriteEnable
	.byte D000_SkipValue						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D000_SkipValue						//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte D000_SkipValue						//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte RotatingLogoColour					//; D027: VIC_Sprite0Colour
	.byte RotatingLogoColour					//; D028: VIC_Sprite1Colour
	.byte RotatingLogoColour					//; D029: VIC_Sprite2Colour
	.byte RotatingLogoColour					//; D02A: VIC_Sprite3Colour
	.byte RotatingLogoColour					//; D02B: VIC_Sprite4Colour
	.byte RotatingLogoColour					//; D02C: VIC_Sprite5Colour
	.byte RotatingLogoColour					//; D02D: VIC_Sprite6Colour
	.byte RotatingLogoColour					//; D02E: VIC_Sprite7Colour

C000FillBytes:
	.fill 8, $00
	.byte $b0, $58, $2c, $16, $0b, $85, $c2, $61

AnimTable:
	.fill 16, i
	.byte 15
	.fill 14, (14 - i)
	.byte 0

NextFrame:
	.fill 32, i
	.fill 32, i

SlideMode:
	.byte $01

.import source "../../../Out/6502/Parts/RotatingGP/DrawSprite.asm"

//; RotatingGP_Init() -------------------------------------------------------------------------------------------------------
RotatingGP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		ldy #$00
		lda #FirstSpriteValue
	SetSpriteValsLoop:
		sta SpriteVals, y
		clc
		adc #$01
		iny
		cpy #$08
		bne SetSpriteValsLoop

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #D011_Value_25Rows
		sta VIC_D011
		lda Row_D012Vals + 0
		sta VIC_D012
		lda #<RotatingGP_MainIRQ
		sta $fffe
		lda #>RotatingGP_MainIRQ
		sta $ffff
		asl VIC_D019

		cli

		rts


RotatingGP_Finished:

		jsr BASECODE_SetDefaultIRQ
		lda #$00
		sta VIC_SpriteEnable
		rts
			


Row_D012Vals:
		.byte $00
		.fill 1, $3a + (20 * (i + 1)) - 1
		.fill 8, $3a + (20 * (i + 2)) - 2
Row_SpriteYVals:
		.fill 10, $3a + (21 * i)
Row_SpriteVals:
		.fill 10, FirstSpriteValue + (8 * i) + 4

RotatingGP_MainIRQ:
		:IRQManager_BeginIRQ(0, 0)

	RotatingGP_SpriteLayerIndex:
		ldy #$00
		bne NotZero

		lda #$ff
		sta VIC_SpriteEnable

	NotZero:
		lda Row_SpriteYVals, y
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta VIC_Sprite0Y + (SpriteIndex * 2)
		}
		.for (var NOPs = 0; NOPs < 8; NOPs++)
		{
			nop
		}
		ldx Row_SpriteVals, y
		lda #$fb
		.for (var SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			sax SpriteVals + SpriteIndex
			stx SpriteVals + SpriteIndex + 4
			.if (SpriteIndex != 3)
			{
				inx
			}
		}

		cpy #0
		bne Not0

	XPosSinIndex:
		ldx #$00

		lda SlideMode
		cmp #$00
		beq XPos_Regular
		cmp #$02
		beq XPos_SlideOut

	XPos_SlideIn:
		cpx #$80
		bcc ContinueSlideIn
		dec SlideMode
		beq XPos_Regular
	ContinueSlideIn:
		lda XPosSinTableAddress + 512 + 128, x
		sta VIC_SpriteXMSB
		lda XPosSinTableAddress + 512 + 0, x
		jmp DoSpriteXSinValues

	XPos_SlideOut:
		cpx #$80
		bcc ContinueSlideOut
		inc Signal_CurrentEffectIsFinished
		ldx #$7f
	ContinueSlideOut:
		lda XPosSinTableAddress + 768 + 128, x
		sta VIC_SpriteXMSB
		lda XPosSinTableAddress + 768 + 0, x
		jmp DoSpriteXSinValues

	XPos_Regular:
		lda XPosSinTableAddress + 256, x
		sta VIC_SpriteXMSB
		lda XPosSinTableAddress + 0, x
	DoSpriteXSinValues:
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta VIC_Sprite0X + (SpriteIndex * 2)
			.if (SpriteIndex != 7)
			{
				clc
				adc #$18
			}
		}
		inx
		stx XPosSinIndex + 1

	Not0:
		iny
		cpy #10
		bne Not10

		inc Signal_CustomSignal0

		lda #$f0
	WaitMore:
		cmp VIC_D012
		bcs WaitMore
		lda #$00
		sta VIC_SpriteEnable

		jsr BASECODE_PlayMusic

		inc FrameOf256
		bne Not256
		inc Frame_256Counter

		lda Frame_256Counter
		cmp #2
		bne Not256

		lda #$02
		sta SlideMode
	Not256:

		ldy #$00

	Not10:
		sty RotatingGP_SpriteLayerIndex + 1

		lda Row_D012Vals, y
		sta VIC_D012
		
		:IRQManager_EndIRQ()
		rti

RotatingGP_Blit:
		dec Signal_CustomSignal0

	LogoIndex:
		lda #$00
		eor #$01
		sta LogoIndex + 1
		bne DoLogo1

	DoLogo0:
		ldx #$00

		ldy NextFrame + 1, x
		sty DoLogo0 + 1

		ldx AnimTable, y
		jmp BlitRotatingGP0

	DoLogo1:
		ldx #8

		ldy NextFrame + 32 - 1, x
		sty DoLogo1 + 1

		ldx AnimTable, y
	BlitJump1:
		jmp BlitRotatingGP1

