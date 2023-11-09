/**
ReflectorTW

2023 G*P
Code: Elder0010
*/

#import "../TechTech/macros.asm"
#import "variables.asm"
#import "scene_settings.asm"
#import "data/column_parser.asm"
#import "data/color_extractor.asm"
#import "data/reflection_anim_parser.asm"

.if(STANDALONE_BUILD){
 	*=music.location "Music"
	.fill music.size, music.getData(i)	
    :BasicUpstart2(start)
}

.macro music(){
      //  inc $d020 
	.if(STANDALONE_BUILD) {
		jsr music.play
	} else {
		jsr BASE_MUSICPLAY
	}
      //  dec $d020
}

.macro open_irq_zp(){
	sta r_zp_1 //3
	stx r_zp_2 //3
	sty r_zp_3 //3 
    lda $01
    sta r_zp_4
    lda #$35
    sta $01
}

.macro close_irq_zp(){
	lda r_zp_4
    sta $01
	lda r_zp_1 //3
	ldx r_zp_2 //3
	ldy r_zp_3 //3
}

.pc = ReflectorTransitionStart "Main routine"
start:
.if (STANDALONE_BUILD){
        sei
        :kernal_off() 
        lax #0 
        tay
        jsr music.init
        :turn_off_cia_turn_on_raster_irq()
        :wait_frame()

        :bank_1()
}		

        lda #$3c+1
        sta $dd02

        //copy the first frame into the sprites
        ldx #$0 
!:
        lda first_sprite,x
        sta sprites_1,x

        lda first_sprite+$100,x
        sta sprites_1+$100,x
        dex 
        bne !-

        jsr init_screen

        jsr anim_sprites
        
        lda #<first_sta_address
        sta sta_dest_zp 
        lda #>first_sta_address
        sta sta_dest_zp+1

       
        :set_irq(init_irq)
        //:set_irq(music_irq)


.if(STANDALONE_BUILD){
        :d011($0)
        :d012($0)
        :wait_frame()
        cli
}         

.if(STANDALONE_BUILD){
        jmp *
} else {
        rts
}

plexed_y:
.byte sprite_y_base, sprite_y_base+21 
.byte sprite_y_base+21*2, sprite_y_base+21*3
.byte sprite_y_base+21*4

music_irq:
        :open_irq_zp()
        asl $d019 
        //inc $d020 
        :music()
       // dec $d020 
        :d011(0)


endirq:
        :close_irq_zp()
        rti


.pc = * "functions"
.import source("transition_functions.asm")


.pc = * "Transition intro"
.import source("transition_intro.asm")

.pc = * "First frame sprites data"
.import source("data/first_sprite.asm")