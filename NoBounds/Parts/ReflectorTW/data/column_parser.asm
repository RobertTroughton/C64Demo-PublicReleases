.const BG_COLOUR = "000000"
.const COLRAM_COLOUR = "ffffff"
.const MC_COL1 = "887ecb"
.const MC_COL2 = "50459b"

.const BACKGROUND_BYTE = $00
.const MC1_BYTE = $55
.const MC2_BYTE = $aa
.const D800_BYTE = $ff 

.var files_list = List()

.for (var x=197; x<=268;x++){
    .var file_name = "Parts/ReflectorTW/data/column/colonna8pX__00" + x + ".png"
  //  .var file_name = "data/column/colonna8pX__00" + x + ".png"
   
    .eval files_list.add(file_name)
}

.function get_byte_from_color(color){
    .if(color == BG_COLOUR){
        .return BACKGROUND_BYTE
    }
    .if(color == COLRAM_COLOUR){
        .return D800_BYTE
    }
    .if(color == MC_COL1){
        .return MC1_BYTE
    }
    .if(color == MC_COL2){
        .return MC2_BYTE
    }
    .print (color +" is not in palette!!!")
}

.var charset_bytes = List()
.var column_pixels = LoadPicture(files_list.get(0)).height
 
.var char_ct = 0
.var char_bytes = List()
.var columns_lut_index = 0
.var columns_lut = List()

.var char_map = Hashtable()
.var char_key = ""
.var total_chars = 0

.var frames_addresses = List()

//populate the charset and the LUT 
.for (var x=0; x<files_list.size();x++){
    //.print("----------------------------------")
    //.print("Processing file: "+files_list.get(x))
    .var image = LoadPicture(files_list.get(x))

    .for(var y=0;y<column_pixels;y++){
        .var pixel = toHexString(image.getPixel(0,y),6)
        .var byte = get_byte_from_color(pixel)

        //.print("Found color: "+pixel+" byte: "+toHexString(byte))

        .eval char_bytes.add(byte)
        .eval char_key = char_key + pixel+" "
        .eval char_ct = char_ct+1
        .eval char_ct = mod(char_ct,8)

        //if we have 8 bytes, we have a char
        .if(char_ct == 0 && char_bytes.size() > 0){
            //check if char is already in charset or not
            .if(!char_map.containsKey(char_key)){
                .eval columns_lut.add(columns_lut_index)
                .eval char_map.put(char_key,columns_lut_index)
                
                .for(var x=0;x<char_bytes.size();x++){
                    .eval charset_bytes.add(char_bytes.get(x))
                }
                .eval total_chars = total_chars+1

                //.print("New char found: "+char_key +" index: "+columns_lut_index)
                .eval columns_lut_index = columns_lut_index+1
            }else{
                .eval columns_lut.add(char_map.get(char_key))
                //.print ("Char already in charset: "+char_key +" index: "+char_map.get(char_key))
            }

            //reset for next char
            .eval char_bytes = List()
            .eval char_key = ""
            .eval char_ct = 0
        }

    }
}

//populate the frames addresses
.var frame_length = column_pixels/8
.var total_frames = files_list.size()


.for(var x=0;x<total_frames;x++){
    .eval frames_addresses.add((x*frame_length))
}

//.print(frames_addresses)
.print("Total chars in charset: "+total_chars)
.print("Total LUT size in bytes: "+columns_lut.size())
.print("Total frames: "+total_frames)
.print("Frame length: "+frame_length)