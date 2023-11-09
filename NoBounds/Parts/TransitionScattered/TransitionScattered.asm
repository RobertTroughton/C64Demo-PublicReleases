/**
TransitionScattered

2023 G*P
Code: Elder0010
*/
#import "macros.asm"
#import "variables.asm"
#import "scene_settings.asm"

.if(STANDALONE_BUILD){
 	*=music.location "Music"
	.fill music.size, music.getData(i)	
    :BasicUpstart2(TransitionScatteredStart)
}

.macro music(){
	.if(STANDALONE_BUILD) {
		jsr music.play
	} else {
		jsr BASE_MUSICPLAY
	}
}
//.import source("data/converter.asm")
.pc = main_routine "main routine"

TransitionScatteredStart:

.if (STANDALONE_BUILD){
		sei
		:kernal_off() 
		lax #0 
		tay
		jsr music.init
		:turn_off_cia_turn_on_raster_irq()
}	
	
		lda #BORDER_COLOUR
		sta $d020 
		lda #BACKGROUND_COLOUR
		sta $d021 

		jsr init_screen

		lda #d018_val
		sta $d018 

        lda #BLOCKS_NUMBER-1
        sta screen_position_pt

        :wait_frame()
		:set_irq(draw_irq)
		:d012($f9)
		:d011($10)
    
.if(STANDALONE_BUILD){
		cli
        jmp *
} else {
        rts
}

music_irq:
        :open_irq()
fade_fn:
        bit fade_border
        :music()
        :d011($10)
set_draw_irq:
        lda #1 
        beq !+
        :set_irq(draw_irq)
		:d012($f9)	
!:
        asl $d019 
        :close_irq()
        rti 

draw_irq:
		:open_irq()
		asl $d019

        :set_irq(music_irq)
		:d012($0)
		:d011($0)

        cli 
        lda #0 
        sta block_id
blkloop:
draw_fn:
        jsr draw_square

        inc block_id
        lda block_id
blockscnt:
        cmp #1
        bne blkloop

increment_fn:
        jsr increment_blocks

		:close_irq()
		rti

.pc = charset "charset"	
.import binary("data/charset.bin")	

charset_end:
.fill $8,$0

increment_blocks:
        inc incrf+1  
incrf:
        lda #0 
        cmp #4
        bne !+

        lda #0 
        sta incrf+1
        inc blockscnt+1

        lda blockscnt+1
        cmp #BLOCKS_NUMBER
        bne !+
        lda #$2c 
        sta increment_fn
!:
        rts

.pc = * "functions"
.import source("functions.asm")
.import source("data/map.asm")