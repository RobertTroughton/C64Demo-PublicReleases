
.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

//---------------------------------
//		Memory Layout
//
//	0400	04f0	-UNUSED-			00f0--
//	04f0	05e0	Screen 1			00f0++
//	0500	05c0	ColRowTab			00c0!!			- Screen 1 will overwrite it
//	0600	0780	ColorData			0180!!
//	0800	0900	Demo driver code	0100!!
//	0900	2000	Music				1700!!
//	2000	3f80	Charset 1			1f80!!

//	4000	43da	RasterCode			03da++
//	4400	44f0	Screen 0			00f0++
//	44f0	5fe4	RasterCode ctd		1af4++
//	6000	7f80	Charset 0			1f80!!

//	8000	8100	D016SinTab			0100++
//	8100	8200	D018SinTab			0100++
//	8200	8300	ColSinTab			0100++
//	8300	8400	D016Sin2Tab			0100++
//	8400	8500	D018Sin2Tab			0100++
//	8500	85c0	RasterColTab		00c0!!
//	85e0	86d0	Screen 2			00f0++
//	8700	8800	ColSin2Tab			0100++
//	8800	8e00	DXTab				0600++
//	8e00	8f80	ColorTab			0180++
//	8f80	8fc0	ColSwapTab			0040++
//	8f00*	9800	Main Code + Sin Tab	0900!!			- 8f00-9000 only used at init, overwritten by ColorTab and ColSwapTab
//	9800	9a00	Intro				0200!!
//	9a00	a000	-UNUSED-			0600--			- 9800-9fff available for peloading after init
//	a000	bf80	Charset 2			1f80!!

//	bf80	c6d0	-UNUSED-			0750--			- bf80-c6d0 awailable for preloading
//	c6d0	c7e8	Screen 3			0118++
//	c7e8	d000	-UNUSED-			0818--			- c800-cfff available for preloading

//	d000	d0c0	EORTabLo			00c0++
//	d0c0	d180	EORTabHi			00c0++
//	d180	d240	SnippetLo			00c0++
//	d240	d300	SnippetHi			00c0++
//	d300	d400	Fade Data			0100!!
//	d400	d4c0	YDiffTab			00c0!!

//	d4c0	d7c1	BadLineCode			0301++
//	d7c1	d942	XCopyCode			0180++
//	d942	dac3	XIncCode			0180++

//	db00	e000	-UNUSED-			0500--			- db00-dfff available for preloading
//	e000	ff80	Charset 3			1f80!!

//	-- unused
//	++ runtime generated
//	!! loaded
//

//	UNUSED:
//	0400	04f0	-UNUSED-	00f0
//	9a00	a000	-UNUSED-	0600
//	bf80	c6d0	-UNUSED-	0750
//	c7e8	d000	-UNUSED-	0818
//	db03*	e000	-UNUSED-	04fd

.const	IRQJmp		=$10

.const	ZP1			=$20
.const	ZPT1		=$22
.const	ZPT2		=$23
.const	ZPT3		=$24
.const	ZPT4		=$25

.const	XK			=$30		//$30-$ef

.const	YK			=$f0
.const	FrameLo		=$f1
.const	FrameHi		=$f2

.const	Screen0		=$4400
.const	Screen1		=$04f0
.const	Screen2		=$85e0
.const	Screen3		=$c6d0

.const	ColRowTab	=$0500		//Will be overwritten by Screen1
.const	ColorData	=$0600		//Original Color Table

.const	RasterCode	=$4000

.const	TmpBLLo		=$8000		//Will be overwritten by D016SinTab
.const	TmpBLHi		=$8080		//Will be overwritten by D016SinTab

.const	D016SinTab	=$8000
.const	D018SinTab	=$8100
.const	ColSinTab	=$8200
.const	D016Sin2Tab	=$8300
.const	D018Sin2Tab	=$8400
.const	RasterColTab=$8500		//-$85c0
.const	ColSin2Tab	=$8700
.const	DXTab		=$8800		//-$8e00
.const	ColorTab	=$8e00
.const	ColSwapTab	=$8f80


.const	EORTabLo	=$d000
.const	EORTabHi	=$d0c0
.const	SnippetLo	=$d180
.const	SnippetHi	=$d240
.const	FadeTab		=$d300
.const	YDiffTab	=$d400

.const	BadLineCode	=$d4c0
.const	XCopyCode	=BadLineCode + $0301
.const	XIncCode	=XCopyCode + $0181

.const	OPC_PHA		=$48
.const	OPC_PLA		=$68

*=$8f00	"Sine table"			//Table will be overwritten by ColorTab and ColSwpTab
Sin:
.fill $100,384+384*cos(toRadians([i+0.5]*360/256))

*=$9000	"Main code"

Trailblazer_Go:                               

		vsync()
		lda #$00
		sta FrameLo
		sta FrameHi

		lda #$34
		sta $01

		jsr BuildRasterCode
		jsr MakeDXTab
		jsr BuildBadLineCode	//BadLineCode needs to be built after Color Tabs are ready!!!
		jsr BuildUpdateCode
		jsr BuildXWaveCode
		jsr MakeSinTabs
		jsr CopyDblColors

		lda #$35
		sta $01

		ldx #$3f				//Create Color Swap Tabs - this version saves a few (7ish) bytes on the old one
mn00:	txa
		lsr
		lsr
		lsr
		alr #$02
		sta ColSwapTab,x
		dex
		bpl mn00

		ldx #$00				//Prepeare color RAM and screen
		lda #$08
ColLoop:
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne ColLoop
		lda #$f0
		ldx #$27
LastRow:
		sta $c7c0,x			//Char row 24	- VIC Bank 3
		dex
		bpl LastRow
		tax
ScrLoop:
		dex
		txa
		sta Screen0,x		//Char rows 0-5	- VIC Bank 1
		sta Screen1,x		//Char rows 6-11	- VIC Bank 0
		sta Screen2,x		//Char rows 12-17	- VIC Bank 2
		sta Screen3,x		//Char rows 18-23	- VIC Bank 3
		bne ScrLoop

		ldx #$c0
		lda #$00
vxloop:	sta XK-1,x
		dex
		bne vxloop

		lda #$00
		sta YK

		dec $01
		jsr BadLineCode
		inc $01

		lda PART_Done
		beq *-3

		nsync()

		lda #$00
		sta PART_Done
		sta $d015

		lda #<irq0
		sta $fffe
		lda #>irq0
		sta $ffff
		lda #$00
		sta $d012
		lda #$1b
		sta $d011
		
		rts

//------------------------------

irq0:	dec $00
		sta ir0_a+1
		stx ir0_x+1
		sty ir0_y+1
		asl $d019

		jsr BASE_PlayMusic

		lda #<irq
		sta $fffe
		lda #>irq
		sta $ffff
		lda #$31
		sta $d012

		inc $00
ir0_y:	ldy #$00
ir0_x:	ldx #$00
ir0_a:	lda #$00
		rti

//------------------------------

irq:	dec $00		
		//dec $d020
		sta ira+1		
		:compensateForJitter(3)
		stx irx+1		//44-47
		sty iry+1		//48-51
		asl $d019		//52-57
		lda #$3d		//58,59
		sta $dd02		//60,61,62,00
		pha				//01,02,03			Waste 9 cycles
		pla				//04,05,06,07
		nop				//08,09

		jsr RasterCode	//10,11,12,13,14,15

		ldx #$05
		dex
		bpl *-1

		lda #$3f
		sta $dd02

		lda #$00
		sta $d012
		lda #<irq0
		sta $fffe
		lda #>irq0
		sta $ffff

		inc $00

		cli

		lda $01
		pha
		
		lda #$34
		sta $01

		jsr XIncCode

SkipXUpdate:
		jsr FadeIn

		ldy FrameHi
		ldx FrameLo
		cpy #$03
		bne	Not03
		cpx #$ff
		beq DoFO

Not03:	cpy #$04
		beq DoFO
		
		cpy #$02
		bne SkipWave
		
		cpx #$03
		bcs SkipTabChg
TabChg:		
		ldx #$00
SnpLoop:
		lda SnippetLo,x
		sta ZP1
		lda SnippetHi,x
		sta ZP1+1
		ldy #$06
		lda #>ColSin2Tab
		sta	(ZP1),y
		ldy #$13
		lda #>D016Sin2Tab
		sta	(ZP1),y
		ldy #$19
		lda #>D018Sin2Tab
		sta	(ZP1),y
		inx
TabCmp:	cpx #$40
		bne	SnpLoop
		stx	TabChg+1
		txa
		clc
		adc #$40
		beq SkipTabChg
		sta TabCmp+1
		bne SkipWave

SkipTabChg:

WaveX:	ldx #$c0
		beq SkipWave
		dex
		stx WaveX+1
		lda YDiffTab,x
		beq SkipX
		clc
		adc XK,x
XWC:	jsr XCopyCode
SkipX:	lda XWC+1
		clc
		adc #$02
		sta XWC+1
		bcc *+5
		inc XWC+2

SkipWave:
		inc FrameLo
		bne SkipTmr
		
		inc FrameHi
		
		bne SkipTmr

DoFO:	jsr FadeOut
		
SkipTmr:
		lda FrameHi
		cmp #$01
		bne	SkipCrcl

icy:	ldx #$40
		lda Sin2,x
		and #$1f
		sta YK
		tay
		inx
		stx icy+1
		jmp BLCode

SkipCrcl:
		lda YK
		sec
		sbc #$02
		and #$1f
		sta YK
		tay

BLCode:
		jsr BadLineCode

		pla
		sta $01
ira:	lda #$00
irx:	ldx #$00
iry:	ldy #$00
		rti

//----------------------------------

FadeIn:
fi00:	ldx #$00
		bne FIDone
fi01:	ldx #$00
		inc fi01+1
		bne fi02
		inc fi00+1
fi02:	lda FadeTab,x
		beq	FIDone
		tay

fi03:	ldx #$00
fi04:	lda ColorData,x
fi05:	sta ColorTab,x
		inx
		inx
		stx fi03+1
		bne fi06
		//txa
		//clc
		//adc #$02
		//sta fi03+1
		//bcc fi06
		inc fi04+2
		inc fi05+2

fi06:	ldx #$00
fi07:	lda EORTabLo,x
		sta fi0b+1
fi08:	lda EORTabHi,x
		sta fi0b+2
fi09:	lda ColorTab
fi0a:	eor ColorTab+1
fi0b:	sta $c0de
		lda fi09+1
		clc
		adc #$02
		sta fi09+1
		ora #$01
		sta fi0a+1
		bcc !+
		inc fi09+2
		inc fi0a+2
!:		inx
		bne !+
		inc fi07+2
		inc fi08+2
!:		stx fi06+1
		dey
		bne fi03
FIDone:	rts		

//----------------------------------

FadeOut:
		//:BranchIfNotFullDemo(SkipPartDone)
fo00:	ldx #$00
		bne FODone
fo01:	ldx #$00
		inc fo01+1
		bne fo02
		inc fo00+1
fo02:	lda FadeTab,x
		beq	SkipPartDone
		tay
fo03:	ldx #$00
		lda #$00
fo04:	sta ColorTab+1,x
fo05:	sta ColorTab+0,x
		txa
		clc
		adc #$02
		sta fo03+1
		bcc fo06
		inc fo04+2
		inc fo05+2

fo06:	ldx #$00
fo07:	lda EORTabLo,x
		sta fo0b+1
fo08:	lda EORTabHi,x
		sta fo0b+2
		lda #$00
fo0b:	sta $c0de
		inx
		bne !+
		inc fo07+2
		inc fo08+2
!:		stx fo06+1
		dey
		bne fo03
		jmp SkipPartDone

FODone:
		:BranchIfNotFullDemo(SkipPartDone)
		
		inc PART_Done
		lda #$00
		sta $d011
SkipPartDone:
		rts

//----------------------------------
//		Create Tables
//----------------------------------

MakeDXTab:
		ldy #$07
mdt0:	lda #$00
		sta ZPT2
		lda #$a0
		sta ZPT1
		lda #<DXTab
		sta ZP1
		lda #>DXTab
		sta ZP1+1
		ldx #$c0
mdt1:	tya
		clc
		adc ZPT1
		bcc SkipInc
		inc ZPT2
		sbc #$c0
SkipInc:
		sta ZPT1
		lda #$17
		sec
		sbc ZPT2
		sta (ZP1),y
		lda #$08
		jsr AddZP1
		dex
		bne mdt1
		dey
		bpl mdt0
		rts

MakeSinTabs:
		ldx #$00
mst0:	lda Sin,x
		and #$07
		sta D016SinTab,x	//#$00-#$07
		lda Sin,x
		lsr
		alr #$0c
		ora #$18
		sta D018SinTab,x	//#$18-#$1e (VIC Bank Base + $0400-$07ff)
		lda Sin,x
		alr #$20
		lsr
		lsr
		lsr
		lsr
		sta ColSinTab,x		//#$00 vs #$01
		inx
		bne mst0
mst1:	lda Sin2,x
		and #$07
		sta D016Sin2Tab,x	//#$00-#$07
		lda Sin2,x
		lsr
		alr #$0c
		ora #$18
		sta D018Sin2Tab,x	//#$18-#$1e (VIC Bank Base + $0400-$07ff)
		lda Sin2,x
		alr #$20
		lsr
		lsr
		lsr
		lsr
		sta ColSin2Tab,x		//#$00 vs #$01
		inx
		bne mst1
		rts

//----------------------------------
//		Build Rastercode
//----------------------------------

BuildRasterCode:
		lda #<RasterCode
		sta ZP1
		lda #>RasterCode
		sta ZP1+1
		
		lda #$03
		sta ZPT1		//Number of char sets (4)
		lda #$00
		sta ZPT4		//Row counter

br00:	lda #$05		//Number of char lines in 1 char set (6)
		sta ZPT2

br01:	jsr AddLine
		jsr AddShortLine
		ldx #$04		//Number of lines with PHA-PLA (5)
		stx ZPT3
br02:	jsr AddLine
		jsr AddWait7
		dec ZPT3
		bpl br02
		jsr AddLine
		jsr AddWait8
		dec ZPT2
		bpl br01
		dec ZPT1
		bpl br00
		rts

AddLine:
		lda ZP1
aslo:	sta SnippetLo
		clc
		adc #<lb0c-lb00+1	//$21
		sta lb06+1
		lda ZP1+1
ashi:	sta SnippetHi
		adc #$00
		sta lb06+2

		inc aslo+1
		bne *+5
		inc aslo+2
		
		inc ashi+1
		bne *+5
		inc ashi+2
		
		ldx ZPT4
		lda ColRowTab,x
		ora #<ColSwapTab
		sta lb03+1
		
		//jsr GetEOR
		//sta lb0e+1

		ldy #<lb0x-lb00-1
al00:	lda lb00,y
		sta (ZP1),y
		dey
		bpl al00
		
		lda #<lb0e-lb00+1
		jsr AddEOR
		
		jsr UpdateLineBase
		
		lda #<lb0x-lb00
AddZP1:	clc
		adc ZP1
		sta ZP1
		bcc *+4
		inc ZP1+1
		rts

AddShortLine:
		//jsr GetEOR
		//sta sb06+1

		inc aslo+1
		bne *+5
		inc aslo+2
		
		inc ashi+1
		bne *+5
		inc ashi+2

		ldy #<sb0x-sb00-1
as00:	lda sb00,y
		sta (ZP1),y
		dey
		bpl as00

		lda ZP1					//Save start address of badlines
as01:	sta TmpBLLo
		lda ZP1+1
as02:	sta TmpBLHi
		inc as01+1
		inc as02+1
		
		lda #<sb06-sb00+1
		jsr AddEOR

		jsr UpdateLineBase		//Skip first line after badline

		lda #<sb0x-sb00
		jmp AddZP1

UpdateLineBase:
		inc lb01+1
		inc ZPT4

		lda lb05+1
		clc
		adc #$02
		sta lb05+1
		bcc *+6
		clc
		inc lb05+2
		
		lda lb08+1
		adc #$08
		sta lb08+1
		bcc *+6
		clc
		inc lb08+2

		lda ge00+1
		ldx ge00+2
		adc #$02
		bcc *+4
		clc
		inx
		sta ge00+1
		stx ge00+2
		
		adc #$01
		bcc *+3
		inx
		sta ge01+1
		stx ge01+2

		rts

GetEOR:
ge00:	lda ColorTab
ge01:	eor ColorTab+1
		rts

AddEOR:	ldx #$00
		clc
		adc ZP1
ae00:	sta EORTabLo,x
		lda ZP1+1
		adc #$00
ae01:	sta EORTabHi,x
		inx
		stx AddEOR+1
		rts

AddWait7:
		ldy #$00
		lda #OPC_PHA
		sta (ZP1),y
		iny
		lda #OPC_PLA
		sta (ZP1),y
		lda #$02
		jmp AddZP1

AddWait8:
		ldx ZPT2
		beq AddDD02
		cpx #$03
		bne SkipJmp
		ldx ZPT1
		cpx #$03
		beq AddJmp
SkipJmp:
		ldy #<w8x-w80-1	//$02
aw80:	lda Wait8Base,y
		sta (ZP1),y
		dey
		bpl aw80
		lda #<w8x-w80	//$03
		jmp AddZP1

AddDD02:
		lda ZPT1
		ldy #$3c
		cmp #$03
		beq ad00
		ldy #$3e
		cmp #$02
		beq ad00
		ldy #$3f
		cmp #$01
		beq ad00
		ldy #$3d
ad00:	sty db00+1
		ldy #<db0x-db00
ad01:	lda db00,y
		sta (ZP1),y
		dey
		bpl ad01
		lda #<db0x-db00
		jmp AddZP1

AddJmp:	ldy #$05
aj00:	lda WaitJmp,y
		sta (ZP1),y
		dey
		bpl aj00
		lda #$f0
		sta ZP1
		lda #$44
		sta ZP1+1
		rts

LineBase:						//Cycles		Bytes
lb00:	ldy YK					//15-17			00-01		ldy YK				19-21
lb01:	ldx XK					//18-20			02-03		ldx XK				22-24
lb02:	lda ColSinTab,x			//21-24			04-06*		lda ColSinTab,x		25-28
lb03:	eor ColSwapTab,y		//25-28			07-09		eor ColSwapTab,y	29-32
lb04:	tay						//29 30			0a			sta $c0de			33-36
lb05:	lda ColorTab,y			//31-34			0b-0d		ldy D016SinTab,x	37-40
lb06:	sta $c0de				//35-38			0e-10		lda DXTab,y			41-44
lb07:	ldy D016SinTab,x		//39-42			11-13*		ldy D018SinTab,x	45-48
lb08:	lda DXTab,y				//43-46			14-16		ldx #$00			49 50
lb09:	ldy D018SinTab,x		//47-50			17-19*		sta $d016			51-54*
lb0a:	sta $d016				//51-54*		1a-1c		sty $d018			55-58
lb0b:	sty $d018				//55-58			1d-1f		lda ColorTab,x		59-62
lb0c:	lda #$00				//59 60			20-21		sta $d022			00-03
lb0d:	sta $d022				//61-01			22-24		eor #$0f			04 05
lb0e:	eor #$00				//02 03			25-26		sta $d023			06-09
lb0f:	sta $d023				//04-07			27-29							10-18 (9c)
lb0x:							//08-14 (7c)

ShortLineBase:
sb00:	ldx #$00
sb01:	ldy #$00
sb02:	stx $d016
sb03:	sty $d018
sb04:	lda #$00
sb05:	sta $d022
sb06:	eor #$00
sb07:	sta $d023
sb08:	nop
sb0x:

Wait7Base:
		pha
		pla

Wait8Base:
w80:	nop						//DO NOT USE CMP ($00,X) - it may randomly read from $dddd - acknowledgning NMI lock timer NMI!!!
		nop
		nop
		nop
w8x:

WaitJmp:
		bit $ea
		nop
		jmp $44f0

DD02Base:
db00:	lda #$3d
		sta $dd02
		nop
db0x:	rts

//----------------------------

BuildBadLineCode:
		lda #<BadLineCode
		sta ZP1
		lda #>BadLineCode
		sta ZP1+1
		lda #$17
		sta ZPT1			//number of badlines (24)
		lda #$01
		sta ZPT2
		lda #$00
		sta ZPT3
		
		jsr UBLB

bc00:	ldy #<bb0x-bb00
bc01:	lda bb00,y
		sta (ZP1),y
		dey
		bpl bc01
		
		jsr UpdateBLBase
		
		lda ZP1
bslo:	sta SnippetLo+1
		lda ZP1+1
bshi:	sta SnippetHi+1
		lda bslo+1
		clc
		adc #$08
		sta bslo+1
		bcc *+5
		inc bslo+2

		lda bshi+1
		clc
		adc #$08
		sta bshi+1
		bcc *+5
		inc bshi+2

		lda #<bb0x-bb00
		jsr AddZP1
		dec ZPT1
		bpl bc00
		rts

UpdateBLBase:
		lda bb01+1
		clc
		adc #$08
		sta bb01+1

		lda ZPT2
		clc
		adc #$08
		sta ZPT2

		inc ZPT3

		lda bb05+1
		clc
		adc #$02*8
		sta bb05+1
		bcc *+6
		clc
		inc bb05+2
		
		lda bb08+1
		adc #$08*8
		sta bb08+1
		bcc *+5
		inc bb08+2

UBLB:	ldx ZPT3
		lda TmpBLLo,x
		ldy TmpBLHi,x
		clc
		adc #$01
		bcc *+4
		iny
		clc
		sta bb0a+1
		sty bb0a+2
		adc #$02
		bcc *+4
		iny
		clc
		sta bb0b+1
		sty bb0b+2
		adc #$08
		bcc *+4
		iny
		clc
		sta bb06+1
		sty bb06+2

		ldx ZPT2
		lda ColRowTab,x
		//clc
		//adc #<ColSwapTab
		ora #<ColSwapTab
		sta bb03+1

		rts

BadLineBase:
bb00:	ldy YK				//00-01
bb01:	ldx XK+1			//02-03
bb02:	lda ColSinTab,x		//04-06*
bb03:	eor ColSwapTab,y	//07-09
bb04:	tay					//0a
bb05:	lda ColorTab+2,y	//0b-0d
bb06:	sta $c0de			//0e-10
bb07:	ldy D016SinTab,x	//11-13*
bb08:	lda DXTab+8,y		//14-16
bb09:	ldy D018SinTab,x	//17-19*
bb0a:	sta $c0de			//1a-1c
bb0b:	sty $c0de			//1d-1f
bb0x:	rts

//-----------------------------------------------------------------------------------------

CopyDblColors:
		ldy #$c0
		ldx #$00
CSrc:	lda ColorData+1,x
CDst1:	sta ColorTab,x
CDst2:	sta ColorTab+1,x
		inx
		inx
		bne !+
		inc CSrc+2
		inc CDst1+2
		inc CDst2+2
!:		dey
		bne CSrc
		rts

//-----------------------------------------------------------------------------------------

BuildUpdateCode:

		lda	#<XIncCode
		sta ZP1
		lda #>XIncCode
		sta ZP1+1
		ldx #$c0
ux00:	ldy #<xu0x-xu00
ux01:	lda xu00,y
		sta (ZP1),y
		dey
		bpl	ux01
		inc xu00+1
		lda #<xu0x-xu00
		jsr AddZP1
		dex
		bne ux00
		rts

xu00:	inc XK
xu0x:	rts

//-----------------------------------------------------------------------------------------

BuildXWaveCode:

		lda	#<XCopyCode
		sta ZP1
		lda #>XCopyCode
		sta ZP1+1
		ldx #$c0
wx00:	ldy #<xw0x-xw00
wx01:	lda xw00,y
		sta (ZP1),y
		dey
		bpl	wx01
		dec xw00+1
		lda #<xw0x-xw00
		jsr AddZP1
		dex
		bne wx00
		rts


xw00:	sta XK+$bf
xw0x:	rts

//-----------------------------------------------------------------------------------------

/*
BuildEORCode:
		lda #<EORCode
		sta ZP1
		lda #>EORCode
		sta ZP1+1
		
		ldx #$bf
bec0:	lda EORTabLo,x
		sta eb02+1
		lda EORTabHi,x
		sta eb02+2
		
		ldy #<eb0x-eb00
bec1:	lda eb00,y
		sta (ZP1),y
		dey
		bpl bec1
		
		lda eb00+1
		sec
		sbc #$02
		sta eb00+1
		ora #$01
		sta eb01+1
		bcs !+
		dec eb00+2
		dec eb01+2
!:
		
		lda #<eb0x-eb00
		jsr AddZP1
		dex
		cpx #$ff
		bne bec0
		rts

EORBase:
eb00:	lda ColorTab+$17e
eb01:	eor ColorTab+$17f
eb02:	sta $c0de
eb0x:	rts
*/

//-----------------------------------------------------------------------------------------

/*
Vertical:
		//Preps:
		
		ldx #$c0
		lda #$00
vxloop:	sta XK-1,x
		dex
		bne vxloop
		
		//Do not increment XK from IRQ
		
		//IRQ:
		lda YK
		sec
		sbc #$04
		and #$1f
		sta YK

Circle:
		//Preps (same as vertical):
		//Use a sine wave with an ampliture of 256?
		
		ldx #$c0
		lda #$00
cxloop:	sta XK-1,x
		dex
		bne cxloop
		
		//IRQ:
		ldx #$c0
		lda XK
		clc
		adc #$02		//value to be tested...
		tay
icx:	sty XK-$01,x
		sty XK-$01,x
		sty XK-$02,x
		sty XK-$03,x
		sty XK-$04,x
		sty XK-$05,x
		sty XK-$06,x
		sty XK-$07,x
		sty XK-$08,x
		sty XK-$09,x
		sty XK-$0a,x
		sty XK-$0b,x
		sty XK-$0c,x
		sty XK-$0d,x
		sty XK-$0e,x
		sty XK-$0f,x
		sty XK-$10,x
		txa
		axs #$10
		bne icx

icy:	ldx #$00
		lda Sin,x
		and #$1f
		sta YK
		inx
		inx
		stx icy+1
*/

.align $100

Sin2:
.fill $100,96+96*cos(toRadians([i+0.5]*360/256))

.import source "TrailblazerIntro.asm"