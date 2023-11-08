//; (c) 2018-2019, Genesis*Project

#include "Common.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

static bool DoSpritesMatch(unsigned char* Sprite0, unsigned char* Sprite1)
{
	for (int Index0 = 0; Index0 < 63; Index0++)
	{
		unsigned char Value0 = Sprite0[Index0];
		unsigned char Value1 = Sprite1[Index0];
		if (Value0 != Value1)
		{
			return false;
		}
	}
	return true;
}

void ImageConv_ImageToMAPandSCR(char* InputFilename, LPCTSTR OutputMAPFilename, LPCTSTR OutputSCRFilename)
{
	CImg<unsigned char> SrcImg(InputFilename);
	SrcImg.resize(320, 200);

	unsigned char CharSet[256][8];
	int NumChars = 0;

	unsigned char ScreenData[25][40];

	unsigned int ColoursUsed[4];
	int NumColoursUsed = 0;

	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 40; XChar++)
		{
			unsigned char ThisChar[8];
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = YChar * 8 + YPixel;
				unsigned char OutputByte = 0;
				for (int XPixel = 0; XPixel < 8; XPixel+=2)
				{
					int XPos = XChar * 8 + XPixel;

					unsigned char R = SrcImg(XPos, YPos, 0, 0);
					unsigned char G = SrcImg(XPos, YPos, 0, 1);
					unsigned char B = SrcImg(XPos, YPos, 0, 2);

					unsigned int ColourHere = (R << 16) | (G << 8) | (B << 0);

					int FoundColourIndex = -1;
					for (int ColourIndex = 0; ColourIndex < NumColoursUsed; ColourIndex++)
					{
						if (ColoursUsed[ColourIndex] == ColourHere)
						{
							FoundColourIndex = ColourIndex;
							break;
						}
					}
					if (FoundColourIndex == -1)
					{
						FoundColourIndex = NumColoursUsed++;
						ColoursUsed[FoundColourIndex] = ColourHere;
					}
					OutputByte |= (FoundColourIndex << (6 - XPixel));
				}
				ThisChar[YPixel] = OutputByte;
			}

			int MatchCharIndex = -1;
			for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
			{
				bool bMatch = true;
				for (int ByteIndex = 0; ByteIndex < 8; ByteIndex++)
				{
					if (CharSet[CharIndex][ByteIndex] != ThisChar[ByteIndex])
					{
						bMatch = false;
						break;
					}
				}
				if (bMatch)
				{
					MatchCharIndex = CharIndex;
					break;
				}
			}
			if (MatchCharIndex == -1)
			{
				MatchCharIndex = NumChars++;
				for (int ByteIndex = 0; ByteIndex < 8; ByteIndex++)
				{
					CharSet[MatchCharIndex][ByteIndex] = ThisChar[ByteIndex];
				}
			}
			ScreenData[YChar][XChar] = MatchCharIndex;
		}
	}
	WriteBinaryFile(OutputMAPFilename, CharSet, NumChars * 8);
	WriteBinaryFile(OutputSCRFilename, ScreenData, 25 * 40);
}

void ImageConv_BMPToPackedSpriteData(LPCTSTR InputFilename, LPCTSTR OutputSpriteDataFilename, LPCTSTR OutputPackedSpriteDataFilename, LPCTSTR OutputPackedSpriteLookupFilename, int Width, int Height, bool bMulticolour, unsigned char* ColourRemap, int InterleaveHeight, int NumAnims, int VirtualNumAnims)
{
	unsigned char SpriteData[1024][64];
	unsigned char PackedSpriteData[256][64];
	unsigned char PackedSpriteLookup[256];

	ZeroMemory(SpriteData, sizeof(SpriteData));
	ZeroMemory(PackedSpriteData, sizeof(PackedSpriteData));
	ZeroMemory(PackedSpriteLookup, sizeof(PackedSpriteLookup));

	int InputWidth = Width * NumAnims;
	int SpriteIndexStridePerRow = (Width * NumAnims)/ 24;
	int VirtualSpriteIndexStridePerRow = (Width * VirtualNumAnims) / 24;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	if (!hFile)
	{
		return;
	}
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	int NumSprites = (InputWidth / 24) * (Height / InterleaveHeight);

	int BMPBitmapDataOffset = 0x3e;
	int ReadBitsStride = 1;
	if (bMulticolour)
	{
		int NumColours = *(int *)(&FileReadBuffer[0x2E]);
		BMPBitmapDataOffset = 0x36 + 4 * NumColours;
		ReadBitsStride = 2;
	}

	int SpriteIndexOffset = 0;
	for (int YRead = 0; YRead < Height; YRead++)
	{
		for (int XRead = 0; XRead < InputWidth; XRead += 8)
		{
			unsigned char OutputChar = 0;
			for (int XByteRead = 0; XByteRead < 8; XByteRead += ReadBitsStride)
			{
				int ReadLocation = BMPBitmapDataOffset;
				ReadLocation += (Height - 1 - YRead) * InputWidth;
				ReadLocation += (XRead + XByteRead);
				unsigned char ReadValue = FileReadBuffer[ReadLocation];
				unsigned char NewValue = ColourRemap[ReadValue];

				int BitShift = (bMulticolour ? 6 : 7) - XByteRead;

				OutputChar |= NewValue << BitShift;
			}

			int XSpriteIndex = XRead / 24;
			int XPixelIndex = XRead % 24;

			int YSpriteIndex = YRead / InterleaveHeight;
			int YPixelIndex = YRead % 21;
			int OutputSpriteIndex = XSpriteIndex + YSpriteIndex * SpriteIndexStridePerRow;
			int ByteOffset = (XPixelIndex / 8) + (YPixelIndex * 3);

			SpriteData[OutputSpriteIndex][ByteOffset] = OutputChar;
		}
	}
	WriteBinaryFile(OutputSpriteDataFilename, SpriteData, NumSprites * 64);

	if (OutputPackedSpriteDataFilename != NULL)
	{
		int NumPackedSprites = 0;
		for (int SpriteIndex0 = 0; SpriteIndex0 < NumSprites; SpriteIndex0++)
		{
			int Match = -1;
			for (int SpriteIndex1 = 0; SpriteIndex1 < NumPackedSprites; SpriteIndex1++)
			{
				if(DoSpritesMatch(SpriteData[SpriteIndex0], PackedSpriteData[SpriteIndex1]))
				{
					Match = SpriteIndex1;
					break;
				}
			}
			if (Match == -1)
			{
				Match = NumPackedSprites;
				NumPackedSprites++;
			}

			int XSpriteIndex = SpriteIndex0 % SpriteIndexStridePerRow;
			int YSpriteIndex = SpriteIndex0 / SpriteIndexStridePerRow;
			int NewSpriteIndex = XSpriteIndex + YSpriteIndex * VirtualSpriteIndexStridePerRow;

			memcpy(PackedSpriteData[Match], SpriteData[SpriteIndex0], 64);
			PackedSpriteLookup[NewSpriteIndex] = Match;
		}
		int VirtualNumSprites = (NumSprites / SpriteIndexStridePerRow) * VirtualSpriteIndexStridePerRow;
		WriteBinaryFile(OutputPackedSpriteDataFilename, PackedSpriteData, NumPackedSprites * 64);
		WriteBinaryFile(OutputPackedSpriteLookupFilename, PackedSpriteLookup, VirtualNumSprites);
	}
}

