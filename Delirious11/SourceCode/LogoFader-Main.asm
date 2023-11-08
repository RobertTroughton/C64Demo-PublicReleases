//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	//; Defines

	.var LF_NumberOfCharsToCopyPerFrame = 8
	.var LF_RandomPointers_BASE = $8000
	.var LF_RandomPointers_Screen_Lo = LF_RandomPointers_BASE
	.var LF_RandomPointers_Screen_Hi = LF_RandomPointers_BASE + $400
	.var LF_RandomPointers_Data_Lo = LF_RandomPointers_BASE + $800
	.var LF_RandomPointers_Data_Hi = LF_RandomPointers_BASE + $c00
	.var LF_RandomPointers_Sprite_Lo = LF_RandomPointers_BASE + $1000
	.var LF_RandomPointers_Sprite_Hi = LF_RandomPointers_BASE + $1400
	
	.var LF_InputPtr_Screen_Hi = $98
	.var LF_OutputPtr_Screen_Hi = $4c
	.var LF_InputPtr_Colour_Hi = $9c
	.var LF_OutputPtr_Colour_Hi = $d8
	.var LF_InputPtr_Data_Hi = $a0
	.var LF_OutputPtr_Data_Hi = $60
	.var LF_InputPtr_Sprite_Hi = $38
	.var LF_OutputPtr_Sprite_Hi = $40
	
* = LogoFader_BASE "Logo Fader"

	JumpTable:
		jmp LF_Init
		jmp IRQManager_RestoreDefaultIRQ
		jmp LF_MainThread
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
	
//; LF_LocalData -------------------------------------------------------------------------------------------------------
LF_LocalData:
	.var IRQNum = 6
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$16,			<LF_IRQ_TopSprites,			>LF_IRQ_TopSprites
		.byte	$00,			$50,			<LF_IRQ_SunSprites,			>LF_IRQ_SunSprites
		.byte	$00,			$89,			<LF_IRQ_RasterBars,			>LF_IRQ_RasterBars
		.byte	$00,			$d7,			<LF_IRQ_BottomSprites0,		>LF_IRQ_BottomSprites0
		.byte	$00,			$f7,			<LF_IRQ_VBlank,				>LF_IRQ_VBlank
		.byte	$00,			$fd,			<LF_IRQ_VBlank2,			>LF_IRQ_VBlank2
		
	LF_CurrentAction:
		.byte $00
	.var LF_CurrentAction_FadeIn = 0
	.var LF_CurrentAction_Display = 1

	.var LF_NumLogos = 5
	LF_CurrentLogo:
		.byte $00
	FaderLogo_D021Values:
		.byte $06,$06,$06,$06,$06
	FaderLogo_SpriteEnableValues:
		.byte $00,$00,$00,$ff,$ff
	FaderLogo_Timer:
		.byte $00,$6e,$00,$00,$00
		
	.print "* $" + toHexString(LF_LocalData) + "-$" + toHexString(EndLF_LocalData - 1) + " LF_LocalData"
EndLF_LocalData:
	
//; LF_Init() -------------------------------------------------------------------------------------------------------
LF_Init:

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta Signal_SpindleLoadNextFile
		sta Signal_SpindleLoadHasCompleted
		sta FrameOf256
		sta Frame_256Counter
		sta ValueD021
		
		lda #$00
		sta spriteDoubleWidth	//; make all sprites double-width
		sta spriteDoubleHeight	//; make all sprites double-height
		
		lda #LF_OutputPtr_Data_Hi
		sta LF_BlankInitialData_InnerLoop + 2
		lda #$00
		ldx #$1f
	LF_BlankInitialData_OuterLoop:
		ldy #$00
	LF_BlankInitialData_InnerLoop:
		sta $ff00, y
		iny
		bne LF_BlankInitialData_InnerLoop
		inc LF_BlankInitialData_InnerLoop + 2
		dex
		bpl LF_BlankInitialData_OuterLoop
		
		ldx #$00
		jsr LF_DisplayLogo
		
		lda #$40
		jsr LF_FillBitmap
		
		lda #$ff
		sta $7fff
		
		lda #LF_CurrentAction_FadeIn
		jsr LF_SetCurrentAction
		
		jmp LF_SetupIRQs

		.print "* $" + toHexString(LF_Init) + "-$" + toHexString(EndLF_Init - 1) + " LF_Init"
EndLF_Init:

//; LF_FillBitmap() -------------------------------------------------------------------------------------------------------
LF_FillBitmap:
		sta LF_FillBitmap_AValue + 1
		clc
		adc #$20
		sta LF_FillBitmapData + 2
		
		ldx #$00
		ldy #$20
		lda #$aa
	LF_FillBitmapData:
		sta $ff00,x
		inx
		bne LF_FillBitmapData
		inc LF_FillBitmapData + 2
		dey
		bne LF_FillBitmapData

		lda #$c0
		sta $f0
	LF_FillBitmap_AValue:
		lda #$00
		clc
		adc #$2d
		sta $f1
		
		ldy #$00
		ldx #(40 * 3)
		lda #$55
	LF_FillBitmapData_RedBars:
		sta ($f0),y
		iny
		sta ($f0),y
		iny
		sta ($f0),y
		iny
		sta ($f0),y
		iny
		sta ($f0),y
		iny
		sta ($f0),y
		iny
		iny
		iny
		bne LF_DidntCrossF0Page
		inc $f1
	LF_DidntCrossF0Page:
		dex
		bne LF_FillBitmapData_RedBars

		lda LF_FillBitmap_AValue + 1
		clc
		adc #$0c
		sta LF_FillBitmapScreen + 2
		tax
		inx
		stx LF_FillBitmapScreen + 5
		inx
		stx LF_FillBitmapScreen + 8
		stx LF_FillBitmapScreen + 11

		ldy #$00
		lda #$20
	LF_FillBitmapScreen:
		sta $4c00,y
		sta $4d00,y
		sta $4e00,y
		sta $4ee8,y
		iny
		bne LF_FillBitmapScreen
		
		ldy #$00
		lda #$f0
	LF_FillBitmapColour:
		sta $d800,y
		sta $d900,y
		sta $da00,y
		sta $dae8,y
		iny
		bne LF_FillBitmapColour
		
		rts

		.print "* $" + toHexString(LF_FillBitmap) + "-$" + toHexString(EndLF_FillBitmap - 1) + " LF_FillBitmap"
EndLF_FillBitmap:

//; LF_DisplayLogo() -------------------------------------------------------------------------------------------------------
LF_DisplayLogo:
		//; Start counters from 0 again for the new logo
		lda #$00
		sta Frame_256Counter
		sta FrameOf256

		lda FaderLogo_SpriteEnableValues,x
		sta ValueSpriteEnable
		lda FaderLogo_D021Values,x
		sta ValueD021
		lda FaderLogo_Timer,x
		sta LF_FrameCountDuration + 1
		rts

//; LF_SetupIRQs() -------------------------------------------------------------------------------------------------------
LF_SetupIRQs:
	LF_WaitUntilWeAreClose:
		lda $d011
		and #$80
		bne LF_WaitUntilWeAreClose
		lda #$10
		cmp $d012
		bne LF_WaitUntilWeAreClose
		
		sei
		lda	#$3b
		sta ValueD011
		sta $d011
		lda #$3d
		sta ValueDD02
		sta $dd02
		lda #$38
		sta ValueD018
		sta $d018
		lda #$18
		sta ValueD016
		sta $d016

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(LF_SetupIRQs) + "-$" + toHexString(EndLF_SetupIRQs - 1) + " LF_SetupIRQs"
EndLF_SetupIRQs:
			
//; LF_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
LF_IRQ_VBlank: //; $F8
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #$f9
	LF_VBWaitF9:
		cmp $d012
		bne LF_VBWaitF9
		
		lda ValueD011
		and #$f7
		sta $d011
		
		jsr SetBottomBlueSprites

		jmp IRQManager_NextInIRQList_RTI
		
		.print "* $" + toHexString(LF_IRQ_VBlank) + "-$" + toHexString(EndLF_IRQ_VBlank - 1) + " LF_IRQ_VBlank"
EndLF_IRQ_VBlank:

LF_SetCurrentAction:
	sta LF_CurrentAction
	lda #$00
	sta FrameOf256
	sta Frame_256Counter

	jsr LF_InitCopyChar

	rts

LF_InitCopyChar:
		lda #$00
		sta LF_CopyChar_Output_ReadLo_Data + 1
		sta LF_CopyChar_Output_HiInput_Data + 1
		sta LF_CopyChar_Output_ReadLo_Screen + 1
		sta LF_CopyChar_Output_HiInput_Screen + 1
		sta LF_CopyChar_Output_ReadLo_Sprite + 1
		sta LF_CopyChar_Output_HiInput_Sprite + 1
		
		lda #>LF_RandomPointers_Data_Lo
		sta LF_CopyChar_Output_ReadLo_Data + 2
		lda #>LF_RandomPointers_Data_Hi
		sta LF_CopyChar_Output_HiInput_Data + 2

		lda #>LF_RandomPointers_Screen_Lo
		sta LF_CopyChar_Output_ReadLo_Screen + 2
		lda #>LF_RandomPointers_Screen_Hi
		sta LF_CopyChar_Output_HiInput_Screen + 2

		lda #>LF_RandomPointers_Sprite_Lo
		sta LF_CopyChar_Output_ReadLo_Sprite + 2
		lda #>LF_RandomPointers_Sprite_Hi
		sta LF_CopyChar_Output_HiInput_Sprite + 2
		
		rts
	
LF_CopyChar:
		ldy #$00
	LF_CopyChar_Next:

	LF_CopyChar_Output_ReadLo_Data:
		ldx $ff00,y
		stx LF_CopyChar_InputAddress_Data + 1
		stx LF_CopyChar_OutputAddress_Data + 1

	LF_CopyChar_Output_HiInput_Data:	
		lax $ff00,y
		ora #LF_InputPtr_Data_Hi
		sta LF_CopyChar_InputAddress_Data + 2
		txa
		ora #LF_OutputPtr_Data_Hi
		sta LF_CopyChar_OutputAddress_Data + 2
		
	LF_CopyChar_Output_HiInput_Screen:	
		lax $ff00,y
		ora #LF_InputPtr_Screen_Hi
		sta LF_CopyChar_InputAddress_Screen + 2
		txa
		ora #LF_OutputPtr_Screen_Hi
		sta LF_CopyChar_OutputAddress_Screen + 2
		txa
		ora #LF_InputPtr_Colour_Hi
		sta LF_CopyChar_InputAddress_Colour + 2
		txa
		ora #LF_OutputPtr_Colour_Hi
		sta LF_CopyChar_OutputAddress_Colour + 2
		
	LF_CopyChar_Output_ReadLo_Sprite:
		lda $ff00,y
		sta LF_CopyChar_InputAddress_Sprite + 1
		sta LF_CopyChar_OutputAddress_Sprite + 1
	LF_CopyChar_Output_HiInput_Sprite:	
		lax $ff00,y
		ora #LF_InputPtr_Sprite_Hi
		sta LF_CopyChar_InputAddress_Sprite + 2
		txa
		ora #LF_OutputPtr_Sprite_Hi
		sta LF_CopyChar_OutputAddress_Sprite + 2
		
		ldx #$07
	LF_CopyChar_InputAddress_Data:
		lda $ff00,x
	LF_CopyChar_OutputAddress_Data:
		sta $ff00,x
		dex
		bpl LF_CopyChar_InputAddress_Data

	LF_CopyChar_Output_ReadLo_Screen:
		ldx $ff00,y
	LF_CopyChar_InputAddress_Screen:
		lda $ff00,x
	LF_CopyChar_OutputAddress_Screen:
		sta $ff00,x
	LF_CopyChar_InputAddress_Colour:
		lda $ff00,x
	LF_CopyChar_OutputAddress_Colour:
		sta $ff00,x

		ldx #(6 * 3)
	LF_CopyChar_InputAddress_Sprite:
		lda $ff00,x
	LF_CopyChar_OutputAddress_Sprite:
		sta $ff00,x
		dex
		dex
		dex
		bpl LF_CopyChar_InputAddress_Sprite

		iny
		cpy #LF_NumberOfCharsToCopyPerFrame
		bne LF_CopyChar_Next

		lda LF_CopyChar_Output_ReadLo_Data + 1
		clc
		adc #LF_NumberOfCharsToCopyPerFrame
		sta LF_CopyChar_Output_ReadLo_Data + 1
		sta LF_CopyChar_Output_HiInput_Data + 1
		sta LF_CopyChar_Output_ReadLo_Screen + 1
		sta LF_CopyChar_Output_HiInput_Screen + 1
		sta LF_CopyChar_Output_ReadLo_Sprite + 1
		sta LF_CopyChar_Output_HiInput_Sprite + 1
		bcc LF_DidntCrossPage
		
		inc LF_CopyChar_Output_ReadLo_Data + 2
		inc LF_CopyChar_Output_HiInput_Data + 2
		inc LF_CopyChar_Output_ReadLo_Screen + 2
		inc LF_CopyChar_Output_HiInput_Screen + 2
		inc LF_CopyChar_Output_ReadLo_Sprite + 2
		inc LF_CopyChar_Output_HiInput_Sprite + 2
	LF_DidntCrossPage:

	rts

//;LF_NumCharsRemaining:
//;	.byte $00

//; LF_IRQ_VBlank2() -------------------------------------------------------------------------------------------------------
LF_IRQ_VBlank2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		lda #$ff
	LF_VBWaitFF:
		cmp $d012
		bne LF_VBWaitFF
		
		lda ValueD011
		sta $d011
		lda ValueD018
		sta $d018
		lda ValueD016
		sta $d016
		lda ValueD021
		sta $d021
		lda ValueDD02
		sta $dd02
		lda	ValueSpriteEnable
		sta spriteEnable
		
		lda Signal_CurrentEffectIsFinished
		cmp #$01
		beq LF_ContinueIRQ

		lda LF_CurrentAction
		cmp #LF_CurrentAction_FadeIn
		beq LF_FadeIn
		jmp LF_Display

	LF_FadeIn:
		lda #$00
		jsr LF_CopyChar

		inc LF_FadeIn + 1
		lda LF_FadeIn + 1
		cmp #((1000 + LF_NumberOfCharsToCopyPerFrame - 1) / LF_NumberOfCharsToCopyPerFrame)
		beq LF_FadeIn_Finished
		jmp LF_ContinueIRQ

	LF_FadeIn_Finished:
		//; Kick off the next load
		inc Signal_SpindleLoadNextFile

		lda #$00
		sta LF_FadeIn + 1

		inc LF_CurrentLogo
		lda LF_CurrentLogo
		cmp #LF_NumLogos
		bne LF_NotFinishedAllLogos
		
		lda #$01
		sta Signal_CurrentEffectIsFinished
		jmp LF_ContinueIRQ

	LF_NotFinishedAllLogos:
		ldx LF_CurrentLogo
		jsr LF_DisplayLogo

		lda #LF_CurrentAction_Display
		jsr LF_SetCurrentAction
		jmp LF_ContinueIRQ
	
	LF_Display:
		lda Frame_256Counter
		cmp #$01
		bcc LF_ContinueIRQ

		lda Signal_SpindleLoadHasCompleted
		cmp #$00
		beq LF_ContinueIRQ
		
		// Start the fade down here...
		lda #LF_CurrentAction_FadeIn
		jsr LF_SetCurrentAction

	LF_ContinueIRQ:
	 	jsr Music_Play

		inc FrameOf256
		lda FrameOf256
	LF_FrameCountDuration:
		cmp #$00
		bne Skip256Counter
		lda #$00
		sta FrameOf256
		inc Frame_256Counter
	Skip256Counter:

		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(LF_IRQ_VBlank2) + "-$" + toHexString(EndLF_IRQ_VBlank2 - 1) + " LF_IRQ_VBlank2"
EndLF_IRQ_VBlank2:

//; LF_MainThread() -------------------------------------------------------------------------------------------------------
LF_MainThread:
		lda Signal_SpindleLoadNextFile
		cmp #$00
		beq LF_NoSpindleLoad
	
		lda #$00
		sta Signal_SpindleLoadNextFile		//; this should be safe so long as the load requests aren't happening rapidly (which they won't be)
		sta Signal_SpindleLoadHasCompleted

		lda #$00
		ldy #$00
	LF_ClearSpriteData:
		sta $3800,y
		sta $3900,y
		sta $3a00,y
		sta $3b00,y
		sta $3c00,y
		iny
		bne LF_ClearSpriteData
		
		jsr Spindle_LoadNextFile
		lda #$01
		sta Signal_SpindleLoadHasCompleted
	LF_NoSpindleLoad:
		
		rts
		.print "* $" + toHexString(LF_MainThread) + "-$" + toHexString(EndLF_MainThread - 1) + " LF_MainThread"
EndLF_MainThread:
	
//; LF_IRQ_TopSprites() -------------------------------------------------------------------------------------------------------
LF_IRQ_TopSprites:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #$1d
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		
		lda #90 + 24 + (24 * 0)
		sta $d000
		lda #90 + 24 + (24 * 1)
		sta $d002
		lda #90 + 24 + (24 * 2)
		sta $d004
		lda #90 + 24 + (24 * 3)
		sta $d006
		lda #90 + 24 + (24 * 4)
		sta $d008
		lda #90 + 24 + (24 * 5)
		sta $d00a
		
		ldx #$00
		stx $4ff8
		inx
		stx $4ff9
		inx
		stx $4ffa
		inx
		stx $4ffb
		inx
		stx $4ffc
		inx
		stx $4ffd
		
		lda #$00
		sta spriteExtraColor0
		lda #$06
		sta spriteExtraColor1

		lda #$0b
		sta SPRITE0_Color
		sta SPRITE1_Color
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		lda #$01
		sta SPRITE5_Color
		lda #$00
		sta SPRITE6_Color
		sta SPRITE7_Color
		
		lda #$00
		sta spriteXMSB

		lda #$3f
		sta spriteMulticolorMode
	
		jmp IRQManager_NextInIRQList_RTI
		
		.print "* $" + toHexString(LF_IRQ_TopSprites) + "-$" + toHexString(EndLF_IRQ_TopSprites - 1) + " LF_IRQ_TopSprites"
EndLF_IRQ_TopSprites:

//; LF_IRQ_SunSprites() -------------------------------------------------------------------------------------------------------
LF_IRQ_SunSprites:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #68+29
		sta $d001
		sta $d003
		sta $d005
		
		lda #154 + 24
		sta $d000
		lda #178 + 24
		sta $d002
		lda #156 + 24
		sta $d004
		
		ldx #$11
		stx $4ff8
		ldx #$12
		stx $4ff9
		ldx #$10
		stx $4ffa
		
		lda #$07
		sta SPRITE0_Color
		sta SPRITE1_Color
		lda #$01
		sta SPRITE2_Color
		
		lda #$00
		sta spriteXMSB

		lda #$00
		sta spriteMulticolorMode
	
		jmp IRQManager_NextInIRQList_RTI
		
		.print "* $" + toHexString(LF_IRQ_SunSprites) + "-$" + toHexString(EndLF_IRQ_SunSprites - 1) + " LF_IRQ_SunSprites"
EndLF_IRQ_SunSprites:

//; LF_IRQ_RasterBars() -------------------------------------------------------------------------------------------------------
LF_IRQ_RasterBars:
		//; LFT Jitter correction
		//; Put earliest cycle in parenthesis.
		//; (10 with no sprites, 19 with all sprites, ...)
		//; Length of clockslide can be increased if more jitter
		//; is expected, e.g. due to NMIs.
		dec	0
		sta	IRQ_RestoreA
		lda	#39 - (10)
		sec
		sbc	$dc06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		ldx #$0c
	LF_RasterWaitLoop1:
		dex
		bne LF_RasterWaitLoop1
		nop
		nop
		lda #$02
		sta $d020

		ldx #$41
	LF_RasterWaitLoop2:
		dex
		bne LF_RasterWaitLoop2
		ora $ff
		lda #$00
		sta $d020

		ldx #$17
	LF_RasterWaitLoop3:
		dex
		bne LF_RasterWaitLoop3
		nop
		nop
		lda #$02
		sta $d020

		ldx #$41
	LF_RasterWaitLoop4:
		dex
		bne LF_RasterWaitLoop4
		ora $ff
		lda #$00
		sta $d020

		ldx #$17
	LF_RasterWaitLoop5:
		dex
		bne LF_RasterWaitLoop5
		nop
		nop
		lda #$02
		sta $d020

		ldx #$41
	LF_RasterWaitLoop6:
		dex
		bne LF_RasterWaitLoop6
		ora $ff
		lda #$00
		sta $d020

	LF_DontDoRasterLines:
		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(LF_IRQ_RasterBars) + "-$" + toHexString(EndLF_IRQ_RasterBars - 1) + " LF_IRQ_RasterBars"
EndLF_IRQ_RasterBars:

//; LF_IRQ_BottomSprites0() -------------------------------------------------------------------------------------------------------
LF_IRQ_BottomSprites0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #229
		sta $d001
		lda #229
		sta $d003
		lda #219
		sta $d005
		lda #240
		sta $d007
		lda #240
		sta $d009
		lda #229
		sta $d00b
		lda #250
		sta $d00d
		lda #229
		sta $d00f
		
		lda #143+24
		sta $d000
		lda #167+24
		sta $d002
		lda #156+24
		sta $d004
		lda #148+24
		sta $d006
		lda #172+24
		sta $d008
		lda #128+24
		sta $d00a
		lda #182+24
		sta $d00c
		lda #172+24
		sta $d00e
		
		ldx #$0e
		stx $4ff8
		inx
		stx $4ff9

		ldx #$06
		stx $4ffa
		inx
		stx $4ffb
		inx
		stx $4ffc
		inx
		stx $4ffd
		inx
		inx
		inx
		stx $4ffe
		inx
		stx $4fff

		lda #$0e
		sta SPRITE0_Color
		sta SPRITE1_Color
		lda #$0b
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		lda #$06
		sta SPRITE5_Color
		sta SPRITE6_Color
		sta SPRITE7_Color
		
		lda #$00
		sta spriteXMSB
		sta spriteMulticolorMode

		jmp IRQManager_NextInIRQList_RTI
		
		.print "* $" + toHexString(LF_IRQ_BottomSprites0) + "-$" + toHexString(EndLF_IRQ_BottomSprites0 - 1) + " LF_IRQ_BottomSprites0"
EndLF_IRQ_BottomSprites0:

SetBottomBlueSprites:
		lda #250
		sta $d00b
		lda #250
		sta $d00f
		
		lda #134+24
		sta $d00a
		lda #158+24
		sta $d00e
		
		ldx #$0a
		stx $4ffd
		inx
		stx $4fff
		
		lda #$06
		sta SPRITE5_Color
		sta SPRITE7_Color
		
		lda #$00
		sta spriteXMSB
		sta spriteMulticolorMode
		rts
		.print "* $" + toHexString(SetBottomBlueSprites) + "-$" + toHexString(EndSetBottomBlueSprites - 1) + " SetBottomBlueSprites"
EndSetBottomBlueSprites: