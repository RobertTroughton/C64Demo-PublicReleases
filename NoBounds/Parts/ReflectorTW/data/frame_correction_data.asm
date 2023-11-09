.var draw_sequence = List()
//.var draw_target_list = List()
.var draw_source_list = List()

.eval draw_sequence.add(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,0)

.for(var x=0;x<draw_sequence.size();x++){
  //  .eval draw_target_list.add(draw_sequence.get(x)*$200+sprites)
    
     .if(draw_sequence.get(x)<16){
        .eval draw_source_list.add((draw_sequence.get(x)*$200)+$6000) //stupid kickassembler bug - it doesn't allow to use $2000 with the label sprites_bk
    }else{
        .eval draw_source_list.add(((draw_sequence.get(x)-16)*$200)+$a000) //stupid kickassembler bug - it doesn't allow to use $e000 with the label sprites_bk2
    }
}

.pc = * "draw source list"
draw_source_lo:
.for (var x=0;x<draw_source_list.size();x++){
    .byte <draw_source_list.get(x)
}

draw_source_hi:
.for (var x=0;x<draw_source_list.size();x++){
    .byte >draw_source_list.get(x)
}

.pc = * "Drawnext function"
drawnext:
        ldx #$00 

        lda draw_source_lo,x
        sta frame_source_zp

        lda draw_source_hi,x
        sta frame_source_zp+1

        lda sprite_buffer_switcher
        eor #$ff 
        sta sprite_buffer_switcher

        lda sprite_buffer_switcher
        beq buf1
        
        lda #<sprites
        sta frame_dest_zp

        lda #>sprites
        sta frame_dest_zp+1
        jmp !+
buf1:     
        lda #<sprites_1
        sta frame_dest_zp

        lda #>sprites_1
        sta frame_dest_zp+1
!:
        ldy #$0
        ldx #16
!:
.for(var x=0;x<16;x++){
        lda (frame_source_zp),y 
        sta (frame_dest_zp),y 
        iny 
}
        dex 
        bne !-

        inc frame_source_zp+1
        inc frame_dest_zp+1
         
        ldy #$0
        ldx #16
!:
.for(var x=0;x<16;x++){
        lda (frame_source_zp),y 
        sta (frame_dest_zp),y 
        iny 
}
        dex 
        bne !- 

can_go_anim:
        bit drawnext+1
        rts
