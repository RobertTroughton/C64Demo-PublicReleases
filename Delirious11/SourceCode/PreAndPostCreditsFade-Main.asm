//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 1 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 0 //; 1=Bank+[0000,07ff]
	.var ScreenBank0 = 0 //; 1=Bank+[0400,07ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)

* = PrePostCreditsFade_BASE "Pre And Post Credits Fade"

	JumpTable:
		jmp PPCF_Init
		jmp PPCF_End
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; PPCF_LocalData -------------------------------------------------------------------------------------------------------
PPCF_LocalData:
	.var PPCF_Sprite_YStart = 8
	.var PPCF_Sprite_First = $a0
	
	.var IRQNum = 8
	IRQList:
		//;		MSB($00/$80),	LINE,								LoPtr,						HiPtr
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 0),	<PPCF_IRQ_SpriteSection0,	>PPCF_IRQ_SpriteSection0
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 1),	<PPCF_IRQ_SpriteSection1,	>PPCF_IRQ_SpriteSection1
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 2),	<PPCF_IRQ_SpriteSection2,	>PPCF_IRQ_SpriteSection2
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 3),	<PPCF_IRQ_SpriteSection3,	>PPCF_IRQ_SpriteSection3
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 4),	<PPCF_IRQ_SpriteSection4,	>PPCF_IRQ_SpriteSection4
		.byte	$00,			PPCF_Sprite_YStart + 1 + (42 * 5),	<PPCF_IRQ_SpriteSection5,	>PPCF_IRQ_SpriteSection5
		.byte	$00,			$f7,								<PPCF_IRQ_BottomBorder,		>PPCF_IRQ_BottomBorder
		.byte	$80,			$10,								<PPCF_IRQ_VBlank,			>PPCF_IRQ_VBlank
		
	PPCF_FadeDirection:
		.byte $00
	PPCF_SpriteColourOnFadeDirection:
		.byte $00, $0b
		
	.print "* $" + toHexString(PPCF_LocalData) + "-$" + toHexString(EndPPCF_LocalData - 1) + " PPCF_LocalData"

EndPPCF_LocalData:

//; PPCF_Init() -------------------------------------------------------------------------------------------------------
PPCF_Init:

		sta PPCF_FadeDirection

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta $bfff
		
		lda PPCF_FadeDirection
		bne PPCF_NoNeedToCleanUp
		
		//; We just clear this data here so that the credit part itself doesn't need to
		ldy #$00
	PPCF_CleanUpData:
		lda #$00
		sta BaseBankAddress + 256 * 0,y
		sta BaseBankAddress + 256 * 1,y
		sta BaseBankAddress + 256 * 2,y
		sta BaseBankAddress + 256 * 3,y
		sta BaseBankAddress + 256 * 4,y
		sta BaseBankAddress + 256 * 5,y
		sta BaseBankAddress + 256 * 6,y
		sta BaseBankAddress + 256 * 7,y
		sta ScreenAddress0 + 0,y
		sta ScreenAddress0 + 256,y
		sta ScreenAddress0 + 512,y
		sta ScreenAddress0 + (1000 - 256),y

		lda #$0b
		sta $d800 + (256 * 0),y
		sta $d800 + (256 * 1), y
		sta $d800 + (256 * 2),y
		sta $d800 + (1000 - 256),y
		iny
		bne PPCF_CleanUpData
		
	PPCF_NoNeedToCleanUp:
		
		sei
		lda #$1b
		sta ValueD011
		lda #$0b
		sta $d021
		lda #$00
		sta $d016
		sta spriteMulticolorMode
		sta spriteDrawPriority
		sta FrameOf256
		sta Frame_256Counter
		lda #((ScreenBank0 * 16) + (CharBank * 8))
		sta $d018
		lda #$3e
		sta $dd02
		lda #$e0
		sta spriteXMSB
		lda #$ff
		sta spriteDoubleWidth	//; make all sprites double-width
		sta spriteDoubleHeight	//; make all sprites double-height
		ldx #$00
		lda #$18
	PPCF_SetSpritePositions:
		sta $d000,x
		clc
		adc #$30
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions
		lda #$00
		ldy #$07
	PPCF_SetSpriteColors:
		sta SPRITE0_Color,y
		dey
		bpl PPCF_SetSpriteColors
		lda #$ff
		sta spriteEnable

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(PPCF_Init) + "-$" + toHexString(EndPPCF_Init - 1) + " PPCF_Init"
EndPPCF_Init:

//; PPCF_End() -------------------------------------------------------------------------------------------------------
PPCF_End:
		lda PPCF_FadeDirection
		eor #$01
		tax
		lda PPCF_SpriteColourOnFadeDirection,x
		sta ValueD021
		sta $d021
		
		lda #$00
		sta ValueSpriteEnable
		sta spriteEnable
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(PPCF_End) + "-$" + toHexString(EndPPCF_End - 1) + " PPCF_End"
EndPPCF_End:

//; PPCF_IRQ_SpriteSection0() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 1)
	PPCF_SetSpritePositions0:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection0) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection0 - 1) + " PPCF_IRQ_SpriteSection0"
EndPPCF_IRQ_SpriteSection0:
		
//; PPCF_IRQ_SpriteSection1() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 2)
	PPCF_SetSpritePositions1:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions1
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection1) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection1 - 1) + " PPCF_IRQ_SpriteSection1"
EndPPCF_IRQ_SpriteSection1:
		
//; PPCF_IRQ_SpriteSection2() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 3)
	PPCF_SetSpritePositions2:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions2
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection2) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection2 - 1) + " PPCF_IRQ_SpriteSection2"
EndPPCF_IRQ_SpriteSection2:
		
//; PPCF_IRQ_SpriteSection3() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection3:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 4)
	PPCF_SetSpritePositions3:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions3
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection3) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection3 - 1) + " PPCF_IRQ_SpriteSection3"
EndPPCF_IRQ_SpriteSection3:
		
//; PPCF_IRQ_SpriteSection4() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection4:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 5)
	PPCF_SetSpritePositions4:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions4
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection4) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection4 - 1) + " PPCF_IRQ_SpriteSection4"
EndPPCF_IRQ_SpriteSection4:
		
//; PPCF_IRQ_SpriteSection4() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_SpriteSection5:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #PPCF_Sprite_YStart + (42 * 6)
	PPCF_SetSpritePositions5:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositions5
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_SpriteSection5) + "-$" + toHexString(EndPPCF_IRQ_SpriteSection5 - 1) + " PPCF_IRQ_SpriteSection5"
EndPPCF_IRQ_SpriteSection5:
		
//; PPCF_IRQ_BottomBorder() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_BottomBorder:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		lda #$f9
	PPCF_VBWaitF9:
		cmp $d012
		bne PPCF_VBWaitF9

		lda ValueD011
		and #$f7
		sta $d011
		
		lda #$ff
	PPCF_VBWaitFF:
		cmp $d012
		bne PPCF_VBWaitFF

		lda ValueD011
		sta $d011

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_BottomBorder) + "-$" + toHexString(EndPPCF_IRQ_BottomBorder - 1) + " PPCF_IRQ_BottomBorder"
EndPPCF_IRQ_BottomBorder:

//; PPCF_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
PPCF_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx #$00
		lda #PPCF_Sprite_YStart
	PPCF_SetSpritePositionsVB:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne PPCF_SetSpritePositionsVB

		jsr Music_Play

		lda PPCF_FadeDirection
		beq PPCF_FadeUp
		
	PPCF_FadeDown:
		lda FrameOf256
		jmp PPCF_SetSpriteValues

	PPCF_FadeUp:
		lda #((24 * 4) - 1)
		sec
		sbc FrameOf256
		
	PPCF_SetSpriteValues:
		lsr
		lsr
		clc
		adc #PPCF_Sprite_First
		sta SPRITE0_Val_Bank0
		sta SPRITE1_Val_Bank0
		sta SPRITE2_Val_Bank0
		sta SPRITE3_Val_Bank0
		sta SPRITE4_Val_Bank0
		sta SPRITE5_Val_Bank0
		sta SPRITE6_Val_Bank0
		sta SPRITE7_Val_Bank0
		
		inc FrameOf256
		lda FrameOf256
		cmp #(24 * 4)
		bne PPCF_NotFinishedDemoPart
		inc Signal_CurrentEffectIsFinished
	PPCF_NotFinishedDemoPart:
	
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PPCF_IRQ_VBlank) + "-$" + toHexString(EndPPCF_IRQ_VBlank - 1) + " PPCF_IRQ_VBlank"
EndPPCF_IRQ_VBlank:
