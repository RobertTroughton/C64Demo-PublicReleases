// (c) Genesis*Project

#include "..\Common\Common.h"

static const int SinDistBetweenSegmentsX = 16;
static const int SinDistBetweenSegmentsY = 16;

static const int NumCharSegments = 8;
static const int NumSegments = 9;

static const int NumSinTables = (NumSegments + 0) * 2;

unsigned char ColourBytes[2][NumSegments * 2][2] =
{
	{
		{3, 3},
		{3, 2},
		{2, 2},
		{2, 1},
		{1, 1},
		{1, 0},
		{0, 0},
		{0, 3},

		{3, 3},
		{0, 3},
		{0, 0},
		{1, 0},
		{1, 1},
		{2, 1},
		{2, 2},
		{3, 2},
	},
	{
		{3, 2},
		{2, 2},
		{2, 1},
		{1, 1},
		{1, 0},
		{0, 0},
		{0, 3},
		{3, 3},

		{3, 2},
		{3, 3},
		{0, 3},
		{0, 0},
		{1, 0},
		{1, 1},
		{2, 1},
		{2, 2},
	},
};

int RelativeSegments[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1};

void TUN_GenAnimation(LPTSTR OutputAnimBINFilename, LPTSTR OutputAnimASMFilename)
{
	static const int NumSineValuesX = 128;
	static const int NumSineValuesY = 128;

	static const double dNumSinValuesX = (double)NumSineValuesX;
	static const double dNumSinValuesY = (double)NumSineValuesY;

	static const double dSinDistBetweenSegmentsX = (double)SinDistBetweenSegmentsX;
	static const double dSinDistBetweenSegmentsY = (double)SinDistBetweenSegmentsY;

	unsigned char XSinTables[NumSinTables][NumSineValuesX];
	unsigned char YSinTables[NumSinTables][NumSineValuesY];
	ZeroMemory(XSinTables, sizeof(XSinTables));
	ZeroMemory(YSinTables, sizeof(YSinTables));

	for (int i = 0; i < NumSineValuesX; i++)
	{
		for (int Segment = 0; Segment < NumSegments; Segment++)
		{
			unsigned char MinX = 255;
			unsigned char MaxX = 0;

			bool bLastSegment = (Segment == NumSegments - 1);
			double SizeX;
			double dSegX;
			if (bLastSegment)
			{
				dSegX = Segment;

			}
			else
			{
				dSegX = Segment - ((double)(i % SinDistBetweenSegmentsX)) / dSinDistBetweenSegmentsX;
			}

			double Z = (dSegX / (NumSegments - 2)) * 7.333333 + 1.0;
			SizeX = 184.0;

			double dX = (double)i + (dSegX * dSinDistBetweenSegmentsX);
			double XSin = sin((dX * PI * 2.0) / dNumSinValuesX) * 18.0;

			double X0 = (XSin - SizeX) / Z + 80.0;
			double X1 = (XSin + SizeX) / Z + 80.0;

			XSinTables[Segment][i] = (unsigned char)min(160, max(0, X0));
			XSinTables[NumSegments * 2 - 1 - Segment][i] = (unsigned char)min(160, max(0, X1));
		}
	}

	for (int i = 0; i < NumSineValuesY; i++)
	{
		unsigned char MinY = 255;
		unsigned char MaxY = 0;
		for (int Segment = 0; Segment < NumSegments; Segment++)
		{
			bool bLastSegment = (Segment == NumSegments - 1);
			double SizeY;
			double dSegY;
			if (bLastSegment)
			{
				dSegY = Segment;
			}
			else
			{
				dSegY = Segment - ((double)(i % SinDistBetweenSegmentsY)) / dSinDistBetweenSegmentsY;
			}

			double Z = (dSegY / (NumSegments - 2)) * 6.333333 + 1.0;
			SizeY = 200.0;

			double dY = (double)i * 2.0 + (dSegY * dSinDistBetweenSegmentsY);
			double YSin = cos((dY * PI * 2.0) / dNumSinValuesY) * 96.0;

			double Y0 = (YSin - SizeY) / Z + 127.5;
			double Y1 = (YSin + SizeY) / Z + 127.5;

			YSinTables[Segment][i] = (unsigned char)min(255, max(0, Y0));
			YSinTables[NumSegments * 2 - 1 - Segment][i] = (unsigned char)min(255, max(0, Y1));
		}
	}

	for (int i = 0; i < NumSineValuesY; i++)
	{
		int MinY = 0;
		int MaxY = 255;

		int LastSegmentOffTop = -1;
		int FirstSegmentOffBottom = -1;
		for (int Segment = 0; Segment < NumSegments; Segment++)
		{
			int OppSegment = NumSegments * 2 - 1 - Segment;
			MinY = max(MinY + 1, YSinTables[Segment][i]);
			MaxY = min(MaxY, YSinTables[OppSegment][i]);

			if (MaxY < MinY)
			{
				MaxY = MinY + 1;
			}

			int OutY0 = MinY - 32;
			if (OutY0 <= 0)
			{
				LastSegmentOffTop = Segment;
				OutY0 = 0;
			}

			int OutY1 = min(192, MaxY - 32);

			YSinTables[Segment][i] = OutY0;
			YSinTables[OppSegment][i] = OutY1;
		}

		if (LastSegmentOffTop > 0)
		{
			for (int Segment = 0; Segment < LastSegmentOffTop; Segment++)
			{
				YSinTables[Segment][i] = 192;
			}
		}
	}


	CodeGen OutAnimASM(OutputAnimASMFilename);

	OutAnimASM.OutputFunctionLine(fmt::format("Set_ZP_SetD018Values"));
	OutAnimASM.OutputBlankLine();

	OutAnimASM.OutputCodeLine(LDX_ABS, fmt::format("YSineLookup"));
	OutAnimASM.OutputBlankLine();

	for (int i = 0; i < NumSinTables; i++)
	{
		OutAnimASM.OutputCodeLine(LDY_ABX, fmt::format("YSinTable{:d}", i));
		OutAnimASM.OutputCodeLine(LDA_ABY, fmt::format("SetD018_Ptrs_Lo"));
		OutAnimASM.OutputCodeLine(STA_ABS, fmt::format("ZP_SetD018 + {:2d} * 2 + 0", i));
		OutAnimASM.OutputCodeLine(LDA_ABY, fmt::format("SetD018_Ptrs_Hi"));
		OutAnimASM.OutputCodeLine(STA_ABS, fmt::format("ZP_SetD018 + {:2d} * 2 + 1", i));
		OutAnimASM.OutputBlankLine();
	}
	OutAnimASM.OutputCodeLine(RTS);
	OutAnimASM.OutputBlankLine();
	OutAnimASM.OutputBlankLine();

	OutAnimASM.OutputCodeLine(NONE, fmt::format(".align 256"));

	int ASMByteOffset = 0;
	for (int i = 1; i < NumSinTables - 1; i++)	//; we skip 0 (all zeros) and the last (all 160s)
	{
		if (i != 9)	//; HACK: we don't need 9 .. our black-sprite-back is fixed size anyway!
		{
			OutAnimASM.OutputFunctionLine(fmt::format("XSinTable{:d}", i));
			OutAnimASM.OutputByteBlock(XSinTables[i], NumSineValuesX, 32);
			OutAnimASM.OutputBlankLine();
			ASMByteOffset += NumSineValuesX;
		}
	}

	for (int i = 0; i < NumSinTables; i++)
	{
		static const int ShortenedNumSineValuesY = 64;
		int NumBytesLeftOnPage = 256 - (ASMByteOffset & 255);
		if (NumBytesLeftOnPage < ShortenedNumSineValuesY)
		{
			OutAnimASM.OutputCodeLine(NONE, fmt::format(".align 256"));
			ASMByteOffset += NumBytesLeftOnPage;
		}
		OutAnimASM.OutputFunctionLine(fmt::format("YSinTable{:d}", i));
		OutAnimASM.OutputByteBlock(YSinTables[i], ShortenedNumSineValuesY, 32);
		OutAnimASM.OutputBlankLine();
		ASMByteOffset += ShortenedNumSineValuesY;
	}
}

void TUN_WasteCycles(CodeGen& OutCode, int NumCycles)
{
	if (NumCycles >= 14)
	{
		int DistanceBeforeRTS = NumCycles - 6 - 6 - 1;
		OutCode.OutputCodeLine(JSR_ABS, fmt::format("CycleWasteFunction_End - {:d}", DistanceBeforeRTS));
	}
	else
	{
		OutCode.WasteCycles(NumCycles);
	}
}


void TUN_GenMainCode(LPTSTR OutMainASM)
{
	static const unsigned char SegmentChars[NumCharSegments * 2] = {
		0x00, 0x04, 0x08, 0x0c, 0x10, 0x14, 0x18, 0x1c,
		0x20, 0x24, 0x28, 0x2c, 0x30, 0x34, 0x38, 0x3c
	};

	CodeGen OutCode(OutMainASM);

	OutCode.OutputFunctionLine(fmt::format("CycleWasteFunction"));
	for (int i = 0; i < 32; i++)
	{
		OutCode.OutputCodeLine(LDA_IMM, fmt::format("#$a9"));
	}
	OutCode.OutputCodeLine(LDA_ABS, fmt::format("$eaa5"));
	OutCode.OutputFunctionLine(fmt::format("CycleWasteFunction_End"));
	OutCode.OutputCodeLine(RTS);
	OutCode.OutputBlankLine();

	OutCode.OutputFunctionLine(fmt::format("MainIRQCode"));
	TUN_WasteCycles(OutCode, 50);

	int CurrentD018Split = 0;
	int SpriteY = 0x4a;
	for (int RasterLine = 0; RasterLine < 192; RasterLine++)
	{
		bool bLastRasterLine = (RasterLine == 191);

		int CharLine = RasterLine / 8;
		int RLMod8 = RasterLine % 8;
		int NumCycles = 63;
		if ((RasterLine >= 16) && (RasterLine < 163))
		{
			NumCycles -= 7;	//; lost for sprites
		}

		int CurrentY = RasterLine + 50;

		if (RasterLine == 0)
		{
			OutCode.OutputFunctionLine(fmt::format("FirstD011Value"));
			NumCycles -= OutCode.OutputCodeLine(LDY_IMM, fmt::format("#$7a"));
			NumCycles -= OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_D011"));
		}
		else
		{
			if (RLMod8 == 0)
			{
				NumCycles -= OutCode.OutputCodeLine(DEC_ABS, fmt::format("VIC_D011"));
			}
			if (RLMod8 == 4)
			{
				NumCycles -= OutCode.OutputCodeLine(INC_ABS, fmt::format("VIC_D011"));
			}
		}

		OutCode.OutputFunctionLine(fmt::format("SetD018_Line{:03d}", RasterLine));
		if (RasterLine == 0)
		{
			NumCycles -= OutCode.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
			NumCycles -= OutCode.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		}
		else
		{
			NumCycles -= OutCode.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
			NumCycles -= OutCode.OutputCodeLine(STA_ABS, fmt::format("$d03f"));
		}

		if ((NumCycles >= 12) && (CurrentY > (SpriteY + 1)))
		{
			SpriteY += 21;
			if (SpriteY <= 216)
			{
				NumCycles -= OutCode.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", SpriteY));
				NumCycles -= OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite0Y"));
				NumCycles -= OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite1Y"));
			}
		}

		if (bLastRasterLine)
		{
			NumCycles += 16;	//; waste some extra before we do the cleanup stuff...
		}
		TUN_WasteCycles(OutCode, NumCycles);
	}
	OutCode.OutputCodeLine(LDY_IMM, fmt::format("#D018Value0"));
	OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_D018"));
	OutCode.OutputCodeLine(LDA_IMM, fmt::format("#$fa"));
	OutCode.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));

	OutCode.OutputCodeLine(LDY_IMM, fmt::format("#$4a"));
	OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite0Y"));
	OutCode.OutputCodeLine(STY_ABS, fmt::format("VIC_Sprite1Y"));

	OutCode.OutputCodeLine(RTS);
	OutCode.OutputBlankLine();

	OutCode.OutputFunctionLine(fmt::format("SetD018_Ptrs_Lo"));
	for (int RasterLine = 0; RasterLine < 192; RasterLine += 8)
	{
		OutCode.OutputCodeLine(NONE, fmt::format(".byte <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}, <SetD018_Line{:03d}", RasterLine + 0, RasterLine + 1, RasterLine + 2, RasterLine + 3, RasterLine + 4, RasterLine + 5, RasterLine + 6, RasterLine + 7));
	}
	OutCode.OutputCodeLine(NONE, fmt::format(".byte <NullMem"));
	OutCode.OutputBlankLine();

	OutCode.OutputFunctionLine(fmt::format("SetD018_Ptrs_Hi"));
	for (int RasterLine = 0; RasterLine < 192; RasterLine += 8)
	{
		OutCode.OutputCodeLine(NONE, fmt::format(".byte >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}, >SetD018_Line{:03d}", RasterLine + 0, RasterLine + 1, RasterLine + 2, RasterLine + 3, RasterLine + 4, RasterLine + 5, RasterLine + 6, RasterLine + 7));
	}
	OutCode.OutputCodeLine(NONE, fmt::format(".byte >NullMem"));
	OutCode.OutputBlankLine();

	OutCode.OutputFunctionLine(fmt::format("DrawCharLine"));

	OutCode.OutputCodeLine(LDA_ABS, fmt::format("XSineLookup"));
	OutCode.OutputCodeLine(AND_IMM, fmt::format("#$0f"));
	OutCode.OutputCodeLine(BNE, fmt::format("PlotNewCharLine"));
	OutCode.OutputFunctionLine(fmt::format("DoFlipCharIndexes"));
	OutCode.OutputCodeLine(LDA_ZP, fmt::format("ZP_SegmentOffset"));
	OutCode.OutputCodeLine(EOR_IMM, fmt::format("#$40"));
	OutCode.OutputCodeLine(STA_ZP, fmt::format("ZP_SegmentOffset"));

	OutCode.OutputCodeLine(LDA_ABS, fmt::format("XSineLookup"));
	OutCode.OutputCodeLine(AND_IMM, fmt::format("#$1f"));
	OutCode.OutputCodeLine(BNE, fmt::format("PlotNewCharLine"));

	OutCode.OutputFunctionLine(fmt::format("CycleColours"));
	OutCode.OutputCodeLine(LDX_ABS, fmt::format("VIC_ScreenColour"));
	OutCode.OutputCodeLine(LDA_ABS, fmt::format("VIC_ColourMemory"));
	OutCode.OutputCodeLine(AND_IMM, fmt::format("#$07"));
	OutCode.OutputCodeLine(STA_ABS, fmt::format("VIC_ScreenColour"));
	OutCode.OutputCodeLine(LDA_ABS, fmt::format("VIC_MultiColour1"));
	OutCode.OutputCodeLine(AND_IMM, fmt::format("#$07"));
	OutCode.OutputCodeLine(ORA_IMM, fmt::format("#$08"));
	OutCode.OutputCodeLine(LDY_IMM, fmt::format("#$07"));
	OutCode.OutputFunctionLine(fmt::format("FillD800Loop"));
	OutCode.OutputCodeLine(STA_ABY, fmt::format("VIC_ColourMemory + (8 * 0)"));
	OutCode.OutputCodeLine(STA_ABY, fmt::format("VIC_ColourMemory + (8 * 1)"));
	OutCode.OutputCodeLine(STA_ABY, fmt::format("VIC_ColourMemory + (8 * 2)"));
	OutCode.OutputCodeLine(STA_ABY, fmt::format("VIC_ColourMemory + (8 * 3)"));
	OutCode.OutputCodeLine(STA_ABY, fmt::format("VIC_ColourMemory + (8 * 4)"));
	OutCode.OutputCodeLine(DEY);
	OutCode.OutputCodeLine(BPL, fmt::format("FillD800Loop"));
	OutCode.OutputCodeLine(LDA_ABS, fmt::format("VIC_MultiColour0"));
	OutCode.OutputCodeLine(STA_ABS, fmt::format("VIC_MultiColour1"));
	OutCode.OutputCodeLine(STX_ABS, fmt::format("VIC_MultiColour0"));

	OutCode.OutputFunctionLine(fmt::format("PlotNewCharLine"));
	OutCode.OutputCodeLine(LDX_ABS, fmt::format("XSineLookup"));
	OutCode.OutputBlankLine();

	int LastGoodSegment = -1;
	for (int Segment = 0; Segment < NumCharSegments * 2; Segment++)
	{
		bool bLastSegment = (Segment == (NumCharSegments * 2 - 1));
		if ((Segment > 0) && (!bLastSegment))
		{
			int SinTableIndex = Segment;
			if (Segment >= NumCharSegments)
				SinTableIndex += 2;
			OutCode.OutputCodeLine(LDY_ABX, fmt::format("XSinTable{:d}", SinTableIndex));
			OutCode.OutputCodeLine(TYA);
			OutCode.OutputCodeLine(AND_IMM, fmt::format("#$03"));
			OutCode.OutputCodeLine(EOR_IMM, fmt::format("#${:02x}", SegmentChars[Segment] + 0x03));
			OutCode.OutputCodeLine(STA_ABS, fmt::format("XJoin{:d} + 1", Segment));
			OutCode.OutputCodeLine(TYA);
			OutCode.OutputCodeLine(LSR);
			OutCode.OutputCodeLine(LSR);
			OutCode.OutputCodeLine(STA_ABS, fmt::format("XChar{:d} + 1", Segment));
		}
		if (LastGoodSegment > 0)
		{
			OutCode.OutputCodeLine(STA_ABS, fmt::format("NextXChar{:d} + 1", LastGoodSegment));
		}
		LastGoodSegment = Segment;
	}
	OutCode.OutputBlankLine();

	OutCode.OutputCodeLine(LDX_IMM, fmt::format("#$00"));

	for (int Segment = 0; Segment < NumCharSegments * 2; Segment++)
	{
		bool bLastSegment = (Segment == (NumCharSegments * 2 - 1));
		OutCode.OutputFunctionLine(fmt::format("XPlot{:d}", Segment));
		OutCode.OutputFunctionLine(fmt::format("XCharIndex{:d}", Segment));
		OutCode.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SegmentChars[Segment]));
		OutCode.OutputCodeLine(EOR_ZP, fmt::format("ZP_SegmentOffset"));

		OutCode.OutputCodeLine(CPX_ABS, fmt::format("XChar{:d} + 1", Segment));

		OutCode.OutputCodeLine(BEQ, fmt::format("NextXChar{:d}", Segment));
		OutCode.OutputFunctionLine(fmt::format("XChar{:d}Loop", Segment));
		OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress0"));
		OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress1"));
		OutCode.OutputCodeLine(INX);

		OutCode.OutputFunctionLine(fmt::format("XChar{:d}", Segment));
		unsigned char CompVal = bLastSegment ? 0x28 : 0x00;
		OutCode.OutputCodeLine(CPX_IMM, fmt::format("#${:02x}", CompVal));
		OutCode.OutputCodeLine(BNE, fmt::format("XChar{:d}Loop", Segment));

		OutCode.OutputFunctionLine(fmt::format("NextXChar{:d}", Segment));
		if (!bLastSegment)
		{
			OutCode.OutputCodeLine(CPX_IMM, fmt::format("#$00"));
			OutCode.OutputCodeLine(BEQ, fmt::format("SkipJoin{:d}", Segment));
		}
		else
		{
			OutCode.OutputCodeLine(CPX_IMM, fmt::format("#$28"));
			OutCode.OutputCodeLine(BEQ, fmt::format("XPlotFin"));
		}
		OutCode.OutputFunctionLine(fmt::format("XJoin{:d}", Segment));
		if (Segment == 0)
		{
			OutCode.OutputCodeLine(LDA_IMM, fmt::format("#$03"));
		}
		else
		{
			OutCode.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SegmentChars[Segment]));
		}
		OutCode.OutputCodeLine(EOR_ZP, fmt::format("ZP_SegmentOffset"));
		OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress0"));
		OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress1"));
		OutCode.OutputCodeLine(INX);
		if (!bLastSegment)
			OutCode.OutputFunctionLine(fmt::format("SkipJoin{:d}", Segment));
	}
	OutCode.OutputCodeLine(CPX_IMM, fmt::format("#$28"));
	OutCode.OutputCodeLine(BEQ, fmt::format("XPlotFin"));
	OutCode.OutputFunctionLine(fmt::format("XPlotLast"));
	OutCode.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	OutCode.OutputCodeLine(EOR_ZP, fmt::format("ZP_SegmentOffset"));
	OutCode.OutputFunctionLine(fmt::format("XCharLastLoop"));
	OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress0"));
	OutCode.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress1"));
	OutCode.OutputCodeLine(INX);
	OutCode.OutputCodeLine(CPX_IMM, fmt::format("#$28"));
	OutCode.OutputCodeLine(BNE, fmt::format("XCharLastLoop"));
	OutCode.OutputFunctionLine(fmt::format("XPlotFin"));
	OutCode.OutputBlankLine();
	OutCode.OutputCodeLine(RTS);
	OutCode.OutputBlankLine();
}

void TUN_GenCharset(LPTSTR OutCharsetBINFilename)
{
	unsigned char Charset[8][128][8];
	ZeroMemory(Charset, sizeof(Charset));
	for (int CharSetIndex = 0; CharSetIndex < 8; CharSetIndex++)
	{
		for (int Half = 0; Half < 2; Half++)
		{
			int i = (1 - Half) * 64;

			int LastSegment = 0;
			for (int Segment = 0; Segment < (NumCharSegments * 2); Segment++)
			{
				int NextSegment = (Segment + 1) % (NumCharSegments * 2);

				int ActualSegment = (RelativeSegments[Segment] > CharSetIndex) ? LastSegment : Segment;
				int ActualNextSegment = (RelativeSegments[NextSegment] > CharSetIndex) ? ActualSegment : NextSegment;

				LastSegment = ActualSegment;

				unsigned char LBits0 = ColourBytes[Half][ActualSegment][0];
				unsigned char LBits1 = ColourBytes[Half][ActualSegment][1];
				unsigned char RBits0 = ColourBytes[Half][ActualNextSegment][0];
				unsigned char RBits1 = ColourBytes[Half][ActualNextSegment][1];

				unsigned char LVal0 = (LBits0 << 6) | (LBits0 << 4) | (LBits0 << 2) | (LBits0 << 0);
				unsigned char LVal1 = (LBits1 << 6) | (LBits1 << 4) | (LBits1 << 2) | (LBits1 << 0);

				unsigned char RVal0 = (RBits0 << 6) | (RBits0 << 4) | (RBits0 << 2) | (RBits0 << 0);
				unsigned char RVal1 = (RBits1 << 6) | (RBits1 << 4) | (RBits1 << 2) | (RBits1 << 0);

				for (int CharIndex = 0; CharIndex < 4; CharIndex++)
				{
					int ShiftVal = CharIndex * 2;

					unsigned char LeftMask = 0xff << ShiftVal;
					unsigned char RightMask = 0xff >> (8 - ShiftVal);

					unsigned char OutByte0 = (LVal0 & LeftMask) | (RVal0 & RightMask);
					unsigned char OutByte1 = (LVal1 & LeftMask) | (RVal1 & RightMask);

					Charset[CharSetIndex][i][0] = Charset[CharSetIndex][i][2] = Charset[CharSetIndex][i][4] = Charset[CharSetIndex][i][6] = OutByte0;
					Charset[CharSetIndex][i][1] = Charset[CharSetIndex][i][3] = Charset[CharSetIndex][i][5] = Charset[CharSetIndex][i][7] = OutByte1;
					i++;
				}
			}
		}
	}
	WriteBinaryFile(OutCharsetBINFilename, Charset, sizeof(Charset));

	int NumUniques = 0;
	UINT64 UniqueCharSet[256];
	UINT64* pCharSet = (UINT64*)Charset;

	unsigned char CharLookup[8][128];
	for (int CharSet = 7; CharSet >= 0; CharSet--)
	{
		for (int i = 0; i < 128; i++)
		{
			int FoundIndex = -1;
			UINT64 ThisChar = pCharSet[CharSet * 128 + i];
			for (int j = 0; j < NumUniques; j++)
			{
				if (ThisChar == UniqueCharSet[j])
				{
					FoundIndex = j;
					break;
				}
			}
			if (FoundIndex == -1)
			{
				FoundIndex = NumUniques;
				if (NumUniques < 256)
				{
					UniqueCharSet[NumUniques] = ThisChar;
				}
				NumUniques++;
			}
			CharLookup[CharSet][i] = FoundIndex;	//; multiply by 2 to give our index into the below table..!
		}
	}

	unsigned char PackedCharSet[64][2]{};
	unsigned char* pUnique = (unsigned char*)UniqueCharSet;
	for (int i = 0; i < NumUniques; i++)
	{
		PackedCharSet[i][0] = pUnique[i * 8 + 0];
		PackedCharSet[i][1] = pUnique[i * 8 + 1];
	}

	unsigned char NewCharSetData[8][128][8];
	for (int CharSet = 0; CharSet < 8; CharSet++)
	{
		for (int i = 0; i < 128; i++)
		{
			NewCharSetData[CharSet][i][0] = NewCharSetData[CharSet][i][2] = NewCharSetData[CharSet][i][4] = NewCharSetData[CharSet][i][6] = PackedCharSet[CharLookup[CharSet][i]][0];
			NewCharSetData[CharSet][i][1] = NewCharSetData[CharSet][i][3] = NewCharSetData[CharSet][i][5] = NewCharSetData[CharSet][i][7] = PackedCharSet[CharLookup[CharSet][i]][1];
		}
	}
	WriteBinaryFile(OutCharsetBINFilename, NewCharSetData, sizeof(NewCharSetData));
}

	
void TUN_PackCharset(LPTSTR InCharsetBINFilename, LPTSTR OutPackedCharsetBINFilename, LPTSTR OutCharsetIndexesBINFilename)
{
	UINT64 Charset[8][128];

	ReadBinaryFile(InCharsetBINFilename, Charset, sizeof(Charset));

	unsigned char CharIndexes[7][128];

	for (int c = 0; c < 7; c++)
	{
		for (int i = 0; i < 128; i++)
		{
			UINT64& ThisChar = Charset[c][i];
			int found = -1;
			for (int j = 0; j < 128; j++)
			{
				if (Charset[7][j] == ThisChar)
				{
					found = j;
					break;
				}
			}
			if (found == -1)
			{
				found = 127;
			}
			CharIndexes[c][i] = found;
		}
	}

	WriteBinaryFile(OutPackedCharsetBINFilename, Charset[7], 128 * 8);
	WriteBinaryFile(OutCharsetIndexesBINFilename, CharIndexes, 7 * 128);
}

	
int Tunnel_Main()
{
	TUN_GenAnimation(L"Link\\Tunnel\\AnimData.bin", L"Build\\6502\\Tunnel\\AnimData.asm");
	TUN_GenMainCode(L"Build\\6502\\Tunnel\\MainIRQCode.asm");
	TUN_GenCharset(L"Link\\Tunnel\\Charset.bin");
	TUN_PackCharset(L"Link\\Tunnel\\Charset.bin", L"Link\\Tunnel\\CharsetPacked.bin", L"Link\\Tunnel\\CharsetPackedIndexes.bin");

	return 0;
}


