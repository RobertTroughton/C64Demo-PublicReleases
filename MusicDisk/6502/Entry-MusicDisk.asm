//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	.import source										"Main-CommonDefines.asm"
	.import source										"Main-CommonMacros.asm"

*= ENTRY_BASE

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
		jsr PreDemoSetup
		jmp DISK_BASE

MusicPtrs:
	.byte <$0800, >$0800, <$0803, >$0803	//; MusicInit / MusicPlay
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//; This PreDemoSetup stuff will be done ONCE and can then be happily overwritten ...

*= ENTRY_BASE + $40

PreDemoSetup:

		//; from Spindle by lft, www.linusakesson.net/software/spindle/
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

		ldy	#0
		sty	$dc07
		lda	#62
		sta	$dc06
		iny
		sty	VIC_D01A
		dey
		dey
		sty	$dc02
		cmp	(0,x)
		cmp	(0,x)
		cmp	(0,x)
		lda	#$11
		sta	$dc0f
		txa
		inx
		inx
		cmp	VIC_D012
		bne	resync


		//; Regular IRQ setup
		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dc0d
		lda $dd0d

		bit $d011
		bpl *-3
		bit $d011
		bmi *-3

		lda #$01
		sta VIC_D01A

		rts
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
