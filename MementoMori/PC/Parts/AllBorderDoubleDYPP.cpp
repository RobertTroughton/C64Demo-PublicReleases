// (c) 2018-2020, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

constexpr auto DISABLE_SUBPIXEL = 0;

constexpr auto ABDDYPP_NUM_FRAMES = 2;

constexpr auto ABDDYPP_StartYPos = 29;

constexpr auto ABDDYPP_TOTALWIDTH = 432;
constexpr auto ABDDYPP_TOTALHEIGHT = 240;
constexpr auto ABDDYPP_TOTALCHARWIDTH = ABDDYPP_TOTALWIDTH / 8;
constexpr auto ABDDYPP_TOTALNUMSPRITESACROSS = ABDDYPP_TOTALCHARWIDTH / 3;

constexpr auto ABDDYPP_FONT_WIDTH = 512;
constexpr auto ABDDYPP_FONT_HEIGHT = 16;
constexpr auto ABDDYPP_HALF_FONT_HEIGHT = ABDDYPP_FONT_HEIGHT / 2;
constexpr auto ABDDYPP_FONT_CHAR_WIDTH = ABDDYPP_FONT_WIDTH / 8;

constexpr auto ABDDYPP_MAX_NUM_SPRITES_TO_USE = 4;

constexpr auto ABDDYPP_Bar_StartY = 73;
constexpr auto ABDDYPP_Bar_EndY = 237;
constexpr auto ABDDYPP_Bar_StartY_Rel = ABDDYPP_Bar_StartY - ABDDYPP_StartYPos;
constexpr auto ABDDYPP_Bar_EndY_Rel = ABDDYPP_Bar_EndY - ABDDYPP_StartYPos;

unsigned char RasterBarColours[165] =
{
	0x02, 0x02, 0x00, 0x00, 0x02, 0x04, 0x04, 0x00, 0x04, 0x04, 0x04, 0x0a, 0x04, 0x04, 0x04, 0x0a,
	0x0a, 0x04, 0x04, 0x0a, 0x0a, 0x0a, 0x04, 0x0a, 0x0a, 0x03, 0x0a, 0x0a, 0x0a, 0x03, 0x03, 0x0a,
	0x0a, 0x03, 0x03, 0x03, 0x0a, 0x03, 0x03, 0x03, 0x03, 0x03, 0x07, 0x03, 0x03, 0x03, 0x07, 0x07,
	0x03, 0x03, 0x07, 0x07, 0x07, 0x03, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x01, 0x07, 0x07, 0x07,
	0x01, 0x01, 0x07, 0x07, 0x01, 0x01, 0x01, 0x07, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x07, 0x01, 0x01, 0x01,
	0x07, 0x07, 0x01, 0x01, 0x07, 0x07, 0x07, 0x01, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x03, 0x07,
	0x07, 0x07, 0x03, 0x03, 0x07, 0x07, 0x03, 0x03, 0x03, 0x07, 0x03, 0x03, 0x03, 0x03, 0x03, 0x0a,
	0x03, 0x03, 0x03, 0x0a, 0x0a, 0x03, 0x03, 0x0a, 0x0a, 0x0a, 0x03, 0x0a, 0x0a, 0x04, 0x0a, 0x0a,
	0x0a, 0x04, 0x04, 0x0a, 0x0a, 0x04, 0x04, 0x04, 0x0a, 0x04, 0x04, 0x04, 0x00, 0x04, 0x04, 0x02,
	0x00, 0x00, 0x02, 0x02, 0x00
};


bool ABDDYPP_SpriteIsUsed[ABDDYPP_TOTALNUMSPRITESACROSS];

int ABDDYPP_MinMaxYValsPerChar[ABDDYPP_NUM_FRAMES][ABDDYPP_TOTALCHARWIDTH][2];
int ABDDYPP_SpriteColumnIndex_PerLine[ABDDYPP_NUM_FRAMES][ABDDYPP_TOTALHEIGHT][ABDDYPP_MAX_NUM_SPRITES_TO_USE];
int ABDDYPP_SpriteIndexPerXChar[ABDDYPP_NUM_FRAMES][ABDDYPP_TOTALCHARWIDTH];
unsigned char ABDDYPP_SineScreenMask[ABDDYPP_TOTALHEIGHT][ABDDYPP_TOTALCHARWIDTH];
int ABDDYPP_SpriteRemapping[ABDDYPP_NUM_FRAMES][9][ABDDYPP_MAX_NUM_SPRITES_TO_USE];
int ABDDYPP_SineValues[ABDDYPP_TOTALWIDTH];
unsigned char ABDDYPP_DedupedFontLine[2048][ABDDYPP_FONT_CHAR_WIDTH];
int ABDDYPP_DedupedFontLineLookup[2048];
int ABDDYPP_FontDataLookup[ABDDYPP_NUM_FRAMES][ABDDYPP_TOTALHEIGHT][ABDDYPP_TOTALCHARWIDTH];
int ABDDYPP_FontDedupeRemapping[ABDDYPP_FONT_CHAR_WIDTH];
int ABDDYPP_FontLookups[64][2];
unsigned char ABDDYPP_DestFontData[ABDDYPP_FONT_CHAR_WIDTH][ABDDYPP_FONT_HEIGHT];
unsigned char ABDDYPP_DedupedFontData[ABDDYPP_FONT_CHAR_WIDTH][ABDDYPP_FONT_HEIGHT];
unsigned char ABDDYPP_FontData[2048][ABDDYPP_FONT_CHAR_WIDTH];
unsigned char ABDDYPP_MyScrollText0[] = {
	"Now this is not the end. It is not even the beginning of the end. But it is...      perhaps...     the end of the beginning."
	"                                                         >"
};
unsigned char ABDDYPP_MyScrollText1[] = {
	"Now this is not the beginning. It is not even the end of the beginning. But it is... perhaps... the beginning of the end."
	"                                                                 >"
}; 

const int SpriteValsToUse[2][4] = {
	{0, 1, 2, 3},
	{7, 6, 5, 4},
};

const int SpriteColours[2][ABDDYPP_TOTALNUMSPRITESACROSS] = {
	{0x02, 0x06, 0x06, 0xff, 0xff, 0xff, 0x06, 0x06, 0x02, 0x04, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x04},
	{0x02, 0x09, 0x09, 0xff, 0xff, 0xff, 0x09, 0x09, 0x02, 0x08, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x08},
};

const int ABDDYPP_UsableSpriteVals[] =
{
	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
	0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
	0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
	0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe,
	0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
	0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde,
	0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
	0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe,
};
const int NumUsableSpriteVals = sizeof(ABDDYPP_UsableSpriteVals) / sizeof(ABDDYPP_UsableSpriteVals[0]);

void ABDDYPP_CalcData(void)
{
	GPIMAGE SineImage(ABDDYPP_TOTALWIDTH, ABDDYPP_TOTALHEIGHT);

	ZeroMemory(ABDDYPP_SineScreenMask, sizeof(ABDDYPP_SineScreenMask));

	for (int XPos = 0; XPos < ABDDYPP_TOTALWIDTH; XPos++)
	{
		static const int MaxYValue = ABDDYPP_TOTALHEIGHT - ABDDYPP_FONT_HEIGHT;
		double angle = (2.0 * PI * XPos) / ABDDYPP_TOTALWIDTH + (1.5 * PI);
		double SinValue = (sin(angle) + 1.0) * 0.5;
		double YValue = SinValue * (double)(MaxYValue) + 1.0;
		unsigned int iYPos = (unsigned int)floor(YValue);

		if (DISABLE_SUBPIXEL)
		{
			iYPos &= 0xfffffffe;
		}

		iYPos = min(iYPos, MaxYValue);
		ABDDYPP_SineValues[XPos] = iYPos;

		unsigned int iYPos2 = iYPos + ABDDYPP_FONT_HEIGHT;

		if (XPos < ABDDYPP_TOTALWIDTH / 2)
		{
			if ((iYPos < ABDDYPP_Bar_StartY_Rel) && (iYPos2 > ABDDYPP_Bar_StartY_Rel))
			{
				iYPos2 = ABDDYPP_Bar_StartY_Rel;
			}
			else if ((iYPos >= ABDDYPP_Bar_StartY_Rel) && (iYPos2 < ABDDYPP_Bar_EndY_Rel))
			{
				// full clip - so ensure nothing is drawn
				iYPos2 = 0;
				iYPos = 1;
			}
			else if ((iYPos < ABDDYPP_Bar_EndY_Rel) && (iYPos2 >= ABDDYPP_Bar_EndY_Rel))
			{
				iYPos = ABDDYPP_Bar_EndY_Rel;
			}
		}

		if (iYPos2 > iYPos)
		{
			SineImage.FillRectangle(XPos, iYPos, XPos + 1, iYPos2, 0xbbbbbb);
		}

		for (unsigned int iYSet = iYPos; iYSet < iYPos2; iYSet++)
		{
			int XPixelPos = XPos % 8;
			int XCharPos = XPos / 8;
			ABDDYPP_SineScreenMask[iYSet][XCharPos] |= (3 << (6 - XPixelPos));
		}
	}
	SineImage.Write("Out\\6502\\Parts\\AllBorderDoubleDYPP\\Sine.png");

	GPIMAGE SpriteSineImage(ABDDYPP_TOTALWIDTH * 2, ABDDYPP_TOTALHEIGHT);

	bool bSetStartLine = true;
	for (int YPos = 0; YPos < ABDDYPP_TOTALHEIGHT; YPos += 8)
	{
		bool bSet = bSetStartLine;
		for (int XPos = 0; XPos < ABDDYPP_TOTALWIDTH * 2; XPos += 8)
		{
			if (bSet)
			{
//;				SpriteSineImage.FillRectangle(XPos, YPos, XPos + 8, YPos + 8, --11);
			}
			bSet = !bSet;
		}
		bSetStartLine = !bSetStartLine;
	}

	memset(ABDDYPP_SpriteColumnIndex_PerLine, 0xff, sizeof(ABDDYPP_SpriteColumnIndex_PerLine));
	memset(ABDDYPP_SpriteIndexPerXChar, 0xff, sizeof(ABDDYPP_SpriteIndexPerXChar));

	for (int FrameIndex = 0; FrameIndex < 2; FrameIndex++)
	{
		int XShift = FrameIndex * 4;
		for (int XSpriteIndex = 0; XSpriteIndex < ABDDYPP_TOTALNUMSPRITESACROSS; XSpriteIndex++)
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
					XPos = (XPos + XShift) % ABDDYPP_TOTALWIDTH;
					for (int YPos = 0; YPos < ABDDYPP_TOTALHEIGHT; YPos++)
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
			if (SpriteMinY < SpriteMaxY)
			{
				int StartSpriteIndex = (XSpriteIndex < (ABDDYPP_TOTALNUMSPRITESACROSS / 2)) ? 0 : 2;
				for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					int SpriteIndexOffsetted = (SpriteIndex + StartSpriteIndex) % ABDDYPP_MAX_NUM_SPRITES_TO_USE;

					SpriteToUse = SpriteIndexOffsetted;
					for (int YPos = SpriteMinY; YPos < SpriteMaxY; YPos++)
					{
						if (ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][YPos][SpriteIndexOffsetted] != -1)
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
			}

			ABDDYPP_SpriteIsUsed[XSpriteIndex] = (SpriteToUse != -1);
			if (SpriteToUse != -1)
			{
				for (int YPos = SpriteMinY; YPos < SpriteMaxY; YPos++)
				{
					ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][YPos][SpriteToUse] = XSpriteIndex;
					ABDDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 0] = ABDDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 1] = ABDDYPP_SpriteIndexPerXChar[FrameIndex][XSpriteIndex * 3 + 2] = SpriteToUse;
				}
			}

			int XPos0 = XSpriteIndex * 24 + FrameIndex * ABDDYPP_TOTALWIDTH;
			int XPos1 = XPos0 + 24;
			int OutputColourIndex;
			if (SpriteToUse >= 0)
			{
				OutputColourIndex = SpriteValsToUse[FrameIndex][SpriteToUse];
			}
			else
			{
				OutputColourIndex = 9;
			}
//;			SpriteSineImage.FillRectangle(XPos0, SpriteMinY, XPos1, SpriteMaxY + 1, --GetC64ColourRGB(OutputColourIndex));
		}
	}

	for (int FrameIndex = 0; FrameIndex < 2; FrameIndex++)
	{
		for (int YPos = 0; YPos < ABDDYPP_TOTALHEIGHT; YPos++)
		{
			for (int XPixel = 0; XPixel < ABDDYPP_TOTALWIDTH; XPixel++)
			{
				int XPos = (FrameIndex * 4 + XPixel) % ABDDYPP_TOTALWIDTH;
				unsigned int SineColour = SineImage.GetPixel(XPos, YPos);
				if (SineColour != 0x000000)
				{
					int SpriteXPos = FrameIndex * ABDDYPP_TOTALWIDTH + XPixel;
					unsigned int Colour = SpriteSineImage.GetPixel(SpriteXPos, YPos);
					if (Colour != 0xffffff)
					{
//;						SpriteSineImage.SetPixel(SpriteXPos, YPos, Colour);
					}
				}
			}
		}
	}

	SpriteSineImage.Write("Out\\6502\\Parts\\AllBorderDoubleDYPP\\SineSprites.png");
}

bool ABDDYPP_InsertSpriteBlitCode(CodeGen& code, int& NumCyclesToUse, bool bFirstPass, int FrameIndex)
{
	int ALineLoaded = -1;

	static bool CODE_bNewXCharPos = false;

	static int CODE_XCharPos = 0;
	static int CODE_MinY[2] = {0, 0};
	static int CODE_MaxY[2] = {0, 0};
	static int CODE_YPos[2] = {0, 0};
	static int ScrollerIndex = 0;
	static int CurrentlyLoadedX = -1;
	static int XToUse = -1;

	static bool bFinishedEverything = false;

	if (bFirstPass)
	{
		CODE_bNewXCharPos = true;
		CODE_XCharPos = 0;
		ScrollerIndex = 0;
		CurrentlyLoadedX = -1;
		bFinishedEverything = false;
	}

	if (bFinishedEverything)
	{
		return true;
	}

	while (!bFinishedEverything)
	{
		int XCharPos = CODE_XCharPos;
		XCharPos += (ABDDYPP_TOTALCHARWIDTH / 2) * ScrollerIndex;
		XCharPos %= ABDDYPP_TOTALCHARWIDTH;

		if (CODE_bNewXCharPos)
		{
			if (EnoughFreeCycles(NumCyclesToUse, 3))
			{
				CODE_MinY[ScrollerIndex] = ABDDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][0] / 2;
				CODE_MaxY[ScrollerIndex] = ABDDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][1] / 2;
				CODE_YPos[ScrollerIndex] = CODE_MinY[ScrollerIndex];

				XToUse = CODE_XCharPos;

				CODE_bNewXCharPos = false;
			}
			else
			{
				return false;
			}
		}

		if (!CODE_bNewXCharPos)
		{
			while (CODE_YPos[ScrollerIndex] < CODE_MaxY[ScrollerIndex])
			{
				static int PartOfPlot = 0;

				bool bDraw = false;

				int ReadLineA = ABDDYPP_DedupedFontLineLookup[ABDDYPP_FontDataLookup[FrameIndex][CODE_YPos[ScrollerIndex] * 2][XCharPos]];
				int SpriteYPosA = CODE_YPos[ScrollerIndex];
				int SpriteIndexA = ABDDYPP_SpriteIndexPerXChar[FrameIndex][XCharPos];
				int SpriteVal = -1;
				int SpriteLine = -1;
				if (SpriteIndexA >= 0)
				{
					int SpriteYIndex = min(8, max(0, SpriteYPosA) / 16);
					SpriteVal = ABDDYPP_SpriteRemapping[FrameIndex][SpriteYIndex][SpriteIndexA] + ScrollerIndex * 64;
					SpriteLine = ((SpriteYPosA + 1) % 21);

					if (XCharPos >= ((2 * ABDDYPP_TOTALCHARWIDTH) / 4))
					{
						bDraw = true;
					}
					if ((SpriteYPosA < (ABDDYPP_Bar_StartY_Rel / 2 - 1)) || (SpriteYPosA >= (ABDDYPP_Bar_EndY_Rel / 2 + 1)))
					{
						bDraw = true;
					}
				}

				if (bDraw)
				{
					if (PartOfPlot == 0)
					{
						if (CurrentlyLoadedX != XToUse)
						{
							if (EnoughFreeCycles(NumCyclesToUse, 3))
							{
								SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDX_ZP, fmt::format("ZP_ScrollText{:d} + {:d}", ScrollerIndex, CODE_XCharPos)));
								CurrentlyLoadedX = XToUse;
							}
							else
							{
								return false;
							}
						}
						PartOfPlot++;
					}
					if (PartOfPlot == 1)
					{
						if (ALineLoaded != ReadLineA)
						{
							if (EnoughFreeCycles(NumCyclesToUse, 4))
							{
								SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("FontDataDeduped_Line{:03d}", ReadLineA)));
								ALineLoaded = ReadLineA;
								PartOfPlot++;
							}
							else
							{
								return false;
							}
						}
						else
						{
							PartOfPlot++; //; Skip this part as it's not needed
						}
					}
					if (PartOfPlot == 2)
					{
						if (EnoughFreeCycles(NumCyclesToUse, 4))
						{
							SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("Base_BankAddress0 + (${:02x} * 64) + ({:d} * 3) + {:d}", ABDDYPP_UsableSpriteVals[SpriteVal], SpriteLine, XCharPos % 3)));
							PartOfPlot = 0;
							CODE_YPos[ScrollerIndex]++;
						}
						else
						{
							return false;
						}
					}
				}
				else
				{
					PartOfPlot = 0;
					CODE_YPos[ScrollerIndex]++;
				}
			}
			if (CODE_YPos[ScrollerIndex] == CODE_MaxY[ScrollerIndex])
			{
				CODE_XCharPos++;
				if (CODE_XCharPos == ABDDYPP_TOTALCHARWIDTH)
				{
					CODE_XCharPos = 0;
					CurrentlyLoadedX = -1;
					ScrollerIndex++;

					if (ScrollerIndex == 2)
					{
						bFinishedEverything = true;
						return true;
					}
				}
				CODE_bNewXCharPos = true;
			}
		}
	}

	return false;
}

int ABDDYPP_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass, int FrameIndex)
{
	static bool bFinishedSpriteBlitCode = false;
	if (bFirstPass)
	{
		bFinishedSpriteBlitCode = false;
	}
	if (!bFinishedSpriteBlitCode)
	{
		bFinishedSpriteBlitCode = ABDDYPP_InsertSpriteBlitCode(code, NumCycles, bFirstPass, 1 - FrameIndex);
	}
	return code.WasteCycles(NumCycles);
}

void ABDDYPP_OutputCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	int SpriteColourCount = 0;
	unsigned char SpriteColoursToSet[256];

	for (int FrameIndex = 0; FrameIndex < ABDDYPP_NUM_FRAMES; FrameIndex++)
	{
		unsigned char LastScreenColour = 0xff;

		int TotalWastedCycles = 0;

		ABDDYPP_UseCycles(code, 0, true, FrameIndex);

		int MSB_SpriteColumnIndices_RasterLine[32];
		int MSB_SpriteColumnIndices[32][8];
		int NumMSBVals = 0;
		int CurrentSpriteColumnIndex[8] = { -1, -1, -1, -1, -1, -1, -1, -1 };
		int CurrentSpriteYVal[8];

		// Initial Sprite Values -------------------------------------------------------------------------------------------------------------
		code.OutputFunctionLine(fmt::format("SetInitialSpriteValues_Frame{:d}", FrameIndex));

		// Initial Y
		code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", ABDDYPP_StartYPos));
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			CurrentSpriteYVal[SpriteIndex] = ABDDYPP_StartYPos;
			code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
		}
		code.OutputBlankLine();

		for (int ScrollerIndex = 0; ScrollerIndex < 2; ScrollerIndex++)
		{
			for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
			{
				int OutputSpriteIndex = SpriteValsToUse[ScrollerIndex][SpriteIndex];

				int SpriteColumnIndex = -1;

				for (int NextUpdateLine = 0; NextUpdateLine < ABDDYPP_TOTALHEIGHT; NextUpdateLine++)
				{
					SpriteColumnIndex = ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][NextUpdateLine][SpriteIndex];
					if (SpriteColumnIndex != -1)
					{
						break;
					}
				}

				// Initial X
				code.OutputFunctionLine(fmt::format("ABDDYPP_SpriteX{:d}_Scroller{:d}_Frame{:d}", SpriteColumnIndex, ScrollerIndex, FrameIndex));
				code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}X", OutputSpriteIndex));
				CurrentSpriteColumnIndex[OutputSpriteIndex] = SpriteColumnIndex;
				code.OutputBlankLine();

				// Initial SpriteVals
				int SpriteVal = ABDDYPP_SpriteRemapping[FrameIndex][0][SpriteIndex];
				if (SpriteVal != -1)
				{
					code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", ABDDYPP_UsableSpriteVals[SpriteVal + ScrollerIndex * 64]));
					code.OutputCodeLine(STY_ABS, fmt::format("SpriteVals0 + {:d}", OutputSpriteIndex));
					code.OutputBlankLine();
				}

				// Initial Colours
				unsigned char ColourToSet = SpriteColours[ScrollerIndex][SpriteColumnIndex];
				SpriteColoursToSet[SpriteColourCount] = ColourToSet;
				code.OutputFunctionLine(fmt::format("SpriteColours_{:d}", SpriteColourCount));
				SpriteColourCount++;

				code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}Colour", OutputSpriteIndex));
				code.OutputBlankLine();
			}
		}

		code.OutputFunctionLine(fmt::format("ABDDYPP_MSB_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_Frame{:d}",
			CurrentSpriteColumnIndex[0],
			CurrentSpriteColumnIndex[1],
			CurrentSpriteColumnIndex[2],
			CurrentSpriteColumnIndex[3],
			CurrentSpriteColumnIndex[4],
			CurrentSpriteColumnIndex[5],
			CurrentSpriteColumnIndex[6],
			CurrentSpriteColumnIndex[7],
			FrameIndex));
		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));
		code.OutputBlankLine();

		MSB_SpriteColumnIndices_RasterLine[NumMSBVals] = 0;
		memcpy(MSB_SpriteColumnIndices[NumMSBVals++], CurrentSpriteColumnIndex, sizeof(CurrentSpriteColumnIndex));

		int CurrentD018 = 0;
		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentD018));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		CurrentD018 ^= 1;
		code.OutputBlankLine();

		code.OutputCodeLine(LDY_IMM, fmt::format("#$ff"));
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_SpriteEnable"));

		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
		// Initial Sprite Values -------------------------------------------------------------------------------------------------------------

		code.OutputFunctionLine(fmt::format("IRQ_Main_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(CALLMACRO, fmt::format("IRQManager_BeginIRQ(1, 0)"));
		code.OutputBlankLine();

		ABDDYPP_UseCycles(code, 40, false, FrameIndex);

		code.OutputCodeLine(DEC_ABS, fmt::format("VIC_D016"));
		code.OutputCodeLine(INC_ABS, fmt::format("VIC_D016"));
		code.OutputBlankLine();

		int UpdateSpriteValIndex = -1;
		bool bXMSBIsDirty = false;
		int SubtractCyclesFromNextLine = 0;

		for (int YLine = 0; YLine < ABDDYPP_TOTALHEIGHT; YLine++)
		{
			int RasterLine = YLine + ABDDYPP_StartYPos + 1;

			code.OutputCommentLine(fmt::format("//; Line ${:02x}", RasterLine));

			int NumCyclesToUse = 40 - SubtractCyclesFromNextLine;
			SubtractCyclesFromNextLine = 0;

			int RasterLineMod8 = RasterLine % 8;
			int YLineMod32 = YLine % 32;

			if ((RasterLine < 71) || (RasterLine > 238))
			{
				NumCyclesToUse -= 6;
			}

			if ((RasterLine > ABDDYPP_StartYPos) && (YLineMod32 == 3))
			{
				UpdateSpriteValIndex = 0;
			}

			if (RasterLine == 249)
			{
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#D011_Value_24Rows")));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_D011")));
				code.OutputBlankLine();
			}
			if (RasterLine == 256)
			{
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#D011_Value_25Rows")));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_D011")));
				code.OutputBlankLine();
			}

			if ((YLine > 0) && (YLineMod32 == 0))
			{
				if (EnoughFreeCycles(NumCyclesToUse, 6))
				{
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#D018Value{:d}", CurrentD018)));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_D018")));
					CurrentD018 ^= 1;
				}
			}

			unsigned char ColourToChangeScreenTo = 0xff;
			if ((RasterLine >= ABDDYPP_Bar_StartY) && (RasterLine <= ABDDYPP_Bar_EndY))
			{
				ColourToChangeScreenTo = RasterBarColours[RasterLine - ABDDYPP_Bar_StartY];
				if (ColourToChangeScreenTo != 0xff)
				{
					SubtractCyclesFromNextLine = 6;
				}
			}

			bool bYLoaded = false;
			for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
			{
				int CurrYVal = CurrentSpriteYVal[SpriteIndex];
				int NextYVal = CurrYVal + 42;
				if (RasterLine > CurrYVal)
				{
					if ((NextYVal >= (ABDDYPP_Bar_StartY - 2)) && (NextYVal < (ABDDYPP_Bar_EndY + 2)) && ((SpriteIndex < 2) || (SpriteIndex >= 6)))
					{
						CurrentSpriteYVal[SpriteIndex] = NextYVal;
						continue;
					}
					if (!bYLoaded)
					{
						if (EnoughFreeCycles(NumCyclesToUse, 2))
						{
							SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", NextYVal & 255)));
							bYLoaded = true;
						}
					}
					if (bYLoaded)
					{
						if (EnoughFreeCycles(NumCyclesToUse, 4))
						{
							SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex)));
							CurrentSpriteYVal[SpriteIndex] = NextYVal;
						}
					}
				}
			}

			bool bUpdatedXMSB = false;
			for (int ScrollerIndex = 0; ScrollerIndex < 2; ScrollerIndex++)
			{
				for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					int OutputSpriteIndex = SpriteValsToUse[ScrollerIndex][SpriteIndex];
					int StartYLine = max(0, YLine - 2);
					int EndYLine = min(YLine + 24, ABDDYPP_TOTALHEIGHT);

					if (ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][StartYLine][SpriteIndex] != CurrentSpriteColumnIndex[OutputSpriteIndex])
					{
						int NextSpriteColumnIndex = -1;
						for (int NextUpdateLine = StartYLine; NextUpdateLine < EndYLine; NextUpdateLine++)
						{
							NextSpriteColumnIndex = ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][NextUpdateLine][SpriteIndex];
							if (NextSpriteColumnIndex != -1)
							{
								break;
							}
						}
						if (NextSpriteColumnIndex != -1)
						{
							if (NextSpriteColumnIndex != CurrentSpriteColumnIndex[OutputSpriteIndex])
							{
								if (EnoughFreeCycles(NumCyclesToUse, 12))
								{
									code.OutputFunctionLine(fmt::format("ABDDYPP_SpriteX{:d}_Scroller{:d}_Frame{:d}", NextSpriteColumnIndex, ScrollerIndex, FrameIndex));
									SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#$00")));
									SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}X", OutputSpriteIndex)));
									code.OutputBlankLine();

									int ColourToSet = SpriteColours[ScrollerIndex][NextSpriteColumnIndex];
									if (ColourToSet != 0xff)
									{
										SpriteColoursToSet[SpriteColourCount] = ColourToSet;
										code.OutputFunctionLine(fmt::format("SpriteColours_{:d}", SpriteColourCount));
										SpriteColourCount++;

										SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#$00")));
										SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}Colour", OutputSpriteIndex)));
										code.OutputBlankLine();
									}

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
					code.OutputFunctionLine(fmt::format("ABDDYPP_MSB_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_Frame{:d}",
						CurrentSpriteColumnIndex[0],
						CurrentSpriteColumnIndex[1],
						CurrentSpriteColumnIndex[2],
						CurrentSpriteColumnIndex[3],
						CurrentSpriteColumnIndex[4],
						CurrentSpriteColumnIndex[5],
						CurrentSpriteColumnIndex[6],
						CurrentSpriteColumnIndex[7],
						FrameIndex));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#$00")));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("VIC_SpriteXMSB")));
					MSB_SpriteColumnIndices_RasterLine[NumMSBVals] = RasterLine;
					memcpy(MSB_SpriteColumnIndices[NumMSBVals++], CurrentSpriteColumnIndex, sizeof(CurrentSpriteColumnIndex));
					bXMSBIsDirty = false;
				}
			}

			while ((UpdateSpriteValIndex != -1) && (EnoughFreeCycles(NumCyclesToUse, 12)))
			{
				int LineVal = YLine / 32 + 1;
				int SpriteVal = ABDDYPP_SpriteRemapping[FrameIndex][LineVal][UpdateSpriteValIndex];
				if (SpriteVal != -1)
				{
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", ABDDYPP_UsableSpriteVals[SpriteVal + 0])));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("SpriteVals{:d} + {:d}", CurrentD018, SpriteValsToUse[0][UpdateSpriteValIndex])));

					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", ABDDYPP_UsableSpriteVals[SpriteVal + 64])));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STY_ABS, fmt::format("SpriteVals{:d} + {:d}", CurrentD018, SpriteValsToUse[1][UpdateSpriteValIndex])));
				}
				UpdateSpriteValIndex++;
				if (UpdateSpriteValIndex == ABDDYPP_MAX_NUM_SPRITES_TO_USE)
				{
					UpdateSpriteValIndex = -1;
				}
			}

			TotalWastedCycles += ABDDYPP_UseCycles(code, NumCyclesToUse, false, FrameIndex);

			code.OutputCodeLine(DEC_ABS, fmt::format("VIC_D016"));
			if (ColourToChangeScreenTo != 0xff)
			{
				code.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", ColourToChangeScreenTo));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_ScreenColour"));
				LastScreenColour = ColourToChangeScreenTo;
			}
			code.OutputCodeLine(INC_ABS, fmt::format("VIC_D016"));

			code.OutputBlankLine();
		}
		code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_SpriteEnable"));

		code.OutputCodeLine(LDY_IMM, fmt::format("#ABDDYPP_BackgroundColour"));
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			code.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite{:d}Colour", SpriteIndex));
		}

		ABDDYPP_UseCycles(code, -1, false, FrameIndex);
		code.OutputBlankLine();

		code.OutputCodeLine(JSR_ABS, fmt::format("BASECODE_PlayMusic"));
		code.OutputBlankLine();

		code.OutputFunctionLine(fmt::format("UpdateSpriteXVals_Frame{:d}", FrameIndex));
		code.OutputCodeLine(LDA_ZP, fmt::format("ZP_SpriteXPos"));
		if (FrameIndex != 0)
		{
			code.OutputCodeLine(CLC);
			code.OutputCodeLine(ADC_IMM, fmt::format("#$03"));
			code.OutputCodeLine(CMP_IMM, fmt::format("#${:02x}", ABDDYPP_TOTALWIDTH / 2));
			code.OutputCodeLine(BCC, fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
			code.OutputCodeLine(SEC);
			code.OutputCodeLine(SBC_IMM, fmt::format("#${:02x}", ABDDYPP_TOTALWIDTH / 2));
		}
		else
		{
			code.OutputCodeLine(SEC);
			code.OutputCodeLine(SBC_IMM, fmt::format("#$01"));
			code.OutputCodeLine(BCS, fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
			code.OutputCodeLine(CLC);
			code.OutputCodeLine(ADC_IMM, fmt::format("#${:02x}", ABDDYPP_TOTALWIDTH / 2));
		}
		code.OutputFunctionLine(fmt::format("NotTheEndOfTheSine_Frame{:d}", FrameIndex));
		code.OutputCodeLine(STA_ZP, fmt::format("ZP_SpriteXPos"));
		code.OutputCodeLine(TAX);

		code.OutputBlankLine();

		for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_TOTALNUMSPRITESACROSS; SpriteIndex++)
		{
			int SpriteIndex2 = (SpriteIndex + 9) % ABDDYPP_TOTALNUMSPRITESACROSS;

			bool bSpriteUsed = ABDDYPP_SpriteIsUsed[SpriteIndex];
			bool bSprite2Used = ABDDYPP_SpriteIsUsed[SpriteIndex2];
			if ((!bSpriteUsed) && (!bSprite2Used))
			{
				continue;
			}

			int XValLookupIndex = (SpriteIndex * ((ABDDYPP_TOTALWIDTH / 2) / ABDDYPP_TOTALNUMSPRITESACROSS)) % (ABDDYPP_TOTALWIDTH / 2);
			code.OutputCodeLine(LDA_ABX, fmt::format("SpriteXValsMem + {:d}", XValLookupIndex));

			if (bSpriteUsed)
			{
				code.OutputCodeLine(STA_ABS, fmt::format("ABDDYPP_SpriteX{:d}_Scroller0_Frame{:d} + 1", SpriteIndex, FrameIndex));
			}
			if (bSprite2Used)
			{
				code.OutputCodeLine(STA_ABS, fmt::format("ABDDYPP_SpriteX{:d}_Scroller1_Frame{:d} + 1", SpriteIndex2, FrameIndex));
			}
		}
		code.OutputBlankLine();

		int CurrentMSBColumnIndices[8] = { INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX, INT_MAX };
		code.OutputCodeLine(LDA_ABS, fmt::format("#$00"));
		code.OutputBlankLine();
		for (int MSBIndex = 0; MSBIndex < NumMSBVals; MSBIndex++)
		{
			unsigned char MSBMask = 0xff;

			if (MSBIndex != 0)
			{
				for (int ScrollerIndex = 0; ScrollerIndex < 2; ScrollerIndex++)
				{
					for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
					{
						int SpriteIndexToUse = SpriteValsToUse[ScrollerIndex][SpriteIndex];
						if (MSB_SpriteColumnIndices[MSBIndex][SpriteIndexToUse] != CurrentMSBColumnIndices[SpriteIndexToUse])
						{
							MSBMask ^= (0x01 << SpriteIndexToUse);
						}
					}
				}

				int RasterLine = MSB_SpriteColumnIndices_RasterLine[MSBIndex];
				/*				if ((RasterLine >= (ABDDYPP_Bar_StartY + 8)) && (RasterLine < (ABDDYPP_Bar_EndY - 8)))
								{
									MSBMask &= 0x3c;
								}*/

				code.OutputCodeLine(AND_IMM, fmt::format("#${:02x}", MSBMask));
			}

			code.OutputCodeLine(LDX_ZP, fmt::format("ZP_SpriteXPos"));
			for (int ScrollerIndex = 0; ScrollerIndex < 2; ScrollerIndex++)
			{
				for (int SpriteIndex = 0; SpriteIndex < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteIndex++)
				{
					int SpriteIndexToUse = SpriteValsToUse[ScrollerIndex][SpriteIndex];

					int NewSpriteColumnIndex = MSB_SpriteColumnIndices[MSBIndex][SpriteIndexToUse];
					if (NewSpriteColumnIndex != CurrentMSBColumnIndices[SpriteIndexToUse])
					{
						int XValLookupIndex = NewSpriteColumnIndex * ((ABDDYPP_TOTALWIDTH / 2) / ABDDYPP_TOTALNUMSPRITESACROSS);
						XValLookupIndex += (ABDDYPP_TOTALWIDTH / 4) * ScrollerIndex;
						XValLookupIndex %= (ABDDYPP_TOTALWIDTH / 2);

						code.OutputCodeLine(LDY_ABX, fmt::format("SpriteXValsMem + {:d} + {:d}", ABDDYPP_TOTALWIDTH, XValLookupIndex));
						code.OutputCodeLine(ORA_ABY, fmt::format("Sprite{:d}MSBVals", SpriteIndexToUse));
						CurrentMSBColumnIndices[SpriteIndexToUse] = NewSpriteColumnIndex;
					}
				}
			}
			code.OutputCodeLine(STA_ABS, fmt::format("ABDDYPP_MSB_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_{:x}_Frame{:d} + 1",
				CurrentMSBColumnIndices[0],
				CurrentMSBColumnIndices[1],
				CurrentMSBColumnIndices[2],
				CurrentMSBColumnIndices[3],
				CurrentMSBColumnIndices[4],
				CurrentMSBColumnIndices[5],
				CurrentMSBColumnIndices[6],
				CurrentMSBColumnIndices[7],
				FrameIndex));
		}
		code.OutputBlankLine();

		code.OutputCodeLine(INC_ABS, fmt::format("FrameOf256"));
		code.OutputCodeLine(BNE, fmt::format("Not256_Frame{:d}", FrameIndex));
		code.OutputCodeLine(INC_ABS, fmt::format("Frame_256Counter"));
		code.OutputFunctionLine(fmt::format("Not256_Frame{:d}", FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(JSR_ABS, fmt::format("SetInitialSpriteValues_Frame{:d}", 1 - FrameIndex));
		code.OutputBlankLine();

		code.OutputCodeLine(LDA_IMM, fmt::format("#<IRQ_Main_Frame{:d}", 1 - FrameIndex));
		code.OutputCodeLine(STA_ZP, fmt::format("ZP_IRQJump + 1"));
		code.OutputCodeLine(LDA_IMM, fmt::format("#>IRQ_Main_Frame{:d}", 1 - FrameIndex));
		code.OutputCodeLine(STA_ZP, fmt::format("ZP_IRQJump + 2"));
		code.OutputBlankLine();

		code.OutputCodeLine(LDA_ABS, fmt::format("FrameOf256"));
		code.OutputCodeLine(AND_IMM, fmt::format("#$01"));
		code.OutputCodeLine(BNE, fmt::format("DontScrollScrollText_Frame{:d}", FrameIndex));
		code.OutputCodeLine(JMP_ABS, fmt::format("ScrollScrollText"));
		code.OutputFunctionLine(fmt::format("DontScrollScrollText_Frame{:d}", FrameIndex));
		code.OutputCodeLine(JMP_ABS, fmt::format("MainIRQHasFinished"));
		code.OutputBlankLine();

		if (FrameIndex == 1)
		{
			code.OutputFunctionLine(fmt::format("SetSpriteColours"));
			for (int Index = 0; Index < SpriteColourCount; Index++)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteColoursToSet[Index]));
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteColours_{:d} + 1", Index));
			}
			code.OutputCodeLine(RTS);
			code.OutputBlankLine();

			code.OutputFunctionLine(fmt::format("BlackenAllSprites"));
			code.OutputCodeLine(LDA_IMM, fmt::format("#ABDDYPP_BackgroundColour"));
			for (int Index = 0; Index < SpriteColourCount; Index++)
			{
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteColours_{:d} + 1", Index));
			}
			code.OutputCodeLine(RTS);
			code.OutputBlankLine();
		}
	}
}

void ABDDYPP_CalcSpritePacking(void)
{
	unsigned char ABDDYPP_TestSpriteData[ABDDYPP_MAX_NUM_SPRITES_TO_USE][9][64];

	ZeroMemory(ABDDYPP_TestSpriteData, sizeof(ABDDYPP_TestSpriteData));

	int NumPackedSprites = 0;

	for (int FrameIndex = 0; FrameIndex < ABDDYPP_NUM_FRAMES; FrameIndex++)
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

					for (int SpriteColumn = 0; SpriteColumn < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteColumn++)
					{
						int ActualY = SpriteIndex * 32 + YVal * 2;
						if (ActualY < ABDDYPP_TOTALHEIGHT)
						{
							int SpriteX = ABDDYPP_SpriteColumnIndex_PerLine[FrameIndex][ActualY][SpriteColumn];
							unsigned char OutputMask = 0x00;
							if (SpriteX >= 0)
							{
								int XMaskLookup = (SpriteX * 3) + XByte;
								OutputMask = ABDDYPP_SineScreenMask[ActualY][XMaskLookup];
							}
							ABDDYPP_TestSpriteData[SpriteColumn][SpriteIndex][OutputOffset] = (OutputByte & OutputMask);// | (0xff - OutputMask);
						}
					}
				}
			}
		}

		for (int SpriteIndex = 0; SpriteIndex < 9; SpriteIndex++)
		{
			for (int SpriteColumn = 0; SpriteColumn < ABDDYPP_MAX_NUM_SPRITES_TO_USE; SpriteColumn++)
			{
				ABDDYPP_SpriteRemapping[FrameIndex][SpriteIndex][SpriteColumn] = -1;

				bool bEmpty = true;
				for (int ByteIndex = 0; ByteIndex < 63; ByteIndex++)
				{
					if (ABDDYPP_TestSpriteData[SpriteColumn][SpriteIndex][ByteIndex])
					{
						bEmpty = false;
						break;
					}
				}

				if (!bEmpty)
				{
					ABDDYPP_SpriteRemapping[FrameIndex][SpriteIndex][SpriteColumn] = NumPackedSprites;
					NumPackedSprites++;
				}
			}
		}
	}
}

void ABDDYPP_Font_DetermineUsedChars(unsigned char* pScrollText, unsigned char* UsedChars, int NumUsedChars)
{
	int CharIndex = 0;
	bool bFinished = false;
	while (!bFinished)
	{
		unsigned char CurrentChar = *pScrollText;
		switch (CurrentChar)
		{
		case '>':
			CurrentChar = 0xff;
			break;

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

		case '-':
			CurrentChar = 30;
			break;

		default:
			CurrentChar &= 31;
			break;
		}

		pScrollText[0] = CurrentChar;

		if (CurrentChar == 0xff)
		{
			bFinished = true;
		}
		else if (CurrentChar < NumUsedChars)
		{
			UsedChars[CurrentChar] = 1;
		}

		pScrollText++;
	}
}

void ABDDYPP_ProcessFontData(char* FontFilename, unsigned char* UsedChars, LPTSTR FontASMFilename)
{
	GPIMAGE SrcImg(FontFilename);

	int NumChars = 0;
	int WidthChar = 1;
	bool bNewChar = true;
	for (int XChar = 0; XChar < ABDDYPP_FONT_CHAR_WIDTH; XChar++)
	{
		if (bNewChar)
		{
			ABDDYPP_FontLookups[NumChars][0] = XChar;
			WidthChar = 1;
			bNewChar = false;
		}
		int XPos = XChar * 8 + 7;

		bool bLastChar = true;
		for (int YPixel = 0; YPixel < ABDDYPP_FONT_HEIGHT; YPixel++)
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
			if (!UsedChars[NumChars])
			{
				//; we're not using this char - so let's blank it out of the font...
				int X0 = ABDDYPP_FontLookups[NumChars][0] * 8;
				int X1 = (ABDDYPP_FontLookups[NumChars][0] + WidthChar) * 8;
				SrcImg.FillRectangle(X0, 0, X1, ABDDYPP_FONT_HEIGHT, 0x000000);
			}
			ABDDYPP_FontLookups[NumChars][1] = WidthChar;
			NumChars++;

			bNewChar = true;
		}
	}

	for (int XChar = 0; XChar < ABDDYPP_FONT_CHAR_WIDTH; XChar++)
	{
		for (int YPixel = 0; YPixel < ABDDYPP_FONT_HEIGHT; YPixel++)
		{
			unsigned char ByteData = 0;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XChar * 8 + XPixel;
				int YPos = YPixel;

				unsigned int Colour = SrcImg.GetPixel(XPos, YPos);
				if (Colour != 0x000000)
				{
					ByteData |= (1 << (7 - XPixel));
				}
			}
			ABDDYPP_DestFontData[XChar][YPixel] = ByteData;
		}
	}

	int NumDedupedChars = 0;

	for (int XChar = 0; XChar < ABDDYPP_FONT_CHAR_WIDTH; XChar++)
	{
		int DupeIndex = -1;
		for (int DedupeIndex = 0; DedupeIndex < NumDedupedChars; DedupeIndex++)
		{
			bool bFound = true;
			for (int YPixel = 0; YPixel < ABDDYPP_FONT_HEIGHT; YPixel++)
			{
				if (ABDDYPP_DestFontData[XChar][YPixel] != ABDDYPP_DedupedFontData[DedupeIndex][YPixel])
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
			memcpy(ABDDYPP_DedupedFontData[NumDedupedChars], ABDDYPP_DestFontData[XChar], sizeof(unsigned char) * ABDDYPP_FONT_HEIGHT);
			DupeIndex = NumDedupedChars;
			NumDedupedChars++;
		}
		ABDDYPP_FontDedupeRemapping[XChar] = DupeIndex;
	}



	GPIMAGE ABDDYPP_FontImage(NumDedupedChars * 8, 2048);

	memset(ABDDYPP_FontDataLookup, 255, sizeof(ABDDYPP_FontDataLookup));

	ZeroMemory(ABDDYPP_FontData, sizeof(ABDDYPP_FontData));
	unsigned char RGBWhite[3] = { 0xff, 0xff, 0xff };

	int YCurrentPos = 0;
	for (int FrameIndex = 0; FrameIndex < ABDDYPP_NUM_FRAMES; FrameIndex++)
	{
		int XShift = FrameIndex * 4;
		for (int XCharPos = 0; XCharPos < ABDDYPP_TOTALCHARWIDTH; XCharPos++)
		{
			int MinY = INT_MAX;
			int MaxY = INT_MIN;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;
				XPos = (XPos + XShift) % ABDDYPP_TOTALWIDTH;

				int SineYMin = ABDDYPP_SineValues[XPos];
				int SineYMax = SineYMin + ABDDYPP_FONT_HEIGHT;
				MinY = min(SineYMin, MinY);
				MaxY = max(SineYMax, MaxY);
			}

			int SubPixelY = MinY & 1;

			ABDDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][0] = MinY;
			ABDDYPP_MinMaxYValsPerChar[FrameIndex][XCharPos][1] = MaxY;

			MinY = MinY / 2;
			MaxY = MaxY / 2;

			int YCurrent = YCurrentPos;
			for (int YPixel = MinY; YPixel < MaxY; YPixel++)
			{
				ABDDYPP_FontDataLookup[FrameIndex][YPixel * 2 + 0][XCharPos] = ABDDYPP_FontDataLookup[FrameIndex][YPixel * 2 + 1][XCharPos] = YCurrent;
				YCurrent++;
			}

			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = XCharPos * 8 + XPixel;
				XPos = (XPos + XShift) % ABDDYPP_TOTALWIDTH;

				int SineY = ABDDYPP_SineValues[XPos];
				int YOffset = SineY / 2 - MinY;

				for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
				{
					int XPos = CharIndex * 8 + XPixel;
					int YPos = YCurrentPos + YOffset;

					for (int YPixel = 0; YPixel < ABDDYPP_HALF_FONT_HEIGHT; YPixel++)
					{
						unsigned char FontByte = ABDDYPP_DedupedFontData[CharIndex][YPixel * 2 + SubPixelY];
						unsigned char ColourIndex = (FontByte & (0x80 >> XPixel)) >> (7 - XPixel);
						ABDDYPP_FontImage.SetPixel(XPos, YPos, (ColourIndex == 0) ? 0x000000 : 0xffffff);
						ABDDYPP_FontData[YPos][CharIndex] |= ColourIndex << (7 - XPixel);

						YPos++;
					}
				}
			}
			YCurrentPos += MaxY - MinY;
		}
	}

	ABDDYPP_FontImage.Write("Out\\6502\\Parts\\AllBorderDoubleDYPP\\DYPPedFont.png");

	int YEndPos = YCurrentPos;

	GPIMAGE ABDDYPP_DedupedFontImage(NumDedupedChars * 8 * 3, YEndPos);

	ZeroMemory(ABDDYPP_DedupedFontLine, sizeof(ABDDYPP_DedupedFontLine));

	int yDedupePos = 0;

	memset(ABDDYPP_DedupedFontLineLookup, 0xff, sizeof(ABDDYPP_DedupedFontLineLookup));

	for (int YPos = 0; YPos < YEndPos; YPos++)
	{
		int LineMatch = -1;
		for (int YPos2 = 0; YPos2 < yDedupePos; YPos2++)
		{
			bool bLineMatches = true;
			for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
			{
				unsigned char Byte0 = ABDDYPP_FontData[YPos][CharIndex];
				unsigned char Byte1 = ABDDYPP_DedupedFontLine[YPos2][CharIndex];
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
			memcpy(ABDDYPP_DedupedFontLine[yDedupePos], ABDDYPP_FontData[YPos], NumDedupedChars);
			LineMatch = yDedupePos;
			bMatch = false;
		}
		ABDDYPP_DedupedFontLineLookup[YPos] = LineMatch;

		for (int CharIndex = 0; CharIndex < NumDedupedChars; CharIndex++)
		{
			unsigned char ByteValue = ABDDYPP_FontData[YPos][CharIndex];
			for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
			{
				int XPos = CharIndex * 8 + XPixelPos;
				int BitValue = ByteValue & (0x80 >> XPixelPos);
				unsigned int PlotColour = BitValue == 0 ? 0x000000 : 0xffffff;

				ABDDYPP_DedupedFontImage.SetPixel(XPos, YPos, PlotColour);

				XPos += NumDedupedChars * 8;
				if (!bMatch)
				{
					ABDDYPP_DedupedFontImage.SetPixel(XPos, YPos, PlotColour);
				}
				else
				{
					if (PlotColour != 0x000000)
					{
						ABDDYPP_DedupedFontImage.SetPixel(XPos, YPos, 0xbbbbbb);
					}
				}

				if (!bMatch)
				{
					XPos += NumDedupedChars * 8;
					ABDDYPP_DedupedFontImage.SetPixel(XPos, yDedupePos, PlotColour);
				}
			}
		}

		if (!bMatch)
		{
			yDedupePos++;
		}
	}
	ABDDYPP_DedupedFontImage.Write("Out\\6502\\Parts\\AllBorderDoubleDYPP\\DYPPedDedupedFont.png");

	unsigned char PadValues[64];
	ZeroMemory(PadValues, sizeof(PadValues));

	CodeGen code(FontASMFilename);
	int CurrentOffset = 0;
	for (int YLine = 0; YLine < yDedupePos; YLine++)
	{
		int NextOffset = CurrentOffset + NumDedupedChars;

		int ThisPage = CurrentOffset / 256;
		int NextPage = (CurrentOffset + NumDedupedChars) / 256;

		int CurrentOffsetModded = CurrentOffset % 256;

		if ((CurrentOffsetModded != 0) && (ThisPage != NextPage))
		{
			int PadAmount = 256 - CurrentOffsetModded;
			if (PadAmount != NumDedupedChars)
			{
				code.OutputByteBlock(PadValues, PadAmount, 16);
				code.OutputBlankLine();
				CurrentOffset += PadAmount;
			}
		}

		code.OutputFunctionLine(fmt::format("FontDataDeduped_Line{:03d}", YLine));
		code.OutputByteBlock(ABDDYPP_DedupedFontLine[YLine], NumDedupedChars, 16);
		code.OutputBlankLine();

		CurrentOffset += NumDedupedChars;
	}
}



void ABDDYPP_ProcessScrollText(unsigned char* InputScrollText, LPTSTR OutputScrollTextFilename)
{
	unsigned char ScrollText[4096];
	int ScrollTextLen = 0;
	bool bFinished = false;
	int Index = 0;
	while (!bFinished)
	{
		unsigned char CurrentChar = InputScrollText[Index];
		if (CurrentChar == 0xff)
		{
			bFinished = true;
		}
		else
		{
			int StartChar = ABDDYPP_FontLookups[CurrentChar][0];
			int NumChars = ABDDYPP_FontLookups[CurrentChar][1];
			for (int ThisChar = StartChar; ThisChar < StartChar + NumChars; ThisChar++)
			{
				ScrollText[ScrollTextLen++] = ABDDYPP_FontDedupeRemapping[ThisChar];
			}
		}
		Index++;
	}
	ScrollText[ScrollTextLen] = 255;
	WriteBinaryFile(OutputScrollTextFilename, ScrollText, ScrollTextLen + 1);
}


void OutputFadeSineTable(LPTSTR OutputSineBINFilename)
{
	static const int SineTableLen = 82;
	static const int SineTableHeight = 165;

	unsigned char SinTable[3][SineTableLen];

	for (int Index = 0; Index < SineTableLen; Index++)
	{
		double Angle = ((2 * PI * Index) / SineTableLen) * 1.5;
		double Amplitude = (Index * SineTableHeight) / SineTableLen;
		double HalfAmplitude = Amplitude * 0.5;
		double SineValue = cos(Angle);
		SineValue *= HalfAmplitude;

		double StartY = SineValue + SineTableHeight / 2;
		double EndY = -SineValue + SineTableHeight / 2;

		unsigned char cStartY = (unsigned char)StartY;
		unsigned char cEndY = (unsigned char)EndY;

		if (cEndY < cStartY)
		{
			unsigned char cTmp = cStartY;
			cStartY = cEndY;
			cEndY = cTmp;
		}
		if (cEndY == cStartY)
		{
			cEndY = cStartY + 1;
		}
		SinTable[0][Index] = cStartY;
		SinTable[1][Index] = cEndY;
		SinTable[2][Index] = cStartY + 0x4a;
	}
	WriteBinaryFile(OutputSineBINFilename, SinTable, sizeof(SinTable));
}

int AllBorderDoubleDYPP_Main()
{
	ABDDYPP_CalcData();

	unsigned char UsedChars[64];
	ZeroMemory(UsedChars, 64);
	ABDDYPP_Font_DetermineUsedChars(ABDDYPP_MyScrollText0, UsedChars, 64);
	ABDDYPP_Font_DetermineUsedChars(ABDDYPP_MyScrollText1, UsedChars, 64);

	ABDDYPP_ProcessFontData("6502\\Parts\\AllBorderDoubleDYPP\\Data\\Ksubi-16px-Font.bmp", UsedChars, L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\Font.asm");

	ABDDYPP_CalcSpritePacking();

	ABDDYPP_OutputCode(L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\MainIRQ.asm");

	ABDDYPP_ProcessScrollText(ABDDYPP_MyScrollText0, L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\ScrollText0.bin");
	ABDDYPP_ProcessScrollText(ABDDYPP_MyScrollText1, L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\ScrollText1.bin");

	unsigned char SpriteXPos[4][ABDDYPP_TOTALWIDTH / 2];
	for (int Index = 0; Index < ABDDYPP_TOTALWIDTH / 2; Index++)
	{
		int XPos = (Index * 2) - 48;
		if (XPos < 0)
		{
			XPos += 512 - 8;
		}
		SpriteXPos[0][Index] = SpriteXPos[1][Index] = (XPos & 255);
		SpriteXPos[2][Index] = SpriteXPos[3][Index] = (XPos >= 256) ? 1 : 0;
	}
	WriteBinaryFile(L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\SpriteXVals.bin", SpriteXPos, sizeof(SpriteXPos));

	OutputFadeSineTable(L"Out\\6502\\Parts\\AllBorderDoubleDYPP\\FadeSinTable.bin");

	return 0;
}


