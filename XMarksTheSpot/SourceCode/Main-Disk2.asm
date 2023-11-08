//; (c) 2018, Raistlin of Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonCode.asm"

*= MAIN2_BASE "Main Disk 2"

		jmp DISK2_Entry

DEADKRAKEN_SetupData:
		.byte $02, $00		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..

		.byte $0c			//; ScreenColor - $ff to leave it alone

		.byte $02			//; Bank [8000,bfff]
		.byte $90			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

THEEYE_SetupData:
		.byte $ff, $ff		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..

		.byte $00			//; ScreenColor - $ff to leave it alone

		.byte $03			//; Bank [8000,bfff]
		.byte $f4			//; D800 Colour Data Ptr Hi
		.byte $0c			//; ScreenBank = Bank+[3000,33ff]
		.byte $00			//; BitmapBank = Bank+[0000,1fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

HEDNING_SetupData:
		.byte $ff, $ff		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..

		.byte $08			//; ScreenColor - $ff to leave it alone

		.byte $02			//; Bank [8000,bfff]
		.byte $90			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

WAVES_SetupData_PirateShip:
		.byte $01 //; 0: Num Parts
		.byte $04 //; 1: Sin Speed
		.byte $06 //; 2: SineRepeat
		.byte $c0 //; 3: NumSkipFramesOnFirstPass
		.byte $0c //; 4: LayerColour0
		.byte $0e //; 5: LayerColour1
		.byte $04 //; 6: LayerColour2
		.byte $06 //; 7: LayerColour3
		.byte $06 * 8 //; 8: NumAnimationFrames (*8)

		.byte $00, $00, $00	//; Empty
		.byte $00, $06, $09	//; Pirate Ship
	
//; DISK2_Entry() -------------------------------------------------------------------------------------------------------
DISK2_Entry:

		:ClearGlobalVariables() //; nb. corrupts A and X

		:FadeMusicAndCopyNew($1006, $a000, $20)

	//; BEGIN Waves2 -------------------------------------------------------------------------------------------------------
		lda #$0c
		ldx #$01
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr Spindle_LoadNextFile //; #WAVES2

		ldx #<WAVES_SetupData_PirateShip
		ldy #>WAVES_SetupData_PirateShip
		jsr Waves_BASE
	//; END Waves2

	//; BEGIN Rotating Shapes -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #ROTATINGSHAPES

		lda #$03
		ldx #$00
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr RotatingShapes_BASE + GP_HEADER_Init

	RS_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq RS_MainLoop

		jsr RotatingShapes_BASE + GP_HEADER_Exit
	//; END Rotating Shapes -------------------------------------------------------------------------------------------------------

	//; BEGIN Full Screen Rotating Things -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #FULLSCREENROTATINGTHINGS

		lda #$0e
		ldx #$00
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr FullScreenRotatingThings_BASE + GP_HEADER_Init

	FSRT_MainLoop:
		lda Signal_VBlank
		beq FSRT_MainLoop
		lda #$00
		sta Signal_VBlank

		jsr FullScreenRotatingThings_BASE + GP_HEADER_MainThreadFunc

		lda Signal_CurrentEffectIsFinished
		beq FSRT_MainLoop

		jsr FullScreenRotatingThings_BASE + GP_HEADER_Exit

		lda #$00
		ldx #$01
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
	//; END Full Screen Rotating Things -------------------------------------------------------------------------------------------------------

	//; BEGIN Dead Kraken -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #Dead Kraken

		lda #$00
		ldx #<DEADKRAKEN_SetupData
		ldy #>DEADKRAKEN_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

		jsr Spindle_LoadNextFile //; #THEEYE-PRELOAD

	DEADKRAKEN_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq DEADKRAKEN_MainLoop

		jsr BitmapDisplay_BASE + GP_HEADER_Exit

		lda #$01
		ldx #$04
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
	//; END Dead Kraken -------------------------------------------------------------------------------------------------------

	//; BEGIN SpriteBobs -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #THEEYE

		lda #$00
		sta Signal_CustomSignal2
		ldx #<THEEYE_SetupData
		ldy #>THEEYE_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init
	SB_WaitForFadeIn:
		lda Signal_CustomSignal2
		beq SB_WaitForFadeIn
		:IRQManager_RestoreDefault(0, 0)

		jsr Spindle_LoadNextFile //; #SPRITEBOBS

		jsr SpriteBobs_BASE + GP_HEADER_Init

	SB_MainLoop:
		:IRQ_WaitForVBlank()

		jsr SpriteBobs_BASE + GP_HEADER_MainThreadFunc

		lda Signal_CurrentEffectIsFinished
		beq SB_MainLoop

		jsr SpriteBobs_BASE + GP_HEADER_Exit

	//; END SpriteBobs

	//; BEGIN Upper Treasure Map -------------------------------------------------------------------------------------------------------
		lda #$00
		ldx #$01
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr Spindle_LoadNextFile //; #TREASUREMAP-UPPER

		lda #$f0
		ldx #$88
		ldy #$24
		jsr TreasureMap_BASE + GP_HEADER_Init

	UPPERMAP_MainLoop:
		lda Signal_CustomSignal0
		beq UPPERMAP_MainLoop
		dec Signal_CustomSignal0
		jsr TreasureMap_BASE + GP_HEADER_MainThreadFunc
	UPPERMAP_CountScrolls:
		ldx #$00
		inx
		stx UPPERMAP_CountScrolls + 1
		cpx #41
		bne UPPERMAP_MainLoop

		inc Signal_CustomSignal1	//; Stop the scrolling of the map

		ldx #$80
	UPPERMAP_DelayForAFewSecs:
		lda Signal_VBlank
		beq UPPERMAP_DelayForAFewSecs
		lda #$00
		sta Signal_VBlank
		dex
		bne UPPERMAP_DelayForAFewSecs

		jsr TreasureMap_BASE + GP_HEADER_Exit
	//; END Upper Treasure Map -------------------------------------------------------------------------------------------------------

	//; BEGIN ScreenHash -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #SCREENHASH

		jsr ScreenHash_BASE + GP_HEADER_Init

	SH_WaitForFade:
		lda Signal_CurrentEffectIsFinished
		beq SH_WaitForFade

		jsr ScreenHash_BASE + GP_HEADER_Exit
	//; END ScreenHash -------------------------------------------------------------------------------------------------------

	//; BEGIN Hedning -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #HEDNING

		lda #$01
		ldx #<HEDNING_SetupData
		ldy #>HEDNING_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

		jsr Spindle_LoadNextFile //; Preload the diagonal bitmap scroller

		inc Signal_CustomSignal0 //; signal that we're waiting for the next disk...

		jsr Spindle_LoadNextFile //; Wait For Swap Disk

		inc Signal_CustomSignal1 //; signal that we should start to fade out...

	HEDNING_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq HEDNING_MainLoop

		jmp BitmapDisplay_BASE + GP_HEADER_Exit
	//; END Hedning -------------------------------------------------------------------------------------------------------

		.print "* $" + toHexString(DISK2_Entry) + "-$" + toHexString(EndDISK2_Entry - 1) + " DISK2_Entry"
EndDISK2_Entry:

