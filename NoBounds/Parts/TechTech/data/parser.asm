.var framesize = 0
.const INVERT_CHARSET = false 

.macro equalCharPack(filename, screenAdr, charsetAdr, upperCharset) {
	.var charMap = Hashtable()
	.var charNo = 0

 
    .if(upperCharset){
        .eval charNo += 128
        .eval charsetAdr += $400
    }

	.var screenData = List()
	.var charsetData = List()
	.var pic = LoadPicture(filename)
 

	// Graphics should fit in 8x8 Single color / 4 x 8 Multi color blocks
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

    .print("Charset bytes " + charsetData.size()/8)	
}


:equalCharPack("logo/redcrab/girl3.png", logo_lut, logo_charset_b1, false)
