//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\Earth\Earth.sym"		//Also includes Earth.sym

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; Earth -------------------------------------------------------------------------------------------------------

		jsr EarthInit_Go

		jsr IRQLoader_LoadNext
		
		lsr PartDone
		bcc *-3

		jsr Earth_Go

		lsr PartDone				//;Wait for part to finish
		bcc *-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda #$00
		sta $d015
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END Earth -------------------------------------------------------------------------------------------------------
