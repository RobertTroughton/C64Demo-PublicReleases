extra_speed_zp_addr:
.byte <can_extra_speed0, <can_extra_speed1, <can_extra_speed2, <can_extra_speed3, can_extra_speed4

flash_screen_speed:
.byte 32,24,14,6,3

.const EXTRA_SPEED_DELAY = 60
//extra_speed_delay:
//.byte 60,40,34,24,14,4
//.byte 60,60,60,60,60,60

//used in the tunnel phase
slower_grow_x_and_keep:
        lda #0 
        inc slower_grow_x_and_keep+1
        cmp #4
        bne !+
        inc x_size
        
        lda #0 
        sta slower_grow_x_and_keep+1
!:
        rts 

//used in the tunnel phase
slower_shrink_x_and_keep:
        lda #0 
        inc slower_shrink_x_and_keep+1
        cmp #4 
        bne !+

        lda #0 
        sta slower_shrink_x_and_keep+1

        dec x_size
        dec x_size
        
        lda x_size 
        bpl norest 
        
        inc x_size 
        inc x_size
norest:
       
!:
        rts 

//used in the tunnel phase
add_extra_speed:
        lda #0
        inc add_extra_speed+1
extraspd0:
        cmp #$40
        bne !+
        lda #0 
        sta add_extra_speed+1
        :set_addr(trigger_tunnel_irq, trigger_palette_fn)
  

        lda #2 
        sta palette_cycle_ct+1
extra_speed_ofs:
        ldx #0 

        lda flash_screen_speed,x 
        sta tun_delay+1
        lda extra_speed_zp_addr,x
        sta speed_flag+1

        lda #0 
        sta tunnel_delayer_ct
        
        inc extra_speed_ofs+1

        lda #1 
speed_flag:
        sta $ff 

        ldx extra_speed_ofs+1
        lda #EXTRA_SPEED_DELAY //extra_speed_delay,x
        sta extraspd0+1
        cpx #5
        bne !+
        lda #0 
        sta extra_speed_ofs+1

        //sei 
       // jmp *
        :set_addr(nothing, x_pulse_fn)
        :set_addr(dec_extra_speed,accel_fn)
!:
        rts

/*
wait_for_dec_extra_speed:
        lda #0 
        inc wait_for_dec_extra_speed+1
        cmp #$2
        bne !+
        :set_addr(dec_extra_speed,accel_fn)
!: 
        rts 
*/

//used in the tunnel phase
dec_extra_speed:
        lda #0
        inc dec_extra_speed+1
extraspd1:
        cmp #4
        bne !+
        lda #0 
        sta dec_extra_speed+1

        :set_addr(slower_shrink_x_and_keep, x_pulse_fn)
extra_speed_ofs0:
        ldx #4

        lda flash_screen_speed,x 
        sta tun_delay+1
        lda extra_speed_zp_addr,x
        sta speed_flag0+1

        lda #0 
        sta tunnel_delayer_ct
        
        dec extra_speed_ofs0+1

        lda #0 
speed_flag0:
        sta $ff 

        ldx extra_speed_ofs0+1
        lda #EXTRA_SPEED_DELAY //extra_speed_delay,x
        sta extraspd1+1
        cpx #$ff
        bne !+
        lda #0 
        sta extra_speed_ofs0+1

        lda #$2c //bit 
        sta extra_speed_fn 

        :set_addr(clear_fpp_table,clear_fn)
        :set_addr(x_pulse_grow, x_pulse_fn)
        :set_addr(slow_move_up, accel_fn) //move and wait (by changing function)
        :set_addr(trigger_palette_irq, trigger_palette_fn)
        jsr force_palette_to_purple
        :set_addr(y_pulse, y_pulse_fn)
        //force the y pulse to stop after 1 round
        lda #$20 //jsr 
        sta stop_immediately_y_fn
        sta trigger_palette_fn
!:
        rts

//used in the tunnel phase
force_palette_to_purple:
         //force the palette to be gray and purple for next round
        lda #$4 
        sta palette_cycle_ct+1

        lda #3
        sta palette_index 
        lda #$24
        sta cycle_colors //inc becomes bit
        rts 

//used in the tunnel phase
slow_move_up:
        lda #0 
        inc slow_move_up+1
        cmp #4
        bne !+
        lda #0 
        sta slow_move_up+1
        dec y_margin+1
        lda y_margin+1
        cmp #$ff
        bne !+
        lda #0
        sta y_margin+1
        :set_addr(wait_for_last_bounce, accel_fn) //wait for last bounce to move to phase 3
!:
        rts

//used in the tunnel phase
wait_for_last_bounce:
        lda rounds+1
        cmp #2
        bne !+

      //  .break 
        //move to phase 3
        :set_addr(slow_grow_x, x_pulse_fn)
        :set_addr(slow_grow_y, y_pulse_fn) 
        :set_addr(accelerate, accel_fn)
        :set_addr(clear_fpp_table_last,clear_fn)

        :set_addr(target_hold_speed, post_acceleration_fn)
        lda #0 
        sta can_hi+1 
       // sta can_lo+1

        lda #1 
        sta can_extra_speed0

        lda #$20
        sta extra_speed_fn
        sta fadeout_fn

        :set_addr(handle_extra_speed_end, extra_speed_fn)
!:
        rts 

holdspeed:
        lda #0
        inc holdspeed+1
        cmp #$f0 - 10 
        bne !+
        lda #0 
        sta holdspeed+1
      //  .break
        :set_addr(decelerate,accel_fn)
!:
        rts 

.const ACCEL_SPEED = 32
accelerate: 
can_hi:
        lda #0 
        beq !+
        jmp higher_speed
!:
        ldx rotation_speed_pt
        lda speed0_table,x 
        sta rotation_speed0

        lda speed1_table,x 
        sta rotation_speed1    

        lda rotation_speed_pt 
        clc 
accspd0:
        adc #ACCEL_SPEED
        sta rotation_speed_pt

       //cmp #$ff
        bne !+
        lda #1
        sta can_hi+1

        lda #$7f 
        sta rotation_speed1 
!:
        rts

higher_speed:  	
        ldx rotation_speed_pt_hi
        lda speed2_table,x 
        sta rotation_speed2

        lda speed3_table,x
        sta rotation_speed3

        lda rotation_speed_pt_hi
        clc 
accspd1:
        adc #ACCEL_SPEED 
        sta rotation_speed_pt_hi

        lda rotation_speed_pt_hi
      //  cmp #$ff
        bne !+
        lda rotation_speed_pt_hi
        sec 
        sbc #ACCEL_SPEED
        sta rotation_speed_pt_hi

        lda #$7f 
        sta rotation_speed3
     //   :set_addr(decelerate,accel_fn)

post_acceleration_fn:
        jsr target_add_extra_speed //will become target decelerate

        lda #0 
        sta can_hi+1
!:
        rts

target_add_extra_speed:
        :set_addr(add_extra_speed, accel_fn)
        :set_addr(slower_grow_x_and_keep, x_pulse_fn)

        //lda rotation_direction
        //eor #$ff 
        //sta rotation_direction
        rts

target_hold_speed:
        :set_addr(holdspeed,accel_fn)
        rts 

decelerate:
can_lo:
        lda #0 
        beq !+
        jmp lower_speed
!:
        ldx rotation_speed_pt
        lda speed0_table,x 
        sta rotation_speed0

        lda speed1_table,x 
        sta rotation_speed1    

        lda rotation_speed_pt 
        sec 
decspd0:
        sbc #ACCEL_SPEED
        sta rotation_speed_pt

       //cmp #$ff
        bne !+
        lda #1
        sta can_lo+1

        lda #0 
        sta rotation_speed1 
!:

trigger_fadeout_fn:
        bit trigger_fadeout
        rts
        
lower_speed:  	
        ldx rotation_speed_pt_hi
        lda speed2_table,x 
        sta rotation_speed2

        lda speed3_table,x
        sta rotation_speed3

        lda rotation_speed_pt_hi
        sec 
decspd1:
        sbc #ACCEL_SPEED 
        sta rotation_speed_pt_hi

        lda rotation_speed_pt_hi
      //  cmp #$ff
        bne !+
        lda rotation_speed_pt_hi
        clc 
decspd2:
        adc #ACCEL_SPEED 
        sta rotation_speed_pt_hi

        lda #0 
        sta rotation_speed3
        sta can_lo+1
        :set_addr(accelerate,accel_fn)

        lda rotation_direction
        eor #$ff 
        sta rotation_direction
!:
        rts

nothing:
        rts 

x_pulse_grow:
        ldx #0
        lda x_acceleration,x 
        cmp #max_x_accel
        bne !+
        inc switch_palette+1
!:
        lda x_size
        clc 
        adc x_acceleration,x 
        sta x_size 

        inc x_pulse_grow+1
        cmp #71
        bne !+
        lda #0 
        sta x_pulse_grow+1
       // lda #0 
       // sta x_size
        :set_addr(x_pulse_shrink,x_pulse_fn)    
        rts

x_pulse_shrink:
        ldx #0
        lda x_size 
        sec 
        sbc x_deceleration,x 
        sta x_size 

        inc x_pulse_shrink+1
        cmp #0 
        bne !+
        inc switch_palette+1
        lda #0 
        sta x_pulse_shrink+1
        //:set_addr(x_pulse_grow,x_pulse_fn) 

        :set_addr(x_pulse_bounce,x_pulse_fn)
        inc rotsw+1
!:
rotsw:
        lda #0 
        cmp #2 
        bne !+
        lda rotation_direction
        eor #$ff 
        sta rotation_direction
        lda #0 
        sta rotsw+1
!:
        rts

x_pulse_bounce:
        ldx #0 
        lda x_bounce,x
        sta x_size

        inc x_pulse_bounce+1
        
        lda x_pulse_bounce+1
        cmp #x_bounce_list.size()
        bne !+
        lda #0 
        sta x_pulse_bounce+1
        :set_addr(x_pulse_grow,x_pulse_fn)

        inc rounds+1
rounds:
        lda #0 
        cmp #2
        bne !+

        //start the "light tunnel effect"       
        :set_addr(accelerate,accel_fn)
        :set_addr(nothing, x_pulse_fn)
        :set_addr(nothing, trigger_palette_fn)
        lda rotation_direction
        eor #$ff 
        sta rotation_direction 
!: 
        rts

y_pulse:
        ldx #0
        lda y_pulse_sin,x 
        sta y_size 

        inc y_pulse+1
        lda y_size 
        cmp #127
        bne skp0
        lda #0 
        sta y_pulse+1
        :set_addr(wait_pulse_y,y_pulse_fn)

skp0:
//used at the begining of phase 3 to stop the y pulse
stop_immediately_y_fn:
        bit stop_immediately_y
        rts

stop_immediately_y:
        inc framect+1
framect:
        lda #0
        cmp #20
        bne !+

        :set_addr(nothing,y_pulse_fn)
        lda #$2c //bit 
        sta stop_immediately_y_fn
      //  :set_addr(slow_grow_x, x_pulse_fn)
!:
        rts 

wait_pulse_y:
        inc ctw1+1
ctw1:
        lda #0 
        cmp #$48
        bne !+
        lda #0 
        sta ctw1+1 
        :set_addr(y_pulse,y_pulse_fn)
!:
        rts

slow_grow_x:  
sinpt:
        ldx #0
        lda x_sin,x
        sta x_size 

        inc sinpt+1
        rts 

slow_grow_y:
        
sinpt0:
        ldx #0
        lda y_sin,x
        sta y_size 

        inc sinpt0+1
        rts     

palette:
.for(var x=0;x<palette_list.size();x++){
        .byte palette_list.get(x)
}


palette_shift:
.for(var x=0;x<palette_list.size()/4;x++){
        .byte x*4
}

cycle_colors:
        inc palette_index
        lda palette_index 
palette_cycle_ct:
        cmp #4
        bne !+
        lda #0 
        sta palette_index 
!:

        //lda rotation_direction
        //eor #$ff 
        //sta rotation_direction
        ldy palette_index 
        ldx palette_shift,y 

        lda palette,x
        sta $d020
        sta $d021 

        inx 
        lda palette,x
        sta $d027
        sta $d028
        sta $d029 
        sta $d02a 
        sta $d02b 
        sta $d02c
        sta $d02d 
        sta $d02e

        inx 
        lda palette,x
        sta $d026 
        
        inx 
        lda palette,x
        sta $d025
        rts

wait_pulse_x:
        inc ctw0+1
  
ctw0:
        lda #0 
        cmp #32
        bne !+

        inc palette_flash+1
palette_flash:
        lda #0 
        cmp #5 
        bne nostoptrigger

        lda #$2c 
        sta trigger_palette_fn
nostoptrigger:

        inc rotinv+1
        clc
rotinv:
        lda #0 
        ror 
        bcc noinvert
        lda rotation_direction
        eor #$ff 
        sta rotation_direction

noinvert:

        lda #0 
        sta ctw0+1 
        :set_addr(x_pulse_grow,x_pulse_fn)
        inc palette_index
        lda palette_index 
        cmp #palette_list.size()/4
        bne !+
        lda #0 
        sta palette_index 
!:
        rts


//PURPLE, LIGHT_RED, YELLOW


col0_fade:
.byte RED,RED,RED,DARK_GRAY 

col1_fade:
.byte ORANGE,BROWN,RED,DARK_GRAY

col2_fade:
.byte LIGHT_RED,PURPLE,RED,DARK_GRAY


fadeout_halver:
.byte $0 


trigger_fadeout:
        lda #$20 
        sta fadeout_fn 
        lda #$2c 
        sta trigger_fadeout_fn
        rts 

fadeout_wait:  
        lda #0 
        inc fadeout_wait+1
        cmp #2 
        bne !+

        lda #0 
        sta fadeout_wait+1
        inc fadetk+1

fadetk:
        lda #0 
        cmp #$a4
        bne !+
       
        :set_addr(fadeout, fadeout_fn)
!:
        rts 

fadeout:
        lda #0 
        inc fadeout+1
        cmp #2 
        bne !+
        lda #0 
        sta fadeout+1
fadect:
        ldx #0 
        lda col0_fade,x
        sta $d027
        sta $d028 
        sta $d029
        sta $d02a 
        sta $d02b 
        sta $d02c 
        sta $d02d
        sta $d02e 

        lda col1_fade,x
        sta $d026

        lda col2_fade,x
        sta $d025 
        inc fadect+1 

        lda fadect+1
        cmp #4
        bne !+
        :set_addr(nothing, fadeout_fn)

        lda #$e0 
        sta fxd012+1 
        sta irqmove+1
        lda #<final_irq
        sta fx_irqlo+1
        lda #>final_irq
        sta fx_irqhi+1
!:
        rts




col0_fadein:
.byte LIGHT_GRAY,LIGHT_GREEN,CYAN,LIGHT_BLUE,PURPLE,palette_list.get(1)

col1_fadein:
.byte BLUE,DARK_GRAY,GRAY,GREEN,DARK_GRAY,palette_list.get(2)

col2_fadein:
.byte BROWN, GRAY,GREEN,LIGHT_BLUE,LIGHT_GRAY,palette_list.get(3)

fadein:
        lda #0 
        inc fadein+1
        cmp #2 
        bne !+
        lda #0 
        sta fadein+1
fadect0:
        ldx #0
        lda col0_fadein,x
        sta $d027
        sta $d028 
        sta $d029
        sta $d02a 
        sta $d02b 
        sta $d02c 
        sta $d02d
        sta $d02e 

        lda col1_fadein,x
        sta $d026

        lda col2_fadein,x
        sta $d025 
        inc fadect0+1 

        lda fadect0+1
        cmp #6
        bne !+
        :set_addr(wait_to_start, fadein_fn)
!:
        rts

wait_to_start:
        lda #0 
        inc wait_to_start+1
        cmp #$48 //do not change this value otherwise the world will end
        bne !+
        :set_addr(trigger_palette_irq, trigger_palette_fn)
        :set_addr(x_pulse_grow, x_pulse_fn)
!:
        rts 