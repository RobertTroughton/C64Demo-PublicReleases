.var map_data = List().add(
 $00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,
 $0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,
 $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$00,$00,$1E,$1F,$20,$21,$22,$23,
 $24,$25,$26,$27,$28,$29,$2A,$2B,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,
 $32,$33,$34,$35,$36,$37,$38,$39,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
)

.print("MAP DATA SIZE: "+map_data.size()+"\n")
.const frames_x_shift = 2
map_data_tiles:
.for(var x=0;x<map_data.size();x++){
    .byte map_data.get(x)
}

frame_offset_tbl:
.for(var x=0;x<ANIMATION_FRAMES;x++){
    .byte x*2
}

/*
frames_lut:
.for(var x=0;x<ANIMATION_FRAMES;x++){
    .var i0 = frames_x_shift*x 
    .var i1 = i0+$1
    .var i2 = i0+$28
    .var i3 = i0+$29

    .print(toHexString(i0)+" "+toHexString(i1)+" "+toHexString(i2)+" "+toHexString(i3))
    .byte  map_data.get(i0)
    .byte  map_data.get(i1)
    .byte  map_data.get(i2)
    .byte  map_data.get(i3)
}
*/


.var frames_addr_list = List()
/*
.for(var x=0;x<ANIMATION_FRAMES;x++){
    .eval frames_addr_list.add(frames_lut+x*4)
}
*/

/*
frames_lut_lo:
.for(var x=0;x<frames_addr_list.size();x++){
    .byte <frames_addr_list.get(x)
}

frames_lut_hi:
.for(var x=0;x<frames_addr_list.size();x++){
    .byte >frames_addr_list.get(x)
}
*/

.var x_sequence = List().add(22, 14, 4, 0, 8, 20, 12, 18, 4, 6, 10, 30, 26, 12, 28, 36, 24, 30, 26, 10, 30, 30, 2, 38, 22, 34, 8, 18, 24, 16, 2, 28, 34, 30, 10, 4, 36, 8, 32, 34, 26, 24, 4, 38, 32, 20, 36, 8, 38, 36, 10, 12, 26, 18, 16, 12, 38, 18, 34, 36, 18, 4, 38, 2, 32, 2, 20, 36, 24, 22, 36, 34, 28, 28, 6, 28, 10, 0, 24, 14, 10, 10, 0, 2, 14, 4, 32, 28, 38, 14, 10, 38, 22, 24, 4, 8, 20, 0, 38, 12, 14, 14, 0, 14, 26, 24, 16, 10, 16, 12, 12, 24, 30, 36, 20, 14, 0, 30, 16, 32, 12, 6, 10, 6, 34, 24, 22, 24, 2, 20, 0, 26, 30, 22, 14, 28, 20, 26, 28, 20, 14, 0, 34, 4, 24, 0, 8, 22, 12, 8, 8, 22, 34, 36, 38, 16, 0, 12, 30, 18, 28, 32, 22, 0, 14, 8, 38, 18, 6, 20, 4, 24, 2, 32, 8, 32, 16, 34, 30, 2, 38, 14, 4, 2, 2, 32, 12, 36, 32, 34, 34, 18, 6, 20, 34, 18, 18, 16, 6, 6, 30, 2, 4, 26, 8, 36, 32, 6, 26, 2, 38, 10, 22, 20, 6, 16, 20, 16, 18, 16, 16, 0, 4, 18, 28, 28, 12, 22, 30, 26, 10, 6, 26, 6, 32, 26, 28, 8, 36, 22)
.var y_sequence = List().add(12, 8, 12, 2, 16, 10, 4, 0, 0, 0, 2, 10, 2, 16, 14, 20, 0, 2, 14, 16, 20, 0, 14, 20, 4, 6, 6, 16, 20, 6, 12, 4, 10, 16, 4, 4, 8, 8, 2, 22, 8, 6, 16, 16, 12, 20, 2, 14, 8, 22, 6, 0, 16, 14, 16, 20, 12, 22, 4, 4, 20, 20, 10, 8, 22, 10, 4, 18, 12, 8, 10, 16, 2, 8, 16, 10, 10, 0, 8, 4, 12, 8, 12, 18, 0, 18, 20, 0, 18, 6, 18, 22, 14, 4, 10, 20, 6, 8, 14, 10, 14, 16, 10, 10, 10, 10, 12, 14, 8, 12, 18, 18, 8, 16, 12, 20, 16, 4, 22, 8, 2, 18, 0, 2, 20, 22, 2, 16, 16, 16, 6, 22, 6, 18, 18, 18, 2, 20, 12, 14, 12, 18, 12, 6, 2, 20, 22, 6, 14, 12, 18, 20, 8, 0, 6, 2, 4, 8, 12, 8, 22, 16, 22, 22, 2, 4, 0, 2, 20, 0, 14, 14, 2, 4, 10, 10, 0, 2, 14, 4, 2, 22, 22, 22, 20, 6, 22, 14, 18, 14, 0, 6, 10, 22, 18, 4, 18, 20, 8, 12, 22, 6, 8, 0, 0, 12, 14, 14, 6, 0, 4, 20, 16, 18, 22, 4, 8, 18, 10, 14, 10, 14, 2, 12, 20, 6, 6, 0, 18, 12, 22, 4, 4, 6, 0, 18, 16, 2, 6, 10)

.var screen_addr_list = List()
.for (var x=0;x<x_sequence.size();x++){
    .var x_v = x_sequence.get(x)
    .var y_v = y_sequence.get(x)+1

    .var screen_addr = screen_1+x_v+y_v*$28
    .eval screen_addr_list.add(screen_addr)
}

screen_addr_lo:
.for (var x=0;x<screen_addr_list.size();x++){
    .byte <screen_addr_list.get(x)
}
screen_addr_hi:
.for (var x=0;x<screen_addr_list.size();x++){
    .byte >screen_addr_list.get(x)
}