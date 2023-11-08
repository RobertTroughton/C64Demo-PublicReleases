//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	.macro OpenKernelRAM()
	{
		inc $00
		dec $01
	}

	.macro CloseKernelRAM()
	{
		inc $01
		dec $00
	}

	.macro IRQ_WaitForVBlank()
	{
		lda #$00
		sta Signal_VBlank

		lda Signal_VBlank
		beq *-3
	}

	.macro IRQManager_BeginIRQ(bWithStableRaster, JitterAmount)
	{
		dec	0
		sta IRQ_RestoreA

		.if(bWithStableRaster == 1)
		{
			:compensateForJitter(JitterAmount)
		}

		stx IRQ_RestoreX
		sty IRQ_RestoreY
	}

	.macro IRQManager_EndIRQ()
	{
		asl VIC_D019
		lda IRQ_RestoreA
		ldx IRQ_RestoreX
		ldy IRQ_RestoreY
		inc 0
	}

	.macro stabilizeRaster()
	{
		ldx $d012
		inx
		cpx $d012
		bne *-3
		ldy #$0a
		dey
		bne *-1
		inx
		cpx $d012
		nop
		beq *+5
		nop
		bit $24
		ldy #$09
		dey
		bne *-1
		nop
		nop
		inx
		cpx $d012
		nop
		beq *+4  
		bit $24
		ldy #$0a
		dey
		bne *-1
		inx
		cpx $d012
		bne *+2
		nop
	}

	.macro compensateForJitter(JitterAmount)
	{
		lda	#(29 + JitterAmount)
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

	.macro MACRO_SetVICBank(Bank)
	{
		lda #(60 + Bank)
		sta VIC_DD02
	}

	.macro	GlobalSync(SyncPoint)
	{
		ldx	#<SyncPoint
		lda	#>SyncPoint
		jsr	BASECODE_WaitForSync
	}