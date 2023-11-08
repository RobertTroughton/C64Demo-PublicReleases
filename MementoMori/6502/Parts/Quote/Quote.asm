//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= Quote_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		jmp Quote_Init
		jmp Quote_StartFadeOut
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $8c00-8fff Bitmap Screen
//; - $9000-9fff Code
//; - $a000-bf3f Bitmap MAP

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var CharBank = 4 //; $2000-27ff
	.var ScreenBank = 10 //; Bank+[2800,2bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var SpriteVals = ScreenAddress + $3f8

	.var D011Value = $1b
	.var D016Value = $08
	.var D018Value = (ScreenBank * 16) + (CharBank * 2)

	.var Sprite_DitherFadeIn_Index = $0b40 / 64
	.var Sprite_DitherFadeIn_Address = Base_BankAddress + $0b40
	.var Sprite_DitherFadeOut_Index = $0b80 / 64
	.var Sprite_DitherFadeOut_Address = Base_BankAddress + $0b80
	.var Sprite_AllBlack_Index = $0bc0 / 64
	.var Sprite_AllBlack_Address = Base_BankAddress + $0bc0

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
	.byte D016Value								//; D016: VIC_D016
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

FadeOutColours:
		.byte $0d, $0f, $01, $0f, $0d, $0e, $05, $06, $09, $0b, $00

FadeInColours:
		.byte $0b, $09, $06, $05, $0e, $0d, $0f, $01, $0f, $0d, $0c, $ff

//; Quote_Init() -------------------------------------------------------------------------------------------------------
Quote_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		ldy #$00
		lda #$00
	FillColourLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillColourLoop

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda #<QuoteIRQ
		sta $fffe
		lda #>QuoteIRQ
		sta $ffff
		lda #$fa
		sta VIC_D012
		asl VIC_D019

		lda #$00
		sta Signal_CurrentEffectIsFinished

		//; FadeIn
		lda #$01
		sta FadeMode + 1

		cli

		rts

//; Quote_StartFadeOut() -------------------------------------------------------------------------------------------------------
Quote_StartFadeOut:
		lda #$02
		sta FadeMode + 1
		rts

//; QuoteIRQ() -------------------------------------------------------------------------------------------------------
QuoteIRQ:

		pha
		txa
		pha
		tya
		pha

		dec $00

		jsr BASECODE_PlayMusic

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

	FadeMode:
		lda #$00
		bne DoFade
		lda #$00
		sta VIC_SpriteEnable
		jmp ReturnFromIRQ

	DoFade:
		cmp #1
		beq DoFadeIn

	DoFadeOut:
		ldx #$00
		lda FadeOutColours, x
		sta VIC_ScreenColour
		bne StillFadingOut
		inc Signal_CurrentEffectIsFinished
	StillFadingOut:
		inc DoFadeOut + 1
		jmp ReturnFromIRQ

	DoFadeIn:
		ldx #$00
		lda FadeInColours, x
		bpl StillFadingIn
		lda #$00
		sta FadeMode + 1
		beq ReturnFromIRQ
	StillFadingIn:
		sta VIC_ScreenColour
		inc DoFadeIn + 1

	ReturnFromIRQ:
		lda #D011Value
		sta VIC_D011

		asl VIC_D019

		inc $00

		pla
		tay
		pla
		tax
		pla

		rti
