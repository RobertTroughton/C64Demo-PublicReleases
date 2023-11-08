//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var ScreenColour = $0c

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 1 //; Bank+[2000,3f7f]
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var BitmapAddress = (Base_BankAddress + (BitmapBank * 8192))
	.var SpriteVals = ScreenAddress + $3f8

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)

	.var D011_Value_24Rows = $33
	.var D011_Value_25Rows = $3b

	.var D011_Value_24Rows_Text = $13
	.var D011_Value_25Rows_Text = $1b

	.var D016_Value_40Columns = $08

	.var ShiftedFontData = $c000
	.var ScrollText = $c000

	.var ZP_IRQJump = $20

	.var TreeTopper_SpriteIndex_Black = $70
	.var TreeTopper_SpriteIndex_White = $74

	.var PartDone = $087f

	.var FADE_NOFADE = 0
	.var FADE_FADEIN = 1
	.var FADE_FADEOUT = 2