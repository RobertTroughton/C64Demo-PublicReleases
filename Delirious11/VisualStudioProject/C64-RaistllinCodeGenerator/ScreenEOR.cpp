// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"

void ScreenEOR_OutputChars(LPCTSTR CharTableFilename)
{
	unsigned char CharTable[64][8];
	ZeroMemory(CharTable, 64 * 8);
	for (unsigned int CharIndex = 0; CharIndex < 64; CharIndex++)
	{
		unsigned char CharHitTable[64];
		ZeroMemory(CharHitTable, 64);

		for (unsigned int NumBits = 0; NumBits < CharIndex; NumBits++)
		{
			bool bFound = false;
			unsigned char bit = 0;
			while (bFound == false)
			{
				bit = rand() % 64;
				if (!CharHitTable[bit])
				{
					CharHitTable[bit] = 1;
					bFound = true;
				}
			}
		}
		for (unsigned int YIndex = 0; YIndex < 8; YIndex++)
		{
			unsigned char CurrentBits = 0;
			for (unsigned int XIndex = 0; XIndex < 8; XIndex++)
			{
				CurrentBits |= CharHitTable[XIndex + YIndex * 8] << XIndex;
			}
			CharTable[CharIndex][YIndex] = CurrentBits;
		}
	}
	WriteBinaryFile(CharTableFilename, CharTable, 64 * 8);
}


int ScreenEOR_Main(void)
{
	ScreenEOR_OutputChars(L"..\\..\\Intermediate\\Built\\ScreenEOR-Chars.bin");

	return 0;
}

