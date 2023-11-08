//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = StarWars_BASE "Star Wars Scroller"

		jmp SW_Init

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0200-023f Demo Main Driver
//; - $0800-08ff Disk Side Driver
//; - $0a00-0bff Nucrunch
//; - $0c00-0dff Spindle
//; - $0e00-0eff Spindle (used while loading)
//; - $0f00-0fbf Base Code
//; ---- $0fc0-0fff Global Variables

//; - $1000-1fff Music

//; - $2800-2bff Main code
//; - $2c00-7fff Plot Code + Data
//; - $b800-bfff ScrollText
//; - $c000-c1ff Water SinWave
//; - $c200-c3ff Remapped Font
//; ---- $c800-cbff Screen
//; ---- $cc00-dfff Scroll buffers
//; ---- $e000-ff3f Bitmap (nb. only bottom 10 lines currently used)

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var WaterSinWave = $c100
	.var RemappedFont = $c200
	.var ScrollText = $bb00
	.var ScrollData = $cc00

	.var SW_FadeInYSinTableLo = $2400
	.var SW_FadeInYSinTableHi = $2500
	.var SW_FadeOutYSinTableLo = $2600
	.var SW_FadeOutYSinTableHi = $2700

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 2 //; Bank+[0800,0bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * $400))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * $2000))

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)
	.var D016Value = $08

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
	.byte D016Value								//; D016: VIC_D016
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
	.byte $06									//; D021: VIC_ScreenColour
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

SW_FadeMode:
	.byte $01	//; Fade-in
SW_FrameOf256:
	.byte $00
SW_Signal_Midpoint:
	.byte $00

.align 64
SW_D016Values:
	.fill 40, $00
SW_INCClamp3:
	.byte 1, 2, 3, 3
SW_FrameCounterTable:
	.byte 1, 2, 0				//; 25fps update .. 1, 2, 0 would be 16.666fps
SW_FontLookupTableLo:
	.fill 16, <(RemappedFont + (i * 32))
SW_FontLookupTableHi:
	.fill 16, >(RemappedFont + (i * 32))
SW_ScrollINCMod:
	.byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 0

//; SW_Init() -------------------------------------------------------------------------------------------------------
SW_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		lda #$34
		sta $01

		ldx #$00
		ldy #20
		txa
	ClearScrollDataLoop:
		sta ScrollData + (0 * 256), x
		inx
		bne ClearScrollDataLoop
		inc ClearScrollDataLoop + 2
		dey
		bne ClearScrollDataLoop

		ldx #$00
		ldy #31
		txa
	ClearBitmapDataEndPartLoop:
		sta BitmapAddress + (31 * 256) - 64, x
		inx
		bne ClearBitmapDataEndPartLoop
	ClearBitmapDataLoop:
		sta BitmapAddress + (0 * 256), x
		inx
		bne ClearBitmapDataLoop
		inc ClearBitmapDataLoop + 2
		dey
		bne ClearBitmapDataLoop

		ldx #$00
	ClearScreenDataLoop:
		lda #$1e
		sta ScreenAddress + 0, x
		sta ScreenAddress + 200, x
		sta ScreenAddress + 400, x
		lda #$e6
		sta ScreenAddress + 600, x
		sta ScreenAddress + 800, x
		inx
		cpx #200
		bne ClearScreenDataLoop

		ldx #39
	ClearScreenDataLoop2:
		lda #$16
		sta ScreenAddress + 480, x
		lda #$f6
		sta ScreenAddress + 520, x
		lda #$c6
		sta ScreenAddress + 560, x
		dex
		bpl ClearScreenDataLoop2

		lda #$35
		sta $01

		:vsync()

		sei
		jsr SW_SetFadeInTopIRQ
		asl VIC_D019 //; Acknowledge VIC interrupts
		cli

	SW_WaitForFadeIn:
		lda SW_FadeMode
		bne SW_WaitForFadeIn

		lda #$34
		sta $01

	SW_Draw:
		jsr StarWars_Plot_BASE
		jsr SW_UpdateScrollText
		dec Signal_CustomSignal0

	SW_WaitForFadeOutToStart:
		lda SW_FadeMode
		beq SW_Draw

		lda #$35
		sta $01

		lda #$00
		sta SW_Signal_Midpoint

	WaitForMidpointArea:
		lda SW_Signal_Midpoint
		beq WaitForMidpointArea

		jsr SW_SetFadeOutTopIRQ

	SW_WaitForEnd:
		lda SW_FadeMode
		bne SW_WaitForEnd

		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ

//; SW_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SW_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 0)

		lda #$0e
		sta VIC_BorderColour

		lda #$08
 		sta VIC_D016

		jsr BASECODE_PlayMusic

	SW_FrameCounter:
		ldx #$00
		ldy SW_FrameCounterTable, x
		sty SW_FrameCounter + 1
		cpy #$00
		bne SW_DontUpdateScroll

		ldx Signal_CustomSignal0
		lda SW_INCClamp3, x
		sta Signal_CustomSignal0
	SW_DontUpdateScroll:

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		jsr SW_SetMidpointIRQ
		:IRQManager_EndIRQ()

		rti

//; SW_IRQ_Midpoint() -------------------------------------------------------------------------------------------------------
SW_IRQ_Midpoint:

		:IRQManager_BeginIRQ(1, 0)

		nop
		lda #$06
		sta VIC_BorderColour

		inc SW_Signal_Midpoint
		
		jsr SW_SetBottomIRQ
		:IRQManager_EndIRQ()

		rti

//; SW_IRQ_Bottom() -------------------------------------------------------------------------------------------------------
SW_IRQ_Bottom:

		:IRQManager_BeginIRQ(1, 0)

		ldx #$00

	BottomLoop:
		lda SW_D016Values + 0, x
 		sta VIC_D016
		
		ldy #$01
	BottomDelayLoop0:
		dey
		bne BottomDelayLoop0
		nop $ff
		nop $ff

		lda SW_D016Values + 1, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop1:
		dey
		bne BottomDelayLoop1
		nop
		nop

		lda SW_D016Values + 2, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop2:
		dey
		bne BottomDelayLoop2
		nop
		nop

		lda SW_D016Values + 3, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop3:
		dey
		bne BottomDelayLoop3
		nop
		nop

		lda SW_D016Values + 4, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop4:
		dey
		bne BottomDelayLoop4
		nop
		nop

		lda SW_D016Values + 5, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop5:
		dey
		bne BottomDelayLoop5
		nop
		nop

		lda SW_D016Values + 6, x
 		sta VIC_D016

		ldy #$0a
	BottomDelayLoop6:
		dey
		bne BottomDelayLoop6
		nop
		nop

		lda SW_D016Values + 7, x
 		sta VIC_D016

		ldy #$07
	BottomDelayLoop8:
		dey
		bne BottomDelayLoop8
		nop $ff
		nop $ff

		txa
		clc
		adc #$08
		tax
		cmp #(8 * 5)
		bne BottomLoop

		ldx #00
	WaterSinePos:
		ldy #$00
	UpdateWaterSines0:
		lda WaterSinWave, y
		sta SW_D016Values, x
		tya
		clc
		adc #$03
		and #$3f
		tay
		inx
		cpx #10
		bne UpdateWaterSines0
	UpdateWaterSines1:
		lda WaterSinWave + 64, y
		sta SW_D016Values, x
		tya
		clc
		adc #$03
		and #$3f
		tay
		inx
		cpx #20
		bne UpdateWaterSines1
	UpdateWaterSines2:
		lda WaterSinWave + 128, y
		sta SW_D016Values, x
		tya
		clc
		adc #$03
		and #$3f
		tay
		inx
		cpx #30
		bne UpdateWaterSines2
	UpdateWaterSines3:
		lda WaterSinWave + 192, y
		sta SW_D016Values, x
		tya
		clc
		adc #$03
		and #$3f
		tay
		inx
		cpx #40
		bne UpdateWaterSines3

		lda WaterSinePos + 1
		clc
		adc #$01
		and #$3f
		sta WaterSinePos + 1

		jsr SW_SetVBlankIRQ
		:IRQManager_EndIRQ()

		rti

SW_SetVBlankIRQ:
		lda #$3b
		sta VIC_D011
		lda #$00
		sta VIC_D012
		lda #<SW_IRQ_VBlank
		sta $fffe
		lda #>SW_IRQ_VBlank
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_SetMidpointIRQ:
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #146
		sta VIC_D012
		lda #<SW_IRQ_Midpoint
		sta $fffe
		lda #>SW_IRQ_Midpoint
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_SetBottomIRQ:
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #178
		sta VIC_D012
		lda #<SW_IRQ_Bottom
		sta $fffe
		lda #>SW_IRQ_Bottom
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_UpdateScrollText:
		ldx #0
		iny

		lda SW_ScrollINCMod, x
		sta SW_UpdateScrollText + 1

		cpx #16
		bcc SW_RegularScrollText

		lda #$ff
		cpx #16
		bne SW_Not16
		lda #$00
	SW_Not16:

	SW_FontWriteBlankPtr:
		.for(var Line = 0; Line < 20; Line++)
		{
			sta ScrollData + (Line * $100), y
		}

		cpx #26
		bne SW_NotLastOne

		lda SW_ScrollTextPtr + 1
		clc
		adc #20
		sta SW_ScrollTextPtr + 1
		lda SW_ScrollTextPtr + 2
		adc #$00
		sta SW_ScrollTextPtr + 2

	SW_NotLastOne:
		jmp SW_FinishedLine

	SW_RegularScrollText:
		lda SW_FontLookupTableLo, x
		sta SW_FontReadPtr + 1
		lda SW_FontLookupTableHi, x
		sta SW_FontReadPtr + 2

		lda #>(ScrollData + (0 * $100))
		sta SW_FontWritePtr + 2

		lda #$00
		sta $f0

	SW_UpdateTextLineLoop:
		ldx $f0
	SW_ScrollTextPtr:
		lda ScrollText, x
		bpl SW_FontRead

	//; loop the scrolltext?
		inc SW_FadeMode

		lda #<ScrollText
		sta SW_ScrollTextPtr + 1
		lda #>ScrollText
		sta SW_ScrollTextPtr + 2
		jmp SW_ScrollTextPtr

	SW_FontRead:
		tax

	SW_FontReadPtr:
		lda RemappedFont, x
	SW_FontWritePtr:
		sta ScrollData + (0 * $100), y

		inc $f0

		inc SW_FontWritePtr + 2
		lda SW_FontWritePtr + 2
		cmp #>(ScrollData + (20 * $100))
		bne SW_UpdateTextLineLoop

	SW_FinishedLine:

		rts

SW_IRQ_FadeIn_Top:
		:IRQManager_BeginIRQ(0, 0)

		lda #$0e
		sta VIC_BorderColour

		jsr BASECODE_PlayMusic

		jsr SW_SetFadeInBottomIRQ

		inc Signal_VBlank

		:IRQManager_EndIRQ()
		rti

SW_IRQ_FadeIn_Bottom:
		:IRQManager_BeginIRQ(1, 0)

		lda #$06
		sta VIC_BorderColour

		inc SW_FrameOf256
		bne SW_FI_Not256
		jsr SW_SetVBlankIRQ
		dec SW_FadeMode
		jmp SW_FI_FinishedBottom

	SW_FI_Not256:
		jsr SW_SetFadeInTopIRQ

	SW_FI_FinishedBottom:
		:IRQManager_EndIRQ()

		rti

SW_SetFadeInTopIRQ:
		lda #$80
		sta VIC_D011
		lda #(304 - 256)
		sta VIC_D012
		lda #<SW_IRQ_FadeIn_Top
		sta $fffe
		lda #>SW_IRQ_FadeIn_Top
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_SetFadeInBottomIRQ:
		ldy SW_FrameOf256
		lda SW_FadeInYSinTableLo, y
		sta VIC_D012
/*		lda VIC_D011
		and #$7f
		ora SW_FadeInYSinTableHi, y*/
		lda SW_FadeInYSinTableHi, y
		sta VIC_D011
		lda #<SW_IRQ_FadeIn_Bottom
		sta $fffe
		lda #>SW_IRQ_FadeIn_Bottom
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_IRQ_FadeOut_Top:
		:IRQManager_BeginIRQ(0, 0)

		lda #$0e
		sta VIC_BorderColour

		jsr SW_SetFadeOutBottomIRQ

		inc Signal_VBlank

		:IRQManager_EndIRQ()
		rti

SW_IRQ_FadeOut_Bottom:
		:IRQManager_BeginIRQ(1, 0)

		lda #$06
		sta VIC_BorderColour

		jsr BASECODE_PlayMusic

		inc SW_FrameOf256
		bne SW_FO_Not256
		jsr SW_SetVBlankIRQ
		dec SW_FadeMode
		jmp SW_FO_FinishedBottom

	SW_FO_Not256:
		jsr SW_SetFadeOutTopIRQ

	SW_FO_FinishedBottom:
		:IRQManager_EndIRQ()

		rti

SW_SetFadeOutTopIRQ:
		lda #$80
		sta VIC_D011
		lda #(304 - 256)
		sta VIC_D012
		lda #<SW_IRQ_FadeOut_Top
		sta $fffe
		lda #>SW_IRQ_FadeOut_Top
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

SW_SetFadeOutBottomIRQ:
		ldy SW_FrameOf256
		lda SW_FadeOutYSinTableLo, y
		sta VIC_D012
		lda SW_FadeOutYSinTableHi, y
		sta VIC_D011
		lda #<SW_IRQ_FadeOut_Bottom
		sta $fffe
		lda #>SW_IRQ_FadeOut_Bottom
		sta $ffff
		lda #$01
		sta VIC_D01A
		rts

