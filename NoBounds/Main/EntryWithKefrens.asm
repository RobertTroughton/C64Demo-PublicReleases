//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "../Build/6502/MAIN/Main-BaseCode.sym"


* = ENTRY_BASE "entry"

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:
	

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
	
		jsr PreDemoSetup

		bit VIC_D011
		bmi *-3

		ldx #$00
		stx MARKER_IsFullDemo
		inx
		stx IRQLoader_BundleIndex

		jsr Sparkle_LoadNext		//; #MAIN-BASECODE

		jsr BASE_DetectNTSC			//; Exit with soft reset if NTSC is detected
		
		jsr IRQLoader_LoadNext		//; MUSIC
		
		lda #$00
		sta MUSIC_FrameLo
		sta MUSIC_FrameHi
	InitMusicJSR:
		jsr $f000

		nsync()

		jsr BASE_Cleanup
		
		sei

		ldy #$03
		ldx #$f0
		sty	Sparkle_IRQ_JSR+1		//; Update music call in default IRQ
		stx	Sparkle_IRQ_JSR+2

		lda #>(PART_ENTRY-1)
		pha
		lda #<(PART_ENTRY-1)
		pha
		jmp IRQLoader_LoadNext		//; #PART1, loader returns to address of PART_ENTRY after job finished

//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//; This PreDemoSetup stuff will be done ONCE and can then be happily overwritten ...

//; * = ENTRY_BASE + $40 "predemosetup"

PreDemoSetup:

		//; from Spindle by lft, www.linusakesson.net/software/spindle/
		//; Prepare CIA #2 timer B to compensate for interrupt jitter.
		//; Also initialise d01a and dc02.
		//; This code is inlined into prgloader, and also into the
		//; first effect driver by pefchain.
		bit VIC_D011
		bmi *-3

		bit VIC_D011
		bpl *-3

		ldx VIC_D012
		inx
	resync:
		cpx VIC_D012
		bne *-3

		ldy #00
		sty $dd07
		lda #62
		sta $dd06
		iny
		sty VIC_D01A
		dey
		dey
		sty $dc02
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		lda #$11
		sta $dd0f
		txa
		inx
		inx
		cmp VIC_D012
		bne resync

		rts
