init_screen:
        ldx #0  
        stx $d015 
        stx block_id
        lda #[[charset_end-charset]&$7ff]/8
!:
        sta screen_1,x
        sta screen_1+$100,x
        sta screen_1+$200,x
        sta screen_1+$300,x
        dex 
        bne !-

        lda #D800_COLOUR
!:
        sta $d800,x
        sta $d800+$100,x 
        sta $d800+$200,x
        sta $d800+$300,x 
        dex 
        bne !-

		:d016($c8)
        .if(!STANDALONE_BUILD)
        {
        lda #$3e
        sta $dd02
        }
        else
        {
        bank_2()
        }
        rts
 
draw_square:
    
//get position pointer
        ldy block_id 
        ldx position_table,y

//set destination address
      // ldx #0 
        lda screen_addr_lo,x 
        sta r0_addr

        lda screen_addr_hi,x
        sta r0_addr+1

       //get animation pointer
        ldx block_id
        lda anim_table,x
        inc anim_table,x //advance animation pointer

        lda anim_table,x
        cmp #ANIMATION_FRAMES
        bne !+

        lda #0 
        sta anim_table,x  
        inc screen_position_pt
    
        lda screen_position_pt
      
goahead:
        sta position_table,x     
        inc tk0+1
tk0:
        lda #0 
        cmp #$eb
        bne g0

        lda #$20 
        sta fade_fn
        :set_addr(finish_squares, draw_fn)
        lda #1 
        sta blockscnt+1
g0:
        rts
!:
        tay 
        ldx frame_offset_tbl,y

        //row0 col0
        ldy #0
        lda map_data_tiles,x 
        sta (r0_addr),y

        //row1 col0
        lda map_data_tiles+$28,x 
        ldy #$28
        sta (r0_addr),y

        inx
        ldy #1
        //row1 col0
        lda map_data_tiles,x 
        sta (r0_addr),y

        //row1 col1 
        ldy #$29
        lda map_data_tiles+$28,x 
        sta (r0_addr),y
        rts 

.pc = * "Anim table"
anim_table:
.fill BLOCKS_NUMBER,mod(i,ANIMATION_FRAMES/4)

.pc = * "Position table"
position_table:
.for(var x=0;x<BLOCKS_NUMBER;x++){
    .byte x
}

fade_tbl:
//.byte WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,BLACK
.byte LIGHT_BLUE,PURPLE,RED,BROWN,BLACK

fade_border:
        ldx #0 
        lda fade_tbl,x 
        sta $d020 
        sta $d021

        inc fadedl+1
fadedl:
        lda #0 
        cmp #FADE_DELAY
        bne !+

        lda #0 
        sta fadedl+1
        inc fade_border+1

        lda fade_border+1
        cmp #5
        bne !+
        lda #$2c 
        sta fade_fn

        lda #1 
        sta PartDone
!:
        rts 


.var final_block0  = screen_1+$80
.var final_block1  = screen_1+$13c
.var final_block2  = screen_1+$1ce


finish_squares:
animend0:
        lda final_frame1
        sta final_block1
        sta final_block2

animend1:
        lda final_frame1+1
        sta final_block1+1
        sta final_block2+1

        lda final_frame1+2
        sta final_block1+$28
        sta final_block2+$28

        lda final_frame1+3
        sta final_block1+$29
        sta final_block2+$29

        lda #$1d
        sta final_block0
        sta final_block0+1
        sta final_block0+$28
        sta final_block0+$29

        :set_addr(last_anim, draw_fn)
        rts


last_anim:
        lda #$1d 
        sta final_block1
        sta final_block1+1
        sta final_block1+$28
        sta final_block1+$29
        sta final_block2
        sta final_block2+1
        sta final_block2+$28
        sta final_block2+$29
        
        lda #0 
        sta set_draw_irq+1 
        rts 




//frame1
final_frame1:
.byte $1b,$1c,$38,$39

