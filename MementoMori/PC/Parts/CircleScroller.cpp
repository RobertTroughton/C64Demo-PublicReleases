// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

static const int CIRCLESCROLL_WIDTH = 320;
static const int CIRCLESCROLL_HEIGHT = 200;
static const int CIRCLESCROLL_NUMCHARS = 96;
static const int CIRCLESCROLL_FONTWIDTH = 9;
static const int CIRCLESCROLL_FONTHEIGHT = 8;
static const int CIRCLESCROLL_NUMFRAMES = 4;

static const int CIRCLESCROLL_CHARWIDTH = CIRCLESCROLL_WIDTH / 8;

static unsigned char ScreenMask[CIRCLESCROLL_HEIGHT][CIRCLESCROLL_CHARWIDTH];

static unsigned char ScrollText[] = {
	"      we send our greetings to all of our friends - including but not limited to those in...   "
	"abnormal  -  "
	"abyss connection  -  "
	"active  -  "
	"albion  -  "
	"ancients  -  "
	"arise  -  "
	"arkanix labs  -  "
	"arsenic  -  "
	"artstate  -  "
	"artline designs  -  "
	"ate bit  -  "
	"atlantis  -  "
	"bonzai  -  "
	"booze design  -  "
	"camelot  -  "
	"cascade  -  "
	"censor design  -  "
	"checkpoint  -  "
	"chorus  -  "
	"cosine  -  "
	"covert bitops  -  "
	"crest  -  "
	"cupid  -  "
	"darklite  -  "
	"dekadence  -  "
	"delysid  -  "
	"demonix  -  "
	"desire  -  "
	"dss  -  "
	"excess  -  "
	"extend  -  "
	"extream  -  "
	"ffcg  -  "
	"fairlight  -  "
	"finnish gold  -  "
	"flood  -  "
	"fossil  -  "
	"glance  -  "
	"hack n trade  -  "
	"hemoroids  -  "
	"hitmen  -  "
	"hmf  -  "
	"hoaxers  -  "
	"hokuto force  -  "
	"judas  -  "
	"larsson bros  -  "
	"laxity  -  "
	"lethargy  -  "
	"level sixtyfour  -  "
	"lft  -  "
	"mahoney  -  "
	"mason  -  "
	"mayday!  -  "
	"mdg  -  "
	"mon  -  "
	"msl  -  "
	"nah kolor  -  "
	"noice  -  "
	"nostalgia  -  "
	"nuance  -  "
	"offence  -  "
	"onslaught  -  "
	"oxsid planetary  -  "
	"oxyron  -  "
	"padua  -  "
	"performers  -  "
	"plush  -  "
	"prosonix  -  "
	"proxima  -  "
	"pvm  -  "
	"rabenauge  -  "
	"razor  -  "
	"resource  -  "
	"role  -  "
	"samar  -  "
	"scs-trc  -  "
	"seventh sector  -  "
	"shape  -  "
	"singular  -  "
	"software of sweden  -  "
	"sync  -  "
	"tempest  -  "
	"the dreams  -  "
	"the noisy bunch  -  "
	"the seniors  -  "
	"the solution  -  "
	"tlr  -  "
	"triad  -  "
	"trsi  -  "
	"udi  -  "
	"undone  -  "
	"up rough  -  "
	"vision  -  "
	"wow  -  "
	"wrath designs      "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	">"
};

void CircleScroller_CalculateClipping(char* InBitmapFilename)
{
	GPIMAGE Font(InBitmapFilename);

	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 40; XChar++)
		{
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = YChar * 8 + YPixel;
				unsigned char Mask = 0x00;
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XChar * 8 + XPixel;
					if (Font.GetPixel(XPos, YPos) == 0x00ffffff)
					{
						Mask |= 1 << (7 - XPixel);
					}
				}
				ScreenMask[YPos][XChar] = Mask;
			}
		}
	}
}

void CircleScroller_OutputScrollText(void)
{
	bool bFinishedST = false;
	int ScrollTextIndex = 0;
	while (!bFinishedST)
	{
		unsigned char CurrentChar = ScrollText[ScrollTextIndex];

		switch (CurrentChar)
		{
		case '>':
			CurrentChar = 255;
			bFinishedST = true;
			break;

		case ' ':
			CurrentChar = 0;
			break;

		case '!':
			CurrentChar = 27;
			break;

		case '.':
			CurrentChar = 28;
			break;

		case ',':
			CurrentChar = 29;
			break;

		case '-':
			CurrentChar = 30;
			break;

		case '?':
			CurrentChar = 31;
			break;

		default:
			CurrentChar = CurrentChar & 0x1f;
			break;
		}

		ScrollText[ScrollTextIndex] = CurrentChar;
		ScrollTextIndex++;
	}

	WriteBinaryFile(L"Out\\6502\\Parts\\CircleScroller\\ScrollText.bin", ScrollText, ScrollTextIndex);
}

unsigned char ScreenData[CIRCLESCROLL_NUMFRAMES][CIRCLESCROLL_HEIGHT][CIRCLESCROLL_CHARWIDTH][3];
unsigned char ScreenCharData[25][40];
void CircleScroller_Do(LPTSTR DrawCircleASMFilename, LPTSTR CircleSCRFilename)
{
	static const int NumSineValues = CIRCLESCROLL_NUMFRAMES * CIRCLESCROLL_NUMCHARS;
	static const int SinXLen = CIRCLESCROLL_WIDTH - CIRCLESCROLL_FONTWIDTH;
	static const int SinYLen = CIRCLESCROLL_HEIGHT - CIRCLESCROLL_FONTHEIGHT;

	double SinXValues[NumSineValues];
	double SinYValues[NumSineValues];

	ZeroMemory(ScreenData, sizeof(ScreenData));

	memset(ScreenCharData, 0x0a, sizeof(ScreenCharData));

	for (int ItIndex = 0; ItIndex < NumSineValues; ItIndex++)
	{
		int Index = (ItIndex + (17 * CIRCLESCROLL_NUMFRAMES)) % NumSineValues;

		int FrameIndex = ItIndex % CIRCLESCROLL_NUMFRAMES;
		int CharIndex = ItIndex / CIRCLESCROLL_NUMFRAMES;

		double angle = (2 * PI * Index) / NumSineValues + PI / 2;
		double percentscale = max(0.0, min(1.0, (sin(angle * 6) + 1.0) / 2.0)) * 0.25 + 0.75;

		double dXSin = max(0.0, min(1.0, (sin(angle) * percentscale + 1.0) / 2.0)) * SinXLen;
		double dYSin = max(0.0, min(1.0, (cos(angle) * percentscale + 1.0) / 2.0)) * SinYLen;

		SinXValues[ItIndex] = dXSin;
		SinYValues[ItIndex] = dYSin;

		int XChar = ((int)dXSin) / 8;
		int YSin = (int)dYSin;

		for (int XCharOffset = 0; XCharOffset < 2; XCharOffset++)
		{
			for (int YPixelOffset = 0; YPixelOffset < CIRCLESCROLL_FONTHEIGHT; YPixelOffset++)
			{
				unsigned char NumChars = ScreenData[FrameIndex][YSin + YPixelOffset][XChar + XCharOffset][0];
				unsigned char Mask = ScreenMask[YSin + YPixelOffset][XChar + XCharOffset];

				if ((NumChars < 2) && (Mask != 0x00))
				{
					int YPos = YSin + YPixelOffset;
					int XCharPos = XChar + XCharOffset;

					ScreenData[FrameIndex][YPos][XCharPos][NumChars + 1] = CharIndex;
					ScreenData[FrameIndex][YPos][XCharPos][0]++;

					int xC = XChar + XCharOffset;
					int yC = (YSin + YPixelOffset) / 8;
					unsigned char ScrollCol = ((xC + yC) % 2) == 0 ? 0x07 : 0x0d;
					ScreenCharData[yC][xC] = ScrollCol;
				}
			}
		}
	}

	int IndexedLDA[2] = { LDA_ABX, LDA_ABY };
	int IndexedORA[2] = { ORA_ABX, ORA_ABY };
	int ImmLDXY[2] = { LDX_IMM, LDY_IMM };
	int AbsSTXY[2] = { STX_ABS, STY_ABS };

	CodeGen code(DrawCircleASMFilename);
	for (int FrameIndex = 0; FrameIndex < CIRCLESCROLL_NUMFRAMES; FrameIndex++)
	{
		code.OutputFunctionLine(fmt::format("DrawCircle_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		//; Blank all parts where we're not drawing but did on the previous frame...
		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		for (int YPos = 0; YPos < CIRCLESCROLL_HEIGHT; YPos++)
		{
			for (int XCharPos = 0; XCharPos < CIRCLESCROLL_CHARWIDTH; XCharPos++)
			{
				unsigned char NumChars = ScreenData[FrameIndex][YPos][XCharPos][0];
				unsigned char LastNumChars = ScreenData[(FrameIndex + 1) % CIRCLESCROLL_NUMFRAMES][YPos][XCharPos][0];
				if ((NumChars == 0) && (LastNumChars > 0))
				{
					unsigned char Mask = ScreenMask[YPos][XCharPos];
					if (Mask != 0x00)
					{
						code.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos / 8, XCharPos, YPos % 8));
					}
				}
			}
		}
		code.OutputBlankLine();

		code.OutputFunctionLine(fmt::format("Char000_Frame{:d}", FrameIndex));
		code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
		int Reg = 1;

		for (int CharIndex = 0; CharIndex < CIRCLESCROLL_NUMCHARS; CharIndex++)
		{
			int NextCharIndex = CharIndex + 1;
			if (NextCharIndex < CIRCLESCROLL_NUMCHARS)
			{
				code.OutputFunctionLine(fmt::format("Char{:03d}_Frame{:d}", NextCharIndex, FrameIndex));
				NextCharIndex %= CIRCLESCROLL_NUMCHARS;
				code.OutputCodeLine(ImmLDXY[Reg], fmt::format("#$00"));
				code.OutputCodeLine(AbsSTXY[Reg], fmt::format("Char{:03d}_Frame{:d} + 1", CharIndex, FrameIndex));
			}
			Reg = 1 - Reg;

			int SinIndex = CharIndex * CIRCLESCROLL_NUMFRAMES + FrameIndex;
			int XSin = (int)SinXValues[SinIndex];
			int YSin = (int)SinYValues[SinIndex];
			int XShift = XSin % 8;
			int XChar0 = XSin / 8;

			int NextSinIndex = NextCharIndex * CIRCLESCROLL_NUMFRAMES + FrameIndex;
			int NextXSin = (int)SinXValues[NextSinIndex];
			int NextYSin = (int)SinYValues[NextSinIndex];
			int NextXShift = NextXSin % 8;
			int XChar1 = NextXSin / 8;

			for (int XRelCharPos = 0; XRelCharPos < 2; XRelCharPos++)
			{
				for (int YPixel = 0; YPixel < CIRCLESCROLL_FONTHEIGHT; YPixel++)
				{
					int XCharPos = XChar0 + XRelCharPos;
					int YPos = YSin + YPixel;

					unsigned char NumChars = ScreenData[FrameIndex][YPos][XCharPos][0];
					unsigned char Char0 = ScreenData[FrameIndex][YPos][XCharPos][1];
					unsigned char Char1 = ScreenData[FrameIndex][YPos][XCharPos][2];
					int XRelCharPos = XCharPos - XChar0;

					int NextXRelCharPos = XCharPos - XChar1;
					int NextYPixel = YPos - NextYSin;

					if ((NumChars > 0)&&(Char0 == CharIndex))
					{
						unsigned char Mask = ScreenMask[YPos][XCharPos];
						if (Mask != 0x00)
						{
							code.OutputCodeLine(IndexedLDA[Reg], fmt::format("ShiftedFontData + ({:d} * 32) + ({:d} * 32 * 2) + ({:d} * 32 * 2 * 8)", XRelCharPos, XShift, YPixel));
							if ((NumChars >= 2) && (Char1 == NextCharIndex))
							{
								if ((NextYPixel >= 0) && (NextYPixel < CIRCLESCROLL_FONTHEIGHT))
								{
									code.OutputCodeLine(IndexedORA[1 - Reg], fmt::format("ShiftedFontData + ({:d} * 32) + ({:d} * 32 * 2) + ({:d} * 32 * 2 * 8)", NextXRelCharPos, NextXShift, NextYPixel));
								}
							}
							if (Mask != 0xff)
							{
								code.OutputCodeLine(AND_IMM, fmt::format("#${:02x}", Mask));
							}
							code.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos / 8, XCharPos, YPos % 8));
						}
					}
				}
			}
		}

		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
	WriteBinaryFile(CircleSCRFilename, ScreenCharData, sizeof(ScreenCharData));
}

void CircleScroller_ConvertFontToShiftedFont(char* InFontFilename, LPTSTR OutFontBINFilename)
{
	GPIMAGE Font(InFontFilename);

	int NumChars = Font.Width / 10;

	unsigned char OutData[CIRCLESCROLL_FONTHEIGHT][8][2][32];
	ZeroMemory(OutData, sizeof(OutData));

	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		for (int Shift = 0; Shift < 8; Shift++)
		{
			for (int YPixel = 0; YPixel < CIRCLESCROLL_FONTHEIGHT; YPixel++)
			{
				for (int XPixel = 0; XPixel < 9; XPixel++)
				{
					int XPos = CharIndex * 10 + XPixel;
					int OutXPixel = XPixel + Shift;
					if (Font.GetPixel(XPos, YPixel))
					{
						int XCharPos = OutXPixel / 8;
						int XBitPos = OutXPixel % 8;
						OutData[YPixel][Shift][XCharPos][CharIndex] |= 1 << (7 - XBitPos);
					}
				}
			}
		}
	}
	WriteBinaryFile(OutFontBINFilename, OutData, sizeof(OutData));
}

int CircleScroller_Main()
{
	CircleScroller_CalculateClipping("6502\\Parts\\CircleScroller\\Data\\BKG.png");

	CircleScroller_Do(L"Out\\6502\\Parts\\CircleScroller\\DrawCircle.asm", L"Out\\6502\\Parts\\CircleScroller\\Circle.scr");

	CircleScroller_ConvertFontToShiftedFont("6502\\Parts\\CircleScroller\\Data\\Font9x8-Raistlin.png", L"Out\\6502\\Parts\\CircleScroller\\FontShifted.bin");

	CircleScroller_OutputScrollText();

	return 0;
}
