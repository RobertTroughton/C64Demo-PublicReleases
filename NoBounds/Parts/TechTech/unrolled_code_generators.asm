.const bankswitching_movement_line_template_length = [bankswitching_movement_line_template_end-bankswitching_movement_line_template_start]
.const colour_movement_line_template_length = [colour_movement_line_template_end-colour_movement_line_template_start]

.macro incr_offset(offset, address){
        clc 
        lda address+1
        adc #offset //sfm_offset
        sta address+1
        bcc !+
        inc address+2
!:
}
//--------------------------------------------------------------------------------------------
//Generator for movement with bankswitching
generate_movement_bankswitch:
        lda #<movement_unrolled_code
        sta unrolled_tg_addr
        lda #>movement_unrolled_code
        sta unrolled_tg_addr+1

next_unrolled:
        ldy #0 
!:
        lda bankswitching_movement_line_template_start,y 
        sta (unrolled_tg_addr),y
        iny 
        cpy #bankswitching_movement_line_template_length
        bne !-

        :incr_offset(18,add_18_here0)
        :incr_offset(18,add_18_here1)
        :incr_offset(18,add_18_here2)
        inc lct0+1   
lct0:
        lda #0 
        cmp #RASTER_FX_LINES
        beq !+

        clc 
        lda unrolled_tg_addr
        adc #bankswitching_movement_line_template_length
        sta unrolled_tg_addr
        bcc noincunrolled
        inc unrolled_tg_addr+1
noincunrolled:
        jmp next_unrolled
!:

        ldx #0 
        ldy #0 
!:
        lda bankswitching_movement_line_template_jmp_back,x 
        sta (unrolled_tg_addr),y 
        iny 
        inx 
        cpx #3 
        bne !-
        rts

//--------------------------------------------------------------------------------------------
//Generator for movement with colour changes
generate_movement_colour:
        lda #<movement_unrolled_code
        sta unrolled_tg_addr
        lda #>movement_unrolled_code
        sta unrolled_tg_addr+1

next_unrolled_colour:
        ldy #0 
!:
        lda colour_movement_line_template_start,y 
        sta (unrolled_tg_addr),y
        iny 
        cpy #colour_movement_line_template_length
        bne !-

        :incr_offset(18,add_18_here3)
        :incr_offset(18,add_18_here4)
        :incr_offset(18,add_18_here5)

        inc lct1+1   
lct1:
        lda #0 
        cmp #RASTER_FX_LINES
        beq !+
        clc 
        lda unrolled_tg_addr
        adc #colour_movement_line_template_length
        sta unrolled_tg_addr
        bcc noincunrolled1
        inc unrolled_tg_addr+1
noincunrolled1:
        jmp next_unrolled_colour
!:

        ldx #0 
        ldy #0 
!:
        lda colour_movement_line_template_jmp_back,x 
        sta (unrolled_tg_addr),y 
        iny 
        inx 
        cpx #3 
        bne !-
        rts

relocate_colour_sin:
        ldx #0 
!:
        lda tech_sin_colour,x
        sta temporary_colour_movement_sin,x
        lda #LOGO_CENTERING_INDEX
        sta tech_sin_colour,x
        
        lda rasters_sin0,x 
        sta temporary_colour_rasters_sin,x 
        
        lda #15 //so the first colour is brown
        sta rasters_sin0,x 
        dex
        bne !-
        rts 

/*
.C:2052  A9 18       LDA #$18
.C:2054  8D 11 D0    STA $D011
.C:2057  A0 D0       LDY #$D0
.C:2059  8C 16 D0    STY $D016
.C:205c  A9 22       LDA #$22
.C:205e  8F 18 D0    SAX $D018
.C:2061  9D 10 DC    STA $DC10,X <- must become $d022
*/

//patch the raster routine to change the dd00 write to d022
patch_irq_for_colours:
        .const colour_register = [$d022-$f0]
        ldx #0 
nextpatch0:
        lda #<colour_register
raster_tglo:
        sta raster_routine+16

        lda #>colour_register
raster_tghi:
        sta raster_routine+17
        
        lda raster_tglo+1
        clc 
        adc #18
        sta raster_tglo+1
        bcc !+
        inc raster_tglo+2
!:

        lda raster_tghi+1
        clc 
        adc #18
        sta raster_tghi+1
        bcc !+
        inc raster_tghi+2
!:
        inx 
        cpx #RASTER_FX_LINES
        beq !+
        jmp nextpatch0
!:
        //lower nibble of $d022 is screwed in the next frame, so it must be fixed
        ldx #0 
nextpatch1:
colourtglo:
        lda tech_values_start+11 //add 18 here
        and #$f0 
        ora #D022_COLOUR
colourtghi:
        sta tech_values_start+11

        :incr_offset(18,colourtglo)
        :incr_offset(18,colourtghi)

        inx 
        cpx #RASTER_FX_LINES
        beq !+
        jmp nextpatch1
!:

        rts 