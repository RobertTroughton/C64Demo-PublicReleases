.var palette_list = List()

//Set 1
//from black to white

.eval palette_list.add(BLACK,BLACK,BLACK)
.eval palette_list.add(BLUE,BLACK,BLACK)
.eval palette_list.add(DARK_GRAY,BLUE,BLACK)
.eval palette_list.add(GRAY,BLUE,BLUE)
.eval palette_list.add(LIGHT_GRAY,BLUE,BLUE)
.eval palette_list.add(LIGHT_GRAY,DARK_GRAY,BLUE)
.eval palette_list.add(LIGHT_GRAY,DARK_GRAY,DARK_GRAY)
.eval palette_list.add(YELLOW,GRAY,DARK_GRAY)
.eval palette_list.add(WHITE,GRAY,GRAY)
.eval palette_list.add(WHITE,GRAY,GRAY)
.eval palette_list.add(WHITE,LIGHT_GRAY,GRAY)


.var steps = palette_list.size()/3

.print "steps: "+steps
col0_palette:
.for(var x=0;x<steps;x++){
    .byte palette_list.get(x*3)
}

col1_palette:
.for(var x=0;x<steps;x++){
    .byte palette_list.get((x*3)+1)
}

col2_palette:
.for(var x=0;x<steps;x++){
    .byte palette_list.get((x*3)+2)
}


//from black to red
.eval palette_list = List()

.eval palette_list.add(BLACK,BLACK,BLACK)
.eval palette_list.add(DARK_GRAY,BLACK,BLACK)
.eval palette_list.add(DARK_GRAY,DARK_GRAY,BLACK)
.eval palette_list.add(DARK_GRAY,DARK_GRAY,DARK_GRAY)
.eval palette_list.add(GRAY,DARK_GRAY,DARK_GRAY)
.eval palette_list.add(GRAY,BROWN,DARK_GRAY)
.eval palette_list.add(GRAY,BROWN,BROWN)
.eval palette_list.add(GRAY,RED,BROWN)
.eval palette_list.add(GRAY,ORANGE,RED)

//.eval palette_list.add(DARK_GRAY,DARK_GRAY,GRAY)
.var steps1 = palette_list.size()/3

col0_palette1:
.for(var x=0;x<steps1;x++){
    .byte palette_list.get(x*3)
}

col1_palette1:
.for(var x=0;x<steps1;x++){
    .byte palette_list.get((x*3)+1)
}

col2_palette1:
.for(var x=0;x<steps1;x++){
    .byte palette_list.get((x*3)+2)
}

//from black to cyan
.eval palette_list = List()
.eval palette_list.add(BLACK,BLACK,BLACK)
.eval palette_list.add(BLUE,BLACK,BLACK)
.eval palette_list.add(DARK_GRAY,BLUE,BLACK)
.eval palette_list.add(DARK_GRAY,BLUE,BLUE)
.eval palette_list.add(GRAY,BLUE,BLUE)
.eval palette_list.add(CYAN,BLUE,BLUE)
.eval palette_list.add(CYAN,GRAY,BLUE)
.eval palette_list.add(CYAN,LIGHT_BLUE,BLUE)

.var steps2 = palette_list.size()/3

col0_palette2:
.for(var x=0;x<steps2;x++){
    .byte palette_list.get(x*3)
}


col1_palette2:
.for(var x=0;x<steps2;x++){
    .byte palette_list.get((x*3)+1)
}

col2_palette2:
.for(var x=0;x<steps2;x++){
    .byte palette_list.get((x*3)+2)
}

sizes_list:
.byte steps-1, steps1-1, steps2-1


palette_table_addr_lo:
.byte <col0_palette, <col1_palette, <col2_palette
.byte <col0_palette1, <col1_palette1, <col2_palette1
.byte <col0_palette2, <col1_palette2, <col2_palette2

palette_table_addr_hi:
.byte >col0_palette, >col1_palette, >col2_palette
.byte >col0_palette1, >col1_palette1, >col2_palette1
.byte >col0_palette2, >col1_palette2, >col2_palette2

multiply_by_3:
.byte 0,3,6,9