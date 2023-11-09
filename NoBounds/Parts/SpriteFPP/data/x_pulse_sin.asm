.var acc_list = List()
.var x_acceleration_list = List().add(
  1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,
  2,3,5,11,5,3,2,
  1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1
)

.for(var x=0;x<x_acceleration_list.size();x++){
        .eval acc_list.add(x_acceleration_list.get(x))
}

.var x_pulse_list = List().add(71,0)

.for (var x=0;x<x_pulse_list.size();x++){
        .byte x_pulse_list.get(x)
}

.const max_area = 71
.var x_acc_area = 0
.var max_x_accel = 0
x_acceleration:
.for (var x=0;x<x_acceleration_list.size();x++){
        .eval x_acc_area = x_acc_area + x_acceleration_list.get(x)
        .if(x_acceleration_list.get(x)>max_x_accel){
                .eval max_x_accel = x_acceleration_list.get(x)
        }
        .byte x_acceleration_list.get(x)
}

.print("Max accel area: " + x_acc_area)	

.var x_deceleration_list = List().add(
     1,2,2,4,6,7,8,9,10,11,11
)

.var x_dec_area = 0 
.var dec_list = List()

.for(var x=0;x<x_deceleration_list.size();x++){
        .eval x_dec_area = x_dec_area + x_deceleration_list.get(x)
}

.print ("Max decel area: " + x_dec_area)

x_deceleration:
.for(var x=0;x<x_deceleration_list.size();x++){
        .byte x_deceleration_list.get(x)
}


.var x_bounce_list = List()
.eval x_bounce_list.add(0,3,6,9,11,13,15,16,16,16,15,13,11,9,6,3,0)
.eval x_bounce_list.add(0,2,5,7,8,10,11,12,12,12,11,10,8,7,5,2,0)
.eval x_bounce_list.add(0,1,2,3,4,5,6,6,6,6,6,5,4,3,2,1,0)
x_bounce:
.for(var x=0;x<x_bounce_list.size();x++){
        .byte x_bounce_list.get(x)
}