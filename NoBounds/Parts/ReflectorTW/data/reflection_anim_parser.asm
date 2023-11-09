.var frames_list = List()
.const VERBOSE_OUTPUT_FRAMES = 0

.var COL_D025 = "70a5b2" 
.var COL_D026 = "ffffff" 
.var COL_SPRITE = "6c5fb5" 

.for (var x=0;x<30;x++){

    .var filename = "reflection/prism_"+x+".png"

    .if(VERBOSE_OUTPUT_FRAMES==1){
        .print(filename)
    }
    .eval frames_list.add(filename)
}

.function matchPixel(pixel){
    .if (pixel==COL_D025){
        .return %01000000
    }

    .if (pixel==COL_D026){
        .return %11000000
    }

    .if (pixel==COL_SPRITE){
        .return %10000000
    }

    .return %00000000

    .print ("NO MATCH FOR "+pixel)
}

.function populate_sprite(image, sprite_id, bytes_list){
    .var x_base = mod(sprite_id,2)*48 
    .var y_base = floor(sprite_id/2)*21

    .var sprite_bytes = List()

    .if(VERBOSE_OUTPUT_FRAMES==1){
        .print("SPRITE "+sprite_id+" "+x_base+" "+y_base)
    }

    .for(var y=0;y<21;y++){
        .var absolute_x = margin_left+x_base
        .var absolute_y = y+margin_top+y_base

        .var bitshift = 0
        .var nextbyte = 0

        .if(VERBOSE_OUTPUT_FRAMES==1){
            .print("---------------")
        }

        .for(var x=0;x<12;x++){
     
            .var pixel = toHexString(image.getPixel(absolute_x, absolute_y),6)

            
            .var bits = matchPixel(pixel)
            .eval nextbyte = nextbyte | bits >> bitshift

            .if(VERBOSE_OUTPUT_FRAMES==1){
                .print("Getting pixel at "+absolute_x+" "+(absolute_y)+" ->"+pixel+" "+toHexString(bits,2)+" "+toHexString(nextbyte,2)+" "+bitshift)
            }
            .eval bitshift = bitshift+2
           
            .if(bitshift==8){
                
                .if(VERBOSE_OUTPUT_FRAMES==1){
                    .print("Byte packed!")
                }
            //    .print(toHexString(nextbyte,2))
                .eval sprite_bytes.add(nextbyte)
                .eval bitshift = 0
                .eval nextbyte = 0
               // .print("next!")

               .if(VERBOSE_OUTPUT_FRAMES==1){
                .print(toHexString(nextbyte,2))
               }
            }
            .eval absolute_x = absolute_x+4
        }
    }

    .for(var x=0;x<sprite_bytes.size();x++){
        .eval bytes_list.add(sprite_bytes.get(x))
    }
    .eval bytes_list.add(0)
    .return bytes_list
}

.var frames_bytes = List()
//populate the list of foreground pixels for each frame
.function dumpReflectionFrames(){

    .for(var i=0;i<frames_list.size();i++){
        .var image = LoadPicture(frames_list.get(i))

        .if(VERBOSE_OUTPUT_FRAMES==1){
            .print("-----------------------------------")
            .print("Checking image "+frames_list.get(i))
        }

        .var frame_bytes = List()
        .var nextbyte = 0
        .var bitshift = 0

        .var bytes = List()
       // .eval bytes = populate_sprite(image, 0, bytes)
        .eval bytes = populate_sprite(image, 0, bytes)
    
        .eval bytes = populate_sprite(image, 1, bytes)
        .eval bytes = populate_sprite(image, 2, bytes)
        .eval bytes = populate_sprite(image, 3, bytes)
        .eval bytes = populate_sprite(image, 4, bytes)
        .eval bytes = populate_sprite(image, 5, bytes)
        .eval bytes = populate_sprite(image, 6, bytes)
        .eval bytes = populate_sprite(image, 7, bytes)
        
        .eval frames_bytes.add(bytes)

    }
}

.eval dumpReflectionFrames()

