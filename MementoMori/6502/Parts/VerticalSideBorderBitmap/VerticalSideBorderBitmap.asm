//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= VerticalSideBorderBitmap_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp VSBB_Init								//; Init
		.byte $00, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; ---- $0400-07ff ........................ <--- LOOK AT THIS .. 1k .. but has some demo-driver and common functions etc right now...
//; - $0800-1fff Music
//; - $2000-7fff Code
//; ---- $8000-8aff Sprite Data 0
//; ---- $8b00-8bff ........................ <--- LOOK AT THIS .. 256 bytes .. lookups for our D800 data change..?
//; ---- $8c00-8fff Screen 0
//; - $9000-9dff Bitmap Data Buffer 0
//; - $9f00-9fff Nibble Conversion Table (Val = (Val >> 4))
//; ---- $a000-bf7f Bitmap 0
//; ---- $c000-caff Sprite Data 1
//; ---- $cb00-cbff ........................ <--- LOOK AT THIS .. 256 bytes
//; ---- $cc00-cfff Screen 1
//; - $d000-ddff Bitmap Data Buffer 1
//; ---- $e000-ff7f Bitmap 1
//;                                                 ALSO... we have the init function sat right below $7f80-7fff ... we don't need this once the demo has started..!

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 3 //; Bank+[0c00,0fff]

	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1

	.var BankAddress0 = (BaseBank0 * $4000)
	.var BankAddress1 = (BaseBank1 * $4000)
	.var BitmapAddress0 = (BankAddress0 + (BitmapBank * 8192))
	.var BitmapAddress1 = (BankAddress1 + (BitmapBank * 8192))
	.var ScreenAddress0 = (BankAddress0 + (ScreenBank * 1024))
	.var ScreenAddress1 = (BankAddress1 + (ScreenBank * 1024))
	.var SpriteVals0 = ScreenAddress0 + $3f8
	.var SpriteVals1 = ScreenAddress1 + $3f8
	.var SpriteDataAddress0 = BankAddress0 + (0 * 64)
	.var SpriteDataAddress1 = BankAddress1 + (0 * 64)
	.var NumSpritesUsed = 40

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D011_Value_24Rows = $30
	.var D011_Value_25Rows = $38

	.var D016_Value_38Rows_MC = $10
	.var D016_Value_40Rows_MC = $18
	.var D016_Value_38Rows_HI = $00
	.var D016_Value_40Rows_HI = $08

	.var ScrollData_Buffer0 = $d000
	.var ScrollData_Buffer1 = $9000

	.var ZP_IRQJump = $20

	.var ZP_BitmapUpdateSRCIndex = $24
	.var ZP_BitmapUpdateDSTIndex = $25
	.var ZP_SpriteDataIndex = $26
	.var ZP_SrcStreamedSpriteDataOffset = $27
	.var ZP_SrcStreamedScrDataOffset = $28

	.var ZP_D016_38Rows = $2e
	.var ZP_D016_40Rows = $2f

	.var BitmapHeight1			= 1600
	.var BitmapHeight2			= 1152 + 192
	.var CharRowsPerLoadCall	= 8

	.var NumFrames_Total		= 16 //; 16/24
	.var NumFrames_BitmapUpdate	= 15 //; 15/16
	.var NumFrames_NoCopy		= NumFrames_Total - NumFrames_BitmapUpdate
	.var NumFrames_PerScroll	= NumFrames_Total / 8
	.var BufferBlockHeight		= 4
	.var NumLoadCallsBeforeD016Flip = BitmapHeight1 / (CharRowsPerLoadCall * 8)						//;25
	.var NumLoadCallsBeforeD016Flip2 = (BitmapHeight1 + BitmapHeight2) / (CharRowsPerLoadCall * 8)	//;42

	.var TotalNumLoadCalls		= (BitmapHeight1 + BitmapHeight2) / (CharRowsPerLoadCall * 8) - 1		//;41

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

Frame16CounterMod1:
	.byte $00
SpriteStartY:
	.byte $00

    UpdateNewData_LoPtrs:
        .byte <UpdateNewData_SRC1_DST1, <UpdateNewData_SRC1_DST0, <UpdateNewData_SRC1_DST1, <UpdateNewData_SRC1_DST0
        .byte <UpdateNewData_SRC0_DST1, <UpdateNewData_SRC0_DST0, <UpdateNewData_SRC0_DST1, <UpdateNewData_SRC0_DST0
        .byte <UpdateNewData_SRC3_DST1, <UpdateNewData_SRC3_DST0, <UpdateNewData_SRC3_DST1, <UpdateNewData_SRC3_DST0
        .byte <UpdateNewData_SRC2_DST1, <UpdateNewData_SRC2_DST0, <UpdateNewData_SRC2_DST1, <UpdateNewData_SRC2_DST0

    UpdateNewData_HiPtrs:
        .byte >UpdateNewData_SRC1_DST1, >UpdateNewData_SRC1_DST0, >UpdateNewData_SRC1_DST1, >UpdateNewData_SRC1_DST0
        .byte >UpdateNewData_SRC0_DST1, >UpdateNewData_SRC0_DST0, >UpdateNewData_SRC0_DST1, >UpdateNewData_SRC0_DST0
        .byte >UpdateNewData_SRC3_DST1, >UpdateNewData_SRC3_DST0, >UpdateNewData_SRC3_DST1, >UpdateNewData_SRC3_DST0
        .byte >UpdateNewData_SRC2_DST1, >UpdateNewData_SRC2_DST0, >UpdateNewData_SRC2_DST1, >UpdateNewData_SRC2_DST0

FrameCounterToDSTIndex:
	.fill NumFrames_BitmapUpdate, i
	.fill NumFrames_NoCopy, 0
FrameCounterToSpriteDataIndex:
	.byte (64 * 0) + 0, (64 * 0) + 1, (64 * 0) + 2
	.byte (64 * 1) + 0, (64 * 1) + 1, (64 * 1) + 2
	.byte (64 * 2) + 0, (64 * 2) + 1, (64 * 2) + 2
	.byte (64 * 3) + 0, (64 * 3) + 1
	.fill NumFrames_Total - 11, (64 * 3) + 2
FrameCounterToSRCIndex:
	.for (var BlockIndex = 0; BlockIndex < BufferBlockHeight; BlockIndex++)
	{
		.fill NumFrames_BitmapUpdate, (i * BufferBlockHeight) + BlockIndex
		.fill NumFrames_NoCopy, 0
	}
FrameCounterToStreamedSpriteDataOffset:
	.for (var BlockIndex = 0; BlockIndex < BufferBlockHeight; BlockIndex++)
	{
		.fill 11, (i * BufferBlockHeight) + BlockIndex
		.fill NumFrames_Total - 11, 255
	}
FrameCounterToStreamedScrDataOffset:
	.for (var BlockIndex = 0; BlockIndex < BufferBlockHeight; BlockIndex++)
	{
		.fill 15, i + (BlockIndex * 40)
		.fill NumFrames_Total - 15, 255
	}

Mul20_16Vals:
	.byte 80, 100, 120, 140
	.byte 0, 20, 40, 60
	.byte 80, 100, 120, 140
	.byte 0, 20, 40, 60

FrameIndexToScrollOffsetInverted:
	.fill NumFrames_PerScroll, 7
	.fill NumFrames_PerScroll, 6
	.fill NumFrames_PerScroll, 5
	.fill NumFrames_PerScroll, 4
	.fill NumFrames_PerScroll, 3
	.fill NumFrames_PerScroll, 2
	.fill NumFrames_PerScroll, 1
	.fill NumFrames_PerScroll, 0

	.var D000_SkipValue = $f1
	.var BlackSprites_YValue = $f5
INITIAL_D000Values:
	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D00C: VIC_Sprite2X
	.byte $00									//; D00D: VIC_Sprite2Y
	.byte $58									//; D00E: VIC_Sprite3X
	.byte BlackSprites_YValue					//; D00F: VIC_Sprite3Y
	.byte $e0									//; D004: VIC_Sprite4X
	.byte $00									//; D005: VIC_Sprite4Y
	.byte $00									//; D006: VIC_Sprite5X
	.byte $00									//; D007: VIC_Sprite5Y
	.byte $58									//; D008: VIC_Sprite6X
	.byte $00									//; D009: VIC_Sprite6Y
	.byte $70									//; D00A: VIC_Sprite7X
	.byte $00									//; D00B: VIC_Sprite7Y
	.byte $d8									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $f8									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows_MC					//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $f0									//; D01C: VIC_SpriteMulticolourMode
	.byte $0f									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $0c									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $0f									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $00									//; D029: VIC_Sprite2Colour
	.byte $00									//; D02A: VIC_Sprite3Colour
	.byte $0b									//; D02B: VIC_Sprite4Colour
	.byte $0b									//; D02C: VIC_Sprite5Colour
	.byte $0b									//; D02D: VIC_Sprite6Colour
	.byte $0b									//; D02E: VIC_Sprite7Colour

DD02Values:
	.byte DD02Value0, DD02Value1

.import source "../../../Out/6502/Parts/VerticalSideBorderBitmap/BorderCode_0.asm"
.import source "../../../Out/6502/Parts/VerticalSideBorderBitmap/BorderCode_1.asm"
.import source "../../../Out/6502/Parts/VerticalSideBorderBitmap/BorderCode_2.asm"
.import source "../../../Out/6502/Parts/VerticalSideBorderBitmap/UpdateNewData.asm"
.import source "../../../Out/6502/Parts/VerticalSideBorderBitmap/D016PatchCode.asm"

IRQ_Main:
		IRQManager_BeginIRQ(1, 0)

	FrameUpdateCall:
		jsr IRQ_MainCall_0

	FrameOf64:
		ldy #$00
	FrameOf16:
		ldx #$00
		iny
		inx
		cpx #NumFrames_Total
		bne Not16Or64
		ldx #0

	Frame16Counter:
		lda #$00
		clc
		adc #$01
		and #$0f
		sta Frame16Counter + 1
		and #$01
		sta Frame16CounterMod1

		cpy #(NumFrames_Total * BufferBlockHeight)
		bne Not16Or64
		ldy #0

	Not16Or64:
		stx FrameOf16 + 1
		sty FrameOf64 + 1

		cpx #NumFrames_BitmapUpdate
		bcs DontUpdateNewData

		lda FrameCounterToSRCIndex, y
		sta ZP_BitmapUpdateSRCIndex
		lda FrameCounterToDSTIndex, x
		sta ZP_BitmapUpdateDSTIndex
		lda FrameCounterToStreamedSpriteDataOffset, y
		sta ZP_SrcStreamedSpriteDataOffset
		lda FrameCounterToStreamedScrDataOffset, y
		sta ZP_SrcStreamedScrDataOffset
		lda FrameCounterToSpriteDataIndex, x
		sta ZP_SpriteDataIndex

		ldy Frame16Counter + 1
		lda UpdateNewData_LoPtrs, y
		sta JumpToUpdateNewData + 1
		lda UpdateNewData_HiPtrs, y
		sta JumpToUpdateNewData + 2

		inc $00
		dec $01
	JumpToUpdateNewData:
		jsr $ffff
		inc $01
		dec $00

		jmp NotColourCopyFrame

	DontUpdateNewData:
		.if ((NumFrames_Total - 1) != NumFrames_BitmapUpdate)
		{
			cpx #(NumFrames_Total - 1)
			bne NotColourCopyFrame
		}

		ldx #<IRQ_MainCall_2
		ldy #>IRQ_MainCall_2
		jmp FinishedNextFrameSetup

	NotColourCopyFrame:
		lda Frame16CounterMod1
		beq DoFrame0
		ldx #<IRQ_MainCall_1
		ldy #>IRQ_MainCall_1
		jmp FinishedNextFrameSetup

	DoFrame0:
		ldx #<IRQ_MainCall_0
		ldy #>IRQ_MainCall_0

	FinishedNextFrameSetup:
		stx FrameUpdateCall + 1
		sty FrameUpdateCall + 2

		jsr BASECODE_PlayMusic

		lda FrameOf16 + 1
		bne DontFlipFrameBuffer

		ldy Frame16CounterMod1
		lda DD02Values,y
		sta VIC_DD02

		lda Frame16Counter + 1
		sec
		sbc #$01
		and #$0f
		tax
		ldy Mul20_16Vals, x
		cpx #8
		bcs ColScrollBuffer1
		jsr VSBB_FastScrollColourMemory0
		jmp DoneColourScroll
	ColScrollBuffer1:
		jsr VSBB_FastScrollColourMemory1
	DoneColourScroll:

		lda FrameOf64 + 1
		bne DontIssueNextLoadSignal

	AlternateFrameLoadOnly:
		lda #$00
		eor #$01
		sta AlternateFrameLoadOnly + 1
		bne DontIssueNextLoadSignal

		inc Signal_CustomSignal0

	CountScrollParts:
		ldx #0
		inx
		stx CountScrollParts + 1
		cpx #NumLoadCallsBeforeD016Flip
		bne CheckFlipD016_2

		inc	FlipD016_1+1

	CheckFlipD016_2:
		cpx #NumLoadCallsBeforeD016Flip2
		bne DontFlipD016

		inc	FlipD016_2+1
	
	DontFlipD016:
		cpx #TotalNumLoadCalls
		bne DontFlipFrameBuffer

		inc Signal_CustomSignal1

	DontIssueNextLoadSignal:
	DontFlipFrameBuffer:

	FlipD016_1:
		lda	#$00
		beq	FlipD016_2
	FlipDelay1:
		ldx	#$11
		dex
		stx	FlipDelay1+1
		bne	SkipFlip

		lda	#$00
		sta	FlipD016_1+1
		lda	#$11
		sta	FlipDelay1+1

		ldx #D016_Value_38Rows_HI
		ldy #D016_Value_40Rows_HI
		lda #$0e //; $16 - D016_Value_40Rows_HI(8)
		stx ZP_D016_38Rows
		sty ZP_D016_40Rows
		jsr PatchD016Code
	SetSpriteColours:
		lda #$00
		sta VIC_SpriteMulticolourMode
	SetSpriteColours2:
		ldy #3
	SetSpriteColours3:
		sta VIC_Sprite4Colour, y
		dey
		bpl SetSpriteColours3
		bmi	SkipFlip

	FlipD016_2:
		lda	#$00
		beq	SkipFlip
	FlipDelay2:
		ldx	#$11
		dex
		stx	FlipDelay2+1
		bne	SkipFlip

		lda	#$00
		sta	FlipD016_2+1
		lda	#$11
		sta	FlipDelay2+1

		ldx	#$00						//;Reset counter
		stx CountScrollParts + 1

		ldx #D016_Value_38Rows_HI + $10
		ldy #D016_Value_40Rows_HI + $10
		lda #$be
		stx ZP_D016_38Rows
		sty ZP_D016_40Rows
		jsr PatchD016Code

		lda	#$f0
		sta VIC_SpriteMulticolourMode
		lda #$0b
		bne SetSpriteColours2


	SkipFlip:
		jsr DoInitialSpriteSettings

		ldx FrameOf16 + 1
		lda FrameIndexToScrollOffsetInverted, x
		ora #40
		sta VIC_D012
		lda FrameIndexToScrollOffsetInverted, x
		ora #D011_Value_24Rows
		sta VIC_D011

		:IRQManager_EndIRQ()
		rti

VSBB_FastScrollColourMemory1:

		.for (var Index = 0; Index < 20; Index++)
		{
			ldx ScrollData_Buffer1 + Index, y
			stx VIC_ColourMemory + 1000 - 40 + (Index * 2) + 0
			lda $9f00, x
			sta VIC_ColourMemory + 1000 - 40 + (Index * 2) + 1
		}
		rts

VSBB_FastScrollColourMemory0:

		inc $00
		dec $01

		.for (var Index = 19; Index >= 0; Index--)
		{
			ldx ScrollData_Buffer0 + Index, y
			.if (Index != 0)
			{
				stx ColourBlitCode + (11 * Index) + 1 - 2
			}
		}

		inc $01
		dec $00

	ColourBlitCode:
		.for (var Index = 0; Index < 20; Index++)
		{
			.if (Index != 0)
			{
				ldx #$ff
			}
			stx VIC_ColourMemory + 1000 - 40 + (Index * 2) + 0
			lda $9f00, x
			sta VIC_ColourMemory + 1000 - 40 + (Index * 2) + 1
		}
		rts

DoInitialSpriteSettings:
		ldx FrameOf16 + 1
		lda FrameIndexToScrollOffsetInverted, x
		clc
		adc #42
		sta SpriteStartY
		jmp SetInitialSpriteSettings

//; VSBB_Init() -------------------------------------------------------------------------------------------------------
VSBB_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		lda #JMP_ABS
		sta ZP_IRQJump + 0
		lda #<IRQ_Main
		sta ZP_IRQJump + 1
		lda #>IRQ_Main
		sta ZP_IRQJump + 2

		jsr DoInitialSpriteSettings

		ldy #$07
		lda #$fe
	FillSpriteValsLoop:
		sta SpriteVals0, y
		sta SpriteVals1, y
		dey
		bpl FillSpriteValsLoop

		lda #$00
		sta ZP_BitmapUpdateSRCIndex
		sta ZP_BitmapUpdateDSTIndex
		sta ZP_SpriteDataIndex
		sta ZP_SrcStreamedSpriteDataOffset
		sta ZP_SrcStreamedScrDataOffset
		sta $bfff

		lda #D016_Value_38Rows_MC
		sta ZP_D016_38Rows
		lda #D016_Value_40Rows_MC
		sta ZP_D016_40Rows

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #47
		sta VIC_D012
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff
		asl VIC_D019

		lda #D016_Value_40Rows_MC
		sta VIC_D016

		cli
		rts

