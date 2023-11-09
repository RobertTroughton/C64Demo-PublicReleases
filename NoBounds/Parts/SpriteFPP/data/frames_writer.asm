
.var padding = fx_height /2 

.var FramesYStart = List()
.var max_height = 0 

.for(var x=0;x<frames_number;x++){
    .var IndexList = FramesIndexList.get(x)
   // .var YList = FramesYList.get(x)

    //.var starting_y = YList.get(0)+padding
    
    .var starting_y = 0
    //store the y start of the frame
    .eval FramesYStart.add(starting_y)

    //store the length of the frame
  //  .eval FramesLength.add(IndexList.size())

    .if(IndexList.size()>max_height){
        .eval max_height = IndexList.size()
    }
}

.pc = frames_lookup "Frame lookup table"
frames_lookup_tbl: 
.for(var x=0;x<frames_number;x++){
    .var IndexList = FramesIndexList.get(x)
    .for(var y=0;y<IndexList.size();y++){
        .byte IndexList.get(y)
    }
}

//address of each frame
.var FramesAddress = List()
//address of each frame lookup data
.var frames_shift = 0

.for(var x=0;x<frames_number;x++){
    .var frame_address = frames_lookup+frames_shift 
    .eval FramesAddress.add(frame_address)
    .eval frames_shift += max_height
   // .eval frames_shift += FramesLength.get(x)
}

.pc = frames_address_tbl "Frames address lo"
frame_addr_lo:
.for(var x=0;x<frames_number;x++){
    .byte <FramesAddress.get(x)
}

.pc = * "Frames address hi"
frame_addr_hi:
.for(var x=0;x<frames_number;x++){
    .byte >FramesAddress.get(x)
}


/*
.pc = * "Frames Length"
frame_length:
.for(var x=0;x<frames_number;x++){
    .byte FramesLength.get(x)
}
*/

.pc = * "Frames starting Y"
frame_starting_y:
.for(var x=0;x<frames_number;x++){
    .byte FramesYStart.get(x)
}


//create the unique list of frames length
/*
.var FramesHeightUniqueHash = Hashtable()
.var FramesHeightUnique = List()
.for(var x=0;x<FramesLength.size();x++){
    .var frame_length = FramesLength.get(x)
    //.print("Frame "+x+": "+frame_length)
    .if(FramesHeightUniqueHash.containsKey(frame_length) == false){
        .eval FramesHeightUniqueHash.put(frame_length,frame_length)
        .eval FramesHeightUnique.add(frame_length)
    }
}

//Create, for each value, the shrink map

.print("Frames Length Unique: "+FramesHeightUnique.sort().reverse())
.print("Max height: "+max_height)
*/

/*
.var shrinked_linemaps = get_shrinked_linemaps(max_height)

.pc = * "Shrinked linemaps"
shrinked_linemaps_data:
.var shrinked_linemap_addresses = List()
.var shrinked_linemap_offset = 0
.for(var x=0;x<shrinked_linemaps.size();x++){
   .var shrinked_linemap = shrinked_linemaps.get(x)
   //.print(shrinked_linemap)
    .for(var y=0;y<shrinked_linemap.size();y++){
         .byte shrinked_linemap.get(y)
    }
    
    .eval shrinked_linemap_addresses.add(shrinked_linemap_offset+shrinked_linemaps_data)
    .eval shrinked_linemap_offset = shrinked_linemap_offset+shrinked_linemap.size() 
}

.pc = * "Shrinked linemaps address (by z)"
shrinked_linemap_addr_lo:
.for(var x=0;x<shrinked_linemaps.size();x++){
    .byte <shrinked_linemap_addresses.get(x)
}
shrinked_linemap_addr_hi:
.for(var x=0;x<shrinked_linemaps.size();x++){
    .byte >shrinked_linemap_addresses.get(x)
}
*/

.pc = * "Frames length (by z)"
frames_length:
.for(var x=0;x<shrink_rounds;x++){
    .byte max_height-(2*x)
}

.pc = * "Sprites X table"	
sprites_x:
.eval calculate_shrinked_sprite_table()