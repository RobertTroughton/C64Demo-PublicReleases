//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseWaltBasicWipe_NoMusic"

PartDone:
		.byte	$00
Entry:

	//; WaltBasicWipe_NoMusic -------------------------------------------------------------------------------------------------------

	.import c64 "Wipe_HeaderCode.prg"
		
		lda	PartDone
		beq	*-3

		lda	#$00
		sta	$d011
		sta	$d015

		:vsync()
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr	IRQLoader_LoadNext		//Load Digi
		
		jsr TrapDigiLamer_BASE		//; Play digi only if disk started from Basic...

		ldx #$09
		jsr BASE_InitMusic

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END WaltBasicWipe_NoMusic -------------------------------------------------------------------------------------------------------
