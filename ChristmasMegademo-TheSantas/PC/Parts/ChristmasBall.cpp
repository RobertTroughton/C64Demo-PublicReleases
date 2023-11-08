// (c) 2018-2020, Genesis*Project

#include "..\Common\Common.h"

void CB_OutputTopSpriteSinTables(LPTSTR OutSinTablesBIN)
{
	unsigned char SinTables[4][256];

	double UnscaledSinTable[2][256];
	double MinVal[2] = {INT_MAX, INT_MAX};
	double MaxVal[2] = {INT_MIN, INT_MIN};
	for (int Index = 0; Index < 256; Index++)
	{
		double AngleA0 = 0.00 + ((Index * 2.0 * PI * 4.0) / 256.0);
		double AngleA1 = 0.43 - ((Index * 2.0 * PI * 3.0) / 256.0);
		double AngleA2 = 1.22 + ((Index * 2.0 * PI * 2.0) / 256.0);
		double SinValA = sin(AngleA0) * 700.0 + sin(AngleA1) * 500.0 + sin(AngleA2) * 350.0;

		UnscaledSinTable[0][Index] = SinValA;
		MinVal[0] = min(MinVal[0], SinValA);
		MaxVal[0] = max(MaxVal[0], SinValA);
	
		double AngleB0 = 0.33 + ((Index * 2.0 * PI * 3.0) / 256.0);
		double AngleB1 = 2.12 - ((Index * 2.0 * PI * 5.0) / 256.0);
		double AngleB2 = 5.78 + ((Index * 2.0 * PI * 1.0) / 256.0);
		double SinValB = sin(AngleB0) * 732.0 + sin(AngleB1) * 610.0 + sin(AngleB2) * 350.0;

		UnscaledSinTable[1][Index] = SinValB;
		MinVal[1] = min(MinVal[1], SinValB);
		MaxVal[1] = max(MaxVal[1], SinValB);
	}

	double SinMidA = (MaxVal[0] + MinVal[0]) / 2.0;
	double SinWidA = (MaxVal[0] - MinVal[0]);
	double SinMidB = (MaxVal[1] + MinVal[1]) / 2.0;
	double SinWidB = (MaxVal[1] - MinVal[1]);

	double SpritesWidthA = 28.0 * 5.0 + 24.0;
	double SpritesWidthB = 28.0 * 2.0 + 24.0;
	double ScaleA = (320.0 - SpritesWidthA) / SinWidA;
	double ScaleB = (320.0 - SpritesWidthB) / SinWidB;
	double CentreSpriteXA = 160.0 + 24.0 - (SpritesWidthA / 2.0);
	double CentreSpriteXB = 160.0 + 24.0 - (SpritesWidthB / 2.0);

	int MinX = 24 + 2;
	int MaxXA = 344 - 2 - (int)SpritesWidthA;
	int MaxXB = 344 - 2 - (int)SpritesWidthB;

	for (int Index = 0; Index < 256; Index++)
	{
		double SinValA = (UnscaledSinTable[0][Index] - SinMidA) * ScaleA + CentreSpriteXA;
		double SinValB = (UnscaledSinTable[1][Index] - SinMidB) * ScaleB + CentreSpriteXB;
		int iSinValA = min(max(MinX, (int)SinValA), MaxXA);
		int iSinValB = min(max(MinX, (int)SinValB), MaxXB);

		unsigned char XMSBA = 0;
		for (int SpriteIndex = 0; SpriteIndex < 6; SpriteIndex++)
		{
			int SpriteXA = iSinValA + (SpriteIndex * 28);
			if (SpriteXA >= 256)
				XMSBA |= 1 << SpriteIndex;
		}

		unsigned char XMSBB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 3; SpriteIndex++)
		{
			int SpriteXB = iSinValB + (SpriteIndex * 28);
			if (SpriteXB >= 256)
				XMSBB |= 1 << SpriteIndex;
		}

		SinTables[0][Index] = (unsigned char)(iSinValA & 255);
		SinTables[1][Index] = XMSBA;

		SinTables[2][Index] = (unsigned char)(iSinValB & 255);
		SinTables[3][Index] = XMSBB;
	}

	WriteBinaryFile(OutSinTablesBIN, SinTables, sizeof(SinTables));
}

void CB_OutputBottomSpriteSinTables(LPTSTR OutSinTablesBIN)
{
	unsigned char SinTables[4][256];

	unsigned int TempSinTable[256];
	for (int Index = 0; Index < 256; Index++)
	{
		double Angle = (Index * 2.0 * PI * 2.0) / 256.0;
		double SinVal = sin(Angle) * 106.0 + 184.0 - 54.0;

		TempSinTable[Index] = (unsigned int)max(0, (int)SinVal);
	}

	for (int Index = 0; Index < 256; Index++)
	{
		unsigned int Sprite0X = TempSinTable[Index];
		unsigned int Sprite1X = Sprite0X + 0x1C;
		unsigned int Sprite2X = Sprite1X + 0x1C;
		unsigned int Sprite3X = Sprite2X + 0x1C;

		unsigned char XMSB = ((Sprite0X / 256) * 1) + ((Sprite1X / 256) * 2) + ((Sprite2X / 256) * 4) + ((Sprite3X / 256) * 8);

		SinTables[0][Index] = (unsigned char)Sprite0X;
		SinTables[1][Index] = XMSB;
	}

	for (int Index = 0; Index < 256; Index++)
	{
		double Angle = (Index * 2.0 * PI * 2.0) / 256.0;
		double SinVal = (sin(Angle + PI) * 58.0) + 184.0 - 102.0;

		unsigned int Sprite4X = (unsigned int)SinVal;
		unsigned int Sprite5X = Sprite4X + 0x34;
		unsigned int Sprite6X = Sprite5X + 0x34;
		unsigned int Sprite7X = Sprite6X + 0x34;
		
		unsigned char XMSB = ((Sprite4X / 256) * 16) + ((Sprite5X / 256) * 32) + ((Sprite6X / 256) * 64) + ((Sprite7X / 256) * 128);

		SinTables[2][Index] = (unsigned char)Sprite4X;
		SinTables[3][Index] = XMSB;
	}
	WriteBinaryFile(OutSinTablesBIN, SinTables, sizeof(SinTables));
}

void CB_ProcessSprites(LPTSTR OutBlitSpriteASM)
{
	static const int NumFrames = 96;
	static const int NumSpritesX = 4;
	static const int NumSpritesY = 4;

	unsigned char SpriteData[NumFrames][NumSpritesY][NumSpritesX][64];
	ZeroMemory(SpriteData, sizeof(SpriteData));

	for (int iFrame = 0; iFrame < NumFrames; iFrame++)
	{
		char InSpriteFilename[256];
		sprintf_s(InSpriteFilename, 256, "6502\\Parts\\ChristmasBall\\Data\\FlipDisk\\sized\\moose_%d.png", iFrame + 1);
		GPIMAGE SpriteImg(InSpriteFilename);
		for (int iYSprite = 0; iYSprite < NumSpritesY; iYSprite++)
		{
			for (int iXSprite = 0; iXSprite < NumSpritesX; iXSprite++)
			{
				for (int iYPixel = 0; iYPixel < 21; iYPixel++)
				{
					int iInYPos = iYSprite * 21 + iYPixel;
					for (int iXChar = 0; iXChar < 3; iXChar++)
					{
						int iOutByte = iYPixel * 3 + iXChar;
						for (int iXPixel = 0; iXPixel < 8; iXPixel++)
						{
							int iInXPos = iXSprite * 24 + iXChar * 8 + iXPixel;

							if (SpriteImg.GetPixelPaletteColour(iInXPos, iInYPos) != 0)
							{
								SpriteData[iFrame][iYSprite][iXSprite][iOutByte] |= (1 << (7 - iXPixel));
							}
						}
					}
				}
			}
		}
	}

	unsigned char SpriteDifferences[NumFrames][2048];
	ZeroMemory(SpriteDifferences, sizeof(SpriteDifferences));

	int SpriteDifferences_Len[NumFrames];
	ZeroMemory(SpriteDifferences_Len, sizeof(SpriteDifferences_Len));

	for (int iFrame = 0; iFrame < NumFrames; iFrame++)
	{
		int iLastFrame = (iFrame + NumFrames - 1) % NumFrames;

		int iDataOffset = 0;

		for (int iYSprite = 0; iYSprite < NumSpritesY; iYSprite++)
		{
			for (int iXSprite = 0; iXSprite < NumSpritesX; iXSprite++)
			{
				for (int iByte = 0; iByte < 63; iByte++)
				{
					unsigned char ByteThisFrame = SpriteData[iFrame][iYSprite][iXSprite][iByte];
					unsigned char ByteLastFrame = SpriteData[iLastFrame][iYSprite][iXSprite][iByte];
					if (ByteThisFrame != ByteLastFrame)
					{
						int ByteOffset = ((iYSprite * NumSpritesX) + iXSprite) * 64 + iByte;
						SpriteDifferences[iFrame][iDataOffset++] = ByteOffset;
						SpriteDifferences[iFrame][iDataOffset++] = ByteThisFrame;
					}
				}
			}
			SpriteDifferences[iFrame][iDataOffset++] = 255;
		}
		SpriteDifferences_Len[iFrame] = iDataOffset;
	}

	CodeGen Code(OutBlitSpriteASM);

	Code.OutputCodeLine(NONE, fmt::format(".align 256"));
	Code.OutputBlankLine();

	Code.OutputFunctionLine(fmt::format("AnimFramePtrsLo"));
	for (int iFrame = 0; iFrame < NumFrames; iFrame+=4)
	{
		Code.OutputCodeLine(NONE, fmt::format(".byte <AnimFrame_{:02d}, <AnimFrame_{:02d}, <AnimFrame_{:02d}, <AnimFrame_{:02d}", iFrame + 0, iFrame + 1, iFrame + 2, iFrame + 3));
	}
	Code.OutputBlankLine();

	Code.OutputFunctionLine(fmt::format("AnimFramePtrsHi"));
	for (int iFrame = 0; iFrame < NumFrames; iFrame+=4)
	{
		Code.OutputCodeLine(NONE, fmt::format(".byte >AnimFrame_{:02d}, >AnimFrame_{:02d}, >AnimFrame_{:02d}, >AnimFrame_{:02d}", iFrame + 0, iFrame + 1, iFrame + 2, iFrame + 3));
	}
	Code.OutputBlankLine();

	int MemOffset = 0;
	Code.OutputCodeLine(NONE, fmt::format(".align 256"));
	for (int iFrame = 0; iFrame < NumFrames; iFrame++)
	{
		int EndMem = MemOffset + SpriteDifferences_Len[iFrame] - 1;
		if ((MemOffset / 256) != (EndMem / 256))
		{
			MemOffset = 0;
			Code.OutputCodeLine(NONE, fmt::format(".align 256"));
			Code.OutputBlankLine();
		}
		Code.OutputFunctionLine(fmt::format("AnimFrame_{:02d}", iFrame));
		Code.OutputByteBlock(SpriteDifferences[iFrame], SpriteDifferences_Len[iFrame]);
		Code.OutputBlankLine();
		MemOffset += SpriteDifferences_Len[iFrame];
	}
}

unsigned char ColFadeTable[16][6] =
{
	{ 0,  0,  0,  0,  0,  0},	//;  00
	{13,  3, 12,  4,  2,  9},	//;  01
	{ 9,  0,  0,  0,  0,  0},	//;  02
	{12,  4,  2,  9,  0,  0},	//;  03
	{ 2,  9,  0,  0,  0,  0},	//;  04
	{ 8,  2,  9,  0,  0,  0},	//;  05
	{ 0,  0,  0,  0,  0,  0},	//;  06
	{15,  5,  8,  2,  9,  0},	//;  07
	{ 2,  9,  0,  0,  0,  0},	//;  08
	{ 0,  0,  0,  0,  0,  0},	//;  09
	{ 8,  2,  9,  0,  0,  0},	//;  0a
	{ 9,  0,  0,  0,  0,  0},	//;  0b
	{ 4,  2,  9,  0,  0,  0},	//;  0c
	{ 3, 12,  4,  2,  9,  0},	//;  0d
	{ 4,  2,  9,  0,  0,  0},	//;  0e
	{ 5,  8,  2,  9,  0,  0},	//;  0f
};

void CB_CreateColourFadeTables(LPTSTR OutColourFadesBIN)
{
	unsigned char ColourFadeTables[6][16];

	for (int Table = 0; Table < 6; Table++)
	{
		for (int Col = 0; Col < 16; Col++)
		{
			unsigned char OutCol = ColFadeTable[Col][Table];
			ColourFadeTables[Table][Col] = OutCol;
		}
	}
	WriteBinaryFile(OutColourFadesBIN, ColourFadeTables, sizeof(ColourFadeTables));
}

int ChristmasBall_Main()
{
	CB_OutputTopSpriteSinTables(L"Out\\6502\\Parts\\ChristmasBall\\TopSinTables.bin");

	CB_OutputBottomSpriteSinTables(L"Out\\6502\\Parts\\ChristmasBall\\BottomSinTables.bin");

	CB_ProcessSprites(L"Out\\6502\\Parts\\ChristmasBall\\BlitSprite.asm");

	CB_CreateColourFadeTables(L"Out\\6502\\Parts\\ChristmasBall\\ColourFades.bin");

	return 0;
}
