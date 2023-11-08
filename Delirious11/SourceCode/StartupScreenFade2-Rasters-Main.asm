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

* = StartupScreenFade2_BASE "Startup Screen Fade 2 - Rasters"

	JumpTable:
		jmp SSF2_Init
		jmp IRQManager_RestoreDefaultIRQ
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; SSF2_LocalData -------------------------------------------------------------------------------------------------------
SSF2_LocalData:
	.var IRQNum = 2
	IRQList:
		//;		MSB($00/$80),	LINE,								LoPtr,						HiPtr
		.byte	$80,			$24,								<SSF2_IRQ_VBlank,			>SSF2_IRQ_VBlank
	IRQList_Raster:
		.byte	$00,			$80,								<SSF2_IRQ_Raster,			>SSF2_IRQ_Raster
		
	.var SSF2_NumColours = 2
	SSF2_ScreenColors:
		.byte $06, $00
		
	.print "* $" + toHexString(SSF2_LocalData) + "-$" + toHexString(EndSSF2_LocalData - 1) + " SSF2_LocalData"

EndSSF2_LocalData:

//; SSF2_Init() -------------------------------------------------------------------------------------------------------
SSF2_Init:

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		
		lda SSF2_ScreenColors
		sta SSF2_NewColour + 1
		lda #$0e
		sta SSF2_OldColour + 1

		lda #$f8
	SSF2_WaitForGoodTimeToStartIRQ:
		lda $d011
		and #$80
		bne SSF2_WaitForGoodTimeToStartIRQ
		
		sei
		lda #$00
		sta $d011
		sta ValueD011
		sta spriteEnable

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(SSF2_Init) + "-$" + toHexString(EndSSF2_Init - 1) + " SSF2_Init"
EndSSF2_Init:

//; SSF2_IRQ_Raster() -------------------------------------------------------------------------------------------------------
SSF2_IRQ_Raster:
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

	SSF2_OldColour:
		lda #$0e
		sta $d020
		
		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF2_IRQ_Raster) + "-$" + toHexString(EndSSF2_IRQ_Raster - 1) + " SSF2_IRQ_Raster"
EndSSF2_IRQ_Raster:

//; SSF2_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SSF2_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		jsr Music_Play
		
		inc FrameOf256
		bne SSF2_Skip256Counter
		inc Frame_256Counter
	SSF2_Skip256Counter:
		
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank
		
	SSF2_NewColour:
		lda #$06
		sta $d020

	SSF2_RasterYPos:
		lda #$01
		clc
		asl
		clc
		asl
		clc
		asl
		sta IRQList_Raster + 1
		lda #$00
		bcc SSF2_NoOverflow
		lda #$80
	SSF2_NoOverflow:
		sta IRQList_Raster + 0
		
		lda SSF2_RasterYPos + 1
		clc
		adc #$01
		cmp #$25
		bne SSF2_NotFinishedScreen
		
		lda SSF2_NewColour + 1
		sta SSF2_OldColour + 1
	SSF2_ColourIndex:
		ldx #$01
		cpx #SSF2_NumColours
		bne SSF2_NotFinishedYet
		inc Signal_CurrentEffectIsFinished
		dex
	SSF2_NotFinishedYet:
		lda SSF2_ScreenColors,x
		sta SSF2_NewColour + 1
		inc SSF2_ColourIndex + 1
	
		lda #$01
	SSF2_NotFinishedScreen:
		sta SSF2_RasterYPos + 1

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SSF2_IRQ_VBlank) + "-$" + toHexString(EndSSF2_IRQ_VBlank - 1) + " SSF2_IRQ_VBlank"
EndSSF2_IRQ_VBlank:
