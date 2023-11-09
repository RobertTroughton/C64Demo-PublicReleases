.var speed_list0 = List()
.var speed_list1 = List()
.var speed_list2 = List()
.var speed_list3 = List()

.for(var x=0;x<256;x++){

  //speed 0 
  .if(x>127){
    .eval speed_list0.add(127)
  }else{
    .eval speed_list0.add(x)
  }

  //speed 1
  .if(x<=127){
    .eval speed_list1.add(0)
  }
  .if(x>=128 && x<=255){
    .eval speed_list1.add(x-128)
  }
}



.for(var x=0;x<256;x++){

  //speed 0 
  .if(x>127){
    .eval speed_list2.add(127)
  }else{
    .eval speed_list2.add(x)
  }

  //speed 1
  .if(x<=127){
    .eval speed_list3.add(0)
  }
  .if(x>=128 && x<=255){
    .eval speed_list3.add(x-128)
  }
}



.pc = * "Speed 0 table"
speed0_table:
.for(var x=0;x<speed_list0.size();x++){
  .byte <speed_list0.get(x)
}

.pc = * "Speed 1 table"
speed1_table:
.for(var x=0;x<speed_list0.size();x++){
    .byte <speed_list1.get(x)
}

.pc = * "Speed 2 table"
speed2_table:
.for(var x=0;x<speed_list2.size();x++){
    .byte speed_list2.get(x)
}


.pc = * "Speed 3 table"
speed3_table:
.for(var x=0;x<speed_list3.size();x++){
    .byte speed_list3.get(x)
}
