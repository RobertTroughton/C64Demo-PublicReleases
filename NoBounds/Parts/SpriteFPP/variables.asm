.const STANDALONE_BUILD = false
.const FAST_FORWARD_MUSIC = false //only for standalone build

.const BASE_MUSICPLAY = $800

.const SpriteFppStart = $c300

.const PartDone = $88f
    
.const music = LoadSid("data/Psych858o-Pulsate.sid")

.const r_zp_1 = $12 
.const r_zp_2 = $13
.const r_zp_3 = $14
.const r_zp_stacked_1 = $60
.const r_zp_stacked_2 = $61
.const r_zp_stacked_3 = $62
.const frame_addr_zp = $15  //word 
.const frame_dest_zp0 = $22 //word 
.const shrinked_linemap_addr_zp = $24 //word 
.const sprite_x_table_addr = $20 //word

.const texture_ptr = $26 
.const target_ptr = $27

.const current_frame_length = $17 
.const tunnel_delayer_ct = $18 

.const screen = $4000
.const d018_val = [[[screen & $3fff] / $0400] << 4] + [[[screen & $3fff] / $0800] << 1]
.const fpp_sprites = $4000
.const FppTab = $700

.const fpp_start_line = $e9
.const logo_y_pos = $f2

.const frames_lookup = $ab00
.const frames_address_tbl = $c200

.const frame_pt = $35

.const rotation_halver0 = $40
.const rotation_halver1 = $41
.const rotation_halver2 = $42
.const rotation_halver3 = $43

.const rotation_speed0 = $f5
.const rotation_speed1 = $f6
.const rotation_speed2 = $f7
.const rotation_speed3 = $f4

.const ROTATION_FORWARD = 0
.const ROTATION_BACKWARD = 1
.const rotation_direction = $88
.const rotation_speed_pt = $c5
.const rotation_speed_pt_hi = $c6

.const ACCELERATE = 1
.const DECELERATE = 2
.const MANTAIN_SPEED = 3
.const rotation_state = $3a


.const tmp = $f1
.const x_size = $44
.const y_size = $45
.const halver_y = $46
.const palette_index = $55

.const can_extra_speed0 = $56 
.const can_extra_speed1 = $57
.const can_extra_speed2 = $58
.const can_extra_speed3 = $59
.const can_extra_speed4 = $5a
