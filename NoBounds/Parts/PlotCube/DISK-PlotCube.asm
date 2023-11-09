//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/PlotCube/PlotCube.sym"

* = DISK_BASE "diskbaseA"

.const PlotCubeIntro_Go	= $e600

PartDone:
		.byte	$00
Entry:

	//; PlotCube -------------------------------------------------------------------------------------------------------

		:BranchIfNotFullDemo(SkipSync)
		MusicSync(SYNC_PlotCube)
	SkipSync:
		
		jsr PlotCubeIntro_Go
		
		jsr PlotCube_Go
		
		lda PartDone				//;Wait for part to finish
		beq *-3

		lda #$00
		sta PartDone

		jsr IRQLoader_LoadNext		//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
		beq *-3
		
		sei							//;Disable IRQ and wait for lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END PlotCube -------------------------------------------------------------------------------------------------------
