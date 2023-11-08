//; (c)2018, Raistlin / Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define MYPI 3.1415

//; Sprite Positions:-
#define NUM_SPRITES 23

void ScreenHashChars_OutputChars(LPCTSTR CharTableFilename, LPCTSTR ScreenTableFilename)
{
	unsigned char CharTable[256][8];
	ZeroMemory(CharTable, 256 * 8);

	unsigned char BitRemap8[8][8] = {
		{ 0x00, 0x01, 0x01, 0x11, 0x15, 0x15, 0x55, 0x55 },
		{ 0x00, 0x00, 0x40, 0x40, 0x44, 0x45, 0x45, 0x55 },

		{ 0x00, 0x10, 0x10, 0x11, 0x11, 0x51, 0x51, 0x55 },
		{ 0x00, 0x00, 0x40, 0x50, 0x50, 0x51, 0x55, 0x55 },

		{ 0x00, 0x00, 0x04, 0x04, 0x05, 0x45, 0x45, 0x55 },
		{ 0x00, 0x40, 0x40, 0x44, 0x44, 0x54, 0x55, 0x55 },

		{ 0x00, 0x00, 0x10, 0x11, 0x11, 0x51, 0x51, 0x55 },
		{ 0x00, 0x04, 0x44, 0x44, 0x45, 0x45, 0x55, 0x55 },
	};
	for (int XValue = 0; XValue < 8; XValue++)
	{
		for (int YValue = 0; YValue < 8; YValue++)
		{
			int CharIndex = YValue * 8 + XValue + 0;

			unsigned char CharValXY0 = (BitRemap8[0][XValue] * 1) | (BitRemap8[0][YValue] * 2);
			unsigned char CharValXY1 = (BitRemap8[1][XValue] * 1) | (BitRemap8[1][YValue] * 2);
			unsigned char CharValXY2 = (BitRemap8[2][XValue] * 1) | (BitRemap8[2][YValue] * 2);
			unsigned char CharValXY3 = (BitRemap8[3][XValue] * 1) | (BitRemap8[3][YValue] * 2);
			unsigned char CharValXY4 = (BitRemap8[4][XValue] * 1) | (BitRemap8[4][YValue] * 2);
			unsigned char CharValXY5 = (BitRemap8[5][XValue] * 1) | (BitRemap8[5][YValue] * 2);
			unsigned char CharValXY6 = (BitRemap8[6][XValue] * 1) | (BitRemap8[6][YValue] * 2);
			unsigned char CharValXY7 = (BitRemap8[7][XValue] * 1) | (BitRemap8[7][YValue] * 2);

			CharTable[CharIndex][0] = CharValXY0;
			CharTable[CharIndex][1] = CharValXY1;
			CharTable[CharIndex][2] = CharValXY2;
			CharTable[CharIndex][3] = CharValXY3;
			CharTable[CharIndex][4] = CharValXY4;
			CharTable[CharIndex][5] = CharValXY5;
			CharTable[CharIndex][6] = CharValXY6;
			CharTable[CharIndex][7] = CharValXY7;
		}
	}

	unsigned char BitZRemap[8][8] = {
		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
		{ 0x7e, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7e },
		{ 0x3c, 0x7e, 0xff, 0xff, 0xff, 0xff, 0x7e, 0x3c },
		{ 0x18, 0x3c, 0x7e, 0xff, 0xff, 0x7e, 0x3c, 0x18 },
		{ 0x00, 0x18, 0x3c, 0x7e, 0x7e, 0x3c, 0x18, 0x00 },
		{ 0x00, 0x00, 0x18, 0x3c, 0x3c, 0x18, 0x00, 0x00 },
		{ 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00 },
		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
	};

	for (int XValue = 0; XValue < 8; XValue++)
	{
		int CharIndex = XValue + 248;

		CharTable[CharIndex][0] = BitZRemap[XValue][0];
		CharTable[CharIndex][1] = BitZRemap[XValue][1];
		CharTable[CharIndex][2] = BitZRemap[XValue][2];
		CharTable[CharIndex][3] = BitZRemap[XValue][3];
		CharTable[CharIndex][4] = BitZRemap[XValue][4];
		CharTable[CharIndex][5] = BitZRemap[XValue][5];
		CharTable[CharIndex][6] = BitZRemap[XValue][6];
		CharTable[CharIndex][7] = BitZRemap[XValue][7];
	}

	WriteBinaryFile(CharTableFilename, CharTable, 256 * 8);
}

void ScreenHashChars_OutputSinTable(LPCTSTR SinTableFilename)
{
	int SinTable[256];
	GenerateSinTable(256, 0, 8, 0, SinTable);

	unsigned char cSinTable[6 * 256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		int SinValue = max(0, min(7, SinTable[SinIndex]));
		cSinTable[SinIndex + (0 * 256)] = cSinTable[SinIndex + (1 * 256)] = (unsigned char)(SinValue *  1);
		cSinTable[SinIndex + (2 * 256)] = cSinTable[SinIndex + (3 * 256)] = (unsigned char)(SinValue *  8);
		cSinTable[SinIndex + (4 * 256)] = cSinTable[SinIndex + (5 * 256)] = (unsigned char)(SinValue *  1 + 248);
	}
	WriteBinaryFile(SinTableFilename, cSinTable, 6 * 256);
}

int ScreenHashChars_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\ScreenHash");

	ScreenHashChars_OutputChars(L"..\\..\\Intermediate\\Built\\ScreenHash\\Chars.bin", L"..\\..\\Intermediate\\Built\\ScreenHash\\Screen.bin");
	ScreenHashChars_OutputSinTable(L"..\\..\\Intermediate\\Built\\ScreenHash\\SinTable.bin");

	return 0;
}

