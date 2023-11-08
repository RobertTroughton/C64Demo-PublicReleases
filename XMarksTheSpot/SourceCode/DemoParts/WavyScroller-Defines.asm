//; (c) 2018, Raistlin of Genesis*Project

//; Local Defines -------------------------------------------------------------------------------------------------------

	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff

	.var BaseBankAddress = (BaseBank * $4000)

	.var ScreenBank0 = 0 //; 0=Bank+[0000,03ff]
	.var ScreenBank1 = 1 //; 1=Bank+[0400,07ff]
	.var ScreenBank2 = 2 //; 2=Bank+[0800,0bff]
	.var ScreenBank3 = 3 //; 3=Bank+[0c00,0fff]

	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (BaseBankAddress + (ScreenBank1 * 1024))
	.var ScreenAddress2 = (BaseBankAddress + (ScreenBank2 * 1024))
	.var ScreenAddress3 = (BaseBankAddress + (ScreenBank3 * 1024))

	.var CharBankA = 4 //; Bank+[2000,27ff]
	.var CharBankB = 5 //; Bank+[2800,2fff]
	.var CharBankC = 6 //; Bank+[3000,37ff]
	.var CharBankD = 7 //; Bank+[3800,3fff]

	.var CharAddressA = (BaseBankAddress + (CharBankA * $800))
	.var CharAddressB = (BaseBankAddress + (CharBankB * $800))
	.var CharAddressC = (BaseBankAddress + (CharBankC * $800))
	.var CharAddressD = (BaseBankAddress + (CharBankD * $800))

	.var WAVYSCROLLER_SinTab_CharAndPixelTable = $3000
	.var WAVYSCROLLER_StartD011Offset = 2
	.var WAVYSCROLLER_XOffset = 5
	.var WAVYSCROLLER_STARTY = 4
	.var WAVYSCROLLER_YLEN = 16
	.var WAVYSCROLLER_YCHARLEN = 14
	.var WAVYSCROLLER_ENDY = WAVYSCROLLER_STARTY + WAVYSCROLLER_YLEN
	.var WAVYSCROLLER_YRASTER = $32 + (WAVYSCROLLER_STARTY * 8) + (WAVYSCROLLER_StartD011Offset) - 2

	.var WAVYSCROLLER_Colours_Screen = (6)
	.var WAVYSCROLLER_Colour_0 = (14)
	.var WAVYSCROLLER_Colour_1 = (14)

	.var WAVYSCROLLER_NumLines = (WAVYSCROLLER_YLEN * 8)

	.var WAVYSCROLLER_NUM_NOPS_BEFORE_D011S = 12
	.var WAVYSCROLLER_NUM_NOPS_BETWEEN_D011S = 3

	.var WAVYSCROLLER_CharSet = $8000
	.var WAVYSCROLLER_CharInfo = $ff00

	.var WAVYSCROLLER_NUM_CHARS_IN_CHARSET = 15
	.var WAVYSCROLLER_CHAR_START = 0

	.var WAVYSCROLLER_BLITCODE_BASE = $c000