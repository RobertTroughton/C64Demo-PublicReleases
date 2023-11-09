init_sprites:
        ldx #0 
        stx $d01d
        stx $d01b
        stx $d017

        lda #fpp_x_pos
!: 
        sta $d000,x
        clc 
        adc #24
        inx 
        inx 
        cpx #18
        bne !-

        lda #$80
        sta $d010 
        
        ldx #14 // Set some sprite y-positions
        clc
        lda #fpp_position
        sta $d001,x
        adc #1
        dex
        dex
        bpl *-7

        lda #$ff 
        sta $d01c

        lda #palette_list.get(0)
        ldx #$8
!: 
        sta $d027,x 
        dex 
        bpl !-

        lda #palette_list.get(0)
        sta $d025 
        
        lda #palette_list.get(0)
        sta $d026

        lda #0 
        sta $d01d

        lda #$ff 
        sta screen+$03f8     
        sta screen+$03f9
        sta screen+$03fa
        sta screen+$03fb
        sta screen+$03fc
        sta screen+$03fd
        sta screen+$03fe 
        sta screen+$03ff

        ldx #0 
        lda #palette_list.get(0)
!:
        sta $d800,x 
        sta $d800+$100,x 
        sta $d800+$200,x 
        sta $d800+$300,x 
        sta $7f00,x
        dex 
        bne !-
        rts



clear_fpp_table_last:
        lda #$00
     //   .break 
      //  lda current_frame_length
      //  lsr 
        .for (var x=0;x<5;x++){
                sta $75c+x
        }

        .for(var x=0;x<35;x++){
                sta FppTab+$61+x
        }   

        rts 

clear_fpp_table:
        lda #$ff 
     //   .break 
      //  lda current_frame_length
      //  lsr 
      /*
.for(var x=0;x<65;x++){
        sta FppTab+$65+x
}   
*/
        .for(var x=0;x<35;x++){
                sta FppTab+$63+x
        }   
        rts 


clear_fpp_table_top:

        lda #$ff
.for(var x=0;x<15;x++){
        sta FppTab+65+x
}
        rts 

//draw frame
draw_frame:
      //  jsr clear_fpp_table
        ldx frame_pt
        lda frame_addr_lo,x 
        sta frame_addr_zp

        lda frame_addr_hi,x 
        sta frame_addr_zp+1
        
        //get frame start (Y margin)
        //lda frame_starting_y,x 
       // clc 

        //lda z_position
      //  asl

y_margin:
        lda #20
        adc #<FppTab
        sta frame_dest_zp0
        lda #>FppTab 
        sta frame_dest_zp0+1
               
//        clc 
      //  lda z_position 
      //  asl 
       // sec 
       // sta tmp
       // lda #max_height
        //sbc tmp
      //  sta current_frame_length


//-------------------------------------------------
        ldy #0 
        ldx #0

        stx texture_ptr 
        stx target_ptr
        stx halver_y
!:
        ldy texture_ptr 
        lda (frame_addr_zp),y
        ldy target_ptr
        sta (frame_dest_zp0),y
        
        inc target_ptr        

        lda halver_y 
        adc y_size 
        sta halver_y
        bpl noinc0
        inc texture_ptr
        and #$7f
        sta halver_y
noinc0:
        //inc texture_ptr
        lda texture_ptr 
        cmp #max_height
        bne !-        
//-------------------------------------------------
        //set the sprites position
        ldx x_size
        lda sprite_x_positions_addr_lo,x
        //sta x_table+1 
        sta sprite_x_table_addr

        lda sprite_x_positions_addr_hi,x
        //sta x_table+2
        sta sprite_x_table_addr+1

        lda sprites_stretch_x,x 
        sta $d01d 

        lda sprites_hi_x,x
        sta $d010     

        ldy #$0
.for(var x=0;x<8;x++){
        lda (sprite_x_table_addr),y
        sta $d000+2*x
        iny
}

x_pulse_fn:
        jsr nothing // x_pulse_grow //x_pulse_grow / slow_grow_x / slower_grow_x_and_keep


        rts 
