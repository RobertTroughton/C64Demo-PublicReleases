//; TODO: make the bob-plot so that we only write to actually affected bytes .. get rid of the top/bottom padding completely!

//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $0400 "InfiniteBobs-FinalFadeOut"

		jmp StartFinalRasterFade

D012Values:	.fill 20, (i * 16)
D011Values:	.fill 16, $00
			.fill 4, $80
RasterBars: .fill 20, $0b

RandomRasterOrder:
			.byte 7, 14, 3, 18, 6, 10, 0, 8, 16, 5, 19, 12, 1, 17, 9, 13, 2, 15, 11, 4
RasterFadeColours:
			.byte $0c, $0f, $01, $0d, $05, $09, $00, $00

FinalRasterFade_MainIRQ:

		pha
		txa
		pha
		tya
		pha

		lda PART_Done
		beq YesDoBarFades
		jmp NoMoreBarFadingToDo

	YesDoBarFades:
		lda $01
		pha
		lda #$35
		sta $01

		ldx #$01
		stx BarIndex + 1
		lda RasterBars + 0
		sta BarColour + 1

		lda #$00
		sta VIC_D011
		sta VIC_D012
		lda #<FinalRasterFade_IRQ
		sta $fffe
		lda #>FinalRasterFade_IRQ
		sta $ffff
		asl VIC_D019
		cli

		jsr BASE_PlayMusic

	RasterBarToFade:
		ldx #$00
		ldy RandomRasterOrder, x
	RasterBarFadeFrame:
		ldx #$00
		lda RasterFadeColours, x
		sta RasterBars, y
		inx
		cpx #7
		bne NotNextBar
		ldx RasterBarToFade + 1
		inx
		stx RasterBarToFade + 1
		cpx #20
		bne NotFinalBar
		inc PART_Done
	NotFinalBar:
		ldx #0
	NotNextBar:
		stx RasterBarFadeFrame + 1

		pla
		sta $01

		pla
		tay
		pla
		tax
		pla
		rti
		
NoMoreBarFadingToDo:
		lda $01
		pha
		lda #$35
		sta $01
		asl VIC_D019

		jsr BASE_PlayMusic

		lda #$00
		jsr BASE_RestoreIRQ

		pla
		sta $01

		pla
		tay
		pla
		tax
		pla
		rti

FinalRasterFade_IRQ:

		IRQManager_BeginIRQ(1, 0)

	BarColour:
		lda #$0b
		sta VIC_BorderColour

	BarIndex:
		ldx #$00
		lda RasterBars, x
		sta BarColour + 1
		lda D012Values, x
		sta VIC_D012
		lda D011Values, x
		sta VIC_D011
		inx
		stx BarIndex + 1
		cpx #20
		bne DontStartFinalRasterFade

		lda #$80
		sta VIC_D011
		lda #$28
		sta VIC_D012
		lda #<FinalRasterFade_MainIRQ
		sta $fffe
		lda #>FinalRasterFade_MainIRQ
		sta $ffff

	DontStartFinalRasterFade:

		IRQManager_EndIRQ()
		rti


StartFinalRasterFade:

	!w:
		bit VIC_D011
		bpl !w-

		sei
		lda #$80
		sta VIC_D011
		lda #$28
		sta VIC_D012
		lda #<FinalRasterFade_MainIRQ
		sta $fffe
		lda #>FinalRasterFade_MainIRQ
		sta $ffff

		asl VIC_D019

		cli

		lda #$00
		sta PART_Done

		jmp IRQLoader_LoadNext
/*
	LoopForever2:
		lda PART_Done				//;Wait for final fade
		beq LoopForever2

	!VB0:
		bit VIC_D011
		bpl !VB0-
	!VB1:
		bit VIC_D011
		bmi !VB1-

		sei
		lda #$00
		sta VIC_D011
		jmp BASE_SetDefaultIRQ_QuickAndClean
*/