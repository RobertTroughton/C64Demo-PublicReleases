//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

//; Bitmap Stuff
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define SCREEN_CHAR_WIDTH (SCREEN_WIDTH / 8)
#define SCREEN_CHAR_HEIGHT (SCREEN_HEIGHT / 8)

#define BITMAP_SCREENS_WIDE 1
#define BITMAP_SCREENS_HIGH 3
#define BITMAP_WIDTH (SCREEN_WIDTH * BITMAP_SCREENS_WIDE)
#define BITMAP_HEIGHT (SCREEN_HEIGHT * BITMAP_SCREENS_HIGH)
#define BITMAP_CHAR_WIDTH (BITMAP_WIDTH / 8)
#define BITMAP_CHAR_HEIGHT (BITMAP_HEIGHT / 8)

#define INITIAL_BITMAP_WIDTH SCREEN_WIDTH
#define INITIAL_BITMAP_HEIGHT SCREEN_HEIGHT
#define INITIAL_BITMAP_CHAR_WIDTH (INITIAL_BITMAP_WIDTH / 8)
#define INITIAL_BITMAP_CHAR_HEIGHT (INITIAL_BITMAP_HEIGHT / 8)

#define INITIAL_CHAR_YSTART (BITMAP_CHAR_HEIGHT - SCREEN_CHAR_HEIGHT)
#define INITIAL_CHAR_END (BITMAP_CHAR_HEIGHT)
#define INITIAL_CHAR_HEIGHT (SCREEN_CHAR_HEIGHT)

#define SCROLL_CHAR_YSTART (0)
#define SCROLL_CHAR_YEND (INITIAL_CHAR_YSTART)
#define SCROLL_CHAR_HEIGHT (SCROLL_CHAR_YEND - SCROLL_CHAR_YSTART)
#define SCROLL_BITMAPDATA_SIZE (BITMAP_CHAR_WIDTH * 8 * SCROLL_CHAR_HEIGHT)
#define SCROLL_SCREENDATA_SIZE (BITMAP_CHAR_WIDTH * SCROLL_CHAR_HEIGHT)

static unsigned char TREASURE_SourceBitmapData[BITMAP_CHAR_HEIGHT][BITMAP_CHAR_WIDTH][8];
static unsigned char TREASURE_SourceScreenData[BITMAP_CHAR_HEIGHT][BITMAP_CHAR_WIDTH];

static unsigned char TREASURE_InitialBitmapData[SCREEN_CHAR_HEIGHT][SCREEN_CHAR_WIDTH][8];
static unsigned char TREASURE_InitialScreenData[SCREEN_CHAR_HEIGHT][SCREEN_CHAR_WIDTH];

static unsigned char TREASURE_ScrollBitmapData[BITMAP_CHAR_WIDTH][8][SCROLL_CHAR_HEIGHT];
static unsigned char TREASURE_ScrollScreenData[BITMAP_CHAR_WIDTH][SCROLL_CHAR_HEIGHT];

//; Path Stuff
int MarkOffsets[5][2] =
{
	{1, 0},
	{0, 1},
	{1, 1},
	{2, 1},
	{1, 2}
};

#define MAX_PATH_POINTS 128
#define MAX_NUM_SPRITE_COORDS 16
#define MAX_NUM_SPRITEBYTE_DIFFERENCES 8 //; Actually could be 6

void TreasureMap_OutputBitmapData(LPCTSTR InputMapFilename, LPCTSTR InputScrFilename, LPCTSTR OutputInitialMapFilename, LPCTSTR OutputInitialScrFilename, LPCTSTR OutputScrollingMapFilename, LPCTSTR OutputScrollingScrFilename)
{
	ReadBinaryFile(InputMapFilename, TREASURE_SourceBitmapData, BITMAP_CHAR_HEIGHT * BITMAP_CHAR_WIDTH * 8);
	ReadBinaryFile(InputScrFilename, TREASURE_SourceScreenData, BITMAP_CHAR_HEIGHT * BITMAP_CHAR_WIDTH);

	//; Initial Bitmap
	for (int CharY = 0; CharY < INITIAL_BITMAP_CHAR_HEIGHT; CharY++)
	{
		for (int CharX = 0; CharX < INITIAL_BITMAP_CHAR_WIDTH; CharX++)
		{
			for (int PixelY = 0; PixelY < 8; PixelY++)
			{
				TREASURE_InitialBitmapData[CharY][CharX][PixelY] = TREASURE_SourceBitmapData[CharY + INITIAL_CHAR_YSTART][CharX][PixelY];
			}
			TREASURE_InitialScreenData[CharY][CharX] = TREASURE_SourceScreenData[CharY + INITIAL_CHAR_YSTART][CharX];
		}
	}
	WriteBinaryFile(OutputInitialMapFilename, TREASURE_InitialBitmapData, INITIAL_BITMAP_CHAR_HEIGHT * INITIAL_BITMAP_CHAR_WIDTH * 8);
	WriteBinaryFile(OutputInitialScrFilename, TREASURE_InitialScreenData, INITIAL_BITMAP_CHAR_HEIGHT * INITIAL_BITMAP_CHAR_WIDTH);

	//; Scrolling Bitmap
	for (int CharY = 0; CharY < SCROLL_CHAR_HEIGHT; CharY++)
	{
		for (int CharX = 0; CharX < BITMAP_CHAR_WIDTH; CharX++)
		{
			for (int PixelY = 0; PixelY < 8; PixelY++)
			{
				unsigned char OutputDataValue = TREASURE_SourceBitmapData[SCROLL_CHAR_YEND - 1 - CharY][CharX][PixelY];
				TREASURE_ScrollBitmapData[CharX][PixelY][CharY] = OutputDataValue;
			}
			TREASURE_ScrollScreenData[CharX][CharY] = TREASURE_SourceScreenData[SCROLL_CHAR_YEND - 1 - CharY][CharX];
		}
	}
	WriteBinaryFile(OutputScrollingMapFilename, TREASURE_ScrollBitmapData, SCROLL_BITMAPDATA_SIZE);
	WriteBinaryFile(OutputScrollingScrFilename, TREASURE_ScrollScreenData, SCROLL_SCREENDATA_SIZE);
}

void TreasureMap_OutputPathData(char* InputFilename, LPCTSTR OutputSpriteCoordsFilename, LPCTSTR OutputSpriteWriteInfoFilename, LPCTSTR OutputFirstSpriteToDrawFilename)
{
	int PathCoords[MAX_PATH_POINTS][2];
	int NumPathPoints = 0;

	CImg<unsigned char> img(InputFilename);

	cimg_forXY(img, x, y)
	{
		int NewY = img.height() - 1 - y;
		if (x > 0 && x < (img.width() - 1) && NewY > 0 && NewY < (img.height() - 1))
		{
			bool bFound = true;
			for (int Index = 0; Index < 5; Index++)
			{
				for (int ColChannel = 0; ColChannel < 3; ColChannel++)
				{
					if (img(x + MarkOffsets[Index][0], NewY + MarkOffsets[Index][1], 0, ColChannel) != 255)
					{
						bFound = false;
					}
				}
			}
			if (bFound && NumPathPoints < MAX_PATH_POINTS)
			{
				PathCoords[NumPathPoints][0] = x;
				PathCoords[NumPathPoints][1] = NewY;
				NumPathPoints++;
			}
		}
	}

	int NumSpritesUsed = 0;
	int SpritesMinMax[MAX_NUM_SPRITE_COORDS][2][2];	// [SpriteIndex][MinMax][XY]

	int AllSpritesMinX = 4000;
	int AllSpritesMinY = 4000;

	int CurrentSpriteMinX, CurrentSpriteMinY;
	int CurrentSpriteMaxX, CurrentSpriteMaxY;
	CurrentSpriteMinX = CurrentSpriteMinY = 9999;
	CurrentSpriteMaxX = CurrentSpriteMaxY = -1;

	int PathPointSpriteIndex[MAX_PATH_POINTS];

	for (int Index = 0; Index < NumPathPoints; Index++)
	{
		int MinX = PathCoords[Index][0] + 0;
		int MaxX = PathCoords[Index][0] + 3;
		int MinY = PathCoords[Index][1] + 0;
		int MaxY = PathCoords[Index][1] + 3;

		int NewSpriteMinX = min(MinX, CurrentSpriteMinX);
		int NewSpriteMinY = min(MinY, CurrentSpriteMinY);
		int NewSpriteMaxX = max(MaxX, CurrentSpriteMaxX);
		int NewSpriteMaxY = max(MaxY, CurrentSpriteMaxY);
		int NewSpriteW = NewSpriteMaxX - NewSpriteMinX;
		int NewSpriteH = NewSpriteMaxY - NewSpriteMinY;

		bool bCurrentSpriteMinMaxIsGood = false;
		if ((NewSpriteW <= 24) && (NewSpriteH <= 21))
		{
			CurrentSpriteMinX = NewSpriteMinX;
			CurrentSpriteMinY = NewSpriteMinY;
			CurrentSpriteMaxX = NewSpriteMaxX;
			CurrentSpriteMaxY = NewSpriteMaxY;
			bCurrentSpriteMinMaxIsGood = true;
		}
		else
		{
			if (NumSpritesUsed < (MAX_NUM_SPRITE_COORDS - 1))
			{
				NumSpritesUsed++;
				CurrentSpriteMinX = MinX;
				CurrentSpriteMinY = MinY;
				CurrentSpriteMaxX = MaxX;
				CurrentSpriteMaxY = MaxY;
				bCurrentSpriteMinMaxIsGood = true;
			}
		}
		if (bCurrentSpriteMinMaxIsGood == true)
		{
			PathPointSpriteIndex[Index] = NumSpritesUsed;
			SpritesMinMax[NumSpritesUsed][0][0] = CurrentSpriteMinX;
			SpritesMinMax[NumSpritesUsed][0][1] = CurrentSpriteMinY;
			SpritesMinMax[NumSpritesUsed][1][0] = CurrentSpriteMaxX;
			SpritesMinMax[NumSpritesUsed][1][1] = CurrentSpriteMaxY;

			AllSpritesMinX = min(AllSpritesMinX, CurrentSpriteMinX);
			AllSpritesMinY = min(AllSpritesMinY, CurrentSpriteMinY);
		}
		else
		{
			PathPointSpriteIndex[Index] = -1;
		}
	}
	NumSpritesUsed++;

	//; Now we should generate all our sprites ... we will need NumPathPoints + 1 (empty) sprites
	unsigned char OutputSprites[MAX_PATH_POINTS][64];
	ZeroMemory(OutputSprites, MAX_PATH_POINTS * 64);

	for (int Index = 0; Index < NumPathPoints; Index++)
	{
		int ThisPointSpriteIndex = PathPointSpriteIndex[Index];
		int XPos = PathCoords[Index][0];
		int YPos = PathCoords[Index][1];
		int SpriteXPos = SpritesMinMax[ThisPointSpriteIndex][0][0];
		int SpriteYPos = SpritesMinMax[ThisPointSpriteIndex][0][1];

		for (int PixelIndex = 0; PixelIndex < 5; PixelIndex++)
		{
			int PixelXPos = XPos + MarkOffsets[PixelIndex][0] - SpriteXPos;
			int PixelYPos = YPos + MarkOffsets[PixelIndex][1] - SpriteYPos;

			int OutputByteOffset = (PixelYPos * 3) + (PixelXPos / 8);
			int PixelShifted = 1 << (7 - (PixelXPos % 8));
			OutputSprites[Index][OutputByteOffset] |= PixelShifted;
		}
	}
//;	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\TreasureMap\\TreasureMap-Path-Sprites1.bin", OutputSprites, NumPathPoints * 64);

	unsigned char SpriteCoords[MAX_NUM_SPRITE_COORDS][2]; // [SpriteIndex][XY][HiLo]
	memset(SpriteCoords, 0xff, MAX_NUM_SPRITE_COORDS * 2);
	int MinX = AllSpritesMinX; //;0;
	int MinY = AllSpritesMinY;
	for (int SpriteIndex = 0; SpriteIndex < NumSpritesUsed; SpriteIndex++)
	{
		int SpriteIndexReversed = NumSpritesUsed - 1 - SpriteIndex;
		int XPos = SpritesMinMax[SpriteIndex][0][0] - MinX;
		int YPos = SpritesMinMax[SpriteIndex][0][1] - MinY;
		SpriteCoords[SpriteIndexReversed][0] = (unsigned char)(XPos % 256);
		SpriteCoords[SpriteIndexReversed][1] = (unsigned char)(YPos % 256);
	}
	WriteBinaryFile(OutputSpriteCoordsFilename, SpriteCoords, MAX_NUM_SPRITE_COORDS * 2);

	int PreviousOutputSpriteIndex = -1;
	unsigned char SpriteWriteInformation[MAX_PATH_POINTS][1 + 6 + 1]; //; 1: define first offset (0-62), 6: 2x3 array of bytes, 1: padding
	memset(SpriteWriteInformation, 0xff, MAX_PATH_POINTS * 8);
	for (int PathPointIndex = 0; PathPointIndex < NumPathPoints; PathPointIndex++)
	{
		int OutputSpriteIndex = PathPointSpriteIndex[PathPointIndex];
		bool bNewSprite = (OutputSpriteIndex != PreviousOutputSpriteIndex);

		int NumDifferences = 0;

		for (int ByteOffset = 0; ByteOffset < 63; ByteOffset++)
		{
			unsigned char bCompareValue = bNewSprite ? 0 : OutputSprites[PathPointIndex - 1][ByteOffset];
			if (OutputSprites[PathPointIndex][ByteOffset] != bCompareValue)
			{
				NumDifferences++;
				if (NumDifferences == 2)
				{
					int ActualByteOffset = ByteOffset - 3;
					int WriteIndex = 0;
					int SpriteIndexReversed = NumSpritesUsed - 1 - OutputSpriteIndex;
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = SpriteIndexReversed;
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = ActualByteOffset;
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (0 * 3) + 0]; //; (0, 0)
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (0 * 3) + 1]; //; (1, 0)
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (1 * 3) + 0]; //; (0, 1)
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (1 * 3) + 1]; //; (1, 1)
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (2 * 3) + 0]; //; (0, 2)
					SpriteWriteInformation[PathPointIndex][WriteIndex++] = OutputSprites[PathPointIndex][ActualByteOffset + (2 * 3) + 1]; //; (1, 2)
					break;
				}
			}
		}
		PreviousOutputSpriteIndex = OutputSpriteIndex;
	}
	SpriteWriteInformation[NumPathPoints][0] = 0xff;
	WriteBinaryFile(OutputSpriteWriteInfoFilename, SpriteWriteInformation, NumPathPoints * 8 + 1);

	unsigned char FirstSpriteToDraw[SCROLL_CHAR_HEIGHT][2];
	memset(FirstSpriteToDraw, 0xff, SCROLL_CHAR_HEIGHT * 2);
	for (int YPos = 0; YPos < SCROLL_CHAR_HEIGHT; YPos++)
	{
		int ScreenYMin = 400 - (YPos * 8);
		int ScreenYMax = 600 - (YPos * 8);

		int NumSpritesOnScreen = 0;

		for (int SpriteIndex = 0; SpriteIndex < NumSpritesUsed; SpriteIndex++)
		{
			int SpriteYMin = SpritesMinMax[SpriteIndex][0][1];
			int SpriteYMax = SpritesMinMax[SpriteIndex][1][1];

			if ((SpriteYMin < ScreenYMax) && (SpriteYMax >= ScreenYMin))
			{
				FirstSpriteToDraw[YPos][0] = NumSpritesUsed - 1 - SpriteIndex;
				NumSpritesOnScreen++;
			}
		}
		FirstSpriteToDraw[YPos][1] = NumSpritesOnScreen;

	}
	WriteBinaryFile(OutputFirstSpriteToDrawFilename, FirstSpriteToDraw, SCROLL_CHAR_HEIGHT * 2);
}

int TreasureMap_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\TreasureMap");

	TreasureMap_OutputBitmapData(
		L"..\\..\\SourceData\\TreasureMap\\LowerMap.map",
		L"..\\..\\SourceData\\TreasureMap\\LowerMap.scr",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-InitialData.map",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-InitialData.scr",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-ScrollingData.map",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-ScrollingData.scr"
	);
	TreasureMap_OutputBitmapData(
		L"..\\..\\SourceData\\TreasureMap\\UpperMap.map",
		L"..\\..\\SourceData\\TreasureMap\\UpperMap.scr",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-InitialData.map",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-InitialData.scr",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-ScrollingData.map",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-ScrollingData.scr"
	);
	TreasureMap_OutputPathData(
		"..\\..\\SourceData\\TreasureMap\\LowerMapWithPath.bmp",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-Path-SpriteCoords.bin",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-Path-SpriteWriteInfo.bin",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\LowerMap-Path-FirstSpriteToDraw.bin"
		);
	TreasureMap_OutputPathData(
		"..\\..\\SourceData\\TreasureMap\\UpperMapWithPath.bmp",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-Path-SpriteCoords.bin",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-Path-SpriteWriteInfo.bin",
		L"..\\..\\Intermediate\\Built\\TreasureMap\\UpperMap-Path-FirstSpriteToDraw.bin"
	);

	return 0;
}
