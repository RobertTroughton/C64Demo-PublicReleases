//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define BITMAP_CHAR_WIDTH 40
#define BITMAP_CHAR_HEIGHT 24

#define VIRTUAL_WIDTH 1664
#define VIRTUAL_HEIGHT 1152
#define VIRTUAL_CHAR_HEIGHT (VIRTUAL_HEIGHT / 8)
#define PIXCEN_VIRTUAL_WIDTH (((VIRTUAL_WIDTH + 319) / 320) * 320)
#define PIXCEN_VIRTUAL_HEIGHT (((VIRTUAL_HEIGHT + 199) / 200) * 200)
#define PIXCEN_VIRTUAL_CHAR_WIDTH (PIXCEN_VIRTUAL_WIDTH / 8)
#define PIXCEN_VIRTUAL_CHAR_HEIGHT (PIXCEN_VIRTUAL_HEIGHT / 8)

#define NUM_SEGMENTS VIRTUAL_CHAR_HEIGHT
#define NUM_SEGMENTS_PER_FILE 4
#define NUM_SEGMENT_FILES (NUM_SEGMENTS / NUM_SEGMENTS_PER_FILE)

static unsigned char DIAG_WorkingBitmapData[PIXCEN_VIRTUAL_CHAR_HEIGHT][PIXCEN_VIRTUAL_CHAR_WIDTH][8];
static unsigned char DIAG_WorkingColourData[PIXCEN_VIRTUAL_CHAR_HEIGHT][PIXCEN_VIRTUAL_CHAR_WIDTH];
static unsigned char DIAG_WorkingScreenData[PIXCEN_VIRTUAL_CHAR_HEIGHT][PIXCEN_VIRTUAL_CHAR_WIDTH];

unsigned char DIAG_SegmentDataBitmap[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][2][NUM_SEGMENTS][4];	//; [X+Y][Pix/4][Seg][Pix%4]
unsigned char DIAG_SegmentDataColour[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][NUM_SEGMENTS];			//; [X+Y][Seg]
unsigned char DIAG_SegmentDataScreen[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][NUM_SEGMENTS];			//; [X+Y][Seg]

unsigned char DIAG_InitialBitmapData[25][40][8];
unsigned char DIAG_InitialColourData[25][40];
unsigned char DIAG_InitialScreenData[25][40];

void DiagonalBitmap_OutputBitmapData(void)
{
	ReadBinaryFile(L"..\\..\\SourceData\\DiagonalBitmap\\bg_09.map", DIAG_WorkingBitmapData, PIXCEN_VIRTUAL_CHAR_HEIGHT * PIXCEN_VIRTUAL_CHAR_WIDTH * 8);
	ReadBinaryFile(L"..\\..\\SourceData\\DiagonalBitmap\\bg_09.scr", DIAG_WorkingScreenData, PIXCEN_VIRTUAL_CHAR_HEIGHT * PIXCEN_VIRTUAL_CHAR_WIDTH);
	ReadBinaryFile(L"..\\..\\SourceData\\DiagonalBitmap\\bg_09.col", DIAG_WorkingColourData, PIXCEN_VIRTUAL_CHAR_HEIGHT * PIXCEN_VIRTUAL_CHAR_WIDTH);

	//; write out the starting-image...
	for (int YPos = 0; YPos < 25; YPos++)
	{
		for (int XPos = 0; XPos < 40; XPos++)
		{
			for (int YPixelPos = 0; YPixelPos < 8; YPixelPos++)
			{
				DIAG_InitialBitmapData[YPos][XPos][YPixelPos] = DIAG_WorkingBitmapData[YPos][XPos + 24][YPixelPos];
			}
			DIAG_InitialScreenData[YPos][XPos] = DIAG_WorkingScreenData[YPos][XPos + 24];
			DIAG_InitialColourData[YPos][XPos] = DIAG_WorkingColourData[YPos][XPos + 24];
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\DiagonalBitmap\\InitialBitmap.map", DIAG_InitialBitmapData, 25 * 40 * 8);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\DiagonalBitmap\\InitialBitmap.scr", DIAG_InitialScreenData, 25 * 40);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\DiagonalBitmap\\InitialBitmap.col", DIAG_InitialColourData, 25 * 40);

	for (int Segment = 0; Segment < NUM_SEGMENTS; Segment++)
	{
		int FixedXPos = BITMAP_CHAR_HEIGHT + (BITMAP_CHAR_WIDTH - 2) + Segment;
		int FixedYPos = BITMAP_CHAR_HEIGHT + Segment;
		int Index = 0;

		for (int XPos = 0; XPos < BITMAP_CHAR_WIDTH - 1; XPos ++)
		{
			int XCharPos = BITMAP_CHAR_HEIGHT + XPos + Segment;
			int YCharPos = FixedYPos;

			if (YCharPos >= VIRTUAL_CHAR_HEIGHT)
			{
				XCharPos -= VIRTUAL_CHAR_HEIGHT;
				YCharPos -= VIRTUAL_CHAR_HEIGHT;
			}

			for (int Line = 0; Line < 8; Line++)
			{
				DIAG_SegmentDataBitmap[Index][Line / 4][Segment][Line % 4] = DIAG_WorkingBitmapData[YCharPos][XCharPos][Line];
			}
			DIAG_SegmentDataScreen[Index][Segment] = DIAG_WorkingScreenData[YCharPos][XCharPos];
			DIAG_SegmentDataColour[Index][Segment] = DIAG_WorkingColourData[YCharPos][XCharPos];
			Index++;
		}
		for (int YPos = 0; YPos < BITMAP_CHAR_HEIGHT; YPos++)
		{
			int XCharPos = FixedXPos;
			int YCharPos = YPos + Segment;

			if (YCharPos >= VIRTUAL_CHAR_HEIGHT)
			{
				XCharPos -= VIRTUAL_CHAR_HEIGHT;
				YCharPos -= VIRTUAL_CHAR_HEIGHT;
			}

			for (int Line = 0; Line < 8; Line++)
			{
				DIAG_SegmentDataBitmap[Index][Line / 4][Segment][Line % 4] = DIAG_WorkingBitmapData[YCharPos][XCharPos][Line];
			}
			DIAG_SegmentDataScreen[Index][Segment] = DIAG_WorkingScreenData[YCharPos][XCharPos];
			DIAG_SegmentDataColour[Index][Segment] = DIAG_WorkingColourData[YCharPos][XCharPos];
			Index++;
		}
	}

	unsigned char SegmentDataBitmap_Split[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][NUM_SEGMENTS_PER_FILE][8 + 2];

	for (int SegFile = 0; SegFile < NUM_SEGMENT_FILES; SegFile++)
	{
		for (int CharOffset = 0; CharOffset < BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT; CharOffset++)
		{
			for (int Segment = 0; Segment < NUM_SEGMENTS_PER_FILE; Segment++)
			{
				for (int Part = 0; Part < 2; Part++)
				{
					for (int Byte = 0; Byte < 4; Byte++)
					{
						SegmentDataBitmap_Split[CharOffset][Segment][Part * 4 + Byte] = DIAG_SegmentDataBitmap[CharOffset][Part][SegFile * NUM_SEGMENTS_PER_FILE + Segment][Byte];
					}
				}
				SegmentDataBitmap_Split[CharOffset][Segment][8] = DIAG_SegmentDataScreen[CharOffset][SegFile * NUM_SEGMENTS_PER_FILE + Segment];
				SegmentDataBitmap_Split[CharOffset][Segment][9] = DIAG_SegmentDataColour[CharOffset][SegFile * NUM_SEGMENTS_PER_FILE + Segment];
			}
		}

		wstring SegmentDataBitmap_Split_Filename = L"..\\..\\Intermediate\\Built\\DiagonalBitmap\\BitmapData" + to_wstring(SegFile) + L".bin";
		WriteBinaryFile(SegmentDataBitmap_Split_Filename.c_str(), SegmentDataBitmap_Split, (BITMAP_CHAR_WIDTH - 1 + BITMAP_CHAR_HEIGHT) * NUM_SEGMENTS_PER_FILE * 10);
	}
}


int DiagonalBitmap_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\DiagonalBitmap");

	DiagonalBitmap_OutputBitmapData();

	return 0;
}
