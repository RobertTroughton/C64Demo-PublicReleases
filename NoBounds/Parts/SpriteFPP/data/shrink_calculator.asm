//calculate the scaled line
.function get_line_list(frame_height){
    .var line_list = List()
    .for (var x=0;x<frame_height;x++){
        .eval line_list.add(x)
    }
    .return line_list
}

.function listContains(list, value){
    .for(var x=0;x<list.size();x++){
        .if(list.get(x) == value){
            .return true
        }
    }
    .return false
}

//calculate the scaled line
.function scale_line_y(line, original_height, shrink_amt) {
 //   .print("_------------------_")
//    .print("Scaling "+original_height+" "+shrink_amt+" times ...")
    .var scaled_line = List()
    //.var scale_factor = new_height / original_height
    .var holes_nr = shrink_amt
    .var selected_pixels = List()
    .if(holes_nr>0){
        .var holes_offset = floor(original_height / (shrink_amt*2))

        .var holes = List()

   //    .print("Holes offset "+holes_offset	)
     //   .print("Holes "+holes)

        .var hole_ct = 0
        .var copy_ct = 0
        .for(var x=0;x<original_height-shrink_amt*2;x++){
            
            .if(mod(x,holes_offset) == 0 && x>0 && x<=original_height ){
                .eval copy_ct=copy_ct+1
            }
            .eval copy_ct = copy_ct+1
            .eval scaled_line.add(line.get(copy_ct))
            .eval hole_ct += 1
            .eval selected_pixels.add(copy_ct)
        }
        .return scaled_line
    }else{
        .return line
    } 
}

.function get_shrinked_linemaps(frame_height){
    //each shrink round will decrease the size by 2 (1 line on the top 1 on the bottom)
    .var shrinked_linemaps = List()

    .var linemap = get_line_list(frame_height) //get a list 0,1,2...frame_height

    .for (var i = 0; i<shrink_rounds; i++){
        //shrink the line map by 2 each round
        .var shrinked_linemap = scale_line_y(linemap, frame_height, i)
    
     //   .print(shrinked_linemap)
        .eval shrinked_linemaps.add(shrinked_linemap)
    }

    .return shrinked_linemaps
}


/*
sprites 0 1 6 7 are used for the actual drawing
sprites 2 3 4 5 are used for the shrinking
each sprite is 48 pixels wide
so we need to calculate how many sprites we need to draw the whole line
shrinking is done by 2 pixels each round
minimum object width is 24 * 4 = 96 pixels
maximum object width is 96+48*4 = 288 pixels
*/
.var d01d_values = List()
.var d010_values = List()
.var sprite_positions = List()

.var min_shrink = 48
.var max_shrink = 192 //192 //48*4 
.var x_shrink_rounds = (max_shrink-min_shrink)/2

.function calculate_shrinked_sprite_table(){

  
    .var sprite_width = 48


    .const s0_default = fpp_x_pos       //s0 24px
    .const s1_default = s0_default+24   //s1 24px
    .const s2_default = s1_default+24   //s2 48px
    .const s3_default = s2_default+48   //s3 48px
    .const s4_default = s3_default+48   //s4 48px
    .const s5_default = s4_default+48   //s5 48px
    .const s6_default = s5_default+48   //s6 24px
    .const s7_default = s6_default+24   //s7 24px

    .var sprite_shift = 0
    .var iteration_ct = 0

    .for(var x=min_shrink;x<=max_shrink;x+=2){
        .var padding_sprites_count = ceil(x / sprite_width)
        .var remaining_width = -(x - (padding_sprites_count * sprite_width))
        //.print("Iteration "+toHexString(iteration_ct))
        //.print("Width "+x+" needs "+padding_sprites_count+" sprites and "+remaining_width+" pixels offset on the last sprite")

        .var d010_value = 0 
        .var d01d_value = 0
        .var sprite_disposition = List()

        .var enabled_sprites = List().add(1,1,0,0,0,0,1,1)

        //by default , shrinking is 0
        .eval sprite_disposition.add(
                                    s0_default, s1_default,
                                    0,0,0,0,
                                    s6_default,s7_default)

        .eval sprite_disposition.set(0, s0_default-sprite_shift/2)
        .eval sprite_disposition.set(1, s1_default-sprite_shift/2)

        //enable 2x width for padding sprites (only needed ones)
        .if(padding_sprites_count==1){
            .eval d01d_value = $4
            .eval sprite_disposition.set(2, sprite_disposition.get(1)+24-remaining_width)
            .eval sprite_disposition.set(6, sprite_disposition.get(2)+48)
  
            .eval enabled_sprites.set(2,1)
        }

        .if(padding_sprites_count==2){
            .eval d01d_value = $c
            .eval sprite_disposition.set(2, sprite_disposition.get(1)+24)
            .eval sprite_disposition.set(3, sprite_disposition.get(2)+48-remaining_width)
            .eval sprite_disposition.set(6, sprite_disposition.get(3)+48)

            .eval enabled_sprites.set(2,1)
            .eval enabled_sprites.set(3,1)
        }

        .if(padding_sprites_count==3){
            .eval d01d_value = $1c
            
            .eval sprite_disposition.set(2, sprite_disposition.get(1)+24)
            .eval sprite_disposition.set(3, sprite_disposition.get(2)+48)
            .eval sprite_disposition.set(4, sprite_disposition.get(3)+48-remaining_width)
            .eval sprite_disposition.set(6, sprite_disposition.get(4)+48)

            .eval enabled_sprites.set(2,1)
            .eval enabled_sprites.set(3,1)
            .eval enabled_sprites.set(4,1)
        }

        .if(padding_sprites_count==4){
            .eval d01d_value = $3c

            .eval sprite_disposition.set(2, sprite_disposition.get(1)+24)
            .eval sprite_disposition.set(3, sprite_disposition.get(2)+48)
            .eval sprite_disposition.set(4, sprite_disposition.get(3)+48)
            .eval sprite_disposition.set(5, sprite_disposition.get(4)+48-remaining_width)
            .eval sprite_disposition.set(6, sprite_disposition.get(5)+48)

            .eval enabled_sprites.set(2,1)
            .eval enabled_sprites.set(3,1)
            .eval enabled_sprites.set(4,1)
            .eval enabled_sprites.set(5,1)
        }

        .eval sprite_disposition.set(7, sprite_disposition.get(6)+24)

        //finally, move the sprites 0-1 to the left and 6-7 to the right accordingly
        /*
        .var sprite_shift = x/2 

        .eval(sprite_disposition.set(0, s0_default-sprite_shift))
        .eval(sprite_disposition.set(1, s1_default-sprite_shift))
        .eval(sprite_disposition.set(6, s6_default+sprite_shift))
        .eval(sprite_disposition.set(7, s7_default+sprite_shift))
        */

        //eval d010 value 
        .var d010hi=false
        
        .for(var x=0;x<sprite_disposition.size();x++){
          
            .if(sprite_disposition.get(x)>255){
                .eval d010hi=true
            }
            .if(d010hi && enabled_sprites.get(x)==1){
                .eval d010_value = d010_value | 1<<x
            }
        }

        //finally, AND $ff each position
        .for(var x=0;x<sprite_disposition.size();x++){
            .eval sprite_disposition.set(x, sprite_disposition.get(x) & $ff)
        }

        .eval sprite_shift = sprite_shift+2
        .eval iteration_ct = iteration_ct+1

        //.print("d010 value: "+toHexString(d010_value))
        //.print("d01d value: "+toHexString(d01d_value))
        //.print("sprite positions: "+sprite_disposition)
        //.print("--------------------")
        
        .eval d01d_values.add(d01d_value & $ff)
        .eval d010_values.add(d010_value & $ff)
        .eval sprite_positions.add(sprite_disposition)
        
    }
}

