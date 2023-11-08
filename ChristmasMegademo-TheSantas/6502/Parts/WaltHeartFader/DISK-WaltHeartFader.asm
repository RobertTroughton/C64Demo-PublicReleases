//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseWaltHeartFader"

PartDone:
		.byte	$00
Entry:

	//; WaltHeartFader -------------------------------------------------------------------------------------------------------

	.import c64 "HeartPic_HeaderCode.prg"
		
		jsr IRQLoader_LoadNext		//;Preloading next part

		lda	#$03
		ldx	#$10
		jsr	BASE_MusicSync

		lda $d011
		bmi *-3
		lda $d011
		bpl *-3

		jsr LeuatScroller_BYPASS

		jsr IRQLoader_LoadNext		//Loading to $2c00-$4000 -  currently not needed

		lda PartDone
		beq *-3

		lda	#$00
		sta	$d011
		sta	$d015

		:vsync()
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END WaltHeartFader -------------------------------------------------------------------------------------------------------
