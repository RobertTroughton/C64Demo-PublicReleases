//-----------------------------------
//	3D Animated Plot Skull
//	Animation Phase
//	By Sparta 2020
//-----------------------------------
//	Memory Layout
//
//	0800	2000	Music
//	2000	242b	Main Code				->Preload
//	 242c	 253f	 UNUSED
//	2540	27fe	CalcJmp
//	2800	49b4	DelPlot
//	4a00	4a4b	MulTab					->Preload
//	4a60	4a73	RowMax					->Preload
//	4a80	5000	JmpTab	($580 bytes)	->Preload
//	5000	95aa	XT		($45ab bytes)	->Preload 5300-95aa
//	 5000	 5293	 Preps					->Preload
//	9600	dbaa	BT		($45ab bytes)	->Preload 9600-c000
//	 a000	 bf40	 BitmapLoad
//	dc00	e000	Screen
//	e000	ff40	Bitmap
//-----------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

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

.const	ZP1		=$10			//-$11
.const	ZP2		=$12			//-$13
.const	PlotAdd	=$14			//-$15
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

.const	RowCnt	=20			//NOT a ZP address

*=PlotSkull_BASE	"Main code"

Main:		jsr	MainCode
		
		lda	PartDone			//Wait for Fade Out to finish
		beq	*-2

		lda	$d011
		bpl	*-3
		lda	$d011
		bmi	*-3
		
		//asl	$d019		//Not needed here as we did not skip any raster IRQs (remains on raster line #$00)
		
		jsr	BASECODE_SetDefaultIRQ

//----------------------------------

CleanUp:	lda	#$00
		sta	$d015		//Sprites off
		sta	$d017		//Sprite Y-expand off
		ldx	#$14
cu00:		sta	$d03d,x	//Sprite coords + screen off
		cpx #6
		beq SkipWrite
		sta	$d01a,x	//Sprite regs and screen colors
	SkipWrite:
		dex
		bne	cu00
cu01:		sta	$d800,x	//Clear color RAM
		sta	$d900,x
		sta	$da00,x
		sta	$dae8,x
		inx
		bne	cu01
		rts

//----------------------------
//		IRQ @ #$00 - Fade Out
//----------------------------

irqfo:	pha
		txa
		pha
		tya
		pha

fotm:		ldx	#$18				//24 ->0
		bpl	*+5
		jmp	irfo_m
		
		cpx	#$15
		bcc	fo00

		lda	#$d0				//Down Right side
		sta	foz3+1
		ldy	#$0e
		lda	#$90				//Up
		ldx	#$04
		bne	fo01a

fo00:		cpx	#$04
		bcc	fo01

		lda	#$e0				//Down Right side
		sta	foz3+1
		ldy	#$0c
		lda	#$60				//Up
		ldx	#$10
		bne	fo01a

fo01:		lda	#$b0				//Down Right side
		sta	foz3+1
		ldy	#$12
		lda	#$70				//Up
		ldx	#$0c

fo01a:	sta	foz4+1
		stx	foz5+1
fo02:		lda	#<Bitmap
		sta	fo08+1
		clc
foz3:		adc	#$00
		sta	fo09+1
fo03:		lda	#>Bitmap
		sta	fo08+2
		adc	#$00
		sta	fo09+2

fo04:		lda	#<Bitmap+[$18*$140]
foz4:		adc	#$00
		sta	fo0c+1
fo05:		lda	#>Bitmap+[$18*$140]
		adc	#$00
		sta	fo0c+2

fo06:		ldx	#$00
fo07:		lda	#$00	
fo08:		sta	Bitmap,x
fo09:		sta	Bitmap,x
		txa
		adc	#$08
		tax
		dey
		bne	fo07

foz5:		ldy	#$00
fo0a:		ldx	#$07
fo0b:		lda	#$00
fo0c:		sta	Bitmap+[$18*$140],x
		txa
		adc	#$08
		tax
		dey
		bne	fo0b

		inc	fo06+1
		dec	fo0a+1
		bpl	irfo_m	

		lda	#$00
		sta	fo06+1
		lda	#$07
		sta	fo0a+1

		lda	fo02+1
		clc
		adc	#$40
		sta	fo02+1
		lda	fo03+1
		adc	#$01
		sta	fo03+1

		lda	fo04+1
		sec
		sbc	#$40
		sta	fo04+1
		lda	fo05+1
		sbc	#$01
		sta	fo05+1

		dec	fotm+1
		bpl	irfo_m

		inc	PartDone

irfo_m:	jsr	MusicPlay

		asl	$d019

		pla
		tay
		pla
		tax
		pla
		rti

//-----------------------------------------------------
//ANYTHING FROM HERE CAN BE OVERWRITTEN DURING FADE-OUT
//WITH THIS UPDATE THIS MEANS $20ff-$dbff BEING FREE
//FOR PRELOADING THE NEXT PART
//-----------------------------------------------------

MainCode:
		jsr BASECODE_VSync

		lda	#<irqfi		//Start Fade In while loading OffsetTab
		sta	$fffe
		lda	#>irqfi
		sta	$ffff
		lda	#$00
		sta	$d012

		jsr	Load			//Loads OffsetTab, overwrites Preps

		lda	FadeIn		//Wait for Fade In to finish
		beq	*-2

		jsr	Load			//Loads BitTab, overwrites Bitmap Load mem

		inc	LoadDone		//Loading is complete, signal to switch IRQ

		lda	FadeOut		//Wait for Fade Out to start
		beq	*-2
		
		jmp	Load			//Preload Next Part during Fade Out
						//At this point the part only uses
						//$2000-$20ff for code (Main Code and Fade-Out IRQ)
						//$dc00-$ff3f for the bitmap fading out
						//Anything in between can be used to preload next part

//----------------------------
//		IRQ @ #$00 - Fade In
//----------------------------

irqfi:	sta	irfi_a+1
		stx	irfi_x+1
		sty	irfi_y+1

		dec	$00

irtm:		ldx	#$18				//24 ->0
		bpl	*+5
		jmp	irfi_m
		
		cpx	#$15
		bcc	if00

		lda	#$b0				//Down Right side
		sta	ifz3+1
		ldy	#$12
		lda	#$70				//Up
		ldx	#$0c
		bne	if02

if00:		cpx	#$04
		bcc	if01

		lda	#$e0				//Down Right side
		sta	ifz3+1
		ldy	#$0c
		lda	#$60				//Up
		ldx	#$10
		bne	if02

if01:		lda	#$d0				//Down Right side
		sta	ifz3+1
		ldy	#$0e
		lda	#$90				//Up
		ldx	#$04

if02:		sta	ifz4+1
		stx	ifz5+1

if03:		lda	#<Bitmap+[$18*$140]
		sta	if08+1
		sta	if09+1
		clc
ifz3:		adc	#$00
		sta	if0a+1
		sta	if0b+1
if04:		lda	#>Bitmap+[$18*$140]
		sta	if09+2
		and	#$bf
		sta	if08+2
		adc	#$00
		sta	if0a+2
		ora	#$40
		sta	if0b+2

if05:		lda	#<Bitmap
ifz4:		adc	#$00
		sta	if0d+1
		sta	if0e+1
if06:		lda	#>Bitmap
		adc	#$00
		sta	if0e+2
		and	#$bf
		sta	if0d+2

		clc

if07:		ldx	#$07
if08:		lda	BmpLoad+[$18*$140],x	
if09:		sta	Bitmap+[$18*$140],x
if0a:		lda	BmpLoad+[$18*$140],x
if0b:		sta	Bitmap+[$18*$140],x
		txa
		adc	#$08
		tax
		dey
		bne	if08

ifz5:		ldy	#$00
if0c:		ldx	#$00
if0d:		lda	BmpLoad,x
if0e:		sta	Bitmap,x
		txa
		adc	#$08
		tax
		dey
		bne	if0d

		inc	if0c+1
		dec	if07+1
		bpl	irfi_m

		lda	#$00
		sta	if0c+1
		lda	#$07
		sta	if07+1

		lda	if03+1
		sec
		sbc	#$40
		sta	if03+1
		lda	if04+1
		sbc	#$01
		sta	if04+1

		lda	if05+1
		clc
		adc	#$40
		sta	if05+1
		lda	if06+1
		adc	#$01
		sta	if06+1

		dec	irtm+1
		bpl	irfi_m

		inc	FadeIn

irfi_m:	jsr	MusicPlay

		lda	LoadDone			//If loading finished, switch to next IRQ if it is
		beq	irfi_z

		ldy	#$00
		clc
		jsr	CalcJmp			//Prime XT and BT vectors on ZP for Plot Skull FadeIn

		ldx	#<RowCnt-1			//Prepare swapping skulls - we have 20 rows to update
		stx	Tmp

		lda	#<irq00
		sta	$fffe
		lda	#>irq00
		sta	$ffff

irfi_z:	asl	$d019

		inc	$00

irfi_y:	ldy	#$00
irfi_x:	ldx	#$00
irfi_a:	lda	#$00
		rti


//----------------------------
//		IRQ @ #$00	- Swap Skulls
//----------------------------

irq00:	sta	ir00_a+1
		stx	ir00_x+1
		sty	ir00_y+1

		ldx	Tmp				//RowCnt-1 -> 0
		cpx	#<RowCnt-2
		bcs	DelBMP			//Skip showing Plot Skull if we are deleting the bottom 2 rows

		//Show Plot Skull

fi11:		txa					//X=RowCnt-3 -> 0
		asl
		tax					//X=(RowCnt-3)*2
		lda	XT+4,x
		clc
		sbc	XT+2,x
		tay
fi12:		lax	(XT+[<RowCnt*2]),y	//1-18 rows *2 bytes on ZP
fi13:		and	#$07
		cmp	fi13+1
		bne	fi16
fi14:		lda	(BT+[<RowCnt*2]),y
fi15:		sta	Bitmap+$40+[$16*$140],x	//Bottom 2 rows are skipped - starts @ Bitmap+$40+[$14*$140]
fi16:		dey
		bpl	fi12

		//Delete Bitmap Skull

		ldx	Tmp
DelBMP:	lda	ColOffset,x
		asl
		asl
		asl
		clc
fi00:		adc	#<Bitmap+$40+[$15*$140]
		sta	fi04+1
fi01:		lda	#>Bitmap+$40+[$15*$140]
		adc	#$00
		sta	fi04+2
		ldy	ColLen,x
fi02:		ldx	fi13+1
fi03:		lda	#$00
fi04:		sta	Bitmap+$40+[$15*$140],x
		txa
		adc	#$08
		tax
		dey
		bne	fi03
		dec	fi13+1
		bpl	ir00_m

		//Update colors

		ldx	Tmp
fi05:		lda	ColOffset,x
		clc
fi06:		adc	#<ColRAM+$07+[$15*$28]
		sta	fi09+1
		sta	fi0a+1
fi07:		lda	#>ColRAM+$07+[$15*$28]
		adc	#$00
		sta	fi09+2
		adc	#$04
		sta	fi0a+2
		ldy	ColLen,x
fi08:		lda	#$01
fi09:		sta	ColRAM+$07+[$15*$28],y
		lda	#$cf
		dec	$01
fi0a:		sta	Screen+$07+[$15*$28],y	//Screen RAM is under IO
		inc	$01
		dey
		bne	fi08

		jsr	UpdateFI

ir00_m:	jsr	MusicPlay

		asl	$d019

ir00_y:	ldy	#$00
ir00_x:	ldx	#$00
ir00_a:	lda	#$00
		rti

//----------------------------------

UpdateFI:	lda	#$07
		sta	fi13+1

		//Next XT and BT vectors on ZP

		dec	fi12+1
		dec	fi12+1
		dec	fi14+1
		dec	fi14+1

		//New char row for plot skull

ufi0:		lda	#<Bitmap+$40+[$16*$140]	//We start 2 rows further down, the bottom 2 rows will be skipped
		sec
		sbc	#$40
		sta	ufi0+1
		tax
ufi1:		lda	#>Bitmap+$40+[$16*$140]
		sbc	#$01
		sta	ufi1+1
		sta	fi15+2

		cpx	#$40
		bne	*+4
		ldx	#$00
		stx	fi15+1

		//Next GFX char row to be deleted

		lda	fi00+1
		sec
		sbc	#$40
		sta	fi00+1
		lda	fi01+1
		sbc	#$01
		sta	fi01+1

		//Next char row for updating colors

		lda	fi06+1
		sec
		sbc	#$28
		sta	fi06+1
		lda	fi07+1
		sbc	#$00
		sta	fi07+1

		dec	Tmp				//Next char row
		bpl	ufix				//Fadein done?

		lda	#<irqc0			//Yes, next IRQ
		sta	$fffe
		lda	#>irqc0
		sta	$ffff
		lda	#$c0
		sta	$d012

ufix:		rts

//----------------------------
//		IRQ @ #$c0
//----------------------------

irqc0:	sta	irc0_a+1
		stx	irc0_x+1
		sty	irc0_y+1
		
phase:	ldy	#$20				//We start with phase #$20 (#$00-#$3f)
		clc
		jsr	CalcJmp

		lda	PartPhase	
		bne	dp	

		lda	#<irqfo
		sta	$fffe
		lda	#>irqfo
		sta	$ffff
		lda	#$00
		sta	$d012

		inc	FadeOut

dp:		dec	$01
		lda	#$00
		jsr	DelPlot			//$3040 - Plot only
		inc	$01

stpctr:	lda	#$00
		beq	next
frmctr:	ldx	#$00
		dex
		bne	done
		lda	phase+1
		clc
stpdir:	adc	#$00
		and	#$3f
		sta	phase+1
		dec	stpctr+1
		bne	frm

next:		inc	animptr+1
animptr:	ldx	#$19
		lda	FrmCtr,x
		bpl	updatefrm
		dec	PartPhase
		ldx	#$00
		stx	animptr+1
		bpl	animptr+2
updatefrm:	sta	frmctr+1
		sta	frm+1
		lda	StartPhase,x
		bmi	SkipPhase
		sta	phase+1
SkipPhase:	lda	StepDir,x
		sta	stpdir+1
		lda	StepCtr,x
		sta	stpctr+1

frm:		ldx	#$00
done:		stx	frmctr+1

		jsr	MusicPlay

		asl	$d019

irc0_y:	ldy	#$00
irc0_x:	ldx	#$00
irc0_a:	lda	#$00
		rti

//----------------------------------

ColOffset:
.byte 6,5,4,3,3,2,2,2,1,1,2,2,3,4,5,5,6,6,6,8
ColLen:
.byte	10,13,16,18,18,20,20,20,22,22,21,21,20,19,17,17,15,14,13,9

//----------------------------------

StartPhase:
//	2nd fwd	 1st fwd	  1st fwd	2nd fwd	1st bkwd		2nd bkwd	Stop 2nd fwd	1st fwd	 End
.byte	$20,$ff,$ff, $ff,$ff,$ff, $00,$ff, $ff,$ff,$ff,	$1f,$ff,$ff,$ff, $ff,$ff,$ff ,$20, $ff,$ff,$ff, $ff,$ff,$ff, $ff
//	Stop	2nd+1st fwd with speed increasing 
.byte	$20, $20,$ff,$ff,$ff,$ff
StepDir:
.byte	$01,$01,$01, $01,$01,$01, $01,$01, $01,$01,$01,	$ff,$ff,$ff,$ff, $ff,$ff,$ff ,$01, $01,$01,$01, $01,$01,$01, $ff

.byte	$01, $01,$01,$01,$01,$01
StepCtr:
.byte	$08,$10,$08, $08,$14,$04, $04,$1C, $08,$10,$08,	$01,$07,$10,$08, $08,$10,$08 ,$01, $07,$10,$08, $08,$10,$08, $ff

.byte	$01, $04,$04,$04,$0c,$28

FrmCtr://																		 End
.byte	$02,$01,$02, $02,$02,$01, $01,$02, $02,$01,$02, $04,$01,$02,$01, $01,$02,$01 ,$08, $02,$01,$02, $02,$02,$02, $ff
//					  End
.byte	$20, $04,$03,$02,$01,$02, $ff
