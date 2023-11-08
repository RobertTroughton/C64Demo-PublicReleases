
.const	PartDone	= $087f

*=$1e80
Start:	sei
		stx	SID1+1
		stx	SID2+1
		sty	SID1+2
		sty	SID2+2
		lda	#$35
		sta	$01
		lda	#$0e
		sta	$d021
		lda	#$d0
		sta	$d016
		lda	#$ba
		sta	$d018
		lda	#$3e
		sta	$dd02
		lda	#$00
		sta	$d012
		lda	#$13
		sta	$d011
		lda	#<irq1
		sta	$fffe
		lda	#>irq1
		sta	$ffff
		asl	$d019
		cli
		rts

irq1:	pha
		txa
		pha
		tya
		pha
		dec	$00
		jsr	$0800

	InitialDelay:
		ldx #75
		beq DelayFinished
		dex
		stx InitialDelay + 1
		jmp Raster1
	DelayFinished:

		jsr	Sub2
		jsr	Sub1
Raster1:	
		lda	#$2e
		ldx	#<irq2
		ldy	#>irq2
irqend:	sta	$d012
		stx	$fffe
		sty	$ffff
		asl	$d019

		pla
		tay
		pla
		tax
		pla
		inc	$00
		rti

irq2:	pha
		txa
		pha
		tya
		pha
		dec	$00
Col2:	ldx	#$0e
		lda	$d012
		cmp	$d012
		beq	*-3
		stx	$d021
Raster2:
		lda	#$fe
		ldx	#<irq3
		ldy	#>irq3
		jmp	irqend

irq3:	pha
		txa
		pha
		tya
		pha
		dec	$00
		ldx	#$01
		lda	$d012
		cmp	$d012
		beq	*-3
		stx	$d021
		lda	#$00
		ldx	#<irq1
		ldy	#>irq1
		jmp	irqend

Sub1:	lda	#$00
		cmp	#$04
		beq	*+6
		inc	Sub1+1
		rts
		lda	#$00
		sta	Sub1+1
SID1:	lda	$0909	
		beq	*+5
SID2:	dec	$0909
		rts

Sub2:	ldx	#$54
		bmi	Sub2End
		lda	#$95
		sec
		sbc	Tab,x
		sta	Raster1+1
		lda	#$97
		clc
		adc	Tab,x
		sta	Raster2+1
		dec	Sub2+1	
		rts

Sub2End:
		lda	#$01
		sta	Col2+1	
		inc	PartDone
		rts

Tab:
.import binary "RasterTab.bin"
