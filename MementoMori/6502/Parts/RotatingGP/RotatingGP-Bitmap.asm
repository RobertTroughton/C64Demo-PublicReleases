//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= RotatingGPBitmap_BASE
		jmp RotatingGPBitmap_Init
		jmp RotatingGPBitmap_Init_OnlyInitIRQ

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $c000-df3f Bitmap MAP
//; - $e000-e3e7 Bitmap COL (load address, ready for fades)
//; - $e400-e7e7 Bitmap SCR (load address, ready for fades)
//; - $e800-ebff FramesDarker fade data
//; - $ec00-efff Bitmap Screen

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; $0000-1f3f
	.var ScreenBank = 14 //; Bank+[3800,3bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_38Columns = $17
	.var D016_Value_40Columns = $18

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var COLData = $e000
	.var SCRData = $e400
	.var FramesDarker = $e800
	.var FramesDarker1 = FramesDarker + (256 * 0)
	.var FramesDarker2 = FramesDarker + (256 * 1)
	.var FramesDarker3 = FramesDarker + (256 * 2)
	.var FramesDarker4 = FramesDarker + (256 * 3)

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
	.byte D016_Value_40Columns					//; D016: VIC_D016
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


//; RotatingGPBitmap_Init() -------------------------------------------------------------------------------------------------------
RotatingGPBitmap_Init:

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		ldy #$00
		lda #$00
	FillScreenColourMemory:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta ScreenAddress + (Page * 256), y
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillScreenColourMemory

	RotatingGPBitmap_Init_OnlyInitIRQ:
		jsr BASECODE_ClearGlobalVariables

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda #D011_Value_25Rows
		sta VIC_D011
		lda #<RotatingGPBitmap_FadeIRQ
		sta $fffe
		lda #>RotatingGPBitmap_FadeIRQ
		sta $ffff
		lda #238
		sta VIC_D012
		asl VIC_D019

		cli
		rts

RotatingGPBitmap_FadeIRQ:

		:IRQManager_BeginIRQ(0, 0)

		jsr BASECODE_PlayMusic

		lda Signal_CurrentEffectIsFinished
		bne SkipFade

	FrameValue:
		ldy #39
		jsr RotatingGPBitmap_Fade_BASE

		dec FrameValue + 1
		lda FrameValue + 1
		cmp #$fc
		bne SkipFade
		inc Signal_CurrentEffectIsFinished
	SkipFade:

		:IRQManager_EndIRQ()
		rti

