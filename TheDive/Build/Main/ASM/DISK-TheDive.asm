//; (c) 2018-2019, Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

*= DISK_BASE "Disk Base"

.var StarWarsNUC_EndOfMemory = $78b1 //; reverse decrunch ... this is LastByte + 1

Entry:

	//; BEGIN BASICFADE -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #BASICFADE

		jsr BASICFADE_BASE

	WAVE_MusicDelay:
		lda MUSIC_FrameLo
		cmp #120
		bcc WAVE_MusicDelay

		jsr BASECODE_StartMusic

	WAVE_Wait:
		lda Signal_CurrentEffectIsFinished
		beq WAVE_Wait

		jsr BASECODE_TurnOffScreenAndSetDefaultIRQ
	//; END BASICFADE -------------------------------------------------------------------------------------------------------

	//; QUOTE -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #QUOTE

		jsr Quote_BASE + GP_HEADER_Init

	Quote_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq Quote_MainLoop

		jsr Quote_BASE + GP_HEADER_Exit
	//; END QUOTE

	//; BEGIN VertBitmap -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #VERTBITMAP

		ldx #$0e
		ldy #$03
		jsr FullScreenRasterSweep_BASE

		jsr VertBitmap_BASE + GP_HEADER_Init

	VB_MainLoop:
		lda Signal_CustomSignal0
		beq VB_MainLoop
		jsr VertBitmap_BASE + GP_HEADER_MainThreadFunc
		lda Signal_CustomSignal1
		beq VB_MainLoop

		jsr IRQLoader_LoadNext //; #ROTATESCROLLER-PRELOAD

	VB_LoopTillFinished:
		lda Signal_CurrentEffectIsFinished
		beq VB_LoopTillFinished

		jsr VertBitmap_BASE + GP_HEADER_Exit
	//; END VertBitmap

	//; BEGIN RotateScroller -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #ROTATESCROLLER

		jsr RotateScroller_BASE + GP_HEADER_Init

	RS_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq RS_MainLoop

	RS_Finished:
		jsr RotateScroller_BASE + GP_HEADER_Exit
	//; END RotateScroller

	//; BEGIN SpinnyShapes -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #SPINNYSHAPES

		ldx #$00
		ldy #$06
		jsr FullScreenRasterSweep_BASE

		jsr SpinnyShapes_BASE + GP_HEADER_Init

		jsr IRQLoader_LoadNext //; #SPRITEBOBS-PRELOAD

	SS_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq SS_MainLoop

		jsr SpinnyShapes_BASE + GP_HEADER_Exit
	//; END SpinnyShapes

	//; BEGIN SpriteBobs -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #SPRITEBOBS

		ldx #$06
		ldy #$03
		jsr FullScreenRasterSweep_BASE

		jsr SpriteBobs_BASE + GP_HEADER_Init
	
	SB_MainLoop:
		:IRQ_WaitForVBlank()

		lda Signal_CurrentEffectIsFinished
		bne SB_Finished

		jsr SpriteBobs_BASE + GP_HEADER_MainThreadFunc
		jmp SB_MainLoop

	SB_Finished:
		jsr SpriteBobs_BASE + GP_HEADER_Exit
	//; END SpriteBobs

	//; BEGIN Deep Sea Dots -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #DEEPSEADOTS

		ldx #$03
		ldy #$00
		jsr FullScreenRasterSweep_BASE

		jsr DeepSeaDots_BASE + GP_HEADER_Init

		jsr IRQLoader_LoadNext //; #SBB-PRELOAD

	DSD_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq DSD_MainLoop

		jsr DeepSeaDots_BASE + GP_HEADER_Exit
	//; END Deep Sea Dots -------------------------------------------------------------------------------------------------------

	//; BEGIN Side Border Bitmap -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #SBB

		jsr SBB_BASE + GP_HEADER_Init

	SBB_MainLoop:
		lda Signal_VBlank
		beq SBB_MainLoop

		lda #$00
		sta Signal_VBlank

		jsr SBB_BASE + GP_HEADER_MainThreadFunc

		lda Signal_CurrentEffectIsFinished
		beq SBB_MainLoop

		jsr SBB_BASE + GP_HEADER_Exit
	//; END Side Border Bitmap -------------------------------------------------------------------------------------------------------

	//; BIGDYPP -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #BIGDYPP

		ldx #$00
		ldy #$06
		jsr FullScreenRasterSweep_BASE

		jsr BIGDYPP_BASE + GP_HEADER_Init

	BIGDYPP_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq BIGDYPP_MainLoop

		jsr BIGDYPP_BASE + GP_HEADER_Exit
	//; END BIGDYPP

	//; BEGIN StarWars -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #STARWARS
		ldx #<StarWarsNUC_EndOfMemory
		lda #>(StarWarsNUC_EndOfMemory-1)
		jsr NUCRUNCH_Decrunch

		ldx #$06
		ldy #$0e
		jsr FullScreenRasterSweep_BASE

		ldx #$0e
	SetVolumeLoop:
		ldy #12
		stx $119d

	TimedWait:
		lda #$00
		sta Signal_VBlank
	WaitForVBlankLoop:
		lda Signal_VBlank
		beq WaitForVBlankLoop
		dey
		bne TimedWait
		dex
		bpl SetVolumeLoop

		jsr BASECODE_StopMusic

		jsr IRQLoader_LoadNext //; #ENDTUNE

		lda #$10
		jsr BASECODE_InitMusicPlayer
		jsr BASECODE_StartMusic

		jsr StarWars_BASE
	//; END StarWars

	//; GPLogo -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #GPLOGO

		jsr GPLogo_BASE + GP_HEADER_Init

	GPLOGO_Loop:
		lda Signal_VBlank
		beq GPLOGO_Loop
		jsr GPLogo_BASE + GP_HEADER_MainThreadFunc
		lda #$00
		sta Signal_VBlank
		jmp GPLOGO_Loop
	//; END GPLogo

BorderColours:
	.byte $00, $00, $00, $00, $00, $00, $0b, $0b, $0b, $0c, $0c, $0c, $0e, $0e, $0e