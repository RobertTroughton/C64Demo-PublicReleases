.macro increment_src_row(row){
    clc
    lda row+1 
    adc #LOGO_WIDTH
    sta row+1
    bcc !+
    inc row+2
!:
}

.macro increment_dest_row(row){
    clc
    lda row+1 
    adc #$28 
    sta row+1
    bcc !+
    inc row+2
!:
}

//Copy the logo to the tech screens, shifted 1 character to the right
prepare_screens:
        lax #$0 
clp0:
        .for (var x=0;x<4;x++){
                .for(var s=0;s<tech_screen_list.size();s++){
                        sta tech_screen_list.get(s)+$100*x,x
                }
        }
        dex 
        beq !+
        jmp clp0
!:

        ldx #0
        lda #$8+WHITE
!:
        sta $d800,x
        sta $d800+$100,x 
        sta $d800+$200,x
        sta $d800+$300,x 
        dex 
        bne !-

        lax #$0
!:
        sta $d800,x 
        sta $d800+$28,x 
        sta $d800+$28*2,x 
        
        inx 
        cpx #$27
        bne !-
        
        ldy #0 
copy_rw:
        ldx #0 
row_src_addr:
        lda logo_lut,x
row_dst_addr0: 
        sta tech_screen_list.get(0)+X_CENTERING+Y_CENTERING*$28,x
        inx 
max_wd:
        cpx #LOGO_WIDTH
        beq !+
        jmp row_src_addr
!:      
        :increment_src_row(row_src_addr)
        :increment_dest_row(row_dst_addr0)
        iny 
        cpy #LOGO_HEIGHT
        beq !+
        jmp copy_rw
!:

//Copy the first screen shifted 1 character to the right
scrindex:
//.break 
        ldx #0
        lda screens_addr_hi,x 
        sta screen_ad+2
        lda screens_addr_lo,x
        sta screen_ad+1 

        :set_addr(tech_screen_list.get(0), source_ad)

        lda #0 
        sta rowfs+1
rowlp: 
        ldx #0
x_mrg:
        ldy #1
!:
source_ad:
        lda tech_screen_list.get(0),x 
screen_ad:
        sta $ffff,y  
        inx       
        iny 
        cpy #$27
        bne !- 

        :increment_dest_row(source_ad)
        :increment_dest_row(screen_ad)
        
        inc rowfs+1
rowfs:
        lda #0 
        cmp #27
        bne rowlp

        inc x_mrg+1

        inc scrindex+1
        lda scrindex+1
        cmp #tech_screen_list.size()-1
        beq !+
        jmp scrindex
!:
        rts

spread_charset:
        ldx #$0
!: 
.for(var x=0;x<8;x++){
        lda logo_charset_b1+x*$100,x 
        .if(!SKIP_BANKSWITCH_ROUTINE){
                sta logo_charset_b2+x*$100,x 
                sta logo_charset_b3+x*$100,x
        }
}
        dex 
        bne !-
        rts 

sin_pt:
.byte 0 

.var sfm_offset = 0
.var t_b = 0
.var d018_val_byte_offset = 1
.var d016_val_byte_offset = 9
.var dd00_val_byte_offset = 11

.pc = * "update tech values fn"
.if(FLI_BUG_COLOUR=="black"){
        .eval d018_val_byte_offset = 11
        .eval d016_val_byte_offset = 6
  //      .var dd00_val_byte_offset = 11
}

.pc = * "transition_sin"
.import source("data/transition_sin.asm")

.pc = * "colour table pt sin"
.import source("data/colour_pt_sin.asm")
.import source("functions_tech_intro.asm")
.import source("functions_tech_colour.asm")

.pc = * "Unrolled code generators"
.import source("unrolled_code_generators.asm")

.pc = * "Bankswitch movement generator (Line template)"
bankswitching_movement_line_template_start:
        ldx tech_sin_bankswitch,y
        
        lda tech_d018_table,x 
add_18_here0:
        sta tech_values_start+d018_val_byte_offset //add sfm_offset += 18
        //if bankswitching is needed
        ora tech_dd00_table,x 
add_18_here1:
        sta tech_values_start+11

        lda tech_d016_table,x 
add_18_here2:
        sta tech_values_start+d016_val_byte_offset  //add sfm_offset += 18

        clc 
        tya 
        adc speed
        tay 
bankswitching_movement_line_template_end:

.pc = * "Bankswitch movement generator (Jmp back instruction template)"
bankswitching_movement_line_template_jmp_back:
        jmp end_movement

.pc = * "Colour movement generator (Line template)"
colour_movement_line_template_start:
        ldx tech_sin_colour,y
        lda tech_d018_table,x 
add_18_here3:
        sta tech_values_start+d018_val_byte_offset //add sfm_offset += 18
add_18_here4:
        sta tech_values_start+11
        lda tech_d016_table,x 
add_18_here5:
        sta tech_values_start+d016_val_byte_offset  //add sfm_offset += 18
        iny 
colour_movement_line_template_end:

.pc = * "Colour movement generator (Jmp back instruction template)"
colour_movement_line_template_jmp_back:
        jmp end_movement_colour


//.pc = movement_unrolled_code_address "Bankswitch movement generator (Unrolled code)"
//movement_unrolled_code:

/*

        .for(var x=0;x<RASTER_FX_LINES;x++){
       
        ldx tech_sin,y
        
        lda tech_d018_table,x 
        sta sfm_offset+tech_values_start+d018_val_byte_offset //ldx #$ff

        //if bankswitching is needed
        ora tech_dd00_table,x 
        sta sfm_offset+tech_values_start+11

        lda tech_d016_table,x 
        sta sfm_offset+tech_values_start+d016_val_byte_offset //ldy #$ff

        clc 
        tya 
        adc speed
        tay 
        .eval sfm_offset += 18
        
}       
       jmp end_movement
*/