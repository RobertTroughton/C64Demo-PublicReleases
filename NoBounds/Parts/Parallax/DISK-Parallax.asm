//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/Parallax/Parallax.sym"		//Also includes Parallax.sym

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; Parallax -------------------------------------------------------------------------------------------------------
		
		jsr Parallax_Go
		
		jsr IRQLoader_LoadNext		//; Preloading ReflectorTransition to $e000

		lda PartDone				//;Wait for part to finish
		beq *-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda #$00
		sta $d015
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		ldy #$05
		ldx #$00
Src:	lda $e000,x					//; Copy ReflectorTransition to its destination address
Dst:	sta $4000,x
		inx
		bne Src
		inc Src+2
		inc Dst+2
		dey
		bne Src

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END Parallax -------------------------------------------------------------------------------------------------------
