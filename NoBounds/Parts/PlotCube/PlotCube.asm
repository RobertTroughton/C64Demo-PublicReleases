//------------------------------
//			PLOT CUBE
//	  386 realtime 3D dots
//------------------------------
//
//	Memory Layout
//	0400	0800	0400	Screen RAM
//	0800	0900	0100	Disk driver
//	0900	2000	1800	Music
//	2000	3000	1000	Map1+Map2
//	3000	3280	0280	Screen RAM
//	3280	33e8	0168	Logo 1 Screen
//	3400	3f40	0b40	Logo 1 Bitmap
//	4000	4c40	0c40	Main Code
//	4c40	4e98	03c0*	-UNUSED-
//	4e98	5000	0168	Logo 1 Color	
//	5000	53e8	03e8	Logo 00 Screen
//	5400	5f40	0b40	Logo 00 Bitmap

//	7118	7280	0168	Logo 2 Color
//	7280	73e8	0168	Logo 2 Screen
//	7400	7f40	0b40	Logo 2 Bitmap

//	7400	7a00	0600!	Plinth 1 Sprites
//	7a00	7c40	0240!	Plinth 2 Sprites
//	7c40	7f40	0300!	Plinth 3 Sprites

//	8118	8280	0168!	Logo 0 Color Load
//	8280	83e8	0168!	Logo 0 Screen Load
//	8400	8f40	0b40!	Logo 0 Bitmap Load

//	8000	a712	2712	DelPlot1
//	a800	cf12	2712	DelPlot2
//	d000	db40	0b40	Logo 2 Bitmap Load
//	db40	e000	04c0	-UNUSED-
//	e000	e600	0600	Tabs
//	e600	f000	0a00	Intro
//	f000	f118	0118	-UNUSED-
//	f118	f280	0168	Logo 3 Color
//	f280	f3e8	0168	Logo 3 Screen
//	f400	ff40	0b40	Logo 3 Bitmap
//	ff40	ffc0	0080	FadeColTab
//------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const RasterTime	= false
.const fast			= false

.const CubeBGCol	= $06
.const ScreenRAM	= $3000
.const ColorRAM		= $d800

.const MapZP	= $05		//$0b-$0c
.const Flag		= $07

.const FOZP		= $10		//$10-11 - for bitmap fade-out

.const CX		= $08
.const X0		= $09		//$11-$38

.const CY		= $31
.const Y0		= $32		//$3a-$61

.const CX0		= $5a		//$62-$69
.const CY0		= $62		//$6a-$71

.const Cnt		= $6a

.const alf		= $6b
.const bet		= $6c
.const gam		= $6d

.const ZP		= $6e		//$6e-$6f, $6e is always #$00
.const ZP1		= $6f		//$6f-$70, overlaps with ZP

.const Color1	= $71
.const Color2	= $72
.const Color3	= $73

.const DelZP	= $74		//$74-$fb - DelZP vectors ($44 byte pairs)

//----------------------------------
//	Vector calc
//	Overlaps with coordinates
//----------------------------------

.const T1		= $38
.const T2		= $39
.const T3		= $3a
.const T4		= $3b
.const T5		= $3c
.const T6		= $3d
.const T7		= $3e
.const T8		= $3f
.const T9		= $40
.const T10		= $41

.const A1		= $42		//C1 and I1 are not needed
.const B1		= $43
.const D1		= $44
.const E1		= $45
.const G1		= $46
.const H1		= $47

.const XA		= $48
.const YA		= $49
.const ZA		= $4a

.const XB		= $4b
.const YB		= $4c
.const ZB		= $4d

.const XC		= $4e
.const YC		= $4f
.const ZC		= $50

.const X0R		= $51		//.const	X0R+1	=$52
.const Y0R		= $53		//.const	Y0R+1	=$53

//----------------------------------

.const ZPDel1	= $80
.const ZPDel2	= ZPDel1+[18*3]

.const Map1		= $2000
.const Map2		= $2800

.const DelPlot1	= $8000 
.const DelPlot2	= DelPlot1+$2800

.const XTabHi1	= $e000
.const XTabHi2	= $e001
.const XTabLo	= $e100
.const XBit1	= $e101
.const XBit2	= $e200
.const XBit3	= $e201
.const XRev		= $e300
.const Sin		= $e400
.const Cos		= $e500

.const FadeColTab	= $ff40
.const FadeTables	= $5800
//----------------------------------

.macro Div2() {
		cmp #$80
		ror
		}

//----------------------------------
		
*=$4000	"Main code"

PlotCube_Go:
Start:	jsr MkDelPlot
		jsr MkTabs
		jsr MkMap
		jsr SetIRQ

		lda #20
		cmp $d012
		bcc *-3

		ldx #$77				//Updating ColRAM for Podium1
!:		lda $4e98,x
		sta $da80,x
		lda $4e98+$78,x
		sta $daf8,x
		lda $4e98+$f0,x
		sta $db70,x
		dex
		bpl !-

		lda #$32
		sta alf
		lda #$1b
		sta bet
		lda #$d3
		sta gam
		lda #$00
		sta Flag
		cli

		jsr CreateFadeTables

		lda Flag
		beq *-2

		lda #$fe
		sta iralf+1
		lda #$01
		sta irbet+1
		lda #$02
		sta irgam+1

		lda #$18
		jsr RelocMap

		lda #20
		cmp $d012
		bcc *-3

		ldx #$77				//Updating ColRAM for Podium2
!:		lda $7118,x
		sta $da80,x
		lda $7118+$78,x
		sta $daf8,x
		lda $7118+$f0,x
		sta $db70,x
		dex
		bpl !-

		lda #$3d
		sta VICBank+1

		lsr Flag

		lda Flag
		beq *-2

		lda #$01
		sta iralf+1
		lda #$02
		sta irbet+1
		lda #$ff
		sta irgam+1

		lda #$0c
		jsr RelocMap

		lda #20
		cmp $d012
		bcc *-3

		ldx #$77				//Updating ColRAM for Podium3
!:		lda $f118,x
		sta $da80,x
		lda $f118+$78,x
		sta $daf8,x
		lda $f118+$f0,x
		sta $db70,x
		dex
		bpl !-

		lda #$3f
		sta VICBank+1

		lsr Flag

		lda Flag
		beq *-2

		lda #$02
		sta iralf+1
		lda #$01
		sta irbet+1
		lda #$02
		sta irgam+1
		
		lsr Flag

		lda Flag
		beq *-2
		
		lda #$01
		sta iralf+1
		lda #$fe
		sta irbet+1
		lda #$fe
		sta irgam+1
		
		lsr Flag

		rts

CtrLo:
.byte $00
CtrHi:
.byte $00
//----------------------------

irqb3:
.if (RasterTime==true) {
		dec $d020
		}
		sta AR+1
		stx XR+1
		sty YR+1

		lax alf
iralf:	axs #$ff
		stx alf
		lax bet
irbet:	axs #$fe
		stx bet
		lax gam
irgam:	axs #$01
		stx gam

		ldx #$08
		ldy #$3b
VICBank:
		lda #$3c
		stx $d021
		sta $dd02
		sty $d011
		//stx $d020

		//lda #$00
		inc $d019
		//nop
		//sta $d021
		//sta $d020

		//jsr BASE_PlayMusic

		lda Flag
		beq Cont
		
ToEnd:	lda $d011
		bpl *-3
		lda $d011
		bmi *-3
		lda #$1b
		sta $d011
		lda #$3c
		sta $dd02
		lda #CubeBGCol
		sta $d020
		sta $d021				//Do NOT write #(CubeBGCol | $08) in $d021!!!
		lda #$ca
		sta $d018				//Restore $d018 to show blue background while block is relocated
		jsr BASE_PlayMusic
		jmp SkipBGColChg		//Wait for block relocation, skip cube anim

Cont:	inc CtrLo
		bne *+5
		inc CtrHi
		lda CtrHi

Next2:	cmp #$02
		bne Next3
FO2:	ldx #$13
		bpl	SkipJmp 
		jmp	FI1
SkipJmp:
		lda FadeOut1,x
		sta Color1
		lda FadeOut2,x
		sta Color2
		lda FadeOut3,x
		sta Color3
		dec FO2+1
		bpl ToCR
To3Lo:	lda #$ce+16+5
		sta DelPlot1+$0ccc+16+5
		sta DelPlot2+$0ccc+16+5
To3Hi1:	lda #$8c
		sta DelPlot1+$0ccd+16+5
To3Hi2:	lda #$b4
		sta DelPlot2+$0ccd+16+5
		
		lda #$0c
NOP1:	sta DelPlot1
NOP2:	sta DelPlot2

		lda #$0f
		sta FI1+1
		inc Flag
		bpl ToEnd

Next3:	cmp #$03
		bne Next4
		lda CtrLo
		bne Next3b
		lda #$22
		sta CtrLo
		inc Flag
		bpl ToCR

Next3b:	cmp #$80
		bne BneCR
		lda #$a3
		sta CtrLo
		inc Flag
		bpl ToCR

Next4:	cmp #$04
		bne Next0
FO3:	ldx #$13
		bmi JmpToEnd
		lda FadeOut1,x
		sta Color1
		lda FadeOut2,x
		sta Color2
		lda FadeOut3,x
		sta Color3
		dec FO3+1
ToCR:	bpl ToCalcRot

		inc PART_Done

		lda #<irqfo
		sta $fffe
		sta irqlo+1
		lda #>irqfo
		sta $ffff
		sta irqhi+1

JmpToEnd:
		jmp ToEnd

Next0:	cmp #$00
		bne Next1
FI1:	ldx #$0f
		bmi CalcRot
		dec FI1+1
		lda FadeIn1,x
		sta Color1
		lda FadeIn2,x
		sta Color2
		lda FadeIn3,x
		sta Color3
ToCalcRot:
		bpl CalcRot

Next1:	cmp #$01
BneCR:	bne CalcRot
FO1:	ldx #$13
		bmi FI1
		lda FadeOut1,x
		sta Color1
		lda FadeOut2,x
		sta Color2
		lda FadeOut3,x
		sta Color3
		dec FO1+1
		bpl CalcRot
To2Lo:	lda #$5e+16+5
		sta DelPlot1+$0ccc+16+5
		sta DelPlot2+$0ccc+16+5
To2Hi1:	lda #$9e
		sta DelPlot1+$0ccd+16+5
To2Hi2:	lda #$c6
		sta DelPlot2+$0ccd+16+5
		lda #$0f
		sta FI1+1
		inc Flag

//----------------------------
		
CalcRot:
		lax bet
.if	(fast==false)	{
		sec }
		sbc gam
		sta T1					//T1=B-G

.if	(fast==false)	{
		clc }
		adc alf
		sta T7					//T7=B-G+A

		lda Sin,x
		//asl					//NEEDED FOR NORMAL SINE AMPLITUDE
		//sta C1				//C1=sin(Beta) - must be multiplied by 2
		eor #$80				//=clc + adc #$80
		sta XC

		txa						//lda	bet
.if	(fast==false)	{
		clc }
		adc gam
		//sta T2				//T2=B+G
		tay						//Y=T2

.if	(fast==false)	{
		sec }
		sbc alf
		sta T8					//T8=B+G-A

		txa						//lda	bet
.if	(fast==false)	{
		sec }
		sbc alf
		sta T9					//T9=B-A

		lax alf
.if	(fast==false)	{
		clc }
		adc gam
		sta T3					//T3=A+G

.if	(fast==false)	{
		sec }
		sbc bet
		sta T6					//T6=A+G-B

		txa						//lda	alf
.if	(fast==false)	{
		sec }
		sbc gam
		sta T4					//T4=A-G

		txa						//lda	alf
.if	(fast==false)	{
		clc }
		adc bet
		sta T10					//T10=A+B

.if	(fast==false)	{
		clc }
		adc gam
		sta T5					//T5=A+B+G

		ldx T1
		//ldy T2				//see TAY above
		lda Cos,x
.if	(fast==false)	{
		clc }
		adc Cos,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta A1					//A1=(cT1+cT2)/2

		lda Sin,x
.if	(fast==false)	{
		sec }
		sbc Sin,y
		//sta B1				//B1=(sT1-sT2)/2		
		Div2()					//WITH DOUBLE SINE APLITUDE
		tax			
XYZ:	//lax B1				//Y
.if	(fast==false)	{
		clc }
		adc A1					//X
.if	(fast==false)	{
		clc }
		adc #$40
		sta XA					//XA=A1+B1

nXYZ:	txa						//lda	B1
.if	(fast==false)	{
		sec }
		sbc A1
.if	(fast==false)	{
		clc }
		adc #$40
		sta XB					//XB=B1-A1

		ldx T3
		ldy T4
		lda Sin,x
.if	(fast==false)	{
		sec }
		sbc Sin,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta D1					//D1_=(sT3-sT4)/2

		lda Cos,x
.if	(fast==false)	{
		clc }
		adc Cos,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta E1					//E1_=(cT3+cT4)/2 

//----------------------------

		lda Cos,y
.if	(fast==false)	{
		sec }
		sbc Cos,x
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta G1					//G1_=(cT4-cT3)/2
		
		lda Sin,x
.if	(fast==false)	{
		clc }
		adc Sin,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta H1					//H1_=(sT3+sT4)/2

//----------------------------

		ldx T9
		ldy T10
		lda Sin,x
.if	(fast==false)	{
		sec }
		sbc Sin,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		//sta F1				//F=(sT9-sT10)/2
		//lda F1				//F1 NOT USED!!!
		eor #$80
		sta YC

//----------------------------

		lda Cos,x
.if	(fast==false)	{
		clc }
		adc Cos,y				//I1 NOT USED!!!
		Div2()					//WITH DOUBLE SINE APLITUDE
		//sta I1				//I=(cT9+cT10)/2
		sta ZC

//----------------------------
		
		ldx T7
		ldy T8
		lda Cos,x
.if	(fast==false)	{
		sec }
		sbc Cos,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta T1					//Tmp1=(cT7-cT8)/2

		lda #00
.if	(fast==false)	{
		sec }
		sbc Sin,x
.if	(fast==false)	{
		sec }
		sbc Sin,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta T2					//Tmp2=(-sT7-sT8)/2

		ldx T5
		ldy T6
		lda Cos,y
.if	(fast==false)	{
		sec }
		sbc Cos,x
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta T3					//Tmp3=(cT6-cT5)/2

.if	(fast==false)	{
		sec }
		sbc T1
		:Div2()					//_D1=(Tmp3-Tmp1)/2
.if	(fast==false)	{
		clc }
		adc D1
		sta D1					//D1=D1_+_D1

		lda Sin,x
.if	(fast==false)	{
		sec }
		sbc Sin,y
		Div2()					//WITH DOUBLE SINE APLITUDE
		sta T4					//Tmp4=(sT5-sT6)/2

.if	(fast==false)	{
		clc }
		adc T2
		:Div2()					//_E1=(Tmp2+Tmp3)/2
.if	(fast==false)	{
		clc }
		adc E1
		//sta E1				//E1=E1_+_E1
		tax
.if	(fast==false)	{
		clc }
		adc D1
.if	(fast==false)	{
		clc }
		adc #$40
		sta YA

		txa						//lda	E1
.if	(fast==false)	{
		sec }
		sbc D1
.if	(fast==false)	{
		clc }
		adc #$40
		sta YB

//----------------------------

		lda T2					//Tmp2=(-sT7-sT8)/2
.if	(fast==false)	{
		sec }
		sbc T4					//Tmp4=(sT5-sT6)/2
		:Div2()					//_G1=(Tmp2-Tmp3)/2
.if	(fast==false)	{
		clc }
		adc G1
		sta G1					//G1=G1_+_G1

		lda T3					//Tmp3=(cT6-cT5)/2
.if	(fast==false)	{
		clc }
		adc T1					//Tmp1=(cT7-cT8)
		:Div2()					//_H1=(Tmp3+Tmp1)/2
.if	(fast==false)	{
		clc }
		adc H1
		tax
		//sta H1				//H1=H1_+_H1
.if	(fast==false)	{
		clc }
		adc G1
		sta ZA
		
		txa
.if	(fast==false)	{
		sec }
		sbc G1
		sta ZB		
		
//----------------------------

CalcVis:
		ldx #$fe
		ldy #$00
		adc ZA
		bpl *+4
		ldy #$7f				//ZA+ZB >= #$80 -> invert X0/Y0 and X1/Y1
		tya
		eor XA
		sax X0
		tya
		eor YA
		sta Y0
		tya
		eor XB
		sax X0+1
		tya
		eor YB
		sta Y0+1
		
		ldy #$00
		lda ZA
		eor #$7f
		adc ZB
		bmi *+4
		ldy #$7f				//ZB-ZA >= #$80 -> invert X0R/Y0R
		tya
		eor XA
		eor #$7f
		sax X0R
		tya
		eor YA
		eor #$7f
		sta Y0R
		tya
		eor XB
		sax X0R+1
		tya
		eor YB
		sta Y0R+1
		
		lda XC
		ldy ZC
		bpl *+4
		eor #$ff
		sax CX0
		lda YC
		ldy ZC
		bpl *+4
		eor #$ff
		sta CY0

CalcXY:
.if	(fast==false)	{
		clc }					//X1	X4	X3	X5	X2	X7	X6	X8	X0
		lax X0
		adc X0+1
		alr #$fc
		sta X0+2
		adc X0+1
		alr #$fc
		sta X0+3
		adc X0+1
		alr #$fc
		sta X0+4
		lda X0+2
		adc X0+3
		alr #$fc
		sta X0+5

		txa
		adc X0+2
		alr #$fc
		sta X0+6
		adc X0+2
		alr #$fc
		sta X0+7

		txa
		adc X0+6
		alr #$fc
		sta X0+8

		lda X0R
		adc X0R+1
		alr #$fc
		sta X0+9					//X9
		adc X0R+1
		alr #$fc
		sta X0+10					//X10
		adc X0R+1
		alr #$fc
		sta X0+11					//X11
		lax X0+9
		adc X0+10
		alr #$fc
		sta X0+12					//X12

		txa							//X9
		adc #$40
		alr #$fc
		sta X0+37
		adc #$40
		alr #$fc
		sta X0+39
		txa
		adc X0+37
		alr #$fc
		sta X0+38

		txa
		adc X0R
		alr #$fc
		sta X0+13
		adc X0R
		alr #$fc
		sta X0+15
		eor #$7f
		adc #$01
		tay							//X15R
		txa
		adc X0+13
		alr #$fc
		sta X0+14
		eor #$7f
		adc #$01
		tax							//X14R

		adc X0+12					//X12	X32	X31	X33	X30	X35	X34	X36	X14
		alr #$fc
		sta X0+30
		adc X0+12
		alr #$fc
		sta X0+31
		adc X0+12
		alr #$fc
		sta X0+32
		lda X0+30
		adc X0+31
		alr #$fc
		sta X0+33

		txa							//X14R
		adc X0+30
		alr #$fc
		sta X0+34
		adc X0+30
		alr #$fc
		sta X0+35

		txa
		adc X0+34
		alr #$fc
		sta X0+36
		
		tya							//X15R
		adc X0+11					//X11	X18	X17	X19	X16	X21	X20	X22	X15
		alr #$fc
		sta X0+16
		adc X0+11
		alr #$fc
		sta X0+17
		adc X0+11
		alr #$fc
		sta X0+18
		lda X0+16
		adc X0+17
		alr #$fc
		sta X0+19

		tya
		adc X0+16
		alr #$fc
		sta X0+20
		adc X0+16
		alr #$fc
		sta X0+21

		tya
		adc X0+20
		alr #$fc
		sta X0+22

		lda X0+13					//X10	X25	X24	X26	X23	X28	X27	X29	X13
		eor #$7f
		adc #$01
		tax
		adc X0+10
		alr #$fc
		sta X0+23
		adc X0+10
		alr #$fc
		sta X0+24
		adc X0+10
		alr #$fc
		sta X0+25
		lda X0+23
		adc X0+24
		alr #$fc
		sta X0+26

		txa
		adc X0+23
		alr #$fc
		sta X0+27
		adc X0+23
		alr #$fc
		sta X0+28

		txa
		adc X0+27
		alr #$fc
		sta X0+29

		lax Y0
		adc Y0+1
		alr #$fe
		sta Y0+2
		adc Y0+1
		alr #$fe
		sta Y0+3
		adc Y0+1
		alr #$fe
		sta Y0+4
		lda Y0+2
		adc Y0+3
		alr #$fe
		sta Y0+5
		txa
		adc Y0+2
		alr #$fe
		sta Y0+6
		adc Y0+2
		alr #$fe
		sta Y0+7
		txa
		adc Y0+6
		alr #$fe
		sta Y0+8

		lda Y0R
		adc Y0R+1
		alr #$fe
		sta Y0+9
		adc Y0R+1
		alr #$fe
		sta Y0+10
		adc Y0R+1
		alr #$fe
		sta Y0+11
		lax Y0+9
		adc Y0+10
		alr #$fe
		sta Y0+12

		txa
		adc #$40
		alr #$fe
		sta Y0+37
		adc #$40
		alr #$fe
		sta Y0+39
		txa
		adc Y0+37
		alr #$fe
		sta Y0+38

		txa
		adc Y0R
		alr #$fe
		sta Y0+13
		adc Y0R
		alr #$fe
		sta Y0+15
		eor #$7f
		adc #$01
		tay
		txa
		adc Y0+13
		alr #$fe
		sta Y0+14
		eor #$7f
		adc #$01
		tax

		adc Y0+12
		alr #$fe
		sta Y0+30
		adc Y0+12
		alr #$fe
		sta Y0+31
		adc Y0+12
		alr #$fe
		sta Y0+32
		lda Y0+30
		adc Y0+31
		alr #$fe
		sta Y0+33

		txa
		adc Y0+30
		alr #$fe
		sta Y0+34
		adc Y0+30
		alr #$fe
		sta Y0+35

		txa
		adc Y0+34
		alr #$fe
		sta Y0+36

		tya
		adc Y0+11
		alr #$fe
		sta Y0+16
		adc Y0+11
		alr #$fe
		sta Y0+17
		adc Y0+11
		alr #$fe
		sta Y0+18
		lda Y0+16
		adc Y0+17
		alr #$fe
		sta Y0+19
		
		tya
		adc Y0+16
		alr #$fe
		sta Y0+20
		adc Y0+16
		alr #$fe
		sta Y0+21

		tya
		adc Y0+20
		alr #$fe
		sta Y0+22

		lda Y0+13
		eor #$7f
		adc #$01
		tax
		adc Y0+10
		alr #$fe
		sta Y0+23
		adc Y0+10
		alr #$fe
		sta Y0+24
		adc Y0+10
		alr #$fe
		sta Y0+25
		lda Y0+23
		adc Y0+24
		alr #$fe
		sta Y0+26

		txa
		adc Y0+23
		alr #$fe
		sta Y0+27
		adc Y0+23
		alr #$fe
		sta Y0+28

		txa
		adc Y0+27
		alr #$fe
		sta Y0+29

		lax CX0
		eor #$c0					//sec, sbc #$40
		and #$7e
		sta CX
		txa
		alr #$fc
		adc #$40
		sta CX0+2
		adc CX0
		ror
		and #$fe					//C=1
		sta CX0+1
		eor #$fe
//.if	(fast==false)	{
//		clc }
		adc #$02
		sta CX0+6
		lda CX0+2
		alr #$fc
		adc #$40					//C=0 after this
		sta CX0+3
		eor #$fe
		adc #$02					//C=0 or 1
		sta CX0+4
		txa
		eor #$fe
.if	(fast==false)	{
		clc }
		adc #$02
		sta CX0+7
		lda CX0+2
		eor #$fe
.if	(fast==false)	{
		clc }
		adc #$02
		sta CX0+5
		
		lax CY0
		eor #$c0					//sec, sbc #$40
		and #$7f
		sta CY
		txa
		alr #$fe
		adc #$40
		sta CY0+2
		adc CY0
		ror
		sta CY0+1
		eor #$ff
.if	(fast==false)	{
		clc }
		adc #$01
		sta CY0+6
		lda CY0+2
		alr #$fe
		adc #$40					//C=0 after this
		sta CY0+3
		eor #$ff
		adc #$01
		sta CY0+4
		txa
		eor #$ff
.if	(fast==false)	{
		clc }
		adc #$01
		sta CY0+7
		lda CY0+2
		eor #$ff
.if	(fast==false)	{
		clc }
		adc #$01
		sta CY0+5

		clc
		ldy #00
ib300:	lda #$00
		eor #$ff
		sta ib300+1
		bpl ib301

		jmp DelPlot1
		
ib301:	eor #$ff
		jmp DelPlot2

irb3x:	bit $d011
		bpl SkipBGColChg
		bit $d011
		bmi *-3
		lda #CubeBGCol
		sta $d020
		lda #$3c
		sta $dd02

SkipBGColChg:
YR:		ldy #$00		//YR	
XR:		ldx #$00		//XR
AR:		lda #$00		//AR
.if (RasterTime==true)	{
		inc $d020
		}
nmi:	rti

//----------------------------------

irq00:
		dec $00
		sta AR0+1

		lda irqlo+1
		cmp #<irqfo
		bne !+
		lda irqhi+1
		cmp #>irqfo
		bne !+

ircol:	lda #$06
		sta $d020
		sta $d021
		sta $d022
		sta $d023

		and #$0f
		cmp #$01
		bne !+
		sta PART_Done
		
!:		asl $d019

		stx XR0+1
		sty YR0+1

ir011:	lda #$1b
		sta $d011
		lda #$ca
		sta $d018
		lda #$18
		sta $d016
		lda #$3c
		sta $dd02

		jsr BASE_PlayMusic

		lda #$b2
		sta $d012
irqlo:	lda #<irqb3
		sta $fffe
irqhi:	lda #>irqb3
		sta $ffff

YR0:	ldy #$00
XR0:	ldx #$00
AR0:	lda #$00
		inc $00

		rti

//----------------------------------

irqfo:	dec $00
		sta irfoA+1
		stx irfoX+1
		sty irfoY+1

		ldx #$03
		dex
		bne *-1 

		nop
		nop $ea

irfo1:	ldx #$08
irf11:	ldy #$3b
		lda #$3f
		stx $d021
		sta $dd02
		sty $d011

		asl $d019

		lda #$fa
		sta $d012
		lda #<irqcl
		sta $fffe
		lda #>irqcl
		sta $ffff

irfoY:	ldy #$00
irfoX:	ldx #$00
irfoA:	lda #$00
		inc $00
		rti

//----------------------------------

irqcl:	sta irclA+1
		stx irclX+1
		sty irclY+1
		lda $01
		sta ircl1+1
		lda #$35
		sta $01
		
		asl $d019

		lda #$00
		sta $d012
		lda #<irq00
		sta $fffe
		lda #>irq00
		sta $ffff

		cli

		lda $2800
		beq ircl0

		jsr ClearMap
		jmp ircl1

ircl0:	lda #$00
		eor #$ff
		sta ircl0+1
		beq ircl1

		lda FOCol+1
		cmp #>FadeTables - $100
		beq ircl1

//		bne ircl2

//ircl3:	lda #$0b
//		sta $d011
//		sta ir011+1
//		sta irf11+1
//ircl4:	ldx #$07
//		lda FadeColTab,x
//		sta ircol+1
//		dex
//		stx ircl4+1
//		jmp ircl1

ircl2:	jsr FadeToWhite

ircl1:	lda #$35
		sta $01

irclY:	ldy #$00
irclX:	ldx #$00
irclA:	lda #$00
		rti


//----------------------------------

ClearMap:
		lax #$00
!:		sta $2800,x
		sta $2900,x
		sta $2a00,x
		sta $2b00,x
		sta $2c00,x
		sta $2d00,x
		sta $2e00,x
		sta $2f00,x
		inx
		bne !-
		rts

//----------------------------------

FadeToWhite:
		lda #<FadeTables + $700
		sta FOZP
FOCol:	lda #>FadeTables + $700
		sta FOZP+1
		
		//lda $d020
		//and #$0f
		//tay
		ldy ircol+1
		lda (FOZP),y
		sta ircol+1
		ldy irfo1+1
		lda (FOZP),y
		sta irfo1+1
		
		ldx #$27
FOLoop:
		.for (var i = 0; i < 9; i++)
		{
		ldy $f280 + (i * $28),x
		lda (FOZP),y
		sta $f280 + (i * $28),x
		ldy $da80 + (i * $28),x
		lda (FOZP),y
		sta $da80 + (i * $28),x
		}
		dex
		bmi FODone
		jmp FOLoop
FODone:	dec FOCol+1
FOEnd:	rts

//---------------------------------------------------------------------------------------------------------------------------------------

AddZP:	clc
		adc ZP
		sta ZP
		bcc *+5
		inc ZP+1
		clc
		rts

//----------------------------------

MkMap:	ldx #$00
		lda #$00
mm99:	sta ScreenRAM + $0000,x
		sta ScreenRAM + $0100,x
		sta ScreenRAM + $0180,x
		inx
		bne mm99
		
		bit $d011
		bpl *-3
		bit $d011
		bmi *-3

		lda #$00
		sta $d011
		//sta $d020
		sta $d021
		sta $d022
		sta $d023
		sta Color1				//00 - XBit1
		sta Color2				//01 - XBit2
		sta Color3				//10 - XBit3

		lda #$00
		jsr RelocMap

		lda #<Map1
		sta ZP					//this also sets ZP to 0!!!
		lda #>Map1
		sta ZP+1
		ldx #$0f
		ldy #$00
		lda #$ff
mm04:	sta (ZP),y
		iny
		bne mm04
		inc ZP+1
		dex
		bpl mm04
		
		rts

//----------------------------------
		
RelocMap:
		sta MapZP
		clc
		adc #$08
		sta mm05+1
		lda #>ScreenRAM
		sta MapZP+1
		lax #$00
mm06:	sta ScreenRAM + $0000,x
		sta ScreenRAM + $0100,x
		sta ScreenRAM + $0180,x
		inx
		bne mm06
mm00:	ldy #$00
		txa
mm01:	sta (MapZP),y
		iny
		clc
		adc #$20
		bcc mm01
		lda #$28
		clc
		adc MapZP
		sta MapZP
		bcc *+4
		inc MapZP+1
		inx
		cpx #$10
		bne mm00
mm05:	lda #$14
		sta MapZP
		lda #>ScreenRAM
		sta MapZP+1
		ldx #$f0
mm02:	ldy #$00
		txa
mm03:	sta (MapZP),y
		iny
		sec
		sbc #$20
		bcs mm03
		lda #$28
		clc
		adc MapZP
		sta MapZP
		bcc *+4
		inc MapZP+1
		inx
		bne mm02
		
		rts

//--------------------------------------

FadeIn1:
.byte $01,$01,$07,$07,$0f,$0f,$0a,$0a			//17fac829
.byte $0c,$0c,$08,$08,$02,$02,$0c,$0c

FadeIn2:
.byte $0a,$0a,$0f,$0f,$0d,$0d,$03,$03			//afd35e4b
.byte $05,$05,$0e,$0e,$04,$04,$0b,$0b

FadeIn3:
.byte $0d,$07,$0d,$0d,$03,$03,$05,$05
.byte $0e,$0e,$04,$04,$0b,$0b,CubeBGCol,CubeBGCol

FadeOut1:
.byte CubeBGCol,CubeBGCol,CubeBGCol,CubeBGCol
.byte CubeBGCol,$0b,$0b,$04,$04,$0e,$0e,$05
.byte $05,$03,$03,$0d,$0d,$07,$07,$01

FadeOut2:
.byte CubeBGCol,CubeBGCol,CubeBGCol,CubeBGCol
.byte CubeBGCol,CubeBGCol,$0b,$0b,$04,$04,$0e,$0e
.byte $05,$05,$0d,$0d,$0f,$0f,$07,$07

FadeOut3:
.byte CubeBGCol,CubeBGCol,CubeBGCol,CubeBGCol
.byte CubeBGCol,CubeBGCol,CubeBGCol,$0b,$0b,$04,$04,$0e
.byte $0e,$05,$05,$03,$03,$0d,$0d,$07

//-----------------------------------

CreateFadeTables:
				ldx #$00
cft00:			txa
				and #$0f
				asl
				asl
				asl
cft01:			ora #$07
				tay
				lda FadeColTab,y
				sta cft02+1

				txa
				alr #$f0
				ora cft01+1
				tay
				lda FadeColTab,y
				asl
				asl
				asl
				asl
cft02:			ora #$00
cft03:			sta FadeTables,x
				inx
				bne cft00
				inc cft03+2
				dec cft01+1
				bpl cft00
				rts

//-----------------------------------

MkTabs:
MkXTabs:
		ldx #$3e
mxt0:	lda #$00
		sta XTabLo+$00,x
		sta XTabLo+$c0,x
		eor #$80
		sta XTabLo+$40,x
		sta XTabLo+$80,x
		dex
		dex
		bpl mxt0

		ldx #$00
		lda #>Map1
mx03:	ldy #$07
mxt4:	sta XTabHi1,x
		sta XTabHi1+$80,x
		eor #$07
		sta XTabHi1+$40,x
		sta XTabHi1+$c0,x
		eor #$0f
		inx
		dey
		bpl mxt4
		clc
		adc #$01
		cmp #>Map2
		bne mx03

MkXBit:	lax #$00
mxb0:	lsr
		lsr
		bne *+4
		lda #$c0
		tay
		eor #$ff
		sta XBit1,x
		ora #$55
		sta XBit2,x
		sec
		ror
		sta XBit3,x
		tya
		inx
		inx
		bne mxb0

MkXRev:	ldx #$00
mx00:	txa
		ldy #$07
mx01:	lsr
		rol XRev,x
		dey
		bpl mx01
		inx
		bne mx00
	
MkSinCos:
		ldx #$3f
gs1:	lda SinBase,x
		sta Sin,x
		eor #$ff
		sta Sin+$80,x
		dex
		bpl gs1
		lda Sin+$3f
		sta Sin+$40
		eor #$ff
		sta Sin+$c0
		ldx #$3f
		ldy #$01
gs2:	lda Sin+$00,x
		sta Sin+$40,y
		lda Sin+$80,x
		sta Sin+$c0,y
		iny
		dex
		bpl gs2
		ldx #$40
		ldy #$00
gs3:	lda Sin,x
		sta Sin,x
		sta Cos,y
		inx
		iny
		bne gs3
		rts

//----------------------------------

SetIRQ:
		lda #$c0
		cmp $d012
		bne *-3

		ldx #$7f
		lda #(CubeBGCol | $08)
!:		sta ColorRAM + $0000,x
		sta ColorRAM + $0080,x
		sta ColorRAM + $0100,x
		sta ColorRAM + $0180,x
		sta ColorRAM + $0200,x
		dex
		bpl !-

		lda #$00
		sta $d012
		lda #<irq00
		sta $fffe
		lda #>irq00
		sta $ffff
		lda #$1b
		sta $d011

		vsync()
	
		lda #CubeBGCol
		sta $d020
		//lda #$ca
		//sta $d018
		//lda #$18
		//sta $d016

		rts

//----------------------------------

ClearZP:
		ldx #$88
	ClearZPLoop:
		lda #>Map1
		sta DelZP-1,x
		dex
		lda #$00
		sta DelZP-1,x
		dex
		bne ClearZPLoop
		rts

//----------------------------------
//		DelPlot
//----------------------------------

MkDelPlot:
		jsr ClearZP
		
		lda #$00					//We are using YR here as a flag (not needed for IRQ yet)
		sta YR+1
		lda #<XTabHi1				//First DelPlot
		sta pb02+1

		lda #<DelPlot1
		ldx #>DelPlot1
		ldy #<ZPDel1

		jsr DP

		lda ZP
		sta DelPlot1+$0ccc+16+5
		lda ZP+1
		sta DelPlot1+$0ccd+16+5
		
		lda To2Hi2+1
		sta To2Hi1+1
		lda To3Hi2+1
		sta To3Hi1+1

//----------------------------------
		
		jsr ResetBases
		
		lda #<XTabHi2				//Second DelPlot
		sta pb02+1
		lda #<DelPlot2
		ldx #>DelPlot2
		ldy #<ZPDel2
		
		jsr DP

		lda ZP
		sta DelPlot2+$0ccc+16+5
		lda ZP+1
		sta DelPlot2+$0ccd+16+5

		rts

//----------------------------------
//		DELPLOT
//----------------------------------

DP:

//----------------------------------
//		DELETE
//----------------------------------

		jsr MkDel

//----------------------------------
//		PLOT EDGES
//----------------------------------

Edge7:	lda #<CX0+7					//Cube bottom (layer 7)
		ldy #<CY0+7
		ldx #<XBit1
		stx pb0c+1
		ldx #>XBit1					//Plot1 Edge Color
		jsr UpdateAll
		lda #<X0					//Starts at X16/Y16
		ldy #<Y0
		ldx #$0f					//16 plots total
		jsr MkPlot1

Edge0:	lda #<CX0					//Cube top (layer 0)
		ldy #<CY0
		jsr UpdateCXY
		lda #<X0					//Starts at X16/Y16
		ldy #<Y0
		ldx #$0f					//16 plots total
		jsr MkPlot1

Edge16:	lda #$05					//Plotting edges of layers 1-3 and 4-6 (skipping middle layer)
		sta Cnt
		lda #<CX0+1					//Start with layer 1
		ldy #<CY0+1
		jsr UpdateCXY
Plot16:	lda #<X0					//Starts at X16/Y16
		ldy #<Y0
		ldx #$01					//2 plots per layer, 6 layers
		jsr MkPlot1
		inc pb01+1
		inc pb07+1
		dec Cnt
		bpl Plot16
		
EdgeMid:
		jsr AddY0
		
		lda #<XBit1					//Plot 0 (middle layer) Edge Color
		sta dp18+1
		lda #>XBit1
		sta dp18+2
		lda #<X0
		ldy #<Y0
		ldx #$01
		jsr MkPlot0					//2 plots per layer (corners only)

		ldy #<cb0x-cb00-1
ColorLoop:
		lda cb00,y
		sta (ZP),y
		dey
		bpl ColorLoop
		
		lda cb00+1
		eor #$02
		sta cb00+1
		
		lda #<cb0x-cb00
		jsr AddZP

		lda ZP
		sta To3Lo+1
		lda ZP+1
		sta To3Hi2+1

//----------------------------------
//		PLOT SIDES
//----------------------------------

Face16:	lda #$05
		sta Cnt
		ldx #<XBit3					//Plot1 BG color
		stx pb0c+1
		ldx #>XBit3
		lda #<CX0+1					//Cube top (layer 0)
		ldy #<CY0+1
		jsr UpdateAll
Plot16f:

		lda #<X0+2					//Starts at X16/Y16
		ldy #<Y0+2
		ldx #$0d					//14 plots total
		jsr MkPlot1
		inc pb01+1
		inc pb07+1
		dec Cnt
		bpl Plot16f
		
Middle:	jsr AddY0					//Adds lda #$00

		lda #<XBit3					//Plot 0 BG color
		sta dp18+1
		lda #>XBit3
		sta dp18+2

		lda #<X0+2
		ldy #<Y0+2
		ldx #$0d
		jsr MkPlot0

		lda ZP
		sta To2Lo+1
		lda ZP+1
		sta To2Hi2+1

//----------------------------------
//		PLOT TOP + BOTTOM
//----------------------------------

		lda #<CX
		ldy #<CY
		ldx #$00
		jsr MkPlot0

		inc YR+1					//Set flag

Face0:	lda #<CX0					//Cube top (layer 0)
		ldy #<CY0
		jsr UpdateCXY
		lda #<X0+16					//Starts at X16/Y16
		ldy #<Y0+16
		ldx #$17					//24 plots total
		jsr MkPlot1

Face7:	lda #<CX0+7					//Cube bottom (layer 7)
		ldy #<CY0+7
		ldx #<XBit2					//Plot 1 FG color
		stx pb0c+1
		jsr UpdateCXY
		lda #<X0+16					//Starts at X16/Y16
		ldy #<Y0+16
		ldx #$17					//24 plots total	
		jsr MkPlot1

		ldy #$02
JmpLoop:
		lda irjmp,y
		sta (ZP),y
		dey
		bpl JmpLoop

		rts

//----------------------------------

MkDel:
		sta ZP
		stx ZP+1
		ldx #$22
md20:	ldy #<dzbx-dzb0-1			//34 instances with ZP vectors
md21:	lda dzb0,y
		sta (ZP),y
		dey
		bpl md21
		lda dzb0+1
		clc
		adc #$02
		sta dzb0+1
		lda #<dzbx-dzb0
		jsr AddZP
		dex
		bne md20

		ldx #$01					//352 instances = 2*176 (2*#$b0)
		stx Cnt
md22:	ldx #$b0
md23:	ldy #<db1x-db10-1
md24:	lda db10,y
		sta (ZP),y
		dey
		bpl md24
		lda #<db1x-db10
		jsr AddZP
		dex
		bne md23
		dec Cnt
		bpl md22
		rts

//----------------------------------
//		Plot 0
//----------------------------------

AddY0:	ldy #$00
		lda #$a0
		sta (ZP),y
		tya
		iny
		sta (ZP),y
		lda #$02
		jmp AddZP

//----------------------------------

MkPlot0:
		sta dp10+1
		sty dp14+1
md26:	ldy #<dp1x-dp10				//	0e 0b 0c 0a 0d 08 09 07 0f
md27:	lda dp10,y					//	x- xx xx xx xx xx xx xx x-
		sta (ZP),y
		dey
		bpl md27
		lda #<dp1x-dp10
		jsr AddZP

UpdateDPB0:
		inc dp10+1					//CX
		inc dp14+1					//CY

		ldy dp13+1					//DelZP+3
		iny
		sty dp15+1					//DelZP+0
		sty dp17+1
		sty dp19+1
		iny
		sty dp12+1					//DelZP+1
		iny
		sty dp16+1					//DelZP+2
		sty dp1a+1
		iny
		sty dp13+1					//DelZP+3

		dex
		bpl md26
		rts

UpdateAll:
		stx pb0c+2
UpdateCXY:
		sta pb01+1
		sty pb07+1
		rts

//----------------------------------
//		Plot 1-8
//----------------------------------

MkPlot1:
		sta pb00+1
		sty pb06+1
md18:

		lda Cnt
		cmp #$05
		bne SkipBGCol1
		cpx #$05					//Adjust this +/- with final music if needed to make sure color change is in VBLANK
		bne SkipBGCol1
		ldy #<bb0x-bb00-1
AddBGCol1:
		lda bb00,y
		sta (ZP),y
		dey
		bpl AddBGCol1
		lda #<bb0x-bb00
		jsr AddZP
SkipBGCol1:

lda	YR+1
		beq md19
		cpx #$10
		bne md19

		dec YR+1

		jsr AddBGColToPlot

md19:	ldy #<pb0x-pb00
md1a:	lda pb00,y
		sta (ZP),y
		dey
		bpl md1a
		lda #<pb0x-pb00
		jsr AddZP

UpdatePB:
		lda pb03+1
		adc #$06
		sta pb03+1
		bcc *+6
		inc pb03+2
		clc

		lda pb05+1
		adc #$06
		sta pb05+1
		bcc *+6
		inc pb05+2
		clc

		lda pb09+1
		adc #$06
		sta pb09+1
		bcc *+6
		inc pb09+2
		clc

		lda pb0a+1
		adc #$06
		sta pb0a+1
		bcc *+5
		inc pb0a+2

		inc pb00+1
		inc pb06+1

		dex
		bpl md18
		rts

AddBGColToPlot:
		ldy #<bb0x-bb00-1
	AddBGCol2:
		lda bb00,y
		sta (ZP),y
		dey
		bpl AddBGCol2
		lda ZP
		clc
		adc #$02
		sta NOP1+1
		sta NOP2+1
		lda ZP+1
		adc #$00
		cmp #$a8
		bcs SkipDP1
		sta NOP1+2
	SkipDP1:
		sta NOP2+2
		lda #<bb0x-bb00
		jmp AddZP

//----------------------------------

ResetBases:
		jsr ResetPB0

ResetDel:
		lda #>Map2
		sta db10+2
		lda #<DelPlot2
		sta ZP
		lda #>DelPlot2
		sta ZP+1

ResetDPB0:
		lda #<CX
		sta dp10+1
		lda #<CY
		sta dp14+1
		lda #<XTabHi2
		sta dp11+1

ResetPB:
		ldy #<DelPlot2+[17*4]+1
		sty pb09+1
		ldy #>DelPlot2+[17*4]+1
		sty pb09+2
		ldy #<DelPlot2+[17*4]+2
		sty pb03+1
		ldy #>DelPlot2+[17*4]+2
		sty pb03+2
		ldy #<DelPlot2+[17*4]+4
		sty pb0a+1
		ldy #>DelPlot2+[17*4]+4
		sty pb0a+2
		ldy #<DelPlot2+[17*4]+5
		sty pb05+1
		ldy #>DelPlot2+[17*4]+5
		sty pb05+2
		rts
		
ResetPB0:
		sta ZP
		sty ZP+1
		stx pb02+1
		
ResetPB1:
		lda #<CX0
		sta pb01+1
		lda #<CY0
		sta pb07+1

ResetPB2:
		lda #<X0
		sta pb00+1
		lda #<Y0
		sta pb06+1
		rts

irjmp:	jmp irb3x

//-----------------------------------

ColorBase:
cb00:	lda #$ca
		sta $d018
		lda #$3c
		sta $dd02
		lda #$1b
		sta $d011
		lda Color1
		sta $d021
		lda Color2
		sta $d022
		lda Color3
		sta $d023
		jsr BASE_PlayMusic
		ldy #$00
		clc
		jmp $c0de
cb0x:

BGColorBase:
bb00:	lda #CubeBGCol
		sta $d020
bb0x:

PlotBase:

//-----------------------------------
pb00:	lda X0					//3		2	+1
pb01:	adc CX0					//3		2	+1
		tax						//2		1
//-----------------------------------
pb02:	lda XTabHi1,x			//4		3		Map1 & Map2
		sta ZP+1				//3		2
pb03:	sta DelPlot1+[17*4]+2	//4		3	+3	Change to ZP for MidPlot (takes $66 bytes on ZP ($10*3+3)x2)
pb05:	sta DelPlot1+[17*4]+5	//4		3	+3
//-----------------------------------
pb06:	lda Y0					//3		2	+1
pb07:	adc CY0					//3		2	+1
//-----------------------------------		Change to lda ZPDel+1, adc CY0, eor #$80 where possible (128 occurances)
pb08:	eor XTabLo,x			//4		3		saves 256 cycles, 4 rasters...
pb09:	sta DelPlot1+[17*4]+1	//4		3	+3	Change to ZP for MidPlot
		tay						//2		1		saves 2 cycles per MidPlot (32 cycles total here)
		lda (ZP),y				//5		2		Total save: 288 cycles = 4.82 rasters
pb0c:	and XBit1,x				//4		3		Max ZPDel: 23 instances = 46 cycles saved (vs 32), takes $90 bytes in ZP
		sta (ZP),y				//6		2		Total save: 302 cycles = 5.05 rasters 
		tax						//2		1
		tya						//2		1
		eor #$ff				//2		2
pb0a:	sta DelPlot1+[17*4]+4	//4		3	+3	Change to ZP for MidPlot
		tay						//2		1
pb0d:	lda XRev,x				//4		3		reverse bit order
pb0b:	sta (ZP),y				//6		2
pb0x:	rts						//76c	49b	76*176=13376 cycles (223 rasters), 47*176=8272 ($2050) bytes

DelBase:

db10:	sta Map1
db1x:	rts

DPBase0:

dp10:	ldx CX					//3		2		CX-X0-X15
dp11:	lda XTabHi1,x			//4		3
dp12:	sta DelZP+1				//3		2	10	
dp13:	sta DelZP+3				//3		2
dp14:	lda CY					//3		2		CY-Y0-Y15
		eor XTabLo,x			//4		3	20
dp15:	sta DelZP+0				//3		2
		eor #$ff				//2		2
dp16:	sta DelZP+2				//3		2
dp17:	lda (DelZP+0),y			//5		2	33
dp18:	and XBit1,x				//4		3
dp19:	sta (DelZP+0),y			//6		2	43
		tax						//2		1
		lda XRev,x				//4		3
dp1a:	sta (DelZP+2),y			//6		2	55
dp1x:	rts						//55c	33b	55+12=67 cycles for plane 0, 17*67=1139 cycles (19.04 rasters)

DelZPBase:
dzb0:	sta (DelZP),y
dzbx:

.align $100
SinBase:
.fill $40,36*sin(toRadians([i+0.5]*360/256))