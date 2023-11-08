//----------------------------------
//	MC Plasma by Sparta 2020
//----------------------------------
//	Memory Layout
//
//	0800	2000	Music
//	2000	2dff	Main code
//	2e00	4318	CalcCol1
//	4319	5ff1	CalcCol3
//	5ff2	6e6a	CalcCol2
//	6e6b	6fce	CalcZP
//	6fcf	70b9	ModCalc
//	72ba	7fff	UNUSED
//	8000	83e7	Screen
//	8400	85ff	Sprites
//	8600	867d	Charmap
//	8680	86ff	ColTab0+Coltab1
//	8700	8fff	UNUSED	
//	9000	9fff	Pattern
//	a000	bf3f	Bitmap
//	c000	fff0	UNUSED
//
//----------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

.const	SpriteCol0	=$0c
.const	SpriteCol1	=$06
.const	SpriteCol2	=$0b

.const	ZP1		=$10
.const	ZP2		=$12
.const	Tmp1		=$14
.const	Tmp2		=$15
.const	Tmp3		=$16
.const	Cnt		=$17

.const	ZPCol		=$00		//Actual Tab location: $80-$bf
.const	ZP		=$20		//$20-$6f	($28 ZP vectors)

.const	MusicPlay	=BASECODE_PlayMusic

.const	CalcCol1	=Routines
.const	CalcCol3	=CalcCol1+[8*736]+24+1	//8 bytes/iter, 736 interations, 24 INYs, 1 RTS (Routines+$1719)
.const	CalcCol2	=CalcCol3+[10*736]+24+1	//10 bytes/iter, 736 interations, 24 INYs, 1 RTS (Routines+$33f2)
.const	CalcZP	=CalcCol2+[5*736]+24+1	//5 bytes/iter, 736 interations, 24 INYs, 1 RTS (Routines+$426b)
.const	ModCalc	=CalcZP+[39*9]+5			//(Routines+$43cf)

.const	Charmap	=$8600
.const	ColTab0	=$8600
.const	ColTab1	=ColTab0+$40
.const	Pattern	=$9000
.const	Bitmap	=$c000
.const	Screen	=$e000
.const	Sprites	=$e400
.const	ColRAM	=$d800

.const	PlasmaRaster=$c0

//----------------------------------------------------

*=MCPlasma_BASE	"Main code"

Main:	jmp	PlasmaIn
		jmp	PlasmaOut

PlasmaIn:
		jsr BASECODE_VSync

		jsr	CleanUp

		jsr	AddPtrn
		jsr	MkCalcCol
		jsr	MkCalcZP
		jsr	MkModCalc

		jsr	InitSpr

		lda	#$00
		sta	Signal_CustomSignal0

		jsr BASECODE_VSync

		lda	#$3f		//VIC bank $c000-$ffff
		sta	$dd02
		lda	#$18		//Multicolor
		sta	$d016
		lda	#$80		//Screen: $e000, Bitmap: $c000
		sta	$d018
		
		lda	#<irq00
		sta	$fffe
		lda	#>irq00		
		sta	$ffff
		lda	#$00
		sta	$d012
		
PlasmaLoop1:
		lda	#PlasmaRaster
		cmp	$d012
		bne	*-3

		jsr	Plasma		//Plasma in main code during fade-in

		lda	FldIn+1
		bne	PlasmaLoop1
		rts

PlasmaOut:
PlasmaLoop2:
		lda	#PlasmaRaster
		cmp	$d012
		bne	*-3

		jsr	Plasma		//Plasma in man code again during fade-out

PartDone:	lda	#$00
		beq	PlasmaLoop2

Done:		sei			//Prevent IRQ at the bottom border
		
		lda	#$2b
		cmp	$d012
		bne	*-3
		
		asl	$d019		//Needed to prevent an extra IRQ right after setting the vectors
		
		jsr	BASECODE_SetDefaultIRQ

//----------------------------------

CleanUp:	lda	#$00
		sta	$d015		//Sprites off
		sta	$d017		//Sprite Y-expand off
		ldx	#$13
cu00:		sta	$d03e,x	//Sprite coords + screen off
		cpx #5
		beq SkipWrite
		sta	$d01b,x	//Sprite regs and screen colors
	SkipWrite:
		dex
		bpl	cu00
		rts

//----------------------------------

Plasma:
cx0x:		ldx	#$00
		jsr	ModCalc
		dex
		txa
		and	#$7f
		sta	cx0x+1

cx00:		ldx	Cos+$92
		jsr	CalcX
		ldx	cx00+1
		inx
		cpx	#$e0
		bne	cx01
		ldx	#$00
cx01:		stx	cx00+1

cy00:		lda	Sin+$63
		lsr
		lsr
		clc
		adc	#$06
		tay
		dec	cy00+1

		jsr	CalcCol1	//ColRam
		jsr	ColCycle

cx1x:		ldx	#$05
		jsr	ModCalc
		dex
		txa
		and	#$7f
		sta	cx1x+1

cx10:		ldx	Cos+$57
		jsr	CalcX
		ldx	cx10+1
		dex
		cpx	#$ff
		bne	cx11
		ldx	#$df
cx11:		stx	cx10+1

cy10:		lda	Sin+$4c
		lsr
		lsr
		lsr
		clc
		adc	#$0c
		tay
		inc	cy10+1

CCol2:	jsr	CalcCol2
		//jsr	ColCycle

cx2x:		ldx	#$1d
		jsr	ModCalc
		inx
		inx
		txa
		and	#$7f
		sta	cx2x+1

cx20:		ldx	Cos+$16
		jsr	CalcX
		ldx	cx20+1
		dex
		dex
		cpx	#$fe
		bne	cx21
		ldx	#$de
cx21:		stx	cx20+1

cy20:		lda	Sin+$28
		lsr
		lsr
		lsr
		clc
		adc	#$0c
		tay
		inc	cy20+1
		inc	cy20+1

CCol3:	jsr	CalcCol3
		jmp	ColCycle

//----------------------------------

irq00:	sta	i00_a+1
		stx	i00_x+1
		sty	i00_y+1

		lda	$01
		sta	i00_01+1
		lda	#$35
		sta	$01

		lda	#$ff		//Turn sprites back on
		sta	$d015

		jsr	MusicPlay
		
		lda	Signal_CustomSignal0	//CCPhase+1
		bne	FldOut

FldIn:	ldx	#$7f
		beq	SkipFld

		lda	FldTab,x
		beq	SkipFld

		jsr	FLD

		dec 	FldIn+1
		ldx	FldIn+1
		cpx	#$07
		bne	FldMrg
		ldx	#$00
		stx	FldIn+1
		inc	SkipFld+1
		bne	FldMrg		//Branch ALWAYS, 0 is handled above

//----------------------------		
		
FldOut:	ldx	#$08
		bpl	SkipDone

		lda	#$00			//FLD Out is complete, turn screen off
		sta	$d011
		beq	SkipFld

SkipDone:	lda	FldTab,x
		jsr	FLD

		inc	FldOut+1
		ldx	FldOut+1

//----------------------------

FldMrg:	lda	FldTab,x
		cmp	#$3b
		bcs	i00_done

SkipFld:	lda	#$00
		beq	i00_12
				
		lda	#$00		
		sta	SkipFld+1		

		lda	#PlasmaRaster
		ldx	#<irqc0
		ldy	#>irqc0
		jmp	i00_store

i00_12:	lda	#$fa
		ldx	#<irqfa
		ldy	#>irqfa

i00_store:	sta	$d012
		stx	$fffe
		sty	$ffff

i00_done:	asl	$d019

i00_01:	lda	#$35
		sta	$01
i00_y:	ldy	#$00
i00_x:	ldx	#$00
i00_a:	lda	#$00
		rti

//----------------------------

FLD:		clc
		adc	#$1b
		ldy	#$0f
fld_0:	sta	$d000,y	//Update sprite Y-coords per FLD
		dey
		dey
		bpl	fld_0

		lda	#$2a
		cmp	$d012
		bne	*-3

		ldy	FldTab,x	//Number of FLD lines

fld_1:	lax	$d012		//FLD
		cmp	$d012
		beq	*-3
		and	#$07
		ora	#$30
		cpx	#$3b
		bcs	*+4
		ora	#$08		//24-row mode if FLD is between #$30-#$b8
		sta	$d011		//Otherwise, 25 rows (beginning and end of FLD)
		dey
		bne	fld_1
		rts

//----------------------------------

irqc0:	sta	ic0_a+1
		stx	ic0_x+1
		sty	ic0_y+1
		lda	$01
		sta	ic0_01+1
		lda	#$35
		sta	$01

		lda	#$fa
		sta	$d012
		lda	#<irqfa
		sta	$fffe
		lda	#>irqfa
		sta	$ffff

		asl	$d019
		cli
		
		jsr	Plasma

		lda	Signal_CustomSignal0	//CCPhase+1
		bne	ic0_01

		lda	#PlasmaRaster
		sta	$d012
		lda	#<irqc0
		sta	$fffe
		lda	#>irqc0
		sta	$ffff

ic0_01:	lda	#$35
		sta	$01
ic0_y:	ldy	#$00
ic0_x:	ldx	#$00
ic0_a:	lda	#$00
		rti

//----------------------------------

irqfa:	sta	ifa_a+1
		stx	ifa_x+1
		sty	ifa_y+1
		lda	$01
		sta	ifa_01+1
		lda	#$35
		sta	$01

		lda	$d011
		and	#$f7
		sta	$d011
		ldx	#$00
		stx	$d015		//Turn sprites off
		stx	$d012		//New IRQ at $00

		ldx	#$fc
		cpx	$d012
		bne	*-3

		ora	#$08
		sta	$d011
		lda	#<irq00
		sta	$fffe
		lda	#>irq00
		sta	$ffff
		asl	$d019

ifa_01:	lda	#$35
		sta	$01
ifa_y:	ldy	#$00
ifa_x:	ldx	#$00
ifa_a:	lda	#$00
		rti

//----------------------------------

ColCycle:	ldx	#$00

		txa
		clc
		adc	#$01
		and	#$03
		sta	ColCycle+1

		lda	Signal_CustomSignal0
		bne	FadeOut

fi01:		ldy	#$00
		lda	ColSH,y
		asl
		asl
		asl
		asl
		sta	CCZP+1
		lda	ColC,y
		sta	CC0+1
		lda	ColSL,y
		sta	CC1+1

fi02:		ldy	#$03
		dec	fi02+1
		bpl	fi03
		ldy	#$03
		sty	fi02+1
		inc	fi01+1
		bne	fi03
		inc	Signal_CustomSignal0
		lda	#$fa
		ldx	#<irqfa
		ldy	#>irqfa

fi03:		jmp	CC

FadeOut:	ldy	#$3f
		bpl	*+3

		rts

		dec	FadeOut+1
		bpl	CC

		inc	PartDone+1

//----------------------------

CC:
CCZP:		lda	#$00
		ldy	ZPCol+$83		//(4+4)*16=128-1=127 cycles on ZP
		sta	ZPCol+$80,x
		lda	ZPCol+$bb
		sta	ZPCol+$bc,x
		lda	ZPCol+$b7
		sta	ZPCol+$b8,x
		lda	ZPCol+$b3
		sta	ZPCol+$b4,x
		lda	ZPCol+$af
		sta	ZPCol+$b0,x
		lda	ZPCol+$ab
		sta	ZPCol+$ac,x
		lda	ZPCol+$a7
		sta	ZPCol+$a8,x
		lda	ZPCol+$a3
		sta	ZPCol+$a4,x
		lda	ZPCol+$9f
		sta	ZPCol+$a0,x
		lda	ZPCol+$9b
		sta	ZPCol+$9c,x
		lda	ZPCol+$97
		sta	ZPCol+$98,x
		lda	ZPCol+$93
		sta	ZPCol+$94,x
		lda	ZPCol+$8f
		sta	ZPCol+$90,x
		lda	ZPCol+$8b
		sta	ZPCol+$8c,x
		lda	ZPCol+$87
		sta	ZPCol+$88,x
		sty	ZPCol+$84,x

CC0:		lda	#$00
		sta	ColTab0+$80,x
		lda	ColTab0+$bb,x
		sta	ColTab0+$bc,x
		lda	ColTab0+$b7,x
		sta	ColTab0+$b8,x
		lda	ColTab0+$b3,x
		sta	ColTab0+$b4,x
		lda	ColTab0+$af,x
		sta	ColTab0+$b0,x
		lda	ColTab0+$ab,x
		sta	ColTab0+$ac,x
		lda	ColTab0+$a7,x
		sta	ColTab0+$a8,x
		lda	ColTab0+$a3,x
		sta	ColTab0+$a4,x
		lda	ColTab0+$9f,x
		sta	ColTab0+$a0,x
		lda	ColTab0+$9b,x
		sta	ColTab0+$9c,x
		lda	ColTab0+$97,x
		sta	ColTab0+$98,x
		lda	ColTab0+$93,x
		sta	ColTab0+$94,x
		lda	ColTab0+$8f,x
		sta	ColTab0+$90,x
		lda	ColTab0+$8b,x
		sta	ColTab0+$8c,x
		lda	ColTab0+$87,x
		sta	ColTab0+$88,x
		lda	ColTab0+$83,x
		sta	ColTab0+$84,x

CC1:		lda	#$00
		sta	ColTab1+$80,x
		lda	ColTab1+$bb,x
		sta	ColTab1+$bc,x
		lda	ColTab1+$b7,x
		sta	ColTab1+$b8,x
		lda	ColTab1+$b3,x
		sta	ColTab1+$b4,x
		lda	ColTab1+$af,x
		sta	ColTab1+$b0,x
		lda	ColTab1+$ab,x
		sta	ColTab1+$ac,x
		lda	ColTab1+$a7,x
		sta	ColTab1+$a8,x
		lda	ColTab1+$a3,x
		sta	ColTab1+$a4,x
		lda	ColTab1+$9f,x
		sta	ColTab1+$a0,x
		lda	ColTab1+$9b,x
		sta	ColTab1+$9c,x
		lda	ColTab1+$97,x
		sta	ColTab1+$98,x
		lda	ColTab1+$93,x
		sta	ColTab1+$94,x
		lda	ColTab1+$8f,x
		sta	ColTab1+$90,x
		lda	ColTab1+$8b,x
		sta	ColTab1+$8c,x
		lda	ColTab1+$87,x
		sta	ColTab1+$88,x
		lda	ColTab1+$83,x
		sta	ColTab1+$84,x
		rts

//----------------------------

CalcX:	txa
		lsr
		lsr
		clc
		adc	#>Pattern	//C=0 after this
		tay			//Y=HiByte
		txa
		and	#$03
		tax
		lda	ZPLo,x	//A=LoByte
		tax
		lda	#$ff
		jmp	CalcZP

ZPLo:
.byte	$00,$40,$80,$c0

//----------------------------------

AddPtrn:	dec	$01			//Bitmap is under IO

		lda	#<Bitmap-$f8
		sta	ZP1
		lda	#>Bitmap-$f8
		sta	ZP1+1

		ldx	#$02

		ldy	#$00
ap00:		sty	Cnt
		lda	Charmap,y
		sta	Tmp1
		lda	#$07
		sta	Tmp2

ap01:		asl	Tmp1
		ldy	#$f8
ap02:		lda	#$ff
		bcc	*+5
		lda	RGBPattern,x
		and	(ZP1),y
		sta	(ZP1),y
		dex
		bpl	*+4
		ldx	#$02
		iny
		bne	ap02
		lda	#$08
		jsr	AddZP1
		dec	Tmp2
		bpl	ap01
		ldy	Cnt
		iny
		cpy	#$7d
		bne	ap00

		inc	$01
		
		ldx	#$3f			//Clear Color Tabs
		lda	#$00
ap13:		sta	ZPCol+$80,x
		sta	ColTab0+$80,x
		sta	ColTab1+$80,x
		dex
		bpl	ap13

		rts

//----------------------------------

InitSpr:	ldx	#$07
		ldy	#$97
is00:		lda	#$0c
		sta	$d027,x
		tya
		sta	Screen+$3f8,x
		dey
		dex
		bpl	is00
		lda	#$06
		sta	$d025
		lda	#$0b
		sta	$d026
		ldx	#$0f
		ldy	#$00
is01:		lda	#$00
		sta	$d000,x
		tya
		dex
		sta	$d000,x
		sec
		sbc	#$18
		tay
		dex
		bpl	is01
		lda	#$80
		sta	$d010
		lda	#$ff
		sta	$d015
		sta	$d01c		//MC sprites

		rts

//----------------------------------

AddZP1:	clc
		adc	ZP1
		sta	ZP1
		bcc	*+5
		inc	ZP1+1
		clc
		rts

RGBPattern:
.byte	%10110110		//2
.byte	%11011011		//1
.byte	%01101101		//0

//----------------------------------

MkCalcCol:	lda	#<CalcCol1
		sta	ZP1
		lda	#>CalcCol1
		sta	ZP1+1

		ldx	#$18
		stx	Cnt

		ldy	#$00
		sty	Tmp3
		lda	Charmap,y
		sta	Tmp1
		lda	#$07
		sta	Tmp2

mcr0:		ldx	#$27

mcr1:		asl	Tmp1
		bcc	mcr3
		
		ldy	#<rb03-rb00
mcr2:		lda	rb00,y
		sta	(ZP1),y
		dey
		bpl	mcr2
		lda	#<rb03-rb00
		jsr	AddZP1

mcr3:		lda	rb00+1
		adc	#$02
		sta	rb00+1

		inc	rb02+1
		bne	*+5
		inc	rb02+2

		dec	Tmp2
		bpl	mcr5
		lda	#$07
		sta	Tmp2
		inc	Tmp3
		ldy	Tmp3
		lda	Charmap,y
		sta	Tmp1

mcr5:		dex
		bpl	mcr1

		lda	#ZP
		sta	rb00+1
		lda	#$01
		jsr	AddZP1

mcr6:		dec	Cnt
		bpl	mcr0
		dec	ZP1
		lda	#$60
		ldy	#$00
		sta	(ZP1),y
		inc	ZP1

		lda	ZP1
		sta	CCol3+1
		clc
		adc	#$06
		sta	rb11+1
		lda	ZP1+1
		sta	CCol3+2
		adc	#$00
		sta	rb11+2

//----------------------------

		ldx	#$18
		stx	Cnt

		ldy	#$00
		sty	Tmp3
		lda	Charmap,y
		sta	Tmp1
		lda	#$07
		sta	Tmp2

mcr10:	ldx	#$27

mcr11:	asl	Tmp1
		bcc	mcr13

		ldy	#<rb24-rb20
mcr12:	lda	rb20,y
		sta	(ZP1),y
		dey
		bpl	mcr12
		lda	#<rb24-rb20
		jsr	AddZP1

mcr13:	lda	rb20+1
		adc	#$02
		sta	rb20+1
		
		inc	rb23+1
		bne	*+5
		inc	rb23+2

		dec	Tmp2
		bpl	mcr14
		lda	#$07
		sta	Tmp2
		inc	Tmp3
		ldy	Tmp3
		lda	Charmap,y
		sta	Tmp1

mcr14:	dex
		bpl	mcr11
		lda	#ZP
		sta	rb20+1
		lda	#$01
		jsr	AddZP1

		dec	Cnt
		bpl	mcr10
		dec	ZP1
		lda	#$60
		ldy	#$00
		sta	(ZP1),y
		inc	ZP1

		lda	ZP1
		sta	CCol2+1
		lda	ZP1+1
		sta	CCol2+2

//----------------------------

		ldx	#$18
		stx	Cnt

		ldy	#$00
		sty	Tmp3
		lda	Charmap,y
		sta	Tmp1
		lda	#$07
		sta	Tmp2

mcr7:		ldx	#$27

mcr8:		asl	Tmp1
		bcc	mcr90

		ldy	#<rb12-rb10
mcr9:		lda	rb10,y
		sta	(ZP1),y
		dey
		bpl	mcr9
		lda	#<rb12-rb10
		jsr	AddZP1

		lda	rb11+1
		adc	#<rb24-rb20
		sta	rb11+1
		bcc	*+6
		inc	rb11+2
		clc

mcr90:	lda	rb10+1
		adc	#$02
		sta	rb10+1

		dec	Tmp2
		bpl	mcr91
		lda	#$07
		sta	Tmp2
		inc	Tmp3
		ldy	Tmp3
		lda	Charmap,y
		sta	Tmp1

mcr91:	dex
		bpl	mcr8

		lda	#ZP
		sta	rb10+1
		lda	#$01
		jsr	AddZP1
		inc	rb11+1
		bne	*+5
		inc	rb11+2

		dec	Cnt
		bpl	mcr7

		dec	ZP1
		lda	#$60
		ldy	#$00
		sta	(ZP1),y

		rts

RenderBase0:
rb00:		lax	(ZP),y	//2	5 
rb01:		lda	ColTab0,x	//3	4
rb02:		sta	ColRAM	//3	4
rb03:		iny			//8B	13c

RenderBase1:
rb10:		lda	(ZP),y	//2	5
rb11:		sta	CalcCol3+6	//3	4
rb12:		iny			//5B	9c

RenderBase2:
rb20:		lax	(ZP),y	//2	5
rb21:		lda	ColTab1,x	//3	4
rb22:		ora	ZPCol+$80	//2	3
rb23:		sta	Screen	//3	4
rb24:		iny			//10B	16c

//----------------------------

MkCalcZP:	lda	#<CalcZP
		sta	ZP1
		lda	#>CalcZP
		sta	ZP1+1
		
		ldx	#$26
mcz0:		ldy	#<czb3-czb0
mcz1:		lda	czb0,y
		sta	(ZP1),y
		dey
		bpl	mcz1
		lda	#<czb3-czb0
		jsr	AddZP1
		inc	czb0+1
		inc	czb0+1
		inc	czb1+1
		inc	czb1+1
		dex
		bpl	mcz0
		ldy	#<czb2-czb0
		lda	#$60
		sta	(ZP1),y
		dey
mcz2:		lda	czb0,y
		sta	(ZP1),y
		dey
		bpl	mcz2
		rts

//----------------------------

CZPBase:
czb0:		stx	ZP		//2
czb1:		sty	ZP+1		//2
czb2:		axs	#$c0		//2
		bcc	czb3		//2
		iny			//1
czb3:		rts

//----------------------------

MkModCalc:	ldx	#$ff
mmc0:		lda	Sin2,x
		sec
		sbc	Sin2-1,x
		clc
		adc	#$c0
		sta	Sin2,x
		dex
		bne	mmc0
		lda	#$c0
		sta	Sin2
		
		lda	#<ModCalc
		sta	ZP1
		lda	#>ModCalc
		sta	ZP1+1
		ldx	#$26
mmc1:		ldy	#<mcb2-mcb0
mmc2:		lda	mcb0,y
		sta	(ZP1),y
		dey
		bpl	mmc2
		lda	#<mcb2-mcb0
		jsr	AddZP1
		lda	mcb1+1
		clc
		adc	#<czb3-czb0
		sta	mcb1+1
		bcc	mmc3
		inc	mcb1+2
mmc3:		inc	mcb0+1
		dex
		bpl	mmc1
		rts	

//----------------------------

mcbase:	
mcb0:		lda	Sin2,x
mcb1:		sta	CalcZP+5
mcb2:		rts

//----------------------------

ColC:
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//00-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c	//10-Red-Blue-Gray
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00
.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00

.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b	//30-Doom
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06
.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//50-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$00,$06,$0e,$03,$0e,$06,$0b,$05	//80-Rainbow
.byte	$0d,$05,$09,$02,$08,$0a,$08,$02
.byte	$00,$06,$0e,$03,$0e,$06,$0b,$05
.byte	$0d,$05,$09,$02,$08,$0a,$08,$02
.byte	$00,$06,$0e,$03,$0e,$06,$0b,$05
.byte	$0d,$05,$09,$02,$08,$0a,$08,$02
.byte	$00,$06,$0e,$03,$0e,$06,$0b,$05
.byte	$0d,$05,$09,$02,$08,$0a,$08,$02

.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e	//c0-Aqua
.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e
.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e
.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//e0-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//f0-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

ColSH:
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//00-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c	//10-Red-Blue-Gray
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00
.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00

.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b	//30-Doom
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06
.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//50-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$02,$08,$0a,$08,$02,$04,$0e,$03	//80-Rainbow
.byte	$0e,$06,$0b,$05,$0d,$0d,$05,$0b
.byte	$02,$08,$0a,$08,$02,$04,$0e,$03
.byte	$0e,$06,$0b,$05,$0d,$0d,$05,$0b
.byte	$02,$08,$0a,$08,$02,$04,$0e,$03
.byte	$0e,$06,$0b,$05,$0d,$0d,$05,$0b
.byte	$02,$08,$0a,$08,$02,$04,$0e,$03
.byte	$0e,$06,$0b,$05,$0d,$0d,$05,$0b

.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06	//c0-Aqua
.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06
.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06
.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//e0-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//f0-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

ColSL:
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//00-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c	//10-Red-Blue-Gray
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00
.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00

.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b	//30-Doom
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06
.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b
.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//50-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$0b,$02,$08,$0a,$0a,$08,$02,$0b	//80-Rainbow
.byte	$06,$04,$0e,$03,$03,$0e,$04,$06
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$0b
.byte	$06,$04,$0e,$03,$03,$0e,$04,$06
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$0b
.byte	$06,$04,$0e,$03,$03,$0e,$04,$06
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$0b
.byte	$06,$04,$0e,$03,$03,$0e,$04,$06

.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06	//c0-Aqua
.byte	$06,$0e,$03,$01,$01,$03,$0e,$06
.byte	$06,$0e,$03,$01,$01,$03,$0e,$06
.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06

.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06	//e0-Dawn
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06

.byte	$00,$00,$06,$0e,$0e,$06,$00,$00	//f0-Black Water
.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

//Rainbow
/*
ColC:		//-> ColTab0
.byte	$00,$06,$0e,$03,$0e,$06,$0b,$05
.byte	$0d,$05,$09,$02,$08,$0a,$08,$02
ColSH:	//-> ZPCol
.byte	$02,$08,$0a,$08,$02,$04,$0e,$03
.byte	$0e,$06,$0b,$05,$0d,$0d,$05,$0b
ColSL:	//-> ColTab1
.byte	$0b,$02,$08,$0a,$0a,$08,$02,$0b
.byte	$06,$04,$0e,$03,$03,$0e,$04,$06
*/
//Red-Blue-Grey
//ColC:	//-> ColTab0
//ColSH:	//-> ZPCol
//ColSL:	//-> ColTab1
//.byte	$00,$06,$0e,$0e,$06,$0b,$0c,$0c
//.byte	$0b,$02,$08,$0a,$0a,$08,$02,$00

//Doom
//ColC:	//-> ColTab0
//ColSH:	//-> ZPCol
//ColSL:	//-> ColTab1
//.byte	$02,$08,$0a,$0a,$08,$02,$02,$0b
//.byte	$0b,$06,$04,$0e,$0e,$04,$06,$06

//Flames
//ColC:	//-> ColTab0
//ColSH:	//-> ZPCol
//ColSL:	//-> ColTab1
//.byte	$02,$08,$0a,$0a,$08,$02,$02,$04
//.byte	$0e,$04,$02,$08,$0a,$0a,$08,$02

//Dawn
/*
ColC:		//-> ColTab0
ColSH:	//-> ZPCol
ColSL:	//-> ColTab1
.byte	$06,$04,$0e,$0a,$0a,$0e,$04,$06
.byte	$06,$04,$0e,$0f,$0f,$0e,$04,$06
*/
//Aqua
//ColC:	//-> ColTab0
//.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e
//.byte	$0e,$0b,$05,$0d,$0d,$05,$0b,$0e
//ColSH:	//-> ZPCol
//ColSL:	//-> ColTab1
//.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06
//.byte	$06,$0e,$03,$0f,$0f,$03,$0e,$06

//Black water:
//ColC:	//-> ColTab0
//ColSH:	//-> ZPCol
//ColSL:	//-> ColTab1
//.byte	$00,$00,$06,$0e,$0e,$06,$00,$00
//.byte	$00,$00,$06,$0e,$0e,$06,$00,$00

.align $100

Sin:
*=Sin	"Sin tabs"
.fill $100,64+64*sin(toRadians([i+0.5]*360/128))
Sin2:
.fill $100,8*sin(toRadians([i+0.5]*360/64))
Cos:
.fill $100,12+12*cos(toRadians([i+0.5]*360/112))
FldTab:
.fill $80,$d0-$d0*cos(toRadians([i+0.5]*360/512))

.align $100

Routines:
*=Routines	"Routines"
