//; (c) 2018-2019, Genesis*Project

#include "..\Common\CodeGen.h"
#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define BITMAP_MAP_LEN 8000
#define BITMAP_SCR_LEN 1000
#define BITMAP_COL_LEN 1000

#define SPRITES_NUM_SETS 3
#define SPRITES_NUM_ROWS 7
#define SPRITES_NUM_PER_ROW 8

void VertBitmap_SpriteWeave(LPCTSTR InputFilename_SpriteMAP, LPCTSTR OutputFilename_SpriteBIN)
{
	int LogoWidth = SPRITES_NUM_PER_ROW * 24;
	unsigned char SourceSpriteData[SPRITES_NUM_SETS][SPRITES_NUM_ROWS][SPRITES_NUM_PER_ROW][64];
	ZeroMemory(SourceSpriteData, sizeof(SourceSpriteData));
	unsigned char OutputSpriteData[SPRITES_NUM_SETS][SPRITES_NUM_ROWS][SPRITES_NUM_PER_ROW][64];
	ZeroMemory(OutputSpriteData, sizeof(OutputSpriteData));

	ReadBinaryFile(InputFilename_SpriteMAP, SourceSpriteData, sizeof(SourceSpriteData));

	for (int SetIndex = 0; SetIndex < SPRITES_NUM_SETS; SetIndex++)
	{
		for (int RowIndex = 0; RowIndex < SPRITES_NUM_ROWS; RowIndex++)
		{
			for (int SpriteIndex = 0; SpriteIndex < SPRITES_NUM_PER_ROW; SpriteIndex++)
			{
				for (int YVal = 0; YVal < 21; YVal++)
				{
					for (int XVal = 0; XVal < 3; XVal++)
					{
						int SourceY = RowIndex * 20 + YVal;
						int SourceRowIndex = SourceY / 21;
						int SourceYPixel = SourceY % 21;
						int SourceByteOffset = SourceYPixel * 3 + XVal;

						int OutputByteOffset = ((YVal + 21 - RowIndex) % 21) * 3 + XVal;

						OutputSpriteData[SetIndex][RowIndex][SpriteIndex][OutputByteOffset] = SourceSpriteData[SetIndex][SourceRowIndex][SpriteIndex][SourceByteOffset];
					}
				}

			}

		}
	}

	WriteBinaryFile(OutputFilename_SpriteBIN, OutputSpriteData, sizeof(OutputSpriteData));
}

void VertBitmap_OutputBitmapScrollDataBIN(LPCTSTR InputFilename_BitmapMAP, LPCTSTR InputFilename_BitmapSCR, LPCTSTR InputFilename_BitmapCOL, LPCTSTR OutputFilename_BitmapScrollDataBIN)
{
	unsigned char MAPData[2][BITMAP_MAP_LEN];
	unsigned char SCRData[2][BITMAP_SCR_LEN];
	unsigned char COLData[2][BITMAP_COL_LEN];
	unsigned char BitmapScrollData[40][200 + 25 + 25 + 6];

	ReadBinaryFile(InputFilename_BitmapMAP, MAPData, BITMAP_MAP_LEN * 2);
	ReadBinaryFile(InputFilename_BitmapSCR, SCRData, BITMAP_SCR_LEN * 2);
	ReadBinaryFile(InputFilename_BitmapCOL, COLData, BITMAP_COL_LEN * 2);

	for (int YCharPos = 0; YCharPos < 25; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < 40; XCharPos++)
		{
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				unsigned char BitmapByte = MAPData[1][(YCharPos * 40 * 8) + (XCharPos * 8) + YPixel];
				BitmapScrollData[XCharPos][YCharPos * 8 + YPixel] = BitmapByte;
			}
			unsigned char ScreenByte = SCRData[1][(YCharPos * 40) + XCharPos];
			unsigned char ColourByte = COLData[1][(YCharPos * 40) + XCharPos];
			BitmapScrollData[XCharPos][200 + YCharPos] = ScreenByte;
			BitmapScrollData[XCharPos][225 + YCharPos] = ColourByte;
		}
	}

	WriteBinaryFile(OutputFilename_BitmapScrollDataBIN, BitmapScrollData, 40 * 256);
}

#define SPRITEX_WAVEAMPLITUDE 64
#define SPRITEX_WAVELENGTH 128
#define SPRITEX_SCROLLINLENGTH 16
#define SIN_OFFSET (SPRITEX_WAVELENGTH - SPRITEX_SCROLLINLENGTH)
void VertBitmap_OutputSpriteXPosSinTables(LPCTSTR OutputFilename_SpriteXSinTablesBIN)
{
	//; 256 Values:
	//;  ... 32 scroll in
	//;  ... 192 waving left and right (4 x 48)
	//;  ... 32 scroll out

	int SpriteXSinWaveTable[SPRITEX_WAVELENGTH];
	GenerateSinTable(SPRITEX_WAVELENGTH, 0, SPRITEX_WAVEAMPLITUDE, 0, SpriteXSinWaveTable);

	int SpriteXSinTable[256];

	//; Scroll In
	int XStartPos = -192 - 32 - 128;
	int XCentre = 24 + 160 - (192 / 2) - (SPRITEX_WAVEAMPLITUDE / 2);
	for (int Index = 0; Index < SPRITEX_SCROLLINLENGTH; Index++)
	{
		int XVal = XStartPos + ((XCentre - XStartPos) * Index) / SPRITEX_SCROLLINLENGTH;
		XVal += SpriteXSinWaveTable[(Index + SIN_OFFSET) % SPRITEX_WAVELENGTH];
		SpriteXSinTable[Index] = XVal;
	}

	//; Waving
	for (int Index = SPRITEX_SCROLLINLENGTH; Index < (256 - SPRITEX_SCROLLINLENGTH); Index++)
	{
		int XVal = XCentre + SpriteXSinWaveTable[(Index + SIN_OFFSET) % SPRITEX_WAVELENGTH];
		SpriteXSinTable[Index] = XVal;
	}

	//; ScrollOut
	int XEndPos = 320 + 24 + 128;
	for (int Index = (256 - SPRITEX_SCROLLINLENGTH); Index < 256; Index++)
	{
		int RelativeIndex = Index - (256 - SPRITEX_SCROLLINLENGTH);
		int XVal = XCentre + ((XEndPos - XCentre) * RelativeIndex) / SPRITEX_SCROLLINLENGTH;
		XVal += SpriteXSinWaveTable[(Index + SIN_OFFSET) % SPRITEX_WAVELENGTH];
		SpriteXSinTable[Index] = XVal;
	}

	unsigned char cSpriteXSinTables[9][256];
	for (int Index = 0; Index < 256; Index++)
	{
		int XPos = (int)SpriteXSinTable[Index];
		unsigned char XMSB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			XPos = min(XPos, 320 + 24);

			unsigned int uXPos = 0;
			if (XPos > 0)
			{
				uXPos = (unsigned int)XPos;
			}
			cSpriteXSinTables[SpriteIndex][Index] = uXPos & 255;

			if (uXPos >= 256)
			{
				XMSB |= (1 << SpriteIndex);
			}
			XPos += 24;
		}
		cSpriteXSinTables[8][Index] = XMSB;
	}

	WriteBinaryFile(OutputFilename_SpriteXSinTablesBIN, cSpriteXSinTables, sizeof(cSpriteXSinTables));

}


int VertBitmap_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\VertBitmap");

	VertBitmap_OutputBitmapScrollDataBIN(L"..\\..\\Build\\Parts\\VertBitmap\\Data\\Dive.map", L"..\\..\\Build\\Parts\\VertBitmap\\Data\\Dive.scr", L"..\\..\\Build\\Parts\\VertBitmap\\Data\\Dive.col", L"..\\..\\Intermediate\\Built\\VertBitmap\\BitmapScrollData.bin");

	VertBitmap_SpriteWeave(L"..\\..\\Build\\Parts\\VertBitmap\\Data\\InitialSpriteLogos.map", L"..\\..\\Intermediate\\Built\\VertBitmap\\InitialSpriteLogos.bin");

	VertBitmap_OutputSpriteXPosSinTables(L"..\\..\\Intermediate\\Built\\VertBitmap\\SpriteXSinTables.bin");

	return 0;
}
