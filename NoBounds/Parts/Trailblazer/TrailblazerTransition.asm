
.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

.const ZP			= $10

.const ColorsFrom	= $9e00
.const ColorsTo		= $9f00

//* = $9a00 "Sinus Table"

//SinTab:
//.fill $20,$70+$70*sin(toRadians([i+128.5]*360/478))
//.fill $c0,$cf-i
//.fill $20,$70+$70*sin(toRadians([i+120.5+$c6]*360/478))
//.fill $38,$68+$68*sin(toRadians([i+254+128.5]*360/512))
//.fill $c8,i+$10

* = $9a00 "Transition from NoBounds"

Transition_Go:

//			lax #$00
//!:			sta ColorsTo,x
//			inx
//			bne !-

			vsync()

			lda #<tirq
			sta $fffe
			lda #>tirq
			sta $ffff
			lda #$31
			sta $d012
			lda #$6b
			sta $d011

			rts
Ctr:
.byte $01

//----------------------------------

tirq:		dec $00
			sta tirq_a+1		
			:compensateForJitter(1)
			stx tirq_x+1
			sty tirq_y+1

			asl $d019

			ldx #$0b
!:			dex
			bne!-
			
			ldx #$00
RasterLoop:
			lda ColorsFrom,x
			sta $d020

			ldy #$09
!:			dey
			bne !-
			nop
			inx
tirq0:		cpx #$01
			bne RasterLoop
			nop $ea
			nop
			sty $d020

			cpx #$c0
			beq Done
			inx
			stx tirq0+1
			jmp tirqm

Done:		lda #$01
			sta PART_Done

tirqm:		lda #$00
			sta $d012
			lda #<mirq
			sta $fffe
			lda #>mirq
			sta $ffff

tirq_y:		ldy #$00
tirq_x:		ldx #$00
tirq_a:		lda #$00
			inc $00
			rti

mirq:		dec $00
			sta mirq_a+1		
			stx mirq_x+1
			sty mirq_y+1
			asl $d019

			jsr BASE_PlayMusic

			lda #$31
			sta $d012
			lda #<tirq
			sta $fffe
			lda #>tirq
			sta $ffff

mirq_y:		ldy #$00
mirq_x:		ldx #$00
mirq_a:		lda #$00
			inc $00
			rti
