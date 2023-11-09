/**
RaytraceNightmare

2023 G*P
Code: Elder0010
*/

#import "../TechTech/macros.asm"
#import "variables.asm"
#import "scene_settings.asm"
#import "data/parser.asm"

.import source "..\..\MAIN\Main-CommonDefines.asm"

.if(STANDALONE_BUILD){
 	*=music.location "Music"
	.fill music.size, music.getData(i)	
        :BasicUpstart2(start)
}

.macro music(){
	.if(STANDALONE_BUILD) {
		jsr music.play
	} else {
		jsr BASE_MUSICPLAY
	}
}

.macro open_irq_zp(){
	sta r_zp_1 //3
	stx r_zp_2 //3
	sty r_zp_3 //3 
}

.macro close_irq_zp(){
	lda r_zp_1 //3
	ldx r_zp_2 //3
	ldy r_zp_3 //3
}

.pc = RaytraceNightmareStart "Main routine"
start:
.if (STANDALONE_BUILD){
        sei
        :kernal_off() 
        lax #0 
        tay
        jsr music.init
        :turn_off_cia_turn_on_raster_irq()
       // :kill_nmi()
        //:wait_frame()
       // :d011($0)    
}	

        .if (STANDALONE_BUILD)
        {
        :bank_1()
        }
        else
        {
        lda #$3d
        sta $dd02
        }

        lda #d018_val
        sta $d018

        lda #$d0
        sta $d016 

        jsr init_screen

        lda #0 
        sta frame_nr
        sta palette_pt
        sta palette_list_pt
        sta sprite_x_pt

        :wait_frame()
        :set_irq(init_irq)
        
.if(STANDALONE_BUILD){
        :d012($dd)
        :d011($0)
       // :wait_frame()
        cli
        jmp *
} 

exitscene: 
        rts
//d012cnt:
//.byte $f9

init_irq:
        :open_irq_zp()
        lda $01
        sta r_zp_4
        lda #$35
        sta $01

       // inc $d020 
        :music()
      //  dec $d020 
        asl $d019
   
        sec 
       d012cnt:
        lda #$f9
        sec
        sbc #$04
        sta d012cnt+1
        sta $d012
        cmp #$dd
        bcs !+
        :set_irq(intro_irq)
        :d012($dd)
!:
        lda r_zp_4
        sta $01

        :close_irq_zp()

        rti

intro_irq:
        :open_irq_zp()

        dec $00

        :music()
 
        inc startdel+1
startdel:
        lda #0
        cmp #FX_START_DELAY
        bne !+
        
        lda #<music_irq
        sta btm_irq_lo+1

        lda #>music_irq
        sta btm_irq_hi+1

        lda #$80
        sta d011_mask+1
        
     //   lda #$20 
     //   sta msx_play

        lda #$08 
        sta btm_irq_d012+1
        jmp irqgo
!:
        asl $d019
        lda #0 
        sta bg_col
        sta d022_fix+1
        sta $d023
        sta $d021
        sta $d022 

        :d011($1b)
        :d012(dma_irq_line)
        :set_irq(stabilizer_irq)

        :close_irq_zp()

        inc $00

        rti

music_irq:
        :open_irq_zp()

        dec $00

        asl $d019 
irqgo:
        ldx sinpt

        lda sintable_frame,x
        sta frame_nr

        lda $d016 
        and #$f8
d016_addr:
        ora sintable_lo,x
        sta $d016 

jmp_table_lo_addr:
        ldy sintable_hi,x
        sty sin_hi

    //--------------------------------------
    //  REMOVE THIS
    //--------------------------------------

//handle delay in unrolled irq
        tya 
        cmp #2 
        bpl !+
        :set_addr(seconddel,deljmp)
     //   inc $d020 
        jmp enddelset
!:
        :set_addr(firstdel,deljmp)

    //--------------------------------------

enddelset:
        lda jmp_table_lo,y
        sta delay_fn+1
        
        lda jmp_table_hi,y 
        sta delay_fn+2 
//skpfr:
     //   lda #0 
   //     beq !+
        :d011($1b)
        :d012(dma_irq_line)
        :set_irq(stabilizer_irq)
        inc sinpt
        asl $d019 

        lda #0 
        sta $d021 

        lda #sprite_y_base
        sta $d001 
        sta $d003 
        sta $d005 
        sta $d007 
        sta $d009
        sta $d00b
        sta $d00d
        sta $d00f
 
        jsr draw_frame
skipirq:

//inc $d020
clean_val:
        lda #$00 //d018_val
        .for(var x=0;x<FX_RASTERLINES;x++){
                sta illegal_table+x
        }
//dec $d020 

        lda #$ff 
        sta $d017         

        ldx #0
!:
        ldy horizontal_sin_pt,x
        inc horizontal_sin_pt,x
        lda horizontal_sin,y
        sta tmp 
        ldy horizontal_positions,x 
        
        tya 
        clc 
        adc tmp 
        tay 
     
        lda horizontal_black_val
        sta illegal_table,y
        inx 
        cpx #$8
        bne !-

        :close_irq_zp()

        inc $00

        rti

d012_val:
.byte $dd

final_irq:
        :open_irq_zp()

        dec $00

        asl $d019 

        lda #0 
        sta $d015 
      //  inc $d020 
        :music()

       // dec $d020 
          
        lda d012_val
        clc
d012add:
        adc #4
        sta d012_val
        sta $d012 
        bmi !+
        lda #1 
        sta PartDone
        lda #0 
        sta d012add+1

        :set_irq(raster_close_irq_top)

     

!:
        :close_irq_zp()

        inc $00

        rti 


.pc = * "Palette"
.import source("data/palette.asm")

.pc = * "functions"
.import source("functions.asm")


.pc = $b400 "Sintable"
.import source("data/sintable.asm")

.align $100
.import source("vsp.asm")

.pc = sprites_0 "Sprites bank1"
.import source("data/sprite.asm")

.pc = sprites_1 "Sprites bank2"
.import source("data/sprite.asm")

.import source("data/horizontal_sin.asm")

/*
.pc = illegal_table_addr "Illegal table"
illegal_table: 
.for (var x=0;x<FX_RASTERLINES;x++){
    .byte d018_val_blank1
}
*/
.pc = $bf00 "Sprite x movement table and routines"
.import source("data/sprites_x_tables.asm")

.pc = unrolled_irq_addr "unrolled irq code"
.import source("unrolled_irq.asm")

.pc = $9e00 "VSP delay routines"
.import source ("delay_routines.asm")

/*
.pc = blank_charset_0 "Blank charset bank1"
.fill $800,$ff

.pc = blank_charset_1 "Blank charset bank2"
.fill $800,$ff
*/

.pc = $fe00 "End transition"

.const rst_delay = 5
raster_close_irq_bottom:
        //:open_irq_zp()
        sta r_zp_a
        stx r_zp_x
        sty r_zp_y
        
        lda $01
        pha
        lda #$35
        sta $01

        lda #DARK_GRAY 
        
        ldy #rst_delay
!:
        dey 
        bpl !-
      
        sta $d020 

firq_d012:
        lda #$2c
        sta $d012 
        
firq_d011:
        lda #$80
        sta $d011 

firq_lo:
        lda #<raster_close_irq_top
        sta $fffe 

firq_hi:
        lda #>raster_close_irq_top
        sta $ffff 
        
        //:set_irq(raster_close_irq_top)
        asl $d019 

        pla
        sta $01
        
        lda r_zp_a
        ldx r_zp_x
        ldy r_zp_y
    
        //:close_irq_zp()
        rti 


raster_close_irq_top:
        :open_irq_zp()
        
        lda $01
        pha
        lda #$35
        sta $01

        lda #BLACK 
        ldy #rst_delay
!:
        dey 
        bpl !-
        sta $d020 
        
sinptend:
        ldx #0 
        lda end_sinus_lo,x
        sta $d012 

        lda end_sinus_hi,x
        sta $d011 
        
        :set_irq(raster_close_irq_bottom)

        inc sinptend+1

        lda sinptend+1
        cmp #53
        bne !+
        dec sinptend+1

        lda #<Sparkle_IRQ 
        sta firq_lo+1

        lda #>Sparkle_IRQ
        sta firq_hi+1

        lda #$00 
        sta firq_d012+1

        lda #0
        sta firq_d011+1

        lda #1 
        sta PartDone 
!:

        asl $d019 
        cli
playmsxtop1:
        lda #0 
        beq !+
    
        :music()
!:

        lda #1
        sta playmsxtop1 + 1

        pla
        sta $01

        :close_irq_zp()

        rti 

/*
quit_irq:
        :open_irq_zp()
        dec $00
        asl $d019

       // inc $d020 
        :music()

     //   dec $d020

       
        :close_irq_zp()
        inc $00
        rti 
*/

.var end_sinus_list = List().add(290,285,278,270,263,255,248,241,233,226,219,211,204,197,190,183,176,170,163,156,150,143,137,131,125,119,113,107,101,96,90,85,80,75,70,65,61,56,52,48,44,40,36,33,30,26,23,21,18,16,13,11,9,7,6,5,3,2,1,1,0)

end_sinus_lo:
.for (var x=0;x<end_sinus_list.size();x++){
    .byte <end_sinus_list.get(x)&$ff
}

end_sinus_hi:
.for (var x=0;x<end_sinus_list.size();x++){
   .if(end_sinus_list.get(x)>255){
    .byte $80
   } else {
    .byte $0
   }
}