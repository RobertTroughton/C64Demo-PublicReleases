//sprite area is 96x84
.var margin_left = 120
.var margin_top = 60
.const FRAME_SIZE = $40*16 

.var sprite_area_width = 96 // 96
.var sprite_area_height = 84

.var images_list = List()
.var foreground_pixels_list = List()
.var colour = "70a4b2" //cyan pixels

.for (var x=0;x<=29;x++){
    .var filename = "colormask/s"+x+".png"
    .eval images_list.add(filename)
}

.const VERBOSE_OUTPUT = 0
//.print (images_list)

//.eval images_list.add("colormask/s0.png")

.function get_empty_frame_byteslist(){
    .var res = List()
    .for(var x=0;x<FRAME_SIZE;x++){
        .eval res.add(0)
    }
    .return res 
}

//populate the list of foreground pixels for each frame
.function findforegroundPixels(){

    .for(var i=0;i<images_list.size();i++){
        .var image = LoadPicture(images_list.get(i))

        .if(VERBOSE_OUTPUT==1){
            .print("-----------------------------------")
            .print("Checking image "+images_list.get(i))
        }

        .var frame_foreground_pixels_list = List()

        //hunt for foreground pixels (4x1 each)
        .for(var y=0; y<sprite_area_height; y++){
            .for(var x=0;x<sprite_area_width/2;x++){
                .var absolute_x = x*2+margin_left
                .var absolute_y = y+margin_top
                .var pixel_x = x*2 
                .var pixel_y = y 

                .var pixel = toHexString(image.getPixel(absolute_x, absolute_y))

                .if(pixel == colour){
                    .if(VERBOSE_OUTPUT==1){
                        .print("Found foreground pixel at "+absolute_x+","+absolute_y +" "+pixel_x+","+pixel_y)
                    }
                    .var padLeftX = ""
                    .var padLeftY = ""

                    .if(pixel_x<10){
                        .eval padLeftX = "0"
                    }

                    .if(pixel_y<10){
                        .eval padLeftY = "0"
                    }
                    .eval frame_foreground_pixels_list.add(padLeftX+toIntString(pixel_x)+","+padLeftY+toIntString(pixel_y))
                }
            }
        }
        .eval foreground_pixels_list.add(frame_foreground_pixels_list)
    }
}

//given a frame and a pixel, return the sprite coordinates
.function getSpriteCohords(frame_bytes, x,y){
    .if(VERBOSE_OUTPUT==1){
        .print("-----------------------------------")
        .print ("Got x:"+x+" y:"+y)
    }
    
    .var row = floor(y/21)
    .var column = floor(x/48)

    //sprites are arranged in this way:
    //s0,s1
    //s2,s3
    //s4,s5
    //s6,s7

    .var destination_sprite = 0
    //we need to detect which sprite we are writing to
    .eval destination_sprite = 2*row+column 
    .if(VERBOSE_OUTPUT==1){
        .print("Row/col "+row+" "+column)
        .print("Destination sprite "+destination_sprite)
    }
    //each sprite is $40 bytes
    .var frame_offset = $40*destination_sprite

    .var x_padding = floor((x/16))-3*mod(destination_sprite,2)
    .var y_padding = mod(y,21)

    .if(VERBOSE_OUTPUT==1){
        .print("Frame offset = $40*destination sprite = $40*"+destination_sprite+" = $"+toHexString(frame_offset,4))
    }
    //add y
    .eval frame_offset = frame_offset+y_padding*3

    .if(VERBOSE_OUTPUT==1){
        .print("Adding y padding "+y_padding+"*3 = $"+toHexString(y_padding*3,4)+" -> $"+toHexString(frame_offset,4))
    }
    
    //for x we need to detect the correct byte
    //col contains the byte, x padding the shift amount
    .eval frame_offset = frame_offset+x_padding

    .if(VERBOSE_OUTPUT==1){
        .print("Adding x padding "+x_padding+" = $"+toHexString(x_padding,4)+" -> $"+toHexString(frame_offset,4))
    }
    
    .var or_byte = $0
    .var pixelmask_or = %01000000 //used to select SPRITE_COL_1 ($d025)
    .var pixelmask_and = %00111111
    
    .var remaining_bits = mod(x/2,8)

    .if(VERBOSE_OUTPUT==1){
        .print("Remaining pixels: "+remaining_bits)
    }

    .var bt = frame_bytes.get(frame_offset)
    .var cp = bt 
    .eval bt = bt & (pixelmask_and >> remaining_bits)
    .eval bt = bt | (pixelmask_or >> remaining_bits)
    .eval bt = bt | cp 

    .eval frame_bytes.set(frame_offset, bt)
    .if(VERBOSE_OUTPUT==1){
        .print("Set byte "+toBinaryString(bt,8)+ " at position $"+toHexString(frame_offset,4))
    }
    .return frame_bytes
}

//dump the address for the background pixels for each frame
.function dumpPixelsForFrames(){
    .var res = List()

    .for(var l=0;l<foreground_pixels_list.size();l++){
        .if(VERBOSE_OUTPUT==1){
            .print("Analyzing frame "+l)
        }
        .var frame_foreground_pixels_list = foreground_pixels_list.get(l)
        .var frame_bytes = get_empty_frame_byteslist()
        .for(var x=0;x<frame_foreground_pixels_list.size();x++){
            
            .var pixels_string = frame_foreground_pixels_list.get(x)
            .var pixel_x = pixels_string.substring(0,2).asNumber()
            .var pixel_y = pixels_string.substring(3,5).asNumber()

            .if(mod(x,2)==0){
                //.print(pixels_string+" "+pixel_x+" "+pixel_y)
                .eval frame_bytes = getSpriteCohords(frame_bytes, pixel_x,pixel_y)
            }    
        }
        .eval res.add(frame_bytes)
    }

    .return res 
}

.eval findforegroundPixels()
//.var frames_correction_bytes = dumpPixelsForFrames()


/*
.var frame_bytes = get_empty_frame_byteslist()
.eval getSpriteCohords(frame_bytes,28,1)
.print(frame_bytes.size())
*/

//.print (frame_correction_bytes)

