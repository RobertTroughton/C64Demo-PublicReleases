//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\CodeGen.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define DYPP_WIDTH 320
#define DYPP_HEIGHT 200

#define DYPP_MAX_NUM_CHARSETS 16 //; we shouldn't need anything like this many...

#define DYPP_FONT_NUMCHARS 64

#define DYPP_CHAR_WIDTH (DYPP_WIDTH / 8)
#define DYPP_CHAR_HEIGHT (DYPP_HEIGHT / 8)

#define DYPP_NUM_FRAMES 1

#define DYPP_FONT_HEIGHT 56
#define DYPP_FONT_CHAR_HEIGHT (DYPP_FONT_HEIGHT / 8)

#define DYPP_SINE_LEN (DYPP_WIDTH * DYPP_NUM_FRAMES)
#define DYPP_SINE_MAXVALUE (DYPP_HEIGHT - DYPP_FONT_HEIGHT)

#define DYPP_MAX_NUM_TILES 256

#define DYPP_SPACEWIDTH 3

unsigned char CharSetData[256][8];

unsigned char CharSetTileIndex[DYPP_FONT_NUMCHARS][16];

unsigned char Deduped1By8Tiles[DYPP_MAX_NUM_TILES][DYPP_FONT_CHAR_HEIGHT];
int NumDeduped1By8Tiles = 0;

char DYPPScrollText[] = {
	" ... gp wibbling and wobbling through your diving mask with dxypp pixel perfection!                 "
};
int SizeDYPPScrollText = sizeof(DYPPScrollText);

unsigned char CharRemap[64];

class BIGDYPP_FINALDATA
{
public:

	unsigned char CharWidth[DYPP_FONT_NUMCHARS];

	int NumCharSets;
	class BIGDYPP_FINALCHARSET
	{
	public:
		unsigned char CharSetData[256][8];
		unsigned char NumChars;
		unsigned char YStartLine;
		unsigned char YEndLine;
	} CharSet[DYPP_MAX_NUM_CHARSETS];

	int NumFinalTiles;
	unsigned char FinalTiles[512][128];

	int ScreenToTileLookup[DYPP_CHAR_HEIGHT][DYPP_CHAR_WIDTH];
} DYPPFinalData;

LPCTSTR DYPPOutputFontFilenames[] = {
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font0.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font1.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font2.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font3.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font4.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font5.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font6.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font7.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font8.map",
	L"..\\..\\Intermediate\\Built\\BigDYPP\\Font9.map",
};

void BIGDYPP_CalculateDYPPChars(void)
{
	unsigned char DYPPScreenUsedData[DYPP_CHAR_HEIGHT][DYPP_CHAR_WIDTH];
	ZeroMemory(DYPPScreenUsedData, DYPP_CHAR_WIDTH * DYPP_CHAR_HEIGHT);
	unsigned char DYPPScreenPixelData[DYPP_HEIGHT][DYPP_WIDTH];
	memset(DYPPScreenPixelData, 0xff, DYPP_WIDTH * DYPP_HEIGHT);

	int DYPPSinTable[DYPP_SINE_LEN];
	GenerateSinTable(DYPP_SINE_LEN, 0, DYPP_SINE_MAXVALUE, 0, DYPPSinTable);
	for (int SineIndex = 0; SineIndex < DYPP_SINE_LEN; SineIndex++)
	{
		int YMin = DYPPSinTable[SineIndex];
		for (int YOffset = 0; YOffset < DYPP_FONT_HEIGHT; YOffset++)
		{
			int YValue = YMin + YOffset;
			DYPPScreenPixelData[YValue][SineIndex] = YOffset;
			DYPPScreenUsedData[YValue / 8][SineIndex / 8] = 1;
		}
	}

	//; Ensure that Char 0 is empty, Char 1 is full...
	for (int CharSetIndex = 0; CharSetIndex < DYPP_MAX_NUM_CHARSETS; CharSetIndex++)
	{
		for (int YPixel = 0; YPixel < 8; YPixel++)
		{
			DYPPFinalData.CharSet[CharSetIndex].CharSetData[0][YPixel] = 0;
			DYPPFinalData.CharSet[CharSetIndex].CharSetData[1][YPixel] = 255;
		}
		DYPPFinalData.CharSet[CharSetIndex].NumChars = 2;
		DYPPFinalData.CharSet[CharSetIndex].YStartLine = 0;
	}

	for (int YCharPos = 0; YCharPos < DYPP_CHAR_HEIGHT; YCharPos++)
	{
		unsigned char CharsOnThisLine[256][8];
		int NumCharsOnThisLine = 0;

		for (int XCharPos = 0; XCharPos < DYPP_CHAR_WIDTH; XCharPos++)
		{
			if (!DYPPScreenUsedData[YCharPos][XCharPos])
			{
				continue;
			}
			for (int TileIndex = 0; TileIndex < NumDeduped1By8Tiles; TileIndex++)
			{
				unsigned char ThisChar[8];
				ZeroMemory(ThisChar, 8);
				for (int YPixel = 0; YPixel < 8; YPixel++)
				{
					int YPos = YCharPos * 8 + YPixel;
					for (int XPixel = 0; XPixel < 8; XPixel++)
					{
						int XPos = XCharPos * 8 + XPixel;
						int YOffset = DYPPScreenPixelData[YPos][XPos];
						if (YOffset != 0xff)
						{
							//; we need to mask the font pixel here...
							unsigned char FontChar = Deduped1By8Tiles[TileIndex][YOffset / 8];
							ThisChar[YPixel] |= (CharSetData[FontChar][YOffset & 7] & (1 << (7 - XPixel)));
						}
					}
				}

				int FoundIndex = -1;
				for (int CheckIndex = 0; CheckIndex < NumCharsOnThisLine; CheckIndex++)
				{
					bool bFound = true;
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						if (CharsOnThisLine[CheckIndex][YPixel] != ThisChar[YPixel])
						{
							bFound = false;
							break;
						}
					}
					if (bFound)
					{
						FoundIndex = CheckIndex;
						break;
					}
				}

				if (FoundIndex < 0)
				{
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						CharsOnThisLine[NumCharsOnThisLine][YPixel] = ThisChar[YPixel];
					}
					FoundIndex = NumCharsOnThisLine;
					NumCharsOnThisLine++;
				}
			}
		}

		//; Now, parse over the chars on this line and dedupe against the current charset
		int CurrentCharset_NumChars = DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].NumChars;

		for (int CharIndex = 0; CharIndex < NumCharsOnThisLine; CharIndex++)
		{
			bool bFound = false;
			for (int CheckCharIndex = 0; CheckCharIndex < CurrentCharset_NumChars; CheckCharIndex++)
			{
				bFound = true;
				for (int YPixel = 0; YPixel < 8; YPixel++)
				{
					if (CharsOnThisLine[CharIndex][YPixel] != DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].CharSetData[CheckCharIndex][YPixel])
					{
						bFound = false;
						break;
					}
				}
				if (bFound)
				{
					break;
				}
			}
			if (!bFound)
			{
				if (CurrentCharset_NumChars < 256)
				{
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].CharSetData[CurrentCharset_NumChars][YPixel] = CharsOnThisLine[CharIndex][YPixel];
					}
				}
				CurrentCharset_NumChars++;
			}
		}

		if (CurrentCharset_NumChars <= 256)
		{
			//; all good!
			DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].NumChars = CurrentCharset_NumChars;
		}
		else
		{
			//; failed to fit ... so we need to start on the next charset and copy our new chars into there
			DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].YEndLine = YCharPos;
			DYPPFinalData.NumCharSets++;
			DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].YStartLine = YCharPos;

			memcpy(&DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].CharSetData[2][0], &CharsOnThisLine[0][0], NumCharsOnThisLine * 8);
			DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].NumChars += NumCharsOnThisLine;
		}
	}
	DYPPFinalData.CharSet[DYPPFinalData.NumCharSets].YEndLine = DYPP_CHAR_HEIGHT;
	DYPPFinalData.NumCharSets++;

	//; Write out the font files (inverted)
	for (int FontIndex = 0; FontIndex < DYPPFinalData.NumCharSets; FontIndex++)
	{
		//; Invert the charset
		unsigned char InvertedCharSetData[256][8];
		for (int Index = 0; Index < 256; Index++)
		{
			for (int YIndex = 0; YIndex < 8; YIndex++)
			{
				InvertedCharSetData[Index][YIndex] = DYPPFinalData.CharSet[FontIndex].CharSetData[Index][YIndex] ^ 255;
			}
		}

		WriteBinaryFile(DYPPOutputFontFilenames[FontIndex], &InvertedCharSetData[0][0], DYPPFinalData.CharSet[FontIndex].NumChars * 8);
	}

	//; SECOND PASS: To generate the tile char info
	DYPPFinalData.NumFinalTiles = 0;
	ZeroMemory(DYPPFinalData.FinalTiles, 512 * 128);

	memset(DYPPFinalData.ScreenToTileLookup, -1, sizeof(DYPPFinalData.ScreenToTileLookup));

	int CurrentCharset = 0;

	int NumFound = 0;
	int NumNotFound = 0;
	for (int YCharPos = 0; YCharPos < DYPP_CHAR_HEIGHT; YCharPos++)
	{
		if (YCharPos >= DYPPFinalData.CharSet[CurrentCharset].YEndLine)
		{
			CurrentCharset++;
		}
		for (int XCharPos = 0; XCharPos < DYPP_CHAR_WIDTH; XCharPos++)
		{
			if (!DYPPScreenUsedData[YCharPos][XCharPos])
			{
				continue;
			}

			unsigned char ThisChar_UsedTiles[128];
			memset(ThisChar_UsedTiles, 0xff, NumDeduped1By8Tiles);

			for (int TileIndex = 0; TileIndex < NumDeduped1By8Tiles; TileIndex++)
			{
				unsigned char ThisChar[8];
				ZeroMemory(ThisChar, 8);
				for (int YPixel = 0; YPixel < 8; YPixel++)
				{
					int YPos = YCharPos * 8 + YPixel;
					for (int XPixel = 0; XPixel < 8; XPixel++)
					{
						int XPos = XCharPos * 8 + XPixel;
						int YOffset = DYPPScreenPixelData[YPos][XPos];
						if (YOffset != 0xff)
						{
							//; we need to mask the font pixel here...
							unsigned char FontChar = Deduped1By8Tiles[TileIndex][YOffset / 8];
							ThisChar[YPixel] |= (CharSetData[FontChar][YOffset & 7] & (1 << (7 - XPixel)));
						}
					}
				}

				//; Now go find where this char exists in the relevant charset...
				int FoundIndex = -1;
				for (int CheckIndex = 0; CheckIndex < DYPPFinalData.CharSet[CurrentCharset].NumChars; CheckIndex++)
				{
					bool bFound = true;
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						if (DYPPFinalData.CharSet[CurrentCharset].CharSetData[CheckIndex][YPixel] != ThisChar[YPixel])
						{
							bFound = false;
							break;
						}
					}
					if (bFound)
					{
						FoundIndex = CheckIndex;
						break;
					}
				}
				if (FoundIndex >= 0)
				{
					ThisChar_UsedTiles[TileIndex] = (unsigned char)FoundIndex;
				}
			}

			int TileFoundIndex = -1;
			for (int TileCheckIndex = 0; TileCheckIndex < DYPPFinalData.NumFinalTiles; TileCheckIndex++)
			{
				bool bFound = true;
				for (int Index = 0; Index < NumDeduped1By8Tiles; Index++)
				{
					if (ThisChar_UsedTiles[Index] != DYPPFinalData.FinalTiles[TileCheckIndex][Index])
					{
						bFound = false;
						break;
					}
				}
				if (bFound)
				{
					TileFoundIndex = TileCheckIndex;
					break;
				}
			}
			if (TileFoundIndex == -1)
			{
				NumNotFound++;

				TileFoundIndex = DYPPFinalData.NumFinalTiles;
				memcpy(&DYPPFinalData.FinalTiles[TileFoundIndex][0], &ThisChar_UsedTiles[0], NumDeduped1By8Tiles);
				DYPPFinalData.NumFinalTiles++;
			}
			else
			{
				NumFound++;
			}
			DYPPFinalData.ScreenToTileLookup[YCharPos][XCharPos] = TileFoundIndex;
		}
	}
}

void BIGDYPP_OutputD018SplitDefinesASM(LPCTSTR OutputFilename_D018SplitDefinesASM)
{
	CodeGen D018SplitDefinesCode(OutputFilename_D018SplitDefinesASM);
	D018SplitDefinesCode.OutputCodeLine(NONE, fmt::format(".var D018Split{:d} = ${:02x}", 0, 50));
	for (int CharSetIndex = 0; CharSetIndex < DYPPFinalData.NumCharSets; CharSetIndex++)
	{
		D018SplitDefinesCode.OutputCodeLine(NONE, fmt::format(".var D018Split{:d} = ${:02x}", CharSetIndex + 1, 50 + (DYPPFinalData.CharSet[CharSetIndex].YEndLine) * 8));
	}
}

void BIGDYPP_OutputTileDataASM(LPCTSTR OutputFilename_TileDataASM)
{
	CodeGen TileDataCode(OutputFilename_TileDataASM);

	TileDataCode.OutputCodeLine(NONE, fmt::format(".import source \"..\\..\\..\\Build\\Main\\ASM\\Main-CommonDefines.asm\""));
	TileDataCode.OutputCodeLine(NONE, fmt::format(".import source \"..\\..\\..\\Build\\Main\\ASM\\Main-CommonMacros.asm\""));
	TileDataCode.OutputBlankLine();
	TileDataCode.OutputFunctionLine(fmt::format("BIGDYPP_TileData"));

	int TileLength = (NumDeduped1By8Tiles + 7) & 0xfffffff8;
	for (int TileIndex = 0; TileIndex < DYPPFinalData.NumFinalTiles; TileIndex++)
	{
		TileDataCode.OutputFunctionLine(fmt::format("BIGDYPP_TileData_Tile{:d}", TileIndex));
		for (int DataIndex = 0; DataIndex < TileLength; DataIndex += 8)
		{
			TileDataCode.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 0],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 1],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 2],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 3],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 4],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 5],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 6],
				DYPPFinalData.FinalTiles[TileIndex][DataIndex + 7])
			);
		}
	}
}

/*void BIGDYPP_AddRenderCodeLine(CodeGen& Code)
{
	static int XCharPos = 0;
	static int YCharPos = 0;
	static int iFirstLine = -1;
	static int iLastLine = 24;
	static bool bFirstOfColumn = true;

	int YBankSplit = DYPPFinalData.CharSet[3].YEndLine;

	if (bFirstOfColumn)
	{
		Code.OutputFunctionLine(fmt::format("BIGDYPP_Render_Column{:d}", XCharPos));
		Code.OutputCodeLine(LDX_ZPY, fmt::format("ZP_TileIndex"));
	}

	int TileIndex = DYPPFinalData.ScreenToTileLookup[YCharPos][XCharPos];
	if (TileIndex >= 0)
	{
		if (bFirstOfColumn)
		{
			iFirstLine = YCharPos;
			bFirstOfColumn = false;
		}
		Code.OutputCodeLine(LDA_ABX, fmt::format("BIGDYPP_TileData_Tile{:d}", TileIndex));
		Code.OutputCodeLine(STA_ABY, fmt::format("ScreenAddress{:d} + ({:d} * 40)", (YCharPos >= YBankSplit) ? 1 : 0, YCharPos));
		iLastLine = YCharPos;
	}
}*/

void BIGDYPP_OutputRenderCodeASM(LPCTSTR OutputFilename_RenderASM)
{
	CodeGen RenderCode(OutputFilename_RenderASM);
	RenderCode.OutputFunctionLine(fmt::format("BIGDYPP_Render"));
	RenderCode.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	RenderCode.OutputBlankLine();

	int YBankSplit = DYPPFinalData.CharSet[3].YEndLine;

	int FirstLastLines[DYPP_CHAR_WIDTH][2];
	for (int XCharPos = 0; XCharPos < DYPP_CHAR_WIDTH; XCharPos++)
	{
		bool bLastColumn = (XCharPos == (DYPP_CHAR_WIDTH - 1));

		bool bFirst = true;
		int iFirstLine = -1;
		int iLastLine = 24;
		for (int YCharPos = 0; YCharPos < DYPP_CHAR_HEIGHT; YCharPos++)
		{
			int TileIndex = DYPPFinalData.ScreenToTileLookup[YCharPos][XCharPos];
			if (TileIndex >= 0)
			{
				if (bFirst)
				{
					iFirstLine = YCharPos;
					bFirst = false;
				}
				iLastLine = YCharPos;
			}
		}
		FirstLastLines[XCharPos][0] = iFirstLine;
		FirstLastLines[XCharPos][1] = iLastLine;
	}

	RenderCode.OutputFunctionLine(fmt::format("BIGDYPP_ClearColumns"));
	RenderCode.OutputCodeLine(LDX_ZPY, fmt::format("ZP_TileIndex"));
	RenderCode.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	for (int XCharPos = 0; XCharPos < DYPP_CHAR_WIDTH; XCharPos++)
	{
		int iFirstLine = FirstLastLines[XCharPos][0];
		int iLastLine = FirstLastLines[XCharPos][1];
		
		int iFirstLinePrev = FirstLastLines[(XCharPos + 1) % DYPP_CHAR_WIDTH][0];
		int iLastLinePrev = FirstLastLines[(XCharPos + 1) % DYPP_CHAR_WIDTH][1];

		int STAXorY = ((XCharPos & 1) == 0) ? STA_ABY : STA_ABX;

		for (int iLine = iFirstLinePrev; iLine < iFirstLine; iLine++)
		{
			RenderCode.OutputCodeLine(STAXorY, fmt::format("ScreenAddress{:d} + ({:d} * 40)", (iLine >= YBankSplit) ? 1 : 0, iLine));
		}
		for (int iLine = iLastLinePrev; iLine > iLastLine; iLine--)
		{
			RenderCode.OutputCodeLine(STAXorY, fmt::format("ScreenAddress{:d} + ({:d} * 40)", (iLine >= YBankSplit) ? 1 : 0, iLine));
		}
		RenderCode.OutputCodeLine(((XCharPos & 1) == 0) ? LDX_ABY : LDY_ABX, fmt::format("BIGDYPP_Add1Mod40"));
	}

	for (int XCharPos = 0; XCharPos < DYPP_CHAR_WIDTH; XCharPos++)
	{
		bool bLastColumn = (XCharPos == (DYPP_CHAR_WIDTH - 1));

		RenderCode.OutputFunctionLine(fmt::format("BIGDYPP_Render_Column{:d}", XCharPos));

		RenderCode.OutputCodeLine(LDX_ZPY, fmt::format("ZP_TileIndex"));

		bool bFirst = true;
		int iFirstLine = -1;
		int iLastLine = 24;
		for (int YCharPos = 0; YCharPos < DYPP_CHAR_HEIGHT; YCharPos++)
		{
			int TileIndex = DYPPFinalData.ScreenToTileLookup[YCharPos][XCharPos];
			if (TileIndex >= 0)
			{
				if (bFirst)
				{
					iFirstLine = YCharPos;
					bFirst = false;
				}
				RenderCode.OutputCodeLine(LDA_ABX, fmt::format("BIGDYPP_TileData_Tile{:d}", TileIndex));
				RenderCode.OutputCodeLine(STA_ABY, fmt::format("ScreenAddress{:d} + ({:d} * 40)", (YCharPos >= YBankSplit) ? 1 : 0, YCharPos));
				iLastLine = YCharPos;
			}
		}
		if (!bLastColumn)
		{
			RenderCode.OutputCodeLine(LDA_ABY, fmt::format("BIGDYPP_Add1Mod40"));
			RenderCode.OutputCodeLine(TAY);
		}
		RenderCode.OutputBlankLine();
	}
	RenderCode.OutputCodeLine(RTS);
}

void BIGDYPP_OutputCharData(LPCTSTR InputCharSetFilename, LPCTSTR InputTileSetFilename)
{
	unsigned char TileSet8By8[128][8][8];
	ZeroMemory(TileSet8By8, 128 * 8 * 8);

	int Num8x8Tiles = ReadBinaryFile(InputTileSetFilename, TileSet8By8, 128 * 8 * 8) / (8 * 8);
	int NumUniqueChars = ReadBinaryFile(InputCharSetFilename, CharSetData, 256 * 8);

	//; Determine which char in the charset is our SPACE char...
	unsigned char SpaceChar = 0xff;
	for (int CharIndex = 0; CharIndex < NumUniqueChars; CharIndex++)
	{
		bool bFound = true;
		for (int YPixel = 0; YPixel < 8; YPixel++)
		{
			if (CharSetData[CharIndex][YPixel] != 0)
			{
				bFound = false;
				break;
			}
		}
		if (bFound)
		{
			SpaceChar = (unsigned char)CharIndex;
			break;
		}
	}

	//; Convert from the 8x8 tiles to 16x8 tiles (what we actually need and, annoyingly, CharPad doesn't support)
	//; Calculate the width for each char at the same time
	unsigned char TileSet16x8[DYPP_FONT_NUMCHARS][8][16];
	ZeroMemory(TileSet16x8, DYPP_FONT_NUMCHARS * 16 * 8);

	memset(CharSetTileIndex, 0x3f, sizeof(CharSetTileIndex));

	int CurrentCharIndex = 1;
	int CurrentXPos = 0;
	for (int TileXTile8Index = 0; TileXTile8Index < Num8x8Tiles; TileXTile8Index++)
	{
		for (int TileXIndex = 0; TileXIndex < 8; TileXIndex++)
		{
			bool bHasChars = false;
			for (int TileYIndex = 0; TileYIndex < 8; TileYIndex++)
			{
				unsigned char CharValue = TileSet8By8[TileXTile8Index][TileYIndex][TileXIndex];
				if (CharValue != SpaceChar)
				{
					bHasChars = true;
				}
				TileSet16x8[CurrentCharIndex][TileYIndex][CurrentXPos] = CharValue;
			}
			if (!bHasChars)
			{
				if (CurrentXPos != 0)
				{
//;					if (CharRemap[CurrentCharIndex] != 255)
					{
						DYPPFinalData.CharWidth[CurrentCharIndex] = CurrentXPos;
						CurrentCharIndex++;
					}
					CurrentXPos = 0;
				}
				break;
			}
			else
			{
				CurrentXPos++;
			}
		}
	}
	
	//; Generate the deduped tile information
	ZeroMemory(Deduped1By8Tiles, DYPP_MAX_NUM_TILES * DYPP_FONT_CHAR_HEIGHT);
	NumDeduped1By8Tiles = 0;

	for (int CharIndex = 0; CharIndex < DYPP_FONT_NUMCHARS; CharIndex++)
	{
		for (int XCharPos = 0; XCharPos < DYPPFinalData.CharWidth[CharIndex]; XCharPos++)
		{
			int MatchingIndex = -1;
			for (int CheckIndex = 0; CheckIndex < NumDeduped1By8Tiles; CheckIndex++)
			{
				bool bMatch = true;
				for (int YCharPos = 0; YCharPos < DYPP_FONT_CHAR_HEIGHT; YCharPos++)
				{
					if (TileSet16x8[CharIndex][YCharPos][XCharPos] != Deduped1By8Tiles[CheckIndex][YCharPos])
					{
						bMatch = false;
						break;
					}
				}
				if (bMatch)
				{
					MatchingIndex = CheckIndex;
					break;
				}
			}
			if (MatchingIndex < 0)
			{
				MatchingIndex = NumDeduped1By8Tiles;
				NumDeduped1By8Tiles++;

				for (int YCharPos = 0; YCharPos < DYPP_FONT_CHAR_HEIGHT; YCharPos++)
				{
					Deduped1By8Tiles[MatchingIndex][YCharPos] = TileSet16x8[CharIndex][YCharPos][XCharPos];
				}
			}
			CharSetTileIndex[CharIndex][XCharPos] = MatchingIndex;
		}
	}

	DYPPFinalData.CharWidth[63] = DYPP_SPACEWIDTH;
}

void BIGDYPP_RemapScrollText(void)
{
	unsigned char CharUsed[64];
	ZeroMemory(CharUsed, 64);

	for (int ScrollTextindex = 0; ScrollTextindex < SizeDYPPScrollText; ScrollTextindex++)
	{
		char& CurrentChar = DYPPScrollText[ScrollTextindex];
		switch (CurrentChar)
		{

		case '!':
			CurrentChar = 27;
			break;

		case '?':
			CurrentChar = 28;
			break;

		case '.':
			CurrentChar = 29;
			break;

		case ',':
			CurrentChar = 30;
			break;

		case '-':
			CurrentChar = 31;
			break;

		case ' ':
			CurrentChar = 63;
			break;

		default:
			unsigned char NumLookup[10] = { 41, 32, 33, 34, 35, 36, 37, 38, 39, 40 };
			if ((CurrentChar >= '0') && (CurrentChar <= '9'))
			{
				CurrentChar = NumLookup[CurrentChar - '0'];
			}
			else
			{
				CurrentChar &= 31;
			}
			break;
		}

		CharUsed[CurrentChar] = 1;
	}

	int RemapIndex = 0;
	for (int Index = 0; Index < 64; Index++)
	{
		if (CharUsed[Index])
		{
			CharRemap[Index] = RemapIndex++;
		}
		else
		{
			CharRemap[Index] = 255;
		}
	}

/*	for (int ScrollTextindex = 0; ScrollTextindex < SizeDYPPScrollText; ScrollTextindex++)
	{
		char& CurrentChar = DYPPScrollText[ScrollTextindex];
		CurrentChar = CharRemap[CurrentChar];
	}*/
}

void BIGDYPP_OutputScrollText(LPCTSTR OutputScrollTextData)
{
	int SizeUnrolledScrollData = 0;
	unsigned char UnrolledScrollData[1024];
	for (int ScrollTextindex = 0; ScrollTextindex < SizeDYPPScrollText; ScrollTextindex++)
	{
		char& CurrentChar = DYPPScrollText[ScrollTextindex];
		for (int XPos = 0; XPos < DYPPFinalData.CharWidth[CurrentChar]; XPos++)
		{
			unsigned char TileIndex = CharSetTileIndex[CurrentChar][XPos];
			UnrolledScrollData[SizeUnrolledScrollData++] = TileIndex;
		}
		UnrolledScrollData[SizeUnrolledScrollData++] = 63;
	}
	UnrolledScrollData[SizeUnrolledScrollData++] = 255;

	WriteBinaryFile(OutputScrollTextData, UnrolledScrollData, SizeUnrolledScrollData);
}

int BIGDYPP_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass)
{
	int WastedCycles = 0;

	static bool bFirst = true;
	if (bFirst)
	{
		bFirst = false;
	}

//;	DYPP_InsertSpriteBlitCode(code, NumCycles, bFirstPass);

	if (NumCycles == -1)
	{
		return 0;
	}
	if (NumCycles == 1)
	{
		return 0;	//; BIG PROBLEM!!
	}

	static int LoopHereCounter = 0;
	{
		int BNECostNotTaken = 2;

		int Cycles, Offset;
		code.QueryCounters(Cycles, Offset);
		int Page0 = (Offset + 2) / 256;	//; this is the Label we branch to
		int Page1 = (Offset + 5) / 256;	//; this is the address after the BNE
		bool bCrossingPageBoundary = (Page0 != Page1);
		int BNECostTaken = BNECostNotTaken + 1;
		if (bCrossingPageBoundary)
		{
			BNECostTaken++;
		}

		int XCount = (NumCycles - (2 + 2 + BNECostNotTaken)) / (2 + BNECostTaken);

		int NewNumCycles = NumCycles - (((BNECostTaken + 2) * XCount) + (2 + 2 + BNECostNotTaken));
		if (NewNumCycles == 1)
		{
			XCount--;
			NewNumCycles = NumCycles - (((BNECostTaken + 2) * XCount) + (2 + 2 + BNECostNotTaken));
		}
		if (XCount > 0)
		{
			do 
			{
				int XCountModded = XCount % 256;
				code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", XCount + 1));
				code.OutputFunctionLine(fmt::format("LoopHere{:d}", LoopHereCounter));
				code.OutputCodeLine(DEX);
				code.OutputCodeLine(BNE, fmt::format("LoopHere{:d}", LoopHereCounter++));
				XCount -= XCountModded;
			} while (XCount > 0);
			WastedCycles += NumCycles - NewNumCycles;
			NumCycles = NewNumCycles;
		}
	}

	if (NumCycles & 1)
	{
		int CyclesTaken = code.OutputCodeLine(NOP_ZP, fmt::format("$ff"));
		NumCycles -= CyclesTaken;
		WastedCycles += CyclesTaken;
	}
	while (NumCycles >= 2)
	{
		int CyclesTaken = code.OutputCodeLine(NOP);
		NumCycles -= CyclesTaken;
		WastedCycles += CyclesTaken;
	}
	return WastedCycles;
}

#define BIGDYPP_WOBBLEHEIGHT 45
void BIGDYPP_OutputCode(LPCTSTR Filename)
{
	int SinValues[BIGDYPP_WOBBLEHEIGHT];
	GenerateSinTable(BIGDYPP_WOBBLEHEIGHT, 0, 3, 0, SinValues);

	CodeGen code(Filename);

	code.OutputFunctionLine(fmt::format("BIGDYPP_RasterCode"));

	int CurrentD018Split = 0;

	int LastSinX = -1;

	int NumCyclesToWaste = 0;

	for (int CharLine = 0; CharLine < 25; CharLine++)
	{
		int RasterLine = CharLine * 8;

		int SinX = SinValues[RasterLine % BIGDYPP_WOBBLEHEIGHT];

		int UsedCycles = 0;
		if (SinX != LastSinX)
		{
			if (NumCyclesToWaste > 0)
			{
				BIGDYPP_UseCycles(code, NumCyclesToWaste, true);
				NumCyclesToWaste = 0;
			}
			UsedCycles += code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SinX));
			UsedCycles += code.OutputCodeLine(ORA_ZP, fmt::format("ZP_D016Value"));
			UsedCycles += code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
			LastSinX = SinX;
		}
		if (RasterLine == 0)
		{
			NumCyclesToWaste -= 8;
		}

		if (RasterLine == (DYPPFinalData.CharSet[CurrentD018Split].YEndLine * 8))
		{
			if (NumCyclesToWaste > 0)
			{
				BIGDYPP_UseCycles(code, NumCyclesToWaste, true);
				NumCyclesToWaste = 0;
			}

			CurrentD018Split++;
			if (CurrentD018Split == 4)
			{
				UsedCycles += code.OutputCodeLine(LDA_IMM, fmt::format("#DD02Value1"));
				UsedCycles += code.OutputCodeLine(STA_ABX, fmt::format("VIC_DD02"));
			}
			UsedCycles += code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentD018Split));
			UsedCycles += code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		}

		NumCyclesToWaste += 20 - UsedCycles;

//;		BIGDYPP_UseCycles(code, NumCyclesToWaste, true);

		RasterLine++;

		for (int YLine = 1; YLine < 8; YLine++)
		{
			bool bLastLine = (CharLine == 24) && (YLine == 7);

//;			int NumCyclesToWaste = 63;

			int SinX = SinValues[RasterLine % BIGDYPP_WOBBLEHEIGHT];
			if (SinX != LastSinX)
			{
				if (NumCyclesToWaste > 0)
				{
					BIGDYPP_UseCycles(code, NumCyclesToWaste, true);
					NumCyclesToWaste = 0;
				}
				code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SinX));
				code.OutputCodeLine(ORA_ZP, fmt::format("ZP_D016Value"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
				LastSinX = SinX;
				NumCyclesToWaste -= 2 + 3 + 4;
			}
			NumCyclesToWaste += 63;

			RasterLine++;
		}
	}
	code.OutputCodeLine(RTS);
}

int BIGDYPP_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\BIGDYPP");

	ZeroMemory(&DYPPFinalData, sizeof(BIGDYPP_FINALDATA));

	BIGDYPP_RemapScrollText();
	BIGDYPP_OutputCharData(L"..\\..\\Build\\Parts\\BigDYPP\\Data\\charset.bin", L"..\\..\\Build\\Parts\\BigDYPP\\Data\\tileset.bin");
	BIGDYPP_CalculateDYPPChars();
	BIGDYPP_OutputRenderCodeASM(L"..\\..\\Intermediate\\Built\\BigDYPP\\Render.asm");
	BIGDYPP_OutputTileDataASM(L"..\\..\\Intermediate\\Built\\BigDYPP\\TileData.asm");
	BIGDYPP_OutputD018SplitDefinesASM(L"..\\..\\Intermediate\\Built\\BigDYPP\\D018SplitDefines.asm");
	BIGDYPP_OutputScrollText(L"..\\..\\Intermediate\\Built\\BigDYPP\\ScrollTextUnrolled.bin");

	BIGDYPP_OutputCode(L"..\\..\\Intermediate\\Built\\BigDYPP\\RasterCode.asm");

	return 0;
}
