//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseQzerowYellowSnow"

PartDone:
		.byte	$00
Entry:

	//; QzerowYellowSnow -------------------------------------------------------------------------------------------------------
		
		jsr QzerowYellowSnow_INIT

		jsr QzerowYellowSnow_GO

		jsr	IRQLoader_LoadNext		//;Preloading Christmas Ball

		lda PartDone
		beq *-3

		lda #$00
		sta $d011
		sta $d015

		//:vsync()
		
		sei							//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda #$08
		sta $d016

		lda	#$0a
		sta	$08fb
		lda	#$02
		sta	$08fc
		lda	#$00
		sta	$08fd

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	Colors:
//	.byte $00,$02,$08,$07,$01

	//; END QzerowYellowSnow -------------------------------------------------------------------------------------------------------
