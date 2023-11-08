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

//; RotatingGPBitmap_FadeColoursIn() -------------------------------------------------------------------------------------------------------
RotatingGPBitmap_FadeColoursIn:
		
		cpy #0
		bpl FadeIn_DontSkipColumn0
		jmp FadeIn_SkipColumn0
	FadeIn_DontSkipColumn0:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker4, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker4, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeIn_SkipColumn0:
		iny
		cpy #40
		bne FadeIn_DoColumn1
		rts

	FadeIn_DoColumn1:
		cpy #0
		bpl FadeIn_DontSkipColumn1
		jmp FadeIn_SkipColumn1
	FadeIn_DontSkipColumn1:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker3, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker3, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeIn_SkipColumn1:
		iny
		cpy #40
		bne FadeIn_DoColumn2
		rts

	FadeIn_DoColumn2:
		cpy #0
		bpl FadeIn_DontSkipColumn2
		jmp FadeIn_SkipColumn2
	FadeIn_DontSkipColumn2:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker2, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker2, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeIn_SkipColumn2:
		iny
		cpy #40
		bne FadeIn_DoColumn3
		rts

	FadeIn_DoColumn3:
		cpy #0
		bpl FadeIn_DontSkipColumn3
		jmp FadeIn_SkipColumn3
	FadeIn_DontSkipColumn3:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			ldx COLData + (YLine * 40), y
			lda FramesDarker1, x
			sta VIC_ColourMemory + (YLine * 40), y

			ldx SCRData + (YLine * 40), y
			lda FramesDarker1, x
			sta ScreenAddress + (YLine * 40), y
		}

	FadeIn_SkipColumn3:
		iny
		cpy #40
		bne FadeIn_DoColumn4
		rts

	FadeIn_DoColumn4:
		cpy #0
		bpl FadeIn_DontSkipColumn4
		rts
	FadeIn_DontSkipColumn4:
		.for (var YLine = 0; YLine < 25; YLine++)
		{
			lda COLData + (YLine * 40), y
			sta VIC_ColourMemory + (YLine * 40), y

			lda SCRData + (YLine * 40), y
			sta ScreenAddress + (YLine * 40), y
		}
		
		rts

