//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbasePerplexSnow"

.var LogoCount	= 5
.var InitDelay	= $d0				//$1d0 frames before first logo
.var LogoDelay	= $e0				//$e0 frames between logos
PartDone:
		.byte	$00
Entry:

	//; PerplexSnow -------------------------------------------------------------------------------------------------------
		ldy #InitDelay
		ldx #LogoDelay
		jsr PerplexSnow_INIT
		jsr PerplexSnow_GO

	LogoCtr:
		ldx	#LogoCount-1			//;First logo is preloaded

		//-------------------------------------------------

	LogoLoop:
		lda	PartDone
		beq	*-3

		jsr	IRQLoader_LoadNext

		lda	#$00
		sta	PartDone

		dec	LogoCtr+1
		bne	LogoLoop

		//-------------------------------------------------

		jsr	IRQLoader_LoadNext		//;Preloading next part

		lda	PartDone
		beq	*-3
		
		lda	#$00
		sta	$d011
		sta	$d015

		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		lda	#$01
		sta	$08fb
		lda	#$02
		sta	$08fc
		lda	#$00
		sta	$08fd

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END PerplexSnow -------------------------------------------------------------------------------------------------------
