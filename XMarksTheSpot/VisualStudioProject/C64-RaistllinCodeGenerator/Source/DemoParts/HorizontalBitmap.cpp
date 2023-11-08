//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"


#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define SCREEN_CHAR_WIDTH (SCREEN_WIDTH / 8)
#define SCREEN_CHAR_HEIGHT (SCREEN_HEIGHT / 8)

#define BITMAP_SCREENS_WIDE 4
#define BITMAP_SCREENS_HIGH 1
#define BITMAP_WIDTH (SCREEN_WIDTH * BITMAP_SCREENS_WIDE)
#define BITMAP_HEIGHT (SCREEN_HEIGHT * BITMAP_SCREENS_HIGH)
#define BITMAP_CHAR_WIDTH (BITMAP_WIDTH / 8)
#define BITMAP_CHAR_HEIGHT (BITMAP_HEIGHT / 8)

#define INITIAL_BITMAP_WIDTH SCREEN_WIDTH
#define INITIAL_BITMAP_HEIGHT SCREEN_HEIGHT
#define INITIAL_BITMAP_CHAR_WIDTH (INITIAL_BITMAP_WIDTH / 8)
#define INITIAL_BITMAP_CHAR_HEIGHT (INITIAL_BITMAP_HEIGHT / 8)

#define SCROLL_CHAR_XSTART (SCREEN_CHAR_WIDTH - 1)
#define SCROLL_CHAR_XEND (160 - 6) //; we chop off the last 6 - because we can't (currently) fit more :-(
#define SCROLL_CHAR_WIDTH (SCROLL_CHAR_XEND - SCROLL_CHAR_XSTART)

static unsigned char HORIZ_SourceBitmapData[BITMAP_CHAR_HEIGHT][BITMAP_CHAR_WIDTH][8];
static unsigned char HORIZ_SourceScreenData[BITMAP_CHAR_HEIGHT][BITMAP_CHAR_WIDTH];
static unsigned char HORIZ_SourceColourData[BITMAP_CHAR_HEIGHT][BITMAP_CHAR_WIDTH];

static unsigned char HORIZ_InitialBitmapData[SCREEN_CHAR_HEIGHT][SCREEN_CHAR_WIDTH][8];
static unsigned char HORIZ_InitialScreenData[SCREEN_CHAR_HEIGHT][SCREEN_CHAR_WIDTH];
static unsigned char HORIZ_InitialColourData[SCREEN_CHAR_HEIGHT][SCREEN_CHAR_WIDTH];

static unsigned char HORIZ_ScrollBitmapData[BITMAP_HEIGHT][SCROLL_CHAR_WIDTH];
static unsigned char HORIZ_ScrollScreenData[BITMAP_CHAR_HEIGHT][SCROLL_CHAR_WIDTH];
static unsigned char HORIZ_ScrollColourData[BITMAP_CHAR_HEIGHT][SCROLL_CHAR_WIDTH];

void HorizontalBitmap_OutputBitmapData(void)
{
	ReadBinaryFile(L"..\\..\\SourceData\\HorizontalBitmap\\4ScreenStitch.map", HORIZ_SourceBitmapData, BITMAP_CHAR_HEIGHT * BITMAP_CHAR_WIDTH * 8);
	ReadBinaryFile(L"..\\..\\SourceData\\HorizontalBitmap\\4ScreenStitch.scr", HORIZ_SourceScreenData, BITMAP_CHAR_HEIGHT * BITMAP_CHAR_WIDTH);
	ReadBinaryFile(L"..\\..\\SourceData\\HorizontalBitmap\\4ScreenStitch.col", HORIZ_SourceColourData, BITMAP_CHAR_HEIGHT * BITMAP_CHAR_WIDTH);

	//; Initial Bitmap
	for (int CharY = 0; CharY < INITIAL_BITMAP_CHAR_HEIGHT; CharY++)
	{
		for (int CharX = 0; CharX < INITIAL_BITMAP_CHAR_WIDTH; CharX++)
		{
			for (int PixelY = 0; PixelY < 8; PixelY++)
			{
				HORIZ_InitialBitmapData[CharY][CharX][PixelY] = HORIZ_SourceBitmapData[CharY][CharX][PixelY];
			}
			HORIZ_InitialScreenData[CharY][CharX] = HORIZ_SourceScreenData[CharY][CharX];
			HORIZ_InitialColourData[CharY][CharX] = HORIZ_SourceColourData[CharY][CharX];
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-InitialData.map", HORIZ_InitialBitmapData, SCREEN_CHAR_HEIGHT * SCREEN_CHAR_WIDTH * 8);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-InitialData.scr", HORIZ_InitialScreenData, SCREEN_CHAR_HEIGHT * SCREEN_CHAR_WIDTH);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-InitialData.col", HORIZ_InitialColourData, SCREEN_CHAR_HEIGHT * SCREEN_CHAR_WIDTH);

	//; Scrolling Bitmap
	for (int CharY = 0; CharY < BITMAP_CHAR_HEIGHT; CharY++)
	{
		for (int CharX = 0; CharX < SCROLL_CHAR_WIDTH; CharX++)
		{
			bool bLast = (CharX == (SCROLL_CHAR_WIDTH - 1));
			for (int PixelY = 0; PixelY < 8; PixelY++)
			{
				unsigned char OutputDataValue = bLast ? 0xff : HORIZ_SourceBitmapData[CharY][CharX + SCROLL_CHAR_XSTART][PixelY];
				HORIZ_ScrollBitmapData[(CharY * 8) + PixelY][CharX] = OutputDataValue;
			}
			unsigned char OutputScreenValue = bLast ? 0x11 : HORIZ_SourceScreenData[CharY][CharX + SCROLL_CHAR_XSTART];
			HORIZ_ScrollScreenData[CharY][CharX] = OutputScreenValue;

			unsigned char OutputColourValue = bLast ? 0x11 : HORIZ_SourceColourData[CharY][CharX + SCROLL_CHAR_XSTART];
			HORIZ_ScrollColourData[CharY][CharX] = OutputColourValue;
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-ScrollingData.map", HORIZ_ScrollBitmapData, BITMAP_HEIGHT * SCROLL_CHAR_WIDTH);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-ScrollingData.scr", HORIZ_ScrollScreenData, BITMAP_CHAR_HEIGHT * SCROLL_CHAR_WIDTH);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Bitmap-ScrollingData.col", HORIZ_ScrollColourData, BITMAP_CHAR_HEIGHT * SCROLL_CHAR_WIDTH);
}

#define NUM_SPRITES 2

void HorizontalBitmap_OutputSprites(LPCTSTR OutputSpriteDataFilename, LPCTSTR OutputSpriteXMSBData)
{
	unsigned char SpriteData[NUM_SPRITES][64];
	ZeroMemory(SpriteData, NUM_SPRITES * 64);
	unsigned char SpriteRAWData[21][24 * NUM_SPRITES];
	ZeroMemory(SpriteRAWData, 24 * NUM_SPRITES * 21);

	for (int y = 0; y < 21; y++)
	{
		double angle = (2 * PI * y) / 21;
		double XPos = sin(angle) * 5.7 + 6.0;
		int iPos = (int)(min(11.0, max(XPos, 0)));
		for (int x = 0; x < 24; x++)
		{
			int LeftShift = 7 - (x & 7);
			int OutputOffset = (y * 3) + x / 8;

			if (x >= iPos)
			{
				SpriteData[0][OutputOffset] |= 1 << LeftShift;
				SpriteRAWData[y][0 * 24 + x] = 255;
			}
		}
		SpriteData[1][y * 3 + 0] = SpriteData[1][y * 3 + 1] = SpriteData[1][y * 3 + 2] = 255;
		SpriteRAWData[y][1 * 24 + 0] = SpriteRAWData[y][1 * 24 + 1] = SpriteRAWData[y][1 * 24 + 2] = 255;
	}
	WriteBinaryFile(OutputSpriteDataFilename, SpriteData, NUM_SPRITES * 64);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Sprites.raw", SpriteRAWData, 24 * NUM_SPRITES * 21);

	unsigned char SpriteXMSBData[3][256];
	for (int Index = 0; Index < 256; Index++)
	{
		int XPos = Index * 2;
		if (XPos > 344)
		{
			XPos = 344;
		}
		unsigned char XMSB = 0;
		unsigned char SpriteEnable = 0;
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			int SpriteXPos = XPos + SpriteIndex * 48;
			if (SpriteIndex > 0)
			{
				SpriteXPos -= 24; // take account of that Sprite0 is only 24 pixels wide
			}

			if (SpriteXPos >= 256)
			{
				XMSB |= 1 << SpriteIndex;
			}

			if (SpriteXPos < 344)
			{
				SpriteEnable |= 1 << SpriteIndex;
			}
		}
		SpriteXMSBData[0][Index] = (unsigned char)XPos;
		SpriteXMSBData[1][Index] = XMSB;
		SpriteXMSBData[2][Index] = SpriteEnable;
	}

	WriteBinaryFile(OutputSpriteXMSBData, SpriteXMSBData, 3 * 256);
}

int HorizontalBitmap_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\HorizontalBitmap");

	HorizontalBitmap_OutputBitmapData();
	HorizontalBitmap_OutputSprites(L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Sprites.bin", L"..\\..\\Intermediate\\Built\\HorizontalBitmap\\Sprite-XMSBEnable.bin");

	return 0;
}
