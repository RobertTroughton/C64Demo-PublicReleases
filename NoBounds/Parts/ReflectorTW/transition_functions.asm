init_screen:
    //    lda #BACKGROUND_COLOR
    //    sta $d020 
    //    sta $d021 

        ldx #0 
        lda #D800_COLOUR
!:
        sta $d800,x 
        sta $d900,x
        sta $da00,x 
        sta $db00,x 
        dex 
        bne !-

        lda #0
        ldx #$8
!: 
        sta charset+$2f8,x
        dex 
        bpl !-
  
        ldx #0 
        lda #1+[charset_bytes.size()]/8 
!:
        sta screen,x
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        dex 
        bne !-      
        

        lda #MC_COLOR1
        sta $d022 

        lda #MC_COLOR2
        sta $d023 

        lda #$d8 
        sta $d016 

        lda #d018_val
        sta $d018 
      
        lda #$ff 
        sta $d01c
        sta $d01d 
        sta $d01b //sprite priority

        lda #0
        sta $d017 
        sta $d010 
        sta sprite_buffer_switcher
        ldx #8
!:
        sta $d027,x 
        dex 
        bpl !-
  
        lda #SPRITE_COL_1
        sta $d025 

        lda #SPRITE_COL_2
        sta $d026

        lda #sprite_x_base
        sta $d000 
        sta $d000+4
        sta $d000+8
        sta $d000+12

        lda #sprite_x_base+48
        sta $d002 
        sta $d002+4
        sta $d002+8
        sta $d002+12
 
        lda #9 
        sta $d02f 

        lda plexed_y
        sta $d001
        sta $d003 
     
        lda plexed_y+1
        sta $d005 
        sta $d007 

        lda plexed_y+2
        sta $d009
        sta $d00b

        lda plexed_y+3 
        sta $d00d
        sta $d00f
        rts

.var col_shift = 0
.var shift_offset = 3

.var frame_ct_list = List()
.for(var x=0;x<10;x++){
    .eval frame_ct_list.add(col_shift)
    .eval col_shift+=shift_offset
}
.for(var x=0;x<10;x++){
    .eval frame_ct_list.add(col_shift)
    .eval col_shift-=shift_offset
}

//.print (frame_ct_list)
anim_sprites:
        lda sprite_buffer_switcher
        bne !+ 
        lda #[sprites_1/$40]
        jmp storeptr
!:
        lda #[sprites/$40]
storeptr: 
        clc 
        sta screen+$03f8
        adc #1
        sta screen+$03f9
        adc #1
        sta screen+$03fa
        adc #1
        sta screen+$03fb
        adc #1
        sta screen+$03fc
        adc #1
        sta screen+$03fd
        adc #1
        sta screen+$03fe
        adc #1
        sta screen+$03ff
        rts 
