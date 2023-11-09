top_irq:
        sta r_zp_1 //3
        stx r_zp_2 //3
        sty r_zp_3 //3 

        dec $00

		lda #<overlay_stabilized_irq 
        sta $fffe //6
d022_fix:
        lda #0 
        sta $d022 
		//lda #>overlay_stabilized_irq 
        //sta $ffff //6

		asl $d019 //6
		inc $d012 //6
    
		tsx

		cli //2 
		.for (var x=0;x<40;x++){
			nop //2
		}
  		
		brk

.pc = * "overlay stabilized irq"
//overlay movement irq
overlay_stabilized_irq:
        txs
        //inc $d018 
        lda bg_col
        sta $d021 

		ldx #$05
!:		dex       	
		bne !-    
        nop
        nop

	    lda #overlay_irq_rasterline+1  //2 
		cmp $d012   //4
		beq !+		//2-3 cycles
!:

        ldx #$05
!:      dex
        bne !-
        nop
        nop
        jmp goirq

//------------------------------------------
//      THESE ARE BYPASSED
//------------------------------------------

deljmp:
        jmp seconddel
firstdel:
        bit $24
        nop 

        jmp delhi

seconddel:
        bit $24
        bit $24 

        jmp delhi    

delhi:
        nop //must become bit $24 accordingly  to sinpt 
        nop 

        jmp goirq

//------------------------------------------

.pc =   unrolled_irq_addr+$15f "Unrolled irq main routine"
goirq:
        ldx #0
        stx irq_ct

.macro good_line(delay){
        lda illegal_table_addr,x
        sta $d018
        inx 
        ldy #delay
!: 
        dey 
        bpl !-
        bit $24 
}

.macro good_line_plex_sprite(delay, dest_y, sprite_nr){
        lda illegal_table_addr,x
        sta $d018
        inx 
        ldy #delay
!: 
        dey 
        bpl !-
        nop
        lda #dest_y
        sta $d001+(sprite_nr*2)
}

.macro good_line_pre_bad_line(){

        lda illegal_table_addr,x
        sta $d018
        inx 
        bit $24 
        bit $24
        bit $24   
        bit $24 
        bit $24
        bit $24 
        bit $24

        lda illegal_table_addr,x
        inx
        ldy illegal_table_addr,x          
}
.macro bad_line(){
        bit $24          
        sta $d018     
}
.macro good_line_post_bad_line(delay){
        sty $d018
        inx 
        ldy #delay
!: 
        dey 
        bpl !-
        bit $24
        bit $24
        nop
        nop     
}

//15 cycles when not finished, 13 cycles when finished
.macro good_line_increment_plex_ct(cmp_val, backaddr){

        lda illegal_table_addr,x
        sta $d018
        inx 
        inc irq_ct //5
        lda irq_ct //3
        cmp #cmp_val  //2
        beq !+ //2 (3 when taken)
        ldy #2
rs0:
        dey 
        bpl rs0
        bit $24 
        jmp backaddr //3
!:
        ldy #3
!:
        dey 
        bpl !-
}

//---------------------------------------
.pc = * "Unrolled loop"

c0: 
        :good_line(5)
        :good_line(5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line(5)
        :good_line(5)
        :good_line_increment_plex_ct(3,c0)
//-------------------------------------------------------
//plex round 1
.var next_y = sprite_y_base+42
        :good_line_plex_sprite(4,next_y,0)
        :good_line_plex_sprite(4,next_y,1)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,2)
        :good_line_plex_sprite(4,next_y,3)
        :good_line(5)

        :good_line_plex_sprite(4,next_y,4)
        :good_line_plex_sprite(4,next_y,5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,6)
        :good_line_plex_sprite(4,next_y,7)
        :good_line(5)
//end of first plex round
//-------------------------------------------------------
//odd lines
        :good_line(3)
        nop 
        nop
        bit $24
        :good_line(5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line(5)
        :good_line(5)
        :good_line(5)
//-------------------------------------------------------
c1: 
        :good_line(5)
        :good_line(5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line(5)
        :good_line(5)
        :good_line_increment_plex_ct(4,c1)

//-------------------------------------------------------
//plex round 2
.eval next_y = sprite_y_base+42*2
        :good_line_plex_sprite(3,next_y,0)
        nop
        :good_line_plex_sprite(4,next_y,1)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,2)
        :good_line_plex_sprite(4,next_y,3)
        :good_line(5)

        :good_line_plex_sprite(4,next_y,4)
        :good_line_plex_sprite(4,next_y,5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,6)
        :good_line_plex_sprite(4,next_y,7)
        :good_line(3)
        nop 
        nop
        bit $24
//end of second plex round
//-------------------------------------------------------
c2:
        :good_line(5)
        :good_line(5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line(5)
        :good_line(5)
        :good_line_increment_plex_ct(8,c2)
//-------------------------------------------------------
//plex round 3
.eval next_y = sprite_y_base+42*3
        :good_line_plex_sprite(4,next_y,0)
        :good_line_plex_sprite(4,next_y,1)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,2)
        :good_line_plex_sprite(4,next_y,3)
        :good_line(5)

        :good_line_plex_sprite(4,next_y,4)
        :good_line_plex_sprite(4,next_y,5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line_plex_sprite(4,next_y,6)
        :good_line_plex_sprite(4,next_y,7)
        :good_line(5)

//-------------------------------------------------------
c3:
        :good_line(5)
        :good_line(5)
        :good_line_pre_bad_line()
        :bad_line()
        :good_line_post_bad_line(4)
        :good_line(5)
        :good_line(5)
        :good_line_increment_plex_ct(11,c3)
//-------------------------------------------------------
.pc = * "Unrolled loop end"

        lda #0 
        sta $d022 
        sta $d017 

btm_irq_d012:
        lda #$dd //#$08
        sta $d012      
   
        lda $d011 
d011_mask:
        ora #$0  //will become $80 
        sta $d011 

        //:set_irq(music_irq)

btm_irq_lo:
        lda #<intro_irq //music_irq 
        sta $fffe 
btm_irq_hi:
        lda #>intro_irq //music_irq
        sta $ffff 

        asl $d019

        :music()

        jsr move_sprites

        :close_irq_zp()
        inc $00
        rti