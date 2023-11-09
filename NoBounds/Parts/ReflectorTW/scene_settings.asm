.const FX_START_DELAY = 20
.const BACKGROUND_COLOR = BLACK 
.const MC_COLOR1 = CYAN
.const MC_COLOR2 = LIGHT_BLUE 
.const D800_COLOUR = WHITE+8 //white

.const y_margin = 3
//.const x_margin = 0
.const SPRITE_BG_COLOR = BLUE 
.const SPRITE_COL_1 = CYAN
.const SPRITE_COL_2 = WHITE 

.const sprite_y_base = $6c
.const sprite_x_base = $90

.const FX_LENGTH_LO = $40
.const FX_LENGTH_HI = $5

//sprite animation mapping against the colum anim
.var sprite_frames_mapping_list = List().add(
    0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
    16,17,18,19,20,21,22,  23,24,25,26,27,28
)

.const D011_VAL = $19