//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/Trailblazer/Trailblazer.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; Trailblazer -------------------------------------------------------------------------------------------------------
		
		ldy #$0b					//Copy preloaded main prg to its mem address
		ldx #$00
Src:	lda $4000,x
Dst:	sta $8f00,x
		inx
		bne Src
		inc Src+2
		inc Dst+2
		dey
		bpl Src

		jsr TrailblazerIntro_Go

		jsr IRQLoader_LoadNext		//;Preloading PlasmaVector
		
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

	//; END Trailblazer -------------------------------------------------------------------------------------------------------
