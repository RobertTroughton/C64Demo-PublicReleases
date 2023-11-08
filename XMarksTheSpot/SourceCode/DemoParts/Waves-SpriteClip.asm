//; (c) 2018, Raistlin / Genesis*Project

.import source "Waves-Defines.asm"

* = WAVES_SpriteClipASM

		ldx #$00	//; <-- this value will be modified through code in Waves.asm
		stx $40
		txa
		.for(var Add10Loop = 0; Add10Loop < 15; Add10Loop++)
		{
			clc
			adc #$10
			sta $41 + Add10Loop
		}

		.for(var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{

			lda WAVES_SpriteClipIndices + SpriteIndex
			and #$03
			tay
			lda WAVES_Mul64, y
			sta $50
			lda WAVES_SpriteClipIndices + SpriteIndex
			lsr
			lsr
			clc
			adc #>WAVES_FirstSpriteAddress
			sta $51

			ldy #$00
			.for(var YVal = 0; YVal < 16; YVal++)
			{
				.for(var XVal = 0; XVal < 3; XVal++)
				{
					lda WAVES_SourceSpriteDataToClip + (SpriteIndex * 64) + YVal * 3 + XVal
					ldx $40 + ((XVal + SpriteIndex * 3) & 15)
					and WAVES_ClipData + (YVal * 16) * 4 * 4, x
					sta ($50), y
					iny
				}
			}
		}

		rts

WAVES_Mul64:
	.byte $00, $40, $80, $c0