//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseDrScienceTextDisplayer2"

PartDone:
		.byte	$00
Entry:

	//; DrScienceTextDisplayer2 -------------------------------------------------------------------------------------------------------
		
		jsr DrScienceTextDisplayer2_GO

		jsr IRQLoader_LoadNext			//;Load Leuat's XmasFader and Muscle Santa

		lda #$80						//;Delay
		jsr DrScienceTextDisplayer2_END

		//lda PartDone					//;Wait for fade-out to finish
		//beq *-3

		lda #$00
		sta PartDone					//;Clear PartDone flag

		sei								//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda #$08
		sta $d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext			//;Load next part, loader returns to address of Entry after job finished

	//; END DrScienceTextDisplayer2 -------------------------------------------------------------------------------------------------------
