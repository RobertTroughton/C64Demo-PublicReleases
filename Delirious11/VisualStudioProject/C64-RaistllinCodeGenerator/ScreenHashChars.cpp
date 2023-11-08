// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#define MYPI 3.1415

// Sprite Positions:-
#define NUM_SPRITES 23
/*unsigned char SpriteXYPositions[] = {
	80, 6,		// 1
	104, 12,	// 2
	118, 30,	// 3
	125, 51,	// 4
	128, 71,	// 5
	129, 81,	// 6
	129, 102,	// 7
	126, 123,	// 8
	120, 144,	// 9
	108, 165,	// 10
	84, 173,	// 11
	60, 173,	// 12
	43, 169,	// 13
	24, 160,	// 14
	14, 139,	// 15
	8, 118,		// 16
	7, 97,		// 17
	7, 76,		// 18
	9, 55,		// 19
	16, 34,		// 20
	28, 27,		// 21
	32, 11,		// 22
	56, 6,		// 0
};*/

void ScreenHashChars_OutputSprites(LPCTSTR InputSpritesFilename, LPCTSTR OutputSpritesFilename)
{
	static const int BMPOffset = 0x3e;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputSpritesFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned char SpriteData[NUM_SPRITES][64];
	ZeroMemory(SpriteData, NUM_SPRITES * 64);
	for (unsigned int SpriteIndex = 0; SpriteIndex < NUM_SPRITES; SpriteIndex++)
	{
		for (unsigned int YPos = 0; YPos < 21; YPos++)
		{
			for (unsigned int XPos = 0; XPos < 24; XPos++)
			{
				unsigned int OutputOffset = YPos * 3 + XPos / 8;
				unsigned int XShiftLeft = 7 - (XPos & 7);

				unsigned int YRead = (24 * NUM_SPRITES - 1) - ((SpriteIndex * 24) + YPos); // Convert Y and SpriteIndex so that we read the BMP bottom-to-top (dumb BMPs!!)
		
				unsigned int InputOffset = BMPOffset + YRead * 24 + XPos;

				unsigned char ReadValue = 1 - FileReadBuffer[InputOffset]; // we need to invert the byte as 1=black, 0=white in the source image

				SpriteData[SpriteIndex][OutputOffset] |= ReadValue << XShiftLeft;
			}
		}
	}
	WriteBinaryFile(OutputSpritesFilename, SpriteData, NUM_SPRITES * 64);
}

void ScreenHashChars_OutputChars(LPCTSTR CharTableFilename, LPCTSTR ScreenTableFilename)
{
	unsigned char CharTable[256][8];
	ZeroMemory(CharTable, 256 * 8);

	for (unsigned int CharIndex0 = 0; CharIndex0 < 16; CharIndex0++)
	{
		for (unsigned int CharIndex1 = 0; CharIndex1 < 16; CharIndex1++)
		{
			unsigned char BitsSet0[16];
			ZeroMemory(BitsSet0, 16);
			unsigned char BitsSet1[16];
			ZeroMemory(BitsSet1, 16);

			for (unsigned int Test0 = 0; Test0 < CharIndex0 + 1; Test0++)
			{
				bool bFound = false;
				while (bFound == false)
				{
					unsigned int TestBit = rand() % 16;
					if (BitsSet0[TestBit] == 0)
					{
						BitsSet0[TestBit] = 1;
						bFound = true;
					}
				}
			}
			for (unsigned int Test1 = 0; Test1 < CharIndex1 + 1; Test1++)
			{
				bool bFound = false;
				while (bFound == false)
				{
					unsigned int TestBit = rand() % 16;
					if (BitsSet1[TestBit] == 0)
					{
						BitsSet1[TestBit] = 1;
						bFound = true;
					}
				}
			}

			for (unsigned int OutputY = 0; OutputY < 8; OutputY++)
			{
				unsigned char BitValue = 0;
				for (unsigned int OutputX = 0; OutputX < 4; OutputX++)
				{
					bool bSet = false;
					if ((OutputY & 1) == 0)
					{
						BitValue |= BitsSet0[(OutputY / 2) * 4 + OutputX] << (OutputX * 2);

					}
					else
					{
						BitValue |= BitsSet1[(OutputY / 2) * 4 + OutputX] << (OutputX * 2 + 1);
					}
				}
				CharTable[CharIndex0 * 16 + CharIndex1][OutputY] = BitValue;
			}
			for (unsigned int YCheck = 0; YCheck < 4; YCheck++)
			{
				unsigned char OredChar = CharTable[CharIndex0 * 16 + CharIndex1][YCheck * 2] | CharTable[CharIndex0 * 16 + CharIndex1][YCheck * 2 + 1];

				unsigned char FullOredChar0 = 0;
				unsigned char FullOredChar1 = 0;
				if ((OredChar & 0xc0) == 0xc0)
					FullOredChar0 |= 0xc0;
				if ((OredChar & 0x30) == 0x30)
					FullOredChar1 |= 0x30;
				if ((OredChar & 0x0c) == 0x0c)
					FullOredChar0 |= 0x0c;
				if ((OredChar & 0x03) == 0x03)
					FullOredChar1 |= 0x03;

				CharTable[CharIndex0 * 16 + CharIndex1][YCheck * 2] |= FullOredChar0;
				CharTable[CharIndex0 * 16 + CharIndex1][YCheck * 2 + 1] |= FullOredChar1;
			}
		}
	}
	for (unsigned int Index = 0; Index < 8; Index++)
	{
		CharTable[0][Index] = 0;
	}
	WriteBinaryFile(CharTableFilename, CharTable, 256 * 8);

	unsigned char ScreenTable[40 * 25];
	ZeroMemory(ScreenTable, 40 * 25);
	for (unsigned int YVal = 0; YVal < 25; YVal++)
	{
		for (unsigned int XVal = 0; XVal < 40; XVal++)
		{
			double fVal0 = sqrt((28.0 - XVal)*(28.0 - XVal) + (7.0 - YVal)*(7.0 - YVal));
			double fVal1 = sqrt((12.0 - XVal)*(12.0 - XVal) + (19.0 - YVal)*(19.0 - YVal));
			unsigned char cXVal = (unsigned char)(min(15.0, max(0.0, fVal0)));
			unsigned char cYVal = (unsigned char)(min(15.0, max(0.0, fVal1)));
			ScreenTable[YVal * 40 + XVal] = ((cXVal & 15) << 4) | (cYVal & 15);
		}
	}
	WriteBinaryFile(ScreenTableFilename, ScreenTable, 40 * 25);
}

void ScreenHashChars_OutputSinTable(LPCTSTR SinTableFilename)
{
	int SinTable[256];
	GenerateSinTable(256, 0, 15, 0, SinTable);

	unsigned char cSinTable[1024 + 256];
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex +   0] = cSinTable[SinIndex + 256] = (unsigned char)(SinTable[SinIndex] *  1);
		cSinTable[SinIndex + 512] = cSinTable[SinIndex + 768] = (unsigned char)(SinTable[SinIndex] * 16);
	}

	GenerateSinTable(256, 0, 255, 0, SinTable);
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex + 1024] = (unsigned char)(SinTable[SinIndex]);
	}
	WriteBinaryFile(SinTableFilename, cSinTable, 1024 + 256);
}

int ScreenHashChars_Main(void)
{
	ScreenHashChars_OutputChars(L"..\\..\\Intermediate\\Built\\ScreenHashChars-Chars.bin", L"..\\..\\Intermediate\\Built\\ScreenHashChars-Screen.bin");
	ScreenHashChars_OutputSinTable(L"..\\..\\Intermediate\\Built\\ScreenHashChars-SinTable.bin");
	ScreenHashChars_OutputSprites(L"..\\..\\SourceData\\CircleMadeFromSprites-24x24x23.bmp", L"..\\..\\Intermediate\\Built\\ScreenHashChars-Sprites.bin");

	return 0;
}

