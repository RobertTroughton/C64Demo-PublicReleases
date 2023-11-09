//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2200 "RotatingGPBase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2200-6fff Code
//; - $7000-79ff "Presents" Sine Data
//; - $8000-83ff "Presents" Screen and Charset
//; - $8400-857f "Presents" Sprite Data
//; - $8580-86ff "Presents" Sprite Colour Fade Table
//; - $c000-f7ff Charsets
//l	---- $f800-fbff Screen 0

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank0 = 14 //; Bank+[3800,3bff]
	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharBank1 = 1 //; Bank+[0800,0f3f]
	.var CharBank2 = 2 //; Bank+[1000,17ff]
	.var CharBank3 = 3 //; Bank+[1800,1fff]
	.var CharBank4 = 4 //; Bank+[2000,27ff]
	.var CharBank5 = 5 //; Bank+[2800,2fff]
	.var CharBank6 = 6 //; Bank+[3000,37ff]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var SpriteVals0 = (ScreenAddress0 + $3F8)
	.var SpriteValsPresents = $83f8

	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank0 * 16) + (CharBank1 * 2)
	.var D018Value2 = (ScreenBank0 * 16) + (CharBank2 * 2)
	.var D018Value3 = (ScreenBank0 * 16) + (CharBank3 * 2)
	.var D018Value4 = (ScreenBank0 * 16) + (CharBank4 * 2)
	.var D018Value5 = (ScreenBank0 * 16) + (CharBank5 * 2)
	.var D018Value6 = (ScreenBank0 * 16) + (CharBank6 * 2)
	.var D018Value7 = (ScreenBank0 * 16) + (CharBank6 * 2)
	.var D018Value8 = (ScreenBank0 * 16) + (CharBank6 * 2)
	
	.var D016_40ColsHi = $18

	.var ADDR_PresentsSineData	= $7000
	.var ADDR_SpriteColourTable = $8580

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:
	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $00									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_40ColsHi							//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte D000_SkipValue						//; D021: VIC_ScreenColour
	.byte $04									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $01									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
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

FrameCounterLo:		.byte $24
FrameCounterHi:		.byte $fe

FrameBottom: .byte $00

.align 256
RasterColours:
		.fill 256, 0
RasterLogoColours:
		.fill 256, 0

//; RotatingGP_Go() -------------------------------------------------------------------------------------------------------
RotatingGP_Go:

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

		ldy #$00
		lda #$08
	FillColLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillColLoop
		lda #$00
	FillScrLoop:
		sta ScreenAddress0 + (0 * 256), y
		sta ScreenAddress0 + (1 * 256), y
		sta ScreenAddress0 + (2 * 256), y
		sta ScreenAddress0 + (3 * 256), y
		iny
		bne FillScrLoop

		jsr UpdateFrames

		vsync()

		sei	

		lda #42
		sta VIC_D012
		lda #$1b
		sta VIC_D011
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		rts


IRQ_Main:
		IRQManager_BeginIRQ(1, 0)

	FrameTop:
		ldx #$00
	FrameRaster:
		ldy #$00
		jsr MainIRQ

		jsr UpdateFrames
		jsr BASE_PlayMusic

	FadeOutFrame:
		ldx #$ff
		bmi NotDoingFadeOut
		dex
		stx FadeOutFrame + 1
		bne NotLastFrame

		inc PART_Done

	NotDoingFadeOut:
		inc FrameCounterLo
		bne NotLastFrame
		inc FrameCounterHi
		bne NotLastFrame

		:BranchIfNotFullDemo(NotLastFrame)

		lda #$a9
		sta ColourTableRead + 0
		sta LogoColourTableRead + 0
		lda #$00
		sta ColourTableRead + 1
		sta LogoColourTableRead + 1
		lda #$ea
		sta ColourTableRead + 2
		sta LogoColourTableRead + 2

		lda #$7f
		sta FadeOutFrame + 1

	NotLastFrame:

	LogoFadeInFrameIndex:
		ldx #$a0
		beq FinishedLogoFadeIn
		inx
		stx LogoFadeInFrameIndex + 1
		bne FinishedLogoFadeIn

		lda #$bd	//; LDA_ABX
		sta LogoColourTableRead + 0
		lda #<LogoColourTable
		sta LogoColourTableRead + 1
		lda #>LogoColourTable
		sta LogoColourTableRead + 2

	FinishedLogoFadeIn:

		lda #42
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti

UpdateFrames:

	FrameIndexTop:
		ldy #$00
		lda FrameSine, y
		sta FrameTop + 1
		iny
		cpy #64
		bne FTNotLoop
		ldy #0
	FTNotLoop:
		sty FrameIndexTop + 1

	FrameIndexBottom:
		ldy #$0e
		lda FrameSine, y
		sta FrameBottom
		iny
		cpy #64
		bne FBNotLoop
		ldy #0
	FBNotLoop:
		sty FrameIndexBottom + 1

		lda FrameRaster + 1
		sec
		sbc #1
		and #$7f
		sta FrameRaster + 1
		tay
		
	ColVal:
		ldx #$00
	ColourTableRead:
		lda ColourTable, x
		bpl ColGood
		ldx #$ff
		lda ColourTable
	ColGood:
		inx
		stx ColVal + 1

		sta RasterColours, y
		sta RasterColours + 128, y

	LogoColVal:
		ldx #$00
	LogoColourTableRead:
		lda #$00 //;LogoColourTable, x
		nop
		bpl LogoColGood
		ldx #$ff
		lda LogoColourTable
	LogoColGood:
		sta RasterLogoColours, y
		sta RasterLogoColours + 128, y
		inx
		stx LogoColVal + 1

	D016IndexTop:
		ldy #$00
		lda D016Sine, y
		sta VIC_D016
		iny
		cpy #64
		bne SineNot64
		ldy #0
	SineNot64:
		sty D016IndexTop + 1

	D016IndexBottom:
		ldy #$25
		lda D016Sine, y
		sta D016ValueBottom + 1
		iny
		cpy #64
		bne SineNot64B
		ldy #0
	SineNot64B:
		sty D016IndexBottom + 1

		rts

ColourTable:
.import source "../../Build/6502/RotatingGP/RasterColours.asm"

LogoColourTable:
.import source "../../Build/6502/RotatingGP/RasterLogoColours.asm"

D016Sine:
.import source "../../Build/6502/RotatingGP/D016Sine.asm"

FrameSine:
.import source "../../Build/6502/RotatingGP/FrameSine.asm"

.align 256
.import source "../../Build/6502/RotatingGP/MainIRQ.asm"

Presents_Go:

		ldy #$00
		lda #$00
		sta $bfff
	FillScreenAndCharsetLoop:
		sta $8000, y
		sta $8100, y
		sta $8200, y
		sta $8300, y
		iny
		bne FillScreenAndCharsetLoop

		lda #$00
		ldy #29
		.for (var i = 0; i < 8; i++)
		{
			ldx #24 + 160 - (4 * 24) + (i * 24) - 14 + (i * 4)
			stx VIC_Sprite0X + (i * 2)
			sty VIC_Sprite0Y + (i * 2)
			sta VIC_Sprite0Colour + i
		}

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight

		lda #$80
		sta VIC_SpriteXMSB

		ldx #$10
		stx SpriteValsPresents + 0
		inx
		stx SpriteValsPresents + 1
		inx
		stx SpriteValsPresents + 2
		stx SpriteValsPresents + 4
		inx
		stx SpriteValsPresents + 3
		stx SpriteValsPresents + 7
		inx
		stx SpriteValsPresents + 5
		inx
		stx SpriteValsPresents + 6

		bit VIC_D011
		bpl *-3
		bit VIC_D011
		bmi *-3

		lda #$00
		sta VIC_D018
		lda #$1b
		sta VIC_D011
		MACRO_SetVICBank(2)

		sei

		ldx #$01
		lda #147
	WaitForBarTopLine:
		cmp VIC_D012
		bne WaitForBarTopLine
		
		ldy #2
	TopLineDelayLoop:
		dey
		bne TopLineDelayLoop
		nop

		stx VIC_BorderColour
		stx VIC_ScreenColour

		ldx #$00
		lda #151
	WaitForBarBottomLine:
		cmp VIC_D012
		bne WaitForBarBottomLine
		
		ldy #9
	BottomLineDelayLoop:
		dey
		bne BottomLineDelayLoop
		nop $ff
		nop $ff

		stx VIC_BorderColour
		stx VIC_ScreenColour

		lda #250
		sta VIC_D012
		lda #<Presents_Go_OpenBorder
		sta $fffe
		lda #>Presents_Go_OpenBorder
		sta $ffff
		asl VIC_D019 //; Acknowledge VIC interrupts
		cli

		lda #$00
		sta PART_Done

		jsr IRQLoader_LoadNext

	Loopity:
		lda PART_Done
		beq Loopity

		lda #$00
		sta PART_Done

		jmp $0500	//; FadeToNoBounds_Go

BarColourTable:	.byte $01, $07, $0d, $03, $0a, $05, $02, $09, $00
FrameIndexLo:	.byte $00

Presents_Go_MainIRQ:

		IRQManager_BeginIRQ(0, 0)

		lda #$0b
		sta VIC_D011

		lda #$00
		sta VIC_SpriteEnable

		jsr BASE_PlayMusic

		lda PART_Done
		bne Presents_SkipEverything

		inc FrameIndexLo
		bne NotFinishedPresentsDemoPart
		inc PART_Done
		bne Presents_SkipEverything
	NotFinishedPresentsDemoPart:

		ldx FrameIndexLo
		ldy ADDR_PresentsSineData + (9 * 256), x
		lda BarColourTable, y
		sta Bar_Colour + 1
		.for (var i = 0; i < 8; i++)
		{
			ldy ADDR_PresentsSineData + (i * 256), x
			sty VIC_Sprite0Y + (i * 2)
			lda ADDR_SpriteColourTable + ((7 - i) * 8), x
			sta VIC_Sprite0Colour + i
		}

	Presents_SkipEverything:

		lda #27
		sta VIC_D012
		lda #<Presents_EnableSpritesIRQ
		sta $fffe
		lda #>Presents_EnableSpritesIRQ
		sta $ffff

		IRQManager_EndIRQ()
		rti

Presents_EnableSpritesIRQ:

		IRQManager_BeginIRQ(0, 0)

		lda #$ff
		sta VIC_SpriteEnable

	Presents_SetD012:
		ldx FrameIndexLo
		lda ADDR_PresentsSineData + (8 * 256), x
		sec
		sbc #1
		sta VIC_D012
		lda #<Presents_Go_BarIRQ
		sta $fffe
		lda #>Presents_Go_BarIRQ
		sta $ffff

		IRQManager_EndIRQ()
		rti

.align 64
Presents_Go_BarIRQ:

		IRQManager_BeginIRQ(1, 0)

	Bar_Colour:
		lda #$01
		beq SkipBorderColour
		sta VIC_BorderColour
		sta VIC_ScreenColour
	SkipBorderColour:

		ldx #47
	Presents_BarDelaysB:
		dex
		bne Presents_BarDelaysB

		lda Bar_Colour + 1
		beq SkipBorderColourAgain

		lda #$00
		sta VIC_BorderColour
		sta VIC_ScreenColour
	SkipBorderColourAgain:

		lda #250
		sta VIC_D012
		lda #<Presents_Go_OpenBorder
		sta $fffe
		lda #>Presents_Go_OpenBorder
		sta $ffff

		IRQManager_EndIRQ()
		rti

Presents_Go_OpenBorder:

		IRQManager_BeginIRQ(0, 0)

		lda #$83
		sta VIC_D011

		lda #0
		sta VIC_D012
		lda #<Presents_Go_MainIRQ
		sta $fffe
		lda #>Presents_Go_MainIRQ
		sta $ffff

		IRQManager_EndIRQ()
		rti


