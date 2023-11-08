//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = DYPP_BASE "DYPP"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp DYPP_Init								//; Init
		jmp DYPP_MainThread							//; MainThreadFunc
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
//; - $2000-7fff Code
//; - $8000-83ff Scrolltext
//; - $8400-bfff Font
//; ---- $c000-dfff Bitmap (with sprites intermixed)
//; ---- $e000-e3ff Screen0 + SpriteInfo
//; ---- $e400-e7ff Screen1 + SpriteInfo
//; ---- $e800-feff More sprites

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var ScreenBank0 = 8 //; Bank+[2000,23ff]
	.var ScreenBank1 = 9 //; Bank+[2400,27ff]
	.var ScreenAddress0 = (Base_BankAddress + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress + (ScreenBank1 * 1024))
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))
	.var Bank_SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var Bank_SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank * 8)

	.var DYPP_YStart = 30
	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_38Rows = $17
	.var D016_Value_40Rows = $18

	.var DYPP_FontPP = $8400

	.var ZP_ScreenChars = $20
	.var ZP_XMSB = $60

	.var ZP_IRQJump = $1a

	.var ColourDataLo = $e800
	.var ColourDataHi = $ec00
	.var ScreenAddressOrig = $f000

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

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
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $0e									//; D020: VIC_BorderColour
	.byte $e0									//; D021: VIC_ScreenColour
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

	DYPP_Jump_InitialParts_Lo:
		.byte <DYPP_IRQ_InitialPart_Frame0, <DYPP_IRQ_InitialPart_Frame1
	DYPP_Jump_InitialParts_Hi:
		.byte >DYPP_IRQ_InitialPart_Frame0, >DYPP_IRQ_InitialPart_Frame1
	DYPP_Jump_Mains_Lo:
		.byte <DYPP_IRQ_Main_Frame0, <DYPP_IRQ_Main_Frame1
	DYPP_Jump_Mains_Hi:
		.byte >DYPP_IRQ_Main_Frame0, >DYPP_IRQ_Main_Frame1

	.var DYPP_NumSpriteXPositions = 408 / 8
	.var DYPP_NumXBlocks = 408 / 24

	DYPP_TabledXPositions:
		.fill DYPP_NumSpriteXPositions, i
	DYPP_TabledXPositions_MidPoint:
		.fill DYPP_NumSpriteXPositions, i
	.var DYPP_NextXPosition = DYPP_TabledXPositions + 1
	.var DYPP_PrevXPosition = DYPP_TabledXPositions_MidPoint - 1

	DYPP_Sprite_XPositions:
		.fill DYPP_NumXBlocks, 0
	DYPP_Sprite_XPositionsMSB:
		.fill DYPP_NumXBlocks, 0

	DYPP_MUL_Lo:
//; WIDER 		.byte <(504 - 48), <(504 - 40)
		.byte <(504 - 32), <(504 - 24), <(504 - 16), <(504 - 8)
		.fill DYPP_NumSpriteXPositions, <(i * 8)
	DYPP_MUL_Hi:
//; WIDER 		.byte <(504 - 48), <(504 - 40)
		.byte >(504 - 32), >(504 - 24), >(504 - 16), >(504 - 8)
		.fill DYPP_NumSpriteXPositions, >(i * 8)

	DYPP_Bit4:
		.byte $00, $10
	DYPP_Bit5:
		.byte $00, $20
	DYPP_Bit6:
		.byte $00, $40
	DYPP_Bit7:
		.byte $00, $80

	DYPP_Add1Modded:
		.fill 15, (i + 1)
		.byte 0

	DYPP_Div:
		.fill 32, (i / 4)

	Flag_ShouldFadeBitmap:
		.byte $01
	Flag_ShouldClearSprites:
		.byte $00
	Flag_SpriteClearFinished:
		.byte $00

.import source "DYPP-BitmapFade.asm"
.import source "..\..\..\..\Intermediate\Built\DYPP\Rasterised.asm"
.import source "..\..\..\..\Intermediate\Built\DYPP\SpriteClear.asm"

//; DYPP_Init() -------------------------------------------------------------------------------------------------------
DYPP_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		lda #$00
		ldy #(DYPP_NumSpriteXPositions - 1)
		lda #$00
	FillZeroPageData:
		sta ZP_ScreenChars, y
		dey
		bpl FillZeroPageData

		ldy #$00
		lda #$aa
	CopyMemoryLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		sta ScreenAddress0 + (0 * 256), y
		sta ScreenAddress0 + (1 * 256), y
		sta ScreenAddress0 + (2 * 256), y
		sta ScreenAddress0 + (3 * 256), y
		sta ScreenAddress1 + (0 * 256), y
		sta ScreenAddress1 + (1 * 256), y
		sta ScreenAddress1 + (2 * 256), y
		sta ScreenAddress1 + (3 * 256), y
		iny
		bne CopyMemoryLoop

		lda #DD02Value
		sta VIC_DD02

		jsr DYPP_IRQ_InitialPart_Frame0

		lda #JMP_ABS
		sta ZP_IRQJump + 0
		lda #<DYPP_StartupInterrupt_Top
		sta ZP_IRQJump + 1
		lda #>DYPP_StartupInterrupt_Top
		sta ZP_IRQJump + 2

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei

		lda #$00
		sta DYPP_FrameOf2 + 1
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #$f0
		sta VIC_SpriteEnable

		lda #(DYPP_YStart + 1)
		sta VIC_D012
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff
		asl VIC_D019

		cli
		rts

DYPP_MainThread:
		lda Flag_ShouldClearSprites
		beq DontClearSprites

		jsr SpriteClear

		dec Flag_ShouldClearSprites
		inc Flag_SpriteClearFinished
	DontClearSprites:
		rts

DYPP_StartupInterrupt_Top:
		:IRQManager_BeginIRQ(1, 1)

		nop
		lda #$0a
		sta VIC_BorderColour
		sta VIC_ScreenColour

        lda #D018Value0
        sta VIC_D018

		inc FrameOf256
		bne Startup_DontIncreaseCounter
		inc Frame_256Counter
	Startup_DontIncreaseCounter:

	ShouldSkipFades:
		lda Flag_ShouldFadeBitmap
		beq SkipFades

		jsr DoFades
		cmp #$ff
		bne SkipFades
		dec Flag_ShouldFadeBitmap
		inc Flag_ShouldClearSprites
	SkipFades:

		lda #$f9
		sta VIC_D012

		lda #<DYPP_StartupInterrupt_Bottom
		sta ZP_IRQJump + 1
		lda #>DYPP_StartupInterrupt_Bottom
		sta ZP_IRQJump + 2

		:IRQManager_EndIRQ()
		rti
	
DYPP_StartupInterrupt_Bottom:
		:IRQManager_BeginIRQ(1, 0)

		lda #D011_Value_24Rows
		sta VIC_D011

		lda #$0b
		cmp VIC_D012
		bne * - 3

		ldx #$0b
	DelayHere:
		dex
		bne DelayHere

		lda #$00
		sta VIC_BorderColour
		sta VIC_ScreenColour

		lda #D011_Value_25Rows
		sta VIC_D011

		jsr BASECODE_PlayMusic

		lda Flag_SpriteClearFinished
		beq NotFinishedStartupInterrupt
		jmp DontUpdateScrollText
	NotFinishedStartupInterrupt:

//;		inc Signal_VBlank

		lda #<DYPP_StartupInterrupt_Top
		sta ZP_IRQJump + 1
		lda #>DYPP_StartupInterrupt_Top
		sta ZP_IRQJump + 2
		lda #(DYPP_YStart + 1)
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011

		:IRQManager_EndIRQ()
		rti

DYPP_UpdateXPositions:
		ldx DYPP_SetXPositions + 1
		ldy DYPP_NextXPosition, x
		sty DYPP_SetXPositions + 1

	DYPP_SetXPositions:
		ldx #$00
		ldy #$00
	UpdateXLoop:
		lda DYPP_MUL_Lo, x
		ora DYPP_ScrollXValue + 1
		sta DYPP_Sprite_XPositions, y

		lda DYPP_MUL_Hi, x
		sta DYPP_Sprite_XPositionsMSB, y

		lda DYPP_NextXPosition + 2, x //; Equivalent to +6 modded
		tax

		iny
		cpy #DYPP_NumXBlocks
		bne UpdateXLoop

	DYPP_FrameOf2:
		lda #$00
		beq DYPP_SetMSBs_Frame0
		jmp DYPP_SetMSBs_Frame1

	DYPP_SetMSBs_Frame0:
		ldy DYPP_Sprite_XPositionsMSB + 0
		lda DYPP_Bit4, y
		ldy DYPP_Sprite_XPositionsMSB + 1
		ora DYPP_Bit5, y
		ldy DYPP_Sprite_XPositionsMSB + 15
		ora DYPP_Bit6, y
		ldy DYPP_Sprite_XPositionsMSB + 16
		ora DYPP_Bit7, y
		sta ZP_XMSB + 0

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 2
		ora DYPP_Bit4, y
		sta ZP_XMSB + 1

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 14
		ora DYPP_Bit7, y
		sta ZP_XMSB + 2

		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 3
		ora DYPP_Bit5, y
		sta ZP_XMSB + 3

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 13
		ora DYPP_Bit6, y
		sta ZP_XMSB + 4

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 4
		ora DYPP_Bit4, y
		sta ZP_XMSB + 5

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 12
		ora DYPP_Bit7, y
		sta ZP_XMSB + 6

		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 5
		ora DYPP_Bit5, y
		sta ZP_XMSB + 7

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 11
		ora DYPP_Bit6, y
		sta ZP_XMSB + 8

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 6
		ora DYPP_Bit4, y
		sta ZP_XMSB + 9

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 10
		ora DYPP_Bit7, y
		sta ZP_XMSB + 10

		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 7
		ora DYPP_Bit5, y
		sta ZP_XMSB + 11
		
		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 9
		ora DYPP_Bit6, y
		sta ZP_XMSB + 12

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 8
		ora DYPP_Bit4, y
		sta ZP_XMSB + 13

		rts

	DYPP_SetMSBs_Frame1:
		ldy DYPP_Sprite_XPositionsMSB + 0
		lda DYPP_Bit4, y
		ldy DYPP_Sprite_XPositionsMSB + 1
		ora DYPP_Bit5, y
		ldy DYPP_Sprite_XPositionsMSB + 16
		ora DYPP_Bit6, y
		ldy DYPP_Sprite_XPositionsMSB + 15
		ora DYPP_Bit7, y
		sta ZP_XMSB + 0

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 14
		ora DYPP_Bit6, y
		sta ZP_XMSB + 1

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 2
		ora DYPP_Bit4, y
		sta ZP_XMSB + 2

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 13
		ora DYPP_Bit7, y
		sta ZP_XMSB + 3

		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 3
		ora DYPP_Bit5, y
		sta ZP_XMSB + 4

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 12
		ora DYPP_Bit6, y
		sta ZP_XMSB + 5

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 4
		ora DYPP_Bit4, y
		sta ZP_XMSB + 6

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 11
		ora DYPP_Bit7, y
		sta ZP_XMSB + 7

		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 5
		ora DYPP_Bit5, y
		sta ZP_XMSB + 8

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 10
		ora DYPP_Bit6, y
		sta ZP_XMSB + 9

		and #$e0
		ldy DYPP_Sprite_XPositionsMSB + 6
		ora DYPP_Bit4, y
		sta ZP_XMSB + 10

		and #$70
		ldy DYPP_Sprite_XPositionsMSB + 9
		ora DYPP_Bit7, y
		sta ZP_XMSB + 11
		
		and #$d0
		ldy DYPP_Sprite_XPositionsMSB + 7
		ora DYPP_Bit5, y
		sta ZP_XMSB + 12

		and #$b0
		ldy DYPP_Sprite_XPositionsMSB + 8
		ora DYPP_Bit6, y
		sta ZP_XMSB + 13

		rts

	ScrollTextRead:
		lda DYPP_ScrollText
		cmp #$f0
		bcc STWriteChar

		cmp #$ff
		beq ST_EndTrigger
		sec
		sbc #$f0
		sta DYPP_ScrollSpeed + 1
		bne NotPaused
		lda #$38
		sta DYPP_ScrollDelay + 1
	NotPaused:
		lda #$00
		beq STWriteChar

	ST_EndTrigger:
		lda #<(DYPP_ScrollText - 1)
		sta ScrollTextRead + 1
		lda #>(DYPP_ScrollText - 1)
		sta ScrollTextRead + 2

		inc Signal_CurrentEffectIsFinished

		lda #$00

	STWriteChar:
		ldy DYPP_WriteChar + 1
		sta ZP_ScreenChars, y

		inc ScrollTextRead + 1
		bne STPtrGood
		inc ScrollTextRead + 2
	STPtrGood:
		rts

DYPP_PostRasterised:
		jsr BASECODE_PlayMusic

		inc FrameOf256
		bne DontIncreaseCounter
		inc Frame_256Counter
	DontIncreaseCounter:

	DYPP_ScrollDelay:
		ldx #$00
		beq DoScroll

		dex
		stx DYPP_ScrollDelay + 1
		bne DontDoScroll

		lda #$02
		sta DYPP_ScrollSpeed + 1

	DoScroll:

	DYPP_ScrollXValue:
		lda #$00
		sec
	DYPP_ScrollSpeed:
		sbc #$02
		sta DYPP_ScrollXValue + 1
		bcs DidntCross
		and #$07
		sta DYPP_ScrollXValue + 1

		jsr ScrollTextRead

		ldx DYPP_SetXPositions + 1
		ldy DYPP_PrevXPosition, x
		sty DYPP_SetXPositions + 1
	DidntCross:

	DontDoScroll:

		lda FrameOf256
		and #$01
		sta DYPP_FrameOf2 + 1
		beq DontUpdateXPositions

		jsr DYPP_UpdateXPositions

		jmp DontUpdateScrollText

	DontUpdateXPositions:

		jsr DYPP_SetXPositions

		ldx ZP_ScreenChars
		.for(var ZPIndex = 0; ZPIndex < (DYPP_NumSpriteXPositions - 1); ZPIndex++)
		{
			lda ZP_ScreenChars + ZPIndex + 1
			sta ZP_ScreenChars + ZPIndex
		}
		stx ZP_ScreenChars + (DYPP_NumSpriteXPositions - 1)

		lda DYPP_SetXPositions + 1
	DYPP_PreviousValue:
		cmp #$00
		beq DontUpdateScrollText

		sta DYPP_PreviousValue + 1

	DYPP_WriteChar:
		ldx #$00
		ldy DYPP_PrevXPosition, x
		sty DYPP_WriteChar + 1
	
	DontUpdateScrollText:

		ldx DYPP_FrameOf2 + 1
		lda DYPP_Jump_InitialParts_Lo, x
		sta DYPP_IRQ_InitialPart + 1
		lda DYPP_Jump_InitialParts_Hi, x
		sta DYPP_IRQ_InitialPart + 2

	NotFinishedThisPartYet:
		lda DYPP_Jump_Mains_Lo, x
		sta ZP_IRQJump + 1
		lda DYPP_Jump_Mains_Hi, x
		sta ZP_IRQJump + 2

	DYPP_IRQ_InitialPart:
		jsr DYPP_IRQ_InitialPart_Frame0

	DYPP_TidyUp:
		inc Signal_VBlank

	DYPP_SetMainIRQ:
		lda #D011_Value_25Rows
		sta VIC_D011
		lda #DYPP_YStart
		sta VIC_D012
		lda #$01
		sta VIC_D01A

	DYPP_IRQQuickExit:
		:IRQManager_EndIRQ()
		rti

	DYPP_ScrollText:
		.import binary "..\..\..\..\Intermediate\Built\DYPP\ScrollText.bin"

	FireballXPos:
		.fill $10, $00
		.fill $22, $5c + (3.8 * i)
	FireballYPos:
		.fill $10, $00
		.fill $22, $c0 - (1.35 * i)
