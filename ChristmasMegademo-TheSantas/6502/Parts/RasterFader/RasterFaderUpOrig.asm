//--------------------------
//	Raster Fader
//--------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"

//ZP usage
.const	ir0a		=$10
.const	ir0x		=$11
.const	ir0y		=$12
.const	ir0z		=$13

.const	ir1a		=$14
.const	ir1x		=$15
.const	ir1y		=$16
.const	ir1z		=$17

.const	ColorTab	=$18

*=$0400

Start:	sta	color1+1		//color0+1
		stx	ColorTab		//color1+1
		sty	ColorTab+1		//color2+1
		lda	$d020
		sta	color0+1
		lda	#$00
		sta	$d011
		ldx	#<irq0
		ldy	#>irq0
		:vsync()
		sta	$d012
		stx	$fffe
		sty	$ffff
		rts

//----------------------------

irq0:		sta	ir0a
		stx	ir0x
		sty	ir0y
		lda	$01
		sta	ir0z
		lda	#$35
		sta	$01
		asl	$d019
color0:	lda	#$00
counter:	ldx	#$c0
		beq	ir0_m
		sta	$d020
		lda	RasterTab-1,x
		asl
		sta	$d012
		arr	#$00
		sta	$d011
		dec	counter+1
		bne	SkipDone
		inc	PART_Done
SkipDone:
		ldx	#<irq1
		ldy	#>irq1
		stx	$fffe
		sty	$ffff
		cli
ir0_m:	jsr	BASE_PlayMusic
		lda	ir0z
		sta	$01
		ldy	ir0y
		ldx	ir0x
		lda	ir0a
		rti

//----------------------------

irq1:		sta	ir1a
		stx	ir1x
		sty	ir1y
		lda	$01
		sta	ir1z
		lda	#$35
		sta	$01
		ldx	#$05
		dex
		bpl	*-1
color1:	lda	#$00
		sta	$d020
		ldy	#$01
colorloop:	ldx	#$22
		dex
		bpl	*-1
		nop
color2:	lda	ColorTab,y
		sta	$d020
		dey
		bpl	ColorLoop

		lda	#$00
		sta	$d011
		sta	$d012
		lda	#<irq0
		sta	$fffe
		lda	#>irq0
		sta	$ffff

		asl	$d019
		lda	ir1z
		sta	$01
		ldy	ir1y
		ldx	ir1x
		lda	ir1a
		rti

ColorTab:
.byte	$00,$00
RasterTab:
.import binary "Data\RasterTab.bin"
