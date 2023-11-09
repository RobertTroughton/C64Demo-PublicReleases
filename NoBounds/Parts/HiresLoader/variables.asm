.const STANDALONE_BUILD = false

.const BASE_MUSICPLAY = $800

.const HiresLoaderStart = $2310

.const PartDone = $88f

.const music = LoadSid("data/golden.sid")

.const r_zp_1 = $12 
.const r_zp_2 = $13
.const r_zp_3 = $14

.const screen = $0400  
.const charset = $2800

.const d018_val = [[[screen & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]

.const column_left_y = $60 
.const column_right_y = $61
.const column_speed = $62
.const speed_pt = $63

