//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/BigDXYCP/BigDXYCP.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; BigDXYCP -------------------------------------------------------------------------------------------------------

		jsr BigDXYCP_Go

		jsr IRQLoader_LoadNext		//;Load the main BigDXYCP data

		jsr Decompress
	
		jsr BigDXYCP_Go2

		lda PartDone				//;Wait for part to finish
		beq *-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END BigDXYCP -------------------------------------------------------------------------------------------------------
