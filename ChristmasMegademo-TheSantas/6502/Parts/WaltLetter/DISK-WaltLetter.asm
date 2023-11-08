//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseWaltLetter"

PartDone:
		.byte	$00
Entry:

	//; WaltLetter -------------------------------------------------------------------------------------------------------

	.import c64 "Letter_HeaderCode.prg"
		
		jsr	IRQLoader_LoadNext		//;Preloading next part

		lda	PartDone
		beq	*-3

		lda	#$00
		sta	$d011
		sta	$d015

		:vsync()
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		dec	$01

		ldy #$3f
		ldx #$00
	CopyLoop:
		lda $c000,x
		sta $4000,x
		inx
		bne	CopyLoop
		inc	CopyLoop+2
		inc	CopyLoop+5
		dey
		bpl	CopyLoop

		inc	$01

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END WaltLetter -------------------------------------------------------------------------------------------------------
