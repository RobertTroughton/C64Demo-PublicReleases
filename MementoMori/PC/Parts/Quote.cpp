// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"


void Quote_ConvertImage(char* InImageFilename, LPTSTR OutIMAPFilename, LPTSTR OutISCRFilename)
{
	GPIMAGE Img(InImageFilename);
	int Width = Img.Width;
	int Height = Img.Height;
	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	unsigned char CharSet[256][8];
	ZeroMemory(CharSet, sizeof(CharSet));
	unsigned char ScreenData[25][40];
	ZeroMemory(ScreenData, sizeof(ScreenData));
	int NumChars = 0;

	for (int YChar = 0; YChar < CharHeight; YChar++)
	{
		for (int XChar = 0; XChar < CharWidth; XChar++)
		{
			unsigned char ThisChar[8];
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = YChar * 8 + YPixel;
				unsigned char ThisByte = 0;
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XChar * 8 + XPixel;
					unsigned int Col = Img.GetPixel(XPos, YPos);
					if (Col != 0x00000000)
					{
						ThisByte |= 1 << (7 - XPixel);
					}
				}
				ThisChar[YPixel] = ThisByte;
			}

			int FoundChar = -1;
			for (int Index = 0; Index < NumChars; Index++)
			{
				if (memcmp(ThisChar, CharSet[Index], 8) == 0)
				{
					FoundChar = Index;
					break;
				}
			}
			if (FoundChar == -1)
			{
				FoundChar = NumChars;
				NumChars++;

				memcpy(CharSet[FoundChar], ThisChar, 8);
			}
			ScreenData[YChar][XChar] = (unsigned char)FoundChar;
		}
	}
	WriteBinaryFile(OutIMAPFilename, CharSet, NumChars * 8);
	WriteBinaryFile(OutISCRFilename, ScreenData, 40 * 25);
}

int Quote_Main()
{
	Quote_ConvertImage("6502\\Parts\\Quote\\Data\\Quote.png", L"Out\\6502\\Parts\\Quote\\Quote.imap", L"Out\\6502\\Parts\\Quote\\Quote.iscr");

	return 0;
}
