//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseLeuatXmasFader"

PartDone:
		.byte	$00
Entry:

	//; LeuatXmasFader -------------------------------------------------------------------------------------------------------
		
		:vsync()
		jsr DrScienceToplessFader_GO
		
		lda PartDone
		beq *-3

		lda #$00
		sta $d020
		sta	PartDone

		:vsync()

		jsr	BASE_SetDefaultIRQ

		:vsync()

		jsr LeuatXmasFader_BASE

		//jsr	IRQLoader_LoadNext			//Loading Dr. Science's Topless Santa part

		jsr DrScienceToplessSanta_GO	

		
		lda PartDone
		beq *-3
		
		//sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		//lda #$00
		//sta	$08fb
		//lda #$0e
		//sta	$08fc
		//lda #$06
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
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	Colors:
	.byte $06,$0e,$0c,$0b,$00

	//; END LeuatXmasFader -------------------------------------------------------------------------------------------------------
