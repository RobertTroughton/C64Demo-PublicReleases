//max x = 71
//min x = 0

.var x_sin_values = List().add(
//45,43,40,38,36,34,31,29,27,25,23,21,19,17,15,13,12,10,9,7,6,5,4,3,2,1,1,0,0,0,0,0,0,1,1,2,3,3,4,5,6,8,9,10,12,13,15,17,18,20,22,24,26,27,29,31,33,35,37,39,40,42,44,46,47,49,50,52,53,55,56,57,59,60,61,62,63,64,64,65,66,67,67,68,68,69,69,69,70,70,70,70,70,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,71,70,70,70,70,70,69,69,69,68,68,67,67,66,65,64,64,63,62,61,60,58,57,56,55,53,52,50,49,47,45,44,42,40,38,37,35,33,31,29,27,25,24,22,20,18,17,15,13,12,10,9,8,6,5,4,3,2,2,1,1,0,0,0,0,0,0,1,1,2,3,4,5,6,7,9,10,12,13,15,17,19,21,23,25,27,29,32,34,36,38,41,43,45,47,49,51,53,55,57,59,60,62,63,65,66,67,68,69,70,70,71,71,71,71,71,71,70,70,69,68,67,66,65,63,62,60,59,57,55,53,51,49,47

 0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,
 2,3,3,3,4,4,5,5,6,6,7,7,8,8,9,9,
 10,11,11,12,13,13,14,15,15,16,17,18,18,19,20,21,
 22,22,23,24,25,26,27,27,28,29,30,31,32,33,33,34,
 35,36,37,38,39,40,40,41,42,43,44,45,46,46,47,48,
 49,50,50,51,52,53,54,54,55,56,56,57,58,58,59,60,
 60,61,62,62,63,63,64,64,65,65,66,66,66,67,67,68,
 68,68,69,69,69,69,70,70,70,70,70,70,70,70,70,70,
 70,70,70,70,70,70,70,70,70,70,69,69,69,69,68,68,
 68,67,67,66,66,66,65,65,64,64,63,63,62,62,61,60,
 60,59,58,58,57,56,56,55,54,54,53,52,51,50,50,49,
 48,47,46,46,45,44,43,42,41,40,40,39,38,37,36,35,
 34,33,33,32,31,30,29,28,27,27,26,25,24,23,22,22,
 21,20,19,18,18,17,16,15,15,14,13,13,12,11,11,10,
 9,9,8,8,7,7,6,6,5,5,4,4,3,3,3,2,
 2,2,1,1,1,1,0,0,0,0,0,0,0,0,0,0


)

.var min_x = 99999 
.var max_x = 0
.for (var x=0;x<x_sin_values.size();x++) {
.byte x_sin_values.get(x)

    .if(x_sin_values.get(x) < min_x) {
        .eval min_x = x_sin_values.get(x)
    }

    .if(x_sin_values.get(x) > max_x) {
        .eval max_x = x_sin_values.get(x)
    }

}

.print("MAX X: " + max_x)
.print("MIN X " + min_x)