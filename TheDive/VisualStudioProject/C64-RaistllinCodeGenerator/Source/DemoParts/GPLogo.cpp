//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\CodeGen.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define KLA_OFFSET_BITMAPDATA 2
#define KLA_OFFSET_SCREENDATA (KLA_OFFSET_BITMAPDATA + 8000)
#define KLA_OFFSET_COLOURDATA (KLA_OFFSET_SCREENDATA + 1000)
#define KLA_SIZE (KLA_OFFSET_COLOURDATA + 1000 + 1)

unsigned int Colours[] = {
	0x3e31a2,	//; Dark Blue
	0xbb776d,	//; Pink
	0x8a46ae,	//; Purple
	0x000000,	//; Black
};

char* ScrollText = {
	"                                      "
	"So, all good things must come to an end!    "
	"We hope that you enjoyed our little Gubbdata demo?    "
	"Special thanks and messages to some people who helped make this demo a reality...    "
	"Deek! For this awesome tune that you're listening to now...    "
	"Hedning! Happy Birthday, boss man!...    "
	"LFT for the awesome Spindle. After working on Rivalry and having to use another loader, let me tell you... Spindle is the best!    "
	"Christopher Jam for telling me about his cunning sprite interleave method...    "
	"JackAsser for all sorts of little coding nuggets that I never knew about...    "
	"CRT for his cool ideas...    "
	"and we'd also like to give special hellos to everyone who made it to gubbdata!    "
	".......  we will return  ......."
	"\xFF"
};
void GPLogo_ConvertFishSprites(char* InputFishSpritesPNG, LPCTSTR OutputMAP)
{
	unsigned char SpriteData[4][12][64];
	ZeroMemory(SpriteData, sizeof(SpriteData));

	CImg<unsigned char> SrcImg(InputFishSpritesPNG);

	for (int YPos = 0; YPos < 42; YPos++)
	{
		for (int XPos = 0; XPos < 576; XPos++)
		{
			unsigned char R = SrcImg(XPos, YPos, 0, 0);
			if (R != 0)
			{
				int SpriteSet = 0;
				if (XPos & 1)
				{
					SpriteSet += 1;
				}
				if (YPos & 1)
				{
					SpriteSet += 2;
				}
				int XVal = XPos / 2;
				int YVal = YPos / 2;

				int SpriteIndex = XVal / 24;

				XVal %= 24;

				int ByteIndex = (XVal / 8) + (YVal * 3);
				int BitSet = 7 - (XVal % 8);

				SpriteData[SpriteSet][SpriteIndex][ByteIndex] |= (1 << BitSet);
			}
		}
	}
	WriteBinaryFile(OutputMAP, SpriteData, sizeof(SpriteData));
}

void GPLogo_ConvertImage(char* InputImagePNG, LPCTSTR OutputKLA)
{
	unsigned char KLAData[KLA_SIZE];
	ZeroMemory(KLAData, KLA_SIZE);

	KLAData[0] = 0;
	KLAData[1] = 96;

	CImg<unsigned char> SrcImg(InputImagePNG);

	unsigned char ScreenVal = 0xA4;
	unsigned char ColourVal = 0x06;
	for (int YCharPos = 0; YCharPos < 25; YCharPos++)
	{
		if (YCharPos == 21)
		{
			ScreenVal = ColourVal = 0x00;
		}
		if (YCharPos == 22)
		{
			ScreenVal = 0x0e;
		}
		for (int XCharPos = 0; XCharPos < 40; XCharPos++)
		{
			KLAData[KLA_OFFSET_SCREENDATA + (YCharPos * 40) + XCharPos] = ScreenVal;
			KLAData[KLA_OFFSET_COLOURDATA + (YCharPos * 40) + XCharPos] = ColourVal;
		}
	}

	for (int YPos = 0; YPos < 200; YPos++)
	{
		for (int XPos = 0; XPos < 320; XPos+=2)
		{
			unsigned char R = SrcImg(XPos, YPos, 0, 0);
			unsigned char G = SrcImg(XPos, YPos, 0, 1);
			unsigned char B = SrcImg(XPos, YPos, 0, 2);
			unsigned int ColourHere = (R << 16) | (G << 8) | (B << 0);

			int FoundColourIndex = 0;
			for (int ColourIndex = 0; ColourIndex < 4; ColourIndex++)
			{
				if (Colours[ColourIndex] == ColourHere)
				{
					FoundColourIndex = ColourIndex;
					break;
				}
			}
			int XCharPos = XPos / 8;
			int XPixelPos = XPos % 8;
			int YCharPos = YPos / 8;
			int YPixelPos = YPos % 8;
			KLAData[KLA_OFFSET_BITMAPDATA + (YCharPos * 40 * 8) + XCharPos * 8 + YPixelPos] |= (FoundColourIndex << (6 - XPixelPos));
		}
	}
	WriteBinaryFile(OutputKLA, KLAData, KLA_SIZE);
}

void GPLogo_OutputColourPlotASM(char* InputMaskImagePNG, LPCTSTR OutputColourPlotASM)
{
	unsigned char ScreenPosUsed[25][40];
	ZeroMemory(ScreenPosUsed, sizeof(ScreenPosUsed));

	CImg<unsigned char> SrcMaskImg(InputMaskImagePNG);

	for (int YCharVal = 0; YCharVal < 25; YCharVal++)
	{
		for (int YPixel = 0; YPixel < 8; YPixel++)
		{
			int YPos = YCharVal * 8 + YPixel;
			for (int XCharVal = 0; XCharVal < 40; XCharVal++)
			{
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XCharVal * 8 + XPixel;
					unsigned char R = SrcMaskImg(XPos, YPos, 0, 0);
					if (R != 0)
					{
						ScreenPosUsed[YCharVal][XCharVal] = 1;
					}
				}
			}
		}
	}
			
	CodeGen ColourPlotCode(OutputColourPlotASM);

	ColourPlotCode.OutputFunctionLine(fmt::format("PlotColours"));

	ColourPlotCode.OutputCodeLine(LDY_ABS, fmt::format("#$00"));
	for (int XStartChar = 0; XStartChar < (40 + 24); XStartChar++)
	{
		for (int YCharVal = 0; YCharVal < 25; YCharVal++)
		{
			int XCharVal = XStartChar - YCharVal;
			if ((XCharVal >= 0) && (XCharVal < 40))
			{
				if (ScreenPosUsed[YCharVal][XCharVal])
				{
					ColourPlotCode.OutputCodeLine(LDA_IZY, fmt::format("ZP_ColourTablePtr"));
					ColourPlotCode.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress + ({:d} * 40) + {:d}", YCharVal, XCharVal));
				}
			}
		}
		ColourPlotCode.OutputCodeLine(INY);
	}
	ColourPlotCode.OutputCodeLine(RTS);
}

void GPLogo_OutputFishSineWaves(LPCTSTR OutputFishSineWavesXBIN, LPCTSTR OutputFishSineWavesYBIN, LPCTSTR OutputFishSineWavesSpriteValBIN)
{
	int FishSineWavesX[256];
	GenerateSinTable(256, 0, 49, 0, FishSineWavesX);

	int FishSineWavesY[64];
	GenerateSinTable(64, 0, 16, 0, FishSineWavesY);

	unsigned char cFishSineWavesX[256 * 2];
	unsigned char cFishSineWavesY[64 * 2];
	unsigned char cFishSineWavesSpriteVal[256 * 2];

	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		int SineValueX = FishSineWavesX[SinIndex];
		cFishSineWavesX[SinIndex + 0] = cFishSineWavesX[SinIndex + 256] = (unsigned char)(SineValueX / 2);

		int SineValueY = FishSineWavesY[SinIndex % 64];
		int SpriteSet = 0;
		if (!(SineValueX & 1))
		{
			SpriteSet += 1;
		}
		if (!(SineValueY & 1))
		{
			SpriteSet += 2;
		}

		int SpriteVal = (SineValueX * 12) / 24;
		SpriteVal = 11 - max(0, min(11, SpriteVal));
		SpriteVal += SpriteSet * 12;
		cFishSineWavesSpriteVal[SinIndex + 0] = cFishSineWavesSpriteVal[SinIndex + 256] = (unsigned char)SpriteVal;
	}

	for (int SinIndex = 0; SinIndex < 64; SinIndex++)
	{
		int SineValueY = FishSineWavesY[SinIndex];
		cFishSineWavesY[SinIndex + 0] =	cFishSineWavesY[SinIndex + 64] = (unsigned char)(SineValueY / 2);

	}

	WriteBinaryFile(OutputFishSineWavesXBIN, cFishSineWavesX, sizeof(cFishSineWavesX));
	WriteBinaryFile(OutputFishSineWavesSpriteValBIN, cFishSineWavesSpriteVal, sizeof(cFishSineWavesSpriteVal));
	WriteBinaryFile(OutputFishSineWavesYBIN, cFishSineWavesY, sizeof(cFishSineWavesY));


}

void GPLogo_UnrollScrolltext(LPCTSTR InputSCRDataISCR, LPCTSTR OutputUnrolledScrollTextBIN)
{
	unsigned char ISCRData[4096];
	ReadBinaryFile(InputSCRDataISCR, ISCRData, 4096);

	unsigned char UnrolledScrollText[4096];
	int SizeUnrolledScrollText = 0;

	bool bFinished = false;
	do
	{
		unsigned char CharValue = *ScrollText++;
		int OutWidth = 2;
		int LookupIndex = 0;

		if (CharValue == 0xff)
		{
			OutWidth = 1;
		}
		else if (CharValue == '!')
		{
			LookupIndex = 27 * 2;
		}
		else if (CharValue == '?')
		{
			LookupIndex = 28 * 2;
		}
		else if (CharValue == '.')
		{
			LookupIndex = 29 * 2;
		}
		else if (CharValue == ',')
		{
			LookupIndex = 30 * 2;
		}
		else if (CharValue == '"')
		{
			LookupIndex = 31 * 2;
		}
		else if (CharValue == '\'')
		{
			LookupIndex = 32 * 2;
		}
		else if ((CharValue >= '0') && (CharValue <= '9'))
		{
			LookupIndex = 33 * 2 + (CharValue - '0');
		}
		else if (CharValue == ' ')
		{
			LookupIndex = 0;
			OutWidth = 1;
		}
		else
		{
			LookupIndex = (CharValue & 31) * 2;
		}

		if (CharValue == 0xff)
		{
			UnrolledScrollText[SizeUnrolledScrollText++] = 0xff;
			bFinished = true;
		}
		else
		{
			UnrolledScrollText[SizeUnrolledScrollText++] = ISCRData[LookupIndex];
			UnrolledScrollText[SizeUnrolledScrollText++] = ISCRData[LookupIndex + 90];
			if (OutWidth == 2)
			{
				UnrolledScrollText[SizeUnrolledScrollText++] = ISCRData[LookupIndex + 1];
				UnrolledScrollText[SizeUnrolledScrollText++] = ISCRData[LookupIndex + 91];
			}
		}
	} while (!bFinished);

	WriteBinaryFile(OutputUnrolledScrollTextBIN, UnrolledScrollText, SizeUnrolledScrollText);
}

void GPLogo_InvertMap(LPCTSTR InputMAP, LPCTSTR OutputMAP)
{
	unsigned char MAPData[2048];
	int Size = ReadBinaryFile(InputMAP, MAPData, sizeof(MAPData));
	for (int Index = 0; Index < Size; Index++)
	{
		MAPData[Index] ^= 0xff;
	}
	WriteBinaryFile(OutputMAP, MAPData, Size);
}

int GPLogo_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\GPLogo");

	GPLogo_ConvertImage("..\\..\\Build\\Parts\\GPLogo\\Data\\Shine-GPBoat.png", L"..\\..\\Intermediate\\Built\\GPLogo\\Shine-GPBoat.kla");
	GPLogo_OutputColourPlotASM("..\\..\\Build\\Parts\\GPLogo\\Data\\Shine-GPBoat-GenesisMask.png", L"..\\..\\Intermediate\\Built\\GPLogo\\ColourPlot.asm");
	GPLogo_OutputFishSineWaves(L"..\\..\\Intermediate\\Built\\GPLogo\\FishSineWavesX.bin", L"..\\..\\Intermediate\\Built\\GPLogo\\FishSineWavesY.bin", L"..\\..\\Intermediate\\Built\\GPLogo\\FishSineWavesSpriteVal.bin");
	GPLogo_ConvertFishSprites("..\\..\\Build\\Parts\\GPLogo\\Data\\FishAnim2x2.png", L"..\\..\\Intermediate\\Built\\GPLogo\\FishAnim2x2.map");

	GPLogo_UnrollScrolltext(L"..\\..\\Build\\Parts\\GPLogo\\Data\\Ksubi-16x16-ALLCHARS.iscr", L"..\\..\\Intermediate\\Built\\GPLogo\\UnrolledScrollText.bin");
	GPLogo_InvertMap(L"..\\..\\Build\\Parts\\GPLogo\\Data\\Ksubi-16x16-ALLCHARS.imap", L"..\\..\\Intermediate\\Built\\GPLogo\\Ksubi-16x16-ALLCHARS-inverted.imap");

	return 0;
}
