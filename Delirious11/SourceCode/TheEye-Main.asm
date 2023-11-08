//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	//; Defines

* = TheEye_BASE "The Eye"

	JumpTable:
		jmp EYE_Init
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
	
//; EYE_LocalData -------------------------------------------------------------------------------------------------------
EYE_LocalData:
	.var IRQNum = 1
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$ff,			<EYE_IRQ_VBlank,			>EYE_IRQ_VBlank

	.print "* $" + toHexString(EYE_LocalData) + "-$" + toHexString(EndEYE_LocalData - 1) + " EYE_LocalData"
EndEYE_LocalData:
		
//; EYE_Init() -------------------------------------------------------------------------------------------------------
EYE_Init:
		lda #$00
		sta ValueD011
		
		lda #$00
		sta Signal_VBlank
	EYE_WaitForVBlank:
		lda Signal_VBlank
		beq EYE_WaitForVBlank
		
		sei
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta $d020
		lda #$ff
		sta $bfff
		lda #$38
 		sta $d018
		lda #$18
 		sta $d016
 		lda #$00
 		sta spriteEnable
		lda #$3e
		sta $dd02
		lda #$3b
		sta $d011
		lda #$00
		sta $d021

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(EYE_Init) + "-$" + toHexString(EndEYE_Init - 1) + " EYE_Init"
EndEYE_Init:

//; EYE_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
EYE_IRQ_VBlank:
		//; LFT Jitter correction
		//; Put earliest cycle in parenthesis.
		//; (10 with no sprites, 19 with all sprites, ...)
		//; Length of clockslide can be increased if more jitter
		//; is expected, e.g. due to NMIs.
		dec	0
		sta	IRQ_RestoreA
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
		
		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:

		lda Frame_256Counter
		cmp #$01
		bne EYE_NotFinishedYet
		
		lda #$01
		sta Signal_CurrentEffectIsFinished
	EYE_NotFinishedYet:

	 	jsr Music_Play

		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(EYE_IRQ_VBlank) + "-$" + toHexString(EndEYE_IRQ_VBlank - 1) + " EYE_IRQ_VBlank"
EndEYE_IRQ_VBlank:
