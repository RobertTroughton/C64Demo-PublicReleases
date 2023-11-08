//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var CharBank1 = 2 //; Bank+[1000,17ff]
	.var CharBank0 = 3 //; Bank+[1800,1fff]
	.var ScreenBank0 = 2 //; Bank+[0800,0bff]
	.var ScreenBank1 = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress0 + (ScreenBank1 * 1024))
	.var SpriteVals0 = (ScreenAddress0 + $3F8 + 0)
	.var SpriteVals1 = (ScreenAddress1 + $3F8 + 0)

	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank1 * 16) + (CharBank0 * 2)
	.var D018Value0B = (ScreenBank0 * 16) + (CharBank1 * 2)
	.var D018Value1B = (ScreenBank1 * 16) + (CharBank1 * 2)

	.var D011_Value_24Rows = $13
	.var D011_Value_25Rows = $1b

	.var D016_Value_38Rows = $07
	.var D016_Value_40Rows = $08

	.var AllBorderDYPP_FirstFrameIRQLine = $f8
	.var AllBorderDYPP_MainIRQLine = $15

	.var ZP_IRQJump = $18

	.var FirstSpriteValue = $80
	.var SpriteValStride = 9
	.var DYPP_BackgroundColour = $00

	.var DYPP_TOTALWIDTH = 432
	.var SpriteXValsMem = $fc00

	.var ZP_SpriteScrollerColour = $1f
	.var ZP_ScrollText = $20

	.var DYPP_ScrollText = $c400
	.var FontDataDeduped = $6e00

	.var MainIRQ = $2500

.import source "../../../Out/6502/Parts/AllBorderDYPP/FontDefines.asm"
