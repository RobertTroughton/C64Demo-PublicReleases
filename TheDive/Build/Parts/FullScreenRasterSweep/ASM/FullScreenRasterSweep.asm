//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = FullScreenRasterSweep_BASE "Full Screen Raster Sweep"

		jmp FSRS_Main

RasterColourTables:

 .align 16
		.byte $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00
		.byte $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00
		.byte $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00
		.byte $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00

 .align 2
FSRS_ColourValues:
		.byte $00, $00

		.var NumBars = 18
		.var NumFramesInTotal = NumBars + 6

D011Table:
	.fill NumBars, (>(294 - (i + 1) * 16)) * 128
	.fill 6, 0
D012Table:
	.fill NumBars, <(298 - (i + 1) * 16)
	.fill 6, 0
StartLineTable:
	.fill NumBars, $00
	.byte $10, $20, $30, $40, $50, $60
NumLinesToDrawTable:
	.byte $10, $20, $30, $40, $50, $60
	.fill NumBars, $70

FSRS_Main:

		jsr FSRS_Init

	FSRS_MainLoop:
		lda Signal_VBlank
		beq FSRS_MainLoop

		lda #$00
		sta Signal_VBlank

		jsr BASECODE_PlayMusic

		lda Signal_CurrentEffectIsFinished
		beq FSRS_MainLoop

		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ

FSRS_Init:

		stx FSRS_ColourValues + 0 //; Start Colour
		sty FSRS_ColourValues + 1 //; End Colour

		jsr BASECODE_ClearGlobalVariables

		lda #$00
		sta VIC_SpriteEnable
		sta FrameCounter + 1

		:IRQ_WaitForVBlank()

		sei

		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #(302 - 256)
		sta VIC_D012
		lda #<FSRS_IRQ_VBlank
		sta $fffe
		lda #>FSRS_IRQ_VBlank
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli
		rts

FSRS_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		lda FSRS_ColourValues + 0
		sta VIC_BorderColour

		inc Signal_VBlank

		inc FrameOf256

	FrameCounter:
		ldx #$00
		lda D011Table, x
		sta VIC_D011
		lda D012Table, x
		sta VIC_D012
		lda StartLineTable, x
		sta StartLine + 1
		lda NumLinesToDrawTable, x
		sta NumLinesToDraw + 1
		inx
		cpx #NumFramesInTotal
		bne NotFinishedAnimationYet
		inc Signal_CurrentEffectIsFinished
		jmp DontAdvanceAnim
	NotFinishedAnimationYet:
		stx FrameCounter + 1
	DontAdvanceAnim:
		lda #<FSRS_IRQ
		sta $fffe
		lda #>FSRS_IRQ
		sta $ffff
		lda #$01
		sta VIC_D01A

		:IRQManager_EndIRQ()
		rti

FSRS_IRQ:

		:IRQManager_BeginIRQ(1, 0)

	StartLine:
		ldy #$00
	NextRasterLine:
		ldx RasterColourTables, y
		lda FSRS_ColourValues, x
		sta VIC_BorderColour

		ldx #$07
	PerLineWait:	
		dex
		bpl PerLineWait
		nop $ff

		iny
	NumLinesToDraw:
		cpy #$10
		bne NextRasterLine

		lda FSRS_ColourValues + 1
		sta VIC_BorderColour

		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #(302 - 256)
		sta VIC_D012
		lda #<FSRS_IRQ_VBlank
		sta $fffe
		lda #>FSRS_IRQ_VBlank
		sta $ffff
		lda #$01
		sta VIC_D01A

		:IRQManager_EndIRQ()
		rti
