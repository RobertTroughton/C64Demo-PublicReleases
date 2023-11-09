/**
SpriteFPP

2023 G*P
Code: Elder0010
*/
#import "../TechTech/macros.asm"
#import "variables.asm"
#import "scene_settings.asm"
#import "data/frames_list.asm"
#import "data/palette.asm"
//#import "data/ExportFrames/dither2-point-shadow-cross/frames_list.asm"
//#import "data/ExportFrames/dither2-point-shadow-cross/palette.asm"

#import "data/shrink_calculator.asm"
#import "data/texture_mapper.asm"
#import "data/sprite_writer.asm"
#import "data/frames_writer.asm"


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

.macro open_irq_zp_stacked(){
	sta r_zp_stacked_1 //3
	stx r_zp_stacked_2 //3
	sty r_zp_stacked_3 //3 
}

.macro close_irq_zp_stacked(){
	lda r_zp_stacked_1 //3
	ldx r_zp_stacked_2 //3
	ldy r_zp_stacked_3 //3
}

.pc = SpriteFppStart "main routine"
start:
.if (STANDALONE_BUILD){
        sei
        :kernal_off() 
        lax #0 
        tay
        jsr music.init
        :turn_off_cia_turn_on_raster_irq()
        :wait_frame()
        :d012($0)
}		

       
.if(STANDALONE_BUILD){
        :wait_frame()

.if(FAST_FORWARD_MUSIC){

fhi:
        lda #0 
frames:
        ldx #0
!:
        :music()
        dec frames+1
        bne !- 
        inc fhi+1
        lda fhi+1
        cmp #$10
        beq !+
        lda #0 
        sta frames+1
        jmp frames
!:
}

        cli
}             
	
      
        //Turn direct bus lock on by writing #$03 to $DD02
      //  lda #$03 
       // sta $dd02 

      //  lda #palette_list.get(0)
       // sta $d020 
        //sta $d021 

/*        ldx #palette_list.get(0)
!:
        sta $d800,x
        sta $d800+$100,x 
        sta $d800+$200,x 
        sta $d800+$300,x
        dex 
        bne !-
*/
        

        .if(STANDALONE_BUILD)
{
        :bank_1()
}
else
{
     
}

      :wait_frame()
          
        :d011($fb)
        :d012($20)                  //; start raster line: $138 - $18
      //  :d012($f9)
        //:set_irq(music_irq)
        :set_irq(init_irq)

      //  lda #0
      

       // lda #0 
       // sta z_position

        //jsr clear_fpp_table_top
        //jsr clear_fpp_table
        
        lda #$ff 
        ldx #0 

        stx frame_pt
        stx tunnel_delayer_ct

       // lda #0
        stx x_size
        stx palette_index
        stx can_extra_speed0
        stx can_extra_speed1
        stx can_extra_speed2
        stx can_extra_speed3
        stx can_extra_speed4

!:
        sta FppTab,x 
        dex
        bne !-

       // lda #fpp_position
      //  sta logo_y_pos

        //clc 
        lda #fpp_position+8
        sta fpp_start_line

        jsr init_sprites
        jsr clear_fpp_table

        lda #$7f
        sta rotation_speed0 
        sta rotation_speed1
        sta rotation_speed2
        sta rotation_speed3

        sta rotation_halver0
        sta rotation_halver1
        sta rotation_halver2
        sta rotation_halver3

        lda #ACCELERATE
        sta rotation_state

        lda #$0
        sta rotation_speed_pt
        sta rotation_speed_pt_hi
        sta $7fff

        lda #ROTATION_FORWARD
        sta rotation_direction

        lda #$7f
        sta y_size

      //  inc init_complete+1

.if(STANDALONE_BUILD){
        jmp *
} else {
        rts
}

init_irq:
        :open_irq_zp()
      //  inc $d020 
        :music()
      //  dec $d020 
        asl $d019
   
        sec
d012cnt:
        lda #$20
        sbc #$18                    //; decrease by $18
        sta d012cnt+1
        sta $d012
        bcs !+
        ldx #$7b
        stx $d011
!:      cmp #$c0                    //; last raster line before switching to next IRQ: $d8 (same as before)
        bne !+
        :set_irq(fpp_bottom_irq)
        :d012($fa)

        lda #$3d
        sta $dd02

        :d016($c8)
        :d018(d018_val)

!:
        :close_irq_zp()
        rti

/*
//.break
music_irq:
        :open_irq()
        asl $d019  
        :music()
        
init_complete:
        lda #0 
        beq !+
       
        inc start_del+1
start_del:
        lda #0 
        cmp #FX_START_DELAY
        bne !+
        :set_irq(fpp_bottom_irq)
       :d011($7b)
        :bank_1()
!:
//inc $d020 
        :close_irq()
        rti
*/

.pc = * "X sin (slow grow)"
x_sin:
.import source("data/x_sin.asm")

.pc = $8000 "Fpp IRQ"
.import source("fpp_irq.asm")

.pc = * "X pulse sin"
x_pulse_sin:
.import source("data/x_pulse_sin.asm")

.pc = * "Actions"
.import source("actions.asm")

.pc = * "Functions"
.import source("functions.asm")

.pc = * "X shrink values"
.import source("data/x_shrink_values.asm")

.pc = * "Rotation speed tables"
.import source("data/rotation_speed_tables.asm")

.pc = * "Y pulse sin"
y_pulse_sin:
.import source("data/y_pulse_sin.asm")

.pc = * "Y stretch sin"
y_sin:
.import source("data/y_sin.asm")