.const FX_START_DELAY = 2
.const INVERT_CHARSET = true 
.const BORDER_COLOR = BLACK
.const D800_COLOUR = BLACK+8 //white
.const LOOP_ROUNDS = 3

//set 1
.const BACKGROUND_COLOR = BLACK  
.const MC_COLOR2 = BLACK 
.const MC_COLOR1 = BLACK 

.const FRAMES_NR = 16

.var CHARS_WIDTH = 11
.var CHARS_HEIGHT = 18

.var X_PADDING = 10 //15 //chars
.var Y_PADDING = 4 //chars
.const FX_RASTERLINES = CHARS_HEIGHT*8 
.const overlay_irq_rasterline = $4a
.const sprite_y_base = overlay_irq_rasterline+1
.const sprite_x_base = $38

.print ("Fx rasterlines: "+ FX_RASTERLINES)