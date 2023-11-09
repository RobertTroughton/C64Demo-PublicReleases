//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "TwistScrollbase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $40-$67 Scrolltext ZP
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0280-$03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-6fff Code
//; - $b000-b7ff Scrolltext
//; - $c000-c3ff Screen
//; - $c400-d7ff BKG Sprites
//; - $d000-d7ff CharSet 0
//; - $d800-dfff CharSet 1
//; - $e000-e7ff CharSet 2
//; - $e800-efff CharSet 3
//; - $f000-f7ff CharSet 4
//; - $f800-ffff CharSet 5

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank =  0 //; Bank+[0000,03ff]
	.var ADDR_Screen = Base_BankAddress0 + ScreenBank * $400
	.var SpriteVals	= ADDR_Screen + $3f8
	.var CharBank0 = 3 //; Bank+[1000,17ff]
	.var CharBank1 = 4 //; Bank+[1800,1fff]
	.var CharBank2 = 5 //; Bank+[2000,27ff]
	.var CharBank3 = 6 //; Bank+[2800,2fff]
	.var CharBank4 = 7 //; Bank+[3000,37ff]
	.var ADDR_Frame0_Charset = Base_BankAddress0 + (CharBank0 * $800)
	.var ADDR_Frame1_Charset = Base_BankAddress0 + (CharBank1 * $800)
	.var ADDR_Frame2_Charset = Base_BankAddress0 + (CharBank2 * $800)
	.var ADDR_Frame3_Charset = Base_BankAddress0 + (CharBank3 * $800)
	.var ADDR_Frame4_Charset = Base_BankAddress0 + (CharBank4 * $800)
	.var D018Value0 = (ScreenBank * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank * 16) + (CharBank1 * 2)
	.var D018Value2 = (ScreenBank * 16) + (CharBank2 * 2)
	.var D018Value3 = (ScreenBank * 16) + (CharBank3 * 2)
	.var D018Value4 = (ScreenBank * 16) + (CharBank4 * 2)

	.var D016_Value_40Cols = $08

	.var NUM_CHARS = 40

	.var ADDR_ScrollText= $b000

	.var ZPADDR_ScrollText = $40

	.var StartSpriteIndex = $10

	.var ADDR_YSine_CharOffset = $bf00
	.var ADDR_YSine = ADDR_YSine_CharOffset + $80

	.label Decompress = $ae00

//; LocalData -------------------------------------------------------------------------------------------------------

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $18, 209								//; D000-1: VIC_Sprite0X, Y
	.byte $48, 209								//; D002-3: VIC_Sprite1X, Y
	.byte $78, 209								//; D004-5: VIC_Sprite2X, Y
	.byte $a8, 209								//; D006-7: VIC_Sprite3X, Y
	.byte $d8, 209								//; D008-9: VIC_Sprite4X, Y
	.byte $08, 209								//; D00a-b: VIC_Sprite5X, Y
	.byte $38, 209								//; D00c-d: VIC_Sprite6X, Y
	.byte $f0, 209								//; D00e-f: VIC_Sprite7X, Y
	.byte $e0									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $ff									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Cols						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $ff									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $ff									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $09									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $05									//; D025: VIC_SpriteExtraColour0
	.byte $0e									//; D026: VIC_SpriteExtraColour1
	.byte $01									//; D027: VIC_Sprite0Colour
	.byte $01									//; D028: VIC_Sprite1Colour
	.byte $01									//; D029: VIC_Sprite2Colour
	.byte $01									//; D02A: VIC_Sprite3Colour
	.byte $01									//; D02B: VIC_Sprite4Colour
	.byte $01									//; D02C: VIC_Sprite5Colour
	.byte $01									//; D02D: VIC_Sprite6Colour
	.byte $01									//; D02E: VIC_Sprite7Colour

FrameCounterLo:						.byte $00
FrameCounterHi:						.byte $00

.var NumFrames = 80
ModdedFrame:						.byte NumFrames - 1
NextModdedFrame:					.byte NumFrames - 1
									.fill NumFrames - 1, i

.align 16
.import source "../../Build/6502/TwistScroll/BackgroundSprites.asm"

.align 64
.import source "../../Build/6502/TwistScroll/PlotCode.asm"

//; TwistScroll_Go() -------------------------------------------------------------------------------------------------------

TwistScroll_Go:

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #$00
	FillColourAndCharMemory:
		sta ADDR_Screen + (0 * 256), y
		sta ADDR_Screen + (1 * 256), y
		sta ADDR_Screen + (2 * 256), y
		sta ADDR_Screen + (3 * 256), y
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillColourAndCharMemory

		ldy #NUM_CHARS - 1
		lda #$00
	ClearScrollText:
		sta ZP_ScrollText, y
		dey
		bpl ClearScrollText

		vsync()

		sei

		lda #$00
		sta FrameCounterLo
		sta FrameCounterHi

		lda #220
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #$1b
		sta VIC_D011

		lda #$00
		sta VIC_BorderColour

		rts


//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		pha
		lda $01
		pha
		lda #$35
		sta $01

		lda	#15
		sec
		sbc	$dd06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5

		txa
		pha
		tya
		pha

		ldx #3
	SlightDelayLoop:
		dex
		bne SlightDelayLoop
		nop
		nop
		nop

		lda #$00
		sta VIC_ScreenColour
		
		ldx ModdedFrame
		lda NextModdedFrame, x
		sta ModdedFrame

		inc FrameCounterLo
		bne FrameNot256
		inc FrameCounterHi
	FrameNot256:

		lda #255
		sta VIC_D012
		lda #<IRQ_SplitBorderCol0
		sta $fffe
		lda #>IRQ_SplitBorderCol0
		sta $ffff
		asl VIC_D019
		cli

		lda FrameCounterLo
		and #$7f
		tay
		lda ADDR_YSine_CharOffset, y
		sta CharOffset + 1
		lda ADDR_YSine, y
		and #$07
		ora #$18
		sta SetD011 + 1
		lda ADDR_YSine, y
		clc
		adc #55
		sta SetSpriteY_Row0 + 1
		sta SetD012_Start + 1
		clc
		adc #16
		sta SetD012_0 + 1
		adc #6
		sta SetD012_1 + 1
		adc #10
		sta SetD012_2 + 1
		adc #15
		sta SetD012_3 + 1
		adc #17
		sta SetD012_4 + 1
		adc #7
		sta SetD012_5 + 1
		adc #9
		sta SetD012_6 + 1
		adc #7
		sta SetD012_7 + 1
		adc #9
		sta SetD012_8 + 1
		adc #7
		sta SetD012_9 + 1
		adc #9
		sta SetD012_10 + 1
		adc #16
		sta SetD012_11 + 1
		adc #7
		sta SetD012_12 + 1

	YIndex:
		ldy #$00
		lda FrameCounterLo
		and #$01
		bne Not40
		iny
		cpy #40
		bne Not40
		ldy #0
	Not40:
		sty YIndex + 1
		tya
		clc
	CharOffset:
		adc #$00
		tay

		jsr DoPlots
		jsr ScrollScroller

		asl VIC_D019

		pla
		tay
		pla
		tax
		pla
		sta $01
		pla

		rti


//; IRQ_Split0() -------------------------------------------------------------------------------------------------------

IRQ_Split0:

		IRQManager_BeginIRQ(0, 0)

	SetD011:
		lda #$1b
		sta VIC_D011

		jsr UpdateSprites_Row0

		lda #D018Value0
		sta VIC_D018

		lda FrameCounterLo
		and #$01
		asl
		asl
		sta VIC_D016
		
		jsr BASE_PlayMusic

	SetD012_Start:
		lda #55
		sta VIC_D012
		lda #<IRQ_Split_Start
		sta $fffe
		lda #>IRQ_Split_Start
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_SplitBorderCol0() -------------------------------------------------------------------------------------------------------

IRQ_SplitBorderCol0:

		IRQManager_BeginIRQ(0, 0)

		lda #$1b
		sta VIC_D011

		//; jsr BASE_PlayMusic

		lda #20
		sta VIC_D012
		lda #<IRQ_Split0
		sta $fffe
		lda #>IRQ_Split0
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split_Start() -------------------------------------------------------------------------------------------------------

IRQ_Split_Start:

		//; IRQManager_BeginIRQ(1, 0)

		dec	0
		pha
		nop
		lda	#29
		sec
		sbc	$dd06
		sta	* + 4
		bpl	* + 2
		lda	#$a9				//; two extra lda #$a9 here
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5

		nop						//; X and Y are not used here, replaced them with NOPs for the same timing
		nop
		nop

		lda #$09
		sta VIC_ScreenColour

	SetD012_0:
		lda #74
		sta VIC_D012
		lda #<IRQ_Split1
		sta $fffe
		lda #>IRQ_Split1
		sta $ffff

		//; IRQManager_EndIRQ()

		asl $d019
		pla
		inc $00

		rti


//; IRQ_Split1() -------------------------------------------------------------------------------------------------------

IRQ_Split1:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

	SetD012_1:
		lda #80
		sta VIC_D012
		lda #<IRQ_Split2
		sta $fffe
		lda #>IRQ_Split2
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split2() -------------------------------------------------------------------------------------------------------

IRQ_Split2:

		IRQManager_BeginIRQ(0, 0)

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

	SetD012_2:
		lda #90
		sta VIC_D012
		lda #<IRQ_Split3
		sta $fffe
		lda #>IRQ_Split3
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split3() -------------------------------------------------------------------------------------------------------

IRQ_Split3:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_3:
		lda #105
		sta VIC_D012
		lda #<IRQ_Split4
		sta $fffe
		lda #>IRQ_Split4
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split4() -------------------------------------------------------------------------------------------------------

IRQ_Split4:

		IRQManager_BeginIRQ(1, -11)

		.for (var i = 0; i < 13; i++)
		{
			nop
		}

		lda #D018Value1
		sta VIC_D018

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_4:
		lda #122
		sta VIC_D012
		lda #<IRQ_Split5
		sta $fffe
		lda #>IRQ_Split5
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split5() -------------------------------------------------------------------------------------------------------

IRQ_Split5:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_5:
		lda #129
		sta VIC_D012
		lda #<IRQ_Split6
		sta $fffe
		lda #>IRQ_Split6
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split6() -------------------------------------------------------------------------------------------------------

IRQ_Split6:

		IRQManager_BeginIRQ(1, -11)

		.for (var i = 0; i < 13; i++)
		{
			nop
		}

		lda #D018Value2
		sta VIC_D018

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

	SetD012_6:
		lda #138
		sta VIC_D012
		lda #<IRQ_Split7
		sta $fffe
		lda #>IRQ_Split7
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split7() -------------------------------------------------------------------------------------------------------

IRQ_Split7:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_7:
		lda #145
		sta VIC_D012
		lda #<IRQ_Split8
		sta $fffe
		lda #>IRQ_Split8
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split8() -------------------------------------------------------------------------------------------------------

IRQ_Split8:

		IRQManager_BeginIRQ(1, -11)

		.for (var i = 0; i < 13; i++)
		{
			nop
		}

		lda #D018Value3
		sta VIC_D018

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

	SetD012_8:
		lda #154
		sta VIC_D012
		lda #<IRQ_Split9
		sta $fffe
		lda #>IRQ_Split9
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split9() -------------------------------------------------------------------------------------------------------

IRQ_Split9:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_9:
		lda #161
		sta VIC_D012
		lda #<IRQ_Split10
		sta $fffe
		lda #>IRQ_Split10
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split10() -------------------------------------------------------------------------------------------------------

IRQ_Split10:

		IRQManager_BeginIRQ(1, -11)

		.for (var i = 0; i < 13; i++)
		{
			nop
		}

		lda #D018Value4
		sta VIC_D018

	SetD012_10:
		lda #170
		sta VIC_D012
		lda #<IRQ_Split11
		sta $fffe
		lda #>IRQ_Split11
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split11() -------------------------------------------------------------------------------------------------------

IRQ_Split11:

		IRQManager_BeginIRQ(0, 0)

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

		lda VIC_Sprite0Y
		clc
		adc #21
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

	SetD012_11:
		lda #186
		sta VIC_D012
		lda #<IRQ_Split12
		sta $fffe
		lda #>IRQ_Split12
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_Split12() -------------------------------------------------------------------------------------------------------

IRQ_Split12:

		//; IRQManager_BeginIRQ(1, 0)

		dec	0
		pha
		nop
		lda	#29
		sec
		sbc	$dd06
		sta	* + 4
		bpl	* + 2
		lda	#$a9				//; two extra lda #$a9 here
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5

		nop						//; X and Y are not used here, replaced them with NOPs for the same timing
		nop
		nop

		.for (var i = 0; i < 8; i++)
		{
			inc SpriteVals + i
		}

	SetD012_12:
		lda #186
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		asl $d019
		pla
		inc $00

		//; IRQManager_EndIRQ()
		rti


//; ScrollScroller() -------------------------------------------------------------------------------------------------------

ScrollScroller:
		ldx ZP_ScrollText
		.for (var i = 0; i < NUM_CHARS - 1; i++)
		{
			lda ZP_ScrollText + i + 1
			sta ZP_ScrollText + i
		}
		stx ZP_ScrollText + NUM_CHARS - 1

		lda FrameCounterLo
		and #1
		bne DontAddNewChar

	ScrollTextPtr:
		lda ADDR_ScrollText
		bpl WriteNewChar

		lda #<ADDR_ScrollText
		sta ScrollTextPtr + 1
		lda #>ADDR_ScrollText
		sta ScrollTextPtr + 2
		lda ADDR_ScrollText

		:BranchIfNotFullDemo(WriteNewChar)

		inc PART_Done
		jmp DontAddNewChar

	WriteNewChar:
		ldx #NUM_CHARS - 2
		sta ZP_ScrollText, x

		dex
		bpl NotNeg
		ldx #39
	NotNeg:
		stx WriteNewChar + 1

	DontUpdateWritePtr:
		inc ScrollTextPtr + 1
		bne ScrollTextPtrNot256
		inc ScrollTextPtr + 2
	ScrollTextPtrNot256:

	DontAddNewChar:

		rts


//; UpdateSprites_Row0() -------------------------------------------------------------------------------------------------------

UpdateSprites_Row0:
		
	SetSpriteY_Row0:
		lda #50 + (21 * 0)
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}

		ldx ModdedFrame
		lda Sprite0_ScrollVals, x
		sta VIC_Sprite0X
		lda Sprite1_ScrollVals, x
		sta VIC_Sprite1X
		lda Sprite2_ScrollVals, x
		sta VIC_Sprite2X
		lda Sprite3_ScrollVals, x
		sta VIC_Sprite3X
		lda Sprite4_ScrollVals, x
		sta VIC_Sprite4X
		lda Sprite5_ScrollVals, x
		sta VIC_Sprite5X
		lda Sprite6_ScrollVals, x
		sta VIC_Sprite6X
		lda Sprite7_ScrollVals, x
		sta VIC_Sprite7X
		lda SpriteXMSB, x
		sta VIC_SpriteXMSB

		lda Sprite0_SpriteVals, x
		sta SpriteVals + 0
		lda Sprite1_SpriteVals, x
		sta SpriteVals + 1
		lda Sprite2_SpriteVals, x
		sta SpriteVals + 2
		lda Sprite3_SpriteVals, x
		sta SpriteVals + 3
		lda Sprite4_SpriteVals, x
		sta SpriteVals + 4
		lda Sprite5_SpriteVals, x
		sta SpriteVals + 5
		lda Sprite6_SpriteVals, x
		sta SpriteVals + 6
		lda Sprite7_SpriteVals, x
		sta SpriteVals + 7

		rts


//; Virtual Memory Reservation -------------------------------------------------------------------------------------------------------

* = ZPADDR_ScrollText "ZP Scrolltext" virtual
	.zp
	{
		ZP_ScrollText: .fill NUM_CHARS, 0
	}
* = ADDR_Frame0_Charset "Frame0 Charset" virtual
	.fill $800, 0
* = ADDR_Frame1_Charset "Frame1 Charset" virtual
	.fill $800, 0
* = ADDR_Frame2_Charset "Frame2 Charset" virtual
	.fill $800, 0
* = ADDR_Frame3_Charset "Frame3 Charset" virtual
	.fill $800, 0
* = ADDR_Frame4_Charset "Frame4 Charset" virtual
	.fill $800, 0
* = ADDR_Screen "Screen" virtual
	.fill $400, 0
* = ADDR_ScrollText "ScrollText" virtual
	.fill $800, 0

