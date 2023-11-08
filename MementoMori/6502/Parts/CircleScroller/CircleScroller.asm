//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= CircleScroller_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp CircleScroller_Init						//; Init
		jmp StartFadeOut							//; MainThreadFunc
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $2000-afff Code+Data
//; - $b000-bfff Shifted Font
//; ---- $cc00-cfff Screen
//; - $d000-d3ff Turn Disk Sprites
//; - $dc00-dfff Screen colours (for fades)
//; - $e000-ff7f Bitmap

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3f7f]
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * 8192))
	.var SpriteVals = ScreenAddress + $3f8

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D016_Value_40Columns = $08

	.var ShiftedFontData = $b000
	.var ScrollText = $c000
	.var ScreenColoursAddress = $dc00

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $f8									//; D000: VIC_Sprite0X
	.byte $ea									//; D001: VIC_Sprite0Y
	.byte $10									//; D002: VIC_Sprite1X
	.byte $ea									//; D003: VIC_Sprite1Y
	.byte $28									//; D004: VIC_Sprite2X
	.byte $ea									//; D005: VIC_Sprite2Y
	.byte $40									//; D006: VIC_Sprite3X
	.byte $ea									//; D007: VIC_Sprite3Y
	.byte $f8									//; D008: VIC_Sprite4X
	.byte $ff									//; D009: VIC_Sprite4Y
	.byte $10									//; D00a: VIC_Sprite5X
	.byte $ff									//; D00b: VIC_Sprite5Y
	.byte $28									//; D00c: VIC_Sprite6X
	.byte $ff									//; D00d: VIC_Sprite6Y
	.byte $40									//; D00e: VIC_Sprite7X
	.byte $ff									//; D00f: VIC_Sprite7Y
	.byte $ee									//; D010: VIC_SpriteXMSB
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

SpriteColourTable:
		.byte $09, $05, $0d, $01
		.fill 24, $01
		.byte $07, $0a, $08, $02

FadeMode:
		.byte $01

//; CircleScroller_Init() -------------------------------------------------------------------------------------------------------
CircleScroller_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		lax #$00
	FillScreenMemory:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta ScreenAddress + (Page * 256), x
		}
		inx
		bne FillScreenMemory

		jsr InitSprites

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #214
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		asl VIC_D019

		cli

		lda #$3b
		sta VIC_D011

		rts

IRQ_Main:
		:IRQManager_BeginIRQ(0, 0)

		jsr BASECODE_PlayMusic

	HasEffectFinishedYet:
		lda #$00
		beq WaitForVBHere0
		lda #$00
		sta VIC_D011
		inc Signal_CurrentEffectIsFinished
		jmp SkipD011Changes

	WaitForVBHere0:
		lda VIC_D012
		cmp #248
		bcc WaitForVBHere0

		lda #D011_Value_24Rows
		sta VIC_D011

	WaitForVBHere:
		lda VIC_D011
		bpl WaitForVBHere

		lda #D011_Value_25Rows
		sta VIC_D011
	SkipD011Changes:

		lda FadeMode
		beq FrameCounter

		cmp #1
		bne DoFadeOut

	DoFadeIn:
		jsr FadeIn
		//; in the case of the fade in, we don't want the scroller to start until the fade in has finished.. so we jump past it
		jmp FinishedDrawCircle

	DoFadeOut:
		jsr FadeOut
		//; in the case of the fade out, the scroller should continue .. so we just fall through to that

	FrameCounter:
		lda #$00
		cmp #$03
		beq DoFrame3
		cmp #$02
		beq DoFrame2
		cmp #$01
		beq DoFrame1

		jsr DrawCircle_Frame3
		jmp FinishedDrawCircle

	DoFrame1:
		jsr DrawCircle_Frame2
		jmp FinishedDrawCircle

	DoFrame2:
		jsr DrawCircle_Frame1
		jmp FinishedDrawCircle

	DoFrame3:
		jsr DrawCircle_Frame0

	ScrollTextRead:
		lda ScrollText
		bpl AllGood
		lda #<ScrollText
		sta ScrollTextRead + 1
		lda #>ScrollText
		sta ScrollTextRead + 2
		lda #$00
	AllGood:
		sta Char095_Frame0 + 1
		sta Char095_Frame1 + 1
		sta Char095_Frame2 + 1
		sta Char095_Frame3 + 1
		inc ScrollTextRead + 1
		bne FinishedDrawCircle
		inc ScrollTextRead + 2
	FinishedDrawCircle:

		inc FrameOf256
		bne NotFrame256
		inc Frame_256Counter
	NotFrame256:

		ldx FrameCounter + 1
		inx
		cpx #4
		bne NotFinalFrame
		ldx #0
	NotFinalFrame:
		stx FrameCounter + 1

		jsr SetSpriteColours

		:IRQManager_EndIRQ()
		rti


InitialSpriteVals:
		.fill 8, 64 + i

InitSprites:
		ldy #7
	SetSpriteValsLoop:
		lda InitialSpriteVals, y
		sta SpriteVals, y
		dey
		bpl SetSpriteValsLoop

		lda #$ff
		sta VIC_SpriteEnable

		rts


SetSpriteColours:
		lda Frame_256Counter
		and #$01
		beq AllBlack
		lda FrameOf256
		cmp #64
		bcc DoFade
	AllBlack:
		lda #$00
		jmp DoColours
	DoFade:
		lsr
		tax
		lda SpriteColourTable, x
	DoColours:
		.for (var Index = 0; Index < 8; Index++)
		{
			sta VIC_Sprite0Colour + Index
		}
		rts

FadeBy3:	.byte $00, $90, $00, $90, $00, $90, $00, $00, $00, $00, $90, $00, $90, $20, $90, $20
FadeBy2:	.byte $00, $40, $00, $40, $90, $20, $00, $20, $90, $00, $20, $00, $20, $40, $20, $80
FadeBy1:	.byte $00, $30, $90, $c0, $20, $80, $00, $50, $20, $00, $80, $90, $40, $30, $40, $50
FadeBy0:	.byte $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0, $f0

FadeIn:

		inc $00
		dec $01

	FadeInIndex:
		ldx #$f0

		cpx #$28
		bcs FadeIn_SkipColumn0
		jsr DoScreenColumn
	FadeIn_SkipColumn0:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeIn_SkipColumn1
		jsr DoScreenColumn_FadeBy1
	FadeIn_SkipColumn1:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeIn_SkipColumn2
		jsr DoScreenColumn_FadeBy2
	FadeIn_SkipColumn2:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeIn_SkipColumn3
		jsr DoScreenColumn_FadeBy3
	FadeIn_SkipColumn3:

		ldx FadeInIndex + 1
		inx
		cpx #$28
		bne FadeIn_NotFinalColumn

		lda #$00
		sta FadeMode
	
	FadeIn_NotFinalColumn:
		stx FadeInIndex + 1

		inc $01
		dec $00

		rts

FadeOut:

		inc $00
		dec $01

	FadeOutIndex:
		ldx #$f0

		cpx #$28
		bcs FadeOut_SkipColumn0
		jsr DoScreenColumn_FadeBy4
	FadeOut_SkipColumn0:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeOut_SkipColumn1
		jsr DoScreenColumn_FadeBy3
	FadeOut_SkipColumn1:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeOut_SkipColumn2
		jsr DoScreenColumn_FadeBy2
	FadeOut_SkipColumn2:

		inx
		inx
		inx
		inx

		cpx #$28
		bcs FadeOut_SkipColumn3
		jsr DoScreenColumn_FadeBy1
	FadeOut_SkipColumn3:

		ldx FadeOutIndex + 1
		inx
		cpx #$28
		bne FadeOut_NotFinalColumn

		inc HasEffectFinishedYet + 1
	
	FadeOut_NotFinalColumn:
		stx FadeOutIndex + 1

		inc $01
		dec $00

		rts

DoScreenColumn_FadeBy4:
		lda #$00
		.for (var Line = 0; Line < 25; Line++)
		{
			sta ScreenAddress + (Line * 40), x
		}
		rts

DoScreenColumn_FadeBy3:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldy ScreenColoursAddress + (Line * 40), x
			lda FadeBy3, y
			sta ScreenAddress + (Line * 40), x
		}
		rts

DoScreenColumn_FadeBy2:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldy ScreenColoursAddress + (Line * 40), x
			lda FadeBy2, y
			sta ScreenAddress + (Line * 40), x
		}
		rts

DoScreenColumn_FadeBy1:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldy ScreenColoursAddress + (Line * 40), x
			lda FadeBy1, y
			sta ScreenAddress + (Line * 40), x
		}
		rts

DoScreenColumn:
		.for (var Line = 0; Line < 25; Line++)
		{
			ldy ScreenColoursAddress + (Line * 40), x
			lda FadeBy0, y
			sta ScreenAddress + (Line * 40), x
		}
		rts

StartFadeOut:

		lda #$02
		sta FadeMode

		lda #$00
		sta Signal_CurrentEffectIsFinished
	WaitForFadeOut:
		lda Signal_CurrentEffectIsFinished
		beq WaitForFadeOut

		jmp BASECODE_SetDefaultIRQ

.import source "../../../Out/6502/Parts/CircleScroller/DrawCircle.asm"
