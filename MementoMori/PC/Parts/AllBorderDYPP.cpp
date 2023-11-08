// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

constexpr auto DYPP_NUM_FRAMES = 2;

constexpr auto DYPP_StartYPos = 21;

constexpr auto DYPP_TOTALWIDTH = 432;
constexpr auto DYPP_TOTALHEIGHT = 254;
constexpr auto DYPP_TOTALCHARWIDTH = DYPP_TOTALWIDTH / 8;
constexpr auto DYPP_NUMSPRITESACROSS = DYPP_TOTALCHARWIDTH / 3;

constexpr auto FONT_WIDTH = 512;
constexpr auto FONT_HEIGHT = 20;
constexpr auto HALF_FONT_HEIGHT = FONT_HEIGHT / 2;
constexpr auto FONT_CHAR_WIDTH = FONT_WIDTH / 8;

constexpr auto MAX_NUM_SPRITES_TO_USE = 4;

const unsigned char ABDYPP_BlackColour[] = { 0, 0, 0 };
const unsigned char ABDYPP_WhiteColour[] = { 255, 255, 255 };

int ABDYPP_MinMaxYValsPerChar[DYPP_NUM_FRAMES][DYPP_TOTALCHARWIDTH][2];
int ABDYPP_SpriteColumnIndex_PerLine[DYPP_NUM_FRAMES][DYPP_TOTALHEIGHT][MAX_NUM_SPRITES_TO_USE];
int ABDYPP_SpriteIndexPerXChar[DYPP_NUM_FRAMES][DYPP_TOTALCHARWIDTH];
unsigned char ABDYPP_SineScreenMask[DYPP_TOTALHEIGHT][DYPP_TOTALCHARWIDTH];
int ABDYPP_SpriteRemapping[DYPP_NUM_FRAMES][9][MAX_NUM_SPRITES_TO_USE];
int ABDYPP_SineValues[DYPP_TOTALWIDTH];
unsigned char ABDYPP_DedupedFontLine[2048][FONT_CHAR_WIDTH];
int ABDYPP_DedupedFontLineLookup[2048];
int ABDYPP_FontDataLookup[DYPP_NUM_FRAMES][DYPP_TOTALHEIGHT][DYPP_TOTALCHARWIDTH];
int ABDYPP_FontDedupeRemapping[FONT_CHAR_WIDTH];
int ABDYPP_SpriteIndicesToUse[MAX_NUM_SPRITES_TO_USE] = {2, 3, 4, 5};
int ABDYPP_FontLookups[64][2];
unsigned char ABDYPP_DestFontData[FONT_CHAR_WIDTH][FONT_HEIGHT];
unsigned char ABDYPP_DedupedFontData[FONT_CHAR_WIDTH][FONT_HEIGHT];
unsigned char ABDYPP_FontData[2048][FONT_CHAR_WIDTH];
unsigned char ABDYPP_TestSpriteData[MAX_NUM_SPRITES_TO_USE][9][64];
unsigned char ABDYPP_PackedSprites[256][64];

unsigned char ABDYPP_MyScrollText[] = {
	"do you know the surest mark of the cowardly? not death but the fear of death."
	"  control your thoughts to see the path to freedom."
	"                                                     "
};

unsigned char SpriteScrollerColours[] = {
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
	0x06, 0x0e, 0x03, 0x01, 0x01, 0x01, 0x0f, 0x0c, 0x0b,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
	0x0b, 0x0c, 0x0f, 0x01, 0x01, 0x01, 0x07, 0x0a, 0x02,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x02, 0x0a, 0x07, 0x01, 0x01, 0x01, 0x03, 0x0e, 0x06,
	0xff
};

void AllBorderDYPP_CalcData(void)
{
	GPIMAGE SineImage(DYPP_TOTALWIDTH, DYPP_TOTALHEIGHT);

	ZeroMemory(ABDYPP_SineScreenMask, sizeof(ABDYPP_SineScreenMask));

	unsigned char RGBGrey[3] = {128, 128, 128};
	for (int XPos = 0; XPos < DYPP_TOTALWIDTH; XPos ++)
	{
		static const int MaxYValue = DYPP_TOTALHEIGHT - FONT_HEIGHT;
		double angle = (2.0 * PI * XPos) / DYPP_TOTALWIDTH + (3 * PI / 2);
		double SinValue = (sin(angle) + 1.0) * 0.5;
		double YValue = SinValue * (double)(MaxYValue - 4) + 3; // Hack to fix the glitching (previously was just (double)MaxYValue + 1)
		unsigned int iYPos = (unsigned int)floor(YValue) & 0xfffffffe;

		// Hacks to fix the glitching
		if (iYPos <= (HALF_FONT_HEIGHT + 8))
		{
			iYPos -= 2;
		}
		if (iYPos >= 210)
		{
			iYPos += 2;
		}
		iYPos = min(iYPos, MaxYValue);
		ABDYPP_SineValues[XPos] = iYPos;

		SineImage.FillRectangle(XPos, iYPos, XPos + 1, iYPos + FONT_HEIGHT, 0xbbbbbb);

		for (unsigned int iYSet = iYPos; iYSet < iYPos + FONT_HEIGHT; iYSet++)
		{
			int XPixelPos = XPos % 8;
			int XCharPos = XPos / 8;
			ABDYPP_SineScreenMask[iYSet][XCharPos] |= (3 << (6 - XPixelPos));
		}
	}
	SineImage.Write("Out\\6502\\Parts\\AllBorderDYPP\\Sine.png");

	GPIMAGE SpriteSineImage(DYPP_TOTALWIDTH * 2, DYPP_TOTALHEIGHT);

	static unsigned char RGBValue[MAX_NUM_SPRITES_TO_USE + 1][3] = {
		{ 255, 0, 0 },
		{ 192, 0, 192 },
		{ 0, 192, 192 },
		{ 192, 192, 0 },
		{ 64, 64, 255 },
	};

	memset(ABDYPP_SpriteColumnIndex_PerLine, 0xff, sizeof(ABDYPP_SpriteColumnIndex_PerLine));
	memset(ABDYPP_SpriteIndexPerXChar, 0xff, sizeof(ABDYPP_SpriteIndexPerXChar));

	for (int FrameIndex = 0; FrameIndex < 2; FrameIndex++)
	{
		int XShift = FrameIndex * 4;
		for (int XSpriteIndex = 0; XSpriteIndex < DYPP_NUMSPRITESACROSS; XSpriteIndex++)
		{
			int SpriteMinY = INT_MAX;
			int SpriteMaxY = INT_MIN;

			for (int XCharIndex = 0; XCharIndex < 3; XCharIndex++)
			{
				int XCharPos = XSpriteIndex * 3 + XCharIndex;

				int MinY = INT_MAX;
				int MaxY = INT_MIN;
				for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
				{
					int XPos = XCharPos * 8 + XPixelPos;
					XPos = (XPos + XShift) % DYPP_TOTALWIDTH;
					for (int YPos = 0; YPos < DYPP_TOTALHEIGHT; YPos++)
					{
						unsigned int Colour = SineImage.GetPixel(XPos, YPos);
						if (Colour != 0x000000)
						{
							MinY = min(YPos, MinY);
							MaxY = max(YPos, MaxY);
						}
					}
				}
				SpriteMinY = min(SpriteMinY, MinY);
				SpriteMaxY = max(SpriteMaxY, MaxY);
			}

			int SpriteToUse = -1;
			for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
			{
				SpriteToUse = SpriteIndex;
				for (int YPos = SpriteMinY; YPos < SpriteMaxY; YPos++)
				{
					if (ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][YPos][SpriteIndex] != -1)
					{
						SpriteToUse = -1;
						break;
					}
				}
				if (SpriteToUse != -1)
				{
					break;
				}
			}
			if (SpriteToUse != -1)
			{
				for (int YPos = SpriteMinY; YPos < SpriteMaxY; YPos++)
				{
					ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][YPos][SpriteToUse] = XSpriteIndex;
					ABDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 0] = ABDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 1] = ABDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 2] = SpriteToUse;
				}
			}
			SpriteToUse++;

			int XPos0 = XSpriteIndex * 24 + FrameIndex * DYPP_TOTALWIDTH;
			int XPos1 = XPos0 + 23;
			SpriteSineImage.FillRectangle(XPos0, SpriteMinY, XPos1, SpriteMaxY, 0xbbbbbb);	//; GetC64ColourRGB(SpriteToUse + 1));
		}
	}

	for (int FrameIndex = 0; FrameIndex < 2; FrameIndex++)
	{
		for (int YPos = 0; YPos < DYPP_TOTALHEIGHT; YPos++)
		{
			for (int XPixel = 0; XPixel < DYPP_TOTALWIDTH; XPixel++)
			{
				int XPos = (FrameIndex * 4 + XPixel) % DYPP_TOTALWIDTH;

				unsigned int Colour = SineImage.GetPixel(XPos, YPos);
				if (Colour != 0x000000)
				{
					int SpriteXPos = FrameIndex * DYPP_TOTALWIDTH + XPixel;
					unsigned int Colour = SpriteSineImage.GetPixel(SpriteXPos, YPos);
					if (Colour != 0xffffff)
					{
						SpriteSineImage.SetPixel(SpriteXPos, YPos, Colour);
					}
				}
			}
		}
	}

	SpriteSineImage.Write("Out\\6502\\Parts\\AllBorderDYPP\\SineSprites.png");
}


bool AllBorderDYPP_InsertSpriteBlitCode(CodeGen& code, int& NumCyclesToUse, bool bFirstPass, int FrameIndex)
{
	int ALineLoaded = -1;

	static bool CODE_bNewXCharPos = false;
	static int CODE_XCharPos = -1;
	static int CODE_SubPixelY = -1;
	static int CODE_MinY = -1;
	static int CODE_MaxY = -1;
	static int CODE_YPos = -1;

	if (bFirstPass)
	{
		CODE_bNewXCharPos = true;
		CODE_XCharPos = 0;
	}

	bool bNotEnoughCycles = false;

	while ((CODE_XCharPos < DYPP_TOTALCHARWIDTH) && (bNotEnoughCycles == false))
	{
		if (CODE_bNewXCharPos)
		{
			if (EnoughFreeCycles(NumCyclesToUse, 3))
			{
				CODE_MinY = ABDYPP_MinMaxYValsPerChar[FrameIndex][CODE_XCharPos][0] / 2;
				CODE_MaxY = ABDYPP_MinMaxYValsPerChar[FrameIndex][CODE_XCharPos][1] / 2;
				CODE_SubPixelY = ABDYPP_MinMaxYValsPerChar[FrameIndex][CODE_XCharPos][0] & 1;

				CODE_YPos = CODE_MinY;

				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDX_ZP, fmt::format("ZP_ScrollText + {:d}", CODE_XCharPos)));

				CODE_bNewXCharPos = false;
			}
			else
			{
				bNotEnoughCycles = true;
			}
		}

		if (!CODE_bNewXCharPos)
		{
			while ((CODE_YPos < CODE_MaxY) && (bNotEnoughCycles == false))
			{
				int ReadLine = ABDYPP_FontDataLookup[FrameIndex][CODE_YPos * 2 + CODE_SubPixelY][CODE_XCharPos];
				ReadLine = ABDYPP_DedupedFontLineLookup[ReadLine];

				int SpriteYPos = CODE_YPos;
				int SpriteIndex = ABDYPP_SpriteIndexPerXChar[FrameIndex][CODE_XCharPos];
				int SpriteYIndex = min(8, max(0, SpriteYPos) / 16);
				int SpriteVal = ABDYPP_SpriteRemapping[FrameIndex][SpriteYIndex][SpriteIndex];
				int SpriteLine = ((SpriteYPos + 1) % 21);

				int NumCyclesNeeded = ALineLoaded == ReadLine ? 4 : 8;
				if (EnoughFreeCycles(NumCyclesToUse, NumCyclesNeeded))
				{
					if (ALineLoaded != ReadLine)
					{
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("FontDataDeduped_Line{:03d}", ReadLine)));
						ALineLoaded = ReadLine;
					}
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("Base_BankAddress0 + (FirstSpriteValue + {:d}) * 64 + {:d} * 3 + {:d}", SpriteVal, SpriteLine, CODE_XCharPos % 3)));

					CODE_YPos++;
				}
				else
				{
					bNotEnoughCycles = true;
				}
			}
			if (CODE_YPos == CODE_MaxY)
			{
				code.OutputBlankLine();
				CODE_XCharPos++;
				CODE_bNewXCharPos = true;
			}
		}
	}

	if (CODE_XCharPos == DYPP_TOTALCHARWIDTH)
	{
		return true;
	}
	return false;
}

int AllBorderDYPP_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass, int FrameIndex)
{
	static bool bFinishedSpriteBlitCode = false;
//;	static bool bFinishedStarCode = false;
	if (bFirstPass)
	{
		bFinishedSpriteBlitCode = false;
//;		bFinishedStarCode = false;
		AllBorderDYPP_InsertSpriteBlitCode(code, NumCycles, bFirstPass, 1 - FrameIndex);
//;		AllBorderDYPP_InsertStarCode(code, NumCycles, bFirstPass, 1 - FrameIndex);
	}
/*	if (!bFinishedStarCode)
	{
		bFinishedStarCode = AllBorderDYPP_InsertStarCode(code, NumCycles, bFirstPass, 1 - FrameIndex);
	}
	if (bFinishedStarCode)*/
	{
		if (!bFinishedSpriteBlitCode)
		{
			bFinishedSpriteBlitCode = AllBorderDYPP_InsertSpriteBlitCode(code, NumCycles, bFirstPass, 1 - FrameIndex);
		}
	}
	return code.WasteCycles(NumCycles);
}


void AllBorderDYPP_AddExtraFunctions(CodeGen& code)
{
	code.OutputCodeLine(NONE, fmt::format("DYPP_SpriteXPos: .byte $00"));
	code.OutputBlankLine();

	for (int Index = 0; Index < 8; Index++)
	{
		code.OutputCodeLine(NONE, fmt::format("Sprite{:d}MSBVals: .byte ${:02x}, ${:02x}", Index, 0, (1 << Index)));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("DYPP_SpriteScrollerColours"));
	code.OutputByteBlock(SpriteScrollerColours, sizeof(SpriteScrollerColours));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("ScrollScrollText"));
	code.OutputCodeLine(LDX_ZP, fmt::format("ZP_ScrollText"));
	for (int Index = 0; Index < 53; Index++)
	{
		code.OutputCodeLine(LDA_ZP, fmt::format("ZP_ScrollText + {:d}", Index + 1));
		code.OutputCodeLine(STA_ZP, fmt::format("ZP_ScrollText + {:d}", Index));
	}
	code.OutputCodeLine(STX_ZP, fmt::format("ZP_ScrollText + 53"));
	code.OutputCodeLine(LDA_ABS, fmt::format("FrameOf256"));
	code.OutputCodeLine(AND_IMM, fmt::format("#$03"));
	code.OutputCodeLine(BNE, fmt::format("UpdateForNewChar"));
	code.OutputCodeLine(RTS);
	code.OutputFunctionLine(fmt::format("UpdateForNewChar"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputFunctionLine(fmt::format("ScrollTextReadPtr"));
	code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_ScrollText"));
	code.OutputCodeLine(BPL, fmt::format("NotFinishedScroller"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#$02"));
	code.OutputCodeLine(STA_ABS, fmt::format("Signal_CustomSignal1"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#<DYPP_ScrollText"));
	code.OutputCodeLine(STA_ABS, fmt::format("ScrollTextReadPtr + 1"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#>DYPP_ScrollText"));
	code.OutputCodeLine(STA_ABS, fmt::format("ScrollTextReadPtr + 2"));
	code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_ScrollText"));
	code.OutputFunctionLine(fmt::format("NotFinishedScroller"));
	code.OutputCodeLine(STA_ABY, fmt::format("ZP_ScrollText"));
	code.OutputCodeLine(INC_ABS, fmt::format("ScrollTextReadPtr + 1"));
	code.OutputCodeLine(BNE, fmt::format("NotPassedPage"));
	code.OutputCodeLine(INC_ABS, fmt::format("ScrollTextReadPtr + 2"));
	code.OutputFunctionLine(fmt::format("NotPassedPage"));
	code.OutputCodeLine(DEY);
	code.OutputCodeLine(BPL, fmt::format("NotLastOne"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#53"));
	code.OutputFunctionLine(fmt::format("NotLastOne"));
	code.OutputCodeLine(STY_ABS, fmt::format("UpdateForNewChar + 1"));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("ScrollerColourUpdate"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputCodeLine(LDA_ABY, fmt::format("DYPP_SpriteScrollerColours"));
	code.OutputCodeLine(BPL, fmt::format("AllGood"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_SpriteScrollerColours"));
	code.OutputFunctionLine(fmt::format("AllGood"));
	code.OutputCodeLine(STA_ABS, fmt::format("ZP_SpriteScrollerColour"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(STY_ABS, fmt::format("ScrollerColourUpdate + 1"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();
}

void AllBorderDYPP_OutputCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	code.OutputCodeLine(NONE, fmt::format(".import source \"../../../../6502/Parts/AllBorderDYPP/AllBorderDYPP-CommonDefines.asm\""));
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("* = MainIRQ"));
	code.OutputBlankLine();

	code.OutputCodeLine(STA_ABS, fmt::format("RestoreIRQA + 1"));
	code.OutputCodeLine(STX_ABS, fmt::format("RestoreIRQX + 1"));
	code.OutputCodeLine(STY_ABS, fmt::format("RestoreIRQY + 1"));

	code.OutputCodeLine(JSR_ABS, fmt::format("SetInitialSpriteValues_Frame0"));

	code.OutputCodeLine(LDX_IMM, fmt::format("#<IRQ_Main_Frame0"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#>IRQ_Main_Frame0"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	AllBorderDYPP_AddExtraFunctions(code);

	for (int FrameIndex = 0; FrameIndex < DYPP_NUM_FRAMES; FrameIndex++)
	{
		bool bCharSetBufferSwapped = false;
		int TotalWastedCycles = 0;

		AllBorderDYPP_UseCycles(code, 0, true, FrameIndex);

		int MSB_SpriteColumnIndices[32][8];
		int NumMSBVals = 0;
		int CurrentSpriteColumnIndex[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
		int CurrentSpriteYVal = DYPP_StartYPos;

		// Initial Sprite Values -------------------------------------------------------------------------------------------------------------
		code.OutputFunctionLine(fmt::format("SetInitialSpriteValues_Frame{:d}", FrameIndex));

		for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			int OutputSpriteIndex = ABDYPP_SpriteIndicesToUse[SpriteIndex];

			int SpriteColumnIndex = -1;

			for (int NextUpdateLine = 0; NextUpdateLine < DYPP_TOTALHEIGHT; NextUpdateLine++)
			{
				SpriteColumnIndex = ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][NextUpdateLine][SpriteIndex];
				if (SpriteColumnIndex != -1)
				{
					break;
				}
			}

			// Initial X
			code.OutputFunctionLine(fmt::format("DYPP_SpriteX{:d}_Frame{:d}", SpriteColumnIndex, FrameIndex));
			code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", OutputSpriteIndex));
			CurrentSpriteColumnIndex[OutputSpriteIndex] = SpriteColumnIndex;

			// Initial Y
			code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYVal));
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", OutputSpriteIndex));

			// Initial SpriteVals
			int SpriteVal = ABDYPP_SpriteRemapping[FrameIndex][0][SpriteIndex];
			if (SpriteVal != -1)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#FirstSpriteValue + {:d}", SpriteVal));
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteVals0 + {:d}", OutputSpriteIndex));
			}
		}

		code.OutputFunctionLine(fmt::format("DYPP_MSB_{:02d}_{:02d}_{:02d}_{:02d}_Frame{:d}", CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[0]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[1]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[2]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[3]], FrameIndex));
		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));
		code.OutputBlankLine();
		memcpy(MSB_SpriteColumnIndices[NumMSBVals++], CurrentSpriteColumnIndex, sizeof(CurrentSpriteColumnIndex));

		int CurrentD018 = 1;
		CurrentD018 ^= 1;
		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentD018));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));

		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
		// Initial Sprite Values -------------------------------------------------------------------------------------------------------------

		code.OutputFunctionLine(fmt::format("IRQ_Main_Frame{:d}", FrameIndex));

		code.OutputCodeLine(CALLMACRO, fmt::format("IRQManager_BeginIRQ(1, 0)"));

		code.OutputCodeLine(LDA_ZP, fmt::format("ZP_SpriteScrollerColour"));
		for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			int OutputSpriteIndex = ABDYPP_SpriteIndicesToUse[SpriteIndex];
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", OutputSpriteIndex));
		}
		code.OutputBlankLine();

		AllBorderDYPP_UseCycles(code, 26, false, FrameIndex);

		code.OutputCodeLine(LDY_IMM, fmt::format("#D016_Value_40Rows"));
		code.OutputCodeLine(LDA_IMM, fmt::format("#D016_Value_38Rows"));
		code.OutputBlankLine();

		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
		code.OutputBlankLine();

		int UpdateSpriteValIndex = -1;
		bool bXMSBIsDirty = false;
		for (int YLine = 0; YLine < DYPP_TOTALHEIGHT; YLine++)
		{
			int RasterLine = YLine + DYPP_StartYPos + 1;
			bool bFlipCharSetThisLine = false;

			code.OutputCommentLine(fmt::format("//; Line ${:02x}", RasterLine));

			int NumCyclesToUse = 42;
			int RasterLineMod8 = RasterLine % 8;
			int YLineMod32 = YLine % 32;

			bool bIsBadLine = (RasterLineMod8 == 2) && (RasterLine >= 50) && (RasterLine < 250);

			if ((RasterLine > DYPP_StartYPos) && (YLineMod32 == 3))
			{
				UpdateSpriteValIndex = 0;
			}

			if (RasterLine == 249)
			{
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_24Rows")));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011")));
				code.OutputBlankLine();
			}
			if (RasterLine == 256)
			{
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_25Rows")));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011")));
				code.OutputBlankLine();
			}

			if (!bIsBadLine && (RasterLine > CurrentSpriteYVal))
			{
				CurrentSpriteYVal += 42;

				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYVal & 255)));
				for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", ABDYPP_SpriteIndicesToUse[SpriteIndex])));
				}
				code.OutputBlankLine();
			}

			if (bIsBadLine)
			{
				code.OutputCodeLine(STA_ABY, fmt::format("VIC_D016 - D016_Value_40Rows"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
				code.OutputBlankLine();
			}
			else
			{
				if ((!bCharSetBufferSwapped) && (RasterLine >= 145))
				{
					if (EnoughFreeCycles(NumCyclesToUse, 6))
					{
						bFlipCharSetThisLine = true;
						NumCyclesToUse -= 6;
					}
				}

				if ((YLine > 31) && (YLineMod32 == 0))
				{
					if (EnoughFreeCycles(NumCyclesToUse, 6))
					{
						CurrentD018 ^= 1;
						if (!bCharSetBufferSwapped)
						{
							SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentD018)));
						}
						else
						{
							SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}B", CurrentD018)));
						}
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018")));
					}
				}

				bool bUpdatedXMSB = false;
				for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					int OutputSpriteIndex = ABDYPP_SpriteIndicesToUse[SpriteIndex];
					if(YLine >= 2)
					{
						if (ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][YLine - 2][SpriteIndex] != CurrentSpriteColumnIndex[OutputSpriteIndex])
						{
							int NextSpriteColumnIndex = -1;
							for (int NextUpdateLine = YLine - 2; NextUpdateLine < DYPP_TOTALHEIGHT; NextUpdateLine++)
							{
								NextSpriteColumnIndex = ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][NextUpdateLine][SpriteIndex];
								if (NextSpriteColumnIndex != -1)
								{
									break;
								}
							}
							if (NextSpriteColumnIndex != -1)
							{
								if (NextSpriteColumnIndex != CurrentSpriteColumnIndex[OutputSpriteIndex])
								{
									if (EnoughFreeCycles(NumCyclesToUse, 6))
									{
										code.OutputFunctionLine(fmt::format("DYPP_SpriteX{:d}_Frame{:d}", NextSpriteColumnIndex, FrameIndex));
										SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#$00")));
										SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", OutputSpriteIndex)));

										bXMSBIsDirty = true;
										CurrentSpriteColumnIndex[OutputSpriteIndex] = NextSpriteColumnIndex;
									}
								}
							}
						}
					}
				}
				if (bXMSBIsDirty)
				{
					if (EnoughFreeCycles(NumCyclesToUse, 6))
					{
						code.OutputFunctionLine(fmt::format("DYPP_MSB_{:02d}_{:02d}_{:02d}_{:02d}_Frame{:d}", CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[0]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[1]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[2]], CurrentSpriteColumnIndex[ABDYPP_SpriteIndicesToUse[3]], FrameIndex));
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#$00")));
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB")));
						memcpy(MSB_SpriteColumnIndices[NumMSBVals++], CurrentSpriteColumnIndex, sizeof(CurrentSpriteColumnIndex));
						bXMSBIsDirty = false;
					}
				}

				while ((UpdateSpriteValIndex != -1) && (EnoughFreeCycles(NumCyclesToUse, 6)))
				{
					int LineVal = YLine / 32 + 1;
					int SpriteVal = ABDYPP_SpriteRemapping[FrameIndex][LineVal][UpdateSpriteValIndex];
					if (SpriteVal != -1)
					{
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_IMM, fmt::format("#FirstSpriteValue + {:d}", SpriteVal)));
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("SpriteVals{:d} + {:d}", 1 - CurrentD018, ABDYPP_SpriteIndicesToUse[UpdateSpriteValIndex])));
					}
					UpdateSpriteValIndex++;
					if (UpdateSpriteValIndex == MAX_NUM_SPRITES_TO_USE)
					{
						UpdateSpriteValIndex = -1;
					}
				}

				TotalWastedCycles += AllBorderDYPP_UseCycles(code, NumCyclesToUse, false, FrameIndex);

				if (bFlipCharSetThisLine)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}B", CurrentD018));
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
					bCharSetBufferSwapped = true;
				}

				code.OutputCodeLine(LDA_IMM, fmt::format("#D016_Value_38Rows"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
				code.OutputBlankLine();
			}
		}

		AllBorderDYPP_UseCycles(code, -1, false, FrameIndex);
		code.OutputBlankLine();

		code.OutputFunctionLine(fmt::format("UpdateSpriteXVals_Frame{:d}", FrameIndex));
		code.OutputCodeLine(LDA_ABS, fmt::format("DYPP_SpriteXPos"));
		if (FrameIndex != 0)
		{
			code.OutputCodeLine(CLC);
			code.OutputCodeLine(ADC_IMM, fmt::format("#${:02x}", 3));
			code.OutputCodeLine(CMP_IMM, fmt::format("#${:02x}", DYPP_TOTALWIDTH / 2));
			code.OutputCodeLine(BCC, fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
			code.OutputCodeLine(SEC);
			code.OutputCodeLine(SBC_IMM, fmt::format("#${:02x}", DYPP_TOTALWIDTH / 2));
		}
		else
		{
			code.OutputCodeLine(SEC);
			code.OutputCodeLine(SBC_IMM, fmt::format("#${:02x}", 1));
			code.OutputCodeLine(BCS, fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
			code.OutputCodeLine(CLC);
			code.OutputCodeLine(ADC_IMM, fmt::format("#${:02x}", DYPP_TOTALWIDTH / 2));
		}
		code.OutputFunctionLine(fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
		code.OutputCodeLine(STA_ABS, fmt::format("DYPP_SpriteXPos"));
		code.OutputCodeLine(TAX);
		code.OutputBlankLine();

		for (int SpriteIndex = 0; SpriteIndex < DYPP_NUMSPRITESACROSS; SpriteIndex++)
		{
			code.OutputCodeLine(LDA_ABX, fmt::format("SpriteXValsMem + {:d}", SpriteIndex * ((DYPP_TOTALWIDTH / 2) / DYPP_NUMSPRITESACROSS)));
 			code.OutputCodeLine(STA_ABS, fmt::format("DYPP_SpriteX{:d}_Frame{:d} + 1", SpriteIndex, FrameIndex));
		}
		code.OutputBlankLine();

		int CurrentMSBColumnIndices[8] = {INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX};
		code.OutputCodeLine(LDA_ABS, fmt::format("#$00"));
		code.OutputBlankLine();
		for (int MSBIndex = 0; MSBIndex < NumMSBVals; MSBIndex++)
		{
			unsigned char MSBMask = 0xff;
		
			if (MSBIndex != 0)
			{
				for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					if (MSB_SpriteColumnIndices[MSBIndex][ABDYPP_SpriteIndicesToUse[SpriteIndex]] != CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[SpriteIndex]])
					{
						MSBMask ^= (0x01 << ABDYPP_SpriteIndicesToUse[SpriteIndex]);
					}
				}
				code.OutputCodeLine(AND_IMM, fmt::format("#${:02x}", MSBMask));
			}

			for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
			{
				int NewSpriteColumnIndex = MSB_SpriteColumnIndices[MSBIndex][ABDYPP_SpriteIndicesToUse[SpriteIndex]];
				if (NewSpriteColumnIndex != CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[SpriteIndex]])
				{
					code.OutputCodeLine(LDY_ABX, fmt::format("SpriteXValsMem + {:d}", DYPP_TOTALWIDTH + NewSpriteColumnIndex * ((DYPP_TOTALWIDTH / 2) / DYPP_NUMSPRITESACROSS)));
					code.OutputCodeLine(ORA_ABY, fmt::format("Sprite{:d}MSBVals", ABDYPP_SpriteIndicesToUse[SpriteIndex]));
					CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[SpriteIndex]] = NewSpriteColumnIndex;
				}
			}
			code.OutputCodeLine(STA_ABS, fmt::format("DYPP_MSB_{:02d}_{:02d}_{:02d}_{:02d}_Frame{:d} + 1", CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[0]], CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[1]], CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[2]], CurrentMSBColumnIndices[ABDYPP_SpriteIndicesToUse[3]], FrameIndex));
		}
		code.OutputBlankLine();

		code.OutputCodeLine(LDA_IMM, fmt::format("#DYPP_BackgroundColour"));
		for (int SpriteIndex = 0; SpriteIndex < MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			int OutputSpriteIndex = ABDYPP_SpriteIndicesToUse[SpriteIndex];
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", OutputSpriteIndex));
		}

		code.OutputCodeLine(INC_ABS, fmt::format("FrameOf256"));
		code.OutputCodeLine(BNE, fmt::format("Not256_Frame{:d}", FrameIndex));
		code.OutputCodeLine(INC_ABS, fmt::format("Frame_256Counter"));
		code.OutputFunctionLine(fmt::format("Not256_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(LDA_ABS, fmt::format("FrameOf256"));
		code.OutputCodeLine(AND_IMM, fmt::format("#$01"));
		code.OutputCodeLine(CMP_IMM, fmt::format("#$00"));
		code.OutputCodeLine(BNE, fmt::format("NotZero_Frame{:d}", FrameIndex));
		code.OutputCodeLine(JSR_ABS, fmt::format("ScrollScrollText"));
		code.OutputFunctionLine(fmt::format("NotZero_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(JSR_ABS, fmt::format("BASECODE_PlayMusic"));
		code.OutputBlankLine();

		code.OutputCodeLine(JSR_ABS, fmt::format("SetInitialSpriteValues_Frame{:d}", 1 - FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(LDX_IMM, fmt::format("#<IRQ_Main_Frame{:d}", 1 - FrameIndex));
		code.OutputCodeLine(LDY_IMM, fmt::format("#>IRQ_Main_Frame{:d}", 1 - FrameIndex));

		if (FrameIndex == 1)
		{
			code.OutputCodeLine(LDA_ABS, fmt::format("Signal_CustomSignal1"));
			code.OutputCodeLine(BEQ, fmt::format("NotFinishedScrollText"));
			code.OutputFunctionLine(fmt::format("RestoreIRQX"));
			code.OutputCodeLine(LDX_IMM, fmt::format("#$ab"));
			code.OutputFunctionLine(fmt::format("RestoreIRQY"));
			code.OutputCodeLine(LDY_IMM, fmt::format("#$ab"));
			code.OutputFunctionLine(fmt::format("RestoreIRQA"));
			code.OutputCodeLine(LDA_IMM, fmt::format("#$ab"));
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_D012"));
			code.OutputFunctionLine(fmt::format("NotFinishedScrollText"));
		}

		code.OutputCodeLine(STX_ZP, fmt::format("ZP_IRQJump + 1"));
		code.OutputCodeLine(STY_ZP, fmt::format("ZP_IRQJump + 2"));
		code.OutputBlankLine();

		code.OutputCodeLine(CALLMACRO, fmt::format("IRQManager_EndIRQ()"));
		code.OutputCodeLine(RTI);
		code.OutputBlankLine();
	}
}

void AllBorderDYPP_CalcSpritePacking(void)
{
	ZeroMemory(ABDYPP_TestSpriteData, sizeof(ABDYPP_TestSpriteData));

	int NumPackedSprites = 0;

	for (int FrameIndex = 0; FrameIndex < DYPP_NUM_FRAMES; FrameIndex++)
	{
		for (int SpriteIndex = 0; SpriteIndex < 9; SpriteIndex++)
		{
			for (int YVal = 0; YVal < 16; YVal++)
			{
				for (int XByte = 0; XByte < 3; XByte++)
				{
					int VirtualY = ((SpriteIndex * 16) + YVal + 1) % 21;
					int OutputOffset = VirtualY * 3 + XByte;
					unsigned char OutputByte = (YVal & 1) ? 0x99 : 0xee;

					for (int SpriteColumn = 0; SpriteColumn < MAX_NUM_SPRITES_TO_USE; SpriteColumn++)
					{
						int ActualY = SpriteIndex * 32 + YVal * 2;
						if (ActualY < DYPP_TOTALHEIGHT)
						{
							int SpriteX = ABDYPP_SpriteColumnIndex_PerLine[FrameIndex][ActualY][SpriteColumn];
							unsigned char OutputMask = 0x00;
							if (SpriteX >= 0)
							{
								int XMaskLookup = (SpriteX * 3) + XByte;
								OutputMask = ABDYPP_SineScreenMask[ActualY][XMaskLookup];
							}
							ABDYPP_TestSpriteData[SpriteColumn][SpriteIndex][OutputOffset] = (OutputByte & OutputMask);// | (0xff - OutputMask);
						}
					}
				}
			}
		}

		for (int SpriteIndex = 0; SpriteIndex < 9; SpriteIndex++)
		{
			for (int SpriteColumn = 0; SpriteColumn < MAX_NUM_SPRITES_TO_USE; SpriteColumn++)
			{
				ABDYPP_SpriteRemapping[FrameIndex][SpriteIndex][SpriteColumn] = -1;

				bool bEmpty = true;
				for (int ByteIndex = 0; ByteIndex < 63; ByteIndex++)
				{
					if (ABDYPP_TestSpriteData[SpriteColumn][SpriteIndex][ByteIndex])
					{
						bEmpty = false;
						break;
					}
				}

				if (!bEmpty)
				{
					memcpy(ABDYPP_PackedSprites[NumPackedSprites], ABDYPP_TestSpriteData[SpriteColumn][SpriteIndex], 64);
					ABDYPP_SpriteRemapping[FrameIndex][SpriteIndex][SpriteColumn] = NumPackedSprites;
					NumPackedSprites++;
				}
			}
		}
	}
}

void AllBorderDYPP_ProcessFontData(char* FontFilename, LPTSTR FontBinFilename, LPTSTR FontASMFilename)
{
	GPIMAGE SrcImg(FontFilename);

	int NumChars = 0;
	int WidthChar = 1;
	bool bNewChar = true;
	for (int XChar = 0; XChar < FONT_CHAR_WIDTH; XChar++)
	{
		if (bNewChar)
		{
			ABDYPP_FontLookups[NumChars][0] = XChar;
			WidthChar = 1;
			bNewChar = false;
		}
		int XPos = XChar * 8 + 7;

		bool bLastChar = true;
		for (int YPixel = 0; YPixel < FONT_HEIGHT; YPixel++)
		{
			unsigned int Colour = SrcImg.GetPixel(XPos, YPixel);
			if (Colour != 0x000000)
			{
				bLastChar = false;
			}
		}
		if (!bLastChar)
		{
			WidthChar++;
		}
		else
		{
			ABDYPP_FontLookups[NumChars][1] = WidthChar;
			NumChars++;
			bNewChar = true;
		}
	}

	for (int XChar = 0; XChar < FONT_CHAR_WIDTH; XChar++)
	{
		for (int YPixel = 0; YPixel < FONT_HEIGHT; YPixel++)
		{
			unsigned char ByteData = 0;
			for (int XPixel = 0; XPixel < 8; XPixel ++)
			{
				int XPos = XChar * 8 + XPixel;
				int YPos = YPixel;

				unsigned int Colour = SrcImg.GetPixel(XPos, YPos);
				if (Colour != 0x000000)
				{
					ByteData |= (1 << (7 - XPixel));
				}
			}
			ABDYPP_DestFontData[XChar][YPixel] = ByteData;
		}
	}

	
	int NumDedupedChars = 0;

	for (int XChar = 0; XChar < FONT_CHAR_WIDTH; XChar++)
	{
		int DupeIndex = -1;
		for (int DedupeIndex = 0; DedupeIndex < NumDedupedChars; DedupeIndex++)
		{
			bool bFound = true;
			for (int YPixel = 0; YPixel < FONT_HEIGHT; YPixel++)
			{
				if (ABDYPP_DestFontData[XChar][YPixel] != ABDYPP_DedupedFontData[DedupeIndex][YPixel])
				{
					bFound = false;
					break;
				}
			}
			if (bFound)
			{
				DupeIndex = DedupeIndex;
				break;
			}
		}
		if (DupeIndex == -1)
		{
			memcpy(ABDYPP_DedupedFontData[NumDedupedChars], ABDYPP_DestFontData[XChar], sizeof(unsigned char) * FONT_HEIGHT);
			DupeIndex = NumDedupedChars;
			NumDedupedChars++;
		}
		ABDYPP_FontDedupeRemapping[XChar] = DupeIndex;
	}




	GPIMAGE DYPPEDFontImage(NumDedupedChars * 8, 2048);

	memset(ABDYPP_FontDataLookup, 255, sizeof(ABDYPP_FontDataLookup));

	ZeroMemory(ABDYPP_FontData, sizeof(ABDYPP_FontData));
	unsigned char RGBWhite[3] = { 0xff, 0xff, 0xff };

	int YCurrentPos = 0;
	for (int FrameIndex = 0; FrameIndex < DYPP_NUM_FRAMES; FrameIndex++)
	{
		int XShift = FrameIndex * 4;
		for (int XCharPos = 0; XCharPos < DYPP_TOTALCHARWIDTH; XCharPos++)
		{
			int MinY = INT_MAX;
			int MaxY = INT_MIN;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;
				XPos = (XPos + XShift) % DYPP_TOTALWIDTH;

				int SineYMin = ABDYPP_SineValues[XPos];
				int SineYMax = SineYMin + FONT_HEIGHT;
				MinY = min(SineYMin, MinY);
				MaxY = max(SineYMax, MaxY);
			}

			int SubPixelY = MinY & 1;

			ABDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][0] = MinY;
			ABDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][1] = MaxY;

			MinY = MinY / 2;
			MaxY = MaxY / 2;

			int YCurrent = YCurrentPos;
			for (int YPixel = MinY; YPixel < MaxY; YPixel++)
			{
				ABDYPP_FontDataLookup[FrameIndex][YPixel * 2 + 0][XCharPos] = ABDYPP_FontDataLookup[FrameIndex][YPixel * 2 + 1][XCharPos] = YCurrent;
				YCurrent++;
			}

			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;
				XPos = (XPos + XShift) % DYPP_TOTALWIDTH;

				int SineY = ABDYPP_SineValues[XPos];
				int YOffset = SineY / 2 - MinY;

				for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
				{
					int XPos = CharIndex * 8 + XPixel;
					int YPos = YCurrentPos + YOffset;

					for (int YPixel = 0; YPixel < HALF_FONT_HEIGHT; YPixel++)
					{
						unsigned char FontByte = ABDYPP_DedupedFontData[CharIndex][YPixel * 2 + SubPixelY];
						unsigned char ColourIndex = (FontByte & (0x80 >> XPixel)) >> (7 - XPixel);
						DYPPEDFontImage.SetPixel(XPos, YPos, (ColourIndex == 0 ? 0x000000 : 0xffffff));

						ABDYPP_FontData[YPos][CharIndex] |= ColourIndex << (7 - XPixel);

						YPos++;
					}
				}
			}
			YCurrentPos += MaxY - MinY;
		}
	}

	DYPPEDFontImage.Write("Out\\6502\\Parts\\AllBorderDYPP\\DYPPedFont.png");

	int YEndPos = YCurrentPos;

	GPIMAGE DYPPEDDedupedFontImage(NumDedupedChars * 8 * 3, YEndPos);

	ZeroMemory(ABDYPP_DedupedFontLine, sizeof(ABDYPP_DedupedFontLine));

	int yDedupePos = 0;

	memset(ABDYPP_DedupedFontLineLookup, 0xff, sizeof(ABDYPP_DedupedFontLineLookup));

	unsigned char RGBGrey[3] = { 0x50, 0x50, 0x50 };

	for (int YPos = 0; YPos < YEndPos; YPos++)
	{
		int LineMatch = -1;
		for (int YPos2 = 0; YPos2 < yDedupePos; YPos2++)
		{
			bool bLineMatches = true;
			for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
			{
				unsigned char Byte0 = ABDYPP_FontData[YPos][CharIndex];
				unsigned char Byte1 = ABDYPP_DedupedFontLine[YPos2][CharIndex];
				if (Byte0 != Byte1)
				{
					bLineMatches = false;
					break;
				}
			}
			if (bLineMatches)
			{
				LineMatch = YPos2;
				break;
			}
		}
		bool bMatch = true;
		if (LineMatch == -1)
		{
			memcpy(ABDYPP_DedupedFontLine[yDedupePos], ABDYPP_FontData[YPos], NumDedupedChars);
			LineMatch = yDedupePos;
			bMatch = false;
		}
		ABDYPP_DedupedFontLineLookup[YPos] = LineMatch;

		for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
		{
			unsigned char ByteValue = ABDYPP_FontData[YPos][CharIndex];
			for (int XPixelPos = 0; XPixelPos < 8; XPixelPos ++)
			{
				int XPos = CharIndex * 8 + XPixelPos;
				int ColourIndex = (ByteValue & (0x80 >> XPixelPos)) >> (7 - XPixelPos);

				DYPPEDDedupedFontImage.SetPixel(XPos, YPos, (ColourIndex == 0 ? 0x000000 : 0xffffff));

				XPos += NumDedupedChars * 8;
				if (!bMatch)
				{
					DYPPEDDedupedFontImage.SetPixel(XPos, YPos, (ColourIndex == 0 ? 0x000000 : 0xffffff));
				}
				else
				{
					if (ColourIndex != 0)
					{
						DYPPEDDedupedFontImage.SetPixel(XPos, YPos, 0xbbbbbb);
					}
				}

				if (!bMatch)
				{
					XPos += NumDedupedChars * 8;
					DYPPEDDedupedFontImage.SetPixel(XPos, yDedupePos, (ColourIndex == 0 ? 0x000000 : 0xffffff));
				}
			}
		}

		if (!bMatch)
		{
			yDedupePos++;
		}
	}
	DYPPEDDedupedFontImage.Write("Out\\6502\\Parts\\AllBorderDYPP\\DYPPedDedupedFont.png");

	unsigned char PadValues[64];
	ZeroMemory(PadValues, sizeof(PadValues));

	int CurrentOffset = 0;
	unsigned char OutputFontBytes[65536];
	ZeroMemory(OutputFontBytes, sizeof(OutputFontBytes));


	CodeGen code(FontASMFilename);
	for (int YLine = 0; YLine < yDedupePos; YLine++)
	{
		int NextOffset = CurrentOffset + NumDedupedChars;

		int ThisPage = CurrentOffset / 256;
		int NextPage = (CurrentOffset + NumDedupedChars) / 256;

		int CurrentOffsetModded = CurrentOffset % 256;

		if ((CurrentOffsetModded != 0) && (ThisPage != NextPage))
		{
			int PadAmount = 256 - CurrentOffsetModded;
			CurrentOffset += PadAmount;
		}

		code.OutputCodeLine(NONE, fmt::format(".var FontDataDeduped_Line{:03d} = FontDataDeduped + ${:04x}", YLine, CurrentOffset));
		for (int Index = 0; Index < NumDedupedChars; Index++)
		{
			OutputFontBytes[CurrentOffset++] = ABDYPP_DedupedFontLine[YLine][Index];
		}
	}
	code.OutputCodeLine(NONE, fmt::format(".var FontDataDeduped_TotalLength = ${:04x}", CurrentOffset));
	WriteBinaryFile(FontBinFilename, OutputFontBytes, CurrentOffset);
}

int AllBorderDYPP_Main()
{
	AllBorderDYPP_CalcData();

	AllBorderDYPP_ProcessFontData("6502\\Parts\\AllBorderDYPP\\Data\\Ksubi-20px-Font.bmp", L"Out\\6502\\Parts\\AllBorderDYPP\\Font.bin", L"Out\\6502\\Parts\\AllBorderDYPP\\FontDefines.asm");

	AllBorderDYPP_CalcSpritePacking();

	AllBorderDYPP_OutputCode(L"Out\\6502\\Parts\\AllBorderDYPP\\MainIRQ.asm");

	unsigned char SpriteXPos[4][DYPP_TOTALWIDTH / 2];
	for (int Index = 0; Index < DYPP_TOTALWIDTH / 2; Index++)
	{
		int XPos = (Index * 2) - 48;
		if (XPos < 0)
		{
			XPos += 512 - 8;
		}
		SpriteXPos[0][Index] = SpriteXPos[1][Index] = (XPos & 255);
		SpriteXPos[2][Index] = SpriteXPos[3][Index] = (XPos >= 256) ? 1 : 0;
	}
	WriteBinaryFile(L"Out\\6502\\Parts\\AllBorderDYPP\\SpriteXVals.bin", SpriteXPos, sizeof(SpriteXPos));

	unsigned char ScrollText[4096];
	int ScrollTextLen = 0;
	for (int Index = 0; Index < sizeof(ABDYPP_MyScrollText); Index++)
	{
		unsigned char CurrentChar = ABDYPP_MyScrollText[Index];
		switch (CurrentChar)
		{
			case ' ':
			CurrentChar = 0;
			break;

			case '.':
			CurrentChar = 27;
			break;

			case '!':
			CurrentChar = 28;
			break;

			case '?':
			CurrentChar = 29;
			break;

			default:
			CurrentChar &= 31;
			break;
		}

		int StartChar = ABDYPP_FontLookups[CurrentChar][0];
		int NumChars = ABDYPP_FontLookups[CurrentChar][1];
		for (int ThisChar = StartChar; ThisChar < StartChar + NumChars; ThisChar++)
		{
			ScrollText[ScrollTextLen++] = ABDYPP_FontDedupeRemapping[ThisChar];
		}

	}
	ScrollText[ScrollTextLen++] = 255;
	ScrollText[ScrollTextLen++] = 255; //; Hack for Sparkle for now...
	ScrollText[ScrollTextLen++] = 255; //; Hack for Sparkle for now...
	WriteBinaryFile(L"Out\\6502\\Parts\\AllBorderDYPP\\ScrollText.bin", ScrollText, ScrollTextLen);

	return 0;
}
