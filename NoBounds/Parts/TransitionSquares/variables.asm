.const STANDALONE_BUILD = false
.const PartDone = $088f
.const BASE_MUSICPLAY = $800

.const main_routine = $fc10
    
.const music = LoadSid("data/Acrouzet-Golden.sid")

.const charset = $f800
.const screen_1 = $f000
.const D800_COLOUR = BLACK
.const d018_val = [[[screen_1 & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]
.const backup_01 = $40