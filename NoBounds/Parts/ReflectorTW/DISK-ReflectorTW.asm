// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Genesis Project
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const ReflectorTWStart = $9b00
.const ReflectorTransitionStart = $4000

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	// ReflectorTW -------------------------------------------------------------------------------------------------------
		

		:BranchIfNotFullDemo(SkipSync)
		MusicSync(SYNC_ReflectorTW) 
	SkipSync:

		jsr ReflectorTransitionStart

		jsr IRQLoader_LoadNext		//;Load ReflectorTW
		
		lda PartDone				//;Wait for part to finish
		beq *-3

		lda #0						//;Clear part done flag
		sta PartDone

		jsr ReflectorTWStart

		jsr IRQLoader_LoadNext		//;Background loading tunnel #1
		jsr IRQLoader_LoadNext		//;Background loading tunnel #2

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

	// END ReflectorTW -------------------------------------------------------------------------------------------------------
