//FPP VARS
.const texture_img = LoadPicture("data/texture_gradient.png")

.const MULTI_COLOUR_TEXTURE = true
.const TEXTURE_BACKGROUND_COLOUR = "000000"
.const TEXTURE_COLOUR_1 = "bbbbbb"
.const TEXTURE_COLOUR_2 = "777777"
.const TEXTURE_COLOUR_3 = "333333"

.const FX_START_DELAY = 1

.const DEBUG_FPP = false
.const DEBUG_FP2 = false
.const fpp_x_pos = 110

.const CANVAS_SIZE = 192
.const D020_COLOUR = DARK_GRAY 

/*
.const D021_COLOUR = BLACK 
.const SPRITE_COL = DARK_GRAY
.const SPRITE_MC2 = GRAY 
.const SPRITE_MC1 = LIGHT_GRAY 
*/


/*
.const D021_COLOUR = DARK_GRAY 
.const SPRITE_COL = PURPLE
.const SPRITE_MC2 = GRAY
.const SPRITE_MC1 = CYAN 


.const D021_COLOUR = DARK_GRAY 
.const SPRITE_COL = PURPLE
.const SPRITE_MC2 = LIGHT_RED
.const SPRITE_MC1 = YELLOW 


.const D021_COLOUR = DARK_GRAY 
.const SPRITE_COL = WHITE
.const SPRITE_MC2 = LIGHT_GREEN
.const SPRITE_MC1 = GREEN 
*/

.var palette_list = List()
.eval palette_list.add(BLACK, BLUE, LIGHT_GREEN, CYAN)
.eval palette_list.add(WHITE,LIGHT_GRAY,GRAY,DARK_GRAY)
.eval palette_list.add(BLUE, RED, ORANGE, YELLOW)
//.eval palette_list.add(RED, PURPLE, CYAN, LIGHT_GRAY)
.eval palette_list.add(DARK_GRAY, PURPLE, LIGHT_RED, YELLOW)


.var frames_number = 64
.const shrink_rounds = 32
.const fpp_position = $44
.const sprite_y_base = $47
.var fx_height = 133