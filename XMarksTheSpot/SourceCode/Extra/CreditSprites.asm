//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

*= CreditSprites_BASE "Credit Sprites"

		jmp CREDITSPRITES_DisplaySprites
		jmp CREDITSPRITES_UpdateSprites

CREDITSPRITES_XVals:
		.byte $6f, $58, $a7, $d7
CREDITSPRITES_YVals:
		.byte $58, $3c, $78, $d0
CREDITSPRITES_Colours:
		.byte $0b, $02, $09, $00
CREDITSPRITES_PageIndex:
		.byte $00

CREDITSPRITES_XMSBLookupTable:
	//; should only be 0, 1, 2 or 4
		.byte $00, $08, $0c, $00, $0e, $00, $00, $00

CREDITSPRITES_DisplaySprites:
		stx CREDITSPRITES_STASpriteVals + 1
		sty CREDITSPRITES_STASpriteVals + 2

		ldy CREDITSPRITES_PageIndex
		lda CREDITSPRITES_XVals, y
		sta CREDITSPRITES_SpriteXPos + 1

		ldy #$00
		ldx #$20
	CREDITSPRITES_SetupSpriteLoop:
		txa
	CREDITSPRITES_STASpriteVals:
		sta $ffff, y
		inx
		iny
		cpy #$08
		bne CREDITSPRITES_SetupSpriteLoop

		ldy CREDITSPRITES_PageIndex
		lda CREDITSPRITES_YVals, y
		ldx #$00
	CREDITSPRITES_SetupSpriteLoop2:
		sta VIC_Sprite0Y, x
		inx
		inx
		cpx #$08
		bne CREDITSPRITES_SetupSpriteLoop2

		ldy CREDITSPRITES_PageIndex
		lda CREDITSPRITES_Colours, y
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour

		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteXMSB

		inc CREDITSPRITES_PageIndex

		rts

CREDITSPRITES_UpdateSprites:

		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteXMSB

		ldx #$00
		stx CREDITSPRITES_XMSBLookup + 1
	CREDITSPRITES_SpriteXPos:
		lda #$b7
	CREDITSPRITES_SpriteLoop2:
		sta VIC_Sprite0X, x
		clc
		adc #$18
		rol CREDITSPRITES_XMSBLookup + 1
		inx
		inx
		cpx #$08
		bne CREDITSPRITES_SpriteLoop2

	CREDITSPRITES_XMSBLookup:
		lda #$ff
		and #$0e	//; we only care about these parts
		lsr
		tax
		lda CREDITSPRITES_XMSBLookupTable, x
		sta VIC_SpriteXMSB

		lda #$0f
		sta VIC_SpriteEnable

		lda FrameOf256
		and #$03
		bne NoSpriteMove

		dec CREDITSPRITES_SpriteXPos + 1

	NoSpriteMove:

		rts
