//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/ColourCycle/ColourCycle.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; ColourCycle -------------------------------------------------------------------------------------------------------
		
		:BranchIfNotFullDemo(SkipSync)
		MusicSync(SYNC_TARDISFadeIn-1)
	SkipSync:

		jsr $0400 //; TARDIS_Go

		lda PartDone				//;Wait for part to finish
		beq *-3

		lda #$00
		sta PartDone

		jsr ColourCycle_Go

		//;jsr IRQLoader_LoadNext	//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
		beq *-3
		
		jsr $0403

		lda #$00
		sta PartDone
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

	//; END ColourCycle -------------------------------------------------------------------------------------------------------
