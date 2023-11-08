//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseNextSide"

PartDone:
		.byte	$00
Entry:

	//; NextSide -------------------------------------------------------------------------------------------------------

		jsr IRQLoader_LoadNext	//;Wait for next side
		
		//inc	PartDone			//;Signal to IRQ next side detected

		//lda PartDone			//;Wait for part to finish
		//bne *-3

		sei						//;Disable IRQ
		lda	$d011				//;Wait til on lower border
		bpl	*-3

		lda	#$0b
		sta	$d011

		lda	#$00
		sta	$d418

		jsr IRQLoader_LoadNext	//;Load next music

		lda	$d011				//;Wait til on lower border
		bpl	*-3
	
		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		sei

		ldx #$09
		jsr BASE_InitMusic

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		lda	#$03
		jmp IRQLoader_LoadA	//; Load next part, loader returns to address of Entry after job finished



	//; END NextSide -------------------------------------------------------------------------------------------------------
