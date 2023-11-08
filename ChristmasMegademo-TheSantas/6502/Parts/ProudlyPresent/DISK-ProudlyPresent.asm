//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; ProudlyPresent -------------------------------------------------------------------------------------------------------
		
		jsr ProudlyPresent_BASE + 0

		jsr IRQLoader_LoadNext	//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
		beq *-3

		lda	#$00
		sta	$d011
		sta	$d015

		lda	$d012					//;IRQs always cover $100+ raster area, free raster time: 225-250 and 05-46
		bmi	*-3
		lda	$d012
		bpl	*-3

		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3
	
		jsr BASE_Cleanup

		lda	#$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//;Load next part, loader returns to address of Entry after job finished

	//; END ProudlyPresent -------------------------------------------------------------------------------------------------------
