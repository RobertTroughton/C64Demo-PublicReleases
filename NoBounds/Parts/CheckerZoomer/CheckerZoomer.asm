
.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

//---------------------------------
//		Memory Layout
//---------------------------------
//
//	0160	0400	Sparkle
//	0400	0800	-UNUSED-
//	0800	0900	Demo Driver
//	0900	2000	Music

//	0400	0651	SinTab1 + PtrTable + Colors
//	0651	07f8	Unused
//	07f8	07ff	Screen  00
//	2000	3fff	Screens 01-08 + sprites $c0-$d0 ($3000-$3440)	$2000-$3000 and $3440-$4000 only used for sprite pointers
//	4000	7fff	Screens 09-24 + sprites $c0-$f3 ($7000-$7d00)	$5f00-$7000 only used for sprite pointers
//	4000	5880	Zoom Phases
//	5900	5a00	BankTable
//	5a00	5b00	ColorTable1
//	5b00	5c00	ColorTable2
//	5c00	5d00	ColorTable3
//	5d00	5e00	ColorTable4
//	5e00	6000	ClearCode
//	7d00	7fd8	SinTab2 + OrTable
//	8000	8d00	Main Code
//	8d00	a381	Raster Code
//	a000	bfff	Screens 25-32 + sprites $c0-$e5 ($b000-$b980)	$a000-$b000 and $b980-$c000 only used for sprite pointers
//	c000	ffff	Screens 33-49 + sprites $c0-$fa ($f000-$fec0)	$c000-$f000 and $fec0-$fff8 only used for sprite pointers <- load bitmap here!!!
//	c000	df78	Bitmap
//	e000	e3e8	ScreenRAM
//	e400	e7c0	Chess figure sprites ($e400-$e740, #4$90-#$9c) and fade-out chessboard sprites ($e740-$e7c0, #$9d-#$9e)
//
//---------------------------------

.const ZP			= $10
.const Tmp			= $12
.const Phase		= $13
.const Offset		= $14
.const EorVal		= $15
.const NextVal		= $16

.const ZoomSize		= $80
.const PhaseStepLo	= $81
.const PhaseStepHi	= $82
.const DeltaLo		= $83
.const DeltaHi		= $84
.const BorderWidth	= $85

.const NumPhases	= 49
.const TableSize	= 96

.const FrmLo		= $1e
.const FrmHi		= $1f
.const StepTable	= $20

.const ZoomPhases	= $4000
.const BankTable	= $5900
.const ColorTable1	= $5a00
.const ColorTable2	= $5b00
.const ColorTable3	= $5c00
.const ColorTable4	= $5d00
.const ClearCode	= $5e00
.const MainCode		= $8000
.const RasterCode	= $8d00
.const PatternTable	= $9000			//-$9400
.const PointerTable	= $9400			//-$9580
.const BmpTmp		= $df40
.const PhaseTables	= $ac00
.const DeltaLoTable	= $ad00
.const DeltaHiTable	= $ad20
.const OffsetTable	= $ad40

.const ColRAM		= $d800
.const ScrRAM		= $e000

.const OPC_NOP_ABS	= $0c
.const OPC_JSR		= $20
.const OPC_STA_ABS	= $8d

.const ChessMoves	= $20

.const XX			= $92
.const WP			= $93
.const WR			= $94
.const WN			= $95
.const WB			= $96
.const WQ			= $97
.const WK			= $98
.const BP			= $99
.const BR			= $9a
.const BN			= $9b
.const BB			= $9c
.const BQ			= $9d
.const BK			= $9e
.const BoardSprite	= $90

.const CX0			= $56
.const CX1			= CX0+$18
.const CX2			= CX0+$30
.const CX3			= CX0+$48
.const CX4			= CX0+$60
.const CX5			= CX0+$78
.const CX6			= CX0+$90
.const CX7			= CX0+$a8

.const CY0			= $36+2
.const CY1			= CY0+$18
.const CY2			= CY0+$30
.const CY3			= CY0+$48
.const CY4			= CY0+$60
.const CY5			= CY0+$78
.const CY6			= CY0+$90
.const CY7			= CY0+$a8

//		RBIdx1	RBIdx2	Idx1	Ptr1	Clr1	Captr	Idx2	SpX2	X0		X1		DX		Y0		Y1		DY		RAIdx1	RAIdx2	Tmr

.const ThisMove		= $a800
.const RBIdx1		= ThisMove + 0
.const RBIdx2		= ThisMove + 1
.const Idx1			= ThisMove + 2
.const Ptr1			= ThisMove + 3
.const Clr1			= ThisMove + 4
.const Capture		= ThisMove + 5
.const Idx2			= ThisMove + 6
.const SpX2			= ThisMove + 7
.const MoveX0		= ThisMove + 8
.const MoveX1		= ThisMove + 9
.const DeltaX		= ThisMove + 10
.const MoveY0		= ThisMove + 11
.const MoveY1		= ThisMove + 12
.const DeltaY		= ThisMove + 13
.const RAIdx1		= ThisMove + 14
.const RAIdx2		= ThisMove + 15
.const TmrCorr		= ThisMove + 16

//-----------------------------------------------------------------------------------------------------

* = $0400	"SinTab1"

SinTab1:
.fill $80,1+48*sin(toRadians([i+0.5]*360/256))
.fill $80,1+48*sin(toRadians([i+0.5]*360/256))

ScrollSinTab:
.fill $100,$58+$40*sin(toRadians([i+0.5]*360/128))

ScrollEndSin:
.fill $30,$38+0.5+$20*cos(toRadians([i+48.5]*360/96))

PtrTable:
.byte $10
.byte $80,$90,$a0,$b0,$c0,$d0,$e0,$f0
.byte $01,$11,$21,$31,$41,$51,$61,$71,$81,$91,$a1,$b1,$c1,$d1,$e1,$f1
.byte $82,$92,$a2,$b2,$c2,$d2,$e2,$f2
.byte $03,$13,$23,$33,$43,$53,$63,$73,$83,$93,$a3,$b3,$c3,$d3,$e3,$f3

Color1A:
.byte $00,$06,$0b,$06,$02,$0b,$08,$08,$04,$04,$0e,$0c
Color1B:
.byte $06,$09,$06,$02,$09,$02,$02,$04,$02,$0c,$04,$0e
Color2A:
.byte $0e,$0c,$0e,$0a,$05,$0c,$05,$0f,$03,$07,$01,$01
Color2B:
.byte $04,$0e,$0a,$0c,$0a,$05,$03,$03,$0d,$03,$07,$01

//-----------------------------------------------------------------------------------------------------

* = $7d00	"SinTab2"

SinTab2:
.fill $100,128+26.5+22.5*sin(toRadians([i+0.5]*360/256))
.fill $100,128+26.5+22.5*sin(toRadians([i+0.5]*360/256))

OrTable:
.fill $0c,$00
.fill $0c,$40
.fill $0c,$00
.fill $0c,$40
.fill $0c,$00
.fill $0c,$40
.fill $0c,$00
.fill $0c,$40
.fill $0c,$00

//-----------------------------------------------------------------------------------------------------

* = $8000

CheckerZoomer_Go:
			//jsr CreateBitmapColors
			jsr CreateZoomPhases
			jsr CreateSpritesAndScreens
			jsr CreateClearCode
			jsr CreateTables
			jsr CreateRasterCode	//RasterCode overlaps with CreateZoomPhases which is not a problem as CreateZoomPhases runs only once at start.
			jsr SetupSprites

			lda #$1f
			sta Phase

			nsync()

			lda #$18
			sta $d018				//Screen: $0400-$07e8, Charset: $2000-$27ff, blank screen only visible for 1 frame before borders are opened
			lda #$3c
			sta $dd02
			lda #$7b				//Turn invalid screen mode on so that we can open the uppen and lower borders
			sta $d011

			lda #$00
			sta FrmLo
			sta FrmHi

			lda #$30
			cmp $d012
			bne *-3
			lda #$00
			sta $d020
			sta $d021

			vsync()					//Instead of nsync() - to avoid skipped music frame

			lda #$fa
			ldx #<irqfa
			ldy #>irqfa
			sta $d012
			stx $fffe
			sty $ffff

			rts

//------------------------------

irqrc:		dec $00
			sta irqrcA+1
			:compensateForJitter(1)
			stx irqrcX+1
			sty irqrcY+1
		
			lda #$f7			//54-55
			sta $fffa			//56-59
			lda #$f6			//60-61
			sta $fffb			//62-02
			lda #$f7			//03-04
			sta $fffe			//05-08
			lda #$fa			//09-10
			sta $ffff			//11-14

irqdl:		ldx #$0a
			dex
			bpl *-1
			nop
			nop
			nop

			jsr RasterCode		//15-20
			
			lda #$10
			sta $d018
			lda #$3c
			sta $dd02

			asl $d019

			lda #<IRQLoader_RTI
			sta $fffa
			lda #>IRQLoader_RTI
			sta $fffb

			inc $00
			
			lda $01
			sta irqrc1+1
			lda #$35
			sta $01

			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff
			cli					//This finishes in raster line 246, we need to wait 2 more raster lines to open upper and lower borders

			lda #$f8
			cmp $d012
			bne *-3

			lda #$00
			sta $d011

irqr2:		nop Wave

irqr1:		nop RotationAroundY

irqr0:		jsr Zoom

irqr3:		jsr HorizontalScroll

irqr6:		nop FadeOut

irqr5:		nop RotationAroundX

irqr4:		nop SetGameIRQ

irqrc1:		lda #$00
			sta $01
irqrcY:		ldy #$00
irqrcX:		ldx #$00
irqrcA:		lda #$00
			rti

//------------------------------

irq00:		dec $00
			sta ir00_a+1
			stx ir00_x+1
			sty ir00_y+1
			asl $d019

			lda #$00
ir0sp:		nop $d015

ir011:		lda #$08
			sta $d011

			lda ir0fe+1
			cmp #<irqbmp
			bne ir00ms
			lda ir0ff+1
			cmp #>irqbmp
			bne ir00ms
						
			lda #$3f
			sta $dd02
			lda #$80
			sta $d018
			lda #<XX
			sta $e3f8
			sta $e3f9
			sta $e3fa
			sta $e3fb
			sta $e3fc
			sta $e3fd
			sta $e3fe
			sta $e3ff

ir00ms:		jsr BASE_PlayMusic

ir0fo:		nop FinishFadeOut

ir012:		lda #$34
			sta $d012
ir0fe:		lda #<irqrc
			sta $fffe
ir0ff:		lda #>irqrc
			sta $ffff

ir00_y:		ldy #$00
ir00_x:		ldx #$00
ir00_a:		lda #$00
			inc $00
			rti

//------------------------------

irqfa:		dec $00					//This IRQ runs only once to open the upper and lower borders for the badline-free screen mode to work
			pha

			lda #$00
			sta $d011

			asl $d019
			
			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

			pla
			inc $00
			rti

//--------------------------------------

irqfo:		dec $00
			sta irfo_A+1

			asl $d019
			
			lda #$00
			sta $d011

			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

irfo_A:		lda #$00
			inc $00
			rti

//--------------------------------------

FinishFadeOut:
			lda #$3f
			sta $dd02
			lda #$80
			sta $d018
			ldx #$06
			lda #<XX
!:			sta $e3f9,x
			dex
			bne !-
			ldx #<BoardSprite
			stx $e3f8
			inx
			stx $e3f9
			lda #$00
			sta $d010
			lda #$18+$a0-$0c
			sta $d000
			sta $d002
			lda #$00
			sta $d017

			lda #$04
			sta $d025
			lda #$0e
			sta $d026
			lda #$0b
			sta $d027
			lda #$06
			sta $d028

ffo0:		lda #$ea
			sta $d001
			sta $d003
			clc
			adc #$04
			sta ffo0+1
			cmp #$32
			bne ffo1

			lda #$01
			sta PART_Done

ffo1:		lda #$30
			cmp $d012
			bne *-3
			lda #$03
			sta $d015

			rts

//--------------------------------------

SetGameIRQ:
			lda #<CY0-6
			sta ir012+1
			lda #<irqbmp
			sta ir0fe+1
			lda #>irqbmp
			sta ir0ff+1

			lda #$3b
			sta $d011
			sta ir011+1
			lda #$d8
			sta $d016
			lda #$00
			sta $d010
			sta $d017	//Y-expand
			lda #$0b
			sta $d025
			lda #$0c
			sta $d026

			lda #$00
			sta FrmLo

			dec $01
			ldx #$07
!:			lda $c3f8,x
			sta BmpTmp+$40,x
			lda BmpTmp+$00,x
			sta $c3f8,x
			lda $c7f8,x
			sta BmpTmp+$48,x
			lda BmpTmp+$08,x
			sta $c7f8,x
			lda $cbf8,x
			sta BmpTmp+$50,x
			lda BmpTmp+$10,x
			sta $cbf8,x
			lda $cff8,x
			sta BmpTmp+$58,x
			lda BmpTmp+$18,x
			sta $cff8,x
			lda $d3f8,x
			sta BmpTmp+$60,x
			lda BmpTmp+$20,x
			sta $d3f8,x
			lda $d7f8,x
			sta BmpTmp+$68,x
			lda BmpTmp+$28,x
			sta $d7f8,x
			lda $dbf8,x
			sta BmpTmp+$70,x
			lda BmpTmp+$30,x
			sta $dbf8,x

			lda $e3f8,x
			sta BmpTmp+$78,x
			dex
			bpl !-
			inc $01

			rts

//--------------------------------------

HorizontalScroll:
			ldy #$00
hsst:		lax ScrollSinTab
			sta $d000					//max. $98
			clc
			adc #$18
			sta $d002					//max. $b0
			adc #$18
			sta $d004					//max. $c8
			adc #$18
			sta $d006					//max. $e0
			adc #$18
			sta $d008					//max. $108
			bcc hs00
			tya
			ora #$f0
			tay
hs00:		txa
			clc
			adc #$78
			sta $d00a					//max. $120
			bcc hs01
			tya
			ora #$e0
			tay
hs01:		txa
			clc
			adc #$90
			sta $d00c					//max. $138
			bcc hs02
			tya
			ora #$c0
			tay
hs02:		txa
			clc
			adc #$a8
			sta $d00e					//max. $120
			bcc hs03
			tya
			ora #$80
			tay
hs03:		sty $d010
			inc hsst+1
			ldy #$0a
			cpx #$40
			bcs !+
			//ldy #$08
			dey
!:			sty irqdl+1

			lda hsst+2
			cmp #>ScrollEndSin
			bne hs0x
			lda hsst+1
			cmp #<ScrollEndSin+$30
			bne hs0x

			lda #<OPC_NOP_ABS
			sta irqr3			//Disable horizontal scroll

			lda #<OPC_JSR
			sta irqr4

hs0x:		rts

//--------------------------------------

Zoom:
zm00:		lda SinTab1
			lsr
			ora #$40
			sta zm01+2
			arr #$00
			sta zm01+1
			ldx #$5f
zm01:		lda $c0de,x
			sta StepTable,x
			dex
			bpl zm01

			inc zm00+1
			lda zm00+1
			cmp #$40
			bcc zm0x
			
			lda #$0c
			sta $d027
			sta $d02e
			lda #$0b
			sta $d028
			sta $d029
			sta $d02a
			lda #$01
			sta $d02b
			sta $d02c
			lda #$0f
			sta $d02d
			
			lda #<OPC_JSR
			sta irqr1
			lda #<OPC_NOP_ABS
			sta irqr0

zm0x:		rts

//--------------------------------------

Wave:		ldy #$5f
			bpl	wvbf
			rts
wvbf:		ldx #$5f
wv00:		lda SinTab2+$e0,y
			lsr
			sta ZP+1			//wv01+2
			arr #$00
			sta ZP				//wv01+1
wv01:		lda (ZP),Y			//$c0de,y
			sta StepTable,x
			dex
			dey
wv02:		cpy #$5d
			bne wv00
			inc wv00+1
			inc wv00+1
			lda wv00+1
			cmp #$88
			bne !+
			clc
			adc #$10
			sta wv00+1
			lda FrmLo
			clc
			adc #$08
			sta FrmLo
!:			ldx wv02+1
			bmi wv03
			dec wv02+1
			dec wv02+1
wv03:		inc FrmLo
			bne wv04
			inc FrmHi
wv04:		lda FrmHi
			beq wv0x
			dec Wave+1
			dec Wave+1
			lda wvbf+1
			sec
			sbc #$02
			sta wvbf+1
			bcs wv0x
			lda #<OPC_NOP_ABS
			sta irqr2
			lda #<ScrollEndSin
			sta hsst+1
			lda #>ScrollEndSin
			sta hsst+2
wv0x:		rts

//--------------------------------------

FadeOut:	ldy #$5f
			cpy #$31
			bne	fobf
			lda #$f8
			sta ir012+1
			lda #<irqfo
			sta ir0fe+1
			lda #>irqfo
			sta ir0ff+1

			lda #<OPC_JSR
			sta ir0fo

			lda #$00
			sta $d015

			lda #<OPC_STA_ABS
			sta ir0sp

			rts

fobf:		ldx #$5f
fo00:		lda SinTab2+$e0,y
			lsr
			sta ZP+1			//fo01+2
			arr #$00
			sta ZP				//fo01+1
fo01:		lda (ZP),y			//$c0de,y
			eor #$40
			sta StepTable,x
			dex
			dey
fo02:		cpy #$5d
			bne fo00

			inc fo00+1
			inc fo00+1

			ldx fo02+1
			bmi fo03
			dec fo02+1
			dec fo02+1

fo03:		inc FrmLo
			bne fo04
			inc FrmHi
fo04:		lda FrmHi
			beq fo0x

			dec FadeOut+1
			dec FadeOut+1

fo0x:		rts

//--------------------------------------

RotationAroundY:

			ldx #$5f
ry00:		ldy SinTab1+$40				//This could be unrolled
ry01:		tya
ry02:		ora OrTable,x
			sta StepTable,x
			dex
			bpl ry01
			lda ry00+1
			clc
			adc #$02
			and #$7f
			sta ry00+1

			tax
			cmp #$04
			bne !+
			lda ry02+1
			eor #$0c
			sta ry02+1
			txa
!:			and #$3f
			cmp #$04
			bne !+
			ldx $d028
			ldy $d02d
			sty $d028
			stx $d02d
			ldx $d029
			ldy $d02c
			sty $d029
			stx $d02c
			ldx $d02a
			ldy $d02b
			sty $d02a
			stx $d02b
!:
			ldx #$01
!:			lda StepTable+0,x
			ora #$80
			sta StepTable+0,x
			lda StepTable+$5e,x
			ora #$80
			sta StepTable+$5e,x
			dex
			bpl !-
			
			lda ry00+1
			cmp #$40
			bne ry0x
			
			lda ry02+1		//Make sure we've had a full rotation, not just a half one (OrTable is restored)
			cmp #<(OrTable ^ $0c)
			beq ry0x

			ldx #$01
!:			lda #$0c
			sta $d027,x
			sta $d02d,x
			lda #$0b
			sta $d029,x
			sta $d02b,x
			dex
			bpl !-

			lda #<OPC_JSR
			sta irqr2
			lda #<OPC_NOP_ABS
			sta irqr1

ry0x:		rts

//--------------------------------------

RotationAroundX:
			lda #$00
			jsr ClearCode

			ldx Phase
			bpl rax0
			jmp RAX2
rax0:		lda #$00
			beq RAX0
rax1:		jmp RAX1

RAX0:		lda OffsetTable,x
			sta Offset
			clc
			adc #<StepTable
			sta rx03+1
			sta rx13+1
			sta rx04+1
			sta rx14+1
			sta rx06+1
			sta rx16+1
			sec
			sbc #$01
			sta rx01+1
			sta rx11+1

			txa
			asl
			asl
			asl
			sta ZP
			lda #>PhaseTables
			adc #$00
			sta ZP+1
			
			ldy #$06				//Exclude X=7 (value is always 0 - we do not need to EOR the topmost line)
rx00:		lax (ZP),y
			lda #$40
rx01:		eor StepTable,x
rx11:		sta StepTable,x
			dey
			bpl rx00

			ldx Phase
			lda DeltaLoTable,x
			sta rx0l+1
			lda DeltaHiTable,x
			sta rx0h+1
			lda #$40
			sta EorVal
			
			lda #$5f
			sec
			sbc Offset
			sbc Offset
			tax
			lda #$30
			ldy #$80
rx02:		sta NextVal
			lda EorVal
rx03:		eor StepTable,x
			sta EorVal
			eor NextVal
rx13:		sta StepTable,x
			tya
rx0l:		sbc #$00				//DeltaLo
			tay
			lda NextVal
rx0h:		sbc #$00				//DeltaHi
			dex
			bpl rx02

			lda #$80
			ldy Phase
			cpy #$0d
		 	bcc rx05
			ldx #00
			cpy #$1c
			bcc rx04
			inx
rx04:		lda StepTable,x
			ora #$80
rx14:		sta StepTable,x
			dex
			bpl rx04

rx05:		lda #$5f
			sec
			sbc Offset
			sbc Offset
			tax
			cpy #$18
			bcc rx06
			dex
rx06:		lda StepTable,x
			ora #$80
rx16:		sta StepTable,x
			inx
			cpx #$60
			bne rx06

			dec Phase
rx0x:		rts

//--------------------------------------

RAX1:		lda OffsetTable,x
			sta Offset
			clc
			adc #<StepTable
			sta rx23+1
			sta rx33+1
			sta rx24+1
			sta rx34+1
			sta rx26+1
			sta rx36+1

			txa
			asl
			asl
			asl
			sta ZP
			lda #>PhaseTables
			adc #$00
			sta ZP+1
			
			ldy #$06				//Exclude X=7 (value is always 0 - we do not need to EOR the topmost line)
rx20:		lda #$60
			sec
			sbc Offset
			sbc (ZP),y
			tax
			lda #$40
rx21:		eor StepTable,x
rx31:		sta StepTable,x
			dey
			bpl rx20

			ldx Phase
			lda DeltaLoTable,x
			sta rx2l+1
			lda DeltaHiTable,x
			sta rx2h+1
			lda #$40
			sta EorVal
			
			lda #$60
			sec
			sbc Offset
			sbc Offset
			sta rx27+1
			lda #$30
			ldy #$80
			ldx #$00
rx22:		sta NextVal
			lda EorVal
rx23:		eor StepTable,x
			sta EorVal
			eor NextVal
rx33:		sta StepTable,x
			tya
rx2l:		sbc #$00				//DeltaLo
			tay
			lda NextVal
rx2h:		sbc #$00				//DeltaHi
			inx
rx27:		cpx #$00
			bne rx22

			ldy Phase
			cpy #$0d
		 	bcc rx25
			lda #$5f
			sec
			sbc Offset
			sbc Offset
			tax
			lda #$80
			cpy #$1c
			bcc rx24
			dex
rx24:		lda StepTable,x
			ora #$80
rx34:		sta StepTable,x
			inx
			cpx #$60
			bne rx24

rx25:		ldx #$00
			cpy #$18
			bcc rx26
			inx
rx26:		lda StepTable,x
			ora #$80
rx36:		sta StepTable,x
			dex
			bpl rx26
			
			inc Phase
			lda Phase
			cmp #$20
			bne rx2x

			//lda #$1f
			//sta Phase
			//lda #$00
			//sta rax0+1

			lda #<OPC_NOP_ABS
			sta irqr5

			lda #<OPC_JSR
			sta irqr6
			
rx2x:		rts

//--------------------------------------

RAX2:		lda #$30
			ora #$80
			sta StepTable+$30

			lda #$00
			sta Phase
			lda #$01
			sta rax0+1

			rts

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

SwitchToBmp:
.byte $00,$01,$00,$00,$01,$00,$00,$01
.byte $00,$01,$01,$00,$01,$01,$01,$01

SwitchToFPP:
.byte $01,$00,$01,$01,$00,$01,$01,$00
.byte $01,$00,$00,$01,$00,$00,$00,$01

irqbmp:		sta irbm0_a+1
			stx irbm0_x+1
			sty irbm0_y+1
			lda $01
			sta irbm0_1+1
			lda #$35
			sta $01

			asl $d019

irbm0:		ldx #$00
			cpx #$40
			bne	!+
			
irbm2:		ldx #$0f
			bmi irbm3
			dec irbm2+1
			cpx #$10
			bcs irbm4
irbm5:		lda SwitchToBmp,x
			beq irbm4
			jsr RestoreFPPIRQ
			jmp irbm4

irbm3:		jsr HandleMoves

irbm4:		lda #$00
			sta irbm0+1

			lda #<CY0-6
			sta irbm1+1

			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

			jmp irbmx

!:			lda FigureYs+0,x
			beq *+5
			sta $d001
			lda FigureYs+1,x
			beq *+5
			sta $d003
			lda FigureYs+2,x
			beq *+5
			sta $d005
			lda FigureYs+3,x
			beq *+5
			sta $d007
			lda FigureYs+4,x
			beq *+5
			sta $d009
			lda FigureYs+5,x
			beq *+5
			sta $d00b
			lda FigureYs+6,x
			beq *+5
			sta $d00d
			lda FigureYs+7,x
			beq *+5
			sta $d00f

			nop
			nop
			nop
			nop
			nop

			lda FigureYs+0,x
			beq !+
			lda FigurePointers+0,x
			sta $e3f8
			lda FigureXs+0,x
			sta $d000
			lda FigureColors+0,x
			sta $d027
!:			lda FigureYs+1,x
			beq !+
			lda FigurePointers+1,x
			sta $e3f9
			lda FigureXs+1,x
			sta $d002
			lda FigureColors+1,x
			sta $d028
!:			lda FigureYs+2,x
			beq !+
			lda FigurePointers+2,x
			sta $e3fa
			lda FigureXs+2,x
			sta $d004
			lda FigureColors+2,x
			sta $d029
!:			lda FigureYs+3,x
			beq !+
			lda FigurePointers+3,x
			sta $e3fb
			lda FigureXs+3,x
			sta $d006
			lda FigureColors+3,x
			sta $d02a
!:			lda FigureYs+4,x
			beq !+
			lda FigurePointers+4,x
			sta $e3fc
			lda FigureXs+4,x
			sta $d008
			lda FigureColors+4,x
			sta $d02b
!:			lda FigureYs+5,x
			beq !+
			lda FigurePointers+5,x
			sta $e3fd
			lda FigureXs+5,x
			sta $d00a
			lda FigureColors+5,x
			sta $d02c
!:			lda FigureYs+6,x
			beq !+
			lda FigurePointers+6,x
			sta $e3fe
			lda FigureXs+6,x
			sta $d00c
			lda FigureColors+6,x
			sta $d02d
!:			lda FigureYs+7,x
			beq !+
			lda FigurePointers+7,x
			sta $e3ff
			lda FigureXs+7,x
			sta $d00e
			lda FigureColors+7,x
			sta $d02e
!:

irbm1:		lda #<CY0-6
			clc
			adc #$18
			sta irbm1+1
			sta $d012

			lda irbm0+1
			clc
			adc #$08
			sta irbm0+1
			
irbmx:
irbm0_1:	lda #$00
			sta $01
irbm0_y:	ldy #$00
irbm0_x:	ldx #$00
irbm0_a:	lda #$00
			//inc $00
			rti

//--------------------------------------

RestoreFPPIRQ:
			lda #$34
			sta ir012+1
			lda #<irqrc
			sta ir0fe+1
			lda #>irqrc
			sta ir0ff+1

			ldx #$70
			lda #$f8
			cmp $d012
			bne *-3
			stx $d011			//Invalid screen mode

			lda #$c8			//MC off
			sta $d016
			lda #$10
			sta $d018			//blank sprites
			lda #$3c
			sta $dd02

			dec $01
			ldx #$07
!:			lda BmpTmp+$40,x
			sta $c3f8,x
			lda BmpTmp+$48,x
			sta $c7f8,x
			lda BmpTmp+$50,x
			sta $cbf8,x
			lda BmpTmp+$58,x
			sta $cff8,x
			lda BmpTmp+$60,x
			sta $d3f8,x
			lda BmpTmp+$68,x
			sta $d7f8,x
			lda BmpTmp+$70,x
			sta $dbf8,x
			lda BmpTmp+$78,x
			sta $e3f8,x
			dex
			bpl !-

			inc $01

			lda #$08
			sta ir011+1

			lda #<ScrollSinTab
			sta hsst+1
			lda #>ScrollSinTab
			sta hsst+2

			jsr SetupSprites

			lda irbm2+1
			bpl rfix

			lda #<OPC_NOP_ABS
			sta irqr4			//Disable switch to bitmap

			lda #<OPC_JSR
			sta irqr5			//Enable fade out

			lda #$01
			sta PART_Done

			lda #$c0
			sta FrmLo
			lda #$00
			sta FrmHi

rfix:		rts

//--------------------------------------

CaptureColors:
.byte $02,$17,$08,$00,$00,$00,$00,$01,$0a,$00,$07,$02,$00,$00,$00,$17
.byte $02,$10,$10,$10,$10,$10,$10,$1a,$10,$10,$18,$10,$10,$10,$10,$10

//--------------------------------------

HandleMoves:
			:BranchIfNotFullDemo(SkipSync)
			lda MUSIC_FrameLo
			cmp #<SYNC_ChessGame
			lda MUSIC_FrameHi
			sbc #>SYNC_ChessGame			//; C=0 - we haven't reached the sync frame yet, C=1 we have reached the sync frame
			bcc hm04
			
SkipSync:
			inc FrmLo
			bne hmsh
			inc FrmHi			

hmsh:		lda FrmLo
			and #$1f
			bne hm01

			ldx #$10
CopyMove:	lda Move2,x
			cmp #$ff
			beq	hm0x
			sta ThisMove,x
			dex
			bpl	CopyMove
			
			lda CopyMove+1
			clc
			adc #<Move2-Move1
			sta CopyMove+1
			lda CopyMove+2
			adc #$00
			sta CopyMove+2
			jmp hm01
			
hm0x:		lda #<XX
			sta FigurePointers+4

			lda #$0f
			sta irbm2+1
			lda #<SwitchToFPP
			sta irbm5+1
			lda #>SwitchToFPP
			sta irbm5+2

			rts

hm01:		lda DeltaY
			beq SkipVerticalMove
			bpl hm03

			jmp HandleYUp

hm03:		jmp HandleYDown

SkipVerticalMove:
			
			lda DeltaX
			beq hm04
	
DoHorizontalMove:
			jmp HandleHorizontal

hm04:		rts

//--------------------------------------

HandleSwap:
			lda TmrCorr
			ora FrmLo
			sta FrmLo
			
			ldx RBIdx1
			bmi hswx
			ldy RBIdx2

			lda FigurePointers,y
			sta Tmp
			lda FigurePointers,x
			sta FigurePointers,y
			lda Tmp
			sta FigurePointers,x

			lda FigureColors,y
			sta Tmp
			lda FigureColors,x
			sta FigureColors,y
			lda Tmp
			sta FigureColors,x

			lda FigureXs,y
			sta Tmp
			lda FigureXs,x
			sta FigureXs,y
			lda Tmp
			sta FigureXs,x

			lda FigureYs,y
			sta Tmp
			lda FigureYs,x
			sta FigureYs,y
			lda Tmp
			sta FigureYs,x

hswx:		rts

//--------------------------------------

HandleHorizontal:	
			cmp #$80
			beq hh00
			jsr SwapSpritesBefore

hh00:		ldx Capture						//Color flicker for capturing a piece
			bmi !+
			stx Tmp
			lda FigureColors,x
			tax
			lda CaptureColors,x
			ldx Tmp
			sta FigureColors,x
!:			
			lda DeltaX
			cmp #$80
			beq HandleSwap
			ldx Idx1
			lda Ptr1
			sta FigurePointers,x

			lda Clr1
			sta FigureColors,x

			lda MoveX0
			clc
			adc DeltaX
			sta MoveX0
			sta FigureXs,x
			cmp MoveX1
			bne hh0x
			lda #$00
			sta DeltaX

			//------------------
			// Replace 1 <-> Replace 2
			//------------------

			jsr SwapSpritesAfter

hh0x:		rts

//--------------------------------------

HandleYUp:	jsr SwapSpritesBefore

hyu0:		ldx Idx2						//#2 - bottom sprite position
			lda #<XX						//Ptr2,y
			sta FigurePointers,x
			lda #$80						//Clr2,y
			sta FigureColors,x
			lda SpX2
			sta FigureXs,x
			lda #$00						//SpY2,y
			sta FigureYs,x

			ldx Capture						//Color flicker for capturing a piece
			bmi !+
			stx Tmp
			lda FigureColors,x
			tax
			lda CaptureColors,x
			ldx Tmp
			sta FigureColors,x
!:			
			ldx Idx1						//#1 - top sprite position
			lda Ptr1
			sta FigurePointers,x
			lda Clr1
			sta FigureColors,x

			lda MoveX0
			clc
			adc DeltaX
			sta MoveX0
			sta FigureXs,x
			cmp	MoveX1
			bne !+
			lda #$00
			sta DeltaX

!:			lda MoveY0
			clc
			adc DeltaY
			sta MoveY0
			sta FigureYs,x
			cmp MoveY1
			bne hyux

			lda #$00
			sta DeltaY

			//------------------
			// Replace 1 <-> Replace 2
			//------------------

			jsr SwapSpritesAfter

hyux:		rts

//--------------------------------------

HandleYDown:
			jsr SwapSpritesBefore
			
			ldx Capture						//Color flicker for capturing a piece
			bmi !+
			stx Tmp
			lda FigureColors,x
			tax
			lda CaptureColors,x
			ldx Tmp
			sta FigureColors,x
!:			
			ldx Idx1						//#1 - top sprite position
			lda Ptr1
			sta FigurePointers,x
			lda Clr1
			sta FigureColors,x
			
			lda MoveX0
			clc
			adc DeltaX
			sta MoveX0
			sta FigureXs,x
			cmp MoveX1
			bne !+
			lda #$00
			sta DeltaX

!:			lda MoveY0
			clc
			adc DeltaY
			sta MoveY0
			sta FigureYs,x
			cmp MoveY1
			bne hydx

			lda #$00
			sta DeltaY

			//------------------
			// Replace 1 <-> Replace 2
			//------------------

			jsr SwapSpritesAfter

hydx:		rts

//--------------------------------------

SwapSpritesBefore:
			ldx RBIdx2
			bmi ssbx

			ldy RBIdx1

			lda FigurePointers,x
			sta Tmp
			lda #<XX
			sta FigurePointers,x
			lda Tmp
			sta FigurePointers,y

			lda FigureColors,x
			sta Tmp
			lda #$80
			sta FigureColors,x
			lda Tmp
			sta FigureColors,y

			lda FigureYs,x
			sta Tmp
			lda #$00
			sta FigureYs,x
			lda Tmp
			sta FigureYs,y

			lda FigureXs,x
			sta Tmp
			lda FigureXs,y
			sta FigureXs,x
			lda Tmp
			sta FigureXs,y

			lda #$80
			sta RBIdx1
			sta RBIdx2
ssbx:		rts

//--------------------------------------

SwapSpritesAfter:
			lda TmrCorr
			ora FrmLo
			sta FrmLo
			
			ldx RAIdx1
			bmi ssax
			ldy RAIdx2

			lda FigurePointers,x
			sta FigurePointers,y
			lda #<XX
			sta FigurePointers,x

			lda FigureColors,x
			sta FigureColors,y
			lda #$80
			sta FigureColors,x

			lda FigureXs,x
			sta FigureXs,y
			lda #$00
			sta FigureXs,x

			lda FigureYs,x
			sta FigureYs,y
			lda #$00
			sta FigureYs,x

ssax:		rts

//-----------------------------------------------------------------------------------------------------

SetupSprites:
			ldx #$10
!:			lda SpriteCoords,x
			sta $d000,x
			dex
			bpl !-
			lda #$ff
			sta $d015
			sta $d017	//Y-expand
			sta $d01c	//MC-sprites
			lda #$00
			sta $d025	//MC color 1
			sta $d026	//MC color 2
			sta $d01d	//X-expand off

			ldx #$01
!:			lda #$0c
			sta $d027,x
			//sta $d028
			sta $d02d,x
			//sta $d02e
			lda #$0b
			sta $d029,x
			//sta $d02a
			sta $d02b,x
			//sta $d02c
			dex
			bpl !-

			rts

SpriteCoords:
.byte $58,$36,$70,$36,$88,$36,$a0,$36,$b8,$36,$d0,$36,$e8,$36,$00,$36,$80

//-----------------------------------------------------------------------------------------------------

CreateRasterCode:
			lda #<RasterCode
			sta ZP
			lda #>RasterCode
			sta ZP+1
			ldx #$c0
cr00:		ldy #<rb0x-rb00
cr01:		lda rb00,y
			sta (ZP),y
			dey
			bpl	cr01

cr02:		lda #$00
			eor #$ff
			sta cr02+1
			bne cr03

			inc	rb01+1

cr03:		lda rb02+2
			eor #>ColorTable1^ColorTable3
			sta rb02+2

			lda rb03+2
			eor #>ColorTable2^ColorTable4
			sta rb03+2

			lda #<rb0x-rb00
			clc
			adc ZP
			sta ZP
			bcc *+4
			inc ZP+1

			dex
			bne cr00
			rts

RasterBase:
rb00:		inc $d017				//00-05
			dec $d017				//06-11
rb01:		ldy.a StepTable			//12-15			//#$00-#$30 or #$40-#$70 for color swap
rb02:		ldx ColorTable1,y		//16-19	
			lda BankTable,y			//20-23
			stx $d018				//28-31
			sta $dd02				//24-27!
rb03:		lda ColorTable2,y		//32-35
			stx $d025				//36-39
			sta $d026				//40-43!
rb0x:		rts

//-----------------------------------------------------------------------------------------------------

CreateSpritesAndScreens:
			dec $01

			ldy #$1f						
			lax #$00
VB1:		sta $2000,x				//Clear Sprites (Not really necessary)
			inx
			bne VB1
			inc VB1+2
			dey
			bpl VB1


			//Create Pointers 

			ldy #$2e				//Last Screen is skipped to avoid overwriting IRQ vectors...
ScrLoop:	ldx #$07
PtrSrc:		lda PointerTable,x
PtrDst:		sta $23f8,x
			dex
			bpl PtrSrc

			lda PtrSrc+1
			clc
			adc #$08
			sta PtrSrc+1
			bcc *+6
			inc PtrSrc+2
			clc

			lda PtrDst+2
			adc #$04
			cmp #$83
			bne *+4
			lda #$a3
			sta PtrDst+2
			dey
			bpl ScrLoop

			ldx #$01
!:			lda PointerTable+$178,x
			sta $fff8,x
			//lda PointerTable+$179
			//sta $fff9
			lda PointerTable+$17c,x
			sta $fffc,x
			//lda PointerTable+$17d
			//sta $fffd
			dex
			bpl !-
			//Create empty sprite line pointers

			ldx #$07
			lda #$c0
!:			sta $07f8,x
			dex
			bpl !-

			//Create Sprites

			lda #$04
			sta Tmp
csploop:	ldy #$02
			ldx #$00
SpSrc1:		lda PatternTable,x
SpDst1:		sta $3000,x
			inx
			dey
			bpl SpSrc1
			lda SpDst1+1
			clc
			adc #$3d
			sta SpDst1+1
			bcc *+5
			inc SpDst1+2
			ldy #$02
SpSrc2:		lda PatternTable,x
			cmp #$aa
			bne SpDst1

			inc SpSrc1+2
			inc SpSrc2+2

			lda #$00
			sta SpDst1+1
			lda SpDst1+2
			and #$f0
			clc
			adc #$40
			sta SpDst1+2
			dec Tmp
			bne csploop
			
			inc $01

			rts

//-----------------------------------------------------------------------------------------------------

CreateClearCode:
			lda #<ClearCode
			sta ZP
			lda #>ClearCode
			sta ZP+1
			ldx #$5f
ccc0:		ldy #<cb0x-cb00
ccc1:		lda cb00,y
			sta (ZP),y
			dey
			bpl ccc1
			inc cb00+1
			lda #<cb0x-cb00
			clc
			adc ZP
			sta ZP
			bcc *+4
			inc ZP+1
			dex
			bpl ccc0
			rts

ClearBase:
cb00:		sta StepTable
cb0x:		rts

//-----------------------------------------------------------------------------------------------------

CreateTables:

			ldx #$30
!:			lda PtrTable,x
			sta BankTable,x
			sta BankTable+$40,x
			sta BankTable+$80,x
			sta BankTable+$c0,x
			dex
			bpl !-

			ldx #$00
!:			lda BankTable
			sta ColorTable1,x
			sta ColorTable3,x
			txa
			axs #$c0
			bne !-

			txa
			ldx #$5f
			//lda #$00
cst0:		sta StepTable,x
			dex
			bpl cst0

			ldy #$00
cct0:		ldx #$03
cct1:		lda Color1A,y
CTDst1:		sta ColorTable1+$01,x
CTDst3:		sta ColorTable2+$41,x
			lda Color2A,y
CTDst2:		sta ColorTable2+$01,x
CTDst4:		sta ColorTable1+$41,x
			lda Color1B,y
CTDst5:		sta ColorTable3+$01,x
CTDst7:		sta ColorTable4+$41,x
			lda Color2B,y
CTDst6:		sta ColorTable4+$01,x
CTDst8:		sta ColorTable3+$41,x
			dex
			bpl cct1
			lda CTDst1+1
			clc
			adc #$04
			sta CTDst1+1
			sta CTDst2+1

			lda CTDst3+1
			adc #$04
			sta CTDst3+1
			sta CTDst4+1

			lda CTDst5+1
			clc
			adc #$04
			sta CTDst5+1
			sta CTDst6+1

			lda CTDst7+1
			adc #$04
			sta CTDst7+1
			sta CTDst8+1

			iny
			cpy #$0c
			bne cct0
			
			ldx #$19
!:			lda #$0b
			sta ColorTable1+$80,x
			sta ColorTable1+$c0,x
			sta ColorTable2+$80,x
			sta ColorTable2+$c0,x
			sta ColorTable3+$80,x
			sta ColorTable3+$c0,x
			sta ColorTable4+$80,x
			sta ColorTable4+$c0,x
			lda #$0c
			sta ColorTable1+$9a,x
			sta ColorTable1+$da,x
			sta ColorTable2+$9a,x
			sta ColorTable2+$da,x
			sta ColorTable3+$9a,x
			sta ColorTable3+$da,x
			sta ColorTable4+$9a,x
			sta ColorTable4+$da,x
			dex
			bpl !-

			ldy #$00
!:			lax BankTable,y
			and #$f0
			ora ColorTable1,y
			sta ColorTable1,y
			and #$f0
			ora ColorTable3,y
			sta ColorTable3,y
			txa
			and #$03
			ora #$3c
			sta BankTable,y
			iny
			bne !-

			rts

//-----------------------------------------------------------------------------------------------------

CreateZoomPhases:
			ldy #<NumPhases/2
			lda #$00
!:			ldx #<TableSize-1
czp0:		sta ZoomPhases,x
czp1:		sta ZoomPhases + $80,x
			dex
			bpl czp0
			inc czp0+2
			inc czp1+2
			dey
			bpl !-

			lda #<ZoomPhases+$80
			sta ZP
			lda #>ZoomPhases+$80
			sta ZP+1

			ldx #$01
czp2:		txa
			asl
			sta ZoomSize
			lda #<TableSize
			sec
			sbc ZoomSize
			lsr
			ora ZP
			sta ZP

			cpx #$06
			bcs NotFirst5

			txa
			ldy ZoomSize
!:			dey
			sta (ZP),y
			bne !-

			ldy #$01
			lda (ZP),y
			ora #$40
!:			sta (ZP),y
			iny
			iny
			cpy ZoomSize
			bcc !-
			ldy #$00
			jmp AddBorders


NotFirst5:	lda #$00
			sta DeltaLo
			lda ZoomSize
			lsr
			ror DeltaLo
			lsr
			ror DeltaLo
			lsr
			ror DeltaLo
			sta DeltaHi
			sta PhaseStepHi
			lda DeltaLo
			sta PhaseStepLo

			ldy #$00
PhaseSwap:	txa
!:			sta (ZP),y
			iny
			cpy PhaseStepHi
			bcc !-
			bne NextPhase
			lda PhaseStepLo
			bne PhaseSwap

NextPhase:	lda PhaseStepLo
			clc
			adc DeltaLo
			sta PhaseStepLo
			lda PhaseStepHi
			adc DeltaHi
			sta PhaseStepHi

!:			txa
			eor #$40
!:			sta (ZP),y
			iny
			cpy PhaseStepHi
			bcc !-
			bne SwapPhase
			lda PhaseStepLo
			bne !--

SwapPhase:	lda PhaseStepLo
			clc
			adc DeltaLo
			sta PhaseStepLo
			lda PhaseStepHi
			adc DeltaHi
			sta PhaseStepHi
			cmp ZoomSize
			bcc PhaseSwap
			beq PhaseSwap

			ldy #$00
			cpx #<(NumPhases+1)/2
			bcc AddBorders
			iny
AddBorders:	sty BorderWidth
!:			ldy BorderWidth
			lda (ZP),y
			ora #$80
			sta (ZP),y
			tya
			sec
			sbc BorderWidth
			clc
			adc ZoomSize
			sbc BorderWidth			//C=0, subtract BorderWidth+1
			tay
			lda (ZP),y
			ora #$80
			sta (ZP),y
			dec BorderWidth
			bpl !-
			lda ZP
			and #$80
			//clc
			eor #$80
			sta ZP
			bne *+4
			inc ZP+1
			inx
			cpx #NumPhases
			beq czpx
			jmp czp2
czpx:		rts

//-----------------------------------------------------------------------------------------------------

*= $a400

FigurePointers:
.byte BR,BN,BB,BQ,BK,BB,BN,BR
.byte BP,BP,BP,BP,BP,BP,BP,BP
.byte XX,XX,XX,XX,XX,XX,XX,XX
.byte XX,XX,XX,XX,XX,XX,XX,XX
.byte XX,XX,XX,XX,XX,XX,XX,XX
.byte XX,XX,XX,XX,XX,XX,XX,XX
.byte WP,WP,WP,WP,WP,WP,WP,WP
.byte WR,WN,WB,WQ,WK,WB,WN,WR

FigureColors:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80
.byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
.byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f

FigureXs:
.byte CX0,CX1,CX2,CX3+1,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3,CX4,CX5,CX6,CX7
.byte CX0,CX1,CX2,CX3+1,CX4,CX5,CX6,CX7

FigureYs:
.byte CY0,CY0,CY0,CY0,CY0,CY0,CY0,CY0
.byte CY1,CY1,CY1,CY1,CY1,CY1,CY1,CY1
.byte $00,$00,$00,$00,$00,$00,$00,$00	//CY2,CY2,CY2,CY2,CY2,CY2,CY2,CY2
.byte $00,$00,$00,$00,$00,$00,$00,$00	//CY3,CY3,CY3,CY3,CY3,CY3,CY3,CY3
.byte $00,$00,$00,$00,$00,$00,$00,$00	//CY4,CY4,CY4,CY4,CY4,CY4,CY4,CY4
.byte $00,$00,$00,$00,$00,$00,$00,$00	//CY5,CY5,CY5,CY5,CY5,CY5,CY5,CY5
.byte CY6,CY6,CY6,CY6,CY6,CY6,CY6,CY6
.byte CY7,CY7,CY7,CY7,CY7,CY7,CY7,CY7

*=ThisMove "Moves"
Move1:		//e4
.byte	$80,	$80,	$24,	WP,		$0f,	$80,	$34,	CX4,	CX4,	CX4,	$00,	CY6,	CY4,	$fe,	$80,	$80,	$00

//		RBIdx1	RBIdx2	Idx1	Ptr1	Clr1	Captr	Idx2	SpX2	X0		X1		DX		Y0		Y1		DY		RAIdx1	RAIdx2	Tmr
Move2:		//e5
.byte	$80,	$80,	$0c,	BP,		$00,	$80,	$1c,	CX4,	CX4,	CX4,	$00,	CY1,	CY3,	$02,	$0c,	$1c,	$00
Move3:		//Nf3
.byte	$36,	$37,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$34,	$36,	$36,	WN,		$0f,	$80,	$3e,	CX6,	CX6,	CX6,	$00,	CY7,	CY6,	$fe,	$80,	$80,	$1f
.byte	$80,	$80,	$2e,	WN,		$0f,	$80,	$36,	CX6,	CX6,	CX5,	$fe,	CY6,	CY5,	$fe,	$34,	$36,	$00
.byte	$36,	$37,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
Move4:		//Nc6
.byte	$0c,	$09,	$01,	BN,		$00,	$80,	$09,	CX1,	CX1,	CX1,	$00,	CY0,	CY1,	$02,	$80,	$80,	$1f
.byte	$80,	$80,	$01,	BN,		$00,	$80,	$12,	CX2,	CX1,	CX2,	$02,	CY1,	CY2,	$02,	$01,	$12,	$00
Move5:		//Nc3
.byte	$34,	$31,	$31,	WN,		$0f,	$80,	$39,	CX1,	CX1,	CX1,	$00,	CY7,	CY6,	$fe,	$80,	$80,	$1f
.byte	$80,	$80,	$29,	WN,		$0f,	$80,	$31,	CX1,	CX1,	CX2,	$02,	CY6,	CY5,	$fe,	$34,	$31,	$00
Move6:		//Nf6
.byte	$0e,	$0f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$09,	$0e,	$06,	BN,		$00,	$80,	$0e,	CX6,	CX6,	CX6,	$00,	CY0,	CY1,	$02,	$80,	$80,	$1f
.byte	$80,	$80,	$06,	BN,		$00,	$80,	$15,	CX5,	CX6,	CX5,	$fe,	CY1,	CY2,	$02,	$06,	$15,	$00
.byte	$0e,	$0f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
Move7:		//a3
.byte	$80,	$80,	$28,	WP,		$0f,	$80,	$30,	CX0,	CX0,	CX0,	$00,	CY6,	CY5,	$fe,	$80,	$80,	$00
Move8:		//a5
.byte	$80,	$80,	$0b,	BP,		$00,	$80,	$13,	CX3,	CX3,	CX3,	$00,	CY1,	CY3,	$02,	$0b,	$13,	$00
Move9:		//exd5
.byte	$13,	$1f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$1d,	$1c,	$1c,	WP,		$0f,	$1f,	$24,	CX3,	CX4,	CX3,	$fe,	CY4,	CY3,	$fe,	$1c,	$1f,	$00
Move10:		//Nxd5
.byte	$80,	$80,	$15,	BN,		$00,	$1f,	$14,	CX4,	CX5,	CX4,	$fe,	CY2,	CY2,	$00,	$15,	$14,	$1f
.byte	$80,	$80,	$14,	BN,		$00,	$1f,	$1c,	CX3,	CX4,	CX3,	$fe,	CY2,	CY3,	$02,	$14,	$1f,	$00
Move11:		//Be2
.byte	$3c,	$3f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$35,	$37,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$34,	$35,	$35,	WB,		$0f,	$80,	$3d,	CX3,	CX5,	CX4,	$fe,	CY7,	CY6,	$fe,	$1d,	$1c,	$00
.byte	$3c,	$3f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
Move12:		//e4
.byte	$80,	$80,	$1c,	BP,		$00,	$80,	$22,	CX4,	CX4,	CX4,	$00,	CY3,	CY4,	$02,	$1c,	$22,	$00
Move13:		//Nxe4
.byte	$22,	$27,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$2a,	$29,	$2a,	WN,		$0f,	$27,	$2b,	CX3,	CX2,	CX3,	$02,	CY5,	CY5,	$00,	$80,	$80,	$1f
.byte	$80,	$80,	$23,	WN,		$0f,	$27,	$2a,	CX4,	CX3,	CX4,	$02,	CY5,	CY4,	$fe,	$2a,	$27,	$00
.byte	$22,	$27,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
Move14:		//Nf4
.byte	$13,	$14,	$1f,	BN,		$00,	$80,	$00,	$00,	CX3,	CX4,	$02,	CY3,	CY3,	$00,	$1f,	$1c,	$1f
.byte	$80,	$80,	$1c,	BN,		$00,	$80,	$00,	$00,	CX4,	CX5,	$02,	CY3,	CY4,	$02,	$1c,	$25,	$00
Move15:		//O-O
.byte	$80,	$80,	$3c,	WK,		$0f,	$80,	$00,	$00,	CX4,	CX6,	$02,	CY7,	CY7,	$00,	$3c,	$3e,	$1f
.byte	$3e,	$3f,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$80,	$80,	$3e,	WR,		$0f,	$80,	$00,	$00,	CX7,	CX5,	$fe,	CY7,	CY7,	$00,	$3e,	$3d,	$00
Move16:		//Nxe2+
.byte	$23,	$27,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
.byte	$80,	$80,	$25,	BN,		$00,	$35,	$00,	$00,	CX5,	CX4,	$fe,	CY4,	CY5,	$02,	$25,	$2c,	$1f
.byte	$30,	$34,	$2c,	BN,		$00,	$35,	$00,	$00,	CX4,	CX4,	$00,	CY5,	CY6,	$02,	$2c,	$35,	$00
.byte	$23,	$27,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$80,	$00,	$00,	$00,	$00,	$00,	$1f
Move17:		//Qxe2
.byte	$34,	$33,	$33,	WQ,		$0f,	$35,	$3b,	CX3,	CX3+1,	CX4+1,	$02,	CY7,	CY6,	$fe,	$33,	$35,	$00
Move18:		//Bg4
.byte	$0b,	$0a,	$02,	BB,		$00,	$80,	$00,	$00,	CX2,	CX3,	$02,	CY0,	CY1,	$02,	$02,	$0a,	$1f
.byte	$13,	$12,	$0a,	BB,		$00,	$80,	$00,	$00,	CX3,	CX5,	$02,	CY1,	CY3,	$02,	$0a,	$1d,	$1f
.byte	$80,	$80,	$1d,	BB,		$00,	$80,	$00,	$00,	CX5,	CX6,	$02,	CY3,	CY4,	$02,	$1d,	$26,	$00
Move19:		//Nf6#
.byte	$23,	$24,	$1c,	WN,		$0f,	$80,	$24,	CX4,	CX4,	CX4,	$00,	CY4,	CY3,	$fe,	$80,	$80,	$1f
.byte	$80,	$80,	$15,	WN,		$0f,	$80,	$1c,	CX4,	CX4,	CX5,	$02,	CY3,	CY2,	$fe,	$80,	$80,	$00
.byte	$80,	$80,	$05,	BK,		$00,	$04,	$05,	CX4,	CX4,	CX5,	$80,	CY0,	CY0,	$00,	$80,	$80,	$00
MoveEnd:
.byte $ff
