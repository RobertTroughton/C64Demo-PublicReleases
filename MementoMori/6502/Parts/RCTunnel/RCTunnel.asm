//-----------------------------------
//	Rotating char tunnel effect
//	By Sparta 2020
//-----------------------------------
//	0160	03ff	Sparkle 2
//	0700	07ff	Main-BaseCode
//	0800	1fff	Music
//	2000	27ff	Main code
//	2800	3fff	UNUSED: $1800 bytes	Free for Loading
//	----------------------
//	4000	7fff	VIC BANK
//	4000	537f	Sprites
//	5400	57bf	Sprite animation tabs
//	5800	5cff	TileMapLoad
//	5800	63ff	UNUSED: $0c00 bytes	Free for Loading (after fade-in)
//	6400	67ff	Screen
//	6800	6fff	Charset
//	----------------------
//	7000	9131	Render
//	9131	9c44	Prep1
//	9c44	a577	Prep2
//	a577	b26a	Prep3
//	b26a	bd7d	Prep4
//	----------------------
//	c000	dfff	UNUSED: $2000 bytes	Free for loading
//	----------------------
//	e000	efff	DepthTab
//	f000	f4ff	TileMap
//	f500	f5ff	ColTab
//	f600	f7ff	AddLoTab
//	f800	f9ff	AddHiTab
//	fa00	fbff	FullDepthTab
//	fc00	fcff	Sine tab
//	----------------------
//	ff00	ff38	D64 Starter - uses Sparkle's Fallback IRQ
//	----------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

//Constants

.const	LogoCount		=12
.const	SpritesPerLogo	=6
.const	IRQRaster		=$b4

.const	Color0		=$09
.const	Color1		=$02
.const	Color2		=$0a
.const	Color3		=$07

.const 	Load		=IRQLoader_LoadNext	

//RAM addresses
.const	MusicPlayer	=BASECODE_PlayMusic
.const	TileMapLoad	=$5800
.const	Screen	=$6400
.const	Chars		=$6800
.const	Render	=$7000			//472 ($1d8) repetitions, $12 bytes each + RTS
.const	Prep1		=Render+[$1d8*$12]+1	//472 ($1d8) repetitions, 6 bytes each + JMP
.const	Prep2		=Prep1+[$1d8*6]+3
.const	Prep3		=Prep2+[$1d8*6]+3
.const	Prep4		=Prep3+[$1d8*6]+3
.const	ColRAM	=$d800
.const	DepthTab	=$e000
.const	AddLoTab	=$f000
.const	AddHiTab	=$f200
.const	FDepth	=$f400
.const	TileMap	=$f600
.const	ColTab	=$fb00
.const	Sin		=$fc00

.const	SXT0		=$5380
.const	SXT1		=SXT0+$040
.const	SXT2		=SXT0+$080
.const	SXT3		=SXT0+$0c0
.const	SXT4		=SXT0+$100
.const	SXT5		=SXT0+$140
.const	SXB0		=SXT0+$180
.const	SXB1		=SXT0+$1c0
.const	SXB2		=SXT0+$200
.const	SXB3		=SXT0+$240
.const	SXB4		=SXT0+$280
.const	SXB5		=SXT0+$2c0
.const	SXBM		=SXT0+$300
.const	STV		=SXT0+$340
.const	SBV		=SXT0+$380

//Zero page

.const	ZP		=$10		//-$11
.const	X		=$12
.const	Y		=$13
.const	TY		=$14
.const	Tmp1		=$15
.const	Tmp2		=$16


*=RCTunnel_BASE	"Main Code"

Main:
		jsr BASECODE_VSync

		jsr	CleanUp
		//sta	Y		//A=#$00
		sta	TY
		lda	#$40
		sta	X

		lda	#$3d		//VIC bank: $4000-$7fff
		sta	$dd02
		lda	#$9a		//Screen: $6400-$67ff, Charset: $6800-$6fff, Sprites: $4000-
		sta	$d018

		jsr	MkRender
		jsr	MkTabs
		jsr	CalcSpriteCoords
		
		jsr	ResetTopSprites
		jsr	ResetBtmSprites

		//lda	#$02
		//sta	PartPhase+1

		lda	#$ff
		sta	$d015		//Sprites on
		sta	$d01c		//Multicolor on

		lda	#$00
		sta	$d025		//Sprite MC1
		lda	#$0a
		sta	$d026		//Sprite MC2
		ldx	#$08
		lda	#$01
mn00:		sta	$d026,x	//Sprite colors
		dex
		bne	mn00

		txa				//Clear TileMap
mn01:		sta	TileMap,x
		sta	TileMap+$100,x
		sta	TileMap+$200,x
		sta	TileMap+$300,x
		sta	TileMap+$400,x
		inx
		bne	mn01

		ldx	#$3f			//Prepare Color Tab
mn02:		lda	#Color0
		sta	ColTab+$00,x
		sta	$d022
		lda	#Color1
		sta	ColTab+$40,x
		sta	$d023
		lda	#Color2
		sta	ColTab+$80,x
		sta	$d024
		lda	#Color3
		sta	ColTab+$c0,x
		dex
		bpl	mn02
		
		jsr BASECODE_VSync

		lda	#$5b
		sta	$d011		//ECM mode
		lda	#IRQRaster
		sta	$d012
		lda	#<irq
		ldx	#>irq
		sta	$fffe
		stx	$ffff

		lda	#$00
		sta	FrameOf256
		sta	Frame_256Counter

		jsr	FadeIn	//Show tunnel

		//ldy	#$80
		//jsr	Wait		//Wait 128 frames before credits (first 128 frames of credits will show nothing)

		dec	PartPhase+1

		jsr	Load

		ldx	#$03
		lda	#$03
WaitFrame:
		cpx	Frame_256Counter
		bcs	WaitFrame
		cmp	FrameOf256
		bcs	WaitFrame

PartPhase:	ldx	#$02		//Wait for IRQ to finish showing credits
		bne	PartPhase

		jsr	FadeOut	//Hide tunnel

		sei			//To avoid next raster IRQ @ $b4. Music just played, default IRQ will take over in the next frame

		//lda	$d011
		//bpl	*-3
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

Wait:		ldx	#IRQRaster-4
		cpx	$d012
		bne	*-3
		cpx	$d012
		beq	*-3
		dey
		bne	Wait
		rts

//----------------------------------

FadeIn:	lda	#$f0
		sta	Tmp2	

		ldx	#$00
fi00:		ldy	#$10

fi01:		lda	TileMapLoad,x
		cmp	Tmp2
		bcc	fi02
		sbc	Tmp2
		sta	TileMap,x
		sta	TileMap+$10,x
		sta	TileMap+$400,x
		sta	TileMap+$410,x
		
fi02:		lda	TileMapLoad+$100,x
		cmp	Tmp2
		bcc	fi03
		sbc	Tmp2
		sta	TileMap+$100,x
		sta	TileMap+$110,x

fi03:		lda	TileMapLoad+$200,x
		cmp	Tmp2
		bcc	fi04
		sbc	Tmp2
		sta	TileMap+$200,x
		sta	TileMap+$210,x

fi04:		lda	TileMapLoad+$300,x
		cmp	Tmp2
		bcc	fi05
		sbc	Tmp2
		sta	TileMap+$300,x
		sta	TileMap+$310,x

fi05:		inx
		dey
		bne	fi01
		txa
		axs	#$f0
		bne	fi00
		lda	Tmp2
		sec
		sbc	#$10
		sta	Tmp2
		bcs	fi00
		rts

//Colors:
//.byte		$0d,$03,$0e,$06,$00,$00,$00
//.byte		$0f,$0a,$02,$09,$00,$00,$00	//1
//.byte		$0a,$08,$02,$09,$00,$00,$00	//2
//.byte		$07,$0a,$02,$09,$00,$00,$00	//3
//.byte		$01,$0f,$0c,$0b,$00,$00,$00	//4
//.byte		$0e,$04,$02,$09,$00,$00,$00	//5


//----------------------------------

FadeOut:	ldx	#$00

fo00:		ldy	#$10
		sec

fo01:		lda	TileMap,x
		beq	fo02
		sbc	#$0c	//08
		bcs	*+5
		lda	#$00
		sec
		sta	TileMap,x
		sta	TileMap+$10,x
		sta	TileMap+$400,x
		sta	TileMap+$410,x

fo02:		lda	TileMap+$100,x
		beq	fo03
		sbc	#$0c	//08
		bcs	*+5
		lda	#$00
		sec
		sta	TileMap+$100,x
		sta	TileMap+$110,x

fo03:		lda	TileMap+$200,x
		beq	fo04
		sbc	#$0c	//08
		bcs	*+5
		lda	#$00
		sec
		sta	TileMap+$200,x
		sta	TileMap+$210,x

fo04:		lda	TileMap+$300,x
		beq	fo05
		sbc	#$0c	//08
		bcs	*+5
		lda	#$00
		sec
		sta	TileMap+$300,x
		sta	TileMap+$310,x

fo05:		inx
		dey
		bne	fo01
		txa
		axs	#$f0
		bne	fo00
		dec	FOCnt
		bpl	fo00
		rts

FOCnt:
.byte	$1f

//----------------------------------

ResetTopSprites:
		lda	#$00
		sta	STOn+1
		lda	#$3a
		sta	SYT+1
		lda	#$00
.for (var i=0;i<5;i++)	{
		sta	SXT+1+i*5}
		rts

//----------------------------------
                                                                     
ResetBtmSprites:
		lda	#$00
		sta	SBOn+1
		lda	#$dd
		sta	SYB+1
		lda	#$58
.for (var i=0;i<6;i++)	{
		sta	SXB+1+i*5}
		lda	#$3f
		sta	SXB_MSB+1
		rts

//----------------------------------

ShowCredits:

CrPhase:	ldx	#$00
		bne	st00
//----------------------------------
//	Phase 0 - Show Btm, reset Top coords
//----------------------------------
BtmWait:	ldx	#$00
		bne	SkipRstT
		jsr	ResetTopSprites
		inc	CrPhase+1
SkipRstT:	dec	BtmWait+1
		rts

st00:		cpx	#$01
		bne	st01
//----------------------------------
//	Phase 1 - Move Top in, Btm out
//----------------------------------
MI:		ldx	#$3f
		jsr	TopInBtmOut
		dec	MI+1
		bpl	SkipNewB
		inc	CrPhase+1
		lda	TopSpr+1
		clc
		adc	#SpritesPerLogo
		sta	BtmSpr+1
		cmp	#(LogoCount+1)*SpritesPerLogo	//$42+12
		bne	SkipNewB
		dec	PartPhase+1
SkipNewB:	rts

st01:		cpx	#$02
		bne	st02
//----------------------------------
//	Phase 2 - Show Top, reset Btm coords
//----------------------------------
TopWait:	ldx	#$00
		bne	SkipRstB
		jsr	ResetBtmSprites
		inc	CrPhase+1
SkipRstB:	dec	TopWait+1
		rts
st02:
//----------------------------------
//	Phase 3 - Move Btm in, Top out
//----------------------------------
MO:		ldx	#$3f
		jsr	BtmInTopOut
		dec	MO+1
		bpl	SkipNewT
		lda	#$00
		sta	CrPhase+1
		lda	#$00
		sta	BtmWait+1
		sta	TopWait+1
		lda	#$3f
		sta	MI+1
		sta	MO+1
		lda	TopSpr+1
		clc
		adc	#(SpritesPerLogo*2)	//$0c
		sta	TopSpr+1
SkipNewT:	rts

//----------------------------------

TopInBtmOut:
		lda	SXT0,x
		sta	SXT+1
		lda	SXT1,x
		sta	SXT+6
		lda	SXT2,x
		sta	SXT+11
		lda	SXT3,x
		sta	SXT+16
		lda	SXT4,x
		sta	SXT+21
		//lda	SXT5,x
		//sta	SXT+26
		lda	STV,x
		sta	STOn+1

BtmOut:	lda	#$17
		sec
		sbc	MOTab,x
		bcs	bo00
		cmp	#$fa
		bcc	bo01
bo00:		lda	#$00
		sta	SBOn+1	
bo01:		sta	SYB+1		
		rts

//----------------------------------

BtmInTopOut:
		lda	SXB0,x
		sta	SXB+1
		lda	SXB1,x
		sta	SXB+6
		lda	SXB2,x
		sta	SXB+11
		lda	SXB3,x
		sta	SXB+16
		lda	SXB4,x
		sta	SXB+21
		lda	SXB5,x
		sta	SXB+26
		lda	SXBM,x
		sta	SXB_MSB+1
		lda	SBV,x
		sta	SBOn+1

TopOut:	lda	MOTab,x
		sta	SYT+1
		cmp	#$1d
		bcs	*+7
		lda	#$00
		sta	STOn+1
		rts

//----------------------------------
//		IRQ @ #$b4
//----------------------------------
	
irq:		//dec	$d020
		sta	irq_a+1
		stx	irq_x+1
		sty	irq_y+1

		dec	$00

		//lda	#$60
		//sta	$d012
		//lda	#<irq60
		//sta	$fffe
		//lda	#>irq60
		//sta	$ffff
		inc	$d019

		//dec	$d020
		lda	#$ff
		sta	$d01c
		//lda	#$01
		//sta	$d027
		//sta	$d028
		//sta	$d029

		jsr	ShowBtmSprites
		//inc	$d020
		
		//cli

		lda	TY
		//anc	#$7f
		//adc	#$c0
		//tax
		//lda	Sin,x
		and	#$0f
		//lsr
		sta	Y
		ldx	X
		lda	Sin,x
		and	#$1f
		sta	Tmp1
		asl
		asl
		asl
		asl
		asl
		ora	Y
		tay
		lda	Tmp1
		lsr
		lsr
		lsr
		beq	P1	
		cmp	#$01	
		beq	P2	
		cmp	#$02	
		beq	P3	
		jsr	Prep4
		jmp	Done
P3:		jsr	Prep3
		jmp	Done
P2:		jsr	Prep2
		jmp	Done
P1:		jsr	Prep1
Done:		
		inc	X
		//lda	X
		//and	#$7f
		//sta	X
		inc	TY
		
		//dec	$d020
		jsr	MusicPlayer
		//inc	$d020
		
		ldx	PartPhase+1
		dex
		bne	irq_end
		
		jsr	ShowCredits
irq_end:
		inc	FrameOf256
		bne	*+5
		inc Frame_256Counter
		inc	$00
irq_y:	ldy	#$00
irq_x:	ldx	#$00
irq_a:	lda	#$00
		//inc	$d020
		rti
/*
//----------------------------------
//		IRQ @ #$60
//----------------------------------

irq60:	//dec	$d020
		sta	ir60_a+1
		
		lda	#$07
		sta	$d015
		lda	#$00
		sta	$d010
		
		lda	#$f8
		sta	$d01c		//Single color
		lda	#$00
		sta	$d027
		sta	$d028
		sta	$d029

		lda	#$6c
		sta	$d001
		sta	$d003
		sta	$d005
		lda	#$94
		sta	$d000
		lda	#$ac
		sta	$d002
		lda	#$c4
		sta	$d004
		lda	#$42
		sta	$77f8
		lda	#$43
		sta	$77f9
		lda	#$44
		sta	$77fa

		lda	#$81
		sta	$d012
		lda	#<irq81
		sta	$fffe
		lda	#>irq81
		sta	$ffff
		inc	$d019

ir60_a:	lda	#$00
		//inc	$d020
		rti

//----------------------------------
//		IRQ @ #$81
//----------------------------------

irq81:	//dec	$d020
		sta	ir81_a+1
		lda	#$05
		sta	$d017		//Y-expand
		lda	#$81
		sta	$d001
		sta	$d005
		lda	#$45
		sta	$77f8
		lda	#$47
		sta	$77fa
		lda	#$aa
		sta	$d012
		lda	#<irqaa
		sta	$fffe
		lda	#>irqaa
		sta	$ffff
		inc	$d019
ir81_a:	lda	#$00
		//inc	$d020
		rti

//----------------------------------
//		IRQ @ #$aa
//----------------------------------

irqaa:	//dec	$d020
		sta	iraa_a+1
		lda	#$00
		sta	$d017		//Y-expand off
		stx	iraa_x+1
		lda	#$ab
		sta	$d001
		sta	$d003
		sta	$d005
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		ldx	#$48
		lda	#$4a
		sta	$77fa
		stx	$77f8
		inx
		stx	$77f9
		lda	#$c0
		sta	$d012
		lda	#<irq
		sta	$fffe
		lda	#>irq
		sta	$ffff
		inc	$d019
iraa_x:	ldx	#$00
iraa_a:	lda	#$00
		//inc	$d020
		rti
*/

//----------------------------------

ShowTopSprites:
		//dec	$d020
STOn:		lda	#$00
		beq	ToJmp
		sta	$d015
SYT:		lda	#$3a
.for (var i=0;i<5;i++)	{
		sta	$d001+i*2}
SXT:		
.for (var i=0;i<5;i++)	{
		lda	#$00
		sta	$d000+i*2}
		lda	#$00
		sta	$d010
TopSpr:	ldx	#$00			//Init value: 0-7	(first 8 sprites)
		stx	Screen+$3f8
.for (var i=1;i<5;i++)	{
		inx
		stx	Screen+$3f8+i}
ToJmp:	//inc	$d020
		jmp	Render

//----------------------------------

ShowBtmSprites:
SBOn:		lda	#$00
		beq	sbsdone
		sta	$d015
SYB:		lda	#$dd
.for (var i=0;i<6;i++)	{
		sta	$d001+i*2}
SXB_MSB:	lda	#$3f
		sta	$d010
SXB:
.for (var i=0;i<6;i++)	{
		lda	#$58
		sta	$d000+i*2}
BtmSpr:	ldx	#$38			//Init value: 38-3f (empty sprites)
		stx	Screen+$3f8
.for (var i=1;i<6;i++)	{
		inx
		stx	Screen+$3f8+i}
sbsdone:	rts

//----------------------------------------
//		PREPARATIONS
//----------------------------------------

CalcSpriteCoords:

		lax	#$00		//Reset top X-coords 
csc0:		sta	SXT0,x
		sta	SXT2,x
		inx
		bne	csc0

		ldx	#$3f
csc1:		ldy	#$00
		lda	MITab,x
		beq	csc2		
		//sta	SXT5,x		
		//ldy	#$20
		sec
		sbc	#$18
		bcc	csc2
		sta	SXT4,x
		ldy	#$10
		sbc	#$18
		bcc	csc2
		sta	SXT3,x
		ldy	#$18
		sbc	#$18
		bcc	csc2
		sta	SXT2,x
		ldy	#$1c
		sbc	#$18
		bcc	csc2
		sta	SXT1,x
		ldy	#$1e
		sbc	#$18
		bcc	csc2
		sta	SXT0,x
		ldy	#$1f
csc2:		tya
		sta	STV,x
		dex
		bpl	csc1		

		ldx	#$3f
csc3:		lda	#$3f
		sta	SXBM,x
		
		lda	#$58
		sec
		sbc	MITab,x
		sta	SXB0,x
		bcs	csc4
		tay
		lda	#$38
		sta	SXBM,x
		tya
		
csc4:		clc
		adc	#$18
		sta	SXB1,x
		bcc	csc5
		tay
		lda	#$3e
		sta	SXBM,x
		tya
		clc

csc5:		adc	#$18
		sta	SXB2,x
		bcc	csc6
		tay
		lda	#$3c
		sta	SXBM,x
		tya
		clc

csc6:		adc	#$18
		sta	SXB3,x
		bcc	csc7
		clc

csc7:		adc	#$18
		sta	SXB4,x
		bcc	csc8
		clc

csc8:		adc	#$18
		sta	SXB5,x
		dex
		bpl	csc3	
		
		ldx	#$3f
csc:		lda	#$00
		sta	SBV,x
		lda	SXBM,x
		and	#$3f
		sta	SXBM,x
		
csc9:		lda	SXBM,x
		and	#$02
		beq	csca
		ldy	SXB1,x
		cpy	#$58
		bcs	csca
		lda	#$03
		sta	SBV,x
		
csca:		lda	SXBM,x
		and	#$04
		beq	cscb
		ldy	SXB2,x
		cpy	#$58
		bcs	cscb
		lda	#$07
		sta	SBV,x
		
cscb:		lda	SXBM,x
		and	#$08
		beq	cscc
		ldy	SXB3,x
		cpy	#$58
		bcs	cscc
		lda	#$0f
		sta	SBV,x

cscc:		lda	SXBM,x
		and	#$10
		beq	cscd
		ldy	SXB4,x
		cpy	#$58
		bcs	cscd
		lda	#$1f
		sta	SBV,x

cscd:		lda	SXBM,x
		and	#$20
		beq	next
		ldy	SXB5,x
		cpy	#$58
		bcs	next
		lda	#$3f
		sta	SBV,x
next:		dex
		bpl	csc
		rts

MkTabs:
		//Clear screen & prepare Depth Tabs 
MkDepthTab://	ldx	#$00
//mdt0:		txa
//		sta	DepthTab,x		//First depth tab
//		lda	#$00
		lax	#$00
mdt0:		sta	ColTab,x		//Clear Color Tab
		sta	Screen,x		//Also clear screen
		sta	Screen+$100,x
		sta	Screen+$200,x
		sta	Screen+$2e8,x
		sta	ColRAM,x		//Also clear screen
		sta	ColRAM+$100,x
		sta	ColRAM+$200,x
		sta	ColRAM+$2e8,x
		inx
		bne	mdt0
		lda	#$ff
		//lda	#$f1			//Increment
		sta	Tmp1
mdt1:		ldx	#$00
		stx	Tmp2
		//ldy	#$00
mdt4:		ldy	#$00
		clc
mdt2:		lda	Tmp2
		adc	Tmp1
		sta	Tmp2
		bcc	*+4
		clc
		iny
		tya
mdt3:		//sta	DepthTab+$0100,x
		sta	DepthTab,x
		inx
		bne	mdt2
		lda	Tmp1
		sec
		sbc	#$10
		sta	Tmp1
		//lda	mdt4+1
		//sec
		//sbc	#$04
		//sta	mdt4+1
		inc	mdt3+2
		lda	mdt3+2
		cmp	#>DepthTab+$1000
		bne	mdt1

//		Sine tab

MkSin:	ldx	#$3f
		ldy	#$40
mks0:		lda	SinBase,x
		sta	Sin,x
		sta	Sin,y
		eor	#$ff
		clc
		adc	#$01
		sta	Sin+$80,x
		sta	Sin+$80,y
		iny
		dex
		bpl	mks0
		rts

MkRender:	lda	#$f4
		sta	Tmp1
		lda	#$02
		sta	Tmp2
		lda	#<Render
		sta	ZP
		lda	#>Render
		sta	ZP+1
		
		ldx	#$00
mk00:		lda	AddHiTab,x
		bmi	mk02
mk04:		lda	FDepth,x
		ora	#>DepthTab
mk05:		sta	rb00+2
		ldy	#<rbxx-rb00-1
mk01:		lda	rb00,y
		sta	(ZP),y
		dey
		bpl	mk01
		lda	#<rbxx-rb00-1
		jsr	AddZP
mk02:		inc	rb01+1
		bne	*+5
		inc	rb01+2
		inc	rb04+1
		bne	*+5
		inc	rb04+2
		lda	rb02+1
		sec
		sbc	#$01
		sta	rb02+1
		bcs	*+5
		dec	rb02+2
		lda	rb05+1
		sec
		sbc	#$01
		sta	rb05+1
		bcs	*+5
		dec	rb05+2
		inx
		bne	mk03	
		inc	mk00+2	
		inc	mk04+2	
mk03:		dec	Tmp1
		bne	mk00
		dec	Tmp2
		bne	mk00
		lda	#$01
		jsr	AddZP
		lda	#>TileMap
		sta	mk12+1
		jsr	MkPrep
		inc	mk12+1
		jsr	MkPrep
		inc	mk12+1
		jsr	MkPrep
		inc	mk12+1

MkPrep:	lda	#$f4
		sta	Tmp1
		lda	#$02
		sta	Tmp2
		lda	#<AddLoTab
		sta	mk10+1
		lda	#>AddLoTab
		sta	mk10+2
		lda	#<AddHiTab
		sta	mk11+1
		lda	#>AddHiTab
		sta	mk11+2
		lda	#<Render+1
		sta	pb01+1
		lda	#>Render+1
		sta	pb01+2

		ldx	#$00
mk10:		lda	AddLoTab,x
		sta	pb00+1
mk11:		lda	AddHiTab,x
		bmi	mk14		
		clc
mk12:		adc	#>TileMap
		cmp	#>TileMap+$0400
		bcc	*+4
		sbc	#>$0400
		sta	pb00+2
		ldy	#<pbxx-pb00-1
mk13:		lda	pb00,y
		sta	(ZP),y
		dey
		bpl	mk13
		lda	#<pb02-pb00
		jsr	AddZP
		lda	pb01+1
		clc
		adc	#<rb06-rb00
		sta	pb01+1
		bcc	*+5
		inc	pb01+2
mk14:		inx
		bne	mk15
		inc	mk10+2
		inc	mk11+2
mk15:		dec	Tmp1
		bne	mk10	
		dec	Tmp2	
		bne	mk10	
		lda	#$03
		jsr	AddZP	
		rts
		
AddZP:	clc
		adc	ZP
		sta	ZP
		bcc	*+4
		inc	ZP+1
		rts
RenderBase:
rb00:		ldx	DepthTab		//32 cycles * 469 = 15008 cycles total - FAST version
rb01:		stx	Screen
rb02:		stx	Screen+$3e7
rb03:		lda	ColTab,x
rb04:		sta	ColRAM
rb05:		sta	ColRAM+$3e7
rb06:		rts
rbxx:

PrepBase:
pb00:		lda	TileMap,y		//4
pb01:		sta	Render+1		//4
pb02:		jmp	ShowTopSprites	//Show top sprites after prep, before Render
pbxx:

MITab:
.fill $40,151.5*cos(toRadians([i+0.5]*360/256))
MOTab:
.fill	$20,$00
.fill $20,57.5*sin(toRadians([i+0.5]*360/128))
SinBase:
.fill $40,63.5*sin(toRadians([i+0.5]*360/256))
