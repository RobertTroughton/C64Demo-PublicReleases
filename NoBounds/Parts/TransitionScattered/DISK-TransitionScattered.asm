// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Genesis Project
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
.import source "../../Build/6502/TransitionScattered/TransitionScattered.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	// TransitionScattered -------------------------------------------------------------------------------------------------------
		
		jsr TransitionScatteredStart

		jsr IRQLoader_LoadNext		//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
		beq *-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

	//	lda #$38
	//	sta $dd00

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	// END TransitionScattered -------------------------------------------------------------------------------------------------------
