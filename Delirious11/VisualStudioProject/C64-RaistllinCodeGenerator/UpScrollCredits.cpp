// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

#define FONT_HEIGHT 8
#define MAX_Y_PER_SPRITE (21 - FONT_HEIGHT)
#define MAX_Y_PER_SPRITE_PLUS1 (MAX_Y_PER_SPRITE + 1)


char ScrollText[] = {
	"DELIRIOUS 11"
	"-==========-"
	"            "
	"CODING:     "
	"    RAISTLIN"
	"            "
	"MUSIC:      "
	"         MCH"
	"            "
	"PRODUCTION: "
	"    RAISTLIN"
	"     HEDNING"
	"            "
	"SPINDLE, IRQ"
	"LOADER:     "
	"         LFT"
	"            "
	"DIR ART:    "
	"S!NK, DESIRE"
	"            "
	"            "
	"            "
	"BEDTIME     "
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"            "
	"            "
	"            "
	"FADE LOGOS  "
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"            "
	"            "
	"            "
	"CREDIT LOGOS"
	"------------"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"            "
	"HEADACHE    "
	"------------"
	"PIXELS:     "
	"     REDCRAB"
	"            "
	"            "
	"            "
	"CIRCLESCROLL"
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"SMALL FONT: "
	"     HEDNING"
	"            "
	"            "
	"            "
	"THE EYE     "
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"            "
	"            "
	"            "
	"HELIX SCROLL"
	"------------"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"            "
	"STAR GREETS "
	"------------"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"            "
	"WAVY PLANET "
	"------------"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"            "
	" UPSCROLLER "
	"------------"
	"FONT:       "
	"     REDCRAB"
	"            "
	"            "
	"            "
	"DIAGONAL    "
	"  SKULL PART"
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"            "
	"            "
	"            "
	"AND FINALLY,"
	"MANY  THANKS"
	" TO ALL THE "
	" PEOPLE WHO "
	"HELPED BRING"
	"THIS DEMO TO"
	"THE BREADBOX"
	" .......... "
	"     WE     "
	"    WILL    "
	"   RETURN   "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
	"            "
};
unsigned int ScrollTextNumLines = ((unsigned int)strlen(ScrollText)) / 12;

void UpScrollCredits_OutputScrollText(LPCTSTR OutputScrollTextFilename)
{
	unsigned char ScrollTextOutput[12][128];
	ZeroMemory(ScrollTextOutput, 12 * 128);
	for (unsigned int ScrollTextLine = 0; ScrollTextLine < ScrollTextNumLines; ScrollTextLine++)
	{
		for (unsigned int XPos = 0; XPos < 12; XPos++)
		{
			unsigned char Byte = ScrollText[ScrollTextLine * 12 + XPos];
			Byte = Byte & 63;
			ScrollTextOutput[XPos][ScrollTextLine] = Byte;
		}
	}
	ScrollTextOutput[0][ScrollTextNumLines] = 255;
	WriteBinaryFile(OutputScrollTextFilename, ScrollTextOutput, 12 * 128);
}

void UpScrollCredits_ReorderCharset(LPCTSTR InputFontFilename, LPCTSTR OutputFontFilename)
{
	static const int BMPBitmapDataOffset = 0x3e;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFontFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned char ReorderedFont[16][64];

	for (unsigned int YVal = 0; YVal < 16; YVal++)
	{
		for (unsigned int Char = 0; Char < 64; Char++)
		{
			ReorderedFont[YVal][Char] = 255 - FileReadBuffer[BMPBitmapDataOffset + (64 * (15 - YVal)) + Char];
		}
	}
	WriteBinaryFile(OutputFontFilename, ReorderedFont, 16 * 64);
}

void UpScrollCredits_OutputSinTables(LPCTSTR OutputSinTableFilename)
{
	int SinTable[256];
	GenerateSinTable(256, 0, (4 * MAX_Y_PER_SPRITE_PLUS1) - 1, 0, SinTable);

	unsigned char cSinTable[256 * 2];
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		int SinValue = SinTable[SinIndex];
		unsigned char ByteOffset = ((SinValue % MAX_Y_PER_SPRITE_PLUS1) * 3) + (SinValue / MAX_Y_PER_SPRITE_PLUS1) * 64;
		cSinTable[SinIndex + 256] = cSinTable[SinIndex] = ByteOffset;
	}
	WriteBinaryFile(OutputSinTableFilename, cSinTable, 256 * 2);
}
	
int UpScrollCredits_Main(void)
{
	UpScrollCredits_OutputSinTables(L"..\\..\\Intermediate\\Built\\UpScrollCredits-SinTable.bin");
	UpScrollCredits_ReorderCharset(L"..\\..\\SourceData\\1x2Font.bmp", L"..\\..\\Intermediate\\Built\\UpScrollCredits-2x2Font.bin");
	UpScrollCredits_OutputScrollText(L"..\\..\\Intermediate\\Built\\UpScrollCredits-ScrollText.bin");

	return 0;
}
