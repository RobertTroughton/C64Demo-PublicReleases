//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseStreptoColorcycler"

PartDone:
		.byte	$00
Entry:

	//; StreptoColorcycler -------------------------------------------------------------------------------------------------------
		
		jsr StreptoColorcycler_INIT

		:vsync()

		jsr StreptoColorcycler_GO

		//lda	PartDone
		//beq	*-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		lda	#$06
		sta	$08fb
		lda	#$09
		sta	$08fc
		lda	#$0c
		sta	$08fd

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END StreptoColorcycler -------------------------------------------------------------------------------------------------------
