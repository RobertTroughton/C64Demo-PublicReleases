// (c) Genesis*Project

#include "..\Common\Common.h"

static const int NUM_CHARS = 104;
static const double CIRCLE_CENTRE_X = 96.0;
static const double CIRCLE_CENTRE_Y = 96.0;

static const int NUM_SPRITE_ROWS = 4;

static const int FONT_NUMCHARS = 32;
static const int FONT_W = 5;
static const int FONT_H = 5;

static const int NumFrames = 3;

unsigned int CharPlots[NumFrames][25][200][8];
unsigned int NumCharPlots[4][25][200];
unsigned char ScreenMap[10][1024];
unsigned char CharSetWrites[4][256][8];


unsigned char ScreenColourTable[40 + 24] = {
	12, 12, 12, 12, 12, 12, 12, 12,
	12, 12, 12, 12, 12, 12, 15,  1,
	 1,  1,  1,  1,  1,  1,  1,  1,
	 1,  1,  1,  1,  1,  1,  1,  1,
	 1,  1,  1,  1,  1,  1,  1,  1,
	 1,  1,  1,  1,  1,  1,  1, 15,
	12, 12, 12, 12, 12, 12, 12, 12,
	12, 12, 12, 12, 12, 12, 12, 12,
};

static unsigned char ScrollText[] = {
	"      we send our greetings to all of our friends - including but not limited to those in           "
	"abnormal - "
	"abyss connection - "
	"active - "
	"agenda - "
	"albion - "
	"ancients - "
	"arise - "
	"arkanix labs - "
	"arsenic - "
	"artstate - "
	"artline designs - "
	"ate bit - "
	"atlantis - "
	"babygang - "
	"bloodsuckers - "
	"bonzai - "
	"booze design - "
	"breeze - "
	"camelot - "
	"cascade - "
	"censor design - "
	"checkpoint - "
	"chorus - "
	"cosine - "
	"covert bitops - "
	"crest - "
	"cupid - "
	"darklite - "
	"dekadence - "
	"delysid - "
	"demonix - "
	"desire - "
	"digital excess - "
	"dss - "
	"elysum - "
	"excess - "
	"exclusive on - "
	"extend - "
	"extream - "
	"f4cg - "
	"faic - "
	"fatzone - "
	"fairlight - "
	"finnish gold - "
	"flood - "
	"fossil - "
	"glance - "
	"graffity - "
	"hack n trade - "
	"hemoroids - "
	"hitmen - "
	"hmf - "
	"hoaxers - "
	"hokuto force - "
	"ibb - "
	"iz8dwf - "
	"judas - "
	"kraze - "
	"larsson bros - "
	"laxity - "
	"lepsi de - "
	"lethargy - "
	"level sixtyfour - "
	"lft - "
	"mahoney - "
	"mason - "
	"mayday - "
	"mdg - "
	"mon - "
	"msl - "
	"nah kolor - "
	"noice - "
	"nostalgia - "
	"nuance - "
	"offence - "
	"onslaught - "
	"oxsid planetary - "
	"oxyron - "
	"padua - "
	"performers - "
	"plush - "
	"pretzel logic - "
	"prosonix - "
	"proxima - "
	"pvm - "
	"rabenauge - "
	"razor - "
	"rebels - "
	"resource - "
	"role - "
	"samar - "
	"scs-trc - "
	"shape - "
	"sid divers - "
	"silicon ltd - "
	"singular - "
	"software of sweden - "
	"sync - "
	"tempest - "
	"the dreams - "
	"the noisy bunch - "
	"the seventh sector - "
	"the solaris agency - "
	"the solution - "
	"tlr - "
	"triad - "
	"trsi - "
	"udi - "
	"undone - "
	"up rough - "
	"vision - "
	"wiseguy industries - "
	"wow - "
	"wrath designs - "
	"xenon      "
	"                   "
	"                   "
	"                   "
	"                   "
	" "
};

int SizeScrollText = sizeof(ScrollText) / sizeof(ScrollText[0]);

static const int MaxNumChars = 64;
static unsigned char ScrollTextUniqueChars[MaxNumChars];
static unsigned char ScrollTextUniqueCharRemapping[MaxNumChars];
static int ScrollTextNumUniqueChars = 0;

void TCS_GeneratePlotCode(LPTSTR OutPlotCodeASM, LPTSTR OutScreensBIN)
{
	ZeroMemory(CharPlots, sizeof(CharPlots));
	ZeroMemory(NumCharPlots, sizeof(NumCharPlots));
	ZeroMemory(ScreenMap, sizeof(ScreenMap));
	ZeroMemory(CharSetWrites, sizeof(CharSetWrites));

	for (int FrameIndex = 0; FrameIndex < NumFrames; FrameIndex++)
	{
		for (int Circle = 0; Circle < 3; Circle++)
		{
			for (int CharIndex = 0; CharIndex < NUM_CHARS; CharIndex++)
			{
				double Angle = (((double)(CharIndex * NumFrames + FrameIndex)) * 2 * PI) / (double)(NUM_CHARS * NumFrames);

				double Radius = (170.0 + sin(Angle * 5.0) * 30.0) / 2.0;

				int iXPos = (int)floor(CIRCLE_CENTRE_X + (sin(Angle) * Radius) - 80.0 + (Circle * 80.0) + 0.5);
				int iYPos = (int)floor(CIRCLE_CENTRE_Y - (cos(Angle) * Radius) - 80.0 + (Circle * 80.0) + 0.5);
				int iXPos0 = max(0, min(iXPos, 200));
				int iXPos1 = max(0, min(iXPos + FONT_W, 200));
				int iYPos0 = max(0, min(iYPos, 200));
				int iYPos1 = max(0, min(iYPos + FONT_H, 200));

				int XChar = iXPos0 / 8;

				for (int iY = iYPos0; iY < iYPos1; iY++)
				{
					int YChar = iY / 8;
					int XCharLeft = max(0, 25 - YChar - 10);
					int XCharRight = min(25, 25 - YChar + 10);

					unsigned char XShift = iXPos0 % 8;
					unsigned char YOffset = (unsigned char)(iY - iYPos);
					unsigned int WriteValue = CharIndex | (XShift << 8) | (YOffset << 16);

					if ((XChar < XCharRight) && (XChar >= XCharLeft))
					{
						int NumToCheck0 = min(8, NumCharPlots[FrameIndex][XChar][iY]);
						int FoundIndex0 = -1;
						for (int i = 0; i < NumToCheck0; i++)
						{
							if (CharPlots[FrameIndex][XChar][iY][i] == WriteValue)
							{
								FoundIndex0 = i;
								break;
							}
						}
						if (FoundIndex0 == -1)
						{
							FoundIndex0 = NumToCheck0;

							NumCharPlots[FrameIndex][XChar][iY]++;
						}
						if (FoundIndex0 < 8)
						{
							CharPlots[FrameIndex][XChar][iY][FoundIndex0] = WriteValue;
						}
					}

					if (XShift > (8 - FONT_W))
					{
						int XCharR = XChar + 1;
						if ((XCharR < XCharRight) && (XCharR >= XCharLeft))
						{
							WriteValue |= 0x80000000;

							int NumToCheck1 = min(7, NumCharPlots[FrameIndex][XCharR][iY]);
							int FoundIndex1 = -1;
							for (int i = 0; i < NumToCheck1; i++)
							{
								if (CharPlots[FrameIndex][XCharR][iY][i] == WriteValue)
								{
									FoundIndex1 = i;
									break;
								}
							}
							if (FoundIndex1 == -1)
							{
								FoundIndex1 = NumToCheck1;
								NumCharPlots[FrameIndex][XCharR][iY]++;
							}
							CharPlots[FrameIndex][XCharR][iY][FoundIndex1] = WriteValue;
						}
					}
				}
			}
		}
	}

	unsigned char PlotChars[25][25];
	ZeroMemory(PlotChars, sizeof(PlotChars));

	int NumCharsUsed = 1;
	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 25; XChar++)
		{
			bool bCharUsed = false;
			for (int FrameIndex = 0; FrameIndex < NumFrames; FrameIndex++)
			{
				for (int YPixel = 0; YPixel < 8; YPixel++)
				{
					int YPos = YChar * 8 + YPixel;
					if (NumCharPlots[FrameIndex][XChar][YPos] > 0)
					{
						bCharUsed = true;
					}
				}
			}
			if (bCharUsed)
			{
				if (NumCharsUsed < 256)
				{
					PlotChars[YChar][XChar] = NumCharsUsed;
				}
				NumCharsUsed++;
			}
		}
	}

	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 25; XChar++)
		{
			unsigned char ThisChar = PlotChars[YChar][XChar];
			if (ThisChar > 0)
			{
				for (int Screen = 0; Screen < 10; Screen++)
				{
					for (int Repeat = 0; Repeat < 8; Repeat++)
					{
						int NewX = XChar - 30 + (Repeat * 10) - Screen + 7;
						int NewY = YChar - 30 + (Repeat * 10) - Screen;
						if ((NewX >= 0) && (NewX < 40) && (NewY >= 0) && (NewY < 25))
							ScreenMap[Screen][NewY * 40 + NewX] = ThisChar;
					}
				}
			}
		}
	}
	WriteBinaryFile(OutScreensBIN, ScreenMap, sizeof(ScreenMap));



	CodeGen codePlotASM(OutPlotCodeASM);

	for (int FrameIndex = 0; FrameIndex < NumFrames; FrameIndex++)
	{
		int Char0XOrY = 1;
		codePlotASM.OutputFunctionLine(fmt::format("DoPlot_Frame{:d}", FrameIndex));
		codePlotASM.OutputFunctionLine(fmt::format("ScrollText_0_Frame{:d}", FrameIndex));
		codePlotASM.OutputCodeLine(LDY_IMM, fmt::format("#$00"));

		for (int CharIndex = 0; CharIndex < NUM_CHARS; CharIndex++)
		{
			int NextCharIndex = (CharIndex + 1) % NUM_CHARS;

			Char0XOrY = 1 - Char0XOrY;

			bool bLastChar = (CharIndex == (NUM_CHARS - 1));
			if (!bLastChar)
			{
				codePlotASM.OutputFunctionLine(fmt::format("ScrollText_{:d}_Frame{:d}", NextCharIndex, FrameIndex));
				if (Char0XOrY == 0)
				{
					codePlotASM.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
					codePlotASM.OutputCodeLine(STX_ABS, fmt::format("ScrollText_{:d}_Frame{:d} + 1", CharIndex, FrameIndex));
				}
				else
				{
					codePlotASM.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
					codePlotASM.OutputCodeLine(STY_ABS, fmt::format("ScrollText_{:d}_Frame{:d} + 1", CharIndex, FrameIndex));
				}
			}

			for (int YChar = 0; YChar < 25; YChar++)
			{
				for (int XChar = 0; XChar < 25; XChar++)
				{
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						int YPos = YChar * 8 + YPixel;

						int NumCharPlotsHere = NumCharPlots[FrameIndex][XChar][YPos];
						int Index0 = -1;
						int Index1 = -1;
						bool bAlreadyWrittenHere = false;
						for (int Index = 0; Index < NumCharPlotsHere; Index++)
						{
							if ((CharPlots[FrameIndex][XChar][YPos][Index] & 0xff) == CharIndex)
							{
								Index0 = Index;
							}
							if ((CharPlots[FrameIndex][XChar][YPos][Index] & 0xff) == NextCharIndex)
							{
								Index1 = Index;
							}
							if ((CharPlots[FrameIndex][XChar][YPos][Index] & 0xff) == 0xff)
							{
								bAlreadyWrittenHere = true;
							}
						}
						if (Index0 != -1)
						{
							unsigned char XShift0 = (CharPlots[FrameIndex][XChar][YPos][Index0] & 0xff00) >> 8;
							unsigned char YOffset0 = (CharPlots[FrameIndex][XChar][YPos][Index0] & 0x7fff0000) >> 16;
							int Side0 = ((CharPlots[FrameIndex][XChar][YPos][Index0] & 0x80000000) == 0) ? 0 : 1;
							if (Char0XOrY == 0)
							{
								codePlotASM.OutputCodeLine(LDA_ABY, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", YOffset0, XShift0, Side0));
							}
							else
							{
								codePlotASM.OutputCodeLine(LDA_ABX, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", YOffset0, XShift0, Side0));
							}
							CharPlots[FrameIndex][XChar][YPos][Index0] = 0xff;

							if (Index1 != -1)
							{
								unsigned char XShift1 = (CharPlots[FrameIndex][XChar][YPos][Index1] & 0x0000ff00) >> 8;
								unsigned char YOffset1 = (CharPlots[FrameIndex][XChar][YPos][Index1] & 0x7fff0000) >> 16;
								int Side1 = ((CharPlots[FrameIndex][XChar][YPos][Index1] & 0x80000000) == 0) ? 0 : 1;
								if (Char0XOrY == 0)
								{
									codePlotASM.OutputCodeLine(ORA_ABX, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", YOffset1, XShift1, Side1));
								}
								else
								{
									codePlotASM.OutputCodeLine(ORA_ABY, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", YOffset1, XShift1, Side1));
								}
								CharPlots[FrameIndex][XChar][YPos][Index1] = 0xff;
							}

							unsigned char CharUsed = ScreenMap[0][YChar * 40 + XChar + 7];
							if (bAlreadyWrittenHere)
								codePlotASM.OutputCodeLine(ORA_ABS, fmt::format("FontWriteAddress + ({:d} * 8) + {:d}", CharUsed, YPixel));

							codePlotASM.OutputCodeLine(STA_ABS, fmt::format("FontWriteAddress + ({:d} * 8) + {:d}", CharUsed, YPixel));
							CharSetWrites[FrameIndex][CharUsed][YPixel] = 1;
						}
					}
				}
			}
		}
		codePlotASM.OutputCodeLine(JMP_ABS, fmt::format("ClearPlot_Frame{:d}", FrameIndex));
		codePlotASM.OutputBlankLine();
	}

	for (int FrameIndex = 0; FrameIndex < NumFrames; FrameIndex++)
	{
		codePlotASM.OutputFunctionLine(fmt::format("ClearPlot_Frame{:d}", FrameIndex));
		codePlotASM.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		int PrevFrameIndex = (FrameIndex + 1) % NumFrames;
		for (int CharIndex = 0; CharIndex < 256; CharIndex++)
		{
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				if ((CharSetWrites[PrevFrameIndex][CharIndex][YPixel] == 1) && (CharSetWrites[FrameIndex][CharIndex][YPixel] == 0))
				{
					codePlotASM.OutputCodeLine(STA_ABS, fmt::format("FontWriteAddress + ({:d} * 8) + {:d}", CharIndex, YPixel));
				}
			}
		}
		codePlotASM.OutputCodeLine(RTS);
		codePlotASM.OutputBlankLine();
	}
}

void TCS_ProcessFont(char* InFontPNG, int font_xspacing, LPTSTR OutFontASMFilename, LPTSTR OutFontBINFilename)
{
	GPIMAGE SrcImg(InFontPNG);

	unsigned char CharSet[FONT_H][FONT_NUMCHARS];
	ZeroMemory(CharSet, sizeof(CharSet));
	for (int YPos = 0; YPos < FONT_H; YPos++)
	{
		for (int XChar = 0; XChar < ScrollTextNumUniqueChars; XChar++)
		{
			unsigned char ThisChar = 0;

			int InXCharPos = ScrollTextUniqueChars[XChar] * 8;

			for (int XPixel = 0; XPixel < FONT_W; XPixel++)
			{
				int InXPos = InXCharPos + XPixel;
				if (SrcImg.GetPixel(InXPos, YPos) != 0x00000000)
				{
					ThisChar |= 0x80 >> XPixel;
				}
			}
			CharSet[YPos][XChar] = ThisChar;
		}
	}
	WriteBinaryFile(OutFontBINFilename, CharSet, sizeof(CharSet));

	CodeGen OutFontASM(OutFontASMFilename);
	int FontBINCount = 0;
	for (int shift = 0; shift < 8; shift++)
	{
		int NumSides = ((shift + FONT_W) > 8) ? 2 : 1;
		for (int side = 0; side < NumSides; side++)
		{
			for (int y = 0; y < FONT_H; y++)
			{
				OutFontASM.OutputCodeLine(NONE, fmt::format(".var Font_Y{:d}_Shift{:d}_Side{:d} = FONTBIN_ADDR + ({:d} * $20)", y, shift, side, FontBINCount));
				FontBINCount++;
			}
		}
	}
}

void TCS_GenerateSinTables(LPTSTR OutSinMovementsBIN)
{
	unsigned char SinTable[256];
	for (int i = 0; i < 256; i++)
	{
		double Angle = (i * 2 * PI) / 256.0;
		double SinVal = sin(Angle) * 76.0;
		SinVal += ((double)i * 160.0) / 256.0;
		int iSinVal = (int)floor(SinVal + 0.5);
		SinTable[i] = ((unsigned char)iSinVal) % 80;
	}
	WriteBinaryFile(OutSinMovementsBIN, SinTable, sizeof(SinTable));
}


void TCS_OutputScrollText(LPTSTR OutScrollTextBIN)
{
	ZeroMemory(ScrollTextUniqueChars, sizeof(ScrollTextUniqueChars));
	for (int i = 0; i < SizeScrollText; i++)
	{
		unsigned char c = ScrollText[i];
		if (((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z')))
		{
			c &= 0x1f;
		}
		else
		{
			c &= 0x3f;
		}
		int found = -1;
		for (int q = 0; q < ScrollTextNumUniqueChars; q++)
		{
			if (ScrollTextUniqueChars[q] == c)
			{
				found = q;
				break;
			}
		}
		if (found == -1)
		{
			ScrollTextUniqueChars[ScrollTextNumUniqueChars] = c;
			ScrollTextUniqueCharRemapping[c] = ScrollTextNumUniqueChars;
			ScrollTextNumUniqueChars++;
		}
	}

	for (int i = 0; i < SizeScrollText; i++)
	{
		unsigned char c = ScrollText[i];
		if (((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z')))
		{
			c = c & 0x1f;
		}
		ScrollText[i] = ScrollTextUniqueCharRemapping[c & 0x3f];
	}
	ScrollText[SizeScrollText - 1] = 0xff;
	WriteBinaryFile(OutScrollTextBIN, ScrollText, SizeScrollText);
}

void TCS_ConvertSpriteData(char* InSpritesPNGFilename, LPTSTR OutSpritesMAPFilename)
{
	GPIMAGE Img(InSpritesPNGFilename);

	unsigned char OutSprites[4][64];
	ZeroMemory(OutSprites, sizeof(OutSprites));

	for (int y = 0; y < 42; y++)
	{
		for (int x = 0; x < 48; x++)
		{
			unsigned char Col = Img.GetPixelPaletteColour(x, y);

			unsigned char OutBits = 0x00;
			int OutSpriteIndex = (y / 21) * 2 + (x / 24);
			int OutByte = (y % 21) * 3 + (x % 24) / 8;
			int OutShift = 7 - (x % 8);

			if (Col == 0x01)
			{
				OutSprites[OutSpriteIndex][OutByte] |= 1 << OutShift;
			}
		}
	}
	WriteBinaryFile(OutSpritesMAPFilename, OutSprites, sizeof(OutSprites));
}

void TCS_InterleaveSpriteData(char* InSpritesPNGFilename, LPTSTR OutSpritesMAPFilename)
{
	GPIMAGE Img(InSpritesPNGFilename);

	unsigned char OutSprites[NUM_SPRITE_ROWS * 8][64];
	ZeroMemory(OutSprites, sizeof(OutSprites));

	int Width = Img.Width;
	int Height = Img.Height;

	int NumSpritesX = Width / 24;

	for (int iSpriteY = 0; iSpriteY < NUM_SPRITE_ROWS; iSpriteY++)
	{
		int iSrcMinY = iSpriteY * 20;
		int iSrcMaxY = (iSpriteY + 1) * 20;
		for (int iSpriteX = 0; iSpriteX < NumSpritesX; iSpriteX++)
		{
			int SpriteIndex = iSpriteY * 8 + iSpriteX;
			for (int iYPixel = 0; iYPixel < 21; iYPixel++)
			{
				int iSrcY = iSpriteY * 21 + iYPixel;
				if (iSrcY > iSrcMaxY)
					iSrcY -= 21;

				for (int iXChar = 0; iXChar < 3; iXChar++)
				{
					unsigned char OutChar = 0;
					for (int iXPixel = 0; iXPixel < 8; iXPixel++)
					{
						int iSrcX = iSpriteX * 24 + iXChar * 8 + iXPixel;
						unsigned int PixelColour = Img.GetPixel(iSrcX, iSrcY);
						if (PixelColour != 0x00000000)
						{
							OutChar |= 1 << (7 - iXPixel);
						}
					}
					OutSprites[SpriteIndex][iYPixel * 3 + iXChar] = OutChar;
				}
			}
		}
	}
	WriteBinaryFile(OutSpritesMAPFilename, OutSprites, sizeof(OutSprites));
}

void TCS_OutputSpriteXSin(LPTSTR OutSpriteXSinBIN)
{
	static const double SinMax0 = 128.0;
	static const double SinAmplitude0 = SinMax0 / 2;

	static const int SinTableLen = 128;
	unsigned char SinTables[2][SinTableLen];

	for (int i = 0; i < SinTableLen; i++)
	{
		double angle0 = (i * PI * 2.0) / (double)SinTableLen;
		double sinval0 = sin(angle0) * SinAmplitude0;
		int iSin0 = (int)floor( max(-SinAmplitude0, min(SinAmplitude0, sinval0)) + 0.5);
		int CurrSpriteX0 = iSin0 + 160 + 24 - (4 * 24);

		SinTables[0][i] = (unsigned char)CurrSpriteX0;

		unsigned char XMSB = 0;
		for (int iSpr = 0; iSpr < 8; iSpr++)
		{
			int SpriteX = CurrSpriteX0;
			CurrSpriteX0 += 24;

			if (SpriteX <= -48)
				SpriteX = -48;

			if (SpriteX < 0)
				SpriteX += 504;

			if (SpriteX >= 256)
			{
				SpriteX -= 256;
				XMSB |= (1 << iSpr);
			}
		}
		SinTables[1][i] = XMSB;
	}
	WriteBinaryFile(OutSpriteXSinBIN, SinTables, sizeof(SinTables));
}

void GenerateUpdatePlotCode(LPTSTR OutUpdatePlotASM)
{
	CodeGen UpdatePlotCode(OutUpdatePlotASM);

	unsigned char NextFrames[NumFrames];
	for (int i = 0; i < NumFrames; i++)
	{
		NextFrames[i] = (i + 1) % NumFrames;
	}
	UpdatePlotCode.OutputFunctionLine(fmt::format("NextFrameIndexTable"));
	UpdatePlotCode.OutputByteBlock(NextFrames, NumFrames);
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputFunctionLine(fmt::format("DoPlotJumpsLo"));
	for (int i = 0; i < NumFrames; i++)
	{
		UpdatePlotCode.OutputCodeLine(NONE, fmt::format(".byte <(DoPlot_Frame{:d} - 1)", NumFrames - 1 - i));
	}
	UpdatePlotCode.OutputFunctionLine(fmt::format("DoPlotJumpsHi"));
	for (int i = 0; i < NumFrames; i++)
	{
		UpdatePlotCode.OutputCodeLine(NONE, fmt::format(".byte >(DoPlot_Frame{:d} - 1)", NumFrames - 1 - i));
	}
	UpdatePlotCode.OutputBlankLine();
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputFunctionLine(fmt::format("UpdatePlot"));
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputFunctionLine(fmt::format("ScrollScrollTextFrameIndex"));
	UpdatePlotCode.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	UpdatePlotCode.OutputCodeLine(LDY_ABX, fmt::format("NextFrameIndexTable"));
	UpdatePlotCode.OutputCodeLine(STY_ABS, fmt::format("ScrollScrollTextFrameIndex + 1"));
	UpdatePlotCode.OutputCodeLine(BNE, fmt::format("SkipScrollScroller"));
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputFunctionLine(fmt::format("CharHere"));
	UpdatePlotCode.OutputCodeLine(LDA_ABS, fmt::format("ScrollText"));
	UpdatePlotCode.OutputCodeLine(BPL, fmt::format("NotEndOfScrollText"));
	UpdatePlotCode.OutputCodeLine(LDA_IMM, fmt::format("#<(ScrollText - 1)"));
	UpdatePlotCode.OutputCodeLine(STA_ABS, fmt::format("CharHere + 1"));
	UpdatePlotCode.OutputCodeLine(LDA_IMM, fmt::format("#>(ScrollText - 1)"));
	UpdatePlotCode.OutputCodeLine(STA_ABS, fmt::format("CharHere + 2"));
	UpdatePlotCode.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	UpdatePlotCode.OutputFunctionLine(fmt::format("NotEndOfScrollText"));
	UpdatePlotCode.OutputBlankLine();

	for (int i = 0; i < NumFrames; i++)
	{
		UpdatePlotCode.OutputCodeLine(STA_ABS, fmt::format("ScrollText_{:d}_Frame{:d} + 1", NUM_CHARS - 1, i));
	}
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputCodeLine(INC_ABS, fmt::format("CharHere + 1"));
	UpdatePlotCode.OutputCodeLine(BNE, fmt::format("SkipScrollScroller"));
	UpdatePlotCode.OutputCodeLine(INC_ABS, fmt::format("CharHere + 2"));
	UpdatePlotCode.OutputFunctionLine(fmt::format("SkipScrollScroller"));
	UpdatePlotCode.OutputBlankLine();

	UpdatePlotCode.OutputCodeLine(LDA_ABY, fmt::format("DoPlotJumpsHi"));
	UpdatePlotCode.OutputCodeLine(PHA);
	UpdatePlotCode.OutputCodeLine(LDA_ABY, fmt::format("DoPlotJumpsLo"));
	UpdatePlotCode.OutputCodeLine(PHA);
	UpdatePlotCode.OutputCodeLine(RTS);
}


int TinyCircleScroll_Main()
{
	TCS_OutputScrollText(L"Link\\TinyCircleScroll\\ScrollText.bin");
	TCS_ProcessFont("Parts\\TinyCircleScroll\\Data\\Scrap-5x5Font.png", 8, L"Build\\6502\\TinyCircleScroll\\FontData.asm", L"Link\\TinyCircleScroll\\FontData.bin");

	TCS_GeneratePlotCode(L"Build\\6502\\TinyCircleScroll\\PlotCode.asm", L"Link\\TinyCircleScroll\\Screen.bin");

	TCS_GenerateSinTables(L"Link\\TinyCircleScroll\\SinTable.bin");

	TCS_OutputSpriteXSin(L"Link\\TinyCircleScroll\\SpriteXSin.bin");

	TCS_InterleaveSpriteData("Parts\\TinyCircleScroll\\Data\\Facet-Sprites.png", L"Link\\TinyCircleScroll\\Facet-Sprites.map");

	TCS_ConvertSpriteData("Parts\\TinyCircleScroll\\Data\\Disk.png", L"Link\\TinyCircleScroll\\Disk.map");

	GenerateUpdatePlotCode(L"Build\\6502\\TinyCircleScroll\\UpdatePlot.asm");

	return 0;
}



