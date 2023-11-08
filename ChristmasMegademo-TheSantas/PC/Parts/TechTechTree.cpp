// (c) 2018-2020, Genesis*Project

#include "..\Common\Common.h"

void TTT_OutputSinTables(LPTSTR OutSinTablesBIN)
{
	static const int ScreenBank[6] =	{ 15,  7, 15, 15,  7, 15 };
	static const int BitmapBank[6] =	{  1,  0,  1,  1,  0,  1 };
	static const int BaseBank[6] =		{  0,  1,  1,  2,  3,  3 };

	unsigned char SinTables[6][128];

	for (int i = 0; i < 128; i++)
	{
		double Angle = ((i * 2.0 * PI) / 128.0);
		double SinVal = sin(Angle) * 24.0 + 24.0;

		unsigned char cSinVal = (unsigned char)SinVal;
		cSinVal = min(47, max(0, cSinVal));

		unsigned char cSinVal_Char = cSinVal / 8;
		unsigned char cSinVal_Pixel = cSinVal % 8;

		SinTables[0][i] = SinTables[1][i] = (ScreenBank[cSinVal_Char] * 16) | (BitmapBank[cSinVal_Char] * 8) | BaseBank[cSinVal_Char];
		SinTables[2][i] = SinTables[3][i] = cSinVal_Pixel + 0x18;

		double SinVal2 = sin(Angle) * 48.0 + 48.0;
		unsigned char cSinVal2 = (unsigned char)SinVal2;
		cSinVal2 = min(95, max(0, cSinVal2));

		int SpriteXStart = 184 - 96 - 48 + cSinVal2;
		unsigned int SpriteXMSB = 0;
		for (int j = 0; j < 8; j++)
		{
			int SpriteX = SpriteXStart + j * 24;
			if (SpriteX >= 256)
				SpriteXMSB |= (1 << j);
		}

		SinTables[4][i] = SpriteXStart;
		SinTables[5][i] = SpriteXMSB;
	}
	WriteBinaryFile(OutSinTablesBIN, SinTables, sizeof(SinTables));
}

void TTT_CompressBitmapData(LPTSTR InFilenameBitmapMAP, LPTSTR InFilenameBitmapSCR, LPTSTR OutFilenameBitmapMAP, LPTSTR OutFilenameBitmapSCR)
{
	unsigned char InBitmapMAP[25][40][8];
	unsigned char InBitmapSCR[25][40];
	ReadBinaryFile(InFilenameBitmapMAP, InBitmapMAP, sizeof(InBitmapMAP));
	ReadBinaryFile(InFilenameBitmapSCR, InBitmapSCR, sizeof(InBitmapSCR));

	unsigned char OutBitmapMAP[25][40][8];
	unsigned char OutBitmapSCR[25][40];
	memset(OutBitmapMAP, 0xff, sizeof(OutBitmapMAP));
	memset(OutBitmapSCR, 0xff, sizeof(OutBitmapSCR));

	for (int YChar = 0; YChar < 22; YChar++)
	{
		for (int XChar = 0; XChar < 27; XChar++)
		{
			int InXChar = XChar + 0; //; + 6
			int OutXChar = XChar + 9; //;
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				OutBitmapMAP[YChar][OutXChar][YPixel] =	InBitmapMAP[YChar][InXChar][YPixel];
				OutBitmapSCR[YChar][OutXChar] =			InBitmapSCR[YChar][InXChar];
			}
		}
	}

	WriteBinaryFile(OutFilenameBitmapMAP, OutBitmapMAP, sizeof(OutBitmapMAP));
	WriteBinaryFile(OutFilenameBitmapSCR, OutBitmapSCR, sizeof(OutBitmapSCR));
}


void TTT_ConvertSprites(char* InSpritesPNG, LPTSTR OutSpritesMAP)
{
//; nb. we output 3 rows of sprites .. but only output to rows 0 and 2
//; that way, we use bank+[0000,01ff] and bank+[0400,05ff] ... leaving the end parts of each screen clear such that we can use them as screens JUST for sprite data [03f8, 03ff]

	unsigned char OutSpriteData[3][8][64];
	ZeroMemory(OutSpriteData, sizeof(OutSpriteData));

	GPIMAGE ImgSprites(InSpritesPNG);
	for (int iYSprite = 0; iYSprite < 2; iYSprite++)
	{
		for (int iXSprite = 0; iXSprite < 8; iXSprite++)
		{
			for (int iYPixel = 0; iYPixel < 21; iYPixel++)
			{
				for (int iXChar = 0; iXChar < 3; iXChar++)
				{
					unsigned char OutByte = 0;
					for (int iXPixel = 0; iXPixel < 8; iXPixel += 2)
					{
						int iInXPos = iXSprite * 24 + iXChar * 8 + iXPixel;
						int iInYPos = iYSprite * 21 + iYPixel;
						unsigned char ColVal = ImgSprites.GetPixelPaletteColour(iInXPos, iInYPos);

						unsigned char OutBits = 0x00;
						int OutShift = 6 - iXPixel;
						if (ColVal == 0x0e)
							OutBits = 0x01;
						else if ((ColVal == 0x04) || (ColVal == 0x06))
							OutBits = 0x03;
						else if (ColVal == 0x01)
							OutBits = 0x02;

						OutByte |= (OutBits << OutShift);
					}
					OutSpriteData[iYSprite * 2][iXSprite][iYPixel * 3 + iXChar] = OutByte;
				}
			}
		}
	}

	WriteBinaryFile(OutSpritesMAP, OutSpriteData, sizeof(OutSpriteData));
}

int TechTechTree_Main()
{
	TTT_CompressBitmapData(L"6502\\Parts\\TechTechTree\\Data\\bitmap.map", L"6502\\Parts\\TechTechTree\\Data\\bitmap.scr", L"Out\\6502\\Parts\\TechTechTree\\Bitmap.map", L"Out\\6502\\Parts\\TechTechTree\\Bitmap.scr");
	TTT_OutputSinTables(L"Out\\6502\\Parts\\TechTechTree\\SinTables.bin");
	TTT_ConvertSprites("6502\\Parts\\TechTechTree\\Data\\sprites.png", L"Out\\6502\\Parts\\TechTechTree\\sprites.map");

	return 0;
}
