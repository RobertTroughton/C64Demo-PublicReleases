//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseDrScienceBox"

PartDone:
		.byte	$00
Entry:

	//; DrScienceBox -------------------------------------------------------------------------------------------------------
		
		jsr DrScienceBoxFader_BASE

		jsr IRQLoader_LoadNext			//;Load Box Main effect

		lda PartDone					//;Wait for fade-out to finish
		beq *-3

		lda #$00
		sta PartDone					//;Clear PartDone flag

		jsr DrScienceBoxMain_BASE		//;Box Main code, will return when fade-out FX starts

		jsr IRQLoader_LoadNext			//;Preload next part to $2000-$ffff

		lda PartDone					//;Wait for Box fade-out FX to finish
		beq *-3

		sei								//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext			//; Load next part, loader returns to address of Entry after job finished

	//; END DrScienceBox -------------------------------------------------------------------------------------------------------
