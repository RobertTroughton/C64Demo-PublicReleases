//--------------------------
//	Marching SnowFlakes
//		Part 1
//--------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"

.const	ZP1		=$10
.const	SF0		=$12
.const	SF1		=$14
.const	SF2		=$16
.const	SF3		=$18
.const	SF4		=$1a
.const	SF5		=$1c
.const	SF6		=$1e
.const	SF7		=$20
.const	SF8		=$22

.const	SX0		=$24
.const	SX1		=$25
.const	SX2		=$26
.const	SY0		=$27
.const	SY1		=$28
.const	SY2		=$29
.const	PY0		=$2a
.const	PY1		=$2b

.const	Counter	=$2c
.const	NextChar0	=$2d
.const	NextChar1	=$2e
.const	Phase		=$2f

.const	ZP2		=$30
.const	ZP3		=$32
.const	ZP4		=$34

.const	Tmr		=$36

.const	Scr		=$0400
.const	Charmap	=$2000
.const	Sprites	=$22c0

.const	VICBank	= 0

.const	D018Value	=((Scr - (VICBank * $4000)) / $40) + ((Charmap - (VICBank * $4000)) / $400)
.const	SpritePtr	=(Sprites - (VICBank * $4000)) / $40

*=MarchingSnowflakes1_BASE

		jmp	Init

//-----------------------------------

Go:		:vsync()

		lda	#<irq
		sta	$fffe
		lda	#>irq
		sta	$ffff
		lda	#$fa
		sta	$d012
		lda	#$1b
		sta	$d011
		rts

//-----------------------------------

irq:		sta	ir0_a+1
		stx	ir0_x+1
		sty	ir0_y+1

		lda	$01
		sta	ir0_z+1

		lda	#$35
		sta	$01

		lda	#<irqm
		sta	$fffe
		lda	#>irqm
		sta	$ffff
		lda	#$00
		sta	$d012

		asl	$d019
		
		cli

		lda	Phase
		bne	ir01

		jsr	ScrollIn
		jmp	ir0m

ir01:		cmp	#$01
		bne	ir02

		jsr	Scroll
		jmp	ir0m

ir02:		cmp	#$02
		bne	ir03

		jsr	Triangle1
		jmp	ir0m

ir03:		cmp	#$03
		bne	ir04

		jsr	Triangle2
		jmp	ir0m

ir04:		cmp	#$04
		bne	ir0m

		jsr	ScrollOut

ir0m:		//jsr	BASE_PlayMusic


ir0_z:	lda	#$35
		sta	$01
ir0_y:	ldy	#$00
ir0_x:	ldx	#$00
ir0_a:	lda	#$00
		rti

irqm:		sta	irm_a+1
		stx	irm_x+1
		sty	irm_y+1

		lda	$01
		sta	irm_z+1

		lda	#$35
		sta	$01

		jsr	BASE_PlayMusic

		lda	#<irq
		sta	$fffe
		lda	#>irq
		sta	$ffff
		lda	#$fa
		sta	$d012

		asl	$d019
		
irm_z:	lda	#$35
		sta	$01
irm_y:	ldy	#$00
irm_x:	ldx	#$00
irm_a:	lda	#$00
		rti

//----------------------------

Scroll:	ldx	Counter
		beq	sc00

		jsr	Horizontal
		jsr	HorX
		dec	Counter
		rts

sc00:		jsr	Horizontal
		jsr	HorSprite

		inc	Phase		//Next phase
		
		lda	#$19
		sta	Tmr		//Wait 1 second

		lda	#$23
		sta	Counter

		lda	SX0
		ora	#$20
		sta	SX2
		lda	SY0
		sta	SY2
		lda	SX1
		ora	#$10
		sta	SX1
		rts

//----------------------------

tr10:		jsr	UpdateMapT

		lda	#$23
		sta	Counter

		lda	#$30
		sta	SX0
		lda	#$40
		sta	SX1
		lda	#$50
		sta	SX2
		lda	#$24
		sta	SY0
		sta	SY2
		lda	#$08
		sta	SY1

		lda	$d000
		sec
		sbc	#$10
		sta	$d002
		clc
		adc	#$20
		sta	$d004
		lda	$d001
		clc
		adc	#$1c
		sta	$d003
		sta	$d005

		inc	Phase
		
		lda	#$19
		sta	Tmr		//Wait 1 second

		rts

Triangle1:	lda	Tmr
		beq	SkipTmr1

		dec	Tmr
		rts

SkipTmr1:	lda	Counter
		bmi	tr10
		
		ldx	#$02
		clc
		adc	#$48
tr11:		tay
		lda	SX0,x
		clc
		adc	MX,y
		bpl	*+5
		clc
		adc	#$5f
		sta	SX0,x
		
		lda	SY0,x
		clc
		adc	MY,y
		bpl	*+5
		clc
		adc	#$38
		cmp	#$38
		bcc	*+4
		sbc	#$38
		sta	SY0,X
		tya
		sec
		sbc	#$24
		dex
		bpl	tr11

		jsr	SetSFT
		jsr	UpdateMapT
		jsr	CorrectSF1
		dec	Counter
		rts	

CorrectSF1:	ldy	#$08
		jsr	CalcZP
		jsr	csf1-2

		ldy	#$0c
		jsr	CalcZP

		ldy	#$24
csf1:		lda	SFTab,x
		sta	(ZP2),y
		lda	SFTab+$80,x
		sta	(ZP3),y
		lda	SFTab+$100,x
		and	(ZP4),y
		sta	(ZP4),y
		iny
		cpy	#$38
		bne	*+4
		ldy	#$00
		txa
		axs	#$f8
		bpl	csf1
		rts

CalcZP:	ldx	#$06
csf11:	lda	SFHi,y
		sta	ZP2-1,x
		dex
		lda	SFLo,y
		sta	ZP2-1,x
		dey
		dex
		bne	csf11
		rts		

CorrectSF2:	ldy	#$02
		jsr	csf2

		ldy	#$06
csf2:		jsr	CalcZP
		ldy	#$08
		jmp	csf1

//----------------------------------
		
Triangle2:	lda	Tmr
		beq	SkipTmr2

		dec	Tmr
		rts

SkipTmr2:	lda	Counter
		clc
		adc	#$48
		ldx	#$02

tr20:		tay
		lda	SX0,x
		clc
		adc	MX,y
		bpl	*+5
		clc
		adc	#$5f
		sta	SX0,x
		
		lda	SY0,x
		sec
		sbc	MY,y
		bcs	*+4
		adc	#$38
		cmp	#$38
		bcc	*+4
		sbc	#$38
		sta	SY0,x
		tya		
		sec		
		sbc	#$24		
		dex		
		bpl	tr20		

		jsr	UpdateSprite
		jsr	SetSFT
		jsr	UpdateMapT
		jsr	CorrectSF2

		dec	Counter
		bmi	skiptr2end		

		rts

skiptr2end:	lda	#$00
		sta	SX0
		lda	#$10
		sta	SX1
		lda	#$08
		sta	SY0
		lda	#$24
		sta	SY1

		inc	Phase
		
		lda	#$19
		sta	Tmr		//Wait 1 second

		lda	#$18
		sta	Counter

		lda	#<Scr
		sta	ZP2
		lda	#>Scr
		sta	ZP2+1
		lda	#<Scr+$3c2
		sta	ZP3
		lda	#>Scr+$3c2
		sta	ZP3+1
		
		lda	#$08
		sta	PY0
		lda	#$24
		sta	PY1
		
		lda	SX1
		jmp	SetSF

UpdateSprite:
		ldx	Counter

		lda	SpriteCol,x
		sta	$d028
		sta	$d029
		lda	#$07
		sta	$d015
		cpx	#$16
		bne	SkipSpSwitch
		dec	Scr+$03f9
		dec	Scr+$03fa
SkipSpSwitch:		

		ldy	#$02
		jsr	SetSp2
		
		ldy	#$00
		jsr	SetSp0
		
		ldy	#$04
SetSp0:	txa
		clc
		adc	#$24

SetSp1:	tax
SetSp2:	lda	$d000,y
		clc
		adc	MX,x
		sta	$d000,y
		
		lda	$d001,y
		sec
		sbc	MY,x
		sta	$d001,y
		rts

//----------------------------------

UpdateMapT:	lda	SX0
		ldy	SY0
		and	#$07
		tax
umt0:		lda	SFTab,x
		sta	(SF0),y
		lda	SFTab+$80,x
		sta	(SF1),y
		lda	SFTab+$100,x
		sta	(SF2),y
		iny
		cpy	#$38
		bne	*+5
		jsr	Overlap
		txa
		axs	#$f8
		bpl	umt0
		
		lda	SX1
		ldy	SY1
		and	#$07
		tax
umt1:		lda	SFTab,x
		sta	(SF3),y
		lda	SFTab+$80,x
		sta	(SF4),y
		lda	SFTab+$100,x
		sta	(SF5),y
		iny
		cpy	#$38
		bne	*+4
		ldy	#$e0
		txa
		axs	#$f8
		bpl	umt1

		lda	SX2
		ldy	SY2
		and	#$07
		tax
umt2:		lda	SFTab,x
		sta	(SF6),y
		lda	SFTab+$80,x
		sta	(SF7),y
		lda	SFTab+$100,x
		sta	(SF8),y
		iny
		cpy	#$38
		bne	*+4
		ldy	#$e0
		txa
		axs	#$f8
		bpl	umt2
		
		rts

Overlap:	lda	SX0
		lsr
		lsr
		lsr
		tay
		lda	SFLo+4,y
		sta	SF0
		lda	SFHi+4,y
		sta	SF0+1
		lda	SFLo+5,y
		sta	SF1
		lda	SFHi+5,y
		sta	SF1+1
		lda	SFLo+6,y
		sta	SF2
		lda	SFHi+6,y
		sta	SF2+1
		ldy	#$00
		rts

SetSFT:	ldy	#$00
		lda	SX0
		jsr	ssft

		ldy	#$06
		lda	SX1
		jsr	ssft
		
		ldy	#$0c
		lda	SX2

ssft:		lsr
		lsr
		lsr
		tax
		lda	SFLo,x
		sta	SF0,y
		lda	SFHi,x
		sta	SF0+1,y
		lda	SFLo+1,x
		sta	SF1,y
		lda	SFHi+1,x
		sta	SF1+1,y
		lda	SFLo+2,x
		sta	SF2,y
		lda	SFHi+2,x
		sta	SF2+1,y
		rts

//----------------------------

ScrollIn:	lda	SX0
		and	#$07
		bne	*+5
		jsr	CopyChars
		
		jsr	Horizontal
		jsr	HorX

		ldx	Counter
		bpl	siend
		
		inc	Phase		//Next phase

		ldx	#$03		//Prep Scroll phase
		stx	Counter	//this will bring the snowflakes to their start position (SX0:$00, SX1:$10, SY0:$08, SY1:$24)

siend:	rts

HorX:		jsr	HorSprite
		lda	SX1
		clc
		adc	#$02
		and	#$1f
		sta	SX1
		
		lda	SX0
		sec
		sbc	#$02
		and	#$1f
		sta	SX0

		rts

HorSprite:	lda	$d000
		sec
		sbc	#$02
		sta	$d000
		lda	$d010
		sbc	#$00
		sta	$d010
		rts

CopyChars:	ldx	Counter
		lda	NextChar0
		sta	Scr+$28,x
		jsr	Add1c
		sta	Scr+$28+$118,x
		jsr	Add1c
		sta	Scr+$28+$230,x
		jsr	Add1c
		sta	Scr+$28+$348,x
		clc
		adc	#$01
		sta	Scr+$50,x
		jsr	Add1c
		sta	Scr+$50+$118,x
		jsr	Add1c
		sta	Scr+$50+$230,x
		jsr	Add1c
		sta	Scr+$50+$348,x

		lda	#$27
		sec
		sbc	Counter
		tax
		lda	NextChar1
		sta	Scr+$a0,x
		jsr	Add1c
		sta	Scr+$a0+$118,x
		jsr	Add1c
		sta	Scr+$a0+$230,x
		jsr	Add1c
		clc
		adc	#$01
		sta	Scr+$c8,x
		jsr	Add1c
		sta	Scr+$c8+$118,x
		jsr	Add1c
		sta	Scr+$c8+$230,x
		jsr	Add1c
		clc
		adc	#$01
		sta	Scr+$f0,x
		jsr	Add1c
		sta	Scr+$f0+$118,x
		jsr	Add1c
		sta	Scr+$f0+$230,x
		lda	NextChar0
		sec
		sbc	#$07
		bcs	*+4
		adc	#$54
		sta	NextChar0
		lda	NextChar1
		clc
		adc	#$07
		cmp	#$58
		bcc	*+4
		sbc	#$54
		sta	NextChar1

		dec	Counter

		rts

//----------------------------

ScrollOut:	lda	Tmr
		beq	SkipTmr3

		dec	Tmr
		rts

SkipTmr3:	lda	SY0
		and	#$07
		cmp	#$02
		bne	*+5
		jsr	DeleteChars
		jsr	Vertical
		
		jsr	VertY
		
SkipOnce:	lda	#$00	
		bne	SpY	
		inc	SkipOnce+1		
		bne	SkipY		
			
SpY:		lda	$d001
		sec
		sbc	#$02
		sta	$d001
		sta	$d003
		bcs	NextSp
		lda	#$00
		sta	$d000
		sta	$d002
NextSp:	lda	$d005
		clc
		adc	#$02
		sta	$d005	
		bcc	SkipY	
		lda	#$00	
		sta	$d004	
SkipY:
		ldx	Counter
		bpl	soend

		inc	PART_Done

soend:	rts

VertY:	lda	SY0
		sta	PY1
		clc
		adc	#$02
		cmp	#$38
		bcc	*+4
		sbc	#$38
		sta	SY0
		
		lda	SY1
		sta	PY0
		sec
		sbc	#$02
		bcs	*+4
		adc	#$38
		sta	SY1
		rts

DeleteChars:lda	#$54		//First unused char
		ldx	#$09
		ldy	#$00
dc00:		sta	(ZP2),y
		sta	(ZP3),y
		iny
		sta	(ZP2),y
		sta	(ZP3),y
		iny
		iny
		iny
		dex
		bpl	dc00

		lda	ZP2
		clc
		adc	#$28
		sta	ZP2
		bcc	*+4
		inc	ZP2+1

		lda	ZP3
		sec
		sbc	#$28
		sta	ZP3
		bcs	*+4
		dec	ZP3+1

		dec	Counter
		rts

//----------------------------

Horizontal:	
		ldx	#$00
		jsr	UpdateMapH
		ldx	#$01
UpdateMapH:	lda	SX0,x
		ldy	SY0,x
		pha
		jsr	SetSF
		pla
		and	#$07
		tax
umh0:		lda	SFTab,x
		sta	(SF0),y
		sta	(SF3),y
		sta	(SF6),y
		lda	SFTab+$80,x
		sta	(SF1),y
		sta	(SF4),y
		sta	(SF7),y
		lda	SFTab+$100,x
		sta	(SF2),y
		sta	(SF5),y
		sta	(SF8),y
		iny
		cpy	#$38
		bne	*+4
		ldy	#$00
		txa
		axs	#$f8
		bpl	umh0
		rts

//----------------------------

Vertical:	ldx	#$00
		jsr	UpdateMapV
		ldx	#$01
UpdateMapV:	ldy	PY0,x
		iny
		cpx	#$01
		beq	Skip1
		tya
		clc
		adc	#$0d
		tay		
Skip1:	cpy	#$38
		bcc	*+6
		tya
		sbc	#$38
		tay
		jsr	DeleteByte

SkipDB:	lda	SX0,x
		ldy	SY0,x
		pha
		jsr	SetSF
		pla
		and	#$07
		tax
umv1:		lda	SFTab,x
		sta	(SF0),y
		sta	(SF3),y
		sta	(SF6),y
		lda	SFTab+$80,x
		sta	(SF1),y
		sta	(SF4),y
		sta	(SF7),y
		iny
		cpy	#$38
		bne	*+4
		ldy	#$00
		txa
		axs	#$f8
		bpl	umv1
		rts

DeleteByte:	lda	#$ff
		sta	(SF2),y	
		sta	(SF5),y	
		sta	(SF8),y	
DelByte2:	sta	(SF0),y	
		sta	(SF3),y	
		sta	(SF6),y	
DelByte3:	sta	(SF1),y	
		sta	(SF4),y	
		sta	(SF7),y	
		rts

//----------------------------

SetSF:	lsr
		lsr
		lsr
		tax
		lda	SFLo,x
		sta	SF0
		lda	SFHi,x
		sta	SF0+1
		lda	SFLo+1,x
		sta	SF1
		lda	SFHi+1,x
		sta	SF1+1
		lda	SFLo+2,x
		sta	SF2
		lda	SFHi+2,x
		sta	SF2+1
		lda	SFLo+4,x
		sta	SF3
		lda	SFHi+4,x
		sta	SF3+1
		lda	SFLo+5,x
		sta	SF4
		lda	SFHi+5,x
		sta	SF4+1
		lda	SFLo+6,x
		sta	SF5
		lda	SFHi+6,x
		sta	SF5+1
		lda	SFLo+8,x
		sta	SF6
		lda	SFHi+8,x
		sta	SF6+1
		lda	SFLo+9,x
		sta	SF7
		lda	SFHi+9,x
		sta	SF7+1
		lda	SFLo+10,x
		sta	SF8
		lda	SFHi+10,x
		sta	SF8+1
		rts

Add1c:	clc
		adc	#$1c
		cmp	#$54
		bcc	*+4
		sbc	#$54
		rts

//----------------------------
//		INIT
//----------------------------

//----------------------------
//		Snowflake Tab

Init:		lda	#<SFTab		
		sta	ZP1
		lda	#>SFTab
		sta	ZP1+1
		ldy	#$00
		ldx	#$00
in00:		lda	Minta,x
		sta	(ZP1),y
		tya
		clc
		adc	#$08
		tay
		bne	*+4
		inc	ZP1+1
		inx
		cpx	#$30
		bne	in00

		ldx	#$00
in01:		lda	SFTab+$000,x
		lsr
		sta	SFTab+$001,x
		lda	SFTab+$080,x
		ror
		sta	SFTab+$081,x
		lda	SFTab+$100,x
		ror
		sta	SFTab+$101,x
		txa
		axs	#$f8
		bpl	in01
		txa
		axs	#$7f
		cpx	#$07
		bne	in01

		ldx	#$00
in02:		lda	SFTab,x
		eor	#$ff
		sta	SFTab,x
		lda	SFTab+$80,x
		eor	#$ff
		sta	SFTab+$80,x
		lda	SFTab+$100,x
		eor	#$ff
		sta	SFTab+$100,x
		inx
		bpl	in02

//----------------------------
//		Screen

		lda	#$00			//char not used for scroll-in to start with a clear screen
		ldx	#$00
in03:		sta	Scr,x
		sta	Scr+$100,x
		sta	Scr+$200,x
		sta	Scr+$2e8,x
		inx
		bne	in03
		
in04:		sta	Scr,x		//fill in unused char lines
		jsr	Add1c
		sta	Scr+$118,x
		jsr	Add1c
		sta	Scr+$230,x
		jsr	Add1c
		sta	Scr+$348,x
		clc
		adc	#$03
		sta	Scr+$78,x
		jsr	Add1c
		sta	Scr+$78+$118,x
		jsr	Add1c
		sta	Scr+$78+$230,x
		jsr	Add1c
		sta	Scr+$78+$348,x
		clc
		adc	#$04
		cmp	#$54
		bcc	*+4
		sbc	#$54
		inx
		cpx	#$28
		bne	in04

//----------------------------
//		Charmap	$2a8 bytes

		lda	#$ff
		ldx	#$00
in05:		sta	Charmap,x
		sta	Charmap+$100,x
		sta	Charmap+$1c0,x
		inx
		bne	in05

//----------------------------
//		Color RAM

		ldx	#$00
		lda	#$06
in06:		sta	$d800,x
		sta	$d900,x
		sta	$da00,x
		sta	$dae8,x
		inx
		bne	in06
		sta	$d020
		inx
		stx	$d021
		lda	#$00
		sta	SX0
		lda	#$08
		sta	SY0
		sty	PY1
		lda	#$10
		sta	SX1
		lda	#$24
		sta	SY1
		sty	PY0

//----------------------------
//		SFLo + SFHi tabs

		lda	#<Charmap
		sta	ZP1
		ldy	#>Charmap

		ldx	#$00
in07:		lda	ZP1
		sta	SFLo,x
		tya
		sta	SFHi,x
		lda	ZP1
		clc
		adc	#$38
		sta	ZP1
		bcc	*+3
		iny
		inx
		cpx	#$0c
		bne	in07
		ldx	#$03
in08:		lda	SFLo,x
		sta	SFLo+$0c,x
		lda	SFHi,x
		sta	SFHi+$0c,x
		dex
		bpl	in08
		
		ldx	#SpritePtr		//$23c0-$2440
		stx	Scr+$3f8
		inx
		stx	Scr+$3f9
		stx	Scr+$3fa

		lda	#$da
		sta	$d000
		lda	#$72
		sta	$d001
		lda	#$01
		sta	$d010
		sta	$d015
		lda	#$0a
		sta	$d027
		sta	$d028
		sta	$d029

		:MACRO_SetVICBank(VICBank)	//$4000-$7fff

		lda	#D018Value
		sta	$d018

		lda	#$00
		sta	Phase
		sta	Tmr
		
		lda	#$27		//Preps for scroll in
		sta	Counter
		lda	#$16
		sta	NextChar0
		lda	#$04
		sta	NextChar1

		rts

//----------------------------

Minta:
.byte	$00,$01,$00,$13,$34,$0d,$0a,$15
.byte	$15,$0a,$0d,$34,$13,$00,$01,$00
.byte	$00,$40,$80,$e4,$96,$d8,$a8,$d4
.byte	$d4,$a8,$d8,$96,$e4,$80,$40,$00
.fill $10,$00
.align $10
SFLo:
.fill	$10,$00
SFHi:
.fill	$10,$00

//----------------------------

MX:
.byte	$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
.byte	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00
.byte	$00,$01,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00
.byte	$ff,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$ff
.byte	$00,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$01,$00

MY:
//	 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 0A, 0B, 0C, 0D, 0E, 0F, 10, 11
.byte	$00,$00,$01,$01,$01,$01,$01,$01,$00,$01,$00,$00,$01,$00,$00,$00,$00,$00
.byte	$00,$00,$00,$00,$00,$ff,$00,$00,$ff,$00,$ff,$ff,$ff,$ff,$ff,$ff,$00,$00
.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$ff,$00,$00,$ff,$00,$00,$00,$00,$00
.byte	$00,$00,$00,$00,$00,$01,$00,$00,$01,$00,$01,$01,$01,$01,$01,$01,$01,$01
.byte	$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

SpriteCol:
.byte	$0a,$0a,$0a,$0a,$08,$08,$08,$08,$02,$02,$02,$02,$09,$09,$09,$09,$00,$00
.byte	$00,$00,$06,$06,$06,$06,$0e,$0e,$0e,$0e,$03,$03,$03,$03,$01,$01,$01,$01
//----------------------------

SFTab: