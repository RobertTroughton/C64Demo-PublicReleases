//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"
.import source "WavyScroller-Defines.asm"
.import source "..\..\Intermediate\KickAss\DemoParts\Blit.sym"

* = WavyScroller_BASE "Wavy Scroller"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; - $3000-3fff SinTables
//; ---- $4000-4fff Screens (0 - 3)
//; ---- $5000-5fff Screens (4 - 7)
//; ---- $6000-7fff Charset (0 - 3)
//; - $8000-bfff CharSet
//; - $e000-feff Code+Data
//; - $ff00-ff3f CharInfo

	.var xbuffer = $02
	.var ybuffer = $2a


.macro equalCharPack(filename, screenAdr, charsetAdr) {
      .var charMap = Hashtable()
      .var charNo = 0
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
                        .var byteVal = pic.getSinglecolorByte(charX, charY*8 + i)
                        .eval key = key + toHexString(byteVal) + ","
                        .eval currentCharBytes.add(byteVal)
                  }
                  .var currentChar = charMap.get(key)
                  // .if (currentChar == null) {
                        .eval currentChar = charNo
                        .eval charMap.put(key, charNo)
                        .eval charNo++
                        .for (var i=0; i<8; i++) {
                              .eval charsetData.add(currentCharBytes.get(i))
                        }
                  // }
                  .eval screenData.add(currentChar)
            }
      }
      // .pc = screenAdr "screen"
      // .fill screenData.size(), screenData.get(i)
      .pc = charsetAdr "Plasma charset"
      .fill charsetData.size(), charsetData.get(i)
}	
	
//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp WAVYSCROLLER_Init				//; Init
		.byte $60, $00, $00					//; MainThreadFunc
		jmp WAVYSCROLLER_End				//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; WAVYSCROLLER_LocalData -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,					LoPtr,							HiPtr
		.byte	$00,			WAVYSCROLLER_YRASTER,	<WAVYSCROLLER_IRQ_Function,		>WAVYSCROLLER_IRQ_Function
		.byte	$ff

framecounter:
      .byte $00

xcnt:
      .byte $00

ycnt: 
      .byte $00

sinus:
.fill 512, 32 + 32*sin(toRadians(i*360/256))

colors:
      .fill 64, 14
      .fill 64, 6
      .fill 64, 14
      .fill 64, 6

	.print "* $" + toHexString(WAVYSCROLLER_LocalData) + "-$" + toHexString(EndWAVYSCROLLER_LocalData - 1) + " WAVYSCROLLER_LocalData"
EndWAVYSCROLLER_LocalData:

init:

      lda #$1c
      sta $d018

      lda #%01011011 // ECM = Set bit 6
      sta $d011

      lda #$08
      sta $d016

      lda #0
      sta $d020
      lda #6
      sta $d021
      lda #14
      sta $d022
      lda #6
      sta $d023 		
      lda #14
      sta $d024

      rts

plasma:
      ldy ycnt
      ldx xcnt

      .for (var count=0; count<40; count++) {
            lda sinus+[[5*count]&$ff],x
            clc
            adc sinus+[[4*count]&$ff],y
            sta xbuffer+count
      }

      .for (var count=0; count<25; count++) {
            lda sinus+[[3*count]&$ff],x
            clc
            adc sinus+[[2*count]&$ff],y
            sta ybuffer+count
      }

      .for (var xcount=0; xcount<40; xcount++) {
            .for (var ycount=0; ycount<25; ycount++) {
                  lda xbuffer+xcount
                  clc
                  adc ybuffer+ycount

                  sta $0400 + xcount + ycount*40
                  tax
                  lda colors,x
                  sta $d800 + xcount + ycount*40
            }
      }

      inc framecounter
      lda framecounter
      and #$02
      bne !+
      rts
!:
      dec xcnt
      inc ycnt

      rts
 
