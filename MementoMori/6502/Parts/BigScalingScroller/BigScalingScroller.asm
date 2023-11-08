//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= BigScalingScroller_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp BigScalingScroller_Init					//; Init
		.byte $00, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $2000-c3ff Code
//; - $c400-c7ff Scrolltext
//; - $c800-cbff Screen0
//; - $cc00-cfff Screen1
//; - $dfd0-dfff Star Chars
//; - $f000-fbff Star Anim Data
//; - $fc00-ff5f SpriteXVals

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank0 = 15 //; Bank+[3c00,3fff]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))

	.var D011_Value_24Rows = $13
	.var D011_Value_25Rows = $1b

	.var D016_Value_38Rows = $07
	.var D016_Value_40Rows = $08

	.var PackedScrollData = $8000
	.var ScrollText = $2e00

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

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
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte $00									//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
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

NextXValue:
	.fill 39, (i + 1)
	.byte 0

	.var Col0 = 2
	.var Col1 = 10
	.var Col2 = 7
	.var Col3 = 1
	.var Col4 = 3
	.var Col5 = 14
	.var Col6 = 4

ScreenColours:
	.byte Col0, Col0
	.byte Col1, Col0, Col1, Col1
	.byte Col2, Col1, Col2, Col2
	.byte Col3, Col3, Col3, Col3
	.byte Col4, Col4, Col5, Col4
	.byte Col5, Col5, Col6, Col5
	.byte Col6, Col6, Col6

.import source "../../../Out/6502/Parts/BigScalingScroller/DrawScroller.asm"

//; BigScalingScroller_Init() -------------------------------------------------------------------------------------------------------
BigScalingScroller_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #$00
	FillScreenLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta ScreenAddress0 + (Page * 256), y
		}
		iny
		bne FillScreenLoop

		ldx #$00
	FillColourLoopOuter:
		ldy #39
	FillColourLoop:
		lda ScreenColours, x
	ColMemPtr:
		sta VIC_ColourMemory, y
		dey
		bpl FillColourLoop
		clc
		lda ColMemPtr + 1
		adc #40
		sta ColMemPtr + 1
		lda ColMemPtr + 2
		adc #0
		sta ColMemPtr + 2
		inx
		cpx #25
		bne FillColourLoopOuter

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #$fa
		sta VIC_D012
		lda #<MainIRQ
		sta $fffe
		lda #>MainIRQ
		sta $ffff
		asl VIC_D019

		cli

		rts

UpdateScroll:
		ldy #38
	ScrollTextPtr:
		lda ScrollText
		bpl NotTheEnd
		inc Signal_CurrentEffectIsFinished
		lda #<ScrollText
		sta ScrollTextPtr + 1
		lda #>ScrollText
		sta ScrollTextPtr + 2

		lda ScrollText
	NotTheEnd:
		ldx ScrollerIndexPtrsLo, y
		stx ScrollerOutAddr + 1
		ldx ScrollerIndexPtrsHi, y
		stx ScrollerOutAddr + 2
	ScrollerOutAddr:
		sta $abcd

		dey
		bpl NotA40
		ldy #39
	NotA40:
		sty UpdateScroll + 1

		inc ScrollTextPtr + 1
		bne Not256
		inc ScrollTextPtr + 2
	Not256:

		rts

MainIRQ:
		:IRQManager_BeginIRQ(0, 0)

		lda #(ScreenBank0 * 16) + (0 * 2)
		sta VIC_D018

	ScrollPos:
		lda #$00
		eor #$04
		sta ScrollPos + 1
		eor #$07
		sta VIC_D016

		jsr BASECODE_PlayMusic

		lda ScrollPos + 1
		beq DontScroll

		lda DrawScroller + 1
		clc
		adc #$01
		cmp #40
		bne NoScrollWrap
		lda #00
	NoScrollWrap:
		sta DrawScroller + 1

		jsr UpdateScroll

	DontScroll:
		jsr DrawScroller

		lda #IRQSplit1
		sta VIC_D012
		lda #$1b
		sta VIC_D011
		lda #<MainIRQ_Split1
		sta $fffe
		lda #>MainIRQ_Split1
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split1:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (1 * 2)
		sta VIC_D018
		
		lda #IRQSplit2
		sta VIC_D012
		lda #<MainIRQ_Split2
		sta $fffe
		lda #>MainIRQ_Split2
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split2:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (2 * 2)
		sta VIC_D018
		
		lda #IRQSplit3
		sta VIC_D012
		lda #<MainIRQ_Split3
		sta $fffe
		lda #>MainIRQ_Split3
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split3:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (3 * 2)
		sta VIC_D018
		
		lda #IRQSplit4
		sta VIC_D012
		lda #<MainIRQ_Split4
		sta $fffe
		lda #>MainIRQ_Split4
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split4:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (4 * 2)
		sta VIC_D018
		
		lda #IRQSplit5
		sta VIC_D012
		lda #<MainIRQ_Split5
		sta $fffe
		lda #>MainIRQ_Split5
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split5:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (5 * 2)
		sta VIC_D018
		
		lda #IRQSplit6
		sta VIC_D012
		lda #<MainIRQ_Split6
		sta $fffe
		lda #>MainIRQ_Split6
		sta $ffff

		:IRQManager_EndIRQ()
		rti

MainIRQ_Split6:
		:IRQManager_BeginIRQ(1, 0)

		lda #(ScreenBank0 * 16) + (6 * 2)
		sta VIC_D018
		
		lda #$fa
		sta VIC_D012
		lda #<MainIRQ
		sta $fffe
		lda #>MainIRQ
		sta $ffff

		:IRQManager_EndIRQ()
		rti


