//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = VertBitmap_BASE "Vertical Bitmap"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp VERTBITMAP_Init							//; Init
		jmp VERTBITMAP_MainThreadFunc				//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $f4-f7 Spindle (Only during loads)
//; ---- $0c00-$0dff Spindle (ALWAYS)
//; ---- $0e00-$0eff Spindle (Only during loads)
//; - $1000-1fff Music
//; - $2a00-???? Code

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var BitmapBank0 = 1 //; Bank+[2000,3fff]
	.var BitmapAddress0 = (Base_BankAddress0 + (BitmapBank0 * 8192))
	.var ScreenBank0 = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var Bank_SpriteVals0 = (ScreenAddress0 + $3F8 + 0)

	.var BaseBank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var BitmapBank1 = 1 //; Bank+[2000,3fff]
	.var BitmapAddress1 = (Base_BankAddress1 + (BitmapBank1 * 8192))
	.var ScreenBank1 = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var Bank_SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank0 * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank1 * 8)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_38Rows = $10
	.var D016_Value_40Rows = $18

	.var VERTBITMAP_ColourData = $4800

	.var VERTBITMAP_ScrollData = $8000

	VERTBITMAP_CurrentDisplayedBank: .byte $00
	VERTBITMAP_BitmapScrollCompletedSignal: .byte $00
	VERTBITMAP_DD02Values: .byte DD02Value0, DD02Value1
	VERTBITMAP_SkipUpdateBitmapData: .byte $00

	.var VERTBITMAP_SpriteLogoYPosition = $4a

	.var VERTBITMAP_Sprite0XSin = $4000
	.var VERTBITMAP_Sprite1XSin = VERTBITMAP_Sprite0XSin + (1 * 256)
	.var VERTBITMAP_Sprite2XSin = VERTBITMAP_Sprite0XSin + (2 * 256)
	.var VERTBITMAP_Sprite3XSin = VERTBITMAP_Sprite0XSin + (3 * 256)
	.var VERTBITMAP_Sprite4XSin = VERTBITMAP_Sprite0XSin + (4 * 256)
	.var VERTBITMAP_Sprite5XSin = VERTBITMAP_Sprite0XSin + (5 * 256)
	.var VERTBITMAP_Sprite6XSin = VERTBITMAP_Sprite0XSin + (6 * 256)
	.var VERTBITMAP_Sprite7XSin = VERTBITMAP_Sprite0XSin + (7 * 256)
	.var VERTBITMAP_SpriteXMSBSin = VERTBITMAP_Sprite0XSin + (8 * 256)

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

VERTBITMAP_PauseAllIRQFunctions:				.byte $00
VERTBITMAP_CurrentSpriteSet:					.byte $00

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $58									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $70									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $88									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $a0									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $b8									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $d0									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $e8									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $80									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $03									//; D020: VIC_BorderColour
	.byte $06									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $01									//; D025: VIC_SpriteExtraColour0
	.byte $03									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $00									//; D029: VIC_Sprite2Colour
	.byte $00									//; D02A: VIC_Sprite3Colour
	.byte $00									//; D02B: VIC_Sprite4Colour
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

.macro SetSpriteVals(SplitNum)
{
	.var Value = $40 + (SplitNum * $08)

	ldx #(Value + 4)
	lda #$fb
	ldy VERTBITMAP_CurrentDisplayedBank
	bne * + 2 + 27 + 3

	sax Bank_SpriteVals0 + 0 //; stores val & $fb
	stx Bank_SpriteVals0 + 4 //; stores val
	inx
	sax Bank_SpriteVals0 + 1
	stx Bank_SpriteVals0 + 5
	inx
	sax Bank_SpriteVals0 + 2
	stx Bank_SpriteVals0 + 6
	inx
	sax Bank_SpriteVals0 + 3
	stx Bank_SpriteVals0 + 7
	jmp * + 3 + 27

	sax Bank_SpriteVals1 + 0
	stx Bank_SpriteVals1 + 4
	inx
	sax Bank_SpriteVals1 + 1
	stx Bank_SpriteVals1 + 5
	inx
	sax Bank_SpriteVals1 + 2
	stx Bank_SpriteVals1 + 6
	inx
	sax Bank_SpriteVals1 + 3
	stx Bank_SpriteVals1 + 7
}

.macro SetSpriteX()
{
	lda VERTBITMAP_Sprite0XSin, x
	sta VIC_Sprite0X
	lda VERTBITMAP_Sprite1XSin, x
	sta VIC_Sprite1X
	lda VERTBITMAP_Sprite2XSin, x
	sta VIC_Sprite2X
	lda VERTBITMAP_Sprite3XSin, x
	sta VIC_Sprite3X
	lda VERTBITMAP_Sprite4XSin, x
	sta VIC_Sprite4X
	lda VERTBITMAP_Sprite5XSin, x
	sta VIC_Sprite5X
	lda VERTBITMAP_Sprite6XSin, x
	sta VIC_Sprite6X
	lda VERTBITMAP_Sprite7XSin, x
	sta VIC_Sprite7X
	lda VERTBITMAP_SpriteXMSBSin, x
	sta VIC_SpriteXMSB
}

.macro SetSpriteY(SplitNum)
{
	lda #(VERTBITMAP_SpriteLogoYPosition + (21 * SplitNum))
	.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
	{
		sta VIC_Sprite0Y + (SpriteIndex * 2)
	}
}

.macro SetD012(SplitNum)
{
		lda #(VERTBITMAP_SpriteLogoYPosition + (20 * SplitNum) - 2)
		sta VIC_D012
}

//; VERTBITMAP_Init() -------------------------------------------------------------------------------------------------------
VERTBITMAP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank0)

		lda #$00
		sta Base_BankAddress0 + $3fff

		ldy #$00
		lda #$33
	ClearScreenLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta VIC_ColourMemory + (Page * 256), y
			sta ScreenAddress0 + (Page * 256), y
		}
		iny
		bne ClearScreenLoop

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei

		lda #$00
		sta VIC_D012
		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #<VERTBITMAP_IRQ_VBlank
		sta $fffe
		lda #>VERTBITMAP_IRQ_VBlank
		sta $ffff
		asl VIC_D019

		cli
		rts
		
SpriteColour0Table:
	.byte  0,   0,  11,  11,  12,  12,   1,   1,   1
SpriteColour1Table:
	.byte  1,  12,  12,  11,  11,   0,   0,   0,   0
SpriteColour2Table:
	.byte  3,   3,  14,   4,   4,   4,   6,   6,   6

VERTBITMAP_IRQ_VBlank:
		:IRQManager_BeginIRQ(0, 0)

		inc FrameOf256
		bne Startup_DontIncreaseCounter
		inc Frame_256Counter
	Startup_DontIncreaseCounter:

		jsr BASECODE_PlayMusic

/*		lda Signal_MusicTrigger
		beq NoMusicTrigger
		lda #$09
		sta Pulse + 1
	NoMusicTrigger:

	Pulse:
		ldx #$00
		beq NoPulse
		dex
		stx Pulse + 1
		lda SpriteColour0Table, x
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta VIC_Sprite0Colour + SpriteIndex
		}
		lda SpriteColour1Table, x
		sta VIC_SpriteExtraColour0
		lda SpriteColour2Table, x
		sta VIC_SpriteExtraColour1
	NoPulse:*/

		lda VERTBITMAP_PauseAllIRQFunctions
		beq DontPauseIRQ
		lda #$00
		sta VIC_D011
		jmp VERTBITMAP_SetVBlankIRQ

	DontPauseIRQ:
		lda VIC_D012
	WaitForChange:
		cmp VIC_D012
		beq WaitForChange

	SetBorderColour:
		lda #$03
	LastValue:
		cmp #$03
		beq DontChange
		sta VIC_BorderColour
		sta LastValue + 1
	DontChange:

		lda VERTBITMAP_CurrentSpriteSet
		cmp #2
		beq FinishedInitialSprites

		lda #$03
		sta VIC_ScreenColour

	VERTBITMAP_SpriteSinPos:
		ldx #$00
		inx
		stx VERTBITMAP_SpriteSinPos + 1
		bne DontUpdateSprites

		inc Signal_CustomSignal0

	DontUpdateSprites:
		lda #D011_Value_24Rows
		sta VIC_D011
		jmp SkipBitmapStuff
	FinishedInitialSprites:

	BitmapScrollScreenColour:
		lda #$06
		sta VIC_ScreenColour

		lda NumFLDLines + 1
		beq VERTBITMAP_SmoothScroll

		lda #$2f
		sta VIC_D012
		lda #D011_Value_24Rows
		sta VIC_D011
		lda #<VERTBITMAP_FLDIRQ
		sta $fffe
		lda #>VERTBITMAP_FLDIRQ
		sta $ffff
		lda #$01
		sta VIC_D01A
		:IRQManager_EndIRQ()

		rti

	.var VERTBITMAP_NumFrames = 8
	VERTBITMAP_NextFrame:
		.byte VERTBITMAP_NumFrames - 1
		.fill VERTBITMAP_NumFrames - 1, i

	VERTBITMAP_SmoothScroll:
		ldx #$00
		stx VERTBITMAP_SpriteSinPos + 1
		inx
		bne NotFinishedThisPart

		inc Signal_CurrentEffectIsFinished

	NotFinishedThisPart:
		cpx #$c0
		bne DontLoop
	VERTBITMAP_Looper:
		ldx #$40
	DontLoop:
		stx VERTBITMAP_SmoothScroll + 1

		ldx VERTBITMAP_SpriteSinPos + 1
		:SetSpriteX()

	VERTBITMAP_SmoothScroll_Index:
		ldx #(3 * 2)
		lda VERTBITMAP_NextFrame, x
		sta VERTBITMAP_SmoothScroll_Index + 1
		tax
		ora #$30
		sta VIC_D011
		cpx #(VERTBITMAP_NumFrames - 1)
		bne SkipBitmapStuff

		inc Signal_CustomSignal0

		lda VERTBITMAP_CurrentDisplayedBank
		eor #$01
		sta VERTBITMAP_CurrentDisplayedBank
		tax
		lda VERTBITMAP_DD02Values, x
		sta VIC_DD02

	SkipBitmapStuff:
		lda #$ff
		sta VIC_SpriteEnable
		:SetSpriteY(0)
		:SetSpriteVals(0)
		ldx VERTBITMAP_SpriteSinPos + 1
		:SetSpriteX()

		:SetD012(1)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit1IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit1IRQ
		sta $ffff
		:IRQManager_EndIRQ()

		rti

VERTBITMAP_SpriteSplit1IRQ:
		:IRQManager_BeginIRQ(1, -2)
		:SetSpriteY(1)
		:SetSpriteVals(1)

		:SetD012(2)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit2IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit2IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit2IRQ:
		:IRQManager_BeginIRQ(1, -2)
		:SetSpriteY(2)
		:SetSpriteVals(2)

		:SetD012(3)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit3IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit3IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit3IRQ:
		:IRQManager_BeginIRQ(1, -2)
		:SetSpriteY(3)
		:SetSpriteVals(3)

		lda VERTBITMAP_CurrentSpriteSet
		bne NotGPLogo
		lda VERTBITMAP_SpriteSinPos + 1
		eor #$ff
		tax
		:SetSpriteX()
	NotGPLogo:

		:SetD012(4)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit4IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit4IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit4IRQ:
		:IRQManager_BeginIRQ(1, -2)
		:SetSpriteY(4)
		:SetSpriteVals(4)

		:SetD012(5)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit5IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit5IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit5IRQ:
		:IRQManager_BeginIRQ(1, -2)
		:SetSpriteY(5)
		:SetSpriteVals(5)

		:SetD012(6)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit6IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit6IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit6IRQ:
		:IRQManager_BeginIRQ(1, -2)

		:SetSpriteY(6)
		:SetSpriteVals(6)

		:SetD012(7)
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_SpriteSplit7IRQ
		sta $fffe
		lda #>VERTBITMAP_SpriteSplit7IRQ
		sta $ffff
		:IRQManager_EndIRQ()
		rti

VERTBITMAP_SpriteSplit7IRQ:
		:IRQManager_BeginIRQ(1, -2)

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteXMSB
		sta VIC_Sprite0X
		sta VIC_Sprite1X
		sta VIC_Sprite2X
		sta VIC_Sprite3X
		sta VIC_Sprite4X
		sta VIC_Sprite5X
		sta VIC_Sprite6X
		sta VIC_Sprite7X

	VERTBITMAP_SetVBlankIRQ:
		lda #$00
		sta VIC_D012
		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #$01
		sta VIC_D01A
		lda #<VERTBITMAP_IRQ_VBlank
		sta $fffe
		lda #>VERTBITMAP_IRQ_VBlank
		sta $ffff
		:IRQManager_EndIRQ()

		rti

VERTBITMAP_FLDIRQ:
		:IRQManager_BeginIRQ(1, -2)

		lda #$03
		sta VIC_ScreenColour

	NumFLDLines:
		lda #240
		cmp #200
		bcc DoFLD
		lda #200
	DoFLD:
		tax
	FLDLoop:
        lda VIC_D012
	FLDWaitForNextLine:
        cmp VIC_D012
        beq FLDWaitForNextLine

        clc
        lda VIC_D011
        adc #$01
        and #$07
        ora #$30
        sta VIC_D011

        dex
        bne FLDLoop

		dec NumFLDLines + 1

		lda #$00
		sta VIC_D012
		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #<VERTBITMAP_IRQ_VBlank
		sta $fffe
		lda #>VERTBITMAP_IRQ_VBlank
		sta $ffff
		lda #$01
		sta VIC_D01A
		:IRQManager_EndIRQ()

		rti


.var SizeOfBitmapDataToCopy = (40 * 8 * 24)
.var BitmapChunkSize = 64
.var NumBitmapChunks = (SizeOfBitmapDataToCopy / BitmapChunkSize)

.var SizeOfScreenDataToCopy = (40 * 24)
.var ScreenChunkSize = 40
.var NumScreenChunks = (SizeOfScreenDataToCopy / ScreenChunkSize)


VERTBITMAP_SpriteCopyAddress:
	.byte $ee, $e0

VERTBITMAP_MainThreadFunc:

		lda #$00
		sta Signal_CustomSignal0

		ldx VERTBITMAP_CurrentSpriteSet
		cpx #2
		beq AlreadyFinishedSprites

		inc VERTBITMAP_PauseAllIRQFunctions

		cpx #1
		bne NotFinalLogo

		jsr IRQLoader_LoadNext	//; Load next logo and the bitmap data
		jsr VERTBITMAP_PrepareForBitmapScroll
		jmp FinishedLoadingHere

	NotFinalLogo:
		jsr IRQLoader_LoadNext	//; Load next logo...
	FinishedLoadingHere:
		inc VERTBITMAP_CurrentSpriteSet
		dec VERTBITMAP_PauseAllIRQFunctions
		rts

	AlreadyFinishedSprites:
		jsr VERTBITMAP_QuickColourScroll

	DoBitmapScroll:
		lda VERTBITMAP_CurrentDisplayedBank
		beq VERTBITMAP_Copy0To1
		jmp VERTBITMAP_Copy1To0

	VERTBITMAP_Copy0To1:
		ldy #(BitmapChunkSize - 1)
	CopyBitmap0To1Loop:
		.for(var BitmapChunkIndex = 0; BitmapChunkIndex < NumBitmapChunks; BitmapChunkIndex++)
		{
			lda BitmapAddress0 + (40 * 8) + BitmapChunkIndex * BitmapChunkSize, y
			sta BitmapAddress1 + BitmapChunkIndex * BitmapChunkSize, y
		}
		dey
		bmi FinishedBitmapCopy0To1
		jmp CopyBitmap0To1Loop

	FinishedBitmapCopy0To1:
		ldy #(ScreenChunkSize - 1)
	CopyScreen0To1Loop:
		.for(var ScreenChunkIndex = 0; ScreenChunkIndex < NumScreenChunks; ScreenChunkIndex++)
		{
			lda ScreenAddress0 + 40 + ScreenChunkIndex * ScreenChunkSize, y
			sta ScreenAddress1 + ScreenChunkIndex * ScreenChunkSize, y
		}
		dey
		bmi FinishedScreenCopy0To1
		jmp CopyScreen0To1Loop

	FinishedScreenCopy0To1:
		lda VERTBITMAP_SkipUpdateBitmapData
		beq BitmapUpdate0To1
		inc VERTBITMAP_BitmapScrollCompletedSignal
		rts

	BitmapUpdate0To1:
		ldx #$00
		ldy #$00
	BitmapUpdate0To1Loop:
		.for (var XPos = 0; XPos < 40; XPos++)
		{
			lda VERTBITMAP_ScrollData + 0 + (XPos * 256), x
			sta BitmapAddress1 + (24 * 40 * 8) + (XPos * 8), y
		}
		inx
		iny
		cpy #$08
		beq FinishedBitmapUpdate0To1
		jmp BitmapUpdate0To1Loop
	FinishedBitmapUpdate0To1:
		lda BitmapUpdate0To1 + 1
		clc
		adc #$10
		sta BitmapUpdate0To1 + 1

	ScreenUpdate0To1:
		ldx #$00
		.for (var XPos = 0; XPos < 40; XPos++)
		{
			lda VERTBITMAP_ScrollData + 200 + (XPos * 256), x
			sta ScreenAddress1 + (24 * 40) + XPos
		}
		inx
		inx
		stx ScreenUpdate0To1 + 1

		inc VERTBITMAP_BitmapScrollCompletedSignal
		rts

	VERTBITMAP_Copy1To0:
		ldy #(BitmapChunkSize - 1)
	CopyBitmap1To0Loop:
		.for(var BitmapChunkIndex = 0; BitmapChunkIndex < NumBitmapChunks; BitmapChunkIndex++)
		{
			lda BitmapAddress1 + (40 * 8) + BitmapChunkIndex * BitmapChunkSize, y
			sta BitmapAddress0 + BitmapChunkIndex * BitmapChunkSize, y
		}
		dey
		bmi FinishedBitmapCopy1To0
		jmp CopyBitmap1To0Loop

	FinishedBitmapCopy1To0:
		ldy #(ScreenChunkSize - 1)
	CopyScreen1To0Loop:
		.for(var ScreenChunkIndex = 0; ScreenChunkIndex < NumScreenChunks; ScreenChunkIndex++)
		{
			lda ScreenAddress1 + 40 + ScreenChunkIndex * ScreenChunkSize, y
			sta ScreenAddress0 + ScreenChunkIndex * ScreenChunkSize, y
		}
		dey
		bmi FinishedScreenCopy1To0
		jmp CopyScreen1To0Loop

	FinishedScreenCopy1To0:
		lda VERTBITMAP_SkipUpdateBitmapData
		beq BitmapUpdate1To0
		inc VERTBITMAP_BitmapScrollCompletedSignal
		rts

	BitmapUpdate1To0:
		ldx #$00
		ldy #$00
	BitmapUpdate1To0Loop:
		.for (var XPos = 0; XPos < 40; XPos++)
		{
			lda VERTBITMAP_ScrollData + 0 + (XPos * 256) + 8, x
			sta BitmapAddress0 + (24 * 40 * 8) + (XPos * 8), y
		}
		inx
		iny
		cpy #$08
		beq FinishedBitmapUpdate1To0
		jmp BitmapUpdate1To0Loop
	FinishedBitmapUpdate1To0:
		lda BitmapUpdate1To0 + 1
		clc
		adc #$10
		sta BitmapUpdate1To0 + 1

	ScreenUpdate1To0:
		ldx #$00
		.for (var XPos = 0; XPos < 40; XPos++)
		{
			lda VERTBITMAP_ScrollData + 200 + (XPos * 256) + 1, x
			sta ScreenAddress0 + (24 * 40) + XPos
		}
		inx
		inx
		stx ScreenUpdate1To0 + 1

		inc VERTBITMAP_BitmapScrollCompletedSignal
		rts

VERTBITMAP_QuickColourScroll:
		ldy #(ScreenChunkSize - 1)
	ColCopyLoop0:
		.for(var ScreenChunkIndex = 0; ScreenChunkIndex < 8; ScreenChunkIndex++)
		{
			lda VIC_ColourMemory + 40 + ScreenChunkIndex * ScreenChunkSize, y
			sta VIC_ColourMemory + ScreenChunkIndex * ScreenChunkSize, y
		}
		dey
		bpl ColCopyLoop0

		ldy #(ScreenChunkSize - 1)
	ColCopyLoop1:
		.for(var ScreenChunkIndex = 8; ScreenChunkIndex < 16; ScreenChunkIndex++)
		{
			lda VIC_ColourMemory + 40 + ScreenChunkIndex * ScreenChunkSize, y
			sta VIC_ColourMemory + ScreenChunkIndex * ScreenChunkSize, y
		}
		dey
		bpl ColCopyLoop1

		ldy #(ScreenChunkSize - 1)
	ColCopyLoop2:
		.for(var ScreenChunkIndex = 16; ScreenChunkIndex < 24; ScreenChunkIndex++)
		{
			lda VIC_ColourMemory + 40 + ScreenChunkIndex * ScreenChunkSize, y
			sta VIC_ColourMemory + ScreenChunkIndex * ScreenChunkSize, y
		}
		dey
		bpl ColCopyLoop2

	FinishedColCopy:
	ColourUpdateIndex:
		ldx #$00
		lda VERTBITMAP_SkipUpdateBitmapData
		beq ColourUpdate

		ldy #39
		lda #$00
	FillLastLineLoop:
		sta VIC_ColourMemory + (24 * 40), y
		sta ScreenAddress0 + (24 * 40), y
		sta ScreenAddress1 + (24 * 40), y
		dey
		bpl FillLastLineLoop
		jmp DontUpdateColours

	ColourUpdate:
		.for (var XPos = 0; XPos < 40; XPos++)
		{
			lda VERTBITMAP_ScrollData + 225 + (XPos * 256), x
			sta VIC_ColourMemory + (24 * 40) + XPos
		}

	DontUpdateColours:
		inx
		stx ColourUpdateIndex + 1

		cpx #25
		bne Not25
		inc VERTBITMAP_SkipUpdateBitmapData
	Not25:
		cpx #50
		bne NotFinishedYet

		lda #$a9
		sta VERTBITMAP_Looper
		lda #$00
		sta BitmapScrollScreenColour + 1
		inc Signal_CustomSignal1

	NotFinishedYet:

		lda VERTBITMAP_BorderColours, x
		sta SetBorderColour + 1
		rts

VERTBITMAP_BorderColours:
	.fill 14, 3
	.fill 11, 14
	.fill 11, 6
	.fill 256 - 36, 0

VERTBITMAP_PrepareForBitmapScroll:

	//; Prep second frame of bitmap
		jsr VERTBITMAP_Copy0To1

		dec $01
		ldy #$00
	VERTBITMAP_CopySpriteDataLoop:
		.for (var Page = 0; Page < 14; Page++)
		{
			lda $5000 + (Page * 256), y
			sta $d000 + (Page * 256), y
		}
		iny
		bne VERTBITMAP_CopySpriteDataLoop
		inc $01

		rts



