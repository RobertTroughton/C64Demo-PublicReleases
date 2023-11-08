//-------------------------------------
//
//		Snowflake Zoomer
//		 by Sparta 2020
//
//-------------------------------------

//-------------------------------------
//		Memory Map
//
//	0160	0400	Sparkle
//	0400	0600	CalcJmp routine
//	0600	0700	YInv tab
//	0700	0800	XInv tab
//	0800	0900	Base code
//	0900	2000	Music
//	2000	4000	DelPlot routine
//	4000	6000	Bitmap			c000	df40	VIC Bank #$3f
//	6000	6400	Screen map			e000	e400
//	6400	6900	Code				e400	ea00
//	6a00	7000	UNUSED			ea00	f000	0600
//	7000	7800	Bluescreen charset	f000	f800	0800
//	7a00	81eb	JmpTab			f800	ffeb	07ec
//	8200	c0a7	YTab				4000	7ea7	3ea8
//	c0c0	c0ff	MulTab			7ec0	7eff
//	c100	ffa7	XTab				7f00	bda7	3ea8
//
//-------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "Data\Labels.sym"

//-------------------------------------
//		ZP usage
//-------------------------------------

.const	ZP1		=$10
.const	ZP2		=$12
.const	TmrLo		=$14
.const	TmrHi		=$15

.const	DelLo		=$20
.const	DelHi		=$2c
.const	PlotLo	=$38
.const	PlotHi	=$44

.const	YT		=$20
.const	XT		=$40

.const	Raster0	=$60
.const	Raster0D	=$61
.const	Raster0M	=$62
.const	Raster1	=$63
.const	Raster1D	=$64
.const	Raster1M	=$65
.const	Phase		=$66

//-------------------------------------
//		Memory addresses
//-------------------------------------

.const	Bitmap	=$c000
.const	ScrRam	=$e000
.const	BlueScr	=$f000
.const	ColRam	=$d800

.const	CalcJmp	=$0400
.const	DelPlot	=$2000

.const	YInv		=$0600
.const	XInv		=$0700

//.const	JmpTab	=$7400
.const	RowCnt	=JmpTab+$7e0
//.const	YTab		=$7c00
//.const	XTab		=$be00

.const	MulTabLo	=XTab-$40
.const	MulTabHi	=XTab-$20

//----------------------------------

*=SnowflakeZoomer_BASE

Start:
		jmp	Init
		jmp	Go

//----------------------------------
//		IRQ @ $00, Music
//----------------------------------

irq1:		sta	ir1_a+1
		stx	ir1_x+1
		sty	ir1_y+1
		lda	$01
		sta	ir1_1+1
		lda	#$35
		sta	$01
		asl	$d019

		//dec	$d020
		jsr	BASE_PlayMusic
		//inc	$d020

FO_Done:	lda	#$00
		beq	ChkPhase
		
		lda	#$00
		sta	$d011
		beq	ir1_1

ChkPhase:	lda	Phase
		bne	ToIRQ0

		ldx	#<irqr0
		ldy	#>irqr0
		lda	Raster0
		jmp	StoreIRQ

ToIRQ0:	ldx	#<irq0
		ldy	#>irq0
		lda	#$c2
StoreIRQ:	stx	$fffe
		sty	$ffff
		sta	$d012

ir1_1:	lda	#$00
		sta	$01
ir1_a:	lda	#$00	
ir1_x:	ldx	#$00
ir1_y:	ldy	#$00
		rti

//-----------------------------
//		Upper Divider IRQ
//-----------------------------

irqr0:	sta	irr0_a+1
		stx	irr0_x+1
		sty	irr0_y+1
		lda	$01
		sta	irr0_1+1

		lda	#$35
		sta	$01

		asl	$d019

		lda	#$80
		ldy	#$3b
		ldx	#$02
		dex
		bne	*-1	
col0:		ldx	#$01
		sty	$d011		//Switch to bimap
d020_0:	stx	$d020
		sta	$d018

		lda	Raster0D
		bpl	SkipEndCheck
		lda	Raster0
		cmp	Raster0M
		bne	SkipEndCheck

		inc	Phase
		inc	PART_Done	//Part is done
		inc	FO_Done+1

SkipEndCheck:
		lda	Raster1
		bpl	ToIRR1
		sec
		sbc	Raster0
		cmp	#$10
		bcc	SameIRQ

ToIRR1:	lda	#<irqr1
		sta	$fffe
		lda	#>irqr1
		sta	$ffff
		lda	Raster1
		sta	$d012
		bmi	R0
		lda	$d011
		ora	#$80
		sta	$d011
		bmi	R0

SameIRQ:	lda	#<irq1
		sta	$fffe
		lda	#>irq1
		sta	$ffff
		lda	#$00
		sta	$d012

		lda	Raster1
		cmp	$d012
		bne	*-3
		
		lda	#$8c
		ldy	#$1b
		ldx	#$08
		dex
		bpl	*-1	
		sta	$d018		//Switch back to blue screen
		sty	$d011
col1:		lda	#$06
d020_1:	sta	$d020
		
		lda	Raster1
		cmp	Raster1M
		beq	R0
		clc
		adc	Raster1D
		sta	Raster1

R0:		lda	Raster0
		cmp	Raster0M		//#$04
		beq	irr0_m
		sec
		sbc	Raster0D
		sta	Raster0
irr0_c:	cmp	#$1e			//Rasterline where music switches IRQs (#$1e during fade-in, #$22 during fade-out)
		bcs	irr0_1

irr0_m:	lda	PART_Done
		bne	irr0_1

		//dec $d020
		jsr	BASE_PlayMusic
		//inc	$d020

irr0_1:	lda	#$00
		sta	$01
irr0_a:	lda	#$00	
irr0_x:	ldx	#$00
irr0_y:	ldy	#$00
		rti

//-----------------------------
//		Lower Divider IRQ
//-----------------------------

irqr1:	sta	irr1_a+1
		stx	irr1_x+1
		sty	irr1_y+1
		lda	$01
		sta	irr1_z+1

		lda	#$35
		sta	$01

		asl	$d019

		lda	#$8c
		ldy	#$1b
		ldx	#$02
		dex
		bne	*-1	
		nop	
col2:		ldx	#$06
d020_2:	stx	$d020
		sta	$d018		//Switch back to blue screen
		sty	$d011

		lda	Raster1
		clc
		adc	Raster1D
		sta	Raster1
		cmp	Raster1M
		bne	irr1_0

		inc	Phase
		lda	#$fe
		sta	Raster0D
		lda	#$fe
		sta	Raster1D
		lda	#$92
		sta	Raster0M
		lda	#$96
		sta	Raster1M
		lda	#$80
		ldx	#$3b
col3:		ldy	#$01
		sta	$d018
d020_3:	sty	$d020
		stx	ird011+1	
		bne	IR1

irr1_0:	lda	Raster0
		cmp	#$20
		bcs	IR1

irr1_1:	ldx	#<irqr0
		ldy	#>irqr0
		bcc	SetIRQ

IR1:		ldx	#<irq1
		ldy	#>irq1
		lda	#$00
SetIRQ:	stx	$fffe
		sty	$ffff
		sta	$d012
ird011:	lda	#$1b
		sta	$d011

irr1_z:	lda	#$00
		sta	$01
irr1_a:	lda	#$00	
irr1_x:	ldx	#$00
irr1_y:	ldy	#$00
		rti

//-----------------------------
//		Plotter IRQ
//-----------------------------

irq0:		sta	ir0_a+1
		stx	ir0_x+1
		sty	ir0_y+1
		lda	$01
		sta	ir0_1+1
		lda	#$35
		sta	$01
		asl	$d019

		//dec	$d020
		
		lda	#<irq1
		sta	$fffe
		lda	#>irq1
		sta	$ffff
		lda	#$00
		sta	$d012
		cli

		jsr	Plotter

		//inc	$d020
		
		dec	TmrLo
		bne	ir0_1
		dec	TmrHi
		bne	ir0_1
		
		dec	Phase
		inc	PART_Done			//Plotting is done, start fade-out
/*
		lda	#$21
		sta	d020_0+1
		sta	d020_1+1
		sta	d020_2+1
		sta	d020_3+1
		lda	#$01
		sta	col1+1
		sta	col2+1
		lda	#$06
		sta	col0+1
		sta	col3+1
*/
		lda	#$22				//update rasterline where music switches IRQs
		sta	irr0_c+1

		lda	#<irqr0
		sta	$fffe
		lda	#>irqr0
		sta	$ffff
		lda	Raster0
		sta	$d012
		lda	#$1b
		sta	ird011+1
		lda	#$24
		sta	Raster1

ir0_1:	lda	#$00
		sta	$01
ir0_a:	lda	#$00	
ir0_x:	ldx	#$00
ir0_y:	ldy	#$00
		rti

Plotter:		

ir00:		lda	#$00
		eor	#$ff
		sta	ir00+1
		beq	SkipNewK

irx0:		ldx	#$00
		bne	irx2
irx1:		ldy	#$00
		lda	XStep,y
		sta	irx0+1
		lda	XStep+$10,y
		sta	DX+1
		iny
		cpy	#$10
		bne	*+4
		ldy	#$00
		sty	irx1+1

irx2:		lda	ZP1
		clc
DX:		adc	#$00
		bpl	irx3
		clc
		adc	#$0c
		tax
		lda	ZP1+1
		sec
		sbc	#$06
		bcs	*+4
		adc	#$0c
		sta	ZP1+1
		txa
irx3:		cmp	#$0c
		bcc	irx4
		sbc	#$0c
		tax
		lda	ZP1+1
		sec
		sbc	#$06
		bcs	*+4
		adc	#$0c
		sta	ZP1+1
		txa
irx4:		sta	ZP1

		dec	irx0+1

iry0:		ldx	#$00
		bne	iry2
iry1:		ldy	#$00
		lda	YStep,y
		sta	iry0+1
		lda	YStep+$10,y
		sta	DY+1
		iny
		cpy	#$10
		bne	*+4
		ldy	#$00
		sty	iry1+1

iry2:		lda	ZP1+1
		clc
DY:		adc	#$00
		bpl	*+5
		clc
		adc	#$0c
		cmp	#$0c
		bcc	*+4
		sbc	#$0c
		sta	ZP1+1

		dec	iry0+1

SkipNewK:	lda	ZP1
		asl
		asl
		sta	ZP2
		asl
		adc	ZP2
		adc	ZP1+1
		tay

		dec	$01

		jsr	CalcJmp
		lda	#$00
		jsr	DelPlot

		inc	$01
		
		rts

//----------------------------------
//		Init code
//----------------------------------

Init:		jsr	Make

		lda	#$3f
		sta	$dd02
		lda	#$cc	//#$80	
		sta	$d018
		lda	#$18
		sta	$d016
		lda	#$06
		sta	$d021

		ldy	#<BlueScr
		sty	ZP1
		lda	#>BlueScr
		sta	ZP1+1
		tya
		ldx	#$07
bs00:		sta	(ZP1),y
		iny
		bne	*-3
		inc	ZP1+1
		dex
		bpl	bs00

		lda	#$02
		sta	Raster0D
		sta	Raster1D

		lda	#$04
		sta	Raster0M
		
		lda	#$30
		sta	Raster1M
		
		lda	#$92
		sta	Raster0
		lda	#$96
		sta	Raster1

		lda	#$03
		sta	TmrHi
		lda	#$02
		sta	TmrLo
		
		ldy	#$00
		sty	ZP1
		sty	ZP1+1
		sty	ZP2
		sty	Phase

		dec	$01

		jsr	CalcJmp
		lda	#$00
		jsr	DelPlot

		inc	$01

		rts

//----------------------------------

Go:		:vsync()

		//lda	#$06
		//sta	$d020
		lda	#<irqr0
		sta	$fffe
		lda	#>irqr0
		sta	$ffff
		lda	Raster0
		sta	$d012
		lda	#$1b
		sta	$d011
	
Next:		lda	#$c2
		cmp	$d012
		bcs	*-3

		jsr	Plotter

		lda	Phase
		beq	Next

		rts

//----------------------------------

Make:

MkXInv:	ldx	#$00
mx00:		txa
		ldy	#$07
mx01:		lsr
		rol	XInv,x
		dey
		bpl	mx01
		inx
		bne	mx00
		
MkYInv:	ldx	#$00
my00:		txa
		eor	#$ff
		sta	YInv,x
		inx
		bne	my00
	
		jsr	MkDelPlot
		jsr	MkMT
		jmp	MkCalcJmp

//----------------------------------

MkDelPlot:
		lda	#<DelPlot
		sta	ZP1
		lda	#>DelPlot
		sta	ZP1+1
		ldx	#$08		//Make Del Rows 8-11 & 12-15
mdp0:		stx	ZP2		//Forward
		jsr	MkDel
		ldx	ZP2
		inx
		cpx	#$0c
		bne	mdp0
		ldx	#$07		//Make DelPlot Rows 7-4 & 19-16
mdp1:		stx	ZP2		//Backward
		jsr	MkDel
		jsr	AddJmp
		jsr	MkPlot
		ldx	ZP2
		dex
		cpx	#$03
		bne	mdp1
		ldx	#$00		//Make DelPlot Rows 0-3 & 20-23
mdp2:		stx	ZP2		//Forward
		jsr	MkDel
		jsr	AddJmp
		jsr	MkPlot
		ldx	ZP2
		inx
		cpx	#$04
		bne	mdp2
		ldx	#$08		//Make Plot Rows 8-11 & 12-15
mdp3:		stx	ZP2		//Forward
		jsr	Add4c
		jsr	AddJmp
		jsr	MkPlot
		ldx	ZP2
		inx
		cpx	#$0c
		bne	mdp3
		lda	#$02
		jsr	SubZP1
		ldy	#$00
		lda	#$60
		sta	(ZP1),y
		rts

MkDel:	lda	ZP1
		sta.z	DelLo,x
		lda	ZP1+1
		sta.z	DelHi,x
		lda	RowHi,x
		ora	#>Bitmap
		ldy	RowLo,x
		bne	MkDel1

MkDel0:	//sta	db00+1		//sta $2000
		sta	db00+2
		//lda	RowLo+$0c,y
		//sta	db01+1
		lda	RowHi+$0c,x
		ora	#>Bitmap
		sta	db01+2
		lda	RowCnt,x
		tax
md00:		ldy	#<db0x-db00	//$05
md01:		lda	db00,y
		sta	(ZP1),y
		dey
		bpl	md01
		lda	#<db0x-db00	//$06
		jsr	AddZP1
		dex
		bpl	md00
		rts

MkDel1:	sty	db11+1		//sta	$2000,x
		sta	db11+2
		lda	RowLo+$0c,x
		sta	db13+1
		lda	RowHi+$0c,x
		ora	#>Bitmap
		sta	db13+2
		lda	RowCnt,x
		tax
md10:		ldy	#<db1x-db10	//$09
md11:		lda	db10,y
		sta	(ZP1),y
		dey
		bpl	md11
		lda	#<db1x-db10	//$0a
		jsr	AddZP1
		dex
		bpl	md10
		rts

Add4c:	lda	#$02
		jsr	SubZP1
		ldy	#$00
		lda	#$4c
		sta	(ZP1),y
		rts

AddJmp:	lda	ZP1
		clc
		adc	#$03
		ldy	#$01
		sta	(ZP1),y
		iny
		tax
		lda	ZP1+1
		adc	#$00
		sta	(ZP1),y
		stx	ZP1
		sta	ZP1+1
		rts

SubZP1:	sta	sz00+1
		lda	ZP1
		sec
sz00:		sbc	#$00
		sta	ZP1
		bcs	szend
		dec	ZP1+1
		sec
szend:	rts

AddZP1:	clc
		adc	ZP1
		sta	ZP1
		bcc	azend
		inc	ZP1+1
		clc
azend:	rts

MkPlot:	ldx	ZP2
		lda	ZP1
		sta.z	PlotLo,x
		lda	ZP1+1
		sta.z	PlotHi,x
		lda	RowCnt,x
		sta	pb00+1
		lda	RowLo,x
		sta	ZP2+1
		sta	pb04+1
		beq	mp99
		lda	#$40
mp99:		sta	pb05+1
		lda	RowHi,x
		ora	#>Bitmap
		sta	pb04+2
		lda	RowLo+$0c,x
		sta	pb09+1
		lda	RowHi+$0c,x
		ora	#>Bitmap
		sta	pb09+2
		lda.z	DelLo,x
		clc
		adc	#$01
		sta	pb02+1
		lda.z	DelHi,x
		adc	#$00
		sta	pb02+2
		lda	#$04
		ldy	ZP2+1
		beq	mp00
		lda	#$06
mp00:		clc
		adc.z	DelLo,x
		sta	pb06+1
		lda.z	DelHi,x
		adc	#$00
		sta	pb06+2
		txa
		asl
		clc
		adc	#<XT
		sta	pb03+1
		adc	#<YT-XT
		sta	pb01+1
mp01:		ldy	#<pb0x-pb00
mp02:		lda	pb00,y
		sta	(ZP1),y
		dey
		bpl	mp02
		lda	#<pb0a-pb00
		jsr	AddZP1
		lda	#<db0x-db00
		ldx	ZP2+1
		beq	mp03
		lda	#<db1x-db10
mp03:		clc
		adc	pb02+1
		sta	pb02+1
		bcc	mp04
		inc	pb02+2
		clc
mp04:		lda	#<db0x-db00
		ldx	ZP2+1
		beq	mp05
		lda	#<db1x-db10
mp05:		clc
		adc	pb06+1
		sta	pb06+1
		bcc	mp06
		inc	pb06+2
		clc
mp06:		dec	pb00+1
		bpl	mp01
		lda	#<pb0x-pb0a
		jsr	AddZP1
		rts
		
MkMT:		ldy	#$1f
		lda	#$00
		sta	ZP1
		sta	ZP1+1
mm00:		lda	ZP1
		sta	MulTabLo,y
		lda	ZP1+1
		sta	MulTabHi,y
		lda	#$19
		jsr	AddZP1
		dey
		bpl	mm00
		rts

MkCalcJmp:	lda	#<CalcJmp
		sta	ZP1
		lda	#>CalcJmp
		sta	ZP1+1
		lda	#<JmpTab
		sta	cx00+1
		lda	#>JmpTab
		sta	cx00+2
		lda	#<JmpTab+$90
		sta	cx01+1
		lda	#>JmpTab+$90
		sta	cx01+2
		lda	#<JmpTab+$120
		sta	cx10+1
		lda	#>JmpTab+$120
		sta	cx10+2
		ldx	#<XT+2
		ldy	#<YT+2
		stx	cx12+1
		inx
		stx	cx14+1
		sty	cx11+1
		iny
		sty	cx13+1
		
		ldy	#<cx10-cx00	
mc00:		lda	cx00,y	
		sta	(ZP1),y	
		dey	
		bpl	mc00	
		lda	#<cx10-cx00	
		jsr	AddZP1	

		ldx	#$00
mcst:		lda	#$1f
		clc			//!!! (AR=$1f-(RowCnt+1)
		sbc	RowCnt,x
		tay
		clc
		adc	#<MulTabLo
		sta	cx15+1
		tya
		clc
		adc	#<MulTabHi
		sta	cx18+1
		lda.z	PlotLo,x
		sta	cx16+1
		ldy	PlotHi,x
		sty	cx19+1
		sec
		sbc	#$01
		bcs	mc01
		dey
		sec
mc01:		sta	cx1a+1
		sty	cx1a+2
		sbc	#$01
		bcs	mc02
		dey
mc02:		sta	cx17+1
		sty	cx17+2
		cpx	#$0b
		beq	mc06
		
mc04:		ldy	#<cx1x-cx10
mc05:		lda	cx10,y
		sta	(ZP1),y
		dey
		bpl	mc05
		jsr	MCPrep
		inx
		cpx	#$0c
		bne	mcst

mc06:		ldy	#$02
mc07:		lda	cx10,y
		sta	(ZP1),y
		dey
		bpl	mc07
		lda	#$03
		jsr	AddZP1
		ldy	#<cx1x-cx15
mc08:		lda	cx15,y
		sta	(ZP1),y
		dey
		bpl	mc08
		rts
		
MCPrep:	lda	#<cx1x-cx10
		jsr	AddZP1
		lda	cx10+1
		adc	#$90
		sta	cx10+1
		bcc	mcp0
		inc	cx10+2
		clc
mcp0:		ldy	cx13+1
		iny
		sty	cx11+1
		iny
		sty	cx13+1
		ldy	cx14+1
		iny
		sty	cx12+1
		iny
		sty	cx14+1
		ldy	cxy2+1
		iny
		sty	cxy1+1
		iny
		sty	cxy2+1
		rts

CalcXYBase:
cx00:		lda	JmpTab+$000,y
		sta	YT+0
		sta	XT+0
cx01:		lda	JmpTab+$090,y
		sta	YT+1
		adc	#>XTab-YTab
		sta	XT+1

cx10:		lax	JmpTab+$120,y
cxy1:		adc	YT+0
cx11:		sta	YT+2
cx12:		sta	XT+2
		lda	#$00
cxy2:		adc	YT+1
cx13:		sta	YT+3
		adc	#>XTab-YTab
cx14:		sta	XT+3
cx15:		lda	MulTabLo,x
cx16:		adc	#$00
cx17:		sta	$5089
cx18:		lda	MulTabHi,x
cx19:		adc	#$00
cx1a:		sta	$508a
cx1x:		rts

Del0Base:
db00:		sta	Bitmap+$00a4	//4
db01:		sta	Bitmap+$1d60	//4
db0x:		jmp	DelPlot		//8 cycles

Del1Base:
db10:		ldx	#$40			//2
db11:		sta	Bitmap+$0180,x	//5
db12:		ldx	#$40			//2
db13:		sta	Bitmap+$1bc0,x	//5
db1x:		jmp	DelPlot		//14 cycles

PlotBase:						//	Alternative version			Short version
pb00:		ldy	#$00			//2		00	ldy	Cnt		3		00	ldy	Cnt		3	00
pb01:		lax	(YT),y		//5		02	ldx	YT,y		4		02	ldx	YT,y		4	02
pb02:		sta	DelPlot		//4		04	stx	Del		4		05	stx	Del		4	05
pb03:		lda	(XT),y		//5		07	lda	XT,y		4		08	lda	#$80		2	08
pb04:		sta	Bitmap,x		//5		09	sta	$2000,x	5		0b	sta	$2000,x	5	0a
pb05:		ldy	YInv,x		//4		0c	ldy	YInv,x	4		0e	ldy	YInv,x	4	0d
pb06:		sty	DelPlot		//4		0f	sty	Del		4		11	sty	Del		4	10
pb07:		tax				//2		12	tax			2		14	eor	#$ff		2	13
pb08:		lda	XInv,x		//4		13	lda	XInv,y	4		15	sta	$3d00,y	5	15
pb09:		sta	Bitmap+$1d00,y	//5		16	sta	$3d00,y	5		18			33 cycles	18 bytes
pb0a:		lda	#$00			//40 cycles	19 bytes			39 cycles	1b bytes
pb0x:		rts

RowLo:
.byte	$00,$80,$c0,$00,$00,$80,$c0,$00,$00,$80,$c0,$00
.byte	$00,$c0,$80,$00,$00,$c0,$80,$00,$00,$c0,$80,$00
RowHi:
.byte	$00,$01,$02,$04,$05,$06,$07,$09,$0a,$0b,$0c,$0e	
.byte	$1d,$1b,$1a,$19,$18,$16,$15,$14,$13,$11,$10,$0f

//.align $100
//Sin:
//.fill $100,mod(48+48*sin(toRadians([i+0.5]*360/256)),12)
YStep:
.byte	$28,$15,$10,$20,$13,$08,$59,$10,$08,$35,$20,$1f,$55,$10,$08,$12
.byte	$00,$01,$ff,$00,$ff,$00,$01,$ff,$00,$ff,$00,$01,$ff,$01,$00,$ff
XStep:
.byte	$30,$10,$10,$40,$10,$08,$08,$08,$10,$20,$10,$10,$10,$40,$10,$10
.byte	$01,$01,$ff,$01,$00,$01,$ff,$00,$01,$ff,$01,$00,$ff,$01,$ff,$00