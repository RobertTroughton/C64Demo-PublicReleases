// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

unsigned char OutputScreenData[1000000];

unsigned char OutputCharData[1000000];

void OutputRandomScreenFillPointers(LPCTSTR OutputDataFilename)
{
	static const unsigned int NumPointers = 1000;
	unsigned char OutputPointers[0x1800];
	ZeroMemory(OutputPointers, 0x1800);
	unsigned char PointerAlreadyOutput[NumPointers];
	ZeroMemory(PointerAlreadyOutput, NumPointers);
	for (unsigned int PointerIndex = 0; PointerIndex < NumPointers; PointerIndex++)
	{
		bool bFound = false;
		while (!bFound)
		{
			unsigned int PointerAttempt = (rand() % NumPointers);
			if (PointerAlreadyOutput[PointerAttempt] == 0)
			{
				bFound = true;
				OutputPointers[PointerIndex + 0x0000] = PointerAttempt % 256;			// Screen Lo
				OutputPointers[PointerIndex + 0x0400] = PointerAttempt / 256;			// Screen Hi
				OutputPointers[PointerIndex + 0x0800] = (PointerAttempt * 8) % 256;		// Data Lo
				OutputPointers[PointerIndex + 0x0c00] = (PointerAttempt * 8) / 256;		// Data Hi
				PointerAlreadyOutput[PointerAttempt]++;

				unsigned int SpriteClearingAttempt = PointerAttempt / 5; // As there are 19 sprites, 9 "chars" in each, gives 171 positions .. round out to 200 (1000/5)
				unsigned int SpriteNum = SpriteClearingAttempt / 9;
				unsigned int CharWithinSprite = (SpriteClearingAttempt % 9);
				unsigned int SpriteAttempt = (SpriteNum * 64) + ((CharWithinSprite / 3) * (7 * 3)) + (CharWithinSprite % 3);
				OutputPointers[PointerIndex + 0x1000] = SpriteAttempt % 256;			// Sprite Lo
				OutputPointers[PointerIndex + 0x1400] = SpriteAttempt / 256;			// Sprite Hi
			}
		}
	}
	WriteBinaryFile(OutputDataFilename, OutputPointers, 0x1800);
}

void Output_BMPToSpriteData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, bool bMulticolour, unsigned int Width, unsigned int Height)
{
	unsigned char ColourRemap[2][4] =
	{
		{1, 0},			// hires
		{3, 2, 1, 0}	// multicolour
	};
	unsigned int BMPBitmapDataOffset = 0x3e;
	unsigned int ReadBitsStride = 1;
	if (bMulticolour)
	{
		BMPBitmapDataOffset += 4;
		ReadBitsStride = 2;
	}

	unsigned char SpriteData[256 * 64];
	ZeroMemory(SpriteData, 256 * 64);

	unsigned int NumSprites = Width / 24;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	for (unsigned int YRead = 0; YRead < Height; YRead++)
	{
		for (unsigned int XRead = 0; XRead < Width; XRead += 8)
		{
			unsigned char OutputChar = 0;
			for (unsigned int XByteRead = 0; XByteRead < 8; XByteRead += ReadBitsStride)
			{
				unsigned int ReadLocation = BMPBitmapDataOffset;
				ReadLocation += (Height - 1 - YRead) * Width;
				ReadLocation += (XRead + XByteRead);
				unsigned char ReadValue = FileReadBuffer[ReadLocation];
				unsigned char NewValue = ColourRemap[bMulticolour][ReadValue];

				unsigned int BitShift = (bMulticolour ? 6 : 7) - XByteRead;

				OutputChar |= NewValue << BitShift;
			}
			unsigned int OutputSpriteIndex = XRead / 24;
			unsigned int OutputOffset = OutputSpriteIndex * 64;
			OutputOffset += (XRead / 8) % 3;
			OutputOffset += YRead * 3;
			SpriteData[OutputOffset] = OutputChar;
		}
	}
	WriteBinaryFile(OutputDataFilename, SpriteData, NumSprites * 64);
}

void Output_BMPBitmapToSpriteData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, unsigned int NumSprites, bool bInvertPixels)
{
	static const int BMPBitmapDataOffset = 0x3e;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned int SrcImageStride = (3 * NumSprites + 3) & (0xfffffffc);

	unsigned char SpriteOutput[65536];
	ZeroMemory(SpriteOutput, 65536);
	for(unsigned int SpriteIndex = 0; SpriteIndex < NumSprites; SpriteIndex++)
	{
		for (unsigned int YVal = 0; YVal < 21; YVal++)
		{
			for (unsigned int XVal = 0; XVal < 3; XVal++)
			{
				unsigned char* Ptr = &FileReadBuffer[BMPBitmapDataOffset + SpriteIndex * 3 + (21 - 1 - YVal) * SrcImageStride + XVal];
				unsigned char Byte = *Ptr;
				SpriteOutput[SpriteIndex * 64 + YVal * 3 + XVal] = bInvertPixels ? Byte : (0xff - Byte);
			}
		}
	}
	WriteBinaryFile(OutputDataFilename, SpriteOutput, NumSprites * 64);
}

void Output_BMPBitmapToCharScreenData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, LPCTSTR OutputScreenFilename, unsigned int ImageWidth, unsigned int ImageHeight, unsigned int OutputWidth, unsigned int OutputHeight, bool bInvertPixels, int NumExtraChars)
{
	ZeroMemory(OutputScreenData, 1000000);
	ZeroMemory(OutputCharData, 1000000);

	static const int BMPBitmapDataOffset = 0x3e;
	
	unsigned int OutputCharData_Num = 0;

	unsigned int SrcImageXChars = ImageWidth / 8;
	unsigned int SrcImageYChars = ImageHeight / 8;
	unsigned int SrcImageStride = (SrcImageXChars + 3) & 0xfffffffc;

	unsigned int MinX = 0;// (OutputWidth - SrcImageXChars) / 2;
	unsigned int MinY = 0;// (OutputHeight - SrcImageYChars) / 2;

	ZeroMemory(FileReadBuffer, FILE_READ_BUFFER_SIZE);

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	// Prefill first two characters - so that we know that 0th is space and 1th is filled
	for (unsigned int XPos = 0; XPos < 8; XPos++)
	{
		if (NumExtraChars > 0)
		{
			OutputCharData[0 * 8 + XPos] = 0; // "Space"
			if (NumExtraChars > 1)
			{
				OutputCharData[1 * 8 + XPos] = 255; // "Fully Filled"
				if (NumExtraChars > 2)
				{
					OutputCharData[2 * 8 + XPos] = ((XPos >= 2) && (XPos < 6)) ? 255 : 0; // "Half Filled"
				}
			}
		}
	}
	OutputCharData_Num += NumExtraChars;

	for (unsigned int YChar = 0; YChar < SrcImageYChars; YChar++)
	{
		for (unsigned int XChar = 0; XChar < SrcImageXChars; XChar++)
		{
			unsigned char CurrentOutput[8];
			for (unsigned int YPos = 0; YPos < 8; YPos++)
			{
				unsigned char* Ptr = &FileReadBuffer[BMPBitmapDataOffset + (ImageHeight - 1 - ((YChar * 8) + YPos)) * SrcImageStride + XChar];// *8];

				unsigned char Byte = *Ptr;
				CurrentOutput[YPos] = bInvertPixels ? Byte : (0xff - Byte);
			}

			bool bFound = false;
			unsigned int FoundChar;
			for (unsigned int OutputCharDataIndex = 0; OutputCharDataIndex < OutputCharData_Num; OutputCharDataIndex++)
			{
				bool bMatch = true;
				for (unsigned int YPos = 0; YPos < 8; YPos++)
				{
					if (OutputCharData[OutputCharDataIndex * 8 + YPos] != CurrentOutput[YPos])
					{
						bMatch = false;
					}
				}
				if (bMatch)
				{
					bFound = true;
					FoundChar = OutputCharDataIndex;
					break;
				}
			}

			if (!bFound)
			{
				FoundChar = OutputCharData_Num++;
				for (unsigned int YPos = 0; YPos < 8; YPos++)
				{
					OutputCharData[FoundChar * 8 + YPos] = CurrentOutput[YPos];
				}
			}
			OutputScreenData[YChar * OutputWidth + XChar] = (unsigned char)(FoundChar & 0x000000ff);
		}
	}
	WriteBinaryFile(OutputDataFilename, OutputCharData, OutputCharData_Num * 8);
	WriteBinaryFile(OutputScreenFilename, OutputScreenData, OutputWidth * OutputHeight);
}

int Images_Main(void)
{
	Output_BMPToSpriteData(L"..\\..\\SourceData\\2-Delirious11-BottomSprites.bmp", L"..\\..\\Intermediate\\Built\\2-Delirious11-BottomSprites.bin", false, 240, 21);
	Output_BMPToSpriteData(L"..\\..\\SourceData\\2-Delirious11-TopSprites.bmp", L"..\\..\\Intermediate\\Built\\2-Delirious11-TopSprites.bin", true, 144, 21);
	Output_BMPToSpriteData(L"..\\..\\SourceData\\2-Delirious11-SunSprites.bmp", L"..\\..\\Intermediate\\Built\\2-Delirious11-SunSprites.bin", false, 72, 21);

	// Intro Logos
	Output_BMPBitmapToCharScreenData(L"..\\..\\SourceData\\000-IntroQuote.bmp", L"..\\..\\Intermediate\\Built\\Intro-QuoteData.bin", L"..\\..\\Intermediate\\Built\\Intro-QuoteScreen.bin", 320, 200, 40, 25, false, 1);

	OutputRandomScreenFillPointers(L"..\\..\\Intermediate\\Built\\RandomScreenPointers.bin");

	return 0;
}
