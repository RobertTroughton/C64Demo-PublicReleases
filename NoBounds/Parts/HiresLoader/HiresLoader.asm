/**
HiresLoader

2023 G*P
Code: Elder0010
*/

#import "../TechTech/macros.asm"
#import "variables.asm"
#import "scene_settings.asm"

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

.pc = HiresLoaderStart "Main routine"
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

        lda #0 
        sta $d020  
}	
        lda #$3c //+ VIC bank
        sta $dd02

        lda #$0
        sta $3fff 

        jsr init_screen
        jsr reposition_trails
        
        :wait_frame()
        :set_irq(init_irq)

.if(STANDALONE_BUILD){
        :d012($f9)
        :d011($0)
      
       // :wait_frame()
        cli
        jmp *
} else {
        rts
}

d012cnt:
.byte 0
init_irq:
        :open_irq_zp()
       // inc $d020 
        :music()
     //   dec $d020 
        asl $d019
   
        sec 
        lda d012cnt
        sbc #4
        sta d012cnt
        sta $d012
        cmp #$dd
        bcs !+
        :set_irq(music_irq)
        :d012($dd)
!:
        :close_irq_zp()
        rti

//------------------------------------------------------------
top_irq:
        :open_irq_zp()
        asl $d019 

//inc $d020 
midirq_pos:
        lda #$80
        sta $d012 

        :set_irq(mid_irq)

 // .break
//must become $14
cmp_top:
        lda #$2
!:
        cmp $d012 
        bne !-
        
top_c0:
        lda #0 
        sta $d000 
        sta $d002 
        sta $d004 
        sta $d006 

cmp_top1:      
        lda #$10
!:
        cmp $d012 
        bne !-
  //      inc $d020 
top_c1:
        lda #column1_x
        sta $d008
        sta $d00a 
        sta $d00c
        sta $d00e
//dec $d020 

//top_sprites_mask:
  //      lda #$f0
    //    sta $d015
//dec $d020 
        :close_irq_zp()
        rti
//------------------------------------------------------------
mid_irq:
        :open_irq_zp()
        asl $d019

//mid_sprites_mask:
   //     lda #$00
       // sta $d015 
//inc $d020 

lowirq_pos:
        lda #$f9
        sta $d012 

//bottom_sprites_mask1:
mid_c0:
        lda #column0_x 
        sta $d000 
        sta $d002 
        sta $d004 
        sta $d006 

mid_c1:
        lda #0
        sta $d008
        sta $d00a 
        sta $d00c
        sta $d00e
      
        :set_irq(music_irq)
//dec $d020 
        :close_irq_zp()
        rti 
//------------------------------------------------------------
enable_c1_center:
        lda #0
        cmp #10
        bne !+
        lda #column1_x
        sta mid_c1+1
        :set_addr(nothing,col_enable_fn)
!:
        inc enable_c1_center+1
        rts

nothing:
        rts 

disable_c0_bottom:
        lda #0
        cmp #10
        bne !+
        lda #0
        sta mid_c0+1
        sta bottom_c0+1
        
        :set_addr(nothing,col_enable_fn)
!:
        inc disable_c0_bottom+1
        rts 

music_irq:
        :open_irq_zp()
        asl $d019 
      //  inc $d020 
        :d011($0)

        bit $d011
        bpl *-3
        :d011($1b)
        :music()

col_enable_fn:
        jsr enable_c1_center
          
topirq_pos:
        lda #$0 
        sta $d012 

next_irq_lo:
        lda #<top_irq 
        sta $fffe 
next_irq_hi:
        lda #>top_irq
        sta $ffff 

        lda #column0_start_y+4
bottom_sprites_mask:
!:
        cmp $d012
        bne !-
     //   stx $d015 
//dec $d020 
bottom_c0:
        lda #column0_x
        sta $d000 
        sta $d002 
        sta $d004 
        sta $d006 
       // sta $d020 
        
bottom_c1:
        lda #0
        sta $d008
        sta $d00a 
        sta $d00c
        sta $d00e

        inc enab0+1
enab0:
        lda #0 
        cmp #10
        bne !+
        lda #column0_x
        sta top_c0+1
       // lda #column1_x
      //  sta mid_c1+1
!:

speed_fn:
        jsr decelerate
rep1:
        jsr reposition_trails   
        :close_irq_zp()
        rti
//------------------------------------------------------------
move_slow_irq:
        :open_irq_zp()
        asl $d019 

        bit $d011
        bpl *-3

        :music()

        lda #column1_x
        sta $d008
        sta $d00a 
        sta $d00c
        sta $d00e

        jsr reposition_trails 

        inc tk0+1
tk0:
        lda #0 
        cmp #4 
        bne !+
        lda #0 
        sta tk0+1
        dec column_left_y
        inc column_right_y    

        inc slowct+1
slowct:
        lda #0 
        cmp #SLOW_MOVEMENT_AMT
        bne !+

        :set_addr(accelerate,speed_fn)
        :set_irq(music_irq)
        lda #<top_irq
        sta next_irq_lo+1
        lda #>top_irq
        sta next_irq_hi+1

        lda #column0_x
        sta top_c0+1

        sta $d000 
        sta $d002
        sta $d004
        sta $d006

        lda #0 
        sta top_c1+1
        sta bottom_c0+1
      //  sta mid_c0+1

        lda #column1_x
        sta mid_c1+1

        lda #column0_x 
        sta mid_c0+1
        //lda #$0 
       // sta topirq_pos+1

        lda #$84
        sta midirq_pos+1

        lda #$0
        sta topirq_pos+1

        lda #$12
        sta cmp_top+1

        lda #$14 
        sta cmp_top1+1
        :set_addr(disable_c0_bottom,col_enable_fn)

!:
        :d011($1b)
        :close_irq_zp()
        rti 

final_irq:
        :open_irq_zp()
        asl $d019 
        
      //  lda #1 
      //  sta PartDone

        :music()

        :close_irq_zp()
        rti 

.pc = * "functions"
.import source("functions.asm")

.align $40 
.pc = * "Sprites"
sprites:
.import source("data/sprites.asm")
//.fill $40,$ff 

.pc = * "accel sin"
.import source("data/accel_sin.asm")

.pc = $2800 "Charset"
.import source("data/charset.asm")

