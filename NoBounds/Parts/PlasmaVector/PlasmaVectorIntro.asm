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
//	6980	6c00	0680	-UNUSED-
//	6c00					Intro
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

.label PlasmaVectorIntro_Go	= $6c00

.const ScrRAM		= $6000
.const ColRAM		= $d800
.const ScrTab		= $7c00
.const ColTab		= $7e00
.const ZP			= $10

*= PlasmaVectorIntro_Go "Intro"

				jsr CreateFadeTables
				jsr ClearScreen

				nsync()


				lda #$3d
				sta $dd02
				lda #$3b
				sta $d011
				lda #$18
				sta $d016
				lda #$80
				sta $d018

				lda #<FadeTables
				sta ZP
				lda #>FadeTables
				sta ZP+1

FadeLoop0:		vsync()

				lda #$ea
				cmp $d012
				bne*-3

				ldx #$11
FadeLoop1:
				.for (var i = 0; i < 25; i++)
				{
				ldy ScrTab + (i * 18),x
				lda (ZP),y
				sta ScrRAM + (i * 40) + 22,x
				ldy ColTab + (i * 18),x
				lda (ZP),y
				sta ColRAM + (i * 40) + 22,x
				}

				dex
				bpl FadeJmp
				inc ZP+1
				lda ZP+1
				cmp #>FadeTables+$800
				beq FadeDone
				jmp FadeLoop0
FadeJmp:		jmp FadeLoop1

FadeDone:		jmp *

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

.align $100

FadeTables:

