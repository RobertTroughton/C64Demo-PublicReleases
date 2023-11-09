//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/TwistScroll/TwistScroll.sym"
.import source "../../Build/6502/TransitionScattered/TransitionScattered.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; TwistScroll -------------------------------------------------------------------------------------------------------

		jsr TransitionScatteredStart

		jsr IRQLoader_LoadNext		//; Load TwistScroll

		jsr Decompress

		lda PartDone				//; Wait for part to finish
		beq *-3

		lda #$00
		sta PartDone

		:BranchIfNotFullDemo(SkipSync)
		MusicSync(SYNC_TwistScroll-1)
	SkipSync:

		vsync()
		
		sei							//; Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		jsr TwistScroll_Go

		jsr IRQLoader_LoadNext		//; Preload CheckerZoomer.prg
		
		lda PartDone				//; Wait for part to finish
		beq *-3
		
		sei							//; Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END TwistScroll -------------------------------------------------------------------------------------------------------
