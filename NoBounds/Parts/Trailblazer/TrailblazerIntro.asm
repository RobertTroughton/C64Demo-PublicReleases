
irq31:		dec $00		
			sta ir31_a+1		
			:compensateForJitter(3)
			
			stx ir31_x+1		//44-47
			sty ir31_y+1		//48-51
			asl $d019			//52-57
								//58-05 - 11 cycles stolen by the sprites
			ldx #$06			//06-07
			dex					//08-..	- 34 cycles delay
			bpl *-1				//..-41
			nop					//42-43

			ldx #$00			//44-45
!:			lda RasterColTab,x	//46-49
			dec $d016			//50-55
			sta $d021			//56..07	Sprite fetch cycles: 58-60 + 61-62 + 00-01 + 02-3 + 04-05
			inc $d016			//08-13
			inc $d017			//14-19		Stretch sprites
			dec $d017			//20-25
			pha					//26-28
			pla					//29-32
			cmp ($00,x)			//33-38
			inx					//39-40
			cpx #$c1			//41-42
			bne !-				//43-45

			lda $d006
			cmp #$e7
			bne !+
			lda #$01
			sta PART_Done
			jmp	IntroDone

!:			inc $d004
			inc $d006
			lda $d006
			cmp #$b7
			bcc *+5
			dec $d008
			dec $d00a

IntroDone:
			lda #$fa
			cmp $d012
			bne *-3
			lda #$00
			sta $d011

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

ir00_y:		ldy #$00
ir00_x:		ldx #$00
ir00_a:		lda #$00
			inc $00
			rti

//------------------------------


irq000:		dec $00
			sta ir000_a+1
			:compensateForJitter(3)
			
			stx ir000_x+1		//44-47
			sty ir000_y+1		//48-51
			asl $d019			//52-57
								//58-05 - 11 cycles stolen by the sprites
			ldx #$09			//06-07
			dex					//08-..
			bpl *-1				//..-45
			nop					//46-47
			nop					//48-49
			nop $ea				//50-52
			ldx #$00			//53-54

!:			lda RasterColTab,x	//55-58
			sta $d020			//59-62
			sta $d021			//00-03
			inx

			jsr NextLine
			jsr NextLine
			jsr NextLine
			jsr NextLine
			jsr NextLine
			jsr NextLine
			jsr NextLine

			cpx #$c0
			bne !-
			nop
			nop $ea
			stx $d020
			stx $d021

			lda #$fa
			cmp $d012
			bne *-3
			
			lda #$13
			sta $d011

			bit $d011
			bpl *-3

			lda #$1b
			sta $d011

			lda #$3c
			sta $d015
			
			lda #$00
			sta $d012
			lda #<irq00
			sta $fffe
			lda #>irq00
			sta $ffff

ir000_y:	ldy #$00
ir000_x:	ldx #$00
ir000_a:	lda #$00
			inc $00
			rti

NextLine:	lda RasterColTab,x
			sta $d020
			sta $d021
			inx
			pha
			pla
			pha
			pla
			pha
			pla
			pha
			pla
			pha
			pla
			nop
			rts
			
//------------------------------

TrailblazerIntro_Go:

			lax #$00
!:			sta $c800,x
			sta $c900,x
			sta $ca00,x
			sta $cb00,x
			inx
			bne !-

			vsync()

			lda #$1b			//Must turn screen on for at least 1 frame for upper and lower border opening to work...
			sta $d011
			lda #$4c
			ldx #<irq31
			ldy #>irq31
			sta.z IRQJmp
			stx.z IRQJmp+1
			sty.z IRQJmp+2
			lda #$31
			ldx #<irq000
			ldy #>irq000
			sta $d012
			stx $fffe
			sty $ffff
			lda #$3f
			sta $dd02
			lda #$22
			sta $d018			//Screen: $c000-$c3e8, Charset: $c000-$c7ff, blank screen only visible for 1 frame before borders are opened
			lda #$08
			sta $d016			//Restore $d016
			lda #$3f
			sta $cbfa
			sta $cbfb
			sta $cbfc
			sta $cbfd
			ldx #$3f
			lda #$ff
!:			sta $cfc0,x
			dex
			bpl !-

			lda #$00
			sta $d029
			sta $d02a
			sta $d02b
			sta $d02c
			lda #$31
			sta $d005
			sta $d007
			sta $d009
			sta $d00b
			lda #$af
			sta $d006
			sec
			sbc #$18
			sta $d004
			lda #$80
			sta $d008
			clc
			adc #$18
			sta $d00a
			lda #$3c
			sta $d010
			sta $d01d	//X-expand = 1
			//sta $d015

			lda #$ff
			sta $d017	//Y-expand = 1

			lda #$00
			sta RasterColTab+$c0

			jmp Trailblazer_Go
