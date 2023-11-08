//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= ABDDYPP_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		jmp ABDDYPP_PreInit							//; Pre-Init
		jmp ABDDYPP_Init							//; Init
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
//; - $1000-29ff Music
//; - $2000-9fff Code
//; - $b800-bb5f SpriteXVals
//; - $bc00-bd7f Scrolltext0
//; - $bd80-beff Scrolltext1
//; - $bf00-bfff Fade Sin Table
//; - $e000-ffff Sprite Output (nb. with space left for the below sprite val data)
//; - $f7f8-f7ff Screen0 Sprite Vals
//; - $fbf8-fbff Screen1 Sprite Vals

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var CharBank0 = 3 //; Bank+[1800,1fff] //; but we don't use the whole thing
	.var ScreenBank0 = 13 //; Bank+[3400,37ff]
	.var  ScreenBank1 = 14 //; Bank+[3800,3bff]
	.var  ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var  ScreenAddress1 = (Base_BankAddress0 + (ScreenBank1 * 1024))
	.var  SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var  SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank1 * 16) + (CharBank0 * 2)

	.var D011_Value_24Rows = $03
	.var D011_Value_25Rows = $0b

	.var D016_Value_38Rows = $07
	.var D016_Value_40Rows = $08

	.var ABDDYPP_MainIRQLine = $1d

	.var ZP_IRQJump = $a0		//$04 - interferes with loader!!!

	.var ZP_SpriteXPos = $10

	.var FirstSpriteValue = $80 //; $e000-$ffff

	.var ABDDYPP_BackgroundColour = $00

	.var ABDDYPP_TOTALWIDTH = 432
	.var SpriteXValsMem = $b800

	.var ScrollTextLen = 54

	.var ZP_ScrollText0 = $20
	.var ZP_ScrollText1 = $58

	.var ABDDYPP_ScrollText0 = $bc00
	.var ABDDYPP_ScrollText1 = $bd80

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $20									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $50									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $e0									//; D008: VIC_Sprite4X
	.byte $10									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $10									//; D00b: VIC_Sprite5Y
	.byte $80									//; D00c: VIC_Sprite6X
	.byte $10									//; D00d: VIC_Sprite6Y
	.byte $b0									//; D00e: VIC_Sprite7X
	.byte $10									//; D00f: VIC_Sprite7Y
	.byte $d0									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $ff									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $c3									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte ABDDYPP_BackgroundColour				//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte 0										//; D027: VIC_Sprite0Colour
	.byte 0										//; D028: VIC_Sprite1Colour
	.byte 0										//; D029: VIC_Sprite2Colour
	.byte 0										//; D02A: VIC_Sprite3Colour
	.byte 0										//; D02B: VIC_Sprite4Colour
	.byte 0										//; D02C: VIC_Sprite5Colour
	.byte 0										//; D02D: VIC_Sprite6Colour
	.byte 0										//; D02E: VIC_Sprite7Colour

Sprite0MSBVals:									.byte $00, $01
Sprite1MSBVals:									.byte $00, $02
Sprite2MSBVals:									.byte $00, $04
Sprite3MSBVals:									.byte $00, $08
Sprite4MSBVals:									.byte $00, $10
Sprite5MSBVals:									.byte $00, $20
Sprite6MSBVals:									.byte $00, $40
Sprite7MSBVals:									.byte $00, $80

//; ABDDYPP_PreInit() -------------------------------------------------------------------------------------------------------
ABDDYPP_PreInit:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #$00
	ClearColourMemoryLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne ClearColourMemoryLoop

		ldx #$1f
		lda #$00
		tay
	ClearSpritesLoop:
		sta Base_BankAddress0 + (FirstSpriteValue * 64), y
		iny
		bne ClearSpritesLoop
		inc ClearSpritesLoop + 2
		dex
		bne ClearSpritesLoop

	ClearSpritesLoop2:
		sta Base_BankAddress0 + $1f00, y
		iny
		cpy #$c0
		bne ClearSpritesLoop2

		ldy #(ScrollTextLen - 1)
		lda #$00
		sta ZP_SpriteXPos
	FillScrollText:
		sta ZP_ScrollText0,y
		sta ZP_ScrollText1,y
		dey
		bpl FillScrollText

        jsr SetInitialSpriteValues_Frame0

		rts
//; ABDDYPP_Init() -------------------------------------------------------------------------------------------------------
ABDDYPP_Init:

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #<IRQ_Main_Frame0
		sta ZP_IRQJump + 1
		lda #>IRQ_Main_Frame0
		sta ZP_IRQJump + 2
		lda #ABDDYPP_MainIRQLine
		sta VIC_D012
		asl VIC_D019

		cli
		rts

ScrollScrollText:

		ldx ZP_ScrollText0
		.for (var ScrollPos = 0; ScrollPos < (ScrollTextLen - 1); ScrollPos++)
		{
			lda ZP_ScrollText0 + 1 + ScrollPos
			sta ZP_ScrollText0 + ScrollPos
		}
		stx ZP_ScrollText0 + (ScrollTextLen - 1)

		ldx ZP_ScrollText1
		.for (var ScrollPos = 0; ScrollPos < (ScrollTextLen - 1); ScrollPos++)
		{
			lda ZP_ScrollText1 + 1 + ScrollPos
			sta ZP_ScrollText1 + ScrollPos
		}
		stx ZP_ScrollText1 + (ScrollTextLen - 1)

		lda FrameOf256
		and #$02
		beq DontDoTheScrollText

	UpdateForNewChar0:
		ldy #0

	ScrollTextReadPtr0:
		lda ABDDYPP_ScrollText0
		bpl NotFinishedScroller0

		inc Signal_CustomSignal0

		lda #0
		sta ZP_ScrollText0,y
		sta ZP_ScrollText1,y

	HaveWeBlackenedSpriteColoursYet:
		ldx #0
		bne WeveBlackenedSpritesAlready
		jsr BlackenAllSprites
		inc HaveWeBlackenedSpriteColoursYet + 1
	WeveBlackenedSpritesAlready:

		jmp NotPassedPage0

	NotFinishedScroller0:
		sta ZP_ScrollText0,y

	HaveWeInitedSpriteColoursYet:
		cmp #0
		beq WeveInitedSpriteColoursAlready	//; skip this if we're not actually adding a "real" char
		ldx #0
		bne WeveInitedSpriteColoursAlready
		jsr SetSpriteColours
		inc HaveWeInitedSpriteColoursYet + 1
	WeveInitedSpriteColoursAlready:

	ScrollTextReadPtr1:
		lda ABDDYPP_ScrollText1
		sta ZP_ScrollText1,y

		inc ScrollTextReadPtr0 + 1
		bne NotPassedPage0
		inc ScrollTextReadPtr0 + 2
	NotPassedPage0:
		inc ScrollTextReadPtr1 + 1
		bne NotPassedPage1
		inc ScrollTextReadPtr1 + 2
	NotPassedPage1:

		dey
		bpl NotLastOne0
		ldy #(ScrollTextLen - 1)
	NotLastOne0:
		sty UpdateForNewChar0 + 1
	DontDoTheScrollText:

	MainIRQHasFinished:
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff

		:IRQManager_EndIRQ()
		rti

.align 256
.import source "../../../Out/6502/Parts/AllBorderDoubleDYPP/MainIRQ.asm"

.align 256
.import source "../../../Out/6502/Parts/AllBorderDoubleDYPP/Font.asm"

