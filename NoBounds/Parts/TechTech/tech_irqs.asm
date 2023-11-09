//la linea dove inizia il logo e' 83
.const first_fli_line = 88

.for (var x=0;x<MAX_SHIFT_PX;x++){
    .var d0 = mod(first_fli_line + x,8) | $18
    .eval tech_d011_table_list.add(d0)
}

.print ("Tech d018 table size: " + tech_d018_table_list.size())
.print ("Tech d016 table size: " + tech_d016_table_list.size())
.print ("Tech d011 table size: " + tech_d011_table_list.size())

.macro waste_cycles(cycles){
    .for(var x=0;x<cycles/2;x++){
                nop
    }
}

.align $100
stabilizer_irq:
        sta r_zp_1 //3
        stx r_zp_2 //3
        sty r_zp_3 //3 

        lda #<stabilized_irq 
        sta $fffe //6
        lda #>stabilized_irq 
        sta $ffff //6

        asl $d019 //6
        inc $d012 //6 
        tsx
        cli //2 

        .for (var x=0;x<24;x++){
                nop //2
        }

        brk

stabilized_irq:
        txs //2
        
        ldx #$08    // Wait exactly  2+(8-1)*5 = 37 cicli
!:		
        dex       	//lines worth of
        bne !-    	//cycles for compare
        bit $ea     //Minus compare
        nop         //cycles

        lda #raster_irq_line+1  	//2 
        cmp $d012   //4
        beq !+		//2-3 cycles
!:  

        .for (var x=0;x<16;x++){
                nop 
        }
d023_col:
        lda #DO23_COLOUR
        sta $d023
    
         //   inc $d020 
        ldx #$f0 
//.break
tech_values_start:
.pc = * "Bankswitching routine start"
.import source("tech_irq_bankswitch.asm")
.pc = * "Bankswitching routine end"

        lda #$7b 
        sta $d011 
        
        lda #0 
        sta $d023

        asl $d019 //6
        
      // sec
!:
        lda $d012 
        cmp #$f0
        bne !-

      //  inc $d020 
        :music()
     //   dec $d020 
fx_irq_lo:
        lda #<stabilizer_irq 
        sta $fffe 
fx_irq_hi:
        lda #>stabilizer_irq
        sta $ffff 

fx_d012:
        :d012(raster_irq_line)

update_tech_fn:
        jsr update_tech_values_intro

frm_nxt0:      
        lda #$0b 
        sta $d011
frm_nxt1:
        lda #$1b 
        sta frm_nxt0+1

      //  lda #$38
      //  sta $dd00
     //   lda #$3c+1
      //  sta $dd02 

        lda r_zp_1 //3
        ldx r_zp_2 //3
        ldy r_zp_3 //3 
        rti


.pc = $3f00 "Tech music irq"
//used only once, to set the first raster line
tech_music_irq:
        :open_irq_zp()
        asl $d019
frm_nxt2:      
        lda #$0
        sta $d011 

        lda tech_d018_table
        sta $d018 

      //  lda tech_dd00_table,x 
      //  sta $dd00 

        :d016($d8)
        :bank_1()   
        :set_irq(stabilizer_irq)
        :d012(raster_irq_line)

        :music()

.if(!STANDALONE_BUILD){
        inc can_rts+1
}
        :close_irq_zp()
        rti
        
wait_for_colours_irq:
        :open_irq_zp()
        asl $d019

//.break
        inc  can_patch_irq+1 //trigger routine patch

        ldx #LOGO_CENTERING_INDEX
        lda tech_d018_table,x 
        sta $d018 

        lda tech_dd00_table,x 
        sta $dd00 

        lda #$d5
        sta $d016

        lda #DO23_COLOUR
        sta $d023
   //  :d012($f4)
        //raster routine has been patched for colours? gotta move on...
colours_patched:
        lda #0
        beq !+
        jsr update_rasters
        :set_addr(update_tech_values_colour,update_tech_fn)

        lda #<stabilizer_irq
        sta fx_irq_lo+1

        lda #>stabilizer_irq
        sta fx_irq_hi+1
        :d012(raster_irq_line)
        sta fx_d012+1
        :set_irq(stabilizer_irq)
        //jmp skipmsx
!:
        lda $d012 
        cmp #MUSIC_PATCH_RASTERLINE
        bne !-
        :music()
skipmsx:
        :close_irq_zp()
        rti

