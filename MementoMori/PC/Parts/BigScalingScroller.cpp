// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

static const int SCROLLER_WIDTH = 320;
static const int SCROLLER_HEIGHT = 200;

static const int SCROLLER_CHARWIDTH = SCROLLER_WIDTH / 8;
static const int SCROLLER_CHARHEIGHT = SCROLLER_HEIGHT / 8;

static const int SCROLLER_FONT_HEIGHT = 64;
static const int SCROLLER_FONT_MAXHEIGHT = SCROLLER_FONT_HEIGHT;
static const int SCROLLER_FONT_MINHEIGHT = 26;

static const int SCROLLER_SINAMPLITUDE = (SCROLLER_HEIGHT - SCROLLER_FONT_MAXHEIGHT) / 2;

static const int PACKEDFONT_MAX_COLUMNS = 128;
unsigned char PackedFont[PACKEDFONT_MAX_COLUMNS][SCROLLER_FONT_HEIGHT][8];
int PackedFont_NumColumns;

int YPos_Height[SCROLLER_WIDTH][2];

static unsigned char BMM_CharSets[16][256][8];
static int BMM_CharSet_NumChars[16];
static int BMM_CharSet_NumScreenLines[16];
static int BMM_NumCharSets;

unsigned char FontColumnRemapping[256];

static unsigned char ScrollText[] = {
	"the only journey is the one within"
	">"
};

int ScreenToPackedLookup[SCROLLER_CHARWIDTH][SCROLLER_CHARHEIGHT];

void BigScalingScroller_LoadFont(char* InFontPNGFilename)
{
	GPIMAGE FontImage(InFontPNGFilename);;

	int Width = FontImage.Width;
	int NumColumnsUnpacked = Width / 8;

	PackedFont_NumColumns = 0;
	for (int Column = 0; Column < NumColumnsUnpacked; Column++)
	{
		unsigned char ThisColumn[SCROLLER_FONT_HEIGHT][8];
		for (int YPixel = 0; YPixel < SCROLLER_FONT_HEIGHT; YPixel++)
		{
			unsigned char ThisByte = 0;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = Column * 8 + XPixel;
				ThisColumn[YPixel][XPixel] = FontImage.GetPixel(XPos, YPixel);
			}
		}
		int FindIndex = -1;
		for (int Index = 0; Index < PackedFont_NumColumns; Index++)
		{
			if (memcmp(ThisColumn, PackedFont[Index], SCROLLER_FONT_HEIGHT * 8) == 0)
			{
				FindIndex = Index;
				break;
			}
		}
		if (FindIndex == -1)
		{
			FindIndex = PackedFont_NumColumns;
			memcpy(PackedFont[PackedFont_NumColumns], ThisColumn, SCROLLER_FONT_HEIGHT * 8);
			PackedFont_NumColumns++;
		}
		FontColumnRemapping[Column] = FindIndex;
	}
	



	int CurrentChar = 1;
	unsigned char CharXW[32][2];
	int ColumnIndex = 0;
	bool InChar = false;

	ZeroMemory(CharXW, sizeof(CharXW));
	CharXW[0][1] = 3;

	while (true)
	{
		unsigned char Col = FontColumnRemapping[ColumnIndex];
		if (Col == 0xff)
		{
			break;
		}
		if (!InChar)
		{
			if (Col != 0x00)
			{
				CharXW[CurrentChar][0] = ColumnIndex;
				InChar = true;
			}
		}
		else
		{
			if (Col == 0x00)
			{
				CharXW[CurrentChar][1] = ColumnIndex - CharXW[CurrentChar][0] + 1;
				CurrentChar++;
				InChar = false;
			}
		}
		ColumnIndex++;
	}

	int ScrollTextIndex = 0;
	unsigned char OutScrollText[8192];
	int OutScrollTextIndex = 0;
	while (true)
	{
		unsigned char CurrentChar = ScrollText[ScrollTextIndex++];
		if (CurrentChar == '>')
		{
			break;
		}

		switch (CurrentChar)
		{
			case ' ':
			CurrentChar = 0;
			break;

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

			default:
			CurrentChar = CurrentChar & 0x1f;
			break;
		}

		int StartX = CharXW[CurrentChar][0];
		int EndX = StartX + CharXW[CurrentChar][1];
		for (int CharX = StartX; CharX < EndX; CharX++)
		{
			OutScrollText[OutScrollTextIndex++] = FontColumnRemapping[CharX];
		}
	}
	for (int Index = 0; Index < 40; Index++)
	{
		OutScrollText[OutScrollTextIndex++] = 0x00;
	}
	OutScrollText[OutScrollTextIndex++] = 0xff;

	WriteBinaryFile(L"Out\\6502\\Parts\\BigScalingScroller\\ScrollText.bin", OutScrollText, OutScrollTextIndex);
}

unsigned char OutDispImage[SCROLLER_CHARHEIGHT][SCROLLER_CHARWIDTH][PACKEDFONT_MAX_COLUMNS][8];

void BigScalingScroller_Calc(char* OutSinePNGFilename, LPTSTR OutFontBINFilename, LPTSTR OutPackedCharLookupsBINFilename)
{
	for (int Index = 0; Index < SCROLLER_WIDTH; Index++)
	{
		double Angle = (2 * PI * Index) / SCROLLER_WIDTH - PI / 4;
		double AngleB = (2 * PI * Index * 8) / SCROLLER_WIDTH + PI / 4;
		double SineValue = 15 * sin(Angle) / 16;
		SineValue += 1 * sin(AngleB) / 16;

		SineValue = sin(Angle);
		SineValue += 1.0 / (SCROLLER_WIDTH * 2);

		double Angle2 = (2 * PI * Index * 3) / SCROLLER_WIDTH;
		double SineValue2 = sin(Angle2) + 1.0 / (SCROLLER_WIDTH * 2);
		SineValue2 = 1.0 - (SineValue2 + 1.0) / 2.0;

		double YMidPos = (SineValue * SCROLLER_SINAMPLITUDE) + (SCROLLER_HEIGHT / 2.0);

		double Height = (SineValue2 * SCROLLER_FONT_MAXHEIGHT) + ((1.0 - SineValue2) * SCROLLER_FONT_MINHEIGHT);
		double HalfHeight = Height / 2.0;

		int YStart = (int)(YMidPos - HalfHeight);
		int iHeight = (int)Height;

		YPos_Height[Index][0] = YStart;
		YPos_Height[Index][1] = iHeight;
	}

	GPIMAGE SineImage(SCROLLER_WIDTH, SCROLLER_HEIGHT);

	ZeroMemory(OutDispImage, sizeof(OutDispImage));

	for (int XCharPos = 0; XCharPos < SCROLLER_CHARWIDTH; XCharPos++)
	{
		for (int XFontChar = 0; XFontChar < PackedFont_NumColumns; XFontChar++)
		{
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;

				int YStart = YPos_Height[XPos][0];
				int iHeight = YPos_Height[XPos][1];

				double TexelCentreOffset = (double)iHeight / (2.0 * SCROLLER_FONT_MAXHEIGHT);
				for (int YPixel = 0; YPixel < iHeight; YPixel++)
				{
					int YPos = YStart + YPixel;

					SineImage.SetPixel(XPos, YPos, 0x00ffffff);

					double TexelYLookup = TexelCentreOffset + (YPixel * SCROLLER_FONT_HEIGHT) / (double)iHeight;

					unsigned char ColValue = PackedFont[XFontChar][(int)TexelYLookup][XPixel];
					if (ColValue != 0)
					{
						static const unsigned char BitMasks[4] = { 0xcc, 0x99, 0x33, 0x66 };
						int OutYCharPos = YPos / 8;
						int OutYPixelPos = YPos % 8;
						unsigned char BitMask = BitMasks[OutYPixelPos & 3];
						OutDispImage[OutYCharPos][XCharPos][XFontChar][OutYPixelPos] |= (1 << (7 - XPixel)) & BitMask;
					}
				}
			}
		}
	}
	SineImage.Write(OutSinePNGFilename);

	ZeroMemory(BMM_CharSets, sizeof(BMM_CharSets));

	//; Ensure that all charsets have the blank char as their first...
	for (int Index = 0; Index < 16; Index++)
	{
		BMM_CharSet_NumChars[Index] = 1;
	}

	BMM_NumCharSets = 0;

	int NumCollectedChars = 0;

	int SizeCharLookup = SCROLLER_CHARHEIGHT * SCROLLER_CHARWIDTH * PackedFont_NumColumns;
	unsigned char* CharLookup = new unsigned char[SizeCharLookup];
	memset(CharLookup, 0x00, SizeCharLookup);

	ZeroMemory(BMM_CharSet_NumScreenLines, sizeof(BMM_CharSet_NumScreenLines));

	for (int YCharPos = 0; YCharPos < SCROLLER_CHARHEIGHT; YCharPos++)
	{
		bool bFinished = false;
		while (bFinished == false)
		{
			bFinished = true;	//; assume first that the new chars will fit...

			NumCollectedChars = BMM_CharSet_NumChars[BMM_NumCharSets];

			for (int XCharPos = 0; XCharPos < SCROLLER_CHARWIDTH; XCharPos++)
			{
				for (int XFontChar = 0; XFontChar < PackedFont_NumColumns; XFontChar++)
				{
					unsigned char ThisChar[8];
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						ThisChar[YPixel] = OutDispImage[YCharPos][XCharPos][XFontChar][YPixel];
					}

					int FoundIndex = -1;
					for (int CharCheck = 0; CharCheck < NumCollectedChars; CharCheck++)
					{
						if (memcmp(ThisChar, BMM_CharSets[BMM_NumCharSets][CharCheck], 8) == 0)
						{
							FoundIndex = CharCheck;
							break;
						}
					}
					if (FoundIndex == -1)
					{
						FoundIndex = NumCollectedChars;
						if (FoundIndex < 256)
						{
							memcpy(BMM_CharSets[BMM_NumCharSets][FoundIndex], ThisChar, 8);
						}
						else
						{
							bFinished = false; //; new chars don't fit .. so let's restart the loop on a new pass
						}
						NumCollectedChars++;
					}
					CharLookup[(YCharPos * SCROLLER_CHARWIDTH + XCharPos) * PackedFont_NumColumns + XFontChar] = FoundIndex;
				}
			}

			if (!bFinished)
			{
				//; it didn't fit ... so we try again using the next charset
				BMM_NumCharSets++;
			}
			else
			{
				BMM_CharSet_NumChars[BMM_NumCharSets] = NumCollectedChars;
				BMM_CharSet_NumScreenLines[BMM_NumCharSets]++;
			}
		}
	}
	if (BMM_CharSet_NumChars[BMM_NumCharSets] > 0)
	{
		BMM_NumCharSets++;
	}
	WriteBinaryFile(OutFontBINFilename, BMM_CharSets, BMM_NumCharSets * 256 * 8);

	unsigned char* PackedCharLookup = new unsigned char[SizeCharLookup];
	memset(PackedCharLookup, 0x00, SizeCharLookup);
	int NumPackedCharLookups = 1;
	for (int YChar = 0; YChar < SCROLLER_CHARHEIGHT; YChar++)
	{
		for (int XChar = 0; XChar < SCROLLER_CHARWIDTH; XChar++)
		{
			int FoundIndex = -1;
			for (int Index = 0; Index < NumPackedCharLookups; Index++)
			{
				if (memcmp(&PackedCharLookup[Index * PackedFont_NumColumns], &CharLookup[((YChar * SCROLLER_CHARWIDTH) + XChar) * PackedFont_NumColumns], PackedFont_NumColumns) == 0)
				{
					FoundIndex = Index;
				}
			}
			if (FoundIndex == -1)
			{
				FoundIndex = NumPackedCharLookups;
				memcpy(&PackedCharLookup[FoundIndex * PackedFont_NumColumns], &CharLookup[((YChar * SCROLLER_CHARWIDTH) + XChar) * PackedFont_NumColumns], PackedFont_NumColumns);
				NumPackedCharLookups++;
			}
			ScreenToPackedLookup[XChar][YChar] = FoundIndex;
		}
	}
	WriteBinaryFile(OutPackedCharLookupsBINFilename, PackedCharLookup, NumPackedCharLookups * PackedFont_NumColumns);
}

void BigScalingScroller_OutputCode(LPTSTR OutDrawCodeASM)
{
	CodeGen code(OutDrawCodeASM);

	code.OutputCodeLine(NONE, fmt::format(".var NumCharSets = {:d}", BMM_NumCharSets));
	code.OutputBlankLine();

	int CurrentLine = 0;
	for (int Index = 0; Index < BMM_NumCharSets + 1; Index++)
	{
		code.OutputCodeLine(NONE, fmt::format(".var IRQSplit{:d} = 50 + ({:d} * 8)", Index, CurrentLine));
		CurrentLine += BMM_CharSet_NumScreenLines[Index];
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("ScrollerIndexPtrsLo"));
	for (int Index = 0; Index < SCROLLER_CHARWIDTH; Index++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <(ScrollerIndex{:d} + 1)", Index));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("ScrollerIndexPtrsHi"));
	for (int Index = 0; Index < SCROLLER_CHARWIDTH; Index++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >(ScrollerIndex{:d} + 1)", Index));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("DrawScroller"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	code.OutputBlankLine();

	int YBank1 = 0;
	for (int Index = 0; Index < 7; Index++)
	{
		YBank1 += BMM_CharSet_NumScreenLines[Index];
	}

	for (int XChar = 0; XChar < SCROLLER_CHARWIDTH; XChar++)
	{
		code.OutputFunctionLine(fmt::format("ScrollerIndex{:d}", XChar));
		code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
		if (XChar == 0)
		{
			code.OutputCodeLine(STY_ZP, fmt::format("FinalYUpdate + 1", XChar));
		}
		else
		{
			code.OutputCodeLine(STY_ABS, fmt::format("ScrollerIndex{:d} + 1", XChar - 1));
		}

		bool bAIsZero = false;
		int XCharR = (XChar + 1) % SCROLLER_CHARWIDTH;
		for (int YChar = 0; YChar < SCROLLER_CHARHEIGHT; YChar++)
		{
			int DataIndexL = ScreenToPackedLookup[XChar][YChar];
			int DataIndexR = ScreenToPackedLookup[(XChar + 1) % SCROLLER_CHARWIDTH][YChar];
			if ((DataIndexL == 0) && (DataIndexR != 0))
			{
				if (!bAIsZero)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
					bAIsZero = true;
				}
				code.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress0 + ({:d} * 40)", YChar));
			}
		}

		for (int YChar = 0; YChar < SCROLLER_CHARHEIGHT; YChar++)
		{
			int DataIndex = ScreenToPackedLookup[XChar][YChar];
			if (DataIndex == 0)
			{
				continue;
			}
			code.OutputCodeLine(LDA_ABY, fmt::format("PackedScrollData + ({:d} * {:d})", DataIndex, PackedFont_NumColumns));
			code.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress0 + ({:d} * 40)", YChar));
		}
		code.OutputCodeLine(LDA_ABX, fmt::format("NextXValue"));
		code.OutputCodeLine(TAX);
		code.OutputBlankLine();
	}
	code.OutputFunctionLine(fmt::format("FinalYUpdate"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$ab"));
	code.OutputCodeLine(STY_ABS, fmt::format("ScrollerIndex{:d} + 1", SCROLLER_CHARWIDTH - 1));

	code.OutputCodeLine(RTS);
}

int BigScalingScroller_Main()
{
	BigScalingScroller_LoadFont("6502\\Parts\\BigScalingScroller\\Data\\font-64px.png");

	BigScalingScroller_Calc("Out\\6502\\Parts\\BigScalingScroller\\Sine.png", L"Out\\6502\\Parts\\BigScalingScroller\\CharSets.bin", L"Out\\6502\\Parts\\BigScalingScroller\\PackedCharLookups.bin");

	BigScalingScroller_OutputCode(L"Out\\6502\\Parts\\BigScalingScroller\\DrawScroller.asm");

	return 0;
}
