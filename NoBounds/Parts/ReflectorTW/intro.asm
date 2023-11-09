columns_appear:

    lda #$8d //sta abs -> will become and abs
    .var row_offset = 0 

    /*
    C:8704  2D 78 44    AND $4478
    .C:8707  2D 79 44    AND $4479
    .C:870a  C8          INY
    .C:870b  B1 20       LDA ($20),Y
    .C:870d  2D A0 44    AND $44A0

    */ 
    ldy #0
    sta (sta_dest_zp),y 
    ldy #3
    sta (sta_dest_zp),y 

.for(var x=0;x<frame_length-1;x++){
        .var offs = x*9
        ldy #offs
        sta (sta_dest_zp),y
        ldy #offs+3
        sta (sta_dest_zp),y
}

    clc 
    lda sta_dest_zp
    adc #$d1
    sta sta_dest_zp
    bcc !+
    inc sta_dest_zp+1
!:

    inc roundsfade+1
roundsfade:
    lda #0
    cmp #20
    bne !+

    lda #$ff 
    sta sprite_enabler0+1

    lda #0 
    sta roundsfade+1

    lda #$2d //and abs
    sta columns_appear+1
    //:set_addr(decrement_fading_column, fading_col_fn)
   // :set_addr(effect_wait, columns_fade_fn)

next_fn_lo:
    lda #<effect_wait
    sta columns_fade_fn+1

next_fn_hi:
    lda #>effect_wait
    sta columns_fade_fn+2  
!:
    rts
    
effect_wait:
    lda #$00
    inc effect_wait+1
    cmp #$47  //$3a ok
    beq times
    cmp #$60
    bne !+

    lda #0
    sta effect_wait+1

    inc times+1
    jmp !+

times:
        lda #0
        cmp #FX_LENGTH_HI
        bne !+
        :set_addr(quit_scene, columns_fade_fn)

        lda #<first_sta_address
        sta sta_dest_zp 
        lda #>first_sta_address
        sta sta_dest_zp+1

        lda #$2c 
        sta drawnext_enable
!:
        rts

.pc = * "quit scene"
quit_scene:
    lda #0 
    sta sprite_enabler0+1
    
    lda #0 
colct:
    ldx #0 
.for(var x=0;x<frame_length;x++){
        sta x*$28+$d800+$28*y_margin,x
        sta x*$28+$d800+$28*y_margin+1,x

        sta x*$28+screen+$28*y_margin,x
        sta x*$28+screen+$28*y_margin+1,x
}    
        inc colct+1
        inc colct+1

        lda #$2d //and abs
        .eval row_offset = 0 

    /*
    C:8704  2D 78 44    AND $4478
.C:8707  2D 79 44    AND $4479
.C:870a  C8          INY
.C:870b  B1 20       LDA ($20),Y
.C:870d  2D A0 44    AND $44A0

*/ 
        ldy #0
        sta (sta_dest_zp),y 
        ldy #3
        sta (sta_dest_zp),y 

.for(var x=0;x<frame_length-1;x++){
        .var offs = x*9
        ldy #offs
        sta (sta_dest_zp),y
        ldy #offs+3
        sta (sta_dest_zp),y
}
        clc 
        lda sta_dest_zp
        adc #$d1
        sta sta_dest_zp
        bcc !+
        inc sta_dest_zp+1
!:
        lda colct+1
        cmp #42
        bne !+
        lda #<final_irq
        sta nextirq_lo+1

        lda #>final_irq
        sta nextirq_hi+1
!:
        rts 

.pc = * "First frame sprites data"
.import source("data/first_sprite.asm")