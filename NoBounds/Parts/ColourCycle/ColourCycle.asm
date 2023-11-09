//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $3600 "ColourCycleBase"

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
//; - $2000-34ff Code 0B
//; - $3e00-3fff SinTable
//; - $4000-43e7 Screen 0
//; - $4400-45ff Sprite Data 0
//; - $4b00-5fff Code 0A
//; - $6000-7f3f Bitmap 0
//; - $8000-83e7 Screen 1
//; - $8400-85ff Sprite Data 1
//; - $8b00-9fff Code 1A
//; - $a000-bf3f Bitmap 1
//; - $c000-df3f Bitmap 2
//; - $e000-e3e7 Screen 2
//; - $e400-e5ff Sprite Data 2
//; - $ea00-feff Code 2A

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank2 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var DD02Value2 = 60 + BaseBank2
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var Base_BankAddress2 = (BaseBank2 * $4000)
	.var ScreenBank0 =  0 //; Bank+[0000,03ff]
	.var ScreenBank1 =  0 //; Bank+[0000,03ff]
	.var ScreenBank2 =  8 //; Bank+[2000,23ff]
	.var ScreenAddress0 = Base_BankAddress0 + ScreenBank0 * $400
	.var ScreenAddress1 = Base_BankAddress1 + ScreenBank1 * $400
	.var ScreenAddress2 = Base_BankAddress2 + ScreenBank2 * $400
	.var BitmapBank0 = 1 //; Bank+[2000,3f3f]
	.var BitmapBank1 = 1 //; Bank+[2000,3f3f]
	.var BitmapBank2 = 0 //; Bank+[0000,1f3f]
	.var BitmapAddress0 = Base_BankAddress0 + BitmapBank0 * $2000
	.var BitmapAddress1 = Base_BankAddress1 + BitmapBank1 * $2000
	.var BitmapAddress2 = Base_BankAddress2 + BitmapBank2 * $2000
	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank0 * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank1 * 8)
	.var D018Value2 = (ScreenBank2 * 16) + (BitmapBank2 * 8)

	.var D016_Value_40Cols = $18

	.label ADDR_CCCodeB			= $2000
	.label ADDR_CCFrame0Code	= $4b00
	.label ADDR_CCFrame1Code	= $8b00
	.label ADDR_CCFrame2Code	= $ea00
	
	.var MaxSize_CCGenCode	= $1800

	.var ADDR_SinTables = $3e00
	.var ADDR_SpriteSinTable_X = $3d80
	.var ADDR_SpriteSinTable_Y = $3dc0

	.var ZPADDR_ColourTable = $40

	.var ZP_TardisSinePos	= $0f

	.var ZP_FrameCounterLo	= $08
	.var ZP_FrameCounterHi	= ZP_FrameCounterLo + 1

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

EaseMode:								.byte $01

.align 16
Mul16Table:								.fill 16, i * 16

ColourTable:							.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06
										.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06
										.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06
										.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06
										.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06
										.byte $0b, $09, $02, $04, $0c, $03, $0d, $01, $0f, $05, $08, $02, $09, $0b, $06, $02, $0a, $0f, $07, $01, $03, $0e, $04, $06

//; ColourCycle_Go() -------------------------------------------------------------------------------------------------------
ColourCycle_Go:

		ldy #$00
		lda #(BackgroundColour + BackgroundColour * 16)
	FillScreenColoursLoop:
		.for (var i = 0; i < 4; i++)
		{
			sta VIC_ColourMemory + (i * 256), y
		}
		iny
		bne FillScreenColoursLoop

	//; copy sprite data
		ldy #$00
	CopySpriteDataLoop:
		lda $4400, y
		sta $8400, y
		sta $e400, y
		lda $4500, y
		sta $8500, y
		sta $e500, y
		iny
		bne CopySpriteDataLoop

		ldy #33
		lda #BackgroundColour
	ClearZPColoursLoop:
		sta ZP_Colours, y
		dey
		bpl ClearZPColoursLoop

		ldx #$10
		ldy #$90
		.for (var i = 0; i < 8; i++)
		{
			stx ScreenAddress1 + $3f8 + i
			sty ScreenAddress2 + $3f8 + i
			.if (i != 7)
			{
				inx
				iny
			}
		}

		vsync()

		sei

		lda #38
		sta VIC_D012
		lda #<IRQ_SetBorderColour1
		sta $fffe
		lda #>IRQ_SetBorderColour1
		sta $ffff

		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #$00
		sta VIC_Sprite1Colour
		sta VIC_Sprite3Colour

		lda #$ff
		sta VIC_SpriteMulticolourMode

		jmp SetSpritePositions

D018Values:				.byte D018Value0, D018Value1, D018Value2
DD02Values:				.byte DD02Value0, DD02Value1, DD02Value2

ColourCycleJumpsLo:		.byte <(ADDR_CCFrame0Code - 1), <(ADDR_CCFrame1Code - 1), <(ADDR_CCFrame2Code - 1)
ColourCycleJumpsHi:		.byte >(ADDR_CCFrame0Code - 1), >(ADDR_CCFrame1Code - 1), >(ADDR_CCFrame2Code - 1)

NextFrame:				.byte 2, 1, 0

IRQ_SetBorderColour0:

		IRQManager_BeginIRQ(1, 0)

		lda #$01
		sta VIC_BorderColour
		ldy #$09
	!Delay:
		dey
		bpl !Delay-
		nop
		nop
		nop
		lda #$00
		sta VIC_BorderColour

		jsr BASE_PlayMusic

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #38
		sta VIC_D012
		lda #<IRQ_SetBorderColour1
		sta $fffe
		lda #>IRQ_SetBorderColour1
		sta $ffff

		IRQManager_EndIRQ()
		rti

IRQ_SetBorderColour1:

		IRQManager_BeginIRQ(1, 0)

		lda #$01
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

	bFirst:
		lda #$01
		beq NotFirstFrame
		dec bFirst + 1

		jmp SkipFirstFrame
	NotFirstFrame:

		lda #D016_Value_40Cols
		sta VIC_D016

		ldy FrameC + 1
		lda D018Values, y
		sta VIC_D018
		lda DD02Values, y
		sta VIC_DD02

		lda #$3b
		sta VIC_D011

	SkipFirstFrame:

		lda #248
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti

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

		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #$06
		sta VIC_D012
		lda #<IRQ_SetBorderColour0
		sta $fffe
		lda #>IRQ_SetBorderColour0
		sta $ffff
		asl VIC_D019
		cli

		lda PART_Done
		beq FrameC
		jmp FrameNot256
	FrameC:
		ldy #$00
		lda ColourCycleJumpsHi, y
		pha
		lda ColourCycleJumpsLo, y
		pha
		rts

	ReturnFromCCCode:

	DoEaseIn:
		lda EaseMode
		beq NoEasing
		cmp #1
		bne DoEaseOut
		jsr EaseIn
		jmp NoEasing
	DoEaseOut:
		jsr EaseOut
	NoEasing:

		jsr SetSpritePositions

		ldx ZP_FrameCounterLo
		lda ADDR_SinTables + (1 * 256), x
		sta FrameC + 1
		ldy ADDR_SinTables + (0 * 256), x

	ColourTableUpdates:
		.for (var i = 0; i < 34; i++)
		{
			lda ColourTable + i, y
			lda ZP_Colours + i
		}

		inc ZP_FrameCounterLo
		bne FrameNot256
		inc ZP_FrameCounterHi
		lda ZP_FrameCounterHi
		cmp #2
		bne FrameNot256
//;		:BranchIfNotFullDemo(FrameNot256)
		lda #2
		sta EaseMode
	FrameNot256:

		pla
		sta $01
		pla
		tay
		pla
		tax
		pla
		rti



Mul5:
		.fill 34, 5 * i

EaseIn:
		ldx #$00
		ldy Mul5, x

		lda #$85
		sta ColourTableUpdates + 3, y

		inx
		cpx #34
		bne NotFinishedEaseIn

		lda #$00
		sta EaseMode
		rts

	NotFinishedEaseIn:
		stx EaseIn + 1
		rts

EaseOut:
		ldx #$00
		ldy Mul5, x

		lda #$a5
		sta ColourTableUpdates + 3, y
		lda #BackgroundColour
		sta ZP_Colours, x

		inx
		cpx #34
		bne NotFinishedEaseOut

		lda #$00
		sta EaseMode
		inc PART_Done
		rts

	NotFinishedEaseOut:
		stx EaseOut + 1
		rts

CombineDataSets:
		sta DataA + 2
		lda #>ADDR_CCCodeB
		sta DataB1 + 2
		sta DataB2 + 2
		lda #$15
		sta $02
		lax #$00				//; A = rolling sum
	DataLoop:
	DataB1:
		ldy ADDR_CCCodeB,x
		beq NextDataB
		clc
	DataB2:
		adc ADDR_CCCodeB,x
	DataA:
		sta ADDR_CCFrame0Code,x
	NextDataB:
		inx
		bne DataLoop
		inc DataB1 + 2
		inc DataB2 + 2
		inc DataA + 2
		dec $02
		bne DataLoop
		rts

SetSpritePositions:

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

		rts

* = ZPADDR_ColourTable "ZP Colourtable" virtual
	.zp
	{
		ZP_Colours: .fill 47, 0
	}
* = ADDR_SinTables "SinTables" virtual
	.fill 512, 0
* = BitmapAddress0 "Frame0 Bitmap" virtual
	.fill 8000, 0
* = BitmapAddress1 "Frame1 Bitmap" virtual
	.fill 8000, 0
* = BitmapAddress2 "Frame2 Bitmap" virtual
	.fill 8000, 0
* = ScreenAddress0 "Frame0 Screen" virtual
	.fill 1000, 0
* = ScreenAddress1 "Frame1 Screen" virtual
	.fill 1000, 0
* = ScreenAddress2 "Frame2 Screen" virtual
	.fill 1000, 0
* = ADDR_CCFrame0Code "Frame0 Code" virtual
	.fill MaxSize_CCGenCode, 0
* = ADDR_CCFrame1Code "Frame1 Code" virtual
	.fill MaxSize_CCGenCode, 0
* = ADDR_CCFrame2Code "Frame2 Code" virtual
	.fill MaxSize_CCGenCode, 0
