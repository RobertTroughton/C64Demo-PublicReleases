//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/CheckerZoomer/CheckerZoomer.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; CheckerZoomer -------------------------------------------------------------------------------------------------------
			
		ldy #$03
		ldx #$00
Src1:	lda $8800,x
Dst1:	sta $0400,x
Src4:	lda $9d00,x
Dst4:	sta $a800,x
		inx
		bne Src1
		inc Src1+2
		inc Dst1+2
		inc Src4+2
		inc Dst4+2
		dey
		bne Src1

		ldy #$11
Src2:	lda $8b00,x
Dst2:	sta $7d00,x
		inx
		bne Src2
		inc Src2+2
		inc Dst2+2
		dey
		bne Src2

Src3:	lda $9c00,x
Dst3:	sta $a400,x
		inx
		bne Src3

		jsr IRQLoader_LoadNext		//;Load Tables

		jsr CheckerZoomer_Go

		jsr IRQLoader_LoadNext		//;Load Bitmap #1
		jsr IRQLoader_LoadNext		//;Load Bitmap #2

		lda PartDone				//;Wait for game to finish
		beq *-3
		
		lda #$00
		sta PartDone

		jsr IRQLoader_LoadNext		//;Preload PlotCubeIntro

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

	//; END CheckerZoomer -------------------------------------------------------------------------------------------------------
