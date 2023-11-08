//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; TechTechTree -------------------------------------------------------------------------------------------------------
		
		jsr TechTechTree_BASE + GP_HEADER_Init
		jsr TechTechTree_BASE + GP_HEADER_Go

		//;jsr IRQLoader_LoadNext	//;Do some preloading if possible
		
		lda PartDone				//;Wait for part to finish
		beq *-3

		lda	#$00
		sta	$d011
		sta	$d015

		lda	$d012					//;IRQs always cover $100+ raster area, free raster time: 225-250 and 05-46
		bmi	*-3
		lda	$d012
		bpl	*-3

		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3
	
		jsr BASE_Cleanup

		lda	#$08
		sta	$d016

		//lda	#$0a
		//sta	$08fb
		//lda	#$07
		//sta	$08fc
		//lda	#$01
		//sta	$08fd
		
		ldx #$04
	ColorLoop:
		lda Colors,x
		sta $c0,x
		dex
		bpl ColorLoop

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//;Load next part, loader returns to address of Entry after job finished

	Colors:
	.byte $01,$0d,$03,$05,$0f


	//; END TechTechTree -------------------------------------------------------------------------------------------------------
