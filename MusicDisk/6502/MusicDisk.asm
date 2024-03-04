//; (c) 2018, Raistlin of Genesis*Project

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - e000-e0ff: Song Data


.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

.var NUM_FREQS_ON_SCREEN = 40

.var MUSICPLAYER_FlashBorder_IRQs = 0
.var MUSICPLAYER_FlashBorder_PlayMusic = 0
.var MUSICPLAYER_FlashBorder_DrawSpectrometer = 0

.var MUSICPLAYER_PlayCallsPerFrame = 1

.var SIDVolumeAddress = $07ff

.var SONGNAME_StartLine = 0
.var SONGMAKER_StartLine = 2
.var SPECTROMETER_StartLine = 4

.var SpectrometerHeight = 15
.var TopSpectrometerHeight = 10
.var BottomSpectrometerHeight = 4

.var SongData = $e000
.var SongData_SongName = SongData + 0
.var SongData_ArtistName = SongData_SongName + 40
.var SongData_InitAddr = SongData_ArtistName + 40
.var SongData_PlayAddr = SongData_InitAddr + 2
.var SongData_VolumeAddr = SongData_PlayAddr + 2
.var SongData_NumPlayCalls = SongData_VolumeAddr + 2

.var SoundbarSine = $e100
.var SpriteSine = $e600
.var FreqTable = $e400
.var FreqHiTable = FreqTable + (0 * 256)
.var FreqLoTable = FreqTable + (1 * 256)

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)	
	.var ScreenBank = 14 //; Bank+[3800,3bff]
	.var CharBankFont = 6 //; Bank+[3000,37ff] //; We only used half the font...
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * $400))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D016Value = $08
	.var D018Value = ((ScreenBank * 16) + (CharBankFont * 2))

	.var Colour_SongName = $01
	.var Colour_Artist = $0b

	.var D012FirstValue = 46
	.var D012Spacing = 52

* = $A000

MUSICPLAYER_Begin:

		jmp MUSICPLAYER_Go

//; MUSICPLAYER_LocalData -------------------------------------------------------------------------------------------------------
MUSICPLAYER_LocalData:

	.var SKIPPValue = $e1
	.var NumInitialD000Values = $2f
	INITIAL_D000Values:
		.byte $10									//; D000: VIC_Sprite0X
		.byte $a5									//; D001: VIC_Sprite0Y
		.byte $40									//; D002: VIC_Sprite1X
		.byte $a5									//; D003: VIC_Sprite1Y
		.byte $70									//; D004: VIC_Sprite2X
		.byte $a5									//; D005: VIC_Sprite2Y
		.byte $a0									//; D006: VIC_Sprite3X
		.byte $a5									//; D007: VIC_Sprite3Y
		.byte $d0									//; D008: VIC_Sprite4X
		.byte $a5									//; D009: VIC_Sprite4Y
		.byte $00									//; D00A: VIC_Sprite5X
		.byte $a5									//; D00B: VIC_Sprite5Y
		.byte $30									//; D00C: VIC_Sprite6X
		.byte $a5									//; D00D: VIC_Sprite6Y
		.byte $00									//; D00E: VIC_Sprite7X
		.byte $00									//; D00F: VIC_Sprite7Y
		.byte $60									//; D010: VIC_SpriteXMSB
		.byte SKIPPValue							//; D011: VIC_D011
		.byte SKIPPValue							//; D012: VIC_D012
		.byte SKIPPValue							//; D013: VIC_LightPenX
		.byte SKIPPValue							//; D014: VIC_LightPenY
		.byte $7f									//; D015: VIC_SpriteEnable
		.byte D016Value								//; D016: VIC_D016
		.byte $00									//; D017: VIC_SpriteDoubleHeight
		.byte D018Value								//; D018: VIC_D018
		.byte SKIPPValue							//; D019: VIC_D019
		.byte SKIPPValue							//; D01A: VIC_D01A
		.byte $00									//; D01B: VIC_SpriteDrawPriority
		.byte $00									//; D01C: VIC_SpriteMulticolourMode
		.byte $7f									//; D01D: VIC_SpriteDoubleWidth
		.byte $00									//; D01E: IC_SpriteSpriteCollision
		.byte $00									//; D01F: VIC_SpriteBackgroundCollision
		.byte $00									//; D020: VIC_BorderColour
		.byte $00									//; D021: VIC_ScreenColour
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
		.byte $00									//; D02C: VIC_Sprite5Colour
		.byte $00									//; D02D: VIC_Sprite6Colour
		.byte $00									//; D02E: VIC_Sprite7Colour


	UpdateSpectrometerSignal:						.byte $00
	Signal_SpacePressed:							.byte $00
	Signal_ChangeSong:								.byte $00

	.align 256

	LoFreqToLookupTable:		.fill 256, i / 4
	SustainConversion:			.fill 256, floor(i / 16) * 4 + 20
	ReleaseConversionHi:		.fill 256, (mod(i, 16) * 32) / 256 + 1
	ReleaseConversionLo:		.fill 256, mod(mod(i, 16) * 32, 256)
								
								.byte 0, 0
	MeterTempHi:				.fill NUM_FREQS_ON_SCREEN, 0
								.byte 0, 0

								.byte 0, 0
	MeterTempLo:				.fill NUM_FREQS_ON_SCREEN, 0
								.byte 0, 0

								.byte 0, 0
	MeterReleaseHi:				.fill NUM_FREQS_ON_SCREEN, 0
								.byte 0, 0

								.byte 0, 0
	MeterReleaseLo:				.fill NUM_FREQS_ON_SCREEN, 0
								.byte 0, 0

	MeterColourValues_Darker:	.fill 80, $00
	MeterColourValues:			.fill 80, $0b

	dBMeterValue:				.fill NUM_FREQS_ON_SCREEN,0
	SID_Ghostbytes:				.fill 32,0
	HiFreqToLookupTable:		.fill 4, i * 64

	DarkColourLookup:			.byte $00, $0c, $00, $0e, $06, $09, $00, $08
								.byte $02, $0b, $02, $00, $0b, $05, $06, $0c

	.var NumColourSets = 4
	MeterColourSetA:			.byte $09, $04, $0d, $01
	MeterColourSetB:			.byte $06, $0e, $07, $01
	MeterColourSetC:			.byte $02, $0a, $0d, $01
	MeterColourSetD:			.byte $0b, $0c, $0f, $01

	MeterColourSetPtr_Lo:		.byte <MeterColourSetA, <MeterColourSetB, <MeterColourSetC, <MeterColourSetD
	MeterColourSetPtr_Hi:		.byte >MeterColourSetA, >MeterColourSetB, >MeterColourSetC, >MeterColourSetD

	MeterColourValueOffsets:	.fill 2, $ff											//; +  2 =  2
								.byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff	//; + 10 = 12
								.fill 5, $00											//; +  5 = 17
								.byte $01, $00, $01, $00, $01, $00, $01, $00, $01, $00	//; + 10 = 27
								.byte $01, $00, $01, $00, $01, $00, $01, $00, $01, $00	//; + 10 = 37
								.fill 5, $01											//; +  5 = 42
								.byte $02, $01, $02, $01, $02, $01, $02, $01, $02, $01	//; + 10 = 52
								.byte $02, $01, $02, $01, $02, $01, $02, $01, $02, $01	//; + 10 = 62
								.fill 4, $02											//; +  4 = 66
								.byte $03, $02, $03, $02, $03, $02, $03, $02, $03, $02	//; + 10 = 76
								.fill 4, $03											//; +  4 = 80


	//; D011/2 stuff for IRQs..
	D011Values_Music1X:			.fill 1, floor(((42 + (i * 312)) / 256)) * 128
	D012Values_Music1X:			.fill 1, 200
	SpecValues_Music1X:			.byte 1
	D011Values_Music2X:			.fill 2, floor(((42 + (i * 156)) / 256)) * 128
	D012Values_Music2X:			.fill 2, 42 + (i * 156)
	SpecValues_Music2X:			.byte 0, 1
	D011Values_Music3X:			.fill 3, floor(((42 + (i * 104)) / 256)) * 128
	D012Values_Music3X:			.fill 3, 42 + (i * 104)
	SpecValues_Music3X:			.byte 0, 0, 1
	D011Values_Music4X:			.fill 4, floor(((42 + (i * 78)) / 256)) * 128
	D012Values_Music4X:			.fill 4, 42 + (i *  78)
	SpecValues_Music4X:			.byte 0, 0, 1, 0
	D011Values_Music5X:			.fill 5, floor(((42 + (i * 62)) / 256)) * 128
	D012Values_Music5X:			.fill 5, 42 + (i *  62)
	SpecValues_Music5X:			.byte 0, 0, 0, 1, 0
	D011Values_Music6X:			.fill 6, floor(((42 + (i * 52)) / 256)) * 128
	D012Values_Music6X:			.fill 6, 42 + (i *  52)
	SpecValues_Music6X:			.byte 0, 0, 0, 1, 0, 0
	D011Values_PtrsLo:			.byte 0, <D011Values_Music1X, <D011Values_Music2X, <D011Values_Music3X, <D011Values_Music4X, <D011Values_Music5X, <D011Values_Music6X
	D011Values_PtrsHi:			.byte 0, >D011Values_Music1X, >D011Values_Music2X, >D011Values_Music3X, >D011Values_Music4X, >D011Values_Music5X, >D011Values_Music6X
	D012Values_PtrsLo:			.byte 0, <D012Values_Music1X, <D012Values_Music2X, <D012Values_Music3X, <D012Values_Music4X, <D012Values_Music5X, <D012Values_Music6X
	D012Values_PtrsHi:			.byte 0, >D012Values_Music1X, >D012Values_Music2X, >D012Values_Music3X, >D012Values_Music4X, >D012Values_Music5X, >D012Values_Music6X
	SpecValues_PtrsLo:			.byte 0, <SpecValues_Music1X, <SpecValues_Music2X, <SpecValues_Music3X, <SpecValues_Music4X, <SpecValues_Music5X, <SpecValues_Music6X
	SpecValues_PtrsHi:			.byte 0, >SpecValues_Music1X, >SpecValues_Music2X, >SpecValues_Music3X, >SpecValues_Music4X, >SpecValues_Music5X, >SpecValues_Music6X

.align 256	
		.fill 72, 224
	MeterToCharValues:
		.fill 8, i + 224 + 1
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9
		.fill 7, i + 224 + 9

	.print "* $" + toHexString(MUSICPLAYER_LocalData) + "-$" + toHexString(EndMUSICPLAYER_LocalData - 1) + " MUSICPLAYER_LocalData"

EndMUSICPLAYER_LocalData:

.align 128
Div3:	.fill 128, i / 3

//; MUSICPLAYER_Go() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_Go:

		jsr PreDemoSetup

		bit	VIC_D011
		bpl	*-3
		bit	VIC_D011
		bmi	*-3

		lda #$00
		sta VIC_D011

		jsr $1f9

		sei

		ldx #(NumInitialD000Values - 1)
	SetupD000Values:
		lda INITIAL_D000Values, x
		cmp #SKIPPValue
		beq SkipThisOne
		sta $d000, x
	SkipThisOne:
		dex
		bpl SetupD000Values

		lda #(BaseBank + 60)
		sta VIC_DD02

	//; Init the meter colour values
		ldx #79
	InitMeterColourValuesLoop:
		lda #$0b
		ldy MeterColourValueOffsets, x
		bmi UseTheBaseLineColour
		lda MeterColourSetA, y
	UseTheBaseLineColour:
		sta MeterColourValues, x
		tay
		lda DarkColourLookup, y
		sta MeterColourValues_Darker, x
		dex
		bpl InitMeterColourValuesLoop

		ldx #$00
		lda #$20
	ClearLoop:
		sta VIC_ColourMemory + (0 * 256), x
		sta VIC_ColourMemory + (1 * 256), x
		sta VIC_ColourMemory + (2 * 256), x
		sta VIC_ColourMemory + (3 * 256), x
		sta ScreenAddress + (0 * 256), x
		sta ScreenAddress + (1 * 256), x
		sta ScreenAddress + (2 * 256), x
		sta ScreenAddress + (3 * 256), x
		inx
		bne ClearLoop

		ldx #39
	FillDisplayNameColoursLoop:
		lda #Colour_SongName
		sta VIC_ColourMemory + ((SONGNAME_StartLine + 0) * 40), x
		sta VIC_ColourMemory + ((SONGNAME_StartLine + 1) * 40), x
		lda #Colour_Artist
		sta VIC_ColourMemory + ((SONGMAKER_StartLine + 0) * 40), x
		sta VIC_ColourMemory + ((SONGMAKER_StartLine + 1) * 40), x
		dex
		bpl FillDisplayNameColoursLoop

		bit	VIC_D011
		bpl	*-3
		bit	VIC_D011
		bmi	*-3

		lda #$1b
		sta VIC_D011

		lda #<MUSICPLAYER_IRQ0
		sta $fffe
		lda #>MUSICPLAYER_IRQ0
		sta $ffff
		lda #D012FirstValue + (D012Spacing * 0)
		sta VIC_D012
		lda VIC_D011
		and #$3f
		sta VIC_D011

		lda #$01
		sta VIC_D01A
		sta VIC_D019

		lda #$35
		sta $01

		cli
	
		jsr MUSICPLAYER_SetupNewSong_SkipBlanking

	LoopForever:

	//; Did we press space?
		lda Signal_ChangeSong
		bne SpaceWasntPressed	//; skip the space-check if we're already changing the song..!

		jsr MUSICPLAYER_CheckForSpaceBar
		lda Signal_SpacePressed
		beq SpaceWasntPressed
		lda #$00
		sta Signal_SpacePressed
		lda #$01
		sta Signal_ChangeSong

	VBWait00:
		lda VIC_D011
		bpl VBWait00

		lda #$00
		sta VIC_D011

	SpaceWasntPressed:

	//; Change song?
		lda Signal_ChangeSong
		cmp #2
		bne DontDoChangeSongUpdate

	SongIndex:
		ldx #1
		inx
		cpx #27
		bne NotLastSong
		ldx #1
	NotLastSong:
		stx SongIndex + 1
		txa
		jsr $160
		
		jsr MUSICPLAYER_SetupNewSong

	VBWait:
		lda VIC_D011
		bpl VBWait

		lda #$1b
		sta VIC_D011

	DontDoChangeSongUpdate:

		lda UpdateSpectrometerSignal
		beq LoopForever

		.if (MUSICPLAYER_FlashBorder_DrawSpectrometer == 1)
		{
			lda #$02
			sta $d020
		}

		jsr MUSICPLAYER_DrawSpectrum

		lda #$00
		sta UpdateSpectrometerSignal

		jsr MUSICPLAYER_Spectrometer_PerFrame

		.if (MUSICPLAYER_FlashBorder_DrawSpectrometer == 1)
		{
			lda #$00
			sta $d020
		}

		jmp LoopForever

MUSICPLAYER_SetSongPlayRateForIRQ:

		lda D011Values_PtrsLo, x
		sta D011ValueRead + 1
		lda D011Values_PtrsHi, x
		sta D011ValueRead + 2
		lda D012Values_PtrsLo, x
		sta D012ValueRead + 1
		lda D012Values_PtrsHi, x
		sta D012ValueRead + 2
		lda SpecValues_PtrsLo, x
		sta SpecValueRead + 1
		lda SpecValues_PtrsHi, x
		sta SpecValueRead + 2
		stx NumPlaysPerFrame + 1
		rts

MUSICPLAYER_NextIRQ:
		ldx #$00

	SpecValueRead:
		lda SpecValues_Music1X, x
		sta UpdateSpectrometerSignal

		inx

	NumPlaysPerFrame:
		cpx #$01
		bne NotFinalIRQ

		ldx #$00
	NotFinalIRQ:
		stx MUSICPLAYER_NextIRQ + 1

		lda VIC_D011
		and #$3f
	D011ValueRead:
		ora D011Values_Music1X, x
		sta VIC_D011

	D012ValueRead:
		lda D012Values_Music1X, x
		sta VIC_D012

		cpx #$00
		bne MoreToPlay

		lda #<MUSICPLAYER_IRQ0
		sta $fffe
		lda #>MUSICPLAYER_IRQ0
		sta $ffff
		rts

	MoreToPlay:

		lda #<MUSICPLAYER_IRQ_JustMusic
		sta $fffe
		lda #>MUSICPLAYER_IRQ_JustMusic
		sta $ffff
		rts

//; MUSICPLAYER_IRQ0() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_IRQ0:

		pha
		txa
		pha
		tya
		pha

		.if (MUSICPLAYER_FlashBorder_IRQs == 1)
		{
			lda $d020
			pha
			lda #$05
			sta $d020
		}

		lda Signal_ChangeSong
		beq DoPlayMusic
		lda #$00
		sta $d418
		lda #2
		sta Signal_ChangeSong
		bne SkipPlayMusic

	DoPlayMusic:
		jsr MUSICPLAYER_PlayMusic
	SkipPlayMusic:

		inc FrameOf256
		bne Not256thFrame
		inc Frame_256Counter

		lda #$00
		sta DoNextColourSet + 1
	ColourSet:
		ldx #$00
		inx
		cpx #NumColourSets
		bne NotLastColourSet
		ldx #$00
	NotLastColourSet:
		stx ColourSet + 1

		lda MeterColourSetPtr_Lo, x
		sta MeterColourSetReadLDA + 1
		lda MeterColourSetPtr_Hi, x
		sta MeterColourSetReadLDA + 2
	Not256thFrame:

	DoNextColourSet:
		lda #$00
		bmi DontUpdateColourSet
		tax

		lda #$0b
		ldy MeterColourValueOffsets, x
		bmi UseBaseLineColourB
	MeterColourSetReadLDA:
		lda MeterColourSetA, y
	UseBaseLineColourB:
		sta MeterColourValues, x

		tay
		lda DarkColourLookup, y
		sta MeterColourValues_Darker, x

		lda DoNextColourSet + 1
		clc
		adc #$01
		cmp #$50
		bne NotLastEntry
		lda #$ff
	NotLastEntry:
		sta DoNextColourSet + 1
	DontUpdateColourSet:

	SpriteMovementX:
		ldx #$00

		lda SpriteSine, x
		.for (var Index = 0; Index < 7; Index++)
		{
			sta VIC_Sprite0X + (Index * 2)
			.if (Index != 6)
			{
				clc
				adc #$30
			}
		}

		lda SpriteSine + 128, x
		sta VIC_SpriteXMSB

	//; Sprite Animation
		ldy #$00
	SpriteAnimIndex:
		lda FrameOf256
		lsr
		lsr
		and #$07
		ora #$b0
		.for (var Index = 0; Index < 7; Index++)
		{
			sta SpriteVals + Index
		}

		stx SpriteMovementX + 1

		lda Signal_ChangeSong
		bne NoNewIRQ
		jsr MUSICPLAYER_NextIRQ
	NoNewIRQ:

		lda #$01
		sta VIC_D01A
		sta VIC_D019

		.if (MUSICPLAYER_FlashBorder_IRQs == 1)
		{
			pla
			sta $d020
		}

		pla
		tay
		pla
		tax
		pla

		rti

//; MUSICPLAYER_IRQ_JustMusic() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_IRQ_JustMusic:

		pha
		txa
		pha
		tya
		pha

		.if (MUSICPLAYER_FlashBorder_IRQs == 1)
		{
			lda $d020
			pha
			lda #$05
			sta $d020
		}

		jsr MUSICPLAYER_PlayMusic

		jsr MUSICPLAYER_NextIRQ

		lda #$01
		sta VIC_D01A
		sta VIC_D019

		.if (MUSICPLAYER_FlashBorder_IRQs == 1)
		{
			pla
			sta $d020
		}

		pla
		tay
		pla
		tax
		pla

		rti

//; MUSICPLAYER_Spectrometer_PerFrame() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_Spectrometer_PerFrame:

		ldx #NUM_FREQS_ON_SCREEN - 1

	!loop:
		sec
		lda MeterTempLo, x //; + i
		sbc MeterReleaseLo, x //; + i
		sta MeterTempLo, x //; + i
		lda MeterTempHi, x //; + i
		sbc MeterReleaseHi, x //; + i
		bpl !good+
		lda #$00
		sta MeterTempLo, x //; + i
	!good:
		sta MeterTempHi, x //; + i
		tay
		lda SoundbarSine, y
		sta dBMeterValue, x //; + i

		dex
		bpl !loop-

		rts

//; MUSICPLAYER_Spectrometer_PerPlay() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_Spectrometer_PerPlay:

		.for (var ChannelIndex = 0; ChannelIndex < 3; ChannelIndex++)
		{
			ldy SID_Ghostbytes + (ChannelIndex * 7) + 1	//; hi-freq

			cpy #4
			bcc Check_FreqLoTable

		Check_FreqHiTable:
			ldx FreqHiTable, y
			jmp GotFreq

		Check_FreqLoTable:
			ldx SID_Ghostbytes + (ChannelIndex * 7) + 0	//; lo-freq
			lda LoFreqToLookupTable, x
			ora HiFreqToLookupTable, y
			tay
			ldx FreqLoTable, y
		GotFreq:

			ldy SID_Ghostbytes + (ChannelIndex * 7) + 6	//; sustain/release .. top 4 bits are sustain, bottom 4 bits are release
			lda SustainConversion, y
			cmp MeterTempHi + 0, x
			bcc NoUpdate
			sta MeterTempHi + 0, x
			lda ReleaseConversionHi, y
			sta MeterReleaseHi + 0, x
			lda ReleaseConversionLo, y
			sta MeterReleaseLo + 0, x
			lda #0
			sta MeterTempLo + 0, x

			//; LHS neighbour bar
			lda MeterTempHi + 0, x
			clc
			adc MeterTempHi - 2, x
			lsr
			cmp MeterTempHi - 1, x
			bcc NoUpdateL
			sta MeterTempHi - 1, x
			lda #$00
			sta MeterTempLo - 1, x

			clc
			lda MeterReleaseLo + 0, x
			adc MeterReleaseLo - 2, x
			sta !LoAvg+ + 1

			lda MeterReleaseHi + 0, x
			adc MeterReleaseHi - 2, x
			sta MeterReleaseHi - 1, x

		!LoAvg:
			lda #$00
			ror MeterReleaseHi - 1, x
			ror
			sta MeterReleaseLo - 1, x

		NoUpdateL:

			//; RHS neighbour bar
			lda MeterTempHi + 0, x
			clc
			adc MeterTempHi + 2, x
			lsr
			cmp MeterTempHi + 1, x
			bcc NoUpdateR
			sta MeterTempHi + 1, x
			lda #$00
			sta MeterTempLo + 1, x

			clc
			lda MeterReleaseLo + 0, x
			adc MeterReleaseLo + 2, x
			sta !LoAvg+ + 1

			lda MeterReleaseHi + 0, x
			adc MeterReleaseHi + 2, x
			sta MeterReleaseHi + 1, x

		!LoAvg:
			lda #$00
			ror MeterReleaseHi + 1, x
			ror
			sta MeterReleaseLo + 1, x


		NoUpdateR:

		NoUpdate:
		}
		rts

//; MUSICPLAYER_DrawSpectrum() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_DrawSpectrum:

		.for (var i = 0; i < NUM_FREQS_ON_SCREEN; i++)
		{
			ldx dBMeterValue + i

			.for (var Line = 0; Line < TopSpectrometerHeight; Line++)
			{
				lda MeterToCharValues - 72 + (Line * 8), x
				sta ScreenAddress + ((SPECTROMETER_StartLine + Line) * 40) + ((40 - NUM_FREQS_ON_SCREEN) / 2) + i
			}

			lda MeterColourValues, x
			.for (var Line = 0; Line < TopSpectrometerHeight; Line++)
			{
				sta VIC_ColourMemory + ((SPECTROMETER_StartLine + Line) * 40) + ((40 - NUM_FREQS_ON_SCREEN) / 2) + i
			}

			lda MeterColourValues_Darker, x
			.for (var Line = 0; Line < BottomSpectrometerHeight; Line++)
			{
				sta VIC_ColourMemory + ((SPECTROMETER_StartLine + SpectrometerHeight - (Line + 2)) * 40) + ((40 - NUM_FREQS_ON_SCREEN) / 2) + i
			}

			lda Div3, x
			tax
			.for (var Line = 0; Line < BottomSpectrometerHeight; Line++)
			{
				lda MeterToCharValues - 25 + (Line * 8), x
				ora #$10
				sta ScreenAddress + ((SPECTROMETER_StartLine + SpectrometerHeight - (Line + 2)) * 40) + ((40 - NUM_FREQS_ON_SCREEN) / 2) + i
			}
		}

		rts

//; MUSICPLAYER_PlayMusic() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_PlayMusic:

		.if (MUSICPLAYER_FlashBorder_PlayMusic == 1)
		{
			lda $d020
			pha
			lda #$01
			sta $d020
		}

		lda $01
		pha
		lda #$30
		sta $01

	JSR_PlayMusic:
		jsr $abcd

		.for (var i=24; i >= 0; i--)
		{
			lda $d400 + i
			sta SID_Ghostbytes + i
		}
		pla
		sta $01

		lda SID_Ghostbytes		+ $15
		sta $d400				+ $15
		lda SID_Ghostbytes		+ $16
		sta $d400				+ $16
		lda SID_Ghostbytes		+ $17
		sta $d400				+ $17
		lda SID_Ghostbytes		+ $18
		sta $d400				+ $18

		.for (var i = 0; i < 3; i++)
		{
			lda SID_Ghostbytes	+ $05 + (i * 7)
			sta $d400			+ $05 + (i * 7)
			lda SID_Ghostbytes	+ $06 + (i * 7)
			sta $d400			+ $06 + (i * 7)
			lda SID_Ghostbytes	+ $02 + (i * 7)
			sta $d400			+ $02 + (i * 7)
			lda SID_Ghostbytes	+ $03 + (i * 7)
			sta $d400			+ $03 + (i * 7)
			lda SID_Ghostbytes	+ $00 + (i * 7)
			sta $d400			+ $00 + (i * 7)
			lda SID_Ghostbytes	+ $01 + (i * 7)
			sta $d400			+ $01 + (i * 7)
			lda SID_Ghostbytes	+ $04 + (i * 7)
			sta $d400			+ $04 + (i * 7)
		}

/*		.for (var i=24; i >= 0; i--)
		{
			lda SID_Ghostbytes + i
			sta $d400 + i
		}*/

		.if (MUSICPLAYER_FlashBorder_PlayMusic == 1)
		{
			pla
			sta $d020
		}

		jmp MUSICPLAYER_Spectrometer_PerPlay

//; MUSICPLAYER_SetupNewSong() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_SetupNewSong:

		ldy #24
		lda #$00
	BlankMusicLoop:
		sta $d400, y
		sta SID_Ghostbytes, y
		dey
		bpl BlankMusicLoop

MUSICPLAYER_SetupNewSong_SkipBlanking:

		ldy #39
	SongNameDisplayLoop:
		lda SongData_SongName, y
		sta ScreenAddress + ((SONGNAME_StartLine + 0) * 40), y
		ora #$80
		sta ScreenAddress + ((SONGNAME_StartLine + 1) * 40), y

		lda SongData_ArtistName, y
		sta ScreenAddress + ((SONGMAKER_StartLine + 0) * 40), y
		eor #$80
		sta ScreenAddress + ((SONGMAKER_StartLine + 1) * 40), y

		dey
		bpl SongNameDisplayLoop

		lda SongData_InitAddr + 0
		sta JMP_InitMusic + 1
		lda SongData_InitAddr + 1
		sta JMP_InitMusic + 2

		lda SongData_PlayAddr + 0
		sta JSR_PlayMusic + 1
		lda SongData_PlayAddr + 1
		sta JSR_PlayMusic + 2

		ldx #NUM_FREQS_ON_SCREEN + 3
		lda #$00
	!loop:
		sta MeterTempHi - 2, x
		sta MeterTempLo - 2, x
		dex
		bpl !loop-

		ldx #NUM_FREQS_ON_SCREEN - 1
	!loop:
		sta dBMeterValue, x
		dex
		bpl !loop-

		ldx SongData_NumPlayCalls
		jsr MUSICPLAYER_SetSongPlayRateForIRQ

		lda #$00
		sta Signal_ChangeSong

		lda #$00
	JMP_InitMusic:
		jmp $abcd

//; MUSICPLAYER_CheckForSpaceBar() -------------------------------------------------------------------------------------------------------
MUSICPLAYER_CheckForSpaceBar:

		lda #$7f
		sta $dc00

	SpaceMode:
		lda #$00
		bne CheckForSpaceRelease

	CheckForSpacePress:
		lda $dc01
		and #$10
		bne SpaceNotPressed
		inc SpaceMode + 1
	SpaceNotPressed:
		rts

	CheckForSpaceRelease:
		lda $dc01
		cmp #$ff
		bne SpaceNotReleased
		dec SpaceMode + 1
		inc Signal_SpacePressed
	SpaceNotReleased:
		rts

//; PreDemoSetup() -------------------------------------------------------------------------------------------------------
PreDemoSetup:

		//; from Spindle by lft, www.linusakesson.net/software/spindle/
		//; Prepare CIA #1 timer B to compensate for interrupt jitter.
		//; Also initialise d01a and dc02.
		//; This code is inlined into prgloader, and also into the
		//; first effect driver by pefchain.
		bit	VIC_D011
		bmi	*-3

		bit	VIC_D011
		bpl	*-3

		ldx	VIC_D012
		inx
	resync:
		cpx	VIC_D012
		bne	*-3

		ldy	#0
		sty	$dc07
		lda	#62
		sta	$dc06
		iny
		sty	VIC_D01A
		dey
		dey
		sty	$dc02
		cmp	(0,x)
		cmp	(0,x)
		cmp	(0,x)
		lda	#$11
		sta	$dc0f
		txa
		inx
		inx
		cmp	VIC_D012
		bne	resync

		//; Regular IRQ setup
		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dc0d
		lda $dd0d

		bit $d011
		bpl *-3
		bit $d011
		bmi *-3

		lda #$01
		sta VIC_D01A

		rts
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
