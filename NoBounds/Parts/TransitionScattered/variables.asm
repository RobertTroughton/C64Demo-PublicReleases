.const STANDALONE_BUILD = false
.const PartDone = $088f
.const BASE_MUSICPLAY = $800

.const music = LoadSid("data/Acrouzet-Golden.sid")

.const main_routine = $a600
.const charset = $a000   
.const screen_1 = $8400

.const D800_COLOUR = BLACK 
.const d018_val = [[[screen_1 & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]
.const r0_addr = $20
.const r1_addr = $32
.const frame_lut_addr = $34
.const block_id = $14
.const screen_position_pt = $49
