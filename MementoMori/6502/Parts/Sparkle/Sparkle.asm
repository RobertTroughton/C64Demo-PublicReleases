// ----------------------------------------------------------
// Code and graphics by Ksubi, original graphics by Sparta :)
// ----------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

// ----------------------------------------------------------
          
// ----------------------------------------------------------


// ----------------------------------------------------------
	
          * = Sparkle_BASE "main_code"

          jmp Init
          jmp Fade_out

RegA: .byte $00
RegX: .byte $00
RegY: .byte $00
Ct2: .byte $00
Ct3: .byte $00
          
// ----------------------------------------------------------
           
          // Start with a clean screen             
Init:
		jsr BASECODE_ClearGlobalVariables
        
          lda #$00
          sta Ct2
          sta Ct3
          sta $d015
          
           MACRO_SetVICBank(2)

          ldx #$00
          lda #$00
Loop_01:
          sta $d800,x
          sta $d900,x
          sta $da00,x
          sta $db00,x
          inx
          bne Loop_01

          jsr Fade_in_IRQ

          rts
          
// ----------------------------------------------------------
          
          // Includes IRQ + screen fade in
Fade_in_IRQ:

          jsr Fade_in
          
          bit $d011
          bmi *-3
          bit $d011
          bpl *-3
          
          sei
          lda #$32
          sta $d012
          lda #<IRQ1
          sta $fffe
          lda #>IRQ1
          sta $ffff
          asl $d019
          
          cli

          rts
         
          
// ----------------------------------------------------------

          // IRQ chain 1 ---   
IRQ1:
          sta RegA
          stx RegX
          sty RegY
          
          lda #$0c
          sta $d021
          
          lda #$78
          sta $d012

          lda #<IRQ2
          sta $fffe
          lda #>IRQ2
          sta $ffff
          
          asl $d019
          
          ldy RegY
          ldx RegX
          lda RegA
          
          rti
          
// ----------------------------------------------------------
          
          // IRQ chain 2 --- 
IRQ2:
          sta RegA
          stx RegX
          sty RegY
          
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          lda #$0f
          sta $d021

          ldx #$62
        Loop_20:
            dex
            bne Loop_20
          
          lda Colour_table_02 + $00
          ldx Colour_table_03 + $00
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $01
          ldx Colour_table_03 + $01
          sta $d025
          stx $d026
          
          jsr Badline
          
          lda Colour_table_02 + $02
          ldx Colour_table_03 + $02
          sta $d025
          stx $d026
          
          lda Colour_table_02 + $03
          ldx Colour_table_03 + $03
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $04
          ldx Colour_table_03 + $04
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $05
          ldx Colour_table_03 + $05
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $06
          ldx Colour_table_03 + $06
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $07
          ldx Colour_table_03 + $07
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $08
          ldx Colour_table_03 + $08
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $09
          ldx Colour_table_03 + $09
          sta $d025
          stx $d026
          
          jsr Badline
          
          lda Colour_table_02 + $0a
          ldx Colour_table_03 + $0a
          sta $d025
          stx $d026
          
          lda Colour_table_02 + $0b
          ldx Colour_table_03 + $0b
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $0c
          ldx Colour_table_03 + $0c
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $0d
          ldx Colour_table_03 + $0d
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $0e
          ldx Colour_table_03 + $0e
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $0f
          ldx Colour_table_03 + $0f
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $10
          ldx Colour_table_03 + $10
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $11
          ldx Colour_table_03 + $11
          sta $d025
          stx $d026
          
          jsr Badline
          
          lda Colour_table_02 + $12
          ldx Colour_table_03 + $12
          sta $d025
          stx $d026
          
          lda Colour_table_02 + $13
          ldx Colour_table_03 + $13
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $14
          ldx Colour_table_03 + $14
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $15
          ldx Colour_table_03 + $15
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $16
          ldx Colour_table_03 + $16
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $17
          ldx Colour_table_03 + $17
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $18
          ldx Colour_table_03 + $18
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $19
          ldx Colour_table_03 + $19
          sta $d025
          stx $d026
          
          jsr Badline
          
          lda Colour_table_02 + $1a
          ldx Colour_table_03 + $1a
          sta $d025
          stx $d026
          
          lda Colour_table_02 + $1b
          ldx Colour_table_03 + $1b
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $1c
          ldx Colour_table_03 + $1c
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $1d
          ldx Colour_table_03 + $1d
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $1e
          ldx Colour_table_03 + $1e
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $1f
          ldx Colour_table_03 + $1f
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $20
          ldx Colour_table_03 + $20
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $21
          ldx Colour_table_03 + $21
          sta $d025
          stx $d026
          
          jsr Burner
          
          lda Colour_table_02 + $22
          ldx Colour_table_03 + $22
          sta $d025
          stx $d026
          
          ldx #$30
Loop_09:
          dex
          bne Loop_09
          
          lda #$0c
          sta $d021
          
          lda #$ff
          sta $d012
          
          lda #<IRQ3
          sta $fffe
          lda #>IRQ3
          sta $ffff
          
          asl $d019
          
          ldy RegY
          ldx RegX
          lda RegA
          
          rti
          
// ----------------------------------------------------------
          
          // IRQ chain 3 --- 
IRQ3:
          sta RegA
          stx RegX
          sty RegY
          
    		jsr BASECODE_PlayMusic
          
          ldy Colour_table_02
          ldx #$00
Loop_05:
          lda Colour_table_02 +1,x
          sta Colour_table_02,x
          inx
          cpx #$1f
          bne Loop_05
          
          sty Colour_table_02 + $1f
          
          ldy Colour_table_03 + $1f
          ldx #$1e
Loop_06:
          lda Colour_table_03,x
          sta Colour_table_03 +1,x
          dex
          bpl Loop_06
          
          sty Colour_table_03
          
          lda #$0c
          sta $d021
          
          jsr Delay
          
          inc Signal_VBlank
          
          lda #$32
          sta $d012
          
          lda #<IRQ1
          sta $fffe
          lda #>IRQ1
          sta $ffff
          
          asl $d019
          
          ldy RegY
          ldx RegX
          lda RegA
          
          rti
          
// ----------------------------------------------------------

          // waste cycles for the raster routine
Burner:
          nop
          
Badline:
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          rts
          
// ----------------------------------------------------------
          
          // init sprites and fade in screen
Fade_in:
          lda #$f0 
          sta $d015
          sta $d01b
          sta $d01c
          
          lda #$1b
          sta $8bfc
          lda #$1c
          sta $8bfd
          lda #$1d
          sta $8bfe
          lda #$1e
          sta $8bff
          
          lda #$3f
          sta $d008
          lda #$58
          sta $d00a
          lda #$3f
          sta $d00c
          lda #$58
          sta $d00e
          
          lda #$7c
          sta $d009
          lda #$7c
          sta $d00b
          lda #$91
          sta $d00d
          lda #$91
          sta $d00f
          
          :IRQ_WaitForVBlank()

          lda #$20
          sta $d018
          lda #$1b
          sta $d011

          ldy #$00

Loop_02:
          lda Colour_table_01 +$00,y
          sta $d021
          lda Colour_table_04 +$00,y
          sta $d025
          lda Colour_table_05 +$00,y
          sta $d026

          :IRQ_WaitForVBlank()
          
          iny
          cpy #$0c
          bne Loop_02
          rts
          
// ----------------------------------------------------------

          // simple delay via counters
Delay:
          inc Ct2
          ldy Ct2
          cpy #$08
          bne Delay
          
          inc Ct3
          ldy Ct3
          cpy #$4f
          bne NotFinished
          inc Signal_CurrentEffectIsFinished
        NotFinished:
          rts

// ----------------------------------------------------------

          // Fade out and finish
Fade_out:

        jsr BASECODE_SetDefaultIRQ

          :IRQ_WaitForVBlank()

          ldy #$0b
Loop_11:
          lda Colour_table_01 +$00,y
          sta $d021
          lda Colour_table_04 +$00,y
          sta $d025
          lda Colour_table_05 +$00,y
          sta $d026
          
          :IRQ_WaitForVBlank()

          dey
          bpl Loop_11

          lda #$00
          sta VIC_D011

          rts
          
// ----------------------------------------------------------
          
          // Colour tables for effects
          * = $8c00 "sparkle_colours"
          
Colour_table_01:
          .byte $00,$0b,$0b,$02,$02,$0c,$0c,$0a
          .byte $0a,$0f,$0f,$0f
          
Colour_table_04:
          .byte $00,$0b,$02,$0b,$02,$0c,$0a,$0c
          .byte $0a,$0f,$0a,$01
          
Colour_table_05:
          .byte $00,$0a,$0c,$0a,$03,$0a,$03,$0d
          .byte $03,$0d,$03,$01
          
Colour_table_02:
          .byte $01,$01,$01,$01,$0a,$0f,$0a,$0c
          .byte $0a,$0b,$0b,$0a,$0c,$0a,$0f,$0a
          .byte $01,$01,$01,$01,$0a,$0f,$0a,$0b
          .byte $0c,$00,$00,$0c,$0b,$0a,$0f,$0a
          .byte $00,$00,$00,$00,$00,$00,$00,$00
          
Colour_table_03:
          .byte $03,$0c,$0c,$03,$05,$0d,$03,$01
          .byte $0d,$01,$01,$0d,$01,$03,$0d,$03
          .byte $03,$0c,$0c,$03,$05,$0d,$03,$01
          .byte $0d,$01,$01,$0d,$01,$03,$0d,$03
          .byte $00,$00,$00,$00,$00,$00,$00,$00
