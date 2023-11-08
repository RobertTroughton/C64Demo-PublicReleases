//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\CodeGen.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define IMAGE_WIDTH 320
#define IMAGE_HEIGHT 200

#define MAX_NUM_TEXTLINES 16
#define TOTAL_MAX_NUM_COLUMNS (32 * MAX_NUM_TEXTLINES)
#define TEXTLINE_HEIGHT 16

class
{
public:
	int MinColumn;
	int MaxColumn;
	int MinRow;
	int MaxRow;
} TextLineInfo[MAX_NUM_TEXTLINES];

void Quote_OutputTextLines(char* InputImagePNG, LPCTSTR OutputTextLinesASM)
{
	CImg<unsigned char> SrcImg(InputImagePNG);
	SrcImg.resize(IMAGE_WIDTH, IMAGE_HEIGHT);

	int ColourIndices[IMAGE_HEIGHT][IMAGE_WIDTH];
	memset(ColourIndices, -1, sizeof(ColourIndices));

	int Width = SrcImg.width();
	int Height = SrcImg.height();

	int NumTextLines = 0;
	unsigned int Colours[MAX_NUM_TEXTLINES];
	for (int YPos = 0; YPos < IMAGE_HEIGHT; YPos++)
	{
		int RowIndex = YPos / 8;
		for (int XPos = 0; XPos < IMAGE_WIDTH; XPos++)
		{
			int ColumnIndex = XPos / 8;

			unsigned char R = SrcImg(XPos, YPos, 0, 0);
			unsigned char G = SrcImg(XPos, YPos, 0, 1);
			unsigned char B = SrcImg(XPos, YPos, 0, 2);
			unsigned int ColourHere = (R << 16) | (G << 8) | (B << 0);

			if (!ColourHere) //; ignore black...
			{
				continue;
			}

			int FoundColourIndex = -1;
			for (int ColourIndex = 0; ColourIndex < NumTextLines; ColourIndex++)
			{
				if (Colours[ColourIndex] == ColourHere)
				{
					FoundColourIndex = ColourIndex;
					break;
				}
			}
			if (FoundColourIndex == -1)
			{
				if (NumTextLines < MAX_NUM_TEXTLINES)
				{
					FoundColourIndex = NumTextLines++;
					Colours[FoundColourIndex] = ColourHere;
					TextLineInfo[FoundColourIndex].MinColumn = ColumnIndex;
					TextLineInfo[FoundColourIndex].MaxColumn = ColumnIndex + 1;
					TextLineInfo[FoundColourIndex].MinRow = RowIndex;
					TextLineInfo[FoundColourIndex].MaxRow = RowIndex + 1;
				}
			}
			ColourIndices[YPos][XPos] = FoundColourIndex;

			TextLineInfo[FoundColourIndex].MinColumn = min(TextLineInfo[FoundColourIndex].MinColumn, ColumnIndex);
			TextLineInfo[FoundColourIndex].MaxColumn = max(TextLineInfo[FoundColourIndex].MaxColumn, ColumnIndex + 1);
			TextLineInfo[FoundColourIndex].MinRow = min(TextLineInfo[FoundColourIndex].MinRow, RowIndex);
			TextLineInfo[FoundColourIndex].MaxRow = max(TextLineInfo[FoundColourIndex].MaxRow, RowIndex + 1);
		}
	}


	int TotalNumColumns = 0;
	unsigned char TextLineData[TOTAL_MAX_NUM_COLUMNS][TEXTLINE_HEIGHT];
	ZeroMemory(TextLineData, sizeof(TextLineData));

	CodeGen code(OutputTextLinesASM);

	code.OutputCodeLine(NONE, fmt::format(".align 16"));

	for (int TextLineIndex = 0; TextLineIndex < NumTextLines; TextLineIndex++)
	{
		int MinColumn = TextLineInfo[TextLineIndex].MinColumn;
		int MaxColumn = TextLineInfo[TextLineIndex].MaxColumn;
		int MinRow = TextLineInfo[TextLineIndex].MinRow;
		int MaxRow = TextLineInfo[TextLineIndex].MaxRow;

		for (int ColumnIndex = MinColumn; ColumnIndex < MaxColumn; ColumnIndex++)
		{
			for (int YPixelPos = 0; YPixelPos < TEXTLINE_HEIGHT; YPixelPos++)
			{
				unsigned char ThisByte = 0;
				for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
				{
					int XPos = ColumnIndex * 8 + XPixelPos;
					int YPos = MinRow * 8 + YPixelPos;

					if (ColourIndices[YPos][XPos] == TextLineIndex)
					{
						ThisByte |= (0x80 >> XPixelPos);
					}
				}
				if (TotalNumColumns < TOTAL_MAX_NUM_COLUMNS)
				{
					TextLineData[TotalNumColumns][YPixelPos] = ThisByte;
				}
			}

			code.OutputCodeLine(NONE, fmt::format("QUOTE_TextLine{:02x}_Column{:02x}: .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
				TextLineIndex, ColumnIndex,
				TextLineData[TotalNumColumns][ 0],
				TextLineData[TotalNumColumns][ 1],
				TextLineData[TotalNumColumns][ 2],
				TextLineData[TotalNumColumns][ 3],
				TextLineData[TotalNumColumns][ 4],
				TextLineData[TotalNumColumns][ 5],
				TextLineData[TotalNumColumns][ 6],
				TextLineData[TotalNumColumns][ 7],
				TextLineData[TotalNumColumns][ 8],
				TextLineData[TotalNumColumns][ 9],
				TextLineData[TotalNumColumns][10],
				TextLineData[TotalNumColumns][11],
				TextLineData[TotalNumColumns][12],
				TextLineData[TotalNumColumns][13],
				TextLineData[TotalNumColumns][14],
				TextLineData[TotalNumColumns][15]
			));

			TotalNumColumns++;
		}
	}
	code.OutputBlankLine();

	for (int TextLineIndex = 0; TextLineIndex < NumTextLines; TextLineIndex++)
	{
		int MinColumn = TextLineInfo[TextLineIndex].MinColumn;
		int MaxColumn = TextLineInfo[TextLineIndex].MaxColumn;
		int NumColumns = MaxColumn - MinColumn;

		int MinRow = TextLineInfo[TextLineIndex].MinRow;

		int OutputOffset = (MinColumn * 8) + (MinRow * 40 * 8);

		code.OutputFunctionLine(fmt::format("Plot_TextLine{:d}", TextLineIndex));
		code.OutputCodeLine(NONE, fmt::format(".byte ${:02x}\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//; NumColumns", NumColumns));
		code.OutputCodeLine(NONE, fmt::format(".byte <(BitmapAddress + ${:04x}), >(BitmapAddress + ${:04x})\t\t\t//; OutputOffsetLo, OutputOffsetHi", OutputOffset, OutputOffset));
		code.OutputCodeLine(NONE, fmt::format(".byte <QUOTE_TextLine{:02x}_Column{:02x}, >QUOTE_TextLine{:02x}_Column{:02x}", TextLineIndex, MinColumn, TextLineIndex, MinColumn));

		code.OutputBlankLine();
	}

	code.OutputFunctionLine(fmt::format("QUOTE_PlotLinesLo"));
	for (int TextLineIndex = 0; TextLineIndex < NumTextLines; TextLineIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <Plot_TextLine{:d}", TextLineIndex));
	}
	code.OutputBlankLine();
	code.OutputFunctionLine(fmt::format("QUOTE_PlotLinesHi"));
	for (int TextLineIndex = 0; TextLineIndex < NumTextLines; TextLineIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >Plot_TextLine{:d}", TextLineIndex));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_MaskValues"));
	code.OutputCodeLine(NONE, fmt::format(".byte $c0, $f0, $fc, $ff"));
	code.OutputBlankLine();
	code.OutputFunctionLine(fmt::format("QUOTE_Add1Mod4"));
	code.OutputCodeLine(NONE, fmt::format(".byte 1, 2, 3, 0"));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_Plot"));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_PartFinishedDelay"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	code.OutputCodeLine(BEQ, fmt::format("QUOTE_FrameDelay"));
	code.OutputCodeLine(DEX);
	code.OutputCodeLine(STX_ABS, fmt::format("QUOTE_PartFinishedDelay + 1"));
	code.OutputCodeLine(BNE, fmt::format("QUOTE_ImmediateReturn"));
	code.OutputCodeLine(INC_ABS, fmt::format("Signal_CurrentEffectIsFinished"));
	code.OutputFunctionLine(fmt::format("QUOTE_ImmediateReturn"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_FrameDelay"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#35"));
	code.OutputCodeLine(BEQ, fmt::format("QUOTE_XPixel"));
	code.OutputCodeLine(DEX);
	code.OutputCodeLine(STX_ABS, fmt::format("QUOTE_FrameDelay + 1"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_XPixel"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	code.OutputCodeLine(LDA_ABX, fmt::format("QUOTE_MaskValues"));
	code.OutputCodeLine(STA_ZP, fmt::format("ZP_Mask"));
	code.OutputCodeLine(LDA_ABX, fmt::format("QUOTE_Add1Mod4"));
	code.OutputCodeLine(STA_ABS, fmt::format("QUOTE_XPixel + 1"));
	code.OutputBlankLine();

	code.OutputCodeLine(LDY_IMM, fmt::format("#$07"));
	code.OutputFunctionLine(fmt::format("PlotTLC_Loop"));
	code.OutputFunctionLine(fmt::format("PlotTLC_ReadPtr0"));
	code.OutputCodeLine(LDA_ABY, fmt::format("$ffff"));
	code.OutputCodeLine(AND_ZP, fmt::format("ZP_Mask"));
	code.OutputFunctionLine(fmt::format("PlotTLC_WritePtr0"));
	code.OutputCodeLine(STA_ABY, fmt::format("$ffff"));
	code.OutputFunctionLine(fmt::format("PlotTLC_ReadPtr1"));
	code.OutputCodeLine(LDA_ABY, fmt::format("$ffff"));
	code.OutputCodeLine(AND_ZP, fmt::format("ZP_Mask"));
	code.OutputFunctionLine(fmt::format("PlotTLC_WritePtr1"));
	code.OutputCodeLine(STA_ABY, fmt::format("$ffff"));
	code.OutputCodeLine(DEY);
	code.OutputCodeLine(BPL, fmt::format("PlotTLC_Loop"));
	code.OutputBlankLine();

	code.OutputCodeLine(NONE, fmt::format("//; Move to next column?"));
	code.OutputCodeLine(LDA_ABS, fmt::format("QUOTE_XPixel + 1"));
	code.OutputCodeLine(BEQ, fmt::format("QUOTE_NextColumn"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_NextColumn"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	code.OutputCodeLine(INX);
	code.OutputCodeLine(STX_ABS, fmt::format("QUOTE_NextColumn + 1"));
	code.OutputFunctionLine(fmt::format("QUOTE_NumColumns"));
	code.OutputCodeLine(CPX_IMM, fmt::format("#$00"));
	code.OutputCodeLine(BCC, fmt::format("QUOTE_MoveToNextColumn"));
	code.OutputCodeLine(JMP_ABS, fmt::format("QUOTE_Plot_NewLine"));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_MoveToNextColumn"));
	code.OutputCodeLine(CLC);
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_ReadPtr0 + 1"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$10"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr0 + 1"));
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_ReadPtr0 + 2"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr0 + 2"));
	code.OutputBlankLine();

	code.OutputCodeLine(CLC);
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_ReadPtr1 + 1"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$10"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr1 + 1"));
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_ReadPtr1 + 2"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr1 + 2"));
	code.OutputBlankLine();

	code.OutputCodeLine(CLC);
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_WritePtr0 + 1"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$08"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr0 + 1"));
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_WritePtr0 + 2"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr0 + 2"));
	code.OutputBlankLine();

	code.OutputCodeLine(CLC);
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_WritePtr1 + 1"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$08"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr1 + 1"));
	code.OutputCodeLine(LDA_ABS, fmt::format("PlotTLC_WritePtr1 + 2"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr1 + 2"));
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_MorePixelsToDo"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_Plot_NewLine"));
	code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
	code.OutputCodeLine(CPX_IMM, fmt::format("#10"));
	code.OutputCodeLine(BNE, fmt::format("QUOTE_NotFinished"));

	code.OutputCodeLine(LDA_IMM, fmt::format("#50"));
	code.OutputCodeLine(STA_ABS, fmt::format("QUOTE_PartFinishedDelay + 1"));
	code.OutputCodeLine(RTS);
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("QUOTE_NotFinished"));
	code.OutputCodeLine(LDA_ABX, fmt::format("QUOTE_PlotLinesLo"));
	code.OutputCodeLine(STA_ABS, fmt::format("ZP_PlotLineData + 0"));
	code.OutputCodeLine(LDA_ABX, fmt::format("QUOTE_PlotLinesHi"));
	code.OutputCodeLine(STA_ABS, fmt::format("ZP_PlotLineData + 1"));
	code.OutputBlankLine();

	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputCodeLine(LDA_IZY, fmt::format("ZP_PlotLineData"));
	code.OutputCodeLine(STA_ABS, fmt::format("QUOTE_NumColumns + 1"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("QUOTE_NextColumn + 1"));
	code.OutputBlankLine();
	code.OutputCodeLine(LDA_IZY, fmt::format("ZP_PlotLineData"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr0 + 1"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(CLC);
	code.OutputCodeLine(ADC_IMM, fmt::format("#$40"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr1 + 1"));
	code.OutputCodeLine(LDA_IZY, fmt::format("ZP_PlotLineData"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr0 + 2"));
	code.OutputCodeLine(ADC_IMM, fmt::format("#$01"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_WritePtr1 + 2"));
	code.OutputBlankLine();
	code.OutputCodeLine(INY);
	code.OutputCodeLine(LDA_IZY, fmt::format("ZP_PlotLineData"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr0 + 1"));
	code.OutputCodeLine(ORA_IMM, fmt::format("#$08"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr1 + 1"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(LDA_IZY, fmt::format("ZP_PlotLineData"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr0 + 2"));
	code.OutputCodeLine(STA_ABS, fmt::format("PlotTLC_ReadPtr1 + 2"));
	code.OutputBlankLine();

	code.OutputCodeLine(INX);
	code.OutputCodeLine(STX_ABS, fmt::format("QUOTE_Plot_NewLine + 1"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#35"));
	code.OutputCodeLine(STA_ABS, fmt::format("QUOTE_FrameDelay + 1"));

	code.OutputCodeLine(RTS);
}

int Quote_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\Quote");

	Quote_OutputTextLines("..\\..\\Build\\Parts\\Quote\\Data\\Quote.png", L"..\\..\\Intermediate\\Built\\Quote\\TextLines.asm");

	return 0;
}

