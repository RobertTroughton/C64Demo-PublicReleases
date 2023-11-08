//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\CodeGen.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define REMOVE_BLANK_LINE_FROM_FONT_DATA 1

#define DYPP_SCREEN_WIDTH 408 //; 320 + 32 (left border) + 32 (right border) + 24 (scrolling range)
//; WIDER #define DYPP_SCREEN_WIDTH 432 //; 320 + 32 (left border) + 32 (right border) + 24 (scrolling range)
#define DYPP_SCREEN_HEIGHT 240

#define DYPP_YSTART 30
#define DYPP_SPRITE_INITIAL_Y (DYPP_YSTART + 1)
#define DYPP_FONT_HEIGHT 14
#define DYPP_NUM_FRAMES 2
#define DYPP_NUM_SCREEN_BUFFERS 2

#define DYPP_NUM_CHARS_IN_FONT 32

#define DYPP_MAX_NUM_SPRITES 64

#define DYPP_NUM_XCHARS (DYPP_SCREEN_WIDTH / 8)

#define DYPP_FIRST_SPRITE_INDEX 4
#define DYPP_MAX_NUM_SPRITES_ON_LINE 4

#define DYPP_SINTABLE_LENGTH (DYPP_SCREEN_WIDTH)

#define DYPP_NUM_XBLOCKS (DYPP_SCREEN_WIDTH / 24)
#define DYPP_NUM_YBLOCKS (DYPP_SCREEN_HEIGHT / 16)
#define DYPP_SAFE_SPRITE_YDISTANCE 1

unsigned char DYPP_ScrollTextStr[] =
"\xf3          "
"\xf2 we heard that tiny sideborder dypps are simply bonzai territory???    "
"\xf3 so... genesis project will just rule the realm of big, all-border dypps!     "
"\xf2 because..   "
"\xf3 yeah..      "
"\xf2 things are so much sexier when raistlin does it.                \xf4                                    ";
//;	"       \xf4 genesis project                 \xf0                \xf3     "
//;	"         accepting no limits for over thirty years!    \xf0          \xf3                    \xf4                       ";
static int DYPP_ScrollTextStrSize = sizeof(DYPP_ScrollTextStr) / sizeof(DYPP_ScrollTextStr[0]);

class DYPP_DATA
{
public:
	class DYPP_CHARBLOCK
	{
	public:
		int MinY;
		int MaxY;
	} CharBlock[DYPP_NUM_XCHARS];
	class DYPP_XBLOCK
	{
	public:
		int MinY;
		int MaxY;
		int SpriteIndex;
	} XBlock[DYPP_NUM_XBLOCKS];
	class DYPP_YBLOCK
	{
	public:
		unsigned char SpriteVal[DYPP_MAX_NUM_SPRITES_ON_LINE];
	} YBlock[DYPP_NUM_YBLOCKS];
	class DYPP_SPRITEUSAGE
	{
	public:
		int NumUsages;
		int XPosIndex[DYPP_MAX_NUM_SPRITES];
		int MinY[DYPP_NUM_XBLOCKS];
		int MaxY[DYPP_NUM_XBLOCKS];
	} SpriteUsage[DYPP_MAX_NUM_SPRITES_ON_LINE];

	int FontDataIndex[DYPP_NUM_XCHARS][64];
	int FontOutputDataRemap[16384];
} DYPPData[DYPP_NUM_FRAMES];

int DYPP_SinTable[DYPP_SINTABLE_LENGTH];

int GFrameIndex = 0;

#define KOALA_HEADER_OFFSET 0
#define KOALA_HEADER_SIZE 2
#define KOALA_MAP_OFFSET (KOALA_HEADER_OFFSET + KOALA_HEADER_SIZE)
#define KOALA_MAP_SIZE (8 * 40 * 25)
#define KOALA_SCR_OFFSET (KOALA_MAP_OFFSET + KOALA_MAP_SIZE)
#define KOALA_SCR_SIZE (40 * 25)
#define KOALA_COL_OFFSET (KOALA_SCR_OFFSET + KOALA_SCR_SIZE)
#define KOALA_COL_SIZE (40 * 25)
#define KOALA_BACKGROUNDCOLOUR_OFFSET (KOALA_COL_OFFSET + KOALA_COL_SIZE)
#define KOALA_BACKGROUNDCOLOUR_SIZE 1
#define KOALA_SIZE (KOALA_HEADER_SIZE + KOALA_MAP_SIZE + KOALA_SCR_SIZE + KOALA_COL_SIZE + KOALA_BACKGROUNDCOLOUR_SIZE)

int SafeSpriteValsToUse[256];
int NumSafeSpriteVals = 0;

void DYPP_OutputBitmapStuff(LPCTSTR InputFilename, LPCTSTR OutputFilename, LPCTSTR OutputFilenameMAP, LPCTSTR OutputFilenameSCR, LPCTSTR OutputFilenameCOL, unsigned char BackgroundColour)
{
	unsigned char BlockUsed[25][40];
	ZeroMemory(BlockUsed, 25 * 40);

	unsigned char KoalaData[KOALA_SIZE];
	unsigned char* KoalaMapData = &KoalaData[KOALA_MAP_OFFSET];
	unsigned char* KoalaScreenData = &KoalaData[KOALA_SCR_OFFSET];
	unsigned char* KoalaColourData = &KoalaData[KOALA_COL_OFFSET];
	unsigned char* KoalaBackgroundColour = &KoalaData[KOALA_BACKGROUNDCOLOUR_OFFSET];

	ReadBinaryFile(InputFilename, KoalaData, KOALA_SIZE);

	for (int YCharPos = 0; YCharPos < 25; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < 40; XCharPos++)
		{
			bool bColourUsed[4] = { false, false, false, false };
			for (int YPixelPos = 0; YPixelPos < 8; YPixelPos++)
			{
				unsigned char ByteValue = KoalaMapData[YCharPos * 8 * 40 + XCharPos * 8 + YPixelPos];
				for (int XPixelPos = 0; XPixelPos < 4; XPixelPos++)
				{
					int XPixelShift = XPixelPos * 2;
					int Colour = (ByteValue & (0x03 << XPixelShift)) >> XPixelShift;
					bColourUsed[Colour] = true;
					if (Colour != 0)
					{
						BlockUsed[YCharPos][XCharPos] = true;
					}
				}
			}
			for (int iColourIndex = 0; iColourIndex < 4; iColourIndex++)
			{
				//; 00: background colour ($d021)
				//; 01: uppernibble from screen ($f-)
				//; 10: lowernibble from screen ($-f)
				//; 11: lowernibble from colour ($-f)

				if (!bColourUsed[iColourIndex])
				{
					switch (iColourIndex)
					{
					case 1:
						KoalaScreenData[YCharPos * 40 + XCharPos] = (KoalaScreenData[YCharPos * 40 + XCharPos] & 0x0f) | (BackgroundColour << 4);
						break;
					case 2:
						KoalaScreenData[YCharPos * 40 + XCharPos] = (KoalaScreenData[YCharPos * 40 + XCharPos] & 0xf0) | (BackgroundColour << 0);
						break;
					case 3:
						KoalaColourData[YCharPos * 40 + XCharPos] = BackgroundColour;
						break;
					}
				}
			}
		}
	}

	*KoalaBackgroundColour = BackgroundColour;

	for (int YCharPos = 0; YCharPos < 25; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < 40; XCharPos += 8)
		{
			int RelativeSpriteIndex = (YCharPos * 5) + (XCharPos / 8);
			if (RelativeSpriteIndex < 64)
			{
				bool bBlockIsEmpty = true;
				for (int XInnerCharPos = 0; XInnerCharPos < 8; XInnerCharPos++)
				{
					if (BlockUsed[YCharPos][XCharPos + XInnerCharPos])
					{
						bBlockIsEmpty = false;
						break;
					}
				}
				if (bBlockIsEmpty)
				{
					SafeSpriteValsToUse[NumSafeSpriteVals] = RelativeSpriteIndex;
					NumSafeSpriteVals++;
				}
			}
		}
	}
	for (int RelativeSpriteIndex = 160; RelativeSpriteIndex < 251; RelativeSpriteIndex++)
	{
		SafeSpriteValsToUse[NumSafeSpriteVals] = RelativeSpriteIndex;
		NumSafeSpriteVals++;
	}

	WriteBinaryFile(OutputFilename, KoalaData, KOALA_SIZE);
	WriteBinaryFile(OutputFilenameMAP, &KoalaData[KOALA_MAP_OFFSET], KOALA_MAP_SIZE);
	WriteBinaryFile(OutputFilenameSCR, &KoalaData[KOALA_SCR_OFFSET], KOALA_SCR_SIZE);
	WriteBinaryFile(OutputFilenameCOL, &KoalaData[KOALA_COL_OFFSET], KOALA_COL_SIZE);
}

void DYPP_OutputSpriteClearCode(LPCTSTR Filename)
{
	CodeGen code(Filename);

	code.OutputFunctionLine(fmt::format("SpriteClear"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$3e"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	code.OutputFunctionLine(fmt::format("SpriteClearLoop"));

	SafeSpriteValsToUse[NumSafeSpriteVals] = 253;

	for (int SpriteIndex = 0; SpriteIndex < NumSafeSpriteVals + 1; SpriteIndex++)
	{
		code.OutputCodeLine(STA_ABY, fmt::format("Base_BankAddress + ({:d} * 64)", SafeSpriteValsToUse[SpriteIndex]));
	}
	code.OutputCodeLine(DEY);
	code.OutputCodeLine(BMI, fmt::format("SpriteClearFinished"));
	code.OutputCodeLine(JMP_ABS, fmt::format("SpriteClearLoop"));
	code.OutputFunctionLine(fmt::format("SpriteClearFinished"));
	code.OutputCodeLine(RTS);
}

void DYPP_OutputScrollText(LPCTSTR OutputFilename)
{
	int WriteSize = 0;
	for (int Index = 0; Index < DYPP_ScrollTextStrSize - 1; Index++)
	{
		unsigned char ByteValue = DYPP_ScrollTextStr[Index];
		if (ByteValue < 0xe0)
		{
			switch (ByteValue)
			{
			case ' ':
				ByteValue = 0;
				break;

			case '.':
				ByteValue = 27;
				break;

			case ',':
				ByteValue = 28;
				break;

			case '!':
				ByteValue = 29;
				break;

			case '-':
				ByteValue = 30;
				break;

			case '?':
				ByteValue = 31;
				break;

			default:
				ByteValue &= 31;
				if (ByteValue > 26)
				{
					ByteValue = 0;
				}
				break;
			}
		}

		DYPP_ScrollTextStr[WriteSize++] = ByteValue;
	}
	DYPP_ScrollTextStr[WriteSize++] = 0xFF;
	WriteBinaryFile(OutputFilename, DYPP_ScrollTextStr, WriteSize);
}



void DYPP_OutputBMPImage(void)
{
	CImg<unsigned char> img(DYPP_SCREEN_WIDTH + 40, DYPP_SCREEN_HEIGHT * DYPP_NUM_FRAMES + 4 * (DYPP_NUM_FRAMES - 1), 1, 3);
	const unsigned char BlackColour[] = {0, 0, 0};
	const unsigned char WhiteColour[] = {255, 255, 255};
	const unsigned char SpriteColours[][2][3] = {
		{{64, 64, 64},{64, 64, 64}},
		{{255, 48, 64},{192, 0, 0}},
		{{64, 255, 64},{0, 192, 0}},
		{{64, 48, 255},{0, 0, 192}},
		{{128, 48, 128},{96, 0, 96}}
	};
	img.fill(0);

	for (int MyFrameIndex = 0; MyFrameIndex < DYPP_NUM_FRAMES; MyFrameIndex++)
	{
		//; Plot the XBlock
		for (int XBlockPos = 0; XBlockPos < DYPP_NUM_XBLOCKS; XBlockPos++)
		{
			int XPos0 = XBlockPos * 24;
			int XPos1 = XPos0 + 23;
			int YPos0 = DYPPData[MyFrameIndex].XBlock[XBlockPos].MinY + (DYPP_SCREEN_HEIGHT + 4) * MyFrameIndex;
			int YPos1 = DYPPData[MyFrameIndex].XBlock[XBlockPos].MaxY + (DYPP_SCREEN_HEIGHT + 4) * MyFrameIndex;
			int ColourIndex = DYPPData[MyFrameIndex].XBlock[XBlockPos].SpriteIndex + 1;
			for (int YPos = YPos0; YPos < YPos1; YPos++)
			{
				img.draw_rectangle(XPos0, YPos, XPos1, YPos, SpriteColours[ColourIndex][(YPos / 16) & 1]);
			}
		}

		for (int XPos = 0; XPos < DYPP_SCREEN_WIDTH; XPos++)
		{
			int YStart = DYPP_SinTable[(XPos - 4 - 2 + 4 * MyFrameIndex + DYPP_SINTABLE_LENGTH) % DYPP_SINTABLE_LENGTH] + (DYPP_SCREEN_HEIGHT + 4) * MyFrameIndex;
			int YEnd = YStart + DYPP_FONT_HEIGHT;
			for (int YPos = YStart; YPos < YEnd; YPos++)
			{
				img.draw_point(XPos, YPos, WhiteColour);
			}
		}

		for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			int NumUsages = DYPPData[MyFrameIndex].SpriteUsage[SpriteIndex].NumUsages;
			for (int UsageIndex = 0; UsageIndex < NumUsages; UsageIndex++)
			{
				int XPos0 = DYPP_SCREEN_WIDTH + 8 + (SpriteIndex * 8);
				int XPos1 = XPos0 + 5;
				int YPos0 = DYPPData[MyFrameIndex].SpriteUsage[SpriteIndex].MinY[UsageIndex] + (DYPP_SCREEN_HEIGHT + 4) * MyFrameIndex;
				int YPos1 = DYPPData[MyFrameIndex].SpriteUsage[SpriteIndex].MaxY[UsageIndex] + (DYPP_SCREEN_HEIGHT + 4) * MyFrameIndex;
				int ColourIndex = SpriteIndex + 1;

				for (int YPos = YPos0; YPos < YPos1; YPos++)
				{
					img.draw_rectangle(XPos0, YPos, XPos1, YPos, SpriteColours[ColourIndex][(YPos / 16) & 1]);
				}
			}
		}
	}

	img.save_bmp("..\\..\\Intermediate\\Built\\DYPP\\Sine.bmp");
}

unsigned char FontOutputData[1024 * 1024];
unsigned char FontWorkingData[65536][8];

void DYPP_GenerateFontData(LPCTSTR OutputFontFilename, char *FontFilename)
{
	CImg<unsigned char> FontImg(FontFilename);

	int NumFontWorkingDataEntries = 0;
	int FontOutputDataOffset = 0;
	int FontOutputDataIndexDeduped = 0;

	int NumCharsInFont = DYPP_NUM_CHARS_IN_FONT;

	FontOutputDataOffset += DYPP_NUM_CHARS_IN_FONT; //; add first one to be the blank line
	FontOutputDataIndexDeduped++;

	for (int MyFrameIndex = 0; MyFrameIndex < DYPP_NUM_FRAMES; MyFrameIndex++)
	{
		NumFontWorkingDataEntries = 0;
		memset(FontWorkingData, 0xff, sizeof(FontWorkingData));

		//; Pass 1: work out the y-lookup indices into the font for our sine-skew
		for (int XCharPos = 0; XCharPos < DYPP_NUM_XCHARS; XCharPos++)
		{
			int YOffset = 0;
			int MinY = DYPPData[MyFrameIndex].CharBlock[XCharPos].MinY;
			int MaxY = DYPPData[MyFrameIndex].CharBlock[XCharPos].MaxY;
			for (int YVal = MinY; YVal < MaxY; YVal++)
			{
				for (int XPixel = 0; XPixel < 7; XPixel++)
				{
					int XPos = XCharPos * 8 + XPixel;
					int YStart = DYPP_SinTable[(XPos - 4 - 2 + 4 * MyFrameIndex + DYPP_SINTABLE_LENGTH) % DYPP_SINTABLE_LENGTH];
					int YEnd = YStart + DYPP_FONT_HEIGHT;

					if ((YVal >= YStart) && (YVal < YEnd))
					{
						FontWorkingData[NumFontWorkingDataEntries + YOffset][XPixel] = (unsigned char)(YVal - YStart);
					}
				}
				DYPPData[MyFrameIndex].FontDataIndex[XCharPos][YOffset] = NumFontWorkingDataEntries + YOffset;
				YOffset++;
			}
			NumFontWorkingDataEntries += MaxY - MinY;
		}

		//; Pass 2: Use the y-lookups to generate our full font data
		for (int FontWorkingDataIndex = 0; FontWorkingDataIndex < NumFontWorkingDataEntries; FontWorkingDataIndex++)
		{
			for (int CharIndex = 0; CharIndex < NumCharsInFont; CharIndex++)
			{
				FontOutputData[FontOutputDataOffset + CharIndex] = 0;

				bool bLastChar = (CharIndex == (NumCharsInFont - 1));
				for (int PixelIndex = 0; PixelIndex < 7; PixelIndex++)
				{
					int FontXLookup = CharIndex * 8 + PixelIndex;
					int FontYLookup = FontWorkingData[FontWorkingDataIndex][PixelIndex];
					if (FontYLookup != 0xff)
					{
						unsigned char red = FontImg(FontXLookup, FontYLookup, 0, 0);
						if (red != 0)
						{
							FontOutputData[FontOutputDataOffset + CharIndex] |= 1 << (7 - PixelIndex);
						}
					}
				}
			}

			//; Now check this last line to see whether it's a dupe
			bool bIsADupe = false;
			int DupeCheckOutputOffset = 0;
			int DupeCheckFontDataCount = 0;
			while (DupeCheckOutputOffset < FontOutputDataOffset)
			{
				bool bIsAMatch = true;
				for (int CharIndex = 0; CharIndex < NumCharsInFont; CharIndex++)
				{
					if (FontOutputData[DupeCheckOutputOffset + CharIndex] != FontOutputData[FontOutputDataOffset + CharIndex])
					{
						bIsAMatch = false;
						break;
					}
				}
				if (bIsAMatch)
				{
					bIsADupe = true;
					DYPPData[MyFrameIndex].FontOutputDataRemap[FontWorkingDataIndex] = DupeCheckFontDataCount;
					break;
				}
				DupeCheckOutputOffset += NumCharsInFont;
				DupeCheckFontDataCount++;
			}
			if (!bIsADupe)
			{
				DYPPData[MyFrameIndex].FontOutputDataRemap[FontWorkingDataIndex] = FontOutputDataIndexDeduped;
				FontOutputDataOffset += NumCharsInFont;
				FontOutputDataIndexDeduped++;
			}
		}
	}

	//; we don't want to write out the initial blank 0's - we'll remove these automatically from the plot code so we don't need them...
	unsigned char *WritePtr = FontOutputData;
	int WriteLen = FontOutputDataOffset;
#if REMOVE_BLANK_LINE_FROM_FONT_DATA
	WritePtr += DYPP_NUM_CHARS_IN_FONT;
	WriteLen -= DYPP_NUM_CHARS_IN_FONT;
#endif //; REMOVE_BLANK_LINE_FROM_FONT_DATA

	WriteBinaryFile(OutputFontFilename, WritePtr, WriteLen);

	//; Output a BMP showing our font
	int XStride = NumCharsInFont * 8;

	CImg<unsigned char> FontDYPPImg(XStride * 2, NumFontWorkingDataEntries * DYPP_NUM_FRAMES, 1, 3);
	unsigned char RedHiColour[] = { 255, 128, 160 };
	unsigned char RedColour[] = { 128, 0, 0 };
	unsigned char BlueHiColour[] = { 160, 128, 255 };
	unsigned char BlueColour[] = { 0, 0, 128 };
	FontDYPPImg.fill(0);

	char DataIndexAlreadyUsed[16384];
	ZeroMemory(DataIndexAlreadyUsed, 16384);

	int YPosUnique = 0;
	int YPos = 0;

	for (int MyFrameIndex = 0; MyFrameIndex < DYPP_NUM_FRAMES; MyFrameIndex++)
	{
		for (int Index = 0; Index < NumFontWorkingDataEntries; Index++)
		{
			int XPos = 0;
			int DataIndex = DYPPData[MyFrameIndex].FontOutputDataRemap[Index];
			int DataOffset = DataIndex * DYPP_NUM_CHARS_IN_FONT;
			bool bIsUnique = DataIndexAlreadyUsed[DataIndex] == 0 ? true : false;

			unsigned char* Colour;
			if (MyFrameIndex == 0)
			{
				if (bIsUnique)
				{
					Colour = &RedHiColour[0];
				}
				else
				{
					Colour = &RedColour[0];
				}
			}
			else
			{
				if (bIsUnique)
				{
					Colour = &BlueHiColour[0];
				}
				else
				{
					Colour = &BlueColour[0];
				}
			}

			for (int CharIndex = 0; CharIndex < NumCharsInFont; CharIndex++)
			{
				unsigned char Byte = FontOutputData[DataOffset + CharIndex];
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					unsigned char BitMask = 1 << (7 - XPixel);

					if (Byte & BitMask)
					{
						FontDYPPImg.draw_point(XPos + 0, YPos, Colour);
						if (bIsUnique)
						{
							FontDYPPImg.draw_point(XPos + XStride, YPosUnique, MyFrameIndex == 0 ? RedHiColour : BlueHiColour);
						}
					}
					XPos++;
				}
			}
			DataIndexAlreadyUsed[DataIndex] = true;
			if (bIsUnique)
			{
				YPosUnique++;
			}
			YPos++;
		}
	}

	FontDYPPImg.save_bmp("..\\..\\Intermediate\\Built\\DYPP\\FontDYPP.bmp");
}

void GenerateFileFromSinTable(char *SineFilename, int SinTableWidth, int SinTableHeight, int* SinTable)
{
	const unsigned char WhiteColour[] = {255, 255, 255};
	CImg<unsigned char> SineImg(SinTableWidth, SinTableHeight, 1, 3);

	SineImg.fill(0);
	for (int XPos = 0; XPos < SinTableWidth; XPos++)
	{
		int MinY = SinTable[XPos];
		int MaxY = MinY + DYPP_FONT_HEIGHT;
		SineImg.draw_rectangle(XPos, MinY, XPos, MaxY - 1, WhiteColour);
	}
	SineImg.save_bmp(SineFilename);
}

void GenerateSinTableFromFile(char *SineFilename, int SinTableWidth, int SinTableHeight, int* SinTable)
{
	CImg<unsigned char> SineImg(SineFilename);

	if (SineImg.width() != SinTableWidth)
	{
		return;
	}
	if (SineImg.height() != SinTableHeight)
	{
		return;
	}
	for (int XPos = 0; XPos < SinTableWidth; XPos++)
	{
		//; find minimum Y for each X where there's a pixel set
		int MinYPos = -1;
		for (int YPos = 0; YPos < SineImg.height(); YPos++)
		{
			unsigned char red = SineImg(XPos, YPos, 0, 0);
			if (red != 0)
			{
				MinYPos = YPos;
				break;
			}
		}
		SinTable[XPos] = MinYPos;
	}
}

void DYPP_CalcSpriteLayouts(void)
{
	GenerateSinTable(DYPP_SINTABLE_LENGTH, 1, DYPP_SCREEN_HEIGHT - DYPP_FONT_HEIGHT, DYPP_SINTABLE_LENGTH / 4, DYPP_SinTable);
	GenerateFileFromSinTable("..\\..\\Build\\Parts\\DYPP\\Data\\Sine-Full.bmp", DYPP_SINTABLE_LENGTH, 240, DYPP_SinTable);
	GenerateSinTableFromFile("..\\..\\Build\\Parts\\DYPP\\Data\\Sine-OPT.bmp", DYPP_SINTABLE_LENGTH, 240, DYPP_SinTable);

	ZeroMemory(&DYPPData[0], sizeof(DYPP_DATA) * DYPP_NUM_FRAMES);

	int CurrentSpriteVal = 0;

	for (int MyFrameIndex = 0; MyFrameIndex < DYPP_NUM_FRAMES; MyFrameIndex++)
	{
		unsigned char SpriteCoverage[DYPP_MAX_NUM_SPRITES_ON_LINE][DYPP_SCREEN_HEIGHT];
		memset(SpriteCoverage, 0xff, sizeof(SpriteCoverage));

		memset(DYPPData[MyFrameIndex].YBlock, 0xfd, sizeof(unsigned char) * DYPP_MAX_NUM_SPRITES_ON_LINE * DYPP_NUM_YBLOCKS);

		//; Pass 1: Work out the MinY/MaxY values for the CharBlock
		for (int XCharPos = 0; XCharPos < DYPP_NUM_XCHARS; XCharPos++)
		{
			int MinY = INT_MAX;
			int MaxY = INT_MIN;

			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;
				int YStart = DYPP_SinTable[(XPos - 4 - 2 + 4 * MyFrameIndex + DYPP_SINTABLE_LENGTH) % DYPP_SINTABLE_LENGTH];
				int YEnd = YStart + DYPP_FONT_HEIGHT;

				MinY = min(MinY, YStart);
				MaxY = max(MaxY, YEnd);

			}

			DYPPData[MyFrameIndex].CharBlock[XCharPos].MinY = MinY;
			DYPPData[MyFrameIndex].CharBlock[XCharPos].MaxY = MaxY;
		}

		//; Pass 2: Work out the MinY/MaxY values for the XBlock
		for (int XBlockPos = 0; XBlockPos < DYPP_NUM_XBLOCKS; XBlockPos++)
		{
			int MinY = INT_MAX;
			int MaxY = INT_MIN;

			for (int XPixel = 0; XPixel < 24; XPixel++)
			{
				int XPos = XBlockPos * 24 + XPixel;
				int YStart = DYPP_SinTable[(XPos - 4 - 2 + 4 * MyFrameIndex + DYPP_SINTABLE_LENGTH) % DYPP_SINTABLE_LENGTH];
				int YEnd = YStart + DYPP_FONT_HEIGHT;

				MinY = min(MinY, YStart);
				MaxY = max(MaxY, YEnd);
			}

			DYPPData[MyFrameIndex].XBlock[XBlockPos].MinY = MinY;
			DYPPData[MyFrameIndex].XBlock[XBlockPos].MaxY = MaxY;

			int FoundSpriteIndex = -1;
			for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
			{
				int SpriteMinYTest = max(0, MinY - DYPP_SAFE_SPRITE_YDISTANCE);						//; feels like a hack .. is this giving us a safe region..?
				int SpriteMaxYTest = min(DYPP_SCREEN_HEIGHT, MaxY + DYPP_SAFE_SPRITE_YDISTANCE);
				bool bFits = true;
				for (int YPos = SpriteMinYTest; YPos < SpriteMaxYTest; YPos++)
				{
					if (SpriteCoverage[SpriteIndex][YPos] != 255)
					{
						bFits = false;
						break;
					}
				}

				if (bFits)
				{
					FoundSpriteIndex = SpriteIndex;
					break;
				}
			}
			DYPPData[MyFrameIndex].XBlock[XBlockPos].SpriteIndex = FoundSpriteIndex;

			if (FoundSpriteIndex >= 0)
			{
				int SpriteMinYTest = max(0, MinY - DYPP_SAFE_SPRITE_YDISTANCE);						//; feels like a hack .. is this giving us a safe region..?
				int SpriteMaxYTest = min(DYPP_SCREEN_HEIGHT, MaxY + DYPP_SAFE_SPRITE_YDISTANCE);
				for (int YPos = SpriteMinYTest; YPos < SpriteMaxYTest; YPos++)
				{
					SpriteCoverage[FoundSpriteIndex][YPos] = XBlockPos;
				}
			}
		}

		//; Pass 3: Sort the sprites from top-to-bottom
		unsigned char SpriteAlreadySorted[DYPP_NUM_XBLOCKS];
		ZeroMemory(SpriteAlreadySorted, sizeof(SpriteAlreadySorted));
		for (int XBlockPos = 0; XBlockPos < DYPP_NUM_XBLOCKS; XBlockPos++)
		{
			int MinY = INT_MAX;
			int MaxY = INT_MIN;
			int TopXBlockPos = -1;
			int TopSpriteIndex = -1;
			for (int XBlockPos2 = 0; XBlockPos2 < DYPP_NUM_XBLOCKS; XBlockPos2++)
			{
				if (SpriteAlreadySorted[XBlockPos2])
				{
					continue;
				}
				int MinYThis = DYPPData[MyFrameIndex].XBlock[XBlockPos2].MinY;
				int MaxYThis = DYPPData[MyFrameIndex].XBlock[XBlockPos2].MaxY;
				if (MinYThis < MinY)
				{
					TopXBlockPos = XBlockPos2;
					TopSpriteIndex = DYPPData[MyFrameIndex].XBlock[XBlockPos2].SpriteIndex;
					MinY = MinYThis;
					MaxY = MaxYThis;
				}
			}
			if (TopXBlockPos != -1)
			{
				SpriteAlreadySorted[TopXBlockPos] = 1;
			}

			int MinYBlock = max(0, MinY / 16);
			int MaxYBlock = min(DYPP_NUM_YBLOCKS, (MaxY + 15) / 16);
			for (int YBlockPos = MinYBlock; YBlockPos < MaxYBlock; YBlockPos++)
			{
				DYPPData[MyFrameIndex].YBlock[YBlockPos].SpriteVal[TopSpriteIndex] = (unsigned char)SafeSpriteValsToUse[CurrentSpriteVal];
				CurrentSpriteVal++;
			}

			int ThisSpriteIndex = DYPPData[MyFrameIndex].XBlock[TopXBlockPos].SpriteIndex;
			int SpriteUsageIndex = DYPPData[MyFrameIndex].SpriteUsage[ThisSpriteIndex].NumUsages;
//;			if (SpriteOnLineIndex < DYPP_MAX_NUM_SPRITES_ON_LINE)
			{
				DYPPData[MyFrameIndex].SpriteUsage[ThisSpriteIndex].MinY[SpriteUsageIndex] = MinY;
				DYPPData[MyFrameIndex].SpriteUsage[ThisSpriteIndex].MaxY[SpriteUsageIndex] = MaxY;
				DYPPData[MyFrameIndex].SpriteUsage[ThisSpriteIndex].XPosIndex[SpriteUsageIndex] = TopXBlockPos;
				DYPPData[MyFrameIndex].SpriteUsage[ThisSpriteIndex].NumUsages++;
			}
		}
	}
}

bool DYPP_IsBadLine(int RasterLine)
{
	if ((RasterLine >= 50) && (RasterLine < 250))
	{
		if ((RasterLine & 7) == 3)
		{
			return true;
		}
	}
	return false;
}

bool DYPP_EnoughFreeCycles(int NumCycles, int NumCyclesNeeded)
{
	//; Special case for "unlimited cycles"
	if (NumCycles == -1)
	{
		return true;
	}

	int NumCyclesLeft = NumCycles - NumCyclesNeeded;

	//; If it doesn't fit, fail
	if (NumCyclesLeft < 0)
	{
		return false;
	}

	//; If it leaves a gap that we can fill, fail
	if (NumCyclesLeft == 1)
	{
		return false;
	}

	//; All good
	return true;
}


class FINALBLITDATA
{
public:
	class
	{
	public:
		int ReadOffset;
		int WriteOffset[64];
		int NumWriteOffsets;
	} UniqueReadData[64];
	int NumUniqueReads;
} FinalBlitData[2][DYPP_NUM_XCHARS];


void FillBlitData()
{
	ZeroMemory(FinalBlitData, sizeof(FinalBlitData));

	for (int FrameIndex = 0; FrameIndex < DYPP_NUM_FRAMES; FrameIndex++)
	{
		for (int CharPos = 0; CharPos < DYPP_NUM_XCHARS; CharPos++)
		{
			FINALBLITDATA& BlitData = FinalBlitData[FrameIndex][CharPos];

			int SpriteIndex = DYPPData[FrameIndex].XBlock[CharPos / 3].SpriteIndex;

			int MinY = DYPPData[FrameIndex].CharBlock[CharPos].MinY;
			int MaxY = DYPPData[FrameIndex].CharBlock[CharPos].MaxY;
			int YRange = MaxY - MinY;

			for (int YOffset = 0; YOffset < YRange; YOffset++)
			{
				int YPos = YOffset + MinY;

				int FontPPIndex = DYPPData[FrameIndex].FontDataIndex[CharPos][YOffset];
				FontPPIndex = DYPPData[FrameIndex].FontOutputDataRemap[FontPPIndex]; //; dedupe

				int FontPPOffset = FontPPIndex * DYPP_NUM_CHARS_IN_FONT;
				int FoundIndex = -1;
				for (int CheckIndex = 0; CheckIndex < BlitData.NumUniqueReads; CheckIndex++)
				{
					if (BlitData.UniqueReadData[CheckIndex].ReadOffset == FontPPOffset)
					{
						FoundIndex = CheckIndex;
						break;
					}
				}
				if (FoundIndex < 0)
				{
					FoundIndex = BlitData.NumUniqueReads;
					BlitData.UniqueReadData[FoundIndex].ReadOffset = FontPPOffset;
					BlitData.NumUniqueReads++;
				}

				unsigned char SpriteVal = DYPPData[FrameIndex].YBlock[YPos / 16].SpriteVal[SpriteIndex];

				int InterleavedYVal = YPos % 21;
				int OutputByteOffset = InterleavedYVal * 3 + (CharPos % 3);
				int WriteOffset = SpriteVal * 64 + OutputByteOffset;

				int WriteOffsetIndex = BlitData.UniqueReadData[FoundIndex].NumWriteOffsets;
				BlitData.UniqueReadData[FoundIndex].WriteOffset[WriteOffsetIndex] = WriteOffset;
				BlitData.UniqueReadData[FoundIndex].NumWriteOffsets++;
			}
		}
	}
}


static bool GFinishedSpriteBlitting = false;
static int LastFontPPOffset;

void DYPP_InsertSpriteBlitCode(CodeGen& code, int& NumCycles, bool bFirstPass)
{
	int InverseFrameIndex = 1 - GFrameIndex;

	bool bInfiniteCycles = false;
	if (NumCycles == -1)
	{
		NumCycles = INT_MAX;
		bInfiniteCycles = true;
	}

	static bool bNewCharPos;
	static int CurrentCharPos;
	static int CurrentYPos;
	static int CurrentYOffset;

	if (bFirstPass)
	{
		bNewCharPos = true;
		CurrentCharPos = 0;
		CurrentYPos = 0;
		CurrentYOffset = 0;
		LastFontPPOffset = -1;
	}

	if (GFinishedSpriteBlitting)
	{
		return;
	}

	bool bFinishedThisPass = false;
	while ((!GFinishedSpriteBlitting) && (!bFinishedThisPass))
	{
		bFinishedThisPass = true;
		if (bNewCharPos)
		{
			if (NumCycles < 3)
			{
				continue;
			}
			bFinishedThisPass = false;
			if (NumCycles == 4)
			{
				NumCycles -= code.OutputCodeLine(LDX_ABS, fmt::format("ZP_ScreenChars + ${:02x}", CurrentCharPos));
			}
			else
			{
				NumCycles -= code.OutputCodeLine(LDX_ZP, fmt::format("ZP_ScreenChars + ${:02x}", CurrentCharPos));
			}
			LastFontPPOffset = -1;

			CurrentYPos = DYPPData[InverseFrameIndex].CharBlock[CurrentCharPos].MinY;
			CurrentYOffset = 0;
			bNewCharPos = false;
		}
		int SpriteIndex = DYPPData[InverseFrameIndex].XBlock[CurrentCharPos / 3].SpriteIndex;
		unsigned char SpriteVal = DYPPData[InverseFrameIndex].YBlock[CurrentYPos / 16].SpriteVal[SpriteIndex];

		int InterleavedYVal = CurrentYPos % 21;
		int OutputByteOffset = InterleavedYVal * 3 + (CurrentCharPos % 3);

		int FontPPIndex = DYPPData[InverseFrameIndex].FontDataIndex[CurrentCharPos][CurrentYOffset];
		FontPPIndex = DYPPData[InverseFrameIndex].FontOutputDataRemap[FontPPIndex]; //; dedupe

		int FontPPOffset = FontPPIndex * DYPP_NUM_CHARS_IN_FONT;

		bool bFontOffsetChanged = FontPPOffset != LastFontPPOffset;

		bool bIsEmptyLine = (FontPPOffset == 0);

#if REMOVE_BLANK_LINE_FROM_FONT_DATA
		FontPPOffset -= DYPP_NUM_CHARS_IN_FONT;
#endif //; REMOVE_BLANK_LINE_FROM_FONT_DATA

		if (bIsEmptyLine)
		{
			bFinishedThisPass = false;
		}
		else
		{
			if (bFontOffsetChanged)
			{
				if (!DYPP_EnoughFreeCycles(NumCycles, 4))
				{
					continue;
				}

				NumCycles -= code.OutputCodeLine(LDA_ABX, fmt::format("DYPP_FontPP + ${:04x}", FontPPOffset));
				LastFontPPOffset = FontPPOffset;
				bFinishedThisPass = false;
			}

			if (NumCycles < 4)
			{
				continue;
			}

			if (NumCycles == 5)
			{
				NumCycles -= code.OutputCodeLine(STA_ABY, fmt::format("Base_BankAddress + ({:d} * 64) + {:d} - D016_Value_40Rows", SpriteVal, OutputByteOffset));
			}
			else
			{
				NumCycles -= code.OutputCodeLine(STA_ABS, fmt::format("Base_BankAddress + ({:d} * 64) + {:d}", SpriteVal, OutputByteOffset));
			}
			bFinishedThisPass = false;
		}

		CurrentYPos++;
		CurrentYOffset++;
		if (CurrentYPos == DYPPData[InverseFrameIndex].CharBlock[CurrentCharPos].MaxY)
		{
			CurrentCharPos++;
			bNewCharPos = true;
			if (CurrentCharPos == DYPP_NUM_XCHARS)
			{
				GFinishedSpriteBlitting = true;
			}
		}
	}
	if (bInfiniteCycles)
	{
		NumCycles = -1;
	}
}

int DYPP_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass)
{
	int WastedCycles = 0;

	static bool bFirst = true;
	if (bFirst)
	{
		bFirst = false;
	}

	DYPP_InsertSpriteBlitCode(code, NumCycles, bFirstPass);

	if (NumCycles == -1)
	{
		return 0;
	}
	if (NumCycles == 1)
	{
		return 0;	//; BIG PROBLEM!!
	}

	if (NumCycles & 1)
	{
		int CyclesTaken = code.OutputCodeLine(NOP_ZP, fmt::format("$ff"));
		NumCycles -= CyclesTaken;
		WastedCycles += CyclesTaken;
	}

	while(NumCycles >= 2)
	{
		int CyclesTaken = code.OutputCodeLine(NOP);
		NumCycles -= CyclesTaken;
		WastedCycles += CyclesTaken;
	}
	return WastedCycles;
}

void DYPP_OutputCode(LPCTSTR Filename)
{
	CodeGen code(Filename);

	int TotalWastedCycles = 0;

	unsigned char SpriteVals[DYPP_NUM_SCREEN_BUFFERS][4];

	std::string CodeString;

	for (GFrameIndex = 0; GFrameIndex < DYPP_NUM_FRAMES; GFrameIndex++)
	{
		bool bSpriteColoursSet = false;

		code.OutputCommentLine(fmt::format("//; Frame {:d} ===============================================================================================", GFrameIndex));

		TotalWastedCycles = 0;

		int XMSBCounter = 0;
		bool bUpdateXMSB = false;

		GFinishedSpriteBlitting = false;
		int CurrentScreenBank = 0;
		bool bScreenBankChanged = false;

		//; Top Sprites (these go in a separate function as we'll place these during VBlank)
		code.OutputFunctionLine(fmt::format("DYPP_IRQ_InitialPart_Frame{:d}", GFrameIndex));

		//; Initial sprite vals
		int CurrentSpriteYPosition = DYPP_SPRITE_INITIAL_Y;
		int UpdateSpriteAtYVal[DYPP_MAX_NUM_SPRITES_ON_LINE];
		int CurrentSpriteIndex[DYPP_MAX_NUM_SPRITES_ON_LINE];

		//; --- Initial Y
		code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYPosition));
		for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{}Y", DYPP_FIRST_SPRITE_INDEX + SpriteIndex));

			UpdateSpriteAtYVal[SpriteIndex] = DYPPData[GFrameIndex].SpriteUsage[SpriteIndex].MaxY[0] + DYPP_SPRITE_INITIAL_Y/* + 1*/;
			CurrentSpriteIndex[SpriteIndex] = 1;
		}

		for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			int XPosIndex = DYPPData[GFrameIndex].SpriteUsage[SpriteIndex].XPosIndex[0];
			code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_Sprite_XPositions +  {:d}", XPosIndex));
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{}X", DYPP_FIRST_SPRITE_INDEX + SpriteIndex));

			for (int ScreenIndex = 0; ScreenIndex < DYPP_NUM_SCREEN_BUFFERS; ScreenIndex++)
			{
				int YBlockIndex = ScreenIndex;
				unsigned char SpriteVal = DYPPData[GFrameIndex].YBlock[YBlockIndex].SpriteVal[SpriteIndex];
				if (SpriteVal != 0xfd)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteVal));
					code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals{:d} + {:d} + {:d}", YBlockIndex, DYPP_FIRST_SPRITE_INDEX, SpriteIndex));

					SpriteVals[ScreenIndex][SpriteIndex] = SpriteVal;
				}
			}
		}

		code.OutputCodeLine(LDA_ZP, fmt::format("ZP_XMSB + {:d}", XMSBCounter));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));
		XMSBCounter ++;

		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		for (int Index = 4; Index < 8; Index++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", Index));
		}

		code.OutputCodeLine(RTS);

		code.OutputBlankLine();
		CurrentScreenBank = 1 - CurrentScreenBank;

		//; Main Screen Sprites
		code.OutputFunctionLine(fmt::format("DYPP_IRQ_Main_Frame{:d}", GFrameIndex));
		code.OutputCodeLine(NONE, fmt::format(":IRQManager_BeginIRQ(1, 0)"));

		int NumCyclesToUse = 58;
		
		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
		NumCyclesToUse -= 2;
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		NumCyclesToUse -= 4;

		code.OutputCodeLine(LDY_IMM, fmt::format("#D016_Value_40Rows"));
		NumCyclesToUse -= 2;

		TotalWastedCycles += DYPP_UseCycles(code, NumCyclesToUse - 2, true);

		code.OutputCodeLine(LDA_IMM, fmt::format("#$0a"));
		LastFontPPOffset = -1; // because we're changing A

		code.OutputBlankLine();

		bool bPreloadA = false;

		for (int LineIndex = 0; LineIndex < DYPP_SCREEN_HEIGHT; LineIndex++)
		{
			int RasterLine = DYPP_YSTART + LineIndex + 1;

			bool bFirstLine = (LineIndex == 0);
			bool bLastLine = (LineIndex == DYPP_SCREEN_HEIGHT - 1);
			bool bIsBadLine = DYPP_IsBadLine(RasterLine);
			bool bNextLineIsBad = DYPP_IsBadLine(RasterLine + 1);
			bool bNextNextLineIsBad = DYPP_IsBadLine(RasterLine + 2);

			int NumCyclesToWaste = 42;

			code.OutputCommentLine(fmt::format("//; RasterLine ${:02x}: {}", RasterLine, bIsBadLine ? " <--BADLINE" : ""));

			if (bIsBadLine)
			{
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016 - D016_Value_40Rows, y"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
			}
			else
			{
				if (bNextLineIsBad)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#D016_Value_38Rows"));
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
					LastFontPPOffset = -1; // because we're changing A
				}
				else
				{
					code.OutputCodeLine(DEC_ABS, fmt::format("VIC_D016"));
				}
				if ((RasterLine == 31) || (RasterLine == 267))
				{
					code.OutputCodeLine(NOP);
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_ScreenColour"));
					NumCyclesToWaste -= 6;
				}
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
			}

			//; if the next line is a bad line, we need to move right along...
			if (bNextLineIsBad)
			{
				continue;
			}

			if (RasterLine == 266)
			{
				bPreloadA = true;
				NumCyclesToWaste -= 2;
			}

			if (!bSpriteColoursSet)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#$01"));
				NumCyclesToWaste -= 2;

				LastFontPPOffset = -1; // because we're changing A

				for (int Index = 4; Index < 8; Index++)
				{
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", Index));
					NumCyclesToWaste -= 4;
				}

				bSpriteColoursSet = true;
			}

			if (RasterLine == 249)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_24Rows"));
				LastFontPPOffset = -1; // because we're changing A
				NumCyclesToWaste -= 2;

				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));
				NumCyclesToWaste -= 4;
			}
			if (RasterLine == 255)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_25Rows"));
				LastFontPPOffset = -1; // because we're changing A
				NumCyclesToWaste -= 2;

				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));
				NumCyclesToWaste -= 4;
			}

			if ((!bFirstLine) && (!bLastLine))
			{
				int ModdedLineIndex = LineIndex % 16;
				if (ModdedLineIndex == 15)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{}",CurrentScreenBank));
					NumCyclesToWaste -= 2;
					LastFontPPOffset = -1; // because we're changing A

					code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
					NumCyclesToWaste -= 4;

					CurrentScreenBank = 1 - CurrentScreenBank;
					bScreenBankChanged = true;
				}
			}
			for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
			{
				if ((CurrentSpriteIndex[SpriteIndex] < DYPPData[GFrameIndex].SpriteUsage[SpriteIndex].NumUsages) && (RasterLine >= UpdateSpriteAtYVal[SpriteIndex]) && (DYPP_EnoughFreeCycles(NumCyclesToWaste, 8)))
				{
					int CurrentSI = CurrentSpriteIndex[SpriteIndex];

					int XPosIndex = DYPPData[GFrameIndex].SpriteUsage[SpriteIndex].XPosIndex[CurrentSI];
					code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_Sprite_XPositions + {}", XPosIndex));
					NumCyclesToWaste -= 4;
					LastFontPPOffset = -1; // because we're changing A

					code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{}X", DYPP_FIRST_SPRITE_INDEX + SpriteIndex));
					NumCyclesToWaste -= 4;

					UpdateSpriteAtYVal[SpriteIndex] = DYPPData[GFrameIndex].SpriteUsage[SpriteIndex].MaxY[CurrentSI] + DYPP_SPRITE_INITIAL_Y + 1;

					CurrentSpriteIndex[SpriteIndex]++;

					bUpdateXMSB = true;
				}
			}
			if ((bUpdateXMSB) && (DYPP_EnoughFreeCycles(NumCyclesToWaste, 7)))
			{
				code.OutputCodeLine(LDA_ZP, fmt::format("ZP_XMSB + {:d}", XMSBCounter));
				NumCyclesToWaste -= 3;
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));
				NumCyclesToWaste -= 4;

				LastFontPPOffset = -1; // because we're changing A
				XMSBCounter++;

				bUpdateXMSB = 0;
			}


			//; When to do this..? How? We should update these after a D018 change - changing the previous sprite vals to point to the next usage...
			static int SpriteValIndexToChange = -1;
			if (bScreenBankChanged)
			{
				int ModdedLineIndex = LineIndex % 16;
				if (ModdedLineIndex == 0)
				{
					SpriteValIndexToChange = 0;
					bScreenBankChanged = false;
				}
			}
			while ((SpriteValIndexToChange >= 0) && (DYPP_EnoughFreeCycles(NumCyclesToWaste, 6)))
			{
				int YBlockIndex = (LineIndex + 31) / 16;
				int ScreenIndex = CurrentScreenBank;

				unsigned char SpriteVal = DYPPData[GFrameIndex].YBlock[YBlockIndex].SpriteVal[SpriteValIndexToChange];
				if (SpriteVals[ScreenIndex][SpriteValIndexToChange] != SpriteVal)
				{
					if (SpriteVal != 0xfd)
					{
						code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteVal));
						NumCyclesToWaste -= 2;
					}
					else
					{
						code.OutputCodeLine(LDA_IMM, fmt::format("#$fd"));
						NumCyclesToWaste -= 2;
					}
					LastFontPPOffset = -1; // because we're changing A
					code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals{} + {} + {}", ScreenIndex, DYPP_FIRST_SPRITE_INDEX, SpriteValIndexToChange));
					NumCyclesToWaste -= 4;

					SpriteVals[ScreenIndex][SpriteValIndexToChange] = SpriteVal;
				}

				SpriteValIndexToChange++;
				if (SpriteValIndexToChange == DYPP_MAX_NUM_SPRITES_ON_LINE)
				{
					SpriteValIndexToChange = -1;
				}
			}

			if (RasterLine > CurrentSpriteYPosition)
			{
				int NumCyclesNeeded = 2 + 4 * 4;
				if (DYPP_EnoughFreeCycles(NumCyclesToWaste, NumCyclesNeeded))
				{
					CurrentSpriteYPosition += 21;

					code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYPosition));
					NumCyclesToWaste -= 2;
					LastFontPPOffset = -1; // because we're changing A
					for (int SpriteIndex = 0; SpriteIndex < DYPP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
					{
						code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{}Y", DYPP_FIRST_SPRITE_INDEX + SpriteIndex));
						NumCyclesToWaste -= 4;
					}
				}
			}
			if (LineIndex == (DYPP_SCREEN_HEIGHT - 1))
			{
				continue;
			}

			TotalWastedCycles += DYPP_UseCycles(code, NumCyclesToWaste, false);
			code.OutputBlankLine();

			if (bPreloadA)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
				LastFontPPOffset = -1; // because we're changing A
				bPreloadA = false;
			}
		}

		code.OutputBlankLine();

		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));

		code.OutputCodeLine(LDA_IMM, fmt::format("#$fd"));
		for (int MySpriteIndex = 0; MySpriteIndex < 4; MySpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + {} + {}", DYPP_FIRST_SPRITE_INDEX, MySpriteIndex));
		}

		code.OutputBlankLine();

		LastFontPPOffset = -1; // because A will have changed
		TotalWastedCycles += DYPP_UseCycles(code, -1, false);
		code.OutputBlankLine();

		code.OutputCodeLine(JMP_ABS, fmt::format("DYPP_PostRasterised"));

		code.OutputBlankLine();

		code.OutputCommentLine(fmt::format("//; Total Wasted Cycles = {:d}", TotalWastedCycles));

		code.OutputBlankLine();

		code.OutputBlankLine();
	}
}

void DYPP_OutputKLAAnimCode(LPCTSTR OutputCodeFilename, int Frame, LPCTSTR KLAFilename0, LPCTSTR KLAFilename1, bool bDoubleBuffer)
{
	CodeGen code(OutputCodeFilename);

	code.OutputFunctionLine(fmt::format("KLA_DrawFrame{:d}", Frame));

	unsigned char KLAFile0[20000];
	unsigned char KLAFile1[20000];

	ReadBinaryFile(KLAFilename0, KLAFile0, 20000);
	ReadBinaryFile(KLAFilename1, KLAFile1, 20000);

	unsigned char* MAPData0 = &KLAFile0[2];
	unsigned char* MAPData1 = &KLAFile1[2];

	unsigned char* SCRData0 = &MAPData0[8000];
	unsigned char* SCRData1 = &MAPData1[8000];

	unsigned char* COLData0 = &SCRData0[1000];
	unsigned char* COLData1 = &SCRData1[1000];

	//; Pass 1: Bitmap Data
	code.OutputCodeLine(NONE, fmt::format(":OpenKernelRAM()"));

	int PrevXValue = 9999;
	for (int CharIndex = 0; CharIndex < 256; CharIndex++)
	{
		bool bValueWillBeUsed = false;
		for (int MAPIndex = 4096; MAPIndex < 8000; MAPIndex++)
		{
			if ((MAPData1[MAPIndex] == CharIndex) && (MAPData0[MAPIndex] != CharIndex))
			{
				bValueWillBeUsed = true;
			}
		}
		if (bValueWillBeUsed)
		{
			if (CharIndex == (PrevXValue + 1))
			{
				code.OutputCodeLine(INX);
			}
			else
			{
				code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", CharIndex));
			}
			PrevXValue = CharIndex;
		}
		for (int MAPIndex = 4096; MAPIndex < 8000; MAPIndex++)
		{
			if ((MAPData1[MAPIndex] == CharIndex) && (MAPData0[MAPIndex] != CharIndex))
			{
				code.OutputCodeLine(STX_ABS, fmt::format("BitmapAddress + ${:04x}", MAPIndex));
			}
		}
	}

	code.OutputCodeLine(NONE, fmt::format(":CloseKernelRAM()"));

	for (int CharIndex = 0; CharIndex < 256; CharIndex++)
	{
		bool bValueWillBeUsed = false;
		for (int MAPIndex = 0; MAPIndex < 4096; MAPIndex++)
		{
			if ((MAPData1[MAPIndex] == CharIndex) && (MAPData0[MAPIndex] != CharIndex))
			{
				bValueWillBeUsed = true;
			}
		}
		for (int ScreenIndex = 0; ScreenIndex < 1000; ScreenIndex++)
		{
			if ((SCRData1[ScreenIndex] == CharIndex) && (SCRData0[ScreenIndex] != CharIndex))
			{
				bValueWillBeUsed = true;
			}
			if ((COLData1[ScreenIndex] == CharIndex) && (COLData0[ScreenIndex] != CharIndex))
			{
				bValueWillBeUsed = true;
			}
		}

		if (bValueWillBeUsed)
		{
			if (CharIndex == (PrevXValue + 1))
			{
				code.OutputCodeLine(INX);
			}
			else
			{
				code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", CharIndex));
			}
			PrevXValue = CharIndex;
		}

		for (int MAPIndex = 0; MAPIndex < 4096; MAPIndex++)
		{
			if ((MAPData1[MAPIndex] == CharIndex) && (MAPData0[MAPIndex] != CharIndex))
			{
				code.OutputCodeLine(STX_ABS, fmt::format("BitmapAddress + ${:04x}", MAPIndex));
			}
		}
		for (int ScreenIndex = 0; ScreenIndex < 1000; ScreenIndex++)
		{
			if ((SCRData1[ScreenIndex] == CharIndex) && (SCRData0[ScreenIndex] != CharIndex))
			{
				code.OutputCodeLine(STX_ABS, fmt::format("ScreenAddress0 + ${:04x}", ScreenIndex));
				if (bDoubleBuffer)
				{
					code.OutputCodeLine(STX_ABS, fmt::format("ScreenAddress1 + ${:04x}", ScreenIndex));	//; TODO: Only one of these should be needed dependent on the Y-value, surely..?
				}
			}
			if ((COLData1[ScreenIndex] == CharIndex) && (COLData0[ScreenIndex] != CharIndex))
			{
				code.OutputCodeLine(STX_ABS, fmt::format("VIC_ColourMemory + ${:04x}", ScreenIndex));
			}
		}
	}

	code.OutputCodeLine(RTS);
}

#define CHARSET_LENGTH 664
void DYPP_ReverseCharSet(LPCTSTR InputFilename, LPCTSTR OutputFilename)
{
	unsigned char CharSet[CHARSET_LENGTH];
	ReadBinaryFile(InputFilename, CharSet, CHARSET_LENGTH);
	for (int Index = 0; Index < CHARSET_LENGTH; Index++)
	{
		CharSet[Index] = CharSet[Index] ^ 255;
	}
	WriteBinaryFile(OutputFilename, CharSet, CHARSET_LENGTH);
}

void DYPP_OutputColourFadeScreens(LPCTSTR InputSCRFilename, LPCTSTR InputCOLFilename, LPCTSTR OutputSCRFilename)
{
	unsigned char InputColourSCR[1000];
	unsigned char InputColourCOL[1000];
	unsigned char OutputColourScreens[3][1024];

	ReadBinaryFile(InputSCRFilename, InputColourSCR, 1000);
	ReadBinaryFile(InputCOLFilename, InputColourCOL, 1000);

	for (int Index = 0; Index < 1000; Index++)
	{
		OutputColourScreens[0][Index] = InputColourSCR[Index] & 0x0f;
		OutputColourScreens[1][Index] = (InputColourSCR[Index] & 0xf0) >> 4;
		OutputColourScreens[2][Index] = InputColourCOL[Index] & 0x0f;
	}

	WriteBinaryFile(OutputSCRFilename, OutputColourScreens, 1024 * 3);
}

void DYPP_GenerateRasterSines(LPCTSTR OutputFilename)
{
	int SinTable0[96];
	int SinTable1[96];
	GenerateSinTable(96, 0, 59, 24, SinTable0);
	GenerateSinTable(96, 59, 118, 24, SinTable1);
	
	unsigned char cSinTable[96];
	for (int SinIndex = 0; SinIndex < 48; SinIndex++)
	{
		cSinTable[SinIndex +  0] = (unsigned char)SinTable0[SinIndex];
		cSinTable[SinIndex + 48] = (unsigned char)SinTable1[SinIndex];
	}

	CodeGen code(OutputFilename);
	code.OutputFunctionLine(fmt::format("DYPP_RasterSinTable"));
	for (int SinIndex = 0; SinIndex < 96; SinIndex += 8)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", cSinTable[SinIndex + 0], cSinTable[SinIndex + 1], cSinTable[SinIndex + 2], cSinTable[SinIndex + 3], cSinTable[SinIndex + 4], cSinTable[SinIndex + 5], cSinTable[SinIndex + 6], cSinTable[SinIndex + 7]));
	}
}

void DYPP_OutputRegionOfKLA(LPCTSTR InputFilename, int X, int Y, int W, int H, LPCTSTR OutputFilename)
{
	unsigned char InputKLA[2 + 8000 + 1000 + 1000 + 1];
	unsigned char *InputMAPData = &InputKLA[2 + 0];
	unsigned char *InputSCRData = &InputMAPData[8000];
	unsigned char *InputCOLData = &InputSCRData[1000];
	ReadBinaryFile(InputFilename, InputKLA, 2 + 8000 + 1000 + 1000 + 1);

	int OutputMAPSize = W * H / 8;
	int OutputSCRSize = OutputMAPSize / 8;
	int OutputCOLSize = OutputSCRSize;

	unsigned char OutputData[65536];

	int OutputMAPOffset = 0;
	int OutputSCROffset = OutputMAPOffset + OutputMAPSize;
	int OutputCOLOffset = OutputSCROffset + OutputSCRSize;
	int OutputDataSize = OutputCOLOffset + OutputCOLSize;

	int XCharMin = X / 8;
	int XCharW = W / 8;

	int YCharMin = Y / 8;
	int YCharH = H / 8;

	int YCharOutputStride = XCharW * 8;

	for (int YCharPos = 0; YCharPos < YCharH; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < XCharW; XCharPos++)
		{
			for (int YPixelPos = 0; YPixelPos < 8; YPixelPos++)
			{
				OutputData[OutputMAPOffset + YPixelPos + XCharPos * 8 + YCharPos * YCharOutputStride] = InputMAPData[YPixelPos + (XCharPos + XCharMin) * 8 + (YCharPos + YCharMin) * 40 * 8];
			}
			OutputData[OutputSCROffset + XCharPos + YCharPos * XCharW] = InputSCRData[(XCharPos + XCharMin) + (YCharPos + YCharMin) * 40];
			OutputData[OutputCOLOffset + XCharPos + YCharPos * XCharW] = InputCOLData[(XCharPos + XCharMin) + (YCharPos + YCharMin) * 40];
		}
	}

	WriteBinaryFile(OutputFilename, OutputData, OutputDataSize);
}

void DYPP_SplitFile(LPCTSTR InputFilename, LPCTSTR OutputFilename1, LPCTSTR OutputFilename2, int Size1, int Size2)
{
	ReadBinaryFile(InputFilename, FileReadBuffer, Size1 + Size2);
	WriteBinaryFile(OutputFilename1, &FileReadBuffer[0], Size1);
	WriteBinaryFile(OutputFilename2, &FileReadBuffer[Size1], Size2);
}

int DYPP_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\DYPP");

	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.col", 0x0A);
	DYPP_OutputSpriteClearCode(L"..\\..\\Intermediate\\Built\\DYPP\\SpriteClear.asm");

//;	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-Burnt.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.col", 0x0A);

/*	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-Anim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.col", 0x0A);
	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-Anim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.col", 0x0A);
	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-Anim2.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.col", 0x0A);
	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-Anim3.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.col", 0x0A);*/

/*	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-ThrowAnim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.col", 0x0A);
	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-ThrowAnim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.col", 0x0A);
	DYPP_OutputBitmapStuff(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-ThrowAnim2.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim2.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim2.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim2.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim2.col", 0x0A);*/

	DYPP_CalcSpriteLayouts();

	DYPP_GenerateFontData(L"..\\..\\Intermediate\\Built\\DYPP\\FontPP.bin", "..\\..\\Build\\Parts\\DYPP\\Data\\Font-Ksubi-7x14.bmp");

	DYPP_OutputBMPImage();

	FillBlitData();

	DYPP_OutputCode(L"..\\..\\Intermediate\\Built\\DYPP\\Rasterised.asm");

	DYPP_OutputScrollText(L"..\\..\\Intermediate\\Built\\DYPP\\scrolltext.bin");
	 
/*	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame0.asm", 0, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.kla", false);
	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame1.asm", 1, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.kla", false);
	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame2.asm", 2, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim2.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.kla", false);
	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame3.asm", 3, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim3.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.kla", false);

	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame_Throw0.asm", 500, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Anim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.kla", false);
	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame_Throw1.asm", 501, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim0.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.kla", false);
	DYPP_OutputKLAAnimCode(L"..\\..\\Intermediate\\Built\\DYPP\\DrawFrame_Throw2.asm", 502, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim1.kla", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-ThrowAnim2.kla", false);

	DYPP_ReverseCharSet(L"..\\..\\Build\\Parts\\DYPP\\Data\\SoyaFont.imap", L"..\\..\\Intermediate\\Built\\DYPP\\SoyaFont.imap");*/

	DYPP_OutputColourFadeScreens(L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.col", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-SplitColours.scr");
//;	DYPP_OutputColourFadeScreens(L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.scr", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt.col", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-Burnt-SplitColours.scr");

	DYPP_GenerateRasterSines(L"..\\..\\Intermediate\\Built\\DYPP\\RasterSine.asm");

//;	DYPP_OutputRegionOfKLA(L"..\\..\\Build\\Parts\\DYPP\\Data\\Facet-Bonsai-WithAddedLogo.kla", 104, 24, 104, 32, L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-JustLogo.bin");

	DYPP_SplitFile(L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-C000.map", L"..\\..\\Intermediate\\Built\\DYPP\\Facet-Bonsai-D000.map", 4096, 8000 - 4096);

	return 0;
}

