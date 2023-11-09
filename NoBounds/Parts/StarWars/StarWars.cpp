// (c) Genesis*Project

#include "..\Common\Common.h"

static const int TopBackgroundColour = 0x0a;
static const int MidBackgroundColour = 0x07;
static const int BottomBackgroundColour = 0x02;
static const int OuterBackgroundColour = 0x00;

#define STARWARS_FONT_WIDTH 720
#define STARWARS_FONT_HEIGHT 16

#define NUM_CHARS_ON_LINE 16
#define SCREEN_X_CHARSTART (20 - NUM_CHARS_ON_LINE)

#define STARWARS_FONT_CHAR_WIDTH 16
#define STARWARS_FONT_CHAR_HEIGHT 16
#define STARWARS_FONT_NUM_CHARS_X (STARWARS_FONT_WIDTH / STARWARS_FONT_CHAR_WIDTH)
#define STARWARS_FONT_NUM_CHARS_Y (STARWARS_FONT_HEIGHT / STARWARS_FONT_CHAR_HEIGHT)
#define STARWARS_FONT_NUM_CHARS (STARWARS_FONT_NUM_CHARS_X * STARWARS_FONT_NUM_CHARS_Y)

#define STARWARS_YCHAR_STRIDE (STARWARS_FONT_WIDTH / 8)

#define STARWARS_MAX_WIDTH (NUM_CHARS_ON_LINE * 16)
#define STARWARS_HALF_MAX_WIDTH (STARWARS_MAX_WIDTH / 2)

#define STARWARS_HEIGHT 120
#define STARWARS_BYTE_WIDTH (STARWARS_MAX_WIDTH / 8)
#define STARWARS_STARTYPOS 100

#define UPPER_MAX_NUM_UNIQUESHORTS 64
#define MAX_NUM_UNIQUESHORTS 32
#define MAX_NUM_UNIQUEBYTESETS 4096

#define MAX_NUM_UNIQUEPIXELMAPPINGS 4096

#define MAX_NUM_CHARS_IN_FONT 32

#define MAX_NUM_CHARS_ON_SINGLE_BYTE 2

unsigned char ScrollText[] = {
	"no pain nor gain"
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"   no worries   "
	"                "
	"   nor regret   "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"   no strings   "
	"                "
	"    attached    "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
 	"                "
	"                "
	"\xff"
/*
	" you will learn "
	"                "
	"  from history  "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"and will prepare"
	"                "
	" for the future "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"   but always   "
	"                "
	"     please     "
	"                "
	" live for today "
	"                "
	"                "
	"                "
	"                "
	"                "
	"                "
	"\xff"
*/ 
};
static const int ScrollTextNumLines = sizeof(ScrollText) / NUM_CHARS_ON_LINE;

class STARWARS_SCREENBYTE
{
public:
	int NumCharVals;
	unsigned char CharVal[MAX_NUM_CHARS_ON_SINGLE_BYTE];
	unsigned char PixelMapping[MAX_NUM_CHARS_ON_SINGLE_BYTE][8];
	int FontMapping[MAX_NUM_CHARS_ON_SINGLE_BYTE];
};
class STARWARS_DATA
{
public:
	STARWARS_SCREENBYTE ScreenByte[STARWARS_HEIGHT][STARWARS_BYTE_WIDTH];

	int NumUniquePixelMappings;
	unsigned char UniquePixelMappings[MAX_NUM_UNIQUEPIXELMAPPINGS][8];

	int NumUniqueShorts;
	unsigned short UniqueShorts[UPPER_MAX_NUM_UNIQUESHORTS];

	int NumUniqueByteSets;
	unsigned char UniqueByteSets[MAX_NUM_UNIQUEBYTESETS][MAX_NUM_UNIQUESHORTS];
} StarWarsData;

unsigned char UsedChars[64];

unsigned char CharRemapping[64];
unsigned char CharUnremapping[64];
int TotalNumCharsUsed;


void StarWars_GenerateData()
{
	ZeroMemory(&StarWarsData, sizeof(StarWarsData));

	int* ScreenToPixelLookup = new int[STARWARS_MAX_WIDTH * STARWARS_HEIGHT];
	memset(ScreenToPixelLookup, -1, STARWARS_MAX_WIDTH * STARWARS_HEIGHT * sizeof(int));

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		int YScreenPos = STARWARS_HEIGHT - 1 - YPos;

		double SinusWidth = sin(YPos * PI / STARWARS_HEIGHT);
		double Width = (0.5 + SinusWidth * 0.5) * (STARWARS_MAX_WIDTH + 1);
		Width = min(STARWARS_MAX_WIDTH, Width);
		double HalfWidth = Width / 2;
		int XMid = STARWARS_MAX_WIDTH / 2;

		for (int XPos = 0; XPos < HalfWidth; XPos++)
		{
			int XScreenPos0 = (XMid + 0) + XPos;
			int XScreenPos1 = (XMid - 1) - XPos;

			double LookupVal = (double)XPos / HalfWidth;

			int XLookupPos0 = (int)floor((double)STARWARS_HALF_MAX_WIDTH + (LookupVal * (double)(STARWARS_HALF_MAX_WIDTH - 1)));
			ScreenToPixelLookup[YScreenPos * STARWARS_MAX_WIDTH + XScreenPos0] = XLookupPos0;

			int XLookupPos1 = (int)floor((double)(STARWARS_HALF_MAX_WIDTH - 1) - (LookupVal * (double)(STARWARS_HALF_MAX_WIDTH - 1)));
			ScreenToPixelLookup[YScreenPos * STARWARS_MAX_WIDTH + XScreenPos1] = XLookupPos1;
		}
	}

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		for (int XBytePos = 0; XBytePos < STARWARS_BYTE_WIDTH; XBytePos++)
		{
			STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];
			memset(rScreenByte.PixelMapping, 255, 8 * MAX_NUM_CHARS_ON_SINGLE_BYTE);

			for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
			{
				int XPos = (XBytePos * 8) + XPixelPos;

				int XLookupPos = ScreenToPixelLookup[YPos * STARWARS_MAX_WIDTH + XPos];
				if (XLookupPos != -1)
				{
					int XByteLookup = XLookupPos / 16;
					int XPixelLookup = XLookupPos % 16;

					//; first and last pixel are always zero - so let's ignore these..
					if ((XPixelLookup == 0) || (XPixelLookup == 15))
					{
						continue;
					}

					int FoundCharVal = -1;
					for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
					{
						if (rScreenByte.CharVal[CharValIndex] == XByteLookup)
						{
							FoundCharVal = CharValIndex;
							break;
						}
					}
					if (FoundCharVal < 0)
					{
						FoundCharVal = rScreenByte.NumCharVals;
						if (FoundCharVal < MAX_NUM_CHARS_ON_SINGLE_BYTE)
						{
							rScreenByte.CharVal[FoundCharVal] = XByteLookup;
							rScreenByte.NumCharVals++;
						}
						else
						{
							FoundCharVal = -1; //; ERROR!
						}
					}

					if ((FoundCharVal >= 0) && (FoundCharVal < MAX_NUM_CHARS_ON_SINGLE_BYTE))
					{
						rScreenByte.PixelMapping[FoundCharVal][XPixelPos] = XPixelLookup;
					}
				}
			}
		}
	}

	delete[] ScreenToPixelLookup;
}

void StarWars_ProcessFont(LPTSTR InputMAPFilename, LPTSTR OutputFilename_RemappedFont)
{
	int SizeRemppedFont = STARWARS_FONT_HEIGHT * TotalNumCharsUsed;
	unsigned char* RemappedFont = new unsigned char[SizeRemppedFont];
	ZeroMemory(RemappedFont, SizeRemppedFont);

	unsigned char FontData[256 * 8];
	ZeroMemory(FontData, sizeof(FontData));
	int FontData_Size = ReadBinaryFile(InputMAPFilename, FontData, sizeof(FontData));
	int ActualNumCharsInFont = FontData_Size / (STARWARS_FONT_HEIGHT * 2);
	int NumCharsInFont = min(MAX_NUM_CHARS_IN_FONT, ActualNumCharsInFont);

	//; Pass 1: Figure out all the unique shorts from the font...
	for (int i = 0; i < TotalNumCharsUsed; i++)
	{
		int FontCharIndex = CharUnremapping[i];

		for (int YPos = 0; YPos < STARWARS_FONT_HEIGHT; YPos++)
		{
			unsigned char Byte0 = FontData[((YPos / 8) * ActualNumCharsInFont * STARWARS_FONT_HEIGHT) + (FontCharIndex * STARWARS_FONT_HEIGHT) + 0 + (YPos & 7)];
			unsigned char Byte1 = FontData[((YPos / 8) * ActualNumCharsInFont * STARWARS_FONT_HEIGHT) + (FontCharIndex * STARWARS_FONT_HEIGHT) + 8 + (YPos & 7)];
			unsigned short ShortValue = (((unsigned short)Byte0) << 8) | (((unsigned short)Byte1) << 0);

			int FoundShortIndex = -1;
			for (int ShortCheckIndex = 0; ShortCheckIndex < StarWarsData.NumUniqueShorts; ShortCheckIndex++)
			{
				if (StarWarsData.UniqueShorts[ShortCheckIndex] == ShortValue)
				{
					FoundShortIndex = ShortCheckIndex;
					break;
				}
			}
			if (FoundShortIndex == -1)
			{
				if (StarWarsData.NumUniqueShorts < UPPER_MAX_NUM_UNIQUESHORTS)
				{
					FoundShortIndex = StarWarsData.NumUniqueShorts;
					StarWarsData.UniqueShorts[FoundShortIndex] = ShortValue;

					StarWarsData.NumUniqueShorts++;
				}
				else
				{
					FoundShortIndex = 0;

					//; ERROR!
				}
			}
			RemappedFont[YPos * TotalNumCharsUsed + i] = (unsigned char)FoundShortIndex;
		}
	}
	StarWarsData.NumUniqueShorts = min(MAX_NUM_UNIQUESHORTS, StarWarsData.NumUniqueShorts);

	WriteBinaryFile(OutputFilename_RemappedFont, RemappedFont, STARWARS_FONT_HEIGHT * TotalNumCharsUsed);
}

static const int NumUniquesToIndex = 24;	//; <-- how to calc this?

void StarWars_OutputByteSetUniquesASM(LPTSTR OutputFilename_SWUniquesASM)
{
	CodeGen SWUniquesCode(OutputFilename_SWUniquesASM);

	SWUniquesCode.OutputCodeLine(NONE, fmt::format(".var SCROLLTEXT_LINE_LENGTH = {:d}", NUM_CHARS_ON_LINE));
	SWUniquesCode.OutputBlankLine();

	SWUniquesCode.OutputFunctionLine(fmt::format("SW_FontLookupTableLo"));
	SWUniquesCode.OutputCodeLine(NONE, fmt::format(".fill 16, <(RemappedFont + (i * {:d}))", TotalNumCharsUsed));
	SWUniquesCode.OutputFunctionLine(fmt::format("SW_FontLookupTableHi"));
	SWUniquesCode.OutputCodeLine(NONE, fmt::format(".fill 16, >(RemappedFont + (i * {:d}))", TotalNumCharsUsed));
	SWUniquesCode.OutputBlankLine();

	int TotalUniqueByteDataSize = 0;

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		for (int XBytePos = 0; XBytePos < STARWARS_BYTE_WIDTH; XBytePos++)
		{
			STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];

			for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
			{
				unsigned char FormedBytes[MAX_NUM_UNIQUESHORTS];
				memset(FormedBytes, 0xff, sizeof(FormedBytes));

				for (int UniqueShortIndex = 0; UniqueShortIndex < StarWarsData.NumUniqueShorts; UniqueShortIndex++)
				{
					unsigned short UniqueShort = StarWarsData.UniqueShorts[UniqueShortIndex];
					for (int XPixel = 0; XPixel < 8; XPixel++)
					{
						if (rScreenByte.PixelMapping[CharValIndex][XPixel] != 255)
						{
							int BitShift = 15 - rScreenByte.PixelMapping[CharValIndex][XPixel];
							unsigned short BitMask = 1 << BitShift;
							if (UniqueShort & BitMask)
							{
								FormedBytes[UniqueShortIndex] -= 1 << (7 - XPixel);
							}
						}
					}
				}

				int MatchIndex = -1;
				for (int UniqueByteSetIndex = 0; UniqueByteSetIndex < StarWarsData.NumUniqueByteSets; UniqueByteSetIndex++)
				{
					MatchIndex = UniqueByteSetIndex;
					for (int UniqueShortIndex = 0; UniqueShortIndex < StarWarsData.NumUniqueShorts; UniqueShortIndex++)
					{
						if (StarWarsData.UniqueByteSets[UniqueByteSetIndex][UniqueShortIndex] != FormedBytes[UniqueShortIndex])
						{
							MatchIndex = -1;
							break;
						}
					}
					if (MatchIndex >= 0)
					{
						break;
					}
				}
				if (MatchIndex < 0)
				{
					MatchIndex = StarWarsData.NumUniqueByteSets;
					StarWarsData.NumUniqueByteSets++;

					for (int UniqueShortIndex = 0; UniqueShortIndex < StarWarsData.NumUniqueShorts; UniqueShortIndex++)
					{
						StarWarsData.UniqueByteSets[MatchIndex][UniqueShortIndex] = FormedBytes[UniqueShortIndex];
					}

					int ByteDataSizeModded = TotalUniqueByteDataSize % 256;
					int BytesLeftOnPage = 256 - ByteDataSizeModded;
					if (BytesLeftOnPage < NumUniquesToIndex)
					{
						SWUniquesCode.OutputCodeLine(NONE, fmt::format(".fill {:d}, $00", BytesLeftOnPage));
						TotalUniqueByteDataSize += BytesLeftOnPage;
					}

					SWUniquesCode.OutputFunctionLine(fmt::format("FontData_{:d}", MatchIndex));

					SWUniquesCode.OutputByteBlock(FormedBytes, NumUniquesToIndex, NumUniquesToIndex);
					TotalUniqueByteDataSize += NumUniquesToIndex;
				}
				rScreenByte.FontMapping[CharValIndex] = MatchIndex;
			}
		}
	}
	SWUniquesCode.OutputCommentLine(fmt::format("//;Total Size: {:d}", TotalUniqueByteDataSize));
}

void StarWars_OutputPlotterASM(LPTSTR OutputFilename_StarWarsPlotterASM)
{
	CodeGen PlotterCode(OutputFilename_StarWarsPlotterASM);

	PlotterCode.OutputCodeLine(NONE, fmt::format(".var BGColourTop = ${:02x}", TopBackgroundColour));
	PlotterCode.OutputCodeLine(NONE, fmt::format(".var BGColourMid = ${:02x}", MidBackgroundColour));
	PlotterCode.OutputCodeLine(NONE, fmt::format(".var BGColourBottom = ${:02x}", BottomBackgroundColour));
	PlotterCode.OutputCodeLine(NONE, fmt::format(".var BGColourOuter = ${:02x}", OuterBackgroundColour));

	int CurrentCharVal = -1;
	PlotterCode.OutputFunctionLine(fmt::format("StarWarsPlotter"));
	PlotterCode.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	PlotterCode.OutputCodeLine(INC_ABS, fmt::format("StarWarsPlotter + 1"));

	double INYPos = 0;
	unsigned int VirtualYPos[STARWARS_HEIGHT];
	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		double fYPos = abs(STARWARS_HEIGHT * 0.5 - YPos);
		INYPos += 0.5 + ((1.2 * fYPos) / (double)(STARWARS_HEIGHT * 0.5));
		VirtualYPos[YPos] = (unsigned int)floor(INYPos);
	}

	static const int RepeatLines[32] = {
		1,
		3,
		5,
		8,
		11,
		14,
		STARWARS_HEIGHT - 2,
		STARWARS_HEIGHT - 4,
		STARWARS_HEIGHT - 6,
		STARWARS_HEIGHT - 9,
		STARWARS_HEIGHT - 12,
		STARWARS_HEIGHT - 15,
	};
	static const int NumRepeatLines = sizeof(RepeatLines) / sizeof(RepeatLines[0]);

	for (int i = 0; i < NumRepeatLines; i++)
	{
		int RepLine = RepeatLines[i];
		VirtualYPos[RepLine] |= 0x80000000; //; = 0x80000000 + VirtualYPos[RepLine + 1];
	}

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		PlotterCode.OutputFunctionLine(fmt::format("PlotLine{:d}", YPos));
		int NumINY = 0;
		if (YPos > 0)
		{
			unsigned int VY = VirtualYPos[YPos] & 0x7fffffff;
			unsigned int VYPrev = VirtualYPos[YPos - 1] & 0x7fffffff;

			NumINY = VY - VYPrev;
			for (int INYIndex = 0; INYIndex < NumINY; INYIndex++)
			{
				PlotterCode.OutputCodeLine(INX);
			}
		}

		bool bVYUsed = (VirtualYPos[YPos] & 0x80000000) == 0;
		if (bVYUsed)
		{
			for (int XBytePos = 0; XBytePos < STARWARS_BYTE_WIDTH; XBytePos++)
			{
				STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];
				if (rScreenByte.NumCharVals == 0)
				{
					continue;
				}

				bool bMatch = false;
				if (YPos < (STARWARS_HEIGHT - 1))
				{
					bool bVYNextUsed = (VirtualYPos[YPos + 1] & 0x80000000) == 0;

					if (bVYNextUsed)
					{
						unsigned int VY = VirtualYPos[YPos] & 0x7fffffff;
						unsigned int VYNext = VirtualYPos[YPos + 1] & 0x7fffffff;

						unsigned int NextNumINY = VYNext - VY;

						if (NextNumINY == 1)
						{
							bMatch = true;
							STARWARS_SCREENBYTE& rScreenByteNext = StarWarsData.ScreenByte[YPos + 1][XBytePos];
							for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
							{
								if (rScreenByte.FontMapping[CharValIndex] != rScreenByteNext.FontMapping[CharValIndex])
								{
									bMatch = false;
								}
							}
						}

						if ((VirtualYPos[YPos] & 0x80000000) || (VirtualYPos[YPos + 1] & 0x80000000))
						{
							bMatch = false;
						}
					}
				}
				int YPos0 = YPos + 39;
				if (bMatch)
				{
					PlotterCode.OutputCodeLine(LDA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", (YPos0 + 1) / 8, XBytePos + SCREEN_X_CHARSTART, (YPos0 + 1) % 8));
				}
				else
				{
					for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
					{
						if (rScreenByte.CharVal[CharValIndex] != CurrentCharVal)
						{
							CurrentCharVal = rScreenByte.CharVal[CharValIndex];
							PlotterCode.OutputCodeLine(LDY_ABX, fmt::format("ScrollData + ({:d} * $100)", CurrentCharVal));
							if (CurrentCharVal == 0)
							{
								PlotterCode.OutputCodeLine(BPL, fmt::format("PlotLine{:d}_Yes", YPos));
								if ((YPos + 1) < STARWARS_HEIGHT)
								{
									PlotterCode.OutputCodeLine(JMP_ABS, fmt::format("PlotLine{:d}", YPos + 1));
								}
								else
								{
									PlotterCode.OutputCodeLine(RTS);
								}
								PlotterCode.OutputFunctionLine(fmt::format("PlotLine{:d}_Yes", YPos));
							}
						}
						PlotterCode.OutputCodeLine((CharValIndex == 0) ? LDA_ABY : AND_ABY, fmt::format("FontData_{:d}", rScreenByte.FontMapping[CharValIndex]));
					}
				}
				PlotterCode.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos0 / 8, XBytePos + SCREEN_X_CHARSTART, YPos0 % 8));
			}
		}
	}
	PlotterCode.OutputFunctionLine(fmt::format("PlotLines_Finished"));
	PlotterCode.OutputCodeLine(RTS);
}

void StarWars_OutputScrollText(LPTSTR OutputFilename_StarWarsScrollTextBIN)
{
	ZeroMemory(UsedChars, sizeof(UsedChars));
	for (int LineIndex = 0; LineIndex < ScrollTextNumLines; LineIndex++)
	{
		bool bLineHasChars = false;
		for (int CharIndex = 0; CharIndex < NUM_CHARS_ON_LINE; CharIndex++)
		{
			unsigned char& CurrentChar = ScrollText[LineIndex * NUM_CHARS_ON_LINE + CharIndex];
			if (CurrentChar != ' ')
			{
				bLineHasChars = true;
				break;
			}
		}
		if (!bLineHasChars)
		{
			for (int CharIndex = 0; CharIndex < NUM_CHARS_ON_LINE; CharIndex++)
			{
				unsigned char& CurrentChar = ScrollText[LineIndex * NUM_CHARS_ON_LINE + CharIndex];
				CurrentChar = 0x80;
			}
		}
		else
		{
			for (int CharIndex = 0; CharIndex < NUM_CHARS_ON_LINE; CharIndex++)
			{
				unsigned char& CurrentChar = ScrollText[LineIndex * NUM_CHARS_ON_LINE + CharIndex];
				if (CurrentChar == '.')
				{
					CurrentChar = 28;
				}
				else
				{
					if (CurrentChar == '!')
					{
						CurrentChar = 29;
					}
					else
					{
						if (CurrentChar == '-')
						{
							CurrentChar = 27;
						}
						else
						{
							if (CurrentChar == ',')
							{
								CurrentChar = 30;
							}
							else
							{
								CurrentChar = CurrentChar & 31;
								if (CurrentChar > 26)
								{
									CurrentChar = 0;
								}
							}
						}
					}
				}
			}
		}
	}

	for (int i = 0; i < ScrollTextNumLines * NUM_CHARS_ON_LINE; i++)
	{
		unsigned char ThisChar = ScrollText[i];
		if (ThisChar < 64)
		{
			UsedChars[ThisChar] = 1;
		}
	}

	unsigned char CurrentChar = 0;
	for (int i = 0; i < 64; i++)
	{
		if (UsedChars[i] == 0)
		{
			CharRemapping[i] = 0xff;
		}
		else
		{
			CharRemapping[i] = CurrentChar;
			CharUnremapping[CurrentChar] = i;
			CurrentChar++;
		}
	}

	for (int i = 0; i < ScrollTextNumLines * NUM_CHARS_ON_LINE; i++)
	{
		unsigned char InChar = ScrollText[i];
		if (InChar < 64)
		{
			ScrollText[i] = CharRemapping[InChar];
		}
	}

	TotalNumCharsUsed = CurrentChar;

	WriteBinaryFile(OutputFilename_StarWarsScrollTextBIN, ScrollText, ScrollTextNumLines * NUM_CHARS_ON_LINE + 1);
}

void StarWars_OutputScreenBIN(LPTSTR OutputFilename_ScreenBIN)
{
	unsigned char ScreenData[25][40];
	unsigned char ScreenCols[25] =
	{
		TopBackgroundColour * 0x11,
		TopBackgroundColour * 0x11,
		TopBackgroundColour * 0x11,
		TopBackgroundColour * 0x11,
		TopBackgroundColour * 0x11,
		0x0c + TopBackgroundColour * 0x10,
		0x0c + TopBackgroundColour * 0x10,
		0x03 + TopBackgroundColour * 0x10,
		0x03 + TopBackgroundColour * 0x10,
		0x0d + TopBackgroundColour * 0x10,
		0x01 + TopBackgroundColour * 0x10,
		0x01 + TopBackgroundColour * 0x10,
		0x01 + MidBackgroundColour * 0x10,
		0x01 + BottomBackgroundColour * 0x10,
		0x01 + BottomBackgroundColour * 0x10,
		0x07 + BottomBackgroundColour * 0x10,
		0x07 + BottomBackgroundColour * 0x10,
		0x0c + BottomBackgroundColour * 0x10,
		0x08 + BottomBackgroundColour * 0x10,
		0x08 + BottomBackgroundColour * 0x10,
		BottomBackgroundColour * 0x11,
		BottomBackgroundColour * 0x11,
		BottomBackgroundColour * 0x11,
		BottomBackgroundColour * 0x11,
		BottomBackgroundColour * 0x11,
	};
	for (int Y = 0; Y < 25; Y++)
	{
		unsigned char LineCol = ScreenCols[Y];
		memset(ScreenData[Y], LineCol, 40);
	}
	WriteBinaryFile(OutputFilename_ScreenBIN, ScreenData, 1000);
}

void StarWars_GenSpriteData(LPTSTR OutputFilename_SpriteDataBIN)
{
	static const unsigned char ColToByte[4] = { 0x00, 0x55, 0xaa, 0xff };
	unsigned char SpriteRowCols[5][21] = {
		{ 1,1,1,0,1,0,0,0,   0,0,0,0,2,0,0,3,   0,3,0,0,0 }, //; 1 = 0x5, 2 = 0x3, 3 = 0xC
		{ 1,0,0,1,0,0,0,0,   0,0,0,0,0,0,1,1,   0,0,1,0,0 }, //; 1 = 0xD
		{ 1,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,   0,2,0,0,0 }, //; 1 = 0xD, 2 = 0x7
		{ 1,0,0,1,0,2,0,0,   0,0,0,0,0,0,3,0,   3,3,0,3,0 }, //; 1 = 0x7, 2 = 0x1, 3 = 0xC
		{ 1,0,0,1,1,0,0,0,   0,0,0,2,0,2,2,0,   0,0,0,0,0 }, //; 1 = 0xC, 2 = 0xE
	};

	unsigned char OutSpriteData[5][64];
	ZeroMemory(OutSpriteData, sizeof(OutSpriteData));

	for (int SpriteIndex = 0; SpriteIndex < 5; SpriteIndex++)
	{
		for (int y = 0; y < 21; y++)
		{
			unsigned char Col = SpriteRowCols[SpriteIndex][y];
			unsigned char OutByte = ColToByte[Col];

			for (int x = 0; x < 3; x++)
			{
				OutSpriteData[SpriteIndex][y * 3 + x] = OutByte;
			}
		}
	}
	WriteBinaryFile(OutputFilename_SpriteDataBIN, OutSpriteData, sizeof(OutSpriteData));
}

void StarWars_GenerateRasterColourFade(LPTSTR OutputFilename_InitialRasterColoursBIN, LPTSTR OutputFilename_RasterTransBIN)
{
	unsigned char CurrentColours[256];
	ZeroMemory(CurrentColours, sizeof(CurrentColours));
	memset(&CurrentColours[ 0 + 28], 0x0a, 96);
	memset(&CurrentColours[96 + 28], 0x07, 8);
	memset(&CurrentColours[104 + 28], 0x02, 96);
	WriteBinaryFile(OutputFilename_InitialRasterColoursBIN, CurrentColours, sizeof(CurrentColours));

	unsigned char OutBytes[3][256];
	memset(&OutBytes[0][0], 0xff, 256);
	unsigned char ClearedLines[256];
	ZeroMemory(ClearedLines, sizeof(ClearedLines));

	for (int i = 0; i < 256; i++)
	{
		if (i < 200)
		{
			int iLine = -1;
			while (iLine < 0)
			{
				int iTry = rand() % 200;
				if (!ClearedLines[iTry])
				{
					iLine = iTry;
				}
			}
			OutBytes[0][i] = iLine;
			ClearedLines[iLine] = 1;
		}
		else
		{
			OutBytes[0][i] = 255;
		}

		double HeightSinus = 200.0 - sin((PI * 0.5 * (double)i) / 256.0) * 196.0;

		double WaveAmplitude = 32.0 - sin((PI * 0.5 * (double)i) / 256.0) * 32.0;
		double WaveSinus = sin((PI * 5.5 * (double)i) / 256.0) * WaveAmplitude;

		int Y0 = (int)(100.0 - HeightSinus * 0.5 - WaveSinus * 0.5);
		int Y1 = (int)(Y0 + HeightSinus + WaveSinus * 0.5);

		Y0 = min(max(Y0, 0), 199);
		Y1 = min(max(Y1, 1), 200);

		OutBytes[1][i] = (unsigned char)Y0;
		OutBytes[2][i] = (unsigned char)Y1 - Y0;
	}

	WriteBinaryFile(OutputFilename_RasterTransBIN, OutBytes, sizeof(OutBytes));
}

int StarWars_Main()
{
	StarWars_GenerateData();

	StarWars_OutputScrollText(L"Link\\StarWars\\SW-ScrollText.bin");

	StarWars_ProcessFont(L"Parts\\StarWars\\Data\\Raistlin-16x16.map", L"Link\\StarWars\\SW-RemappedFont.bin");
	StarWars_OutputByteSetUniquesASM(L"Build\\6502\\StarWars\\SW-Uniques.asm");
	StarWars_OutputPlotterASM(L"Build\\6502\\StarWars\\SW-Plot.asm");

	StarWars_GenSpriteData(L"Link\\StarWars\\RasterSprites.bin");

	StarWars_OutputScreenBIN(L"Link\\StarWars\\Screen.bin");

	StarWars_GenerateRasterColourFade(L"Link\\StarWars\\InitialRasterColours.bin", L"Link\\StarWars\\RasterTrans.bin");

	return 0;
}
