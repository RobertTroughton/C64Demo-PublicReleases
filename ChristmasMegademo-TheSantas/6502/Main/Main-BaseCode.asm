//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

* = MAIN_BASECODE "basecode"

//; BASE_MusicPlay() -------------------------------------------------------------------------------------------------------
BASE_MusicPlay:
		inc MUSIC_FrameLo
		bne NotZero
		inc MUSIC_FrameHi
	NotZero:

	MusicPlayJMP:
		jmp $1003

//; BASE_InitMusic() -------------------------------------------------------------------------------------------------------
BASE_InitMusic:

		stx MusicInitJMP + 2
		stx MusicPlayJMP + 2

		lda #$00
		sta MUSIC_FrameLo
		sta MUSIC_FrameHi

	MusicInitJMP:
		jmp $1000

//; BASE_Cleanup()------------------------------------------------------------------------------------------------------------
BASE_Cleanup:

		lda	#$35				//;To make sure I/O is ON
		sta	$01

		lda #$00
		sta $d015				//;Sprites off
		sta $d017				//;Sprite Y-expand off
		ldx #$13
	CleanupLoop:
		sta $d03e,x				//;Sprite coords + screen off
		cpx #$05
		beq SkipWrite			//;Skips $d020
		sta $d01b,x				//;Sprite regs and screen colors
	SkipWrite:
		dex
		bpl CleanupLoop

		:MACRO_SetVICBank(0)	//;Restoring VIC Bank 0

//; BASE_TurnOffScreenAndSetDefaultIRQ() -------------------------------------------------------------------------------------------------------
BASE_TurnOffScreenAndSetDefaultIRQ:
		lda #$00
		sta VIC_D011

//; BASE_SetDefaultIRQ() -------------------------------------------------------------------------------------------------------
BASE_SetDefaultIRQ:
		sei

		ldx #$7f				//;Disabling CIA interrupts
		stx $dc0d
		stx $dd0d
		lda $dd0d-$7f,x			//;Acknowledging interrupts to both CIAs at the same time :)

		lda #<IRQLoader_RTI		//;Restoring NMI vector for NMI lock
		sta $fffa
		lda #>IRQLoader_RTI
		sta $fffb

		lda VIC_D011
		and #$7f
		sta VIC_D011

		lda #$00
		ldx #>BASE_PlayMusic
		ldy #<BASE_PlayMusic
		jsr IRQLoader_SetIRQandPlayer

		asl $d019

		cli
		rts

//; BASE_MusicSync()------------------------------------------------------------------------------------------------------------
BASE_MusicSync:				//;A/X = sync frame Hi/Lo
	CheckHi:
		cmp MUSIC_FrameHi	//;Wait for MUSIC_FrameHi to catch up with A
		bne NotEqual
		cpx MUSIC_FrameLo	//;MUSIC_FrameHi = A, now wait for MUSIC_FrameLo to catch up with X
		beq SyncDone
	NotEqual:
		bcs CheckHi
	SyncDone:
		rts
