// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

* = FullScreenRasters_BASE "Full Screen Rasters"

// DLL jump table
Jumps:
		jmp Init_FSR
		jmp End_FSR
		
//; FSR_LocalData -------------------------------------------------------------------------------------------------------
FSR_LocalData:
	.var IRQNum = 2
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,							HiPtr
		.byte	$00,			$18,			<FSR_IRQ_Function_SetRedBlack,	>FSR_IRQ_Function_SetRedBlack
		.byte	$80,			$24,			<FSR_VBlank_Function,			>FSR_VBlank_Function
	
	FSR_RasterInterruptLines:
		.byte $1e, $20, $26, $28, $2e, $00
		
	FSR_FadeInOrFadeOut:
		.byte $00								//; $00=fadein, $01=fadeout
	
	FSR_FinishedAnimation:
		.byte $00
		
	.var FSR_RasterPosition1 = IRQList + 1
	.var FSR_RasterPosition2 = FSR_RasterInterruptLines + 0
	.var FSR_RasterPosition3 = FSR_RasterInterruptLines + 1
	.var FSR_RasterPosition4 = FSR_RasterInterruptLines + 2
	.var FSR_RasterPosition5 = FSR_RasterInterruptLines + 3
	.var FSR_RasterPosition6 = FSR_RasterInterruptLines + 4

	.print "* $" + toHexString(FSR_LocalData) + "-$" + toHexString(EndFSR_LocalData - 1) + " FSR_LocalData"
EndFSR_LocalData:

// Init_FSR() -------------------------------------------------------------------------------------------------------
Init_FSR:
		sta FSR_FadeInOrFadeOut
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta spriteEnable		// make no sprites visible
		sta FrameOf256
		sta Frame_256Counter
		jsr FSR_AnimateRasters_Fade

		sei
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts
		
		.print "* $" + toHexString(Init_FSR) + "-$" + toHexString(EndInit_FSR - 1) + " Init_FSR"
EndInit_FSR:

// End_FSR() -------------------------------------------------------------------------------------------------------
End_FSR:
		lda #$00
		sta ValueD021
		sta ValueD011

		jsr IRQManager_RestoreDefaultIRQ

		rts
		.print "* $" + toHexString(End_FSR) + "-$" + toHexString(EndEnd_FSR - 1) + " End_FSR"
EndEnd_FSR:

// FSR_VBlank_Function() -------------------------------------------------------------------------------------------------------
FSR_VBlank_Function:
		dec	0
		sta IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		lda #$00
		sta $d011

		lda FSR_FinishedAnimation
		bne FSR_DontUpdateRasters
		
		jsr FSR_AnimateRasters_Fade
		
	FSR_DontUpdateRasters:
		jsr Music_Play

		inc FrameOf256
		lda FrameOf256
		cmp #$80
		bne FSR_NotFinishedYet
		
		lda #$01
		sta Signal_CurrentEffectIsFinished
	FSR_NotFinishedYet:
	
		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(FSR_VBlank_Function) + "-$" + toHexString(EndFSR_VBlank_Function - 1) + " FSR_VBlank_Function"
EndFSR_VBlank_Function:

// FSR_IRQ_Function_SetRedBlack() -------------------------------------------------------------------------------------------------------
FSR_IRQ_Function_SetRedBlack:
		dec	0
		sta IRQ_RestoreA
		lda	#39 - (10)
		sec
		sbc	$dc06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		nop

	FSR_IRQ_RedBlack:
		lda #$02
		sta $d020
		
	FSR_IRQ_YValue:
		ldy #$00
		lda FSR_RasterInterruptLines,y
		sta $d012
		lda #$01
		sta $d01a
		lda FSR_IRQ_RedBlack + 1
	FSR_IRQ_RedBlack_ColourEOR:
		eor #$02
		sta FSR_IRQ_RedBlack + 1
		iny
		sty FSR_IRQ_YValue + 1
		cpy #$06
		bne FSR_IRQ_Finished
		lda #$00
		sta FSR_IRQ_YValue + 1

		jmp IRQManager_NextInIRQList_RTI
	
	FSR_IRQ_Finished:
		asl $d019 //; Acknowledge VIC interrupts
		lda	IRQ_RestoreA
		ldx IRQ_RestoreX
		ldy IRQ_RestoreY
		inc 0
		rti
		
		.print "* $" + toHexString(FSR_IRQ_Function_SetRedBlack) + "-$" + toHexString(EndFSR_IRQ_Function_SetRedBlack - 1) + " FSR_IRQ_Function_SetRedBlack"
EndFSR_IRQ_Function_SetRedBlack:

// FSR_AnimateRasters_Fade() -------------------------------------------------------------------------------------------------------
FSR_AnimateRasters_Fade:
		lda FSR_FadeInOrFadeOut
		beq FSR_DoFadeIn
		jmp FSR_AnimateRasters_FadeOut
	FSR_DoFadeIn:

		lda FrameOf256
		sta FSR_AR_FrameStore + 1
		cmp #$59
		bcs FSR_FadeFinished

	FSR_Fade_JumpPoint:
	FSR_AR_FrameStore:
		lda #$00
		clc
		lsr
		lsr
		lsr
		cmp #$06
		bcc FSR_GoodHeight
		lda #$06
	FSR_GoodHeight:
		cmp #$02
		bcs FSR_GoodHeight2
		lda #$02
	FSR_GoodHeight2:
		sta FSR_Height + 1
		
		lda FSR_AR_FrameStore + 1
		clc
		adc #$32
		sta FSR_RasterPosition1 // red
		clc
	FSR_Height:
		adc #$06
		sta FSR_RasterPosition2 // black
		
		lda #$92
		sta FSR_RasterPosition3 // red
		clc
		adc FSR_Height + 1
		sta FSR_RasterPosition4 // black

		lda #$58
		sec
		sbc FSR_AR_FrameStore + 1
		clc
		adc #$9a
		sta FSR_RasterPosition5
		clc
		adc FSR_Height + 1
		sta FSR_RasterPosition6 // black

	FSR_FinishedAnimateRasters:
		rts

	FSR_FadeFinished:
		lda #$01
		sta FSR_FinishedAnimation
		rts
		
FSR_AnimateRasters_FadeOut:
		lda #$58
		sec
		sbc FrameOf256
		bcs FSR_NotFinishedAnimateRasters2
		
		lda #$01
		sta FSR_FinishedAnimation
		lda #$00
		sta FSR_IRQ_RedBlack + 1
		sta FSR_IRQ_RedBlack_ColourEOR + 1
		rts

	FSR_NotFinishedAnimateRasters2:
		sta FSR_AR_FrameStore + 1
		jmp FSR_Fade_JumpPoint
		
		.print "* $" + toHexString(FSR_AnimateRasters_Fade) + "-$" + toHexString(EndFSR_AnimateRasters_Fade - 1) + " FSR_AnimateRasters_Fade"
EndFSR_AnimateRasters_Fade:
