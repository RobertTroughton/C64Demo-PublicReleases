//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"
.import source "GreetingScroller-CommonDefines.asm"
.import source "../../../Out/6502/Parts/GreetingScroller/DrawShape.sym"

*= GreetingScroller_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		jmp GreetingScroller_EaseIn
		jmp GreetingScroller_EaseOut
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $2000-b3ff Code+Data
//; - $b800-bfff Sprite Mask Data
//; - $c000-c7ff Scrolltext
//; - $cc00-cfe7 Screen
//; - $dc00-dd3f Star sprites
//; - $e000-ff7f Bitmap

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $18									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $48									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $78									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $a8									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $d8									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $08									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $38									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00e: VIC_Sprite8X
	.byte $60									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Columns					//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
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
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

SpriteColourTable:
		.byte $09, $05, $0d, $01
		.fill 24, $01
		.byte $07, $0a, $08, $02

FrameOf256:										.byte $00
Frame_256Counter:								.byte $00

bShouldDrawTreeTopper:							.byte $00
bIsDrawShapeLoaded:								.byte $00
bFinishedEaseIn:								.byte $00
bFinishedEaseOut:								.byte $00
bSignalStartEaseOut:							.byte $00
EaseMode:										.byte $00

//; GreetingScroller_EaseIn() -------------------------------------------------------------------------------------------------------
GreetingScroller_EaseIn:

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		MACRO_SetVICBank(BaseBank)

		ldy #$3e
		lda #$ff
	FillSpriteDataLoop:
		sta $ff80, y
		dey
		bpl FillSpriteDataLoop

		lda #$4c
		sta ZP_IRQJump + 0

		lda #$00
		sta EaseMode

		vsync()

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		lda #$00
		sta VIC_D011
		lda #<ZP_IRQJump
		sta $fffe
		lda #$00
		sta $ffff
		jsr StartEaseIRQ
		asl VIC_D019

		cli

		lda #$0c
		sta VIC_BorderColour

		rts

GreetingScroller_EaseOut:

		stx MusicFadeAddress + 1
		sty MusicFadeAddress + 2

		ldy #$3e
		lda #$00
	ClearLastSprite:
		sta $ff80, y
		dey
		bpl ClearLastSprite

	WaitForPulseDelayToFinish:
		lda DelayForPulse + 1
		beq WaitForPulseDelayToFinish

		lda #5
		sta TreeTopperFadeIndex + 1
		lda #$00
		sta bShouldDrawTreeTopper
		lda #LDA_ABS
		sta Hack1					//; Ugly nasty hack..
		inc bSignalStartEaseOut

		lda bSignalStartEaseOut
		bne * - 3

		lda #$01
		sta EaseMode

		sei
		jsr StartEaseIRQ
		asl VIC_D019
		cli
		rts

SpriteYVals:		.byte 42, 84, 126, 168, 210, 252, 0
D012Vals:			.byte 0, 43, 85, 127, 169, 211, 249

IRQ_EaseInOut:

		:IRQManager_BeginIRQ(1, -9)

	SpriteRow:
		ldy #$00
		bne NotFirst
		lda #$0b
		sta VIC_ScreenColour
	NotFirst:

		cpy #1
		bne NotPriorToScreen

		lda #50
	WaitForScreenLine:
		cmp VIC_D012
		bne WaitForScreenLine

		ldx #6
	DelayLoopForD011:
		dex
		bne DelayLoopForD011
		nop
		nop
		nop
	D011WriteValA:
		lda #$3b
		sta VIC_D011

		lda EaseMode
		bne DontFinishEaseIRQ

	DoEaseIn:
		lda bFinishedEaseIn
		beq DontFinishEaseIRQ
		lda PartDone
		beq DontFinishEaseIRQ
		lda #$00
		sta PartDone

		lda #$00
		sta VIC_SpriteEnable
		inc bIsDrawShapeLoaded
		lda #<IRQ_Main
		sta ZP_IRQJump + 1
		lda #>IRQ_Main
		sta ZP_IRQJump + 2
		lda #249
		jmp FinishedIRQ
	DontFinishEaseIRQ:

	NotPriorToScreen:

		cpy #6
		bne NotFinal

		lda #$08
		sta VIC_ScreenColour

		nop
		nop
		nop
		nop

	D011WriteValB:
		lda #$13
		sta VIC_D011

		lda #250
	WaitFor250:
		cmp VIC_D012
		bcc WaitFor250

	NotFinal:
		lda SpriteYVals, y
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Y + (i * 2)
		}
		iny
		sty SpriteRow + 1

		cpy #1
		bne NotPlayMusic

		jsr BASE_PlayMusic
		jmp NotFinishedAllRows
	NotPlayMusic:

		cpy #7
		bne NotFinishedAllRows

	WaitForBlank:
		lda VIC_D011
		bpl WaitForBlank

		lda EaseMode
		beq DoEaseInStuff

	DoEaseOutStuff:
		lda #$00
		bne FinishedEaseOutTree
		jsr EaseOutTreeScroller
		sta DoEaseOutStuff + 1
		jmp FinishedThisEaseStuff
	FinishedEaseOutTree:

		lda bFinishedEaseOut
		bne SkipMasking
		jsr DeMaskSpritesOut
	SkipMasking:
		lda bFinishedEaseOut
		beq FinishedThisEaseStuff
		cmp #2
		bne WaitALittleLonger
		inc PartDone
	WaitALittleLonger:
		lda #$02
		sta bFinishedEaseOut
		lda #$00
		sta $d051
		sta D011WriteValA + 1
		sta D011WriteValB + 1
		jmp FinishedThisEaseStuff

	DoEaseInStuff:
		lda #$1b
		sta VIC_D011
		jsr DeMaskSpritesIn

	FinishedThisEaseStuff:

		ldy #$00
		sty SpriteRow + 1
	
	NotFinishedAllRows:
		ldy SpriteRow + 1
		lda D012Vals, y

	FinishedIRQ:
		sta VIC_D012

		:IRQManager_EndIRQ()
		rti


IRQ_TopScreen:

		pha
		txa
		pha
		tya
		pha

		lda #$00
		sta VIC_SpriteEnable

		.for (var Delay = 0; Delay < 1; Delay++)
		{
			nop
		}
		lda #249
		sta VIC_D012
		lda #<IRQ_Main
		sta ZP_IRQJump + 1
		lda #>IRQ_Main
		sta ZP_IRQJump + 2
		lda #D011_Value_25Rows
		sta VIC_D011
		asl VIC_D019

		pla
		tay
		pla
		tax
		pla

		rti

IRQ_TopBorder:
		pha
		txa
		pha
		tya
		pha

		lda #$0b
		sta VIC_ScreenColour

		jsr SetTreeTopperSprites

		lda #D011_Value_25Rows_Text
		sta VIC_D011

		lda #50
		sta VIC_D012
		lda #<IRQ_TopScreen
		sta ZP_IRQJump + 1
		lda #>IRQ_TopScreen
		sta ZP_IRQJump + 2

		asl VIC_D019

		pla
		tay
		pla
		tax
		pla

		rti

IRQ_Main:
		:IRQManager_BeginIRQ(1, 0)

		lda #$08
		sta VIC_ScreenColour

		lda	#<IRQ_TopBorder
		sta	ZP_IRQJump + 1
		lda	#>IRQ_TopBorder
		sta	ZP_IRQJump + 2
		lda	#$00
		sta	VIC_D012

		ldx #8
	D011DelayLoop:
		dex
		bne D011DelayLoop

		lda #D011_Value_24Rows_Text
		sta VIC_D011
		asl VIC_D019
		cli
		
		jsr BASE_PlayMusic

		lda bSignalStartEaseOut
		beq NoEaseOutSignal

		lda FrameOf256
		and #$07
		bne SkipIndexUpdate
		dec TreeTopperFadeIndex + 1

	SkipIndexUpdate:
		lda TreeTopperFadeIndex + 1
		bpl NoEaseOutSignal

		lda #$00
		sta TreeTopperFadeIndex + 1
		sta bSignalStartEaseOut
		sta bIsDrawShapeLoaded
	NoEaseOutSignal:

		lda bIsDrawShapeLoaded
		bne DoDrawShapeCode
		jmp SkipDrawShapeCode
	DoDrawShapeCode:

	TurnDiskJSR:
		lda DoTurnDiskPulse

		lda #D011_Value_25Rows_Text
		sta VIC_D011

	FrameCounter:
		lda #$00
		cmp #$02
		beq DoFrame0
		cmp #$01
		beq DoFrame1

		jsr DrawShape_Frame2
		jmp FinishedDrawShape

	DoFrame1:
		jsr DrawShape_Frame1
		jmp FinishedDrawShape

	DoFrame0:
		jsr DrawShape_Frame0

	ScrollTextRead:
		lda ScrollText
		bpl AllGood
		lda #<ScrollText
		sta ScrollTextRead + 1
		lda #>ScrollText
		sta ScrollTextRead + 2
		lda #$00
	AllGood:
		sta FinalChar

		lda Char000_Frame0 + 1
		beq Char0NotSet
	Hack1:
		sta bShouldDrawTreeTopper
		lda #JSR_ABS
		sta TurnDiskJSR + 0
	Char0NotSet:

		inc ScrollTextRead + 1
		bne FinishedDrawShape
		inc ScrollTextRead + 2
	FinishedDrawShape:

		ldx FrameCounter + 1
		inx
		cpx #3
		bne NotFinalFrame
		ldx #0
	NotFinalFrame:
		stx FrameCounter + 1

	SkipDrawShapeCode:

		inc FrameOf256
		bne NotFrame256
		inc Frame_256Counter
	NotFrame256:

		:IRQManager_EndIRQ()
		rti

TreeTopperColours_01:
		.byte $0b, $0c, $0f, $01, $0f, $0c
TreeTopperColours_2345:
		.byte $0b, $0c, $0f, $01, $07, $07
TreeTopperColours_MC0:
		.byte $0b, $0c, $0f, $01, $0f, $0f
TreeTopperColours_MC1:
		.byte $0b, $0c, $0f, $01, $01, $01

SetTreeTopperSprites:

		lda #$18
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		sta VIC_Sprite0Y
		clc
		adc #$15
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite1Y

		lda #$a2
		sta VIC_Sprite2X
		sta VIC_Sprite4X
		sta VIC_Sprite0X
		sta VIC_Sprite1X
		clc
		adc #$18
		sta VIC_Sprite3X
		sta VIC_Sprite5X

		lda #$00
		sta VIC_SpriteXMSB

		lda bShouldDrawTreeTopper
		bne YesDrawTreeTopper

	TreeTopperFadeIndex:
		ldy #$00
		jmp SkipUpdateIndex

	YesDrawTreeTopper:
		ldy #$00
		lda FrameOf256
		and #$03
		bne Not6

		iny
		cpy #6
		bne Not6
		ldy #5
	Not6:
		sty YesDrawTreeTopper + 1
	SkipUpdateIndex:

		lda TreeTopperColours_01, y
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		lda TreeTopperColours_2345, y
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		lda TreeTopperColours_MC0, y
		sta VIC_SpriteExtraColour0
		lda TreeTopperColours_MC1, y
		sta VIC_SpriteExtraColour1

		lda #$03
		sta VIC_SpriteDoubleWidth
		lda #$00
		sta VIC_SpriteDoubleHeight

		ldx #TreeTopper_SpriteIndex_Black
		stx SpriteVals + 2
		inx
		stx SpriteVals + 3
		inx
		stx SpriteVals + 4
		inx
		stx SpriteVals + 5

		ldx #TreeTopper_SpriteIndex_White
		stx SpriteVals + 0
		inx
		stx SpriteVals + 1

		lda #$3c
		sta VIC_SpriteMulticolourMode

		lda #$3f
		sta VIC_SpriteEnable

		rts

TurnDiskColours:
					.fill 29, $bb
					.byte $b2, $b8, $b7
					.fill 32, $b1
					.byte $b3, $be, $b6
					.fill 29, $bb

DoTurnDiskPulse:

	DelayForPulse:
		ldx #$3f
		beq DoTheActualPulse
		dex
		stx DelayForPulse + 1
		rts

	DoTheActualPulse:
		ldy #$00
		lda TurnDiskColours, y

	WhichTurnDisk:
		ldx #$00
		.for (var XPos = 0; XPos < 12; XPos++)
		{
			.if (XPos != 0)
				lda TurnDiskColours + XPos, y
			.for (var YPos = 0; YPos < 6; YPos++)
			{
				.var VirtX = XPos - YPos;
				.if ((VirtX >= 0) && (VirtX < 7))
				{
					sta ScreenAddress + (5 + VirtX) + (4 + YPos) * 40, x
				}
			}
		}

		inc DoTheActualPulse + 1
		lda DoTheActualPulse + 1
		cmp #96 - 12
		bne NotFinishedColourPulse

		lda #$bf
		sta DelayForPulse + 1
		lda #$00
		sta DoTheActualPulse + 1
		lda WhichTurnDisk + 1
		eor #24
		sta WhichTurnDisk + 1

	NotFinishedColourPulse:
		rts


DeMaskSpritesIn:
		ldy #$00

		ldx $b800, y
		bpl NotFinishedEaseIn
		sta bFinishedEaseIn
		rts
	NotFinishedEaseIn:
		lda $b900, y
		sta $ff80, x

		ldx $ba00, y
		lda $bb00, y
		sta $ff80, x

		iny
		sty DeMaskSpritesIn + 1

		tya
		and #$01
		beq DoMaskSpriteScroll
		rts

DeMaskSpritesOut:
		ldy #$00

		ldx $bc00, y
		bpl NotFinishedEaseOut
		inc bFinishedEaseOut
		rts
	NotFinishedEaseOut:
		lda $bd00, y
		sta $ff80, x

		ldx $be00, y
		lda $bf00, y
		sta $ff80, x

		iny

		ldx $bc00, y
		bpl NotFinishedEaseOut2
		inc bFinishedEaseOut
		rts
	NotFinishedEaseOut2:
		lda $bd00, y
		sta $ff80, x

		ldx $be00, y
		lda $bf00, y
		sta $ff80, x

		iny
		sty DeMaskSpritesOut + 1

		tya
		lsr
		lsr
		lsr
		lsr
		eor #$0f
	MusicFadeAddress:
		sta $107f	//; music volume fade

		tya
		and #$02
		beq DoMaskSpriteScroll
		rts

DoMaskSpriteScroll:
		.for (var XVal = 0; XVal < 3; XVal++)
		{
			ldx $ff80 + 60 + XVal
			.for (var YVal = 19; YVal >= 0; YVal--)
			{
				lda $ff80 + (YVal * 3) + XVal
				sta $ff80 + (YVal * 3) + XVal + 3
			}
			stx $ff80 + XVal
		}
		rts
		
StartEaseIRQ:

		lda #$00
		sta SpriteRow + 1

		ldy #$10
	SetInitialD000ValsLoop:
		lda INITIAL_D000Values, y
		sta $d280, y
		dey
		bpl SetInitialD000ValsLoop

		lda #$7f
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		lda #$00
		sta VIC_SpriteMulticolourMode

		lda #$0c
		.for (var i = 0; i < 7; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		ldy #$07
		lda #$fe
	SetSpriteValsLoop:
		sta SpriteVals, y
		dey
		bpl SetSpriteValsLoop

		lda #<IRQ_EaseInOut
		sta ZP_IRQJump + 1
		lda #>IRQ_EaseInOut
		sta ZP_IRQJump + 2

		lda #$00
		sta VIC_D012

		rts

EaseOutTreeScroller:

		ldy #$08
		.for (var i = 0; i < 25; i++)
		{
			lda ScreenAddress + (i * 40), y
			and #$0f
			.if (i < 21)
			{
				ora #$b0
			}
			.if (i == 21)
			{
				ora #$90
			}
			.if (i > 21)
			{
				ora #$80
			}
			
			sta ScreenAddress + (i * 40), y
		}
		lda #$00
		iny
		cpy #$20
		bne NotFinished
		lda #$01
	NotFinished:
		sty EaseOutTreeScroller + 1
		rts