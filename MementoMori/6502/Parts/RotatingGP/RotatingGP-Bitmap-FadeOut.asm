//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; $0000-1f3f
	.var ScreenBank = 14 //; Bank+[3800,3bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var SpriteVals = (ScreenAddress + $3F8 + 0)

	.var COLData = $e000
	.var SCRData = $e400
	.var FramesDarker = $e800
	.var FramesDarker1 = FramesDarker + (256 * 0)
	.var FramesDarker2 = FramesDarker + (256 * 1)
	.var FramesDarker3 = FramesDarker + (256 * 2)
	.var FramesDarker4 = FramesDarker + (256 * 3)

*= RotatingGPBitmap_Fade_BASE

//; RotatingGPBitmap_FadeColoursOut() -------------------------------------------------------------------------------------------------------
RotatingGPBitmap_FadeColoursOut:
		
		cpy #0
		bpl FadeOut_DontSkipColumn0
		jmp FadeOut_SkipColumn0
	FadeOut_DontSkipColumn0:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker1, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker1, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeOut_SkipColumn0:
		iny
		cpy #40
		bne FadeOut_DoColumn1
		rts

	FadeOut_DoColumn1:
		cpy #0
		bpl FadeOut_DontSkipColumn1
		jmp FadeOut_SkipColumn1
	FadeOut_DontSkipColumn1:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker2, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker2, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeOut_SkipColumn1:
		iny
		cpy #40
		bne FadeOut_DoColumn2
		rts

	FadeOut_DoColumn2:
		cpy #0
		bpl FadeOut_DontSkipColumn2
		jmp FadeOut_SkipColumn2
	FadeOut_DontSkipColumn2:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker3, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker3, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeOut_SkipColumn2:
		iny
		cpy #40
		bne FadeOut_DoColumn3
		rts

	FadeOut_DoColumn3:
		cpy #0
		bpl FadeOut_DontSkipColumn3
		jmp FadeOut_SkipColumn3
	FadeOut_DontSkipColumn3:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker4, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker4, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeOut_SkipColumn3:
		iny
		cpy #40
		bne FadeOut_DoColumn4
		rts

	FadeOut_DoColumn4:
		cpy #0
		bpl FadeOut_DontSkipColumn4
		rts
	FadeOut_DontSkipColumn4:
		lda #$00
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			sta VIC_ColourMemory + (YLine * 40), y
			sta ScreenAddress + (YLine * 40), y
		}
		
		rts

