//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "AllBorderDYPP-CommonDefines.asm"


*= AllBorderDYPP_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp AllBorderDYPP_Init						//; Init
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
//; - $2000-c3ff Code
//; - $c400-c7ff Scrolltext
//; - $c800-cbff Screen0
//; - $cc00-cfff Screen1
//; - $e000-efff Spritedata
//; - $fc00-ff5f SpriteXVals

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
	.byte $e0									//; D008: VIC_Sprite4X
	.byte $10									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $10									//; D00b: VIC_Sprite5Y
	.byte $58									//; D00c: VIC_Sprite6X
	.byte $10									//; D00d: VIC_Sprite6Y
	.byte $70									//; D00e: VIC_Sprite7X
	.byte $10									//; D00f: VIC_Sprite7Y
	.byte $d0									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $3c									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $ff									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte DYPP_BackgroundColour					//; D021: VIC_ScreenColour
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


//; AllBorderDYPP_Init() -------------------------------------------------------------------------------------------------------
AllBorderDYPP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		lda #JMP_ABS
		sta ZP_IRQJump + 0
		lda #<IRQ_FirstFrameA
		sta ZP_IRQJump + 1
		lda #>IRQ_FirstFrameA
		sta ZP_IRQJump + 2

		ldx #$10
		ldy #$00
		lda #$00
	ClearSpritesLoop:
        sta Base_BankAddress0 + (FirstSpriteValue * 64),y
		iny
		bne ClearSpritesLoop
		inc ClearSpritesLoop + 2
		dex
		bne ClearSpritesLoop

		ldy #$07
	FillSpriteValsLoop:
		lda #$80
		sta SpriteVals0,y
		lda #$81
		sta SpriteVals1,y
		dey
		bpl FillSpriteValsLoop

		ldy #53
		lda #$00
	FillScrollText:
		sta ZP_ScrollText,y
		dey
		bpl FillScrollText
		sta ZP_SpriteScrollerColour

		ldy #$00
		lda #$00
	FillColourMemoryLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillColourMemoryLoop

		lda #$01
		sta Signal_CustomSignal1

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #AllBorderDYPP_FirstFrameIRQLine
		sta VIC_D012
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff
		asl VIC_D019

		cli

		jsr IRQLoader_LoadNext
		inc Signal_CustomSignal0

		rts

IRQ_FirstFrameA:
		:IRQManager_BeginIRQ(1, 0)

		lda #$13
		sta VIC_D011
		lda #$ff
	WaitForFF:
		cmp VIC_D012
		bne WaitForFF
		lda #$1b
		sta VIC_D011

		lda #D018Value0
		sta VIC_D018

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

		jsr BASECODE_PlayMusic

		lda Signal_CustomSignal1
		beq NoFades
		cmp #1
		beq DoFadeIn
	DoFadeOut:
		jsr FadeScreenColoursOut
		jmp NotFinishedLoading
	DoFadeIn:
		jsr FadeScreenColoursIn
		jmp NotFinishedLoading

	NoFades:
		lda Signal_CustomSignal0
		beq NotFinishedLoading

		ldx #<IRQ_FirstFrameB
		ldy #>IRQ_FirstFrameB
		lda #$91
		jsr MainIRQ							//; loads X and Y with pointers to the Main IRQ...
		lda #$00
		sta FrameOf256
		lda #AllBorderDYPP_MainIRQLine
		jmp IsFinished

	NotFinishedLoading:
		ldx #<IRQ_FirstFrameB
		ldy #>IRQ_FirstFrameB
		lda #$91

	IsFinished:
		stx ZP_IRQJump + 1
		sty ZP_IRQJump + 2
		sta VIC_D012

		lda #$13
		sta VIC_D011

		:IRQManager_EndIRQ()
		rti

IRQ_FirstFrameB:
		:IRQManager_BeginIRQ(1, 0)

		ldx #$09
	DelayHere:
		dex
		bpl DelayHere
		nop

		lda #D018Value0B
		sta VIC_D018

		ldx #<IRQ_FirstFrameA
		ldy #>IRQ_FirstFrameA
		lda #AllBorderDYPP_FirstFrameIRQLine
		stx ZP_IRQJump + 1
		sty ZP_IRQJump + 2
		sta VIC_D012

		:IRQManager_EndIRQ()
		rti


FadeOne:	.byte $00, $0c, $00, $0e, $06, $09, $00, $08, $02, $00, $02, $00, $0b, $05, $06, $0c
FadeTwo:	.byte $00, $0b, $00, $06, $00, $00, $00, $02, $00, $00, $00, $00, $00, $09, $00, $0b

DontDoFade:
		rts

FadeScreenColoursIn:
		ldy #54

		cpy #39
		bcs FadeIn_SkipColumn0
		cpy #0
		bcc FadeIn_SkipColumn0
		jsr UpdateScreenColourColumn_Fade0
	FadeIn_SkipColumn0:

		dey
		dey
		dey
		dey
		dey
		dey
		cpy #39
		bcs FadeIn_SkipColumn1
		cpy #0
		bcc FadeIn_SkipColumn1
		jsr UpdateScreenColourColumn_Fade1
	FadeIn_SkipColumn1:

		dey
		dey
		dey
		dey
		dey
		dey
		cpy #39
		bcs FadeIn_SkipColumn2
		cpy #0
		bcc FadeIn_SkipColumn2
		jsr UpdateScreenColourColumn_Fade2
	FadeIn_SkipColumn2:

		dec FadeScreenColoursIn + 1
		bpl NotFinishedFadeIn

		lda #$00
		sta Signal_CustomSignal1

	NotFinishedFadeIn:
	DontDoFadeOut:
		rts

FadeScreenColoursOut:
		ldy #54

		cpy #39
		bcs FadeOut_SkipColumn0
		cpy #0
		bcc FadeOut_SkipColumn0
		jsr UpdateScreenColourColumn_SetBlack
	FadeOut_SkipColumn0:

		dey
		dey
		dey
		dey
		dey
		dey
		cpy #39
		bcs FadeOut_SkipColumn1
		cpy #0
		bcc FadeOut_SkipColumn1
		jsr UpdateScreenColourColumn_Fade2
	FadeOut_SkipColumn1:

		dey
		dey
		dey
		dey
		dey
		dey
		cpy #39
		bcs FadeOut_SkipColumn2
		cpy #0
		bcc FadeOut_SkipColumn2
		jsr UpdateScreenColourColumn_Fade1
	FadeOut_SkipColumn2:

		dec FadeScreenColoursOut + 1
		bpl NotFinishedFadeOut

		inc Signal_CurrentEffectIsFinished

	NotFinishedFadeOut:
		rts

UpdateScreenColourColumn_SetBlack:
		lda #$00
		.for (var Line = 0; Line < 25; Line++)
		{
			sta VIC_ColourMemory + (Line * 40), y
		}
		rts

UpdateScreenColourColumn_Fade2:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldx $f000 + (Line * 40), y
			lda FadeTwo, x
			sta VIC_ColourMemory + (Line * 40), y
		}
		rts

UpdateScreenColourColumn_Fade1:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldx $f000 + (Line * 40), y
			lda FadeOne, x
			sta VIC_ColourMemory + (Line * 40), y
		}
		rts

UpdateScreenColourColumn_Fade0:
		.for (var Line = 0; Line < 25; Line++)
		{
			lda $f000 + (Line * 40), y
			sta VIC_ColourMemory + (Line * 40), y
		}
		rts