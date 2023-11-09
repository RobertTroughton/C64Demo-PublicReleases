//------------------------------
//	PARALLAX CHECKERBOARD
//------------------------------

.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

//; ------------------------
//; Memory Layout
//;-------------------------
//;
//;   02	  04	Sparkle (only during loading)
//;   fc	  fd	Music ZP
//;   fe	  ff	Music frame counter
//; 0160	03ff	Sparkle (ALWAYS)
//; 0400	07e7	Screen RAM
//; 0800	08ff	Disk Driver
//; 0900	1fff	Music
//; 2000			Main Code + Generated Code
//; 4000	4140	Charset16A
//; 4140	4800	-UNUSED-	06c0
//; 4800	4940	Charset14A
//; 4940	5000	-UNUSED-	06c0
//; 5000	5140	Charset12A
//; 5140	5800	-UNUSED-	06c0
//; 5800	5940	Charset10A
//; 5940	6000	-UNUSED-	06c0
//; 6000	6140	Charset08
//; 6140	6800	-UNUSED-	06c0
//; 6800	6940	Charset06
//; 6940	7000	-UNUSED-	06c0
//; 7000	7140	Charset04
//; 7140	7800	-UNUSED-	06c0
//; 7800	7940	Charset02
//; 7940	7c00	-UNUSED-	02c0
//; 7c00	7fe8	ScreenA

//; 8000	c000	-UNUSED-	4000

//; c000	c140	Charset16B
//; c140	c800	-UNUSED-	06c0
//; c800	c940	Charset14B
//; c940	d000	-UNUSED-	06c0
//; d000	d140	Charset12B
//; d140	d800	-UNUSED-	06c0
//; d800	d940	Charset10B

//; d940	fc00	-UNUSED-	22c0

//; fc00	ffe8	ScreenB

//------------------------------------------------------------------------------------------------------------------------------------------------------

.const ZP			= $02
.const ZP2			= $04
.const Tmp			= $06
.const Tmp2			= $07
.const ZPdX			= $0a
.const FrameLo		= $0b
.const FrameHi		= $0c
.const Direction	= $0d
.const ZPTab		= $10		//-$f6, actual tab: $50-$b4

.const YSinTabSize	= $b8

.const FrameHiMax	= $02

.const Color0A		= $09
.const Color0B		= $00
.const Color1A		= $02
.const Color1B		= $06
.const Color2A		= $04
.const Color2B		= $0b
.const Color3A		= $08
.const Color3B		= $0e
.const Color4A		= $0a
.const Color4B		= $0c
.const Color5A		= $03
.const Color5B		= $05
.const Color6A		= $0d
.const Color6B		= $0f
.const Color7A		= $07
.const Color7B		= $01

.const PatternSize0	= 1
.const PatternSize1	= 2
.const PatternSize2	= 3
.const PatternSize3	= 4
.const PatternSize4	= 5
.const PatternSize5	= 6
.const PatternSize6	= 7
.const PatternSize7	= 8

.const Charset16A	= $4000
.const Charset14A	= $4800
.const Charset12A	= $5000
.const Charset10A	= $5800
.const Charset08	= $6000
.const Charset06	= $6800
.const Charset04	= $7000
.const Charset02	= $7800
.const Charset16B	= $c000
.const Charset14B	= $c800
.const Charset12B	= $d000
.const Charset10B	= $d800
.const ScreenA		= $7c00
.const ScreenB		= $fc00

.const OPC_NOP		= $ea
.const OPC_RTS		= $60
.const OPC_ZPX		= $95
.const OPC_JMP		= $4c

.const VICBank1		= $3d
.const VICBank3		= $3f

//------------------------------------------------------------------------------------------------------------------------------------------------------

* = $2000

Parallax_Go:
			jsr CreateInitScreen

			nsync()

			lda #$00
			sta $d012
			lda #<irqmsc
			sta $fffe
			lda #>irqmsc
			sta $ffff
			lda #$1b
			sta $d011
			lda #$d0
			sta $d016
			lda #$3e
			sta $dd02
			lda #$10
			sta $d018

			jsr CreateScreens
			jsr CreateCharsets
			jsr CreatePatterns
			jsr CreatePatternMod

			lda #OPC_RTS
			jsr ModifyPatterns

			ldx #<Color0A
			lda #<Color0B
			jsr DrawPattern0

			lda #$00
			sta ZPdX
			lda #$00
			sta FrameLo
			lda #<FrameHiMax+1
			sta FrameHi
			
			lda #$00
			sta Direction

			:BranchIfNotFullDemo(DontSyncMusic)
			MusicSync(SYNC_Parallax) 
	DontSyncMusic:

			//nsync()
			
			lda #$01
			sta IntroDone+1
			
/*			lda #$00
			sta $d012
			lda #<irqmsc
			sta $fffe
			lda #>irqmsc
			sta $ffff
			lda #$1b
			sta $d011

			lda #$30
			cmp $d012
			bne *-3
			lda #$04
			sta $d020
			lda #$00
			sta $d021
*/
			rts

//------------------------------------------------------------------------------------------------------------------------------------------------------

irq0:		dec $00
			sta irq0A+1
			:compensateForJitter(1)
			stx irq0X+1
			sty irq0Y+1
			asl $d019
		
			nop $ea				//60-62		-----
			lda #<ZPTab+$40-1	//00-01		-----	Initialize ZPTab
			sta ir01+1			//02-05		-----
ir00:		inc ir01+1			//06-11		26-31
ir01:		lax ZPTab+$40		//12-14		32-34	Color table is on ZP now
			ldy SizeTab,x		//15-18		35-38
			eor EORTab,y		//19-22		39-42
			sta ir03+1			//23-26		43-46
			lda ColorEOR,y		//27-30		47-50
			sta ir04+1			//31-34		51-54
			lda D018Tab,y		//35-38		55-58
			sta ir02+1			//39-42		59-62
			lda D016Tab,y		//43-46		00-03
			ldx DD02Tab,y		//47-50		04-07
ir02:		ldy #$f0			//51-52		08-09
			sta $d016			//53-56		10-56
			stx $dd02			//57-60		57-60
			sty $d018			//61-01		61-01
ir03:		lda #$01			//02-03		02-03
			sta $d022			//04-07		04-07
ir04:		eor #$06			//08-09		08-09
			sta $d023			//10-13		10-13
			nop $ea				//14-16		14-16
			lda ir01+1			//17-20		17-20
			and #$03			//21-22		21-22
			beq	ir00			//23-24		23-25
			lda ir01+1			//25-28
			cmp #<ZPTab+$40+$65	//29-30
			beq ir0x			//31-32
			jsr DELAY			//33.02		(33 cycles)
			jmp ir00			//03-05
ir0x:
			inc $00
			lda $01
			sta irq01+1
			lda #$35
			sta $01

			lda #$00
			sta $d012
			lda #<irqmsc
			sta $fffe
			lda #>irqmsc
			sta $ffff
			cli
			
			jsr CalcX
			jsr CalcY2
			lda irm01+1
			cmp #<irq0
			bne !+
			jsr DrawPhase2

!:			inc FrameLo
			bne NotDone0
			dec FrameHi
NotDone0:
irq01:		lda #$00
			sta $01
irq0Y:		ldy #$00
irq0X:		ldx #$00
irq0A:		lda #$00
			
			rti

//--------------------------------------

irq1:		dec $00
			sta irq1A+1
			:compensateForJitter(1)
			stx irq1X+1
			sty irq1Y+1
			asl $d019
		
			nop $ea				//60-62		-----
			lda #<ZPTab+$40-1	//00-01		-----	Initialize ZPTab
			sta ir11+1			//02-05		-----
ir10:		inc ir11+1			//06-11		26-31
ir11:		lax ZPTab+$40		//12-14		32-34	Color table is on ZP now
			ldy SizeTab,x		//15-18		35-38
			eor EORTab,y		//19-22		39-42
			sta ir13+1			//23-26		43-46
			lda ColorEOR,y		//27-30		47-50
			sta ir14+1			//31-34		51-54
			lda D018Tab,y		//35-38		55-58
			sta ir12+1			//39-42		59-62
			lda D016Tab,y		//43-46		00-03
			ldx DD02Tab,y		//47-50		04-07
ir12:		ldy #$f0			//51-52		08-09
			sta $d016			//53-56		10-56
			stx $dd02			//57-60		57-60
			sty $d018			//61-01		61-01
ir13:		lda #$01			//02-03		02-03
			sta $d022			//04-07		04-07
ir14:		eor #$06			//08-09		08-09
			sta $d023			//10-13		10-13
			nop $ea				//14-16		14-16
			lda ir11+1			//17-20		17-20
			and #$03			//21-22		21-22
			beq	ir10			//23-24		23-25
			lda ir11+1			//25-28
			cmp #<ZPTab+$40+$65	//29-30
			beq ir1x			//31-32
			jsr DELAY			//33.02		(33 cycles)
			jmp ir10			//03-05
ir1x:
			inc $00
			lda $01
			sta irq11+1
			lda #$35
			sta $01

			lda #$00
			sta $d012
			lda #<irqmsc
			sta $fffe
			lda #>irqmsc
			sta $ffff
			cli
			
			lda dp10
			cmp	 #$60			//Skip updating X and Y scroll values if only the bottom layer is shown to avoid screen flickering
			beq !+
			jsr CalcX
			jsr CalcY
!:			jsr DrawPhase

			lda FrameHi
			cmp #<FrameHiMax
			bne SkipFI
			
			jsr FadeIn

SkipFI:		cmp #$01
			bne SkipFO
			//:BranchIfNotFullDemo(NotDone1)

			jsr FadeOut

SkipFO:		inc FrameLo
			bne NotDone1
			dec FrameHi
			bne NotDone1
			//:BranchIfNotFullDemo(NotDone1)
			lda #$01
			sta PART_Done
			lda #$7b
			sta $d011
NotDone1:
irq11:		lda #$00
			sta $01
irq1Y:		ldy #$00
irq1X:		ldx #$00
irq1A:		lda #$00
			
			rti

//--------------------------------------

irqmsc:		dec $00
			sta irqmscA+1
			
d020:		lda #$00
			sta $d020
d022:		lda #$00
			sta $d022
d023:		lda #$00
			sta $d023

			lda #$3e
			sta $dd02
			lda #$10
			sta $d018
			
			stx irqmscX+1
			sty irqmscY+1
			
			asl $d019

			jsr BASE_PlayMusic

Outro:		lda #$01
			bne InX

OutX:		lda #$00
			cmp #$12
			bcc NextCol

			sta PART_Done
			bcs irqmscY

NextCol:	lsr
			tax
			lda Col20+1,x
			sta d020+1
			lda Col22+1,x
			sta d022+1
			lda Col23+1,x
			sta d023+1
			inc OutX+1
			bpl irqmscY

InX:		lda #$0f
			bmi IntroDone
			lsr
			tax
			lda Col20,x
			sta d020+1
			lda Col22,x
			sta d022+1
			lda Col23,x
			sta d023+1
			dec InX+1
			bpl irqmscY

IntroDone:	lda #$00
			beq irqmscY

			lda #$30
			sta $d012
irm01:		lda #<irq0
			sta $fffe
irm02:		lda #>irq0
			sta $ffff

irqmscY:	ldy #$00
irqmscX:	ldx #$00
irqmscA:	lda #$00
			
			inc $00
			rti

//--------------------------------------

DELAY:		pha			//39-41
			pla			//42-45
			pha			//46-48
			pla			//49-52
			pha			//53-55
			pla			//56-59
			rts			//60-02

//--------------------------------------

FadeIn:		lda FrameLo
			cmp #$38
			bcs fi0x
			lsr
			lsr
			lsr
			tax
			
			lda JmpLo+1,x
			sta fi00+1
			lda JmpHi+1,x
			sta fi00+2
			lda #OPC_JMP
fi00:		sta $c0de
fi0x:		rts


//--------------------------------------

FadeOut:	lda FrameLo
			cmp #$d8
			bcc FONotDone
			ldx #$00
			stx IntroDone+1
			stx Outro+1
	FONotDone:
			cmp	#$a0
			bcc fo0x
			adc #$1f
			alr #$3f
			lsr
			lsr
			eor #$07
			tax
			
			lda JmpLo,x
			sta fo00+1
			lda JmpHi,x
			sta fo00+2
			lda #OPC_RTS
fo00:		sta $c0de
fo0x:		rts

//--------------------------------------

CalcX:
dx00:		ldx #$c0

dx01:		lda XSinTabLo,x
			sta DeltaXLo+7
			sta Tmp
dx02:		lda XSinTabHi,x
			sta DeltaXHi+7		// 8/8
			
			cmp #$80
			ror
			sta DeltaXHi+3		// 4/8
			ror Tmp
			ldx Tmp
			stx DeltaXLo+3
			
			cmp #$80
			ror
			sta DeltaXHi+1		// 2/8
			ror Tmp
			ldx Tmp
			stx DeltaXLo+1
			
			cmp #$80
			ror
			sta DeltaXHi+0		// 1/8
			ror Tmp
			ldx Tmp
			stx DeltaXLo+0
			
			txa
			clc
			adc DeltaXLo+1
			lda DeltaXHi+0
			adc DeltaXHi+1
			sta DeltaXHi+2		// 3/8
			
			txa
			clc
			adc DeltaXLo+3
			lda DeltaXHi+0
			adc DeltaXHi+3
			sta DeltaXHi+4		// 5/8
			
			lda DeltaXLo+1
			clc
			adc DeltaXLo+3
			tay
			lda DeltaXHi+1
			adc DeltaXHi+3
			sta DeltaXHi+5		// 6/8
			
			tya
			clc
			adc DeltaXLo+0
			lda DeltaXHi+5
			adc DeltaXHi+0
			sta DeltaXHi+6		// 7/8

Size0:		lda ScrollX+0
			clc
			adc DeltaXHi+0
			and #$07
			sta ScrollX+0
			ora #$d0
			sta D016Tab+0

Size1:		lda ScrollX+1
			clc
			adc DeltaXHi+1
			and #$07
			sta ScrollX+1
			ora #$d0
			sta D016Tab+1

Size2:		lda ScrollX+2
			clc
			adc DeltaXHi+2
			bpl	cx22			//
cx20:		tax
			lda EORTab+2
			eor ColorEOR+2
			sta EORTab+2
			txa
			clc
			adc #(<PatternSize2*2)
			bmi cx20			//
			bpl cx23			//
cx21:		tax
			lda EORTab+2
			eor ColorEOR+2
			sta EORTab+2
			txa
			sec
			sbc #(<PatternSize2*2)
cx22:		cmp #(<PatternSize2*2)
			bcs cx21			//
cx23:		sta ScrollX+2
			ora #$d0
			sta D016Tab+2

Size3:		lda ScrollX+3
			clc
			adc DeltaXHi+3
			bpl	cx32			//
cx30:		tax
			lda EORTab+3
			eor ColorEOR+3
			sta EORTab+3
			txa
			clc
			adc #(<PatternSize3*2)
			bmi cx30			//
			bpl cx33			//
cx31:		tax
			lda EORTab+3
			eor ColorEOR+3
			sta EORTab+3
			txa
			sec
			sbc #(<PatternSize3*2)
cx32:		cmp #(<PatternSize3*2)
			bcs cx31			//
cx33:		sta ScrollX+3
			ora #$d0
			sta D016Tab+3

Size4:		lda ScrollX+4
			clc
			adc DeltaXHi+4
			bpl	cx42			//
cx40:		tax
			lda EORTab+4
			eor ColorEOR+4
			sta EORTab+4
			txa
			clc
			adc #(<PatternSize4*2)
			bmi cx40			//
			bpl cx43			//
cx41:		tax
			lda EORTab+4
			eor ColorEOR+4
			sta EORTab+4
			txa
			sec
			sbc #(<PatternSize4*2)
cx42:		cmp #(<PatternSize4*2)
			bcs cx41			//
cx43:		ldx #VICBank1
			cmp #$08
			bcc cx44			//
			ldx #VICBank3
cx44:		stx DD02Tab+4
			sta ScrollX+4
			and #$07
			ora #$d0
			sta D016Tab+4

Size5:		lda ScrollX+5
			clc
			adc DeltaXHi+5
			bpl	cx52			//
cx50:		tax
			lda EORTab+5
			eor ColorEOR+5
			sta EORTab+5
			txa
			clc
			adc #(<PatternSize5*2)
			bmi cx50			//
			bpl cx53			//
cx51:		tax
			lda EORTab+5
			eor ColorEOR+5
			sta EORTab+5
			txa
			sec
			sbc #(<PatternSize5*2)
cx52:		cmp #(<PatternSize5*2)
			bcs cx51			//
cx53:		ldx #VICBank1
			cmp #$08
			bcc cx54			//
			ldx #VICBank3
cx54:		stx DD02Tab+5
			sta ScrollX+5
			and #$07
			ora #$d0
			sta D016Tab+5

Size6:		lda ScrollX+6
			clc
			adc DeltaXHi+6
			bpl	cx62			//
cx60:		tax
			lda EORTab+6
			eor ColorEOR+6
			sta EORTab+6
			txa
			clc
			adc #(<PatternSize6*2)
			bmi cx60			//
			bpl cx63			//
cx61:		tax
			lda EORTab+6
			eor ColorEOR+6
			sta EORTab+6
			txa
			sec
			sbc #(<PatternSize6*2)
cx62:		cmp #(<PatternSize6*2)
			bcs cx61			//
cx63:		ldx #VICBank1
			cmp #$08
			bcc cx64			//
			ldx #VICBank3
cx64:		stx DD02Tab+6
			sta ScrollX+6
			and #$07
			ora #$d0
			sta D016Tab+6

Size7:		lda ScrollX+7
			clc
			adc DeltaXHi+7
			bpl	cx72			//
cx70:		tax
			lda EORTab+7
			eor ColorEOR+7
			sta EORTab+7
			txa
			clc
			adc #(<PatternSize7*2)
			bmi cx70			//
			bpl cx73			//
cx71:		tax
			lda EORTab+7
			eor ColorEOR+7
			sta EORTab+7
			txa
			sec
			sbc #(<PatternSize7*2)
cx72:		cmp #(<PatternSize7*2)
			bcs cx71			//
cx73:		ldx #VICBank1
			cmp #$08
			bcc cx74			//
			ldx #VICBank3
cx74:		stx DD02Tab+7
			sta ScrollX+7
			and #$07
			ora #$d0
			sta D016Tab+7

cx80:		lda #$00
			eor #$01
			sta cx80+1
			bne cx0x
			inc dx00+1

cx0x:		rts

//--------------------------------------

CalcY:		lda SYLo
			clc
			adc DYLo
			sta SYLo
			lda SYHi
			adc DYHi
			cmp #(<PatternSize7*4)
			bne *+4
			sbc #(<PatternSize7*8)
			sta SYHi

cy00:		ldx #$00			//Add sine wave
			lda YSinTabLo,x
			clc
			adc SYLo
			sta Tmp
			lda YSinTabHi,x
			adc SYHi
			bpl cy01
			cmp #$100-(<PatternSize7*4)
			bcs cy02
			adc #(<PatternSize7*8)
			jmp cy02
cy01:		cmp #(<PatternSize7*4)
			bcc cy02
			sbc #(<PatternSize7*8)
cy02:		sta ScrollYHi+7		// 8/8
			
			cmp #$80
			ror
			sta ScrollYHi+3		// 4/8
			ror Tmp
			ldx Tmp
			stx ScrollYLo+3
			
			cmp #$80
			ror
			sta ScrollYHi+1		// 2/8
			ror Tmp
			ldx Tmp
			stx ScrollYLo+1
			
			cmp #$80
			ror
			sta ScrollYHi+0		// 1/8
			ror Tmp
			ldx Tmp
			stx ScrollYLo+0
			
			txa
			clc
			adc ScrollYLo+1
			lda ScrollYHi+0
			adc ScrollYHi+1
			sta ScrollYHi+2		// 3/8
			
			txa
			clc
			adc ScrollYLo+3
			lda ScrollYHi+0
			adc ScrollYHi+3
			sta ScrollYHi+4		// 5/8
			
			lda ScrollYLo+1
			clc
			adc ScrollYLo+3
			tay
			lda ScrollYHi+1
			adc ScrollYHi+3
			sta ScrollYHi+5		// 6/8
			
			tya
			clc
			adc ScrollYLo+0
			lda ScrollYHi+5
			adc ScrollYHi+0
			sta ScrollYHi+6		// 7/8

			ldx cy00+1
			inx
			cpx #<YSinTabSize
			bne *+4
			ldx #$00
			stx cy00+1

cy0x:		rts

//--------------------------------------

CalcY2:		lda FrameHi
			cmp #<FrameHiMax+1
			bne cy22

cy20:		ldx #$12
			cpx #$58
			beq	cy22

			ldy #$07
cy21:		lda YSinTab2FI,x
			sta ScrollYHi,y
			txa
			axs #$03
			dey
			bpl cy21
			inc cy20+1
			rts

cy22:		ldx #$47
			cpx #$c7
			bne !+
			cmp #<FrameHiMax+1
			bcc cy24

!:			ldy #$07
cy23:		lda YSinTab2,x
			sta ScrollYHi,y
			txa
			axs #$04
			dey
			bpl cy23
			inc cy22+1
			rts

cy24:		ldx #$b8
			ldy #$07
cy25:		lda YSinTab2FI,x
			sta ScrollYHi,y
			txa
			axs #$03
			dey
			bpl cy25
			inc cy24+1
			lda cy24+1
			cmp #$fc
			bne cy2x
			lda #OPC_ZPX
			jsr ModifyPatterns
			lda #<irq1
			sta irm01+1
			lda #>irq1
			sta irm02+1
			lda #$00
			sta FrameLo
			lda #<FrameHiMax
			sta FrameHi
			lda #<OPC_RTS
			sta dp10
			sta dp20
			sta dp30
			sta dp40
			sta dp50
			sta dp60
			sta dp70
cy2x:		rts

//--------------------------------------

DrawPhase:	ldx #<Color0A
			lda #<Color0B
			//ldy #$00
			//lda ScrollYHi+0
			//and #$01
			//beq *+6
			//ldx #$00
			//ldy #$09
			//tya
			jsr DrawPattern0
			
			lda #$32-(<PatternSize1*2)
			sec
			sbc ScrollYHi+1
			sec
			sbc #(<PatternSize1*8)
			bcs *-2
			tax
			lda #<Color1A
			jsr dp10
			txa
			axs #$100-<PatternSize1
			lda #<Color1B
			jsr dp10

			lda #$32-(<PatternSize2*2)
			sec
			sbc ScrollYHi+2
			sec
			sbc #(<PatternSize2*8)
			bcs *-2
			tax
			lda #<Color2A
			jsr dp20
			txa
			axs #$100-<PatternSize2
			lda #<Color2B
			jsr dp20

			lda #$32-(<PatternSize3*2)
			sec
			sbc ScrollYHi+3
			sec
			sbc #(<PatternSize3*8)
			bcs *-2
			tax
			lda #<Color3A
			jsr dp30
			txa
			axs #$100-<PatternSize3
			lda #<Color3B
			jsr dp30

			lda #$32-(<PatternSize4*2)
			sec
			sbc ScrollYHi+4
			sec
			sbc #(<PatternSize4*8)
			bcs *-2
			tax
			lda #<Color4A
			jsr dp40
			txa
			axs #$100-<PatternSize4
			lda #<Color4B
			jsr dp40

			lda #$32-(<PatternSize5*2)
			sec
			sbc ScrollYHi+5
			sec
			sbc #(<PatternSize5*8)
			bcs *-2
			tax
			lda #<Color5A
			jsr dp50
			txa
			axs #$100-<PatternSize5
			lda #<Color5B
			jsr dp50

			lda #$32-(<PatternSize6*2)
			sec
			sbc ScrollYHi+6
			sec
			sbc #(<PatternSize6*8)
			bcs *-2
			tax
			lda #<Color6A
			jsr dp60
			txa
			axs #$100-<PatternSize6
			lda #<Color6B
			jsr dp60

			lda #$32-(<PatternSize7*2)
			sec
			sbc ScrollYHi+7
			sec
			sbc #(<PatternSize7*8)
			bcs *-2
			tax
			lda #<Color7A
			jsr dp70
			txa
			axs #$100-<PatternSize7
			lda #<Color7B
			jsr dp70
			rts

dp00:		jmp $c0de
dp10:		jmp $c0de
dp20:		jmp $c0de
dp30:		jmp $c0de
dp40:		jmp $c0de
dp50:		jmp $c0de
dp60:		jmp $c0de
dp70:		jmp $c0de

JmpLo:
.byte <dp00, <dp10, <dp20, <dp30, <dp40, <dp50, <dp60, <dp70
JmpHi:
.byte >dp00, >dp10, >dp20, >dp30, >dp40, >dp50, >dp60, >dp70

//--------------------------------------

DrawPhase2:
			ldx #<Color0A
			lda #<Color0B
			jsr DrawPattern0

			lax ScrollYHi+1
			axs #<PatternSize1*2
			lda #<Color1A
			jsr dp10
			txa
			axs #$100-<PatternSize1
			lda #<Color1B
			jsr dp10

			lax ScrollYHi+2
			axs #<PatternSize2*2
			lda #<Color2A
			jsr dp20
			txa
			axs #$100-<PatternSize2
			lda #<Color2B
			jsr dp20

			lax ScrollYHi+3
			axs #<PatternSize3*2
			lda #<Color3A
			jsr dp30
			txa
			axs #$100-<PatternSize3
			lda #<Color3B
			jsr dp30

			lax ScrollYHi+4
			axs #<PatternSize4*2
			lda #<Color4A
			jsr dp40
			txa
			axs #$100-<PatternSize4
			lda #<Color4B
			jsr dp40

			lax ScrollYHi+5
			axs #<PatternSize5*2
			lda #<Color5A
			jsr dp50
			txa
			axs #$100-<PatternSize5
			lda #<Color5B
			jsr dp50

			lax ScrollYHi+6
			axs #<PatternSize6*2
			lda #<Color6A
			jsr dp60
			txa
			axs #$100-<PatternSize6
			lda #<Color6B
			jsr dp60

			lax ScrollYHi+7
			axs #<PatternSize7*2
			lda #<Color7A
			jsr dp70
			txa
			axs #$100-<PatternSize7
			lda #<Color7B
			jsr dp70
			rts

//------------------------------------------------------------------------------------------------------------------------------------------------------

CreateInitScreen:
			lda #$08
			ldx #$fa
!:			dex
			sta $d800,x
			sta $d8fa,x
			sta $d9f4,x
			sta $daee,x
			bne !-

			txa
!:			sta $8400,x
			sta $8500,x
			sta $8600,x
			sta $8700,x
			inx
			bne !-

			lda #$99
			sta $8000
			sta $8003
			sta $8004
			sta $8007
			lda #$66
			sta $8001
			sta $8002
			sta $8005
			sta $8006

			rts

CreateScreens:

			ldx #$4f
			lda #$99				//Charset02 is generated in a simple loop here
!:			sta Charset02,x
			sta Charset02+$50,x
			sta Charset02+$a0,x
			sta Charset02+$f0,x
			dex
			bpl !-

			lda #>ScreenA
			jsr CreateScreen
			lda #>ScreenB
CreateScreen:
			sta ZP+1
			lda #$00
			sta ZP
			ldx #$18
cs00:		ldy #$27
!:			tya
			sta (ZP),y
			dey
			bpl !-
			lda #$28
			jsr AddZP
			dex
			bpl cs00
			rts

//--------------------------------------

CreateCharsets:
			ldx #$4f				//Charset04 is generated in a simple loop here
			lda #$a5
!:			sta Charset04,x
			sta Charset04+$50,x
			sta Charset04+$a0,x
			sta Charset04+$f0,x
			dex
			bpl !-

			lda #<Charset16A
			ldy #>Charset16A
			ldx #<PatternSize7
			jsr NextCharset

			lda #>Charset16A
			ldx #(<PatternSize7-1)*8
			jsr CopyAtoB
			
			lda #<Charset14A
			ldy #>Charset14A
			ldx #<PatternSize6
			jsr NextCharset

			lda #>Charset14A
			ldx #(<PatternSize6-1)*8
			jsr CopyAtoB
			
			lda #<Charset12A
			ldy #>Charset12A
			ldx #<PatternSize5
			jsr NextCharset

			lda #>Charset12A
			ldx #(<PatternSize5-1)*8
			jsr CopyAtoB
			
			lda #<Charset10A
			ldy #>Charset10A
			ldx #<PatternSize4
			jsr NextCharset

			lda #>Charset10A
			ldx #(<PatternSize4-1)*8
			jsr CopyAtoB
			
			lda #<Charset08
			ldy #>Charset08
			ldx #<PatternSize3
			jsr NextCharset
			
			lda #<Charset06
			ldy #>Charset06
			ldx #<PatternSize2

			//jsr NextCharset

			//lda #<Charset04
			//ldy #>Charset04
			//ldx #<PatternSize1

			//lda #<Charset02
			//ldy #>Charset02
			//ldx #<PatternSize0
			//jsr NextCharset

NextCharset:
			sta ZP
			sty ZP+1
			stx Tmp
			lda #$28
			sta Tmp2
			lda #$02
			sta NextPixel+1
nc00:		ldy #$04
			lda #$00
nc01:		asl
			asl
NextPixel:	ora #$02
			dex
			bne !+
			pha
			lda NextPixel+1
			eor #$03
			sta NextPixel+1
			ldx Tmp
			pla
!:			dey
			bne nc01
			sta (ZP),y
			lda #$08
			jsr AddZP
			dec Tmp2
			bne nc00

			lda ZP
			sec
			sbc #$40
			sta ZP
			lda ZP+1
			sbc #$01
			sta ZP+1

			ldx #$28
nc02:		ldy #$00
			lda (ZP),y
!:			iny
			sta (ZP),y
			cpy #$07
			bne !-
			lda #$08
			jsr AddZP
			dex
			bpl nc02
			rts

AddZP:		clc
			adc ZP
			sta ZP
			bcc *+5
			inc ZP+1
			clc
			rts

CopyAtoB:	dec $01

			sta ZP+1
			ora #$80
			sta ZP2+1

			lda #$00
			sta ZP
			lda #$08
			sta ZP2
			
			ldy #$00
!:			lda (ZP),y
			sta (ZP2),y
			iny
			bne !-

			inc ZP+1
			inc ZP2+1

			ldy #$37
!:			lda (ZP),y
			sta (ZP2),y
			dey
			bpl !-
			
			stx ZP
			dec ZP+1
		
			lda #$00
			sta ZP2
			dec ZP2+1

			ldy #$07
!:			lda (ZP),y
			sta (ZP2),y
			dey
			bpl !-
			inc $01
			rts

//--------------------------------------

CreatePatterns:

cp00:		lda #<DrawPattern0
			sta ZP
			lda #>DrawPattern0
			sta ZP+1
			ldx #$33
cp01:		ldy #<pb0x-pb00
cp02:		lda pb00,y
			sta (ZP),y
			dey
			bpl cp02
			lda #<pb0x-pb00
			jsr AddZP
			lda pb00+1
			clc
			adc #$02
			sta pb00+1
			lda pb01+1
			clc
			adc #$02
			sta pb01+1
			dex
			bne cp01
			lda #$01
			jsr AddZP

			lda ZP
			sta dp10+1
			lda ZP+1
			sta dp10+2
			ldy #$08
			lda #<PatternSize1
			jsr NextPattern

			lda ZP
			sta dp20+1
			lda ZP+1
			sta dp20+2
			ldy #$05
			lda #<PatternSize2
			jsr NextPattern

			lda ZP
			sta dp30+1
			lda ZP+1
			sta dp30+2
			ldy #$05
			lda #<PatternSize3
			jsr NextPattern

			lda ZP
			sta dp40+1
			lda ZP+1
			sta dp40+2
			ldy #$04
			lda #<PatternSize4
			jsr NextPattern

			lda ZP
			sta dp50+1
			lda ZP+1
			sta dp50+2
			ldy #$04
			lda #<PatternSize5
			jsr NextPattern

			lda ZP
			sta dp60+1
			lda ZP+1
			sta dp60+2
			ldy #$03
			lda #<PatternSize6
			jsr NextPattern

			lda ZP
			sta dp70+1
			lda ZP+1
			sta dp70+2
			ldy #$03
			lda #<PatternSize7

NextPattern:
			ldx #<ZPTab+$40
			stx pb0+1
			sty Tmp
			sta np01+1
			sta np02+1
			asl
			sta np00+1
			asl
			clc
			adc np01+1
			sta np05+1
np00:		ldx #$0a
np01:		cpx #$05
			bne np03
			lda pb0+1
			clc
np02:		adc #$05
			sta pb0+1
np03:		ldy #<pbx-pb0
np04:		lda pb0,y
			sta (ZP),y
			dey
			bpl np04
			lda #<pbx-pb0
			jsr AddZP
			inc pb0+1
			dex
			bne np01
			lda pb0+1
			clc
np05:		adc #$14
			sta pb0+1
			dec Tmp
			bne np00
			lda #$01
			jsr AddZP
			rts

PatternBase0:
pb00:		sta.z ZPTab+$40				//AXAXAXAX
pb01:		stx.z ZPTab+$41
pb0x:		rts

PatternBase:
pb0:		sta.z ZPTab+$40,x
pbx:		rts

//--------------------------------------

CreatePatternMod:
			ldx OPC_RTS
			lda dp10+1
			clc
			adc #(<PatternSize1*4)
			sta mp01+1
			lda dp10+2
			adc #$00
			sta mp01+2

			lda dp20+1
			clc
			adc #(<PatternSize2*4)
			sta mp02+1
			lda dp20+2
			adc #$00
			sta mp02+2

			lda dp30+1
			clc
			adc #(<PatternSize3*4)
			sta mp03+1
			lda dp30+2
			adc #$00
			sta mp03+2

			lda dp40+1
			clc
			adc #(<PatternSize4*4)
			sta mp04+1
			lda dp40+2
			adc #$00
			sta mp04+2

			lda dp50+1
			clc
			adc #(<PatternSize5*4)
			sta mp05+1
			lda dp50+2
			adc #$00
			sta mp05+2

			lda dp60+1
			clc
			adc #(<PatternSize6*4)
			sta mp06+1
			lda dp60+2
			adc #$00
			sta mp06+2

			lda dp70+1
			clc
			adc #(<PatternSize7*4)
			sta mp07+1
			lda dp70+2
			adc #$00
			sta mp07+2
			rts

ModifyPatterns:
mp01:		sta $c0de
mp02:		sta $c0de
mp03:		sta $c0de
mp04:		sta $c0de
mp05:		sta $c0de
mp06:		sta $c0de
mp07:		sta $c0de
			rts

//--------------------------------------

//Colors1: $09,$02,$04,$08,$0a,$03,$0d,$07
//Colors2: $00,$06,$0b,$0e,$0c,$05,$0f,$01

//Actual table starts at ShiftedColors+$40. This allows avoiding page crossing.
//Put ShiftedColors to ZP (e.g. $20-$c4, incl. $20-$20 bytes buffer on each side), this saves 25% on CPU cycles
//
//PatternBase0 (1px):	repeat x 51		102*3  cycles	306 cycles
//PatternBase1 (8*2px):	repeat x 8		8*8*4  cycles	256 cycles
//PatternBase2 (8*3px):	repeat x 5		5*12*4 cycles	240 cycles
//PatternBase3 (8*4px):	repeat x 5		5*16*4 cycles	320 cycles
//PatternBase4 (8*5px):	repeat x 4		4*20*4 cycles	320 cycles
//PatternBase5 (8*6px):	repeat x 4		4*24*4 cycles	384 cycles
//PatternBase6 (8*7px):	repeat x 3		3*28*4 cycles	336 cycles
//PatternBase7 (8*8px):	repeat x 3		3*32*4 cycles	384 cycles
//												Total:	2546 cycles = 40 raster lines
//TODO:Patterns4-7: calculate jump in and out to save on CPU cycles.

//--------------------------------------

.align $100
XSinTabHi:
.fill $100,$160 * sin(toRadians((i + 0.5) * 360 / 256)) - $160 * sin(toRadians((i - 0.5) * 360 / 256))

//--------------------------------------

XSinTabLo:
.fill $100,mod($16000 * sin(toRadians((i + 0.5) * 360 / 256)) - $16000 * sin(toRadians((i - 0.5) * 360 / 256)), 256)

//--------------------------------------

YSinTab2:
.fill $100, $32 + $32 * cos(toRadians((i + 0.5) * 360 / 128))

//--------------------------------------

YSinTab2FI:
.fill $a0, $42 + $42 * cos(toRadians((i + 0.5) * 360 / $a0))
.fill $60, $42 + $42 * cos(toRadians((i - 95.5) * 360 / $a0))

Col20:
.byte $04,$0e,$03,$0d,$03,$0e,$04,$0b,$06,$00
Col22:
.byte $00,$06,$0b,$04,$0c,$0f,$0c,$0b,$06,$00
Col23:
.byte $09,$08,$02,$0c,$0f,$0c,$04,$0b,$06,$00

//--------------------------------------
.align $100

YSinTabHi:
.fill YSinTabSize,((($6000 + $5600 * sin(toRadians(i * 360 / YSinTabSize))) & $3fff) - $2000) / 256

//--------------------------------------

.align $100
YSinTabLo:
.fill YSinTabSize,mod(((($6000 + $5600 * sin(toRadians(i * 360 / YSinTabSize))) & $3fff) - $2000), 256)

//--------------------------------------

.align $100

//XX00
SizeTab:
.byte $00,$07,$01,$05,$02,$05,$01,$07,$03,$00,$04,$02,$04,$06,$03,$06

//XX10
D018Tab:
.byte $fe,$fc,$fa,$f8,$f6,$f4,$f2,$f0

//XX18
D016Tab:
.fill 8, $d0

//XX20
DD02Tab:
.fill 8, VICBank1

//XX28
EORTab:
.fill 8,$00

//XX30
ColorEOR:
.byte Color0A^Color0B,Color1A^Color1B,Color2A^Color2B,Color3A^Color3B,Color4A^Color4B,Color5A^Color5B,Color6A^Color6B,Color7A^Color7B

//XX38
ScrollX:
.fill 8,$00

//XX40
DeltaXHi:
.fill 8,$00

//XX48
DeltaXLo:
.fill 8,$00

//XX50
ScrollYLo:
.fill 8,0

//XX58
ScrollYHi:
.fill 8,0

//XX60
SYLo:
.byte $00

//XX61
SYHi:
.byte $e0

//XX62
DYLo:
.byte $00

//XX63
DYHi:
.byte $01

//XX64
DrawPattern0: