//MAP DATA...
//40x25 (1000) cells, 8 bits per cell, total size is 1000 ($3E8) bytes.
map_data:
.var map_list = List().add(
 $00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,
 $0F,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,
 $1F,$20,$21,$22,$23,$24,$25,$26,$00,$00,$27,$28,$29,$2A,$2B,$2C,
 $2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,
 $3D,$3E,$3F,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C
)

anim_sequence_top:
.for(var x=0;x<=$28;x++){
    .byte map_list.get(x)
}

anim_sequence_bottom:
.for(var x=$28;x<$50;x++){
    .byte map_list.get(x)
}