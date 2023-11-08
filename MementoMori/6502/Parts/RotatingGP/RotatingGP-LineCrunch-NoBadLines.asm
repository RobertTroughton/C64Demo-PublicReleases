//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= RotatingGP_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp RotatingGP_Init							//; Init
		.byte $00, $00, $00							//; MainThreadFunc
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

//; - $4000-58bf Bitmap 0B + data interspersed (however many lines this is?)
//; - $58c0-5fbf Sprite data
//; - $5ff8-5fff SpriteVal Info
//; - $6000-7fff Bitmap 0A + data interspersed

//; - $8000-bfff Code

//; - $c000-c8bf Bitmap 1B + data interspersed (however many lines this is?)
//; - $c8c0-cfbf Sprite data
//; - $cff8-cfff SpriteVal Info <-- could go under $d000 surely..?
//; - $e000-ffff Bitmap 1A + data interspersed

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_38Rows = $17
	.var D016_Value_40Rows = $18

	.var D018Value = (ScreenBank * 16) //; + (CharBank * 2)

	.var RotatingLogoColour = $01

	.var BlitDataAddress = $4f00
	.var SinTableAddress = $be00
	.var XPosSinTableAddress = $bc00

	.var FirstSpriteValue = $00

	.var SpriteMem = Base_BankAddress + (FirstSpriteValue * 64)

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $40									//; D000: VIC_Sprite0X
	.byte $31									//; D001: VIC_Sprite0Y
	.byte $58									//; D002: VIC_Sprite1X
	.byte $31									//; D003: VIC_Sprite1Y
	.byte $70									//; D004: VIC_Sprite2X
	.byte $31									//; D005: VIC_Sprite2Y
	.byte $88									//; D006: VIC_Sprite3X
	.byte $31									//; D007: VIC_Sprite3Y
	.byte $a0									//; D008: VIC_Sprite4X
	.byte $31									//; D009: VIC_Sprite4Y
	.byte $b8									//; D00a: VIC_Sprite5X
	.byte $31									//; D00b: VIC_Sprite5Y
	.byte $d0									//; D00c: VIC_Sprite6X
	.byte $31									//; D00d: VIC_Sprite6Y
	.byte $e8									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $7f									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $7f									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $06									//; D021: VIC_ScreenColour
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

//; RotatingGP_Init() -------------------------------------------------------------------------------------------------------
RotatingGP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

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

		lda #$00
		sta VIC_BorderColour

		lda #D011_Value_25Rows
		sta VIC_D011
		lda #41
		sta VIC_D012
		lda #<BordersIRQ
		sta $fffe
		lda #>BordersIRQ
		sta $ffff
		asl VIC_D019

		cli

		rts

BordersIRQ:

		:IRQManager_BeginIRQ(1, 0)

		ldy #$18

		.for (var Delay = 0; Delay < 211; Delay++)
		{
			nop
		}
		
		ldx #$38
		asl VIC_D016
		stx VIC_D011
		sty VIC_D016

		.for (var Delay = 0; Delay < 99; Delay++)
		{
			nop
		}

		ldx #$3f
		asl VIC_D016
		stx VIC_D011
		sty VIC_D016

		.for (var Delay = 0; Delay < 16; Delay++)
		{
			nop
		}

		.for (var CharLine = 0; CharLine < 10; CharLine++)
		{
			.for (var LineIndex = 0; LineIndex < 8; LineIndex++)
			{
				.if (LineIndex == 0)
				{
					ldx #$38
				}
				else
				{
					inx
				}
				asl VIC_D016
				stx VIC_D011
				sty VIC_D016

				.var DelayLen = 16
				.if (CharLine == 1)
				{
					.if (LineIndex == 0)
					{
						lda #$5b
						sta $d001
						sta $d003
						sta $d005
						.eval DelayLen -= 7
					}
					.if (LineIndex == 1)
					{
						sta $d007
						sta $d009
						sta $d00b
						sta $d00d
						.eval DelayLen -= 8
					}
				}

				.if ((CharLine == 2) && (LineIndex == 6))
				{
					lda #(ScreenBank * 16) + (0 * 8)
					sta VIC_D018
					.eval DelayLen -= 3
				}
				.for (var Delay = 0; Delay < DelayLen; Delay++)
				{
					nop
				}
			}
		}

		lda #$ff
	WaitForF9:
		cmp VIC_D012
		bne WaitForF9
		lda #$78
		sta VIC_D011
		lda #$18
		sta VIC_D016
		lda #(ScreenBank * 16) + (1 * 8)
		sta VIC_D018

		lda #$31
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d

		jsr BASECODE_PlayMusic

		:IRQManager_EndIRQ()
		rti
