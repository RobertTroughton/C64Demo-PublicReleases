//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const TechTechStart = $9700
.const TransitionSquaresStart = $fc10

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	// TechTech -------------------------------------------------------------------------------------------------------
        
		ldy #$05					//; Copy Preloaded TransitionSquares from $2000 to $f800
		ldx #$00
Src:	lda $2000,x
Dst:	sta $f800,x
		inx
		bne Src
		inc Src+2
		inc Dst+2
		dey
		bne Src

		jsr TransitionSquaresStart

        jsr IRQLoader_LoadNext

        lda PartDone				//; Wait for part to finish
		beq *-3

        lda #0 
        sta PartDone

		jsr TechTechStart

		//;jsr IRQLoader_LoadNext	//; Do some preloading if possible
		
		lda PartDone				//; Wait for part to finish
		beq *-3
		
		sei							//; Disable IRQ and wait til on lower border
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

	//; END TechTech -------------------------------------------------------------------------------------------------------
