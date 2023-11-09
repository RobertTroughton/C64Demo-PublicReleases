//.break
.pc = * "Raster routine start"
raster_routine:
.var x_b = 0   
       .for(var x=0;x<RASTER_FX_LINES;x++){
            .var indx = mod(x_b,MAX_SHIFT_PX)
            .var shift_ofs = sin_intro.get(x)

            .if(SKIP_BANKSWITCH_ROUTINE){
                .eval shift_ofs = 15
            }
            /*
            .if(FLI_BUG_COLOUR=="brown"){
                lda #tech_d018_table_list.get(indx)|3   //2	
                sax $d018                               //4
                sta $dd00                               //4                         
                lda #$ff                                //2           
                sta $d016,y                             //5 
                lda #tech_d011_table_list.get(mod(first_fli_line+x_b,8)) | $18 //2
                sta $d011                               //4  
           }
            */

            //.if(FLI_BUG_COLOUR=="black"){
            lda #tech_d011_table_list.get(mod(first_fli_line+x_b,8)) | $18 
            sta $d011                          
            ldy #tech_d016_table_list.get(shift_ofs)                                     
            sty $d016                          
            lda #tech_d018_table_list.get(shift_ofs) | tech_dd00_table_list.get(shift_ofs)   
            sax $d018                             
            sta $dd00-$f0,x                                                                  
            //}
            .eval x_b = x_b+1
            .eval indx = mod(x_b,MAX_SHIFT_PX)
       }
