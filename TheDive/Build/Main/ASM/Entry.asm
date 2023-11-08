//; (c) 2018-2019, Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

*= ENTRY_BASE "Entry"

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
		jsr PreDemoSetup

		jsr IRQLoader_LoadNext //; #MAIN-BASECODE
		
	//; music initialization
		lda #$10	//; hibyte of music address
		jsr BASECODE_InitMusicPlayer

		jsr BASECODE_SetDefaultIRQ

		jsr IRQLoader_LoadNext //; #MAIN-DISK1
		jmp DISK_BASE

//; This PreDemoSetup stuff will be done ONCE and can then be happily overwritten ...
*= ENTRY_BASE + $40

PreDemoSetup:

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


//; Regular IRQ setup
		lda #$7f
		sta $dc0d //; Turn off CIA 1 interrupts
		sta $dd0d //; Turn off CIA 2 interrupts
		lda $dc0d //; Acknowledge CIA 1 interrupts
		lda $dd0d //; Acknowledge CIA 2 interrupts

		bit $d011
		bpl *-3
		bit $d011
		bmi *-3

		lda #$01
		sta VIC_D01A //; Turn on raster interrupts

		rts
