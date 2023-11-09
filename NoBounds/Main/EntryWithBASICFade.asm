//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "../Build/6502/MAIN/Main-BaseCode.sym"

* = ENTRY_BASE "entry"

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:

	//; NTSC check -------------------------------------------------------------------------------------------------------------

		//;DetectNTSC()		

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------

		jsr PreDemoSetup

		bit VIC_D011
		bmi *-3

		ldx #$00
		stx MARKER_IsFullDemo
		inx
		stx IRQLoader_BundleIndex

		jsr Sparkle_LoadNext		//; #MAIN-BASECODE (Bundle #01)

		jsr BASE_DetectNTSC			//; Exit with soft reset if NTSC is detected

		jsr IRQLoader_LoadNext		//; Load SID and BASICFade (Bundle #02)

		lda #$00
		sta MUSIC_FrameLo
		sta MUSIC_FrameHi
		sta PART_Done

	InitMusicJSR:
		jsr BASE_InitMusic

		jsr BASE_SetDefaultIRQ

		sei

		jsr $4000					//; BASICFade1

		jsr IRQLoader_LoadNext		//; Preload StarWars

	Loop:
		bit $088f
		beq Loop

		ldy #>(PART_ENTRY-1)
		ldx #<(PART_ENTRY-1)
		jmp $e300					//; BASICFade2

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