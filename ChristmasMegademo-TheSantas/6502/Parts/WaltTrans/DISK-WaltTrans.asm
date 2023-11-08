//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseWaltTrans"

PartDone:
		.byte	$00
Entry:

	//; WaltLetter -------------------------------------------------------------------------------------------------------

	.import c64 "WaltTrans_HeaderCode.prg"
		
		jsr IRQLoader_LoadNext		//;Preloading next part

		lda PartDone
		beq *-3

		sei							//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup
		
		lda #$08
		sta $d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END WaltTrans -------------------------------------------------------------------------------------------------------
