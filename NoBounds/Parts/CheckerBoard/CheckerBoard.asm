
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
//	2000	2500	Main Code + SinTab
//	2500	4000	-UNUSED-

//	4000	4400	Screen0
//	4400	4800	Charset
//	4800	4c00	IntroScreen
//	4c00	5000	-UNUSED-
//	5000	5400	Screen1
//	5400	6000	-UNUSED-
//	6000	6400	Screen2
//	6400	7000	-UNUSED-
//	7000	7400	Screen3
//	7400	8000	Logo Sprites

//	8000	bc00	ShiftedData
//	bc00	bd00	RandomTab
//	bd00	be00	FliTabLo
//	be00	bf00	FliTabHi
//	bf00	e000	-UNUSED-
//	e000	f1d1	BlitCode
//	f200	fca1	FliCode
//	fca2	ffff	-UNUSED-
//
//---------------------------------


.const ZP			= $10
.const Tmp			= $12
.const Tmp2			= $13
.const FrameLo		= $14
.const FrameHi		= $15
.const SpSwap		= $16

.const IRQJmp		= $20

.const SpriteCol1	= $00		//Darkest
.const MCCol1		= $0b		//Dark
.const MCCol2		= $0c		//Bright
.const SpriteCol2	= $0f		//Brightest

.const Screen0		= $4000
.const Screen1		= $5000
.const Screen2		= $6000
.const Screen3		= $7000
.const IntroScreen	= $4800

.const Charset		= $4000		//$4400-$7ff
.const Sprites		= $7400
//.const SpPtrBkg		= ((Sprites + $000) & $3fff)/$40
.const SpPtrNoB		= ((Sprites + $200) & $3fff)/$40
.const SpPtrPrj		= ((Sprites + $400) & $3fff)/$40
.const SpPtrGen		= ((Sprites + $600) & $3fff)/$40
//.const SpPtrDel		= ((Sprites + $800) & $3fff)/$40
//.const SpPtrNoL		= ((Sprites + $a00) & $3fff)/$40

.const BlitCode		= $e000
.const FliCode		= $f200
.const ShiftedData	= $8000		//$3c00 bytes, the frist $1400 are used to create the remaining $2800
.const RandomTab	= $bc00
.const FliTabLo		= $bd00
.const FliTabHi		= $be00

.const FrameHiMax	= $03
.const FliLines		= $c2

* = $2000

CheckerBoard_Go:

			jsr SetupScreen
			jsr CreateBlitCode
			jsr CreateFliCode
			//jsr CreateSineTable
			jsr CreateShiftedData

			ldx #$00
			lda #$0e		//#$0e, #$08
s4:			sta $d800,x
			sta $d900,x
			sta $da00,x
			sta $dae8,x
			inx
			bne s4

			lsr PART_Done
			bcc *-3

			:BranchIfNotFullDemo(SkipSync)
			MusicSync(SYNC_CheckerWipeIn-1)
SkipSync:
			
			vsync()
			
			lda #$3d
			sta $dd02
			//lda #$0a		//#$0a, #$0d
			//sta $d021
			lda #$0c		//#$0c, #$05
			sta $d022
			lda #$09		//#$09, #$09
			sta $d023

			lda #$00
			sta FrameLo
			sta SpSwap
			lda #FrameHiMax
			sta FrameHi

			lda #$2a
			sta $d001
			//lda #$07+$18
			//sta $d00e
			//lda #<SpPtrGen
			//sta IntroScreen+$3f8

			lda #$1b
			sta $d011
			lda #$31
			sta $d012
			lda #<irq
			sta $fffe
			lda #>irq
			sta $ffff

			rts

//----------------------------------

irq:		dec $00
			sta ira+1
			:compensateForJitter(3)
			stx irx+1		//44-47
			sty iry+1		//48-51
			asl $d019		//52..62
							//54-56 Write cycles only
							//57-58 Sprite 0 fetch
ird011:		lda #$7b		//00-01
			sta $d011		//02-05
ir00:		ldy #$10		//06-07
			ldx #$c0		//08-09
			lda SinTab,y	//10-13
			sax $d018		//14-17
			sta $d016		//18-21
			nop				//22-23 Wasting 41 cycles 
			nop				//24-25
			nop				//26-27
			pha				//28-30
			pla				//31-34
			pha				//35-37
			pla				//38-41
			pha				//42-44
			pla				//45-48
			pha				//49-51
			pla				//52..60
							//54-56 Write cycles only
							//57-58 Sprite 0 fetch
			pha				//61-00
			pla				//01-04
			jsr FliCode+5	//05-10 Skip first $d011 write, we are in a badline, so the VIC-II takes care of it
			iny
			bpl *+4
			ldy #$00
			sty ir00+1
			
			lda #$1b
			sta ird011+1

			jsr SwapSprites

ir01:		ldx #$00
			jsr BlitCode
			dex
			bpl !+
			ldx #$4f
!:			stx ir01+1
			
			lda #$0a
			sta $d021
			
			jsr BASE_PlayMusic

			lda FrameHi
			cmp #<FrameHiMax
			bne SkipFadeIn

			ldx FrameLo
			cpx #<FliLines
			bcs SkipFadeIn
			jsr ToggleD011
			cpx #<FliLines-1
			bne SkipFadeIn
			ldx #<FliLines-1+$10
			stx FrameLo

SkipFadeIn:
			inc FrameLo
			bne SkipFrmHi
			dec FrameHi

SkipFrmHi:	lda FrameHi
			cmp #$01
			bne Not1
			ldx FrameLo
			cpx #$ef
			bne irend
			ldx #$ff
			stx FrameLo
			jmp irend

Not1:		//lda FrameHi
			cmp #$00
			bne irend

			//:BranchIfNotFullDemo(irend)

FadeOut:	ldy FrameLo
			cpy #FliLines
			bcs done
/*			cpy #(<FliLines - $10)
			bcc SkipSpFO
			tya
			sec
			sbc #(<FliLines - $10)
			tax
			lda DarkestFO,x
			sta $d027
			sta $d028
			sta $d02d
			sta $d02e
			lda BrightestFO,x
			sta $d029
			sta $d02a
			sta $d02b
			sta $d02c
			lda DarkFO,x
			sta $d025
			lda BrightFO,x
			sta $d026
*/
SkipSpFO:	ldx RandomTab,y
			jsr ToggleD011
			jmp irend

done:		lda #$01
			sta PART_Done
			lda #$7b
			sta $d011

irend:		asl $d019
ira:		lda #$00
irx:		ldx #$00
iry:		ldy #$00
			inc $00
			rti

//----------------------------------

ToggleD011:
			//cpx #FliLines
			//bcs SkipToggle
			lda FliTabLo,x
			sta ZP
			lda FliTabHi,x
			sta ZP+1
			ldy #$00
			lda (ZP),y
			eor #$60
			sta (ZP),y
SkipToggle:
			rts

//----------------------------------

SwapSprites:
			ldy FrameLo
SpPtr:		ldx #SpPtrPrj+7
			cpx #SpPtrNoB-1
			beq SSDone
			cpy #$ea
			bne !+
			lda SpSwap
			bne SSDone
			stx $43ff
			lda #$01
			sta SpSwap
SSDone:		rts

!:			lda SpSwap
			beq SSDone
			cpy #$09
			bne !+
			stx $53ff
			stx $63ff
			stx $73ff
			dex
			stx SpPtr+1
			rts

!:			cpy #$0c
			bne !+
			stx $43fe
			rts

!:			cpy #$21
			bne !+
			stx $53fe
			stx $63fe
			stx $73fe
			dex
			stx $43fd
			stx SpPtr+1
			rts

!:			cpy #$36
			bne !+
			stx $53fd
			stx $63fd
			stx $73fd
			dex
			stx $43fc
			stx SpPtr+1
			rts

!:			cpy #$4b
			bne !+
			stx $53fc
			stx $63fc
			stx $73fc
			dex
			stx $43fb
			stx SpPtr+1
			rts

!:			cpy #$60
			bne !+
			stx $53fb
			stx $63fb
			stx $73fb
			dex
			stx $43fa
			stx SpPtr+1
			rts

!:			cpy #$75
			bne !+
			stx $53fa
			stx $63fa
			stx $73fa
			dex
			stx $43f9
			stx SpPtr+1
			rts

!:			cpy #$8a
			bne !+
			stx $53f9
			stx $63f9
			stx $73f9
			dex
			stx $43f8
			stx SpPtr+1
			rts

!:			cpy #$a9
			bne !+
			stx $53f8
			stx $63f8
			stx $73f8
			dex
			stx SpPtr+1
			lda #$00
			sta SpSwap

!:			rts

//----------------------------------

SetupSprites:

			//Sprite Pointers

			ldx #$07
			ldy #SpPtrGen+7				//"GENESIS"
!:			tya
			sta Screen0+$03f8,x
			sta Screen1+$03f8,x
			sta Screen2+$03f8,x
			sta Screen3+$03f8,x
			dey
			dex
			bpl !-

			//Sprite Colors 0-0-f-f-f-f-0-0
			ldx #$01
!:			lda #SpriteCol1
			sta $d027,x
			sta $d02d,x
			lda #SpriteCol2
			sta $d029,x
			sta $d02b,x
			dex
			bpl !-

			//Sprite MC colors
			lda #MCCol1
			sta $d025
			lda #MCCol2
			sta $d026

			//Sprite X
			ldx #$0e
			lda #$c6			//Start outside "full" borders
!:			sta $d000,x
			dex
			dex
			bpl !-
			
			//Sprite Y
			ldx #$00
			lda #$2a
!:			sta $d001,x
AddMore:	clc
			adc #21
			cmp #$2a+21
			beq AddMore
			inx
			inx
			cpx #$10
			bne !-

			lda #$00
			sta $d01d			//No X-expand
			lda #$81
			sta $d017			//Y-expand sprites 0 and 7	
			lda #$ff
			sta $d01c			//MC sprites
			sta $d015
			sta $d010			//MSB - we start off screen!!!
			rts

//----------------------------------

SetupScreen:
			lda #<Screen0
			sta ZP
			lda #>Screen0
			sta ZP+1

			lda #$04
			sta Tmp

s2:			ldx #$80
s1:			ldy #$00
s0:			txa
			sta (ZP),y
			tya
			clc
			adc #$14
			tay
			txa
			sta (ZP),y
			txa
			axs #$fb
			tya
			sec
			sbc #$13
			tay
			cpy #$14
			bne s0

			txa
			axs #$63
			
			lda ZP
			clc
			adc #$28
			sta ZP
			bcc *+4
			inc ZP+1

			cpx #$85
			bne s1

			dec Tmp
			bpl s2
		
			ldy #$03
			ldy #$03
			lax #$00
s3:			sta Charset+$400,x
			inx
			bne s3
			inc s3+2
			dey
			bpl s3

//			ldx #$3f
//			lda #$ff
//!:			sta Charset+$7c0,x
//			dex
//			bpl !-

//----------------------------------

CopyScreen:
			lda #>Screen0
			ldx #>Screen1
			jsr cscr

			lda #>Screen1
			ldx #>Screen2
			jsr cscr

			lda #>Screen2
			ldx #>Screen3

cscr:		sta cs01+2
			stx cs02+2
			stx cs03+2
			stx cs04+2
			ldx #$00
			stx cs01+1
			stx cs03+1
			stx cs04+1
			inx
			stx cs02+1

			ldy #$18
cs00:		ldx #$26
cs01:		lda Screen0,x
cs02:		sta Screen1+1,x
			dex
			bpl cs01
			ldx #$14
cs03:		lda Screen1,x
cs04:		sta Screen1
			lda cs01+1
			clc
			adc #$28
			sta cs01+1
			bcc *+6
			inc cs01+2
			clc

			lda cs02+1
			adc #$28
			sta cs02+1
			bcc *+6
			inc cs02+2
			clc
			
			lda cs03+1
			adc #$28
			sta cs03+1
			sta cs04+1
			lda cs03+2
			adc #$00
			sta cs03+2
			sta cs04+2
			
			dey
			bpl cs00
			rts

//----------------------------------

CreateBlitCode:
			lda #<BlitCode
			sta ZP
			lda #>BlitCode
			sta ZP+1
			lda #$13
			sta Tmp2
!:			lda #$03
			sta Tmp
!:			jsr AddRegular
			jsr AddRegular
			jsr SwitchToNext
			jsr AddRegular
			jsr SwitchToNext
			jsr AddRegular
			jsr AddRegular
			jsr SwitchBack
			dec Tmp
			bpl !-
			jsr NextRow
			dec Tmp2
			bpl !--
			rts

AddRegular:
			ldy #<bb0x-bb00
ar00:		lda bb00,y
			sta (ZP),y
			dey
			bpl ar00
			jsr UpdateBase
			lda #<bb0x-bb00
			jmp AddZP

UpdateBase:
			lda bb00+1
			clc
			adc #$04
			sta bb00+1

			lda bb01+1
			adc #$28
			sta bb01+1
			bcc *+6
			inc bb01+2
			clc

			lda bb02+1
			adc #$28
			sta bb02+1
			bcc *+5
			inc bb02+2
			rts

SwitchToNext:
			lda bb00+2
			clc
			adc #$14
			sta bb00+2
			rts

SwitchBack:
			lda bb00+2
			sec
			sbc #$28
			sta bb00+2
			rts

NextRow:
			lda #$00
			sta bb00+1
			inc bb00+2

			lda bb01+1
			sec
			sbc #$1f
			sta bb01+1
			lda bb01+2
			sbc #$03
			sta bb01+2

			lda bb02+1
			sec
			sbc #$1f
			sta bb02+1
			lda bb02+2
			sbc #$03
			sta bb02+2
			rts

AddZP:		clc
			adc ZP
			sta ZP
			bcc *+4
			inc ZP+1
			rts

BlitBase0:
bb00:		lda ShiftedData,x
bb01:		sta Charset+$400+00
			eor #$aa
bb02:		sta Charset+$400+20
bb0x:		rts

//----------------------------------

CreateFliCode:
			lda #<FliCode
			sta ZP
			lda #>FliCode
			sta ZP+1
			ldx #$00
!:			jsr AddFli
			inx
			cpx #FliLines
			bne !-
			rts

AddFli:		lda ZP
			clc
			adc #$01
			sta FliTabLo,x
			lda ZP+1
			adc #$00
			sta FliTabHi,x
			ldy #<fb0x-fb00
af00:		lda fb00,y
			sta (ZP),y
			dey
			bpl af00
			lda #<fb02-fb00
			jsr AddZP
			lda fb00+1
			clc
			adc #$01
			and #$07
			ora #$78
			sta fb00+1
			inc fb01+1
			bpl !+
			lda #$00
			sta fb01+1
!:			rts

FliBase:							//Cycles
fb00:		lda #$7b				//08-09
			sta $d011				//10-13
									//14-16 Write cycles only
									//17-53 Screen fetch cycles
									//54-56 Write cycles only
									//57-58 Sprite 0 fetch
fb01:		lda SinTab+1,y			//59-62
			sax $d018				//00-03
			sta $d016				//04-07
fb02:		lda #$70
			sta $d011
fb0x:		rts

//----------------------------------

//CreateSineTable:
//			ldx #$00
//!:		lda SinTab,x
//			tay
//			and #$07
//			ora #$10
//			sta SinTab,x
//			tya
//			and #$18
//			asl
//			asl
//			asl
//			ora SinTab,x
//			sta SinTab,x
//			inx
//			bne !-
//			rts

//----------------------------------

CreateShiftedData:

			ldy #$13
!:			ldx #$4f
csd00:		lda ShiftedData,x
			eor #$0a
csd01:		sta ShiftedData+$1400,x
csd02:		sta ShiftedData+$1450,x
			eor #$a0
csd03:		sta ShiftedData+$2800,x
csd04:		sta ShiftedData+$2850,x
			dex
			bpl csd00
			inc csd00+2
			inc csd01+2
			inc csd02+2
			inc csd03+2
			inc csd04+2
			dey
			bpl !-
			rts

DarkestFO:
.byte $0b,$0b,$0c,$0c,$0f,$0f,$01,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00
DarkFO:
.byte $0b,$0b,$0c,$0c,$0f,$0f,$01,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00
BrightFO:
.byte $0c,$0c,$0f,$0f,$01,$01,$01,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00
BrightestFO:
.byte $0f,$0f,$0f,$0f,$01,$01,$01,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00

//----------------------------------

.align $100
SinTab:
.fill $100,(((16+16*cos(toRadians([i+0.5]*360/128))) & 7) + 16) + (((16+16*cos(toRadians([i+0.5]*360/128))) & $18) * 8)

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//			INTRO
//--------------------------------------------------------------------------------------------------------------------------------------------------------

irq31:		dec $00
			sta ir31_a+1
			:compensateForJitter(3)
			
			stx ir31_x+1		//44-47
			sty ir31_y+1		//48-51
			asl $d019			//52-57
								//58-62 - 05 cycles stolen by the sprites
			ldx #$07			//00-01
			dex					//02-..	- 39 cycles delay
			bpl *-1				//..-40
			nop $ea				//41-43

			ldx #$00			//44-45
!:			nop					//46-47
			nop					//48-49
			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			nop					//02-03
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			inx					//39-40
			cpx #$22			//41-42
			bne !-				//43-45

			nop $ea				//48-49
!:			nop
			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			nop					//02-03
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			inx					//39-40
			cpx #$4d			//41-42
			bne !-				//43-45

			.byte $04			//NOP $ea
!:			nop					//48-49
			nop
			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			lda #SpPtrGen+7
			sta IntroScreen+$3f8
			lda #$d2
			sta $d001
			nop					//02-03
			nop
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			inx					//39-40
			cpx #$62			//41-42
			bne !-				//43-45

			nop $ea				//48-49
!:			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			nop					//02-03
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			nop
			inx					//39-40
			cpx #$8c			//41-42
			bne !-				//43-45
			nop
!:			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			nop					//02-03
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			nop $ea
			inx					//39-40
			cpx #$a0			//41-42
			bne !-				//43-45

!:			dec $d016-$a0,x		//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			nop					//02-03
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			pha					//32-34
			pla					//35-38
			nop
			nop
			nop

!:			dec $d016			//50-55		Write only cycles for Sprite 0: 54-56, fetch cycles: 57-58, DEC $d016 will used first 2 write only cycles
								//54-56		Write only cycles (DEC $d016 will use the first two of them)
								//57-58		Sprite 0 fetch cycles
			inc $d016			//59-01
			pha					//04-06
			pla					//07-10
			pha					//11-13
			pla					//14-17
			pha					//18-20
			pla					//21-24
			pha					//25-27
			pla					//28-31
			nop
			nop
			nop
			nop
			inx					//39-40
			cpx #FliLines		//41-42
			bne !-				//43-45

			ldy #$ff
XStep:		ldx #$00
			cpx #71
			bne !+
PartDoneSet:
			lda #$00
			bne SkipNewX
			lda #$01
			sta PART_Done
			sta PartDoneSet
			jmp SkipNewX

!:			lda SineX,x
			sta $d000
			sta $d002
			sta $d004
			sta $d006
			sta $d008
			sta $d00a
			sta $d00c
			sta $d00e
			bmi !+
			iny
!:			sty $d010
			inc XStep+1

SkipNewX:	lda #$fa
			cmp $d012
			bne *-3
			lda #$00
			sta $d011

			lda #$00
			sta $d015

			lda #$2a
			sta $d001

			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

ir31_a:		lda #$00
ir31_x:		ldx #$00
ir31_y:		ldy #$00
			inc $00
			rti

//------------------------------

irq00:		dec $00
			sta ir00_a+1
			stx ir00_x+1
			sty ir00_y+1
			asl $d019

			lda #$08
			sta $d011

			jsr BASE_PlayMusic
			
			lda #$31
			sta $d012
			lda #<IRQJmp
			sta $fffe
			lda #>IRQJmp
			sta $ffff

			lda #$ff
			sta $d015
			lda #SpPtrGen
			sta IntroScreen+$3f8

ir00_y:		ldy #$00
ir00_x:		ldx #$00
ir00_a:		lda #$00
			inc $00
			rti

//------------------------------

irq000:		dec $00					//This IRQ runs only once to open the upper and lower borders before the side borders get opened
			pha						//to avoid a glitch in the left upper corner of the side border

			lda #$13
			sta $d011

			bit $d011
			bpl *-3
			lda #$1b
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

//------------------------------

CheckerBoardIntro_Go:

			lax #$00
!:			sta IntroScreen+$000,x
			sta IntroScreen+$100,x
			sta IntroScreen+$200,x
			sta IntroScreen+$300,x
			inx
			bne !-
			
			//:BranchIfNotFullDemo(SkipSync)
			//MusicSync(SYNC_CheckerSpritesIn-1)
//SkipSync:

			vsync()				//Insted of nsync() to avoid skipped music frame

			lda #$1b			//Must trun screen on for at least 1 frame for upper and lower border opening to work...
			sta $d011
			lda #$4c
			ldx #<irq31
			ldy #>irq31
			sta.z IRQJmp
			stx.z IRQJmp+1
			sty.z IRQJmp+2
			lda #$fa
			ldx #<irq000
			ldy #>irq000
			sta $d012
			stx $fffe
			sty $ffff
			lda #$3d
			sta $dd02
			lda #$22
			sta $d018			//Screen: $4800-$4be8, Charset: $4800-$4fff, blank screen only visible for 1 frame before borders are opened
			ldx #$07
			lda #<SpPtrGen+7
			sec
!:			sta IntroScreen+$3f8,x
			sbc #$01
			dex
			bpl !-

			jsr SetupSprites

			jmp CheckerBoard_Go

SineX:
.for (var i = 0; i < 36; i++)
{
.var j = $c6 + 138*sin(toRadians([i+0.5]*360/144))
	.if (j >= $f8)
	{
	.eval j+=8
	}
.byte mod(j,256)
}
.for (var i = 36; i < 71; i++)
{
.var j = $1f + (88-31)*sin(toRadians([i]*360/140))
.byte mod(j,256)
}
