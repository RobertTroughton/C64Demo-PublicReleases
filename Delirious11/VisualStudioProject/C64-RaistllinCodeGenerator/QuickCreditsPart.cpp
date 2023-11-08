// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

#define NUM_SPRITES_PER_LINE 4

void BMPBitmap_To_PackedSprites(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, unsigned int Width, unsigned int Height)
{
	static const int BMPBitmapDataOffset = 0x3e;
	unsigned char OutputData[256 * 64];
	unsigned int CurrentNumSprites = 0;

	ZeroMemory(OutputData, 256 * 64);

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned int YReadStride = ((Width / 8) + 3) & 0xfffffffc;

	for (unsigned int SpriteLine = 0; SpriteLine < Height / 21; SpriteLine++)
	{
		unsigned int MinX = SpriteLine * 21;
		for (unsigned int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE; SpriteIndex++)
		{
			for (unsigned int YVal = 0; YVal < 21; YVal++)
			{
				for (unsigned int XVal = 0; XVal < 24; XVal++)
				{
					unsigned int YPos = SpriteLine * 21 + YVal;
					unsigned int XPos = MinX + (SpriteIndex * 24) + XVal; 
					if (XPos < Width)
					{
						unsigned int ReadOffset = BMPBitmapDataOffset + (Height - 1 - YPos) * YReadStride + (XPos / 8);
						unsigned char Byte = FileReadBuffer[ReadOffset];
						unsigned char BitLeftShift = 7 - (XPos & 7);
						bool bPixelSet = (Byte & (1 << BitLeftShift)) == 0;
						if (bPixelSet)
						{
							unsigned int OutputByteOffset = CurrentNumSprites * 64 + YVal * 3 + XVal / 8;
							unsigned int OutputByteLeftShift = 7 - (XVal & 7);
							OutputData[OutputByteOffset] |= 1 << OutputByteLeftShift;
						}
					}
				}
			}
			CurrentNumSprites++;
		}
	}
	WriteBinaryFile(OutputDataFilename, OutputData, CurrentNumSprites * 64);
}

void QuickCredits_SinTables(LPCTSTR OutputFilename)
{
	int QuickCredits_SinTabX[256];
	int QuickCredits_SinTabY[256];
	GenerateSinTable(256, 0, 40, 0, QuickCredits_SinTabX);
	GenerateSinTable(256, 0, 69, 0, QuickCredits_SinTabY);

	unsigned char cQuickCredits_SinTab[256 * 2];
	for (unsigned int Index = 0; Index < 256; Index++)
	{
		cQuickCredits_SinTab[Index] = (unsigned char)QuickCredits_SinTabX[Index];
		cQuickCredits_SinTab[Index + 256] = (unsigned char)QuickCredits_SinTabY[Index];
	}
	WriteBinaryFile(OutputFilename, cQuickCredits_SinTab, 512);
}

#define NUM_SPRITES_TO_USE_FOR_CLEAR 24
void QuickCredits_ClearSprites(LPCTSTR OutputFilename)
{
	unsigned char ClearSprites[256 * 64];
	ZeroMemory(ClearSprites, 256 * 64);
	unsigned char PixelCovered[24];

	unsigned int NumPixelsCovered = 0;
	ZeroMemory(PixelCovered, 24);
	for (unsigned int SpriteNum = 0; SpriteNum < NUM_SPRITES_TO_USE_FOR_CLEAR; SpriteNum++)
	{
		if (SpriteNum > 0)
		{
			for (unsigned int CopyIndex = 0; CopyIndex < 64; CopyIndex++)
			{
				ClearSprites[SpriteNum * 64 + CopyIndex] = ClearSprites[(SpriteNum - 1) * 64 + CopyIndex];
			}
		}
		unsigned int NumPixelsToCover = (24 * SpriteNum) / (NUM_SPRITES_TO_USE_FOR_CLEAR - 1);

		while (NumPixelsCovered < NumPixelsToCover)
		{
			unsigned int Attempt = rand() % 24;
			if (!PixelCovered[Attempt])
			{
				for (unsigned int YVal = 0; YVal < 21; YVal++)
				{
					ClearSprites[(SpriteNum * 64) + (YVal * 3) + (Attempt / 8)] |= 1 << (Attempt & 7);
				}
				PixelCovered[Attempt] = 1;
				NumPixelsCovered++;
			}
		}
	}
	WriteBinaryFile(OutputFilename, ClearSprites, NUM_SPRITES_TO_USE_FOR_CLEAR * 64);
}


int QuickCredits_Main()
{
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-BLANKNAME.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-BLANKNAME.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Raistlin.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Raistlin.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-MCH.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-MCH.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-CelticDesign.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-CelticDesign.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Razorback.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Razorback.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Redcrab.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Redcrab.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Mermaid.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Mermaid.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Hedning.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Hedning.bin", 243, 168);
	BMPBitmap_To_PackedSprites(L"..\\..\\SourceData\\002-CREDITS-Kobi.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Kobi.bin", 243, 168);

	Output_BMPBitmapToCharScreenData(L"..\\..\\SourceData\\002-CREDITS-Code.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Code-Data.bin", L"..\\..\\Intermediate\\Built\\002-CREDITS-Code-Screen.bin", 320, 200, 40, 25, false, 0);
	Output_BMPBitmapToCharScreenData(L"..\\..\\SourceData\\002-CREDITS-Art.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Art-Data.bin", L"..\\..\\Intermediate\\Built\\002-CREDITS-Art-Screen.bin", 320, 200, 40, 25, false, 0);
	Output_BMPBitmapToCharScreenData(L"..\\..\\SourceData\\002-CREDITS-Sound.bmp", L"..\\..\\Intermediate\\Built\\002-CREDITS-Sound-Data.bin", L"..\\..\\Intermediate\\Built\\002-CREDITS-Sound-Screen.bin", 320, 200, 40, 25, false, 0);

	QuickCredits_ClearSprites(L"..\\..\\Intermediate\\Built\\002-CREDITS-ClearSprites.bin");

	QuickCredits_SinTables(L"..\\..\\Intermediate\\Built\\002-CREDITS-SinTables.bin");
	return 0;
}
