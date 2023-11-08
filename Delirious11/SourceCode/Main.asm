//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

*= $0200 "Main Entry"

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:
	
	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
		ldx #$00
	Entry_CopyScreenData:
		lda $0400,x
		sta $8400,x
		lda $0500,x
		sta $8500,x
		lda $0600,x
		sta $8600,x
		lda $0700,x
		sta $8700,x
		inx
		bne Entry_CopyScreenData
		
		lda #$3e
		sta $dd02

		jsr ClearGlobalVariables

	//; music initialization
		lda #$00
		jsr Music_Init
		
	//; We should wait a few frames so that DD02 etc has time to take effect
	//; Because the first load will load up IRQManager - which goes at $0500
		ldx #$02
	STARTUP_WaitAFewFrames1:
		lda $d012
		cmp #$ff
		bne STARTUP_WaitAFewFrames1
	STARTUP_WaitAFewFrames2:
		lda $d012
		cmp #$20
		bne STARTUP_WaitAFewFrames2
		dex
		bne STARTUP_WaitAFewFrames1

		jsr Spindle_LoadNextFile //; #IRQMANAGER_AND_SCREENFADE
		
		jsr IRQManager_Init
	//; END Demo Setup

	//; BEGIN Startup Screen Fade -------------------------------------------------------------------------------------------------------
		jsr StartupScreenFade_Init

	SSF_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq SSF_WaitForFinish

		jsr StartupScreenFade_End
	//; END Startup Screen Fade
	
	//; BEGIN Startup Screen Fade 2 -------------------------------------------------------------------------------------------------------
		jsr StartupScreenFade2_Init

		jsr Spindle_LoadNextFile //; #BEDINTRO

	SSF2_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq SSF2_WaitForFinish

		jsr StartupScreenFade2_End
	//; END Startup Screen Fade
	//; BEGIN Bed Intro -------------------------------------------------------------------------------------------------------
		jsr BedIntro_Init

		jsr Spindle_LoadNextFile //; #FULLSCREENRASTERS_AND_QUOTE_SCREEN

	BI_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq BI_WaitForFinish
		
		jsr BedIntro_End
		
		//; Wait a couple of frames to make sure we have a clean switchover
		lda #$00
		sta ValueD011
		sta Signal_VBlank
	BI_WaitForVBlank:
		lda Signal_VBlank
		beq BI_WaitForVBlank
	//; END Bed Intro

	//; BEGIN Full Screen Rasters -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr FullScreenRasters_Init
	
	FSR_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq FSR_WaitForFinish
	//; END Full Screen Rasters
	
	//; BEGIN logo faders -------------------------------------------------------------------------------------------------------
		jsr LogoFader_Init
		
	LF_WaitForFinish:
		lda #$01
	WaitForVBlank1:
		cmp Signal_VBlank
		bne WaitForVBlank1
		dec Signal_VBlank

		jsr LogoFader_MainThreadFunction //; SpindleLoads .. 1: #INTROLOGO-GP, 2: #INTROLOGO-PRESENTS, 3: #INTROLOGO-DELIRIOUS11, 4: #INTROLOGO-JUSTSTRIPES, 5: #FULLSCREENRASTERS(2)

	LF_CheckForEndOfPart:

		lda Signal_CurrentEffectIsFinished
		beq LF_WaitForFinish

	LF_Finished:
		lda #$00
		sta ValueSpriteEnable
		sta spriteEnable

		jsr Spindle_LoadNextFile //; #PREPOSTCREDITSFADE_AND_CREDITS_CODE_RAISTLIN

		jsr LogoFader_End
	//; END logo faders
		
	//; BEGIN Full Screen Rasters 2 -------------------------------------------------------------------------------------------------------
		lda #$01
		jsr FullScreenRasters_Init
	
	FSR_WaitForFinish2:
		lda Signal_CurrentEffectIsFinished
		beq FSR_WaitForFinish2
		
		jsr FullScreenRasters_End
	//; END Full Screen Rasters 2
	
	//; BEGIN Simple Credits -------------------------------------------------------------------------------------------------------
	//; (a) Fade In To Grey Screen
		lda #$00
		jsr PrePostCreditsFade_Init
	PPCF_WaitForFinish1:
		lda Signal_CurrentEffectIsFinished
		beq PPCF_WaitForFinish1
		jsr PrePostCreditsFade_End
		
	//; (b) Main Credits Bit
		jsr SimpleCredits_Init
	
	SC_WaitForFinish:
		lda Signal_SpindleLoadNextFile
		beq SC_DontLoadNextFile
		dec Signal_SpindleLoadNextFile
		jsr Spindle_LoadNextFile //; 1: #CREDITS_SOUND_MCH, 2: #CREDITS_CELTICDESIGN, 3: #CREDITS_ART_RAZORBACK, 4: #CREDITS_REDCRAB, 5: #CREDITS_RAISTLIN, 6: #CREDITS_HEDNING, 7: #HEADACHE
	SC_DontLoadNextFile:
		lda Signal_CurrentEffectIsFinished
		beq SC_WaitForFinish
		
		jsr SimpleCredits_End
	
	//; (c) Fade Out To Black Screen
		lda #$01
		jsr PrePostCreditsFade_Init

	PPCF_WaitForFinish2:
		lda Signal_CurrentEffectIsFinished
		beq PPCF_WaitForFinish2
		jsr PrePostCreditsFade_End
	//; END Simple Credits

	//; BEGIN Koala Pic (Headache) -------------------------------------------------------------------------------------------------------
		lda #$00
		sta ValueD011
		jsr Headache_Init
		jsr Spindle_LoadNextFile //; #SPRITEBOBS1
		
	NC_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq NC_WaitForFinish

		jsr Headache_End
	//; END Koala Pic

	//; BEGIN SpriteBobs -------------------------------------------------------------------------------------------------------
		lda #$3e
		sta ValueDD02
		jsr Spindle_LoadNextFile //; #SPRITEBOBS2

		jsr SpriteBobs_Init
	LoopHereForSpriteBobs:
		lda Signal_VBlank
		beq LoopHereForSpriteBobs
		dec Signal_VBlank

		jsr SpriteBobs_MainThreadFunction
		lda Signal_CurrentEffectIsFinished
		beq LoopHereForSpriteBobs

	EndSpriteBobs:
		lda #$00
		sta ValueD011
		sta $d011
		jsr SpriteBobs_End
	//; END SpriteBobs

	//; BEGIN The Eye -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #THEEYE_PIC
		
		jsr TheEye_Init
		
		jsr Spindle_LoadNextFile //; #SCREENHASH

	TheEyeWait0:
		lda Signal_CurrentEffectIsFinished
		beq TheEyeWait0
		
		jsr TheEye_End
	//; END The Eye

	//; BEGIN ScreenHash -------------------------------------------------------------------------------------------------------
		jsr ScreenHash_Init
		jsr Spindle_LoadNextFile

	WaitForEndOfScreenHash:
		lda Signal_CurrentEffectIsFinished
		beq WaitForEndOfScreenHash

		jsr ScreenHash_End

	//; END ScreenHash

	//; BEGIN Greetings -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile
		jsr Greetings_Init

	GREET_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		bne GREET_Finished

		lda Signal_VBlank
		beq GREET_WaitForFinish

		lda #$00
		sta Signal_VBlank
		jsr Greetings_MainThreadFunction
		jmp GREET_WaitForFinish

	GREET_Finished:
		jsr Greetings_End
	//; END Greetings

	//; BEGIN rotating stars -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile
		jsr RotatingStars_Init
		
	LoopHereeeee:
		lda Signal_SpindleLoadNextFile
		beq RS_DontSpindleLoad
		dec Signal_SpindleLoadNextFile
		jsr Spindle_LoadNextFile
	RS_DontSpindleLoad:
		lda Signal_CurrentEffectIsFinished
		beq LoopHereeeee
		
		jsr RotatingStars_End
	//; END rotating stars

	//; BEGIN planet -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile
		jsr WavyLineCircle_Init
	PLANET_WaitForEnd:
		lda Signal_CurrentEffectIsFinished
		beq PLANET_WaitForEnd
		jsr WavyLineCircle_End
	//; END planet -------------------------------------------------------------------------------------------------------

	//; BEGIN Volume Fader -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr FillColorMemory

	VolumeFader:
		ldx #$0f
	VF_Loop:
		lda Signal_VBlank
		beq VF_Loop

		lda #$00
		sta Signal_VBlank

		lda FrameOf256
		and #$0f
		bne VF_Loop

		dex
		cpx #$ff
		beq Finished_VolumeFader
		stx $1160 //; MUSIC VOLUME MOD LOCATION...
		jmp VF_Loop
	Finished_VolumeFader:
	//; END Volume Fader -------------------------------------------------------------------------------------------------------
	
		sei
		lda #$00
		sta $d418
		jsr Spindle_LoadNextFile
		lda #$00
		jsr Music_Init
		cli

	//; BEGIN UPSCROLL -------------------------------------------------------------------------------------------------------
		jsr UpScroll_Init
		jsr Spindle_LoadNextFile
		lda #$01
	UpScrollWait:
		cmp Signal_CurrentEffectIsFinished
		bne UpScrollWait

		jsr UpScroll_End
	//; END UPSCROLL -------------------------------------------------------------------------------------------------------
		
	//; BEGIN END SCREEN -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile
		jsr EndCredits_Init
	END_WaitForFinish:
		lda Signal_VBlank
		beq END_WaitForFinish

		lda #$00
		sta Signal_VBlank
		jsr EndCredits_MainThreadFunction
		jmp END_WaitForFinish
	//; END END SCREEN -------------------------------------------------------------------------------------------------------

//; ClearGlobalVariables() -------------------------------------------------------------------------------------------------------
ClearGlobalVariables:
		lda #$00
		ldx #$17
	ClearGlobalVariablesLoop:
		sta GlobalVariables, x
		dex
		bpl ClearGlobalVariablesLoop
		
		lda $dd02
		sta ValueDD02
		lda $d018
 		sta ValueD018
 		lda $d016
 		sta ValueD016
 		lda $d021
 		sta ValueD021
 		lda $d022
 		sta ValueD022
 		lda $d023
 		sta ValueD023
		
		rts

//; FillColorMemory() -------------------------------------------------------------------------------------------------------
FillColorMemory:		
		ldx #$00
	FillColorLoop:
		sta $d800 + 0,x
		sta $d800 + 256,x
		sta $d800 + 512,x
		sta $d800 + 768,x
		inx
		bne FillColorLoop
		rts

//; DisplayKoalaPic() -------------------------------------------------------------------------------------------------------
DisplayKoalaPic:
		stx KP_SetColourScreen + 2 + (6 * 0)
		inx
		stx KP_SetColourScreen + 2 + (6 * 1)
		inx
		stx KP_SetColourScreen + 2 + (6 * 2)
		stx KP_SetColourScreen + 2 + (6 * 3)
		
        lda #$18
        sta ValueD016

		lda #$00
		sta ValueSpriteEnable
		sta Signal_VBlank

	KOALA_WaitForVBlank1:
		lda Signal_VBlank
		beq KOALA_WaitForVBlank1
		dec Signal_VBlank

		lda #$00
		sta $d020

		ldx #$00
	KP_SetColourScreen:
		lda $ff00,x
		sta $d800,x
		lda $ff00,x
		sta $d900,x
		lda $ff00,x
		sta $da00,x
		lda $ffe8,x
		sta $dae8,x
		inx
		bne KP_SetColourScreen
		
		lda #$3b
		sta ValueD011
		lda #$00
		sta Signal_VBlank
	KOALA_WaitForVBlank2:
		lda Signal_VBlank
		beq KOALA_WaitForVBlank2
		dec Signal_VBlank

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		jsr Spindle_LoadNextFile
		
	WaitForEndOfKoala:
		lda Frame_256Counter
		cmp #$02
		bcc WaitForEndOfKoala

		lda #$00
		sta ValueD011
		sta Signal_VBlank
	KOALA_WaitForVBlank3:
		lda Signal_VBlank
		beq KOALA_WaitForVBlank3
		dec Signal_VBlank

		rts