//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
.import source "../../Build/6502/VerticalBitmapScroll/VerticalBitmapScroll-ChunkLoadDefine.sym"

.var DebugBorderColours = false

* = $2000 "VerticalBitmapScrollBase"

.var NumPreloadedChunks = 4 / NumBuffersPerChunkLoad
.var NumFramesUntilLoadShouldHappen = 32 * NumBuffersPerChunkLoad

.var NumVerticalBitmapLoadcalls = 32 / NumBuffersPerChunkLoad
//; .var FirstLoopingBitmapLoadIndex_Standalone = 3
//; .var FirstLoopingBitmapLoadIndex_NoBounds = 23

.var NumBitmapSegments = 1024 / 64		//; each chunk gets loaded separately

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $1000-1fff Music
//; - $2200-3fff Code
//; - $4000-41ff Sprites 0
//; - $4400-5bff Stream Data 0-3
//; - $5c00-5fff Screen 0
//; - $6000-7fff Bitmap 0
//; - $8000-81ff Sprites 1
//; - $8c00-8fff Screen 1
//; - $a000-bfff Bitmap 1
//; - $c000-c3ff Coldata (for init)
//; --- $c400-c487 Colour Memory Restore Buffer

//; Available:-
//; --- $8200-8bff
//; --- $9000-9fff
//; --- $c488-fffd


//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var ScreenBank0 = 7 //; Bank+[1c00,1fff]
	.var ScreenBank1 = 3 //; Bank+[0000,03ff]
	.var BitmapBank0 = 1 //; Bank+[2000,3f3f]
	.var BitmapBank1 = 1 //; Bank+[2000,3f3f]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var SpriteVals0 = (ScreenAddress0 + $3F8)
	.var SpriteVals1 = (ScreenAddress1 + $3F8)
	.var BitmapAddress0 = Base_BankAddress0 + BitmapBank0 * $2000
	.var BitmapAddress1 = Base_BankAddress1 + BitmapBank1 * $2000

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank0 * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank1 * 8)
	
	.var ScreenColour = $00

	.var D016_40ColsMC = $18

	.var ADDR_ZP_ColourMemoryRestoreBuffer = $40

	.var ADDR_StreamData0 = $5600
	.var ADDR_StreamData1 = $5000
	.var ADDR_StreamData2 = $4a00
	.var ADDR_StreamData3 = $4400

	.var ADDR_BlankPage = $0400
	.var ADDR_HighNibbleToLowNibbleTable	= $0500
		
	.var ZP_CreditsUpdatePtr0 = $e0
	.var ZP_CreditsUpdatePtr1 = $e2

//; LocalData -------------------------------------------------------------------------------------------------------

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:
	.byte $7c, $5b								//; D000-1: VIC_Sprite0X, Y
	.byte $94, $5b								//; D002-3: VIC_Sprite0X, Y
	.byte $ac, $5b								//; D004-5: VIC_Sprite0X, Y
	.byte $c4, $5b								//; D006-7: VIC_Sprite0X, Y
	.byte $dc, $5b								//; D008-9: VIC_Sprite0X, Y
	.byte $70, $5b								//; D00A-B: VIC_Sprite0X, Y
	.byte $a0, $5b								//; D00C-D: VIC_Sprite0X, Y
	.byte $d0, $5b								//; D00E-F: VIC_Sprite0X, Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_40ColsMC							//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $e0									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte ScreenColour							//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $00									//; D029: VIC_Sprite2Colour
	.byte $00									//; D02A: VIC_Sprite3Colour
	.byte $00									//; D02B: VIC_Sprite4Colour
	.byte $07									//; D02C: VIC_Sprite5Colour
	.byte $07									//; D02D: VIC_Sprite6Colour
	.byte $07									//; D02E: VIC_Sprite7Colour

D011Table:										.byte $07, $06, $05, $04, $03, $02, $01,$00
												.byte $06, $05, $04, $03, $02, $01, $00
												.byte $06, $05, $04, $03, $02, $01, $00
												.byte $06, $05, $04, $03, $02, $01, $00
												.byte $06, $05, $04

LineCrunchTable:							.fill 8, 0
											.fill 7, 1
											.fill 7, 2
											.fill 7, 3
											.fill 3, 4

FrameCounterLo:								.byte $01
CurrentDBuffer:								.byte $00
Signal_BufferFlip:							.byte $00
Signal_D800Flip:							.byte $00
Signal_MainIRQIsD800Copying:				.byte $00
Signal_LoadNext:							.byte $00

DD02Values:									.byte DD02Value0, DD02Value1
D018Values:									.byte D018Value0, D018Value1

SpriteIndicesRestoreBuffer0:				.fill 8, 0
SpriteIndicesRestoreBuffer1:				.fill 8, 0

SourceCreditsPtrHi:
		.fill 31, >$e000 + (i * 256)
		.fill 7,  >$9000 + (i * 256)

FadeDelayTable:					.byte  -49, -69, -69
								.fill 11, -49
								.byte $80
								.byte -89, -49, $80
								.byte $b1,$b2				//; delay to start credit loop at the same bitmap scroll position.
								.fill 6, $80				//; these are not used

SpriteFadeOutTable:				.byte $07, $0d, $07, $07, $07, $0a, $07, $0a, $0a, $0a, $02, $0a, $02, $02, $09, $02, $09, $09, $00, $09, $00
SpriteFadeInTable:				.byte $09, $00, $09, $09, $09, $02, $09, $02, $02, $02, $0a, $02, $0a, $0a, $0f, $0a, $0f, $0f, $0d, $0f, $0d




.import source "../../Build/6502/VerticalBitmapScroll/UpdateCode.asm"

//; MainLoop() -------------------------------------------------------------------------------------------------------
MainLoop:

	CheckForLoadSignal:
		lda Signal_LoadNext
		beq CheckForLoadSignal

		dec Signal_LoadNext

		.if (DebugBorderColours == true)
		{
			lda VIC_BorderColour
			eor #$04
			sta VIC_BorderColour
		}

	LoadIndex:
		ldx #NumPreloadedChunks - 1
		inx
		cpx #NumVerticalBitmapLoadcalls
		bne DontLoopLoadCalls

		ldx #$00
		stx LoadIndex + 1

		jsr IRQLoader_LoadFetched
		jmp FinishedLoad

	DontLoopLoadCalls:
		stx LoadIndex + 1
		jsr IRQLoader_LoadNext

		ldx LoadIndex+1
		cpx #<NumVerticalBitmapLoadcalls-1
		bne FinishedLoad

	LoopLoadIndex:
		lda #0
		sta IRQLoader_BundleIndex
		jsr IRQLoader_SendCmd

	FinishedLoad:
		.if (DebugBorderColours == true)
		{
			lda VIC_BorderColour
			eor #$04
			sta VIC_BorderColour
		}

		jmp MainLoop
		

//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		pha
		txa
		pha
		tya
		pha

		lda $01
		pha
		lda #$35
		sta $01

		.for (var i = 0; i < 8; i++)
		{
			lda SpriteIndicesRestoreBuffer0 + i
			sta SpriteVals0 + i
			lda SpriteIndicesRestoreBuffer1 + i
			sta SpriteVals1 + i
		}

		lda #$fe
		sta VIC_D012
		lda #<IRQ_Bottom
		sta $fffe
		lda #>IRQ_Bottom
		sta $ffff
		asl VIC_D019
		cli

		lda Signal_MainIRQIsD800Copying
		bne FinishedMainIRQ

		lda Signal_D800Flip
		beq DontFlipD800
		dec Signal_D800Flip
		inc Signal_MainIRQIsD800Copying
		jsr UpdateD800Frame
		dec Signal_MainIRQIsD800Copying
		jmp FinishedMainIRQ
	DontFlipD800:

		lda Signal_BufferFlip	//; wait for the 32-frame signal!
		beq FinishedMainIRQ
		dec Signal_BufferFlip
		lda CurrentDBuffer
		bne JumpToCopyBitmap1To0
		jsr CopyBitmap0To1
		jmp FinishedBitmapCopy
	JumpToCopyBitmap1To0:
		jsr CopyBitmap1To0
	FinishedBitmapCopy:
		
	FinishedMainIRQ:

		pla
		sta $01

		pla
		tay
		pla
		tax
		pla

		rti


//; IRQ_Bottom() -------------------------------------------------------------------------------------------------------

IRQ_Bottom:

		:IRQManager_BeginIRQ(0,0)

		jsr UpdateSpriteRow0
		
		lda FrameCounterLo
		and #$1f
		bne NoFrameFlip
		lda CurrentDBuffer
		eor #$01
		sta CurrentDBuffer
		inc Signal_BufferFlip
	NoFrameFlip:
		cmp #$1f
		bne NoD800Flip
		inc Signal_D800Flip
	NoD800Flip:

		lda FrameCounterLo
		and #NumFramesUntilLoadShouldHappen - 1
		bne DontIssueLoadCall
		inc Signal_LoadNext
	DontIssueLoadCall:

		ldy CurrentDBuffer
		lda DD02Values, y
		sta VIC_DD02
		lda D018Values, y
		sta VIC_D018

		lda FrameCounterLo
		and #$1f
		tay
		lda LineCrunchTable, y
		sta _lineCrunch + 1

		lda D011Table, y
		sta FinalD011 + 1
		sta FinalD011B + 1
		clc
		adc #$30-1
		sta SetD012 + 1

	FinalD011B:
		lda #$00
		ora #$70
		sta VIC_D011

		jsr BASE_PlayMusic

		jsr UpdateCredits

		inc FrameCounterLo
	DontIncFrame:

	SetD012:
		lda #47
		sta VIC_D012
		lda #<IRQ_LineCrunch
		sta $fffe
		lda #>IRQ_LineCrunch
		sta $ffff

		:IRQManager_EndIRQ()
		rti


//; IRQ_LineCrunch() -------------------------------------------------------------------------------------------------------

.align 256
IRQ_LineCrunch:

		:IRQManager_BeginIRQ(1,0)

		clc
	FinalD011:
		lda #$00
	_lineCrunch:
		ldx #0
	crunchloop:
		adc #1
		and #$07
		ora #$70
		sta VIC_D011
		ldy #8
		dey
		bne *-1
		ldy #$3b
		and #$37
		nop $ea
		dex
		bpl crunchloop
!:		cpy $d012
		bne !-
		sta VIC_D011

//; Update bitmap data at the bottom of the screen if needed
		lda FrameCounterLo
		and #$07
		cmp #$02
		bne NoBitmapUpdate
		lda FrameCounterLo
		and #$7f
		lsr
		lsr
		lsr
		tay
		jsr BitmapUpdate
	NoBitmapUpdate:

		lda #$c0
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		:IRQManager_EndIRQ()
		rti


//; CopyBitmap0To1() -------------------------------------------------------------------------------------------------------

CopyBitmap0To1:

		//; we need to copy MAP data from [0500, 1f3f] to [0000, 1a3f]
		ldy #$00
	!Copyloop:
		.for (var i = 0; i < 13; i++)
		{
			lda BitmapAddress0 + $0500 + (i * 256), y
			sta BitmapAddress1 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-
	!Copyloop:
		.for (var i = 13; i < 26; i++)
		{
			lda BitmapAddress0 + $0500 + (i * 256), y
			sta BitmapAddress1 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-

		ldy #$3f
	!Copyloop:
		lda BitmapAddress0 + $1f00, y
		sta BitmapAddress1 + $1a00, y
		dey
		bpl !Copyloop-

		//; we need to copy SCR data from [00a0, 03e7] to [0000, 0347]
		ldy #$00
	!Copyloop:
		.for (var i = 0; i < 3; i++)
		{
			lda ScreenAddress0 + $00a0 + (i * 256), y
			sta ScreenAddress1 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-

		ldy #$47
	!Copyloop:
		lda ScreenAddress0 + $03a0, y
		sta ScreenAddress1 + $0300, y
		dey
		bpl !Copyloop-

		rts


//; CopyBitmap1To0() -------------------------------------------------------------------------------------------------------

CopyBitmap1To0:

		//; we need to copy MAP data from [0500, 1f3f] to [0000, 1a3f]
		ldy #$00
	!Copyloop:
		.for (var i = 0; i < 13; i++)
		{
			lda BitmapAddress1 + $0500 + (i * 256), y
			sta BitmapAddress0 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-
	!Copyloop:
		.for (var i = 13; i < 26; i++)
		{
			lda BitmapAddress1 + $0500 + (i * 256), y
			sta BitmapAddress0 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-

		ldy #$3f
	!Copyloop:
		lda BitmapAddress1 + $1f00, y
		sta BitmapAddress0 + $1a00, y
		dey
		bpl !Copyloop-

		//; we need to copy SCR data from [00a0, 03e7] to [0000, 0347]
		ldy #$00
	!Copyloop:
		.for (var i = 0; i < 3; i++)
		{
			lda ScreenAddress1 + $00a0 + (i * 256), y
			sta ScreenAddress0 + $0000 + (i * 256), y
		}
		iny
		bne !Copyloop-

		ldy #$47
	!Copyloop:
		lda ScreenAddress1 + $03a0, y
		sta ScreenAddress0 + $0300, y
		dey
		bpl !Copyloop-

		rts


//; UpdateD800Frame() -------------------------------------------------------------------------------------------------------

UpdateD800Frame:

	//; copy [$d800, $db87] to our colour restore buffer [$0000, $0087]
		ldy #$43
	!SetRestoreDataLoop:
		lda VIC_ColourMemory + $00, y
		sta ADDR_ZP_ColourMemoryRestoreBuffer + $00, y
		lda VIC_ColourMemory + $44, y
		sta ADDR_ZP_ColourMemoryRestoreBuffer + $44, y
		dey
		bpl !SetRestoreDataLoop-

	//; copy [$d8a0, db9f] to [$d800, $daff] // do it one block at a time because we're chasing the raster..!
		ldy #$00
		.for (var i = 0 ; i < 3; i++)
		{
	!CopyCOLLoop:
			lda VIC_ColourMemory + (4 * 40) + (i * 256), y
			sta VIC_ColourMemory + (0 * 40) + (i * 256), y
			iny
			bne !CopyCOLLoop-
		}

	//; copy [$dba0, dbff] to [$db00, $db5f]
		ldy #$5f
	!CopyCOLLoop:
		lda VIC_ColourMemory + (4 * 40) + (3 * 256), y
		sta VIC_ColourMemory + (0 * 40) + (3 * 256), y
		dey
		bpl !CopyCOLLoop-

	//; copy from our restore buffer [$0000, $0087] to [$db60, $dbe7)]
		ldy #$43
	!CopyBottomCOLLoop:
		lda ADDR_ZP_ColourMemoryRestoreBuffer + $00, y
		sta VIC_ColourMemory + $0360, y
		lda ADDR_ZP_ColourMemoryRestoreBuffer + $44, y
		sta VIC_ColourMemory + $03a4, y
		dey
		bpl !CopyBottomCOLLoop-

		rts


//; UpdateSpriteRow0() -------------------------------------------------------------------------------------------------------

UpdateSpriteRow0:

		ldx #0
		.for (var i = 0; i < 8; i++)
		{
			stx SpriteVals0 + i
			stx SpriteVals1 + i
			.if (i != 7)
			{
				inx
			}
		}

		lda #$ff
		sta VIC_SpriteEnable
		rts


//; UpdateCredits() -------------------------------------------------------------------------------------------------------

SourceCreditsRandomisedLines:
	.import source "../../Build/6502/VerticalBitmapScroll/CreditsRandomisedLines.asm"


UpdateCredits:

	FrameDelay:
		ldx #$ff
		beq CreditFrame
		dex
		stx FrameDelay + 1
		rts

	CreditFrame:
		ldy #$00
		bpl FadeInCredit

	FadeOutCredit:
		tya
		clc
		adc #48
		bmi ExtraDelayNeeded
		tay
		cpy #21
		bcc DoClearLine
	ExtraDelayNeeded:
		jmp FinishedUpdateCredits

	DoClearLine:

		lda #>ADDR_BlankPage
		sta ZP_CreditsUpdatePtr0 + 1
		sta ZP_CreditsUpdatePtr1 + 1

		lda SpriteFadeOutTable, y
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour
		jmp DoTheCreditLineUpdate

	FadeInCredit:
	CreditIndex:
		lda #$00
		cmp #19
		bcc GoodCreditLine
		jmp SkipUpdateCreditSprites
	GoodCreditLine:
		asl
		tax
		lda SourceCreditsPtrHi + 0, x
		sta ZP_CreditsUpdatePtr0 + 1
		lda SourceCreditsPtrHi + 1, x
		sta ZP_CreditsUpdatePtr1 + 1
		lda SpriteFadeInTable, y
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

	DoTheCreditLineUpdate:
		ldx SourceCreditsRandomisedLines, y
		stx ZP_CreditsUpdatePtr0 + 0
		stx ZP_CreditsUpdatePtr1 + 0

		.for (var SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			.for (var Column = 0; Column < 3; Column++)
			{
				ldy #(SpriteIndex * 64) + Column
				lda (ZP_CreditsUpdatePtr0), y
				sta $4000 + (SpriteIndex * 64) + Column, x
				sta $8000 + (SpriteIndex * 64) + Column, x
				lda (ZP_CreditsUpdatePtr1), y
				sta $4100 + (SpriteIndex * 64) + Column, x
				sta $8100 + (SpriteIndex * 64) + Column, x
			}
		}

	SkipUpdateCreditSprites:

		lda CreditFrame + 1
		cmp #20
		bne Not21

		ldy CreditIndex + 1
		lda FadeDelayTable, y
		sta CreditFrame + 1

		lda #60
		sta FrameDelay + 1

		ldy CreditIndex + 1
		iny
		cpy #20								//; was #21
		bne NotLastCredit

		lda #255
		sta FrameDelay + 1

		ldy #0
	NotLastCredit:
		sty CreditIndex + 1

	Not21:

	FinishedUpdateCredits:
		inc CreditFrame + 1
		
		rts


//; VerticalBitmapScroll_Go() -------------------------------------------------------------------------------------------------------
VerticalBitmapScroll_Go:

		sta LoopLoadIndex + 1				//A = first looping bitmap chunk's bundle index

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		MACRO_SetVICBank(BaseBank0)

		lda #$00
		tay
	SetCOLSRCBlankLoop:
		.for (var i = 0; i < 4; i++)
		{
			sta VIC_ColourMemory + (i * 256), y
			sta ScreenAddress0 + (i * 256), y
			sta ScreenAddress1 + (i * 256), y
		}
		sta ADDR_BlankPage, y
		iny
		bne SetCOLSRCBlankLoop

		ldy #$ff
		ldx #$10
		lda #$0f
	FillNibbleLookupTableLoop:
		sta ADDR_HighNibbleToLowNibbleTable, y
		dey
		dex
		bne FillNibbleLookupTableLoop
		ldx #$10
		sec
		sbc #1
		bcs FillNibbleLookupTableLoop
	FinishedNibbling:

		ldy #$00
		tya
	ClearSpritesLoop:
		sta $4000, y
		sta $4100, y
		sta $8000, y
		sta $8100, y
		iny
		bne ClearSpritesLoop

		vsync()

		sei

		lda #$33
		sta VIC_D011
		lda #$fe
		sta VIC_D012
		lda #<IRQ_Bottom
		sta $fffe
		lda #>IRQ_Bottom
		sta $ffff

		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		jmp MainLoop


