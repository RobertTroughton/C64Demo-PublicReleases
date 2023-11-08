// (c) 2018-2020, Genesis*Project


//; TODO: optimise sprite memory:-
//;		- change the sprite X/MSB code so that the sprites only scroll by 0-47 pixels... and then update SpriteVals instead to scroll!
//;		- look for duplicate sprites and remove them
//;		- split the sprite data into the 2 banks
//;		- weave the sprite data into screen memory where possible?

#include <atlstr.h>

#include "..\Common\Common.h"

void JaddedEdge_Do(LPTSTR OutSpriteMAPFilename)
{
	unsigned char OutSprites[13][64];
	unsigned int OutBytes[13] = {0x000, 0x040, 0x060, 0x0e0, 0x0f0, 0x1f0, 0x1f8, 0x3f8, 0x3fc, 0x7fc, 0x7fe, 0xffe, 0xfff};
	for (int AnimIndex = 0; AnimIndex < 13; AnimIndex++)
	{
		for (int YLine = 0; YLine < 21; YLine++)
		{
			OutSprites[AnimIndex][YLine * 3 + 0]  = (OutBytes[AnimIndex] & 0xff0) >> 4;
			OutSprites[AnimIndex][YLine * 3 + 1]  = (OutBytes[AnimIndex] & 0x00f) << 4;
			OutSprites[AnimIndex][YLine * 3 + 1] |= (OutBytes[AnimIndex] & 0xf00) >> 8;
			OutSprites[AnimIndex][YLine * 3 + 2]  = (OutBytes[AnimIndex] & 0x0ff);
		}
		OutSprites[AnimIndex][63] = OutSprites[AnimIndex][62];
	}
	WriteBinaryFile(OutSpriteMAPFilename, OutSprites, sizeof(OutSprites));
}


int SpriteTransitions_Main(void)
{
	JaddedEdge_Do(L"Out\\6502\\Misc\\SpriteTransitions\\SpriteTrans.map");

	return 0;
}
