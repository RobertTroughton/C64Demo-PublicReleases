.var scaled_lines = List()
.var texture_lines = List()

//print the line as hex
.function dump_line(line){
    .var result = List()
    .for(var x=0;x<line.size();x++){
        .eval result.add(toHexString(line.get(x),6))
    }
    .return result 
}

//get the pixels of a line (RGB)
.function get_pixel_line(y){
    .var line = List()
  
    .for(var x=0;x<texture_img.width;x++){
        .var px = texture_img.getPixel(x,y)
        .eval line.add(px)
    }
    .return line
}

//calculate the scaled line
.function scale_line_x(line, original_width, new_width) {
    //.print("Scaling "+original_width+" to "+new_width+"...")
    .var scaled_line = List()
    .if (new_width==0){
        .for(var x=0;x<CANVAS_SIZE;x++){
            .eval scaled_line.add(0)
        }
        .return scaled_line
    }

    .var scale_factor = new_width / original_width
    .var padding = (CANVAS_SIZE-new_width)/2

    .for(var x=0;x<CANVAS_SIZE;x++){
        .eval scaled_line.add(0)
    }

    .for (var x=0;x<original_width;x++){
        .var px = line.get(x)
        .for(var i=0;i<scale_factor;i++){
            .eval scaled_line.set(padding+round(x*scale_factor)+i, px)
        }
    }
    .return scaled_line
}

.function generate_palette(){
    //.var texture_lines = List()
    .var texture_width = texture_img.width
    .var texture_height = texture_img.height
    
    //read the texture line by line
    .print("Original texture width = " + texture_width)

   // .var scaled_texture_lines = List()

    .for(var y=0;y<texture_height;y++){
        .var line = get_pixel_line(y)
        .eval texture_lines.add(line)
    }

    .for(var x=0;x<PaletteLineIdList.size();x++){
  
        .var line = texture_lines.get(PaletteLineIdList.get(x))
        .var scaled_line = scale_line_x(line, texture_width, PaletteWidthList.get(x))

        //.print("Scaled line "+scaled_line+" pixels")

        .eval scaled_lines.add(scaled_line)
    }
}

.eval generate_palette()