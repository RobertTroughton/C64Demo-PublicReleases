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

	.macro IRQManager_BeginIRQ(bWithStableRaster, JitterAmount)
	{
		dec	0
		pha
		nop

		.if (bWithStableRaster == 1)
		{
			compensateForJitter(JitterAmount)
		}

		txa
		pha
		tya
		pha
	}

	.macro IRQManager_EndIRQ()
	{
		pla
		tay
		pla
		tax
		pla

		inc 0

		asl VIC_D019
	}

	.macro vsync()
	{
		bit $d011
		bpl *-3
		bit $d011
		bmi *-3
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

	.macro compensateForJitter(JA)
	{
		lda	#(29 + JA)
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
