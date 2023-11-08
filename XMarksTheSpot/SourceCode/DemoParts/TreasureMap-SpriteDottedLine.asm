//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = TreasureMap_SpriteDottedLine_BASE "Treasure Map - Sprite Multiplex"

	jmp TREASURESPRITEDOTTEDLINE_Init
	jmp TREASURESPRITEDOTTEDLINE_DrawSprites
	jmp TREASURESPRITEDOTTEDLINE_AddNewDot
	jmp TREASURESPRITEDOTTEDLINE_ExtraSprites

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BitmapBank = 1 //; Bank+[2000,3fff]
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var TREASURESPRITEDOTTEDLINE_FirstSpriteIndex = $20

	.var Bank0 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Bank0_BaseAddress = (Bank0 * $4000)
	.var Bank0_BitmapAddress = Bank0_BaseAddress + (BitmapBank * $2000)
	.var Bank0_ScreenAddress = (Bank0_BaseAddress + (ScreenBank * $0400))
	.var Bank0_SpriteVals = Bank0_ScreenAddress + $3f8
	.var Bank0_SpriteAddress = Bank0_BaseAddress + TREASURESPRITEDOTTEDLINE_FirstSpriteIndex * 64

	.var Bank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Bank1_BaseAddress = (Bank1 * $4000)
	.var Bank1_BitmapAddress = Bank1_BaseAddress + (BitmapBank * $2000)
	.var Bank1_ScreenAddress = (Bank1_BaseAddress + (ScreenBank * $0400))
	.var Bank1_SpriteVals = Bank1_ScreenAddress + $3f8
	.var Bank1_SpriteAddress = Bank1_BaseAddress + TREASURESPRITEDOTTEDLINE_FirstSpriteIndex * 64

	.var TREASURESPRITEDOTTEDLINE_SpriteWriteInfo = $9800
	.var TREASURESPRITEDOTTEDLINE_FirstSpriteToDraw = $9f40
	.var TREASURESPRITEDOTTEDLINE_SpriteCoords = $9fe0

	TREASURESPRITEDOTTEDLINE_SpriteAddressesLo:
		.fill 16, <(Bank0_SpriteAddress + i * 64)
	TREASURESPRITEDOTTEDLINE_SpriteAddressesHi:
		.fill 16, >(Bank0_SpriteAddress + i * 64)

	TREASURESPRITEDOTTEDLINE_SpriteWriteInfoLookup_Lo:
		.fill 68, <(TREASURESPRITEDOTTEDLINE_SpriteWriteInfo + i * 8)
	TREASURESPRITEDOTTEDLINE_SpriteWriteInfoLookup_Hi:
		.fill 68, >(TREASURESPRITEDOTTEDLINE_SpriteWriteInfo + i * 8)

	TREASURESPRITEDOTTEDLINE_SpriteXOffset:
		.byte $00
	TREASURESPRITEDOTTEDLINE_SpriteYOffset:
		.byte $00

	TREASURESPRITEDOTTEDLINE_NumSpritesToDraw:
		.byte $00

	TREASURESPRITEDOTTEDLINE_SpriteIndexLookup:
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $00)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $01)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $02)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $03)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $04)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $05)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $06)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $07)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $08)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $09)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0a)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0b)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0c)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0d)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0e)
		.byte (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0f)
		.fill 16, (TREASURESPRITEDOTTEDLINE_FirstSpriteIndex + $0f)

TREASURESPRITEDOTTEDLINE_Init:

		sta TREASURESPRITEDOTTEDLINE_WaitFrames + 1
		stx TREASURESPRITEDOTTEDLINE_SpriteXOffset
		sty TREASURESPRITEDOTTEDLINE_SpriteYOffset

		lda #$00
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight

		rts

		.print "* $" + toHexString(TREASURESPRITEDOTTEDLINE_Init) + "-$" + toHexString(EndTREASURESPRITEDOTTEDLINE_Init - 1) + " TREASURESPRITEDOTTEDLINE_Init"
EndTREASURESPRITEDOTTEDLINE_Init:

TREASURESPRITEDOTTEDLINE_DrawSprites:

		lda #$00
		sta VIC_SpriteEnable

	TREASURESPRITEDOTTEDLINE_SpriteLookup:
		ldx #$00

	TREASURESPRITEDOTTEDLINE_PrevD011:
		lda #$00
		cmp VIC_D011
		beq TREASURESPRITEDOTTEDLINE_DontMoveSprites

		inc TREASURESPRITEDOTTEDLINE_SpriteYOffset
		lda TREASURESPRITEDOTTEDLINE_SpriteYOffset
		and #$07
		bne TREASURESPRITEDOTTEDLINE_DontMoveSprites
		inx
		inx
		stx TREASURESPRITEDOTTEDLINE_SpriteLookup + 1


	TREASURESPRITEDOTTEDLINE_DontMoveSprites:
		lda VIC_D011
		sta TREASURESPRITEDOTTEDLINE_PrevD011 + 1

		lda TREASURESPRITEDOTTEDLINE_FirstSpriteToDraw + 1, x
		bne TREASURESPRITEDOTTEDLINE_YesWeShouldDrawSomeSprites

		ldy #$ff
		rts
	TREASURESPRITEDOTTEDLINE_YesWeShouldDrawSomeSprites:

		sta TREASURESPRITEDOTTEDLINE_NumSpritesToDraw

		lda #$ff
		sta VIC_SpriteEnable

		ldy TREASURESPRITEDOTTEDLINE_FirstSpriteToDraw + 0, x
		.for(var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda TREASURESPRITEDOTTEDLINE_SpriteIndexLookup, y
			sta Bank0_SpriteVals + SpriteIndex
			sta Bank1_SpriteVals + SpriteIndex
			.if(SpriteIndex != 7)
			{
				iny
			}
		}

		lda TREASURESPRITEDOTTEDLINE_FirstSpriteToDraw + 0, x
		asl
		tay
		.for(var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda TREASURESPRITEDOTTEDLINE_SpriteCoords + (SpriteIndex * 2) + 1, y
			clc
			adc TREASURESPRITEDOTTEDLINE_SpriteYOffset
			sta VIC_Sprite0Y + (SpriteIndex * 2)
			lda TREASURESPRITEDOTTEDLINE_SpriteCoords + (SpriteIndex * 2) + 0, y
			clc
			adc TREASURESPRITEDOTTEDLINE_SpriteXOffset
			sta VIC_Sprite0X + (SpriteIndex * 2)
			ror VIC_SpriteXMSB
		}

		ldy #$ff
		lda TREASURESPRITEDOTTEDLINE_NumSpritesToDraw
		sec
		sbc #$08
		bcc TREASURESPRITEDOTTEDLINE_NoMoreSpritesToDraw
		sta TREASURESPRITEDOTTEDLINE_NumSpritesToDraw
		lda VIC_Sprite3Y
		clc
		adc #21
		ldy #$00

	TREASURESPRITEDOTTEDLINE_NoMoreSpritesToDraw:
		rts

		.print "* $" + toHexString(TREASURESPRITEDOTTEDLINE_DrawSprites) + "-$" + toHexString(EndTREASURESPRITEDOTTEDLINE_DrawSprites - 1) + " TREASURESPRITEDOTTEDLINE_DrawSprites"
EndTREASURESPRITEDOTTEDLINE_DrawSprites:

TREASURESPRITEDOTTEDLINE_AddNewDot:

		//; delay the dots for some frames (0x00a0)
		lda Frame_256Counter
		bne TREASURESPRITEDOTTEDLINE_MightDrawDot
		lda FrameOf256
	TREASURESPRITEDOTTEDLINE_WaitFrames:
		cmp #$a0
		bcc TREASURESPRITEDOTTEDLINE_ShouldNotDrawDot

	TREASURESPRITEDOTTEDLINE_MightDrawDot:
		lda FrameOf256
		and #$07
		beq TREASURESPRITEDOTTEDLINE_ShouldDrawDot
	TREASURESPRITEDOTTEDLINE_ShouldNotDrawDot:
		rts

		//; we're only going to get 32 of these... eek...
	TREASURESPRITEDOTTEDLINE_ShouldDrawDot:
	TREASURESPRITEDOTTEDLINE_DotIndex:
		ldx #$00
		lda TREASURESPRITEDOTTEDLINE_SpriteWriteInfoLookup_Lo, x
		sta $40
		lda TREASURESPRITEDOTTEDLINE_SpriteWriteInfoLookup_Hi, x
		sta $41

		ldy #$00

		lda ($40), y
		cmp #$ff
		beq TREASURESPRITEDOTTEDLINE_ShouldNotDrawDot
		tax
		lda TREASURESPRITEDOTTEDLINE_SpriteAddressesLo, x
		sta TEXTURE_SpriteWrite_X0_ORA + 1
		sta TEXTURE_SpriteWrite_X1_ORA + 1
		sta TEXTURE_SpriteWrite_X0_Bank0 + 1
		sta TEXTURE_SpriteWrite_X1_Bank0 + 1
		sta TEXTURE_SpriteWrite_X0_Bank1 + 1
		sta TEXTURE_SpriteWrite_X1_Bank1 + 1
		lda TREASURESPRITEDOTTEDLINE_SpriteAddressesHi, x
		sta TEXTURE_SpriteWrite_X0_ORA + 2
		sta TEXTURE_SpriteWrite_X1_ORA + 2
		sta TEXTURE_SpriteWrite_X0_Bank0 + 2
		sta TEXTURE_SpriteWrite_X1_Bank0 + 2
		clc
		adc #>(Bank1_BaseAddress - Bank0_BaseAddress)
		sta TEXTURE_SpriteWrite_X0_Bank1 + 2
		sta TEXTURE_SpriteWrite_X1_Bank1 + 2
		iny

		lda ($40), y
		tax
		iny

	TREASURESPRITEDOTTEDLINE_SpriteWrite_Loop_2Bytes:
		lda ($40), y
	TEXTURE_SpriteWrite_X0_ORA:
		ora $ffff, x
	TEXTURE_SpriteWrite_X0_Bank0:
		sta $ffff, x
	TEXTURE_SpriteWrite_X0_Bank1:
		sta $ffff, x
		inx
		iny

		lda ($40), y
	TEXTURE_SpriteWrite_X1_ORA:
		ora $ffff, x
	TEXTURE_SpriteWrite_X1_Bank0:
		sta $ffff, x
	TEXTURE_SpriteWrite_X1_Bank1:
		sta $ffff, x
		inx
		inx
		iny
		cpy #$08
		bne TREASURESPRITEDOTTEDLINE_SpriteWrite_Loop_2Bytes

		inc TREASURESPRITEDOTTEDLINE_DotIndex + 1

		rts

		.print "* $" + toHexString(TREASURESPRITEDOTTEDLINE_AddNewDot) + "-$" + toHexString(EndTREASURESPRITEDOTTEDLINE_AddNewDot - 1) + " TREASURESPRITEDOTTEDLINE_AddNewDot"
EndTREASURESPRITEDOTTEDLINE_AddNewDot:

TREASURESPRITEDOTTEDLINE_ExtraSprites:

		ldx TREASURESPRITEDOTTEDLINE_SpriteLookup + 1

		lda TREASURESPRITEDOTTEDLINE_FirstSpriteToDraw, x
		clc
		adc #$08
		sta TREASURESPRITEDOTTEDLINE_FirstExtraSprite + 1
		tay
		.for(var SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			lda TREASURESPRITEDOTTEDLINE_SpriteIndexLookup, y
			sta Bank0_SpriteVals + SpriteIndex
			sta Bank1_SpriteVals + SpriteIndex
			.if(SpriteIndex != 7)
			{
				iny
			}
		}

		lda #$00
		sta TREASURESPRITEDOTTEDLINE_XMSB + 1

	TREASURESPRITEDOTTEDLINE_FirstExtraSprite:
		lda #$00
		asl
		tay
		.for(var SpriteIndex = 3; SpriteIndex >= 0; SpriteIndex--)
		{
			lda TREASURESPRITEDOTTEDLINE_SpriteCoords + (SpriteIndex * 2) + 1, y
			clc
			adc TREASURESPRITEDOTTEDLINE_SpriteYOffset
			sta VIC_Sprite0Y + (SpriteIndex * 2)
			lda TREASURESPRITEDOTTEDLINE_SpriteCoords + (SpriteIndex * 2) + 0, y
			clc
			adc TREASURESPRITEDOTTEDLINE_SpriteXOffset
			sta VIC_Sprite0X + (SpriteIndex * 2)
			rol TREASURESPRITEDOTTEDLINE_XMSB + 1
		}
		lda VIC_SpriteXMSB
		and #$f0
	TREASURESPRITEDOTTEDLINE_XMSB:
		ora #$00
		sta VIC_SpriteXMSB
		
		rts
		