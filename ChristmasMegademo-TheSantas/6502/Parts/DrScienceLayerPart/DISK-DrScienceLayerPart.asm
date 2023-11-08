//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseDrScienceLayerPart"

.var SyncPoint = $0400

PartDone:
		.byte	$00
Entry:
	
	//; DrScienceLayerPart -------------------------------------------------------------------------------------------------------
		
		ldx #>SyncPoint
		ldy #<SyncPoint
		lda #$a0
		jsr DrScienceLayerPart_GO_1			//;Start Part1 Show Raster FX

		jsr IRQLoader_LoadNext				//;Load Segments 2-3

		lda PartDone
		beq *-3

		lda #$00
		sta PartDone						//;Clear PartDone flag

		jsr DrScienceLayerPart_GO_2			//;Start Part2 Main Part runs & fades out

		lda PartDone
		beq *-3

		lda #$00
		sta PartDone

		jsr DrScienceLayerPart_GO_3			//;Raster FX OUT
		
		//now Raster FX is playing, some loading of next part can be done from $2000-$ffff
		
		jsr IRQLoader_LoadNext
		
		// When Raster FX is finished, it will set PartDone = 1
		
		lda PartDone
		beq *-3

		lda #$00
		sta PartDone

		// continue....

		sei									//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda	#$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext				//; Load next part, loader returns to address of Entry after job finished

	//; END DrScienceLayerPart -------------------------------------------------------------------------------------------------------
