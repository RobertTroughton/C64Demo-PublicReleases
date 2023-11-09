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
       // inc $d020 
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

.pc = ReflectorTWStart "Main routine"
start:
.if (STANDALONE_BUILD){
        sei
        :kernal_off() 
        lax #0 
        tay
        jsr music.init
        :turn_off_cia_turn_on_raster_irq()
        :wait_frame()
}		
        //copy the first frame into the sprites
        ldx #$0 
!:
        lda first_sprite,x
        sta sprites_bk,x

        lda first_sprite+$100,x
        sta sprites_bk+$100,x
        dex 
        bne !-

        jsr drawnext

        ldx #$00
!:
        lda sprites_bk,x 
        sta sprites_1,x 

        lda sprites_bk+$100,x 
        sta sprites_1+$100,x 
        dex 
        bne !-

        jsr anim_sprites
        
        lda #<first_sta_address
        sta sta_dest_zp 
        lda #>first_sta_address
        sta sta_dest_zp+1

       // :d011($0)
        :wait_frame()
        .if(STANDALONE_BUILD)
        {
        :bank_1()
        }
        else
        {
        lda #$3d
	    sta $dd02
        }
        //:d012($f9)
       // :set_irq(intro_irq)
        :set_irq(music_irq)


.if(STANDALONE_BUILD){
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
        :d011(D011_VAL)
init_complete:
        lda #0 
        beq !+
       
        jmp endirq
!:      
        jsr draw_column
        jsr anim_sprites

drawnext_fn:
        bit drawnext

columns_fade_fn:
        jsr columns_appear

nextirq_lo:
        lda #<music_irq
        sta $fffe 
nextirq_hi:
        lda #>music_irq
        sta $ffff
endirq:
        :close_irq_zp()
        rti

.import source ("data/columns.asm")

.pc = * "functions"
.import source("functions.asm")


.pc = frame_correction_values "Frame correction values"
.import source("data/frame_correction_data.asm")


.pc = sprites_backup "Sprites (f0-f15)"
sprites_bk:
//.fill $200,$0

.pc = *+$200
.for (var x=1;x<16;x++){
    .var frame_bytes = frames_bytes.get(x)
    .for(var y=0;y<frame_bytes.size();y++){
        .byte frame_bytes.get(y)
    }
}

.pc = $a000 "Sprites (f16-f29)"
sprites_bk2:
.for (var x=16;x<29;x++){
    .var frame_bytes = frames_bytes.get(x)
    .for(var y=0;y<frame_bytes.size();y++){
        .byte frame_bytes.get(y)
    }
}


d012_val:
.byte $f8

final_irq:
        :open_irq_zp()
        asl $d019 
        :music()
        :d011($0)
        lda d012_val
        clc
d012add:
        adc #8
        sta d012_val
        sta $d012 
        bmi !+

        :d011($80)
        inc d012chk+1
!:

d012chk:
        lda #0
        beq !+
        lda d012_val
        cmp #$34 
        bcc !+
        lda #1 
        sta PartDone
        lda #0
        sta d012add+1
        sta $d012 //remove
!:
        :close_irq_zp()
        rti 

.import source("intro.asm")


