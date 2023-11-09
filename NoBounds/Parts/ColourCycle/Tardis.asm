//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/ColourCycle/ColourCycle.sym"

* = $0400 "Tardis"

	jmp TARDIS_Go
	jmp TARDIS_ReGo

.var BackgroundColour = $0b

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $40-6f Colours
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-$03ff Sparkle (ALWAYS)
//; - $0400-07ff Code
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $4000-43e7 Screen 0

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharAddress0 = Base_BankAddress0 + CharBank0 * $800
	.var ScreenBank0 =  0 //; Bank+[0000,03ff]
	.var ScreenAddress0 = Base_BankAddress0 + ScreenBank0 * $400
	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)

	.var D016_Value_40Cols = $08

	.var ADDR_SpriteSinTable_X = $3d80
	.var ADDR_SpriteSinTable_Y = $3dc0

//; LocalData -------------------------------------------------------------------------------------------------------

//;	.var D000_SkipValue = $f1
//;
//;INITIAL_D000Values:
//;	.byte $00									//; D000: VIC_Sprite0X
//;	.byte $00									//; D001: VIC_Sprite0Y
//;	.byte $00									//; D002: VIC_Sprite1X
//;	.byte $00									//; D003: VIC_Sprite1Y
//;	.byte $00									//; D004: VIC_Sprite2X
//;	.byte $00									//; D005: VIC_Sprite2Y
//;	.byte $00									//; D006: VIC_Sprite3X
//;	.byte $00									//; D007: VIC_Sprite3Y
//;	.byte $00									//; D008: VIC_Sprite4X
//;	.byte $00									//; D009: VIC_Sprite4Y
//;	.byte $00									//; D00a: VIC_Sprite5X
//;	.byte $00									//; D00b: VIC_Sprite5Y
//;	.byte $00									//; D00c: VIC_Sprite6X
//;	.byte $00									//; D00d: VIC_Sprite6Y
//;	.byte $00									//; D00e: VIC_Sprite7X
//;	.byte $00									//; D00f: VIC_Sprite7Y
//;	.byte $00									//; D010: VIC_SpriteXMSB
//;	.byte D000_SkipValue						//; D011: VIC_D011
//;	.byte D000_SkipValue						//; D012: VIC_D012
//;	.byte D000_SkipValue						//; D013: VIC_LightPenX
//;	.byte D000_SkipValue						//; D014: VIC_LightPenY
//;	.byte $00									//; D015: VIC_SpriteEnable
//;	.byte D016_Value_40Cols						//; D016: VIC_D016
//;	.byte $00									//; D017: VIC_SpriteDoubleHeight
//;	.byte D018Value0							//; D018: VIC_D018
//;	.byte D000_SkipValue						//; D019: VIC_D019
//;	.byte D000_SkipValue						//; D01A: VIC_D01A
//;	.byte $00									//; D01B: VIC_SpriteDrawPriority
//;	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
//;	.byte $00									//; D01D: VIC_SpriteDoubleWidth
//;	.byte $00									//; D01E: VIC_SpriteSpriteCollision
//;	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
//;	.byte D000_SkipValue						//; D020: VIC_BorderColour
//;	.byte D000_SkipValue						//; D021: VIC_ScreenColour
//;	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
//;	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
//;	.byte $00									//; D024: VIC_ExtraBackgroundColour2
//;	.byte $06									//; D025: VIC_SpriteExtraColour0
//;	.byte $0e									//; D026: VIC_SpriteExtraColour1
//;	.byte $01									//; D027: VIC_Sprite0Colour
//;	.byte $00									//; D028: VIC_Sprite1Colour
//;	.byte $01									//; D029: VIC_Sprite2Colour
//;	.byte $00									//; D02A: VIC_Sprite3Colour
//;	.byte $01									//; D02B: VIC_Sprite4Colour
//;	.byte $00									//; D02C: VIC_Sprite5Colour
//;	.byte $01									//; D02D: VIC_Sprite6Colour
//;	.byte $00									//; D02E: VIC_Sprite7Colour

.var ZP_TardisSinePos	= $0f

.var ZP_FrameCounterLo	= $08
.var ZP_FrameCounterHi	= ZP_FrameCounterLo + 1

InitialColourScreens:							.byte $00, $09, $05, $0d, $01, $0f, $0c, $0b, $ff
												.byte $0b, $0c, $0f, $01, $0d, $05, $09, $00, $ff

InitialColourTextSprites:						.byte $0b, $0b, $0b, $0b, $0b, $0c, $0f, $01
InitialColourTardisSprites_01:					.byte $0b, $0c, $0f, $01, $01, $01, $01, $01
InitialColourTardisSprites_00:					.byte $0b, $0c, $0f, $01, $03, $0e, $06, $00
InitialColourTardisSprites_06:					.byte $0b, $0c, $0f, $01, $01, $03, $0e, $06
InitialColourTardisSprites_0e:					.byte $0b, $0c, $0f, $01, $01, $01, $03, $0e

OutsideBorderFadeColourTable:					.byte $0c, $0f, $0d, $01, $0f, $0e, $04, $06, $09, $00, $09, $06, $04, $0e, $0f, $01, $0d, $0f, $0c, $0b
OutsideBorderWhiteBarFadeColourTable:			.byte $0c, $0f, $0d, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $0d, $0f, $0c, $0b

SpriteFadeFrame:								.byte $00

//; TARDIS_Go() -------------------------------------------------------------------------------------------------------
TARDIS_Go:

		ldy #$00
	!FillScreenColoursLoop:
		lda #$00
		sta ZP_TardisSinePos
		.for (var i = 0; i < 4; i++)
		{
			sta ScreenAddress0 + (i * 256), y
		}
		iny
		bne !FillScreenColoursLoop-

		ldy #7
	ClearCharLoop:
		sta CharAddress0, y
		dey
		bpl ClearCharLoop

		ldx #$10
		.for (var i = 0; i < 8; i++)
		{
			stx ScreenAddress0 + $3f8 + i
			.if (i != 7)
			{
				inx
			}
		}

		lda #$a0
		sta ZP_FrameCounterLo
		lda #$fe
		sta ZP_FrameCounterHi

	TARDIS_ReGo:

	!W:
		bit VIC_D011
		bmi !W-

	!W:
		bit VIC_D011
		bpl !W-

		lda #$20
	WaitFor20:
		cmp VIC_D012
		bcs WaitFor20

		lda #D016_Value_40Cols
		sta VIC_D016

	OnlyDoThisOnce:
		lda DoFadeOut

		sei

		lda #$00
		sta $7fff	//; ghostbyte
		sta VIC_D011
		sta VIC_D012
		lda #<IRQ_Initial
		sta $fffe
		lda #>IRQ_Initial
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #JMP_ABS
		sta OnlyDoThisOnce

		MACRO_SetVICBank(BaseBank0)
		lda #$1b
		sta VIC_D011

		jsr IRQLoader_LoadNext

		lda #>ADDR_CCFrame0Code
		jsr	CombineDataSets

		jsr IRQLoader_LoadNext

		lda #>ADDR_CCFrame1Code
		jsr	CombineDataSets

		jsr IRQLoader_LoadNext
		
		lda #>ADDR_CCFrame2Code
		jmp	CombineDataSets


IRQ_Initial:

		IRQManager_BeginIRQ(0, 0)

	InitialColourFade:
		lda #$00
		lsr
		lsr
		tay
		lda InitialColourScreens, y
		bmi FinishedColourFade
		sta VIC_BorderColour
		sta VIC_ScreenColour

		jsr BASE_PlayMusic

		inc InitialColourFade + 1

		jmp FinishIRQ

	FinishedColourFade:

		lda #$04
		jsr SetIRQ_Raster00B

	FinishIRQ:

		IRQManager_EndIRQ()
		rti


IRQ_Tardis:

		IRQManager_BeginIRQ(0, 0)

		jsr TARDIS_SetSpritePositions

		inc ZP_FrameCounterLo
		bne !FrameNot256+
		inc ZP_FrameCounterHi
		bne !FrameNot256+
		inc PART_Done
	!FrameNot256:

		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #$06
		sta VIC_D012
		lda #<IRQ_TARDIS_SetBorderColour0
		sta $fffe
		lda #>IRQ_TARDIS_SetBorderColour0
		sta $ffff

		IRQManager_EndIRQ()
		rti

IRQ_60Years:

		IRQManager_BeginIRQ(0, 0)

	DoYears60:
		jsr YEARS60_SetSpritePositions

		lda #$fb
		sta VIC_D012
		lda #<IRQ_Tardis
		sta $fffe
		lda #>IRQ_Tardis
		sta $ffff

		IRQManager_EndIRQ()
		rti


IRQ_TARDIS_SetBorderColour0:

		IRQManager_BeginIRQ(1, 0)

	WhiteBarColour0:
		lda #$0b
		sta VIC_BorderColour
		ldy #$09
	!Delay:
		dey
		bpl !Delay-
		nop
		nop
		nop
	OutsideBorderColour1:
		lda #$0b
		sta VIC_BorderColour

	OutsideBorderFade:
		lda #$00
		lsr
		lsr
		tay
		lda OutsideBorderWhiteBarFadeColourTable, y
		sta WhiteBarColour0 + 1
		sta WhiteBarColour1 + 1
		lda OutsideBorderFadeColourTable, y
		sta OutsideBorderColour0 + 1
		sta OutsideBorderColour1 + 1
	ColourToTestAgainst:
		cmp #$00
		beq NoMoreFade
		inc OutsideBorderFade + 1
	NoMoreFade:

		jsr SetIRQ_Raster00

		IRQManager_EndIRQ()
		rti


IRQ_TARDIS_SetBorderColour1:

		IRQManager_BeginIRQ(1, 0)

	WhiteBarColour1:
		lda #$0b
		sta VIC_BorderColour
		ldy #$09
	!Delay:
		dey
		bpl !Delay-
		nop
		nop
		nop
		lda #$0b
		sta VIC_BorderColour

		lda #194
		sta VIC_D012
		lda #<IRQ_60Years
		sta $fffe
		lda #>IRQ_60Years
		sta $ffff

		IRQManager_EndIRQ()
		rti

IRQ_TARDIS_SetBorderColour_Raster00:

		IRQManager_BeginIRQ(1, 0)

	OutsideBorderColour0:
		lda #$0b
		sta VIC_BorderColour

	PlayMusicJSR:
		jsr BASE_PlayMusic

		lda #JSR_ABS
		sta PlayMusicJSR

		lda #38
		sta VIC_D012
		lda #<IRQ_TARDIS_SetBorderColour1
		sta $fffe
		lda #>IRQ_TARDIS_SetBorderColour1
		sta $ffff

		IRQManager_EndIRQ()
		rti

TARDIS_SetSpritePositions:

		lda	ZP_TardisSinePos
		clc
		adc #1
		and #$3f
		sta ZP_TardisSinePos
		tax

		lda ADDR_SpriteSinTable_X, x
		sta VIC_Sprite0X
		sta VIC_Sprite2X
		sta VIC_Sprite4X
		sta VIC_Sprite6X
		clc
		adc #$18
		sta VIC_Sprite1X
		sta VIC_Sprite3X
		sta VIC_Sprite5X
		sta VIC_Sprite7X

		lda ADDR_SpriteSinTable_Y, x
		clc
		adc #100
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		adc #21
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		adc #21
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		adc #21
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		ldx #$10
		.for (var i = 0; i < 4; i++)
		{
			stx ScreenAddress0 + $3f8 + i
			.if (i != 3)
			{
				inx
			}
		}

	SpriteFadeDelayedFrame:
		ldx #$00
	SpriteFadeEnd:
		cpx #$1f
		beq NoIncrease
	SpriteFadeINXorDEX:
		inx
		stx SpriteFadeDelayedFrame + 1
	NoIncrease:
		txa
		lsr
		lsr
		sta SpriteFadeFrame
		cmp #$07
		bcc WithinRange
		lda #$07
	WithinRange:
		tay
		lda InitialColourTardisSprites_01, y
		sta VIC_Sprite0Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite6Colour
		lda InitialColourTardisSprites_00, y
		sta VIC_Sprite1Colour
		sta VIC_Sprite3Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite7Colour
		lda InitialColourTardisSprites_06, y
		sta VIC_SpriteExtraColour0
		lda InitialColourTardisSprites_0e, y
		sta VIC_SpriteExtraColour1

		lda #$ff
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteEnable

		rts

YEARS60_SetSpritePositions:

		lda	ZP_FrameCounterLo
		clc
		adc #$13
		and #$3f
		eor #$3f
		tax

		lda ADDR_SpriteSinTable_X, x
		sec
		sbc #$18
		sta VIC_Sprite0X
		clc
		adc #$18
		sta VIC_Sprite1X
		clc
		adc #$18
		sta VIC_Sprite2X
		clc
		adc #$18
		sta VIC_Sprite3X

		lda ADDR_SpriteSinTable_Y, x
		clc
		adc #200
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y

		ldx #$18
		.for (var i = 0; i < 4; i++)
		{
			stx ScreenAddress0 + $3f8 + i
			.if (i != 3)
			{
				inx
			}
		}

		ldy SpriteFadeFrame
		lda InitialColourTardisSprites_01, y
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour

		lda #$00
		sta VIC_SpriteMulticolourMode

		rts

SetIRQ_Raster00:

		lda #$00
	SetIRQ_Raster00B:	//; a special kind of hack!
		sta VIC_D012
		lda VIC_D011
		and #$1f
		sta VIC_D011
		lda #<IRQ_TARDIS_SetBorderColour_Raster00
		sta $fffe
		lda #>IRQ_TARDIS_SetBorderColour_Raster00
		sta $ffff
		rts


DoFadeOut:

	!W:
		bit VIC_D011
		bpl !W-

		sei
		jsr SetIRQ_Raster00

		lda #LDA_ABS
		sta PlayMusicJSR

		lda #$01
		sta VIC_D01A
		asl VIC_D019

		lda #$0b
		sta ColourToTestAgainst + 1
		lda #LDA_ABS
		sta DoYears60

		lda #$00
		sta SpriteFadeEnd + 1
		lda #$7f
		sta SpriteFadeDelayedFrame + 1
		lda #DEX
		sta SpriteFadeINXorDEX

		lda #DD02Value0
		sta VIC_DD02

		lda #$70
		sta ZP_FrameCounterLo
		lda #$ff
		sta ZP_FrameCounterHi

		cli
		jmp IRQLoader_LoadNext

