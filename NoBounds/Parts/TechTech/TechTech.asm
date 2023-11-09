/**
TechTech

2023 G*P
Code: Elder0010
*/
#import "macros.asm"

#import "variables.asm"
#import "scene_settings_tech.asm"
#import "data/parser.asm"

.if(!STANDALONE_BUILD){
	.import source "../../MAIN/Main-CommonDefines.asm"
	.import source "../../MAIN/Main-CommonMacros.asm"
	.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
}

.if(STANDALONE_BUILD){
 	*=music.location "Music"
	.fill music.size, music.getData(i)	
    :BasicUpstart2(start)
}

.macro music(){
	//inc $d020 
	.if(STANDALONE_BUILD) {
		jsr music.play
	} else {
		jsr BASE_MUSICPLAY
	}
	//dec $d020
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

.pc = $3a00 "Logo sin (bankswitch)"
tech_sin_bankswitch:
//.import source("data/tech_sin0.asm")
.import source("data/tech_sin_bankswitch.asm")

.pc = * "Logo LUT"
logo_lut:
//.import source( "data/logo/triangle/logo - LUT.asm" )	

//.pc = $3800 "Logo sin (colour)"	
.pc = $9300 "tech tables"
.import source("data/tech_tables.asm")

.pc = * "Raster colour table"
.import source("data/rasters.asm")	

tech_sin_colour:
.import source("data/tech_sin_colour.asm")

.pc = TechTechStart "main routine"
start:
.if (STANDALONE_BUILD){
		sei
		:kernal_off() 
		lax #0 
		tay
		jsr music.init
		:turn_off_cia_turn_on_raster_irq()
		:wait_frame()

		lda #D020_COLOUR
        sta $d020 
		lda #D021_COLOUR
		sta $d021 
	//	:d011($80)
}		
    	:wait_frame()
		:set_irq(safe_irq)

irq_triggered:
        lda #0 
        beq irq_triggered
        
		lda #0
		sta $d015
		sta $d016
		sta $d020 

		//Turn direct bus lock on by writing #$03 to $DD02
		lda #$03 
		sta $dd02 
	
        lda #D022_COLOUR  
        sta $d022
        lda #DO23_COLOUR
        sta $d023

		jsr generate_movement_bankswitch

        jsr prepare_screens
		jsr spread_charset

		.if(SKIP_BANKSWITCH_ROUTINE){
			jsr patch_irq_for_colours
			jsr generate_movement_colour
			jsr relocate_colour_sin
			:set_addr(update_tech_values_colour,update_tech_fn)
		}

		//;-------------------------
		//; Sync check
		//;-------------------------
		
		.if(!STANDALONE_BUILD){
		
			:BranchIfNotFullDemo(SkipSync)
			MusicSync(SYNC_TechTechFadeIn-1)
		SkipSync:
		}

        lda #0 
        sta PartDone
        inc init_finished+1
.if(STANDALONE_BUILD){
		:wait_frame()
		cli
}
can_patch_irq:
		lda #0 
		beq can_patch_irq
		jsr patch_irq_for_colours
		jsr generate_movement_colour
		jsr relocate_colour_sin
        inc colours_patched+1

.if(STANDALONE_BUILD){
		jmp *
}

can_rts:
		lda #0 
		beq can_rts
		rts

.pc = logo_charset_b1 "logo charset" 
//.import binary("data/logo/triangle/logo - Chars.bin")

.pc = $e000 "Tech functions"
.import source("functions_tech.asm")

d012cnt:
.byte $34
init_irq:
        :open_irq_zp()
      
        :music()

        asl $d019
    //    :d011($80)
        sec 
        lda d012cnt
d012amt:
        sbc #16
        sta d012cnt
        sta $d012
        cmp #$f0
        bcc !+
frm_nxt:      
        lda tech_d018_table
        sta $d018 

        lda tech_dd00_table,x 
        sta $dd00 

        :d016($d8)
		:bank_1()   
		:set_irq(tech_music_irq)
		:d012($f9)

		lda #$0
        sta $d011 
		sta d012amt+1
!:
        :close_irq_zp()
        rti

d012_val:
.byte $f1

closing_irq:
		:open_irq_zp()

		:music()
		asl $d019 
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
		
        lda #0
        sta d012add+1
		sta d012_val
        sta $d012
        sta $d011
		:set_irq(final_irq)
!:	
		:close_irq_zp()
		rti 

.pc = $9000 "Rasters sin"
.import source("data/rasters_sin0.asm")

.pc = $2000 "Tech irqs"
.import source("tech_irqs.asm")	

safe_irq:
        :open_irq_zp()
        :music()
        asl $d019 

        :d011($0)
        inc irq_triggered+1

init_finished:
        lda #0
        beq !+
        :set_irq(init_irq)
		:d011($80)
    	:d012($34)
!:
        :close_irq_zp()
        rti 