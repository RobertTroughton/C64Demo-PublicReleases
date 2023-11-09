.const STANDALONE_BUILD = true
.const PartDone = $088f
.const BASE_MUSICPLAY = $800

.const main_routine = $2500
    
.const music = LoadSid("data/flipdisk.sid")

.const charset = $2000
.const screen_1 = $0400
.const D800_COLOUR = $b 
.const d018_val = [[[screen_1 & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]
