// (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"

static const int GREETINGSCROLL_WIDTH = 320;
static const int GREETINGSCROLL_HEIGHT = 200;
static const int GREETINGSCROLL_NUMCHARS = 250;
static const int GREETINGSCROLL_FONTWIDTH = 5;
static const int GREETINGSCROLL_XSPACING = 6;
static const int GREETINGSCROLL_FONTHEIGHT = 5;
static const int GREETINGSCROLL_NUMFRAMES = 3;

static const int GREETINGSCROLL_CHARWIDTH = GREETINGSCROLL_WIDTH / 8;
static const int MAX_NUM_WRITES_PER_BYTE = 8;

static unsigned char ScrollText[] = {
	"      we would like to wish all of our friends a very merry christmas - and a happy new year! let us hope that the next year brings brighter things for all of us. special christmas hugs to  -  "
	"abnormal  -  "
	"abyss connection  -  "
	"active  -  "
	"albion  -  "
	"alpha flight  -  "
	"ancients  -  "
	"arise  -  "
	"arkanix labs  -  "
	"arsenic  -  "
	"artstate  -  "
	"artline designs  -  "
	"ate bit  -  "
	"bauknecht  -  "
	"booze design  -  "
	"camelot  -  "
	"cascade  -  "
	"censor design  -  "
	"checkpoint  -  "
	"chorus  -  "
	"cosine  -  "
	"covert bitops  -  "
	"crest  -  "
	"csdb.dk  -  "
	"csixtyfour.com  -  "
	"darklite  -  "
	"dekadence  -  "
	"delysid  -  "
	"demonix  -  "
	"dentifrice  -  "
	"desire  -  "
	"dss  -  "
	"elysium  -  "
	"excess  -  "
	"exclusive on  -  "
	"extend  -  "
	"extream  -  "
	"ffourcg  -  "
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
	"ian coog  -  "
	"judas  -  "
	"larsson bros  -  "
	"laxity  -  "
	"level sixtyfour  -  "
	"lft  -  "
	"mahoney  -  "
	"maniacs of noise  -  "
	"mason  -  "
	"mayday!  -  "
	"masters design group  -  "
	"multistyle labs  -  "
	"nah-kolor  -  "
	"noice  -  "
	"nostalgia  -  "
	"nuance  -  "
	"onslaught  -  "
	"oxsid planetary  -  "
	"oxyron  -  "
	"padua  -  "
	"panda design  -  "
	"panoramic design  -  "
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
	"siesta  -  "
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
	"underground domain inc  -  "
	"undone  -  "
	"up rough  -  "
	"vision  -  "
	"warriors of the wasteland  -  "
	"wrath designs  -  "
	"x-ample  "
	"                   "
	"                   "
	"         the santas will return      "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	"                   "
	">"
};

void GreetingScroller_OutputScrollText(void)
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
			CurrentChar = 28;
			break;

		case '.':
			CurrentChar = 27;
			break;

		case '-':
			CurrentChar = 29;
			break;

		default:
			CurrentChar = CurrentChar & 0x1f;
			if (CurrentChar > 26)
				CurrentChar = 0;
			break;
		}

		ScrollText[ScrollTextIndex] = CurrentChar;
		ScrollTextIndex++;
	}

	WriteBinaryFile(L"Out\\6502\\Parts\\GreetingScroller\\ScrollText.bin", ScrollText, ScrollTextIndex);
}

unsigned int CharPlots[GREETINGSCROLL_NUMFRAMES][GREETINGSCROLL_HEIGHT][GREETINGSCROLL_CHARWIDTH][MAX_NUM_WRITES_PER_BYTE];
unsigned int NumCharPlots[GREETINGSCROLL_NUMFRAMES][GREETINGSCROLL_HEIGHT][GREETINGSCROLL_CHARWIDTH];

void GreetingScroller_Do(LPTSTR DrawShapeASMFilename)
{
	static const int NumSineValues = GREETINGSCROLL_NUMFRAMES * GREETINGSCROLL_NUMCHARS;
	static const int SinXLen = GREETINGSCROLL_WIDTH - GREETINGSCROLL_FONTWIDTH;
	static const int SinYLen = GREETINGSCROLL_HEIGHT - GREETINGSCROLL_FONTHEIGHT;

	double SinXValues[NumSineValues];
	double SinYValues[NumSineValues];

	ZeroMemory(CharPlots, sizeof(CharPlots));
	ZeroMemory(NumCharPlots, sizeof(NumCharPlots));

	for (int ItIndex = 0; ItIndex < NumSineValues; ItIndex++)
	{
		double InvAngle = (ItIndex * 0.5 * PI) / NumSineValues;//; +PI / 2.0;
		double dInvIndex = (1.0 - sin(InvAngle)) * (NumSineValues - 1.0);
		int InvIndex = (int)dInvIndex;

		int FrameIndex = ItIndex % GREETINGSCROLL_NUMFRAMES;
		int CharIndex = ItIndex / GREETINGSCROLL_NUMFRAMES;

		int WaveNumSineValues = (int)(NumSineValues / 14.0);
		int WaveIndex = InvIndex % WaveNumSineValues;
		double WaveAngle = (PI * WaveIndex) / WaveNumSineValues;
		double WaveRadius = 100.0 - (100.0 * dInvIndex) / NumSineValues;
		double WaveHeight = 25.0;

		double Angle = (PI * 2.0 * dInvIndex) / (NumSineValues / 7.0);

		double dXSin = sin(Angle + PI / 2) * WaveRadius + 160.0;
		double dYSin = ((sin(WaveAngle) + 1.0) * 0.5) * WaveHeight + 175.0 - ((180.0 * dInvIndex) / NumSineValues);

		SinXValues[ItIndex] = dXSin;
		SinYValues[ItIndex] = dYSin;

		int XChar = ((int)dXSin) / 8;
		int YSin = (int)dYSin;

		int XShift = ((int)dXSin) % 8;
		unsigned char YOffset = (unsigned char)YSin;

		int NumCharsHit = (XShift > 3) ? 2 : 1;

		for (int XCharOffset = 0; XCharOffset < NumCharsHit; XCharOffset++)
		{
			for (int YPixelOffset = 0; YPixelOffset < GREETINGSCROLL_FONTHEIGHT; YPixelOffset++)
			{
				int iY = YSin + YPixelOffset;
				int XCharPos = XChar + XCharOffset;

				int NumToCheck = min(MAX_NUM_WRITES_PER_BYTE, NumCharPlots[FrameIndex][iY][XCharPos]);
				int FoundIndex = -1;
				for (int i = 0; i < NumToCheck; i++)
				{
					if (CharPlots[FrameIndex][iY][XCharPos][i] == CharIndex)
					{
						FoundIndex = i;
						break;
					}
				}
				if (FoundIndex == -1)
				{
					FoundIndex = NumToCheck;

					NumCharPlots[FrameIndex][iY][XCharPos]++;
				}
				if (FoundIndex < MAX_NUM_WRITES_PER_BYTE)
				{
					CharPlots[FrameIndex][iY][XCharPos][FoundIndex] = CharIndex;
				}
			}
		}
	}

	int IndexedLDA[2] = { LDA_ABX, LDA_ABY };
	int IndexedORA[2] = { ORA_ABX, ORA_ABY };
	int ImmLDXY[2] = { LDX_IMM, LDY_IMM };
	int AbsLDXY[2] = { LDX_ABS, LDY_ABS };
	int AbsSTXY[2] = { STX_ABS, STY_ABS };


	int MaxCharIndexPlotted = -1;
	for (int FrameIndex = 0; FrameIndex < GREETINGSCROLL_NUMFRAMES; FrameIndex++)
	{
		for (int CharIndex = 0; CharIndex < GREETINGSCROLL_NUMCHARS; CharIndex++)
		{
			int SinIndex = CharIndex * GREETINGSCROLL_NUMFRAMES + FrameIndex;
			int XSin = (int)SinXValues[SinIndex];
			int XChar0 = XSin / 8;

			if (XChar0 < 32)
			{
				MaxCharIndexPlotted = max(MaxCharIndexPlotted, CharIndex);
			}
		}
	}

	CodeGen code(DrawShapeASMFilename);

	code.OutputCodeLine(NONE, fmt::format(".import source \"../../../../6502/Main/Main-CommonDefines.asm\""));
	code.OutputCodeLine(NONE, fmt::format(".import source \"../../../../6502/Main/Main-CommonMacros.asm\""));
	code.OutputCodeLine(NONE, fmt::format(".import source \"../../../../6502/Parts/GreetingScroller/GreetingScroller-CommonDefines.asm\""));
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("* = GreetingsScrollerDrawShape_BASE"));
	code.OutputBlankLine();
	code.OutputCodeLine(NONE, fmt::format(".import source \"ShiftedFont.asm\""));
	code.OutputBlankLine();
	code.OutputFunctionLine(fmt::format("FinalChar"));
	code.OutputCodeLine(NONE, fmt::format(".byte $00"));
	code.OutputBlankLine();

	for (int FrameIndex = 0; FrameIndex < GREETINGSCROLL_NUMFRAMES; FrameIndex++)
	{
		code.ResetCounters();

		int LastFrameIndex = (FrameIndex + 1) % GREETINGSCROLL_NUMFRAMES;
		code.OutputFunctionLine(fmt::format("DrawShape_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		//; Blank all parts where we're not drawing but did on the previous frame...
		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		for (int YPos = 0; YPos < GREETINGSCROLL_HEIGHT; YPos++)
		{
			for (int XCharPos = 0; XCharPos < GREETINGSCROLL_CHARWIDTH; XCharPos++)
			{
				if ((XCharPos >= 32) || (XCharPos < 8))
					continue;

				unsigned int NumChars = NumCharPlots[FrameIndex][YPos][XCharPos];
				unsigned int LastNumChars = NumCharPlots[LastFrameIndex][YPos][XCharPos];
				if ((NumChars == 0) && (LastNumChars > 0))
				{
					code.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos / 8, XCharPos, YPos % 8));
				}
			}
		}
		code.OutputBlankLine();

		code.OutputFunctionLine(fmt::format("Char000_Frame{:d}", FrameIndex));
		code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
		int Reg = 1;

		for (int CharIndex = 0; CharIndex < MaxCharIndexPlotted; CharIndex++)
		{
			int NextCharIndex = CharIndex + 1;

			int SinIndex = CharIndex * GREETINGSCROLL_NUMFRAMES + FrameIndex;
			int XSin = (int)SinXValues[SinIndex];
			int YSin = (int)SinYValues[SinIndex];
			int XShift = XSin % 8;
			int XChar0 = XSin / 8;

			int NextSinIndex = NextCharIndex * GREETINGSCROLL_NUMFRAMES + FrameIndex;
			int NextXSin = (int)SinXValues[NextSinIndex];
			int NextYSin = (int)SinYValues[NextSinIndex];
			int NextXShift = NextXSin % 8;
			int XChar1 = NextXSin / 8;

			if (NextCharIndex < GREETINGSCROLL_NUMCHARS)
			{
				if (NextCharIndex == MaxCharIndexPlotted)
				{
					code.OutputCodeLine(AbsLDXY[Reg], fmt::format("FinalChar"));
				}
				else
				{
					code.OutputFunctionLine(fmt::format("Char{:03d}_Frame{:d}", NextCharIndex, FrameIndex));
					code.OutputCodeLine(ImmLDXY[Reg], fmt::format("#$00"));
				}
				code.OutputCodeLine(AbsSTXY[Reg], fmt::format("Char{:03d}_Frame{:d} + 1", CharIndex, FrameIndex));
				Reg = 1 - Reg;
			}

			for (int XRelCharPos = 0; XRelCharPos < 2; XRelCharPos++)
			{
				int XCharPos = XChar0 + XRelCharPos;

				if (XCharPos >= 32)
					continue;

				for (int YPixel = 0; YPixel < GREETINGSCROLL_FONTHEIGHT; YPixel++)
				{
					int YPos = YSin + YPixel;

					unsigned int NumChars = NumCharPlots[FrameIndex][YPos][XCharPos];
					int Index0 = -1;
					int Index1 = -1;

					int NextXRelCharPos = XCharPos - XChar1;
					int NextYPixel = YPos - NextYSin;

					bool bAlreadyWrittenHere = false;
					for (unsigned int Index = 0; Index < NumChars; Index++)
					{
						if ((CharPlots[FrameIndex][YPos][XCharPos][Index]) == CharIndex)
						{
							Index0 = Index;
						}
						if ((CharPlots[FrameIndex][YPos][XCharPos][Index]) == NextCharIndex)
						{
							Index1 = Index;
						}
						if ((CharPlots[FrameIndex][YPos][XCharPos][Index]) == 0xffff)
						{
							bAlreadyWrittenHere = true;
						}
					}

					if (Index0 != -1)
					{
						code.OutputCodeLine(IndexedLDA[Reg], fmt::format("ShiftedFont_Shift{:d}_Y{:d}_Side{:d}", XShift, YPixel, XRelCharPos));
						CharPlots[FrameIndex][YPos][XCharPos][Index0] = 0xffff;

						if (Index1 != -1)
						{
							code.OutputCodeLine(IndexedORA[1 - Reg], fmt::format("ShiftedFont_Shift{:d}_Y{:d}_Side{:d}", NextXShift, NextYPixel, NextXRelCharPos));
							CharPlots[FrameIndex][YPos][XCharPos][Index1] = 0xffff;
						}

						if (bAlreadyWrittenHere)
							code.OutputCodeLine(ORA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos / 8, XCharPos, YPos % 8));;

						code.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress + ({:d} * 320) + ({:d} * 8) + {:d}", YPos / 8, XCharPos, YPos % 8));
					}
				}
			}
		}

		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
}

void GreetingScroller_ConvertFontToShiftedFont(char* InFontFilename, LPTSTR OutFontASMFilename)
{
	GPIMAGE Font(InFontFilename);

	CodeGen Code(OutFontASMFilename);

	int NumChars = Font.Width / GREETINGSCROLL_XSPACING;

	unsigned char OutData[GREETINGSCROLL_FONTHEIGHT][8][2][32];
	ZeroMemory(OutData, sizeof(OutData));

	for (int Shift = 0; Shift < 8; Shift++)
	{
		for (int YPixel = 0; YPixel < GREETINGSCROLL_FONTHEIGHT; YPixel++)
		{
			for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
			{
				for (int XPixel = 0; XPixel < GREETINGSCROLL_FONTWIDTH; XPixel++)
				{
					int XPos = CharIndex * GREETINGSCROLL_XSPACING + XPixel;
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

	Code.OutputCodeLine(NONE, fmt::format(".align 32"));
	for (int Shift = 0; Shift < 8; Shift++)
	{
		for (int YPixel = 0; YPixel < GREETINGSCROLL_FONTHEIGHT; YPixel++)
		{
			int NumBytes = (Shift > 3) ? 2 : 1;
			for (int ByteIndex = 0; ByteIndex < NumBytes; ByteIndex++)
			{
				Code.OutputFunctionLine(fmt::format("ShiftedFont_Shift{:d}_Y{:d}_Side{:d}", Shift, YPixel, ByteIndex));
				Code.OutputByteBlock(OutData[YPixel][Shift][ByteIndex], 32, 16);
			}
		}
	}
}

void GreetingScroller_ConvertBackgroundImage(char* InPNGFilename, LPTSTR OutMAPFilename, LPTSTR OutSCRFilename)
{
	GPIMAGE Image(InPNGFilename);
	int iW = Image.Width;
	int iH = Image.Height;
	int iCharW = iW / 8;
	int iCharH = iH / 8;
	unsigned char OutMAP[25 * 40 * 8];
	unsigned char OutSCR[25 * 40];
	ZeroMemory(OutMAP, sizeof(OutMAP));
	ZeroMemory(OutSCR, sizeof(OutSCR));
	for (int iYChar = 0; iYChar < iCharH; iYChar++)
	{
		int MinX = 8;
		int MaxX = 32;
		int Dist = 0;
		if (iYChar < (iCharH - 5))
			Dist = iCharH - 5 - iYChar;
		MinX += (Dist / 2);
		MaxX -= (Dist / 2);

		for (int iXChar = 0; iXChar < iCharW; iXChar++)
		{
			unsigned char Col0 = 0xff, Col1 = 0xff;

			if ((iXChar < MaxX) && (iXChar >= MinX)) //; scroller part
			{
				Col0 = Image.GetPixelPaletteColour(iXChar * 8 + 3, iYChar * 8 + 4);
				Col1 = 0x0d;
			}
			else
			{
				for (int iYPixel = 0; iYPixel < 8; iYPixel++)
				{
					int iYPos = iYChar * 8 + iYPixel;
					for (int iXPixel = 0; iXPixel < 8; iXPixel++)
					{
						int iXPos = iXChar * 8 + iXPixel;
						unsigned char Col = Image.GetPixelPaletteColour(iXPos, iYPos);

						bool bIsCol0 = (Col == Col0);
						bool bIsCol1 = (Col == Col1);

						if (!bIsCol0 && !bIsCol1)
						{
							if (Col0 == 0xff)
								Col0 = Col;
							else if (Col1 == 0xff)
								Col1 = Col;
						}
					}
				}
				if (Col0 > Col1)
				{
					unsigned char TmpCol = Col0;
					Col0 = Col1;
					Col1 = TmpCol;
				}

				for (int iYPixel = 0; iYPixel < 8; iYPixel++)
				{
					int iYPos = iYChar * 8 + iYPixel;
					for (int iXPixel = 0; iXPixel < 8; iXPixel++)
					{
						int iXPos = iXChar * 8 + iXPixel;
						unsigned char Col = Image.GetPixelPaletteColour(iXPos, iYPos);

						bool bIsCol0 = (Col == Col0);
						bool bIsCol1 = (Col == Col1);

						unsigned char BitValue = 0;
						if (bIsCol1)
							BitValue = 1;

						OutMAP[((iYChar * 40) + iXChar) * 8 + iYPixel] |= (BitValue << (7 - iXPixel));
					}
				}
			}

			//; Make "TurnDisk" logos invisible initially
			if (
				((iXChar >= 5) && (iXChar < 12) && (iYChar >= 4) && (iYChar < 10)) ||
				((iXChar >= 29) && (iXChar < 36) && (iYChar >= 4) && (iYChar < 10))
				)
			{
				Col0 = Col1;
			}

			unsigned char OutSCRVal = (Col1 << 4) | Col0;
			OutSCR[(iYChar * 40) + iXChar] = OutSCRVal;
		}
	}
	WriteBinaryFile(OutMAPFilename, OutMAP, sizeof(OutMAP));
	WriteBinaryFile(OutSCRFilename, OutSCR, sizeof(OutSCR));
}

void GreetingScroller_ConvertSprites(char* InMCSpritesPNG, char* InHISpritesPNG, LPTSTR OutSpritesMAP)
{
	unsigned char OutSpriteData[6][64];
	ZeroMemory(OutSpriteData, sizeof(OutSpriteData));

	GPIMAGE ImgMCSprites(InMCSpritesPNG);
	for (int iYSprite = 0; iYSprite < 2; iYSprite++)
	{
		for (int iXSprite = 0; iXSprite < 2; iXSprite++)
		{
			for (int iYPixel = 0; iYPixel < 21; iYPixel++)
			{
				for (int iXChar = 0; iXChar < 3; iXChar++)
				{
					unsigned char OutByte = 0;
					for (int iXPixel = 0; iXPixel < 8; iXPixel += 2)
					{
						int iInXPos = iXSprite * 24 + iXChar * 8 + iXPixel;
						int iInYPos = iYSprite * 21 + iYPixel;
						unsigned char ColVal = ImgMCSprites.GetPixelPaletteColour(iInXPos, iInYPos);
						if (ColVal == 15)
							OutByte |= 1 << (6 - iXPixel);
						else if (ColVal == 7)
							OutByte |= 2 << (6 - iXPixel);
						else if (ColVal == 1)
							OutByte |= 3 << (6 - iXPixel);
					}
					OutSpriteData[iYSprite * 2 + iXSprite][iYPixel * 3 + iXChar] = OutByte;
				}
			}
		}
	}

	GPIMAGE ImgHISprites(InHISpritesPNG);
	for (int iYSprite = 0; iYSprite < 2; iYSprite++)
	{
		for (int iYPixel = 0; iYPixel < 21; iYPixel++)
		{
			for (int iXChar = 0; iXChar < 3; iXChar++)
			{
				unsigned char OutByte = 0;
				for (int iXPixel = 0; iXPixel < 8; iXPixel++)
				{
					int iInXPos = iXChar * 8 + iXPixel;
					int iInYPos = iYSprite * 21 + iYPixel;
					unsigned char ColVal = ImgHISprites.GetPixelPaletteColour(iInXPos, iInYPos);
					if (ColVal != 0)
						OutByte |= 1 << (7 - iXPixel);
				}
				OutSpriteData[4 + iYSprite][iYPixel * 3 + iXChar] = OutByte;
			}
		}
	}

	WriteBinaryFile(OutSpritesMAP, OutSpriteData, sizeof(OutSpriteData));
}

void GreetingScroller_GenSpriteMaskData(LPTSTR OutSpriteMaskDataBIN)
{
	unsigned char OutData[8][256];
	ZeroMemory(OutData, sizeof(OutData));

	unsigned char SpriteData[64];
	ZeroMemory(SpriteData, sizeof(SpriteData));

	for (int j = 0; j < 2; j++)
	{
		int OutOffset = 0;
		int Block = 0;
		memset(SpriteData, 255, sizeof(SpriteData));
		for (int i = 0; i < 24 * 21; i++)
		{
			bool bFound = false;
			unsigned char ByteIndex = 0;
			unsigned char Mask = 0;
			while (!bFound)
			{
				int Val = rand() % (24 * 21);
				ByteIndex = Val / 8;
				Mask = 1 << (Val % 8);
				if ((SpriteData[ByteIndex] & Mask) != 0)
				{
					bFound = true;
				}
			}
			SpriteData[ByteIndex] -= Mask;

			if (j == 0)
			{
				OutData[Block + 0][OutOffset] = ByteIndex;
				OutData[Block + 1][OutOffset] = SpriteData[ByteIndex];
			}
			else
			{
				OutData[Block + 4][OutOffset] = ByteIndex;
				OutData[Block + 5][OutOffset] = 0xff - SpriteData[ByteIndex];
			}
			Block = (Block + 2) % 4;
			if (!Block)
			{
				OutOffset++;

				int OutOffsetMask = (j == 0) ? 1 : 3;
				if ((OutOffset & OutOffsetMask) == 0)
				{
					unsigned char Tmp0 = SpriteData[60];
					unsigned char Tmp1 = SpriteData[61];
					unsigned char Tmp2 = SpriteData[62];
					for (int y = 19; y >= 0; y--)
					{
						SpriteData[y * 3 + 3] = SpriteData[y * 3 + 0];
						SpriteData[y * 3 + 4] = SpriteData[y * 3 + 1];
						SpriteData[y * 3 + 5] = SpriteData[y * 3 + 2];
					}
					SpriteData[0] = Tmp0;
					SpriteData[1] = Tmp1;
					SpriteData[2] = Tmp2;
				}
			}
		}
		OutData[(j * 4) + 0][OutOffset] = OutData[(j * 4) + 1][OutOffset] = OutData[(j * 4) + 2][OutOffset] = OutData[(j * 4) + 3][OutOffset] = 255;
	}
	WriteBinaryFile(OutSpriteMaskDataBIN, OutData, sizeof(OutData));
}


int GreetingScroller_Main()
{
	GreetingScroller_Do(L"Out\\6502\\Parts\\GreetingScroller\\DrawShape.asm");

	GreetingScroller_ConvertFontToShiftedFont("6502\\Parts\\GreetingScroller\\Data\\5x5Font.png", L"Out\\6502\\Parts\\GreetingScroller\\ShiftedFont.asm");

	GreetingScroller_OutputScrollText();

	GreetingScroller_ConvertBackgroundImage("6502\\Parts\\GreetingScroller\\Data\\bkg.png", L"Out\\6502\\Parts\\GreetingScroller\\bkg.map", L"Out\\6502\\Parts\\GreetingScroller\\bkg.scr");

	GreetingScroller_ConvertSprites("6502\\Parts\\GreetingScroller\\Data\\StarMC.png", "6502\\Parts\\GreetingScroller\\Data\\StarHI.png", L"Out\\6502\\Parts\\GreetingScroller\\StarSprites.map");

	GreetingScroller_GenSpriteMaskData(L"Out\\6502\\Parts\\GreetingScroller\\SpriteMaskData.bin");

	return 0;
}
