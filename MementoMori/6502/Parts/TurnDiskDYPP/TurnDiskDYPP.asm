//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= TurnDiskDYPP_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp TurnDiskDYPP_Init						//; Init
		jmp WaitForDiskSwapAndStartFadeOut			//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $1000-29ff Music
//; - $2000-c3ff Code
//; - $4000-67ff Charset0
//; - $6800-6be7 Screen0
//; - $c000-e7ff Charset1
//; - $e800-ebe7 Screen1

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharBank1 = 1 //; Bank+[0800,0fff]
	.var CharBank2 = 2 //; Bank+[1000,17ff]
	.var CharBank3 = 3 //; Bank+[1800,1fff]
	.var CharBank4 = 4 //; Bank+[2000,27ff]
	.var ScreenBank0 = 10 //; Bank+[2800,2bff]
	.var ScreenBank1 = 11 //; Bank+[2c00,2fff]
	.var Bank0_ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var Bank0_ScreenAddress1 = (Base_BankAddress0 + (ScreenBank1 * 1024))
	.var Bank1_ScreenAddress0 = (Base_BankAddress1 + (ScreenBank0 * 1024))
	.var Bank1_ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var Bank0_SpriteVals0 = (Bank0_ScreenAddress0 + $3F8 + 0)
	.var Bank0_SpriteVals1 = (Bank0_ScreenAddress1 + $3F8 + 0)
	.var Bank1_SpriteVals0 = (Bank1_ScreenAddress0 + $3F8 + 0)
	.var Bank1_SpriteVals1 = (Bank1_ScreenAddress1 + $3F8 + 0)

	.var D011_Value_24Rows = $13
	.var D011_Value_25Rows = $1b

	.var D016_Value_38Rows = $07
	.var D016_Value_40Rows = $08

	.var D018ValueInit = ScreenBank0 * 16 + CharBank0 * 2

	.var ScreenAnimData = $9000

	.var TurnColourMain = $06
	.var TurnColourBar = $0e
	.var DiskColourMain = $02
	.var DiskColourBar = $0a

	.var FirstSpriteValue = $c0

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
	.byte $60									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018ValueInit							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $7f									//; D01B: VIC_SpriteDrawPriority
	.byte $7f									//; D01C: VIC_SpriteMulticolourMode
	.byte $7f									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte DiskColourMain						//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte DiskColourBar							//; D025: VIC_SpriteExtraColour0
	.byte TurnColourBar							//; D026: VIC_SpriteExtraColour1
	.byte TurnColourMain						//; D027: VIC_Sprite0Colour
	.byte TurnColourMain						//; D028: VIC_Sprite1Colour
	.byte TurnColourMain						//; D029: VIC_Sprite2Colour
	.byte TurnColourMain						//; D02A: VIC_Sprite3Colour
	.byte TurnColourMain						//; D02B: VIC_Sprite4Colour
	.byte TurnColourMain						//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

//; TurnDiskDYPP_Init() -------------------------------------------------------------------------------------------------------
TurnDiskDYPP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #$00
	FillScreenAndColourMemory:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta Bank0_ScreenAddress0 + (Page * 256), y
			sta Bank0_ScreenAddress1 + (Page * 256), y
			sta Bank1_ScreenAddress0 + (Page * 256), y
			sta Bank1_ScreenAddress1 + (Page * 256), y
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillScreenAndColourMemory

		jsr UpdateFrame

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
		sta VIC_D011
		lda #$fa
		sta VIC_D012
		lda #<TurnDiskDYPP_MusicIRQ
		sta $fffe
		lda #>TurnDiskDYPP_MusicIRQ
		sta $ffff
		asl VIC_D019

		cli

		rts

TurnDiskDYPP_MusicIRQ:
		:IRQManager_BeginIRQ(1, 0)

		jsr BASECODE_PlayMusic

		jsr SetSpriteColours

 		lda #$7f
		sta VIC_SpriteEnable

		jsr UpdateFrame

		lda #D011_Value_25Rows
		sta VIC_D011
		lda #$58
		sta VIC_D012
		lda #<TurnDiskDYPP_MainIRQ
		sta $fffe
		lda #>TurnDiskDYPP_MainIRQ
		sta $ffff

		:IRQManager_EndIRQ()
		rti

TurnDiskDYPP_MainIRQ:
		:IRQManager_BeginIRQ(1, 0)

		jsr MainIRQ

		lda #$fa
		sta VIC_D012
		lda #<TurnDiskDYPP_MusicIRQ
		sta $fffe
		lda #>TurnDiskDYPP_MusicIRQ
		sta $ffff

		:IRQManager_EndIRQ()
		rti

UpdateFrame:
	FadeInPtr:
		jsr DoFadeIn

	FrameIndex:
		ldy #$04
		jsr DrawLogo

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

	AnimDelay:
		lda #$00
		eor #$01
		sta AnimDelay + 1
		bne DontUpdateAnim

		ldy FrameIndex + 1
		iny
		cpy #30
		bne NotFinishedFrames
		ldy #$00
	NotFinishedFrames:
		sty FrameIndex + 1
		jmp StartFrameWithoutAdvance

	DontUpdateAnim:
		jmp StartFrame

.import source "../../../Out/6502/Parts/TurnDiskDYPP/drawlogo.asm"

DoFadeIn:
		lda FrameOf256
		and #$01
		beq FadeInValue
		rts

	FadeInValue:
		ldy #$00
		cpy #DrawLogo_NumLines
		beq FinishedFadeIn

		lda DrawLogo_LinePtrsLo + 0, y
		sta DrawLogoPointer0 + 1
		lda DrawLogo_LinePtrsHi + 0, y
		sta DrawLogoPointer0 + 2

		lda DrawLogo_LinePtrsLo + 1, y
		sta DrawLogoPointer1 + 1
		lda DrawLogo_LinePtrsHi + 1, y
		sta DrawLogoPointer1 + 2

		iny
		sty FadeInValue + 1

		lda #NOP
	DrawLogoPointer0:
		sta $abcd

		lda #RTS
	DrawLogoPointer1:
		sta $abcd

	FinishedFadeIn:
		rts

DoFadeOut:
		lda FrameOf256
		and #$01
		beq FadeOutValue
		rts

	FadeOutValue:
		ldy #DrawLogo_NumLines

		dey
		bpl NotFinishedFadeOut

		inc Signal_CurrentEffectIsFinished
		rts

	NotFinishedFadeOut:
		sty FadeOutValue + 1

		lda DrawLogo_LinePtrsLo + 0, y
		sta DrawLogoPointer2 + 1
		lda DrawLogo_LinePtrsHi + 0, y
		sta DrawLogoPointer2 + 2

		lda ClearLogo_LinePtrsLo + 0, y
		sta ClearLineJMP + 1
		lda ClearLogo_LinePtrsHi + 0, y
		sta ClearLineJMP + 2

		lda #RTS
	DrawLogoPointer2:
		sta $abcd

	ClearLineJMP:
		jmp $abcd

WaitForDiskSwapAndStartFadeOut:

		jsr IRQLoader_LoadNext //; Wait for disk turn

		lda #<DoFadeOut
		sta FadeInPtr + 1
		lda #>DoFadeOut
		sta FadeInPtr + 2

		lda #$00
		sta Signal_CurrentEffectIsFinished

	LoopUntilFadedOut:
		lda Signal_CurrentEffectIsFinished
		beq LoopUntilFadedOut

		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ

ColourPulsesMain:
		.byte $01, $07, $0a, $02
		.fill 24, $02
		.byte $02, $0a, $07, $01
		.byte $01, $03, $0e, $04
		.fill 24, $04
		.byte $04, $0e, $03, $01
		.byte $01, $0d, $05, $09
		.fill 24, $09
		.byte $09, $05, $0d, $01
		.byte $01, $03, $0e, $06
		.fill 24, $06
		.byte $06, $0e, $03, $01
		.byte $01, $0f, $0c, $0b
		.fill 24, $0b
		.byte $0b, $0c, $0f, $01

ColourPulsesBar:
		.byte $01, $01, $07, $0a
		.fill 24, $0a
		.byte $0a, $07, $01, $01
		.byte $01, $01, $07, $0f
		.fill 24, $0f
		.byte $0f, $0d, $01, $01
		.byte $01, $01, $0d, $05
		.fill 24, $05
		.byte $05, $0d, $01, $01
		.byte $01, $01, $03, $0e
		.fill 24, $0e
		.byte $0e, $03, $01, $01
		.byte $01, $01, $0f, $0c
		.fill 24, $0c
		.byte $0c, $0f, $01, $01

Mul32:
		.fill 5, i * 32
		.fill 5, i * 32

Add1Mod:
		.byte 1, 2, 3, 4, 0

SetSpriteColours:

	ColourSetIndex:
		ldy #$00
		lda FrameOf256
		and #$7f
		bne NotZero
		lda Add1Mod, y
		tay
		sty ColourSetIndex + 1
		
	NotZero:
		lsr
		lsr
		and #$1f
		ora Mul32, y
		tax

		lda ColourPulsesMain, x
		.for (var SpriteIndex = 0; SpriteIndex < 6; SpriteIndex++)
		{
			sta VIC_Sprite0Colour + SpriteIndex
		}
		lda ColourPulsesBar, x
		sta VIC_SpriteExtraColour1

	ColourSetIndex2:
		ldy #$02
		lda FrameOf256
		eor #$40
		and #$7f
		bne NotZero2
		lda Add1Mod, y
		tay
		sty ColourSetIndex2 + 1
		
	NotZero2:
		lsr
		lsr
		and #$1f
		ora Mul32, y
		tax

		lda ColourPulsesMain, x
		sta VIC_ScreenColour
		lda ColourPulsesBar, x
		sta VIC_SpriteExtraColour0

		rts

