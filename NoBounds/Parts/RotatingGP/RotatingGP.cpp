// (c) 2018-2020, Genesis*Project


#include "..\Common\Common.h"

static const int NumFrames = 22;
static const int FrameWidth = 320;
static const int FrameHeight = 200;

static const int FrameCharWidth = FrameWidth / 8;
static const int TotalImageWidth = FrameWidth * NumFrames;
static const int TotalImageCharWidth = TotalImageWidth / 8;

static const int FrameCharHeight = FrameHeight / 8;
static const int TopFrame_Y0 = 0;
static const int TopFrame_Y1 = FrameCharHeight / 2;
static const int BottomFrame_Y0 = FrameCharHeight / 2;
static const int BottomFrame_Y1 = FrameCharHeight;

unsigned char ScreenChars[FrameCharHeight][FrameCharWidth][NumFrames];

class CHARSET_CHAR
{
public:
	union {
		unsigned char bytes[8];
		unsigned long long qword;
	};

	CHARSET_CHAR() : qword(0) {}
	CHARSET_CHAR(unsigned long long A) : qword(A) {}

	friend bool operator==(CHARSET_CHAR const& lhs, CHARSET_CHAR const& rhs);
};

static const int MaxCharSets = FrameCharHeight;

CHARSET_CHAR UnpackedLineChars[MaxCharSets][TotalImageCharWidth];	//; the full chars - with TotalImageCharWidth chars per line

CHARSET_CHAR CompressedCharSets[MaxCharSets][256];	//; charsets merged together to reduce the number of them
int CompressedCharSets_NumChars[MaxCharSets];	//; charsets merged together to reduce the number of them

unsigned char YLine_CharSet[FrameCharHeight];			//; which charset are we using on each line?

static const int AllowableBitDifferences = 0;// 2;

unsigned int Screen_WhichCharsAnimate[FrameCharHeight][FrameCharWidth];

unsigned __int64 countSetBits(unsigned long long n)
{
	unsigned __int64 count = 0;
	while (n) {
		n &= (n - 1);
		count++;
	}
	return count;
}

bool operator==(CHARSET_CHAR const& lhs, CHARSET_CHAR const& rhs)
{
	unsigned long long diff = lhs.qword ^ rhs.qword;
	return (countSetBits(diff) <= AllowableBitDifferences);
}

int FindCharInCharSet(CHARSET_CHAR FindChar, CHARSET_CHAR Src[], int& NumSrc)
{
	int CharIndex = -1;

	bool bFinished = false;
	for (int j = 0; j < NumSrc; j++)
	{
		if (Src[j] == FindChar)
		{
			CharIndex = j;
			break;
		}
	}
	return CharIndex;
}

int AddAllUniqueChars(CHARSET_CHAR Dst[], int NumDst, CHARSET_CHAR Src[], const int NumSrc, const int MaxNum)
{
	int Num = NumDst;
	for (int i = 0; i < NumSrc; i++)
	{
		CHARSET_CHAR ThisChar = Src[i];
		if (FindCharInCharSet(ThisChar, Dst, Num) < 0)
		{
			if (Num < MaxNum)
			{
				Dst[Num] = ThisChar;
			}
			Num++;
		}
	}
	return Num;
}

int RotatingGP_UseCycles(CodeGen& code, int NumCycles)
{
	static int xchar = 0;
	static int ychar = 0;
	static bool bLoadNewXValue = false;

	static bool bFinishedEverything = false;
	int CyclesRemaining = NumCycles;

	if (!bFinishedEverything)
	{
		bool bFinished = false;
		while (!bFinished)
		{
			if (bLoadNewXValue)
			{
				if ((CyclesRemaining >= 6) || (CyclesRemaining == 4))
				{
					CyclesRemaining -= code.OutputCodeLine(LDX_ABS, fmt::format("FrameBottom"));
					bLoadNewXValue = false;
				}
				else
				{
					bFinished = true;
				}
			}
			else
			{
				unsigned int WhichChars = Screen_WhichCharsAnimate[ychar][xchar];
				if (WhichChars == 0xffffffff)
				{
					if ((CyclesRemaining >= 10) || (CyclesRemaining == 8))
					{
						CyclesRemaining -= code.OutputCodeLine(LDA_ABX, fmt::format("Anim_X{:02d}_Y{:02d}", xchar, ychar));
						if (ychar < 12)
						{
							CyclesRemaining -= code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress0 + ({:d} * 40) + {:d} - 0", ychar, xchar));
						}
						else
						{
							CyclesRemaining -= code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress0 + ({:d} * 40) + {:d} + 0", ychar, xchar));
						}
					}
					else
					{
						bFinished = true;
					}
				}
				else if (WhichChars != 0)
				{
					if ((CyclesRemaining >= 8) || (CyclesRemaining == 6))
					{
						CyclesRemaining -= code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", Screen_WhichCharsAnimate[ychar][xchar]));
						if (ychar < 12)
						{
							CyclesRemaining -= code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress0 + ({:d} * 40) + {:d} - 0", ychar, xchar));
						}
						else
						{
							CyclesRemaining -= code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress0 + ({:d} * 40) + {:d} + 0", ychar, xchar));
						}
					}
					else
					{
						bFinished = true;
					}
				}

				if (!bFinished)
				{
					xchar++;
					if (xchar == 40)
					{
						xchar = 0;
						ychar++;
						if (ychar == 25)
						{
							bFinished = true;
							bFinishedEverything = true;
						}
						if (ychar == 12)
						{
							ychar++;
							bLoadNewXValue = true;
						}
					}
				}
			}
		}
	}

	CyclesRemaining = code.WasteCycles(CyclesRemaining);
	return CyclesRemaining;
}


void RotatingGP_ProcessImages(void)
{
	GPIMAGE InImage("Parts\\RotatingGP\\Data\\RotatingGP.png");

	for (int ychar = 0; ychar < FrameCharHeight; ychar++)
	{
		for (int xchar = 0; xchar < TotalImageCharWidth; xchar++)
		{
			int xchar2 = xchar;
/*			int Frame = xchar / FrameCharWidth;
			int xc = xchar % FrameCharWidth;
			int xchar2 = Frame * (FrameCharWidth * 2) + xc;*/

			CHARSET_CHAR ThisChar;
			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				unsigned char ThisByte = 0;
				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int x = (xchar2 * 8) + xpixel;
					int stripe = (2 + xpixel + (ypixel * 2)) % 8;
					if (stripe >= 4)
					{
//;						if (ypixel != 4)
						{
							if (InImage.GetPixel(x, y) != 0x00000000)
							{
								ThisByte |= (0xc0 >> xpixel);
							}
						}
					}
				}
				ThisChar.bytes[ypixel] = ThisByte;
			}
			UnpackedLineChars[ychar][xchar] = ThisChar;
		}
	}

	//; try to pair up some charsets..!
	int CurrentNumCharSets = 0;

	int ychar = 0;

	memset(YLine_CharSet, 0xff, sizeof(YLine_CharSet));

	while (ychar < FrameCharHeight)
	{
		if (YLine_CharSet[ychar] == 0xff)
		{
			CompressedCharSets[CurrentNumCharSets][0].qword = 0;
			CompressedCharSets_NumChars[CurrentNumCharSets] = 1;

			int Num = AddAllUniqueChars(CompressedCharSets[CurrentNumCharSets], 1, UnpackedLineChars[ychar], TotalImageCharWidth, 256);
			if (Num > 256)
			{
				return;
			}

			int WorkingCharSet_NumChars = Num;

			YLine_CharSet[ychar] = CurrentNumCharSets;

			int ychar2 = ychar + 1;
			while (ychar2 < FrameCharHeight)
			{
				if (YLine_CharSet[ychar2] == 0xff)
				{
					int Num = AddAllUniqueChars(CompressedCharSets[CurrentNumCharSets], WorkingCharSet_NumChars, UnpackedLineChars[ychar2], TotalImageCharWidth, 256);
					if (Num <= 256)
					{
						WorkingCharSet_NumChars = Num;
						YLine_CharSet[ychar2] = CurrentNumCharSets;
					}
				}
				ychar2++;
			}

			CompressedCharSets_NumChars[CurrentNumCharSets] = WorkingCharSet_NumChars;
			CurrentNumCharSets++;
		}
		ychar++;
	}

	for (int ychar = 0; ychar < FrameCharHeight; ychar++)
	{
		unsigned char CharSetIndex = YLine_CharSet[ychar];
		for (int Frame = 0; Frame < NumFrames; Frame++)
		{
			for (int xchar = 0; xchar < FrameCharWidth; xchar++)
			{
				CHARSET_CHAR CurrentChar = UnpackedLineChars[ychar][xchar + Frame * FrameCharWidth];
				int index = FindCharInCharSet(CurrentChar, CompressedCharSets[CharSetIndex], CompressedCharSets_NumChars[CharSetIndex]);
				if (index < 0)
				{
					index = 0;
				}
				ScreenChars[ychar][xchar][Frame] = (unsigned char)index;
			}
		}
	}

/*	for (int Frame = 0; Frame < NumFrames; Frame++)
	{
		GPIMAGE OutImage(FrameWidth, FrameHeight);
		for (int ychar = 0; ychar < FrameCharHeight; ychar++)
		{
			unsigned char CharSetIndex = YLine_CharSet[ychar];
			for (int xchar = 0; xchar < FrameCharWidth; xchar++)
			{
				unsigned char CharVal = ScreenChars[ychar][xchar][Frame];

				for (int ypixel = 0; ypixel < 8; ypixel++)
				{
					int y = ychar * 8 + ypixel;
					unsigned char byte = CompressedCharSets[CharSetIndex][CharVal].bytes[ypixel];
					for (int xpixel = 0; xpixel < 8; xpixel++)
					{
						int x = xchar * 8 + xpixel;
						unsigned int Col = (byte & (1 << (7 - xpixel))) ? 0x00ffffff : 0x00000000;
						OutImage.SetPixel(x, y, Col);

					}
				}
			}
		}
		char OutFilename[256];
		sprintf(OutFilename, "Link\\RotatingGP\\IMG%02d.png", Frame);
		OutImage.Write(OutFilename);
		sprintf(OutFilename, "Link\\RotatingGP\\IMG%02d.png", NumFrames + (NumFrames - 1 - Frame));
		OutImage.Write(OutFilename);
	}*/

	int NumAnimChars = 0;

	for (int CharSet = 0; CharSet < CurrentNumCharSets; CharSet++)
	{
		for (int i = 0; i < 256; i++)
		{
			CompressedCharSets[CharSet][i].qword ^= 0x5555555555555555;
		}
	}
	WriteBinaryFile(L"Link\\RotatingGP\\CharSets.bin", CompressedCharSets, CurrentNumCharSets * (256 * 8));

	CodeGen DrawLogoASM(L"Build\\6502\\RotatingGP\\MainIRQ.asm");
	int CurrentOffset = 0;
	unsigned char PadBytes[24];
	ZeroMemory(PadBytes, sizeof(PadBytes));
	for (int ychar = 0; ychar < FrameCharHeight; ychar++)
	{
		unsigned char CharSetIndex = YLine_CharSet[ychar];
		for (int xchar = 0; xchar < FrameCharWidth; xchar++)
		{
			bool bAllMatch = true;

//; v1: do any values change..?
			unsigned char CharVal = ScreenChars[ychar][xchar][0];
			for (int Frame = 1; Frame < NumFrames; Frame++)
			{
				unsigned char CharVal2 = ScreenChars[ychar][xchar][Frame];
				if (CharVal2 != CharVal)
				{
					bAllMatch = false;
					break;
				}
			}
			if (!bAllMatch)
			{
				Screen_WhichCharsAnimate[ychar][xchar] = 0xffffffff;
			}
			else
			{
				Screen_WhichCharsAnimate[ychar][xchar] = ScreenChars[ychar][xchar][0];
			}

//; v2: are any values non-zero..?

			for (int Frame = 0; Frame < NumFrames; Frame++)
			{
				unsigned char CharVal = ScreenChars[ychar][xchar][Frame];
				if (CharVal)
				{
					bAllMatch = false;
					break;
				}
			}

			if (!bAllMatch)
			{
				unsigned char AnimLine[NumFrames];
				for (int Frame = 0; Frame < NumFrames; Frame++)
				{
					AnimLine[Frame] = ScreenChars[ychar][xchar][Frame];
				}

				int ThisPage = CurrentOffset / 256;
				int NextPage = (CurrentOffset + NumFrames - 1) / 256;
				if (ThisPage != NextPage)
				{
					//; add pad bytes
					int NextOffset = NextPage * 256;
					int PadSize = NextOffset - CurrentOffset;
					DrawLogoASM.OutputCommentLine(fmt::format("//; Padding to avoid crossing a page...", PadSize));
					DrawLogoASM.OutputByteBlock(PadBytes, PadSize);
					DrawLogoASM.OutputBlankLine();
					CurrentOffset += PadSize;
				}

				DrawLogoASM.OutputCommentLine(fmt::format("//; Set {:d}", NumAnimChars));
				DrawLogoASM.OutputFunctionLine(fmt::format("Anim_X{:02d}_Y{:02d}", xchar, ychar));
				DrawLogoASM.OutputByteBlock(AnimLine, NumFrames);
				DrawLogoASM.OutputBlankLine();

				CurrentOffset += NumFrames;
				NumAnimChars++;
			}
		}
	}
	DrawLogoASM.OutputBlankLine();

	DrawLogoASM.OutputFunctionLine(fmt::format("MainIRQ"));

	static const int Raster_Cycles[] = {
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 20,
		63, 63, 63, 63, 63, 63, 63, 63,
		63, 63, 63, 63, 63, 63, 63, 63,
	};
	
	RotatingGP_UseCycles(DrawLogoASM, 54);

	unsigned char CurrentCharSet = 0xff;
	bool bChangeD016 = false;

	for (int Line = 0; Line < 215; Line++)
	{
		int NumCycles = Raster_Cycles[Line];

		int RasterLine = 43 + Line;

		if (Line == 104)
			bChangeD016 = true;

		if ((Line == 104) || (Line == 214))
		{
			if ((NumCycles >= 12) || (NumCycles == 10))
			{
				unsigned char Colour = 0x01;
				if (Line == 214)
					Colour = 0x00;
				NumCycles -= DrawLogoASM.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", Colour));
				NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_BorderColour"));
				NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_MultiColour0"));
			}
		}
		else if ((Line < 104) || (Line >= 108))
		{
			if ((NumCycles >= 14) || (NumCycles == 12))
			{
				double absLine = Line < 108 ? 107 - Line : Line - 108;
/*				absLine /= 107.0;
				double SinVal = 127.0 - sin((double)absLine * PI * 0.48) * 127.0;*/
				double SinVal = 2540.0 / (absLine + 20.0);
				int cSinVal = (int)floor(SinVal);
				cSinVal = max(0, min(127, cSinVal));
				cSinVal = 127 - cSinVal;
				NumCycles -= DrawLogoASM.OutputCodeLine(LDA_ABY, fmt::format("RasterColours + {:d}", (unsigned char)cSinVal));
				NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_BorderColour"));
				NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_MultiColour0"));
			}
		}

		if ((bChangeD016) && ((NumCycles >= 8) || (NumCycles == 6)))
		{
			DrawLogoASM.OutputFunctionLine(fmt::format("D016ValueBottom"));
			NumCycles -= DrawLogoASM.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
			NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
			bChangeD016 = false;
		}

		if ((NumCycles >= 12) || (NumCycles == 10))
		{
			int absLine = Line < 108 ? 53 - (Line / 2) : (Line / 2) - 53;
			NumCycles -= DrawLogoASM.OutputCodeLine(LDA_ABY, fmt::format("RasterLogoColours + {:d}", absLine));
			NumCycles -= DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_MultiColour1"));
		}

		bool bUpdateCharSet = false;
		if ((RasterLine >= 47) && ((RasterLine % 8) == 1))
		{
			unsigned char NewCharSet = YLine_CharSet[(RasterLine - 48) / 8];
			if (NewCharSet != CurrentCharSet)
			{
				CurrentCharSet = NewCharSet;
				bUpdateCharSet = true;
				NumCycles -= 6;
			}
		}

		RotatingGP_UseCycles(DrawLogoASM, NumCycles);

		if (bUpdateCharSet)
		{
			DrawLogoASM.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentCharSet));
			DrawLogoASM.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		}
	}

	DrawLogoASM.OutputCodeLine(RTS);

	return;
}

void RotatingGP_ProcessRasterColours(char* InRasterPNG, LPTSTR OutRasterASM)
{
	GPIMAGE InImage(InRasterPNG);

	unsigned char Cols[256];
	ZeroMemory(Cols, sizeof(Cols));


	for (int y = 0; y < InImage.Height; y++)
	{
		Cols[y] = InImage.GetPixelPaletteColour(0, y);
	}
	Cols[InImage.Height] = 0xff;

	CodeGen OutRasterColoursASM(OutRasterASM);
	OutRasterColoursASM.OutputByteBlock(Cols, InImage.Height + 1);
}

void RotatingGP_GenerateD016Sine(LPTSTR OutD016SineASMFilename)
{
	static const int SineLength = 64;

	unsigned char D016Sine[SineLength];

	for (int i = 0; i < SineLength; i++)
	{
		double angle = (((double)i) * 2.0 * PI) / (double)SineLength;
		double sinvalue = sin(angle) * 4.0 + 4.0;
		sinvalue = floor(sinvalue);
		unsigned char csin = max(0, min(7, (unsigned char)sinvalue));
		D016Sine[i] = csin + 0x10;
	}
	CodeGen OutD016SineASM(OutD016SineASMFilename);
	OutD016SineASM.OutputByteBlock(D016Sine, SineLength);
}

void RotatingGP_GenerateFrameSine(LPTSTR OutFrameSineASMFilename)
{
	static const int SineLength = 64;

	unsigned char FrameSine[SineLength];

	for (int i = 0; i < SineLength; i++)
	{
		double angle = (((double)i) * 2.0 * PI) / (double)SineLength;
		double HalfNumFrames = NumFrames / 2;
		double sinvalue = sin(angle) * HalfNumFrames + HalfNumFrames;
		sinvalue = floor(sinvalue);
		unsigned char csin = max(0, min(NumFrames - 1, (unsigned char)sinvalue));
		FrameSine[i] = csin;
	}
	CodeGen OutD016SineASM(OutFrameSineASMFilename);
	OutD016SineASM.OutputByteBlock(FrameSine, SineLength);
}

void Presents_GenerateSineData(LPTSTR OutSineDataBINFilename)
{
	static const int NumFrames = 256;
	unsigned char SineData[10][NumFrames];

	double SpriteYVals[8];
	double SpriteVels[8];
	double BarY = 148.0;
	double BarYVel = 0.0;

	int NumImpacts = 0;

	for (int i = 0; i < 8; i++)
	{
		SpriteYVals[i] = 29.0;
		SpriteVels[i] = 4.5;
	}

	int BarColourIndex = 0;

	for (int i = 0; i < NumFrames; i++)
	{
		double MaxSpriteY = 0.0;
		int MaxSpriteIndex = -1;
		for (int spr = 0; spr < 8; spr++)
		{
			int iSpriteY = (int)floor(SpriteYVals[spr]);
			iSpriteY = min(max(iSpriteY, 0), 250);
			SineData[spr][i] = (unsigned char)iSpriteY;

			if (i >= spr * 8)
			{
				SpriteYVals[spr] += SpriteVels[spr];
				SpriteVels[spr] += 0.1;

				if (SpriteYVals[spr] > MaxSpriteY)
				{
					MaxSpriteY = SpriteYVals[spr];
					MaxSpriteIndex = spr;
				}
			}
		}

		int BarColourIndex = (int)floor(((BarY - 148.0) * 9.0) / (230.0 - 148.0));
		BarColourIndex = max(0, min(8, BarColourIndex));

		if ((BarColourIndex < 8) && ((MaxSpriteY + 21.0) > BarY))
		{
			BarYVel = SpriteVels[MaxSpriteIndex] * 0.4;
			SpriteVels[MaxSpriteIndex] = -SpriteVels[MaxSpriteIndex] * 0.5;

			double NewSpriteY = (BarY + BarYVel) - 23.0;
			SpriteYVals[MaxSpriteIndex] = NewSpriteY;
			int iNewSpriteY = (int)floor(NewSpriteY);
			iNewSpriteY = min(max(iNewSpriteY, 0), 250);
			SineData[MaxSpriteIndex][i] = (unsigned char)iNewSpriteY;
		}

		BarY += BarYVel;

		BarYVel = (BarYVel * 0.8) - 0.1;
		if (BarYVel < 0.0)
		{
			BarYVel = 0.0;
		}

		int iBarY = (int)floor(BarY);
		iBarY = min(max(iBarY, 0), 242);

		SineData[8][i] = (unsigned char)iBarY;
		SineData[9][i] = (unsigned char)BarColourIndex;
	}
	WriteBinaryFile(OutSineDataBINFilename, SineData, sizeof(SineData));
}

void Presents_GenerateSpriteFadeColourTable(LPTSTR OutSpriteColourFadeTableBINFilename)
{
	unsigned char SpriteColourFadeTable[256 + 56];
	for (int i = 0; i < 256 + 56; i++)
	{
		unsigned char ColValue = 0x01;
		if ((i < 56) || (i >= 255))
		{
			ColValue = 0x00;
		}
		else if ((i == 56) || (i == 254))
		{
			ColValue = 0x09;
		}
		else if ((i == 57) || (i == 253))
		{
			ColValue = 0x02;
		}
		else if ((i == 58) || (i == 252))
		{
			ColValue = 0x05;
		}
		else if ((i == 59) || (i == 251))
		{
			ColValue = 0x0d;
		}
		SpriteColourFadeTable[i] = ColValue;
	}
	WriteBinaryFile(OutSpriteColourFadeTableBINFilename, SpriteColourFadeTable, sizeof(SpriteColourFadeTable));
}

void FadeToNoBounds_ProcessRasterColours(char* InRasterPNG, LPTSTR OutRasterUpdateDataASMFilename, LPTSTR OutRasterUpdateDefinesASMFilename)
{
	static const int MaxNumFrames = 512;
	static const int MaxNumColourChanges = 16384;

	GPIMAGE InImage(InRasterPNG);

	unsigned char Cols[256];
	ZeroMemory(Cols, sizeof(Cols));

	unsigned char OutRasterUpdateData_MinY[MaxNumFrames];
	unsigned char OutRasterUpdateData_MaxY[MaxNumFrames];
	unsigned char OutRasterUpdateData_NumColourChanges[MaxNumFrames];

	int NumColourChanges = 0;
	unsigned char OutRasterUpdateData_YValues[MaxNumColourChanges];
	unsigned char OutRasterUpdateData_ColValues[MaxNumColourChanges];

	int MinY = INT_MAX;
	int MaxY = -INT_MAX;

	int NumFrames = InImage.Width;

	for (int x = 0; x < NumFrames; x++)
	{
		int LastNumColourChanges = NumColourChanges;
		for (int y = 0; y < InImage.Height; y++)
		{
			unsigned char Col = InImage.GetPixelPaletteColour(x, y);
			if (Col != Cols[y])
			{
				MinY = min(y, MinY);
				MaxY = max(y + 1, MaxY);

				OutRasterUpdateData_YValues[NumColourChanges] = y;
				OutRasterUpdateData_ColValues[NumColourChanges] = Col;
				NumColourChanges++;

				Cols[y] = Col;
			}
		}
		OutRasterUpdateData_NumColourChanges[x] = NumColourChanges - LastNumColourChanges;;
		OutRasterUpdateData_MinY[x] = MinY;
		OutRasterUpdateData_MaxY[x] = MaxY + 1;
	}

	CodeGen OutRasterUpdateDefinesASM(OutRasterUpdateDefinesASMFilename);
	OutRasterUpdateDefinesASM.OutputCodeLine(NONE, fmt::format(".var FadeToNoBounds_NumFrames = {:d}", NumFrames));
	OutRasterUpdateDefinesASM.OutputBlankLine();

	CodeGen OutRasterUpdateDataASM(OutRasterUpdateDataASMFilename);
	OutRasterUpdateDataASM.OutputCodeLine(NONE, fmt::format("* = $e000"));
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeToNoBounds_RasterData_NumColourChanges"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_NumColourChanges, NumFrames, 64);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeToNoBounds_RasterData_MinYValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_MinY, NumFrames, 64);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeToNoBounds_RasterData_MaxYValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_MaxY, NumFrames, 64);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeToNoBounds_RasterData_YValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_YValues, NumColourChanges, 64);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeToNoBounds_RasterData_ColValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_ColValues, NumColourChanges, 64);
	OutRasterUpdateDataASM.OutputBlankLine();
}

int RotatingGP_Main()
{
	RotatingGP_ProcessRasterColours("Parts\\RotatingGP\\Data\\RasterColours.png", L"Build\\6502\\RotatingGP\\RasterColours.asm");
	RotatingGP_ProcessRasterColours("Parts\\RotatingGP\\Data\\RasterLogoColours.png", L"Build\\6502\\RotatingGP\\RasterLogoColours.asm");

	RotatingGP_GenerateD016Sine(L"Build\\6502\\RotatingGP\\D016Sine.asm");
	RotatingGP_GenerateFrameSine(L"Build\\6502\\RotatingGP\\FrameSine.asm");

	RotatingGP_ProcessImages();
	
	Presents_GenerateSineData(L"Link\\RotatingGP\\PresentsSineData.bin");
	Presents_GenerateSpriteFadeColourTable(L"Link\\RotatingGP\\SpritesColourFadeTable.bin");

	FadeToNoBounds_ProcessRasterColours("Parts\\RotatingGP\\Data\\Facet-FadeToNoBounds.png", L"Build\\6502\\RotatingGP\\FadeToNoBounds_RasterUpdateData.asm", L"Build\\6502\\RotatingGP\\FadeToNoBounds_RasterUpdateDefines.asm");

	return 0;
}
