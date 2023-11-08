//; (c) 2018-2019, Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

*= MAIN_BASECODE "Main-BaseCode"

		jmp DEFIRQ_TurnOffScreenAndSetDefaultIRQ
		jmp DEFIRQ_SetDefaultIRQ
		jmp DEFIRQ_SetScreenCol
		jmp ClearGlobalVariables
		jmp InitialiseD000
		jmp InitMusicPlayer
		jmp MusicPlayer_StartMusic
		jmp MusicPlayer_StopMusic
//;		jmp MusicPlayer

	.var ZP_Music = $3f

MusicPlayer:
		inc MUSIC_FrameLo
		bne NotZero
		inc MUSIC_FrameHi
	NotZero:

		lda ZP_Music + 0
		sta RestoreDemoZP0 + 1
		lda ZP_Music + 1
		sta RestoreDemoZP1 + 1
		
	RestoreMusicZP0:
		lda #$00
		sta ZP_Music + 0
	RestoreMusicZP1:
		lda #$00
		sta ZP_Music + 1

	PlayMusicJSR:
		jsr $1003

		lda ZP_Music + 0
		sta RestoreMusicZP0 + 1
		lda ZP_Music + 1
		sta RestoreMusicZP1 + 1

	RestoreDemoZP0:
		lda #$00
		sta ZP_Music + 0
	RestoreDemoZP1:
		lda #$00
		sta ZP_Music + 1

	//; test for music trigger ------------------------------
/*		ldx #$00
		lda $103f
	Last103F:
		cmp #$20
		beq NoChange
		sta Last103F + 1
		inx
	NoChange:
		stx Signal_MusicTrigger*/
	//; test for music trigger ------------------------------

		rts

InitMusicPlayer:
		sta InitMusicJMP + 2
		sta PlayMusicJSR + 2

		jsr MusicPlayer_StopMusic

		lda #$00
		sta MUSIC_FrameLo
		sta MUSIC_FrameHi

	InitMusicJMP:
		jmp $1000

MusicPlayer_StartMusic:
		lda #JSR_ABS
		sta PlayMusicJSR + 0
		rts
MusicPlayer_StopMusic:
		lda #RTS
		sta PlayMusicJSR + 0
		rts

DEFIRQ_TurnOffScreenAndSetDefaultIRQ:
		lda #$00
		sta VIC_D011

DEFIRQ_SetDefaultIRQ:
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

		lda VIC_BorderColour
DEFIRQ_SetScreenCol:
		sta DEFIRQ_ScreenCol + 1
		rts

//; DefaultIRQMain() -------------------------------------------------------------------------------------------------------
DEFIRQ_DefaultIRQ:
		:IRQManager_BeginIRQ(0, 0)

	DEFIRQ_ScreenCol:
		lda #$0e
		sta VIC_BorderColour
	 	
		jsr BASECODE_PlayMusic

		inc Signal_VBlank

		inc FrameOf256
		bne DEFIRQ_Not256
		inc Frame_256Counter
	DEFIRQ_Not256:

		:IRQManager_EndIRQ()

		rti

ClearGlobalVariables:
		ldx #NumGlobalVariablesToClear - 1
		lda #$00
	ClearLoop:
		sta GlobalVariables, x
		dex
		bpl ClearLoop
		rts

InitialiseD000:
		stx $f0
		sty $f1
		ldy #$00

		lda ($f0), y
		sta D000SkipValue + 1

		ldy #$2f
	SetupD000ValuesLoop:
		lda ($f0), y
	D000SkipValue:
		cmp #$ee
		beq SkipThisOne
		sta VIC_Sprite0X - 1, y
	SkipThisOne:
		dey
		bne SetupD000ValuesLoop
		rts
