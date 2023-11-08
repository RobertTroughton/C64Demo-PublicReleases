//-----------------------------------
//	3D Animated Plot Skull
//	Preparation Phase
//	By Sparta 2020
//-----------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

.const	Main		=$2000

.const	Screen	=$dc00
.const	ColRAM	=$d800
.const	Load		=IRQLoader_LoadNext
.const	Preps		=$5000
.const	MusicPlay	=$0803
.const	BmpLoad	=$a000
.const	Bitmap	=$e000
.const	CalcJmp	=$2540
.const	DelPlot	=$2800
.const	MulTab	=$4a00
.const	RowMax	=$4a60
.const	JmpTab	=$4a80
.const	XTab		=$5000
.const	BTab		=$9600

.const	ZP1		=$10		//-$11
.const	ZP2		=$12		//-$13
.const	PlotAdd	=$14		//-$15
.const	Tmp		=$16
.const	LoadDone	=$17
.const	PartDone	=$18
.const	PartPhase	=$19
.const	FadeOut	=$1a
.const	FadeIn	=$1b
.const	PlotLo	=$20
.const	PlotHi	=$40
.const	XT		=$60
.const	BT		=$88

.const	RowCnt	=20		//NOT a ZP address

*=$5000	"Preparations"

Start:
		jsr BASECODE_VSync

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

		sta	FadeIn
		sta	FadeOut
		sta	PartDone
		sta	LoadDone
		lda	#$02		//Number of repetitions of animation sequence before part is finished
		sta	PartPhase

		ldy	#$00
		sty	ZP1		//Delete $e000-$ff40
		lda	#>Bitmap
		sta	ZP1+1
		ldx	#$1e
		tya
pr00:		sta	(ZP1),y
		iny
		bne	pr00
		inc	ZP1+1
		dex
		bpl	pr00
		ldy	#$3f
pr01:		sta	$ff00,y
		dey
		bpl	pr01

		//jsr	Load		//Loads Bitmap - not needed, loaded in one at the beginning

		jsr BASECODE_VSync

		lda	#$3f		//VIC bank $c000-$ffff
		sta	$dd02
		lda	#$18		//Multicolor
		sta	$d016
		lda	#$78		//Screen: $dc00, Bitmap: $e000
		sta	$d018
		lda	#$3b		//Show bitmap
		sta	$d011

		lda	#$00		//Find max row size and update MkCalcJmp with max value
		ldx	#<RowCnt-1
rm00:		cmp	RowMax,x
		bcs	*+5
		lda	RowMax,x
		dex
		bpl	rm00
		clc
		adc	#$01
		sta	mcst+1
		sec
		adc	mcmtlo+1
		sta	mcmthi+1

		jsr	Make

		lda	PlotLo+RowCnt-1
		sec
		sbc	#$02
		sta	PlotAdd
		lda	PlotHi+RowCnt-1
		sbc	#$00
		sta	PlotAdd+1	

		jmp	Main

//----------------------------------

Make:		jsr	MkDelPlot

MkCalcJmp:	lda	#<CalcJmp
		sta	ZP1
		lda	#>CalcJmp
		sta	ZP1+1

/*		lda	#<JmpTab
		sta	cx00+1
		lda	#>JmpTab
		sta	cx00+2
		lda	#<JmpTab+$40
		sta	cx01+1
		lda	#>JmpTab+$40
		sta	cx01+2
		lda	#<JmpTab+$80
		sta	cx10+1
		lda	#>JmpTab+$80
		sta	cx10+2

		ldx	#<XT+2
		stx	cx11+1
		inx
		stx	cx13+1

		ldx	#<BT+2
		stx	cx12+1
		inx
		stx	cx14+1
*/		
		ldy	#<cx10-cx00	
mc00:		lda	cx00,y	
		sta	(ZP1),y	
		dey	
		bpl	mc00	
		lda	#<cx10-cx00	
		jsr	AddZP1	

		ldx	#<RowCnt-1
mcst:		lda	#$2b		//Multab last value (#$00-#$2a, max RowMax is #$2b), updated at start
		clc			//!!! (AR=$2a-(RowMax+1)
		sbc	RowMax,x
		tay
		clc
mcmtlo:	adc	#<MulTab
		sta	cx15+1
		tya
		clc
mcmthi:	adc	#<MulTab+$2c	//Update at start
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
		cpx	#$00		
		beq	mc06
		
mc04:		ldy	#<cx1x-cx10
mc05:		lda	cx10,y
		sta	(ZP1),y
		dey
		bpl	mc05
		jsr	MCPrep
		dex
		bpl	mcst

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
		adc	#$40
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

//----------------------------------

CalcXYBase:	//Call with C=0!!!
cx00:		lda	JmpTab+$000,y
		sta	XT+0
		sta	BT+0
cx01:		lda	JmpTab+$040,y
		adc	#>XTab
		sta	XT+1
		adc	#>BTab-XTab
		sta	BT+1

cx10:		lax	JmpTab+$080,y
cxy1:		adc	XT+0
cx11:		sta	XT+2
cx12:		sta	BT+2
		lda	#$00
cxy2:		adc	XT+1
cx13:		sta	XT+3
		adc	#>BTab-XTab
cx14:		sta	BT+3
cx15:		lda	MulTab,x
cx16:		adc	#$00
cx17:		sta	$5089
cx18:		lda	MulTab+$2b,x
cx19:		adc	#$00
cx1a:		sta	$508a
cx1x:		rts

//----------------------------------

MkDelPlot:
MkDel:	lda	#<DelPlot
		sta	ZP1
		lda	#>DelPlot
		sta	ZP1+1
		lda	#<Bitmap+$2c0	//2 rows and 80 bytes
		sta	ZP2
		lda	#>Bitmap+$2c0
		sta	ZP2+1
		ldx	#<RowCnt-1		//Row count
		stx	Tmp
md00:		ldy	Tmp
		ldx	RowMax,y
		lda	ZP2
		bmi	base1

base0:	lda	#$60
		sta	db00+1
		lda	ZP2+1
		sta	db00+2
bs00:		ldy	#<db02-db00-1
bs01:		lda	db00,y
		sta	(ZP1),y
		dey
		bpl	bs01
		lda	#<db01-db00
		jsr	AddZP1
		dex
		bpl	bs00
		bmi	md01

base1:	sta	db11+1
		lda	ZP2+1
		sta	db11+2
bs10:		ldy	#<db13-db10-1
bs11:		lda	db10,y
		sta	(ZP1),y
		dey
		bpl	bs11
		lda	#<db12-db10
		jsr	AddZP1
		dex
		bpl	bs10
md01:		lda	ZP2
		clc
		adc	#$40
		sta	ZP2
		lda	ZP2+1
		adc	#$01
		sta	ZP2+1
		dec	Tmp
		bpl	md00

MkPlot:	lda	#$03			//Skip JMP
		jsr	AddZP1
		lda	#<Bitmap+$2c0
		sta	ZP2
		lda	#>Bitmap+$2c0
		sta	ZP2+1
		ldx	#<RowCnt-1
		stx	Tmp

mp00:		lda	ZP2
		cmp	#$40
		bne	*+4
		lda	#$00
		sta	pb04+1
		lda	ZP2+1
		sta	pb04+2
		ldy	Tmp
		lda	ZP1
		sta	PlotLo,y
		lda	ZP1+1
		sta	PlotHi,y
		ldx	RowMax,y
		stx	pb00+1
mp01:		ldy	#<pb06-pb00-1
mp02:		lda	pb00,y
		sta	(ZP1),y
		dey
		bpl	mp02
		lda	#<pb05-pb00
		jsr	AddZP1
		lda	#$05
		ldy	ZP2
		bmi	*+4
		lda	#$03
		clc
		adc	pb02+1
		sta	pb02+1
		bcc	*+5
		inc	pb02+2
		dec	pb00+1
		bpl	mp01
		ldx	Tmp
		beq	mp03
		lda	#$03
		jsr	AddZP1		//Skip JMP
mp03:		lda	ZP2
		clc
		adc	#$40
		sta	ZP2
		lda	ZP2+1
		adc	#$01
		sta	ZP2+1
		inc	pb01+1
		inc	pb01+1
		inc	pb03+1
		inc	pb03+1
		dec	Tmp
		bpl	mp00
		ldy	#$00
		lda	#$60
		sta	(ZP1),y
		rts

//----------------------------------

AddZP1:	clc
		adc	ZP1
		sta	ZP1
		bcc	AddZP1x
		inc	ZP1+1
		clc
AddZP1x:	rts

//----------------------------------

PlotBase:
pb00:		ldy	#$00		//2		2
pb01:		lax	(XT),y	//5		2
pb02:		stx	DelPlot+1	//4		3
pb03:		lda	(BT),y	//5		2
pb04:		sta	Bitmap,x	//5		3
pb05:		jmp	DelPlot	//21 cycles	12 bytes/plot	-> $1ab8 bytes for 570 iterations
pb06:

//----------------------------------

DelBase0:
db00:		sta	Bitmap	//4 cycles	3 bytes		-> 1200 cycles/$0384 bytes for 300 plots
db01:		jmp	DelPlot
db02:

//----------------------------------

db10:		ldx	#$60		//2
db11:		sta	Bitmap,x	//5
db12:		jmp	DelPlot	//7 cycles	5 bytes		-> 4 bytes on average -> $08e8 bytes for 570 iterations
db13:		

//----------------------------------