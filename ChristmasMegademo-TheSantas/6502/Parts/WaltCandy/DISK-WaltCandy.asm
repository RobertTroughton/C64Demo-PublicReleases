//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseWaltCandy"

PartDone:
		.byte	$00
Entry:

	//; WaltCandy -------------------------------------------------------------------------------------------------------

	.import c64 "Candy_HeaderCode.prg"	//;Replaces WaltCandy_INIT and WaltCandy_GO
		
		jsr	IRQLoader_LoadNext			//;Preload next part

		lda	PartDone
		beq	*-3

		lda	#$00
		sta	$d011
		sta	$d015

		:vsync()
		
		sei								//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		ldx #$04						//;Preps for Walt's transition effect
	ColorLoop:
		lda Colors,x
		sta $c0,x
		dex
		bpl ColorLoop

		lda	#<SteelComingHomeVolume
		sta	$08fe
		lda #>SteelComingHomeVolume
		sta	$08ff

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	Colors:
	.byte $0b,$0e,$03,$0d,$01

	//; END WaltCandy -------------------------------------------------------------------------------------------------------
