//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = BIGDYPP_BASE "Big DYPP"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp BIGDYPP_Init							//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

.import source "..\..\..\..\Intermediate\Built\BigDYPP\D018SplitDefines.asm"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $f4-f7 Spindle (Only during loads)
//; ---- $0c00-$0dff Spindle (ALWAYS)
//; ---- $0e00-$0eff Spindle (Only during loads)
//; - $1000-29ff Music
//; - $2a00-89ff Code
//; ---- $a400-a7ff Screen1
//; - $a800-bfff Charsets 4-6
//; - $c000-dfff Charsets 0-3
//; ---- $f800-fbff Screen0
//; - $fc00-ffff Scrolltext

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var CharBanks0 = 0 //; Bank+[0000,1fff] //; 4 charbanks
	.var CharBanks1 = 5 //; Bank+[2800,3fff] //; 3 charbanks
	.var CharBank0 = CharBanks0 + 0
	.var CharBank1 = CharBanks0 + 1
	.var CharBank2 = CharBanks0 + 2
	.var CharBank3 = CharBanks0 + 3
	.var CharBank4 = CharBanks1 + 0
	.var CharBank5 = CharBanks1 + 1
	.var CharBank6 = CharBanks1 + 2
	.var ScreenBank0 = 14 //; Bank+[3800,3bff]
	.var ScreenBank1 = 9 //; Bank+[2400,27ff]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var Bank_SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var Bank_SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var ScrollTextUnrolled = $fc00

	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank0 * 16) + (CharBank1 * 2)
	.var D018Value2 = (ScreenBank0 * 16) + (CharBank2 * 2)
	.var D018Value3 = (ScreenBank0 * 16) + (CharBank3 * 2)
	.var D018Value4 = (ScreenBank1 * 16) + (CharBank4 * 2)
	.var D018Value5 = (ScreenBank1 * 16) + (CharBank5 * 2)
	.var D018Value6 = (ScreenBank1 * 16) + (CharBank6 * 2)

	.var D011_Value_24Rows = $13
	.var D011_Value_25Rows = $1b

	.var D016_Value_38Rows = $00
	.var D016_Value_40Rows = $08

	.var ZP_TileIndex = $50

	.var ZP_IRQJump = $1a

	.var ZP_D016Value = $1f

	.var BIGDYPP_VBlank = $fe

	.var BIGDYPP_ScrollSpeed = $04

	.var BIGDYPP_TextColour = $0e
	.var BIGDYPP_BackgroundColour = $06

//; BIGDYPP_LocalData -------------------------------------------------------------------------------------------------------
BIGDYPP_LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $20									//; D000: VIC_Sprite0X
	.byte $32									//; D008: VIC_Sprite0Y
	.byte $50									//; D002: VIC_Sprite1X
	.byte $32									//; D008: VIC_Sprite1Y
	.byte $80									//; D004: VIC_Sprite2X
	.byte $32									//; D008: VIC_Sprite2Y
	.byte $b0									//; D006: VIC_Sprite3X
	.byte $32									//; D009: VIC_Sprite3Y
	.byte $e0									//; D008: VIC_Sprite4X
	.byte $32									//; D009: VIC_Sprite4Y
	.byte $10									//; D00a: VIC_Sprite5X
	.byte $32									//; D008: VIC_Sprite5Y
	.byte $40									//; D00c: VIC_Sprite6X
	.byte $32									//; D008: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D008: VIC_Sprite7Y
	.byte $60									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $ff									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $ff									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte BIGDYPP_BackgroundColour				//; D020: VIC_BorderColour
	.byte BIGDYPP_TextColour					//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $01									//; D025: VIC_SpriteExtraColour0
	.byte $03									//; D026: VIC_SpriteExtraColour1
	.byte $04									//; D027: VIC_Sprite0Colour
	.byte $04									//; D028: VIC_Sprite1Colour
	.byte $04									//; D029: VIC_Sprite2Colour
	.byte $04									//; D02A: VIC_Sprite3Colour
	.byte $04									//; D02B: VIC_Sprite4Colour
	.byte $04									//; D02C: VIC_Sprite5Colour
	.byte $04									//; D02D: VIC_Sprite6Colour
	.byte $04									//; D02E: VIC_Sprite7Colour

BIGDYPP_Add1Mod40:
	.fill 39, i + 1
	.byte $0

//; BIGDYPP_Init() -------------------------------------------------------------------------------------------------------
BIGDYPP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		ldx #$80
		stx Bank_SpriteVals0 + 0
		stx Bank_SpriteVals1 + 0
		inx
		stx Bank_SpriteVals0 + 1
		stx Bank_SpriteVals1 + 1
		inx
		stx Bank_SpriteVals0 + 2
		stx Bank_SpriteVals1 + 2
		inx
		stx Bank_SpriteVals0 + 3
		stx Bank_SpriteVals1 + 3
		inx
		stx Bank_SpriteVals0 + 4
		stx Bank_SpriteVals1 + 4
		inx
		stx Bank_SpriteVals0 + 5
		stx Bank_SpriteVals1 + 5
		inx
		stx Bank_SpriteVals0 + 6
		stx Bank_SpriteVals1 + 6
		inx
		stx Bank_SpriteVals0 + 7
		stx Bank_SpriteVals1 + 7

		lda #JMP_ABS
		sta ZP_IRQJump + 0
		lda #<IRQ_Split0
		sta ZP_IRQJump + 1
		lda #>IRQ_Split0
		sta ZP_IRQJump + 2

		ldx #$27
		lda #$3f
	FillTileDataLoop:
		sta ZP_TileIndex, x
		dex
		bpl FillTileDataLoop

		ldy #$00
	FillScreenAndColourMemory:
		lda #$00
		sta ScreenAddress0 + (0 * 256), y
		sta ScreenAddress0 + (1 * 256), y
		sta ScreenAddress0 + (2 * 256), y
		sta ScreenAddress0 + 1000 - 256, y
		sta ScreenAddress1 + (0 * 256), y
		sta ScreenAddress1 + (1 * 256), y
		sta ScreenAddress1 + (2 * 256), y
		sta ScreenAddress1 + 1000 - 256, y
		lda #BIGDYPP_BackgroundColour
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillScreenAndColourMemory

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #BIGDYPP_VBlank
		sta VIC_D012
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff
		asl VIC_D019

		cli
		rts

BIGDYPP_SubMod8:
	.fill BIGDYPP_ScrollSpeed, 8 - BIGDYPP_ScrollSpeed + i
	.fill 8 - BIGDYPP_ScrollSpeed, i

IRQ_Split0:
		:IRQManager_BeginIRQ(0, 0)

		lda #D011_Value_25Rows
		sta VIC_D011

        lda #D018Value0
        sta VIC_D018
		lda #DD02Value0
		sta VIC_DD02

	D016FrameValue:
		ldx #$00
		ldy BIGDYPP_SubMod8, x
		sty VIC_D016
		sty ZP_D016Value
		sty D016FrameValue + 1

		jsr BIGDYPP_UpdateScroll

		inc FrameOf256
		bne Startup_DontIncreaseCounter
		inc Frame_256Counter
	Startup_DontIncreaseCounter:

		jsr BASECODE_PlayMusic

		jsr BIGDYPP_Render

		lda #D018Split1
		lda #$32
		sta VIC_D012
		lda #<IRQ_Split1
		sta ZP_IRQJump + 1
		lda #>IRQ_Split1
		sta ZP_IRQJump + 2

		:IRQManager_EndIRQ()

		rti

.align 256
.import source "..\..\..\..\Intermediate\Built\BigDYPP\RasterCode.asm"

IRQ_Split1:
		:IRQManager_BeginIRQ(1, 1)

		jsr BIGDYPP_RasterCode

		lda #BIGDYPP_VBlank
		sta VIC_D012
		lda #<IRQ_Split0
		sta ZP_IRQJump + 1
		lda #>IRQ_Split0
		sta ZP_IRQJump + 2

		:IRQManager_EndIRQ()

		rti
	
.import source "..\..\..\..\Intermediate\Built\BigDYPP\TileData.asm"
.import source "..\..\..\..\Intermediate\Built\BigDYPP\Render.asm"

BIGDYPP_UpdateScroll:
		lda D016FrameValue + 1
		cmp #(8 - BIGDYPP_ScrollSpeed)
		bcs DoScroll

		ldx BIGDYPP_Render + 1
		lda BIGDYPP_Add1Mod40, x
		sta BIGDYPP_Render + 1
		rts

	DoScroll:
		.for(var TileIndex = 0; TileIndex < 40; TileIndex++)
		{
			.if(TileIndex != 39)
			{
				lda ZP_TileIndex + TileIndex + 1
			}
			else
			{
				lda ZP_TileIndex + 0
			}
			sta ZP_TileIndex + TileIndex
		}

	ScrollPoint:
		lda ScrollTextUnrolled
		bpl AllGood

		lda #<ScrollTextUnrolled
		sta ScrollPoint + 1
		lda #>ScrollTextUnrolled
		sta ScrollPoint + 2

		inc Signal_CurrentEffectIsFinished
		lda #$3f

	AllGood:
		sta ZP_TileIndex + 39
		inc ScrollPoint + 1
		bne DidntPassPage
		inc ScrollPoint + 2
	DidntPassPage:
		rts
