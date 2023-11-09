
.var tech_d018_table_list = List()
.const tech_d016_table_list = List()
.const tech_d011_table_list = List()


.var x_ofs = 0
.var d018_pt = 0
.var tech_dd00_table_list = List()
.pc = * "Tech d018 table"
tech_d018_table:
.for(var x=0;x<MAX_SHIFT_PX;x++){
    .var b = d018_tech_list.get(d018_pt)
   .byte b
   .eval tech_d018_table_list.add(b)
   .eval tech_dd00_table_list.add(dd00_tech_list.get(d018_pt))
   .eval x_ofs = x_ofs + 1
   .if(x_ofs == 8){
        .eval x_ofs = 0
        .eval d018_pt = d018_pt + 1 
   }
}

.pc = * "Tech d016 table"
tech_d016_table:
.for(var x=0;x<MAX_SHIFT_PX;x++){
    .var b = (mod(x,8) | $d0 )
    .eval tech_d016_table_list.add(b)
    .byte b
}

.pc = * "Tech dd00 table"
tech_dd00_table: 
.for(var x=0;x<tech_dd00_table_list.size();x++){
    .byte tech_dd00_table_list.get(x)
}