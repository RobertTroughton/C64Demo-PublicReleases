
.pc = * "d010 table"
d010_tbl:
.for(var x=0;x<d010_values.size();x++){
    .byte d010_values.get(x)
}

.pc = * "d01d table"
d01d_tbl:
.for(var x=0;x<d01d_values.size();x++){
    .byte d01d_values.get(x)
}

sprites_lo_x:
.for(var x=0;x<x_shrink_rounds;x++){
    .var spr_lo_list = sprite_positions.get(x)
    .for(var y=0;y<spr_lo_list.size();y++){
        .byte spr_lo_list.get(y)
    }  
}

sprites_hi_x:
.for(var x=0;x<x_shrink_rounds;x++){
    .byte d010_values.get(x)
}

sprites_stretch_x:
.for(var x=0;x<x_shrink_rounds;x++){
    .byte d01d_values.get(x)
}

.var sprites_lo_x_addr_list = List()
.for(var x=0;x<x_shrink_rounds;x++){
    .eval sprites_lo_x_addr_list.add(8*x)
}

sprite_x_positions_addr_lo:
.for(var x=0;x<sprites_lo_x_addr_list.size();x++){
    .byte <[sprites_lo_x+sprites_lo_x_addr_list.get(x)]
}


sprite_x_positions_addr_hi:
.for(var x=0;x<sprites_lo_x_addr_list.size();x++){
    .byte >[sprites_lo_x+sprites_lo_x_addr_list.get(x)]
}
