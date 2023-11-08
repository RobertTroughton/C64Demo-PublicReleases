//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= HorseMenPic_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp HorseMenPic_Init						//; Init
		jmp HorseMenPic_StartFadeOut				//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
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
//; - $4f00-bbff Data
//; - $c000-df3f Bitmap MAP
//; - $f800-fbff Bitmap Screen
//; - $fc00-fdff XPos Sintable

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; $0000-1f3f
	.var ScreenBank = 7 //; Bank+[1c00,1fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * 8192))
	.var SpriteVals = ScreenAddress + $3f8

	.var D011Value = $3b
	.var D016Value = $18
	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var Sprite_DitherFadeIn_Index = $1b40 / 64
	.var Sprite_DitherFadeIn_Address = Base_BankAddress + $1b40
	.var Sprite_DitherFadeOut_Index = $1b80 / 64
	.var Sprite_DitherFadeOut_Address = Base_BankAddress + $1b80
	.var Sprite_AllBlack_Index = $1bc0 / 64
	.var Sprite_AllBlack_Address = Base_BankAddress + $1bc0

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $00									//; D000: VIC_Sprite0X
	.byte $32									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $32									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $32									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $32									//; D007: VIC_Sprite3Y
	.byte $00									//; D008: VIC_Sprite4X
	.byte $32									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $32									//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte $32									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $32									//; D00f: VIC_Sprite7Y
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
	.byte D000_SkipValue						//; D021: VIC_ScreenColour
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

Sprite_DitherFadeIn_Data:
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $88, $aa, $ee
	.byte $00

Sprite_DitherFadeOut_Data:
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $77, $55, $11
	.byte $00

	.fill 64, 96
SpriteXVals_FadeOut:
	.byte $e0, $e8, $f0
	.fill 32, i * 8
	.fill 12, i * 8

	.fill 64, 96	//; shared between fade out and fade in...

SpriteXVals_FadeIn:
	.fill 32, i * 8
	.fill 12, i * 8

	.fill 64, 96	//; shared between fade out and fade in...

SpriteMSBVals_FadeIn:
	.fill 5, $c0
	.fill 6, $e0
	.fill 6, $f0
	.fill 6, $f8
	.fill 6, $fc
	.fill 3, $fe
	.fill 12, $ff

SpriteMSBVals_FadeOut:
	.fill 3, $ff	//;
	.fill 6, $7f	//; $000-02f
	.fill 6, $3f	//; $030-05f
	.fill 6, $1f	//; $060-08f
	.fill 6, $0f	//; $090-0bf
	.fill 6, $07	//; $0c0-0ef
	.fill 2, $03	//; $0f0-0ff
	.fill 4, $83	//; $100-11f
	.fill 2, $81	//; $120-12f
	.fill 4, $c1	//; $130-14f
	.fill 2, $c0	//; $150-15f
	.fill 6, $e0	//; $160-18f* (clamped to $160)
	.fill 6, $f0	//; $190-1bf*
	.fill 6, $f8	//; $1c0-1ef
	.fill 6, $fc	//; 
	.fill 6, $fe	//; 
	.fill 6, $ff	//; 

//; HorseMenPic_Init() -------------------------------------------------------------------------------------------------------
HorseMenPic_Init:

		sta VIC_ScreenColour

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		dec $01

		ldy #62
	FillSpriteDataLoop:
		lda #$ff
		sta Sprite_AllBlack_Address, y
		lda Sprite_DitherFadeOut_Data, y
		sta Sprite_DitherFadeOut_Address, y
		lda Sprite_DitherFadeIn_Data, y
		sta Sprite_DitherFadeIn_Address, y
		dey
		bpl FillSpriteDataLoop

		lda #Sprite_DitherFadeIn_Index
		sta SpriteVals + 0

		lda #Sprite_AllBlack_Index
		.for (var SpriteIndex = 1; SpriteIndex < 8; SpriteIndex++)
		{
			sta SpriteVals + SpriteIndex
		}

		inc $01

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda #<HorseMenIRQ
		sta $fffe
		lda #>HorseMenIRQ
		sta $ffff
		lda #$fa
		sta VIC_D012
		asl VIC_D019

		lda #$00
		sta FadeInColumn + 1
		sta FadeOutColumn + 1
		sta Signal_CurrentEffectIsFinished

		//; FadeIn
		lda #$01
		sta FadeMode + 1

		cli

		rts

HorseMenPic_StartFadeOut:
		lda #$02
		sta FadeMode + 1

		dec $01

		lda #Sprite_AllBlack_Index
		.for (var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta SpriteVals + SpriteIndex
		}

		lda #Sprite_DitherFadeOut_Index
		sta SpriteVals + 7

		inc $01

		rts

HorseMenIRQ:

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
		cmp #2
		beq DoFadeOut
	DoFadeIn:
		jsr FadeInFrame
		jmp NextSpriteRow

	DoFadeOut:
		jsr FadeOutFrame

	NextSpriteRow:

		lda #$33
		sta VIC_D012

		lda #$00
		sta SpriteRow + 1

		lda #<SpriteRowIRQ
		sta $fffe
		lda #>SpriteRowIRQ
		sta $ffff

	ReturnFromIRQ:

		lda #$3b
		sta VIC_D011

		asl VIC_D019

		pla
		tay
		pla
		tax
		pla

		inc $00

		rti

FadeOutFrame:
		jsr SetupSpritesFirstRow

	FadeOutColumn:
		ldx #$00
		
		lda SpriteXVals_FadeOut + 4 - (6 * 0), x
		sta VIC_Sprite7X
		lda SpriteXVals_FadeOut + 4 - (6 * 1), x
		sta VIC_Sprite6X
		lda SpriteXVals_FadeOut + 4 - (6 * 2), x
		sta VIC_Sprite5X
		lda SpriteXVals_FadeOut + 4 - (6 * 3), x
		sta VIC_Sprite4X
		lda SpriteXVals_FadeOut + 4 - (6 * 4), x
		sta VIC_Sprite3X
		lda SpriteXVals_FadeOut + 4 - (6 * 5), x
		sta VIC_Sprite2X
		lda SpriteXVals_FadeOut + 4 - (6 * 6), x
		sta VIC_Sprite1X
		lda SpriteXVals_FadeOut + 4 - (6 * 7), x
		sta VIC_Sprite0X
		lda SpriteMSBVals_FadeOut + 4, x
		sta VIC_SpriteXMSB

		lda #$7f
		sta VIC_SpriteDoubleWidth

		cpx #(40 + 4)
		bcc StillFadingOut

		lda #$01
		sta Signal_CurrentEffectIsFinished
		rts

	StillFadingOut:
		inc FadeOutColumn + 1
		rts

FadeInFrame:
		jsr SetupSpritesFirstRow

	FadeInColumn:
		ldx #$00
		
		lda SpriteXVals_FadeIn + 0, x
		sta VIC_Sprite0X
		lda SpriteXVals_FadeIn + 3, x
		sta VIC_Sprite1X
		lda SpriteXVals_FadeIn + 9, x
		sta VIC_Sprite2X
		lda SpriteXVals_FadeIn + 15, x
		sta VIC_Sprite3X
		lda SpriteXVals_FadeIn + 21, x
		sta VIC_Sprite4X
		lda SpriteXVals_FadeIn + 27, x
		sta VIC_Sprite5X
		lda SpriteXVals_FadeIn + 33, x
		sta VIC_Sprite6X
		lda SpriteXVals_FadeIn + 39, x
		sta VIC_Sprite7X
		lda SpriteMSBVals_FadeIn, x
		sta VIC_SpriteXMSB

		lda #$fe
		sta VIC_SpriteDoubleWidth

		cpx #(40 + 4)
		bcc StillFadingIn

		lda #$00
		sta FadeMode + 1

		rts

	StillFadingIn:
		inc FadeInColumn + 1
		rts

SetupSpritesFirstRow:

		lda #$32
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y
		lda #$ff
		sta VIC_SpriteEnable
		rts

SpriteRowIRQ:

		pha
		txa
		pha
		tya
		pha

		dec $00

		ldy #$0e
		lda VIC_Sprite0Y, y
		clc
		adc #21
	SetSpriteYPosBLoop:
		sta VIC_Sprite0Y, y
		dey
		dey
		bpl SetSpriteYPosBLoop

	SpriteRow:
		ldx #$00
		inx
		stx SpriteRow + 1
		cpx #9
		bne NotFinishedSpriteRows

		lda #$fa
		sta VIC_D012
		lda #<HorseMenIRQ
		sta $fffe
		lda #>HorseMenIRQ
		sta $ffff
		jmp ReturnFromIRQ

	NotFinishedSpriteRows:
		ldx VIC_Sprite0Y
		inx
		stx VIC_D012
		jmp ReturnFromIRQ




