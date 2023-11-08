//; (c) 2018, Raistlin of Genesis*Project

	.var WAVES_SpriteClipASM = $8000

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines0
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)
	.var CharBank = 0 //; Bank+[0000,07ff]
	.var ScreenBank0 = 8 //; Bank+[3000,33ff]
	.var ScreenBank1 = 9 //; Bank+[3400,37ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (BaseBankAddress + (ScreenBank1 * 1024))
	.var SPRITE_Vals0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE_Vals1 = (ScreenAddress1 + $3F8 + 0)

	.var WAVES_FirstSpriteValue = 160
	.var WAVES_FirstSpriteAddress = BaseBankAddress + (WAVES_FirstSpriteValue * 64)

	.var WAVES_ClipData = $b000
	.var WAVES_SourceSpriteDataToClip = $3e00
	.var WAVES_SpriteClipIndices = $cd78
	.var WAVES_AnimationLookup = $cd80

	//; Wave Sintables
	.var WAVES_SinTables = $3000
	.var WAVES_SinTable_Pixel = WAVES_SinTables + $000
	.var WAVES_SinTable_Char = WAVES_SinTables + $100
	.var WAVES_SinTable_Undulation = WAVES_SinTables + $200
	.var WAVES_SinTable_UndulationHi = WAVES_SinTables + $300

	//; Sprite Sintables
	.var WAVES_SpriteSinTables = $c000
	.var WAVES_SpriteSinTableLen = $100
	.var WAVES_SinTable_SpriteX0 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 0)
	.var WAVES_SinTable_SpriteX1 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 1)
	.var WAVES_SinTable_SpriteX2 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 2)
	.var WAVES_SinTable_SpriteX3 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 3)
	.var WAVES_SinTable_SpriteX4 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 4)
	.var WAVES_SinTable_SpriteX5 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 5)
	.var WAVES_SinTable_SpriteX6 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 6)
	.var WAVES_SinTable_SpriteX7 = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 7)
	.var WAVES_SinTable_SpriteXMSB = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 8)
	.var WAVES_SinTable_SpriteClipX = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 9)
	.var WAVES_SinTable_SpriteClipXPixel = WAVES_SpriteSinTables + (WAVES_SpriteSinTableLen * 10)

	.var WAVES_SinMovementSpacing = 7
	.var WAVES_SinScaleSpacing = 97
	.var WAVES_SinScaleSpeed = 4

