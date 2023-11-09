// (c) Genesis*Project

#include "..\Common\Common.h"

static const int NumSpriteLines = 9;
static const int SpriteInterleaveDistance = 16;

static const int TotalDYPPWidth = 160;
static const int TotalDYPPHeight = 136;
static const int TotalDYPPCharWidth = TotalDYPPWidth / 8;
static const int TotalDYPPCharHeight = TotalDYPPHeight / 8;

static const int ScreenCharWidth = 40;

static const int Font_MaxCharWidth = 32 * 8;
static const int Font_CharHeight = 8;
static const int Max_Num_Strips = 64;
static const int Max_Num_ScreenStrips = 1000;
static const int Max_Num_CharSets = 16;

static const int cSpacer = 4;

static unsigned char CharSet[256][8];
static int CharSet_Num;

static unsigned char FontStrips[Max_Num_Strips][Font_CharHeight];
static int FontStrips_Num;

static unsigned char FontColumn_To_StripIndex[Font_MaxCharWidth];

static unsigned char PackedCharSets[Max_Num_CharSets][256][8];
static int PackedCharSets_NumChars[Max_Num_CharSets];
static int PackedCharSets_NumLines[Max_Num_CharSets];

static unsigned char ScreenStrips[TotalDYPPCharHeight][TotalDYPPCharWidth][Max_Num_Strips];

static int ScreenStrips_MinMaxY[TotalDYPPCharWidth][2];

static unsigned char UniqueScreenStrips[Max_Num_ScreenStrips][Max_Num_Strips];
static int NumUniqueScreenStrips;

static unsigned int Screen_UniqueScreenStrips_Lookup[TotalDYPPCharWidth][TotalDYPPCharHeight];

static int Font_CharInfo[64][2];

static int GLOB_CharLine[25];

static unsigned char ScrollText[] = {
	"look at this beautiful slinky scroller       round and around       and on with the show                      "
	">"
};

void TS_GeneratePlotCode(LPTSTR OutPlotCodeASM)
{
}

void TS_ProcessFont(char* InFontPNG, LPTSTR OutPlotASM, LPTSTR OutCharSetBIN)
{
	GPIMAGE FontImg(InFontPNG);

	int Font_Width = FontImg.Width / 8;

	ZeroMemory(CharSet, sizeof(CharSet));
	memset(&CharSet[1], 255, 8);
	CharSet_Num = 2;

	ZeroMemory(FontStrips, sizeof(FontStrips));
	FontStrips_Num = 1;

	unsigned int CurrentCharIndex = 0;
	unsigned int StartXChar = 0;
	bool bLastWasProperStrip = false;
	Font_CharInfo[0][0] = 0;
	Font_CharInfo[0][1] = 1;
	CurrentCharIndex++;
	for (int XChar = 0; XChar < Font_Width; XChar++)
	{
		unsigned char ThisStrip[Font_CharHeight];
		for (int YChar = 0; YChar < Font_CharHeight; YChar++)
		{
			unsigned char ThisChar[8];
			ZeroMemory(ThisChar, sizeof(ThisChar));
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = YChar * 8 + YPixel;
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XChar * 8 + XPixel;
					if (FontImg.GetPixel(XPos, YPos) != 0x00000000)
					{
						ThisChar[YPixel] |= (1 << (7 - XPixel));
					}
				}
			}

			int CharIndex = -1;
			for (int i = 0; i < CharSet_Num; i++)
			{
				if (!memcmp(ThisChar, CharSet[i], 8))
				{
					CharIndex = i;
					break;
				}
			}
			if (CharIndex == -1)
			{
				CharIndex = CharSet_Num;
				memcpy(CharSet[CharIndex], ThisChar, 8);
				CharSet_Num++;
			}
			ThisStrip[YChar] = CharIndex;
		}
		int StripIndex = -1;
		for (int i = 0; i < FontStrips_Num; i++)
		{
			if (!memcmp(ThisStrip, FontStrips[i], Font_CharHeight))
			{
				StripIndex = i;
				break;
			}
		}
		if (StripIndex == -1)
		{
			StripIndex = FontStrips_Num;
			if (StripIndex < Max_Num_Strips)
			{
				memcpy(FontStrips[StripIndex], ThisStrip, Font_CharHeight);
			}
			FontStrips_Num++;
		}
		FontColumn_To_StripIndex[XChar] = StripIndex;
		if (StripIndex == 0)
		{
			if (bLastWasProperStrip)
			{
				Font_CharInfo[CurrentCharIndex][0] = StartXChar;
				Font_CharInfo[CurrentCharIndex][1] = XChar - StartXChar;
				CurrentCharIndex++;
				StartXChar = XChar + 1;
				bLastWasProperStrip = false;
			}
			else
			{
				StartXChar = XChar + 1;
			}
		}
		else
		{
			bLastWasProperStrip = true;
		}
	}

	int OutImg_Width = FontStrips_Num * TotalDYPPWidth;

	GPIMAGE OutBKGImg(84, 136);

	GPIMAGE OutImg(OutImg_Width, 136);

	for (int StripIndex = 0; StripIndex < FontStrips_Num; StripIndex++)
	{
		for (int XChar = 0; XChar < TotalDYPPCharWidth; XChar++)
		{
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				unsigned char PixelMask = 1 << (7 - XPixel);

				int OutXPos = ((StripIndex * TotalDYPPCharWidth) + XChar) * 8 + XPixel;

				int InXPos = XChar * 8 + XPixel;

				double Angle = (InXPos * 2 * PI) / (double)(TotalDYPPWidth * 2) + PI / 2.0;
				double dY0 = sin(Angle) * 36.0 + 36.0;
				dY0 = max(min(dY0, 80.0), 0.0);
				int Y[2];
				Y[0] = (int)dY0;
				Y[1] = 72 - Y[0];

				for (int Scroller = 0; Scroller < 2; Scroller++)
				{
					int OutY = Y[Scroller];
					for (int YPixel = 0; YPixel < cSpacer; YPixel++)
					{
						int OutYPosTop = OutY - (YPixel + 1);
						int OutYPosBottom = OutY + (Font_CharHeight * 8) + YPixel;
						if (OutYPosTop >= 0)
						{
							OutImg.SetPixel(OutXPos, OutYPosTop, 0x00000000);
						}
						if (OutYPosBottom < TotalDYPPHeight)
						{
							OutImg.SetPixel(OutXPos, OutYPosBottom, 0x00000000);
						}
					}
					for (int YChar = 0; YChar < Font_CharHeight; YChar++)
					{
						unsigned char InChar = FontStrips[StripIndex][YChar];
						for (int YPixel = 0; YPixel < 8; YPixel++)
						{
							int OutYPos = OutY + YChar * 8 + YPixel;
							unsigned int OutColour = ((CharSet[InChar][YPixel] & PixelMask) == 0) ? 0x00000000 : 0x00ffffff;

							if (OutColour == 0x00ffffff) // diagonal stripes ..
							{
								int DiagMod16 = (OutXPos + OutYPos) % 8;
								if ((DiagMod16 == 0) || (DiagMod16 == 1))
									OutColour = 0x00000000;
							}

							OutImg.SetPixel(OutXPos, OutYPos, OutColour);
							if (StripIndex == 0)
							{
								int InY = YChar * 8 + YPixel;
								static unsigned int OutColours[2][3] = {
									{ 0x000000, 0x808080, 0xffffff },
									{ 0x000000, 0xc0c0c0, 0xffffff },
								};

								int ColIndex = 0;

								int Zone = 0;
								if ((InY >= 26) && (InY < 38))
								{
									Zone = 4;
								}
								else if ((InY >= 12) && (InY < 52))
								{
									Zone = 3;
								}
								else
								{
									Zone = 2;
								}

								int WriteXPos0 = (OutXPos / 4) + 0;
								int WriteXPos1 = (OutXPos / 4) + 40;

								static const int ShadowFade[] =
								{
									0, 0,
									0, 0, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 1, 1,
									1, 1, 0, 0,
									0, 0, 0, 0,
									0, 0, 0, 0,
								};

								int ShadowIndex = 0;
								if (Scroller == 0)
								{
									Zone -= ShadowFade[WriteXPos0 + (OutYPos & 1)] * 2;
								}

								switch (Zone)
								{
								case 4:
									ColIndex = 2;
									break;

								case 3:
									ColIndex = (OutYPos & 1) ? 1 : 2;
									break;

								case 2:
									ColIndex = 1;
									break;

								case 1:
									ColIndex = (OutYPos & 1) ? 0 : 1;
									break;

								case 0:
									ColIndex = 0;
									break;
								}

								OutBKGImg.SetPixel(WriteXPos0, OutYPos, OutColours[Scroller][ColIndex]);
								OutBKGImg.SetPixel(WriteXPos1, OutYPos, OutColours[1 - Scroller][ColIndex]);
							}
						}
					}
				}
			}
		}
	}
	OutImg.Write("Build\\6502\\TwistScroll\\SinScroll.png");
	OutBKGImg.Write("Build\\6502\\TwistScroll\\BKG.png");

	memset(PackedCharSets, 0xff, sizeof(PackedCharSets));
	ZeroMemory(PackedCharSets_NumLines, sizeof(PackedCharSets_NumLines));
	for (int i = 0; i < Max_Num_CharSets; i++)
	{
		PackedCharSets_NumChars[i] = 1;	//; ensure that the first char is a space...
	}

	int CurrentCharSet = 0;
	int CurrentNumChars = 1;
	for (int YChar = 0; YChar < TotalDYPPCharHeight; YChar++)
	{
		if (CurrentCharSet < Max_Num_CharSets)
		{
			for (int Pass = 0; Pass < 2; Pass++)
			{
				for (int XChar = 0; XChar < OutImg_Width / 8; XChar++)
				{
					unsigned char ThisChar[8];
					ZeroMemory(ThisChar, sizeof(ThisChar));
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						int YPos = YChar * 8 + YPixel;
						for (int XPixel = 0; XPixel < 8; XPixel++)
						{
							int XPos = XChar * 8 + XPixel;
							if (OutImg.GetPixel(XPos, YPos) != 0x00ffffff)
							{
								ThisChar[YPixel] |= (1 << (7 - XPixel));
							}
						}
					}
					int CharIndex = -1;
					for (int i = 0; i < CurrentNumChars; i++)
					{
						if (!memcmp(PackedCharSets[CurrentCharSet][i], ThisChar, 8))
						{
							CharIndex = i;
						}
					}
					if (CharIndex == -1)
					{
						CharIndex = CurrentNumChars;
						if (CharIndex < 256)
						{
							memcpy(PackedCharSets[CurrentCharSet][CharIndex], ThisChar, 8);
						}
						CurrentNumChars++;
					}
					ScreenStrips[YChar][XChar % TotalDYPPCharWidth][XChar / TotalDYPPCharWidth] = CharIndex;
				}
				if (Pass == 0)
				{
					if (CurrentNumChars <= 256)
					{
						Pass = 1;
						PackedCharSets_NumChars[CurrentCharSet] = CurrentNumChars;
						PackedCharSets_NumLines[CurrentCharSet]++;
					}
					else
					{
						CurrentCharSet++;
						CurrentNumChars = 1;
					}
				}
				else
				{
					if (CurrentNumChars <= 256)
					{
						PackedCharSets_NumChars[CurrentCharSet] = CurrentNumChars;
						PackedCharSets_NumLines[CurrentCharSet]++;
					}
					else
					{
						while (1);
					}
				}
			}
		}
	}
	int TotalNumCharSets = CurrentCharSet;
	if (CurrentNumChars > 0)
	{
		TotalNumCharSets++;
	}
	WriteBinaryFile(OutCharSetBIN, PackedCharSets, 256 * 8 * TotalNumCharSets);

	CodeGen code(OutPlotASM);
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format(".var NumCharsets = {:d}", TotalNumCharSets));
	code.OutputBlankLine();

	int CurrentCharLine = 0;
	for (int i = 0; i < TotalNumCharSets; i++)
	{
		GLOB_CharLine[i] = CurrentCharLine;
		code.OutputCodeLine(NONE, fmt::format(".var CharLine{:d} = {:d}", i, CurrentCharLine));
		CurrentCharLine += PackedCharSets_NumLines[i];
	}
	code.OutputCodeLine(NONE, fmt::format(".var CharLine{:d} = {:d}", TotalNumCharSets, CurrentCharLine));
	code.OutputBlankLine();

	ZeroMemory(UniqueScreenStrips, sizeof(UniqueScreenStrips));
	NumUniqueScreenStrips = 0;

	memset(Screen_UniqueScreenStrips_Lookup, 0xff, sizeof(Screen_UniqueScreenStrips_Lookup));

	for (int YChar = 0; YChar < TotalDYPPCharHeight; YChar++)
	{
		for (int XChar = 0; XChar < TotalDYPPCharWidth; XChar++)
		{
			unsigned char StripValue = ScreenStrips[YChar][XChar][0];
			bool bChanges = false;
			for (int i = 1; i < FontStrips_Num; i++)
			{
				if (ScreenStrips[YChar][XChar][i] != StripValue)
				{
					bChanges = true;
					break;
				}
			}
			if (bChanges)
			{
				int FoundIndex = -1;
				for (int i = 0; i < NumUniqueScreenStrips; i++)
				{
					if (!memcmp(UniqueScreenStrips[i], ScreenStrips[YChar][XChar], FontStrips_Num))
					{
						FoundIndex = i;
						break;
					}
				}
				if (FoundIndex == -1)
				{
					FoundIndex = NumUniqueScreenStrips;
					memcpy(UniqueScreenStrips[FoundIndex], ScreenStrips[YChar][XChar], FontStrips_Num);
					NumUniqueScreenStrips++;

					code.OutputFunctionLine(fmt::format("StripData_{:d}", FoundIndex));
					code.OutputByteBlock(UniqueScreenStrips[FoundIndex], FontStrips_Num, FontStrips_Num);
				}
				Screen_UniqueScreenStrips_Lookup[XChar][YChar] = (unsigned int)FoundIndex;
			}
		}
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("NextXValue"));
	for (int i = 0; i < 7; i++)
	{
		code.OutputCodeLine(NONE, fmt::format(".fill {:d}, i + 1 + ({:d} * 40)", ScreenCharWidth - 1, i));
		code.OutputCodeLine(NONE, fmt::format(".byte ({:d} * 40)", i));
	}
	code.OutputBlankLine();
	code.OutputBlankLine();

	//; find min-max values for each strip
	for (int XChar = 0; XChar < TotalDYPPCharWidth; XChar++)
	{
		ScreenStrips_MinMaxY[XChar][0] = 0;
		ScreenStrips_MinMaxY[XChar][1] = 16;
		for (int YChar = 0; YChar < TotalDYPPCharHeight; YChar++)
		{
			int UniqueStrip = Screen_UniqueScreenStrips_Lookup[XChar % TotalDYPPCharWidth][YChar];
			if (UniqueStrip != 0xffffffff)
			{
				ScreenStrips_MinMaxY[XChar][0] = YChar;
				break;
			}
		}
		for (int YChar = 16; YChar >= 0; YChar--)
		{
			int UniqueStrip = Screen_UniqueScreenStrips_Lookup[XChar % TotalDYPPCharWidth][YChar];
			if (UniqueStrip != 0xffffffff)
			{
				ScreenStrips_MinMaxY[XChar][1] = YChar;
				break;
			}
		}
	}

	code.OutputFunctionLine(fmt::format("DoPlots"));
	code.OutputBlankLine();

	bool bXOrY = true;
	for (int XChar = 0; XChar < ScreenCharWidth; XChar++)
	{
		bool bAIsClear = false;
		for (int YChar = 0; YChar < TotalDYPPCharHeight; YChar++)
		{
			int UniqueStrip = Screen_UniqueScreenStrips_Lookup[XChar % TotalDYPPCharWidth][YChar];
			if (UniqueStrip == 0xffffffff)
			{
				if (!bAIsClear)
				{
					code.OutputCommentLine(fmt::format("// clear top/bottom part - could be more optimal!")); //; TODO!
					code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
					bAIsClear = true;
				}
				if (bXOrY)
					code.OutputCodeLine(STA_ABY, fmt::format("ADDR_Screen + ({:2d} * 40)", YChar + 1));
				else
					code.OutputCodeLine(STA_ABX, fmt::format("ADDR_Screen + ({:2d} * 40)", YChar + 1));
			}
		}
		if (bAIsClear)
		{
			code.OutputBlankLine();
		}

		if (bXOrY)
			code.OutputCodeLine(LDX_ZP, fmt::format("ZP_ScrollText + {:d}", XChar));
		else
			code.OutputCodeLine(LDY_ZP, fmt::format("ZP_ScrollText + {:d}", XChar));

		for (int YChar = 0; YChar < TotalDYPPCharHeight; YChar++)
		{
			int UniqueStrip = Screen_UniqueScreenStrips_Lookup[XChar % TotalDYPPCharWidth][YChar];
			if (UniqueStrip != 0xffffffff)
			{
				if (bXOrY)
					code.OutputCodeLine(LDA_ABX, fmt::format("StripData_{:d}", UniqueStrip));
				else
					code.OutputCodeLine(LDA_ABY, fmt::format("StripData_{:d}", UniqueStrip));
				if (bXOrY)
					code.OutputCodeLine(STA_ABY, fmt::format("ADDR_Screen + ({:2d} * 40)", YChar + 1));
				else
					code.OutputCodeLine(STA_ABX, fmt::format("ADDR_Screen + ({:2d} * 40)", YChar + 1));
			}
		}

		code.OutputBlankLine();
		code.OutputFunctionLine(fmt::format("FinPlot_Col{:d}", XChar));
		code.OutputCodeLine(NOP);
		code.OutputBlankLine();

		if (bXOrY)
			code.OutputCodeLine(LDX_ABY, fmt::format("NextXValue"));
		else
			code.OutputCodeLine(LDY_ABX, fmt::format("NextXValue"));
		bXOrY = !bXOrY;

		code.OutputBlankLine();
	}
	code.OutputCodeLine(RTS);
}

void TS_ProcessScrollText(LPTSTR OutScrollTextBIN)
{
	bool bFinishedST = false;
	int ScrollTextIndex = 0;
	unsigned char* OutScrollText = new unsigned char[4096];
	int OutScrollTextPos = 0;
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

		default:
			CurrentChar = CurrentChar & 0x1f;
			break;
		}

		if (!bFinishedST)
		{
			int StartPos = Font_CharInfo[CurrentChar][0];
			int EndPos = StartPos + Font_CharInfo[CurrentChar][1];
			for (int i = StartPos; i < EndPos; i++)
			{
				if (OutScrollTextPos < 4096)
					OutScrollText[OutScrollTextPos++] = FontColumn_To_StripIndex[i];
			}
			if (OutScrollTextPos < 4096)
				OutScrollText[OutScrollTextPos++] = 0;
		}
		ScrollTextIndex++;
	}
	if (OutScrollTextPos < 4096)
		OutScrollText[OutScrollTextPos++] = 255;
	WriteBinaryFile(OutScrollTextBIN, OutScrollText, OutScrollTextPos);
	delete[] OutScrollText;
}


int TS_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass, bool bCanInsertCode)
{
	int NumRemainingCycles = NumCycles;

	static int Stage = 0;
	static int Counter = 0;
	if (bFirstPass)
	{
		Stage = 0;
		Counter = 0;
	}

	return code.WasteCycles(NumRemainingCycles);
}


void TS_GenerateYSine(LPTSTR OutYSineBINFilename)
{
	static const int YSineLen = 128;
	unsigned char OutYSine[2][YSineLen];

	for (int i = 0; i < YSineLen; i++)
	{
		double Angle = ((double)i * 2.0 * PI) / YSineLen;
		double YSinValue = sin(Angle) * 24.0 + 24.0;
		int iSinValue = (int)floor(YSinValue);
		iSinValue = max(0, min(47, iSinValue));

		OutYSine[0][i] = (unsigned char)((iSinValue / 8) * 40);
		OutYSine[1][i] = (unsigned char)iSinValue;
	}
	WriteBinaryFile(OutYSineBINFilename, OutYSine, sizeof(OutYSine));
}

void TS_InterleaveSprites(char* InSpritesPNGFilename, LPTSTR OutSpritesMAPFilename)
{
	GPIMAGE InSprites(InSpritesPNGFilename);

	unsigned char OutSpritesMAP[NumSpriteLines * 7][64];
	ZeroMemory(OutSpritesMAP, sizeof(OutSpritesMAP));

	for (int SpriteRow = 0; SpriteRow < NumSpriteLines; SpriteRow++)
	{
		for (int YPixel = 0; YPixel < 21; YPixel++)
		{
			int OutY = SpriteRow * 21 + YPixel;
			int InY = OutY;
			while (InY >= (21 + (SpriteRow * SpriteInterleaveDistance)))
			{
				InY -= 21;
			}
			for (int SpriteColumn = 0; SpriteColumn < 7; SpriteColumn++)
			{
				for (int XChar = 0; XChar < 3; XChar++)
				{
					unsigned char OutChar = 0x00;
					for (int XPixel = 0; XPixel < 8; XPixel+=2)
					{
						int InX = SpriteColumn * 12 + XChar * 4 + XPixel / 2;
						int OutX = InX;
						unsigned int Colour = InSprites.GetPixel(InX, InY);
						unsigned char OutCol = 0x00;
						if (Colour == 0x00808080)
						{
							OutCol = 0x01;
						}
						else if (Colour == 0x00c0c0c0)
						{
							OutCol = 0x03;
						}
						else if (Colour == 0x00ffffff)
						{
							OutCol = 0x02;
						}
						OutChar |= (OutCol << (6 - XPixel));
					}
					int ByteIndex = YPixel * 3 + XChar;
					int SpriteIndex = SpriteRow + SpriteColumn * NumSpriteLines;
					OutSpritesMAP[SpriteIndex][ByteIndex] = OutChar;
				}
			}
		}
	}

	WriteBinaryFile(OutSpritesMAPFilename, OutSpritesMAP, NumSpriteLines * 7 * 64);
}


void TS_GenerateSpriteXASM(LPTSTR OutBackgroundSpritesASMFilename)
{
	static const int NumFrames = 80;
	static const int MoveDistance = 320 / NumFrames;

	CodeGen OutBackgroundSpritesASM(OutBackgroundSpritesASMFilename);

	unsigned char cSpriteX[8][NumFrames];
	unsigned char cSpriteXMSB[NumFrames];
	unsigned char cSpriteVal[8][NumFrames];

	ZeroMemory(cSpriteXMSB, sizeof(cSpriteXMSB));

	int spriteX[8] =
	{
		  0,	//; 0
		 48,	//; 1
		 96,	//; 2
		144,	//; 3
		192,	//; 4
		240,	//; 5
		288,	//; 6
		320,	//; 7
	};

	int spriteVal[8] =
	{
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		0,
	};

	for (int spriteindex = 0; spriteindex < 8; spriteindex++)
	{
		int x = spriteX[spriteindex];
		int sprval = spriteVal[spriteindex];

		for (int i = 0; i < NumFrames; i++)
		{
			int sprx = x + 24;

			if (sprx >= 0)
			{
				cSpriteX[spriteindex][i] = sprx & 255;
			}
			else
			{
				cSpriteX[spriteindex][i] = (sprx + 248) & 255;
			}

			cSpriteVal[spriteindex][i] = (sprval * 9) + 0x10;

			if ((sprx < 0) || (sprx >= 256))
			{
				cSpriteXMSB[i] |= 1 << spriteindex;
			}

			x -= MoveDistance;
			if (x < -47)
			{
				x += 368;
				sprval = (sprval + 1) % 7;
			}
		}

		OutBackgroundSpritesASM.OutputFunctionLine(fmt::format("Sprite{:d}_ScrollVals", spriteindex));
		OutBackgroundSpritesASM.OutputByteBlock(cSpriteX[spriteindex], NumFrames);
		OutBackgroundSpritesASM.OutputFunctionLine(fmt::format("Sprite{:d}_SpriteVals", spriteindex));
		OutBackgroundSpritesASM.OutputByteBlock(cSpriteVal[spriteindex], NumFrames);
	}
	OutBackgroundSpritesASM.OutputFunctionLine(fmt::format("SpriteXMSB"));
	OutBackgroundSpritesASM.OutputByteBlock(cSpriteXMSB, NumFrames);
}


int TwistScroll_Main()
{
	TS_ProcessFont("Parts\\TwistScroll\\Data\\Raistlin-FontFull.png", L"Build\\6502\\TwistScroll\\PlotCode.asm", L"Link\\TwistScroll\\CharSets.bin");

	TS_ProcessScrollText(L"Link\\TwistScroll\\ScrollText.bin");

	TS_InterleaveSprites("Build\\6502\\TwistScroll\\BKG.png", L"Link\\TwistScroll\\BKG.map");

	TS_GenerateSpriteXASM(L"Build\\6502\\TwistScroll\\BackgroundSprites.asm");

	TS_GenerateYSine(L"Link\\TwistScroll\\YSine.bin");
		
	return 0;
}