init_screen:

.if(STANDALONE_BUILD){
        lda #BORDER_COLOR
        sta $d020 

        lda #BACKGROUND_COLOR
        sta $d021 
}

        //ldx #0 
        lax #D800_COLOUR
        tay
!:
        sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $db00,x 

        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x 
        sta screen+$300,x 

        dex 
        bne !-
    
        ldx #$0 
      //  ldy #$0 (already 0)
        sty $d01c //hires
        sty speed_pt

        lda #$0  
!:
        sta $d001,x  
        inx 
        inx 
        iny 
        cpy #8 
        bne !-

        lda #$ff 
        sta $d01b //priority

        lda #$c8
        sta $d016 

        lda #[sprites/$40]
        sta screen+$03f8 
        
        ldx #$5
        lda #[sprites/$40]+1
!:
        sta screen+$03f9,x 
        dex 
        bpl !-

        lda #[sprites/$40]+2
        sta screen+$03ff
  
        lax #0 
        tay
        sty $d010    
    !:
      //  lda #column0_x
        sta $d000,x 

        //lda #column1_x
        sta $d008,x 
        inx 
        inx 
        iny 
        cpy #4 
        bne !-

        lda #column0_start_y
        sta column_left_y

        lda #column1_start_y
        sta column_right_y

        ldx #$8
        lda #SPRITE_COLOUR
!:
        sta $d027,x 
        dex 
        bpl !-

        lda #d018_val
        sta $d018 

        lda #$ff 
        sta $d015  
        
//-------------------------------------------------------------
nextrow:
        ldy #0 
        ldx #0 
rowlp:
        lda row_clear,y
scrtrg:
        sta screen,x

        iny 
        cpy #5
        bne noresy
        ldy #0
noresy:
        inx 
        cpx #$28 
        bne rowlp
        
        clc 
        lda scrtrg+1
        adc #$28 
        sta scrtrg+1
        bcc !+
        inc scrtrg+2
!:

        inc rowct+1
rowct:
        lda #0 
        cmp #25
        beq !+
        jmp nextrow

!:
        
        ldx #0
        ldy #0
!:
        lda row_horizontal,y
        sta screen+$28*4,x 
        sta screen+$28*8,x 
        sta screen+$28*12,x 
        sta screen+$28*16,x 
        sta screen+$28*20,x 

        iny 
        cpy #5
        bne noresy2
        ldy #0 
noresy2:
        inx 
        cpx #$28
        bne !-

//jmp *
        rts 


row_clear:
.byte 0,0,0,1,0

row_horizontal:
.byte 2,2,2,3,2


reposition_trails:
        ldx #0
        ldy #0         
        lda column_left_y
!:
        clc
        sta $d001,x 
        adc #21 
        inx 
        inx 
        iny 
        cpy #$4
        bne !-

        ldx #0
        ldy #0         
        lda column_right_y
         
!:
        sta $d009,x 
        clc
        adc #21 
        inx 
        inx 
        iny 
        cpy #$4
        bne !-
        rts 

decelerate:
        ldx speed_pt
        lda column_left_y
        sec 
        sbc accel_sin,x 
        sta column_left_y

        lda column_right_y
        clc 
        adc accel_sin,x 
        sta column_right_y

        inc speed_pt

        lda accel_sin,x
        cmp #1
        bne !+
        dec speed_pt

        lda #$f9
        sta topirq_pos+1

        lda #<move_slow_irq 
        sta next_irq_lo+1
        lda #>move_slow_irq 
        sta next_irq_hi+1   

        lda #column1_x
        sta $d008
        sta $d00a 
        sta $d00c
        sta $d00e
!:
        rts 

accelerate:
        ldx speed_pt
        lda column_left_y
        sec 
        sbc accel_sin,x 
        sta column_left_y

        lda column_right_y
        clc 
        adc accel_sin,x 
        sta column_right_y

        dec speed_pt

        lda accel_sin,x
        cmp #14
        bne !+
        dec speed_pt

        lda #$f9
        sta topirq_pos+1

        //lda #0 
       // sta $d015
        lda #0 
        sta $d015 

        inc PartDone

        lda #<final_irq 
        sta next_irq_lo+1
        lda #>final_irq 
        sta next_irq_hi+1   
!:
        rts