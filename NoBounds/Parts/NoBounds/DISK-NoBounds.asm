//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/NoBounds/NoBounds.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; NoBounds -------------------------------------------------------------------------------------------------------

.if (FINAL_RELEASE_DEMO == 0)
{
		:BranchIfFullDemo(SkipStandalonePreload)
		jsr IRQLoader_LoadNext
	SkipStandalonePreload:
}
		bit	$d011
		bpl	*-3
		bit	$d011
		bmi	*-3

//;		jsr IRQLoader_LoadNext

		jsr NoBounds_Go

		lda #$00
		sta PartDone

	LoopForever:
		lda PartDone				//; Wait for part to finish
		bne FinishedThisPart
		lda $0400
		beq LoopForever
		jsr IRQLoader_LoadNext		//; The last loader call in this loop preloads FadeFromNoBounds.prg and RasterData
		dec $0400
		jmp LoopForever
		
	FinishedThisPart:
		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp $c000

	//; END NoBounds -------------------------------------------------------------------------------------------------------
