
.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const ZPA			= $10
.const ZPX			= $11
.const ZPY			= $12
.const ZP1			= $13

.const Intro		= $c200
.const ScrRAM		= $cc00
.const ColRAM		= $d800
.const ScreenTab	= $d490

* = Intro "BigDXYCP Intro"

Intro_Go:	jsr SetupScreenAndSprites

			nsync()

			lda #$00
			sta $d012
			lda #<irq0
			sta $fffe
			lda #>irq0
			sta $ffff

			lda #$1b
			sta $d011

			lda #$3f					//; VIC bank $c000-$ffff
			sta $dd02

			lda #$34					//; Screen: $cc00, charset: $d000
			sta $d018

			rts

//----------------------------------

SetupScreenAndSprites:

			lax #$00
!:			sta ScrRAM+$000,x
			sta ScrRAM+$100,x
			sta ScrRAM+$200,x
			sta ScrRAM+$300,x
			sta ColRAM+$000,x
			sta ColRAM+$100,x
			sta ColRAM+$200,x
			sta ColRAM+$300,x
			inx
			bne !-

			dec $01
			ldx #$17
!:			lda ScreenTab,x
			sta ScrRAM + (10 * 40) + 8,x
			lda ScreenTab+$18,x
			sta ScrRAM + (11 * 40) + 8,x
			lda ScreenTab+$48,x
			sta ScrRAM + (13 * 40) + 8,x
			lda ScreenTab+$60,x
			sta ScrRAM + (14 * 40) + 8,x
			dex
			bpl !-

			ldx #$00
!:			lda $7600,x						//; Copy No Bounds sprites from their original location in the RAM to new one
			sta $d600,x
			lda $7700,x
			sta $d700,x
			inx
			bne !-

			inc $01

			ldx #$10
!:			lda SpriteCoords,x				//; No Bounds sprite coordinates
			sta $d000,x
			dex
			bpl !-

			ldx #$09
!:			lda SpriteColors,x
			sta $d025,x
			dex
			bpl !-

			lda #$81
			sta $d017						//; Y-expand

			lda #$ff
			sta $d015						//; Sprites on
			sta $d01c						//; MC sprites

			ldx #$07
			lda #$5f
			sec
!:			sta $cff8,x						//; Sprite pointers
			sbc #$01
			dex
			bpl !-

			rts

SpriteCoords:
.byte $1f,$2a,$1f,$54,$1f,$69,$1f,$7e,$1f,$93,$1f,$a8,$1f,$bd,$1f,$d2, $00

SpriteColors:
.byte $0b,$0c,$00,$00,$0f,$0f,$0f,$0f,$00,$00

//----------------------------------

irq0:		dec $00
			sta ir0_A+1
			stx ir0_X+1
			sty ir0_Y+1

			asl $d019

Col0:		lda #$00
			sta $d021

			jsr BASE_PlayMusic

			lda #$96
			sta $d012
			lda #<irq1
			sta $fffe
			lda #>irq1
			sta $ffff

ir0_A:		lda #$00
ir0_X:		ldx #$00
ir0_Y:		ldy #$00
			inc $00
			rti

//----------------------------------

irq1:		sta ir1_A+1
			lda $01
			sta ir1_1+1

			lda #$35
			sta $01

Col1:		lda #$00
			sta $d021

			stx ir1_X+1
			sty ir1_Y+1

			asl $d019

			jsr UpdateColors

			lda #00
			sta $d012
			lda #<irq0
			sta $fffe
			lda #>irq0
			sta $ffff

ir1_1:		lda #$00
			sta $01

ir1_A:		lda #$00
ir1_X:		ldx #$00
ir1_Y:		ldy #$00
			rti

//----------------------------------

UpdateColors:
UpdateFlag:	lda #$02
			beq IntroFinished

StartCol:	ldx #$00
			lda ColorTab+$20,x
			sta Col0+1
			lda ColorTab+$00,x
			sta Col1+1
			inx
			stx StartCol+1
			cpx #$a0
			bcc UpdateDone

			dec UpdateFlag + 1
			beq UpdateDone

			ldx #$00
			sta StartCol+1

			dec $01

			ldx #$17
!:			lda ScreenTab+$90,x
			sta ScrRAM + (10 * 40) + 8,x
			lda ScreenTab+$a8,x
			sta ScrRAM + (11 * 40) + 8,x
			lda ScreenTab+$d8,x
			sta ScrRAM + (13 * 40) + 8,x
			lda ScreenTab+$f0,x
			sta ScrRAM + (14 * 40) + 8,x
			dex
			bpl !-

			inc $01
UpdateDone:
			rts

IntroFinished:
			lda #$01
			sta PART_Done
			rts
ColorTab:

	.fill $20, $00
	.byte $09, $02, $08, $0a, $07, $0d, $07, $01
	.fill $60, $01
	.byte $01, $0d, $07, $05, $0c, $09, $0b, $00
	.fill $30, $00

