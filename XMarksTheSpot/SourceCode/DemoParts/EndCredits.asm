//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = EndCredits_BASE "End Credits"

//; Common Code: $0000-0fff
//; Music: $1000-2fff
//; BitmapData A: $3000-39ff
//; BitmapData B: $3a00-43ff
//; This Code: $4400-75ff
//; Scrolltext: $7600-7fff
//; Sprites 0: $8000-86ff
//; Screen 0: $8c00-$8fe7
//; Font: $9000-93ff
//; Bitmap 0: $a000-$bfff
//; Sprites 1: $c000-c6ff
//; Screen 1: $cc00-$cfe7
//; Bitmap 1: $e000-$ffff

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $60, $60					//; Pre-Init
		jmp END_Init						//; Init
		.byte $60, $60, $60					//; MainThreadFunc
		.byte $60, $60, $60					//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff

	.var BaseBankAddress0 = (BaseBank0 * $4000)
	.var BaseBankAddress1 = (BaseBank1 * $4000)

	.var ScreenBank = 3 //; 3=Bank+[0c00,0fff]
	.var ScreenAddress0 = (BaseBankAddress0 + (ScreenBank * $0400))
	.var ScreenAddress1 = (BaseBankAddress1 + (ScreenBank * $0400))
	
	.var SPRITE0_Val0 = ScreenAddress0 + $3f8
	.var SPRITE1_Val0 = SPRITE0_Val0 + 1
	.var SPRITE2_Val0 = SPRITE0_Val0 + 2
	.var SPRITE3_Val0 = SPRITE0_Val0 + 3
	.var SPRITE4_Val0 = SPRITE0_Val0 + 4
	.var SPRITE5_Val0 = SPRITE0_Val0 + 5
	.var SPRITE6_Val0 = SPRITE0_Val0 + 6
	.var SPRITE7_Val0 = SPRITE0_Val0 + 7
	.var SPRITE0_Val1 = ScreenAddress1 + $3f8
	.var SPRITE1_Val1 = SPRITE0_Val1 + 1
	.var SPRITE2_Val1 = SPRITE0_Val1 + 2
	.var SPRITE3_Val1 = SPRITE0_Val1 + 3
	.var SPRITE4_Val1 = SPRITE0_Val1 + 4
	.var SPRITE5_Val1 = SPRITE0_Val1 + 5
	.var SPRITE6_Val1 = SPRITE0_Val1 + 6
	.var SPRITE7_Val1 = SPRITE0_Val1 + 7

	.var BitmapBank = 1 //; 1=Bank+[2000,3fff]
	.var BitmapAddress0 = BaseBankAddress0 + (BitmapBank * $2000)
	.var BitmapAddress1 = BaseBankAddress1 + (BitmapBank * $2000)
	
	.var END_SegmentData_Bitmap_A = $3000
	.var END_SegmentData_Bitmap_B = $3a00

	.var SEGMENT_SIZE_BITMAPDATA = 4
	
	.var StartSpriteIndex = 0
	.var SpriteDataAddress0 = BaseBankAddress0 + (StartSpriteIndex * 64)
	.var SpriteDataAddress1 = BaseBankAddress1 + (StartSpriteIndex * 64)

	.var UPSCROLL_ScrollText = $7600
	.var UPSCROLL_Font = $9000
	.var UPSCROLL_ScrollTextStride = 192
	.var UPSCROLL_SPRITEYWRITEOFFSET = 2

//; END_LocalData -------------------------------------------------------------------------------------------------------
END_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,				LoPtr,							HiPtr
		.byte	$00,			$f8,				<UPSCROLL_IRQ_VBlank,			>UPSCROLL_IRQ_VBlank
		.byte	$00,			82 + (21 * 1),		<UPSCROLL_IRQ_SpritePlex0,		>UPSCROLL_IRQ_SpritePlex0
		.byte	$00,			82 + (21 * 2),		<UPSCROLL_IRQ_SpritePlex1,		>UPSCROLL_IRQ_SpritePlex1
		.byte	$00,			82 + (21 * 3),		<UPSCROLL_IRQ_SpritePlex2,		>UPSCROLL_IRQ_SpritePlex2
		.byte	$00,			82 + (21 * 4),		<UPSCROLL_IRQ_SpritePlex3,		>UPSCROLL_IRQ_SpritePlex3
		.byte	$00,			82 + (21 * 5),		<UPSCROLL_IRQ_SpritePlex4,		>UPSCROLL_IRQ_SpritePlex4
		.byte	$00,			82 + (21 * 6),		<UPSCROLL_IRQ_SpritePlexFINAL,	>UPSCROLL_IRQ_SpritePlexFINAL
		.byte	$ff

	END_MultiplyMod160:
		.byte   0,  11,  22,  33,  44,  55,  66,  77,  88, 100, 112, 124, 136, 148, 160
	END_MultiplyMod38:
		.byte   0,   3,   6,   9,  12,  15,  18,  21,  24,  27,  30,  32,  34,  36,  38
	END_Mul10:
		.byte (0 * 10)
		.byte (1 * 10)
		.byte (2 * 10)
		.byte (3 * 10)
		.byte (4 * 10)
		.byte (5 * 10)
		.byte (6 * 10)
		.byte (7 * 10)

	UPSCROLL_SpriteLineYPositions:
		.byte 82 + (21 * 0)
		.byte 82 + (21 * 1)
		.byte 82 + (21 * 2)
		.byte 82 + (21 * 3)
		.byte 82 + (21 * 4)
		.byte 82 + (21 * 5)
		
	UPSCROLL_ScrollPosition:
		.byte $00

	UPSCROLL_SpriteLineVals:
		.byte StartSpriteIndex + (0 * 4)
		.byte StartSpriteIndex + (1 * 4)
		.byte StartSpriteIndex + (2 * 4)
		.byte StartSpriteIndex + (3 * 4)
		.byte StartSpriteIndex + (4 * 4)
		.byte StartSpriteIndex + (5 * 4)
		
		.byte StartSpriteIndex + (0 * 4)
		.byte StartSpriteIndex + (1 * 4)
		.byte StartSpriteIndex + (2 * 4)
		.byte StartSpriteIndex + (3 * 4)
		.byte StartSpriteIndex + (4 * 4)
		.byte StartSpriteIndex + (5 * 4)
		
	.print "* $" + toHexString(END_LocalData) + "-$" + toHexString(EndEND_LocalData - 1) + " END_LocalData"
EndEND_LocalData:

//; END_Init() -------------------------------------------------------------------------------------------------------
END_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
		ldy #$08
		ldx #$00
	END_ClearSpriteLoop:
		sta SpriteDataAddress0, x
		sta SpriteDataAddress1, x
		inx
		bne END_ClearSpriteLoop
		inc END_ClearSpriteLoop + 2
		inc END_ClearSpriteLoop + 5
		dey
		bne END_ClearSpriteLoop

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight

		lda #$07
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

		lda #$0f
		sta FrameOf16

		lda #$88
		sta VIC_Sprite0X
		sta VIC_Sprite4X
		clc
		adc #$18
		sta VIC_Sprite1X
		sta VIC_Sprite5X
		clc
		adc #$18
		sta VIC_Sprite2X
		sta VIC_Sprite6X
		clc
		adc #$18
		sta VIC_Sprite3X
		sta VIC_Sprite7X

		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()
		
		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(END_Init) + "-$" + toHexString(EndEND_Init - 1) + " END_Init"
EndEND_Init:

//; END_crollColour() -------------------------------------------------------------------------------------------------------
END_ScrollColour:
		.for(var BlockIndex = 0; BlockIndex < 24; BlockIndex++)
		{
			.for(var XVal = 0; XVal < 38; XVal++)
			{
				lda VIC_ColourMemory + BlockIndex * 40 + XVal + 41
				sta VIC_ColourMemory + BlockIndex * 40 + XVal
			}
		}

		ldx END_ScrollPositionModBITMAP + 1
		ldy END_Mul10, x

		lda END_AOrB + 1
		beq END_COLSETA
		jmp END_COLSETB
		
	END_COLSETA:

		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_A + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)) + 9, y
			sta VIC_ColourMemory + 38 + BlockIndexY * 40
		}

		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_A + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)) + 9, y
			sta VIC_ColourMemory + 24 * 40 + BlockIndexX
		}

		rts
		
	END_COLSETB:

		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_B + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)) + 9, y
			sta VIC_ColourMemory + 38 + BlockIndexY * 40
		}

		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_B + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)) + 9, y
			sta VIC_ColourMemory + 24 * 40 + BlockIndexX
		}

		rts

		.print "* $" + toHexString(END_ScrollColour) + "-$" + toHexString(EndEND_ScrollColour - 1) + " END_ScrollColour"
EndEND_ScrollColour:

//; END_ScrollBitmap() -------------------------------------------------------------------------------------------------------
END_ScrollBitmap:
		ldy FrameOf16
		cpy #$0e
		bcc END_NotLastFrame
		cpy #$0e
		beq END_Frame14
		rts
		
	END_Frame14:
		lda END_DoubleBufferFrame + 1
		beq END_AND1
	END_AOrB:
		lda #$00
		bne END_AND0B
	END_AND0A:
		jmp END_AddNewData0_A
	END_AND0B:
		jmp END_AddNewData0_B
	END_AND1:
		lda END_AOrB + 1
		bne END_AND1B
	END_AND1A:
		jmp END_AddNewData1_A
	END_AND1B:
		jmp END_AddNewData1_B
	
	END_NotLastFrame:
		lda END_DoubleBufferFrame + 1
		bne END_CB_Copy0To1
		jmp END_CB_Copy1To0
		
	//; 1st Buffer
		
	END_CB_Copy0To1:
		lda END_MultiplyMod160, y
		sta END_CB_Copy0To1_InitialY + 1
		lda END_MultiplyMod160 + 1, y
		sta END_CB_Copy0To1_CPY + 1
		lda END_MultiplyMod38, y
		sta END_CB_Copy0To1_Screen_InitialY + 1
		lda END_MultiplyMod38 + 1, y
		sta END_CB_Copy0To1_Screen_CPY + 1

	END_CB_Copy0To1_InitialY:
		ldy #$00
	END_CB_Loop_0To1Bitmap:
		.for(var BlockIndex = 0; BlockIndex < (24 * 2); BlockIndex++)
		{
			lda BitmapAddress0 + BlockIndex * 20 * 8 + (41 * 8), y
			sta BitmapAddress1 + BlockIndex * 20 * 8, y
		}
		iny
	END_CB_Copy0To1_CPY:
		cpy #20 * 8
		beq END_CB_Copy0To1_FinishedBitmap
		jmp END_CB_Loop_0To1Bitmap
	END_CB_Copy0To1_FinishedBitmap:

	END_CB_Copy0To1_Screen_InitialY:
		ldy #$00
	END_CB_Loop_0To1Screen:
		.for(var BlockIndex = 0; BlockIndex < 24; BlockIndex++)
		{
			lda ScreenAddress0 + BlockIndex * 40 + 41, y
			sta ScreenAddress1 + BlockIndex * 40, y
		}
		iny
	END_CB_Copy0To1_Screen_CPY:
		cpy #38
		beq END_CB_Copy0To1_FinishedScreen
		jmp END_CB_Loop_0To1Screen
	END_CB_Copy0To1_FinishedScreen:
		rts

	//; 2nd Buffer
		
	END_CB_Copy1To0:
		lda END_MultiplyMod160, y
		sta END_CB_Copy1To0_InitialY + 1
		lda END_MultiplyMod160 + 1, y
		sta END_CB_Copy1To0_CPY + 1
		lda END_MultiplyMod38, y
		sta END_CB_Copy1To0_Screen_InitialY + 1
		lda END_MultiplyMod38 + 1, y
		sta END_CB_Copy1To0_Screen_CPY + 1

	END_CB_Copy1To0_InitialY:
		ldy #$00
	END_CB_Loop_1To0Bitmap:
		.for(var BlockIndex =0; BlockIndex < (24 * 2); BlockIndex++)
		{
			lda BitmapAddress1 + BlockIndex * 20 * 8 + (41 * 8), y
			sta BitmapAddress0 + BlockIndex * 20 * 8, y
		}
		iny
	END_CB_Copy1To0_CPY:
		cpy #20 * 8
		beq END_CB_Copy1To0_FinishedBitmap
		jmp END_CB_Loop_1To0Bitmap
	END_CB_Copy1To0_FinishedBitmap:

	END_CB_Copy1To0_Screen_InitialY:
		ldy #$00
	END_CB_Loop_1To0Screen:
		.for(var BlockIndex = 0; BlockIndex < 24; BlockIndex++)
		{
			lda ScreenAddress1 + BlockIndex * 40 + 41, y
			sta ScreenAddress0 + BlockIndex * 40, y
		}
		iny
	END_CB_Copy1To0_Screen_CPY:
		cpy #38
		beq END_CB_Copy1To0_FinishedScreen
		jmp END_CB_Loop_1To0Screen
	END_CB_Copy1To0_FinishedScreen:
		rts
		
		.print "* $" + toHexString(END_ScrollBitmap) + "-$" + toHexString(EndEND_ScrollBitmap - 1) + " END_ScrollBitmap"
EndEND_ScrollBitmap:

END_AddNewData0_A:
		
		ldx END_ScrollPositionModBITMAP + 1
		ldy END_Mul10, x

		ldx #$00

	END_AddNewData0_A_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_A + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress0 + ((24 * 40) + BlockIndexX) * 8, x
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_A + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress0 + (BlockIndexY * 40 + 38) * 8, x
		}
		iny
		inx
		cpx #$08
		beq END_AddNewData0_A_Finished
		jmp END_AddNewData0_A_Loop
	END_AddNewData0_A_Finished:
		
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_A + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress0 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_A + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress0 + 38 + BlockIndexY * 40
		}

		rts

		.print "* $" + toHexString(END_AddNewData0_A) + "-$" + toHexString(EndEND_AddNewData0_A - 1) + " END_AddNewData0_A"
EndEND_AddNewData0_A:

END_AddNewData0_B:
		
		ldx END_ScrollPositionModBITMAP + 1
		ldy END_Mul10, x

		ldx #$00

	END_AddNewData0_B_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_B + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress0 + ((24 * 40) + BlockIndexX) * 8, x
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_B + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress0 + (BlockIndexY * 40 + 38) * 8, x
		}
		iny
		inx
		cpx #$08
		beq END_AddNewData0_B_Finished
		jmp END_AddNewData0_B_Loop
	END_AddNewData0_B_Finished:
		
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_B + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress0 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_B + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress0 + 38 + BlockIndexY * 40
		}

		rts

		.print "* $" + toHexString(END_AddNewData0_B) + "-$" + toHexString(EndEND_AddNewData0_B - 1) + " END_AddNewData0_B"
EndEND_AddNewData0_B:

END_AddNewData1_A:
		
		ldx END_ScrollPositionModBITMAP + 1
		ldy END_Mul10, x

		ldx #$00

	END_AddNewData1_A_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_A + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress1 + ((24 * 40) + BlockIndexX) * 8, x
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_A + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress1 + (BlockIndexY * 40 + 38) * 8, x
		}
		iny
		inx
		cpx #$08
		beq END_AddNewData1_A_Finished
		jmp END_AddNewData1_A_Loop
	END_AddNewData1_A_Finished:
		
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_A + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress1 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_A + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress1 + 38 + BlockIndexY * 40
		}
		rts

		.print "* $" + toHexString(END_AddNewData1_A) + "-$" + toHexString(EndEND_AddNewData1_A - 1) + " END_AddNewData1_A"
EndEND_AddNewData1_A:

END_AddNewData1_B:
		
		ldx END_ScrollPositionModBITMAP + 1
		ldy END_Mul10, x

		ldx #$00

	END_AddNewData1_B_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_B + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress1 + ((24 * 40) + BlockIndexX) * 8, x
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_B + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta BitmapAddress1 + (BlockIndexY * 40 + 38) * 8, x
		}
		iny
		inx
		cpx #$08
		beq END_AddNewData1_B_Finished
		jmp END_AddNewData1_B_Loop
	END_AddNewData1_B_Finished:
		
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Bitmap_B + (BlockIndexX * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress1 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Bitmap_B + ((39 + BlockIndexY) * (SEGMENT_SIZE_BITMAPDATA * 10)), y
			sta ScreenAddress1 + 38 + BlockIndexY * 40
		}
		rts

		.print "* $" + toHexString(END_AddNewData1_B) + "-$" + toHexString(EndEND_AddNewData1_B - 1) + " END_AddNewData1_B"
EndEND_AddNewData1_B:

//; UPSCROLL_IRQ_SpritePlex0() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex0:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

		nop
		nop
		nop
		nop
		nop
		nop
		lda #$00
		sta VIC_SpriteXMSB
		
		lda UPSCROLL_SpriteLineYPositions + 2
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex0) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex0 - 1) + " UPSCROLL_IRQ_SpritePlex0"
EndUPSCROLL_IRQ_SpritePlex0:

//; UPSCROLL_IRQ_SpritePlex1() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex1:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 2, y
		stx SPRITE0_Val0
		stx SPRITE0_Val1
		inx
		stx SPRITE1_Val0
		stx SPRITE1_Val1
		inx
		stx SPRITE2_Val0
		stx SPRITE2_Val1
		inx
		stx SPRITE3_Val0
		stx SPRITE3_Val1

		lda UPSCROLL_SpriteLineYPositions + 3
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex1) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex1 - 1) + " UPSCROLL_IRQ_SpritePlex1"
EndUPSCROLL_IRQ_SpritePlex1:

//; UPSCROLL_IRQ_SpritePlex2() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex2:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)

		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 3, y
		stx SPRITE4_Val0
		stx SPRITE4_Val1
		inx
		stx SPRITE5_Val0
		stx SPRITE5_Val1
		inx
		stx SPRITE6_Val0
		stx SPRITE6_Val1
		inx
		stx SPRITE7_Val0
		stx SPRITE7_Val1

		lda UPSCROLL_SpriteLineYPositions + 4
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex2) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex2 - 1) + " UPSCROLL_IRQ_SpritePlex2"
EndUPSCROLL_IRQ_SpritePlex2:

//; UPSCROLL_IRQ_SpritePlex3() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex3:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)

		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 4, y
		stx SPRITE0_Val0
		stx SPRITE0_Val1
		inx
		stx SPRITE1_Val0
		stx SPRITE1_Val1
		inx
		stx SPRITE2_Val0
		stx SPRITE2_Val1
		inx
		stx SPRITE3_Val0
		stx SPRITE3_Val1
		
		lda UPSCROLL_SpriteLineYPositions + 5
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex3) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex3 - 1) + " UPSCROLL_IRQ_SpritePlex3"
EndUPSCROLL_IRQ_SpritePlex3:

//; UPSCROLL_IRQ_SpritePlex4() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex4:

		:IRQManager_BeginIRQ(0, 0)
		
		:Start_ShowTiming(0)

		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 5, y
		stx SPRITE4_Val0
		stx SPRITE4_Val1
		inx
		stx SPRITE5_Val0
		stx SPRITE5_Val1
		inx
		stx SPRITE6_Val0
		stx SPRITE6_Val1
		inx
		stx SPRITE7_Val0
		stx SPRITE7_Val1

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex4) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex4 - 1) + " UPSCROLL_IRQ_SpritePlex4"
EndUPSCROLL_IRQ_SpritePlex4:

//; UPSCROLL_IRQ_SpritePlexFINAL() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlexFINAL:
		
		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)

		lda #$ff
		sta VIC_SpriteXMSB
		sta VIC_SpriteEnable

		jsr Music_Play
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlexFINAL) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlexFINAL - 1) + " UPSCROLL_IRQ_SpritePlexFINAL"
EndUPSCROLL_IRQ_SpritePlexFINAL:

//; UPSCROLL_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_VBlank:
		
		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)

		lda FrameOf16
		lsr
		and #$07
		ora #$30
 		sta VIC_D011
		eor #$20
 		sta VIC_D016

		jsr UPSCROLL_SetSpriteYPositions
		
		lda FrameOf16
		cmp #$0f
		bne END_DontFlipBuffer
	END_DoubleBufferFrame:
		lda #$00
		eor #$01
		sta END_DoubleBufferFrame + 1
		ora #$3e
		sta VIC_DD02
	END_DontFlipBuffer:
		
		lda UPSCROLL_SpriteLineYPositions + 0
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		lda UPSCROLL_SpriteLineYPositions + 1
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 0, y
		stx SPRITE0_Val0
		stx SPRITE0_Val1
		inx
		stx SPRITE1_Val0
		stx SPRITE1_Val1
		inx
		stx SPRITE2_Val0
		stx SPRITE2_Val1
		inx
		stx SPRITE3_Val0
		stx SPRITE3_Val1
		ldx UPSCROLL_SpriteLineVals + 1, y
		stx SPRITE4_Val0
		stx SPRITE4_Val1
		inx
		stx SPRITE5_Val0
		stx SPRITE5_Val1
		inx
		stx SPRITE6_Val0
		stx SPRITE6_Val1
		inx
		stx SPRITE7_Val0
		stx SPRITE7_Val1

		lda FrameOf16
		cmp #$0f
		bne END_DontScrollColour

	END_DontScrollColourOnFirstFrame:
		ldy #$01
		beq END_ScrollPositionModBITMAP
		dey
		sty END_DontScrollColourOnFirstFrame + 1
		jmp END_DontScrollColour
		
	END_ScrollPositionModBITMAP:
		ldy #$00
		iny
		cpy #SEGMENT_SIZE_BITMAPDATA
		bne END_ScrollPosGoodBITMAP

		inc Signal_SpindleLoadNextFile
		lda END_AOrB + 1
		eor #$01
		sta END_AOrB + 1
		ldy #$00
	END_ScrollPosGoodBITMAP:
		sty END_ScrollPositionModBITMAP + 1
		
		jsr END_ScrollColour
		
	END_DontScrollColour:
		jsr END_ScrollBitmap
		
		inc FrameOf256
		bne END_Skip256Counter
		inc Frame_256Counter
	END_Skip256Counter:

		lda FrameOf256
		and #$0f
		eor #$0f
		sta FrameOf16
	
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(UPSCROLL_IRQ_VBlank) + "-$" + toHexString(EndUPSCROLL_IRQ_VBlank - 1) + " UPSCROLL_IRQ_VBlank"
EndUPSCROLL_IRQ_VBlank:

UPSCROLL_SetSpriteYPositions:
		lda #$00
		sec
		sbc #$01
		bcs UPSCROLL_SetY_AllGood

		lda UPSCROLL_ScrollPosition
		clc
		adc #$01
		cmp #6
		bne UPSCROLL_DontLoopScroll
		lda #$00
	UPSCROLL_DontLoopScroll:
		sta UPSCROLL_ScrollPosition

		lda Frame_256Counter
		beq UPSCROLL_DontScrollTextYet

		inc UPSCROLL_ShouldFillCharLine + 1

		lda #$00
		sta UPSCROLL_FillCharLine_X + 1

		jsr UPSCROLL_FillNewCharLineInit
	UPSCROLL_DontScrollTextYet:
		
		lda #20
	UPSCROLL_SetY_AllGood:
		sta UPSCROLL_SetSpriteYPositions + 1

		clc
		adc #83
		sta UPSCROLL_SpriteLineYPositions + 0
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 1
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 2
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 3
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 4
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 5

	UPSCROLL_ShouldFillCharLine:
		lda #$00
		beq UPSCROLL_DontScrollCharLine
	UPSCROLL_FillCharLine_X:
		ldx #$00
 		jsr UPSCROLL_FillNewCharLine
		
		lda UPSCROLL_FillCharLine_X + 1
		clc
		adc #3
		cmp #12
		bne UPSCROLL_FillCharLine_NotFinished
		dec UPSCROLL_ShouldFillCharLine + 1
		lda #$00
	UPSCROLL_FillCharLine_NotFinished:
		sta UPSCROLL_FillCharLine_X + 1
	
	UPSCROLL_DontScrollCharLine:
		rts

		.print "* $" + toHexString(UPSCROLL_SetSpriteYPositions) + "-$" + toHexString(EndUPSCROLL_SetSpriteYPositions - 1) + " UPSCROLL_SetSpriteYPositions"
EndUPSCROLL_SetSpriteYPositions:

UPSCROLL_FillNewCharLineInit:
		ldy UPSCROLL_ScrollPosition
		
		lda UPSCROLL_SpriteLineVals + 5, y
		lsr
		lsr
		clc
	UPSCROLL_FNCLI_Bank:
		adc #>BaseBankAddress0

		sta UPSCROLL_SpriteOutputAddressA0_0 + 2
		sta UPSCROLL_SpriteOutputAddressA1_0 + 2
		sta UPSCROLL_SpriteOutputAddressA2_0 + 2
		sta UPSCROLL_SpriteOutputAddressA3_0 + 2
		sta UPSCROLL_SpriteOutputAddressB0_0 + 2
		sta UPSCROLL_SpriteOutputAddressB1_0 + 2
		sta UPSCROLL_SpriteOutputAddressB2_0 + 2
		sta UPSCROLL_SpriteOutputAddressB3_0 + 2
		sta UPSCROLL_SpriteOutputAddressC0_0 + 2
		sta UPSCROLL_SpriteOutputAddressC1_0 + 2
		sta UPSCROLL_SpriteOutputAddressC2_0 + 2
		sta UPSCROLL_SpriteOutputAddressC3_0 + 2
		sta UPSCROLL_SpriteOutputAddressD0_0 + 2
		sta UPSCROLL_SpriteOutputAddressD1_0 + 2
		sta UPSCROLL_SpriteOutputAddressD2_0 + 2
		sta UPSCROLL_SpriteOutputAddressD3_0 + 2
		sta UPSCROLL_SpriteOutputAddressE0_0 + 2
		sta UPSCROLL_SpriteOutputAddressE1_0 + 2
		sta UPSCROLL_SpriteOutputAddressE2_0 + 2
		sta UPSCROLL_SpriteOutputAddressE3_0 + 2
		sta UPSCROLL_SpriteOutputAddressF0_0 + 2
		sta UPSCROLL_SpriteOutputAddressF1_0 + 2
		sta UPSCROLL_SpriteOutputAddressF2_0 + 2
		sta UPSCROLL_SpriteOutputAddressF3_0 + 2
		sta UPSCROLL_SpriteOutputAddressG0_0 + 2
		sta UPSCROLL_SpriteOutputAddressG1_0 + 2
		sta UPSCROLL_SpriteOutputAddressG2_0 + 2
		sta UPSCROLL_SpriteOutputAddressG3_0 + 2
		sta UPSCROLL_SpriteOutputAddressH0_0 + 2
		sta UPSCROLL_SpriteOutputAddressH1_0 + 2
		sta UPSCROLL_SpriteOutputAddressH2_0 + 2
		sta UPSCROLL_SpriteOutputAddressH3_0 + 2
		sta UPSCROLL_SpriteOutputAddressI0_0 + 2
		sta UPSCROLL_SpriteOutputAddressI1_0 + 2
		sta UPSCROLL_SpriteOutputAddressI2_0 + 2
		sta UPSCROLL_SpriteOutputAddressI3_0 + 2
		sta UPSCROLL_SpriteOutputAddressJ0_0 + 2
		sta UPSCROLL_SpriteOutputAddressJ1_0 + 2
		sta UPSCROLL_SpriteOutputAddressJ2_0 + 2
		sta UPSCROLL_SpriteOutputAddressJ3_0 + 2
		sta UPSCROLL_SpriteOutputAddressK0_0 + 2
		sta UPSCROLL_SpriteOutputAddressK1_0 + 2
		sta UPSCROLL_SpriteOutputAddressK2_0 + 2
		sta UPSCROLL_SpriteOutputAddressK3_0 + 2
		sta UPSCROLL_SpriteOutputAddressL0_0 + 2
		sta UPSCROLL_SpriteOutputAddressL1_0 + 2
		sta UPSCROLL_SpriteOutputAddressL2_0 + 2
		sta UPSCROLL_SpriteOutputAddressL3_0 + 2
		
		and #$3f
		adc #>BaseBankAddress1
		sta UPSCROLL_SpriteOutputAddressA0_1 + 2
		sta UPSCROLL_SpriteOutputAddressA1_1 + 2
		sta UPSCROLL_SpriteOutputAddressA2_1 + 2
		sta UPSCROLL_SpriteOutputAddressA3_1 + 2
		sta UPSCROLL_SpriteOutputAddressB0_1 + 2
		sta UPSCROLL_SpriteOutputAddressB1_1 + 2
		sta UPSCROLL_SpriteOutputAddressB2_1 + 2
		sta UPSCROLL_SpriteOutputAddressB3_1 + 2
		sta UPSCROLL_SpriteOutputAddressC0_1 + 2
		sta UPSCROLL_SpriteOutputAddressC1_1 + 2
		sta UPSCROLL_SpriteOutputAddressC2_1 + 2
		sta UPSCROLL_SpriteOutputAddressC3_1 + 2
		sta UPSCROLL_SpriteOutputAddressD0_1 + 2
		sta UPSCROLL_SpriteOutputAddressD1_1 + 2
		sta UPSCROLL_SpriteOutputAddressD2_1 + 2
		sta UPSCROLL_SpriteOutputAddressD3_1 + 2
		sta UPSCROLL_SpriteOutputAddressE0_1 + 2
		sta UPSCROLL_SpriteOutputAddressE1_1 + 2
		sta UPSCROLL_SpriteOutputAddressE2_1 + 2
		sta UPSCROLL_SpriteOutputAddressE3_1 + 2
		sta UPSCROLL_SpriteOutputAddressF0_1 + 2
		sta UPSCROLL_SpriteOutputAddressF1_1 + 2
		sta UPSCROLL_SpriteOutputAddressF2_1 + 2
		sta UPSCROLL_SpriteOutputAddressF3_1 + 2
		sta UPSCROLL_SpriteOutputAddressG0_1 + 2
		sta UPSCROLL_SpriteOutputAddressG1_1 + 2
		sta UPSCROLL_SpriteOutputAddressG2_1 + 2
		sta UPSCROLL_SpriteOutputAddressG3_1 + 2
		sta UPSCROLL_SpriteOutputAddressH0_1 + 2
		sta UPSCROLL_SpriteOutputAddressH1_1 + 2
		sta UPSCROLL_SpriteOutputAddressH2_1 + 2
		sta UPSCROLL_SpriteOutputAddressH3_1 + 2
		sta UPSCROLL_SpriteOutputAddressI0_1 + 2
		sta UPSCROLL_SpriteOutputAddressI1_1 + 2
		sta UPSCROLL_SpriteOutputAddressI2_1 + 2
		sta UPSCROLL_SpriteOutputAddressI3_1 + 2
		sta UPSCROLL_SpriteOutputAddressJ0_1 + 2
		sta UPSCROLL_SpriteOutputAddressJ1_1 + 2
		sta UPSCROLL_SpriteOutputAddressJ2_1 + 2
		sta UPSCROLL_SpriteOutputAddressJ3_1 + 2
		sta UPSCROLL_SpriteOutputAddressK0_1 + 2
		sta UPSCROLL_SpriteOutputAddressK1_1 + 2
		sta UPSCROLL_SpriteOutputAddressK2_1 + 2
		sta UPSCROLL_SpriteOutputAddressK3_1 + 2
		sta UPSCROLL_SpriteOutputAddressL0_1 + 2
		sta UPSCROLL_SpriteOutputAddressL1_1 + 2
		sta UPSCROLL_SpriteOutputAddressL2_1 + 2
		sta UPSCROLL_SpriteOutputAddressL3_1 + 2
		
	UPSCROLL_ScrollTextPos:
		ldx #$00
		lda UPSCROLL_ScrollText + ( 0 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueA + 1
		lda UPSCROLL_ScrollText + ( 1 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueB + 1
		lda UPSCROLL_ScrollText + ( 2 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueC + 1
		lda UPSCROLL_ScrollText + ( 3 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueD + 1
		lda UPSCROLL_ScrollText + ( 4 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueE + 1
		lda UPSCROLL_ScrollText + ( 5 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueF + 1
		lda UPSCROLL_ScrollText + ( 6 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueG + 1
		lda UPSCROLL_ScrollText + ( 7 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueH + 1
		lda UPSCROLL_ScrollText + ( 8 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueI + 1
		lda UPSCROLL_ScrollText + ( 9 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueJ + 1
		lda UPSCROLL_ScrollText + (10 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueK + 1
		lda UPSCROLL_ScrollText + (11 * UPSCROLL_ScrollTextStride), x
		sta UPSCROLL_CharValueL + 1

		inx

		lda UPSCROLL_ScrollText + ( 0 * UPSCROLL_ScrollTextStride), x
		cmp #$ff
		bne UPSCROLL_NotEndOfScrollText

		inc Signal_CurrentEffectIsFinished
		dex
	UPSCROLL_NotEndOfScrollText:
		stx UPSCROLL_ScrollTextPos + 1
		
		rts

		.print "* $" + toHexString(UPSCROLL_FillNewCharLineInit) + "-$" + toHexString(EndUPSCROLL_FillNewCharLineInit - 1) + " UPSCROLL_FillNewCharLineInit"
EndUPSCROLL_FillNewCharLineInit:
		
UPSCROLL_FillNewCharLine:
	//; 1st char
	UPSCROLL_CharValueA:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressA0_0:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressA0_1:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressA1_0:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressA1_1:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressA2_0:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressA2_1:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressA3_0:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressA3_1:
		sta $ff00 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueA + 1

	//; 2nd char
	UPSCROLL_CharValueB:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressB0_0:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressB0_1:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressB1_0:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressB1_1:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressB2_0:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressB2_1:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressB3_0:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressB3_1:
		sta $ff01 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueB + 1

	//; 3rd char
	UPSCROLL_CharValueC:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressC0_0:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressC0_1:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressC1_0:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressC1_1:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressC2_0:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressC2_1:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressC3_0:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressC3_1:
		sta $ff02 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueC + 1

	//; 4th char
	UPSCROLL_CharValueD:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressD0_0:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressD0_1:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressD1_0:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressD1_1:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressD2_0:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressD2_1:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressD3_0:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressD3_1:
		sta $ff40 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueD + 1

	//; 5th char
	UPSCROLL_CharValueE:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressE0_0:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressE0_1:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressE1_0:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressE1_1:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressE2_0:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressE2_1:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressE3_0:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressE3_1:
		sta $ff41 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueE + 1

	//; 6th char
	UPSCROLL_CharValueF:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressF0_0:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressF0_1:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressF1_0:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressF1_1:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressF2_0:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressF2_1:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressF3_0:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressF3_1:
		sta $ff42 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueF + 1

	//; 7th char
	UPSCROLL_CharValueG:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressG0_0:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressG0_1:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressG1_0:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressG1_1:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressG2_0:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressG2_1:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressG3_0:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressG3_1:
		sta $ff80 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueG + 1

	//; 8th char
	UPSCROLL_CharValueH:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressH0_0:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressH0_1:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressH1_0:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressH1_1:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressH2_0:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressH2_1:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressH3_0:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressH3_1:
		sta $ff81 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueH + 1

	//; 9th char
	UPSCROLL_CharValueI:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressI0_0:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressI0_1:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressI1_0:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressI1_1:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressI2_0:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressI2_1:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressI3_0:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressI3_1:
		sta $ff82 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueI + 1

	//; 10th char
	UPSCROLL_CharValueJ:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressJ0_0:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressJ0_1:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressJ1_0:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressJ1_1:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressJ2_0:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressJ2_1:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressJ3_0:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressJ3_1:
		sta $ffc0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueJ + 1

	//; 11th char
	UPSCROLL_CharValueK:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressK0_0:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressK0_1:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressK1_0:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressK1_1:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressK2_0:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressK2_1:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressK3_0:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressK3_1:
		sta $ffc1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueK + 1

	//; 12th char
	UPSCROLL_CharValueL:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256), y
	UPSCROLL_SpriteOutputAddressL0_0:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
	UPSCROLL_SpriteOutputAddressL0_1:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3, x
		lda UPSCROLL_Font + (1 * 256), y
	UPSCROLL_SpriteOutputAddressL1_0:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
	UPSCROLL_SpriteOutputAddressL1_1:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3, x
		lda UPSCROLL_Font + (2 * 256), y
	UPSCROLL_SpriteOutputAddressL2_0:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
	UPSCROLL_SpriteOutputAddressL2_1:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3, x
		lda UPSCROLL_Font + (3 * 256), y
	UPSCROLL_SpriteOutputAddressL3_0:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
	UPSCROLL_SpriteOutputAddressL3_1:
		sta $ffc2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3, x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueL + 1
		
		rts

		.print "* $" + toHexString(UPSCROLL_FillNewCharLine) + "-$" + toHexString(EndUPSCROLL_FillNewCharLine - 1) + " UPSCROLL_FillNewCharLine"
EndUPSCROLL_FillNewCharLine:
