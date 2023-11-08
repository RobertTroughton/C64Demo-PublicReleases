//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = BorderBitmap_BASE "Border Bitmap"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp BORDERBITMAP_Init						//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-1fff Music

//; - $2000-62ff .. Source MAP Data
//; - $6300-6bff .. Source COL Data
//; - $6c00-74ff .. Source SCR Data

//; - $7500-76ff SinTables

//; - $7700-bfff Code

//; - $c000-dfff Bitmap
//; - $e000-e3e7 Screen 0
//; - $e400-e7e7 Screen 1
//; - $e800-???? Sprites


//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var ScreenBank0 = 8 //; Bank+[2000,23ff]
	.var ScreenBank1 = 9 //; Bank+[2400,27ff]
	.var ScreenAddress0 = (Base_BankAddress + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress + (ScreenBank1 * 1024))
	.var Bank_SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var Bank_SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank * 8)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b
	.var D016_Value_38Rows = $e0
	.var D016_Value_40Rows = $e1
	.var VSP_ScrollPos = $d0

	.var BORDERBITMAP_YStart = $2e //; $30 for NOVSP
	.var BORDERBITMAP_FirstSpriteIndex = 160

	.var BORDERBITMAP_Sin_D016Values = $7500
	.var BORDERBITMAP_Sin_XPosValues = $7600

//; BORDERBITMAP_LocalData -------------------------------------------------------------------------------------------------------
BORDERBITMAP_LocalData:

	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$f9,			<BORDERBITMAP_IRQ_OpenTopBottom,	>BORDERBITMAP_IRQ_OpenTopBottom
		.byte	$ff

//; BORDERBITMAP_Init() -------------------------------------------------------------------------------------------------------
BORDERBITMAP_Init:

		jsr BASECODE_ClearGlobalVariables

		lda #$10
		sta D016_Value_38Rows
		lda #$18
		sta D016_Value_40Rows
 		sta VIC_D016

		MACRO_SetVICBank(BaseBank)

		lda #D018Value0
		sta VIC_D018

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteDrawPriority

		lda #$01
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

		lda #$00
		sta VIC_ScreenColour

		ldx #$08
		ldy #$00
		lda #$aa
	BORDERBITMAP_FillSprites:
	BORDERBITMAP_FillSprites_Ptr0:
		sta Base_BankAddress + (BORDERBITMAP_FirstSpriteIndex * 64), y
	BORDERBITMAP_FillSprites_Ptr1:
		sta Base_BankAddress + (BORDERBITMAP_FirstSpriteIndex * 64) + 256, y
		iny
		bne BORDERBITMAP_FillSprites
		inc BORDERBITMAP_FillSprites_Ptr0 + 2
		inc BORDERBITMAP_FillSprites_Ptr0 + 2
		inc BORDERBITMAP_FillSprites_Ptr1 + 2
		inc BORDERBITMAP_FillSprites_Ptr1 + 2
		dex
		bne BORDERBITMAP_FillSprites

		ldy #$03
	BORDERBITMAP_SpriteSetupLoop:
		lda #BORDERBITMAP_FirstSpriteIndex
		sta Bank_SpriteVals0, y
		sta Bank_SpriteVals1, y
		lda #$0b
		sta VIC_Sprite4Colour, y
		dey
		bpl BORDERBITMAP_SpriteSetupLoop

		lda #$d0
		sta VIC_SpriteXMSB

		lda #$f0
		sta VIC_SpriteEnable
		sta VIC_SpriteMulticolourMode

		lda #$0f
		sta VIC_SpriteExtraColour0
		lda #$0c
		sta VIC_SpriteExtraColour1

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$f9
		sta VIC_D012
		lda #<BORDERBITMAP_IRQ_OpenTopBottom
		sta $fffe
		lda #>BORDERBITMAP_IRQ_OpenTopBottom
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

//; BORDERBITMAP_IRQ_OpenTopBottom() -------------------------------------------------------------------------------------------------------
BORDERBITMAP_IRQ_OpenTopBottom:

		:IRQManager_BeginIRQ(0, 0)

		lda #D011_Value_24Rows
		sta VIC_D011

		jsr BASECODE_PlayMusic

		lda #D011_Value_25Rows
		sta VIC_D011

	TwoFrameCounter:
		ldx #$20
		dex
		stx TwoFrameCounter + 1
		bne MoreFramesToDo

		lda #BORDERBITMAP_YStart
		sta VIC_D012
		lda #<BORDERBITMAP_IRQ_Main
		sta $fffe
		lda #>BORDERBITMAP_IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		jsr BORDERBITMAP_IRQ_InitialPart

	MoreFramesToDo:

		:IRQManager_EndIRQ()

		rti

BORDERBITMAP_PostRasterised:
		jsr BASECODE_PlayMusic

		jsr BORDERBITMAP_UpdateVSP

		inc FrameOf256
		bne DontIncreaseCounter
		inc Frame_256Counter
	DontIncreaseCounter:
		lda FrameOf256

		jsr BORDERBITMAP_IRQ_InitialPart

		inc Signal_VBlank

		:IRQManager_EndIRQ()
		rti

BORDERBITMAPRasterisedASM:
		.import source "..\..\..\..\Intermediate\Built\BorderBitmap\Rasterised.asm"

 //; VSP stuff ...

BorderBitmap_DoVSP:
		ldx #$70
		ldy #$7b
		nop
		lda $ea
		lda #$33
		sta VIC_D011

		//; Waste some time
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		//; Still in line 47
		//; Calculate a variable offset to delay by branching over nops
		lda #39
		sec
		sbc VSP_ScrollPos
		//; divide by 2 to get the number of nops to skip
		lsr
		sta sm1+1
		//; Force branch always
		clv

		//; Line 48

		//; Introduce a 1 cycle extra delay depending on the least significant bit of the x offset
		bcc sm1
	sm1:
		bvc *
		//; The above branches somewhere into these nops depending on the x offset position
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		//; Do the HSP by tweaking the VIC2ScreenControlV register at the correct time
		stx VIC_D011
		sty VIC_D011

	BORDERBITMAP_Sprite4XPos:
		lda #$e0
		sta VIC_Sprite4X
	BORDERBITMAP_Sprite5XPos:
		lda #$00
		sta VIC_Sprite5X
	BORDERBITMAP_Sprite6XPos:
		lda #$58
		sta VIC_Sprite6X
	BORDERBITMAP_Sprite7XPos:
		lda #$70
		sta VIC_Sprite7X

		rts

BORDERBITMAP_UpdateVSP:
		ldx #$00

		lda BORDERBITMAP_Sin_D016Values, x
		sta D016_Value_40Rows
		and #$07
		ora #$e0
		sta BORDERBITMAP_Sprite4XPos + 1
		eor #$e0
		sta BORDERBITMAP_Sprite5XPos + 1
		eor #$58
		sta BORDERBITMAP_Sprite6XPos + 1
		eor #$28
		sta BORDERBITMAP_Sprite7XPos + 1

		lda BORDERBITMAP_Sin_XPosValues, x
		sta VSP_ScrollPos

		inc BORDERBITMAP_UpdateVSP + 1

		rts



