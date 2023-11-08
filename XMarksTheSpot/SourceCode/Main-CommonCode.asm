//; (c) 2018, Raistlin of Genesis*Project

#importonce

//; ZEROPAGE
	.var IRQManager_IRQTablePtr				= $00c0 //; 2 bytes

.macro Start_ShowTiming(bCycleMatch)
{
		.if(ShowTimings)
		{
			inc VIC_BorderColour
		}
		else
		{
			.if(bCycleMatch != 0)
			{
				nop
				nop
				nop
			}
		}
}

.macro Stop_ShowTiming(bCycleMatch)
{
		.if(ShowTimings)
		{
			dec VIC_BorderColour
		}
		else
		{
			.if(bCycleMatch != 0)
			{
				nop
				nop
				nop
			}
		}
}

.macro SpindleIRQInit()
{
//; Spindle by lft, www.linusakesson.net/software/spindle/
//; Prepare CIA #1 timer B to compensate for interrupt jitter.
//; Also initialise d01a and dc02.
//; This code is inlined into prgloader, and also into the
//; first effect driver by pefchain.
		bit	VIC_D011
		bmi	*-3

		bit	VIC_D011
		bpl	*-3

		ldx	VIC_D012
		inx
resync:
		cpx	VIC_D012
		bne	*-3
		//; at cycle 4 or later
		ldy	#0		//; 4
		sty	$dc07	//; 6
		lda	#62		//; 10
		sta	$dc06	//; 12
		iny			//; 16
		sty	VIC_D01A	//; 18
		dey			//; 22
		dey			//; 24
		sty	$dc02	//; 26
		cmp	(0, x)	//; 30
		cmp	(0, x)	//; 36
		cmp	(0, x)	//; 42
		lda	#$11	//; 48
		sta	$dc0f	//; 50
		txa			//; 54
		inx			//; 56
		inx			//; 58
		cmp	VIC_D012	//; 60	still on the same line?
		bne	resync
}		

.macro IRQ_WaitForVBlank()
{
		lda #$00
		sta Signal_VBlank

		lda Signal_VBlank
		beq *-3
}

.macro IRQManager_Init()
{
		lda $d011
		and #$80
		beq *-5

		lda #$7f
		sta $dc0d //; Turn off CIA 1 interrupts
		sta $dd0d //; Turn off CIA 2 interrupts
		lda $dc0d //; Acknowledge CIA 1 interrupts
		lda $dd0d //; Acknowledge CIA 2 interrupts

		lda #$01
		sta VIC_D01A //; Turn on raster interrupts
}

.macro IRQManager_SetIRQs()
{
		stx IRQManager_IRQTablePtr + 0
		sty IRQManager_IRQTablePtr + 1
		
		lda #$00
		sta IRQManager_IRQIndexMUL4
		
		IRQManager_NextIRQ()

		asl VIC_D019 //; Acknowledge VIC interrupts
}

.macro IRQManager_RestoreDefault(bShouldWaitForVBlank, bShouldBlankScreen)
{
		.if(bShouldWaitForVBlank != 0)
		{
			lda #$00
			sta Signal_VBlank

			lda Signal_VBlank
			beq *-3
		}

		sei
		lda VIC_D011
		.if(bShouldBlankScreen != 0)
		{
			and #$07
		}
		ora #$80
		sta VIC_D011

		lda #$00
		sta VIC_D012

		lda #<MAIN_DefaultIRQ_BASE
		sta $fffe
		lda #>MAIN_DefaultIRQ_BASE
		sta $ffff

		lda #$00
		sta Signal_VBlank

		cli
}

.macro IRQManager_BeginIRQ(bWithStableRaster, JitterAmount)
{
	dec	0
	sta IRQ_RestoreA
	.if(bWithStableRaster == 1)
	{
		lda	#39 - JitterAmount
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
	}
	stx IRQ_RestoreX
	sty IRQ_RestoreY
}

.macro IRQManager_EndIRQ()
{
		asl VIC_D019 //; Acknowledge VIC interrupts

		lda IRQ_RestoreA
		ldx IRQ_RestoreX
		ldy IRQ_RestoreY

		inc 0
}

.macro IRQManager_NextIRQ()
{
		ldy IRQManager_IRQIndexMUL4
		lda VIC_D011
		and #$7f
		ora (IRQManager_IRQTablePtr), y
		sta VIC_D011
		iny
		lda (IRQManager_IRQTablePtr), y
		sta VIC_D012
		iny
		lda (IRQManager_IRQTablePtr), y
		sta $fffe
		iny
		lda (IRQManager_IRQTablePtr), y
		sta $ffff
		lda #$01
		sta VIC_D01A
		iny
		lda (IRQManager_IRQTablePtr), y
		cmp #$ff
		bne *+4
		ldy #$00
		sty IRQManager_IRQIndexMUL4
}

.macro IRQManager_SetIRQIndex(index)
{
		lda #(index * 4)
		sta IRQManager_IRQIndexMUL4
}

.macro ClearGlobalVariables()
{
		ldx #NumGlobalVariablesToClear - 1
		lda #$00
		sta GlobalVariables, x
		dex
		bpl *-4
}

//; FadeMusicAndCopyNew() -------------------------------------------------------------------------------------------------------
.macro FadeMusicAndCopyNew(SetVolumeJMP, CopyFromAddress, CopyNumPages)
{
	.label FadeMusic_FadeLoop = *
		lda #$00
		sta FrameOf256

	.label FadeMusic_Wait8Frames = *
		lda FrameOf256
		cmp #$08
		bne FadeMusic_Wait8Frames

	.label FadeMusic_MusicVolume = * + 1
		ldx #$0f
		dex
		bmi FadeMusic_Done
		stx FadeMusic_MusicVolume
		txa
		jsr SetVolumeJMP
		jmp FadeMusic_FadeLoop

	.label FadeMusic_Done = *
		sei
		ldy #$00

		ldx #CopyNumPages
	.label FadeMusic_CopyLoop = *
		lda CopyFromAddress, y
		sta $1000, y
		iny
		bne FadeMusic_CopyLoop
		inc FadeMusic_CopyLoop + 2
		inc FadeMusic_CopyLoop + 5
		dex
		bne FadeMusic_CopyLoop

		lda #$00
		tax
		tay
		jsr Music_Init
		cli
}
