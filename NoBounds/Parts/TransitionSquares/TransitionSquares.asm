/**
TransitionSquares

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

.macro save_01(){
    lda $01
    sta backup_01

    lda #$35
    sta $01
}

.macro restore_01(){
    lda backup_01
    sta $01

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
        lda #BORDER_COLOUR
		sta $d020 
		sta $d021 

        lda #$3c + 3
        sta $dd02

		jsr init_screen

		lda #d018_val
		sta $d018 

		:d016($c8)

		:wait_frame()
		:d011($10)
        :d012($0)
        :set_irq(delay_irq)

.if(STANDALONE_BUILD){
		cli
        jmp *
} else {
        rts
}

delay_irq:
		:open_irq()
        //:save_01()

        asl $d019

		:music()
		inc introd+1
introd:
		lda #0 
		cmp #INTRO_DELAY
		bne !+
		:set_irq(music_irq)
!:

        //:restore_01()
		:close_irq()
		rti

music_irq:
		:open_irq()
        //:save_01()

      //  lda #$35 
       // sta $01

fade_fn:
        bit fade_screen
		asl $d019
		:music()
		inc sptk+1
sptk:
	 	lda #0 
		cmp #SPEED_DELAY
		bne !+

		lda #0 
		sta sptk+1
      //  inc $d020
unlock_fn:
		jsr unlock_columns			
draw_fn:
		jsr draw_rows
!:
      //  dec $d020 

nextirq_lo:
        lda #<music_irq
        sta $fffe 

nextirq_hi:
        lda #>music_irq
        sta $ffff 

        //:restore_01()
		:close_irq()
		rti

final_irq:
        :open_irq()
        //:save_01()
        asl $d019

        :music()
         :d011($0)
         lda #$38
        sta $dd00
        lda #$3c+1
        sta $dd02 
        
        lda #1
        sta PartDone

        //:restore_01()
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