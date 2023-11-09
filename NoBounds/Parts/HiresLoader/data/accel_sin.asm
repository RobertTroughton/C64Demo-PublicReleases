.var accel_sin_list = List().add(
   16,15,14,14,13,13,12,11,10,9,8,7,7,6,5,4,4,3,3,2,2,1,1,0
)

accel_sin:
.for(var x=0;x<accel_sin_list.size();x++){
    .byte accel_sin_list.get(x)
}
