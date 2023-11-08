//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

void ScreenEffects_OutputSinTables()
{
	int ScreenClearSinTab[256];
	GenerateSinTable(256, 0, 14, 64, ScreenClearSinTab);

	unsigned char cScreenClearSinTab[128];

	for (int SinIndex = 0; SinIndex < 128; SinIndex++)
	{
		cScreenClearSinTab[SinIndex] = (unsigned char)ScreenClearSinTab[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\0-InitialScreenClear\\SinTable.bin", cScreenClearSinTab, 128);
}

int ScreenEffects_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\0-InitialScreenClear");

	ScreenEffects_OutputSinTables();
	return 0;
}
