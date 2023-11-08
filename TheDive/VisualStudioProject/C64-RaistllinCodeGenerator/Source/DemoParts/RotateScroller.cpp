//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\CodeGen.h"

void RotateScroller_OutputFont(LPCTSTR OutputFontFilename)
{
	unsigned char Charset[256][8];
	for (int CharIndex = 0; CharIndex < 256; CharIndex++)
	{
		Charset[CharIndex][0] = ((CharIndex & 1) == 0) ? 0 : 255;
		Charset[CharIndex][1] = ((CharIndex & 2) == 0) ? 0 : 255;
		Charset[CharIndex][2] = ((CharIndex & 4) == 0) ? 0 : 255;
		Charset[CharIndex][3] = ((CharIndex & 8) == 0) ? 0 : 255;
		Charset[CharIndex][4] = ((CharIndex & 16) == 0) ? 0 : 255;
		Charset[CharIndex][5] = ((CharIndex & 32) == 0) ? 0 : 255;
		Charset[CharIndex][6] = ((CharIndex & 64) == 0) ? 0 : 255;
		Charset[CharIndex][7] = ((CharIndex & 128) == 0) ? 0 : 255;
	}

	WriteBinaryFile(OutputFontFilename, Charset, sizeof(Charset));
}


int RotateScroller_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\RotateScroller");

	RotateScroller_OutputFont(L"..\\..\\Intermediate\\Built\\RotateScroller\\Font.bin");

	return 0;
}

