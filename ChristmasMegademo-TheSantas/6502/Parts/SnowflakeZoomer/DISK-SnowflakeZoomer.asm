//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseSnowflakeZoomer"

PartDone:
		.byte	$00
Entry:

	//; SnowflakeZoomer -------------------------------------------------------------------------------------------------------
		
		jsr SnowflakeZoomer_BASE + GP_HEADER_Init
		jsr SnowflakeZoomer_BASE + GP_HEADER_Go

		lda PartDone				//;Wait for fade-out to start
		beq *-3

		dec	PartDone				//;Clear PartDone flag

		jsr IRQLoader_LoadNext		//;Preload next part

		lda	PartDone				//;Wait for fade-out to finish
		beq	*-3

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

	//; END SnowflakeZoomer -------------------------------------------------------------------------------------------------------
