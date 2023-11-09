//; (c) 2018-2019, Genesis*Project

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "Star Wars Scroller"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-b00d Code + Data
//; - $c800-cbff Screen
//; ---- $ce00-dfff Scroll buffers
//; - $e000-e3bf ScrollText
//; ---- $e3c0-fcbf Bitmap (nb. only bottom 10 lines currently used)
//; - $fd00-feff Remapped Font

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var ScrollText = $e000
	.var RemappedFont = $fd00
	.var ScrollData = $ce00

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 2 //; Bank+[0800,0bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * $400))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)
	.var D016Value = $08

	.var ZP_ScrollTextPtr = $40

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $28									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $58									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $88									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $b8									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $e8									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $18									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $20									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $3f									//; D015: VIC_SpriteEnable
	.byte D016Value								//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $3f									//; D01B: VIC_SpriteDrawPriority
	.byte $3f									//; D01C: VIC_SpriteMulticolourMode
	.byte $3f									//; D01D: VIC_SpriteDoubleWidth
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

SW_FrameOf256:
	.byte $00
SW_Signal_Midpoint:
	.byte $00
SW_Finished:
	.byte $00

SW_ScrollINCMod:
	.byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 0


.import source "..\..\Build\6502\StarWars\SW-Uniques.asm"
.import source "..\..\Build\6502\StarWars\SW-Plot.asm"

//; StarWars_Go() -------------------------------------------------------------------------------------------------------
StarWars_Go:

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		bit VIC_D011
		bpl *-3
		bit VIC_D011
		bmi *-3

		sei
		jsr SW_SetVBlankIRQ
		asl VIC_D019 //; Acknowledge VIC interrupts
		lda #$01
		sta VIC_D01A
		cli

		dec $01

		lda #$ff

		//; fill 5*$140 ($640) to 20*$140 ($1900)
		ldy #$00
	ClearBuffersLoopPre:
		.for (var i = $05; i < $1a; i++)
		{
			sta BitmapAddress + i * $100, y
		}
		sta BitmapAddress + $1940, y
		iny
		bne ClearBuffersLoopPre

		ldy #$00
		lda #$80
	ClearBuffersLoop1:
		sta ScrollData, y
		iny
		bne ClearBuffersLoop1

		inc $01

		ldy #$06
		lda #48
	SetSpriteValsLoop:
		sta SpriteVals, y
		dey
		bpl SetSpriteValsLoop

		lda #<ScrollText
		sta ZP_ScrollTextPtr + 0
		lda #>ScrollText
		sta ZP_ScrollTextPtr + 1

		MACRO_SetVICBank(BaseBank)

		bit VIC_D011
		bpl *-3
		bit VIC_D011
		bmi *-3

		lda #$3b
		sta VIC_D011
		
		MusicSync($0380)

		dec $01

	SW_Draw:
		jsr StarWarsPlotter
		jsr SW_UpdateScrollText

		lda SW_Finished
		beq SW_Draw

		inc PART_Done

		inc $01

		rts

//; SW_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SW_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 0)

		lda #BGColourTop
		sta VIC_BorderColour

		lda #$08
 		sta VIC_D016

		jsr SW_SetSpriteRow0

		jsr SW_SetSpriteRow1IRQ
		:IRQManager_EndIRQ()

		rti

//; SW_IRQ_Midpoint0() -------------------------------------------------------------------------------------------------------
SW_IRQ_Midpoint0:

		:IRQManager_BeginIRQ(1, -6)

		.for (var i = 0; i < 16; i++)
		{
			nop
		}
		nop $ff

		lda #BGColourMid
		sta VIC_BorderColour

		inc SW_Signal_Midpoint
		
		jsr SW_SetMidpoint1IRQ
		:IRQManager_EndIRQ()

		rti

//; SW_IRQ_Midpoint1() -------------------------------------------------------------------------------------------------------
SW_IRQ_Midpoint1:

		:IRQManager_BeginIRQ(1, -6)

		.for (var i = 0; i < 16; i++)
		{
			nop
		}
		nop $ff

		lda #BGColourBottom
		sta VIC_BorderColour

		jsr SW_SetSpriteRow3IRQ
		:IRQManager_EndIRQ()

		rti

SW_IRQ_Bottom:

		:IRQManager_BeginIRQ(1, 0)

		lda #BGColourOuter
		sta VIC_BorderColour

		jsr BASE_PlayMusic

		jsr SW_SetVBlankIRQ
		:IRQManager_EndIRQ()

		rti

SW_SetVBlankIRQ:
		lda #$32
		sta VIC_D012
		lda #<SW_IRQ_VBlank
		sta $fffe
		lda #>SW_IRQ_VBlank
		sta $ffff
		rts

SW_SetSpriteRow1IRQ:
		lda #$70
		sta VIC_D012
		lda #<SW_IRQ_SpriteRow1
		sta $fffe
		lda #>SW_IRQ_SpriteRow1
		sta $ffff
		rts

SW_SetSpriteRow2IRQ:
		lda #$8a
		sta VIC_D012
		lda #<SW_IRQ_SpriteRow2
		sta $fffe
		lda #>SW_IRQ_SpriteRow2
		sta $ffff
		rts

SW_SetSpriteRow3IRQ:
		lda #$a3
		sta VIC_D012
		lda #<SW_IRQ_SpriteRow3
		sta $fffe
		lda #>SW_IRQ_SpriteRow3
		sta $ffff
		rts

SW_SetSpriteRow4IRQ:
		lda #$bb
		sta VIC_D012
		lda #<SW_IRQ_SpriteRow4
		sta $fffe
		lda #>SW_IRQ_SpriteRow4
		sta $ffff
		rts

SW_SetMidpoint0IRQ:
		lda #$91
		sta VIC_D012
		lda #<SW_IRQ_Midpoint0
		sta $fffe
		lda #>SW_IRQ_Midpoint0
		sta $ffff
		rts

SW_SetMidpoint1IRQ:
		lda #$99
		sta VIC_D012
		lda #<SW_IRQ_Midpoint1
		sta $fffe
		lda #>SW_IRQ_Midpoint1
		sta $ffff
		rts

SW_SetBottomIRQ:
		lda #$fa
		sta VIC_D012
		lda #<SW_IRQ_Bottom
		sta $fffe
		lda #>SW_IRQ_Bottom
		sta $ffff
		rts

SW_UpdateScrollText:
		ldy #0
		inx

		lda SW_ScrollINCMod, y
		sta SW_UpdateScrollText + 1

		cpy #16
		bcc SW_RegularScrollText

		lda #$ff
		cpy #16
		bne SW_Not16
		lda #$00
	SW_Not16:

	SW_FontWriteBlankPtr:
		.for(var Line = 0; Line < 18; Line++)
		{
			sta ScrollData + (Line * $100), x
		}

		cpy #18
		bne SW_NotLastOne

		lda ZP_ScrollTextPtr + 0
		clc
		adc #SCROLLTEXT_LINE_LENGTH
		sta ZP_ScrollTextPtr + 0
		bcc SW_NotLastOne
		inc ZP_ScrollTextPtr + 1

	SW_NotLastOne:
		rts

	SW_RegularScrollText:
		lda SW_FontLookupTableLo, y
		sta SW_FontReadPtr + 1
		lda SW_FontLookupTableHi, y
		sta SW_FontReadPtr + 2

		lda #>(ScrollData + (0 * $100))
		sta SW_FontWritePtr + 2

		ldy #$00
		sty $f0
		lda (ZP_ScrollTextPtr), y
		bpl SW_UpdateTextLineLoop_0
		cmp #$ff
		bne SW_DoBlankLine
		
		:BranchIfNotFullDemo(LoopForever)
		inc SW_Finished
	LoopForever:
		lda #<ScrollText
		sta ZP_ScrollTextPtr + 0
		lda #>ScrollText
		sta ZP_ScrollTextPtr + 1

	SW_DoBlankLine:
		lda #$80
		sta ScrollData + (0 * $100), x
		rts

	SW_UpdateTextLineLoop:
		lda (ZP_ScrollTextPtr), y
	SW_UpdateTextLineLoop_0:
		tay

	SW_FontReadPtr:
		lda RemappedFont,y
	SW_FontWritePtr:
		sta ScrollData + (0 * $100), x

		inc SW_FontWritePtr + 2
		ldy $f0
		iny
		sty $f0
		cpy #18
		bne SW_UpdateTextLineLoop

	SW_FinishedLine:
		rts


SW_SetSpriteRow0:
		
		lda #$03
		ldx #$30
		ldy #$5b

		.for (var i = 0; i < 6; i++)
		{
			sta VIC_Sprite0Colour + i
			stx SpriteVals + i
			sty VIC_Sprite0Y + (i * 2)
		}
		lda #$05
		sta VIC_SpriteExtraColour0
		lda #$0c
		sta VIC_SpriteExtraColour1
		
		rts

SW_IRQ_SpriteRow1:
		
		:IRQManager_BeginIRQ(0, 0)

		ldx #$31
		ldy #$75

		.for (var i = 0; i < 6; i++)
		{
			stx SpriteVals + i
			sty VIC_Sprite0Y + (i * 2)
		}
		lda #$0d
		sta VIC_SpriteExtraColour0
		
		jsr SW_SetSpriteRow2IRQ
		:IRQManager_EndIRQ()

		rti

SW_IRQ_SpriteRow2:
		
		:IRQManager_BeginIRQ(0, 0)

		lda #$07
		ldx #$32
		ldy #$8e

		.for (var i = 0; i < 6; i++)
		{
			sta VIC_Sprite0Colour + i
			stx SpriteVals + i
			sty VIC_Sprite0Y + (i * 2)
		}
		lda #$0d
		sta VIC_SpriteExtraColour0
		
		jsr SW_SetMidpoint0IRQ
		:IRQManager_EndIRQ()

		rti

SW_IRQ_SpriteRow3:
		
		:IRQManager_BeginIRQ(0, 0)

		lda #$01
		ldx #$33
		ldy #$a6

		.for (var i = 0; i < 6; i++)
		{
			sta VIC_Sprite0Colour + i
			stx SpriteVals + i
			sty VIC_Sprite0Y + (i * 2)
		}
		lda #$07
		sta VIC_SpriteExtraColour0
		lda #$0c
		sta VIC_SpriteExtraColour1
		
		jsr SW_SetSpriteRow4IRQ
		:IRQManager_EndIRQ()

		rti

SW_IRQ_SpriteRow4:
		
		:IRQManager_BeginIRQ(0, 0)

		lda #$0e
		ldx #$34
		ldy #$c1

		.for (var i = 0; i < 6; i++)
		{
			sta VIC_Sprite0Colour + i
			stx SpriteVals + i
			sty VIC_Sprite0Y + (i * 2)
		}
		lda #$0c
		sta VIC_SpriteExtraColour0
		
		jsr SW_SetBottomIRQ
		:IRQManager_EndIRQ()

		rti

