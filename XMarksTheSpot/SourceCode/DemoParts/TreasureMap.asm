//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = TreasureMap_BASE "Treasure Map"

//; Common Code: $0000-0fff
//; Music: $1000-2fff
//; This Code: $3000-45ff
//; Bitmap Scroll Data: $4800-87ff
//; Sprite 0: $8800-$883f
//; DotSprites 0: $8800-$8bff //; Sprites
//; Screen 0: $8c00-$8fe7
//; Colour Scroll Data: $9000-97ff
//; Sprite Write Info: $9800-9a3f
//; First Sprite / Sprite Num Info: $9f40-9fdf
//; Sprite Coords: $9fe0-9fff
//; Bitmap 0: $a000-$bf3f
//; Sprite 1: $c800-$c83f
//; DotSprites 1: $c800-$cbff //; Sprites
//; Screen 1: $cc00-$cfe7
//; Bitmap 1: $e000-$ff3f

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $60, $60					//; Pre-Init
		jmp TREASURE_Init					//; Init
		jmp	TREASURE_ScrollBitmap			//; MainThreadFunc
		jmp TREASURE_End					//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var TREASURE_FirstSpriteIndex = $20

	.var Bank0 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Bank0_BaseAddress = (Bank0 * $4000)
	.var Bank0_BitmapAddress = Bank0_BaseAddress + (BitmapBank * $2000)
	.var Bank0_ScreenAddress = (Bank0_BaseAddress + (ScreenBank * $0400))
	.var Bank0_SpriteVals = Bank0_ScreenAddress + $3f8
	.var Bank0_SpriteAddress = Bank0_BaseAddress + TREASURE_FirstSpriteIndex * 64

	.var Bank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Bank1_BaseAddress = (Bank1 * $4000)
	.var Bank1_BitmapAddress = Bank1_BaseAddress + (BitmapBank * $2000)
	.var Bank1_ScreenAddress = (Bank1_BaseAddress + (ScreenBank * $0400))
	.var Bank1_SpriteVals = Bank1_ScreenAddress + $3f8
	.var Bank1_SpriteAddress = Bank1_BaseAddress + TREASURE_FirstSpriteIndex * 64

	.var TREASURE_BitmapScrollData = $4800
	.var TREASURE_ScreenScrollData = $9000

	.var TREASURESPRITEDOTTEDLINE_Init = TreasureMap_SpriteDottedLine_BASE + 0
	.var TREASURESPRITEDOTTEDLINE_DrawSprites = TreasureMap_SpriteDottedLine_BASE + 3
	.var TREASURESPRITEDOTTEDLINE_AddNewDot = TreasureMap_SpriteDottedLine_BASE + 6
	.var TREASURESPRITEDOTTEDLINE_ExtraSprites = TreasureMap_SpriteDottedLine_BASE + 9

//; TREASURE_LocalData -------------------------------------------------------------------------------------------------------
TREASURE_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,				LoPtr,									HiPtr
		.byte	$80,			$10,				<TREASURE_IRQ_VBlank,					>TREASURE_IRQ_VBlank
	IRQList_ExtraSprites0:
		.byte	$ff,			$fc,				<TREASURE_ExtraSprites,					>TREASURE_ExtraSprites
	IRQList_ExtraSprites1:
		.byte	$ff,			$fc,				<TREASURE_ExtraSprites,					>TREASURE_ExtraSprites
		.byte	$ff

	TREASURE_DoubleBufferDD02:
		.byte Bank1 + 60
		.byte Bank0 + 60

	.print "* $" + toHexString(TREASURE_LocalData) + "-$" + toHexString(EndTREASURE_LocalData - 1) + " TREASURE_LocalData"
EndTREASURE_LocalData:

//; TREASURE_Init() -------------------------------------------------------------------------------------------------------
TREASURE_Init:

		jsr TREASURESPRITEDOTTEDLINE_Init

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
 		sta VIC_ScreenColour
		sta VIC_SpriteEnable
		sta VIC_SpriteMulticolourMode

		lda #(ScreenBank * 16) + (BitmapBank * 8)
		sta VIC_D018

		lda #$08
		sta VIC_D016

		ldx #$07
		lda #$0a
	TREASURE_SetSpriteColours:
		sta VIC_Sprite0Colour, x
		dex
		bpl TREASURE_SetSpriteColours

		lda #$00
		tay
		ldx #$04
	TREASURE_ClearSpriteLoop:
		sta Bank0_SpriteAddress, y
		sta Bank1_SpriteAddress, y
		iny
		bne TREASURE_ClearSpriteLoop
		inc TREASURE_ClearSpriteLoop + 2
		inc TREASURE_ClearSpriteLoop + 5
		dex
		bne TREASURE_ClearSpriteLoop

		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		
		cli
		rts

		.print "* $" + toHexString(TREASURE_Init) + "-$" + toHexString(EndTREASURE_Init - 1) + " TREASURE_Init"
EndTREASURE_Init:

//; TREASURE_End() -------------------------------------------------------------------------------------------------------
TREASURE_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(TREASURE_End) + "-$" + toHexString(EndTREASURE_End - 1) + " TREASURE_End"
EndTREASURE_End:

//; TREASURE_ScrollBitmap() -------------------------------------------------------------------------------------------------------
TREASURE_ScrollBitmap:

		lda TREASURE_DoubleBufferFrame + 1
		beq TREASURE_Copy0To1
		jmp TREASURE_Copy1To0
	TREASURE_DontScrollBitmap:
		rts
		
	//; 1st Buffer
	TREASURE_Copy0To1:

		//; Scroll Bitmap (Part 1)
		ldy #$00
	TREASURE_Loop_Bitmap_0To1:
		.for(var YVal = 23; YVal >= 0; YVal--)
		{
			lda Bank0_BitmapAddress + ((YVal + 0) * 40) * 8, y
			sta Bank1_BitmapAddress + ((YVal + 1) * 40) * 8, y
			lda Bank0_BitmapAddress + ((YVal + 0) * 40) * 8 + (20 * 8), y
			sta Bank1_BitmapAddress + ((YVal + 1) * 40) * 8 + (20 * 8), y
		}
		iny
		cpy #(20 * 8)
		beq TREASURE_Loop_Bitmap_0To1_FIN
		jmp TREASURE_Loop_Bitmap_0To1
	TREASURE_Loop_Bitmap_0To1_FIN:

		//; Scroll Screen
		ldy #$00
	TREASURE_Loop_Screen_0To1:
		.for(var YVal = 23; YVal >= 0; YVal--)
		{
			lda Bank0_ScreenAddress + ((YVal + 0) * 40), y
			sta Bank1_ScreenAddress + ((YVal + 1) * 40), y
		}
		iny
		cpy #40
		beq TREASURE_Loop_Screen_0To1_FIN
		jmp TREASURE_Loop_Screen_0To1
	TREASURE_Loop_Screen_0To1_FIN:

		//; Add New Bitmap Data
	TREASURE_ScrollIndex:
		ldx #$00
		.for(var XCharVal = 0; XCharVal < 40; XCharVal++)
		{
			.for(var PixelVal = 0; PixelVal < 8; PixelVal++)
			{
				lda TREASURE_BitmapScrollData + ((XCharVal * 8) + PixelVal) * 50, x
				sta Bank1_BitmapAddress + XCharVal * 8 + PixelVal
			}
			lda TREASURE_ScreenScrollData + (XCharVal * 50), x
			sta Bank1_ScreenAddress + XCharVal
		}
		inc TREASURE_ScrollIndex + 1

		rts

	//; 2nd Buffer
	TREASURE_Copy1To0:

		//; Scroll Bitmap (Part 1)
		ldy #$00
	TREASURE_Loop_Bitmap_1To0:
		.for(var YVal = 23; YVal >= 0; YVal--)
		{
			lda Bank1_BitmapAddress + ((YVal + 0) * 40) * 8, y
			sta Bank0_BitmapAddress + ((YVal + 1) * 40) * 8, y
			lda Bank1_BitmapAddress + ((YVal + 0) * 40) * 8 + (20 * 8), y
			sta Bank0_BitmapAddress + ((YVal + 1) * 40) * 8 + (20 * 8), y
		}
		iny
		cpy #(20 * 8)
		beq TREASURE_Loop_Bitmap_1To0_FIN
		jmp TREASURE_Loop_Bitmap_1To0
	TREASURE_Loop_Bitmap_1To0_FIN:

		//; Scroll Screen
		ldy #$00
	TREASURE_Loop_Screen_1To0:
		.for(var YVal = 23; YVal >= 0; YVal--)
		{
			lda Bank1_ScreenAddress + ((YVal + 0) * 40), y
			sta Bank0_ScreenAddress + ((YVal + 1) * 40), y
		}
		iny
		cpy #40
		beq TREASURE_Loop_Screen_1To0_FIN
		jmp TREASURE_Loop_Screen_1To0
	TREASURE_Loop_Screen_1To0_FIN:

		//; Add New Bitmap Data
		ldx TREASURE_ScrollIndex + 1
		.for(var XCharVal = 0; XCharVal < 40; XCharVal++)
		{
			.for(var PixelVal = 0; PixelVal < 8; PixelVal++)
			{
				lda TREASURE_BitmapScrollData + ((XCharVal * 8) + PixelVal) * 50, x
				sta Bank0_BitmapAddress + XCharVal * 8 + PixelVal
			}
			lda TREASURE_ScreenScrollData + (XCharVal * 50), x
			sta Bank0_ScreenAddress + XCharVal
		}
		inc TREASURE_ScrollIndex + 1

		rts
		
		.print "* $" + toHexString(TREASURE_ScrollBitmap) + "-$" + toHexString(EndTREASURE_ScrollBitmap - 1) + " TREASURE_ScrollBitmap"
EndTREASURE_ScrollBitmap:

//; TREASURE_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
TREASURE_IRQ_VBlank:

		:Start_ShowTiming(0)
		
		:IRQManager_BeginIRQ(0, 0)

		lda FrameOf256
		and #$0f
		sta FrameOf16
		and #$07
		sta FrameOf8
		and #$01
		sta FrameOf2

		jsr Music_Play

	TREASURE_DoScroll:
		lda FrameOf16
		lsr
		ora #$30
 		sta VIC_D011

		lda FrameOf16
		bne TREASURE_DontFlipBuffer

	TREASURE_DoubleBufferFrame:
		lda #$00
		tax
		eor #$01
		sta TREASURE_DoubleBufferFrame + 1

		lda TREASURE_DoubleBufferDD02, x
		sta VIC_DD02

		inc Signal_CustomSignal0	//; We can start prepping the next screen immediately
	TREASURE_DontFlipBuffer:

		jsr TREASURESPRITEDOTTEDLINE_DrawSprites

		cpy #$ff
		bne TREASURE_MoreSpritesToDraw

		:IRQManager_SetIRQIndex(0)
		lda #$ff

	TREASURE_MoreSpritesToDraw:
		sta IRQList_ExtraSprites0 + 1
		lda #$00
		sta IRQList_ExtraSprites0 + 0
	TREASURE_NoMoreSpritesToDraw:

		lda Signal_CustomSignal1
		bne TREASURE_Skip256Counter

		jsr TREASURESPRITEDOTTEDLINE_AddNewDot

		inc FrameOf256
		bne TREASURE_Skip256Counter
		inc Frame_256Counter
	TREASURE_Skip256Counter:

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		:Stop_ShowTiming(0)
		
		rti

		.print "* $" + toHexString(TREASURE_IRQ_VBlank) + "-$" + toHexString(EndTREASURE_IRQ_VBlank - 1) + " TREASURE_IRQ_VBlank"
EndTREASURE_IRQ_VBlank:

TREASURE_ExtraSprites:

		:Start_ShowTiming(0)
		
		:IRQManager_BeginIRQ(0, 0)

		jsr TREASURESPRITEDOTTEDLINE_ExtraSprites

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		:Stop_ShowTiming(0)
		
		rti

		.print "* $" + toHexString(TREASURE_ExtraSprites) + "-$" + toHexString(EndTREASURE_ExtraSprites - 1) + " TREASURE_ExtraSprites"
EndTREASURE_ExtraSprites:
