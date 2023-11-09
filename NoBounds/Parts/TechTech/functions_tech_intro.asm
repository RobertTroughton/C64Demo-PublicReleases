update_tech_values_intro:
curspeed:   
        lda #$7d
        sta speed

//.const SPEED = $7d
        inc sin_pt 
        ldy sin_pt 

        jmp movement_unrolled_code
end_movement:
intro_fn: 
        jsr fade_colours
        rts

fade_colours:
        ldx #0

        lda d022_fade_tbl,x 
        sta $d022

        lda d023_fade_tbl,x 
        sta d023_col+1
        //sta $d023
        inc fade_colours+1

        lda fade_colours+1 
        cmp #12
        bne !+
        dec fade_colours+1
        :set_addr(stop_intro,intro_fn)
!:
        rts 

stop_intro:
        hlv0:
        lda #0
        eor #$ff 
        sta hlv0+1
        bne !+
        inc introdelay+1
!:

introdelay:
        lda #0 
.pc = * "Intro delay"
        cmp #$50 //6b //83
        bne !+
        lda #0
        sta can_clear+1
!:

can_clear:
        lda #$ff 
        bne !+
clear:
        ldx #0 
        lda #LOGO_CENTERING_INDEX
        sta tech_sin_bankswitch,x     
        inc clear+1
        bne !+
        
//intro finished, stop the update function and point the switch irq
        lda #1
        sta curspeed+1
        :set_addr(null_function,update_tech_fn)
        lda #0 
        sta sin_pt

        lda #<wait_for_colours_irq
        sta fx_irq_lo+1
        sta $fffe 
        lda #>wait_for_colours_irq
        sta fx_irq_hi+1
        sta $ffff
        lda #$f9 
        sta fx_d012+1
!:
        rts

screens_addr_lo:
.for(var x=1;x<tech_screen_list.size();x++){
        .byte <tech_screen_list.get(x)
}

screens_addr_hi:
.for(var x=1;x<tech_screen_list.size();x++){
        .byte >tech_screen_list.get(x)
}

d022_fade_tbl:
.byte WHITE, WHITE
.byte LIGHT_GREEN, LIGHT_GREEN
.byte CYAN, CYAN
.byte LIGHT_BLUE, LIGHT_BLUE
.byte PURPLE, PURPLE 
.byte PURPLE, PURPLE 
/*
.byte WHITE,WHITE
.byte LIGHT_GRAY,LIGHT_GRAY
.byte LIGHT_GREEN,LIGHT_GREEN
.byte CYAN,CYAN
.byte GREEN,GREEN 
.byte ORANGE,ORANGE
.byte GRAY,GRAY
.byte PURPLE,PURPLE
*/

d023_fade_tbl:
.byte WHITE,WHITE 
.byte LIGHT_GREEN,LIGHT_GREEN
.byte LIGHT_GRAY, LIGHT_GRAY
.byte LIGHT_BLUE,LIGHT_BLUE
.byte GRAY, GRAY 
.byte ORANGE, ORANGE

/*
.byte DARK_GRAY,DARK_GRAY
.byte PURPLE,PURPLE 
.byte GRAY,GRAY
.byte LIGHT_RED,LIGHT_RED
.byte LIGHT_GRAY,LIGHT_GRAY
.byte CYAN,CYAN
.byte LIGHT_GREEN,LIGHT_GREEN
.byte ORANGE,ORANGE
*/
