//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank0 = 0 //; 0=c000-ffff
	.var BaseBank1 = 1 //; 1=8000-bfff

	.var BaseBankAddress0 = $c000 - (BaseBank0 * $4000)
	.var BaseBankAddress1 = $c000 - (BaseBank1 * $4000)

	.var ScreenBank = 3 //; 3=Bank+[0c00,0fff]
	.var ScreenAddress0 = (BaseBankAddress0 + (ScreenBank * $0400))
	.var ScreenAddress1 = (BaseBankAddress1 + (ScreenBank * $0400))

	.var BitmapBank = 1 //; 1=Bank+[2000,3fff]
	.var BitmapAddress0 = BaseBankAddress0 + (BitmapBank * $2000)
	.var BitmapAddress1 = BaseBankAddress1 + (BitmapBank * $2000)
	
	.var END_SegmentData_Bitmap = $2100
	.var END_SegmentData_Colour = $8000
	.var END_SegmentData_Screen = $c000

* = EndCredits_BASE "End Credits"

	JumpTable:
		jmp END_Init
		jmp IRQManager_RestoreDefaultIRQ
		jmp END_MainThread
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; END_LocalData -------------------------------------------------------------------------------------------------------
END_LocalData:
	.var IRQNum = 2
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$f7,			<END_IRQ_VBlank,			>END_IRQ_VBlank
		.byte	$00,			$90,			<END_IRQ_ScrollColour,		>END_IRQ_ScrollColour

END_InitialFrameFlicker:
	.byte $30, $00, $00, $00, $00, $00
	.byte $30, $00, $00, $00
	.byte $30, $00, $00
	.byte $30, $00
	.byte $30
	
	.print "* $" + toHexString(END_LocalData) + "-$" + toHexString(EndEND_LocalData - 1) + " END_LocalData"
EndEND_LocalData:

//; END_Init() -------------------------------------------------------------------------------------------------------
END_Init:

		lda #$00
		sta ValueD011
		sta Signal_VBlank
	END_WaitForVBlank:
		lda Signal_VBlank
		beq END_WaitForVBlank
		
		jsr END_PreFill
		
		sei
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta spriteEnable
		sta $d020
		lda #((ScreenBank * 16) + (BitmapBank * 8))
 		sta $d018
 		lda #$0c
 		sta $d021
		
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(END_Init) + "-$" + toHexString(EndEND_Init - 1) + " END_Init"
EndEND_Init:

//; END_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
END_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
	END_D011Value:
		lda #$00
		ora FrameOf8
 		sta $d011
		eor #$20
 		sta $d016

	END_DoubleBufferFrame:
		lda #$3f
		sta $dd02
		
	END_ShouldScrollColour:
		lda #$00
		beq END_DontScrollColour
		dec END_ShouldScrollColour + 1
		jsr END_ScrollColour2

	END_ScrollPosition:
		ldy #25
		iny
		cpy #$30
		bne END_ScrollPosGood
		ldy #$00
	END_ScrollPosGood:
		sty END_ScrollPosition + 1
	END_DontScrollColour:
		
		inc FrameOf256
		bne END_Skip256Counter
		inc Frame_256Counter
	END_Skip256Counter:
	
		lda FrameOf256
		and #$07
		eor #$07
		sta FrameOf8
	
	//; Initial screen flicker on/off
	END_InitialFlickerHasFinished:
		lda #$00
		bne END_NotFirstFrame
		
		lda FrameOf256
		and #$03
		bne END_NotFirstFrame
		
	END_InitialFlicker_Index:
		ldx #$00
		lda END_InitialFrameFlicker,x
		sta END_D011Value + 1
		inx
		stx END_InitialFlicker_Index + 1
		cpx #$10
		bne END_NotFirstFrame
		inc END_InitialFlickerHasFinished + 1
	END_NotFirstFrame:

		jsr Music_Play
		
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(END_IRQ_VBlank) + "-$" + toHexString(EndEND_IRQ_VBlank - 1) + " END_IRQ_VBlank"
EndEND_IRQ_VBlank:

//; END_IRQ_ScrollColour() -------------------------------------------------------------------------------------------------------
END_IRQ_ScrollColour:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
	END_ReadyToFlipFrame:
		lda #$00
		beq END_DontFlipFrame
		
		lda FrameOf8
		cmp #$07
		bne END_DontFlipFrame
		
		dec END_ReadyToFlipFrame + 1

		lda END_DoubleBufferFrame + 1
		eor #$01
		sta END_DoubleBufferFrame + 1

		inc END_ShouldScrollColour + 1
	
		inc END_MainThreadShouldDrawNextFrame + 1
	END_DontFlipFrame:

		lda END_ShouldScrollColour + 1
		beq END_DontScrollColour1
		
		jsr END_ScrollColour1
	END_DontScrollColour1:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(END_IRQ_ScrollColour) + "-$" + toHexString(EndEND_IRQ_ScrollColour - 1) + " END_IRQ_ScrollColour"
EndEND_IRQ_ScrollColour:

//; END_ScrollBitmap() -------------------------------------------------------------------------------------------------------
END_ScrollBitmap:
		.if(ShowTimings)
		{
			lda #$02
			sta $d020
		}
	
		lda END_DoubleBufferFrame + 1
		cmp #$3f
		beq END_CB_Copy0To1
		jmp END_CB_Copy1To0

	END_CB_Copy0To1:
		ldy #$00
	END_CB_Loop_0To1Bitmap:
		.for(var BlockIndex = 0; BlockIndex < (24 * 2); BlockIndex++)
		{
			lda BitmapAddress0 + BlockIndex * 20 * 8 + (41 * 8),y
			sta BitmapAddress1 + BlockIndex * 20 * 8,y
		}
		iny
		cpy #20 * 8
		beq END_CB_Copy0To1_FinishedBitmap
		jmp END_CB_Loop_0To1Bitmap
	END_CB_Copy0To1_FinishedBitmap:

		ldy #$00
	END_CB_Loop_0To1Screen:
		.for(var BlockIndex = 0; BlockIndex < 24; BlockIndex++)
		{
			lda ScreenAddress0 + BlockIndex * 40 + 41,y
			sta ScreenAddress1 + BlockIndex * 40,y
		}
		iny
		cpy #38
		beq END_CB_Copy0To1_FinishedScreen
		jmp END_CB_Loop_0To1Screen
	END_CB_Copy0To1_FinishedScreen:
	
		jsr END_AddNewData1
		jmp END_CB_Copy_Finished
		
	END_CB_Copy1To0:
		ldy #$00
	END_CB_Loop_1To0Bitmap:
		.for(var BlockIndex =0; BlockIndex < (24 * 2); BlockIndex++)
		{
			lda BitmapAddress1 + BlockIndex * 20 * 8 + (41 * 8),y
			sta BitmapAddress0 + BlockIndex * 20 * 8,y
		}
		iny
		cpy #20 * 8
		beq END_CB_Copy1To0_FinishedBitmap
		jmp END_CB_Loop_1To0Bitmap
	END_CB_Copy1To0_FinishedBitmap:

		ldy #$00
	END_CB_Loop_1To0Screen:
		.for(var BlockIndex = 0; BlockIndex < 24; BlockIndex++)
		{
			lda ScreenAddress1 + BlockIndex * 40 + 41,y
			sta ScreenAddress0 + BlockIndex * 40,y
		}
		iny
		cpy #38
		beq END_CB_Copy1To0_FinishedScreen
		jmp END_CB_Loop_1To0Screen
	END_CB_Copy1To0_FinishedScreen:

		jsr END_AddNewData0

	END_CB_Copy_Finished:
	
		inc END_ReadyToFlipFrame + 1

		.if(ShowTimings)
		{
			lda #$00
			sta $d020
		}

		rts
		
		.print "* $" + toHexString(END_ScrollBitmap) + "-$" + toHexString(EndEND_ScrollBitmap - 1) + " END_ScrollBitmap"
EndEND_ScrollBitmap:

//; END_ScrollColour1() -------------------------------------------------------------------------------------------------------
END_ScrollColour1:
		ldy #$00
	END_CB_Loop_Colour_Part1:
		.for(var BlockIndex = 0; BlockIndex < 12; BlockIndex++)
		{
			lda $d800 + BlockIndex * 40 + 41,y
			sta $d800 + BlockIndex * 40,y
		}
		iny
		cpy #38
		beq END_CB_Copy_FinishedColour_Part1
		jmp END_CB_Loop_Colour_Part1
	END_CB_Copy_FinishedColour_Part1:

		ldy END_ScrollPosition + 1
		.for(var BlockIndexY = 0; BlockIndexY < 12; BlockIndexY++)
		{
		 	lda END_SegmentData_Colour + (39 + BlockIndexY) * 48,y
			sta $d800 + 38 + BlockIndexY * 40
		}

		rts
		
		.print "* $" + toHexString(END_ScrollColour1) + "-$" + toHexString(EndEND_ScrollColour1 - 1) + " END_ScrollColour1"
EndEND_ScrollColour1:

//; END_ScrollColour2() -------------------------------------------------------------------------------------------------------
END_ScrollColour2:
		ldy #$00
	END_CB_Loop_Colour_Part2:
		.for(var BlockIndex = 12; BlockIndex < 24; BlockIndex++)
		{
			lda $d800 + BlockIndex * 40 + 41,y
			sta $d800 + BlockIndex * 40,y
		}
		iny
		cpy #38
		beq END_CB_Copy_FinishedColour_Part2
		jmp END_CB_Loop_Colour_Part2
	END_CB_Copy_FinishedColour_Part2:

		ldy END_ScrollPosition + 1
		.for(var BlockIndexY = 12; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Colour + (39 + BlockIndexY) * 48,y
			sta $d800 + 38 + BlockIndexY * 40
		}
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Colour + BlockIndexX * 48,y
			sta $d800 + 24 * 40 + BlockIndexX
		}

		rts
		
		.print "* $" + toHexString(END_ScrollColour2) + "-$" + toHexString(EndEND_ScrollColour2 - 1) + " END_ScrollColour2"
EndEND_ScrollColour2:

//; END_MainThread() -------------------------------------------------------------------------------------------------------
END_MainThread:
	END_MainThreadShouldDrawNextFrame:
		lda #$01
		beq END_DontDrawNextFrame
		dec END_MainThreadShouldDrawNextFrame + 1
		jsr END_ScrollBitmap
	END_DontDrawNextFrame:
	
		rts
				
		.print "* $" + toHexString(END_MainThread) + "-$" + toHexString(EndEND_MainThread - 1) + " END_MainThread"
EndEND_MainThread:

END_AddNewData0:
		
		lda END_ScrollPosition + 1
		rol
		rol
		ora #$03
		tay

		ldx #$03

	END_AddNewData0_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			.for( var Pix = 0; Pix < 2; Pix++)
			{
				lda END_SegmentData_Bitmap + ((BlockIndexX * 2 + Pix) * (48 * 4)), y
				sta BitmapAddress0 + ((24 * 40) + BlockIndexX) * 8 + Pix * 4,x
			}
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			.for( var Pix = 0; Pix < 2; Pix++)
			{
				lda END_SegmentData_Bitmap + (((39 + BlockIndexY) * 2 + Pix) * (48 * 4)), y
				sta BitmapAddress0 + (BlockIndexY * 40 + 38) * 8 + Pix * 4,x
			}
		}
		dey
		dex
		bmi END_AddNewData0_Finished
		jmp END_AddNewData0_Loop
	END_AddNewData0_Finished:
		
		ldy END_ScrollPosition + 1
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Screen + BlockIndexX * 48,y
			sta ScreenAddress0 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Screen + (39 + BlockIndexY) * 48,y
			sta ScreenAddress0 + 38 + BlockIndexY * 40
		}

		rts

		.print "* $" + toHexString(END_AddNewData0) + "-$" + toHexString(EndEND_AddNewData0 - 1) + " END_AddNewData0"
EndEND_AddNewData0:


END_AddNewData1:
		
		lda END_ScrollPosition + 1
		rol
		rol
		ora #$03
		tay

		ldx #$03

	END_AddNewData1_Loop:
		//; Fill bottom data
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			.for( var Pix = 0; Pix < 2; Pix++)
			{
				lda END_SegmentData_Bitmap + ((BlockIndexX * 2 + Pix) * (48 * 4)), y
				sta BitmapAddress1 + ((24 * 40) + BlockIndexX) * 8 + Pix * 4,x
			}
		}

		//; Fill RHS data
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			.for( var Pix = 0; Pix < 2; Pix++)
			{
				lda END_SegmentData_Bitmap + (((39 + BlockIndexY) * 2 + Pix) * (48 * 4)), y
				sta BitmapAddress1 + (BlockIndexY * 40 + 38) * 8 + Pix * 4,x
			}
		}
		dey
		dex
		bmi END_AddNewData1_Finished
		jmp END_AddNewData1_Loop
	END_AddNewData1_Finished:
		
		ldy END_ScrollPosition + 1
		.for(var BlockIndexX = 0; BlockIndexX < 39; BlockIndexX++)
		{
			lda END_SegmentData_Screen + BlockIndexX * 48,y
			sta ScreenAddress1 + 24 * 40 + BlockIndexX
		}
		.for(var BlockIndexY = 0; BlockIndexY < 24; BlockIndexY++)
		{
			lda END_SegmentData_Screen + (39 + BlockIndexY) * 48,y
			sta ScreenAddress1 + 38 + BlockIndexY * 40
		}

		rts

		.print "* $" + toHexString(END_AddNewData1) + "-$" + toHexString(EndEND_AddNewData1 - 1) + " END_AddNewData1"
EndEND_AddNewData1:





* = $a000
END_InitialSetup:

	END_Mul48_Lo:
		.byte <( 0 * 48), <( 1 * 48), <( 2 * 48), <( 3 * 48), <( 4 * 48), <( 5 * 48), <( 6 * 48), <( 7 * 48), <( 8 * 48), <( 9 * 48)
		.byte <(10 * 48), <(11 * 48), <(12 * 48), <(13 * 48), <(14 * 48), <(15 * 48), <(16 * 48), <(17 * 48), <(18 * 48), <(19 * 48)
		.byte <(20 * 48), <(21 * 48), <(22 * 48), <(23 * 48), <(24 * 48), <(25 * 48), <(26 * 48), <(27 * 48), <(28 * 48), <(29 * 48)
		.byte <(30 * 48), <(31 * 48), <(32 * 48), <(33 * 48), <(34 * 48), <(35 * 48), <(36 * 48), <(37 * 48), <(38 * 48), <(39 * 48)
		.byte <(40 * 48), <(41 * 48), <(42 * 48), <(43 * 48), <(44 * 48), <(45 * 48), <(46 * 48), <(47 * 48), <(48 * 48), <(49 * 48)
		.byte <(50 * 48), <(51 * 48), <(52 * 48), <(53 * 48), <(54 * 48), <(55 * 48), <(56 * 48), <(57 * 48), <(58 * 48), <(59 * 48)
		.byte <(60 * 48), <(61 * 48), <(62 * 48), <(63 * 48), <(64 * 48)
	END_Mul48_Hi:
		.byte >( 0 * 48), >( 1 * 48), >( 2 * 48), >( 3 * 48), >( 4 * 48), >( 5 * 48), >( 6 * 48), >( 7 * 48), >( 8 * 48), >( 9 * 48)
		.byte >(10 * 48), >(11 * 48), >(12 * 48), >(13 * 48), >(14 * 48), >(15 * 48), >(16 * 48), >(17 * 48), >(18 * 48), >(19 * 48)
		.byte >(20 * 48), >(21 * 48), >(22 * 48), >(23 * 48), >(24 * 48), >(25 * 48), >(26 * 48), >(27 * 48), >(28 * 48), >(29 * 48)
		.byte >(30 * 48), >(31 * 48), >(32 * 48), >(33 * 48), >(34 * 48), >(35 * 48), >(36 * 48), >(37 * 48), >(38 * 48), >(39 * 48)
		.byte >(40 * 48), >(41 * 48), >(42 * 48), >(43 * 48), >(44 * 48), >(45 * 48), >(46 * 48), >(47 * 48), >(48 * 48), >(49 * 48)
		.byte >(50 * 48), >(51 * 48), >(52 * 48), >(53 * 48), >(54 * 48), >(55 * 48), >(56 * 48), >(57 * 48), >(58 * 48), >(59 * 48)
		.byte >(60 * 48), >(61 * 48), >(62 * 48), >(63 * 48), >(64 * 48)
	END_Mul_2_48_4_Lo:
		.byte <( 0 * 2 * 48 * 4), <( 1 * 2 * 48 * 4), <( 2 * 2 * 48 * 4), <( 3 * 2 * 48 * 4), <( 4 * 2 * 48 * 4), <( 5 * 2 * 48 * 4), <( 6 * 2 * 48 * 4), <( 7 * 2 * 48 * 4), <( 8 * 2 * 48 * 4), <( 9 * 2 * 48 * 4)
		.byte <(10 * 2 * 48 * 4), <(11 * 2 * 48 * 4), <(12 * 2 * 48 * 4), <(13 * 2 * 48 * 4), <(14 * 2 * 48 * 4), <(15 * 2 * 48 * 4), <(16 * 2 * 48 * 4), <(17 * 2 * 48 * 4), <(18 * 2 * 48 * 4), <(19 * 2 * 48 * 4)
		.byte <(20 * 2 * 48 * 4), <(21 * 2 * 48 * 4), <(22 * 2 * 48 * 4), <(23 * 2 * 48 * 4), <(24 * 2 * 48 * 4), <(25 * 2 * 48 * 4), <(26 * 2 * 48 * 4), <(27 * 2 * 48 * 4), <(28 * 2 * 48 * 4), <(29 * 2 * 48 * 4)
		.byte <(30 * 2 * 48 * 4), <(31 * 2 * 48 * 4), <(32 * 2 * 48 * 4), <(33 * 2 * 48 * 4), <(34 * 2 * 48 * 4), <(35 * 2 * 48 * 4), <(36 * 2 * 48 * 4), <(37 * 2 * 48 * 4), <(38 * 2 * 48 * 4), <(39 * 2 * 48 * 4)
		.byte <(40 * 2 * 48 * 4), <(41 * 2 * 48 * 4), <(42 * 2 * 48 * 4), <(43 * 2 * 48 * 4), <(44 * 2 * 48 * 4), <(45 * 2 * 48 * 4), <(46 * 2 * 48 * 4), <(47 * 2 * 48 * 4), <(48 * 2 * 48 * 4), <(49 * 2 * 48 * 4)
		.byte <(50 * 2 * 48 * 4), <(51 * 2 * 48 * 4), <(52 * 2 * 48 * 4), <(53 * 2 * 48 * 4), <(54 * 2 * 48 * 4), <(55 * 2 * 48 * 4), <(56 * 2 * 48 * 4), <(57 * 2 * 48 * 4), <(58 * 2 * 48 * 4), <(59 * 2 * 48 * 4)
		.byte <(60 * 2 * 48 * 4), <(61 * 2 * 48 * 4), <(62 * 2 * 48 * 4), <(63 * 2 * 48 * 4), <(64 * 2 * 48 * 4)
	END_Mul_2_48_4_Hi:
		.byte >( 0 * 2 * 48 * 4), >( 1 * 2 * 48 * 4), >( 2 * 2 * 48 * 4), >( 3 * 2 * 48 * 4), >( 4 * 2 * 48 * 4), >( 5 * 2 * 48 * 4), >( 6 * 2 * 48 * 4), >( 7 * 2 * 48 * 4), >( 8 * 2 * 48 * 4), >( 9 * 2 * 48 * 4)
		.byte >(10 * 2 * 48 * 4), >(11 * 2 * 48 * 4), >(12 * 2 * 48 * 4), >(13 * 2 * 48 * 4), >(14 * 2 * 48 * 4), >(15 * 2 * 48 * 4), >(16 * 2 * 48 * 4), >(17 * 2 * 48 * 4), >(18 * 2 * 48 * 4), >(19 * 2 * 48 * 4)
		.byte >(20 * 2 * 48 * 4), >(21 * 2 * 48 * 4), >(22 * 2 * 48 * 4), >(23 * 2 * 48 * 4), >(24 * 2 * 48 * 4), >(25 * 2 * 48 * 4), >(26 * 2 * 48 * 4), >(27 * 2 * 48 * 4), >(28 * 2 * 48 * 4), >(29 * 2 * 48 * 4)
		.byte >(30 * 2 * 48 * 4), >(31 * 2 * 48 * 4), >(32 * 2 * 48 * 4), >(33 * 2 * 48 * 4), >(34 * 2 * 48 * 4), >(35 * 2 * 48 * 4), >(36 * 2 * 48 * 4), >(37 * 2 * 48 * 4), >(38 * 2 * 48 * 4), >(39 * 2 * 48 * 4)
		.byte >(40 * 2 * 48 * 4), >(41 * 2 * 48 * 4), >(42 * 2 * 48 * 4), >(43 * 2 * 48 * 4), >(44 * 2 * 48 * 4), >(45 * 2 * 48 * 4), >(46 * 2 * 48 * 4), >(47 * 2 * 48 * 4), >(48 * 2 * 48 * 4), >(49 * 2 * 48 * 4)
		.byte >(50 * 2 * 48 * 4), >(51 * 2 * 48 * 4), >(52 * 2 * 48 * 4), >(53 * 2 * 48 * 4), >(54 * 2 * 48 * 4), >(55 * 2 * 48 * 4), >(56 * 2 * 48 * 4), >(57 * 2 * 48 * 4), >(58 * 2 * 48 * 4), >(59 * 2 * 48 * 4)
		.byte >(60 * 2 * 48 * 4), >(61 * 2 * 48 * 4), >(62 * 2 * 48 * 4), >(63 * 2 * 48 * 4), >(64 * 2 * 48 * 4)
		
END_PreFill:

	END_PreFill_Horizontal:

	END_PreFill_Horizontal_XStartOffset:
		ldy #24

	END_PreFill_Horizontal_YLine:
		lda #$00
		asl
		asl
		clc
		adc END_Mul_2_48_4_Lo,y
		sta END_PreFill_Horizontal_BitmapIn0 + 1

		lda END_Mul_2_48_4_Hi,y
		adc #>END_SegmentData_Bitmap
		sta END_PreFill_Horizontal_BitmapIn0 + 2

		lda END_PreFill_Horizontal_BitmapIn0 + 1
		clc
		adc #(48*4)
		sta END_PreFill_Horizontal_BitmapIn1 + 1

		lda END_PreFill_Horizontal_BitmapIn0 + 2
		adc #$00
		sta END_PreFill_Horizontal_BitmapIn1 + 2
		
	END_PreFill_Horizontal_NextLine_BitmapLo:
		lda #<BitmapAddress0
		sta END_PreFill_Horizontal_BitmapOut0 + 1
		clc
		adc #$04
		sta END_PreFill_Horizontal_BitmapOut1 + 1

	END_PreFill_Horizontal_NextLine_BitmapHi:
		lda #>BitmapAddress0
		sta END_PreFill_Horizontal_BitmapOut0 + 2
		adc #$00
		sta END_PreFill_Horizontal_BitmapOut1 + 2

	END_PreFill_Horizontal_XLength_LineSetup:
		lda #15
		sta END_PreFill_Horizontal_XLengthCount + 1

		ldy END_PreFill_Horizontal_XStartOffset + 1

		lda END_Mul48_Lo,y
		clc
		adc END_PreFill_Horizontal_YLine + 1
		sta END_PreFill_Horizontal_ColourIn + 1
		lda END_Mul48_Hi,y
		adc #>END_SegmentData_Colour
		sta END_PreFill_Horizontal_ColourIn + 2

		lda END_Mul48_Lo,y
		clc
		adc END_PreFill_Horizontal_YLine + 1
		sta END_PreFill_Horizontal_ScreenIn + 1
		lda END_Mul48_Hi,y
		adc #>END_SegmentData_Screen
		sta END_PreFill_Horizontal_ScreenIn + 2
		
	END_PreFill_Horizontal_NextLine_ColourLo:
		lda #$00
		sta END_PreFill_Horizontal_ColourOut + 1

	END_PreFill_Horizontal_NextLine_ColourHi:
		lda #$d8
		sta END_PreFill_Horizontal_ColourOut + 2
		
	END_PreFill_Horizontal_NextLine_ScreenLo:
		lda #<ScreenAddress0
		sta END_PreFill_Horizontal_ScreenOut + 1

	END_PreFill_Horizontal_NextLine_ScreenHi:
		lda #>ScreenAddress0
		sta END_PreFill_Horizontal_ScreenOut + 2
		
		lda #$00
		sta END_PreFill_Horizontal_OuterLoop + 1
		
	END_PreFill_Horizontal_OuterLoop:
		ldx #$00
	END_PreFill_Horizontal_ColourIn:
		lda $ffff
	END_PreFill_Horizontal_ColourOut:
		sta $ffff,x

	END_PreFill_Horizontal_ScreenIn:
		lda $ffff
	END_PreFill_Horizontal_ScreenOut:
		sta $ffff,x
	
		ldx #$00
		ldy #$00
	END_PreFill_Horizontal_InnerLoop:
	END_PreFill_Horizontal_BitmapIn0:
		lda $ffff,y
	END_PreFill_Horizontal_BitmapOut0:
		sta $ffff,x
	END_PreFill_Horizontal_BitmapIn1:
		lda $ffff,y
	END_PreFill_Horizontal_BitmapOut1:
		sta $ffff,x
		iny
		inx
		cpx #$04
		bne END_PreFill_Horizontal_InnerLoop
		
		lda END_PreFill_Horizontal_BitmapIn0 + 1
		clc
		adc #<(48 * 4 * 2)
		sta END_PreFill_Horizontal_BitmapIn0 + 1
		lda END_PreFill_Horizontal_BitmapIn0 + 2
		adc #>(48 * 4 * 2)
		sta END_PreFill_Horizontal_BitmapIn0 + 2

		lda END_PreFill_Horizontal_BitmapIn1 + 1
		clc
		adc #<(48 * 4 * 2)
		sta END_PreFill_Horizontal_BitmapIn1 + 1
		lda END_PreFill_Horizontal_BitmapIn1 + 2
		adc #>(48 * 4 * 2)
		sta END_PreFill_Horizontal_BitmapIn1 + 2

		lda END_PreFill_Horizontal_BitmapOut0 + 1
		clc
		adc #$08
		sta END_PreFill_Horizontal_BitmapOut0 + 1
		lda END_PreFill_Horizontal_BitmapOut0 + 2
		adc #$00
		sta END_PreFill_Horizontal_BitmapOut0 + 2
		sta END_PreFill_Horizontal_BitmapOut1 + 2
		lda END_PreFill_Horizontal_BitmapOut0 + 1
		ora #$04
		sta END_PreFill_Horizontal_BitmapOut1 + 1

		lda END_PreFill_Horizontal_ColourIn + 1
		clc
		adc #48
		sta END_PreFill_Horizontal_ColourIn + 1
		lda END_PreFill_Horizontal_ColourIn + 2
		adc #$00
		sta END_PreFill_Horizontal_ColourIn + 2

		lda END_PreFill_Horizontal_ScreenIn + 1
		clc
		adc #48
		sta END_PreFill_Horizontal_ScreenIn + 1
		lda END_PreFill_Horizontal_ScreenIn + 2
		adc #$00
		sta END_PreFill_Horizontal_ScreenIn + 2

		inc END_PreFill_Horizontal_OuterLoop + 1
	END_PreFill_Horizontal_XLengthCount:
		ldx #15
		dex
		stx END_PreFill_Horizontal_XLengthCount + 1
		beq END_PreFill_Horizontal_LineFinished
		jmp END_PreFill_Horizontal_OuterLoop
	
	END_PreFill_Horizontal_LineFinished:
		lda END_PreFill_Horizontal_NextLine_BitmapLo + 1
		clc
		adc #<(40 * 8)
		sta END_PreFill_Horizontal_NextLine_BitmapLo + 1

		lda END_PreFill_Horizontal_NextLine_BitmapHi + 1
		adc #>(40 * 8)
		sta END_PreFill_Horizontal_NextLine_BitmapHi + 1
		
		lda END_PreFill_Horizontal_NextLine_ColourLo + 1
		clc
		adc #40
		sta END_PreFill_Horizontal_NextLine_ColourLo + 1

		lda END_PreFill_Horizontal_NextLine_ColourHi + 1
		adc #$00
		sta END_PreFill_Horizontal_NextLine_ColourHi + 1

		lda END_PreFill_Horizontal_NextLine_ScreenLo + 1
		clc
		adc #40
		sta END_PreFill_Horizontal_NextLine_ScreenLo + 1

		lda END_PreFill_Horizontal_NextLine_ScreenHi + 1
		adc #$00
		sta END_PreFill_Horizontal_NextLine_ScreenHi + 1

		inc END_PreFill_Horizontal_XLength_LineSetup + 1
		inc END_PreFill_Horizontal_YLine + 1
		dec END_PreFill_Horizontal_XStartOffset + 1
		bmi END_PreFill_Horizontal_Finished
		jmp END_PreFill_Horizontal

	END_PreFill_Horizontal_Finished:
	


	END_PreFill_Vertical:

	END_PreFill_Vertical_YStartOffset:
		ldy #(39 + 24)

	END_PreFill_Vertical_YLine:
		lda #$00
		asl
		asl
		clc
		adc END_Mul_2_48_4_Lo,y
		sta END_PreFill_Vertical_BitmapIn0 + 1

		lda END_Mul_2_48_4_Hi,y
		adc #>END_SegmentData_Bitmap
		sta END_PreFill_Vertical_BitmapIn0 + 2

		lda END_PreFill_Vertical_BitmapIn0 + 1
		clc
		adc #(48*4)
		sta END_PreFill_Vertical_BitmapIn1 + 1

		lda END_PreFill_Vertical_BitmapIn0 + 2
		adc #$00
		sta END_PreFill_Vertical_BitmapIn1 + 2
		
	END_PreFill_Vertical_NextLine_BitmapLo:
		lda #<(BitmapAddress0 + 14 * 8)
		sta END_PreFill_Vertical_BitmapOut0 + 1
		clc
		adc #$04
		sta END_PreFill_Vertical_BitmapOut1 + 1

	END_PreFill_Vertical_NextLine_BitmapHi:
		lda #>(BitmapAddress0 + 14 * 8)
		sta END_PreFill_Vertical_BitmapOut0 + 2
		adc #$00
		sta END_PreFill_Vertical_BitmapOut1 + 2

	END_PreFill_Vertical_XLength_LineSetup:
		lda #0
		sta END_PreFill_Vertical_XLengthCount + 1

		ldy END_PreFill_Vertical_YStartOffset + 1

		lda END_Mul48_Lo,y
		clc
		adc END_PreFill_Vertical_YLine + 1
		sta END_PreFill_Vertical_ColourIn + 1
		lda END_Mul48_Hi,y
		adc #>END_SegmentData_Colour
		sta END_PreFill_Vertical_ColourIn + 2

		lda END_Mul48_Lo,y
		clc
		adc END_PreFill_Vertical_YLine + 1
		sta END_PreFill_Vertical_ScreenIn + 1
		lda END_Mul48_Hi,y
		adc #>END_SegmentData_Screen
		sta END_PreFill_Vertical_ScreenIn + 2
		
	END_PreFill_Vertical_NextLine_ColourLo:
		lda #<($d800 + 14)
		sta END_PreFill_Vertical_ColourOut + 1

	END_PreFill_Vertical_NextLine_ColourHi:
		lda #>($d800 + 14)
		sta END_PreFill_Vertical_ColourOut + 2
		
	END_PreFill_Vertical_NextLine_ScreenLo:
		lda #<(ScreenAddress0 + 14)
		sta END_PreFill_Vertical_ScreenOut + 1

	END_PreFill_Vertical_NextLine_ScreenHi:
		lda #>(ScreenAddress0 + 14)
		sta END_PreFill_Vertical_ScreenOut + 2
		
		lda #$00
		sta END_PreFill_Vertical_OuterLoop + 1
		
//; first time through we'll have nothing to draw .. so skip it
		lda END_PreFill_Vertical_XLengthCount + 1
		bne END_PreFill_Vertical_LengthNotZero
		jmp END_PreFill_Vertical_LineFinished
	END_PreFill_Vertical_LengthNotZero:
		
	END_PreFill_Vertical_OuterLoop:
		ldx #$00
	END_PreFill_Vertical_ColourIn:
		lda $ffff
	END_PreFill_Vertical_ColourOut:
		sta $ffff,x

	END_PreFill_Vertical_ScreenIn:
		lda $ffff
	END_PreFill_Vertical_ScreenOut:
		sta $ffff,x
	
		ldx #$00
		ldy #$00
	END_PreFill_Vertical_InnerLoop:
	END_PreFill_Vertical_BitmapIn0:
		lda $ffff,y
	END_PreFill_Vertical_BitmapOut0:
		sta $ffff,x
	END_PreFill_Vertical_BitmapIn1:
		lda $ffff,y
	END_PreFill_Vertical_BitmapOut1:
		sta $ffff,x
		iny
		inx
		cpx #$04
		bne END_PreFill_Vertical_InnerLoop
		
		lda END_PreFill_Vertical_BitmapIn0 + 1
		clc
		adc #<(48 * 4 * 2)
		sta END_PreFill_Vertical_BitmapIn0 + 1
		lda END_PreFill_Vertical_BitmapIn0 + 2
		adc #>(48 * 4 * 2)
		sta END_PreFill_Vertical_BitmapIn0 + 2

		lda END_PreFill_Vertical_BitmapIn1 + 1
		clc
		adc #<(48 * 4 * 2)
		sta END_PreFill_Vertical_BitmapIn1 + 1
		lda END_PreFill_Vertical_BitmapIn1 + 2
		adc #>(48 * 4 * 2)
		sta END_PreFill_Vertical_BitmapIn1 + 2

		lda END_PreFill_Vertical_BitmapOut0 + 1
		clc
		adc #<(40 * 8)
		sta END_PreFill_Vertical_BitmapOut0 + 1
		lda END_PreFill_Vertical_BitmapOut0 + 2
		adc #>(40 * 8)
		sta END_PreFill_Vertical_BitmapOut0 + 2
		sta END_PreFill_Vertical_BitmapOut1 + 2
		lda END_PreFill_Vertical_BitmapOut0 + 1
		ora #$04
		sta END_PreFill_Vertical_BitmapOut1 + 1

		lda END_PreFill_Vertical_ColourIn + 1
		clc
		adc #48
		sta END_PreFill_Vertical_ColourIn + 1
		lda END_PreFill_Vertical_ColourIn + 2
		adc #$00
		sta END_PreFill_Vertical_ColourIn + 2

		lda END_PreFill_Vertical_ScreenIn + 1
		clc
		adc #48
		sta END_PreFill_Vertical_ScreenIn + 1
		lda END_PreFill_Vertical_ScreenIn + 2
		adc #$00
		sta END_PreFill_Vertical_ScreenIn + 2

		lda END_PreFill_Vertical_ColourOut + 1
		clc
		adc #$28
		sta END_PreFill_Vertical_ColourOut + 1
		lda END_PreFill_Vertical_ColourOut + 2
		adc #$00
		sta END_PreFill_Vertical_ColourOut + 2
		
		lda END_PreFill_Vertical_ScreenOut + 1
		clc
		adc #$28
		sta END_PreFill_Vertical_ScreenOut + 1
		lda END_PreFill_Vertical_ScreenOut + 2
		adc #$00
		sta END_PreFill_Vertical_ScreenOut + 2
		
	END_PreFill_Vertical_XLengthCount:
		ldx #15
		dex
		stx END_PreFill_Vertical_XLengthCount + 1
		beq END_PreFill_Vertical_LineFinished
		jmp END_PreFill_Vertical_OuterLoop
	
	END_PreFill_Vertical_LineFinished:
		lda END_PreFill_Vertical_NextLine_BitmapLo + 1
		clc
		adc #$08
		sta END_PreFill_Vertical_NextLine_BitmapLo + 1

		lda END_PreFill_Vertical_NextLine_BitmapHi + 1
		adc #$00
		sta END_PreFill_Vertical_NextLine_BitmapHi + 1
		
		lda END_PreFill_Vertical_NextLine_ColourLo + 1
		clc
		adc #1
		sta END_PreFill_Vertical_NextLine_ColourLo + 1

		lda END_PreFill_Vertical_NextLine_ColourHi + 1
		adc #$00
		sta END_PreFill_Vertical_NextLine_ColourHi + 1

		lda END_PreFill_Vertical_NextLine_ScreenLo + 1
		clc
		adc #01
		sta END_PreFill_Vertical_NextLine_ScreenLo + 1

		lda END_PreFill_Vertical_NextLine_ScreenHi + 1
		adc #$00
		sta END_PreFill_Vertical_NextLine_ScreenHi + 1

		inc END_PreFill_Vertical_XLength_LineSetup + 1
		inc END_PreFill_Vertical_YLine + 1
		dec END_PreFill_Vertical_YStartOffset + 1
		lda END_PreFill_Vertical_YLine + 1
		cmp #25
		beq END_PreFill_Vertical_Finished
		jmp END_PreFill_Vertical

	END_PreFill_Vertical_Finished:
		
		rts

		.print "* $" + toHexString(END_InitialSetup) + "-$" + toHexString(EndEND_InitialSetup - 1) + " END_InitialSetup"
EndEND_InitialSetup:
