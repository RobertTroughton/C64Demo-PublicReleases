//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\CodeGen.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

void DYPP_AnimTree_ConvertSprites(char* InputSingleColourSpritesFilename, char* InputMultiColourSpritesFilename, LPCTSTR OutputFilename)
{
	CImg<unsigned char> SColSpritesImg(InputSingleColourSpritesFilename);	//; 192 x 42
	CImg<unsigned char> MColSpritesImg(InputMultiColourSpritesFilename);	//; 48 x 42

	//; Multicol sprites
	unsigned char SpriteOutputData[4 + 16][64];
	ZeroMemory(SpriteOutputData, (4 + 16) * 64);
	for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
	{
		for (int YPos = 0; YPos < 21; YPos++)
		{
			for (int XPos = 0; XPos < 12; XPos++)
			{
				int XRead = (SpriteIndex % 2) * 24 + (XPos * 2);
				int YRead = (SpriteIndex / 2) * 21 + YPos;
				unsigned char Red = MColSpritesImg(XRead, YRead, 0, 0);
				unsigned char OutCol = 0;
				switch (Red)
				{
					case 0x35: OutCol = 1; break;
					case 0x00: OutCol = 2; break;
					case 0x6f: OutCol = 3; break;
				}

				int ByteIndex = (YPos * 3) + (XPos / 4);
				unsigned char BitSet = (OutCol << ((3 - (XPos & 3)) * 2));
				SpriteOutputData[SpriteIndex][ByteIndex] |= BitSet;
			}
		}
	}

	//; Singlecol sprites
	for (int SpriteIndex = 0; SpriteIndex < 16; SpriteIndex++)
	{
		for (int YPos = 0; YPos < 21; YPos++)
		{
			for (int XPos = 0; XPos < 24; XPos++)
			{
				int XRead = (SpriteIndex % 8) * 24 + XPos;
				int YRead = (SpriteIndex / 8) * 21 + YPos;
				unsigned char Red = SColSpritesImg(XRead, YRead, 0, 0);
				unsigned char OutCol = 0;
				switch (Red)
				{
					case 0xff: OutCol = 1; break;
				}

				int ByteIndex = (YPos * 3) + (XPos / 8);
				unsigned char BitSet = (OutCol << (7 - (XPos & 7)));
				SpriteOutputData[SpriteIndex + 4][ByteIndex] |= BitSet;
			}
		}
	}
	WriteBinaryFile(OutputFilename, SpriteOutputData, (4 + 16) * 64);
}

int DYPP_AnimTree_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\DYPP");

	DYPP_AnimTree_ConvertSprites("..\\..\\Build\\Parts\\DYPP\\Data\\SkullHunter-SingleColours.png", "..\\..\\Build\\Parts\\DYPP\\Data\\SkullHunter-MultiColours.png", L"..\\..\\Intermediate\\Built\\DYPP\\SkullHunterSprites.bin");

	return 0;
}
