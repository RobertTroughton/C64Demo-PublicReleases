//; (c) 2018-2019, Genesis*Project

.align 16
FadeTablesLo:
		.byte ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1)
		.byte ($04 *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1)
		.byte ($02 *  1), ($0f *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($04 *  1), ($0a *  1), ($0a *  1), ($04 *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1), ($0a *  1)
		.byte ($09 *  1), ($07 *  1), ($04 *  1), ($0c *  1), ($0a *  1), ($0c *  1), ($0b *  1), ($0f *  1), ($0a *  1), ($02 *  1), ($0a *  1), ($04 *  1), ($0a *  1), ($0f *  1), ($0c *  1), ($0a *  1)
		.fill 16, i
FadeTablesHi:
		.byte ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16)
		.byte ($04 * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16)
		.byte ($02 * 16), ($0f * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a *  1), ($04 * 16), ($0a * 16), ($0a * 16), ($04 * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16), ($0a * 16)
		.byte ($09 * 16), ($07 * 16), ($04 * 16), ($0c * 16), ($0a * 16), ($0c * 16), ($0b * 16), ($0f * 16), ($0a * 16), ($02 * 16), ($0a * 16), ($04 * 16), ($0a * 16), ($0f * 16), ($0c * 16), ($0a * 16)
		.fill 16, (i * 16)

DoFades:
		ldx #0

		lda FrameOf256
		and #$01
		beq DoItAll
		rts
	DoItAll:
		lda #$00
		beq DoFadeIn
		jmp DoFadeOut

	DoFadeIn:
		lda #<(FadeTablesLo + (16 * 4))
		sta $f0
		lda #>(FadeTablesLo + (16 * 4))
		sta $f1
		lda #<(FadeTablesHi + (16 * 4))
		sta $f2
		lda #>(FadeTablesHi + (16 * 4))
		sta $f3
		jsr ColourLineUsingFadeTable
		inx

		lda #<(FadeTablesLo + (16 * 3))
		sta $f0
		lda #>(FadeTablesLo + (16 * 3))
		sta $f1
		lda #<(FadeTablesHi + (16 * 3))
		sta $f2
		lda #>(FadeTablesHi + (16 * 3))
		sta $f3
		jsr ColourLineUsingFadeTable

		inx
		lda #<(FadeTablesLo + (16 * 2))
		sta $f0
		lda #>(FadeTablesLo + (16 * 2))
		sta $f1
		lda #<(FadeTablesHi + (16 * 2))
		sta $f2
		lda #>(FadeTablesHi + (16 * 2))
		sta $f3
		jsr ColourLineUsingFadeTable

		inx
		lda #<(FadeTablesLo + (16 * 1))
		sta $f0
		lda #>(FadeTablesLo + (16 * 1))
		sta $f1
		lda #<(FadeTablesHi + (16 * 1))
		sta $f2
		lda #>(FadeTablesHi + (16 * 1))
		sta $f3
		jsr ColourLineUsingFadeTable
		jmp FinishedFade

	DoFadeOut:
		lda #<(FadeTablesLo + (16 * 0))
		sta $f0
		lda #>(FadeTablesLo + (16 * 0))
		sta $f1
		lda #<(FadeTablesHi + (16 * 0))
		sta $f2
		lda #>(FadeTablesHi + (16 * 0))
		sta $f3
		jsr ColourLineUsingFadeTable
		inx

		lda #<(FadeTablesLo + (16 * 1))
		sta $f0
		lda #>(FadeTablesLo + (16 * 1))
		sta $f1
		lda #<(FadeTablesHi + (16 * 1))
		sta $f2
		lda #>(FadeTablesHi + (16 * 1))
		sta $f3
		jsr ColourLineUsingFadeTable

		inx
		lda #<(FadeTablesLo + (16 * 2))
		sta $f0
		lda #>(FadeTablesLo + (16 * 2))
		sta $f1
		lda #<(FadeTablesHi + (16 * 2))
		sta $f2
		lda #>(FadeTablesHi + (16 * 2))
		sta $f3
		jsr ColourLineUsingFadeTable

		inx
		lda #<(FadeTablesLo + (16 * 3))
		sta $f0
		lda #>(FadeTablesLo + (16 * 3))
		sta $f1
		lda #<(FadeTablesHi + (16 * 3))
		sta $f2
		lda #>(FadeTablesHi + (16 * 3))
		sta $f3
		jsr ColourLineUsingFadeTable

	FinishedFade:
		lda #$00
		ldx DoFades + 1
		inx
		stx DoFades + 1
		cpx #37
		bne NotFinishedThis
		lda DoItAll + 1
		eor #$01
		sta DoItAll + 1
		lda #$00
		sta DoFades + 1
		lda #$ff
	NotFinishedThis:

		rts

ColourLineUsingFadeTable:

		.for(var YVal = 0; YVal < 25; YVal++)
		{
			ldy ScreenAddressOrig + (YVal * 40), x
			lda ($f0), y
			sta VIC_ColourMemory + (YVal * 40), x

			ldy ColourDataLo + (YVal * 40), x
			lda ($f0), y
			ldy ColourDataHi + (YVal * 40), x
			ora ($f2), y
			sta ScreenAddress0 + (YVal * 40), x
			sta ScreenAddress1 + (YVal * 40), x
		}

		rts

