//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define NUM_SPRITEFADE_RANDOMDITHER_ANIMS 32

void ScreenFadeAndTurnDisk_OutputSprites(LPCTSTR OutputSpriteFilename)
{
	unsigned char SpriteData[NUM_SPRITEFADE_RANDOMDITHER_ANIMS][64];
	ZeroMemory(SpriteData, NUM_SPRITEFADE_RANDOMDITHER_ANIMS * 64);
	int NumPixelsInSprite = 24 * 21;
	int NumDotsCovered = 0;
	for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITEFADE_RANDOMDITHER_ANIMS; SpriteIndex++)
	{
		if (SpriteIndex > 0)
		{
			memcpy(&SpriteData[SpriteIndex][0], &SpriteData[SpriteIndex - 1][0], 64);
		}
		int TotalNumDotsToCover = (NumPixelsInSprite * (SpriteIndex + 1)) / NUM_SPRITEFADE_RANDOMDITHER_ANIMS;
		int NumNewDotsToCover = TotalNumDotsToCover - NumDotsCovered;
		for (int DotIndex = 0; DotIndex < NumNewDotsToCover; DotIndex++)
		{
			bool bFound = false;
			while (!bFound)
			{
				int RandX = rand() % 24;
				int RandY = rand() % 21;

				int CharOffset = (RandX / 8) + (RandY * 3);
				unsigned char PixelShifted = 1 << (RandX % 8);

				if ((SpriteData[SpriteIndex][CharOffset] & PixelShifted) == 0)
				{
					SpriteData[SpriteIndex][CharOffset] |= PixelShifted;
					bFound = true;
				}
			}
		}
		NumDotsCovered = TotalNumDotsToCover;
	}
	WriteBinaryFile(OutputSpriteFilename, SpriteData, 64 * NUM_SPRITEFADE_RANDOMDITHER_ANIMS);
}

void TurnDisk_OutputSinTables(LPCTSTR OutputSinTableFilename)
{
	int SinTable[2][256];
	GenerateSinTable(256, 24, 66, 0, SinTable[0]);
	GenerateSinTable(256, 52, 66, 0, SinTable[1]);
	unsigned char cSinTable[2][256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[0][SinIndex] = (unsigned char)SinTable[0][SinIndex];
		cSinTable[1][SinIndex] = (unsigned char)SinTable[1][SinIndex];
	}
	WriteBinaryFile(OutputSinTableFilename, cSinTable, 256 * 2);
}

int ScreenFadeAndTurnDisk_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\ScreenFadeAndTurnDisk");

	ScreenFadeAndTurnDisk_OutputSprites(L"..\\..\\Intermediate\\Built\\ScreenFadeAndTurnDisk\\Sprites.bin");

	TurnDisk_OutputSinTables(L"..\\..\\Intermediate\\Built\\ScreenFadeAndTurnDisk\\SinTables.bin");

	return 0;
}
