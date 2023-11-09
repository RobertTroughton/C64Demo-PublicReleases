


charset_data:
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF,$7F,$FF,$FF,$FF,$FF,$FF,$FF
.byte $FE,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$8F,$9F,$7F,$FF,$FF,$FF,$FF,$FF
.byte $F2,$F6,$FD,$FF,$FF,$FF,$FF,$FF,$A7,$8F,$9F,$7F,$FF,$FF,$FF,$FF
.byte $DA,$F2,$F6,$FD,$FF,$FF,$FF,$FF,$A9,$A7,$8F,$9F,$BF,$7F,$FF,$FF
.byte $6A,$DA,$F2,$F6,$FE,$FD,$FF,$FF,$A8,$A1,$87,$8F,$9F,$BF,$FF,$FF
.byte $2A,$4A,$D2,$F2,$F6,$FE,$FF,$FF,$A8,$A1,$85,$87,$9F,$9F,$7F,$7F
.byte $2A,$4A,$52,$D2,$F6,$F6,$FD,$FD,$A8,$A9,$A1,$87,$8F,$9F,$3F,$3F
.byte $2A,$6A,$4A,$D2,$F2,$F6,$FC,$FC,$A8,$A8,$A1,$81,$87,$8F,$1F,$3F
.byte $2A,$2A,$4A,$42,$D2,$F2,$F4,$FC,$A8,$A8,$A1,$81,$85,$8F,$1F,$1F
.byte $2A,$2A,$4A,$42,$52,$F2,$F4,$F4,$A8,$A8,$A1,$81,$85,$87,$1F,$1F
.byte $2A,$2A,$4A,$42,$52,$D2,$F4,$F4,$A8,$A8,$A1,$81,$85,$87,$17,$1F
.byte $2A,$2A,$4A,$42,$52,$D2,$D4,$F4,$A8,$A8,$A1,$A1,$85,$87,$17,$1F
.byte $2A,$2A,$4A,$4A,$52,$D2,$D4,$F4,$AA,$A8,$A1,$A1,$85,$87,$17,$17
.byte $AA,$2A,$4A,$4A,$52,$D2,$D4,$D4,$AA,$A8,$A1,$A1,$85,$85,$17,$17
.byte $AA,$2A,$4A,$4A,$52,$52,$D4,$D4,$AA,$A8,$A8,$A1,$A1,$85,$85,$17
.byte $AA,$2A,$2A,$4A,$4A,$52,$52,$D4,$AA,$AA,$A8,$A8,$A1,$A1,$85,$87
.byte $AA,$AA,$2A,$2A,$4A,$4A,$52,$D2,$AA,$AA,$AA,$A8,$A8,$A1,$A1,$85
.byte $AA,$AA,$AA,$2A,$2A,$4A,$4A,$52,$AA,$AA,$AA,$AA,$A8,$A9,$A1,$85
.byte $AA,$AA,$AA,$AA,$2A,$6A,$4A,$52,$AA,$AA,$AA,$AA,$AA,$A8,$A1,$A1
.byte $AA,$AA,$AA,$AA,$AA,$2A,$4A,$4A,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$BF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FD,$FE,$FF,$FF,$FF,$FF,$FF,$7F,$9F,$8F
.byte $FF,$FF,$FF,$FF,$FF,$FD,$F6,$F2,$FF,$FF,$FF,$7F,$9F,$8F,$A7,$A9
.byte $FF,$FF,$FF,$FD,$F6,$F2,$DA,$6A,$FF,$FF,$7F,$BF,$9F,$8F,$A7,$A9
.byte $FF,$FF,$FD,$FE,$F6,$F2,$DA,$6A,$FF,$FF,$BF,$9F,$8F,$87,$A1,$A8
.byte $FF,$FF,$FE,$F6,$F2,$D2,$4A,$2A,$7F,$7F,$9F,$9F,$87,$85,$A1,$A8
.byte $FD,$FD,$F6,$F6,$D2,$52,$4A,$2A,$3F,$3F,$9F,$8F,$87,$A1,$A9,$A8
.byte $FC,$FC,$F6,$F2,$D2,$4A,$6A,$2A,$3F,$1F,$8F,$87,$81,$A1,$A8,$A8
.byte $FC,$F4,$F2,$D2,$42,$4A,$2A,$2A,$1F,$1F,$8F,$85,$81,$A1,$A8,$A8
.byte $F4,$F4,$F2,$52,$42,$4A,$2A,$2A,$1F,$1F,$87,$85,$81,$A1,$A8,$A8
.byte $F4,$F4,$D2,$52,$42,$4A,$2A,$2A,$1F,$17,$87,$85,$81,$A1,$A8,$A8
.byte $F4,$D4,$D2,$52,$42,$4A,$2A,$2A,$1F,$17,$87,$85,$A1,$A1,$A8,$A8
.byte $F4,$D4,$D2,$52,$4A,$4A,$2A,$2A,$17,$17,$87,$85,$A1,$A1,$A8,$A8
.byte $D4,$D4,$D2,$52,$4A,$4A,$2A,$2A,$17,$17,$85,$85,$A1,$A1,$A8,$A8
.byte $D4,$D4,$52,$52,$4A,$4A,$2A,$2A,$17,$85,$85,$A1,$A1,$A8,$A8,$AA
.byte $D4,$52,$52,$4A,$4A,$2A,$2A,$AA,$87,$85,$A1,$A1,$A8,$A8,$AA,$AA
.byte $D2,$52,$4A,$4A,$2A,$2A,$AA,$AA,$85,$A1,$A1,$A8,$A8,$AA,$AA,$AA
.byte $52,$4A,$4A,$2A,$2A,$AA,$AA,$AA,$85,$A1,$A9,$A8,$AA,$AA,$AA,$AA
.byte $52,$4A,$6A,$2A,$AA,$AA,$AA,$AA,$A1,$A1,$A8,$AA,$AA,$AA,$AA,$AA
.byte $4A,$4A,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8,$A1
.byte $AA,$AA,$AA,$AA,$AA,$AA,$2A,$4A,$AA,$AA,$AA,$AA,$AA,$AA,$A8,$A8
.byte $AA,$AA,$AA,$AA,$AA,$AA,$2A,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$A8
.byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
.byte $A1,$A8,$AA,$AA,$AA,$AA,$AA,$AA,$4A,$2A,$AA,$AA,$AA,$AA,$AA,$AA
.byte $A8,$A8,$AA,$AA,$AA,$AA,$AA,$AA,$2A,$2A,$AA,$AA,$AA,$AA,$AA,$AA
.byte $A8,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$2A,$AA,$AA,$AA,$AA,$AA,$AA,$AA


/*
; CHARSET IMAGE ATTRIBUTE DATA...
; 90 attributes, 1 attribute per image, 8 bits per attribute, total size is 90 ($5A) bytes.
; nb. Upper nybbles = material, lower nybbles = colour.

charset_attrib_data

.byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
.byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
.byte $09,$0D,$0D,$0D,$0D,$0D,$0D,$09,$09,$09,$09,$09,$09,$09,$09,$09
.byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
.byte $09,$09,$09,$09,$09,$09,$09,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
.byte $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
*/