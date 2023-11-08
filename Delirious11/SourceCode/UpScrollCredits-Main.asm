//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 0 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 7 //; 1=Bank+[3800,3fff]
	.var ScreenBank = 14 //; 14=Bank+[3800,3bff]
	.var ScreenAddress = (BaseBankAddress + (ScreenBank * 1024))
	.var SPRITE0_Val = (ScreenAddress + $3F8 + 0)
	.var SPRITE1_Val = (ScreenAddress + $3F8 + 1)
	.var SPRITE2_Val = (ScreenAddress + $3F8 + 2)
	.var SPRITE3_Val = (ScreenAddress + $3F8 + 3)
	.var SPRITE4_Val = (ScreenAddress + $3F8 + 4)
	.var SPRITE5_Val = (ScreenAddress + $3F8 + 5)
	.var SPRITE6_Val = (ScreenAddress + $3F8 + 6)
	.var SPRITE7_Val = (ScreenAddress + $3F8 + 7)
	.var StartSpriteIndex = 128
	.var SpriteDataAddress = BaseBankAddress + (StartSpriteIndex * 64)
	
* = UpScroll_BASE "UpScroll"

	JumpTable:
		jmp UPSCROLL_Init
		jmp UPSCROLL_End

		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; UPSCROLL_LocalData -------------------------------------------------------------------------------------------------------
UPSCROLL_LocalData:
	.var UPSCROLL_ScrollText = $ca00
	.var UPSCROLL_Font = $f000
	.var UPSCROLL_ScrollTextStride = 128
	
	.var UPSCROLL_SPRITEYWRITEOFFSET = 2
	
	.var IRQNum = 14
	IRQList:
		//;		MSB($00/$80),	LINE,				LoPtr,								HiPtr
		.byte	$80,			$17,				<UPSCROLL_IRQ_VBlank,				>UPSCROLL_IRQ_VBlank
		.byte	$00,			(21 * 1),			<UPSCROLL_IRQ_SpritePlex0,			>UPSCROLL_IRQ_SpritePlex0
		.byte	$00,			(21 * 2),			<UPSCROLL_IRQ_SpritePlex1,			>UPSCROLL_IRQ_SpritePlex1
		.byte	$00,			(21 * 3),			<UPSCROLL_IRQ_SpritePlex2,			>UPSCROLL_IRQ_SpritePlex2
		.byte	$00,			(21 * 4),			<UPSCROLL_IRQ_SpritePlex3,			>UPSCROLL_IRQ_SpritePlex3
		.byte	$00,			(21 * 5),			<UPSCROLL_IRQ_SpritePlex4,			>UPSCROLL_IRQ_SpritePlex4
		.byte	$00,			(21 * 6),			<UPSCROLL_IRQ_SpritePlex5,			>UPSCROLL_IRQ_SpritePlex5
		.byte	$00,			(21 * 7),			<UPSCROLL_IRQ_SpritePlex6,			>UPSCROLL_IRQ_SpritePlex6
		.byte	$00,			(21 * 8),			<UPSCROLL_IRQ_SpritePlex7,			>UPSCROLL_IRQ_SpritePlex7
		.byte	$00,			(21 * 9),			<UPSCROLL_IRQ_SpritePlex8,			>UPSCROLL_IRQ_SpritePlex8
		.byte	$00,			(21 * 10),			<UPSCROLL_IRQ_SpritePlex9,			>UPSCROLL_IRQ_SpritePlex9
		.byte	$00,			(21 * 11),			<UPSCROLL_IRQ_SpritePlex10,			>UPSCROLL_IRQ_SpritePlex10
		.byte	$00,			$f9,				<UPSCROLL_IRQ_BottomBorder1,		>UPSCROLL_IRQ_BottomBorder1
		.byte	$80,			$11,				<UPSCROLL_IRQ_BottomBorder2,		>UPSCROLL_IRQ_BottomBorder2
		
	UPSCROLL_SpriteXStartPosition:
		.byte (24 + (320 / 2) - (24 * 2))
	
	UPSCROLL_SpriteLineYPositions:
		.byte (21 * 0)
		.byte (21 * 1)
		.byte (21 * 2)
		.byte (21 * 3)
		.byte (21 * 4)
		.byte (21 * 5)
		.byte (21 * 6)
		.byte (21 * 7)
		.byte (21 * 8)
		.byte (21 * 9)
		.byte (21 * 10)
		.byte ((21 * 11))&255
		.byte ((21 * 12))&255
		.byte ((21 * 13))&255
		
	UPSCROLL_ScrollPosition:
		.byte $00

	UPSCROLL_SpriteLineVals:
		.byte StartSpriteIndex + (0 * 4)
		.byte StartSpriteIndex + (1 * 4)
		.byte StartSpriteIndex + (2 * 4)
		.byte StartSpriteIndex + (3 * 4)
		.byte StartSpriteIndex + (4 * 4)
		.byte StartSpriteIndex + (5 * 4)
		.byte StartSpriteIndex + (6 * 4)
		.byte StartSpriteIndex + (7 * 4)
		.byte StartSpriteIndex + (8 * 4)
		.byte StartSpriteIndex + (9 * 4)
		.byte StartSpriteIndex + (10 * 4)
		.byte StartSpriteIndex + (11 * 4)
		.byte StartSpriteIndex + (12 * 4)
		.byte StartSpriteIndex + (13 * 4)
		.byte StartSpriteIndex + (0 * 4)
		.byte StartSpriteIndex + (1 * 4)
		.byte StartSpriteIndex + (2 * 4)
		.byte StartSpriteIndex + (3 * 4)
		.byte StartSpriteIndex + (4 * 4)
		.byte StartSpriteIndex + (5 * 4)
		.byte StartSpriteIndex + (6 * 4)
		.byte StartSpriteIndex + (7 * 4)
		.byte StartSpriteIndex + (8 * 4)
		.byte StartSpriteIndex + (9 * 4)
		.byte StartSpriteIndex + (10 * 4)
		.byte StartSpriteIndex + (11 * 4)
		.byte StartSpriteIndex + (12 * 4)
		.byte StartSpriteIndex + (13 * 4)
		
	.print "* $" + toHexString(UPSCROLL_LocalData) + "-$" + toHexString(EndUPSCROLL_LocalData - 1) + " UPSCROLL_LocalData"
	
EndUPSCROLL_LocalData:

UPCSCROLL_SetSpriteYPositions:
		lda #$00
		sec
		sbc #$01
		bcs UPSCROLL_SetY_AllGood

		lda UPSCROLL_ScrollPosition
		clc
		adc #$01
		cmp #14
		bne UPSCROLL_DontLoopScroll
		lda #$00
	UPSCROLL_DontLoopScroll:
		sta UPSCROLL_ScrollPosition

		inc UPSCROLL_ShouldFillCharLine + 1
		lda #$00
		sta UPSCROLL_FillCharLine_X + 1
		jsr UPSCROLL_FillNewCharLineInit
		
		lda #20
	UPSCROLL_SetY_AllGood:
		sta UPCSCROLL_SetSpriteYPositions + 1

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
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 6
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 7
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 8
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 9
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 10
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 11
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 12
		clc
		adc #$15
		sta UPSCROLL_SpriteLineYPositions + 13
		
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


//; UPSCROLL_Init() -------------------------------------------------------------------------------------------------------
UPSCROLL_Init:

		lda #$00
		sta $d020
		
		ldx #$00
		lda #$00
	UPSCROLL_ClearScreenColoursAndSprites:
		sta $d800 + (0 * 256),x
		sta $d800 + (1 * 256),x
		sta $d800 + (2 * 256),x
		sta $d800 + (1000 - 256),x
		sta ScreenAddress + (0 * 256),x
		sta ScreenAddress + (1 * 256),x
		sta ScreenAddress + (2 * 256),x
		sta ScreenAddress + (1024 - 256),x
		sta SpriteDataAddress + ( 0 * 256),x
		sta SpriteDataAddress + ( 1 * 256),x
		sta SpriteDataAddress + ( 2 * 256),x
		sta SpriteDataAddress + ( 3 * 256),x
		sta SpriteDataAddress + ( 4 * 256),x
		sta SpriteDataAddress + ( 5 * 256),x
		sta SpriteDataAddress + ( 6 * 256),x
		sta SpriteDataAddress + ( 7 * 256),x
		sta SpriteDataAddress + ( 8 * 256),x
		sta SpriteDataAddress + ( 9 * 256),x
		sta SpriteDataAddress + (10 * 256),x
		sta SpriteDataAddress + (11 * 256),x
		sta SpriteDataAddress + (12 * 256),x
		sta SpriteDataAddress + (13 * 256),x
		sta SpriteDataAddress + (14 * 256),x
		sta SpriteDataAddress + (15 * 256),x
		inx
		bne UPSCROLL_ClearScreenColoursAndSprites
		
		sei
		lda #(63 - BaseBank)
		sta $dd02
		lda #((ScreenBank * 16) + (CharBank * 2))
 		sta $d018
		lda #$08
		sta $d016
		
		lda #$00
		sta $d021

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta spriteDrawPriority
		sta spriteXMSB
		sta spriteDoubleWidth
		sta spriteDoubleHeight
		sta spriteMulticolorMode

		lda #$ff
		sta spriteEnable
		
		lda #$1b
		sta $d011
		sta ValueD011

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(UPSCROLL_Init) + "-$" + toHexString(EndUPSCROLL_Init - 1) + " UPSCROLL_Init"
EndUPSCROLL_Init:

//; UPSCROLL_End() -------------------------------------------------------------------------------------------------------
UPSCROLL_End:
		lda #$00
		sta ValueD011
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(UPSCROLL_End) + "-$" + toHexString(EndUPSCROLL_End - 1) + " UPSCROLL_End"
EndUPSCROLL_End:

//; UPSCROLL_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #$00
		sta SPRITE0_Color
		sta SPRITE1_Color
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		sta SPRITE5_Color
		sta SPRITE6_Color
		sta SPRITE7_Color
		
		jsr UPCSCROLL_SetSpriteYPositions
		
		lda UPSCROLL_SpriteLineYPositions + 0
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		lda UPSCROLL_SpriteLineYPositions + 1
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f

		lda UPSCROLL_SpriteXStartPosition
		sta $d000
		sta $d008
		clc
		adc #$18
		sta $d002
		sta $d00a
		clc
		adc #$18
		sta $d004
		sta $d00c
		clc
		adc #$18
		sta $d006
		sta $d00e
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		ldx UPSCROLL_SpriteLineVals + 1,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val
		
		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:
	
		jsr Music_Play
		
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_VBlank) + "-$" + toHexString(EndUPSCROLL_IRQ_VBlank - 1) + " UPSCROLL_IRQ_VBlank"
EndUPSCROLL_IRQ_VBlank:

//; UPSCROLL_IRQ_SpritePlex0() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #$0f
		sta SPRITE0_Color
		sta SPRITE1_Color
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		sta SPRITE5_Color
		sta SPRITE6_Color
		sta SPRITE7_Color

		lda UPSCROLL_SpriteLineYPositions + 2
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex0) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex0 - 1) + " UPSCROLL_IRQ_SpritePlex0"
EndUPSCROLL_IRQ_SpritePlex0:

//; UPSCROLL_IRQ_SpritePlex1() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 2,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val

		lda UPSCROLL_SpriteLineYPositions + 3
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex1) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex1 - 1) + " UPSCROLL_IRQ_SpritePlex1"
EndUPSCROLL_IRQ_SpritePlex1:

//; UPSCROLL_IRQ_SpritePlex2() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 3,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val

		lda UPSCROLL_SpriteLineYPositions + 4
		sta $d001
		sta $d003
		sta $d005
		sta $d007

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex2) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex2 - 1) + " UPSCROLL_IRQ_SpritePlex2"
EndUPSCROLL_IRQ_SpritePlex2:

//; UPSCROLL_IRQ_SpritePlex3() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex3:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 4,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		
		lda UPSCROLL_SpriteLineYPositions + 5
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex3) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex3 - 1) + " UPSCROLL_IRQ_SpritePlex3"
EndUPSCROLL_IRQ_SpritePlex3:

//; UPSCROLL_IRQ_SpritePlex4() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex4:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 5,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val

		lda UPSCROLL_SpriteLineYPositions + 6
		sta $d001
		sta $d003
		sta $d005
		sta $d007

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex4) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex4 - 1) + " UPSCROLL_IRQ_SpritePlex4"
EndUPSCROLL_IRQ_SpritePlex4:

//; UPSCROLL_IRQ_SpritePlex5() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex5:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 6,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		
		lda UPSCROLL_SpriteLineYPositions + 7
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex5) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex5 - 1) + " UPSCROLL_IRQ_SpritePlex5"
EndUPSCROLL_IRQ_SpritePlex5:

//; UPSCROLL_IRQ_SpritePlex6() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex6:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 7,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val

		lda UPSCROLL_SpriteLineYPositions + 8
		sta $d001
		sta $d003
		sta $d005
		sta $d007

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex6) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex6 - 1) + " UPSCROLL_IRQ_SpritePlex6"
EndUPSCROLL_IRQ_SpritePlex6:

//; UPSCROLL_IRQ_SpritePlex7() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex7:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 8,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		
		lda UPSCROLL_SpriteLineYPositions + 9
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex7) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex7 - 1) + " UPSCROLL_IRQ_SpritePlex7"
EndUPSCROLL_IRQ_SpritePlex7:

//; UPSCROLL_IRQ_SpritePlex8() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex8:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 9,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val

		lda UPSCROLL_SpriteLineYPositions + 10
		sta $d001
		sta $d003
		sta $d005
		sta $d007

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex8) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex8 - 1) + " UPSCROLL_IRQ_SpritePlex8"
EndUPSCROLL_IRQ_SpritePlex8:

//; UPSCROLL_IRQ_SpritePlex9() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex9:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 10,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		
		lda UPSCROLL_SpriteLineYPositions + 11
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex9) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex9 - 1) + " UPSCROLL_IRQ_SpritePlex9"
EndUPSCROLL_IRQ_SpritePlex9:

//; UPSCROLL_IRQ_SpritePlex10() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_SpritePlex10:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 11,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val

		lda UPSCROLL_SpriteLineYPositions + 12
		sta $d001
		sta $d003
		sta $d005
		sta $d007

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_SpritePlex10) + "-$" + toHexString(EndUPSCROLL_IRQ_SpritePlex10 - 1) + " UPSCROLL_IRQ_SpritePlex10"
EndUPSCROLL_IRQ_SpritePlex10:

//; UPSCROLL_IRQ_BottomBorder1() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_BottomBorder1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda ValueD011
		and #$f7
		sta $d011

		lda #$fc
	UPSCROLL_VBWaitFC:
		cmp $d012
		bne UPSCROLL_VBWaitFC

		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 12,y
		stx SPRITE0_Val
		inx
		stx SPRITE1_Val
		inx
		stx SPRITE2_Val
		inx
		stx SPRITE3_Val
		
		lda UPSCROLL_SpriteLineYPositions + 13
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		lda #$ff
	UPSCROLL_VBWaitFF:
		cmp $d012
		bne UPSCROLL_VBWaitFF
		
		lda ValueD011
 		sta $d011

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_BottomBorder1) + "-$" + toHexString(EndUPSCROLL_IRQ_BottomBorder1 - 1) + " UPSCROLL_IRQ_BottomBorder1"
EndUPSCROLL_IRQ_BottomBorder1:

//; UPSCROLL_IRQ_BottomBorder2() -------------------------------------------------------------------------------------------------------
UPSCROLL_IRQ_BottomBorder2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldy UPSCROLL_ScrollPosition
		ldx UPSCROLL_SpriteLineVals + 13,y
		stx SPRITE4_Val
		inx
		stx SPRITE5_Val
		inx
		stx SPRITE6_Val
		inx
		stx SPRITE7_Val
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(UPSCROLL_IRQ_BottomBorder2) + "-$" + toHexString(EndUPSCROLL_IRQ_BottomBorder2 - 1) + " UPSCROLL_IRQ_BottomBorder2"
EndUPSCROLL_IRQ_BottomBorder2:

UPSCROLL_FillNewCharLineInit:
		ldy UPSCROLL_ScrollPosition
		
		lda UPSCROLL_SpriteLineVals + 13,y
		lsr
		lsr
		clc
		adc #>BaseBankAddress

		sta UPSCROLL_SpriteOutputAddressA0 + 2
		sta UPSCROLL_SpriteOutputAddressA1 + 2
		sta UPSCROLL_SpriteOutputAddressA2 + 2
		sta UPSCROLL_SpriteOutputAddressA3 + 2
		sta UPSCROLL_SpriteOutputAddressB0 + 2
		sta UPSCROLL_SpriteOutputAddressB1 + 2
		sta UPSCROLL_SpriteOutputAddressB2 + 2
		sta UPSCROLL_SpriteOutputAddressB3 + 2
		sta UPSCROLL_SpriteOutputAddressC0 + 2
		sta UPSCROLL_SpriteOutputAddressC1 + 2
		sta UPSCROLL_SpriteOutputAddressC2 + 2
		sta UPSCROLL_SpriteOutputAddressC3 + 2
		sta UPSCROLL_SpriteOutputAddressD0 + 2
		sta UPSCROLL_SpriteOutputAddressD1 + 2
		sta UPSCROLL_SpriteOutputAddressD2 + 2
		sta UPSCROLL_SpriteOutputAddressD3 + 2
		sta UPSCROLL_SpriteOutputAddressE0 + 2
		sta UPSCROLL_SpriteOutputAddressE1 + 2
		sta UPSCROLL_SpriteOutputAddressE2 + 2
		sta UPSCROLL_SpriteOutputAddressE3 + 2
		sta UPSCROLL_SpriteOutputAddressF0 + 2
		sta UPSCROLL_SpriteOutputAddressF1 + 2
		sta UPSCROLL_SpriteOutputAddressF2 + 2
		sta UPSCROLL_SpriteOutputAddressF3 + 2
		sta UPSCROLL_SpriteOutputAddressG0 + 2
		sta UPSCROLL_SpriteOutputAddressG1 + 2
		sta UPSCROLL_SpriteOutputAddressG2 + 2
		sta UPSCROLL_SpriteOutputAddressG3 + 2
		sta UPSCROLL_SpriteOutputAddressH0 + 2
		sta UPSCROLL_SpriteOutputAddressH1 + 2
		sta UPSCROLL_SpriteOutputAddressH2 + 2
		sta UPSCROLL_SpriteOutputAddressH3 + 2
		sta UPSCROLL_SpriteOutputAddressI0 + 2
		sta UPSCROLL_SpriteOutputAddressI1 + 2
		sta UPSCROLL_SpriteOutputAddressI2 + 2
		sta UPSCROLL_SpriteOutputAddressI3 + 2
		sta UPSCROLL_SpriteOutputAddressJ0 + 2
		sta UPSCROLL_SpriteOutputAddressJ1 + 2
		sta UPSCROLL_SpriteOutputAddressJ2 + 2
		sta UPSCROLL_SpriteOutputAddressJ3 + 2
		sta UPSCROLL_SpriteOutputAddressK0 + 2
		sta UPSCROLL_SpriteOutputAddressK1 + 2
		sta UPSCROLL_SpriteOutputAddressK2 + 2
		sta UPSCROLL_SpriteOutputAddressK3 + 2
		sta UPSCROLL_SpriteOutputAddressL0 + 2
		sta UPSCROLL_SpriteOutputAddressL1 + 2
		sta UPSCROLL_SpriteOutputAddressL2 + 2
		sta UPSCROLL_SpriteOutputAddressL3 + 2
		
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
		lda UPSCROLL_ScrollText + ( 0 * UPSCROLL_ScrollTextStride),x
		cmp #$ff
		bne UPSCROLL_NotEndOfScrollText

		inc Signal_CurrentEffectIsFinished
		ldx #$00
	UPSCROLL_NotEndOfScrollText:
		stx UPSCROLL_ScrollTextPos + 1
		
		rts
		
UPSCROLL_FillNewCharLine:

	//; 1st char
	UPSCROLL_CharValueA:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressA0:
		sta $6000 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressA1:
		sta $6000 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressA2:
		sta $6000 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressA3:
		sta $6000 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueA + 1

	//; 2nd char
	UPSCROLL_CharValueB:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressB0:
		sta $6001 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressB1:
		sta $6001 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressB2:
		sta $6001 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressB3:
		sta $6001 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueB + 1

	//; 3rd char
	UPSCROLL_CharValueC:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressC0:
		sta $6002 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressC1:
		sta $6002 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressC2:
		sta $6002 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressC3:
		sta $6002 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueC + 1

	//; 4th char
	UPSCROLL_CharValueD:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressD0:
		sta $6040 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressD1:
		sta $6040 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressD2:
		sta $6040 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressD3:
		sta $6040 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueD + 1

	//; 5th char
	UPSCROLL_CharValueE:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressE0:
		sta $6041 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressE1:
		sta $6041 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressE2:
		sta $6041 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressE3:
		sta $6041 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueE + 1

	//; 6th char
	UPSCROLL_CharValueF:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressF0:
		sta $6042 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressF1:
		sta $6042 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressF2:
		sta $6042 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressF3:
		sta $6042 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueF + 1

	//; 7th char
	UPSCROLL_CharValueG:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressG0:
		sta $6080 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressG1:
		sta $6080 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressG2:
		sta $6080 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressG3:
		sta $6080 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueG + 1

	//; 8th char
	UPSCROLL_CharValueH:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressH0:
		sta $6081 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressH1:
		sta $6081 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressH2:
		sta $6081 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressH3:
		sta $6081 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueH + 1

	//; 9th char
	UPSCROLL_CharValueI:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressI0:
		sta $6082 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressI1:
		sta $6082 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressI2:
		sta $6082 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressI3:
		sta $6082 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueI + 1

	//; 10th char
	UPSCROLL_CharValueJ:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressJ0:
		sta $60c0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressJ1:
		sta $60c0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressJ2:
		sta $60c0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressJ3:
		sta $60c0 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueJ + 1

	//; 11th char
	UPSCROLL_CharValueK:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressK0:
		sta $60c1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressK1:
		sta $60c1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressK2:
		sta $60c1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressK3:
		sta $60c1 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueK + 1

	//; 12th char
	UPSCROLL_CharValueL:
		ldy #$00
		lda UPSCROLL_Font + (0 * 256),y
	UPSCROLL_SpriteOutputAddressL0:
		sta $60c2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 0)) * 3,x
		lda UPSCROLL_Font + (1 * 256),y
	UPSCROLL_SpriteOutputAddressL1:
		sta $60c2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 1)) * 3,x
		lda UPSCROLL_Font + (2 * 256),y
	UPSCROLL_SpriteOutputAddressL2:
		sta $60c2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 2)) * 3,x
		lda UPSCROLL_Font + (3 * 256),y
	UPSCROLL_SpriteOutputAddressL3:
		sta $60c2 + (UPSCROLL_SPRITEYWRITEOFFSET + (4 * 3)) * 3,x
		tya
		clc
		adc #$40
		sta UPSCROLL_CharValueL + 1
		
		rts
