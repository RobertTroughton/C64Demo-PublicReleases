.pc = charset "Charset"
.for(var x=0;x<charset_bytes.size();x++){
        .byte charset_bytes.get(x)
}
.fill $8,$00

.pc = frames_lut "Columns LUT"
.for(var x=0;x<columns_lut.size();x++){
        .byte columns_lut.get(x)
}

.pc = * "LUT addresses"
lut_addr_lo:
.for(var x=0;x<frames_addresses.size();x++){
        .byte <frames_addresses.get(x)+frames_lut
}

lut_addr_hi:
.for(var x=0;x<frames_addresses.size();x++){
        .byte >frames_addresses.get(x)+frames_lut
}
