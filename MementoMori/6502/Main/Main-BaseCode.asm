//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

*= MAIN_BASECODE

//; BASECODE_PlayMusic() -------------------------------------------------------------------------------------------------------
BASECODE_PlayMusic:
		inc GlobalTimerLo
		bne PlayMusicJMP
		inc GlobalTimerHi
	PlayMusicJMP:
		jmp MusicAddr + 3

//; BASECODE_StopMusic() -------------------------------------------------------------------------------------------------------
BASECODE_StopMusic:
		lda #RTS
		sta PlayMusicJMP + 0
		rts

//; BASECODE_StartMusic() -------------------------------------------------------------------------------------------------------
BASECODE_StartMusic:
		lda #$00
		jsr MusicAddr + 0
		lda #JMP_ABS
		sta PlayMusicJMP + 0
		//; fall through to InitGlobalTimer()

//; BASECODE_InitGlobalTimer() -------------------------------------------------------------------------------------------------------
BASECODE_InitGlobalTimer:
		lda #$00
		sta GlobalTimerLo
		sta GlobalTimerHi
		rts

//; BASECODE_WaitForSync() -------------------------------------------------------------------------------------------------------
BASECODE_WaitForSync:				//;X/A=SyncPoint Lo/Hi
		cmp GlobalTimerHi
		beq CheckLo					//;Global Timer Hi = Sync Point Hi, compare Lo bytes
		bcs BASECODE_WaitForSync	//;Global Timer Hi < Sync Point Hi, compare Hi bytes again
		rts
	
	CheckLo:
		cpx GlobalTimerLo		//;Global Timer Hi = Sync Point Hi, comparing Lo bytes
		beq SyncEnd				//;Global Timer Lo = Sync Point Lo, sync done
		bcs CheckLo				//;Global Timer Lo < Sync Point Lo, compare Lo Bytes again
	SyncEnd:
		rts

//; BASECODE_TurnOffScreenAndSetDefaultIRQ() -------------------------------------------------------------------------------------------------------
BASECODE_TurnOffScreenAndSetDefaultIRQ:
		lda #$00
		sta VIC_D011

//; BASECODE_SetDefaultIRQ() -------------------------------------------------------------------------------------------------------
BASECODE_SetDefaultIRQ:
		sei
		lda VIC_D011
		and #$7f
		sta VIC_D011

		lda #$00
		sta VIC_D012
		sta Signal_VBlank

		ldx #<DEFIRQ_DefaultIRQ
		ldy #>DEFIRQ_DefaultIRQ
		stx $fffe
		sty $ffff

		cli
		rts

//; DEFIRQ_DefaultIRQ() -------------------------------------------------------------------------------------------------------
DEFIRQ_DefaultIRQ:
		dec $00

		pha
		txa
		pha
		tya
		pha

		jsr BASECODE_PlayMusic

		inc Signal_VBlank
		inc FrameOf256
		bne Not256Here
		inc Frame_256Counter
	Not256Here:

		asl VIC_D019
		pla
		tay
		pla
		tax
		pla

		inc $00

		rti

//; BASECODE_ClearGlobalVariables() -------------------------------------------------------------------------------------------------------
BASECODE_ClearGlobalVariables:
		ldx #NumGlobalVariablesToClear - 1
		lda #$00
	ClearLoop:
		sta GlobalVariables,x
		dex
		bpl ClearLoop
		rts

//; BASECODE_InitialiseD000() -------------------------------------------------------------------------------------------------------
BASECODE_InitialiseD000:
		sta D000SkipValue + 1
		stx SetupD000ValuesLoop + 1
		sty SetupD000ValuesLoop + 2

	LookupTable:
		ldy #$2e
	SetupD000ValuesLoop:
		lda $abcd,y
	D000SkipValue:
		cmp #$ee
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop
		rts

BASECODE_VSync:
		bit $d011
		bpl *-3
		bit $d011
		bmi *-3
		rts
