//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h" 
#include "..\Common\SinTables.h" 

void BASICFADE_GenerateCurve(LPTSTR OutCurveBINFilename)
{
	static const int NumEntries = 32;
	unsigned char CurveTable[2][NumEntries];

	for (int i = 0; i < NumEntries; i++)
	{
		double Index = (i * 6.4) / (double)NumEntries;
		double Val = exp(Index);
		Val = min(Val, 252.0);
		unsigned char cVal = (unsigned char)Val;
		CurveTable[0][i] = cVal % 21;
		CurveTable[1][i] = 12 - (cVal / 21);
	}
	CurveTable[0][0] = CurveTable[0][1] = 0;
	CurveTable[1][0] = CurveTable[1][1] = 12;
	WriteBinaryFile(OutCurveBINFilename, CurveTable, sizeof(CurveTable));
}

void BASICFADE_OutputSpriteUpdateASM(LPTSTR OutputASMFilename)
{
	CodeGen MyCode(OutputASMFilename);

	for (int xchar = 0; xchar < 3; xchar++)
	{
		MyCode.OutputFunctionLine(fmt::format("UpdateSpriteAndScreenData_X{:d}", xchar));

		for (int ychar = 0; ychar < 25; ychar++)
		{
			MyCode.OutputCodeLine(LDY_ABX, fmt::format("ScreenAddress0 + ({:2d} * 40)", ychar));

			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				int SpriteIndex = y / 21;
				int SpriteY = y % 21;

				MyCode.OutputCodeLine(LDA_ABY, fmt::format("ADDR_FontData_Y{:d}", ypixel));
				MyCode.OutputCodeLine(STA_ABS, fmt::format("SpriteDataAddress0 + ({:d} * 64) + ({:d} * 3) + {:d}", SpriteIndex, SpriteY, xchar));
			}
			MyCode.OutputBlankLine();
		}
		MyCode.OutputCodeLine(RTS);
		MyCode.OutputBlankLine();
		MyCode.OutputBlankLine();
	}
}

void BASICFADE_GenerateTopBottomFadeASM(LPTSTR OutputFadeRastersASMFilename)
{
	static const int NumTopRasters = 43;
	static const int NumBottomRasters = 50;
	static const int NumRows = NumTopRasters + NumBottomRasters;

	static const unsigned char FadeColours[] = { 15, 1, 13, 5, 9, 0 };
	static const int NumFadeColours = sizeof(FadeColours);

	static const int NumFrames = NumRows * 2 + NumFadeColours * 3;

	static const int OutputFadeColours_LeadInSize = ((NumRows - 1) * 2);

	CodeGen OutFadeCode(OutputFadeRastersASMFilename);

	//; setup the fade colour table
	static const int FadeColours_TotalSize = OutputFadeColours_LeadInSize + NumFadeColours * 3 + OutputFadeColours_LeadInSize;
	unsigned char OutputFadeColours[FadeColours_TotalSize]; //; nb. *2 because we also have the leadout
	memset(OutputFadeColours, 14, OutputFadeColours_LeadInSize);
	for (int i = 0; i < NumFadeColours * 3; i++)
	{
		OutputFadeColours[OutputFadeColours_LeadInSize + i] = FadeColours[i / 3];
	}
	memset(&OutputFadeColours[OutputFadeColours_LeadInSize + NumFadeColours * 3], 0, OutputFadeColours_LeadInSize);

	OutFadeCode.OutputCodeLine(NONE, fmt::format(".var NumFadeFrames = {:d}", OutputFadeColours_LeadInSize + NumFadeColours * 3));
	OutFadeCode.OutputBlankLine();
	OutFadeCode.OutputCodeLine(NONE, fmt::format(".var NumRastersTop = {:d}", NumTopRasters));
	OutFadeCode.OutputCodeLine(NONE, fmt::format(".var NumRastersBottom = {:d}", NumBottomRasters));
	OutFadeCode.OutputBlankLine();

	OutFadeCode.OutputFunctionLine(fmt::format("FadeColours"));
	OutFadeCode.OutputByteBlock(OutputFadeColours, FadeColours_TotalSize);


	//; figure out the order in which the rows will fade out
	unsigned char FadeOrder[NumRows];
	memset(FadeOrder, 0xff, sizeof(FadeOrder));
	for (int index = 0; index < NumRows; index++)
	{
		bool bFound = false;
		while (!bFound)
		{
			int i = rand() % NumRows;
			if (FadeOrder[i] == 0xff)
			{
				FadeOrder[i] = index;
				bFound = true;
			}
		}
	}
	OutFadeCode.OutputBlankLine();

	OutFadeCode.OutputFunctionLine(fmt::format("BASICFADE_UpdateRasterColours"));
	for (int index = 0; index < NumRows; index++)
	{
		int OffsetToData = OutputFadeColours_LeadInSize - FadeOrder[index] * 2;
		OutFadeCode.OutputCodeLine(LDA_ABY, fmt::format("FadeColours + {:d}", OffsetToData));
		if (index < NumTopRasters)
		{
			OutFadeCode.OutputCodeLine(STA_ABS, fmt::format("ZP_RasterColoursTop + {:d}", index));
		}
		else
		{
			OutFadeCode.OutputCodeLine(STA_ABS, fmt::format("ZP_RasterColoursBottom + {:d}", index - NumTopRasters));
		}
	}
	OutFadeCode.OutputCodeLine(RTS);
}

void BASICFADE_GenerateScreenFadePNG(char* OutputScreenFadeRastersPNGFilename)
{
	static const int NumFramesForScreenFade = 96;

	GPIMAGE OutScreenFadeRasters(NumFramesForScreenFade, 200);

	int LastMinY = -256;
	int LastMaxY = -256;

	unsigned char ColAbove = 14;
	unsigned char ColBelow = 14;

	for (int Frame = 0; Frame < NumFramesForScreenFade; Frame++)
	{
		double SinMod = 135.0 - (135.0 * Frame) / (NumFramesForScreenFade - 1);
		double SinY = cos((Frame * 1.7 * 2 * PI) / NumFramesForScreenFade) * SinMod + 100.0;

		double YellowBarExtra = sin((Frame * 2.0 * PI * 6.5) / NumFramesForScreenFade) * 4.0 + 8.0;
		double YellowBarMod = 1.0 - ((double)Frame / (double)(NumFramesForScreenFade - 1));
		double YellowBarSize = 4.0 + (YellowBarExtra * YellowBarMod);

		int MinY = (int)floor(SinY - YellowBarSize);
		int MaxY = (int)floor(SinY + YellowBarSize);

		if (MinY <= 0)
		{
			ColAbove = 10;
		}
		if (MaxY >= 200)
		{
			ColBelow = 2;
		}

		MinY = max(0, MinY);
		MaxY = min(200, MaxY);

		OutScreenFadeRasters.FillRectanglePaletteColour(Frame, MinY, Frame + 1, MaxY, 7);
		OutScreenFadeRasters.FillRectanglePaletteColour(Frame, 0, Frame + 1, MinY, ColAbove);
		OutScreenFadeRasters.FillRectanglePaletteColour(Frame, MaxY, Frame + 1, 200, ColBelow);
	}
	OutScreenFadeRasters.Write(OutputScreenFadeRastersPNGFilename);
}
	
unsigned char OutBytes[32768];
void BASICFADE_GenerateScreenFadeBIN(char* InScreenFadeRastersPNGFilename, LPTSTR OutputScreenFadeRastersBINFilename)
{
	GPIMAGE InScreenFadeRasters(InScreenFadeRastersPNGFilename);

	int NumFramesForScreenFade = InScreenFadeRasters.Width;
	int Height = InScreenFadeRasters.Height;

	int CurrPos = 0;

	for (int Frame = 1; Frame < NumFramesForScreenFade; Frame++)
	{
		for (int y = 0; y < Height; y++)
		{
			unsigned char ThisCol = InScreenFadeRasters.GetPixelPaletteColour(Frame, y);
			unsigned char LastCol = InScreenFadeRasters.GetPixelPaletteColour(Frame - 1, y);
			if (ThisCol != LastCol)
			{
				OutBytes[CurrPos++] = y;
				OutBytes[CurrPos++] = ThisCol;
			}
		}
		OutBytes[CurrPos++] = 0xfe;
	}
	OutBytes[CurrPos - 1] = 0xff;
	WriteBinaryFile(OutputScreenFadeRastersBINFilename, OutBytes, CurrPos);
}

int BASICFADE_Main()
{
	BASICFADE_GenerateCurve(L"Link\\BASICFADE\\CurveTable.bin");

	BASICFADE_OutputSpriteUpdateASM(L"Build\\6502\\BASICFADE\\SpriteUpdate.asm");

	BASICFADE_GenerateTopBottomFadeASM(L"Build\\6502\\BASICFADE\\FadeCode.asm");
		
	BASICFADE_GenerateScreenFadePNG("Build\\6502\\BASICFADE\\ScreenFadeRasterWrites.png");
	BASICFADE_GenerateScreenFadeBIN("Build\\6502\\BASICFADE\\ScreenFadeRasterWrites.png", L"Link\\BASICFADE\\ScreenFadeRasterWrites.bin");

	return 0;
}
