//; (c) 2018, Raistlin of Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonCode.asm"

*= MAIN1_BASE "Main Disk 1"

		jmp DISK1_Entry

BLACKBEARDQUOTE_SetupData:
		.byte $03, $2c		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..

		.byte $00			//; ScreenColor - $ff to leave it alone

		.byte $02			//; Bank [8000,bfff]
		.byte $90			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

.var CREDITS_NumScreens = 4

CREDITS_ScreenColours:
		.byte $00, $00, $0d, $00

CREDITS_BorderColours:
		.byte $0d, $0a, $07, $03

CREDITS_SetupData:
		.byte $01, $40		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..
	CREDITS_SetupData_ScrColour:
		.byte $05			//; ScreenColor - $ff to leave it alone
	CREDITS_SetupData_Bank:
		.byte $01			//; Bank [4000,7fff]
		.byte $50			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

TURNDISK_SetupData:
		.byte $ff, $ff		//; Number of frames to display logo for (high, low) .. ($ff, $ff) will display forever..

		.byte $00			//; ScreenColor - $ff to leave it alone

		.byte $02			//; Bank [4000,7fff]
		.byte $90			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $18			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $3b			//; D011 Value

WAVES_SetupData_IntroLogos:
		.byte $04 //; 0: Num Parts
		.byte $02 //; 1: Sin Speed
		.byte $01 //; 2: SineRepeat
		.byte $60 //; 3: NumSkipFramesOnFirstPass
		.byte $00 //; 4: LayerColour0
		.byte $06 //; 5: LayerColour1
		.byte $0e //; 6: LayerColour2
		.byte $03 //; 7: LayerColour3
		.byte $01 * 8 //; 8: NumAnimationFrames (*8)

		.byte $00, $00, $00	//; Empty
		.byte $0e, $00, $01 //; Genesis
		.byte $0a, $00, $01 //; Project
		.byte $0c, $00, $01 //; Presents
		.byte $07, $00, $01 //; X Marks The Spot

	//; DISK1_Entry() -------------------------------------------------------------------------------------------------------
DISK1_Entry:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$06
		jsr ScreenWipe_BASE //; Initial Screen Fade

		ldx #$08
		jsr DISK1_MusicTimingDelay

	//; BEGIN All Borders Sweep -------------------------------------------------------------------------------------------------------
		lda #$0a
		ldx #$00
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
	//; END All Borders Sweep -------------------------------------------------------------------------------------------------------

		ldx #$74
		jsr DISK1_MusicTimingDelay
	
	//; BEGIN Post-fadein, pre-demo setup -------------------------------------------------------------------------------------------------------
		lda #$00
		sta VIC_D011
	//; END Post-fadein, pre-demo setup -------------------------------------------------------------------------------------------------------

	//; BEGIN Blackbeard Quote -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #BLACKBEARDQUOTE

		lda #$00
		ldx #<BLACKBEARDQUOTE_SetupData
		ldy #>BLACKBEARDQUOTE_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

		jsr Spindle_LoadNextFile //; #HORIZONTALBITMAP-PRELOAD

	BLACKBEARDQUOTE_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq BLACKBEARDQUOTE_MainLoop

		jsr BitmapDisplay_BASE + GP_HEADER_Exit
	//; END Blackbeard Quote -------------------------------------------------------------------------------------------------------

	//; BEGIN All Borders Sweep -------------------------------------------------------------------------------------------------------
		lda #$06
		ldx #$00
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
	//; END All Borders Sweep -------------------------------------------------------------------------------------------------------
	
	//; BEGIN Horizontal Bitmap -------------------------------------------------------------------------------------------------------
		lda #$00
		sta VIC_D011
		sta Signal_CustomSignal2

		:IRQ_WaitForVBlank()

		jsr Spindle_LoadNextFile //; #HORIZONTALBITMAP-OVERLAPS

		//; for Horiz Bitmap, we do this here - because we have no spare memory in there..!
		:ClearGlobalVariables() //; nb. corrupts A and X
		jsr HorizontalBitmap_BASE + GP_HEADER_Init

	HORIZ_MainLoop:
		lda Signal_CustomSignal0
		beq HORIZ_MainLoop
		dec Signal_CustomSignal0
	HORIZ_ShouldPlotNewData:
		lda #$01
		jsr HorizontalBitmap_BASE + GP_HEADER_MainThreadFunc
	HORIZ_CountScrolls:
		ldx #$00
		cpx #114
		beq HORIZ_PastEndOfBitmap
		inx
		stx HORIZ_CountScrolls + 1
		cpx #114
		beq HORIZ_ReachedEndOfBitmap
		jmp HORIZ_MainLoop

	HORIZ_ReachedEndOfBitmap:
		lda #$00
		sta HORIZ_ShouldPlotNewData + 1
		sta Signal_CustomSignal2

	HORIZ_PastEndOfBitmap:
		lda Signal_CustomSignal2
		cmp #$00
		beq HORIZ_MainLoop

		jsr HorizontalBitmap_BASE + GP_HEADER_Exit
	//; END Horizontal Bitmap -------------------------------------------------------------------------------------------------------

	//; BEGIN Credits -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #CREDITS

	CREDITS_MainLoop:
		ldx #$00
		cpx #CREDITS_NumScreens
		beq CREDITS_Finished

		inc CREDITS_MainLoop + 1
		lda CREDITS_ScreenColours, x
		sta CREDITS_SetupData_ScrColour
		lda CREDITS_BorderColours, x
		ldx #$00
	CREDITS_UpDownSwipe:
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
		lda CREDITS_UpDownSwipe + 1
		eor #$01
		sta CREDITS_UpDownSwipe + 1

		lda #$02
		ldx #<CREDITS_SetupData
		ldy #>CREDITS_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

		lda CREDITS_SetupData_Bank
		eor #$03 //; Make the bank alternate between 1 and 2
		sta CREDITS_SetupData_Bank

		jsr Spindle_LoadNextFile //; Load next file...

	CREDITS_WaitLoop:
		lda Signal_CurrentEffectIsFinished
		beq CREDITS_WaitLoop

		jsr BitmapDisplay_BASE + GP_HEADER_Exit
		jmp CREDITS_MainLoop

	CREDITS_Finished:
	//; END Credits -------------------------------------------------------------------------------------------------------

	//; BEGIN Second Tune -------------------------------------------------------------------------------------------------------
		lda #$00
		ldx #$01
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		:FadeMusicAndCopyNew($1006, $6000, $20)
	//; END Second Tune -------------------------------------------------------------------------------------------------------
	
	//; BEGIN Waves -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; #WAVES

		ldx #<WAVES_SetupData_IntroLogos
		ldy #>WAVES_SetupData_IntroLogos
		jsr Waves_BASE
	//; END Waves -------------------------------------------------------------------------------------------------------

	//; BEGIN Shadow's Flag -------------------------------------------------------------------------------------------------------
		lda #$0e
		ldx #$01
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr Spindle_LoadNextFile //; #SHADOWS-FLAG
		jsr TextureFlag_BASE
	//; END Shadow's Flag -------------------------------------------------------------------------------------------------------

	//; BEGIN Lower Treasure Map -------------------------------------------------------------------------------------------------------
		lda #$00
		ldx #$01
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE
	
		jsr Spindle_LoadNextFile //; #TREASUREMAP-LOWER

		lda #$c0
		ldx #$d4
		ldy #$10
		jsr TreasureMap_BASE + GP_HEADER_Init

	LOWERMAP_MainLoop:
		lda Signal_CustomSignal0
		beq LOWERMAP_MainLoop
		dec Signal_CustomSignal0
		jsr TreasureMap_BASE + GP_HEADER_MainThreadFunc
	LOWERMAP_CountScrolls:
		ldx #$00
		inx
		stx LOWERMAP_CountScrolls + 1
		cpx #49
		bne LOWERMAP_MainLoop

		inc Signal_CustomSignal1	//; Stop the scrolling of the map

		ldx #$80
	LOWERMAP_DelayForAFewSecs:
		lda Signal_VBlank
		beq LOWERMAP_DelayForAFewSecs
		lda #$00
		sta Signal_VBlank
		dex
		bne LOWERMAP_DelayForAFewSecs

		jsr TreasureMap_BASE + GP_HEADER_Exit
	//; END Lower Treasure Map -------------------------------------------------------------------------------------------------------

	//; BEGIN WavyScroller -------------------------------------------------------------------------------------------------------
		lda #$06
		ldx #$07
		ldy #$01 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr Spindle_LoadNextFile //; #WAVYSCROLLER
		jsr WavyScroller_BASE + GP_HEADER_Init

	WAVYSCROLLER_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq WAVYSCROLLER_MainLoop

		jsr WavyScroller_BASE + GP_HEADER_Exit
	//; END WavyScroller -------------------------------------------------------------------------------------------------------

	//; BEGIN WavySnake (00) -------------------------------------------------------------------------------------------------------
		lda #$00
		ldx #$01
		ldy #$00 //; 00 = Top-to-Bottom, 01 = Bottom-to-Top
		jsr AllBorders_BASE

		jsr Spindle_LoadNextFile //; #WAVYSNAKE

		lda #$00
		jsr WavySnake_BASE
	//; END WavySnake (00) -------------------------------------------------------------------------------------------------------

	//; TURN DISK 1
		jsr Spindle_LoadNextFile //; Turn Disk Bitmap

		lda #$01
		ldx #<TURNDISK_SetupData
		ldy #>TURNDISK_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

		inc Signal_CustomSignal0 //; tell the BitmapDisplay code that we're waiting for the next disk...

		jsr Spindle_LoadNextFile //; Wait For Swap Disk

		inc Signal_CustomSignal1 //; tell the BitmapDisplay code that we should start to fade out...

	TURNDISK_WaitForFade:
		lda Signal_CurrentEffectIsFinished
		beq TURNDISK_WaitForFade

		jmp BitmapDisplay_BASE + GP_HEADER_Exit //; return to Entry when finished...
	//; END TURN DISK 1

		.print "* $" + toHexString(DISK1_Entry) + "-$" + toHexString(EndDISK1_Entry - 1) + " DISK1_Entry"
EndDISK1_Entry:

DISK1_MusicTimingDelay:
		lda #$00
		sta FrameOf256
	DISK1_MusicTiming:
		cpx FrameOf256
		bne DISK1_MusicTiming
		rts
