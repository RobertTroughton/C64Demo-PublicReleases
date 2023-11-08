//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = $0002 "ZP variables" virtual
.zp {
ZP_Mask:
	.byte 0
ZP_PlotLineData:
	.byte 0
}

* = Quote_BASE "Quote Screen"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp QUOTE_Init								//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0200-023f Demo Main Driver
//; - $0800-08ff Disk Side Driver
//; - $0a00-0bff Nucrunch
//; - $0c00-0dff Spindle
//; - $0e00-0eff Spindle (used while loading)
//; - $0f00-0fbf Base Code
//; ---- $0fc0-0fff Global Variables

//; - $1000-27ff Music

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 2 //; Bank+[0800,0bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * $400))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)
	.var D016_Value_38Rows = $00
	.var D016_Value_40Rows = $08

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

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
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $0e									//; D020: VIC_BorderColour
	.byte $0e									//; D021: VIC_ScreenColour
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

//; QUOTE_Init() -------------------------------------------------------------------------------------------------------
QUOTE_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		ldy #$00
		lda #$6e
	ClearScreenDataLoop:
		sta ScreenAddress + (0 * 256), y
		sta ScreenAddress + (1 * 256), y
		sta ScreenAddress + (2 * 256), y
		sta ScreenAddress + (3 * 256), y
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne ClearScreenDataLoop

		ldx #$1f
		ldy #$00
		lda #$00
	ClearBitmapLoop:
		sta BitmapAddress, y
		iny
		bne ClearBitmapLoop
		inc ClearBitmapLoop + 2
		dex
		bne ClearBitmapLoop
		ldy #$3f
	ClearBitmapLoop2:
		sta BitmapAddress + $1f00, y
		dey
		bpl ClearBitmapLoop2

		jsr QUOTE_Plot_NewLine
		:vsync()

		sei
		jsr QUOTE_SetVBlankIRQ
		asl VIC_D019 //; Acknowledge VIC interrupts
		cli
		rts

//; QUOTE_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
QUOTE_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 0)

		jsr BASECODE_PlayMusic

		jsr QUOTE_Plot

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		jsr QUOTE_SetVBlankIRQ
		:IRQManager_EndIRQ()

		rti

QUOTE_SetVBlankIRQ:
		lda #$3b
		sta VIC_D011
		lda #$00
		sta VIC_D012
		lda #<QUOTE_IRQ_VBlank
		sta $fffe
		lda #>QUOTE_IRQ_VBlank
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts
	
.import source "..\..\Intermediate\Built\Quote\TextLines.asm"
