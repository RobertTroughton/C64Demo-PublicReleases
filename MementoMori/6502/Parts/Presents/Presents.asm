//----------------------------------
//	"PRESENTS" loader screen
//	by Sparta 2020
//----------------------------------
//	Memory Layout
//
//	c000 c400	Screen
//	c400 c600	Sprites
//	c600 c77a	Code
//
//----------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

//Constants

.const BaseBank		=3
.const Base_BankAddress	=BaseBank*$4000							//$c000-$ffff
.const ScreenBank		=0
.const ScreenAddress	=Base_BankAddress+(ScreenBank*$0400)	//$c000-$c3e7
.const CharBank		=0
.const D018Value		=(ScreenBank*$10)+(CharBank*2)			//$c000-$c7ff
.const DD02Value		=$3c+BaseBank							//#$3f
.const D011Value		=$1b
.const MusicPlay		=BASECODE_PlayMusic

.const Sprites		=ScreenAddress+$0400
.const SpritePtr		=(ScreenBank+1)*$10
.const SpriteColor	=$0f

.const TmrVal		=$80

* = Presents_BASE

Main:		jmp	In
		jmp	Out

In:
		jsr BASECODE_VSync

		jsr	CleanUp

		//lax	#$00				//A=X=0 here
in00:		sta	ScreenAddress,x		//Clear screen, technically, not needed - all char colors are black
		sta	ScreenAddress+$100,x
		sta	ScreenAddress+$200,x
		sta	ScreenAddress+$2e8,x
		inx
		bne	in00

		jsr	InitSprites

		lda	#<DD02Value			//VIC bank: $c000-$ffff
		sta	$dd02
		lda	#<D018Value			//Screen: $c800, Map: #$c000
		sta	$d018
		lda	#<D011Value			//Screen on, text mode
		sta	$d011

		lda	#<irq
		sta	$fffe
		lda	#>irq
		sta	$ffff
		rts

//----------------------------------------

Out:		lda	Timer+1
		bne	Out
		inc	Phase+1			//Signal to IRQ
		lda	ir10+1			//Wait for fade-out to finish
		bne	*-3				//We are right AFTER the IRQ here ($d011<$80)
		
		lda	$d011
		bpl	*-3
		
		lda	#$2b			//bottom of screen, to eliminate grey dot.
		cmp	$d012
		bne	*-3

		jsr	BASECODE_SetDefaultIRQ

//----------------------------

CleanUp:
		lda	#$00
		sta	$d015				//Sprites off
		sta	$d017				//Sprite Y-expand off
		ldx	#$13
cu00:		sta	$d03e,x			//Sprite coords + screen off
		cpx #5
		beq SkipWrite
		sta	$d01b,x	//Sprite regs and screen colors
	SkipWrite:
		dex
		bpl	cu00
		inx
cu01:		sta	$d800,x
		sta	$d900,x
		sta	$da00,x
		sta	$dae8,x
		inx
		bne	cu01
		rts

//----------------------------------------

irq:		dec	$00
		sta	ir_a+1
		stx	ir_x+1
		sty	ir_y+1

Phase:	lda	#$00
		bne	ir10

ir00:		lda	#$77
		cmp	#$ff
		beq	Timer

		dec	ir00+1

		ldy	#$0e
ir01:		cmp	#$3f
		bcs	ir02+2
		tax
		bmi	ir02+1

		lda	Sin,x
		sta	$d001,y

ir02:		txa
		sec
		sbc	#$08
		dey
		dey
		bpl	ir01

		bmi	Done

//----------------------------------------

ir10:		ldx	#$17
		beq	Done
		ldy	#$00
ir11:		lda	ColorTab-1,x
		sta	$d027,y
		inx
		iny
		cpy	#$08
		bne	ir11
		dec	ir10+1
		bpl	Done

Timer:	lda	#TmrVal
		beq	Done
		dec	Timer+1

Done:		jsr	MusicPlay

		asl	$d019
ir_y:		ldy	#$00
ir_x:		ldx	#$00
ir_a:		lda	#$00
		inc	$00
		rti

//----------------------------------------

InitSprites:
		ldx	#$10
is00:		lda	SpriteCoords,x		//Coordinates
		sta	$d000,x
		dex
		bpl	is00

		ldx	#$07
is01:		lda	SpritePtrs,x
		sta	ScreenAddress+$3f8,x	//Sprite pointer
		dex
		bpl	is01

		ldx	#$07
		lda	#SpriteColor
is02:		sta	$d027,x			//Sprite colors
		dex
		bpl	is02
		lda	#$ff
		sta	$d015
		rts

//----------------------------------------

SpritePtrs:
.byte	<SpritePtr,<SpritePtr+1,<SpritePtr+2,<SpritePtr+3,<SpritePtr+2,<SpritePtr+4,<SpritePtr+5,<SpritePtr+3
ColorTab:
.byte	$00,$00,$00,$00,$00,$00,$00,$00,$09,$09,$02,$02,$08,$08,$0c,$0a,$0a,$0f,$07,$01,$01,$07,$07,$0f,$0f,$0f,$0f,$0f,$0f,$0f

.const LeftX	= $5b
SpriteCoords:
.byte	LeftX,$fa,LeftX+24,$fa,LeftX+50,$fa,LeftX+76,$fa,LeftX+96,$fa,LeftX+120,$fa,LeftX+146,$fa,LeftX+172,$fa,$80

//.align $100
Sin:
.const Len1		=$20
.const Len2		=$10
.const Len3		=$10
.const CenterTop	=$8c
.const Min		=CenterTop-$20
.const Max		=CenterTop+$10

.fill	Len3,CenterTop+((Max-CenterTop)/2)+((Max-CenterTop)/2)*cos(toRadians([i+0.5+Len3]*360/(Len3*2)))
.fill	Len2,((Min+Max)/2)+((Max-Min)/2)*cos(toRadians([i+0.5]*360/(Len2*2)))
.fill Len1,Min+($fa-Min)-($fa-Min)*cos(toRadians([i+0.5]*360/(Len1*4)))
//.fill	$80-Len1-Len2-Len3,$fa
