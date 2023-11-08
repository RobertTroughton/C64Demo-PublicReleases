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

	//; MarchingSnowflakes2 -------------------------------------------------------------------------------------------------------
		
		jsr MarchingSnowflakes2_BASE + GP_HEADER_Init
		jsr MarchingSnowflakes2_BASE + GP_HEADER_Go

		//jsr IRQLoader_LoadNext		//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
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
		jmp IRQLoader_LoadNext		//;Load next part, loader returns to address of Entry after job finished

	//; END MarchingSnowflakes2 -------------------------------------------------------------------------------------------------------
