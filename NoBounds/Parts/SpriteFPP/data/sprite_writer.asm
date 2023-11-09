.function get_mapped_value(rgb_value){
    .const BITS_TRANSPARENT = %00
    .const BITS_MC1 = %01
    .const BITS_MC2 = %11
    .const BITS_SPRCOL = %10

    .eval rgb_value = toHexString(rgb_value,6)

    .if(rgb_value == TEXTURE_BACKGROUND_COLOUR){
        .return BITS_TRANSPARENT
    }
    .if(rgb_value == TEXTURE_COLOUR_1){
        .return BITS_MC1
    }
    .if(rgb_value == TEXTURE_COLOUR_2){
        .return BITS_MC2
    }
    .if(rgb_value == TEXTURE_COLOUR_3){
        .return BITS_SPRCOL
    }
    .print("Failed to map colour: " + rgb_value)
    .return BITS_TRANSPARENT
}

.function get_pixels_byte(line, offset){
    .var byte = 0
  //  .print("offset" +offset)
    .var pixels = List().add(line.get(offset),line.get(offset+2),line.get(offset+4),line.get(offset+6))
    
    .eval byte = byte | (get_mapped_value(pixels.get(0)) << 6) 
    .eval byte = byte | (get_mapped_value(pixels.get(1)) << 4)
    .eval byte = byte | (get_mapped_value(pixels.get(2)) << 2)
    .eval byte = byte | get_mapped_value(pixels.get(3))
   .return byte & $ff
}

.function get_line_sprite_bytes(line){
    .var byte_sprite_line = List()
    .var byte_offset = 0
    .var total_bytes = 0
    .var total_pixels = 0
    .for(var x=0;x<line.size()/8;x++){
       .eval byte_sprite_line.add(get_pixels_byte(line, x*8))
    }
    .return byte_sprite_line
}

.print ("Generating sprite data...")
//.var sizes = line_palette.keys()
.var line_address = fpp_sprites

/*
.macro write_sprite_data(){
    .for(var x=0;x<sizes.size();x++){
        .print("Generating sprite data for size: " + sizes.get(x))
        .var lines_at_size = line_palette.get(sizes.get(x))
    
        .for(var y=0;y<lines_at_size.size();y++){
            .eval line_address = fpp_sprites + [$40*y]
            .pc = line_address "Sprite line "
            .var line = lines_at_size.get(y)
            .var bytes = get_line_sprite_bytes(line)
        
            .for(var b=0;b<bytes.size();b++){
                .byte bytes.get(b)
            }
        }
    }
}

:write_sprite_data()
*/

.macro write_sprite_data(){
    .for(var x=0;x<PaletteLineIdList.size();x++){
        .eval line_address = fpp_sprites + [$40*x]+3
        .pc = line_address "Sprite line "
        .var line = scaled_lines.get(x)
        .var bytes = get_line_sprite_bytes(line)
        
        .for(var b=0;b<bytes.size();b++){
            .byte bytes.get(b)
        }
    }
}

:write_sprite_data()