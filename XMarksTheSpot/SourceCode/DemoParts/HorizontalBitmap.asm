//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = HorizontalBitmap_BASE "Horizontal Bitmap"

//; Common Code: $0000-0fff
//; Music: $1000-1fff
//; This Code: $2000-30ff
//; Bitmap Scroll Data: $3200-8bff
//; Screen 0: $8c00-$8fe7
//; Screen Scroll Data: $9000-9bff
//; Bitmap 0: $a000-$bf3f
//; Ease-in/out Sprites 0: $bf40-bfbe
//; Colour Scroll Data: $c000-cbff
//; Screen 1: $cc00-$cfe7
//; Bitmap 1: $e000-$ff3f
//; Ease-in/out Sprites 0: $ff40-ffbe

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $60, $60					//; Pre-Init
		jmp HORIZ_Init						//; Init
		jmp	HORIZ_ScrollBitmap				//; MainThreadFunc
		jmp HORIZ_End						//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; Local Defines -------------------------------------------------------------------------------------------------------
	.var Bank0 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var ScreenBank0 = 3 //; Bank+[0c00,0fff]
	.var BitmapBank0 = 1 //; Bank+[2000,3fff]
	.var Bank0_BaseAddress = (Bank0 * $4000)
	.var Bank0_BitmapAddress = Bank0_BaseAddress + (BitmapBank0 * $2000)
	.var Bank0_ScreenAddress = (Bank0_BaseAddress + (ScreenBank0 * $0400))
	.var Bank0_SpriteVals = Bank0_ScreenAddress + $3f8

	.var Bank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var ScreenBank1 = 3 //; Bank+[0c00,0fff]
	.var BitmapBank1 = 1 //; Bank+[2000,3fff]
	.var Bank1_BaseAddress = (Bank1 * $4000)
	.var Bank1_BitmapAddress = Bank1_BaseAddress + (BitmapBank1 * $2000)
	.var Bank1_ScreenAddress = (Bank1_BaseAddress + (ScreenBank1 * $0400))
	.var Bank1_SpriteVals = Bank1_ScreenAddress + $3f8

	.var HORIZ_BitmapScrollData = $3200
	.var HORIZ_ScreenScrollData = $9000
	.var HORIZ_ColourScrollData = $c000

	.var HORIZ_SpriteXTable = $9c00
	.var HORIZ_SpriteXMSBTable = HORIZ_SpriteXTable + $100
	.var HORIZ_SpriteEnableTable = HORIZ_SpriteXTable + $200

//; HORIZ_LocalData -------------------------------------------------------------------------------------------------------
HORIZ_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,				LoPtr,							HiPtr
		.byte	$00,			$fc,				<HORIZ_IRQ_VBlank,				>HORIZ_IRQ_VBlank
	IRQList_SpriteCarpet:
		.byte	$00,			50 + 21 + (42 * 0),	<HORIZ_SpriteCarpet,			>HORIZ_SpriteCarpet
		.byte	$00,			50 + 21 + (42 * 1),	<HORIZ_SpriteCarpet,			>HORIZ_SpriteCarpet
		.byte	$00,			50 + 21 + (42 * 2),	<HORIZ_SpriteCarpet,			>HORIZ_SpriteCarpet
		.byte	$00,			50 + 21 + (42 * 3),	<HORIZ_SpriteCarpet,			>HORIZ_SpriteCarpet
		.byte	$ff

	HORIZ_DoubleBufferDD02:
		.byte Bank1 + 60
		.byte Bank0 + 60

	HORIZ_DoubleBufferD018:
		.byte (ScreenBank1 * 16) + (BitmapBank1 * 8)
		.byte (ScreenBank0 * 16) + (BitmapBank0 * 8)

	HORIZ_ScrollIndex:
		.byte $00

	HORIZ_FirstPass:
		.byte $01

	HORIZ_ScrollValue:
		.byte $00

	.print "* $" + toHexString(HORIZ_LocalData) + "-$" + toHexString(EndHORIZ_LocalData - 1) + " HORIZ_LocalData"
EndHORIZ_LocalData:

//; HORIZ_Init() -------------------------------------------------------------------------------------------------------
HORIZ_Init:

		lda #$00
 		sta VIC_ScreenColour

		jsr HORIZ_SetSprites

		sei
		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()
		
		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(HORIZ_Init) + "-$" + toHexString(EndHORIZ_Init - 1) + " HORIZ_Init"
EndHORIZ_Init:

//; HORIZ_End() -------------------------------------------------------------------------------------------------------
HORIZ_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(HORIZ_End) + "-$" + toHexString(EndHORIZ_End - 1) + " HORIZ_End"
EndHORIZ_End:

//; HORIZ_ScrollColour() -------------------------------------------------------------------------------------------------------
HORIZ_ScrollColour:

		lda #$ad
		sta HORIZ_JSRScrollColour

		ldy #$00
	HORIZ_ScrollColour_Loop_A:
		.for(var YVal = 0; YVal < 10; YVal++)
		{
			lda VIC_ColourMemory + YVal * 40 + 1, y
			sta VIC_ColourMemory + YVal * 40, y
		}
		iny
		cpy #38
		beq HORIZ_ScrollColour_Loop_FIN_A
		jmp HORIZ_ScrollColour_Loop_A
	HORIZ_ScrollColour_Loop_FIN_A:

		ldy #$00
	HORIZ_ScrollColour_Loop_B:
		.for(var YVal = 10; YVal < 25; YVal++)
		{
			lda VIC_ColourMemory + YVal * 40 + 1, y
			sta VIC_ColourMemory + YVal * 40, y
		}
		iny
		cpy #38
		beq HORIZ_ScrollColour_Loop_FIN_B
		jmp HORIZ_ScrollColour_Loop_B
	HORIZ_ScrollColour_Loop_FIN_B:

		ldx HORIZ_ScrollIndex
		.for(var YVal = 0; YVal < 25; YVal++)
		{
			lda HORIZ_ColourScrollData + (YVal * 115), x
			sta VIC_ColourMemory + (YVal * 40) + 38
		}

	HORIZ_INCScrollIndex:
		inc HORIZ_ScrollIndex

		rts
		
		.print "* $" + toHexString(HORIZ_ScrollColour) + "-$" + toHexString(EndHORIZ_ScrollColour - 1) + " HORIZ_ScrollColour"
EndHORIZ_ScrollColour:

//; HORIZ_ScrollBitmap() -------------------------------------------------------------------------------------------------------
HORIZ_DontPlotNewData:
		lda #LDA_ABS
		sta HORIZ_INCScrollIndex
		lda #$00
		sta IRQList_SpriteCarpet	//; Re-enable sprite carpet IRQs
		lda #JSR_ABS
		sta HORIZ_JSRUpdateSprites
		lda #DEX
		sta HORIZ_INX_DEX
		sta HORIZ_INX_DEX + 1
		sta HORIZ_INX_DEX + 2
		sta HORIZ_INX_DEX + 3
		lda #LDA_IMM
		sta HORIZ_ScrollBitmap

HORIZ_ScrollBitmap:

		beq HORIZ_DontPlotNewData

	HORIZ_JSRScrollColour:
		lda HORIZ_ScrollColour

		lda HORIZ_DoubleBufferFrame + 1
		beq HORIZ_Copy0To1
		jmp HORIZ_Copy1To0
	HORIZ_DontScrollBitmap:
		rts
		
	//; 1st Buffer
	HORIZ_Copy0To1:

		//; Scroll Bitmap (Part 1)
		ldy #$00
	HORIZ_Loop_Bitmap_0To1:
		.for(var YVal = 0; YVal < 25 + 1; YVal++)
		{
			.if(YVal < 25)
			{
				lda Bank0_BitmapAddress + ((YVal * 40) + 1) * 8, y
				sta Bank1_BitmapAddress + ((YVal * 40) + 0) * 8, y
			}
			.if(YVal >= 1)
			{
				lda Bank0_BitmapAddress + (((YVal - 1) * 40) + 19 + 1) * 8, y
				sta Bank1_BitmapAddress + (((YVal - 1) * 40) + 19 + 0) * 8, y
			}
		}
		iny
		cpy #(19 * 8)
		beq HORIZ_Loop_Bitmap_0To1_FIN
		jmp HORIZ_Loop_Bitmap_0To1
	HORIZ_Loop_Bitmap_0To1_FIN:

		//; Scroll Screen
		ldy #$00
	HORIZ_Loop_Screen_0To1:
		.for(var YVal = 0; YVal < 25; YVal++)
		{
			lda Bank0_ScreenAddress + ((YVal * 40) + 1), y
			sta Bank1_ScreenAddress + ((YVal * 40) + 0), y
		}
		iny
		cpy #38
		beq HORIZ_Loop_Screen_0To1_FIN
		jmp HORIZ_Loop_Screen_0To1
	HORIZ_Loop_Screen_0To1_FIN:

		//; Add New Bitmap Data
		ldx HORIZ_ScrollIndex
		.for(var YCharVal = 0; YCharVal < 25; YCharVal++)
		{
			.for(var YPixelVal = 0; YPixelVal < 8; YPixelVal++)
			{
				lda HORIZ_BitmapScrollData + ((YCharVal * 8) + YPixelVal) * 115, x
				sta Bank1_BitmapAddress + (YCharVal * 40 + 38) * 8 + YPixelVal
			}
			lda HORIZ_ScreenScrollData + (YCharVal * 115), x
			sta Bank1_ScreenAddress + (YCharVal * 40) + 38
		}

		rts

	//; 2nd Buffer
	HORIZ_Copy1To0:

		//; Scroll Bitmap (Part 1)
		ldy #$00
	HORIZ_Loop_Bitmap_1To0:
		.for(var YVal = 0; YVal < 25 + 1; YVal++)
		{
			.if(YVal < 25)
			{
				lda Bank1_BitmapAddress + ((YVal * 40) + 1) * 8, y
				sta Bank0_BitmapAddress + ((YVal * 40) + 0) * 8, y
			}
			.if(YVal >= 1)
			{
				lda Bank1_BitmapAddress + (((YVal - 1) * 40) + 19 + 1) * 8, y
				sta Bank0_BitmapAddress + (((YVal - 1) * 40) + 19 + 0) * 8, y
			}
		}
		iny
		cpy #(19 * 8)
		beq HORIZ_Loop_Bitmap_1To0_FIN
		jmp HORIZ_Loop_Bitmap_1To0
	HORIZ_Loop_Bitmap_1To0_FIN:

		//; Scroll Screen
		ldy #$00
	HORIZ_Loop_Screen_1To0:
		.for(var YVal = 0; YVal < 25; YVal++)
		{
			lda Bank1_ScreenAddress + ((YVal * 40) + 1), y
			sta Bank0_ScreenAddress + ((YVal * 40) + 0), y
		}
		iny
		cpy #38
		beq HORIZ_Loop_Screen_1To0_FIN
		jmp HORIZ_Loop_Screen_1To0
	HORIZ_Loop_Screen_1To0_FIN:

		//; Add New Bitmap Data
		ldx HORIZ_ScrollIndex
		.for(var YCharVal = 0; YCharVal < 25; YCharVal++)
		{
			.for(var YPixelVal = 0; YPixelVal < 8; YPixelVal++)
			{
				lda HORIZ_BitmapScrollData + ((YCharVal * 8) + YPixelVal) * 115, x
				sta Bank0_BitmapAddress + (YCharVal * 40 + 38) * 8 + YPixelVal
			}
			lda HORIZ_ScreenScrollData + (YCharVal * 115), x
			sta Bank0_ScreenAddress + (YCharVal * 40) + 38
		}

		rts
		
		.print "* $" + toHexString(HORIZ_ScrollBitmap) + "-$" + toHexString(EndHORIZ_ScrollBitmap - 1) + " HORIZ_ScrollBitmap"
EndHORIZ_ScrollBitmap:

//; HORIZ_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
HORIZ_IRQ_VBlank:

		:Start_ShowTiming(0)
		
		:IRQManager_BeginIRQ(0, 0)

		lda FrameOf256
		and #$0f
		sta FrameOf16
		and #$07
		sta FrameOf8
		sta HORIZ_ScrollValue

		lda HORIZ_ScrollValue
		eor #$17
 		sta VIC_D016

		jsr Music_Play

		lda #$3b
		sta VIC_D011

	HORIZ_JSRUpdateSprites:
		jsr HORIZ_UpdateSprites
	
		lda HORIZ_ScrollValue
		bne HORIZ_DontFlipBuffer

	HORIZ_DoubleBufferFrame:
		lda #$00
		tax
		eor #$01
		sta HORIZ_DoubleBufferFrame + 1

		lda HORIZ_DoubleBufferDD02, x
		sta VIC_DD02
		lda HORIZ_DoubleBufferD018, x
		sta VIC_D018

		inc Signal_CustomSignal0	//; We can start prepping the next screen immediately

		lda HORIZ_FirstPass
		bne HORIZ_DontFlipBuffer
		lda #$20
		sta HORIZ_JSRScrollColour

	HORIZ_DontFlipBuffer:
		lda #$00
		sta HORIZ_FirstPass
		
		inc FrameOf256
		bne HORIZ_Skip256Counter
		inc Frame_256Counter
	HORIZ_Skip256Counter:
	
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		:Stop_ShowTiming(0)
		
		rti

		.print "* $" + toHexString(HORIZ_IRQ_VBlank) + "-$" + toHexString(EndHORIZ_IRQ_VBlank - 1) + " HORIZ_IRQ_VBlank"
EndHORIZ_IRQ_VBlank:

HORIZ_SetSprites:
		ldx #$fe
		stx VIC_SpriteDoubleWidth
		inx
		stx VIC_SpriteDoubleHeight

		ldx #$07
		ldy #$0e
	HORIZ_SetSpriteLoop:
		lda #$06
		sta VIC_Sprite0Colour, x
		lda #$fe
		sta Bank0_SpriteVals, x
		sta Bank1_SpriteVals, x

	HORIZ_SpriteYPos:
		lda #$32
		sta VIC_Sprite0Y, y
		clc
		adc #42
		sta HORIZ_SpriteYPos + 1
		dey
		dey
		dex
		bpl HORIZ_SetSpriteLoop

		lda #$fd
		sta Bank0_SpriteVals
		sta Bank1_SpriteVals
	//; We fall straight through to the sprite "update"

HORIZ_UpdateSprites:
	HORIZ_SpriteXValue:
		ldx #$00
	HORIZ_INX_DEX:
		inx
		inx
		inx
		inx
		bne HORIZ_NotFinishedSpriteCarpet
		inc Signal_CustomSignal2
		jmp HORIZ_SetSpriteY
	HORIZ_NotFinishedSpriteCarpet:
		stx HORIZ_SpriteXValue + 1

		lda HORIZ_SpriteEnableTable, x
		sta VIC_SpriteEnable
		bne HORIZ_SpritesNotDisabled

		lda #LDA_ABS
		sta HORIZ_JSRUpdateSprites
		lda #$ff
		sta IRQList_SpriteCarpet	//; Prevent sprite carpet code running more
		:IRQManager_SetIRQIndex(0)
	HORIZ_SpritesNotDisabled:

		lda HORIZ_SpriteXMSBTable, x
		sta VIC_SpriteXMSB

		lda HORIZ_SpriteXTable, x
		sta VIC_Sprite0X
		txa
		clc
		adc #12
		tax
		ldy #$00
	HORIZ_SetSpriteLoop2:
		lda HORIZ_SpriteXTable, x
		sta VIC_Sprite1X, y
		txa
		clc
		adc #24
		tax
		iny
		iny
		cpy #$0e
		bne HORIZ_SetSpriteLoop2

	HORIZ_SetSpriteY:
		ldy #$0e
		lda #$32
	HORIZ_SetSpriteLoop3:
		sta VIC_Sprite0Y, y
		dey
		dey
		bpl HORIZ_SetSpriteLoop3

		rts
		
HORIZ_SpriteCarpet:

		:Start_ShowTiming(0)
		
		:IRQManager_BeginIRQ(0, 0)

		lda VIC_Sprite0Y
		clc
		adc #42
	HORIZ_UpdateY:
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		:Stop_ShowTiming(0)
		
		rti


