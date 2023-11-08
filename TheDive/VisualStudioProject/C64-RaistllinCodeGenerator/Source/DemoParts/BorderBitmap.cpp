//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\CodeGen.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define BORDERBITMAP_YSTART 58
#define BORDERBITMAP_SCREEN_HEIGHT 202

#define BORDERBITMAP_FIRST_SPRITE_INDEX 4
#define BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE 4

#define BORDERBITMAP_SPRITE_INITIAL_Y (BORDERBITMAP_YSTART - 1)

#define BITMAP_INPUT_WIDTH 640
#define BITMAP_INPUT_HEIGHT 184

#define BITMAP_INPUT_CHAR_WIDTH (BITMAP_INPUT_WIDTH / 8)
#define BITMAP_INPUT_CHAR_HEIGHT (BITMAP_INPUT_HEIGHT / 8)

#define BITMAP_INPUT_MAPDATASIZE (BITMAP_INPUT_CHAR_WIDTH * BITMAP_INPUT_HEIGHT)
#define BITMAP_INPUT_COLSCRDATASIZE (BITMAP_INPUT_CHAR_WIDTH * BITMAP_INPUT_CHAR_HEIGHT)
unsigned char InputMAPData[BITMAP_INPUT_CHAR_HEIGHT][BITMAP_INPUT_CHAR_WIDTH][8];
unsigned char InputCOLData[BITMAP_INPUT_CHAR_HEIGHT][BITMAP_INPUT_CHAR_WIDTH];
unsigned char InputSCRData[BITMAP_INPUT_CHAR_HEIGHT][BITMAP_INPUT_CHAR_WIDTH];

#define BITMAP_OUTPUT_MAPDATASIZE ((200 + 2) / 3 * 256)	//; should be 80 * 200 ... but instead we group 3 lines together, giving 240, and pad it out to 256 bytes...
#define BITMAP_OUTPUT_COLSCRDATASIZE (((200 / 8) + 2) / 3 * 256) //; should be 80 * 25 ... ^^
unsigned char OutputMAPData[BITMAP_OUTPUT_MAPDATASIZE];
unsigned char OutputCOLData[BITMAP_OUTPUT_COLSCRDATASIZE];
unsigned char OutputSCRData[BITMAP_OUTPUT_COLSCRDATASIZE];

void BORDERBITMAP_ConvertBitmapData(LPCTSTR InputMAPFilename, LPCTSTR InputCOLFilename, LPCTSTR InputSCRFilename, LPCTSTR OutputMAPFilename, LPCTSTR OutputCOLFilename, LPCTSTR OutputSCRFilename)
{
	ReadBinaryFile(InputMAPFilename, InputMAPData, BITMAP_INPUT_MAPDATASIZE);
	ReadBinaryFile(InputCOLFilename, InputCOLData, BITMAP_INPUT_COLSCRDATASIZE);
	ReadBinaryFile(InputSCRFilename, InputSCRData, BITMAP_INPUT_COLSCRDATASIZE);

	for (int YCharPos = 0; YCharPos < BITMAP_INPUT_CHAR_HEIGHT; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < BITMAP_INPUT_CHAR_WIDTH; XCharPos++)
		{
			for (int YPixelPos = 0; YPixelPos < 8; YPixelPos++)
			{
				int YPos = YCharPos * 8 + YPixelPos;

				unsigned char MAPValue = InputMAPData[YCharPos][XCharPos][YPixelPos];

				int OutputMAPOffset = 0;
				OutputMAPOffset += (YPos / 3) * 256;
				OutputMAPOffset += (YPos % 3) * 80;
				OutputMAPOffset += XCharPos;

				OutputMAPData[OutputMAPOffset] = MAPValue;
			}
			unsigned char COLValue = InputCOLData[YCharPos][XCharPos];
			unsigned char SCRValue = InputCOLData[YCharPos][XCharPos];

			int OutputCOLSCROffset = 0;
			OutputCOLSCROffset += (YCharPos / 3) * 256;
			OutputCOLSCROffset += (YCharPos % 3) * 80;
			OutputCOLSCROffset += XCharPos;

			OutputCOLData[OutputCOLSCROffset] = COLValue;
			OutputSCRData[OutputCOLSCROffset] = SCRValue;
		}
	}

	WriteBinaryFile(OutputMAPFilename, OutputMAPData, BITMAP_OUTPUT_MAPDATASIZE);
	WriteBinaryFile(OutputCOLFilename, OutputCOLData, BITMAP_OUTPUT_COLSCRDATASIZE);
	WriteBinaryFile(OutputSCRFilename, OutputSCRData, BITMAP_OUTPUT_COLSCRDATASIZE);
}


bool BORDERBITMAP_IsBadLine(int RasterLine)
{
	if ((RasterLine >= 50) && (RasterLine < 250))
	{
		if ((RasterLine & 7) == 3)
		{
			return true;
		}
	}
	return false;
}

bool BORDERBITMAP_EnoughFreeCycles(int NumCycles, int NumCyclesNeeded)
{
	//; Special case for "unlimited cycles"
	if (NumCycles == -1)
	{
		return true;
	}

	int NumCyclesLeft = NumCycles - NumCyclesNeeded;

	//; If it doesn't fit, fail
	if (NumCyclesLeft < 0)
	{
		return false;
	}

	//; If it leaves a gap that we can fill, fail
	if (NumCyclesLeft == 1)
	{
		return false;
	}

	//; All good
	return true;
}

static bool GFinishedCodeInterleave = false;
static bool bInitInterleave = true;
void BORDERBITMAP_InsertInterleavedCode(CodeGen& code, int& TotalCycles, int& TotalSize, int& NumCycles)
{
	if (GFinishedCodeInterleave)
	{
		return;
	}

	int XWriteRemaps[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }; // 0, 10 and 11 are never visible

	static int YWritePosition = 2;	//; [0,199] for screen Y
	static int XWritePosition = 0;	//; [0,11] as it crosses 4 sprites

	if (bInitInterleave)
	{
		YWritePosition = 0;
		XWritePosition = 0;
		bInitInterleave = false;
	}
	bool bFinished = false;
	while (!bFinished)
	{
		if (BORDERBITMAP_EnoughFreeCycles(NumCycles, 6))
		{
			int SpriteXIndex = XWriteRemaps[XWritePosition] / 3;
			int SpriteWriteByte = XWriteRemaps[XWritePosition] % 3;

			int SpriteYCellIndex = YWritePosition / 16;
			int SpriteYWriteOffset = (YWritePosition + 1) % 21;

			NumCycles -= code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", rand() % 256));
			NumCycles -= code.OutputCodeLine(STA_ABS, fmt::format("Base_BankAddress + ((BORDERBITMAP_FirstSpriteIndex + ({:d} * 4) + {:d}) * 64) + ({:d} * 3) + {:d}", SpriteYCellIndex, SpriteXIndex, SpriteYWriteOffset, SpriteWriteByte));

			XWritePosition += 2;
			if (XWritePosition >= 9)
			{
				XWritePosition -= 9;
				YWritePosition++;
				if (YWritePosition == 200)
				{
					bFinished = true;
					GFinishedCodeInterleave = true;
				}
			}
		}
		else
		{
			bFinished = true;
		}
	}
}

int BORDERBITMAP_UseCycles(CodeGen& code, int& TotalCycles, int& TotalSize, int NumCycles)
{
	int WastedCycles = 0;

	static bool bFirst = true;
	if (bFirst)
	{
		bFirst = false;
	}

	BORDERBITMAP_InsertInterleavedCode(code, TotalCycles, TotalSize, NumCycles);

	if (NumCycles == -1)
	{
		return 0;
	}

	while(BORDERBITMAP_EnoughFreeCycles(NumCycles, 2))
	{
		int CyclesUsed = code.OutputCodeLine(NOP);
		NumCycles -= CyclesUsed;
		WastedCycles += CyclesUsed;
	}
	if (BORDERBITMAP_EnoughFreeCycles(NumCycles, 3))
	{
		int CyclesUsed = code.OutputCodeLine(NOP_ZP, fmt::format("$ff"));
		NumCycles -= CyclesUsed;
		WastedCycles += CyclesUsed;
	}
	return WastedCycles;
}

void BORDERBITMAP_OutputCode(LPCTSTR Filename)
{
	CodeGen code(Filename);
	int TotalWastedCycles = 0;
	int TotalCycles = 0;
	int TotalSize = 0;

	{
		int CurrentSpriteVal = 0;
		int CurrentSpriteValIndex = 0;

		bool bSpriteInitialDataSet = false;

		TotalWastedCycles = 0;
		TotalCycles = 0;

		int XMSBCounter = 0;
		bool bUpdateXMSB = false;

		GFinishedCodeInterleave = false;
		int CurrentScreenBank = 0;
		bool bScreenBankChanged = false;

		//; Top Sprites (these go in a separate function as we'll place these during VBlank)
		code.OutputFunctionLine(fmt::format("BORDERBITMAP_IRQ_InitialPart"));

		//; Initial sprite vals
		int CurrentSpriteYPosition = BORDERBITMAP_SPRITE_INITIAL_Y;

		//; --- Initial Y
		code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYPosition));
		for (int SpriteIndex = 0; SpriteIndex < BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", BORDERBITMAP_FIRST_SPRITE_INDEX + SpriteIndex));
		}

		code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		for (int SpriteIndex = 0; SpriteIndex < BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", BORDERBITMAP_FIRST_SPRITE_INDEX + SpriteIndex));
		}

		for (int SpriteIndex = 0; SpriteIndex < BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			code.OutputCodeLine(LDA_IMM, fmt::format("#BORDERBITMAP_FirstSpriteIndex + ${:02x}", CurrentSpriteVal++));
			code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + {:d}", BORDERBITMAP_FIRST_SPRITE_INDEX + SpriteIndex));
		}
		for (int SpriteIndex = 0; SpriteIndex < BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
		{
			code.OutputCodeLine(LDA_IMM, fmt::format("#BORDERBITMAP_FirstSpriteIndex + ${:02x}", CurrentSpriteVal++));
			code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals1 + {:d}", BORDERBITMAP_FIRST_SPRITE_INDEX + SpriteIndex));
		}

		code.OutputCodeLine(RTS);
		code.OutputBlankLine();

		CurrentScreenBank = 1 - CurrentScreenBank;

		//; Main Screen Sprites
		code.OutputFunctionLine(fmt::format("BORDERBITMAP_IRQ_Main"));

		code.OutputCodeLine(NONE, fmt::format(":IRQManager_BeginIRQ(1, 10)"));

		code.OutputCodeLine(JSR_ABS, fmt::format("BorderBitmap_DoVSP"));

		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));

		code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));

		TotalWastedCycles += BORDERBITMAP_UseCycles(code, TotalCycles, TotalSize, 64 + 460);

		code.OutputCodeLine(LDY_ZP, fmt::format("D016_Value_40Rows"));

		code.OutputBlankLine();

		bool bD011Inited = false;

		for (int LineIndex = 0; LineIndex < BORDERBITMAP_SCREEN_HEIGHT; LineIndex++)
		{
			int RasterLine = BORDERBITMAP_YSTART + LineIndex + 0;//;1;

			bool bFirstLine = (LineIndex == 0);
			bool bLastLine = (LineIndex == BORDERBITMAP_SCREEN_HEIGHT - 1);
			bool bIsBadLine = BORDERBITMAP_IsBadLine(RasterLine);
			bool bNextLineIsBad = BORDERBITMAP_IsBadLine(RasterLine + 1);

			code.OutputCommentLine(fmt::format("//; RasterLine ${:02x} {}", RasterLine, bIsBadLine ? " <--BADLINE" : ""));

			if (bIsBadLine)
			{
				code.OutputCodeLine(STA_ABX, fmt::format("VIC_D016 - $80"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
			}
			else
			{
				code.OutputCodeLine(LDX_IMM, fmt::format("#$80"));	//; TODO: only load this when the next line is bad..?
				code.OutputCodeLine(LDA_ZP, fmt::format("D016_Value_38Rows"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
				code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
			}

			//; if the next line is a bad line, we need to move right along...
			if (bNextLineIsBad)
			{
				continue;
			}

			int NumCyclesToWaste = 39;

			if (!bD011Inited)
			{
				NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#$3b"));
				NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));

				bD011Inited = true;
			}

			if ((!bSpriteInitialDataSet) && (RasterLine >= 31))
			{
				NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#$0b"));
				for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
				{
					NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Colour", SpriteIndex + 4));
				}
				bSpriteInitialDataSet = true;
			}

			if (RasterLine == 249)
			{
				NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_24Rows"));
				NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));
			}
			if (RasterLine == 255)
			{
				NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#D011_Value_25Rows"));
				NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));
			}

			if ((!bFirstLine) && (!bLastLine))
			{
				int ModdedLineIndex = LineIndex % 16;
				if (ModdedLineIndex == 15)
				{
					NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value{:d}", CurrentScreenBank));
					NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));

					CurrentScreenBank = 1 - CurrentScreenBank;
					bScreenBankChanged = true;
					CurrentSpriteValIndex = 0;
				}
			}
			while (bScreenBankChanged && BORDERBITMAP_EnoughFreeCycles(NumCyclesToWaste, 6))
			{
				NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#BORDERBITMAP_FirstSpriteIndex + ${:02x}", CurrentSpriteVal++));
				NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals{:d} + {:d}", CurrentScreenBank, BORDERBITMAP_FIRST_SPRITE_INDEX + CurrentSpriteValIndex));
				CurrentSpriteValIndex++;
				if (CurrentSpriteValIndex == 4)
				{
					bScreenBankChanged = false;
				}
			}

			if (RasterLine > CurrentSpriteYPosition)
			{
				int NumCyclesNeeded = 2 + 4 * 4;
				if (BORDERBITMAP_EnoughFreeCycles(NumCyclesToWaste, NumCyclesNeeded))
				{
					CurrentSpriteYPosition += 21;

					NumCyclesToWaste -= code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", CurrentSpriteYPosition));
					for (int SpriteIndex = 0; SpriteIndex < BORDERBITMAP_MAX_NUM_SPRITES_ON_LINE; SpriteIndex++)
					{
						NumCyclesToWaste -= code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", BORDERBITMAP_FIRST_SPRITE_INDEX + SpriteIndex));
					}
				}
			}
			if (LineIndex == (BORDERBITMAP_SCREEN_HEIGHT - 1))
			{
				continue;
			}

			TotalWastedCycles += BORDERBITMAP_UseCycles(code, TotalCycles, TotalSize, NumCyclesToWaste);
			code.OutputBlankLine();
		}

		code.OutputBlankLine();

		code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
		code.OutputBlankLine();

		TotalWastedCycles += BORDERBITMAP_UseCycles(code, TotalCycles, TotalSize, -1);
		code.OutputBlankLine();

		code.OutputCodeLine(JMP_ABS, fmt::format("BORDERBITMAP_PostRasterised"));
		code.OutputBlankLine();

		code.OutputCommentLine(fmt::format("//; Total Wasted Cycles = ", TotalWastedCycles));

		code.OutputBlankLine();

		code.OutputBlankLine();
	}
}

void BORDERBITMAP_OutputSinTables(LPCTSTR OutputFilename)
{
	int SinTable[256];
	unsigned char cSinTables[2][256];

	GenerateSinTable(256, 0, 319, 0, SinTable);

	for (int Index = 0; Index < 256; Index++)
	{
		int SinValue = SinTable[Index];

		cSinTables[0][Index] = (SinValue & 7) | 0x18;
		cSinTables[1][Index] = SinValue / 8;
	}

	WriteBinaryFile(OutputFilename, cSinTables, 256 * 2);
}


int BORDERBITMAP_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\BORDERBITMAP");

	BORDERBITMAP_OutputCode(L"..\\..\\Intermediate\\Built\\BORDERBITMAP\\Rasterised.asm");

	BORDERBITMAP_OutputSinTables(L"..\\..\\Intermediate\\Built\\BORDERBITMAP\\SinTables.bin");

	BORDERBITMAP_ConvertBitmapData(
		L"..\\..\\Build\\Parts\\BorderBitmap\\Data\\Stitch-640x200.map", L"..\\..\\Build\\Parts\\BorderBitmap\\Data\\Stitch-640x200.col", L"..\\..\\Build\\Parts\\BorderBitmap\\Data\\Stitch-640x200.scr",
		L"..\\..\\Intermediate\\Built\\BORDERBITMAP\\Stitch-640x200.map", L"..\\..\\Intermediate\\Built\\BORDERBITMAP\\Stitch-640x200.col", L"..\\..\\Intermediate\\Built\\BORDERBITMAP\\Stitch-640x200.scr"
	);

	return 0;
}
