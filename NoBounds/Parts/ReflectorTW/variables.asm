.const STANDALONE_BUILD = false

.const BASE_MUSICPLAY = $800


.const ReflectorTWStart = $9b00
.const ReflectorTransitionStart = $4000
.const PartDone = $88f

.const music = LoadSid("data/Acrouzet-Golden.sid")

.const r_zp_1 = $12 
.const r_zp_2 = $13
.const r_zp_3 = $14
.const r_zp_4 = $15

.const lut_source_zp = $20 //word
.const intro_dest_zp = $18 //word

.const frame_source_zp = $30 //word
.const frame_dest_zp = $24 //word

.const sta_dest_zp = $56 //word

.const charset = $5800 
.const screen = $4400
.const frames_lut = $8000

.const d018_val = [[[screen & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]

.const sprites = $4800
.const sprites_1 = $4a00 

.const sprite_buffer_switcher = $27 

//.const sprites_backup_offset = $2800
.const sprites_backup = $6000

.const frame_correction_values = $9900 

.const first_sta_address = $8704
//.const d018_val = $1e

