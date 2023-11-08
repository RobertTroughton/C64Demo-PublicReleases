//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseLeuatRotatingSantas"

PartDone:
		.byte	$00
Entry:

	//; LeuatRotatingSantas -------------------------------------------------------------------------------------------------------
		
		jsr LeuatRotatingSantas_BASE
		
		sei							//;Disable IRQ and wait til on lower border

		lda	#$35					//;Turn I/O back on as it is left off after part returns
		sta	$01

		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		//lda	#$00
		//sta	$08fb
		//lda	#$0c
		//sta	$08fc
		//lda	#$01
		//sta	$08fd

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END LeuatRotatingSantas ---------------------------------------------------------------------------------------------------
