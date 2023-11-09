//------------------------------------
//		Plasma Vector
//------------------------------------

.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

//		Memory Layout
//		3d70 bytes free

//	  10	  60	0050	ZP vectors	
//	  c0	  ff	0040	ZPCol
//
//	From:	To:		Length:
//	0400	0800	0400	ColTabs x4
//	0800	0900	0100	Demo Framework
//	0900	2000	1700	Music
//	2000	3000	1000	Plasma Map
//	3000	4000	1000	Cube Data
//	4000	5f40	1f40	Bitmap RAM
//	6000	6400	0400	Screen RAM
//	6400	6980	0580	SPRITES
//	6980	7400	0a80	-UNUSED-
//	7400	7c00	0800	FadeTables
//	7c00	7e00	0200	ScrTab
//	7e00	8000	0200	ScrTab
//	8000	c000	4000	Generated Code
//	c000	c852	0852	Fill
//	c852	cdb0	04fe	Del
//	ce00	ce80	0080	CCMulTab
//	ce80	cec0	0040	LnTabLo
//	cec0	cf00	0040	LnTabHi
//	cf00	d000	0100	FaceVis Data
//	d000	e000	1000	-UNUSED-
//	e000	f800	1800	Main Code + Sine Tables
//	f800	fa40	0240	Line1
//	fa40	fc80	0240	Line2
//
//------------------------------------

.const Test			= cmdLineVars.get("test").asBoolean()

.const ZPCol		= $00		//Actual Tab location: $80-$bf
.const ColBase		= $80

.const ZPA			= $08
.const ZPX			= $09
.const ZPY			= $0a
.const ZP01			= $05

.const ZPFI			= $06		//-$07

.const ZP			= $10		//$10-$5f	($28 ZP addresses)

.const ZP1			= ZP
.const ZP2			= ZP1+2
.const Cnt			= ZP2+2

.const dXY			= ZP+$10
.const dX			= ZP+$11		
.const dY			= ZP+$12	
.const Color		= ZP+$13
.const Vis			= ZP+$14
.const Tmp1			= ZP+$15		//2 bytes

.const C0			= ZP+$20
.const C1			= ZP+$21
.const C2			= ZP+$22
.const C3			= ZP+$23
.const C4			= ZP+$24
.const C5			= ZP+$25
.const C6			= ZP+$26
.const C7			= ZP+$27
.const C8			= ZP+$28
.const C9			= ZP+$29
.const C10			= ZP+$2a
.const C11			= ZP+$2b

.const X0			= ZP+$2c
.const X1			= ZP+$2d

.const Y0			= ZP+$2e
.const Y1			= ZP+$2f

.const Step			= ZP+$50
.const Phase		= ZP+$51

.const ColTab0		= $0400
.const ColTab1		= $0500
.const ColTab2		= $0600
.const ColTab3		= $0700

.const PlasmaMap	= $2000
.const Cube			= $3000
.const Bitmap		= $4000
.const ScrRAM		= $6000
.const ColRAM		= $d800

.const FadeTables	= $7400
.const ScrTab		= $7c00
.const ColTab		= $7e00

.const NumBlocks	= 692
.const MaxRowLen	= 37
.const CalcZPLen	= ((MaxRowLen-1)*9)+5

.const PlasmaMask	= $8000

.const Routines		= $8000
.const CalcCol1		= Routines							//$8000-$95b9 ($15b9)	New: $5d00	([8*1000]+40+1= $1f69)
.const CalcCol2		= CalcCol1+[8*NumBlocks]+24+1		//$95b9-$a356 ($0d9d)	New: $7c69	([5*1000]+40+1=$13b1)
.const CalcCol3		= CalcCol2+[5*NumBlocks]+24+1		//$a356-$be77 ($1b21)	New: $901a	([10*1000]+40+1=$2739)
.const CalcZP		= CalcCol3+[10*NumBlocks]+24+1		//$be77-$bfc0 ($0149)	New: $b753	(4+[9*39]+1=$164)
//.const ModCalc		= CalcZP+CalcZPLen					//$964f-$96e0 ($0091)	New: $b8b7  (39*6+1=$eb) $b8b7-$b9a2	

.const Fill			= $c000								//$a000-$a852, 426*6 = 2556 cycles, 42 rasters (18 rasters saved)
.const Del			= Fill+[5*25*24]					//$a852-$ad50, 426*4 = 1704 cycles, 28 rasters (12 rasters saved) New: $ba00-

.const CCMulTab		= $ce00
.const LnMTLo		= $ce80
.const LnMTHi		= $cec0
.const LnTb1Lo		= LnMTLo
.const LnTb1Hi		= LnMTHi
.const LnTb2Lo		= LnMTLo+$19
.const LnTb2Hi		= LnMTHi+$19

.const VisTab		= $cf00

.const Line1		= $f800						//$f800-$f258
.const Line2		= $fa58						//$fa58-$fcb0

.const ModCalc		= $fd00

.const TmpLnTab		= $ff00

.const CubeColor1	= $01						//White
.const CubeColor2	= $00						//Black

.const OPC_NOPABS	= $0c
.const OPC_JSR		= $20

.const PlFOPhase	= $1c						//Plasma Fade-out Phase, adjust this to change the length of the part. Previous settings: $24/$30.

.const PlasmaFO		= $1938
.const BitmapFO		= PlasmaFO + $53

//----------------------

.macro NegA() {
		eor #$ff
		//clc		//in both use cases C=0
		adc #$01
		}

//----------------------

*=$e000 "Main"

PlasmaVector_Go:

Start:
.if (Test==true)	{
		sei
		lda #$35
		sta $01
		}
		//jsr MkPattern			// ONLY USE IT IF THE BITMAP CHANGES, TO CREATE A NEW COMBINED MAP... NEEDS PLASMAMASK.BIN TOO!!!

		jsr MkCalcCol
		jsr MkCalcZP
		jsr MkModCalc
		jsr MkLines

		lda #<OPC_NOPABS
		cmp FI
		bne *-3

		nsync()

		jsr ClearClash1
		
		ldx #$07
		lda #$a2
		sec
!:		sta ScrRAM+$03f8,x
		sbc #$01
		dex
		bpl !-

		lda #$00
		sta $d012
		lda #<IRQ0
		sta $fffe
		lda #>IRQ0
		sta $ffff

		//lda #$3d				//VIC Bank at $4000-$8000
		//sta $dd02
		//lda #$80				//Bitmap at $4000, Screen RAM at $6000
		//sta $d018
		//lda #$3b
		//sta $d011
		//lda #$18
		//sta $d016

		lda #$cc
		sta Phase
		lda #$00
		sta Step

//----------------------

PlasmaLoop:
		//dec $d020
		jsr DrawCube
		//inc $d020

cx0x:	ldx #$00
		jsr ModCalc
		inx
		txa
		and #$7f
		sta cx0x+1

cx00:	ldx Cos
		jsr CalcX
		ldx cx00+1
		inx
		cpx #$e0
		bne cx01
		ldx #$00
cx01:	stx cx00+1

cy00:	lda Sin+$08
		lsr
		alr #$fe			//C=0
		adc #$06
		tay
		dec cy00+1

CCol1:	jsr CalcCol1		//ColRAM
		jsr ColCycle

		//dec $d020

//----------------------

cx1x:	ldx #$05
		jsr ModCalc
		dex
		txa
		and #$7f
		sta cx1x+1

cx10:	ldx Cos+$1c
		jsr CalcX
		ldx cx10+1
		dex
		cpx #$ff
		bne cx11
		ldx #$df
cx11:	stx cx10+1

cy10:	lda Sin+$4c
		lsr
		lsr
		alr #$fe			//C=0
		adc #$0c
		tay
		inc cy10+1

CCol2:	jsr CalcCol2
		//jsr ColCycle

		//dec $d020

//----------------------

cx2x:	ldx #$1d
		jsr ModCalc
		inx
		inx
		txa
		and #$7f
		sta cx2x+1

cx20:	ldx Cos+$38
		jsr CalcX
		ldx cx20+1
		dex
		dex
		cpx #$fe
		bne cx21
		ldx #$de
cx21:	stx cx20+1

cy20:	lda Sin+$28
		lsr
		lsr
		alr #$fe			//C=0
		adc #$0c
		tay
		inc cy20+1
		inc cy20+1

CCol3:	jsr CalcCol3
		jsr ColCycle

//----------------------

		//lda Step
		//cmp #$02
		//bcc LoopJmp
		//lda Phase
		//cmp #<PlFOPhase+$24
		//beq PlasmaVector_End

		lda MUSIC_FrameLo
		cmp #<BitmapFO
		lda MUSIC_FrameHi
		sbc #>BitmapFO				//; C=0 - we haven't reached the sync frame yet, C=1 we have reached the sync frame
		bcs PlasmaVector_End

LoopJmp:
		jmp PlasmaLoop

PlasmaVector_End:
		nsync()

		jsr ClearClash2
		
		ldx #$07
		lda #$97
		sec
!:		sta ScrRAM+$03f8,x
		sbc #$01
		dex
		bpl !-

		lda #$00
		sta $d012
		lda #<IRQFI0
		sta $fffe
		lda #>IRQFI0
		sta $ffff

		lda #<OPC_JSR
		sta FO

		rts

//----------------------------

IRQ0:	dec $00
		//dec $d020
		sta ZPA
		stx ZPX
		sty ZPY
		asl $d019

		lda #$d8						//$d8,$aa,$c8,$b2,$e0,$d2
		sta $d008
		lda #$aa
		sta $d009
		lda #$c8
		sta $d00a
		lda #$b2
		sta $d00b
		lda #$e0
		sta $d00c
		lda #$d2
		sta $d00d

		lda #$00
		sta $d010

		ldx #$9f
		stx ScrRAM+$03fc
		inx
		stx ScrRAM+$03fd
		inx
		stx ScrRAM+$03fe

		lda #$05
		sta $d025
		lda #$0c
		sta $d026

		jsr BASE_PlayMusic

		lda #$5a-3
		sta $d012
		lda #<IRQ1
		sta $fffe
		lda #>IRQ1
		sta $ffff

		lda ZPA
		ldx ZPX
		ldy ZPY
		//inc $d020
		inc $00
		rti

//----------------------------

IRQ1:	dec $00
		//dec $d020
		sta ZPA
		asl $d019

		lda #$0b
		sta $d025

		lda #$aa-3
		sta $d012
		lda #<IRQ2
		sta $fffe
		lda #>IRQ2
		sta $ffff

		lda ZPA
		inc $00
		//inc $d020
		rti

//----------------------------

IRQ2:	dec $00
		//dec $d020
		sta ZPA
		asl $d019

		lda #$04
		sta $d025
		lda #$0a
		sta $d026

		lda #$d2-3
		sta $d012
		lda #<IRQ3
		sta $fffe
		lda #>IRQ3
		sta $ffff

		lda ZPA
		//inc $d020
		inc $00
		rti
		
//----------------------------

IRQ3:	dec $00
		//dec $d020
		sta ZPA
		asl $d019

		lda #$0b
		sta $d025
		lda #$0f
		sta $d026

		lda #$ea-3
		sta $d012
		lda #<IRQ4
		sta $fffe
		lda #>IRQ4
		sta $ffff

		lda ZPA
		//inc $d020
		inc $00
		rti
		
//----------------------------

IRQ4:	dec $00
		//dec $d020
		sta ZPA
		stx ZPX
		asl $d019

		lda #$ea
		sta $d009
		sta $d00b
		sta $d00d

		lda #$00
		sta $d008
		lda #$18
		sta $d00a
		lda #$30
		sta $d00c

		lda #$70
		sta $d010

		ldx #$a3
		stx ScrRAM+$03fc
		inx
		stx ScrRAM+$03fd
		inx
		stx ScrRAM+$03fe

		lda #$09
		sta $d025
		lda #$08
		sta $d026

		lda #$00
		sta $d012
		lda #<IRQ0
		sta $fffe
		lda #>IRQ0
		sta $ffff

		lda ZPA
		ldx ZPX
		//inc $d020
		inc $00
		rti

//----------------------------

ClearClash1:

		lda #$00
		sta ScrRAM+(2*40)+30
		sta ScrRAM+(5*40)+29
		sta ScrRAM+(6*40)+28
		sta ScrRAM+(7*40)+26
		sta ScrRAM+(10*40)+25
		sta ScrRAM+(15*40)+24
		sta ScrRAM+(15*40)+25
		sta ScrRAM+(16*40)+23
		sta ScrRAM+(17*40)+22
		sta ScrRAM+(20*40)+25
		sta ScrRAM+(21*40)+25
		sta ScrRAM+(23*40)+26
		sta ScrRAM+(23*40)+27
		sta ScrRAM+(23*40)+28
		sta ScrRAM+(23*40)+29
		sta ScrRAM+(23*40)+30
		sta ScrRAM+(23*40)+31
		sta ScrRAM+(23*40)+32
		sta ScrRAM+(23*40)+33
		sta ScrRAM+(23*40)+34
		sta ScrRAM+(23*40)+35
		sta ScrRAM+(24*40)+36

		sta ColRAM+(2*40)+30
		sta ColRAM+(5*40)+29
		sta ColRAM+(6*40)+28
		sta ColRAM+(7*40)+26
		sta ColRAM+(10*40)+25
		sta ColRAM+(15*40)+24
		sta ColRAM+(15*40)+25
		sta ColRAM+(16*40)+23
		sta ColRAM+(17*40)+22
		sta ColRAM+(20*40)+25
		sta ColRAM+(21*40)+25
		sta ColRAM+(23*40)+26
		sta ColRAM+(23*40)+27
		sta ColRAM+(23*40)+28
		sta ColRAM+(23*40)+29
		sta ColRAM+(23*40)+30
		sta ColRAM+(23*40)+31
		sta ColRAM+(23*40)+32
		sta ColRAM+(23*40)+33
		sta ColRAM+(23*40)+34
		sta ColRAM+(23*40)+35
		sta ColRAM+(24*40)+36
		rts

//----------------------------

ClearClash2:

		lda ScrTab+(2*18)+8
		sta ScrRAM+(2*40)+30
		lda ScrTab+(5*18)+7
		sta ScrRAM+(5*40)+29
		lda ScrTab+(6*18)+6
		sta ScrRAM+(6*40)+28
		lda ScrTab+(7*18)+4
		sta ScrRAM+(7*40)+26
		lda ScrTab+(10*18)+3
		sta ScrRAM+(10*40)+25
		lda ScrTab+(15*18)+2
		sta ScrRAM+(15*40)+24
		lda ScrTab+(15*18)+3
		sta ScrRAM+(15*40)+25
		lda ScrTab+(16*18)+1
		sta ScrRAM+(16*40)+23
		lda ScrTab+(17*18)+0
		sta ScrRAM+(17*40)+22
		lda ScrTab+(20*18)+3
		sta ScrRAM+(20*40)+25
		lda ScrTab+(21*18)+3
		sta ScrRAM+(21*40)+25
		lda ScrTab+(23*18)+4
		sta ScrRAM+(23*40)+26
		lda ScrTab+(23*18)+5
		sta ScrRAM+(23*40)+27
		lda ScrTab+(23*18)+6
		sta ScrRAM+(23*40)+28
		lda ScrTab+(23*18)+7
		sta ScrRAM+(23*40)+29
		lda ScrTab+(23*18)+8
		sta ScrRAM+(23*40)+30
		lda ScrTab+(23*18)+9
		sta ScrRAM+(23*40)+31
		lda ScrTab+(23*18)+10
		sta ScrRAM+(23*40)+32
		lda ScrTab+(23*18)+11
		sta ScrRAM+(23*40)+33
		lda ScrTab+(23*18)+12
		sta ScrRAM+(23*40)+34
		lda ScrTab+(23*18)+13
		sta ScrRAM+(23*40)+35
		lda ScrTab+(24*18)+14
		sta ScrRAM+(24*40)+36

		lda ColTab+(2*18)+8
		sta ColRAM+(2*40)+30
		lda ColTab+(5*18)+7
		sta ColRAM+(5*40)+29
		lda ColTab+(6*18)+6
		sta ColRAM+(6*40)+28
		lda ColTab+(7*18)+4
		sta ColRAM+(7*40)+26
		lda ColTab+(10*18)+3
		sta ColRAM+(10*40)+25
		lda ColTab+(15*18)+2
		sta ColRAM+(15*40)+24
		lda ColTab+(15*18)+3
		sta ColRAM+(15*40)+25
		lda ColTab+(16*18)+1
		sta ColRAM+(16*40)+23
		lda ColTab+(17*18)+0
		sta ColRAM+(17*40)+22
		lda ColTab+(20*18)+3
		sta ColRAM+(20*40)+25
		lda ColTab+(21*18)+3
		sta ColRAM+(21*40)+25
		lda ColTab+(23*18)+4
		sta ColRAM+(23*40)+26
		lda ColTab+(23*18)+5
		sta ColRAM+(23*40)+27
		lda ColTab+(23*18)+6
		sta ColRAM+(23*40)+28
		lda ColTab+(23*18)+7
		sta ColRAM+(23*40)+29
		lda ColTab+(23*18)+8
		sta ColRAM+(23*40)+30
		lda ColTab+(23*18)+9
		sta ColRAM+(23*40)+31
		lda ColTab+(23*18)+10
		sta ColRAM+(23*40)+32
		lda ColTab+(23*18)+11
		sta ColRAM+(23*40)+33
		lda ColTab+(23*18)+12
		sta ColRAM+(23*40)+34
		lda ColTab+(23*18)+13
		sta ColRAM+(23*40)+35
		lda ColTab+(24*18)+14
		sta ColRAM+(24*40)+36
		rts

//----------------------------

ColCycle:
		ldx #<ColBase

		//dec $d020
		
		jsr CCZP
		
		ldy ColTab0+ColBase+$3f		//(4+5)*16=144 cycles per ColTab
cc00:	tya
		jsr CC0

		lda Step
		cmp #$01
		bne cc01
		ldy #<CubeColor1

cc01:	tya
		jsr CC1

		lda Step
		cmp #$01
		bne cc02
		ldy #<CubeColor2

cc02:	tya
		jsr CC2

		lda Step
		cmp #$01
		bne cc03
		ldy Col2		//ColTab0+ColBase+$20

cc03:	tya
		jsr CC4
		

		lda Col2+$3f
		jsr CC3
		
		inx
		cpx #ColBase+$4
		bne !+

FICol:	ldy #$0f
		bmi SkipFICol
		lda Col,y
		sta ColTab0+ColBase+$3f
		sta ColTab1+ColBase+$3f
		sta ColTab2+ColBase+$3f
		sta ColTab3+ColBase+$3f
		asl
		asl
		asl
		asl
		sta ZPCol+ColBase+$3f
		dec FICol+1
		jmp SkipFOCol

SkipFICol:
		//lda Step
		//cmp #$02
		//bne SkipFOCol
		//lda Phase
		//cmp #<PlFOPhase
		//bcc SkipFOCol
		
		lda MUSIC_FrameLo
		cmp #<PlasmaFO
		lda MUSIC_FrameHi
		sbc #>PlasmaFO				//; C=0 - we haven't reached the sync frame yet, C=1 we have reached the sync frame
		bcc SkipFOCol

FOCol:	ldy #$0f
		bmi SkipFOCol
		lda #$00
		sta ColTab0+ColBase+$3f
		sta ColTab1+ColBase+$3f
		sta ColTab2+ColBase+$3f
		sta ColTab3+ColBase+$3f
		sta ZPCol+ColBase+$3f
		dec FOCol+1
SkipFOCol:
		ldx #ColBase
!:		stx ColCycle+1

		//inc $d020
		
		rts
//----------------------------

CC0:	sta ColTab0+$00,x
		lda ColTab0+$3b,x
		sta ColTab0+$3c,x
		lda ColTab0+$37,x
		sta ColTab0+$38,x
		lda ColTab0+$33,x
		sta ColTab0+$34,x
		lda ColTab0+$2f,x
		sta ColTab0+$30,x
		lda ColTab0+$2b,x
		sta ColTab0+$2c,x
		lda ColTab0+$27,x
		sta ColTab0+$28,x
		lda ColTab0+$23,x
		sta ColTab0+$24,x
		lda ColTab0+$1f,x
		sta ColTab0+$20,x
		lda ColTab0+$1b,x
		sta ColTab0+$1c,x
		lda ColTab0+$17,x
		sta ColTab0+$18,x
		lda ColTab0+$13,x
		sta ColTab0+$14,x
		lda ColTab0+$0f,x
		sta ColTab0+$10,x
		lda ColTab0+$0b,x
		sta ColTab0+$0c,x
		lda ColTab0+$07,x
		sta ColTab0+$08,x
		lda ColTab0+$03,x
		sta ColTab0+$04,x
		rts

CC1:	sta ColTab1+$00,x
		lda ColTab1+$3b,x
		sta ColTab1+$3c,x
		lda ColTab1+$37,x
		sta ColTab1+$38,x
		lda ColTab1+$33,x
		sta ColTab1+$34,x
		lda ColTab1+$2f,x
		sta ColTab1+$30,x
		lda ColTab1+$2b,x
		sta ColTab1+$2c,x
		lda ColTab1+$27,x
		sta ColTab1+$28,x
		lda ColTab1+$23,x
		sta ColTab1+$24,x
		lda ColTab1+$1f,x
		sta ColTab1+$20,x
		lda ColTab1+$1b,x
		sta ColTab1+$1c,x
		lda ColTab1+$17,x
		sta ColTab1+$18,x
		lda ColTab1+$13,x
		sta ColTab1+$14,x
		lda ColTab1+$0f,x
		sta ColTab1+$10,x
		lda ColTab1+$0b,x
		sta ColTab1+$0c,x
		lda ColTab1+$07,x
		sta ColTab1+$08,x
		lda ColTab1+$03,x
		sta ColTab1+$04,x
		rts

CC2:	sta ColTab2+$00,x
		lda ColTab2+$3b,x
		sta ColTab2+$3c,x
		lda ColTab2+$37,x
		sta ColTab2+$38,x
		lda ColTab2+$33,x
		sta ColTab2+$34,x
		lda ColTab2+$2f,x
		sta ColTab2+$30,x
		lda ColTab2+$2b,x
		sta ColTab2+$2c,x
		lda ColTab2+$27,x
		sta ColTab2+$28,x
		lda ColTab2+$23,x
		sta ColTab2+$24,x
		lda ColTab2+$1f,x
		sta ColTab2+$20,x
		lda ColTab2+$1b,x
		sta ColTab2+$1c,x
		lda ColTab2+$17,x
		sta ColTab2+$18,x
		lda ColTab2+$13,x
		sta ColTab2+$14,x
		lda ColTab2+$0f,x
		sta ColTab2+$10,x
		lda ColTab2+$0b,x
		sta ColTab2+$0c,x
		lda ColTab2+$07,x
		sta ColTab2+$08,x
		lda ColTab2+$03,x
		sta ColTab2+$04,x
		rts

CC3:	sta Col2-ColBase+$00,x
		lda Col2-ColBase+$3b,x
		sta Col2-ColBase+$3c,x
		lda Col2-ColBase+$37,x
		sta Col2-ColBase+$38,x
		lda Col2-ColBase+$33,x
		sta Col2-ColBase+$34,x
		lda Col2-ColBase+$2f,x
		sta Col2-ColBase+$30,x
		lda Col2-ColBase+$2b,x
		sta Col2-ColBase+$2c,x
		lda Col2-ColBase+$27,x
		sta Col2-ColBase+$28,x
		lda Col2-ColBase+$23,x
		sta Col2-ColBase+$24,x
		lda Col2-ColBase+$1f,x
		sta Col2-ColBase+$20,x
		lda Col2-ColBase+$1b,x
		sta Col2-ColBase+$1c,x
		lda Col2-ColBase+$17,x
		sta Col2-ColBase+$18,x
		lda Col2-ColBase+$13,x
		sta Col2-ColBase+$14,x
		lda Col2-ColBase+$0f,x
		sta Col2-ColBase+$10,x
		lda Col2-ColBase+$0b,x
		sta Col2-ColBase+$0c,x
		lda Col2-ColBase+$07,x
		sta Col2-ColBase+$08,x
		lda Col2-ColBase+$03,x
		sta Col2-ColBase+$04,x
		rts

CC4:	sta ColTab3+$00,x
		lda ColTab3+$3b,x
		sta ColTab3+$3c,x
		lda ColTab3+$37,x
		sta ColTab3+$38,x
		lda ColTab3+$33,x
		sta ColTab3+$34,x
		lda ColTab3+$2f,x
		sta ColTab3+$30,x
		lda ColTab3+$2b,x
		sta ColTab3+$2c,x
		lda ColTab3+$27,x
		sta ColTab3+$28,x
		lda ColTab3+$23,x
		sta ColTab3+$24,x
		lda ColTab3+$1f,x
		sta ColTab3+$20,x
		lda ColTab3+$1b,x
		sta ColTab3+$1c,x
		lda ColTab3+$17,x
		sta ColTab3+$18,x
		lda ColTab3+$13,x
		sta ColTab3+$14,x
		lda ColTab3+$0f,x
		sta ColTab3+$10,x
		lda ColTab3+$0b,x
		sta ColTab3+$0c,x
		lda ColTab3+$07,x
		sta ColTab3+$08,x
		lda ColTab3+$03,x
		sta ColTab3+$04,x
		rts

CCZP:	ldy ZPCol+<ColBase+$03
		lda ZPCol+<ColBase+$3f		//(4+4)*16=128-1=127 cycles on ZP
		sta ZPCol+$00,x
		lda ZPCol+<ColBase+$3b
		sta ZPCol+$3c,x
		lda ZPCol+<ColBase+$37
		sta ZPCol+$38,x
		lda ZPCol+<ColBase+$33
		sta ZPCol+$34,x
		lda ZPCol+<ColBase+$2f
		sta ZPCol+$30,x
		lda ZPCol+<ColBase+$2b
		sta ZPCol+$2c,x
		lda ZPCol+<ColBase+$27
		sta ZPCol+$28,x
		lda ZPCol+<ColBase+$23
		sta ZPCol+$24,x
		lda ZPCol+<ColBase+$1f
		sta ZPCol+$20,x
		lda ZPCol+<ColBase+$1b
		sta ZPCol+$1c,x
		lda ZPCol+<ColBase+$17
		sta ZPCol+$18,x
		lda ZPCol+<ColBase+$13
		sta ZPCol+$14,x
		lda ZPCol+<ColBase+$0f
		sta ZPCol+$10,x
		lda ZPCol+<ColBase+$0b
		sta ZPCol+$0c,x
		lda ZPCol+<ColBase+$07
		sta ZPCol+$08,x
		sty ZPCol+$04,x
		rts

//----------------------------

CalcX:	txa
		lsr
		alr #$fe			//C=0
		//lsr
		//clc
		adc #>PlasmaMap		//C=0 after this
		tay					//Y=HiByte
		txa
		and #$03
		tax
		lda ZPLo,x			//A=LoByte
		tax
		lda #$ff
		jmp CalcZP

//----------------------------------

MkPattern:

		lda #$1f
		sta Cnt
		ldx #$00
		ldy #$00
!:		lda Pattern,x
Msk:	and PlasmaMask,y
Bmp:	ora Bitmap,y
Dst:	sta Bitmap,y
		inx
		cpx #$10
		bne *+4
		ldx #$00
		iny
		bne !-
		inc Msk+2
		inc Bmp+2
		inc Dst+2
		dec Cnt
		bpl !-
/*
		ldx #$0f
!:		lda Pattern,x
		sta Bitmap,x
		dex
		bpl !-

		ldx #$10
!:		lda Bitmap-$10,x
		sta Bitmap,x
		inx
		cpx #$c8
		bne !-

		ldy #$00
!:		ldx #$00
Src:	lda Bitmap,x
Dst:	sta Bitmap+$140,x
		inx
		cpx #$c8
		bne Src
		lda Dst+1
		sta Src+1
		clc
		adc #$40
		sta Dst+1
		lda Dst+2
		sta Src+2
		adc #$01
		sta Dst+2
		iny
		cpx #$19
		bne !-
		rts
*/

//----------------------------

MkColTabs:
		rts
		ldy #$0f
mzc0:	ldx #$03
mzc1:	lda Col,y
mzc2:	sta ColTab2+<ColBase
mzc3:	sta ColTab0+<ColBase
		sta ColTab1+<ColBase
		sta ColTab3+<ColBase
		asl
		asl
		asl
		asl
mzc4:	sta ZPCol+<ColBase
		inc mzc2+1
		inc mzc3+1
		inc mzc3+4
		inc mzc3+7
		inc mzc4+1
		dex
		bpl mzc1
		dey
		bpl mzc0
		rts

//----------------------------

AddZP1:	clc
		adc ZP1
		sta ZP1
		bcc az1end
		inc ZP1+1
		clc
az1end:	rts

//----------------------------

MkCalcCol:
		lda #<CalcCol1
		sta ZP1
		lda #>CalcCol1
		sta ZP1+1
		ldx #$00
		stx Cnt
mcr0:	lda RowLenTab,x
		tax
mcr1:	ldy #<cb03-cb00
mcr2:	lda cb00,y
		sta (ZP1),y
		dey
		bpl mcr2
		lda #<cb03-cb00
		jsr AddZP1
		lda cb00+1
		adc #$02
		sta cb00+1
		lda cb02+1
		clc
mcr3:	adc #$01
		sta cb02+1
		bcc mcr4
		inc cb02+2
mcr4:	dex
		bne mcr1
		lda #ZP
		sta cb00+1
		lda #$01
		jsr AddZP1
		ldx Cnt
		lda #$28
		sec
		sbc RowLenTab,x
		clc
		adc cb02+1
		sta cb02+1
		bcc *+5
		inc cb02+2
		inc Cnt
		ldx Cnt
		cpx #$19
		bne mcr0
		dec ZP1
		lda #$60
		ldy #$00
		sta (ZP1),y
		inc ZP1

		lda #<CalcCol2
		sta ZP1
		lda #>CalcCol2
		sta ZP1+1
		ldx #$00				//#$18
		stx Cnt
mcr7:	lda RowLenTab,x			//ldx Cnt
		tax
mcr8:	ldy #<cb12-cb10
mcr9:	lda cb10,y
		sta (ZP1),y
		dey
		bpl mcr9
		lda #<cb12-cb10
		jsr AddZP1
		lda cb10+1
		adc #$02
		sta cb10+1
		lda cb11+1
		adc #<cb24-cb20
		sta cb11+1
		bcc *+5
		inc cb11+2
		dex
		bne mcr8				//bpl
		lda #ZP
		sta cb10+1
		lda #$01
		jsr AddZP1
		lda cb11+1
		adc #$01
		sta cb11+1
		bcc *+5
		inc cb11+2
		inc Cnt					//dec Cnt
		ldx Cnt
		cpx #$19
		bne mcr7				//bpl mcr 7
		dec ZP1
		lda #$60
		ldy #$00
		sta (ZP1),y
		inc ZP1

		lda #<CalcCol3
		sta ZP1
		lda #>CalcCol3
		sta ZP1+1
		ldx #$00
		stx Cnt
mcr10:	//ldx #$18
		lda RowLenTab,x
		tax
mcr11:	ldy #<cb24-cb20
mcr12:	lda cb20,y
		sta (ZP1),y
		dey
		bpl mcr12
		lda #<cb24-cb20
		jsr AddZP1
		lda cb20+1
		adc #$02
		sta cb20+1
		inc cb23+1
		bne mcr13
		inc cb23+2
mcr13:	dex
		bne mcr11
		lda #ZP
		sta cb20+1
		lda #$01
		jsr AddZP1
		ldx Cnt
		lda #$28
		sec
		sbc RowLenTab,x
		clc
		adc cb23+1
		//clc
		//adc #$0f
		sta cb23+1
		bcc *+5
		inc cb23+2
		inc Cnt
		ldx Cnt
		cpx #$19
		bne mcr10
		//dec Cnt
		//bpl mcr10
		dec ZP1
		lda #$60
		ldy #$00
		sta (ZP1),y
		rts

//----------------------------

CircBase0:
cb00:	lax (ZP),y		//2		5 
cb01:	lda ColTab0,x	//3		4
cb02:	sta ColRAM		//3		4
cb03:	iny				//8B	13c	((13*25)+1)*25=8150 cycles = 136 rasters

CircBase1:
cb10:	lda (ZP),y		//2		5
cb11:	sta CalcCol3+6	//3		4
cb12:	iny				//5B	9c	((9*25)+1)*25=5650 cycles = 94 rasters

CircBase2:
cb20:	lax (ZP),y		//2		5
cb21:	lda ColTab0,x	//3		4
cb22:	ora ZPCol		//2		3
cb23:	sta ScrRAM		//3		4
cb24:	iny				//10B	16c	((16*25)+1)*25=10025 cycles = 167 rasters

//----------------------------

MkCalcZP:
		lda #<CalcZP
		sta ZP1
		lda #>CalcZP
		sta ZP1+1
		
		ldx #<MaxRowLen - 1			//$17					//24 iterations +  1 more without X/Y calc.
mcz0:	ldy #<czb3-czb0
mcz1:	lda czb0,y
		sta (ZP1),y
		dey
		bpl mcz1
		lda #<czb3-czb0
		jsr AddZP1
		inc czb0+1
		inc czb0+1
		inc czb1+1
		inc czb1+1
		dex
		bne mcz0
		ldy #<czb2-czb0
		lda #$60
		sta (ZP1),y
		dey
mcz2:	lda czb0,y
		sta (ZP1),y
		dey
		bpl mcz2
		rts

//----------------------------

CZPBase:
czb0:	stx ZP
czb1:	sty ZP+1
czb2:	axs #<ColBase
		bcc czb3
		iny
czb3:	rts


MkModCalc:
		ldx #$ff
mmc0:	lda Sin2,x
		sec
		sbc Sin2-1,x
		clc
		adc #$c0
		sta Sin2,x
		dex
		bne mmc0
		lda #$c0
		sta Sin2
		
		lda #<ModCalc
		sta ZP1
		lda #>ModCalc
		sta ZP1+1
		ldx #<MaxRowLen-1				//#$18
mmc1:	ldy #<mcb2-mcb0
mmc2:	lda mcb0,y
		sta (ZP1),y
		dey
		bpl mmc2
		lda #<mcb2-mcb0
		jsr AddZP1
		lda mcb1+1
		clc
		adc #<czb3-czb0
		sta mcb1+1
		bcc mmc3
		inc mcb1+2
mmc3:	inc mcb0+1
		dex
		bne mmc1
		rts

mcbase:	
mcb0:	lda Sin2,x
mcb1:	sta CalcZP+5
mcb2:	rts

//----------------------------
		
MkLines:
MkCCMT:	ldx #$18
		lda #$78
		sec
		sta CCMulTab,x
		sbc #$05
		dex
		bpl *-6

MkLnMT:	lda #<Line1
		sta ZP1
		lda #>Line1
		sta ZP1+1
		ldx #$00
mlmt:	lda ZP1
		sta LnMTLo,x
		lda ZP1+1
		sta LnMTHi,x
		lda #<lb04-lb00
		jsr AddZP1
		inx
		cpx #$32
		bne mlmt

		jsr MkFill

		lda #<Line1
		sta ZP1
		lda #>Line1
		sta ZP1+1
		jsr MkLine2

		lda #<Fill+1
		sta lb02+1
		sta lb03+1
		lda #>Fill+1
		sta lb02+2
		sta lb03+2
		lda #$88
		sta lb01

MkLine2:
		ldx #$18
ml10:	ldy Xmin,x				//18,08,06,04,04,03,02,02
		lda TmpLnTab+$00,x				//00,00,
		sec
		sbc CCMulTab,y			//78,
		sta lb02+1
		sta lb03+1
		lda TmpLnTab+$20,x
		sbc #$00
		sta lb02+2
		sta lb03+2
		ldy #<lb04-lb00
ml11:	lda lb00,y
		sta (ZP1),y
		dey
		bpl ml11
		lda #<lb04-lb00
		jsr AddZP1
		dex
		bpl ml10
		rts
		
//----------------------------

LineBase:
lb00:	lda dXY
		adc dY
		bcc *+7
lb01:	iny						//INY=$c8, DEY=$88		
		sbc dX
		bcs *-3
		sta dXY
		ldx CCMulTab,y
lb02:	lda Fill+1,x
		eor Color
lb03:	sta Fill+1,x
lb04:	rts

//----------------------------

DrawCube:
LineSel:
		ldx Phase
		lda VisTab,x
		sta Vis

		ldx #$00				//Reset line colors
		stx C0
		stx C1
		stx C2
		stx C3
		stx C4
		stx C5
		stx C6
		stx C7
		stx C8
		stx C9
		stx C10
		stx C11

		lda #$03				//#$c0		//Faces 0 and 5
		lsr Vis					//C=1 - face visible, C=0 - face hidden
		bcc LS1
		sta C0					//F0: L0,L1,L2,L3
		sta C1
		sta C2
		sta C3
LS1:	lsr Vis					//F5: L8,L9,L10,L11
		bcc LS2
		sta C8
		sta C9
		sta C10
		sta C11

LS2:	lda #$02				//#$80		//Faces 1 and 3
		tax
		lsr Vis
		bcc LS3
		sta C4					//F1: L0,L4,L5,L10
		sta C5
		eor C0
		sta C0
		txa
		eor C10
		sta C10
LS3:	lsr Vis
		bcc LS4
		stx C6					//F3: L2,L6,L7,L8 
		stx C7
		txa
		eor C2
		sta C2
		txa
		eor C8
		sta C8

LS4:	lda #$01				//#$40		//Faces 2 and 4
		tax
		lsr Vis
		bcc LS5
		eor C1					//F2: L1,L5,L6,L11
		sta C1
		txa
		eor C5
		sta C5
		txa
		eor C6
		sta C6
		txa
		eor C11
		sta C11
LS5:	lsr Vis
		bcc LS6
		txa						//F4: L3,L4,L7,L9
		eor C3
		sta C3
		txa
		eor C4
		sta C4
		txa
		eor C7
		sta C7
		txa
		eor C9
		sta C9
LS6://	rts

//----------------------
//	Line1	  Y		   Line2	 Y
//	 -------------->	 -------------->
//	 |\X0Y0				|    /X0Y0
//	 | \				|   /
//	X|  \			   X|  /
//	 |   \				| /
//	 |    \X1Y1			|/X1Y1
//	 V					V


Draw:	ldx Phase
		ldy C0					//P0,P1
		beq dc1
		lda Cube,x				//X0
		cmp Cube+$100,x
		beq dc1					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$100,x			//X1
		sta X1
		lda Cube+$800,x			//Y0
		ldy Cube+$900,x			//Y1
		jsr DrawLine
		ldx Phase
dc1:	ldy C1					//P1,P2
		beq dc2
		lda Cube+$100,x			//X1
		cmp Cube+$200,x
		beq dc2					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$200,x			//X2
		sta X1
		lda Cube+$900,x			//Y1
		ldy Cube+$a00,x			//Y2
		jsr DrawLine
		ldx Phase
dc2:	ldy C2					//P2,P3
		beq dc3
		lda Cube+$200,x			//X2
		cmp Cube+$300,x
		beq dc3					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$300,x			//X3
		sta X1
		lda Cube+$a00,x			//Y2
		ldy Cube+$b00,x			//Y3
		jsr DrawLine
		ldx Phase
dc3:	ldy C3					//P0,P3
		beq dc4
		lda Cube,x				//X0
		cmp Cube+$300,x
		beq dc4					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$300,x			//X3
		sta X1
		lda Cube+$800,x			//Y0
		ldy Cube+$b00,x			//Y3
		jsr DrawLine
		ldx Phase
dc4:	ldy C4					//P0,P6
		beq dc5
		lda Cube,x				//X0
		cmp Cube+$600,x
		beq dc5					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$600,x			//X6
		sta X1
		lda Cube+$800,x			//Y0
		ldy Cube+$e00,x			//Y6
		jsr DrawLine
		ldx Phase
dc5:	ldy C5					//P1,P7
		beq dc6
		lda Cube+$100,x			//X1
		cmp Cube+$700,x
		beq dc6					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$700,x			//X7
		sta X1
		lda Cube+$900,x			//Y1
		ldy Cube+$f00,x			//Y7
		jsr DrawLine
		ldx Phase
dc6:	ldy C6					//P2,P4
		beq dc7
		lda Cube+$200,x			//X2
		cmp Cube+$400,x
		beq dc7					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$400,x			//X4
		sta X1
		lda Cube+$a00,x			//Y2
		ldy Cube+$c00,x			//Y4
		jsr DrawLine
		ldx Phase
dc7:	ldy C7					//P3,P5
		beq dc8
		lda Cube+$300,x			//X3
		cmp Cube+$500,x
		beq dc8					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$500,x			//X5
		sta X1
		lda Cube+$b00,x			//Y3
		ldy Cube+$d00,x			//Y5
		jsr DrawLine
		ldx Phase
dc8:	ldy C8					//P4,P5
		beq dc9
		lda Cube+$400,x			//X4
		cmp Cube+$500,x
		beq dc9					//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$500,x			//X5
		sta X1
		lda Cube+$c00,x			//Y4
		ldy Cube+$d00,x			//Y5
		jsr DrawLine
		ldx Phase
dc9:	ldy C9					//P5,P6
		beq dc10
		lda Cube+$500,x			//X5
		cmp Cube+$600,x
		beq dc10				//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$600,x			//X6
		sta X1
		lda Cube+$d00,x			//Y5
		ldy Cube+$e00,x			//Y6
		jsr DrawLine
		ldx Phase
dc10:	ldy C10					//P6,P7
		beq dc11
		lda Cube+$600,x			//X6
		cmp Cube+$700,x
		beq dc11				//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$700,x			//X7
		sta X1
		lda Cube+$e00,x			//Y6
		ldy Cube+$f00,x			//Y7
		jsr DrawLine
		ldx Phase
dc11:	ldy C11					//P4,P7
		beq dc12
		lda Cube+$400,x			//X4
		cmp Cube+$700,x
		beq dc12				//X0=X1 = horizontal line, will not be drawn
		sty Color
		sta X0
		lda Cube+$700,x			//X7
		sta X1
		lda Cube+$c00,x			//Y4
		ldy Cube+$f00,x			//Y7
		jsr DrawLine
dc12:	//lda Step
		//cmp #$03
		//bcs dc13
		inc Phase
		bne dc13
		inc Step

dc13:	ldx #$00
		jmp Fill

//----------------------
//	Line1	  Y		   Line2	 Y
//	 -------------->	 -------------->
//	 |\X0Y0				|    /X0Y0
//	 | \				|   /
//	X|  \			   X|  /
//	 |   \				| /
//	 |    \X1Y1			|/X1Y1
//	 V					V

DrawLine:
		sta Y0				//X0=15,X1=03,Y0=03,Y1=03
		sty Y1				//Y1 must be larger than Y0

		lda X1
		sec
		sbc X0
		bcs drl1
		ldx X0
		ldy X1
		stx X1
		sty X0
		ldx Y0
		ldy Y1
		stx Y1
		sty Y0
		:NegA()				//C=0
drl1:	sta dX

		ldx X0
		ldy X1				//X1>X0

		lda Y1
		sec
		sbc Y0
		bcc drl2
		sta dY				//Y1>Y0, Line1 (YR increasing)
		lda LnTb1Lo,x
		sta drl4+1
		lda LnTb1Hi,x		//X=X0, smaller, line1 start
		sta drl4+2
		lda LnTb1Lo,y		//Y=X1, larger, line1 end
		sta Tmp1
		lda LnTb1Hi,y
		bcs drl3
drl2:	:NegA()				//Y0>Y1, Line 2 (YR decreasing), C=0
		sta dY
		lda LnTb2Lo,x
		sta drl4+1
		lda LnTb2Hi,x		//X=X0, smaller, line2 start
		sta drl4+2
		lda LnTb2Lo,y		//Y=X1, larger, line2 end
		sta Tmp1
		lda LnTb2Hi,y
drl3:	sta Tmp1+1
		ldy #$00
		lda #$60
		sta (Tmp1),y
		ldy Y0
		lda dY
		alr #$fe			//C=0
		//lsr
		eor #$ff
		sta dXY
		//clc
drl4:	jsr Line1
		ldy #$00
		lda #$a5
		sta (Tmp1),y
drlend:	rts

//----------------------------

MkFill:	lda #<Fill
		sta ZP1
		lda #>Fill
		sta ZP1+1
		lda #<CalcCol1+4	//3
		sta ZP2
		lda #>CalcCol1+4	//3
		sta ZP2+1

		lda #$16
		sta Cnt
mf10:	ldy Cnt
		lda ZP1
		clc
		adc #$01
		sta TmpLnTab+$02,y
		lda ZP1+1
		adc #$00
		sta TmpLnTab+$22,y
		lda Xlen+2,y
		beq mf13		//Skip this whole line
		lda Xmin+2,y
		asl
		asl
		asl
		adc ZP2
		sta fb01+1
		lda ZP2+1
		adc #$00
		sta fb01+2
		ldx Xlen+2,y

mf11:	ldy #<fb02-fb00
mf12:	lda fb00,y
		sta (ZP1),y
		dey
		bpl mf12
		lda #<fb02-fb00
		jsr AddZP1
		lda fb01+1
		clc
		adc #$08
		sta fb01+1
		bcc *+5
		inc fb01+2
		lda #$49					//EOR #$00
		sta fb00
		lda #$00
		sta fb00+1
		dex
		bpl mf11
		lda #$a9					//LDA #$04
		sta fb00
		lda #>ColTab0
		sta fb00+1
mf13:	
		lda RowLenTab
		inc mf13+1
		asl
		asl
		asl
		bcc *+4
		inc ZP2+1
		sec							//+1 for INY
		adc ZP2
		sta ZP2
		bcc *+4
		inc ZP2+1

		//lda ZP2
		//clc
		//adc #$c9					//Make a table with row lengths then LDA ZP2 CLC ADC ROWLENTAB,Y to make variable row length work.
		//sta ZP2
		//bcc *+4
		//inc ZP2+1
		dec Cnt
		bpl mf10

//----------------------

MkDel:	lda #<Fill+1
		sta db00+1
		lda #>Fill+1
		sta db00+2

		lda #$16
		sta Cnt
md10:	ldy Cnt
		ldx Xlen+2,y
		beq md13		//Skip this whole line
		lda #$8d		//=STA XXXX
md11:	sta db00
		ldy #<db01-db00
md12:	lda db00,y
		sta (ZP1),y
		dey
		bpl md12
		lda #<db01-db00
		jsr AddZP1
		lda db00+1
		clc
		adc #$05
		sta db00+1
		bcc *+5
		inc db00+2
		lda #$8e		//=STX XXXX (#$8f = SAX XXXX)
		//sta db00
		dex
		bpl md11

md13:	dec Cnt
		bpl md10
		rts

FillBase:
fb00:	lda #>ColTab0	//LDA #00 = $A9, EOR #00 = $49
fb01:	sta CalcCol1+3	//625*6 cycles = 3750 cycles
fb02:	rts

DelBase:
db00:	sta Fill+1		//625*4 cycles = 2500 cycles (SAX=#$8f, STA = #$8d) 
db01:	rts
						//Total: 6250 cycles = 104 rasters for fill and delete
						//88 unused in corners (saves 880 cycles)
						//537 used:	5370 cycles = 89 rasters, 15 rasters saved...
Xmin:
//.import binary "xmin.bin"
.byte $00,$00,$08,$06,$05,$03,$03,$02
.byte $02,$01,$01,$01,$01,$01,$01,$01
.byte $01,$01,$02,$02,$03,$04,$05,$07//,$00

//.byte $00,$07,$05,$03,$03,$03,$02,$01	//unmodified
//.byte $01,$00,$00,$00,$00,$00,$00,$00
//.byte $00,$01,$01,$02,$03,$03,$05,$07

Xlen:
//.import binary "xlen.bin"
.byte $00,$00,$08,$0c,$0e,$12,$12,$14
.byte $14,$16,$16,$16,$16,$16,$16,$16
.byte $16,$16,$14,$14,$13,$0f,$0d,$09,$00

//.byte $00,$0a,$0e,$12,$12,$12,$14,$16	//unmodified
//.byte $16,$18,$18,$18,$18,$18,$18,$18
//.byte $18,$16,$16,$14,$12,$12,$0e,$0a,$00

//----------------------------

.align $100

Sin:
*=Sin "Sin tabs"
.fill $100,64+64*sin(toRadians([i+0.5]*360/128))
//NewSin:
//.fill $100,12+4*sin(toRadians([i+0.5]*360/32))
Sin2:
.fill $100,8*sin(toRadians([i+0.5]*360/64))
Cos:
.fill $e0,12+12*cos(toRadians([i+0.5]*360/112))
Col:
.byte $00,$06,$0e,$03,$0e,$06,$0b,$05	//$00,$06,$0e,$03,$0b,$05,$0d,$09,$02,$08,$0a (note used: $01,$0c,$0f,$07,$04)
.byte $0d,$05,$09,$02,$08,$0a,$08,$02

Col2:
.byte $00,$00,$00,$00,$06,$06,$06,$06
.byte $04,$04,$04,$04,$0e,$0e,$0e,$0e
.byte $03,$03,$03,$03,$0e,$0e,$0e,$0e
.byte $04,$04,$04,$04,$06,$06,$06,$06
.byte $00,$00,$00,$00,$0b,$0b,$0b,$0b
.byte $0c,$0c,$0c,$0c,$0f,$0f,$0f,$0f
.byte $07,$07,$07,$07,$0f,$0f,$0f,$0f
.byte $0b,$0b,$0b,$0b,$00,$00,$00,$00

ZPLo:
.byte $00,$40,$80,$c0

RowLenTab:
.byte 32,31,31,30,30,30,29,27		//   240
.byte 25,25,26,26,25,25,25,26		// + 203
.byte 24,23,25,25,26,26,26,36		// + 211
.byte 37							// +  37 = 691 total

Pattern:
.byte %00110000
.byte %10011000
.byte %11101100
.byte %01000111
.byte %10111000
.byte %11011100
.byte %00100000
.byte %00000011

.byte %10111000
.byte %11011100
.byte %00100000
.byte %00000011
.byte %00110000
.byte %10011000
.byte %11101100
.byte %01000111

//--------------------------------------

.align $100

Intro_Go:		jsr ClearColTabs
				jsr CreateFadeTables
				jsr ClearScreen
				jsr SetupSprites

				ldy #$08
				ldx #$00
CpySrc0:		lda $9800,x				//Plasma Pattern preloaded to $9800-$a000 and $c800-$d000
CpyDst0:		sta $2000,x
CpySrc1:		lda $c800,x
CpyDst1:		sta $2800,x
				inx
				bne CpySrc0
				inc CpySrc0+2
				inc CpyDst0+2
				inc CpySrc1+2
				inc CpyDst1+2
				dey
				bne CpySrc0

				lda #$34
				sta $01

				ldy #$05
CpySrc2:		lda $bf80,x				//Cube ($c00 bytes) preloaded to $bf80-$c680 and $db00-$e000
CpyDst2:		sta $3000,x
CpySrc3:		lda $db00,x
CpyDst3:		sta $3700,x
				inx
				bne CpySrc2
				inc CpySrc2+2
				inc CpyDst2+2
				inc CpySrc3+2
				inc CpyDst3+2
				dey
				bne CpySrc2

				lda #$35
				sta $01

!:				lda $c480,x
				sta $3500,x
				lda $c580,x
				sta $3600,x
				inx
				bne !-

				nsync()

				lda #$00
				sta $d012
				lda #<IRQFI0
				sta $fffe
				lda #>IRQFI0
				sta $ffff

				lda #$3d
				sta $dd02
				lda #$3b
				sta $d011
				lda #$18
				sta $d016
				lda #$80
				sta $d018


				rts
		
//------------------------------------

IRQFI0:			dec $00
				sta ZPA
				stx ZPX
				sty ZPY
				asl $d019
		
				jsr SetPos1

				jsr BASE_PlayMusic

				lda #$00
				sta $d025
				sta $d026

				lda #$ea-3
				sta $d012
				lda #<IRQFI1
				sta $fffe
				lda #>IRQFI1
				sta $ffff

				lda ZPA
				ldx ZPX
				ldy ZPY
				inc $00
				rti

//------------------------------------

IRQFI1:			dec $00
				sta ZPAFI1+1
				stx ZPXFI1+1
				asl $d019

				lda #$ea
				sta $d009
				sta $d00b
				sta $d00d

				lda #$00
				sta $d008
				lda #$18
				sta $d00a
				lda #$30
				sta $d00c

				lda #$70
				sta $d010

				ldx #$98
				stx ScrRAM+$03fc
				inx
				stx ScrRAM+$03fd
				inx
				stx ScrRAM+$03fe

				sty ZPYFI1+1

				lda #$00
				sta $d012
				lda #<IRQFI0
				sta $fffe
				lda #>IRQFI0
				sta $ffff

				inc $00
				lda $01
				sta ZP01
				lda #$35
				sta $01

				cli

		FI:		jsr FadeIn

		FO:		nop FadeOut

				lda ZP01
				sta $01

ZPAFI1:			lda #$00
ZPXFI1:			ldx #$00
ZPYFI1:			ldy #$00
				rti

//--------------------------------------

FadeIn:			lda #$00
				eor #$ff
				sta FadeIn+1
				bne fis0
				rts

fis0:			lda #<FadeTables
				sta ZPFI
fi00:			lda #>FadeTables
				sta ZPFI+1

				ldx #$11
fi01:
				.for (var i = 0; i < 25; i++)
				{
				ldy ScrTab + (i * 18),x
				lda (ZPFI),y
				sta ScrRAM + (i * 40) + 22,x
				
				ldy ColTab + (i * 18),x
				lda (ZPFI),y
				sta ColRAM + (i * 40) + 22,x
				}

				dex
				bpl FadeInJmp
				inc fi00+1
				lda fi00+1
				cmp #>FadeTables+$800
				beq FadeInDone
				rts
FadeInJmp:		jmp fi01

FadeInDone:		lda #<OPC_NOPABS
				sta FI
				rts

//--------------------------------------

FadeOut:		lda #$00
				eor #$ff
				sta FadeOut+1
				bne fos0
				rts

fos0:			lda #<FadeTables+$700
				sta ZPFI
fo00:			lda #>FadeTables+$700
				sta ZPFI+1

				ldx #$11
fo01:
				.for (var i = 0; i < 25; i++)
				{
				ldy ScrTab + (i * 18),x
				lda (ZPFI),y
				sta ScrRAM + (i * 40) + 22,x
				
				ldy ColTab + (i * 18),x
				lda (ZPFI),y
				sta ColRAM + (i * 40) + 22,x
				}

				dex
				bpl FadeOutJmp
				dec fo00+1
				lda fo00+1
				cmp #>FadeTables-$100
				beq FadeOutDone
				rts
FadeOutJmp:		jmp fo01

FadeOutDone:	lda #<OPC_NOPABS
				sta FO
				lda #$01
				sta PART_Done

				rts
//--------------------------------------

ClearScreen:
				lax #$00
!:				sta $6000,x
				sta $6100,x
				sta $6200,x
				sta $62e8,x
				sta $d800,x
				sta $d900,x
				sta $da00,x
				sta $dae8,x
				inx
				bne !-
				rts

//--------------------------------------

ClearColTabs:
		ldx #$3f
		lda #$00
!:		sta ZPCol+ColBase,x
		sta ColTab0+ColBase,x
		sta ColTab1+ColBase,x
		sta ColTab2+ColBase,x
		sta ColTab3+ColBase,x
		dex
		bpl !-
		rts

//--------------------------------------

SetupSprites:

		lda #$ff
		sta $d015
		sta $d01c
		lda #$00
		sta $d017
		sta $d01d

		lda #$0f
		sta $d027
		sta $d02a
		lda #$08
		sta $d028
		sta $d029
		lda #$0e
		sta $d02b
		sta $d02c
		sta $d02d
		sta $d02e

SetPos1:
		ldx #$10
!:		lda SpritePos1,x
		sta $d000,x
		dex
		bpl !-

		ldx #$07
		lda #$97
		sec
!:		sta ScrRAM+$03f8,x
		sbc #$01
		dex
		bpl !-
		
		rts

//--------------------------------------

SpritePos1:
.byte $f8,$42,$f8,$5a,$e8,$6a,$e0,$82,$d8,$aa,$c8,$b2,$e0,$d2,$e8,$ea,$00

SpritePos2:
.byte $00,$ea,$18,$ea,$30,$ea,$07

//--------------------------------------

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
