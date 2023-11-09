//------------------------------
//	EARTH
//------------------------------

.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

//; ------------------------

//; Memory Map
//;   02	  04	Sparkle (only during loading)
//;   fc	  fd	Music ZP
//;   fe	  ff	Music frame counter
//; 0160	03ff	Sparkle (ALWAYS)
//; 0400	07ff	SinTab
//; 0800	08ff	Disk Driver
//; 0900	1fff	Music
//; 2000	74ff	Map Data
//; 7500	b9cf	Unrolled blit code
//; ba00	bfff	-UNUSED-
//; c000	df3f	MC Bitmap
//; e000	e3f7	Color RAM
//; e400	f0ff	Sprites
//; e800*	ecff*	Init (will be overwritten by sprites)
//; f100	f5ff	Main code
//; f600	ff7f	-UNUSED-
//; f700	ff00	FadeTables
//; ff80	ffbe	Empty sprite

.label Init				= $e800
.label Earth			= $f100
.const SineTabLo		= $0400
.const SineTabHi		= $0600
.const Map				= $2000
.const Blit				= $7500
.const CompMap			= Blit - (Blit-Map)/4
.const Sprite			= $e400
.const Offsets			= $3000
.const ByteCnt			= $3d00
.const Partial			= ByteCnt+$55
.const SpOffset			= ByteCnt+$aa
.const IL				= $3e00

.const ZP				= $10	//2 bytes
.const Tmp				= $12	
.const Overlap			= $13
.const MapOfst			= $14	//2 bytes
.const MapRow			= $16	//1 byte (hi byte of Map address)
.const SP				= $17	//2 bytes (first byte of sprite row)
.const SpOfst			= $19	//1 bytes
.const Tmp2				= $1a

.const FadeStart		= $1b

.const VICBank			= $c000
.const Bitmap			= VICBank
.const ScrRAM			= $e000
.const ColRAM			= $d800
.const Sprites			= $e400
.const SpPtr			= ScrRAM + $03f8
.const FadeTables		= $f700
.const TmpScr			= $e400
.const TmpCol			= $bc00

.const SpCol1			= $08
.const SpCol2			= $02
.const SpCol3			= $06
.const SpCol4			= $00		//; Blue globe
.const SpCol5			= $00		//; Shadow
.const SpBase			= $2400/64

.const ZPA				= $20
.const ZPX				= $21
.const ZPY				= $22

.const ZPA0				= $23
.const ZPX0				= $24
.const ZPY0				= $25

.const SpriteX			= $26
.const SpriteXHi		= $27
.const SineLo			= $28	//2 bytes
.const SineHi			= $2a	//2 bytes
.const SpriteY			= $2c
.const SpritePhase		= $2d
.const SpriteStep		= $2e

.const Phase			= $30

.const OPC_NOPABS		= $0c

//--------------------------

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

.macro UpdateIRQ()
{
		sta $d012
		stx $fffe
		sty $ffff
}

//--------------------------

* = Earth	"Main code"

Earth_Go:
		jsr MkBlt
		jsr ExpandMap

		bit ADDR_FullDemoMarker
		bpl SkipSync
		MusicSync(SYNC_EarthBitmapIn-1)
	SkipSync:

		jsr SetupSprites			//These two calls require $1c (#28) frames

		ldy Phase
FirstX:
		ldx #$aa
BitLoop:
		txa
		beq	FirstX
NextX:
		dex
		nsync()
		jsr Blit
		tya
		eor #$40
		sta Phase
		tay
		lda PART_Done
		beq	BitLoop
		rts

//--------------------------

SetupSprites:

		ldy #$09
		lax #$00
SpClrLoop:
		sta Sprites,x
		inx
		bne SpClrLoop
		inc SpClrLoop+2
		dey
		bpl SpClrLoop

		ldx #$3f
SpClrLoop2:
		sta VICBank+(254*64),x		//; ff80-ffbe, Sprite #$fe - empty sprite
		dex
		bpl SpClrLoop2
		
		nsync()
		
		lda #$00
		sta Phase
		sta SpritePhase
		lda PhaseSteps
		sta SpriteStep
		
		lda #$00
		sta $d020
		sta $d021

		lda #<SineTabLo
		sta SineLo
		lda #>SineTabLo
		sta SineLo+1
		lda #<SineTabHi
		sta SineHi
		lda #>SineTabHi
		sta SineHi+1

		lda #$78
		sta SpriteX
		//sta $d00c
		//sta $d00e
		lda #$6a
		sta SpriteY
		lda #$01
		sta SpriteXHi

		lda #$2a		//#$3f
		sta Sprites+(34*64)+$11			//Buttom pixel row go globe is always set
		sta Sprites+(35*64)+$11
		lda #$a8		//#$fc
		sta Sprites+(36*64)+$0f
		sta Sprites+(37*64)+$0f
		
		ldx #$03
		lda #SpBase+6
		sec
PtrLoop:
		sta SpPtr,x
		sbc #$02
		dex
		bpl PtrLoop
		
		ldx #SpBase+40
		stx SpPtr+4
		inx
		stx SpPtr+5
		ldx #SpBase+50
		stx SpPtr+6
		inx
		stx SpPtr+7

		//lda #220			//Shadow Y-pos
		//sta $d00d
		//sta $d00f
		lda #SpCol3
		sta $d025			//MC color 1
		lda #SpCol1
		sta $d026			//MC color 2
		ldx #$03
		lda #SpCol2
SprColLoop:
		sta $d027,x			//Sprite colors
		dex
		bpl SprColLoop
		
		lda #SpCol4
		sta $d02b
		sta $d02c
		
		lda #SpCol5
		sta $d02d
		sta $d02e

		lda #$3f
		sta $d010			//MSB
		lda #$00
		sta $d01b			//Sprite priority
		sta $d017			//Y-expand off
		lda #$30
		sta $d01d			//X-expand Sprites 4-5
		lda #$0f
		sta $d01c			//MC sprites: 0-3, HR: 4-5
		lda #$3f
		sta $d015			//Sprites on
		
		lda #$3f			//; VIC Bank: $c000-$ffff
		sta $dd02
		lda #$80			//; Bitmap: $c000-$df3f, Color RAM: $e000-$e3e7
		sta $d018
		lda #$18
		sta $d016
		lda #$3b			//; MC Bitmap mode
		sta $d011			
		lda #00
		ldx #<IRQ0
		ldy #>IRQ0
		UpdateIRQ()

		rts

//--------------------------

IRQ0:	StartIRQ(0)

		asl $d019
	
		//lda #$00
		//sta $d020
		//sta $d021

		//lda #$d8
		//sta $d016

		jsr BASE_PlayMusic

		lda SpriteY
		.for(var i = 0; i < 12; i += 2)
		{
			sta $d001+i
		}

		{
		ldx #$03
		lda #SpBase+6
		ldy Phase
		bne *+4
		lda #SpBase+7
		sec
Loop:	sta SpPtr,x
		sbc #$02
		dex
		bpl Loop
		}
		ldx #SpBase+40
		stx SpPtr+4
		inx
		stx SpPtr+5

		jsr UpdateX

		lda SpriteY
		clc
		adc #$12
		bcc !+
		tax
		lda $d011
		ora #$80
		sta $d011
		txa
!:		ldx #<IRQ1
		ldy #>IRQ1

IRQEnd:	UpdateIRQ()
		EndIRQ(0)

//--------------------------

IRQ1:	StartIRQ(0)
		lax $d001
		axs #$100-$15
		.for(var i = 0; i < 12; i+=2)
		{
			stx $d001+i
		}

		lda #$fd
		ldx #SpBase+$0a
		bit Phase
		beq ir10			//	2	3

		ldy $d012			//	4	-
		cpy $d012			//	4	-
		beq *-3				//	2	-

		sax SpPtr+0			//	4	-
		stx SpPtr+1			//	4	-
		ldx #SpBase+$0e		//	2	-
		bne ir11			//	3	-

ir10:	inx					//	-	2

		ldy $d012			//	-	4
		cpy $d012			//	-	4
		beq *-3				//	-	2

		sax SpPtr+0			//	-	4
		stx SpPtr+1			//	-	4
		ldx #SpBase+$0f		//	-	2

ir11:	sax SpPtr+2			//	25	25 cycles each branch
		stx SpPtr+3
		ldx #SpBase+42
		stx SpPtr+4
		inx
		stx SpPtr+5
		
		lda SpriteY
		clc
		adc #$27
		bcc !+
		tax
		lda $d011
		ora #$80
		sta $d011
		txa
!:		ldx #<IRQ2
		ldy #>IRQ2
		jmp IRQEnd

//--------------------------

IRQ2:	StartIRQ(0)
				
		lda #$fd
		ldx #SpBase+$12
		bit Phase
		beq ir20			//	2	3

		ldy $d012			//	4	-
		cpy $d012			//	4	-
		beq *-3				//	2	-

		sax SpPtr+0			//	4	-
		stx SpPtr+1			//	4	-
		ldx #SpBase+$16		//	2	-
		bne ir21			//	3	-

ir20:	inx					//	-	2

		ldy $d012			//	-	4
		cpy $d012			//	-	4
		beq *-3				//	-	2

		sax SpPtr+0			//	-	4
		stx SpPtr+1			//	-	4
		ldx #SpBase+$17		//	-	2

ir21:	sax SpPtr+2			//	25	25 cycles each branch
		stx SpPtr+3
		ldx #SpBase+44
		stx SpPtr+4
		inx
		stx SpPtr+5

		jsr NextSpriteRow 
		
		lda SpriteY
		clc
		adc #$3a
		bcc !+
		tax
		lda $d011
		ora #$80
		sta $d011
		txa
!:		ldx #<IRQ3
		ldy #>IRQ3
		jmp IRQEnd

//--------------------------

IRQ3:	IRQManager_BeginIRQ(1, 0)

		nop

		lda #$fd
		ldx #SpBase+$1a
		bit Phase
		beq ir30			//	2	3

		ldy $d012			//	4	-
		cpy $d012			//	4	-
		beq *-3				//	2	-

		sax SpPtr+0			//	4	-
		stx SpPtr+1			//	4	-
		ldx #SpBase+$1e		//	2	-
		bne ir31			//	3	-

ir30:	inx					//	-	2

		ldy $d012			//	-	4
		cpy $d012			//	-	4
		beq *-3				//	-	2

		sax SpPtr+0			//	-	4
		stx SpPtr+1			//	-	4
		ldx #SpBase+$1f		//	-	2

ir31:	sax SpPtr+2			//	25	25 cycles each branch
		stx SpPtr+3
		ldx #SpBase+46
		stx SpPtr+4
		inx
		stx SpPtr+5
		
		jsr NextSpriteRow 

		//jsr RasterColor

		lda SpriteY
		clc
		adc #$4f
		bcc !+
		tax
		lda $d011
		ora #$80
		sta $d011
		txa
!:		ldx #<IRQ4
		ldy #>IRQ4
		UpdateIRQ()
		IRQManager_EndIRQ()
		rti

//--------------------------

IRQ4:	StartIRQ(0)

		lda #$fd
		ldx #SpBase+$22
		bit Phase
		beq ir40			//	2	3

		ldy $d012			//	4	-
		cpy $d012			//	4	-
		beq *-3				//	2	-

		sax SpPtr+0			//	4	-
		stx SpPtr+1			//	4	-
		ldx #SpBase+$26		//	2	-
		bne ir41			//	3	-

ir40:	inx					//	-	2

		ldy $d012			//	-	4
		cpy $d012			//	-	4
		beq *-3				//	-	2

		sax SpPtr+0			//	-	4
		stx SpPtr+1			//	-	4
		ldx #SpBase+$27		//	-	2

ir41:	sax SpPtr+2			//	25	25 cycles each branch
		stx SpPtr+3
		ldx #SpBase+48
		stx SpPtr+4
		inx
		stx SpPtr+5

		jsr NextSpriteRow 
		
		lda SpriteY
		clc
		adc #$5a
		bcc !+
		tax
		lda $d011
		ora #$80
		sta $d011
		txa
!:		ldx #<IRQ5
		ldy #>IRQ5
		jmp IRQEnd

//--------------------------

IRQ5:	sta ZPA

		lda #$fe			//Blank Sprite at $ff80-$ffbe
		sta SpPtr+0
		sta SpPtr+1
		sta SpPtr+2
		sta SpPtr+3
		sta SpPtr+4
		sta SpPtr+5

		stx ZPX
		sty ZPY

		jsr Move

		//lda #$08
		//ldx #$c9
		//cpx $d012
		//bne *-3

		//ldx #$06
		//dex
		//bpl *-1
		//nop
		//nop
		//nop

		//sta $d016

		lda $d011
		and #$7f
		sta $d011

FOFlag:	lda #$00
		beq !+

		lda #$fa
		ldx #<IRQFO1
		ldy #>IRQFO1
		jmp IRQEnd

!:		lda #$00
		ldx #<IRQ0
		ldy #>IRQ0
		jmp IRQEnd

//--------------------------

IRQFO1: pha
		txa
		pha
		tya
		pha
		lda $01
		pha
		lda #$35
		sta $01

		asl $d019
		
		lda #$00
		sta $d012
		lda #<IRQFO2
		sta $fffe
		lda #>IRQFO2
		sta $ffff
		cli
		
		dec $01

		jsr FadeOut

		inc $01

		pla
		sta $01
		pla
		tay
		pla
		tax
		pla
		rti

//--------------------------

IRQFO2:	dec $00
		sta ZPA
		stx ZPX
		sty ZPY

		asl $d019

		jsr BASE_PlayMusic

		lda #$fa
		sta $d012
		lda #<IRQFO1
		sta $fffe
		lda #>IRQFO1
		sta $fff

		ldy ZPY
		ldx ZPX
		lda ZPA
		inc $00
		rti

//--------------------------

FadeOut:

StartX:	lda #$60
		sta XVal+1
D1Lo:	lda #<Bitmap-$60
		sta Ds1+1
D1Hi:	lda #>Bitmap-$60
		sta Ds1+2
D2Lo:	lda #<Bitmap+$40
		sta Ds2+1
D2Hi:	lda #>Bitmap+$40
		sta Ds2+2
StartY:	ldy #$00
		cpy #$19
		beq Done
XVal:	ldx #$60
FOLoop:	lda #$00
Ds1:	sta Bitmap-$60,x
Ds2:	sta Bitmap+$40,x
		txa
		axs #$f8
		bcc FOLoop
		iny
		cpy #$19
		beq LoopDone
		lda Ds1+1
		clc
		adc #$40
		sta Ds1+1
		lda Ds1+2
		adc #$01
		sta Ds1+2
		lda Ds2+1
		clc
		adc #$40
		sta Ds2+1
		lda Ds2+2
		adc #$01
		sta Ds2+2
		dec XVal+1
		ldx XVal+1
		cpx #$5f
		bne FOLoop
LoopDone:
		inc StartX+1
		lda StartX+1
		cmp #$68
		bne Done
		lda #$67
		sta StartX+1
		inc StartY+1
		lda StartY+1
		cmp #$19
		bne FONotDone
		inc PART_Done
		rts
FONotDone:
		lda D1Lo+1
		clc
		adc #$40
		sta D1Lo+1
		lda D1Hi+1
		adc #$01
		sta D1Hi+1
		lda D2Lo+1
		clc
		adc #$40
		sta D2Lo+1
		lda D2Hi+1
		adc #$01
		sta D2Hi+1
Done:	
		rts
//--------------------------

Move:	ldy #$00
		lda (SineLo),y
		sta SpriteX
		lda (SineHi),y
		sta SpriteXHi

		ldx SpritePhase
		lda PhaseDirLo,x
		clc
		adc SineLo
		sta SineLo
		sta SineHi

		lda	PhaseDirHi,x
		adc SineLo+1
		sta SineLo+1
		clc
		adc #>SineTabHi-SineTabLo
		sta SineHi+1

!:		dec SpriteStep
		bne	MoveDone
		inc SpritePhase
		ldx SpritePhase
		cpx #$05
		bcc !+
		//:BranchIfNotFullDemo(NotDone)
		//inc PART_Done
		stx FOFlag+1
		bcs MoveDone

NotDone:
		lda #>SineTabLo
		sta SineLo+1
		lda #>SineTabHi
		sta SineHi+1
		ldx #$00
		stx SpritePhase
!:		lda PhaseSteps,x
		sta SpriteStep
MoveDone:
		rts

PhaseSteps:
.byte $c8,$70,$70,$70,$a0
PhaseDirLo:
.byte $01,$01,$ff,$01,$01
PhaseDirHi:
.byte $00,$00,$ff,$00,$00

//--------------------------

UpdateX:
		lax SpriteX
		sta $d000
		lda SpriteXHi
		lsr
		ror
		tay

		txa
		adc #$18
		sta $d002
		lda SpriteXHi
		bcc !+
		eor #$01
!:		lsr
		tya
		ror
		tay
		
		txa
		adc #$30
		sta $d004
		lda SpriteXHi
		bcc !+
		eor #$01
!:		lsr
		tya
		ror
		tay
		
		txa
		adc #$48
		sta $d006
		lda SpriteXHi
		bcc !+
		eor #$01
!:		lsr
		tya
		ror
		tay
		
		stx $d008
		lda SpriteXHi
		lsr
		tya
		ror
		tay

		txa
		adc #$30
		sta $d00a
		lda SpriteXHi
		bcc !+
		eor #$01
!:		lsr
		tya
		ror
		tay

		//stx $d00c
		//lda SpriteXHi
		//lsr
		//tya
		//ror
		//tay

		//txa
		//adc #$30
		//sta $d00e
		//lda SpriteXHi
		//bcc !+
		//eor #$01
!:		//lsr
		tya
		//ror
		lsr
		lsr
		
		sta $d010

		lda SpriteXHi
		beq uxx

		lda $d000
		cmp #$e0
		bcc !+
		sbc #$08
		sta $d000
		sta $d008
		//sta $d00c

!:		lda $d002
		cmp #$e0
		bcc !+
		sbc #$08
		sta $d002

!:		lda $d004
		cmp #$e0
		bcc !+
		sbc #$08
		sta $d004
		sta $d00a
		//sta $d00e

!:		lda $d006
		cmp #$e0
		bcc uxx
		sbc #$08
		sta $d006

uxx:	rts

//--------------------------
PageCheck:
.if ([<PageCheck] > $bd)
{
	.align $100
}
RasterColor:
		ldx #$09
		dex
		bne *-1

		nop
		nop

		lda #$00
		ldy #$0b
		sta $d020-$0b,y

		ldx #$08	//#$07
		dex
		bne *-1
		nop $ea

		sty $d020

		ldx #$1c
		dex
		bne *-1
		nop
		nop

		sta $d020

		ldx #$11
		dex
		bne *-1
		nop
		nop
		nop

		sty $d020

		ldx #$12
		dex
		bne *-1

		sta $d020,x
		
		ldx #$12
		dex
		bne *-1
		nop
		nop
		nop

		sty $d020
		
		ldx #$08
		dex
		bne *-1
		nop

		sta $d020,x
RasterEnd:
		rts

.if([>RasterColor] != [>RasterEnd])
{
	.error "Page crossing in raster color routine!!!"
}
//--------------------------
		
NextSpriteRow:
		lax $d001
		axs #$100-$15
		.for(var i = 0; i < 12; i+=2)
		{
			stx $d001+i
		}
		rts

//------------------------------------------------------
//------------------------------------------------------

*=Init	"Init"
		
EarthInit_Go:
			jsr CreateFadeTables
		
			lax #$00
!:			sta ScrRAM+$000,x
			sta ScrRAM+$100,x
			sta ScrRAM+$200,x
			sta ScrRAM+$2e8,x
			sta ColRAM+$000,x
			sta ColRAM+$100,x
			sta ColRAM+$200,x
			sta ColRAM+$2e8,x
			inx
			bne !-
			
			nsync()

			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

			lda #$3f			//; VIC Bank: $c000-$ffff
			sta $dd02
			lda #$80			//; Bitmap: $c000-$df3f, Color RAM: $e000-$e3e7
			sta $d018
			lda #$18
			sta $d016
			lda #$3b			//; MC Bitmap mode
			sta $d011

			rts

//--------------------------

ExpandMap:	lda #$55
			sta Tmp
			ldx #$00
	Src:	lda CompMap
			tay
			and #$03
	Dst0:	sta Map+0,x
			tya
			lsr
			lsr
			tay
			and #$03
	Dst1:	sta Map+1,x
			tya
			lsr
			lsr
			tay
			and #$03
	Dst2:	sta Map+2,x
			tya
			lsr
			lsr
	Dst3:	sta Map+3,x
	ByteDone:
			inc Src+1
			bne	*+5
			inc Src+2
			txa
			axs	#$fc
			bne Src
			inc Dst0+2
			inc Dst1+2
			inc Dst2+2
			inc Dst3+2
			dec Tmp
			bne Src
			ldy #$55
	MapCopyLoop:
			ldx #$54
	S1:		lda Map,x
	D1:		sta Map+$aa,x
			dex
			bpl	S1
			inc S1+2
			inc D1+2
			dey
			bne	MapCopyLoop
			rts


//;-----------------------------

MkBlt:		lda #<Offsets
			sta MapOfst
			lda #>Offsets
			sta MapOfst+1

			lda #>Map
			sta MapRow

			lda #<Blit
			sta ZP
			lda #>Blit
			sta ZP+1

			lda #$13
			sta Overlap

			lda #$00
			sta Tmp
			ldx Tmp
	NextRow:
			lda IL,x
			sta SP
			lda IL+$55,x
			sta SP+1
			lda SpOffset,x
			sta SpOfst

			lda Partial,x
			beq Full
			cmp #$01
			bne SkipL1
			jsr Left1
			jmp Full

	SkipL1:	cmp #$02
			bne SkipL2
			jsr Left2
			jmp Full

	SkipL2:	jsr Left3

	Full:	ldx Tmp
			jsr FullByte
			ldx Tmp
			dec ByteCnt,x
			bne	Full

			ldx Tmp
			lda Partial,x
			beq RowDone
			cmp #$01
			bne SkipR1
			jsr Right1
			jmp RowDone

	SkipR1:	cmp #$02
			bne SkipR2
			jsr Right2
			jmp RowDone

	SkipR2:	jsr Right3

	RowDone:
			dec Overlap
			bpl SkipOL
			lda #$13
			sta Overlap
	SkipOL:	inc MapRow				//Next MapRow
			inc Tmp
			ldx Tmp
			cpx #$55
			bne NextRow
			rts

	AdvOfst:
			inc MapOfst
			bne *+4
			inc MapOfst+1
			rts

	AdvSp:	inc SP
			inc SpOfst		//00..02
			lda SpOfst
			cmp #$03
			bne AdvSpX
			lda #$00
			sta SpOfst
			lda SP
			clc
			adc #$80-3
			sta SP
			bcc	AdvSpX
			inc SP+1
	AdvSpX:	rts

	Left1:	ldy #$00
			lda (MapOfst),y
			sta l100+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l100+2
			lda SP
			sta l101+1
			lda SP+1
			sta l101+2
			ldy #l10x-l100
	L10:	lda l100,y
			sta (ZP),y
			dey
			bpl	L10
			lda #l10x-l100
			jsr AddZP
			jmp AddOL

	Left2:	ldy #$00
			lda (MapOfst),y
			sta l200+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l200+2
			lda (MapOfst),y
			sta l201+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l201+2
			lda SP
			sta l202+1
			lda SP+1
			sta l202+2
			ldy #l20x-l200
	L20:	lda l200,y
			sta (ZP),y
			dey
			bpl	L20
			lda #l20x-l200
			jsr AddZP
			jmp AddOL

	Left3:	ldy #$00
			lda (MapOfst),y
			sta l300+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l300+2
			lda (MapOfst),y
			sta l301+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l301+2
			lda (MapOfst),y
			sta l302+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta l302+2
			lda SP
			sta l303+1
			lda SP+1
			sta l303+2
			ldy #l30x-l300
	L30:	lda l300,y
			sta (ZP),y
			dey
			bpl L30
			lda #l30x-l300
			jsr AddZP
			jmp AddOL

	FullByte:
			ldy #$00
			lda (MapOfst),y
			sta bb00+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta bb00+2
			lda (MapOfst),y
			sta bb01+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta bb01+2
			lda (MapOfst),y
			sta bb02+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta bb02+2
			lda (MapOfst),y
			sta bb03+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta bb03+2
			lda SP
			sta bb04+1
			lda SP+1
			sta bb04+2
			ldy #bb0x-bb00
	B00:	lda bb00,y
			sta (ZP),y
			dey
			bpl B00
			lda #bb0x-bb00
			jsr AddZP
			jmp AddOL

	Right1:	ldy #$00
			lda (MapOfst),y
			sta r100+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r100+2
			lda SP
			sta r101+1
			lda SP+1
			sta r101+2
			ldy #r10x-r100
	R10:	lda r100,y
			sta (ZP),y
			dey
			bpl R10
			lda #r10x-r100
			jsr AddZP
			jmp AddOL

	Right2:	ldy #$00
			lda (MapOfst),y
			sta r201+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r201+2
			lda (MapOfst),y
			sta r200+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r200+2
			lda SP
			sta r202+1
			lda SP+1
			sta r202+2
			ldy #r20x-r200
	R20:	lda r200,y
			sta (ZP),y
			dey
			bpl R20
			lda #r20x-r200
			jsr AddZP
			jmp AddOL

	Right3:	ldy #$00
			lda (MapOfst),y
			sta r300+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r300+2
			lda (MapOfst),y
			sta r301+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r301+2
			lda (MapOfst),y
			sta r302+1
			jsr AdvOfst
			lda MapRow				//Advance to next row after Row is done
			sta r302+2
			lda SP
			sta r303+1
			lda SP+1
			sta r303+2
			ldy #r30x-r300
	R30:	lda r300,y
			sta (ZP),y
			dey
			bpl R30
			lda #r30x-r300
			jsr AddZP
	AddOL:	lda Overlap
			bne R3X
			lda SP
			sta r303+1
			lda SP+1
			clc
			adc #$02
			sta r303+2
			ldy #$02
	R31:	lda r303,y
			sta (ZP),y
			dey
			bpl R31
			lda #$03
			jsr AddZP
	R3X:	jmp AdvSp

	AddZP:	clc
			adc ZP
			sta ZP
			bcc *+4
			inc ZP+1
			rts

	//;-----------------------------

Left1Base:
	l100:	lda Map,x
	l101:	sta Sprite,y
	l10x:	rts

Left2Base:
	l200:	lda Map,x
			asl
			asl
	l201:	ora Map,x
	l202:	sta Sprite,y
	l20x:	rts

Left3Base:
	l300:	lda Map,x
			asl
			asl
	l301:	ora Map,x
			asl
			asl
	l302:	ora Map,x
	l303:	sta Sprite,y
	l30x:	rts

Roght1Base:
	r100:	lda Map,x
			lsr
			ror
			ror
	r101:	sta Sprite,y
	r10x:	rts

Right2Base:
	r200:	lda Map,x			//Right sided pixel, this is done backwards!!!
			lsr
			ror
	r201:	ora Map,x			//Left sided pixel
			ror
			ror
			ror
	r202:	sta Sprite,y
	r20x:	rts

Right3Base:
	r300:	lda Map,x
			asl
			asl
	r301:	ora Map,x
			asl
			asl
	r302:	ora Map,x
			asl
			asl
	r303:	sta Sprite,y
	r30x:	rts

BlitBase:
	bb00:	lda Map,x
			asl
			asl
	bb01:	ora Map,x
			asl
			asl
	bb02:	ora Map,x
			asl
			asl
	bb03:	ora Map,x
	bb04:	sta Sprite,y
	bb0x:	rts

//;---------------------------------------------------------------------------------------------------------------------------------

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

FadeColTab:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $01,$0d,$03,$0c,$04,$02,$09,$00
.byte $02,$09,$00,$00,$00,$00,$00,$00
.byte $03,$0c,$04,$02,$09,$00,$00,$00
.byte $04,$02,$09,$00,$00,$00,$00,$00
.byte $05,$08,$02,$09,$00,$00,$00,$00
.byte $06,$00,$00,$00,$00,$00,$00,$00
.byte $07,$0f,$05,$08,$02,$09,$00,$00
.byte $08,$02,$09,$00,$00,$00,$00,$00
.byte $09,$00,$00,$00,$00,$00,$00,$00
.byte $0a,$08,$02,$09,$00,$00,$00,$00
.byte $0b,$09,$00,$00,$00,$00,$00,$00
.byte $0c,$04,$02,$09,$00,$00,$00,$00
.byte $0d,$03,$0c,$05,$02,$09,$00,$00
.byte $0e,$04,$02,$09,$00,$00,$00,$00
.byte $0f,$05,$08,$02,$09,$00,$00,$00

//;-----------------------------

FadeInBitmap:

//;-----------------------------

irq00:		StartIRQ(1)
			
			jsr BASE_PlayMusic

			lda #$fa
			ldx #<irqfi
			ldy #>irqfi
			UpdateIRQ()
			EndIRQ(1)

//;-----------------------------

irqfi:		sta irfi_A+1
			stx irfi_X+1
			sty irfi_Y+1
			lda $01
			sta irfi_1+1
			lda #$35
			sta $01

			asl $d019

			lda #$00
			ldx #<irq00
			ldy #>irq00
			UpdateIRQ()

			cli

JSRFI:		jsr FadeIn
			
irfi_1:		lda #$35
			sta $01
irfi_Y:		ldy #$00
irfi_X:		ldx #$00
irfi_A:		lda #$00
			rti

//;-----------------------------

FadeIn:		lda #$19
			sta Tmp
			lda #<TmpScr
			sta FromScr+1
			sta ToScr+1
			sta FromCol+1
			sta ToCol+1
			lda #>TmpScr
			sta FromScr+2
			lda #>ScrRAM
			sta ToScr+2
			lda #>TmpCol
			sta FromCol+2
			lda #>ColRAM
			sta ToCol+2

InitVal:	lda #$00-$18
			cmp #$28+$19
			beq FadeInDone

			sta FadeStart
			lda #<FadeTables
			sta ZP

OuterLoop:	lda #>FadeTables
			sta ZP+1
			ldy #$07
			sty Tmp2
			
			ldx FadeStart
			bmi NextCRow
			
InnerLoop:	cpx #$28+8
			bcs NextVal
			cpx #$28
			bcs SkipCopy
FromScr:	ldy TmpScr,x
			lda (ZP),y
ToScr:		sta ScrRAM,x
FromCol:	ldy TmpCol,x
			lda (ZP),y
ToCol:		sta ColRAM,x
SkipCopy:	inc ZP+1

NextVal:	dec Tmp2
			bmi NextCRow
			dex
			bpl InnerLoop

NextCRow:	inc FadeStart
			lda FadeStart
			cmp #$28+8
			beq PhaseDone
			lda FromScr+1
			clc
			adc #$28
			sta FromScr+1
			sta ToScr+1
			sta FromCol+1
			sta ToCol+1
			bcc SkipHi
			inc FromScr+2
			inc ToScr+2
			inc FromCol+2
			inc ToCol+2

SkipHi:		dec Tmp
			bne OuterLoop

PhaseDone:	inc InitVal+1
			rts

FadeInDone:	lda #<OPC_NOPABS
			sta JSRFI
			lda #$01
			sta PART_Done
			lda #$00
			jmp BASE_RestoreIRQ

//;-----------------------------

