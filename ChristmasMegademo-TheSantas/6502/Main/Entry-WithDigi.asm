//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "..\..\Out\6502\Main\Main-BaseCode.sym"

* = ENTRY_BASE "entry"

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:

		lda #$01
		sta VIC_D011
		sta VIC_BorderColour
		sta VIC_ScreenColour

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
		jsr PreDemoSetup

		jsr IRQLoader_LoadNext		//; #MAIN-BASECODE + MUSIC
		jsr IRQLoader_LoadNext		//; #DIGI
		
		jsr TrapDigiLamer_BASE		//; Play digi only if disk started from Basic...

		ldx #$09
		jsr BASE_InitMusic

		jsr BASE_SetDefaultIRQ

		lda #>(PART_ENTRY-1)
		pha
		lda #<(PART_ENTRY-1)
		pha
		jmp IRQLoader_LoadNext		//; #PART1, loader returns to address of PART_ENTRY after job finished

//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//; This PreDemoSetup stuff will be done ONCE and can then be happily overwritten ...

* = ENTRY_BASE + $40 "predemosetup"

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

		rts
