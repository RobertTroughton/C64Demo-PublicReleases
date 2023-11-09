init_screen:
.if(STANDALONE_BUILD){
        lda #BORDER_COLOR
        sta $d020 

        lda #BACKGROUND_COLOR
        sta $d021 
}
        lda #MC_COLOR1
        sta $d022 

        lda #MC_COLOR2
        sta $d023

        ldx #0 
        lda #D800_COLOUR
!:
        sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $db00,x 
        dex 
        bne !-

        ldx #$0 
        lda #$00
!:
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x 
        sta screen+$300,x
       
        sta screen2,x 
        sta screen2+$100,x
        sta screen2+$200,x 
        sta screen2+$300,x
       
        dex 
        bne !-
       
        lda #sprite_x_base
        ldy #$0
        ldx #$0
!: 
        clc 
        sta $d000,x
        adc #24
        inx 
        inx 
        iny 
        cpy #8
        bne !-

        lda #$ff 
        sta $d015

        ldx #$0 
        ldy #$0 
        sty $d01b //priority
        sty $d01c //hires
        lda #sprite_y_base 
!:
        sta $d001,x  
        inx 
        inx 
        iny 
        cpy #8 
        bne !-

        lda #$0
        sta $d010 

        lda #$ff 
        sta $d017
        
        ldx #$7 
!:      
        lda #[sprites_1/$40]&$3fff 
        sta screen2+$03f8,x 
        lda #[sprites_0/$40]&$3fff 
        sta screen+$03f8,x
        lda #$0
        sta $d027,x
        dex 
        bpl !-

        //empty the charsets

        lda #$ff 
        ldx #$0 
!:
        .for(var x=0;x<8;x++){
                sta blank_charset_0+x*$100,x 
                sta blank_charset_1+x*$100,x
        }
        dex 
        bne !-
        rts 


draw_frame:
//Handle palette
        ldx palette_pt
palette_src0:
        lda col0_palette,x 
        sta bg_col //$d021 

palette_src1:
        lda col1_palette,x 
        sta $d023 

palette_src2:
        lda col2_palette,x
        sta d022_fix+1
        
//----------------------------------------------------
move_light_fn:
        //jsr near_light
        jsr near_light
//----------------------------------------------------
        ldx frame_nr

        //ldx #0
        lda d018_values,x 
        sta $d018 
        sta clean_val+1

        lda d018_blanking_values,x 
        sta horizontal_black_val

        .if(STANDALONE_BUILD)
        {
            lda $dd00
            and #%11111100

            ora banks_list,x 
            sta $dd00 
        }
        else
        {
            lda $dd02
            and #%11111100

            ora banks_list,x 
            sta $dd02 
        }
        
        lda frames_addr_lo,x
        sta scrsrc+1

        lda frames_addr_hi,x
        sta scrsrc+2

        lda screens_list_hi,x 
        sta scrtrg+2    

        lda screens_list_lo,x
        sta scrtrg+1

        ldx #0
        stx rowct+1
rowloop:
        ldy #0
!:
scrsrc: 
        lda screens,x 
scrtrg:
        sta screen,y 
        inx 
        iny 
        cpy #CHARS_WIDTH
        bne !-
        
        inc rowct+1
        inx 
rowct:
        lda #0  
        cmp #CHARS_HEIGHT
        beq finished
        clc 
        lda scrtrg+1
        adc #$28
        sta scrtrg+1
        bcc !+
        inc scrtrg+2
!:
        jmp rowloop
finished:
        rts

.var frame_addr_list = List()
.for(var x=0;x<FRAMES_NR;x++){
        .eval frame_addr_list.add(screens+[x*$d8] )
}

frames_addr_lo:
.for(var x=0;x<frame_addr_list.size();x++){
        .byte <frame_addr_list.get(x) 
}

frames_addr_hi:
.for(var x=0;x<frame_addr_list.size();x++){
        .byte >frame_addr_list.get(x) 
}

d018_values:
.for(var x=0;x<d018_table.size();x++){
        .byte d018_table.get(x) 
}

stop_light:
        inc dl0+1
dl0:
        lda #0
nextedelay:
        cmp #$f0
        bne !+
        lda #0 
        sta dl0+1

nextfnlo:
        lda #<far_light
        sta move_light_fn+1
nextfnhi:
        lda #>far_light
        sta move_light_fn+2
        //:set_addr(far_light,move_light_fn)
!:
        rts

near_light:
        inc pldy+1
pldy:      
        lda #0 

        cmp #4
        bne !+
        lda #0 
        sta pldy+1
        inc palette_pt
        lda palette_pt
cursize:
        cmp #steps-1 //7
        bne !+

        lda #<far_light
        sta nextfnlo+1

        lda #>far_light
        sta nextfnhi+1

        :set_addr(stop_light,move_light_fn) 
        lda #$f3 
        sta nextedelay+1
!:
        rts

far_light: //lol
        inc pldy0+1
pldy0:      
        lda #0 
        cmp #4
        bne !+
        lda #0 
        sta pldy0+1
        dec palette_pt
        lda palette_pt

        cmp #$ff
        bne !+
        inc palette_pt
        :set_addr(stop_light,move_light_fn) 

        inc lpz+1
lpz:
        lda #0 
        cmp #LOOP_ROUNDS
        bne continuefx 
        jsr trigger_stop_fx
continuefx:

        lda #<near_light
        sta nextfnlo+1

        lda #>near_light
        sta nextfnhi+1

        lda #$e
        sta nextedelay+1

        inc palette_list_pt 
        lda palette_list_pt
        cmp #3
        bne noresetpalettelist
        lda #0 
        sta palette_list_pt

noresetpalettelist:
        tax 

        lda sizes_list,x 
        sta cursize+1

        lda multiply_by_3,x 
        tax 
        lda palette_table_addr_lo,x 
        sta palette_src0+1

        lda palette_table_addr_hi,x 
        sta palette_src0+2

        inx  

        lda palette_table_addr_lo,x 
        sta palette_src1+1

        lda palette_table_addr_hi,x 
        sta palette_src1+2

        inx  

        lda palette_table_addr_lo,x 
        sta palette_src2+1

        lda palette_table_addr_hi,x 
        sta palette_src2+2
!:
        rts

trigger_stop_fx:
        lda #<final_irq
        sta btm_irq_lo+1

        lda #>final_irq
        sta btm_irq_hi+1

        lda #$dd 
        sta btm_irq_d012+1

        lda #$0 
        sta d011_mask+1

     //   inc PartDone
        rts 

move_sprites:
//reset hi table
        lax #$0 
        stx tmp 
        stx $d010 
!: 
        sta d010_table_check,x 
        inx 
        cpx #$8
        bne !-
         
        ldy sprite_x_pt 
        inc sprite_x_pt
        lda #sprite_x_base
        clc
        adc sprites_x_sin,y
        sta $d000 
        bcc !+
        inc d010_table_check
!: 
        clc 
        adc #24
        sta $d002
        bcc !+
        inc d010_table_check+1
!: 
        clc 
        adc #24
        sta $d004
        bcc !+
        inc d010_table_check+2
!: 
        clc 
        adc #24
        sta $d006
        bcc !+
        inc d010_table_check+3
!: 
        clc 
        adc #24
        sta $d008
        bcc !+
        inc d010_table_check+4
!: 
        clc 
        adc #24
        sta $d00a
        bcc !+
        inc d010_table_check+5
!: 
        clc 
        adc #24
        sta $d00c
        bcc !+
        inc d010_table_check+6
!: 
        clc 
        adc #24
        sta $d00e
        bcc !+
        inc d010_table_check+7
!: 
//----------------------------------------------------
//d010 
       ldx #0 
checkhi:
        
        lda d010_table_check,x
        beq !+
        lda $d010 
        ora d010_mask,x
        sta $d010
!:
        inx 
        cpx #$8
        bne checkhi

        ldx #$0 
        lda $d010 
        beq endalter
nextchk:
        cmp d010_mask,x 
        bne !+
        lda d010_fill,x 
        sta $d010 
        jmp endalter
!:
        inx 
        cpx #$8 
        bne nextchk
endalter:
        rts

d010_table_check:
.fill $8,0


d010_mask:
.byte %00000001
.byte %00000010
.byte %00000100
.byte %00001000
.byte %00010000
.byte %00100000
.byte %01000000
.byte %10000000

d010_fill:
.byte %11111111
.byte %11111110
.byte %11111100
.byte %11111000
.byte %11110000
.byte %11100000
.byte %11000000
.byte %10000000

