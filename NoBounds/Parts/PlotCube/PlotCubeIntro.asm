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
//	e600	f118	0b18	Intro
//	f118	f280	0168	Logo 3 Color
//	f280	f3e8	0168	Logo 3 Screen
//	f400	ff40	0b40	Logo 3 Bitmap
//------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

//------------------------------

.label PlotCubeIntro_Go	= $e600

//------------------------------

.const ZPA				= $10
.const ZPX				= $11
.const ZPY				= $12

.const RasterLo			= $13
.const RasterHi			= $14
.const RasterTmp		= $15

.const ZP				= $16		//-$17

.const SpriteY			= $18
.const Plinth			= $19

.const FromCol			= $1a

.const SpPtr			= $53f8

//------------------------------

.var RasterMs			= $06
.var RasterSp			= $b2
.var RasterBr			= $c8

.var ToCol				= $06

//------------------------------

.macro StartIRQ(IO)
{
		sta ZPA
		stx ZPX
		sty ZPY
		.if (IO==1)
		{
		dec $00
		}
}

.macro EndIRQ(IO)
{
		asl $d019
		.if (IO==1)
		{
		inc $00
		}
		ldy ZPY
		ldx ZPX
		lda ZPA
		rti
}

.macro UpdateIRQ(UseRegs,Raster, NextIRQ)
{
		.if (UseRegs == 0)
		{
		lda #<Raster
		ldx #<NextIRQ
		ldy #>NextIRQ
		}
		sta $d012
		stx $fffe
		sty $ffff
}

//------------------------------

* = PlotCubeIntro_Go

IntroInit:		jsr SetupScreenAndSprites
				
				lda #$34
				sta RasterLo
				lda #$80
				sta RasterHi
				
				lda $d020
				sta FromCol

				nsync()

				lda RasterLo
				sta $d012
				lda #<IRQUp
				sta $fffe
				lda #>IRQUp
				sta $ffff
				lda #$0b
				ora RasterHi
				sta $d011

				jsr IRQLoader_LoadNext				//Loading Podium00, Podium0, Podium3, Plinth sprites, PlotCube.prg

				ldx Plinth
				lda PlinthStop,x
!:				cmp SpriteY
				bne !-

				jsr CopyPlinth1

				nsync()

				ldx #$00
				lda #$f8
				clc
!:				sta $d000,x
				adc #$18
				inx
				inx
				cpx #$0c
				bne !-

				lda #$3e
				sta $d010

				lda #$fa
				sta SpriteY

				inc Plinth

				jsr IRQLoader_LoadNext				//Loading Podium2

				ldx Plinth
				lda PlinthStop,x
!:				cmp SpriteY
				bne !-

				jsr CopyPlinth2

				nsync()

				ldx #$00
				lda #$2a
				clc
!:				sta $d000,x
				adc #$18
				inx
				inx
				cpx #$0c
				bne !-

				lda #$00
				sta $d010

				lda #$fa
				sta SpriteY

				inc Plinth

				jsr IRQLoader_LoadNext				//Loading Podium1

				ldx Plinth
				lda PlinthStop,x
!:				cmp SpriteY
				bne !-

				jsr CopyPlinth3

				lda #$00
				sta $d015

				ldy #$0b
				ldx #$00
				dec $01
From2:			lda $d000,x
To2:			sta $7400,x
				inx
				bne From2
				inc From2+2
				inc To2+2
				dey
				bne From2

				ldx #$3f
!:				lda $db00,x
				sta $7f00,x
				dex
				bpl !-
				inc $01

				rts

//------------------------------

IRQUp:			dec $00
				sta IRQUpA+1
				:compensateForJitter(1)
				stx IRQUpX+1
				sty IRQUpY+1

				nop $ea

				lda #ToCol
				sta $d020

				lax RasterLo
				bne SkipUp0
				stx RasterHi
			SkipUp0:
				axs #$04
				stx RasterLo

				ldy RasterHi
				bne SetIRQMsUp
				cpx #$1c
				bcs SetIRQMsUp

			IRQUp_Play:

				jsr BASE_PlayMusic

				lda RasterLo
				ora RasterHi
				cmp #$08
				bne SetIRQMsUp

				lda #<IRQRstr
				sta IRQLo+1
				lda #>IRQRstr
				sta IRQHi+1
				lda #<RasterSp
				sta RasterLo
				lda #$1b
				sta D011+1
				lda #$06
				sta FromCol

				lda #<Rasters
				sta ZP
				lda #>Rasters
				sta ZP+1

			SetIRQMsUp:
				lda #$0b
				sta $d011
				lda #RasterMs
				sta $d012
				lda #<IRQMs
				sta $fffe
				lda #>IRQMs
				sta $ffff

			IRQUpEnd:
				asl $d019
				inc $00
			IRQUpY:
				ldy #$00
			IRQUpX:
				ldx #$00
			IRQUpA:
				lda #$00
				rti

//------------------------------

.align $100
IRQRstr:		StartIRQ(1)
				
				ldy #$00
				nop
				nop				//8

	RstrLoop:	lda (ZP),y		//5

				ldx #$04		//2
				dex
				bne *-1			//19
				nop				//2
				nop				//2		//38

				sta $d021

				iny
				lda (ZP),y

				nop
				nop
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop
				nop

				sta $d021

				iny
				lda (ZP),y
				
				ldx #$09
				dex
				bne *-1
				nop
				nop

				sta $d021
				
				ldx #$04
				dex
				bne *-1
				nop

				iny
				cpy #$48
				bne RstrLoop

				lda ZP
				cmp #$48
				bne NotDone

				lda #<IRQBmp
				sta IRQLo+1
				lda #>IRQBmp
				sta IRQHi+1
				lda #$3b
				sta D011+1
				lda #$3d
				sta DD02+1
				lda #$40
				sta D018+1

				jsr SetupSprites

				jmp IRQRstrEnd

	NotDone:	
/*				cmp #$38
				bcc IncZP
		
	EorVal:		lda #$00
				eor #$01
				sta EorVal+1
				bne IRQRstrEnd
*/
	IncZP:		inc ZP
	IRQRstrEnd:
				UpdateIRQ(0, RasterMs, IRQMs)
				
				EndIRQ(1)
		
//------------------------------

IRQMs:			StartIRQ(1)

				ldx FromCol
				lda $d020
				and #$0f
				cmp FromCol
				beq	!+
				stx $d020
!:				lda $d021
				and #$0f
				cmp FromCol
				beq !+
				stx $d021
!:
	D011:		lda #$0b
				ora RasterHi
				sta $d011

	D018:		lda #$18
				sta $d018
				
	D016:		lda #$18
				sta $d016
		
	DD02:		lda #$3c
				sta $dd02

				ldx #$fe
	Spr00:		lda #$d1
				sax	SpPtr+0
				sta	SpPtr+1
	Spr01:		lda #$d3
				sax SpPtr+2
				sta SpPtr+3
	Spr02:		lda #$d5
				sax SpPtr+4
				sta SpPtr+5

				lda SpriteY
				sta $d001
				sta $d003
				sta $d005
				sta $d007
				sta $d009
				sta $d00b
		
				lda RasterLo
				ora RasterHi
				cmp #$20
				bcc SkipMusic

				jsr BASE_PlayMusic

	SkipMusic:	lda RasterLo
				sta $d012
	IRQLo:		lda #<IRQUp
				sta $fffe
	IRQHi:		lda #>IRQUp
				sta $ffff

				EndIRQ(1)
		
//------------------------------

IRQBmp:			StartIRQ(1)						//Raster line 178, always!!! Sprite row 1

				ldx #$07
				dex
				bne *-1
				nop

				lda #$08
				sta $d021

				ldx Plinth
				lda PointerTab+9,x
				sta Spr10+1
				lda PointerTab+12,x
				sta Spr11+1
				lda PointerTab+15,x
				sta Spr12+1

				lax SpriteY
				axs #$100-$0a
				stx $d012
				bcc !+
				lda $d011
				ora #$80
				sta $d011
!:				lda #<IRQSpr0
				sta $fffe
				lda #>IRQSpr0
				sta $ffff

				EndIRQ(1)

//------------------------------

IRQSpr0:		StartIRQ(1)
				
				lax $d001
				axs #$100-$15
				.for (var i = 0; i < 12; i+=2)
				{
				stx $d001+i
				}

				lax SpriteY
				axs #$100-$13
				stx $d012
				bcc !+
				lda $d011
				ora #$80
				sta $d011
!:				lda #<IRQSpr1
				sta $fffe
				lda #>IRQSpr1
				sta $ffff

				EndIRQ(1)
				
//------------------------------

IRQSpr1:		dec $00							//Raster line SpriteY+20 (270-) Sprite row 2
				sta IRQSpr1A+1
				:compensateForJitter(1)
				stx IRQSpr1X+1

				ldx #$fe
	Spr10:		lda #$d1
				sax	SpPtr+0
				sta	SpPtr+1
	Spr11:		lda #$d3
				sax SpPtr+2
				sta SpPtr+3
	Spr12:		lda #$d5
				sax SpPtr+4
				sta SpPtr+5

				ldx Plinth
				lda PointerTab+18,x
				sta Spr20+1
				lda PointerTab+21,x
				sta Spr21+1
				lda PointerTab+24,x
				sta Spr22+1

				lax SpriteY
				axs #$100-$27
				stx $d012
				bcc	!+
				lda $d011
				ora #$80
				sta $d011
!:				lda #<IRQSpr2
				sta $fffe
				lda #>IRQSpr2
				sta $ffff

				ldx #$20
				dex
				bne *-1

				lax $d001
				axs #$100-$15
				.for (var i = 0; i < 12; i+=2)
				{
				stx $d001+i
				}

				asl $d019

IRQSpr1X:		ldx #$00
IRQSpr1A:		lda #$00
				inc $00
				rti

//------------------------------

IRQSpr2:		dec $00							//Raster line SpriteY+40 (290-) Sprite row 3
				sta IRQSpr2A+1
				:compensateForJitter(1)
				stx IRQSpr2X+1

				ldx #$fe
	Spr20:		lda #$d1
				sax	SpPtr+0
				sta	SpPtr+1
	Spr21:		lda #$d3
				sax SpPtr+2
				sta SpPtr+3
	Spr22:		lda #$d5
				sax SpPtr+4
				sta SpPtr+5

				ldx Plinth
				lda PointerTab+27,x
				sta Spr30+1
				lda PointerTab+30,x
				sta Spr31+1
				lda PointerTab+33,x
				sta Spr32+1

				lax SpriteY
				axs #$100-$3b
				stx $d012
				bcc	!+
				lda $d011
				ora #$80
				sta $d011
!:				lda #<IRQSpr3
				sta $fffe
				lda #>IRQSpr3
				sta $ffff

				ldx #$20
				dex
				bne *-1

				lax $d001
				axs #$100-$15
				.for (var i = 0; i < 12; i+=2)
				{
				stx $d001+i
				}

				asl $d019

IRQSpr2X:		ldx #$00
IRQSpr2A:		lda #$00
				inc $00
				rti

//------------------------------

IRQSpr3:		dec $00							//Raster line SpriteY+60 (310-) Sprite row 4
				sta IRQSpr3A+1
				:compensateForJitter(1)
				stx IRQSpr3X+1

				ldx #$fe
	Spr30:		lda #$d1
				sax	SpPtr+0
				sta	SpPtr+1
	Spr31:		lda #$d3
				sax SpPtr+2
				sta SpPtr+3
	Spr32:		lda #$d5
				sax SpPtr+4
				sta SpPtr+5

				ldx Plinth
				lda PointerTab+0,x
				sta Spr00+1
				lda PointerTab+3,x
				sta Spr01+1
				lda PointerTab+6,x
				sta Spr02+1

				lda #<RasterMs
				sta $d012
				lda $d011
				and #$7f
				sta $d011
				lda #<IRQMs
				sta $fffe
				lda #>IRQMs
				sta $ffff
				
				lda SpriteY
				cmp PlinthStop,x
				beq !+
				dec SpriteY
!:

				ldx #$20
				dex
				bne *-1

				lax $d001
				axs #$100-$15
				.for (var i = 0; i < 12; i+=2)
				{
				stx $d001+i
				}

				asl $d019

IRQSpr3X:		ldx #$00
IRQSpr3A:		lda #$00
				inc $00
				rti


SetupSprites:	lda #$3f
				sta $d015
				sta $d01c			//Multicolor

				rts

//------------------------------

SetupScreenAndSprites:
				ldx #$00
!:				lda #$00
				sta $0400,x			//not sure this is needed
				sta $0500,x
				sta $0600,x
				sta $06e8,x
				sta $2000,x			//blank char
				lda #$66
				sta $5000,x
				sta $5100,x
				sta $5180,x
				sta $d800,x
				sta $d900,x
				sta $d980,x
				lda #$6b
				sta $5280,x
				sta $52e8,x
				lda #$04
				sta $da80,x
				sta $dae8,x
				inx
				bne !-

				ldx #$7f
				lda #$00			//Two blank sprites ($7e and $7f)
!:				sta $5f80,x
				dex
				bpl !-

				lda #$fa			//250
				sta SpriteY
				
				lda #$00
				sta Plinth

				lda #$00
				sta $d025
				lda #$09
				sta $d026
				ldx #$07
				lda #$0b
!:				sta $d027,x
				dex
				bpl !-

				ldx #$00
				lda #$74
				clc
!:				sta $d000,x
				adc #$18
				inx
				inx
				cpx #$0c
				bne !-

				rts

CopyPlinth1:
				nsync()

				ldx #00
!:				lda $8400+$000+$58,x
				sta $5400+$000+$58,x
				lda $8400+$140+$58,x
				sta $5400+$140+$58,x
				lda $8400+$280+$58,x
				sta $5400+$280+$58,x
				inx
				cpx #$88
				bne !-

				ldx #$10
!:				lda $8118+$0b,x
				sta $da80+$0b,x
				lda $8118+$28+$0b,x
				sta $da80+$28+$0b,x
				lda $8118+$50+$0b,x
				sta $da80+$50+$0b,x
				lda $8280+$0b,x
				sta $5280+$0b,x
				lda $8280+$28+$0b,x
				sta $5280+$28+$0b,x
				lda $8280+$50+$0b,x
				sta $5280+$50+$0b,x
				dex
				bpl	!-

				nsync()

				ldx #$0f
!:				lda $8118+$78+$0c,x
				sta $da80+$78+$0c,x
				lda $8280+$78+$0c,x
				sta $5280+$78+$0c,x
				dex
				bpl !-

				ldx #$0e
!:				lda $8118+$a0+$0d,x
				sta $da80+$a0+$0d,x
				lda $8118+$c8+$0d,x
				sta $da80+$c8+$0d,x
				lda $8118+$f0+$0d,x
				sta $da80+$f0+$0d,x
				lda $8118+$118+$0d,x
				sta $da80+$118+$0d,x
				lda $8118+$140+$0d,x
				sta $da80+$140+$0d,x
				lda $8280+$a0+$0d,x
				sta $5280+$a0+$0d,x
				lda $8280+$c8+$0d,x
				sta $5280+$c8+$0d,x
				lda $8280+$f0+$0d,x
				sta $5280+$f0+$0d,x
				lda $8280+$118+$0d,x
				sta $5280+$118+$0d,x
				lda $8280+$140+$0d,x
				sta $5280+$140+$0d,x
				dex
				bpl !-
							
				ldx #$77
!:				lda $8400+$3c0+$68,x
				sta $5400+$3c0+$68,x
				lda $8400+$500+$68,x
				sta $5400+$500+$68,x
				lda $8400+$640+$68,x
				sta $5400+$640+$68,x
				lda $8400+$780+$68,x
				sta $5400+$780+$68,x
				lda $8400+$8c0+$68,x
				sta $5400+$8c0+$68,x
				lda $8400+$a00+$68,x
				sta $5400+$a00+$68,x
				dex
				bpl !-

				lda $8400+$3c0+$60
				sta $5400+$3c0+$60
				lda $8400+$3c0+$61
				sta $5400+$3c0+$61
				lda $8400+$3c0+$62
				sta $5400+$3c0+$62
				lda #$aa
				sta $5400+$3c0+$63
				sta $5400+$3c0+$66

				rts

CopyPlinth2:
				nsync()

				ldx #$08
!:				lda $8118+$50+$1c,x
				sta $da80+$50+$1c,x
				lda $8280+$50+$1c,x
				sta $5280+$50+$1c,x
				
				lda $8118+$78+$1c,x
				sta $da80+$78+$1c,x
				lda $8280+$78+$1c,x
				sta $5280+$78+$1c,x
				
				lda $8118+$a0+$1c,x
				sta $da80+$a0+$1c,x
				lda $8280+$a0+$1c,x
				sta $5280+$a0+$1c,x
				
				lda $8118+$c8+$1c,x
				sta $da80+$c8+$1c,x
				lda $8280+$c8+$1c,x
				sta $5280+$c8+$1c,x

				lda $8118+$f0+$1c,x
				sta $da80+$f0+$1c,x
				lda $8280+$f0+$1c,x
				sta $5280+$f0+$1c,x
				
				lda $8118+$118+$1c,x
				sta $da80+$118+$1c,x
				lda $8280+$118+$1c,x
				sta $5280+$118+$1c,x
				
				lda $8118+$140+$1c,x
				sta $da80+$140+$1c,x
				lda $8280+$140+$1c,x
				sta $5280+$140+$1c,x
				
				dex
				bpl !-

				ldx #$47
!:				lda $8400+$280+$e0,x
				sta $5400+$280+$e0,x
				lda $8400+$3c0+$e0,x
				sta $5400+$3c0+$e0,x
				lda $8400+$500+$e0,x
				sta $5400+$500+$e0,x
				lda $8400+$640+$e0,x
				sta $5400+$640+$e0,x
				lda $8400+$780+$e0,x
				sta $5400+$780+$e0,x
				lda $8400+$8c0+$e0,x
				sta $5400+$8c0+$e0,x
				lda $8400+$a00+$e0,x
				sta $5400+$a00+$e0,x
				dex
				bpl !-

				rts

CopyPlinth3:	nsync()
				
				ldx #$0a
!:				lda $8118+$78+$02,x
				sta $da80+$78+$02,x
				lda $8280+$78+$02,x
				sta $5280+$78+$02,x

				lda $8118+$a0+$02,x
				sta $da80+$a0+$02,x
				lda $8280+$a0+$02,x
				sta $5280+$a0+$02,x

				lda $8118+$c8+$02,x
				sta $da80+$c8+$02,x
				lda $8280+$c8+$02,x
				sta $5280+$c8+$02,x
				dex
				bpl !-

				ldx #$08
!:				lda $8118+$f0+$03,x
				sta $da80+$f0+$03,x
				lda $8280+$f0+$03,x
				sta $5280+$f0+$03,x
				dex
				bpl !-

				ldx #$07
!:				lda $8118+$118+$04,x
				sta $da80+$118+$04,x
				lda $8280+$118+$04,x
				sta $5280+$118+$04,x

				lda $8118+$140+$04,x
				sta $da80+$140+$04,x
				lda $8280+$140+$04,x
				sta $5280+$140+$04,x
				dex
				bpl !-

				ldx #$57
!:				lda $8400+$3c0+$10,x
				sta $5400+$3c0+$10,x
				lda $8400+$500+$10,x
				sta $5400+$500+$10,x
				lda $8400+$640+$10,x
				sta $5400+$640+$10,x
				dex
				bpl !-

				ldx #$47
!:				lda $8400+$780+$18,x
				sta $5400+$780+$18,x
				dex
				bpl !-

				ldx #$3f
!:				lda $8400+$8c0+$20,x
				sta $5400+$8c0+$20,x
				lda $8400+$a00+$20,x
				sta $5400+$a00+$20,x
				dex
				bpl !-

				rts
.align $100
Rasters:
.fill 72,$06
.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$0b,$0b,$04,$0b
.byte $04,$0b,$04,$04,$0b,$04,$04,$04,$04,$04,$04,$06,$04,$04,$06,$04
.byte $06,$04,$06,$06,$04,$06,$06,$06,$08,$06,$06,$06,$06,$06,$06,$06
.byte $08,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
.byte $08,$06,$06,$06,$06,$06,$06,$06

PointerTab:
.byte $d1,$e9,$f5,$d3,$eb,$f7,$d5,$7f,$7f		//0,3,6
.byte $d7,$ed,$f9,$d9,$ef,$fb,$db,$7f,$7f		//9,12,15
.byte $dd,$f1,$fd,$df,$f3,$ff,$e1,$7f,$7f		//18,21,24
.byte $e3,$7f,$7f,$e5,$7f,$7f,$e7,$7f,$7f		//27,30,33

PlinthStop:
.byte <RasterSp, <RasterSp+17, <RasterSp+26