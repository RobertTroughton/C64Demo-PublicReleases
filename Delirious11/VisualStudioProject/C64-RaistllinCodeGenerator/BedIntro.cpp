// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

int BedIntro_Main()
{
	Output_BMPBitmapToSpriteData(L"..\\..\\SourceData\\0000-BEDINTRO-spritenumbers.bmp", L"..\\..\\Intermediate\\Built\\0000-BEDINTRO-spritenumbers.bin", 20, false);
	Output_BMPBitmapToSpriteData(L"..\\..\\SourceData\\0000-BEDINTRO-spriteanims.bmp", L"..\\..\\Intermediate\\Built\\0000-BEDINTRO-spriteanims.bin", 9, false);

	int SinTable[128];
	GenerateSinTable(128, 0, 13, 32, SinTable);
	unsigned char cSinTable[64];
	for (unsigned int SinIndex = 0; SinIndex < 32; SinIndex++)
	{
		cSinTable[SinIndex] = (unsigned char)SinTable[SinIndex];
		cSinTable[SinIndex + 32] = (unsigned char)SinTable[31 - SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\0000-BEDINTRO-AlarmClock-SinTable.bin", cSinTable, 64);

	return 0;
}
