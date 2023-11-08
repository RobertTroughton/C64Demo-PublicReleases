//; (c) 2018, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\CodeGen.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define SBB_HEIGHT_OF_SPACE_CHAR  6

#define FONT_NUMBER_0 27
#define FONT_EXCLAMATION 37
#define FONT_QUESTIONMARK 38
#define FONT_FULLSTOP 39
#define FONT_COMMA 40
#define FONT_COLON 41
#define FONT_SEMICOLON 42
#define FONT_EQUALS 43
#define FONT_SINGLEQUOTE 44
#define FONT_PLUS 46
#define FONT_DASH 47
#define FONT_DIVIDE 48
#define FONT_SPECIAL_SYMBOLS 49
#define FONT_SPECIAL_SHARK (FONT_SPECIAL_SYMBOLS + 0)
#define FONT_SPECIAL_PRESENT (FONT_SPECIAL_SYMBOLS + 2)
#define FONT_SPECIAL_WREATH (FONT_SPECIAL_SYMBOLS + 3)
#define FONT_SPECIAL_TURKEY (FONT_SPECIAL_SYMBOLS + 4)
#define FONT_SPECIAL_CANDLES (FONT_SPECIAL_SYMBOLS + 5)
#define FONT_SPECIAL_GINGERBREAD (FONT_SPECIAL_SYMBOLS + 6)
#define FONT_SPECIAL_SNOWMAN (FONT_SPECIAL_SYMBOLS + 7)

#define TEXT_ENCODE_SPECIALSYMBOLS 0xf0
#define TEXT_ENCODE_SHARK "\xf0"
#define TEXT_ENCODE_PRESENT "\xf1"
#define TEXT_ENCODE_WREATH "\xf2"
#define TEXT_ENCODE_TURKEY "\xf3"
#define TEXT_ENCODE_CANDLES "\xf4"
#define TEXT_ENCODE_GINGERBREAD "\xf5"
#define TEXT_ENCODE_SNOWMAN "\xf6"

#define SBB_FONT_MAXNUMCHARS 128

unsigned char ScrollText[] = {
	"what horrors lurk in the abyss?  "
	"  what monsters lie in the darkness?  "
	"                        "
};
int ScrollTextLen = sizeof(ScrollText);

void SBB_OutputScrollText(LPCTSTR Filename)
{
	for(int ScrollTextPos = 0; ScrollTextPos < ScrollTextLen; ScrollTextPos++)
	{
		unsigned char CharValue;
		CharValue = ScrollText[ScrollTextPos];

		unsigned char OutputCharValue = 0;
		if (CharValue >= TEXT_ENCODE_SPECIALSYMBOLS)
		{
			OutputCharValue = CharValue - TEXT_ENCODE_SPECIALSYMBOLS + FONT_SPECIAL_SYMBOLS;
		}
		else if (CharValue == 0x00)
		{
			OutputCharValue = 0xff;
		}
		else if ((CharValue >= '0') && (CharValue <= '9'))
		{
			OutputCharValue = CharValue - '0' + FONT_NUMBER_0;
		}
		else if (CharValue == '!')
		{
			OutputCharValue = FONT_EXCLAMATION;
		}
		else if (CharValue == ':')
		{
			OutputCharValue = FONT_COLON;
		}
		else if (CharValue == ';')
		{
			OutputCharValue = FONT_SEMICOLON;
		}
		else if (CharValue == '.')
		{
			OutputCharValue = FONT_FULLSTOP;
		}
		else if (CharValue == ',')
		{
			OutputCharValue = FONT_COMMA;
		}
		else if (CharValue == '?')
		{
			OutputCharValue = FONT_QUESTIONMARK;
		}
		else if (CharValue == '-')
		{
			OutputCharValue = FONT_DASH;
		}
		else if (CharValue == '=')
		{
			OutputCharValue = FONT_EQUALS;
		}
		else if (CharValue == '+')
		{
			OutputCharValue = FONT_PLUS;
		}
		else if (CharValue == '/')
		{
			OutputCharValue = FONT_DIVIDE;
		}
		else if (CharValue == '\'')
		{
			OutputCharValue = FONT_SINGLEQUOTE;
		}
		else //; letters
		{
			OutputCharValue = CharValue & 0x1f; //; force letters to 1-26 range
		}
		ScrollText[ScrollTextPos] = OutputCharValue;
	}
	WriteBinaryFile(Filename, ScrollText, ScrollTextLen);
}

bool SBB_EnoughFreeCycles(int NumCycles, int NumCyclesNeeded)
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

void SBB_InsertScrollerCode(CodeGen& code, int& NumCycles)
{
	static bool bFinishedScrolling = false;
	static bool bMostlyFinishedScrolling = false;
	if (bFinishedScrolling)
	{
		return;
	}

	static int Final_DataOffset = 0;

	while (!bMostlyFinishedScrolling && SBB_EnoughFreeCycles(NumCycles, 8))
	{
		static int YLoopCounter = 0;

		static int ToFrom_XPosition = 0;

		static int To_YPosition = YLoopCounter + 1;
		int From_YPosition = To_YPosition + 2;

		int To_SpriteIndex = YLoopCounter / 16;
		int From_SpriteIndex = (YLoopCounter + 2) / 16;
		int To_SpriteYIndex = (To_YPosition % 21);
		int From_SpriteYIndex = (From_YPosition % 21);

		int To_DataOffset = (To_SpriteIndex * 64) + (To_SpriteYIndex * 3) + ToFrom_XPosition;
		int From_DataOffset = (From_SpriteIndex * 64) + (From_SpriteYIndex * 3) + ToFrom_XPosition;

		code.OutputCodeLine(LDX_ABS, fmt::format("ScrollerSpriteDataAddress + ${:04x}", From_DataOffset));
		code.OutputCodeLine(STX_ABS, fmt::format("ScrollerSpriteDataAddress + ${:04x}", To_DataOffset));
		if (NumCycles > 0)
		{
			NumCycles -= 8;
		}

		ToFrom_XPosition++;
		if (ToFrom_XPosition == 3)
		{
			ToFrom_XPosition = 0;
			To_YPosition++;
			if (To_YPosition == 199)
			{
				bMostlyFinishedScrolling = true;
				Final_DataOffset = (From_SpriteIndex * 64) + (From_SpriteYIndex * 3);
				break;
			}
			YLoopCounter++;
		}
	}
	if (bMostlyFinishedScrolling)
	{
		static int FinalByteCount = 0;

		while (!bFinishedScrolling && SBB_EnoughFreeCycles(NumCycles, 10))
		{
			code.OutputCodeLine(LDX_ABS, fmt::format("ScrollerNextBytes + {:d}", FinalByteCount));
			code.OutputCodeLine(STX_ABS, fmt::format("ScrollerSpriteDataAddress + ${:04x}", Final_DataOffset + FinalByteCount - 3));

			if (NumCycles > 0)
			{
				NumCycles -= 8;
			}
			FinalByteCount++;
			if (FinalByteCount == 6)
			{
				bFinishedScrolling = true;
			}
		}
	}
}

void SBB_UseCycles(CodeGen& code, int NumCycles)
{
	static bool bFirst = true;
	if (bFirst)
	{
		bFirst = false;
	}

	SBB_InsertScrollerCode(code, NumCycles);

	if (NumCycles == -1)
	{
		return;
	}

	while (SBB_EnoughFreeCycles(NumCycles, 2))
	{
		code.OutputCodeLine(NOP);
		NumCycles -= 2;
	}
	if (SBB_EnoughFreeCycles(NumCycles, 3))
	{
		code.OutputCodeLine(NOP_ZP, fmt::format("$ff"));
		NumCycles -= 3;
	}
}

void SBB_GenerateRasterCode(LPCTSTR Filename)
{
	CodeGen code(Filename);

	static const int SpriteStartYPos = 0x31;
	static int SpriteToUpdate = 0;

	code.OutputFunctionLine(fmt::format("SBB_PreScroll"));
	SBB_UseCycles(code, 1000);
	code.OutputCodeLine(RTS);

	code.OutputFunctionLine(fmt::format("SBB_IRQ_GeneratedMainCode"));

	code.OutputCodeLine(LDA_IMM, fmt::format("#$f0"));
	code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteEnable"));

	for (int SpriteIndex = 0; SpriteIndex < 2; SpriteIndex++)
	{
		code.OutputFunctionLine(fmt::format("SpriteX{:d}_0", SpriteToUpdate));
		code.OutputCodeLine(LDA_IMM, fmt::format("#$ee"));
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", SpriteToUpdate + 4));
		SpriteToUpdate ^= 1;
	}

	SBB_UseCycles(code, 77);

	code.OutputCodeLine(LDX_IMM, fmt::format("#SBB_ScreenColour"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#(D016_Value_MultiColour + D016_Value_38Rows)"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#(D016_Value_MultiColour + D016_Value_40Rows)"));
	code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
	code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));

	int SpriteLineIndex = 0;
	bool bShouldMoveSprites = true;
	int NewSpritePos = SpriteStartYPos + 21;
	int CurrentScreenBank = 0;

	for (int LineIndex = 0; LineIndex < 200; LineIndex++)
	{
		int NumCyclesSpare = 42;
		int LineIndexMod8 = LineIndex & 7;
		int LineIndexMod16 = LineIndex & 15;
		int LineIndexMod4 = LineIndex & 3;

		if (LineIndex == 1)
		{
			code.OutputCodeLine(STX_ABS, fmt::format("VIC_ScreenColour"));
			NumCyclesSpare -= 4;
		}

		if (LineIndexMod8)
		{
			if (LineIndexMod16 == 15)
			{
				CurrentScreenBank = 1 - CurrentScreenBank;
				if(CurrentScreenBank == 0)
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
				}
				else
				{
					code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value1"));
				}
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));
				NumCyclesSpare -= 6;
			}

			if (LineIndex >= 16)
			{
				if ((LineIndexMod16 == 4) || (LineIndexMod16 == 5))
				{
					int SpriteLookupIndex = (LineIndex / 16) + 1;

					if (LineIndexMod16 == 4)
					{
						code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueL{:d}", SpriteLookupIndex));
						code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
					}
					else
					{
						code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueR{:d}", SpriteLookupIndex));
						code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
					}
					code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals{:d} + {:d}", (1 - CurrentScreenBank), (LineIndexMod16 == 4 ? 6 : 7)));
					NumCyclesSpare -= 6;

					code.OutputCodeLine(LDA_IMM, fmt::format("#(FirstSpriteValueForScroller + {:d})", SpriteLookupIndex));
					code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals{:d} + {:d}", (1 - CurrentScreenBank), (LineIndexMod16 == 4) ? 4 : 5));
					NumCyclesSpare -= 6;
				}
			}

			if (bShouldMoveSprites)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#{:d}", NewSpritePos));
				for (int SpriteIndex = 4; SpriteIndex < 8; SpriteIndex++)
				{
					code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
				}

				NumCyclesSpare -= 2 + (4 * 4);
				NewSpritePos += 21;

				bShouldMoveSprites = false;
			}

			int NumSpriteUpdates = 0;
			if (NumCyclesSpare >= 6)
			{
				NumSpriteUpdates++;
				if (NumCyclesSpare >= 12)
				{
					NumSpriteUpdates++;
				}
			}
			NumCyclesSpare -= 6 * NumSpriteUpdates;

			unsigned char SprColour = 0xff;
			if ((NumCyclesSpare >= 6) && (NumCyclesSpare != 7))
			{
				switch (LineIndex)
				{
				case 3:
				case 193:
					SprColour = 0x0e;
					break;
				case 7:
				case 188:
					SprColour = 0x03;
					break;
				case 12:
					SprColour = 0x01;
					break;
				case 197:
					SprColour = 0x06;
					break;
				}
				if (SprColour != 0xff)
				{
					NumCyclesSpare -= 6;
				}
			}

			if (SprColour != 0xff)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#{:d}", SprColour));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite4Colour"));
			}
			SBB_UseCycles(code, NumCyclesSpare);

			while(NumSpriteUpdates > 0)
			{
				code.OutputFunctionLine(fmt::format("SpriteX{:d}_{:d}", SpriteToUpdate, LineIndex));
				code.OutputCodeLine(LDA_IMM, fmt::format("#$ee"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", SpriteToUpdate + 4));
				SpriteToUpdate ^= 1;
				NumSpriteUpdates--;
			}

			code.OutputCodeLine(LDA_IMM, fmt::format("#(D016_Value_MultiColour + D016_Value_38Rows)"));
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_D016"));
			code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
		}
		else
		{
			code.OutputCodeLine(STA_ABY, fmt::format("VIC_D016 - (D016_Value_MultiColour + D016_Value_40Rows)"));
			code.OutputCodeLine(STY_ABS, fmt::format("VIC_D016"));
		}
		SpriteLineIndex = SpriteLineIndex + 1;
		if (SpriteLineIndex == 21)
		{
			SpriteLineIndex = 0;
			bShouldMoveSprites = true;
		}
	}

	code.OutputCodeLine(STA_ABS, fmt::format("VIC_ScreenColour"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
	code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteEnable"));

	SBB_UseCycles(code, -1);

	code.OutputFunctionLine(fmt::format("SBB_InitialSpriteSetup"));
	code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueL0"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + 6"));
	code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueL1"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals1 + 6"));
	code.OutputBlankLine();
	code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueR0"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + 7"));
	code.OutputFunctionLine(fmt::format("SBB_BorderSpriteValueR1"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#BlankSpriteValue"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals1 + 7"));
	code.OutputBlankLine();

	code.OutputCodeLine(LDA_IMM, fmt::format("#(FirstSpriteValueForScroller + 0)"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + 4"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals0 + 5"));
	code.OutputCodeLine(LDA_IMM, fmt::format("#(FirstSpriteValueForScroller + 1)"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals1 + 4"));
	code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals1 + 5"));
	code.OutputBlankLine();

	code.OutputCodeLine(LDA_IMM, fmt::format("#{:d}", SpriteStartYPos));
	for (int SpriteIndex = 4; SpriteIndex < 8; SpriteIndex++)
	{
		code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
	}
	code.OutputCodeLine(LDA_IMM, fmt::format("#D018Value0"));
	code.OutputCodeLine(STA_ABS, fmt::format("VIC_D018"));

	code.OutputCodeLine(RTS);

	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("SBB_UpdateXPositions"));
	code.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
	code.OutputCodeLine(INY);
	code.OutputCodeLine(INY);
	code.OutputCodeLine(INY);
	code.OutputCodeLine(STY_ABS, fmt::format("SBB_UpdateXPositions + 1"));

	for (int LineIndex = 0; LineIndex < 200; LineIndex++)
	{
		int LineIndexMod8 = LineIndex % 8;
		if ((LineIndex == 0) || (LineIndexMod8 != 0))
		{
			code.OutputCodeLine(LDA_ABY, fmt::format("SpriteXSintable_X0 + {:d}", LineIndex));
			code.OutputCodeLine(STA_ABS, fmt::format("SpriteX0_{:d} + 1", LineIndex));
			code.OutputCodeLine(LDA_ABY, fmt::format("SpriteXSintable_X1 + {:d}", LineIndex));
			code.OutputCodeLine(STA_ABS, fmt::format("SpriteX1_{:d} + 1", LineIndex));
		}
	}
	code.OutputCodeLine(RTS);
}

void SBB_ConvertProportionalFontToASM(char* InputFontFilename, LPCTSTR Filename)
{
	CodeGen code(Filename);

	CImg<unsigned char> img(InputFontFilename);

	int Height = img.height();
	int Width = img.width();
	int NumChars = 0;
	int YPos = 0;

	int CharHeights[SBB_FONT_MAXNUMCHARS];

	//; Add the space character
	CharHeights[0] = SBB_HEIGHT_OF_SPACE_CHAR;
	code.OutputFunctionLine(fmt::format("CharData_0"));
	for (int YInterPos = 0; YInterPos < SBB_HEIGHT_OF_SPACE_CHAR; YInterPos++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte $00, $00, $00   //; Y ={:d}", YInterPos));
	}
	NumChars++;

	//; Rest of the characters...
	while ((YPos < Height) && (NumChars < SBB_FONT_MAXNUMCHARS))
	{
		int CharHeight = 0;

		int CharStartY = YPos;

		bool bFoundPixel = false;
		do
		{
			if (YPos >= Height)
			{
				break;
			}

			bFoundPixel = false;
			for (int XPos = 0; XPos < Width; XPos++)
			{
				if (img(XPos, YPos) != 0)
				{
					bFoundPixel = true;
					YPos++;
					CharHeight++;
					break;
				}
			}
		} while (bFoundPixel == true);

		bFoundPixel = false;
		do
		{
			if (YPos == Height)
			{
				break;
			}

			bFoundPixel = false;
			for (int XPos = 0; XPos < Width; XPos++)
			{
				if (img(XPos, YPos) != 0)
				{
					bFoundPixel = true;
					break;
				}
			}
			if (!bFoundPixel)
			{
				YPos++;
			}
		} while (bFoundPixel == false);

		if (CharHeight & 1)
		{
			CharHeight++;	//; make it a multiple of 2 (it makes double-speed-scrolling easier...)
		}

		//; Output the data for this char...
		CharHeights[NumChars] = CharHeight;

		code.OutputFunctionLine(fmt::format("CharData_{:d}", NumChars));

		for (int YInterPos = 0; YInterPos < CharHeight; YInterPos++)
		{
			int ThisYPos = CharStartY + YInterPos;

			unsigned char OurValues[3] = { 0, 0, 0 };
			for (int XCharPos = 0; XCharPos < 3; XCharPos++)
			{
				for (int XPixelPos = 0; XPixelPos < 8; XPixelPos++)
				{
					int XPos = XCharPos * 8 + XPixelPos;
					unsigned char Value = img(XPos, ThisYPos);
					OurValues[XCharPos] |= ((Value & 1) << (7 - XPixelPos));
				}
			}
			code.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}   //; Y ={:d}", OurValues[0], OurValues[1], OurValues[2], YInterPos));
		}

		code.OutputBlankLine();
		NumChars++;
	}

	//; Output CharHeights and pointers to CharData...

	code.OutputFunctionLine(fmt::format("CharDataLookups_Lo"));
	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <CharData_{:d}", CharIndex));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("CharDataLookups_Hi"));
	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >CharData_{:d}", CharIndex));
	}
	code.OutputBlankLine();

	code.OutputFunctionLine(fmt::format("CharDataHeights"));
	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte {:d}", CharHeights[CharIndex]));
	}
	code.OutputBlankLine();
}

void SBB_ConvertSpritesToInterleaved(LPCTSTR InputSpritesFilename, LPCTSTR OutputInterleavedSpritesFilename)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputSpritesFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	if (!hFile)
	{
		return;
	}
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned char OutputSprites[26][64];
	ZeroMemory(OutputSprites, sizeof(OutputSprites));

	static const unsigned char EORMask = 0x00;//; 0xAA;

	int OutputSpriteIndex = 0;
	int OutputY = 1;

	for (int InputY = 0; InputY < 200; InputY++)
	{
		int ReadSprite = (InputY / 21) * 2;
		int ReadYWithinSprite = InputY % 21;

		int ReadOffset = (ReadSprite * 64) + (ReadYWithinSprite * 3);
		OutputSprites[OutputSpriteIndex +  0][OutputY * 3 + 0] = FileReadBuffer[ReadOffset + 0] ^ EORMask;
		OutputSprites[OutputSpriteIndex +  0][OutputY * 3 + 1] = FileReadBuffer[ReadOffset + 1] ^ EORMask;
		OutputSprites[OutputSpriteIndex +  0][OutputY * 3 + 2] = FileReadBuffer[ReadOffset + 2] ^ EORMask;
		OutputSprites[OutputSpriteIndex + 13][OutputY * 3 + 0] = FileReadBuffer[ReadOffset + 64] ^ EORMask;
		OutputSprites[OutputSpriteIndex + 13][OutputY * 3 + 1] = FileReadBuffer[ReadOffset + 65] ^ EORMask;
		OutputSprites[OutputSpriteIndex + 13][OutputY * 3 + 2] = FileReadBuffer[ReadOffset + 66] ^ EORMask;

		OutputY = (OutputY + 1) % 21;

		if ((InputY % 16) == 15)
		{
			OutputSpriteIndex++;
		}
	}
	WriteBinaryFile(OutputInterleavedSpritesFilename, OutputSprites, sizeof(OutputSprites));
}

int SBB_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\SideBorderBitmap");

	SBB_ConvertSpritesToInterleaved(L"..\\..\\Build\\Parts\\SideBorderBitmap\\Data\\sidebordersprites.map", L"..\\..\\Intermediate\\Built\\SideBorderBitmap\\sidebordersprites-interleaved.map");

	SBB_ConvertProportionalFontToASM("..\\..\\Build\\Parts\\SideBorderBitmap\\Data\\24pxFont.bmp", L"..\\..\\Intermediate\\Built\\SideBorderBitmap\\24pxFont.asm");

	SBB_GenerateRasterCode(L"..\\..\\Intermediate\\Built\\SideBorderBitmap\\rastercode.asm");

	int SBB_SpriteXSmallMovement[256];
	GenerateSinTable(256, 0, 64, 0, SBB_SpriteXSmallMovement);

	unsigned char cSBB_SinTable[4][256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		int XDistance = 2;
		int XPos0 = SBB_SpriteXSmallMovement[SinIndex] + 24 + 160 - 32 - 12 + XDistance;
		int XPos1 = SBB_SpriteXSmallMovement[SinIndex] + 24 + 160 - 32 - 12 - XDistance;
		cSBB_SinTable[0][SinIndex] = cSBB_SinTable[1][SinIndex] = (unsigned char)(XPos0 & 255);
		cSBB_SinTable[2][SinIndex] = cSBB_SinTable[3][SinIndex] = (unsigned char)(XPos1 & 255);
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\SideBorderBitmap\\sintable.bin", cSBB_SinTable, sizeof(cSBB_SinTable));

	SBB_OutputScrollText(L"..\\..\\Intermediate\\Built\\SideBorderBitmap\\scrolltext.bin");

	return 0;
}
