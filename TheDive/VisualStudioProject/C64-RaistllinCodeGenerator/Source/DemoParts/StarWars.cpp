//; (c) 2018-2019, Genesis*Project

#include "..\Common\CodeGen.h"
#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;


char ScrollText[] = {
	"                    "
	"  genesis send our  "
	" warmest regards to "
	"                    "
	"abnormal.......abyss"
	"active........albion"
	"ancients.......arise"
	"arkanix......arsenic"
	"artstate.....artline"
	"atebit......atlantis"
	"bonzai..booze design"
	"camelot......cascade"
	"censor....checkpoint"
	"chorus........cosine"
	"cov.bitops.....crest"
	"c sixtyfour  dot com"
	"darklite...dekadence"
	"delysid......demonix"
	"desire...........dss"
	"excess........extend"
	"f4cg.......fairlight"
	"flood.........fossil"
	"glance....hackntrade"
	"hemoroids.....hitmen"
	"hmf..........hoaxers"
	"hok.force...ian coog"
	"judas...larsson bros"
	"laxity...........lft"
	"mahoney..........mon"
	"mason............mdg"
	"mayday....multistyle"
	"nah kolor......noice"
	"nostalgia.....nuance"
	"offence..........omg"
	"onslaught......oxsid"
	"oxyron.........padua"
	"panda.....performers"
	"plush.......prosonix"
	"pvm........rabenauge"
	"razor.......resource"
	"rgcd...........samar"
	"scs trc........shape"
	"singular.........sos"
	"sync.........tempest"
	"thedreams.noisybunch"
	"solution.........tlr"
	"triad...........trsi"
	"udi...........undone"
	"up rough......vision"
	"wow....wrath designs"
	"....the  seniors...."
	"                    "
	"and anyone we missed"
	"                    "
	"                    "
	"                    "
	"                    "
	"                    "
	"\xff"
};
int ScrollTextNumLines = sizeof(ScrollText) / 20;

#define STARWARS_MAX_NUMBER_OF_UNIQUE_BYTES 20

#define STARWARS_FONT_WIDTH 720
#define STARWARS_FONT_HEIGHT 16

#define STARWARS_FONT_CHAR_WIDTH 16
#define STARWARS_FONT_CHAR_HEIGHT 16
#define STARWARS_FONT_NUM_CHARS_X (STARWARS_FONT_WIDTH / STARWARS_FONT_CHAR_WIDTH)
#define STARWARS_FONT_NUM_CHARS_Y (STARWARS_FONT_HEIGHT / STARWARS_FONT_CHAR_HEIGHT)
#define STARWARS_FONT_NUM_CHARS (STARWARS_FONT_NUM_CHARS_X * STARWARS_FONT_NUM_CHARS_Y)

#define STARWARS_YCHAR_STRIDE (STARWARS_FONT_WIDTH / 8)

#define STARWARS_MAX_WIDTH 320
#define STARWARS_START_WIDTH (STARWARS_MAX_WIDTH / 2)
#define STARWARS_END_WIDTH (STARWARS_MAX_WIDTH)

#define STARWARS_HEIGHT 80
#define STARWARS_BYTE_WIDTH (STARWARS_MAX_WIDTH / 8)
#define STARWARS_STARTYPOS 100

#define UPPER_MAX_NUM_UNIQUESHORTS 64
#define MAX_NUM_UNIQUESHORTS 32
#define MAX_NUM_UNIQUEBYTESETS 4096

#define MAX_NUM_UNIQUEPIXELMAPPINGS 4096

#define MAX_NUM_CHARS_IN_FONT 32

#define MAX_NUM_CHARS_ON_SINGLE_BYTE 2

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


void STARWARS_GenerateData()
{
	ZeroMemory(&StarWarsData, sizeof(StarWarsData));

	int ScreenToPixelLookup[STARWARS_HEIGHT][STARWARS_MAX_WIDTH];
	memset(ScreenToPixelLookup, -1, STARWARS_MAX_WIDTH * STARWARS_HEIGHT * sizeof(int));

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		int YScreenPos = STARWARS_HEIGHT - 1 - YPos;

		int Width = STARWARS_START_WIDTH + ((STARWARS_END_WIDTH - STARWARS_START_WIDTH) * YPos) / (STARWARS_HEIGHT - 1);
		int HalfWidth = Width / 2;
		int XMid = STARWARS_MAX_WIDTH / 2;
		for (int XPos = 0; XPos < HalfWidth; XPos++)
		{
			int XScreenPos0 = (XMid + 0) + XPos;
			int XScreenPos1 = (XMid - 1) - XPos;

			float LookupVal = (float)XPos / float(HalfWidth - 1);

			float ZValue = 0.6f + (((float)YScreenPos) / ((float)STARWARS_HEIGHT)) * 0.4f;
			int YLookupPos = 499 - (int)(299.0f / ZValue);

			int XLookupPos0 = (int)(160.0f + (LookupVal * 159.0f));
			ScreenToPixelLookup[YScreenPos][XScreenPos0] = XLookupPos0;

			int XLookupPos1 = (int)(159.0f - (LookupVal * 159.0f));
			ScreenToPixelLookup[YScreenPos][XScreenPos1] = XLookupPos1;
		}
	}

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		for (int XBytePos = 0; XBytePos < STARWARS_MAX_WIDTH / 8; XBytePos++)
		{
			STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];
			memset(rScreenByte.PixelMapping, 255, 8 * MAX_NUM_CHARS_ON_SINGLE_BYTE);

			for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
			{
				int XPos = (XBytePos * 8) + XPixelPos;

				int XLookupPos = ScreenToPixelLookup[YPos][XPos];
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

					rScreenByte.PixelMapping[FoundCharVal][XPixelPos] = XPixelLookup;
				}
			}
		}
	}
}

void STARWARS_ProcessFont(LPCTSTR InputMAPFilename, LPCTSTR OutputFilename_RemappedFont)
{
	unsigned char RemappedFont[16][MAX_NUM_CHARS_IN_FONT];

	unsigned char FontData[256 * 8];
	ZeroMemory(FontData, sizeof(FontData));
	int FontData_Size = ReadBinaryFile(InputMAPFilename, FontData, sizeof(FontData));
	int ActualNumCharsInFont = FontData_Size / (16 * 2);
	int NumCharsInFont = min(MAX_NUM_CHARS_IN_FONT, ActualNumCharsInFont);

	//; Pass 1: Figure out all the unique shorts from the font...
	for (int FontCharIndex = 0; FontCharIndex < NumCharsInFont; FontCharIndex++)
	{
		for (int YPos = 0; YPos < 16; YPos++)
		{
			unsigned char Byte0 = FontData[((YPos / 8) * ActualNumCharsInFont * 16) + (FontCharIndex * 16) + 0 + (YPos & 7)];
			unsigned char Byte1 = FontData[((YPos / 8) * ActualNumCharsInFont * 16) + (FontCharIndex * 16) + 8 + (YPos & 7)];
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
			RemappedFont[YPos][FontCharIndex] = (unsigned char)FoundShortIndex;
		}
	}

	StarWarsData.NumUniqueShorts = min(MAX_NUM_UNIQUESHORTS, StarWarsData.NumUniqueShorts);

	WriteBinaryFile(OutputFilename_RemappedFont, RemappedFont, 16 * MAX_NUM_CHARS_IN_FONT);
}

void STARWARS_OutputByteSetUniquesASM(LPCTSTR OutputFilename_SWUniquesASM)
{
	CodeGen SWUniquesCode(OutputFilename_SWUniquesASM);

	int TotalUniqueByteDataSize = 0;

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		for (int XBytePos = 0; XBytePos < STARWARS_MAX_WIDTH / 8; XBytePos++)
		{
			STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];

			for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
			{
				unsigned char FormedBytes[MAX_NUM_UNIQUESHORTS];
				ZeroMemory(FormedBytes, sizeof(FormedBytes));

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
								FormedBytes[UniqueShortIndex] |= 1 << (7 - XPixel);
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
					if (BytesLeftOnPage < 28)
					{
						SWUniquesCode.OutputCodeLine(NONE, fmt::format(".fill {:d}, $00", BytesLeftOnPage));
						TotalUniqueByteDataSize += BytesLeftOnPage;
					}

					SWUniquesCode.OutputFunctionLine(fmt::format("FontData_{:d}", MatchIndex));

					SWUniquesCode.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
						FormedBytes[(8 * 0) + 0],
						FormedBytes[(8 * 0) + 1],
						FormedBytes[(8 * 0) + 2],
						FormedBytes[(8 * 0) + 3],
						FormedBytes[(8 * 0) + 4],
						FormedBytes[(8 * 0) + 5],
						FormedBytes[(8 * 0) + 6],
						FormedBytes[(8 * 0) + 7]));
					SWUniquesCode.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
						FormedBytes[(8 * 1) + 0],
						FormedBytes[(8 * 1) + 1],
						FormedBytes[(8 * 1) + 2],
						FormedBytes[(8 * 1) + 3],
						FormedBytes[(8 * 1) + 4],
						FormedBytes[(8 * 1) + 5],
						FormedBytes[(8 * 1) + 6],
						FormedBytes[(8 * 1) + 7]));
					SWUniquesCode.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
						FormedBytes[(8 * 2) + 0],
						FormedBytes[(8 * 2) + 1],
						FormedBytes[(8 * 2) + 2],
						FormedBytes[(8 * 2) + 3],
						FormedBytes[(8 * 2) + 4],
						FormedBytes[(8 * 2) + 5],
						FormedBytes[(8 * 2) + 6],
						FormedBytes[(8 * 2) + 7]));
					SWUniquesCode.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}",
						FormedBytes[(8 * 3) + 0],
						FormedBytes[(8 * 3) + 1],
						FormedBytes[(8 * 3) + 2],
						FormedBytes[(8 * 3) + 3]/*,
						FormedBytes[(8 * 3) + 4]*/));

					TotalUniqueByteDataSize += 28;
				}
				rScreenByte.FontMapping[CharValIndex] = MatchIndex;
			}
		}
	}
	SWUniquesCode.OutputCommentLine(fmt::format("//;Total Size: {:d}", TotalUniqueByteDataSize));
}

void STARWARS_OutputPlotterASM(LPCTSTR OutputFilename_StarWarsPlotterASM)
{
	CodeGen PlotterCode(OutputFilename_StarWarsPlotterASM);

	PlotterCode.OutputCodeLine(NONE, fmt::format(".import source \"..\\..\\..\\Build\\Main\\ASM\\Main-CommonDefines.asm\""));
	PlotterCode.OutputCodeLine(NONE, fmt::format(".import source \"..\\..\\..\\Build\\Main\\ASM\\Main-CommonMacros.asm\""));
	PlotterCode.OutputBlankLine();

	PlotterCode.OutputCodeLine(NONE, fmt::format("* = StarWars_Plot_BASE"));
	PlotterCode.OutputCodeLine(JMP_ABS, fmt::format("StarWarsPlotter"));
	PlotterCode.OutputBlankLine();

	PlotterCode.OutputCodeLine(NONE, fmt::format(".import source \"SW-Uniques.asm\""));
	PlotterCode.OutputBlankLine();

	PlotterCode.OutputCodeLine(NONE, fmt::format(".var ScrollData = $cc00"));
	PlotterCode.OutputCodeLine(NONE, fmt::format(".var BitmapAddress = $e000"));
	PlotterCode.OutputBlankLine();

	int CurrentCharVal = -1;
	PlotterCode.OutputFunctionLine(fmt::format("StarWarsPlotter"));
	PlotterCode.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	PlotterCode.OutputCodeLine(INC_ABS, fmt::format("StarWarsPlotter + 1"));

	
	double INYPos = 0;
	int VirtualYPos[STARWARS_HEIGHT];
	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		double fYPos = (double)(STARWARS_HEIGHT - 1 - YPos);
		INYPos += 2.5 - ((1.5 * fYPos) / (double)STARWARS_HEIGHT);
		VirtualYPos[YPos] = (int)floor(INYPos);
	}

	for (int YPos = 0; YPos < STARWARS_HEIGHT; YPos++)
	{
		PlotterCode.OutputFunctionLine(fmt::format("PlotLine{:d}", YPos));
		int NumINY = 0;
		if (YPos != 0)
		{
			NumINY = VirtualYPos[YPos] - VirtualYPos[YPos - 1];
			for (int INYIndex = 0; INYIndex < NumINY; INYIndex++)
			{
				PlotterCode.OutputCodeLine(INY);
			}
		}
		for (int XBytePos = 0; XBytePos < STARWARS_MAX_WIDTH / 8; XBytePos++)
		{
			STARWARS_SCREENBYTE& rScreenByte = StarWarsData.ScreenByte[YPos][XBytePos];
			if (rScreenByte.NumCharVals == 0)
			{
				continue;
			}

			bool bMatch = false;
			if (YPos < (STARWARS_HEIGHT - 1))
			{
				int NextNumINY = VirtualYPos[YPos + 1] - VirtualYPos[YPos];
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
			}
			int YPos0 = YPos + 36;
			if (bMatch)
			{
				PlotterCode.OutputCodeLine(LDA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", (YPos0 + 1) / 8, XBytePos, (YPos0 + 1) % 8));
			}
			else
			{
				for (int CharValIndex = 0; CharValIndex < rScreenByte.NumCharVals; CharValIndex++)
				{
					if (rScreenByte.CharVal[CharValIndex] != CurrentCharVal)
					{
						CurrentCharVal = rScreenByte.CharVal[CharValIndex];
						PlotterCode.OutputCodeLine(LDX_ABY, fmt::format("ScrollData + ({:d} * $100)", CurrentCharVal));
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
					PlotterCode.OutputCodeLine((CharValIndex == 0) ? LDA_ABX : ORA_ABX, fmt::format("FontData_{:d}", rScreenByte.FontMapping[CharValIndex]));
				}
			}
			PlotterCode.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos0 / 8, XBytePos, YPos0 % 8));
			if (YPos % 2 == 0)
			{
				if(rand() % 2 == 0)
				{
					int YPos1 = 167 - (YPos / 2);
					if (YPos0 != YPos1)
					{
						PlotterCode.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos1 / 8, XBytePos, YPos1 % 8));
					}
				}
			}
		}
	}
	PlotterCode.OutputFunctionLine(fmt::format("PlotLines_Finished"));
	PlotterCode.OutputCodeLine(RTS);
}

void STARWARS_OutputScrollText(LPCTSTR OutputFilename_StarWarsPlotterASM)
{
	for (int LineIndex = 0; LineIndex < ScrollTextNumLines; LineIndex++)
	{
		for (int CharIndex = 0; CharIndex < 20; CharIndex++)
		{
			char& CurrentChar = ScrollText[LineIndex * 20 + CharIndex];
			if (CurrentChar == '.')
			{
				CurrentChar = 29;
			}
			else
			{
				if (CurrentChar == '4')
				{
					CurrentChar = 28;
				}
				else
				{
					if (CurrentChar == '-')
					{
						CurrentChar = 27;
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
	WriteBinaryFile(OutputFilename_StarWarsPlotterASM, ScrollText, ScrollTextNumLines * 20 + 1);
}

void STARWARS_SplitKLA(LPCTSTR InputFilename_KLA, LPCTSTR OutputFilename_MAP, LPCTSTR OutputFilename_SCR, LPCTSTR OutputFilename_COL)
{
	unsigned char KLAData[16384];

	ReadBinaryFile(InputFilename_KLA, KLAData, 16384);
	WriteBinaryFile(OutputFilename_MAP, &KLAData[2], 8000);
	WriteBinaryFile(OutputFilename_COL, &KLAData[2 + 8000 + 1000], 13 * 40);

	//; for the screen, we want to pre-fill the scroller area with $e0...
	for (int Offset = (13 * 40); Offset < 1000; Offset++)
	{
		KLAData[2 + 8000 + Offset] = 0xe0;
	}
	WriteBinaryFile(OutputFilename_SCR, &KLAData[2 + 8000], 1000);
}

void STARWARS_OutputFadeSprites(LPCTSTR OutputFilename)
{
	unsigned char UsedAlready[42];
	ZeroMemory(UsedAlready, sizeof(UsedAlready));

	unsigned char FadeTable[4][7][3] = {
		{
			{ 15,  15,  15},
			{  7,  15,  15},
			{  3,   7,  15},
			{  1,   3,   7},
			{  0,   1,   3},
			{  0,   0,   1},
			{  0,   0,   0},
		},
		{
			{ 15,  15,  15},
			{ 15,  15,   7},
			{ 15,   7,   3},
			{  7,   3,   1},
			{  3,   1,   0},
			{  1,   0,   0},
			{  0,   0,   0},
		},
		{
			{ 15,  15,  15},
			{ 14,  15,  15},
			{ 12,  14,  15},
			{  8,  12,  14},
			{  0,   8,  12},
			{  0,   0,   8},
			{  0,   0,   0},
		},
		{
			{ 15,  15,  15},
			{ 15,  15,  14},
			{ 15,  14,  12},
			{ 14,  12,   8},
			{ 12,   8,   0},
			{  8,   0,   0},
			{  0,   0,   0},
		},
	};
	int NumFades = 7;
	int NumFadeLocations = 42;	//; for a 24x21 sprite, there are 42 4x3 blocks (a grid of 6x7)
	int NumSpritesNeeded = NumFadeLocations + NumFades - 1;
	int FadeXYRTable[42][3];

	unsigned char FadeSprites[48][64];	//; <-- defines
	ZeroMemory(FadeSprites, sizeof(FadeSprites));

	for (int SpriteIndex = 0; SpriteIndex < NumSpritesNeeded; SpriteIndex++)
	{
		if (SpriteIndex > 0)
		{
			memcpy(FadeSprites[SpriteIndex], FadeSprites[SpriteIndex - 1], 64);
		}

		if (SpriteIndex < NumFadeLocations)
		{
			int RandValue = -1;
			while (RandValue < 0)
			{
				RandValue = rand() % 42;
				if (UsedAlready[RandValue] == 1)
				{
					RandValue = -1;
				}
			}
			UsedAlready[RandValue] = 1;

			FadeXYRTable[SpriteIndex][0] = (RandValue % 6) * 4;
			FadeXYRTable[SpriteIndex][1] = (RandValue / 6) * 3;
			FadeXYRTable[SpriteIndex][2] = rand() % 4;
		}

		int FirstFadeSpriteIndex = SpriteIndex - (NumFades - 1);
		int MaxFadeSpriteIndex = SpriteIndex + 1;

		int RelativeFadeIndex = 0;
		int CurrentFadeIndex = FirstFadeSpriteIndex;
		while(CurrentFadeIndex < MaxFadeSpriteIndex)
		{
			if ((CurrentFadeIndex >= 0) && (CurrentFadeIndex < NumFadeLocations) && (RelativeFadeIndex < NumFades))
			{
				int XPos = FadeXYRTable[CurrentFadeIndex][0];
				int YPos = FadeXYRTable[CurrentFadeIndex][1];
				int RIndex = FadeXYRTable[CurrentFadeIndex][2];

				for (int YVal = 0; YVal < 3; YVal++)
				{
					unsigned char MaskValue = 0xff - (0x0f << (XPos & 4));
					unsigned char OrValue = FadeTable[RIndex][RelativeFadeIndex][YVal] << (XPos & 4);
					int ByteOffset = (YPos * 3) + (XPos / 8);
					FadeSprites[SpriteIndex][ByteOffset] = (FadeSprites[SpriteIndex][ByteOffset] & MaskValue) | OrValue;

					YPos++;
				}
			}

			CurrentFadeIndex++;
			RelativeFadeIndex++;
		}
	}
	WriteBinaryFile(OutputFilename, FadeSprites, sizeof(FadeSprites));
}

void STARWARS_OutputWaterSinWaveBIN(LPCTSTR OutputFilename_WaterSinWaveBIN)
{
	int SinTable[256];
	unsigned char cSinTable[256];
	GenerateSinTable(64, 3, 4, 0, &SinTable[0]);
	GenerateSinTable(64, 2, 5, 0, &SinTable[64]);
	GenerateSinTable(64, 1, 6, 0, &SinTable[128]);
	GenerateSinTable(64, 0, 7, 0, &SinTable[192]);
	for (int Index = 0; Index < 256; Index++)
	{
		cSinTable[Index] = (unsigned char)SinTable[Index];
	}
	WriteBinaryFile(OutputFilename_WaterSinWaveBIN, cSinTable, 256);
}

void STARWARS_GenerateFadeYSinTableBIN(LPCTSTR OutputFilename_FadeYSinBIN)
{
	double SinTable[64];
	for (int SineIndex = 0; SineIndex < 64; SineIndex++)
	{
		double angle = (2 * PI * SineIndex) / 64;
		SinTable[SineIndex] = sin(angle);
	}

	unsigned char cSinTable[4][256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		double Amplitude = 150.0 - (((double)SinIndex) * 150.0) / 255.0;

		double SinValue = 147.0 + SinTable[(SinIndex + 16) % 64] * Amplitude;
		SinValue = max(12.0, min(298.0, SinValue));

		unsigned int uiSinValue = (unsigned int)SinValue;

		cSinTable[0][SinIndex] = (unsigned char)uiSinValue;
		cSinTable[1][SinIndex] = uiSinValue < 256 ? 0x00 : 0x80;

		double SinValue2 = 147.0 - SinTable[(SinIndex + 16) % 64] * Amplitude;
		SinValue2 = max(12.0, min(298.0, SinValue2));

		unsigned int uiSinValue2 = (unsigned int)SinValue2;

		cSinTable[2][255 - SinIndex] = (unsigned char)uiSinValue2;
		cSinTable[3][255 - SinIndex] = uiSinValue2 < 256 ? 0x00 : 0x80;

	}
	WriteBinaryFile(OutputFilename_FadeYSinBIN, cSinTable, sizeof(cSinTable));
}

int STARWARS_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\STARWARS");

	STARWARS_GenerateData();
	STARWARS_ProcessFont(L"..\\..\\Build\\Parts\\StarWars\\Data\\Ksubi-16x16.map", L"..\\..\\Intermediate\\Built\\StarWars\\SW-RemappedFont.bin");
	STARWARS_OutputByteSetUniquesASM(L"..\\..\\Intermediate\\Built\\StarWars\\SW-Uniques.asm");
	STARWARS_OutputPlotterASM(L"..\\..\\Intermediate\\Built\\StarWars\\SW-Plot.asm");

	STARWARS_OutputScrollText(L"..\\..\\Intermediate\\Built\\StarWars\\SW-ScrollText.bin");

	STARWARS_SplitKLA(L"..\\..\\Build\\Parts\\StarWars\\Data\\RivalrySWLogo.kla", L"..\\..\\Intermediate\\Built\\StarWars\\SWBitmap.map", L"..\\..\\Intermediate\\Built\\StarWars\\SWBitmap.scr", L"..\\..\\Intermediate\\Built\\StarWars\\SWBitmap.col");
	STARWARS_OutputFadeSprites(L"..\\..\\Intermediate\\Built\\StarWars\\SWFadeSprites.bin");

	STARWARS_OutputWaterSinWaveBIN(L"..\\..\\Intermediate\\Built\\StarWars\\SW-WaterSinWave.bin");

	STARWARS_GenerateFadeYSinTableBIN(L"..\\..\\Intermediate\\Built\\StarWars\\SW-FadeYSinWave.bin");
	return 0;
}
