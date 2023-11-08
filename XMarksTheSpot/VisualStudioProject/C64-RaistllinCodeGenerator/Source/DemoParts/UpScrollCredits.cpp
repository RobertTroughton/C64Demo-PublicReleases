//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define FONT_HEIGHT 8
#define MAX_Y_PER_SPRITE (21 - FONT_HEIGHT)
#define MAX_Y_PER_SPRITE_PLUS1 (MAX_Y_PER_SPRITE + 1)


char USC_ScrollText[] = {
	"------------"
	"X MARKS     "
	"    THE SPOT"
	"------------"
	"            "
	"            "
	"BLACKBEARD  "
	"------------"
	"PIXELS:     "
	"       FACET"
	"            "
	"            "
	"GP WIDE LOGO"
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"       FACET"
	"            "
	"            "
	"CREDIT LOGOS"
	"------------"
	"PIXELS:     "
	"       FACET"
	"            "
	"            "
	"PARALLAX SEA"
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"LOGOS:      "
	"       FACET"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"CROWS NEST  "
	"------------"
	"CODE:       "
	"      SHADOW"
	"PIXELS:     "
	"     REDCRAB"
	"            "
	"            "
	"WAVY SCROLL "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"FONT:       "
	"     REDCRAB"
	"            "
	"            "
	"WAVY SNAKE  "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"       FACET"
	"            "
	"            "
	"LOBOKRAKEN  "
	"------------"
	"PIXELS:     "
	"       FACET"
	"            "
	"            "
	"PIRATE SHIP "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"SHIP:       "
	"     REDCRAB"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"THE WHEELS  "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"DEAD KRAKEN "
	"------------"
	"PIXELS:     "
	"   RAZORBACK"
	"            "
	"            "
	"SPINNY THING"
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"EYE SCROLLER"
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"       FACET"
	"FONT:       "
	"     HEDNING"
	"            "
	"            "
	"TREASURE MAP"
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"     REDCRAB"
	"            "
	"            "
	"X           "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"    RAISTLIN"
	"            "
	"            "
	"CAPTAIN HED "
	"------------"
	"PIXELS:     "
	"     REDCRAB"
	"            "
	"            "
	"END PART    "
	"------------"
	"CODE:       "
	"    RAISTLIN"
	"PIXELS:     "
	"   RAZORBACK"
	"FONT:       "
	"     HEDNING"
	"------------"
	"            "
	"            "
	"            "
	"       MUSIC"
	"------------"
	"            "
	"DANGER DAWG "
	"INTRO       "
	"            "
	"     STEEL &"
	"     STINSEN"
	"------------"
	"            "
	"PARTY       "
	"PIRATES     "
	"PART 1 AND 2"
	"            "
	"     STEEL &"
	"     STINSEN"
	"------------"
	"            "
	"TREASURE    "
	"       CHEST"
	"            "
	"         MCH"
	"------------"
	"            "
	"            "
	"SPINDLE     "
	"IRQ LOADER  "
	"         LFT"
	"            "
	"            "
	"DIR ART     "
	" S!NK/DESIRE"
	"            "
	"            "
	"COVER ART   "
	" DUCE/EXTEND"
	"            "
	"            "
	"WE HOPE THAT"
	"YOU  ENJOYED"
	" OUR LITTLE "
	" PRODUCTION "
	"            "
	"------------"
	"            "
	"     WE     "
	"    WILL    "
	"   RETURN   "
	"            "
};
#define NUM_CHARS_PER_LINE 12
#define SCROLL_TEXT_STRIDE 192
int USC_ScrollTextNumLines = min(256, (int)(strlen(USC_ScrollText) / NUM_CHARS_PER_LINE));
unsigned char USC_ScrollTextOutput[NUM_CHARS_PER_LINE][SCROLL_TEXT_STRIDE];

void UpScrollCredits_OutputScrollText(LPCTSTR OutputScrollTextFilename)
{
	ZeroMemory(USC_ScrollTextOutput, NUM_CHARS_PER_LINE * SCROLL_TEXT_STRIDE);
	for (int ScrollTextLine = 0; ScrollTextLine < USC_ScrollTextNumLines; ScrollTextLine++)
	{
		for (int XPos = 0; XPos < NUM_CHARS_PER_LINE; XPos++)
		{
			unsigned char Byte = USC_ScrollText[ScrollTextLine * NUM_CHARS_PER_LINE + XPos];
			Byte = Byte & 63;
			USC_ScrollTextOutput[XPos][ScrollTextLine] = Byte;
		}
	}
	USC_ScrollTextOutput[0][USC_ScrollTextNumLines] = 255;
	WriteBinaryFile(OutputScrollTextFilename, USC_ScrollTextOutput, NUM_CHARS_PER_LINE * SCROLL_TEXT_STRIDE);
}

void UpScrollCredits_ReorderCharsetBMP(LPCTSTR InputFontFilename, LPCTSTR OutputFontFilename)
{
	static const int BMPBitmapDataOffset = 0x3e;

	ReadBinaryFile(InputFontFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	unsigned char ReorderedFont[16][64];

	for (int YVal = 0; YVal < 16; YVal++)
	{
		for (int Char = 0; Char < 64; Char++)
		{
			ReorderedFont[YVal][Char] = 255 - FileReadBuffer[BMPBitmapDataOffset + (64 * (15 - YVal)) + Char];
		}
	}
	WriteBinaryFile(OutputFontFilename, ReorderedFont, 16 * 64);
}

void UpScrollCredits_ReorderCharsetBIN(LPCTSTR InputFontFilename, LPCTSTR OutputFontFilename)
{
	static const int HeaderSize = 0x02;

	ReadBinaryFile(InputFontFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	unsigned char ReorderedFont[16][64];

	for (int YVal = 0; YVal < 16; YVal++)
	{
		for (int Char = 0; Char < 64; Char++)
		{
			ReorderedFont[YVal][Char] = FileReadBuffer[HeaderSize + ((8 * 64) * (YVal / 8)) + Char * 8 + YVal % 8];
		}
	}
	WriteBinaryFile(OutputFontFilename, ReorderedFont, 16 * 64);
}

int UpScrollCredits_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\UpScrollCredits");

//	UpScrollCredits_ReorderCharsetBMP(L"..\\..\\SourceData\\UpScrollCredits\\1x2Font.bmp", L"..\\..\\Intermediate\\Built\\UpScrollCredits\\1x2Font.bin");
	UpScrollCredits_ReorderCharsetBIN(L"..\\..\\SourceData\\Fonts\\Apan-1x2.bin", L"..\\..\\Intermediate\\Built\\UpScrollCredits\\1x2Font.bin");
	UpScrollCredits_OutputScrollText(L"..\\..\\Intermediate\\Built\\UpScrollCredits\\ScrollText.bin");

	return 0;
}
