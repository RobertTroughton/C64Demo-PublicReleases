//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseRasterFader"

PartDone:
		.byte	$00
Entry:

	//; RasterFader -------------------------------------------------------------------------------------------------------

		lda	$08fb					//;Old color
		ldx	$08fc					//;Intermediate color
		ldy	$08fd					//;New color
		
		jsr RasterFader_GO

		jsr IRQLoader_LoadNext		//;Preload next part

		lda PartDone				//;Wait for fade-out to start
		beq *-3

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

	//; END RasterFader -------------------------------------------------------------------------------------------------------
