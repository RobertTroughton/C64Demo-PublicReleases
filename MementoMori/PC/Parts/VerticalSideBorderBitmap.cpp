//; (c) 2018-2020, Genesis*Project

#include <atlstr.h>
#include <vector>
#include <io.h>

#include "..\Common\Common.h"

//;static const int SpriteStartY = 49;
static const int COPY_STRIDE = 15;	//; FASTERSCROLL: 15/16;
static const int SPRITE_YSTART_OFFSET = 5;

static const int NUM_STREAM_BUFFERS = 4;
static const int STREAM_BUFFER_BLOCKHEIGHT = 4;
static const int STREAM_BUFFER_SPRITEDATA_STRIDE = 11;

static const int BitmapMAP_Stride = 320;
static const int BitmapSCR_Stride = 40;
static const int BitmapCOL_Stride = 20;
static const int SpriteMAP_Stride = STREAM_BUFFER_SPRITEDATA_STRIDE * 8;

static const int BitmapMAP_BlockStride = BitmapMAP_Stride * STREAM_BUFFER_BLOCKHEIGHT;
static const int BitmapSCR_BlockStride = BitmapSCR_Stride * STREAM_BUFFER_BLOCKHEIGHT;
static const int BitmapCOL_BlockStride = BitmapCOL_Stride * STREAM_BUFFER_BLOCKHEIGHT;
static const int SpriteMAP_BlockStride = SpriteMAP_Stride * STREAM_BUFFER_BLOCKHEIGHT;

static const int BitmapMAP_StreamSize = BitmapMAP_BlockStride * 2;
static const int BitmapSCR_StreamSize = BitmapSCR_BlockStride * 2;
static const int BitmapCOL_StreamSize = BitmapCOL_BlockStride * 2;
static const int SpriteMAP_StreamSize = SpriteMAP_BlockStride * 2;

static const int BitmapCOL_OffsetToData = 0;
static const int BitmapMAP_OffsetToData = BitmapCOL_OffsetToData + BitmapCOL_StreamSize;
static const int BitmapSCR_OffsetToData = BitmapMAP_OffsetToData + BitmapMAP_StreamSize;
static const int SpriteMAP_OffsetToData = BitmapSCR_OffsetToData + BitmapSCR_StreamSize;

static int DoubleStreamBuffers[2] = {0xD000, 0x9000};

static int GLOB_OperationMode = -1;

int SpriteData_BitmapLineToSpriteLine[208][2];

int SpriteIndices[4] = { 4, 5, 6, 7 };

static int LoadStoreStage = 0;


bool VSBB_InsertSpriteScrollCode(CodeGen& code, int& NumCyclesToUse, bool bFirstPass)
{
	static bool bFinishedEverything = false;
	static int CurrentYPos = 0;	//; [0, 192)

	if (bFirstPass)
	{
		bFinishedEverything = false;
		CurrentYPos = SPRITE_YSTART_OFFSET;

		if (!EnoughFreeCycles(NumCyclesToUse, 3, false))
			return bFinishedEverything;

		SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDX_ZP, fmt::format("ZP_SpriteDataIndex")));
	}

	bool bFinishedThisTime = bFinishedEverything;
	while (!bFinishedThisTime)
	{
		if (CurrentYPos < (192 + SPRITE_YSTART_OFFSET))
		{
			int SrcLine = SpriteData_BitmapLineToSpriteLine[CurrentYPos + 8][0];
			int DstLine0 = SpriteData_BitmapLineToSpriteLine[CurrentYPos + 0][0];
			int DstLine1 = SpriteData_BitmapLineToSpriteLine[CurrentYPos + 0][1];

			int SrcSpriteIndex = (SrcLine / 21) * 4;
			int SrcSpriteDataOffset = (SrcSpriteIndex * 64) + ((SrcLine % 21) * 3);

			int DstSpriteIndex0 = (DstLine0 / 21) * 4;
			int DstSpriteDataOffset0 = (DstSpriteIndex0 * 64) + ((DstLine0 % 21) * 3);

			int DstSpriteIndex1 = (DstLine1 / 21) * 4;
			int DstSpriteDataOffset1 = (DstSpriteIndex1 * 64) + ((DstLine1 % 21) * 3);

			if (DstLine1 >= 0)
			{
				if (LoadStoreStage == 0)
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 4, false))
						return bFinishedEverything;
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("SpriteDataAddress{:d} + ${:04x}", GLOB_OperationMode, SrcSpriteDataOffset)));
					LoadStoreStage = 1;
				}
				if (LoadStoreStage == 1)
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 10, false))
						return bFinishedEverything;
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABX, fmt::format("SpriteDataAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, DstSpriteDataOffset0)));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABX, fmt::format("SpriteDataAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, DstSpriteDataOffset1)));
					CurrentYPos++;
					LoadStoreStage = 0;
				}
			}
			else
			{
				if (LoadStoreStage == 0)
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 4, false))
						return bFinishedEverything;
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("SpriteDataAddress{:d} + ${:04x}", GLOB_OperationMode, SrcSpriteDataOffset)));
					LoadStoreStage = 1;
				}
				if (LoadStoreStage == 1)
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 5, false))
						return bFinishedEverything;
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABX, fmt::format("SpriteDataAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, DstSpriteDataOffset0)));
					CurrentYPos++;
					LoadStoreStage = 0;
				}
			}
		}
		if (CurrentYPos == (192 + SPRITE_YSTART_OFFSET))
		{
			bFinishedEverything = true;
			bFinishedThisTime = true;
		}
	}
	return bFinishedEverything;
}

bool VSBB_InsertBitmapScrollCode(CodeGen& code, int& NumCyclesToUse, bool bFirstPass)
{
	static bool bFinishedEverything = false;
	static int CurrentCopyPos = 0;
	static int CurrentCopyMode = 0;

	if (bFirstPass)
	{
		bFinishedEverything = false;
		CurrentCopyPos = 0;
		CurrentCopyMode = 0;
		LoadStoreStage = 0;
	}

	bool bFinishedThisTime = bFinishedEverything;
	while (!bFinishedThisTime)
	{
		if (GLOB_OperationMode < 2)
		{
			if (CurrentCopyMode == 0)
			{
				int StartSrcOffset = CurrentCopyPos + 320;
				int EndSrcOffset = StartSrcOffset + COPY_STRIDE - 1;
				int StartDstOffset = CurrentCopyPos;

				if ((StartSrcOffset & 255) == 255)
				{
					CurrentCopyPos ++;
				}
				else
				{
					if (EndSrcOffset >= (320 * 25))
					{
						int DistanceOver = (EndSrcOffset + 1) - (320 * 25);
						StartSrcOffset -= DistanceOver;
						EndSrcOffset -= DistanceOver;
						StartDstOffset -= DistanceOver;
						CurrentCopyPos -= DistanceOver;
					}

					int Page_StartSrcOffset = StartSrcOffset / 256;
					int Page_EndSrcOffset = EndSrcOffset / 256;

					if (Page_StartSrcOffset != Page_EndSrcOffset)//; will the LDA,x be variant for cycles..?
					{
						int DistanceOver = (EndSrcOffset + 1) % 256;

						StartSrcOffset -= DistanceOver;
						StartDstOffset -= DistanceOver;
						CurrentCopyPos -= DistanceOver;
					}

					if (LoadStoreStage == 0)
					{
						if (!EnoughFreeCycles(NumCyclesToUse, 4, false))
							return bFinishedEverything;
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("BitmapAddress{:d} + ${:04x}", GLOB_OperationMode, StartSrcOffset)));
						LoadStoreStage = 1;
					}
					if (LoadStoreStage == 1)
					{
						if (!EnoughFreeCycles(NumCyclesToUse, 5, false))
							return bFinishedEverything;
						SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABX, fmt::format("BitmapAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, StartDstOffset)));
						CurrentCopyPos += COPY_STRIDE;
						LoadStoreStage = 0;
					}
				}

				if (CurrentCopyPos >= (8000 - 320))
				{
					CurrentCopyMode++;
					CurrentCopyPos = 0;
				}
			}
			if (CurrentCopyMode == 1)
			{
				int StartSrcOffset = CurrentCopyPos + 40;
				int EndSrcOffset = StartSrcOffset + COPY_STRIDE - 1;
				int Page_StartSrcOffset = StartSrcOffset / 256;
				int Page_EndSrcOffset = EndSrcOffset / 256;

				int StartDstOffset = CurrentCopyPos;
				int Page_StartDstOffset = StartDstOffset / 256;

				if (Page_StartSrcOffset != Page_EndSrcOffset) //; will the LDA,x be variant for cycles..?
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 8, false))
						return bFinishedEverything;

					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABS, fmt::format("ScreenAddress{:d} + ${:04x}", GLOB_OperationMode, StartSrcOffset)));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, StartDstOffset)));
					CurrentCopyPos++;
				}
				else
				{
					if (!EnoughFreeCycles(NumCyclesToUse, 9, false))
						return bFinishedEverything;
	
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABX, fmt::format("ScreenAddress{:d} + ${:04x}", GLOB_OperationMode, StartSrcOffset)));
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABX, fmt::format("ScreenAddress{:d} + ${:04x}", 1 - GLOB_OperationMode, StartDstOffset)));
					CurrentCopyPos += COPY_STRIDE;
				}


				if (CurrentCopyPos >= (1000 - 40))
				{
					bFinishedThisTime = true;
					bFinishedEverything = true;
				}
				else
				{
					if ((CurrentCopyPos + 40 + COPY_STRIDE) > 1000)
					{
						CurrentCopyPos = 1000 - (40 + COPY_STRIDE);
					}
				}
			}
		}
		else
		{
			if (LoadStoreStage == 0)
			{
				if (!EnoughFreeCycles(NumCyclesToUse, 4, false))
					return bFinishedEverything;
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABS, fmt::format("VIC_ColourMemory + ${:04x}", CurrentCopyPos + 40)));
				LoadStoreStage = 1;
			}
			if (LoadStoreStage == 1)
			{
				if (!EnoughFreeCycles(NumCyclesToUse, 4, false))
					return bFinishedEverything;
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ${:04x}", CurrentCopyPos)));
				LoadStoreStage = 0;

				CurrentCopyPos++;
				if (CurrentCopyPos == 960)
				{
					bFinishedThisTime = true;
					bFinishedEverything = true;
				}
			}
		}
	}

	return bFinishedEverything;
}

int VSBB_UseCycles(CodeGen& code, int NumCycles, bool bFirstPass, bool bCanInsertCode)
{
	int NumCyclesRemaining = NumCycles;

	static bool bFinishedBitmapScrollCode = false;
	static bool bFinishedSpriteScrollCode = false;
	static bool bBitmapScrollFirstPass = false;
	static bool bSpriteScrollFirstPass = false;
	if (bFirstPass)
	{
		bFinishedBitmapScrollCode = false;
		bFinishedSpriteScrollCode = false;
		bBitmapScrollFirstPass = true;
		bSpriteScrollFirstPass = true;
	}
	if (bCanInsertCode)
	{
		if (!bFinishedBitmapScrollCode)
		{
			bFinishedBitmapScrollCode = VSBB_InsertBitmapScrollCode(code, NumCyclesRemaining, bBitmapScrollFirstPass);
			if (bBitmapScrollFirstPass)
			{
				bBitmapScrollFirstPass = false;
			}
		}
		if (bFinishedBitmapScrollCode)
		{
			if ((!bFinishedSpriteScrollCode) && (GLOB_OperationMode < 2))
			{
				bFinishedSpriteScrollCode = VSBB_InsertSpriteScrollCode(code, NumCyclesRemaining, bSpriteScrollFirstPass);
				if (bSpriteScrollFirstPass)
				{
					bSpriteScrollFirstPass = false;
				}
			}
		}
	}

	NumCyclesRemaining = code.WasteCycles(NumCyclesRemaining);

	return NumCyclesRemaining;
}

int Num_D016_38Cols_Loads = 0;
int Num_D016_40Cols_Loads = 0;
int Num_D016_IndexedSTAs = 0;
void VSBB_GenerateCode(LPTSTR Filename, int OperationMode)
{
	GLOB_OperationMode = OperationMode;

	CodeGen code(Filename);

	VSBB_UseCycles(code, 0, true, false);	//; init UseCycles code

	code.OutputFunctionLine(fmt::format("IRQ_MainCall_{:d}", OperationMode));
	code.OutputBlankLine();

	if (OperationMode < 2)
	{
		code.OutputCodeLine(LDX_ZP, fmt::format("ZP_BitmapUpdateDSTIndex"));
	}

	int NumCycles = OperationMode < 2 ? 110 : 113;
	NumCycles = VSBB_UseCycles(code, NumCycles, false, (OperationMode != 2));

	if (OperationMode < 2)
	{
		if (NumCycles > 0)
		{
			code.OutputCodeLine(LDY_ZP, fmt::format("ZP_D016_40Rows"));
		}
		else
		{
			code.OutputFunctionLine(fmt::format("D016_40Cols_Load_{:d}", Num_D016_40Cols_Loads++));
			code.OutputCodeLine(LDY_IMM, fmt::format("#D016_Value_40Rows_MC"));
		}
		code.OutputCodeLine(DEC_ABS, fmt::format("VIC_D016"));
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
	}
	else
	{
		code.OutputFunctionLine(fmt::format("D016_40Cols_Load_{:d}", Num_D016_40Cols_Loads++));
		code.OutputCodeLine(LDY_IMM, fmt::format("#D016_Value_40Rows_MC"));
		code.OutputFunctionLine(fmt::format("D016_38Cols_Load_{:d}", Num_D016_38Cols_Loads++));
		code.OutputCodeLine(LDX_IMM, fmt::format("#D016_Value_38Rows_MC"));
		code.OutputCodeLine(STX_ABS, fmt::format("VIC_D016"));
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
	}
	code.OutputBlankLine();

	int CurrentSpriteRow = 1;
	int CurrentSpriteYVal = 0;

	int UpdateSpriteVals = 0;
	for (int IndexLine = 0; IndexLine < 208; IndexLine++)
	{
		int RasterLine = IndexLine + 50;
		bool bIsBadLine = ((RasterLine < 250) && ((RasterLine & 7) == 7));

		int NextRasterLine = RasterLine + 1;
		bool bNextIsBadLine = ((NextRasterLine < 250) && ((NextRasterLine & 7) == 7));

		code.OutputCommentLine(fmt::format("//; Line ${:02x}", RasterLine));

		if (bIsBadLine)
		{
			code.OutputFunctionLine(fmt::format("D016_IndexedSTA_{:d}", Num_D016_IndexedSTAs++));
			code.OutputCodeLine(STA_ABY, fmt::format("VIC_D016 - D016_Value_40Rows_MC"));
			code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
			code.OutputBlankLine();
			continue;
		}

		int NumCyclesToUse = 42;
		if ((OperationMode == 2) && (!bNextIsBadLine))
		{
			NumCyclesToUse += 2;
		}

		if ((IndexLine > 0) && ((IndexLine % 20) == 19))
		{
			UpdateSpriteVals = 2;
		}

		if ((RasterLine > (CurrentSpriteYVal + 48 + 6)) && (EnoughFreeCycles(NumCyclesToUse, 4 + 2 + 2 + 4 * 5, false)))
		{
			CurrentSpriteYVal += 21;
			if (CurrentSpriteYVal < (21 * 10))
			{
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABS, fmt::format("SpriteStartY")));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(CLC));
				SubtractCycles(NumCyclesToUse, code.OutputCodeLine(ADC_IMM, fmt::format("#({:d} * 21)", CurrentSpriteYVal / 21)));

				for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
				{
					SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite0Y + ({:d} * 2)", SpriteIndices[SpriteIndex])));
				}

				LoadStoreStage = 0; //; we've broken A - so we need to force another LDA of the data if one was done hoping to carry...
			}
		}

		if (UpdateSpriteVals > 0)
		{
			NumCyclesToUse -= 24;
		}

		bool bCanInsertCode = ((OperationMode != 2) || (RasterLine >= 55));
		NumCyclesToUse = VSBB_UseCycles(code, NumCyclesToUse, false, bCanInsertCode);
		code.OutputBlankLine();

		if (UpdateSpriteVals > 0)
		{
			int UpdateBank;
			if (OperationMode < 2)
			{
				UpdateSpriteVals = 0;
				UpdateBank = OperationMode;
			}
			else
			{
				UpdateSpriteVals--;
				UpdateBank = UpdateSpriteVals;
			}
			for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", (CurrentSpriteRow * 4) + SpriteIndex));
				code.OutputCodeLine(STA_ABS, fmt::format("SpriteVals{:d} + {:d}", UpdateBank, SpriteIndices[SpriteIndex]));

				LoadStoreStage = 0; //; we've broken A - so we need to force another LDA of the data if one was done hoping to carry...
			}
			if (!UpdateSpriteVals)
			{
				CurrentSpriteRow++;
			}
		}

		if (bNextIsBadLine)
		{
			if (NumCyclesToUse == 1)
			{
				code.OutputCodeLine(LDA_ZP, fmt::format("ZP_D016_38Rows"));
			}
			else
			{
				code.OutputFunctionLine(fmt::format("D016_38Cols_Load_{:d}", Num_D016_38Cols_Loads++));
				code.OutputCodeLine(LDA_IMM, fmt::format("#D016_Value_38Rows_MC"));
			}
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
			LoadStoreStage = 0; //; we've broken A - so we need to force another LDA of the data if one was done hoping to carry...
		}
		else
		{
			if (OperationMode != 2)
			{
				if (NumCyclesToUse == 1)
				{
					code.OutputCodeLine(LDA_ZP, fmt::format("ZP_D016_38Rows"));
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
					LoadStoreStage = 0;
				}
				else
				{
					code.OutputCodeLine(DEC_ABS, fmt::format("VIC_D016"));
				}
			}
			else
			{
				code.OutputCodeLine(STX_ABS, fmt::format("VIC_D016"));
			}
		}
		code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
		code.OutputBlankLine();
	}

	//; Early exit the sprite data stuff if we can...
	if (OperationMode < 2)
	{
		code.OutputCodeLine(CPX_IMM, fmt::format("#((64 * 3) + 2)"));
		code.OutputCodeLine(BEQ, fmt::format("FinishedAllOfThis_{:d}", OperationMode));
	}

	VSBB_UseCycles(code, -1, false, true);	//; finish off with whatever is left...

	if (OperationMode == 2)
	{
		code.OutputCodeLine(JMP_ABS, fmt::format("CopySingleBitmapDatas"));
	}
	else
	{
		code.OutputFunctionLine(fmt::format("FinishedAllOfThis_{:d}", OperationMode));
		code.OutputCodeLine(RTS);
	}

	code.OutputBlankLine();

	if (OperationMode == 0)
	{
		code.OutputFunctionLine(fmt::format("SetInitialSpriteSettings"));
		for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite0Y + ({:d} * 2)", SpriteIndices[SpriteIndex]));
		}
		code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
		for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			code.OutputCodeLine(STX_ABS, fmt::format("SpriteVals0 + {:d}", SpriteIndices[SpriteIndex]));
			code.OutputCodeLine(STX_ABS, fmt::format("SpriteVals1 + {:d}", SpriteIndices[SpriteIndex]));
			code.OutputCodeLine(INX);
		}
		code.OutputBlankLine();
		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
}

void VSBB_GeneratePatchCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	code.OutputFunctionLine(fmt::format("PatchD016Code"));
	for (int Index = 0; Index < Num_D016_38Cols_Loads; Index++)
	{
		code.OutputCodeLine(STX_ABS, fmt::format("D016_38Cols_Load_{:d} + 1", Index));
	}
	for (int Index = 0; Index < Num_D016_40Cols_Loads; Index++)
	{
		code.OutputCodeLine(STY_ABS, fmt::format("D016_40Cols_Load_{:d} + 1", Index));
	}
	for (int Index = 0; Index < Num_D016_IndexedSTAs; Index++)
	{
		code.OutputCodeLine(STA_ABS, fmt::format("D016_IndexedSTA_{:d} + 1", Index));
	}
	code.OutputCodeLine(RTS);
}

//; Sprite Reorder Function:
//;  Row 0: SpriteLine  0 = ImageLine  0 ... SpriteLine [1,...,20] = ImageLine[1,...,20] (ie. SpriteLine [0,...,20] = ImageLine[0,...,20]
//;  Row 1: SpriteLine 20 = ImageLine 20 ... SpriteLine [0,...,19] = ImageLine[21,...,40]
//;  Row 2: SpriteLine 19 = ImageLine 40 ... SpriteLine [20, 0, ..., 18] = ImageLine[41,...,60]
//;  Row 3: SpriteLine 18 = ImageLine 60 ... SpriteLine [19, 20, 0, ..., 17] = ImageLine[61,...,80]
//;  ...

void GenerateSpriteData(void)
{
	memset(SpriteData_BitmapLineToSpriteLine, 0xff, sizeof(SpriteData_BitmapLineToSpriteLine));

	for (int LineBlock = 0; LineBlock < 11; LineBlock++)
	{
		int SpriteStartLine = (0 + 21 - LineBlock) % 21;
		int SourceStartLine = LineBlock * 20;
		for (int LineOf21 = 0; LineOf21 < 21; LineOf21++)
		{
			int SpriteLine = ((SpriteStartLine + LineOf21) % 21) + LineBlock * 21;
			int SourceLine = SourceStartLine + LineOf21;

			if (SourceLine < 208)
			{
				int Index = 0;
				if (SpriteData_BitmapLineToSpriteLine[SourceLine][0] >= 0)
					Index = 1;

				SpriteData_BitmapLineToSpriteLine[SourceLine][Index] = SpriteLine;
			}
		}
	}
}

void ConvertTallBitmapToSpriteStreamData(GPIMAGE& ImgBitmap, LPTSTR OutputFilename, bool bMulticolour, unsigned char Colour0, unsigned char Colour1, unsigned char Colour2, unsigned char Colour3)
{
	int Width = ImgBitmap.Width;
	int Height = ImgBitmap.Height;

	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	unsigned char FixedColours[4] = {
		Colour0,
		Colour1,
		Colour2,
		Colour3
	};

	int SizePackedData = CharHeight * CharWidth * 8;
	unsigned char* PackedData = new unsigned char[SizePackedData];

	for (int YCharPos = 0; YCharPos < CharHeight; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < CharWidth; XCharPos++)
		{
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = (YCharPos * 8) + YPixel;
				unsigned char OutByte = 0;
				if (bMulticolour)
				{
					for (int XPixel = 0; XPixel < 8; XPixel += 2)
					{
						int XPos = (XCharPos * 8) + XPixel;

						unsigned char C64Colour = ImgBitmap.GetPixelPaletteColour(XPos, YPos);

						unsigned int C64ValueUsed = 0xff;
						for (unsigned int PaletteIndex = 0; PaletteIndex < 4; PaletteIndex++)
						{
							if (C64Colour == FixedColours[PaletteIndex])
							{
								C64ValueUsed = PaletteIndex;
								break;
							}
						}

						if (C64ValueUsed == 0xff)
						{
							C64ValueUsed = 0;
						}
						OutByte |= (C64ValueUsed << (6 - XPixel));
					}
				}
				else
				{
					for (int XPixel = 0; XPixel < 8; XPixel ++)
					{
						int XPos = (XCharPos * 8) + XPixel;

						if (ImgBitmap.GetPixel(XPos, YPos) == 0x00000000)
						{
							OutByte |= 1 << (7 - XPixel);
						}
					}
				}
				PackedData[((YCharPos * CharWidth) + XCharPos) * 8 + YPixel] = OutByte;
			}
		}
	}
	WriteBinaryFile(OutputFilename, PackedData, SizePackedData);

	delete[] PackedData;
}

void ConvertTallBitmapToSpriteStreamData(char* BitmapFilename, LPTSTR OutputFilename, bool bMulticolour, unsigned char Colour0, unsigned char Colour1, unsigned char Colour2, unsigned char Colour3)
{
	GPIMAGE ImgBitmap(BitmapFilename);

	ConvertTallBitmapToSpriteStreamData(ImgBitmap, OutputFilename, bMulticolour, Colour0, Colour1, Colour2, Colour3);
}

void MergeBitmapAndSpriteStreamData(LPTSTR BitmapStreamFilename1, LPTSTR BitmapStreamFilename2, LPTSTR SpriteStreamFilename1, LPTSTR SpriteStreamFilename2, LPTSTR OutputMergedStreamDataFilename, LPTSTR OutputD800DataFilename, LPTSTR OutputSLSMainFilename, LPTSTR OutputSLSPartFilename)
{
	int CharHeight1 = 1600 / 8;
	int CharHeight2 = 1152 / 8;
	int CharHeight = CharHeight1 + CharHeight2;
	int BlockHeight = STREAM_BUFFER_BLOCKHEIGHT;
	int NumBlocks = CharHeight / BlockHeight;

	int BitmapStreamLineSize = 320 + 40 + 40;
	int BitmapStreamDataSize1 = CharHeight1 * BitmapStreamLineSize;
	int BitmapStreamDataSize2 = CharHeight2 * BitmapStreamLineSize;
	int BitmapStreamDataSize = BitmapStreamDataSize1 + BitmapStreamDataSize2;
	unsigned char* BitmapStreamData = new unsigned char [BitmapStreamDataSize];
	ReadBinaryFile(BitmapStreamFilename1, &BitmapStreamData[0], BitmapStreamDataSize1);
	ReadBinaryFile(BitmapStreamFilename2, &BitmapStreamData[BitmapStreamDataSize1], BitmapStreamDataSize2);

	int SpriteStreamLineSizeSRC = 12 * 8;
	int SpriteStreamDataSizeSRC1 = CharHeight1 * SpriteStreamLineSizeSRC;
	int SpriteStreamDataSizeSRC2 = CharHeight2 * SpriteStreamLineSizeSRC;
	int SpriteStreamDataSizeSRC = SpriteStreamDataSizeSRC1 + SpriteStreamDataSizeSRC2;
	int SpriteStreamLineSizeDST = SpriteMAP_Stride;
	int SpriteStreamDataSizeDST = CharHeight * SpriteStreamLineSizeDST;
	unsigned char* SpriteStreamData = new unsigned char [SpriteStreamDataSizeSRC];
	ReadBinaryFile(SpriteStreamFilename1, &SpriteStreamData[0], SpriteStreamDataSizeSRC1);
	ReadBinaryFile(SpriteStreamFilename2, &SpriteStreamData[SpriteStreamDataSizeSRC1], SpriteStreamDataSizeSRC2);

	int MergedStreamLineSize = BitmapStreamLineSize + SpriteStreamLineSizeDST - 40 + 20; //; HACK to convert colour data to 2-cols per byte
	int MergedStreamDoubleBlockSize = (MergedStreamLineSize * BlockHeight) * 2;
	int MergedStreamDataSize = MergedStreamDoubleBlockSize * (NumBlocks / 2);

	unsigned char* MergedStreamData = new unsigned char[MergedStreamDataSize];

	CodeGen codeMain(OutputSLSMainFilename, false);
	CodeGen codePart(OutputSLSPartFilename, false);

	unsigned int DoubleStreamBufferIndex = 0;
	for (int Repeats = 0; Repeats < 1; Repeats++)
	{
		int MergedDataOffset = 0;
		for (int BlockIndex = 0; BlockIndex < NumBlocks / 2; BlockIndex++)
		{
			int LoadAddress = DoubleStreamBuffers[DoubleStreamBufferIndex];
			bool bLoadUnderROM = (LoadAddress == 0xD000);
			if (Repeats == 0)
			{
				if (bLoadUnderROM)
				{
					codeMain.OutputCommentLine(fmt::format("File:\t\t..\\Parts\\VerticalSideBorderBitmap\\StreamData.bin*\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
				}
				else
				{
					codeMain.OutputCommentLine(fmt::format("File:\t\t..\\Parts\\VerticalSideBorderBitmap\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
				}
			}
			if (bLoadUnderROM)
			{
				codePart.OutputCommentLine(fmt::format("File:\t\tStreamData.bin*\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
			}
			else
			{
				codePart.OutputCommentLine(fmt::format("File:\t\tStreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
			}

			MergedDataOffset += MergedStreamDoubleBlockSize;
			DoubleStreamBufferIndex = (DoubleStreamBufferIndex + 1) % 2;

			//;if ((Repeats > 0) || (BlockIndex >= ((NUM_STREAM_BUFFERS / 2) - 1)))
			//; {
			if (Repeats == 0)
			{
				codeMain.OutputBlankLine();
			}
			codePart.OutputBlankLine();
			//;}
		}
		//; Repeat the last 3 stream data blocks of the MC bitmap
		MergedDataOffset = MergedStreamDoubleBlockSize * 22;
		for (int BlockIndex = 22; BlockIndex < 25; BlockIndex++)
		{
			int LoadAddress = DoubleStreamBuffers[DoubleStreamBufferIndex];
			bool bLoadUnderROM = (LoadAddress == 0xD000);
				if (Repeats == 0)
				{
					if (bLoadUnderROM)
					{
						codeMain.OutputCommentLine(fmt::format("File:\t\t..\\Parts\\VerticalSideBorderBitmap\\StreamData.bin*\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
					}
					else
					{
						codeMain.OutputCommentLine(fmt::format("File:\t\t..\\Parts\\VerticalSideBorderBitmap\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
					}
				}
			if (bLoadUnderROM)
			{
				codePart.OutputCommentLine(fmt::format("File:\t\tStreamData.bin*\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
			}
			else
			{
				codePart.OutputCommentLine(fmt::format("File:\t\tStreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, MergedDataOffset, MergedStreamDoubleBlockSize));
			}

			MergedDataOffset += MergedStreamDoubleBlockSize;
			DoubleStreamBufferIndex = (DoubleStreamBufferIndex + 1) % 2;

			//;if ((Repeats > 0) || (BlockIndex >= ((NUM_STREAM_BUFFERS / 2) - 1)))
			//; {
			if (Repeats == 0)
			{
				codeMain.OutputBlankLine();
			}
			codePart.OutputBlankLine();

		}
	}

	for (int YBlock = 0; YBlock < NumBlocks; YBlock++)
	{
		//; Sparkle fills data backwards .. so to ensure we get our blocks in the right order
		//;  we flip them here... giving a 1-0-3-2 order instead of 0-1-2-3
		int YBlockPair = YBlock / 2;
		int YPairIndex_Sparkle = 1 - (YBlock & 1);

		for (int Index = 0; Index < BitmapStreamLineSize; Index++)
		{
			for (int YIndex = 0; YIndex < BlockHeight; YIndex++)
			{
				int YChar = YBlock * BlockHeight + YIndex;

				int SRCBitmapOffset = BitmapStreamLineSize * YChar + Index;
				if (Index >= (BitmapStreamLineSize - 40))		//; COL
				{
					unsigned char Colour = BitmapStreamData[SRCBitmapOffset];

					int DSTIndex = (Index - (BitmapStreamLineSize - 40)) / 2;
					int DSTOffset = BitmapCOL_OffsetToData + YBlockPair * MergedStreamDoubleBlockSize + ((YPairIndex_Sparkle * BlockHeight) + YIndex) * BitmapCOL_Stride + DSTIndex;
					if ((Index & 1) == 0)
					{
						MergedStreamData[DSTOffset] = Colour;
					}
					else
					{
						MergedStreamData[DSTOffset] |= (Colour << 4);
					}
				}
				else
				{
					if (Index >= (BitmapStreamLineSize - 80))			//; SCR
					{
						int DSTIndex = Index - (BitmapStreamLineSize - 80);
						int DSTOffset = BitmapSCR_OffsetToData + YBlockPair * MergedStreamDoubleBlockSize + ((YPairIndex_Sparkle * BlockHeight) + YIndex) * BitmapSCR_Stride + DSTIndex;
						MergedStreamData[DSTOffset] = BitmapStreamData[SRCBitmapOffset];
					}
					else											//; MAP
					{
						int DSTIndex = Index;
						int DSTOffset = BitmapMAP_OffsetToData + YBlockPair * MergedStreamDoubleBlockSize + (YPairIndex_Sparkle * BlockHeight) * BitmapMAP_Stride + (DSTIndex * BlockHeight) + YIndex;
						MergedStreamData[DSTOffset] = BitmapStreamData[SRCBitmapOffset];
					}
				}
			}
		}
		for (int Index = 0; Index < SpriteStreamLineSizeDST; Index++)
		{
			for (int YIndex = 0; YIndex < BlockHeight; YIndex++)
			{
				int YChar = YBlock * BlockHeight + YIndex;

				int SpriteYPixel = Index % 8;
				int SpriteXChar = Index / 8;
				int DSTIndex = (SpriteYPixel * STREAM_BUFFER_SPRITEDATA_STRIDE) + SpriteXChar;

				int SRCSpriteOffset = SpriteStreamLineSizeSRC * YChar + Index;

				int DSTOffset = SpriteMAP_OffsetToData + YBlockPair * MergedStreamDoubleBlockSize + (YPairIndex_Sparkle * BlockHeight) * SpriteMAP_Stride + DSTIndex * BlockHeight + YIndex;
				MergedStreamData[DSTOffset] = SpriteStreamData[SRCSpriteOffset];
			}
		}
	}
	WriteBinaryFile(OutputMergedStreamDataFilename, MergedStreamData, MergedStreamDataSize);
//;	WriteBinaryFile(OutputD800DataFilename, D800Data, 4096);

	delete[] BitmapStreamData;
	delete[] SpriteStreamData;
	delete[] MergedStreamData;
}


void VSBB_GenerateUpdateCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	for (int StreamBufferIndex = 0; StreamBufferIndex < NUM_STREAM_BUFFERS; StreamBufferIndex++)
	{
		int LoadBufferIndex = StreamBufferIndex / 2;
		int PairIndex = StreamBufferIndex % 2;
		int BitmapMAP_SRCOffset = BitmapMAP_OffsetToData + BitmapMAP_BlockStride * PairIndex;
		int BitmapSCR_SRCOffset = BitmapSCR_OffsetToData + BitmapSCR_BlockStride * PairIndex;
		int BitmapCOL_SRCOffset = BitmapCOL_OffsetToData + BitmapCOL_BlockStride * PairIndex;
		int SpriteMAP_SRCOffset = SpriteMAP_OffsetToData + SpriteMAP_BlockStride * PairIndex;

		for (int OutputBankIndex = 0; OutputBankIndex < 2; OutputBankIndex++)
		{
			code.OutputFunctionLine(fmt::format("UpdateNewData_SRC{:d}_DST{:d}", StreamBufferIndex, OutputBankIndex));

			code.OutputCodeLine(LDX_ZP, fmt::format("ZP_BitmapUpdateSRCIndex"));
			code.OutputCodeLine(LDY_ZP, fmt::format("ZP_BitmapUpdateDSTIndex"));
			code.OutputBlankLine();

			int CurrentBitmapCopyPos = 0;
			while (CurrentBitmapCopyPos < 320)
			{
				int StartSrcOffset = CurrentBitmapCopyPos * STREAM_BUFFER_BLOCKHEIGHT + BitmapMAP_SRCOffset;
				int EndSrcOffset = StartSrcOffset + COPY_STRIDE - 1;
				int StartDstOffset = CurrentBitmapCopyPos + (24 * 40 * 8);

				code.OutputCodeLine(LDA_ABX, fmt::format("ScrollData_Buffer{:d} + ${:04x}", LoadBufferIndex, StartSrcOffset));
				code.OutputCodeLine(STA_ABY, fmt::format("BitmapAddress{:d} + ${:04x}", OutputBankIndex, StartDstOffset));
				CurrentBitmapCopyPos += COPY_STRIDE;
			}
			code.OutputBlankLine();

			int CurrentScreenCopyPos = 0;
			code.OutputCodeLine(LDX_ZP, fmt::format("ZP_SrcStreamedScrDataOffset"));
			code.OutputCodeLine(CPX_IMM, fmt::format("#$ff"));
			code.OutputCodeLine(BEQ, fmt::format("NoScrDataUpdate_SRC{:d}_DST{:d}", StreamBufferIndex, OutputBankIndex));
			while (CurrentScreenCopyPos < 40)
			{
				if ((CurrentScreenCopyPos + COPY_STRIDE) > 40)
				{
					CurrentScreenCopyPos = 40 - COPY_STRIDE;
				}

				int StartSrcOffset = BitmapSCR_SRCOffset + CurrentScreenCopyPos;
				code.OutputCodeLine(LDA_ABX, fmt::format("ScrollData_Buffer{:d} + ${:04x}", LoadBufferIndex, StartSrcOffset));
				code.OutputCodeLine(STA_ABY, fmt::format("ScreenAddress{:d} + ${:04x}", OutputBankIndex, CurrentScreenCopyPos + 960));
				CurrentScreenCopyPos += COPY_STRIDE;
			}
			code.OutputFunctionLine(fmt::format("NoScrDataUpdate_SRC{:d}_DST{:d}", StreamBufferIndex, OutputBankIndex));
			code.OutputBlankLine();

			code.OutputCodeLine(LDX_ZP, fmt::format("ZP_SrcStreamedSpriteDataOffset"));
			code.OutputCodeLine(BMI, fmt::format("NoSpriteDataUpdate_SRC{:d}_DST{:d}", StreamBufferIndex, OutputBankIndex));
			code.OutputCodeLine(LDY_ZP, fmt::format("ZP_SpriteDataIndex"));
			for (int iSpriteLine = 0; iSpriteLine < 8; iSpriteLine++)
			{
				int CurrentYPos = 192 + SPRITE_YSTART_OFFSET + iSpriteLine;
				int StartSrcOffset = SpriteMAP_SRCOffset + iSpriteLine * STREAM_BUFFER_SPRITEDATA_STRIDE * STREAM_BUFFER_BLOCKHEIGHT;

				int DstLine0 = SpriteData_BitmapLineToSpriteLine[CurrentYPos + 0][0];
				int DstLine1 = SpriteData_BitmapLineToSpriteLine[CurrentYPos + 0][1];

				int DstSpriteIndex0 = (DstLine0 / 21) * 4;
				int DstSpriteDataOffset0 = (DstSpriteIndex0 * 64) + ((DstLine0 % 21) * 3);

				int DstSpriteIndex1 = (DstLine1 / 21) * 4;
				int DstSpriteDataOffset1 = (DstSpriteIndex1 * 64) + ((DstLine1 % 21) * 3);

				code.OutputCodeLine(LDA_ABX, fmt::format("ScrollData_Buffer{:d} + ${:04x}", LoadBufferIndex, StartSrcOffset));
				code.OutputCodeLine(STA_ABY, fmt::format("SpriteDataAddress{:d} + ${:04x}", OutputBankIndex, DstSpriteDataOffset0));

				if (DstLine1 >= 0)
				{
					code.OutputCodeLine(STA_ABY, fmt::format("SpriteDataAddress{:d} + ${:04x}", OutputBankIndex, DstSpriteDataOffset1));
				}
			}
			code.OutputFunctionLine(fmt::format("NoSpriteDataUpdate_SRC{:d}_DST{:d}", StreamBufferIndex, OutputBankIndex));
			code.OutputBlankLine();

			code.OutputCodeLine(RTS);
			code.OutputBlankLine();
			code.OutputBlankLine();
		}
	}

	code.OutputFunctionLine(fmt::format("CopySingleBitmapDatas"));
	code.OutputCodeLine(LDA_ABS, fmt::format("Frame16CounterMod1"));
	code.OutputCodeLine(BEQ, fmt::format("CopySingleBitmapDatas0"));
	code.OutputCodeLine(JMP_ABS, fmt::format("CopySingleBitmapDatas1"));
	code.OutputBlankLine();

	for (int DoubleBufferIndex = 0; DoubleBufferIndex < 2; DoubleBufferIndex++)
	{
		code.OutputFunctionLine(fmt::format("CopySingleBitmapDatas{:d}", DoubleBufferIndex));

		int SrcBuffer = DoubleBufferIndex;
		int DstBuffer = 1 - DoubleBufferIndex;
		for (int PageIndex = 2; PageIndex < 31; PageIndex++)
		{
			int SrcOffset = (PageIndex * 256) + 255;
			int DstOffset = SrcOffset - 320;
			code.OutputCodeLine(LDA_ABS, fmt::format("BitmapAddress{:d} + ${:04x}", SrcBuffer, SrcOffset));
			code.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress{:d} + ${:04x}", DstBuffer, DstOffset));
		}
		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
}


void VSBB_ConvertImage(char* BitmapFilename, LPTSTR OutputBMPFilename, LPTSTR OutputSCRFilename, LPTSTR OutputCOLFilename)
{
	GPIMAGE ImgBitmap(BitmapFilename);

	int PicW = (int)(ImgBitmap.Width / 2);
	int PicH = (int)ImgBitmap.Height;
	int CharCol = PicW / 4;
	int CharRow = PicH / 8;

	//Two arrays, one for the R component of the RGB color, one for the picture
	std::vector<unsigned char> Red((PicW * PicH));
	std::vector<unsigned char> Pic((PicW * PicH));

	//Three Color Tab arrays for the three colors per char, the 4th is always $0c for this particular image with an R value of &H80
	std::vector<unsigned char> ColTab1((CharCol * CharRow));
	std::vector<unsigned char> ColTab2((CharCol * CharRow));
	std::vector<unsigned char> ColTab3((CharCol * CharRow));

	//Final bitmap array
	std::vector<unsigned char> BMP((CharCol * PicH));

	unsigned char V = 0; //One temporary byte to work with...
	int CP = 0; //Char Position within array

	//Fetch R component of the RGB color code for each pixel
	for (int Y = 0; Y < PicH; Y++)
	{
		for (int X = 0; X < PicW; X++)
		{
			unsigned int Colour = ImgBitmap.GetPixel(X * 2, Y);
			unsigned char R = (unsigned char)((Colour & 0xff0000) >> 16);
			Red[(Y * PicW) + X] = R;
		}
	}

	//R values of the 16 colors: &H00,&H80,&H55,&H8a,&H3e,&H90,&H5c,&Hab,&Hff,&H7c,&H89,&H7a,&Hac,&H68,&Hd0,&Hbb

	unsigned char UnusedColor = 0x10; //Value not used by either the image or the C64

	//Background color ($0c) R value
	unsigned char BGColR = 0x80;

	//Fill all three Color Tabs with a value that is not used by either the image or the C64
	for (int I = 0; I < ColTab1.size(); I++)
	{
		ColTab1[I] = UnusedColor;
		ColTab2[I] = UnusedColor;
		ColTab3[I] = UnusedColor;
	}

	//Sort R values into 3 Color Tabs per char
	for (int CY = 0; CY < CharRow; CY++) //200 char rows
	{
		for (int CX = 0; CX < CharCol; CX++) //40 chars per row
		{
			CP = (CY * 8 * PicW) + (CX * 4); //Char's position within R array (160*1600) = Y*160*8 + X*4
			for (int BY = 0; BY <= 7; BY++) //Pixel's Y-position within char
			{
				for (int BX = 0; BX <= 3; BX++) //Pixel's X-position within char
				{
					unsigned char RVal = Red[CP + (BY * PicW) + BX]; //Fetch R value of pixel in char

					if ((RVal == BGColR) || (ColTab1[(CY * 40) + CX] == RVal) || (ColTab2[(CY * 40) + CX] == RVal) || (ColTab3[(CY * 40) + CX] == RVal))
					{
						//Color cannot be &0c, and can only be stored once
					}
					else if (ColTab1[(CY * 40) + CX] == UnusedColor)
					{
						//If color is not in Color Tabs yet, first fill Color Tab 1
						ColTab1[(CY * 40) + CX] = RVal;
					}
					else if (ColTab2[(CY * 40) + CX] == UnusedColor)
					{
						//Then try Color Tab 2
						ColTab2[(CY * 40) + CX] = RVal;
					}
					else if (ColTab3[(CY * 40) + CX] == UnusedColor)
					{
						//Finally Color Tab 3
						ColTab3[(CY * 40) + CX] = RVal;
					}
				}
			}
		}
	}

	//Load predefined R-To-C64 color conversion tab into 32-byte array
	unsigned char RtoC64ConvTab[] = {
		0x00, 0x80, 0x55, 0x8a, 0x3e, 0x90, 0x5c, 0xab,
		0xff, 0x7c, 0x89, 0x7a, 0xac, 0x68, 0xd0, 0xbb,
		0x00, 0x0c, 0x0b, 0x04, 0x06, 0x08, 0x09, 0x0f,
		0x01, 0x0e, 0x02, 0x03, 0x0d, 0x05, 0x07, 0x0a,
	};

	//Replace R values with C64 color codes
	for (int I = 0; I < ColTab1.size(); I++)
	{

		for (int J = 0; J <= 15; J++)
		{
			if (ColTab1[I] == RtoC64ConvTab[J])
			{
				ColTab1[I] = RtoC64ConvTab[J + 16];
				break;
			}
		}

		for (int J = 0; J <= 15; J++)
		{
			if (ColTab2[I] == RtoC64ConvTab[J])
			{
				ColTab2[I] = RtoC64ConvTab[J + 16];
				break;
			}
		}

		for (int J = 0; J <= 15; J++)
		{
			if (ColTab3[I] == RtoC64ConvTab[J])
			{
				ColTab3[I] = RtoC64ConvTab[J + 16];
				break;
			}
		}
	}

	//--------------------------------------------------------------------------------------------------------
	//Finde longest sequences of the same color per channel
	//--------------------------------------------------------------------------------------------------------

	//Three arrays for the longest color sequence per char position per color channel
	std::vector<int> Seq1((CharCol * CharRow));
	std::vector<int> Seq2((CharCol * CharRow));
	std::vector<int> Seq3((CharCol * CharRow));
	//Temporary storage for color swapping
	unsigned char Tmp = 0;

	//RESORT COLORS TO FIND THE LONGEST CHAINS

//-------------------------
	//This is done backwards!!!
//-------------------------

	for (int I = (int)ColTab1.size() - 2; I >= 0; I--)
	{
		//Does color 1 match the previous value of color 2 or vice versa?
		if ((ColTab1[I] == ColTab2[I + 1]) || (ColTab2[I] == ColTab1[I + 1]))
		{
			//Swap colors
			Tmp = ColTab2[I];
			ColTab2[I] = ColTab1[I];
			ColTab1[I] = Tmp;
			//then check the same for the new color 1 (former color 2) and color 3
			if ((ColTab1[I] == ColTab3[I + 1]) || (ColTab3[I] == ColTab1[I + 1])) //3=1
			{
				Tmp = ColTab3[I];
				ColTab3[I] = ColTab1[I];
				ColTab1[I] = Tmp;
				//and finally the new color 2 (previously color 1) and color 3
			}
			else if ((ColTab2[I] == ColTab3[I + 1]) || (ColTab3[I] == ColTab2[I + 1])) //3=1
			{
				Tmp = ColTab3[I];
				ColTab3[I] = ColTab2[I];
				ColTab2[I] = Tmp;
			}
			//If there was no match, check the same for color 1 and color 3 and vice versa
		}
		else if ((ColTab1[I] == ColTab3[I + 1]) || (ColTab3[I] == ColTab1[I + 1])) //3=1
		{
			Tmp = ColTab3[I];
			ColTab3[I] = ColTab1[I];
			ColTab1[I] = Tmp;
			//then for the new color 1 (former color 3) and color 2
			if ((ColTab1[I] == ColTab2[I + 1]) || (ColTab2[I] == ColTab1[I + 1])) //2=1
			{
				Tmp = ColTab2[I];
				ColTab2[I] = ColTab1[I];
				ColTab1[I] = Tmp;
				//finally for the new color 3 (former color 1) and color 2
			}
			else if ((ColTab3[I] == ColTab2[I + 1]) || (ColTab2[I] == ColTab3[I + 1])) //2=1
			{
				Tmp = ColTab2[I];
				ColTab2[I] = ColTab3[I];
				ColTab3[I] = Tmp;
			}
		}
		else
		{
			//Last check can be simplified as we know that color 1<> color 2 and color 1<> color 3
			//So we only compare colors 2 and 3 here
			if ((ColTab2[I] == ColTab3[I + 1]) || (ColTab3[I] == ColTab2[I + 1])) //3=2
			{
				Tmp = ColTab3[I];
				ColTab3[I] = ColTab2[I];
				ColTab2[I] = Tmp;
			}
		}
	}

	//------------------------------------------------------------------------------------------------
	//Calculate chain length for each position in the color tabs and store it in the sequence arrays
	//ALSO DONE BACKWARDS!
	//------------------------------------------------------------------------------------------------

	for (int I = (int)ColTab1.size() - 2; I >= 0; I--)
	{
		if (ColTab1[I] == ColTab1[I + 1])
		{
			//Repeating color found, increase chain length and store it in next position
			Seq1[I] = Seq1[I + 1] + 1;
		}
		else
		{
			//New color value, chain starts over
			Seq1[I] = 0;
		}

		if (ColTab2[I] == ColTab2[I + 1])
		{
			Seq2[I] = Seq2[I + 1] + 1;
		}
		else
		{
			Seq2[I] = 0;
		}
		if (ColTab3[I] == ColTab3[I + 1])
		{
			Seq3[I] = Seq3[I + 1] + 1;
		}
		else
		{
			Seq3[I] = 0;
		}
	}

	//Arrays for color RAM, screen RAM high and low nibbles, and screen RAM combined
	std::vector<unsigned char> ColRAM((CharCol * CharRow));
	std::vector<unsigned char> ScrHi((CharCol * CharRow));
	std::vector<unsigned char> ScrLo((CharCol * CharRow));
	std::vector<unsigned char> ScrRAM((CharCol * CharRow));

	//------------------------------------------------------------------------------------------------
	//Select the longest chain for the actual position in the color tabs
	//and fill color ram and screen arrays with colors per sequences
	//THIS IS DONE FORWARD!!!
	//------------------------------------------------------------------------------------------------

	for (int I = 0; I < ColRAM.size(); I++)
	{
		if (Seq1[I] > Seq2[I])
		{
			if (Seq1[I] > Seq3[I])
			{
				//VB TO C++ CONVERTER NOTE: The ending condition of VB 'For' loops is tested only on entry to the loop. VB to C++ Converter has created a temporary variable in order to use the initial value of I + Seq1(I) for every iteration:
				int tempVar = I + Seq1[I];
				for (int J = I; J <= tempVar; J++)
				{
					ColRAM[J] = ColTab1[J]; //ColTab1 sequence is longest
					ScrHi[J] = ColTab2[J];
					ScrLo[J] = ColTab3[J];
				}
				I += Seq1[I];
			}
			else
			{
				//VB TO C++ CONVERTER NOTE: The ending condition of VB 'For' loops is tested only on entry to the loop. VB to C++ Converter has created a temporary variable in order to use the initial value of I + Seq3(I) for every iteration:
				int tempVar2 = I + Seq3[I];
				for (int J = I; J <= tempVar2; J++)
				{
					ColRAM[J] = ColTab3[J]; //ColTab3 sequence is longest
					ScrHi[J] = ColTab1[J];
					ScrLo[J] = ColTab2[J];
				}
				I += Seq3[I];
			}
		}
		else
		{
			if (Seq2[I] > Seq3[I])
			{
				//VB TO C++ CONVERTER NOTE: The ending condition of VB 'For' loops is tested only on entry to the loop. VB to C++ Converter has created a temporary variable in order to use the initial value of I + Seq2(I) for every iteration:
				int tempVar3 = I + Seq2[I];
				for (int J = I; J <= tempVar3; J++)
				{
					ColRAM[J] = ColTab2[J]; //ColTab2 sequence is longest
					ScrHi[J] = ColTab1[J];
					ScrLo[J] = ColTab3[J];
				}
				I += Seq2[I];
			}
			else
			{
				//VB TO C++ CONVERTER NOTE: The ending condition of VB 'For' loops is tested only on entry to the loop. VB to C++ Converter has created a temporary variable in order to use the initial value of I + Seq3(I) for every iteration:
				int tempVar4 = I + Seq3[I];
				for (int J = I; J <= tempVar4; J++)
				{
					ColRAM[J] = ColTab3[J]; //ColTab3 sequence is longest
					ScrHi[J] = ColTab1[J];
					ScrLo[J] = ColTab2[J];
				}
				I += Seq3[I];
			}
		}
	}

	//------------------------------------------------------------------------------------------------
	//Replace unused colors with adjacent values, to improve data compression
	//This is done backwards, as compression and loading is done backwards to
	//------------------------------------------------------------------------------------------------

	//Find first used color in ColorRAM, starting from last position
	if (ColRAM[ColRAM.size() - 1] == UnusedColor)
	{
		for (int I = (int)ColRAM.size() - 2; I >= 0; I--)
		{
			if (ColRAM[I] != UnusedColor)
			{
				ColRAM[ColRAM.size() - 1] = ColRAM[I]; //Save it to last position if that was unused
				break;
			}
		}
	}

	//Same for screen low nibble...
	if (ScrLo[ScrLo.size() - 1] == UnusedColor)
	{
		for (int I = (int)ScrLo.size() - 2; I >= 0; I--)
		{
			if (ScrLo[I] != UnusedColor)
			{
				ScrLo[ScrLo.size() - 1] = ScrLo[I];
				break;
			}
		}
	}

	//...and high nibble
	if (ScrHi[ScrHi.size() - 1] == UnusedColor)
	{
		for (int I = (int)ScrHi.size() - 2; I >= 0; I--)
		{
			if (ScrHi[I] != UnusedColor)
			{
				ScrHi[ScrHi.size() - 1] = ScrHi[I];
				break;
			}
		}
	}

	//Replace unused color value starting from end
	for (int I = (int)ColRAM.size() - 2; I >= 0; I--)
	{
		if (ColRAM[I] == UnusedColor)
		{
			ColRAM[I] = ColRAM[I + 1];
		}
		if (ScrHi[I] == UnusedColor)
		{
			ScrHi[I] = ScrHi[I + 1];
		}
		if (ScrLo[I] == UnusedColor)
		{
			ScrLo[I] = ScrLo[I + 1];
		}
	}

	//Combine screen RAM hi and low nibbles
	for (int I = 0; I < ScrRAM.size(); I++)
	{
		ScrRAM[I] = (unsigned char)((ScrHi[I] * 16) + ScrLo[I]);
	}

	//----------------------------------------------------------------------------
	//Rebuild the bitmap
	//----------------------------------------------------------------------------

//VB TO C++ CONVERTER NOTE: The ending condition of VB 'For' loops is tested only on entry to the loop. VB to C++ Converter has created a temporary variable in order to use the initial value of PicW * PicH for every iteration:
	int tempVar5 = PicW * PicH;
	for (int I = 0; I < tempVar5; I++)
	{
		//We are converting R RGB values to C64 color codes for the image
		for (int J = 0; J <= 15; J++)
		{
			if (Red[I] == RtoC64ConvTab[J])
			{
				Pic[I] = RtoC64ConvTab[J + 16];
				break;
			}
		}
	}

	unsigned char Col0 = 0xC; //Background color code for C64
	unsigned char Col1 = 0;
	unsigned char Col2 = 0;
	unsigned char Col3 = 0;

	//Replace C64 colors with respective bit pairs
	for (int CY = 0; CY < CharRow; CY++) //200 char rows
	{
		for (int CX = 0; CX < CharCol; CX++) //40 char columns
		{
			Col1 = ScrHi[(CY * 40) + CX]; //Fetch colors from tabs
			Col2 = ScrLo[(CY * 40) + CX];
			Col3 = ColRAM[(CY * 40) + CX];
			for (int BY = 0; BY <= 7; BY++)
			{
				for (int BX = 0; BX <= 3; BX++)
				{
					//Calculate pixel position in array
					CP = (CY * PicW * 8) + (CX * 4) + (BY * PicW) + BX;
					if (Pic[CP] == Col0)
					{
						Pic[CP] = 0;
					}
					else if (Pic[CP] == Col1)
					{
						Pic[CP] = 1;
					}
					else if (Pic[CP] == Col2)
					{
						Pic[CP] = 2;
					}
					else if (Pic[CP] == Col3)
					{
						Pic[CP] = 3;
					}
				}
			}
		}
	}

	//Finally, convert bit pairs to final bitmap
	for (int CY = 0; CY < CharRow; CY++)
	{
		for (int CX = 0; CX < CharCol; CX++)
		{
			for (int BY = 0; BY <= 7; BY++)
			{
				CP = (CY * PicW * 8) + (CX * 4) + (BY * PicW);
				V = (unsigned char)((Pic[CP] * 64) + (Pic[CP + 1] * 16) + (Pic[CP + 2] * 4) + Pic[CP + 3]);
				CP = (CY * 320) + (CX * 8) + BY;
				BMP[CP] = V;
			}
		}
	}



	int SizeBMPRAM2 = (int)BMP.size();
	int SizeScrRAM2 = (int)ScrRAM.size();
	int SizeColRAM2 = (int)ColRAM.size() / 2;
	unsigned char* BMPRAM2 = new unsigned char[SizeBMPRAM2];
	unsigned char* ScrRAM2 = new unsigned char[SizeScrRAM2];
	unsigned char* ColRAM2 = new unsigned char[SizeColRAM2];
	for (int I = 0; I < BMP.size(); I++)
	{
		BMPRAM2[I] = BMP[I];
	}
	for (int I = 0; I < ScrRAM.size()-1000; I++)
	{
		ScrRAM2[I] = ScrRAM[I];
	}
	//clearing the last 1000 bytes of the screen colours
	//this also avoids a grey screen and blue strips in the side borders when switching from multicolour mode to hi-res
	for (int I = ScrRAM.size()-1000; I < ScrRAM.size(); I++)
	{
		ScrRAM2[I] = 0;
	}
	for (int I = 0; I < ColRAM.size() / 2; I++)
	{
		ColRAM2[I] = (unsigned char)((ColRAM[(I * 2) + 1] * 16) + ColRAM[I * 2]);
	}
	WriteBinaryFile(OutputBMPFilename, BMPRAM2, SizeBMPRAM2);
	WriteBinaryFile(OutputSCRFilename, ScrRAM2, SizeScrRAM2);
	WriteBinaryFile(OutputCOLFilename, ColRAM2, SizeColRAM2);
}

int VerticalSideBorderBitmap_Main()
{
	int SizeHiresSCRCOLMemory = 40 * (1152 / 8);
	unsigned char* HiresSCRCOLMemory = new unsigned char[SizeHiresSCRCOLMemory];
	memset(HiresSCRCOLMemory, 0x0c, SizeHiresSCRCOLMemory - 1);
	memset(HiresSCRCOLMemory + SizeHiresSCRCOLMemory - 1, 0x00, 1);

	WriteBinaryFile(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap2.scr", HiresSCRCOLMemory, SizeHiresSCRCOLMemory);
	memset(HiresSCRCOLMemory, 0x00, SizeHiresSCRCOLMemory);
	WriteBinaryFile(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap2.col", HiresSCRCOLMemory, SizeHiresSCRCOLMemory);
	delete[] HiresSCRCOLMemory;
	
	VSBB_ConvertImage("6502\\Parts\\VerticalSideBorderBitmap\\Data\\Bitmap.png", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.map", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.scr", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.col");
	ConvertBitmapDataToStreamData(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.map", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.scr", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap.col", 320, 1600, L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamBitmapData.bin", false);
	ConvertTallBitmapToSpriteStreamData("6502\\Parts\\VerticalSideBorderBitmap\\Data\\Sprites.png", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamSpriteData.bin", true, 12, 0, 11, 15);
	ConvertTallBitmapToSpriteStreamData("6502\\Parts\\VerticalSideBorderBitmap\\Data\\Sprites2.png", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamSpriteData2.bin", false, 0, 0, 0, 0);
	//;ConvertBitmapDataToStreamData(L"6502\\Parts\\VerticalSideBorderBitmap\\Data\\Bitmap2.map", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap2.scr", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap2.col", 320, 1200, L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamBitmapData2.bin", true);
	ConvertBitmapDataToStreamData(L"6502\\Parts\\VerticalSideBorderBitmap\\Data\\Bitmap2.map", L"6502\\Parts\\VerticalSideBorderBitmap\\Data\\Bitmap2.scr", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\Bitmap2.col", 320, 1152, L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamBitmapData2.bin", true);

	MergeBitmapAndSpriteStreamData(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamBitmapData.bin", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamBitmapData2.bin", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamSpriteData.bin", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamSpriteData2.bin", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamData.bin", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\D800Data.bin", L"Out\\6502\\Main\\VerticalSideBorderBitmap-StreamData.sls", L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\StreamData.sls");

	GenerateSpriteData();

	VSBB_GenerateCode(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\BorderCode_0.asm", 0);
	VSBB_GenerateCode(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\BorderCode_1.asm", 1);
	VSBB_GenerateCode(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\BorderCode_2.asm", 2);
	VSBB_GeneratePatchCode(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\D016PatchCode.asm");
	VSBB_GenerateUpdateCode(L"Out\\6502\\Parts\\VerticalSideBorderBitmap\\UpdateNewData.asm");

	return 0;
}


