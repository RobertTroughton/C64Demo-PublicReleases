// (c) 2018-2020, Genesis*Project

#define _CRT_SECURE_NO_WARNINGS

#include "Common.h"

void ConvertBitmapDataToStreamData(LPTSTR MAPFilename, LPTSTR SCRFilename, LPTSTR COLFilename, int Width, int Height, LPTSTR OutputFilename)
{
	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	int BitmapCharLineDataSize = CharWidth * 8;
	int ScreenCharLineDataSize = CharWidth;
	int BitmapDataSize = CharHeight * BitmapCharLineDataSize;
	int ScreenDataSize = CharHeight * ScreenCharLineDataSize;
	int HalfColourDataSize = ScreenDataSize / 2;

	unsigned char* OutBitmap = new unsigned char[BitmapDataSize];
	unsigned char* OutScreen = new unsigned char[ScreenDataSize];
	unsigned char* OutColour = new unsigned char[ScreenDataSize];
	unsigned char* OutHalfColour = new unsigned char[HalfColourDataSize];

	ReadBinaryFile(MAPFilename, OutBitmap, BitmapDataSize);
	ReadBinaryFile(SCRFilename, OutScreen, ScreenDataSize);
	ReadBinaryFile(COLFilename, OutHalfColour, HalfColourDataSize);

	//; HACK!
	for (int COLIndex = 0; COLIndex < HalfColourDataSize; COLIndex++)
	{
		OutColour[COLIndex * 2 + 0] = OutHalfColour[COLIndex] & 0x0f;
		OutColour[COLIndex * 2 + 1] = (OutHalfColour[COLIndex] & 0xf0) >> 4;
	}

	ConvertBitmapDataToStreamData(Width, Height, OutBitmap, OutScreen, OutColour, OutputFilename);

	delete[] OutBitmap;
	delete[] OutScreen;
	delete[] OutColour;
}

void ConvertBitmapDataToStreamData(int Width, int Height, unsigned char* MAPData, unsigned char* SCRData, unsigned char* COLData, LPTSTR OutputFilename)
{
	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	int BitmapCharLineDataSize = CharWidth * 8;
	int ScreenCharLineDataSize = CharWidth;
	int CharLineDataSize = BitmapCharLineDataSize + (ScreenCharLineDataSize * 2);
	int PackedDataSize = CharHeight * CharLineDataSize;
	unsigned char* OutputPackedData = new unsigned char[PackedDataSize];

	unsigned char* pPackedData = OutputPackedData;
	for (int YCharPos = 0; YCharPos < CharHeight; YCharPos++)
	{
		memcpy(pPackedData, &MAPData[BitmapCharLineDataSize * YCharPos], BitmapCharLineDataSize);
		pPackedData += BitmapCharLineDataSize;

		memcpy(pPackedData, &SCRData[ScreenCharLineDataSize * YCharPos], ScreenCharLineDataSize);
		pPackedData += ScreenCharLineDataSize;

		memcpy(pPackedData, &COLData[ScreenCharLineDataSize * YCharPos], ScreenCharLineDataSize);
		pPackedData += ScreenCharLineDataSize;
	}
	WriteBinaryFile(OutputFilename, OutputPackedData, PackedDataSize);

	delete[] OutputPackedData;
}

