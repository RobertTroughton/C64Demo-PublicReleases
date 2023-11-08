//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

*= TurnSide_BASE "Turn Side"

		jmp TURNSIDE_DisplaySprites
		jmp TURNSIDE_UpdateSprites

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var TURNSIDE_SpriteSinX = $8a00
	.var TURNSIDE_SpriteSinY = $8b00

TURNSIDE_DisplaySprites:
		stx TURNSIDE_SetSpriteVals + 1
		sty TURNSIDE_SetSpriteVals + 2

		ldy #$00
		ldx #$20
	TURNSIDE_SetSpriteValsLoop:
		txa
	TURNSIDE_SetSpriteVals:
		sta $ffff, y
		inx
		iny
		cpy #$08
		bne TURNSIDE_SetSpriteValsLoop

		lda #$05
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		sta VIC_Sprite2Colour
		sta VIC_Sprite3Colour
		lda #$01
		sta VIC_Sprite4Colour
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour

		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteXMSB

		rts

TURNSIDE_UpdateSprites:
	TURNSIDE_UpdateSprites_XSin:
		ldx #$00
		lda TURNSIDE_SpriteSinX, x
		sta VIC_Sprite0X + (0 * 2)
		sta VIC_Sprite0X + (4 * 2)
		clc
		adc #$18
		sta VIC_Sprite0X + (1 * 2)
		sta VIC_Sprite0X + (5 * 2)
		clc
		adc #$18
		sta VIC_Sprite0X + (2 * 2)
		sta VIC_Sprite0X + (6 * 2)
		clc
		adc #$18
		sta VIC_Sprite0X + (3 * 2)
		sta VIC_Sprite0X + (7 * 2)

	TURNSIDE_UpdateSprites_YSin:
		ldx #$33
		lda TURNSIDE_SpriteSinY, x
		sta VIC_Sprite0Y + (0 * 2)
		sta VIC_Sprite0Y + (1 * 2)
		sta VIC_Sprite0Y + (2 * 2)
		sta VIC_Sprite0Y + (3 * 2)
//;		clc
//;		adc #$15
		sta VIC_Sprite0Y + (4 * 2)
		sta VIC_Sprite0Y + (5 * 2)
		sta VIC_Sprite0Y + (6 * 2)
		sta VIC_Sprite0Y + (7 * 2)

		lda TURNSIDE_UpdateSprites_XSin + 1
		clc
		adc #$03
		sta TURNSIDE_UpdateSprites_XSin + 1
		lda TURNSIDE_UpdateSprites_YSin + 1
		clc
		adc #$05
		sta TURNSIDE_UpdateSprites_YSin + 1

		lda #$ff
		sta VIC_SpriteEnable

		rts
