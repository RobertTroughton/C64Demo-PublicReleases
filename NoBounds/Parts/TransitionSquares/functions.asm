init_screen:
        ldx #0  
        stx $d015
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
        rts
 
draw_rows:
        lda #0 
        sta col_index+1
        ldy #0

col_index:  
        ldx #0
        lda can_draw_column,x 
        bne !+
        jmp nodraw
!: 
        lda frame_pointers,x 
        dec frame_pointers,x 
        dec frame_pointers,x 
        cmp #$fe
        bne continue_anim
        lda #0 
        sta can_draw_column,x 
        rts 
continue_anim:
        tax 
        lda anim_sequence_top,x
        .for(var x=0;x<12;x++){
                sta $28+screen_1+[x*$28*2],y
        }
        
        lda anim_sequence_bottom,x
        .for(var x=0;x<12;x++){
                sta $28+screen_1+[x*$28*2]+$28,y
        }

        inx 
        lda anim_sequence_top,x
        .for(var x=0;x<12;x++){
                sta $28+1+screen_1+[x*$28*2],y
        }
        lda anim_sequence_bottom,x
        .for(var x=0;x<12;x++){
                sta $28+1+screen_1+[x*$28*2]+$28,y
        }
        
nodraw:
        inc col_index+1
        lda col_index+1
        cmp #$28/2
        beq !+
        iny 
        iny 
        jmp col_index
!:
        rts

unlock_columns:
        inc tk+1
tk:        
        lda #0 
        cmp #UNLOCK_FRAMES
        bne !+

        lda #0 
        sta tk+1 
can_tk:
        ldx #0 
        inc can_draw_column,x 

        inc can_tk+1 
        inc col_ct+1        
col_ct:       
        lda #0 
        cmp #32 
        bne !+

        lda #$20 //jsr 
        sta fade_fn
        rts
!:
        cmp #38
        bne !+
        lda #$2c //bit 
        sta unlock_fn  
        sta draw_fn 
!:
        rts


fade_tbl:
.byte WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,BLACK

fade_screen:
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
        inc fade_screen+1

        lda fade_screen+1
        cmp #5
        bne !+
        lda #$2c 
        sta fade_fn

        
        lda #<final_irq
        sta nextirq_lo+1

        lda #>final_irq
        sta nextirq_hi+1

!:
        rts 

