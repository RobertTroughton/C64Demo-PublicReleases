// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

// _____
// |   |\
// | 1 | \
// |   | 3\
// --------|
// \ 3 |   |\
//  \  | 2 | \
//   \ |   | 4\
//     ---------
//     \ 4 |
//      \  |  1 ...
//       \ |
//        \|

static const int NumBitmapParts = 9;

LPCTSTR InputFilenameBitmap[NumBitmapParts] = {
	L"..\\..\\SourceData\\endbitmap\\0-topleft-data.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-data.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-data.bin",
	L"..\\..\\SourceData\\endbitmap\\3-bottomleft-data.bin",
	L"..\\..\\SourceData\\endbitmap\\4-bottommiddle-data.bin",
	L"..\\..\\SourceData\\endbitmap\\5-bottomright-data.bin",
	L"..\\..\\SourceData\\endbitmap\\0-topleft-data.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-data.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-data.bin",
};
LPCTSTR InputFilenameColour[NumBitmapParts] = {
	L"..\\..\\SourceData\\endbitmap\\0-topleft-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\3-bottomleft-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\4-bottommiddle-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\5-bottomright-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\0-topleft-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-colour.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-colour.bin",
};
LPCTSTR InputFilenameScreen[NumBitmapParts] = {
	L"..\\..\\SourceData\\endbitmap\\0-topleft-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\3-bottomleft-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\4-bottommiddle-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\5-bottomright-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\0-topleft-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\1-topmiddle-screen.bin",
	L"..\\..\\SourceData\\endbitmap\\2-topright-screen.bin",
};

unsigned char WorkingBitmapData[2048][2048 / 8];
unsigned char WorkingColourData[512][512];
unsigned char WorkingScreenData[512][512];

char MyFileReadBuffer_Bitmap[NumBitmapParts][FILE_READ_BUFFER_SIZE];
char MyFileReadBuffer_Colour[NumBitmapParts][FILE_READ_BUFFER_SIZE];
char MyFileReadBuffer_Screen[NumBitmapParts][FILE_READ_BUFFER_SIZE];

#define BITMAP_CHAR_WIDTH 40
#define BITMAP_CHAR_HEIGHT 24

#define NUM_SEGMENTS (BITMAP_CHAR_HEIGHT * 2)

void EndCredits_OutputBitmapData(void)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };

	ZeroMemory(MyFileReadBuffer_Bitmap, FILE_READ_BUFFER_SIZE * NumBitmapParts);
	ZeroMemory(MyFileReadBuffer_Colour, FILE_READ_BUFFER_SIZE * NumBitmapParts);
	ZeroMemory(MyFileReadBuffer_Screen, FILE_READ_BUFFER_SIZE * NumBitmapParts);

	for (int FileIndex = 0; FileIndex < NumBitmapParts; FileIndex++)
	{
		HANDLE hFileBitmap = CreateFile(InputFilenameBitmap[FileIndex], GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
		ReadFile(hFileBitmap, MyFileReadBuffer_Bitmap[FileIndex], FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
		CloseHandle(hFileBitmap);

		HANDLE hFileColour = CreateFile(InputFilenameColour[FileIndex], GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
		ReadFile(hFileColour, MyFileReadBuffer_Colour[FileIndex], FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
		CloseHandle(hFileColour);

		HANDLE hFileScreen = CreateFile(InputFilenameScreen[FileIndex], GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
		ReadFile(hFileScreen, MyFileReadBuffer_Screen[FileIndex], FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
		CloseHandle(hFileScreen);
	}

	ZeroMemory(WorkingBitmapData, 1024 * 1024 / 8);
	ZeroMemory(WorkingScreenData, 256 * 256);
	ZeroMemory(WorkingColourData, 256 * 256);

	for (int PicturePart = 0; PicturePart < NumBitmapParts; PicturePart++)
	{
		int PictureWidth = 0;
		switch (PicturePart)
		{
		case 0: // top-left
		case 2: // top-right
		case 3: // bottom-left
		case 5: // bottom-right
		case 6: // top-left (2)
		case 8: // top-right (2)
			PictureWidth = BITMAP_CHAR_HEIGHT;
			break;

		case 1: // top-middle
		case 4: // bottom-middle
		case 7: // top-middle (2)
			PictureWidth = BITMAP_CHAR_WIDTH;
			break;

		default:
			PictureWidth = 0;
			break;
		}

		for (int YCharPos = 0; YCharPos < BITMAP_CHAR_HEIGHT; YCharPos++)
		{
			for (int XCharPos = 0; XCharPos < PictureWidth; XCharPos++)
			{
				int ReadXCharPos = 0;
				int ReadYCharPos = 1;
				int WriteXCharPos = 0;
				int WriteYCharPos = 0;
				switch (PicturePart)
				{
				case 0: // top-left
					ReadXCharPos = (40 - BITMAP_CHAR_HEIGHT);
					WriteXCharPos = 0;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 0;
					break;

				case 1: // top-middle
					WriteXCharPos = BITMAP_CHAR_HEIGHT;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 0;
					break;

				case 2: // top-right
					WriteXCharPos = BITMAP_CHAR_HEIGHT + BITMAP_CHAR_WIDTH;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 0;
					break;

				case 3: // bottom-left
					ReadXCharPos = (40 - BITMAP_CHAR_HEIGHT);
					WriteXCharPos = BITMAP_CHAR_HEIGHT;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 1;
					break;

				case 4: // bottom-middle
					WriteXCharPos = BITMAP_CHAR_HEIGHT * 2;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 1;
					break;

				case 5: // bottom-right
					WriteXCharPos = BITMAP_CHAR_HEIGHT * 2 + BITMAP_CHAR_WIDTH;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 1;
					break;

				case 6: // top-left (2)
					ReadXCharPos = (40 - BITMAP_CHAR_HEIGHT);
					WriteXCharPos = BITMAP_CHAR_HEIGHT * 2;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 2;
					break;

				case 7: // top-middle (2)
					WriteXCharPos = BITMAP_CHAR_HEIGHT * 3;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 2;
					break;

				case 8: // top-right (2)
					WriteXCharPos = BITMAP_CHAR_HEIGHT * 3 + BITMAP_CHAR_WIDTH;
					WriteYCharPos = BITMAP_CHAR_HEIGHT * 2;
					break;
				}
				ReadXCharPos += XCharPos;
				ReadYCharPos += YCharPos;
				WriteXCharPos += XCharPos;
				WriteYCharPos += YCharPos;

				for (int YPixelPos = 0; YPixelPos < 8; YPixelPos++)
				{
					int WriteYPixelPos = WriteYCharPos * 8 + YPixelPos;

					int ByteReadOffset = 2;
					ByteReadOffset += ReadYCharPos * 40 * 8;
					ByteReadOffset += ReadXCharPos * 8;
					ByteReadOffset += YPixelPos;
					WorkingBitmapData[WriteYPixelPos][WriteXCharPos] = MyFileReadBuffer_Bitmap[PicturePart][ByteReadOffset];
				}

				int CharReadOffset = 2;
				CharReadOffset += ReadYCharPos * 40;
				CharReadOffset += ReadXCharPos;
				WorkingColourData[WriteYCharPos][WriteXCharPos] = MyFileReadBuffer_Colour[PicturePart][CharReadOffset];
				WorkingScreenData[WriteYCharPos][WriteXCharPos] = MyFileReadBuffer_Screen[PicturePart][CharReadOffset];
			}
		}
	}

	unsigned char SegmentDataBitmap[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][2][NUM_SEGMENTS][4]; // [X+Y][Pix/4][Seg][Pix%4]
	unsigned char SegmentDataColour[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][NUM_SEGMENTS]; // [X+Y][Seg]
	unsigned char SegmentDataScreen[BITMAP_CHAR_WIDTH + BITMAP_CHAR_HEIGHT][NUM_SEGMENTS]; // [X+Y][Seg]

	for (int Segment = 0; Segment < NUM_SEGMENTS; Segment++)
	{
		int FixedXPos = (BITMAP_CHAR_HEIGHT/* - 1*/) + (BITMAP_CHAR_WIDTH - 2) + Segment;
		int FixedYPos = (BITMAP_CHAR_HEIGHT/* - 1*/) + Segment;
		int Index = 0;

		for (int XPos = 0; XPos < BITMAP_CHAR_WIDTH - 1; XPos ++)
		{
			int XCharPos = (BITMAP_CHAR_HEIGHT/* - 1*/) + XPos + Segment;
			int YCharPos = FixedYPos;
			for (int Line = 0; Line < 8; Line++)
			{
				SegmentDataBitmap[Index][Line / 4][Segment][Line % 4] = WorkingBitmapData[YCharPos * 8 + Line][XCharPos];
			}
			SegmentDataScreen[Index][Segment] = WorkingScreenData[YCharPos][XCharPos];
			SegmentDataColour[Index][Segment] = WorkingColourData[YCharPos][XCharPos];
			Index++;
		}
		for (int YPos = 0; YPos < BITMAP_CHAR_HEIGHT; YPos++)
		{
			int XCharPos = FixedXPos;
			int YCharPos = YPos + Segment;
			for (int Line = 0; Line < 8; Line++)
			{
				SegmentDataBitmap[Index][Line / 4][Segment][Line % 4] = WorkingBitmapData[YCharPos * 8 + Line][XCharPos];
			}
			SegmentDataScreen[Index][Segment] = WorkingScreenData[YCharPos][XCharPos];
			SegmentDataColour[Index][Segment] = WorkingColourData[YCharPos][XCharPos];
			Index++;
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\999-END-BitmapData.bin", SegmentDataBitmap, (BITMAP_CHAR_WIDTH - 1 + BITMAP_CHAR_HEIGHT) * 2 * NUM_SEGMENTS * 4);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\999-END-ColourData.bin", SegmentDataColour, (BITMAP_CHAR_WIDTH - 1 + BITMAP_CHAR_HEIGHT) * NUM_SEGMENTS);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\999-END-ScreenData.bin", SegmentDataScreen, (BITMAP_CHAR_WIDTH - 1 + BITMAP_CHAR_HEIGHT) * NUM_SEGMENTS);
}


int EndCredits_Main()
{
	EndCredits_OutputBitmapData();

	return 0;
}




