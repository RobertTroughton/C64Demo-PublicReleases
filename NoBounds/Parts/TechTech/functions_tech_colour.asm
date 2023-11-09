//.import source "..\..\MAIN\Main-CommonDefines.asm"


null_function:
        rts

rasters_pt:
.byte 0 

.pc = $2d00 "Update tech values function (colour)"
update_tech_values_colour:
        inc sin_pt 
        ldy sin_pt 

        jmp movement_unrolled_code

end_movement_colour:
        jsr update_rasters

transition_fn:
        jsr transition_colours 

        rts

.pc = * "Update raster colours function"

.const LOGO_UPPER = RASTER_FX_LINES/2-3
.const LOGO_LOWER = RASTER_FX_LINES 
.var colour_reg_byte_offset = 11
.eval sfm_offset = 0

update_rasters:     
        ldy rasters_pt 
.for(var x=0;x<LOGO_UPPER;x++){
        iny
        lda sfm_offset+tech_values_start+colour_reg_byte_offset
        ldx rasters_sin0,y 
        ora raster_tbl,x 
        sta sfm_offset+tech_values_start+colour_reg_byte_offset
        .eval sfm_offset += 18
}

.for(var x=0;x<LOGO_UPPER;x++){
        dey
        lda sfm_offset+tech_values_start+colour_reg_byte_offset
        ldx rasters_sin0,y 
        ora raster_tbl,x 
        sta sfm_offset+tech_values_start+colour_reg_byte_offset
        .eval sfm_offset += 18
}

/*
end_update_rasters:
        ldx #0 
        lda colour_pt_sin,x
        sta rasters_pt 

        inc end_update_rasters+1
        */
        inc rasters_pt 

        rts 

transition_colours:
        ldx #0 
        lda temporary_colour_rasters_sin,x 
        sta rasters_sin0,x 

        inx 
        lda temporary_colour_rasters_sin,x 
        sta rasters_sin0,x 

        inc transition_colours+1
        inc transition_colours+1


        /*
        lda temporary_colour_rasters_sin+$80,x 
        sta rasters_sin0+$80,x 
        */
        inc rndc0+1 
rndc0:
        lda #0
        cmp #$80
        bne !+
        :set_addr(transition_movement,transition_fn)

       // lda #0 
     //   sta rasters_pt
!:

/*
        ldx #0 
        lda temporary_colour_table,x 
        sta raster_tbl,x
        inc transition_colours+1 
        
        cpx #RASTER_TBL_SIZE
        bne !+
        :set_addr(transition_movement,transition_fn)
!:
*/
        rts 

transition_movement:
        //.if(STANDALONE_BUILD){
            lda rasters_pt 
            cmp #$22 //$24
            bne !+

            inc can_start_trns+1
    !:
/*        }
        else {
.if (FINAL_RELEASE_DEMO == 0)
{
    		:BranchIfFullDemo(DoSync)
            lda rasters_pt 
            cmp #$22 //$24
            beq !+
            bne !++
		DoSync:
}
            lda MUSIC_FrameLo
		    cmp #<SYNC_TechTechWave
		    lda MUSIC_FrameHi
		    sbc #>SYNC_TechTechWave
		    bcc !++
    !:
            lda #$01
            sta can_start_trns+1
    !:
        }
*/
can_start_trns:
        lda #0 
        bne !+
        rts
!:

upt0:   
        ldx #0 
        lda temporary_colour_movement_sin,x 
        sta tech_sin_colour,x 
        
        inx        
        lda temporary_colour_movement_sin,x 
        sta tech_sin_colour,x 

        inc upt0+1 
        inc upt0+1 

        inc rndcm0+1
rndcm0:
        lda #0
        cmp #$80
        bne !+
        :set_addr(wait_for_end,transition_fn)
!:
        rts

//wait some frames before killing the fx
wait_for_end:
   
delayer0:
        lda #0 
        eor #$ff 
        sta delayer0+1
        bne !+
        rts
!:
        inc tk0+1
tk0:
        lda #0 
        cmp #COLOUR_ROUTINE_TIME 
        bne !+
        :set_addr(transition_end,transition_fn)
!:
        rts

.macro decr_offset(offset,addr){
        lda addr+1 
        sec 
        sbc #offset 
        sta addr+1
        bcs !+
        dec addr+2
!:
}

transition_end:
        //lda #$7b 
      //  .break

.const CLOSE_OFFSET = 18*[LOGO_LOWER-1]
/*
add_18_here7:
        lda tech_values_start+1 
        and #$7 
        ora #$78 
        
add_18_here6:
        and tech_values_start+1

        :incr_offset(18,add_18_here6)
        :incr_offset(18,add_18_here7)

*/
sub_18_here0:
        lda tech_values_start+1 +CLOSE_OFFSET
        and #$7
        ora #$78
sub_18_here1:
        sta tech_values_start+1 +CLOSE_OFFSET
        :decr_offset(36,sub_18_here0)
        :decr_offset(36,sub_18_here1)


sub_18_here2:
        lda tech_values_start+1 +CLOSE_OFFSET-18
        and #$7
        ora #$78
sub_18_here3:
        sta tech_values_start+1 +CLOSE_OFFSET-18
        :decr_offset(36,sub_18_here2)
        :decr_offset(36,sub_18_here3)
     
inc final_ct+1
final_ct:
        lda #0 
        cmp #RASTER_FX_LINES/2 //LOGO_UPPER+2
        bne !+
        //dec final_ct+1 
        :set_addr(null_function,transition_fn)

        lda #<closing_irq
        sta fx_irq_lo+1
        sta $fffe 

        lda #>closing_irq
        sta fx_irq_hi+1

        sta $ffff 
        lda #$f0
        sta fx_d012+1
        sta $d012

        lda #$7b 
        sta frm_nxt1+1
        sta frm_nxt0+1
      //  inc $d020 
        :d011($7b)
!:
        rts 


.pc = * "final irq"
final_irq:
        :open_irq_zp()
        asl $d019

        :music()

        :d011($0)
        :d012($0)

        lda #$38
        sta $dd00
        lda #$3c+1
        sta $dd02 
      
        inc PartDone
       
        :close_irq_zp()
        rti 