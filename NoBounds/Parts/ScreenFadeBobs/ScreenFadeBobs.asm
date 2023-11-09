/**
ScreenFadeBobs

2023 G*P
Code: Elder0010
*/
#import "macros.asm"
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
//.import source("data/converter.asm")
.pc = main_routine "main routine"
start:
.if (STANDALONE_BUILD){
		sei
		:kernal_off() 
		lax #0 
		tay
		jsr music.init
		:turn_off_cia_turn_on_raster_irq()
}	
		:wait_frame()
		:d011(0)

		lda #BORDER_COLOUR
		sta $d020 
		lda #BACKGROUND_COLOUR
		sta $d021 

		jsr init_screen

		lda #d018_val
		sta $d018 

		lda #0
        sta $d015
        
		:d016($d8)
		:set_irq(delay_irq)
		:d012($f9)
		:wait_frame()
		:d011($1b)
		cli

		jmp *

delay_irq:
		:open_irq()
		asl $d019

		:music()
		inc introd+1
introd:
		lda #0 
		cmp #INTRO_DELAY
		bne !+
		:set_irq(music_irq)
!:
		:close_irq()
		rti

music_irq:
		:open_irq()
		asl $d019
		:music()
		inc sptk+1
sptk:
	 	lda #0 
		cmp #SPEED_DELAY
		bne !+

		lda #0 
		sta sptk+1

unlock_fn:
		jsr unlock_columns			
draw_fn:
		jsr draw_rows
!:
		:close_irq()
		rti

.pc = charset "charset"	
.import binary("data/charset.bin")	

charset_end:
.fill $8,$0

.pc = * "map"
.import source("data/map.asm")

.pc = * "functions"
.import source("functions.asm")

.pc = * "frames index"
frames_index:
.for(var x=0;x<$28;x++){
    .byte x
}

can_draw_column:
.fill 40,0

frame_pointers:
.fill 40,ANIMATION_LENGTH