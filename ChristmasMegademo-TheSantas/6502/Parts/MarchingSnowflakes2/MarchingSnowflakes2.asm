//--------------------------
//	Marching SnowFlakes
//		Part 2
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
.const	Ctr2		=$37
.const	Ctr3		=$38

.const	Scr		=$0400
.const	Charmap	=$2000
.const	Sprites	=$22c0

.const	VICBank	= 0

.const	D018Value	=((Scr - (VICBank * $4000)) / $40) + ((Charmap - (VICBank * $4000)) / $400)
.const	SpritePtr	=(Sprites - (VICBank * $4000)) / $40

//-----------------------------------

*=MarchingSnowflakes2_BASE

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

		ldx	#<irqm
		ldy	#>irqm
		lda	#$00
		jsr	NextIRQ

		asl	$d019
		
		cli

		lda	Phase
		bne	ir01

		jsr	ScrollIn
		jmp	ir0_z

ir01:		cmp	#$01
		bne	ir02

		jsr	Triangle1
		jmp	ir0_z

ir02:		cmp	#$02
		bne	ir03

		jsr	Triangle2
		jmp	ir0_z

ir03:		cmp	#$03
		bne	ir0_z

		jsr	ScrollOut

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

		asl	$d019

irm_s:	lda	#$00
		beq	SkipSprites

		ldx	#<irs1
		ldy	#>irs1
		lda	#$70
		jsr	NextIRQ

		lda	SpriteCoords+6
		sta	$d010

		ldx	#$05
irm_1:	lda	SpriteCoords,x
		sta	$d000,x
		dex
		bpl	irm_1

		bmi	irm_z

SkipSprites:
		ldx	#<irq
		ldy	#>irq
		lda	#$fa
		jsr	NextIRQ
		
irm_z:	lda	#$35
		sta	$01
irm_y:	ldy	#$00
irm_x:	ldx	#$00
irm_a:	lda	#$00
		rti

//----------------------------

NextIRQ:	stx	$fffe
		sty	$ffff
		sta	$d012
		rts

//----------------------------

irs1:		sta	is1_a+1
		stx	is1_x+1
		sty	is1_y+1

		lda	$01
		sta	is1_z+1

		jsr	NextSp
		
		ldx	#<irs2
		ldy	#>irs2
		lda	#$a8
		jsr	NextIRQ
		
		asl	$d019

is1_z:	lda	#$35
		sta	$01
is1_y:	ldy	#$00
is1_x:	ldx	#$00
is1_a:	lda	#$00
		rti

irs2:		sta	is2_a+1
		stx	is2_x+1
		sty	is2_y+1

		lda	$01
		sta	is2_z+1

		jsr	NextSp

		ldx	#<irq
		ldy	#>irq
		lda	#$fa
		jsr	NextIRQ

		asl	$d019

is2_z:	lda	#$35
		sta	$01
is2_y:	ldy	#$00
is2_x:	ldx	#$00
is2_a:	lda	#$00
		rti

NextSp:	lda	#$35
		sta	$01

		ldx	#$05
		sec
ns00:		lda	$d000,x
		adc	#$37
		sta	$d000,x
		dex
		lda	$d000,x
		sbc	#$1f
		sta	$d000,x
		bcs	ns04
		lda	$d010
		cpx	#$00
		bne	ns01
		and	#$fe
		jmp	ns03
ns01:		cpx	#$02
		bne	ns02
		and	#$fd
		jmp	ns03
ns02:		ora	#$04
ns03:		sta	$d010

ns04:		dex
		bpl	ns00
		rts

//----------------------------

ScrollIn:	lda	SY0
		and	#$07
		bne	*+5
		jsr	CopyChars
		
		jsr	Vertical
		jsr	VertY

		ldx	Counter
		bpl	siend
		
		inc	Phase		//Next phase
		
		inc	irm_s+1

		lda	$d008
		sta	$d004
		sta	SpriteCoords+4
		sec
		sbc	#$10
		sta	$d002
		sta	SpriteCoords+2
		sbc	#$10
		sta	$d000
		sta	SpriteCoords+0

		lda	$d009
		sta	$d005
		sta	SpriteCoords+5
		sta	$d001
		sta	SpriteCoords+1
		sec
		sbc	#$1c
		sta	$d003
		sta	SpriteCoords+3

		lda	#<irs1
		sta	$fffe
		lda	#>irs1
		sta	$ffff
		lda	#$70
		sta	$d012
		
		lda	#$07
		sta	$d015

		lda	#$19
		sta	Tmr

		lda	#$23
		sta	Counter

		lda	SX0
		ora	#$20
		sta	SX2
		lda	#$08
		sta	SY0
		sta	SY2
		lda	SX1
		ora	#$10
		sta	SX1
		lda	#$24
		sta	SY1

siend:	rts

//----------------------------------

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
		sta	Tmr		//Wait 0.5 seconds

		lda	#$27
		sta	Counter

		rts

UpdateSprite:
		ldx	Counter

		lda	SpriteCol,x
		sta	$d027
		sta	$d028
		cpx	#$16
		bne	SkipSpSwitch
		dec	Scr+$03f8
		dec	Scr+$03f9
SkipSpSwitch:		

		ldy	#$00
		jsr	SetSp2
		
		ldy	#$02
		jsr	SetSp0
		
		ldy	#$04
SetSp0:	txa
		clc
		adc	#$24

SetSp1:	tax
SetSp2:	lda	SpriteCoords,y
		clc
		adc	MX,x
		sta	SpriteCoords,y
		
		lda	SpriteCoords+1,y
		sec
		sbc	MY,x
		sta	SpriteCoords+1,y
		rts

//----------------------------------

ScrollOut:	lda	Tmr
		beq	SkipTmr3

		dec	Tmr
		rts

SkipTmr3:	lda	SX0
		and	#$07
		bne	*+5
		jsr	DeleteChars
		jsr	Horizontal

		jsr	HorX

		ldx	Counter
		bpl	soend
		
		inc	Phase

		inc	PART_Done

soend:	rts

DeleteChars:ldx	Counter
		lda	#$00
		sta	Scr+$28,x
		sta	Scr+$50,x
		sta	Scr+$28+$118,x
		sta	Scr+$50+$118,x
		sta	Scr+$28+$230,x
		sta	Scr+$50+$230,x
		sta	Scr+$28+$348,x
		sta	Scr+$50+$348,x

		lda	#$27
		sec
		sbc	Counter
		tax
		lda	#$00
		sta	Scr+$a0,x
		sta	Scr+$c8,x
		sta	Scr+$f0,x
		sta	Scr+$a0+$118,x
		sta	Scr+$c8+$118,x
		sta	Scr+$f0+$118,x
		sta	Scr+$a0+$230,x
		sta	Scr+$c8+$230,x
		sta	Scr+$f0+$230,x

		dec	Counter

		rts

//----------------------------------------------------------

CopyChars:	ldy	#$00
		lax	NextChar0
cc00:		sta	(ZP1),y
		jsr	Add07
		iny
		sta	(ZP1),y
		jsr	Add15
		iny
		iny
		iny
		cpy	#$28
		bne	cc00

		lda	ZP1		//Next char row
		clc
		adc	#$28
		sta	ZP1
		bcc	*+4
		inc	ZP1+1

		inx
		dec	Ctr2
		bpl	cc01
		txa
		jsr	Add15
		tax
		lda	#$06
		sta	Ctr2

cc01:		stx	NextChar0

		ldy	#$02
		lax	NextChar1
cc02:		sta	(ZP2),y
		jsr	Add07
		iny
		sta	(ZP2),y
		jsr	Add15
		iny
		iny
		iny
		cpy	#$28
		bcc	cc02

		lda	ZP2		//Previous char row
		sec
		sbc	#$28
		sta	ZP2
		bcs	*+4
		dec	ZP2+1

		dex
		dec	Ctr3
		bpl	cc03
		txa
		sec
		sbc	#$15
		bcs	*+4
		adc	#$54
		tax
		lda	#$06
		sta	Ctr3

cc03:		stx	NextChar1
		
		dec	Counter

		rts

HorX:		lda	SX1
		clc
		adc	#$02
		and	#$1f
		sta	SX1
		
		lda	SX0
		sec
		sbc	#$02
		and	#$1f
		sta	SX0
		
SkipOnce:	lda	#$00	
		bne	SPX	
		inc	SkipOnce+1		
		bne	hx02		
		
SPX:		lda	SpriteCoords+4
		sec
		sbc	#$02
		sta	SpriteCoords+4
		bcs	hx00
		lda	$d015
		and	#$fb
		sta	$d015		
hx00:		lda	SpriteCoords+0
		clc
		adc	#$02
		sta	SpriteCoords+0
		bmi	hx01
		lda	#$01
		sta	SpriteCoords+6
hx01:		lda	SpriteCoords+2
		clc
		adc	#$02
		sta	SpriteCoords+2
		bmi	hx02
		lda	#$03
		sta	SpriteCoords+6
hx02:		rts

VertY:	jsr	SpritesIn	
		lda	SY0
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
		
SpritesIn:	lda	$d005
		sec
		sbc	#$02
		sta	$d005
		bcs	spin0
		lda	$d015
		ora	#$04
		sta	$d015
spin0:	lda	$d007	
		sec	
		sbc	#$02
		sta	$d007
		bcs	spin1
		lda	$d015
		ora	#$08
		sta	$d015
spin1:	lda	$d009
		sec
		sbc	#$02
		sta	$d009
		bcs	spin2
		lda	$d015
		ora	#$10
		sta	$d015
spin2:	rts

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
		
Add07:	clc
		adc	#$07
		cmp	#$54
		bcc	*+4
		sbc	#$54
		rts

Add15:	clc
		adc	#$15
		cmp	#$54
		bcc	*+4
		sbc	#$54
		rts

//----------------------------
//		INIT
//----------------------------

//----------------------------
//		Snowflake Tab

Init:		lda	#<SFTab	//Creates a bitwise shifted version of the snowflake pattern		
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

		lda	#$54			//char not used for scroll-in to start with a clear screen
		ldx	#$00
in03:		sta	Scr,x
		sta	Scr+$100,x
		sta	Scr+$200,x
		sta	Scr+$2e8,x
		inx
		bne	in03

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
		lda	#$00			//Start positions of snowflakes
		sta	SX0
		lda	#$28
		sta	SY0
		sty	PY1
		lda	#$10
		sta	SX1
		lda	#$04
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
		
		ldx	#SpritePtr			//$22c0-$2340
		stx	Scr+$3fa
		stx	Scr+$3fb
		stx	Scr+$3fc
		inx
		stx	Scr+$3f8
		stx	Scr+$3f9

		ldx	#$05
scrdloop:	lda	SpriteCoords,x
		sta	$d004,x
		dex
		bpl	scrdloop
		lda	#$00
		sta	$d010
		lda	#$00
		sta	$d015

		ldx	#$05
		lda	#$0a
scolloop:	sta	$d029,x
		dex
		bpl	scolloop
		lda	#$01
		sta	$d027
		sta	$d028

		:MACRO_SetVICBank(VICBank)	//$0000-$3fff

		lda	#D018Value
		sta	$d018

		lda	#$00
		sta	Phase
		sta	Tmr
		
		lda	#$18				//Preps for scroll in (25 rows)
		sta	Counter
		lda	#$06
		sta	Ctr2
		lda	#$03
		sta	Ctr3
		lda	#$00
		sta	NextChar0
		lda	#$11
		sta	NextChar1
		
		lda	#<Scr				//Screen row start positions for scroll in
		sta	ZP1
		lda	#>Scr
		sta	ZP1+1
		lda	#<Scr+$3c0
		sta	ZP2
		lda	#>Scr+$3c0
		sta	ZP2+1

		lda	SX1
		jmp	SetSF				//Prepare ZP addresses for vertical movement

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
SpriteCoords:
.byte	$88,$88,$a8,$50,$c8,$18,$00
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
