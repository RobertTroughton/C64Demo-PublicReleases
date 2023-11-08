// ----------------------------------------------------------
// Code and sprites by Ksubi, bitmap graphics by Jon Egg
// ----------------------------------------------------------

// ----------------------------------------------------------

          // memory map
          
          // Default-segment:
          // $3000-$30b6 init_code -- can be relocated
          // $3100-$37ad irq_chain -- can be relocated
          // $3800-$3be7 screen RAM source
          // $3c00-$3fe7 colour RAM source
          // $c000-$c3e7 screen RAM
          // $c400-$dfff hourglass sprites
          // $e000-$ff3f hourglass bitmap

// ----------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

// ----------------------------------------------------------

          // starting addresses
          
          .label Start = Hourglass_BASE
          .label Screen_source  = $3800
          .label Screen_address = $c000
          .label Colour_source  = $3c00
          .label Colour_address = $d800
          //.label Bank_end = $8000
          
// ----------------------------------------------------------

          // program counters
          
          .label RegA = Start + $fd
          .label RegX = Start + $fe
          .label RegY = Start + $ff
          
          .label Counter_01 = Start + $f1
          .label Counter_02 = Start + $f2
          .label Counter_03 = Start + $f3
          .label Counter_04 = Start + $f4
          .label Counter_05 = Start + $f5
          
// ----------------------------------------------------------

          // zero page addresses used
          
          .label Screen_ram_lo_source = $80
          .label Screen_ram_hi_source = $81
          .label Screen_ram_lo_destination = $82
          .label Screen_ram_hi_destination = $83
          
          .label Colour_ram_lo_source = $84
          .label Colour_ram_hi_source = $85
          .label Colour_ram_lo_destination = $86
          .label Colour_ram_hi_destination = $87
          
// ----------------------------------------------------------


// ----------------------------------------------------------

          * = Start "init_code"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp Hourglass_Init					    	//; Init
		.byte $00, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

Hourglass_Init:
		jsr BASECODE_ClearGlobalVariables

          lda #$00
          sta Counter_01
          sta Counter_02
          sta Counter_03
          sta Counter_04
          sta Counter_05
          sta $d01b
          sta $d01d
          sta $d017
          
          lda #$66
          sta $d015
          sta $d01c
          
          ldx #$00
          lda #$00
Loop_01:
            .for (var Page = 0; Page < 4; Page++)
            {
                sta Screen_address + (Page * 256),x
                sta VIC_ColourMemory + (Page * 256),x
            }
          inx
          bne Loop_01
          
          lda #$18
          sta $d016
          lda #$08
          sta $d018

        MACRO_SetVICBank(3)
          
          lda #$0a
          sta $d028
          sta $d029
          sta $d02c
          sta $d02d
          
          lda #$58 + $44
          sta $d002
          lda #$70 + $44
          sta $d004
          
          lda #$58 + $44
          sta $d00a
          lda #$70 + $44
          sta $d00c
          
          bit $d011
          bmi *-3
          bit $d011
          bpl *-3
          
// ----------------------------------------------------------
          
          // irq set up code
          
          sei
	
          lda #$35
          sta $01
	
          lda #$70 +$0c -$15
          sta $d012
          lda #<IRQ1
          sta $fffe
          lda #>IRQ1
          sta $ffff
          asl $d019
          cli
	
          lda #$3b
          sta $d011

          rts

// ----------------------------------------------------------
          
          // IRQ chain 1 ---
          
          * = Start + $0100 "irq_chain"
	
IRQ1:
          sta RegA
          stx RegX
          sty RegY

          dec $00
          
          //nop
          //nop
          //nop
          //nop

          bit $ea
          nop
          nop
          nop
          
          lda #$01
          sta $d025
          lda #$07
          sta $d026
          
          lda #$71 +$0c -$15
          sta $d003
          sta $d005
          
          lda #$86 +$0c -$15
          sta $d00b 
          sta $d00d 
          
Sprite_pointer_update_11:
          lda #$11
          sta Screen_address + $03f9
Sprite_pointer_update_12:
          lda #$18
          sta Screen_address + $03fa
Sprite_pointer_update_15:
          lda #$1f
          sta Screen_address + $03fd
Sprite_pointer_update_16:
          lda #$31
          sta Screen_address + $03fe
	
          lda #$9a +$0c -$15
          ldx #<IRQ2
          ldy #>IRQ2
	
          sta $d012
          stx $fffe
          sty $ffff
	
          asl $d019
	
          inc $00

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
          
          dec $00
          
          //nop
          //nop
          //nop
          //nop

          bit $ea
          nop
          nop
          nop
          nop
          nop
          
          lda #$0f
          sta $d025
          lda #$07
          sta $d026
          
          lda #$9b +$0c -$15
          sta $d003
          sta $d005
          
          lda #$b0 +$0c -$15
          sta $d00b 
          sta $d00d 
          
Sprite_pointer_update_21:
          lda #$10
          sta Screen_address + $03f9
Sprite_pointer_update_22:
          lda #$10
          sta Screen_address + $03fa
Sprite_pointer_update_25:
          lda #$10
          sta Screen_address + $03fd
Sprite_pointer_update_26:
          lda #$10
          sta Screen_address + $03fe
          
          lda #$02
          sta $d028
          sta $d029
          sta $d02c
          sta $d02d
	
          lda #$c3 +$0c -$15
          ldx #<IRQ3
          ldy #>IRQ3
	
          sta $d012
          stx $fffe
          sty $ffff
	
          asl $d019
	
          inc $00

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
          
          dec $00

          //nop
          //nop
          //nop
          //nop
          
          bit $ea
          nop
          nop
          nop
          nop
          nop
          
          lda #$0c
          sta $d025
          lda #$0b
          sta $d026
          
          lda #$c5 +$0c -$15
          sta $d003
          sta $d005
          
          lda #$da +$0c -$15
          sta $d00b
          sta $d00d
          
Sprite_pointer_update_31:
          lda #$10
          sta Screen_address + $03f9
Sprite_pointer_update_32:
          lda #$10
          sta Screen_address + $03fa
Sprite_pointer_update_35:
          lda #$10
          sta Screen_address + $03fd
Sprite_pointer_update_36:
          lda #$10
          sta Screen_address + $03fe
	
          lda #$ff
          ldx #<IRQ4
          ldy #>IRQ4
	
          sta $d012
          stx $fffe
          sty $ffff
	
          asl $d019
	
          inc $00

          ldy RegY
          ldx RegX
          lda RegA
          rti
          
// ----------------------------------------------------------

          // IRQ chain 4 ---
          
IRQ4:
          sta RegA
          stx RegX
          sty RegY

          dec $00
          
		  jsr BASECODE_PlayMusic
          
Build_a_bridge:          
          nop
          nop
          nop
          
          lda Counter_04
          cmp #$08
          bne Skip_routine
          
Begin_to_fade:
          jsr Build_screen
          jsr Row_by_row

          lda #$00
          sta Counter_04
          
Skip_routine:
          inc Counter_04
          
Routine_return:
          lda #$70 +$0c -$15
          ldx #<IRQ1
          ldy #>IRQ1
	
          sta $d012
          stx $fffe
          sty $ffff
	
          asl $d019

          inc $00
	
          ldy RegY
          ldx RegX
          lda RegA
          rti
          
// ----------------------------------------------------------

          // animation timing loop
          
Activate_animation:
          ldy Counter_02
          cpy #$12
          bne Exit_routine_04
          
          jsr Animate
          
          lda #$00
          sta Counter_02
          
Exit_routine_04:
          inc Counter_02
          jmp Routine_return
          
// ----------------------------------------------------------

          // animation routine
          
Animate:
          ldy Counter_01
          
          lda Table_01,y
          sta Sprite_pointer_update_11 +1
          lda Table_02,y
          sta Sprite_pointer_update_12 +1
          
          lda Table_03,y
          sta Sprite_pointer_update_15 +1
          lda Table_04,y
          sta Sprite_pointer_update_16 +1
          
          lda Table_05,y
          sta Sprite_pointer_update_21 +1
          lda Table_06,y
          sta Sprite_pointer_update_22 +1
          
          lda Table_07,y
          sta Sprite_pointer_update_25 +1
          lda Table_08,y
          sta Sprite_pointer_update_26 +1

          lda Table_09,y
          sta Sprite_pointer_update_31 +1
          lda Table_10,y
          sta Sprite_pointer_update_32 +1
          
          lda Table_11,y
          sta Sprite_pointer_update_35 +1
          lda Table_12,y
          sta Sprite_pointer_update_36 +1
          
          inc Counter_01
          ldy Counter_01
          cpy #$20
          bne Exit_routine_01
          
          lda #$ea
          sta Build_a_bridge
          sta Build_a_bridge +1
          sta Build_a_bridge +2
          
          sta Begin_to_fade +3
          sta Begin_to_fade +4
          sta Begin_to_fade +5
          
          lda #$20
          sta Begin_to_fade
          lda #<Fade_to_black
          sta Begin_to_fade +1
          lda #>Fade_to_black
          sta Begin_to_fade +2
          
          lda #$00
          sta Counter_04
          
Exit_routine_01:
          rts
          
// ----------------------------------------------------------

          // fade in screen build routine
          
Build_screen:
          ldy Counter_03

          ldx RowOrder,y

          lda #<Screen_source
          clc
          adc TabLo,x
          sta Screen_ram_lo_source
          lda #>Screen_source
          adc TabHi,x
          sta Screen_ram_hi_source

          lda #<Screen_address
          clc
          adc TabLo,x
          sta Screen_ram_lo_destination
          lda #>Screen_address
          adc TabHi,x
          sta Screen_ram_hi_destination

          lda #<Colour_source
          clc
          adc TabLo,x
          sta Colour_ram_lo_source
          lda #>Colour_source
          adc TabHi,x
          sta Colour_ram_hi_source

          lda #<Colour_address
          clc
          adc TabLo,x
          sta Colour_ram_lo_destination
          lda #>Colour_address
          adc TabHi,x
          sta Colour_ram_hi_destination

/*          
          lda Screen_ram_src_lo_table,y
          sta Screen_ram_lo_source
          lda Screen_ram_src_hi_table,y
          sta Screen_ram_hi_source
          
          lda Screen_ram_des_lo_table,y
          sta Screen_ram_lo_destination
          lda Screen_ram_des_hi_table,y
          sta Screen_ram_hi_destination
          
          lda Colour_ram_src_lo_table,y
          sta Colour_ram_lo_source
          lda Colour_ram_src_hi_table,y
          sta Colour_ram_hi_source
          
          lda Colour_ram_des_lo_table,y
          sta Colour_ram_lo_destination
          lda Colour_ram_des_hi_table,y
          sta Colour_ram_hi_destination
*/          
          inc Counter_03
          
          ldy Counter_03
          cpy #$01
          beq Shift_data_01
          cpy #$14
          beq Shift_data_02
          cpy #$16
          beq Shift_data_03
          cpy #$18
          beq Shift_data_04
          cpy #$19
          bne Exit_routine_02
          
          lda #$00
          sta Counter_03
          
          lda #$4c
          sta Build_a_bridge
          lda #<Activate_animation
          sta Build_a_bridge +1
          lda #>Activate_animation
          sta Build_a_bridge +2
          
Exit_routine_02:
          rts
          
Shift_data_01:
          jsr Move_sprites_02
          rts
          
Shift_data_02:
          jsr Move_sprites_01
          rts
          
Shift_data_03:
          jsr Move_sprites_03
          rts
          
Shift_data_04:
          jsr Move_sprites_04
          rts
          
// ----------------------------------------------------------
          
          // build the screen row by row
          
Row_by_row:
          ldy #$00
Loop_03:
          lda (Screen_ram_lo_source),y
          sta (Screen_ram_lo_destination),y
          lda (Colour_ram_lo_source),y
          sta (Colour_ram_lo_destination),y
          iny
          cpy #$28
          bne Loop_03
          rts
          
// ----------------------------------------------------------

          // move sprite data into the buffer
          
Move_sprites_01:
          ldy #$00
Loop_04:
          lda Sprite_slice_01,y
          sta Screen_address + $0467,y
          lda Sprite_slice_02,y
          sta Screen_address + $0624,y
          iny
          cpy #$12
          bne Loop_04
          rts
          
Move_sprites_02:
          ldy #$00
Loop_05:
          lda Sprite_slice_03,y
          sta Screen_address + $0476,y
          lda Sprite_slice_04,y
          sta Screen_address + $0636,y
          iny
          cpy #$09
          bne Loop_05
          
          ldy #$00
Loop_06:
          lda Sprite_slice_05,y
          sta Screen_address + $07c0,y
          lda Sprite_slice_06,y
          sta Screen_address + $0c40,y
          iny
          cpy #$0f
          bne Loop_06
          rts
          
Move_sprites_03:
          ldy #$00
Loop_07:
          lda Sprite_slice_07,y
          sta Screen_address + $07cf,y
          lda Sprite_slice_08,y
          sta Screen_address + $0c4f,y
          iny
          cpy #$18
          bne Loop_07
          rts
          
Move_sprites_04:
          ldy #$00
Loop_08:
          lda Sprite_slice_09,y
          sta Screen_address + $07e7,y
          lda Sprite_slice_10,y
          sta Screen_address + $0c67,y
          iny
          cpy #$0f
          bne Loop_08
          rts
          
// ----------------------------------------------------------

          // fade out routine
          
Fade_to_black:
          ldy Counter_05
          
          ldx RowOrder,y
          lda #<Screen_address
          clc
          adc TabLo,x
          sta Screen_ram_lo_destination
          lda #>Screen_address
          adc TabHi,x
          sta Screen_ram_hi_destination

          ldx RowOrder,y
          lda #<Colour_address
          clc
          adc TabLo,x
          sta Colour_ram_lo_destination
          lda #>Colour_address
          adc TabHi,x
          sta Colour_ram_hi_destination

/*
          lda Screen_ram_des_lo_table,y
          sta Screen_ram_lo_destination
          lda Screen_ram_des_hi_table,y
          sta Screen_ram_hi_destination
          
          lda Colour_ram_des_lo_table,y
          sta Colour_ram_lo_destination
          lda Colour_ram_des_hi_table,y
          sta Colour_ram_hi_destination
*/          
          inc Counter_05

          ldy Counter_05
          cpy #$10
          beq Wipe_data_01
          cpy #$12
          beq Wipe_data_02
          cpy #$07
          beq Wipe_data_03
          cpy #$17
          beq Wipe_data_04
          cpy #$19
          bne Exit_routine_05
          
          lda #$00
          sta Counter_05
          
          jsr Black_out_rows
          jmp Routine_complete
          
Exit_routine_05:
          jsr Black_out_rows
          rts
          
Wipe_data_01:
          jmp Black_out_sprites_01
          rts
          
Wipe_data_02:
          jmp Black_out_sprites_02
          rts
          
Wipe_data_03:
          jmp Black_out_sprites_03
          rts
          
Wipe_data_04:
          jmp Black_out_sprites_04
          rts
          
// ----------------------------------------------------------

          // remove one row at a time
          
Black_out_rows:
          ldy #$00
          lda #$00
Loop_09:
          sta (Screen_ram_lo_destination),y
          sta (Colour_ram_lo_destination),y
          iny
          cpy #$28
          bne Loop_09
          rts
          
// ----------------------------------------------------------

          // remove sprite rows with the bitmap
          
Black_out_sprites_01:
          inc $00
          dec $01
          ldy #$00
          lda #$00
Loop_10:
          sta Screen_address + $1e03,y
          sta Screen_address + $1fc3,y
          iny
          cpy #$0c
          bne Loop_10
          inc $01
          dec $00
          jmp Exit_routine_05
          
Black_out_sprites_02:
          inc $00
          dec $01
          ldy #$00
          lda #$00
Loop_11:
          sta Screen_address + $186a,y
          sta Screen_address + $1c6a,y
          sta Screen_address + $1e00,y
          sta Screen_address + $1fc0,y
          iny
          cpy #$18
          bne Loop_11
          inc $01
          dec $00
          jmp Exit_routine_05
          
Black_out_sprites_03:
          inc $00
          dec $01
          ldy #$00
          lda #$00
Loop_12:
          sta Screen_address + $1852,y
          sta Screen_address + $1c52,y
          iny
          cpy #$18
          bne Loop_12
          inc $01
          dec $00
          jmp Exit_routine_05
          
Black_out_sprites_04:
          inc $00
          dec $01
          ldy #$00
          lda #$00
Loop_13:
          sta Screen_address + $1840,y
          sta Screen_address + $1c40,y
          iny
          cpy #$18
          bne Loop_13
          inc $01
          dec $00
          jmp Exit_routine_05
                    
// ----------------------------------------------------------

          // sand sprites animation tables
          
Table_01:
          .byte $11,$12,$13,$14,$15,$16,$17,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          
Table_02:
          .byte $18,$19,$1a,$1b,$1c,$1d,$1e,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          
Table_03:
          .byte $1f,$1f,$1f,$1f,$1f,$1f,$1f,$20
          .byte $21,$22,$23,$24,$25,$26,$27,$28
          .byte $29,$2a,$2b,$2c,$2d,$2e,$2f,$30
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          
Table_04:
          .byte $31,$31,$31,$31,$31,$31,$31,$32
          .byte $33,$34,$35,$36,$37,$38,$39,$3a
          .byte $3b,$3c,$3d,$3e,$3f,$40,$41,$42
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          
Table_05:
          .byte $43,$44,$45,$46,$47,$44,$45,$46
          .byte $45,$46,$47,$44,$45,$46,$45,$47
          .byte $45,$46,$47,$44,$45,$48,$49,$4a
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          
Table_06:
          .byte $4b,$4c,$4d,$4e,$4f,$50,$4c,$4d
          .byte $4f,$4e,$4c,$4d,$4f,$4e,$4d,$4c
          .byte $4f,$4e,$4c,$4d,$4c,$4e,$4f,$50
          .byte $51,$10,$10,$10,$10,$10,$10,$10
          
Table_07:
          .byte $10,$10,$10,$43,$44,$45,$46,$47
          .byte $44,$45,$46,$45,$46,$47,$44,$45
          .byte $46,$45,$47,$45,$46,$47,$44,$45
          .byte $47,$48,$49,$4a,$10,$10,$10,$10
          
Table_08:
          .byte $10,$10,$10,$4b,$4c,$4d,$4e,$4f
          .byte $50,$4c,$4d,$4f,$4e,$4c,$4d,$4f
          .byte $4e,$4d,$4c,$4f,$4e,$4c,$4d,$4f
          .byte $4e,$50,$51,$10,$10,$10,$10,$10
          
Table_09:
          .byte $10,$10,$10,$10,$10,$10,$43,$44
          .byte $45,$52,$53,$54,$55,$56,$57,$58
          .byte $59,$5a,$5b,$5c,$5c,$5d,$5d,$5e
          .byte $5e,$5f,$5f,$60,$60,$61,$61,$61
          
Table_10:
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$62,$63,$64,$65,$66,$67,$68
          .byte $69,$6a,$6b,$6c,$6c,$6d,$6d,$6e
          .byte $6e,$6f,$6f,$70,$70,$71,$71,$71
          
Table_11:
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$72,$72,$73,$74,$74,$75,$75
          .byte $76,$76,$77,$77,$77,$78,$78,$78
          .byte $78,$78,$78,$78,$78,$78,$78,$78
          
Table_12:
          .byte $10,$10,$10,$10,$10,$10,$10,$10
          .byte $10,$79,$79,$7a,$7b,$7b,$7c,$7c
          .byte $7d,$7d,$7e,$7e,$7e,$7f,$7f,$7f
          .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
          
// ----------------------------------------------------------

          // hi + lo tables for bitmap fade in

RowOrder:
.byte   $09,$01,$0d,$18,$0e,$06,$12,$16,$00,$02,$10,$0c,$03,$17,$04,$14,$07,$13,$05,$08,$15,$0a,$11,$0b,$0f
TabLo:
.byte   $00,$28,$50,$78,$a0,$c8,$f0,$18,$40,$68,$90,$b8,$e0,$08,$30,$58,$80,$a8,$d0,$f8,$20,$48,$70,$98,$c0
TabHi:
.byte   $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03

/*
Screen_ram_src_lo_table:
          .byte $a8,$68,$48,$00,$70,$30,$10,$b0
          .byte $40,$90,$c0,$20,$b8,$d8,$e0,$60
          .byte $58,$38,$08,$80,$88,$d0,$e8,$f8
          .byte $98
          
Screen_ram_src_hi_table:
          .byte >Bank_end +$000,>Bank_end -$100
          .byte >Bank_end +$100,>Bank_end +$300
          .byte >Bank_end +$100,>Bank_end +$000
          .byte >Bank_end +$200,>Bank_end +$200
          .byte >Bank_end -$100,>Bank_end -$100
          .byte >Bank_end +$100,>Bank_end +$100
          .byte >Bank_end -$100,>Bank_end +$200
          .byte >Bank_end -$100,>Bank_end +$200
          .byte >Bank_end +$000,>Bank_end +$200
          .byte >Bank_end +$000,>Bank_end +$000
          .byte >Bank_end +$200,>Bank_end +$000
          .byte >Bank_end +$100,>Bank_end +$000
          .byte >Bank_end +$100
          
Screen_ram_des_lo_table:
          .byte $68,$28,$08,$c0,$30,$f0,$d0,$70
          .byte $00,$50,$80,$e0,$78,$98,$a0,$20
          .byte $18,$f8,$c8,$40,$48,$90,$a8,$b8
          .byte $58
          
Screen_ram_des_hi_table:
          .byte >Screen_address +$100,>Screen_address +$000
          .byte >Screen_address +$200,>Screen_address +$300
          .byte >Screen_address +$200,>Screen_address +$000
          .byte >Screen_address +$200,>Screen_address +$300
          .byte >Screen_address +$000,>Screen_address +$000
          .byte >Screen_address +$200,>Screen_address +$100
          .byte >Screen_address +$000,>Screen_address +$300
          .byte >Screen_address +$000,>Screen_address +$300
          .byte >Screen_address +$100,>Screen_address +$200
          .byte >Screen_address +$000,>Screen_address +$100
          .byte >Screen_address +$300,>Screen_address +$100
          .byte >Screen_address +$200,>Screen_address +$100
          .byte >Screen_address +$200
          
Colour_ram_src_lo_table:
          .byte $90,$50,$30,$e8,$58,$18,$f8,$98
          .byte $28,$78,$a8,$08,$a0,$c0,$c8,$48
          .byte $40,$20,$f0,$68,$70,$b8,$d0,$e0
          .byte $80
          
Colour_ram_src_hi_table:
          .byte >Bank_end +$400,>Bank_end +$300
          .byte >Bank_end +$500,>Bank_end +$600
          .byte >Bank_end +$500,>Bank_end +$400
          .byte >Bank_end +$500,>Bank_end +$600
          .byte >Bank_end +$300,>Bank_end +$300
          .byte >Bank_end +$500,>Bank_end +$500
          .byte >Bank_end +$300,>Bank_end +$600
          .byte >Bank_end +$300,>Bank_end +$600
          .byte >Bank_end +$400,>Bank_end +$600
          .byte >Bank_end +$300,>Bank_end +$400
          .byte >Bank_end +$600,>Bank_end +$400
          .byte >Bank_end +$500,>Bank_end +$400
          .byte >Bank_end +$500
          
Colour_ram_des_lo_table:
          .byte $68,$28,$08,$c0,$30,$f0,$d0,$70
          .byte $00,$50,$80,$e0,$78,$98,$a0,$20
          .byte $18,$f8,$c8,$40,$48,$90,$a8,$b8
          .byte $58
          
Colour_ram_des_hi_table:
          .byte $d9,$d8,$da,$db,$da,$d8,$da,$db
          .byte $d8,$d8,$da,$d9,$d8,$db,$d8,$db
          .byte $d9,$da,$d8,$d9,$db,$d9,$da,$d9
          .byte $da
*/
// ----------------------------------------------------------

          // sprite data copied to buffer for fade in

Sprite_slice_01:
          .byte $00,$00,$00,$00,$00,$00,$00,$00
          .byte $00,$00,$f0,$00,$01,$54,$00,$0f
          .byte $ff,$c3,$00,$00,$00,$00,$00,$00
          
Sprite_slice_02:
          .byte $00,$00,$3c,$00,$03,$ff,$00,$0f
          .byte $ff,$00,$3f,$ff,$00,$ff,$ff,$0f
          .byte $ff,$fe,$00,$00,$00,$00,$00,$00

Sprite_slice_03:
          .byte $0f,$ff,$c3,$05,$55,$5f,$3f,$ff
          .byte $ff,$00,$00,$00,$00,$00,$00,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00

Sprite_slice_04:
          .byte $ff,$ff,$fc,$fd,$5d,$fc,$ff,$ff
          .byte $f8,$00,$00,$00,$00,$00,$00,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00

Sprite_slice_05:
          .byte $25,$55,$55,$0f,$f7,$77,$09,$55
          .byte $55,$03,$fd,$df,$03,$55,$55,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00
          
Sprite_slice_06:
          .byte $57,$77,$f0,$ff,$ff,$f0,$5d,$df
          .byte $e0,$ff,$ff,$c0,$77,$7f,$c0,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00
          
Sprite_slice_07:
          .byte $00,$ff,$f7,$00,$35,$55,$00,$0f
          .byte $ff,$00,$01,$55,$00,$02,$ff,$00
          .byte $00,$55,$00,$00,$bf,$00,$00,$15
          
Sprite_slice_08:
          .byte $ff,$ff,$00,$dd,$fc,$00,$ff,$f0
          .byte $00,$77,$c0,$00,$ff,$80,$00,$df
          .byte $00,$00,$fe,$00,$00,$7c,$00,$00

Sprite_slice_09:
          .byte $00,$00,$2f,$00,$00,$0f,$00,$00
          .byte $0b,$00,$00,$03,$00,$00,$00,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00

Sprite_slice_10:
          .byte $f8,$00,$00,$f0,$00,$00,$e0,$00
          .byte $00,$c0,$00,$00,$c0,$00,$00,$00
          .byte $00,$00,$00,$00,$00,$00,$00,$00
          
// ----------------------------------------------------------

Routine_complete:
          bit $d011
          bpl *-3
          bit $d011
          bmi *-3
            inc Signal_CurrentEffectIsFinished
            rts
// ----------------------------------------------------------
