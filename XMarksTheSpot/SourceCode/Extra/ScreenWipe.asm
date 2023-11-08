//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

*= ScreenWipe_BASE "ScreenWipe"
		jmp DoScreenWipe

.var SCRWIPE_SinTable = $3000

	SCRWIPE_Mul40Lo:
		.byte <( 0 * 40), <( 1 * 40), <( 2 * 40), <( 3 * 40), <( 4 * 40), <( 5 * 40), <( 6 * 40), <( 7 * 40), <( 8 * 40), <( 9 * 40)
		.byte <(10 * 40), <(11 * 40), <(12 * 40), <(13 * 40), <(14 * 40), <(15 * 40), <(16 * 40), <(17 * 40), <(18 * 40), <(19 * 40)
		.byte <(20 * 40), <(21 * 40), <(22 * 40), <(23 * 40), <(24 * 40)
	SCRWIPE_Mul40Hi:
		.byte >( 0 * 40), >( 1 * 40), >( 2 * 40), >( 3 * 40), >( 4 * 40), >( 5 * 40), >( 6 * 40), >( 7 * 40), >( 8 * 40), >( 9 * 40)
		.byte >(10 * 40), >(11 * 40), >(12 * 40), >(13 * 40), >(14 * 40), >(15 * 40), >(16 * 40), >(17 * 40), >(18 * 40), >(19 * 40)
		.byte >(20 * 40), >(21 * 40), >(22 * 40), >(23 * 40), >(24 * 40)
	SCRWIPE_INV_Mul40Lo:
		.byte <(24 * 40), <(23 * 40), <(22 * 40), <(21 * 40), <(20 * 40)
		.byte <(19 * 40), <(18 * 40), <(17 * 40), <(16 * 40), <(15 * 40), <(14 * 40), <(13 * 40), <(12 * 40), <(11 * 40), <(10 * 40)
		.byte <( 9 * 40), <( 8 * 40), <( 7 * 40), <( 6 * 40), <( 5 * 40), <( 4 * 40), <( 3 * 40), <( 2 * 40), <( 1 * 40), <( 0 * 40)
	SCRWIPE_INV_Mul40Hi:
		.byte >(24 * 40), >(23 * 40), >(22 * 40), >(21 * 40), >(20 * 40)
		.byte >(19 * 40), >(18 * 40), >(17 * 40), >(16 * 40), >(15 * 40), >(14 * 40), >(13 * 40), >(12 * 40), >(11 * 40), >(10 * 40)
		.byte >( 9 * 40), >( 8 * 40), >( 7 * 40), >( 6 * 40), >( 5 * 40), >( 4 * 40), >( 3 * 40), >( 2 * 40), >( 1 * 40), >( 0 * 40)

DoScreenWipe:

		:ClearGlobalVariables() //; nb. corrupts A and X

	SCRWIPE_Loop:
		:IRQ_WaitForVBlank()

		lda #39
		sta SCRWIPE_CharCounter + 1

		ldx FrameOf256
		cpx #(128 + 41)
		bcc SCRWIPE_CharCounter
		cpx #$ff
		bne SCRWIPE_Loop
		rts

	SCRWIPE_CharCounter:
		ldy #39

		cpx #40
		bcc SCRWIPE_SkipChar
		cpx #(128 + 40)
		bcs SCRWIPE_SkipChar

		ldy SCRWIPE_SinTable - 40, x
		cpy #$00
		beq SCRWIPE_SkipChar

		dey

		lda SCRWIPE_Mul40Lo, y
		sta SCRWIPE_ClearScrPtr0 + 1
		sta SCRWIPE_ClearColPtr0 + 1
		lda SCRWIPE_Mul40Hi, y
		and #$03
		ora #$80
		sta SCRWIPE_ClearScrPtr0 + 2
		and #$03
		ora #$d8
		sta SCRWIPE_ClearColPtr0 + 2

		lda SCRWIPE_INV_Mul40Lo, y
		sta SCRWIPE_ClearScrPtr1 + 1
		sta SCRWIPE_ClearColPtr1 + 1
		lda SCRWIPE_INV_Mul40Hi, y
		and #$03
		ora #$80
		sta SCRWIPE_ClearScrPtr1 + 2
		and #$03
		ora #$d8
		sta SCRWIPE_ClearColPtr1 + 2

		ldy SCRWIPE_CharCounter + 1
		lda #$a0
	SCRWIPE_ClearScrPtr0:
		sta $ffff, y
	SCRWIPE_ClearScrPtr1:
		sta $ffff, y

		lda #$0e
	SCRWIPE_ClearColPtr0:
		sta $ffff, y
	SCRWIPE_ClearColPtr1:
		sta $ffff, y

	SCRWIPE_SkipChar:
		inx
		dec SCRWIPE_CharCounter + 1
		bpl SCRWIPE_CharCounter

		jmp SCRWIPE_Loop

		.print "* $" + toHexString(DoScreenWipe) + "-$" + toHexString(EndDoScreenWipe - 1) + " DoScreenWipe"
EndDoScreenWipe:
