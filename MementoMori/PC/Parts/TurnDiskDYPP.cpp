// (c) 2018-2020, Genesis*Project


//; TODO: optimise sprite memory:-
//;		- change the sprite X/MSB code so that the sprites only scroll by 0-47 pixels... and then update SpriteVals instead to scroll!
//;		- look for duplicate sprites and remove them
//;		- split the sprite data into the 2 banks
//;		- weave the sprite data into screen memory where possible?

#include <atlstr.h>

#include "..\Common\Common.h"

constexpr auto NUM_BANKS = 2;

constexpr auto NUM_CHARS_PER_CHARSET = 256;
constexpr auto MAX_NUM_CHARSETS = 32;
constexpr auto NUM_FRAMES = 30;
constexpr auto PIXEL_PADDING = 4;

constexpr auto SINE_AMPLITUDE = 48.0;

constexpr auto SINE_WIDTH = 240;
constexpr auto SINE_CHAR_WIDTH = (SINE_WIDTH / 8);

constexpr auto NUM_SPRITES_PER_LINE = 5; //; HACK - this should be calced!

unsigned char CharsetData[32][NUM_CHARS_PER_CHARSET][8];

int StoredSine[2][SINE_WIDTH];

class
{
public:
	int NumChars;
	int StartLine;
	int NumLines;
} CharsetInfo[MAX_NUM_CHARSETS];

unsigned char ScreenLineToCharsetLookup[25];

unsigned char ScreenAnims[25][SINE_CHAR_WIDTH][NUM_FRAMES];

int NumDedupedScreenAnims;
unsigned char DedupedScreenAnims[1000][NUM_FRAMES];
int ScreenAnimLookup[25][SINE_CHAR_WIDTH];

void TurnDiskDYPP_InterleaveSpriteData(char* InputSpritesPNG, LPTSTR OutputSpritesBIN)
{
	GPIMAGE SrcImg(InputSpritesPNG);

	int SpritesWidth = SrcImg.Width;
	int SpritesHeight = SrcImg.Height;

	unsigned int Palette[4];
	int NumPaletteEntries = 0;
	int StartYOutputOffset = 1;

	unsigned char OutputSpriteData[256][64];
	ZeroMemory(OutputSpriteData, sizeof(OutputSpriteData));
	for (int SpriteRow = 2; SpriteRow < 16; SpriteRow++)
	{
		memset(OutputSpriteData[SpriteRow * 5 + 0], 0xaa, 64);
		memset(OutputSpriteData[SpriteRow * 5 + 3], 0xaa, 64);
		memset(OutputSpriteData[SpriteRow * 5 + 4], 0xaa, 64);
	}

	int MaxSpriteIndex = -1;
	for (int LogoIndex = 0; LogoIndex < 2; LogoIndex++)
	{
		for (int XPos = 0; XPos < SpritesWidth; XPos += 2)
		{
			for (int ShortYPos = 0; ShortYPos < SpritesHeight / 2; ShortYPos++)
			{
				int ZSortedLogoIndex = (XPos >= (SpritesWidth / 2)) ? LogoIndex : 1 - LogoIndex;

				int YPos = ZSortedLogoIndex * (SpritesHeight / 2) + ShortYPos;

				unsigned int Colour = SrcImg.GetPixel(XPos, YPos);

				int FoundPaletteIndex = -1;
				for (int PaletteIndex = 0; PaletteIndex < NumPaletteEntries; PaletteIndex++)
				{
					if (Palette[PaletteIndex] == Colour)
					{
						FoundPaletteIndex = PaletteIndex;
						break;
					}
				}
				if (FoundPaletteIndex == -1)
				{
					FoundPaletteIndex = NumPaletteEntries;
					if (NumPaletteEntries < 4)
					{
						Palette[NumPaletteEntries] = Colour;
						NumPaletteEntries++;
					}
				}

				int SinYPos = StoredSine[ZSortedLogoIndex][XPos * 2] + (YPos % (SpritesHeight / 2));

				int OutputXPos = XPos % 24;
				int AdjustedYPos = SinYPos + StartYOutputOffset;
				int OutputYPos = AdjustedYPos % 21;
				int OutputByteOffset = (OutputYPos * 3) + (OutputXPos / 8);
				unsigned char OrByte = FoundPaletteIndex << (6 - (OutputXPos % 8));
				unsigned char AndByte = 0xff - (0x03 << (6 - (OutputXPos % 8)));
				int OutputSpriteRow = SinYPos / 16;
				int OutputSpriteIndex = OutputSpriteRow * NUM_SPRITES_PER_LINE + (XPos / 24);

				MaxSpriteIndex = max(MaxSpriteIndex, OutputSpriteIndex);

				OutputSpriteData[OutputSpriteIndex][OutputByteOffset] = (OutputSpriteData[OutputSpriteIndex][OutputByteOffset] & AndByte) | OrByte;
			}
		}
	}
	WriteBinaryFile(OutputSpritesBIN, OutputSpriteData, (MaxSpriteIndex + 1) * 64);
}

void TurnDiskDYPP_GenerateAnimationFrames(char* InputLogoPNG, LPTSTR OutputCharSetBIN, LPTSTR ScreenAnimsBIN, LPTSTR ScreenBIN, LPTSTR DrawLogoASM)
{
	GPIMAGE SrcImg(InputLogoPNG);

	unsigned int LogoWidth = SrcImg.Width;
	unsigned int LogoCharWidth = LogoWidth / 8;
	unsigned int LogoXCharStart = (40 - LogoCharWidth) / 2;

	unsigned int LogoHeight = SrcImg.Height;
	unsigned int LogoCharHeight = LogoHeight / 8;
	unsigned int LogoYCharStart = (25 - LogoCharHeight) / 2;

	unsigned char(*WholeImage)[NUM_FRAMES][SINE_WIDTH / 8][8] = new unsigned char[LogoCharHeight][NUM_FRAMES][SINE_WIDTH / 8][8];
	ZeroMemory(WholeImage, LogoCharHeight * NUM_FRAMES * (SINE_WIDTH / 8) * 8);

	NumDedupedScreenAnims = 0;

	int SizeOutImgData = SINE_WIDTH * LogoHeight;
	unsigned char* OutImgData = new unsigned char[SizeOutImgData];

	for (int FrameIndex = 0; FrameIndex < NUM_FRAMES; FrameIndex++)
	{
		ZeroMemory(OutImgData, SizeOutImgData);

		for (int LogoIndex = 0; LogoIndex < 2; LogoIndex++)
		{
			for (int XPos = 0; XPos < SINE_WIDTH; XPos++)
			{
				double angle = (2.0 * PI * (XPos - FrameIndex * (SINE_WIDTH / NUM_FRAMES))) / SINE_WIDTH;
				while (angle < 0)
				{
					angle += 2.0 * PI;
				}
				while (angle >= (2.0 * PI))
				{
					angle -= 2.0 * PI;
				}
				int ZSortedLogoIndex = (angle >= PI) ? LogoIndex : 1 - LogoIndex;

				angle += (ZSortedLogoIndex * PI);
				double dY = (cos(angle) + 1.0) * 0.5;
				dY *= SINE_AMPLITUDE;

				unsigned int YPos = (unsigned int)dY;
				if (FrameIndex == 0)
				{
					StoredSine[ZSortedLogoIndex][XPos] = YPos;
				}
				for (int LogoYPos = -PIXEL_PADDING; LogoYPos < (43 + PIXEL_PADDING); LogoYPos++)
				{
					unsigned char C64Colour = 0;
					if ((LogoYPos >= 0) && (LogoYPos < 43))
					{
						C64Colour = SrcImg.GetPixelPaletteColour(XPos, LogoYPos + ZSortedLogoIndex * 48);
					}
					if ((YPos >= 0) && (YPos < LogoHeight))
					{
						OutImgData[XPos + YPos * SINE_WIDTH] = C64Colour;
					}
					YPos++;
				}
			}
		}

		for (unsigned int YPos = 0; YPos < LogoHeight; YPos++)
		{
			for (unsigned int XPos = 0; XPos < SINE_WIDTH; XPos++)
			{
				if (OutImgData[XPos + YPos * SINE_WIDTH] == 0)
				{
					unsigned char bitSet = 1 << (7 - (XPos % 8));
					int unsigned YCharPos = YPos / 8;
					WholeImage[YCharPos][FrameIndex][XPos / 8][YPos % 8] |= bitSet;
				}
			}
		}
	}

	delete[] OutImgData;

	memset(CharsetData, 0xff, sizeof(CharsetData));
	ZeroMemory(CharsetInfo, sizeof(CharsetInfo));

	int NumCharsets = 0;

	bool bFinished = false;
	int YCharPos = 0;
	int FramePos = 0;
	int XCharPos = 0;
	int CurrentNumChars = 1;
	while (!bFinished)
	{
		int FoundIndex = -1;
		for (int CharIndex = 0; CharIndex < CurrentNumChars; CharIndex++)
		{
			if (memcmp(WholeImage[YCharPos][FramePos][XCharPos], CharsetData[NumCharsets][CharIndex], 8) == 0)
			{
				FoundIndex = CharIndex;
				break;
			}
		}
		bool bAdvanceToNextChar = true;
		if (FoundIndex == -1)
		{
			if (CurrentNumChars >= NUM_CHARS_PER_CHARSET)
			{
				//; Didn't fit! Move to next charset and retry the line...
				NumCharsets++;
				bAdvanceToNextChar = false;
				if (NumCharsets >= MAX_NUM_CHARSETS)
				{
					bFinished = true;
				}
				else
				{
					CharsetInfo[NumCharsets].StartLine = YCharPos;

					CurrentNumChars = 1;

					XCharPos = 0;
					FramePos = 0;
				}
			}
			else
			{
				FoundIndex = CurrentNumChars;
				memcpy(CharsetData[NumCharsets][FoundIndex], WholeImage[YCharPos][FramePos][XCharPos], 8);
				CurrentNumChars++;
			}
		}
		if (bAdvanceToNextChar)
		{
			ScreenAnims[YCharPos][XCharPos][FramePos] = FoundIndex;
			XCharPos++;
			if (XCharPos == SINE_CHAR_WIDTH)
			{
				XCharPos = 0;
				FramePos++;
				if (FramePos == NUM_FRAMES)
				{
					ScreenLineToCharsetLookup[YCharPos] = NumCharsets;

					FramePos = 0;
					YCharPos++;
					CharsetInfo[NumCharsets].NumChars = CurrentNumChars;
					CharsetInfo[NumCharsets].NumLines = YCharPos - CharsetInfo[NumCharsets].StartLine;
					if (YCharPos == LogoCharHeight)
					{
						if (CurrentNumChars > 1)
						{
							NumCharsets++;
						}
						bFinished = true;
					}
				}
			}
		}
	}

	delete[]WholeImage;

	int NumCharsetsPerBank = (NumCharsets + (NUM_BANKS - 1)) / NUM_BANKS;

	//; Dedupe screen anim data
	unsigned char(*StartScreen)[SINE_CHAR_WIDTH] = new unsigned char[LogoCharHeight][SINE_CHAR_WIDTH];
	for (unsigned int YCharPos = 0; YCharPos < LogoCharHeight; YCharPos++)
	{
		for (unsigned int XCharPos = 0; XCharPos < SINE_CHAR_WIDTH; XCharPos++)
		{
			//; (1) make sure that the screen value varies
			bool bDiffers = false;
			unsigned char FirstVal = ScreenAnims[YCharPos][XCharPos][0];
			StartScreen[YCharPos][XCharPos] = FirstVal;
			for (int FrameIndex = 1; FrameIndex < NUM_FRAMES; FrameIndex++)
			{
				if (ScreenAnims[YCharPos][XCharPos][FrameIndex] != FirstVal)
				{
					bDiffers = true;
					break;
				}

			}
			if (bDiffers)
			{
				int FoundIndex = -1;
				for (int DedupeIndex = 0; DedupeIndex < NumDedupedScreenAnims; DedupeIndex++)
				{
					if (memcmp(DedupedScreenAnims[DedupeIndex], ScreenAnims[YCharPos][XCharPos], NUM_FRAMES) == 0)
					{
						FoundIndex = DedupeIndex;
						break;
					}
				}
				if (FoundIndex == -1)
				{
					FoundIndex = NumDedupedScreenAnims;
					memcpy(DedupedScreenAnims[FoundIndex], ScreenAnims[YCharPos][XCharPos], NUM_FRAMES);
					NumDedupedScreenAnims++;
				}
				ScreenAnimLookup[YCharPos][XCharPos] = FoundIndex;
			}
			else
			{
				ScreenAnimLookup[YCharPos][XCharPos] = -1;
			}
		}
	}

	WriteBinaryFile(OutputCharSetBIN, CharsetData, NumCharsets * 256 * 8);
	WriteBinaryFile(ScreenAnimsBIN, DedupedScreenAnims, NumDedupedScreenAnims * NUM_FRAMES);
//;	WriteBinaryFile(ScreenBIN, StartScreen, LogoCharHeight * SINE_CHAR_WIDTH);
	delete[]StartScreen;

	CodeGen code(DrawLogoASM);
	code.OutputFunctionLine(fmt::format("MainIRQ"));

	unsigned char LastBank = 0xff;
	unsigned char LastCharSet = 0xff;
	unsigned char LastScreen = 0xff;

	int SpriteY = 49 + (LogoYCharStart * 8);
	bool bDoSprites = true;
	int NumCyclesToBurn = 897;
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight; ScreenLine++)
	{
		int RasterLine = 50 + ((LogoYCharStart - 1) * 8) + (ScreenLine * 8);
		code.OutputCommentLine(fmt::format("//; Line ${:02x}", RasterLine));

		unsigned char NewBank = ScreenLineToCharsetLookup[ScreenLine] / NumCharsetsPerBank;
		unsigned char NewCharSet = ScreenLineToCharsetLookup[ScreenLine] % NumCharsetsPerBank;
		unsigned char NewScreen = (ScreenLine % 4) / 2;
		if (NewBank == 1)
		{
			NewCharSet = (NumCharsetsPerBank - 1) - NewCharSet;
		}

		if (NewBank != LastBank)
		{
			NumCyclesToBurn -= code.OutputCodeLine(LDA_IMM, fmt::format("#DD02Value{:d}", NewBank));
			NumCyclesToBurn -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_DD02"));
			LastBank = NewBank;
		}

		if ((NewScreen != LastScreen) || (NewCharSet != LastCharSet))
		{
			NumCyclesToBurn -= code.OutputCodeLine(LDA_IMM, fmt::format("#(ScreenBank{:d} * 16 + CharBank{:d} * 2)", NewScreen, NewCharSet));
			NumCyclesToBurn -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
			LastCharSet = NewCharSet;
			LastScreen = NewScreen;
		}

		if ((!bDoSprites) && ((SpriteY + 1) < RasterLine))
		{
			bDoSprites = true;
			SpriteY += 21;
		}
		if (bDoSprites)
		{
			NumCyclesToBurn -= code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteY));
			for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE + 1; SpriteIndex++)
			{
				NumCyclesToBurn -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
			}
			bDoSprites = false;
		}

		if (ScreenLine & 1)
		{
			unsigned int NextScreenLine = ScreenLine + 2;
			if (NextScreenLine < LogoCharHeight)
			{
				unsigned char NextBank = ScreenLineToCharsetLookup[NextScreenLine] / NumCharsetsPerBank;
				unsigned char NextScreen = (NextScreenLine % 4) / 2;
				for (int SpriteToUpdate = 0; SpriteToUpdate < NUM_SPRITES_PER_LINE + 1; SpriteToUpdate++)
				{
					int SpriteVal = (NextScreenLine / 2) * NUM_SPRITES_PER_LINE + (SpriteToUpdate % NUM_SPRITES_PER_LINE);
					code.OutputFunctionLine(fmt::format("SpriteVal_Line{:d}_Sprite{:d}", (ScreenLine + 1) / 2, SpriteToUpdate));
					NumCyclesToBurn -= code.OutputCodeLine(LDA_IMM, fmt::format("#FirstSpriteValue + ${:02x}", SpriteVal));
					if (NextBank != NewBank)
					{
						NumCyclesToBurn -= code.OutputCodeLine(STA_ABS, fmt::format("Bank{:d}_SpriteVals{:d} + {:d}", NewBank, NextScreen, SpriteToUpdate));
					}
					NumCyclesToBurn -= code.OutputCodeLine(STA_ABS, fmt::format("Bank{:d}_SpriteVals{:d} + {:d}", NextBank, NextScreen, SpriteToUpdate));
				}
			}
		}

		if (ScreenLine != (LogoCharHeight - 1))
		{
			code.WasteCycles(NumCyclesToBurn);
			NumCyclesToBurn = 341;
		}
	}

	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("DrawLogo"));
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight; ScreenLine++)
	{
		code.OutputFunctionLine(fmt::format("DrawLogo_Line{:d}", ScreenLine));
		code.OutputCodeLine(RTS); //;
		unsigned char NewBank = ScreenLineToCharsetLookup[ScreenLine] / NumCharsetsPerBank;
		unsigned char NewScreen = (ScreenLine % 4) / 2;
		for (int XCharPos = 0; XCharPos < SINE_CHAR_WIDTH; XCharPos++)
		{
			int ScreenAnimIndex = ScreenAnimLookup[ScreenLine][XCharPos];
			if (ScreenAnimIndex != -1)
			{
				code.OutputCodeLine(LDA_ABY, fmt::format("ScreenAnimData + ({:d} * {:d})", ScreenAnimIndex, NUM_FRAMES));
				code.OutputCodeLine(STA_ABS, fmt::format("Bank{:d}_ScreenAddress{:d} + ({:d} * 40) + {:d}", NewBank, NewScreen, ScreenLine + LogoYCharStart, XCharPos + LogoXCharStart));
			}
		}
	}
	code.OutputFunctionLine(fmt::format("DrawLogo_Line{:d}", LogoCharHeight));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format(".var DrawLogo_NumLines = {:d}", LogoCharHeight));
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("DrawLogo_LinePtrsLo:"));
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight + 1; ScreenLine++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <DrawLogo_Line{:d}", ScreenLine));
	}
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("DrawLogo_LinePtrsHi:"));
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight + 1; ScreenLine++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >DrawLogo_Line{:d}", ScreenLine));
	}
	code.OutputBlankLine();

	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight; ScreenLine++)
	{
		unsigned char NewBank = ScreenLineToCharsetLookup[ScreenLine] / NumCharsetsPerBank;
		unsigned char NewScreen = (ScreenLine % 4) / 2;

		code.OutputFunctionLine(fmt::format("ClearLogo_Line{:d}", ScreenLine));
		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		code.OutputCodeLine(LDY_IMM, fmt::format("#39"));
		code.OutputFunctionLine(fmt::format("ClearLogo_Line{:d}Loop", ScreenLine));
		code.OutputCodeLine(STA_ABY, fmt::format("Bank{:d}_ScreenAddress{:d} + ({:d} * 40)", NewBank, NewScreen, ScreenLine + LogoYCharStart));
		code.OutputCodeLine(DEY);
		code.OutputCodeLine(BPL, fmt::format("ClearLogo_Line{:d}Loop", ScreenLine));
		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}

	code.OutputCodeLine(NONE, fmt::format("ClearLogo_LinePtrsLo:"));
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight; ScreenLine++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <ClearLogo_Line{:d}", ScreenLine));
	}
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("ClearLogo_LinePtrsHi:"));
	for (unsigned int ScreenLine = 0; ScreenLine < LogoCharHeight; ScreenLine++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >ClearLogo_Line{:d}", ScreenLine));
	}
	code.OutputBlankLine();




	constexpr auto STRIDE = SINE_WIDTH / NUM_FRAMES;
	constexpr auto NUM_X_POSITIONS = 48 / STRIDE;

	unsigned char SpriteXData[NUM_SPRITES_PER_LINE + 1][NUM_X_POSITIONS];
	unsigned char SpriteMSBData[NUM_X_POSITIONS];
	unsigned char ModdedLookup[NUM_FRAMES];

	for (int Index = 0; Index < NUM_X_POSITIONS; Index++)
	{
		unsigned char XMSB = 0;
		int XPos = 24 + (LogoXCharStart * 8) - 48 + Index * STRIDE;
		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE + 1; SpriteIndex++)
		{
			int SpriteXPos = XPos + (48 * SpriteIndex);
			SpriteXData[SpriteIndex][Index] = SpriteXPos & 255;
			if (SpriteXPos >= 256)
			{
				XMSB |= (1 << SpriteIndex);
			}
		}
		SpriteMSBData[Index] = XMSB;
	}

	code.OutputFunctionLine(fmt::format("SpriteXData"));
	for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE + 1; SpriteIndex++)
	{
		code.OutputByteBlock(SpriteXData[SpriteIndex], NUM_X_POSITIONS);
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("SpriteVals"));
	unsigned char SpriteVals[NUM_SPRITES_PER_LINE][NUM_FRAMES];
	for (int Index = 0; Index < NUM_FRAMES; Index++)
	{
		ModdedLookup[Index] = Index % NUM_X_POSITIONS;

		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE; SpriteIndex++)
		{
			int NewIndex = (Index * NUM_SPRITES_PER_LINE) / NUM_FRAMES;
			int NewSpriteIndex = (SpriteIndex + NUM_SPRITES_PER_LINE - NewIndex) % NUM_SPRITES_PER_LINE;
			SpriteVals[SpriteIndex][Index] = (unsigned char)NewSpriteIndex + 0xC0;
		}
	}
	for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_PER_LINE; SpriteIndex++)
	{
		code.OutputByteBlock(SpriteVals[SpriteIndex], NUM_FRAMES);
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("SpriteMSBData"));
	code.OutputByteBlock(SpriteMSBData, NUM_X_POSITIONS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("ModdedLookup"));
	code.OutputByteBlock(ModdedLookup, NUM_FRAMES);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("StartFrame"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$09"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(CPY_IMM, fmt::format("#${:02x}", NUM_FRAMES));
	code.OutputCodeLine(BNE, fmt::format("NotFinalXFrame"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputFunctionLine(fmt::format("NotFinalXFrame"));
	code.OutputCodeLine(STY_ABS, fmt::format("StartFrame + 1"));

	code.OutputFunctionLine(fmt::format("StartFrameWithoutAdvance"));
	code.OutputCodeLine(LDX_ABS, fmt::format("StartFrame + 1"));
	code.OutputCodeLine(LDY_ABX, fmt::format("ModdedLookup"));
	code.OutputBlankLine();

	code.OutputCodeLine(LDA_ABY, fmt::format("SpriteMSBData"));
	code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));

	for (int SpriteToUpdate = 0; SpriteToUpdate < NUM_SPRITES_PER_LINE + 1; SpriteToUpdate++)
	{
		code.OutputCodeLine(LDA_ABY, fmt::format("SpriteXData + ({:d} * {:d})", SpriteToUpdate, NUM_X_POSITIONS));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", SpriteToUpdate));

		if (SpriteToUpdate != 5)
		{
			code.OutputCodeLine(LDA_ABX, fmt::format("SpriteVals + ({:d} * {:d})", SpriteToUpdate, NUM_FRAMES));
			code.OutputCodeLine(STA_ABS, fmt::format("SpriteVal_Line{:d}_Sprite{:d} + 1", 0, SpriteToUpdate));
			if (SpriteToUpdate == 0)
			{
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteVal_Line{:d}_Sprite{:d} + 1", 0, 5));
			}
			for (int LineIndex = 1; LineIndex < 6; LineIndex++)
			{
				code.OutputCodeLine(CLC);
				code.OutputCodeLine(ADC_IMM, fmt::format("#${:d}", NUM_SPRITES_PER_LINE));
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteVal_Line{:d}_Sprite{:d} + 1", LineIndex, SpriteToUpdate));
				if (SpriteToUpdate == 0)
				{
					code.OutputCodeLine(STA_ABS, fmt::format("SpriteVal_Line{:d}_Sprite{:d} + 1", LineIndex, 5));
				}
			}
		}

		code.OutputFunctionLine(fmt::format("SpriteVal_Line0_Sprite{:d}", SpriteToUpdate));
		code.OutputCodeLine(LDA_IMM, fmt::format("#FirstSpriteValue + ${:02x}", (SpriteToUpdate % NUM_SPRITES_PER_LINE)));
		code.OutputCodeLine(STA_ABS, fmt::format("Bank0_SpriteVals0 + {:d}", SpriteToUpdate));
	}
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();
}

int TurnDiskDYPP_Main()
{
	TurnDiskDYPP_GenerateAnimationFrames(
		"6502\\Parts\\TurnDiskDYPP\\Data\\TurnDisk.png",
		L"Out\\6502\\Parts\\TurnDiskDYPP\\CharSet.bin",
		L"Out\\6502\\Parts\\TurnDiskDYPP\\ScreenAnims.bin",
		L"Out\\6502\\Parts\\TurnDiskDYPP\\Screen.bin",
		L"Out\\6502\\Parts\\TurnDiskDYPP\\drawlogo.asm"
	);

	TurnDiskDYPP_InterleaveSpriteData(
		"6502\\Parts\\TurnDiskDYPP\\Data\\Sprites.png",
		L"Out\\6502\\Parts\\TurnDiskDYPP\\Sprites.bin"
	);

	return 0;
}
