fpp_irq:
       	:open_irq_zp()
        lda #$ff 
        sta $d015 
      //  .break
        lda fpp_start_line // Wait for sprite y-position
        cmp $d012
        bne *-3

        .var delay_v = 5
.if(DEBUG_FPP || DEBUG_FP2){
        .eval delay_v = 3
}
        asl $d019

           /*
del_v:
        ldx #delay_v
        dex  
        bne *-1
        nop 
        */

        nop
        nop 

btm_irq_lo:
        lda #<fpp_bottom_irq 
        sta $fffe 
btm_irq_hi:
        lda #>fpp_bottom_irq 
        sta $ffff 

        :d012($fa)

.if(DEBUG_FPP || DEBUG_FP2){
        inc $d020
}
.const fpp_line_bytes = $24
fpp_core_loop:
    .pc = * "start loop"
        ldy #$ff 
        ldx #0
fpp_loop_start:
    .for (var x=0;x<fx_height;x++){ //should be 125 at least
        sty $d017      
        lda FppTab+x   
        sta screen+$03f8     
        sta screen+$03f9
        sta screen+$03fa
        sta screen+$03fb
        sta screen+$03fc
        sta screen+$03fd
        sta screen+$03fe 
        sta screen+$03ff
        stx $d017 // Set back $d017
}
endfpp:
        sty $d017
        lda FppTab
        sta screen+$03f8     
        sta screen+$03f9
        sta screen+$03fa
        sta screen+$03fb
        sta screen+$03fc
        sta screen+$03fd
        sta screen+$03fe 
        sta screen+$03ff
        stx $d017 

.if(DEBUG_FPP || DEBUG_FP2){
        dec $d020 
}       
        
.if(DEBUG_FPP || DEBUG_FP2){
        dec $d020
}     
        lda #0 
        sta $d015
clear_fn:
        jsr clear_fpp_table_top

//inc $d020 

//dec $d020 

//----------------------------------------
//handle speed
        lda rotation_direction
        beq !+
        lda #$e6 //inc
        jmp dirsta
!:
        lda #$c6 //dec
dirsta:
        sta diropcode1
        sta diropcode2
        sta diropcode3
        sta diropcode4
//move forward step 1
        lda rotation_halver0 
        clc
        adc rotation_speed0
        sta rotation_halver0
        bpl !+
diropcode1:
        inc frame_pt
        lda #0 
        sta rotation_halver0
!:      

//move forward step 2
        lda rotation_halver1 
        clc
        adc rotation_speed1
        sta rotation_halver1
        bpl !+
diropcode2:
        inc frame_pt
        lda #0
        sta rotation_halver1
!:    

//move forward step 3
        lda rotation_halver2 
        clc
        adc rotation_speed2
        sta rotation_halver2
        bpl !+
diropcode3:
        inc frame_pt
        lda #0 
        sta rotation_halver2
!: 
        lda rotation_halver3 
        clc
        adc rotation_speed3
        sta rotation_halver3
        bpl !+
diropcode4:
        inc frame_pt
        lda #0 
        sta rotation_halver3
!: 
//----------------------------------------
      //  inc $d020 

       // dec $d020 
        
.if(DEBUG_FPP || DEBUG_FP2){
        inc $d020 
}           

.if(DEBUG_FPP || DEBUG_FP2){
inc $d020 
}
        cli
 
      //  inc $d020 
        :music()
      //  dec $d020 
.if(DEBUG_FPP || DEBUG_FP2){
        dec $d020 
}
        :close_irq_zp()
        rti

handle_extra_speed:
        lda diropcode1
        sta extra_spd0
        sta extra_spd1
        sta extra_spd2
        sta extra_spd3

        lda can_extra_speed0
        beq !+
extra_spd0:      
        dec frame_pt 
!:
        lda can_extra_speed1 
        beq !+
extra_spd1:
        dec frame_pt
!:

        lda can_extra_speed2 
        beq !+
extra_spd2:
        dec frame_pt
!:

        lda can_extra_speed3
        beq !+
extra_spd3:
        dec frame_pt
!:

        lda can_extra_speed4
        beq !+
extra_spd4:
        dec frame_pt
!:
        rts 

handle_extra_speed_end:
        lda diropcode1
        sta extra_spd0_end
extra_spd0_end:      
        dec frame_pt 
        rts

fpp_bottom_irq:
        :open_irq_zp()
        :d011($0)

        bit $d011
        bpl *-3
   
        asl $d019

        ldx #$8
        stx $d011
trigger_palette_fn:
        jsr trigger_fadein_irq //trigger_palette_irq //trigger_tunnel_irq //trigger_palette_irq
        
      .if(DEBUG_FPP || DEBUG_FP2){
        inc $d020 
        }

 y_pulse_fn:
        jsr nothing //slow_grow_y

extra_speed_fn:
        jsr handle_extra_speed

        lda frame_pt 
        and #$3f 
        sta frame_pt 

        jsr draw_frame
        .if(DEBUG_FPP || DEBUG_FP2){
        dec $d020        
        }
    
        //:set_irq(fpp_irq)
accel_fn:
        jsr nothing //accelerate

        //lda #8 // Set $d011 to idle mode -> no badlines
fadeout_fn:
        bit fadeout_wait

fx_irqlo:
        lda #<fpp_irq 
        sta $fffe 
fx_irqhi:
        lda #>fpp_irq
        sta $ffff 

fxd012:
        lda #sprite_y_base-3
        sta $d012 
        //:d012(sprite_y_base-4)

        lda $d011 
        and #$f7 
        ora #$8 
        sta $d011

        //dec $d020 
        :close_irq_zp()
        rti

.const hidden_irq_d011 = $0 
.const hidden_irq_d012 = $4
trigger_fadein_irq:
        :d011(hidden_irq_d011)
        :d012(hidden_irq_d012)
        :set_irq(fadein_irq)
        cli
        rts

trigger_palette_irq:
        :d011(hidden_irq_d011)
        :d012(hidden_irq_d012)
        :set_irq(cycle_colors_irq)
        cli
        rts

trigger_tunnel_irq:
        :d011(hidden_irq_d011)
        :d012(hidden_irq_d012)
        :set_irq(tunnel_colours_irq)
        cli
        rts

//fade in the object 
fadein_irq:
        :open_irq_zp_stacked()
        asl $d019 
fadein_fn:
        jsr fadein
        :close_irq_zp_stacked()
        rti 

//changes the palette while the x bounce fx is running
cycle_colors_irq:
        :open_irq_zp_stacked()
        asl $d019
        //inc $d020
switch_palette:
        lda #0 
        beq !+
        dec switch_palette+1
colors_fn:
        jsr cycle_colors //cycle_colors
!:
        :close_irq_zp_stacked()
        rti 


//"tunnels" the background colour
tunnel_colours_irq:
        :open_irq_zp_stacked()
        asl $d019 

        inc tunnel_delayer_ct

        lda tunnel_delayer_ct
tun_delay:
        cmp #50
        bne !+
        jsr cycle_colors //cycle_colors

        lda #0 
        sta tunnel_delayer_ct
!:
        :close_irq_zp_stacked()
        rti 

final_irq:
        :open_irq_zp()
        asl $d019 

      //  inc $d020
        :music()
      //  dec $d020 
irqmove:
        lda #$ff  //will be initialized by fadeout fn (actions.asm)
        sta $d012 

        //inc irqmove+1
        clc
        lda irqmove+1
        //cmp #
        bmi !+
        //dec irqmove+1
        lda #$80 
        sta d011v+1
        inc d012chk+1
!:
        lda irqmove+1
irqadd:
        adc #8
        sta irqmove+1

d012chk:
        lda #0
        beq !+
        lda irqmove+1
        cmp #$34 
        bcc !+
        lda #1 
        sta PartDone
        lda #0
        sta irqadd+1
        sta $d012
        sta d011v+1
!:

d011v:
        lda #$0 
        sta $d011 

        :close_irq_zp()
        rti 

