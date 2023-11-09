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

frame_counters:
.for(var x=0;x<frame_ct_list.size();x++){
        .byte frame_ct_list.get(x)
}

.pc = $86f3 "Draw column"
draw_column:
        .var col_address = screen+y_margin*$28
        .var col_offset = 0

.for(var c=0;c<20;c++){
        ldx frame_counters+c
        lda lut_addr_lo,x 
        sta lut_source_zp 

        lda lut_addr_hi,x
        sta lut_source_zp+1

        ldy #0 
        .eval col_offset = 2*c
    //.pc = * "Here"
.for(var x=0;x<frame_length;x++){
        lda (lut_source_zp),y 
        //rimettere STA
        and col_address+(x*$28)+col_offset
        and col_address+(x*$28)+col_offset+1

        .if(x!=frame_length-1){
            iny 
        }
       // iny 
        
}
        inc frame_counters+c
        lda frame_counters+c
        cmp #72 
        bmi !+
        lda #0 
        sta frame_counters+c  
!:
}
        lda frame_counters+10 
        cmp #6
        bne !+
//sprite going DOWN in priority
        dec $d01b
        lda #0 
        sta $d015 
!:
        cmp #$2f
        bne !+
//sprite going UP in priority
        lda #0
        sta $d01b
        sta $d027
        sta $d028 
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e
        
.const frames_padding = 6
!:
        lda frame_counters+10 
        cmp #$0c+frames_padding
        bne !+
//anim started! 
        lda #$ee //inc abs
        sta can_go_anim

        lda #0
        sta drawnext+1

drawnext_enable:
        lda #$20
        sta drawnext_fn
!:
        lda frame_counters+10
        cmp #$0c+frames_padding+2
        bne !+

sprite_enabler0:
        lda #$0 //will become $ff 
        sta $d015 
!:
        lda frame_counters+10
        cmp #$0d 
        bne !+

        lda #SPRITE_BG_COLOR
        sta $d027

        sta $d028 
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e
!:

        lda frame_counters+10 
        cmp #$2a+frames_padding
        bne !+

        //disable patching when it's over
        lda #$2c 
        sta can_go_anim    

        lda #$2c
        sta drawnext_fn
        dec drawnext+1   
!:
        rts

sprite_anim_table:
.for(var x=0;x<28;x++){
        .byte [sprites/$40]+8*x
}

sprite_mapping_table:
.for (var x=0;x<sprite_frames_mapping_list.size();x++){
    .byte sprite_frames_mapping_list.get(x)
}

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
