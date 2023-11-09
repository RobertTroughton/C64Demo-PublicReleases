.var framesize = 0

.macro equalCharPack(filename, screenAdr, charsetAdr, upperCharset) {
	.var charMap = Hashtable()
	.var charNo = 1

 
    .if(upperCharset){
        .eval charNo += 128
        .eval charsetAdr += $400
    }

	.var screenData = List()
	.var charsetData = List()
	.var pic = LoadPicture(filename)
    .for(var x=0;x<8;x++){
        .eval charsetData.add($ff)
    }

	// Graphics should fit in 8x8 Single collor / 4 x 8 Multi collor blocks
	.var PictureSizeX = pic.width/8
	.var PictureSizeY = pic.height/8

	.for (var charY=0; charY<PictureSizeY; charY++) {
		.for (var charX=0; charX<PictureSizeX; charX++) {
			.var currentCharBytes = List()
			.var key = ""
			.for (var i=0; i<8; i++) {
				.var byteVal = pic.getMulticolorByte(charX, charY*8 + i)

                // Invert bits for background and d800 color
                .var b0 = byteVal & 1
                .var b1 = byteVal & 2
                .var b2 = byteVal & 4
                .var b3 = byteVal & 8
                .var b4 = byteVal & 16
                .var b5 = byteVal & 32
                .var b6 = byteVal & 64
                .var b7 = byteVal & 128

                //we must invert nibble 00 with 11 and 11 with 00
                .var n0 = b0 | b1
                .var n1 = b2 | b3
                .var n2 = b4 | b5
                .var n3 = b6 | b7

                .if(INVERT_CHARSET){
                    .if(b0!=0 && b1!=0){
                        .eval n0 = %00000000
                
                    }
                    .if(b0==0 && b1==0){
                        .eval n0 = %00000011
                    }

                    .if(b2!=0 && b3!=0){
                        .eval n1 = %00000000
                    }
                    .if(b2==0 && b3==0){
                        .eval n1 = %00001100
                    }

                    .if(b4!=0 && b5!=0){
                        .eval n2 = %00000000
                    }
                    .if(b4==0 && b5==0){
                        .eval n2 = %00110000
                    }

                    .if(b6!=0 && b7!=0){
                        .eval n3 = %00000000
                    }
                    .if(b6==0 && b7==0){
                        .eval n3 = %11000000
                    }
                }

                .eval byteVal = n0 | n1 | n2 | n3

				.eval key = key + toHexString(byteVal) + ","
				.eval currentCharBytes.add(byteVal)
			}
			.var currentChar = charMap.get(key)
			.if (currentChar == null) {
				.eval currentChar = charNo
				.eval charMap.put(key, charNo)
				.eval charNo++
				.for (var i=0; i<8; i++) {
					.eval charsetData.add(currentCharBytes.get(i))
				}
			}
			.eval screenData.add(currentChar)
		}
	}


    .pc = screenAdr "screen"
	.fill screenData.size(), screenData.get(i)
    .eval framesize = screenData.size()
	.pc = charsetAdr "charset"
	.fill charsetData.size(), charsetData.get(i)
    //.print("Charset bytes " + charsetData.size()/8)
}


:equalCharPack("face/15.png", screens+framesize*0, $4800, false)
:equalCharPack("face/14.png", screens+framesize*1, $4800, true)

:equalCharPack("face/13.png", screens+framesize*2, $5000, false)
:equalCharPack("face/12.png", screens+framesize*3, $5000, true)

:equalCharPack("face/11.png", screens+framesize*4, $5800, false)
:equalCharPack("face/10.png", screens+framesize*5, $5800, true)

:equalCharPack("face/9.png", screens+framesize*6, $6000, false)
:equalCharPack("face/8.png", screens+framesize*7, $6000, true)

:equalCharPack("face/7.png", screens+framesize*8, $6800, false)
:equalCharPack("face/6.png", screens+framesize*9, $6800, true)

:equalCharPack("face/5.png", screens+framesize*10, $7000, false)
:equalCharPack("face/4.png", screens+framesize*11, $7000, true)

:equalCharPack("face/3.png", screens+framesize*12, $8800, false)
:equalCharPack("face/2.png", screens+framesize*13, $8800, true)

:equalCharPack("face/1.png", screens+framesize*14, $a800, false)
:equalCharPack("face/0.png", screens+framesize*15, $a800, true)


.print("FRAMESIZE: $"+toHexString(framesize))

.function getd018(screen, charset){
    .return [[[screen & $3fff] / $0400] << 4] + [[[charset & $3fff] / $0800] << 1]
}

.var d018_table = List()
.eval d018_table.add(getd018(screen, $4800))
.eval d018_table.add(getd018(screen, $4800))

.eval d018_table.add(getd018(screen, $5000))
.eval d018_table.add(getd018(screen, $5000))

.eval d018_table.add(getd018(screen, $5800))
.eval d018_table.add(getd018(screen, $5800))

.eval d018_table.add(getd018(screen, $6000))
.eval d018_table.add(getd018(screen, $6000))

.eval d018_table.add(getd018(screen, $6800))
.eval d018_table.add(getd018(screen, $6800))

.eval d018_table.add(getd018(screen, $7000))
.eval d018_table.add(getd018(screen, $7000))

.eval d018_table.add(getd018(screen2, $8800))
.eval d018_table.add(getd018(screen2, $8800))

.eval d018_table.add(getd018(screen2, $a800))
.eval d018_table.add(getd018(screen2, $a800))


.var banks = List()
.var screen_target = List()
.var bank0 = %00  //%11 
.var bank1 = %01  //%10 
.var bank2 = %10  //%01
.var bank3 = %11  //%00
.if (STANDALONE_BUILD)
{
    .eval bank0 = %11 
    .eval bank1 = %10 
    .eval bank2 = %01
    .eval bank3 = %00
}
.var d018_blanking_values_list = List()
.for (var x=0;x<12;x++){
    .eval banks.add(bank1)
    .eval screen_target.add(screen+X_PADDING+Y_PADDING*$28)
    .eval d018_blanking_values_list.add(d018_val_blank0)
}
.eval banks.add(bank2)
.eval banks.add(bank2)
.eval banks.add(bank2)
.eval banks.add(bank2)
.eval screen_target.add(screen2+X_PADDING+Y_PADDING*$28)
.eval screen_target.add(screen2+X_PADDING+Y_PADDING*$28)
.eval screen_target.add(screen2+X_PADDING+Y_PADDING*$28)
.eval screen_target.add(screen2+X_PADDING+Y_PADDING*$28)
.eval d018_blanking_values_list.add(d018_val_blank1)
.eval d018_blanking_values_list.add(d018_val_blank1)
.eval d018_blanking_values_list.add(d018_val_blank1)
.eval d018_blanking_values_list.add(d018_val_blank1)

banks_list:
.for(var x=0;x<banks.size();x++){
    .byte banks.get(x)
}

screens_list_hi:
.for(var x=0;x<screen_target.size();x++){
    .byte >screen_target.get(x)
}

screens_list_lo:
.for(var x=0;x<screen_target.size();x++){
    .byte <screen_target.get(x)
}

d018_blanking_values:
.for(var x=0;x<d018_blanking_values_list.size();x++){
    .byte d018_blanking_values_list.get(x)
}

//.print(banks)
//.print(screen_target)