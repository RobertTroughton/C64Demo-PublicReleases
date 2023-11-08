//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 1 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 0 //; 1=Bank+[0000,07ff]
	.var ScreenBank0 = 1 //; 1=Bank+[0400,07ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)

* = StartupScreenFade_BASE "Startup Screen Fade"

	JumpTable:
		jmp SSF_Init
		jmp IRQManager_RestoreDefaultIRQ
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; SSF_LocalData -------------------------------------------------------------------------------------------------------
SSF_LocalData:
	.var SSF_Sprite_YStart = 40
	.var SSF_Sprite_First = $80
	
	.var IRQNum = 5
	IRQList:
		//;		MSB($00/$80),	LINE,								LoPtr,						HiPtr
		.byte	$00,			SSF_Sprite_YStart + 1 + (42 * 0),	<SSF_IRQ_SpriteSection0,	>SSF_IRQ_SpriteSection0
		.byte	$00,			SSF_Sprite_YStart + 1 + (42 * 1),	<SSF_IRQ_SpriteSection1,	>SSF_IRQ_SpriteSection1
		.byte	$00,			SSF_Sprite_YStart + 1 + (42 * 2),	<SSF_IRQ_SpriteSection2,	>SSF_IRQ_SpriteSection2
		.byte	$00,			SSF_Sprite_YStart + 1 + (42 * 3),	<SSF_IRQ_SpriteSection3,	>SSF_IRQ_SpriteSection3
		.byte	$00,			$fd,								<SSF_IRQ_VBlank,			>SSF_IRQ_VBlank
		
	.print "* $" + toHexString(SSF_LocalData) + "-$" + toHexString(EndSSF_LocalData - 1) + " SSF_LocalData"

EndSSF_LocalData:

//; SSF_Init() -------------------------------------------------------------------------------------------------------
SSF_Init:

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta spriteMulticolorMode
		sta spriteDrawPriority

		lda #$ff
		sta spriteDoubleWidth	//; make all sprites double-width
		sta spriteDoubleHeight	//; make all sprites double-height
		
		ldy #$07
		lda #$0e
	SSF_SetSpriteColors:
		sta SPRITE0_Color,y
		dey
		bpl SSF_SetSpriteColors
		
		ldx #$00
		lda #$18
	SSF_SetSpritePositions:
		sta $d000,x
		clc
		adc #$30
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositions
		
		lda #$e0
		sta spriteXMSB

		lda #$f8
	SSF_WaitForGoodTimeToStartIRQ:
		cmp $d012
		bcc SSF_WaitForGoodTimeToStartIRQ
		
		sei
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(SSF_Init) + "-$" + toHexString(EndSSF_Init - 1) + " SSF_Init"
EndSSF_Init:

//; SSF_IRQ_SpriteSection0() -------------------------------------------------------------------------------------------------------
SSF_IRQ_SpriteSection0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #SSF_Sprite_YStart + (42 * 1)
	SSF_SetSpritePositions0:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositions0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF_IRQ_SpriteSection0) + "-$" + toHexString(EndSSF_IRQ_SpriteSection0 - 1) + " SSF_IRQ_SpriteSection0"
EndSSF_IRQ_SpriteSection0:
		
//; SSF_IRQ_SpriteSection1() -------------------------------------------------------------------------------------------------------
SSF_IRQ_SpriteSection1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #SSF_Sprite_YStart + (42 * 2)
	SSF_SetSpritePositions1:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositions1
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF_IRQ_SpriteSection1) + "-$" + toHexString(EndSSF_IRQ_SpriteSection1 - 1) + " SSF_IRQ_SpriteSection1"
EndSSF_IRQ_SpriteSection1:
		
//; SSF_IRQ_SpriteSection2() -------------------------------------------------------------------------------------------------------
SSF_IRQ_SpriteSection2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #SSF_Sprite_YStart + (42 * 3)
	SSF_SetSpritePositions2:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositions2
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF_IRQ_SpriteSection2) + "-$" + toHexString(EndSSF_IRQ_SpriteSection2 - 1) + " SSF_IRQ_SpriteSection2"
EndSSF_IRQ_SpriteSection2:
		
//; SSF_IRQ_SpriteSection3() -------------------------------------------------------------------------------------------------------
SSF_IRQ_SpriteSection3:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$00
		lda #SSF_Sprite_YStart + (42 * 4)
	SSF_SetSpritePositions3:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositions3
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF_IRQ_SpriteSection3) + "-$" + toHexString(EndSSF_IRQ_SpriteSection3 - 1) + " SSF_IRQ_SpriteSection3"
EndSSF_IRQ_SpriteSection3:
		
//; SSF_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SSF_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		lda #$ff
		sta spriteEnable
		
		ldx #$00
		lda #SSF_Sprite_YStart
	SSF_SetSpritePositionsVB:
		sta $d001,x
		inx
		inx
		cpx #$10
		bne SSF_SetSpritePositionsVB
		
		lda FrameOf256
		clc
		adc #SSF_Sprite_First
		sta SPRITE0_Val_Bank0
		sta SPRITE1_Val_Bank0
		sta SPRITE2_Val_Bank0
		sta SPRITE3_Val_Bank0
		sta SPRITE4_Val_Bank0
		sta SPRITE5_Val_Bank0
		sta SPRITE6_Val_Bank0
		sta SPRITE7_Val_Bank0
		
		jsr Music_Play
		
		inc FrameOf256
		lda FrameOf256
		cmp #$40
		bne SSF_NotFinishedDemoPart
		inc Signal_CurrentEffectIsFinished
	SSF_NotFinishedDemoPart:
	
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF_IRQ_VBlank) + "-$" + toHexString(EndSSF_IRQ_VBlank - 1) + " SSF_IRQ_VBlank"
EndSSF_IRQ_VBlank:
