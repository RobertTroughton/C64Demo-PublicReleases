// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

static int SpriteStartY = 65;
static int SpriteEndY = SpriteStartY + (8 * 21);

static int GScreenBank;

static int BMM_NumCharSets = 0;
static unsigned char BMM_CharSets[8][256][8];
static int BMM_CharSet_NumChars[8];
static int BMM_CharSet_NumScreenLines[16];

static unsigned char UnpackedStrips[512][24];
static unsigned char PackedStrips[256][24];
static unsigned char LogoStripIndices[512];
static unsigned char ReorderedPackedStrips[24][256];

static bool GAIsLoaded = false;

void BigMMLogo_ConvertBlitData(char *InSpriteFilename, LPTSTR OutBlitBINFilename)
{
	unsigned char OutBlitData[160][64];
	memset(OutBlitData, 0xff, sizeof(OutBlitData));

	GPIMAGE SrcImg(InSpriteFilename);

	//; 480 x 160 -> 40 x 8 (320) sprites
	for (int YPos = 1; YPos < 159; YPos++)
	{
		for (int XChar = 0; XChar < 64; XChar++)
		{
			unsigned char OutByte = 0;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int InX = XChar * 8 + XPixel;

				if (SrcImg.GetPixel(InX, YPos) == 0x00000000) //; invert pixels so we can control the bkg colour with D021..!
				{
					OutByte |= (1 << (7 - XPixel));
				}
			}

			if ((YPos & 1) == 1)
			{
				OutByte = FlipByte(OutByte);
			}

			OutBlitData[YPos][XChar] = OutByte;
		}
	}
	WriteBinaryFile(OutBlitBINFilename, OutBlitData, sizeof(OutBlitData));
}

void BigMMLogo_OutputBlitCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	for (int Loop = 0; Loop < 2; Loop++)
	{
		if (Loop == 0)
		{
			code.OutputFunctionLine(fmt::format("DoLeftBlit"));
		}
		else
		{
			code.OutputFunctionLine(fmt::format("DoRightBlit"));
		}
		for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			int MinYSrc0 = (SpriteIndex + 0) * 20;
			int MaxYSrc0 = MinYSrc0 + 20;
			int MinYSrc1 = (SpriteIndex + 4) * 20;
			int MaxYSrc1 = MinYSrc1 + 20;
			for (int YPixel = 0; YPixel < 21; YPixel++)
			{
				int SrcY0 = ((SpriteIndex + 0) * 21) + YPixel;
				if (SrcY0 > MaxYSrc0)
					SrcY0 -= 21;
				int SrcY1 = ((SpriteIndex + 4) * 21) + YPixel;
				if (SrcY1 > MaxYSrc1)
					SrcY1 -= 21;

				if (Loop != 0)
				{
					SrcY0 = 159 - SrcY0;
					SrcY1 = 159 - SrcY1;
				}

				if ((SrcY0 & 1) == Loop)
				{
					code.OutputCodeLine(LDY_IMM, fmt::format("#({:d} * 64 + {:2d} * 3)", SpriteIndex, YPixel));
					code.OutputCodeLine(LDA_ABX, fmt::format("BlitData + ({:3d} * 64)", SrcY0));
					code.OutputCodeLine(STA_IZY, fmt::format("ZP_SpriteBlitPtr0"));
				}
				else
				{
					code.OutputCodeLine(LDY_ABX, fmt::format("BlitData + ({:3d} * 64)", SrcY0));
					code.OutputCodeLine(LDA_ABY, fmt::format("FlipByteTable"));
					code.OutputCodeLine(LDY_IMM, fmt::format("#({:d} * 64 + {:2d} * 3)", SpriteIndex, YPixel));
					code.OutputCodeLine(STA_IZY, fmt::format("ZP_SpriteBlitPtr0"));
				}
				if ((SrcY1 & 1) == Loop)
				{
					code.OutputCodeLine(LDY_IMM, fmt::format("#({:d} * 64 + {:2d} * 3)", SpriteIndex, YPixel));
					code.OutputCodeLine(LDA_ABX, fmt::format("BlitData + ({:3d} * 64)", SrcY1));
					code.OutputCodeLine(STA_IZY, fmt::format("ZP_SpriteBlitPtr1"));
				}
				else
				{
					code.OutputCodeLine(LDY_ABX, fmt::format("BlitData + ({:3d} * 64)", SrcY1));
					code.OutputCodeLine(LDA_ABY, fmt::format("FlipByteTable"));
					code.OutputCodeLine(LDY_IMM, fmt::format("#({:d} * 64 + {:2d} * 3)", SpriteIndex, YPixel));
					code.OutputCodeLine(STA_IZY, fmt::format("ZP_SpriteBlitPtr1"));
				}
				code.OutputBlankLine();
			}
		}
		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
}


bool BigMMLogo_InsertScreenBlitCode(CodeGen& code, int& NumCyclesToUse, bool bFirstPass)
{
	int ALineLoaded = -1;

	static bool bFinishedEverything = false;

	static int XChar = 0;
	static int YChar = 0;
	static bool bNewXChar;

	if (bFirstPass)
	{
		XChar = 0;
		YChar = 0;
		bNewXChar = true;
		bFinishedEverything = false;
	}

	if (bFinishedEverything)
	{
		return true;
	}

	bool bFinished = false;
	while (!bFinished)
	{
		if (bNewXChar)
		{
			if (!EnoughFreeCycles(NumCyclesToUse, 4))
				return false;

			SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDY_ABS, fmt::format("ScreenColumns + {:d}", XChar)));
			bNewXChar = false;
			GAIsLoaded = false;
		}

		if (!GAIsLoaded)
		{
			if (!EnoughFreeCycles(NumCyclesToUse, 4))
				return false;

			SubtractCycles(NumCyclesToUse, code.OutputCodeLine(LDA_ABY, fmt::format("PackedStrips + ({:2d} * 256)", YChar)));
			GAIsLoaded = true;
		}
		
		if (GAIsLoaded)
		{
			if (!EnoughFreeCycles(NumCyclesToUse, 4))
				return false;

			SubtractCycles(NumCyclesToUse, code.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress{:d} + ({:2d} * 40) + {:2d}", 1 - GScreenBank, YChar, XChar)));
			GAIsLoaded = false;
		}

		YChar++;
		if (YChar == 24)
		{
			YChar = 0;
			XChar++;
			bNewXChar = true;
			if (XChar == 39)
			{
				bFinishedEverything = true;
				bFinished = true;
			}
		}
	}
	return bFinishedEverything;
}
		
		
int BigMMLogo_UseCycles(CodeGen & code, int NumCycles, bool bFirstPass)
{
	static bool bFinishedScreenBlitCode = false;
	if (bFirstPass)
	{
		bFinishedScreenBlitCode = false;
	}
	if (!bFinishedScreenBlitCode)
	{
		bFinishedScreenBlitCode = BigMMLogo_InsertScreenBlitCode(code, NumCycles, bFirstPass);
	}
	return code.WasteCycles(NumCycles);
}

void BigMMLogo_OutputCode(LPTSTR Filename)
{
	CodeGen code(Filename);

	for (GScreenBank = 0; GScreenBank < 2; GScreenBank++)
	{
		code.OutputFunctionLine(fmt::format("ScreenIRQ{:d}", GScreenBank));

		int SpriteYVal = SpriteStartY;

		code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteYVal));
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
		}

		code.OutputCodeLine(LDA_IMM, fmt::format("#$f7"));
		for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
		{
			int SpriteIndex0 = SpriteIndex * 2;
			int SpriteIndex1 = SpriteIndex * 2 + 1;
			code.OutputFunctionLine(fmt::format("Bank{:d}_Row0_SP{:d}{:d}", GScreenBank, SpriteIndex0, SpriteIndex1));
			code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", 8 + SpriteIndex * 16));
			code.OutputCodeLine(SAX_ABS, fmt::format("SpriteVals{:d} + {:d}", GScreenBank, SpriteIndex0));
			code.OutputCodeLine(STX_ABS, fmt::format("SpriteVals{:d} + {:d}", GScreenBank, SpriteIndex1));
		}

		BigMMLogo_UseCycles(code, 160, true);
		for (int LineIndex = 0; LineIndex < 160; LineIndex++)
		{
			int RasterLine = 66 + LineIndex;

			bool bNextIsBadLine = (RasterLine % 8) == 0;
			bool bBadLine = (RasterLine % 8) == 1;
			bool bLastWasBadLine = (RasterLine % 8) == 2;

			int NumCyclesToUse = 44;
			if (bBadLine)
				NumCyclesToUse = 0;
			if (bLastWasBadLine)
				NumCyclesToUse = 45;

			int SpriteLineMod20 = (RasterLine - SpriteStartY) % 20;
			int SpriteRow = (RasterLine - SpriteStartY) / 20 + 1;
			if ((SpriteLineMod20 == 19) && EnoughFreeCycles(NumCyclesToUse, 42))
			{
				NumCyclesToUse -= code.OutputCodeLine(LDA_IMM, fmt::format("#$f7"));
				for (int SpriteIndex = 0; SpriteIndex < 4; SpriteIndex++)
				{
					int SpriteIndex0 = SpriteIndex * 2;
					int SpriteIndex1 = SpriteIndex * 2 + 1;
					code.OutputFunctionLine(fmt::format("Bank{:d}_Row{:d}_SP{:d}{:d}", GScreenBank, SpriteRow, SpriteIndex0, SpriteIndex1));
					NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", 8 + SpriteIndex * 16 + SpriteRow));
					NumCyclesToUse -= code.OutputCodeLine(SAX_ABS, fmt::format("SpriteVals{:d} + {:d}", GScreenBank, SpriteIndex0));
					NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("SpriteVals{:d} + {:d}", GScreenBank, SpriteIndex1));
				}
				GAIsLoaded = false;
			}

			int SetD018 = -1;
			if (RasterLine == 50 + (7 * 8))
			{
				if (EnoughFreeCycles(NumCyclesToUse, 6))
				{
					SetD018 = 1;
					NumCyclesToUse -= 6;
/*					NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#D018_Value{:d}B", GScreenBank));
					NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("VIC_D018"));*/
				}
			}

			if (RasterLine == 50 + (16 * 8))
			{
				if (EnoughFreeCycles(NumCyclesToUse, 6))
				{
					SetD018 = 2;
					NumCyclesToUse -= 6;
/*					NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#D018_Value{:d}C", GScreenBank));
					NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("VIC_D018"));*/
				}
			}

			if ((RasterLine > (SpriteYVal + 2)) && (EnoughFreeCycles(NumCyclesToUse, 34)))
			{
				SpriteYVal += 21;

				if (SpriteYVal < SpriteEndY)
				{
					NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", SpriteYVal));
					for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
					{
						NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteIndex));
					}
				}
			}

			if (LineIndex == 0)
			{
				NumCyclesToUse -= 6;
			}

			BigMMLogo_UseCycles(code, NumCyclesToUse, false);

			if (LineIndex == 0)
			{
				code.OutputFunctionLine(fmt::format("Bank{:d}_ScreenColour", GScreenBank));
				code.OutputCodeLine(LDX_IMM, fmt::format("#BackgroundColour"));
				code.OutputCodeLine(STX_ABS, fmt::format("VIC_ScreenColour"));
			}
			
			if (SetD018 == 1)
			{
				NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#D018_Value{:d}B", GScreenBank));
				NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("VIC_D018"));
			}
			if (SetD018 == 2)
			{
				NumCyclesToUse -= code.OutputCodeLine(LDX_IMM, fmt::format("#D018_Value{:d}C", GScreenBank));
				NumCyclesToUse -= code.OutputCodeLine(STX_ABS, fmt::format("VIC_D018"));
			}
		}
		code.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
		code.OutputCodeLine(STX_ABS, fmt::format("VIC_ScreenColour"));
		BigMMLogo_UseCycles(code, -1, false);
		code.OutputBlankLine();

		code.OutputCodeLine(RTS);
	}
}

void BigMMLogo_ConvertLogo(char* InLogoFilename, LPTSTR OutCharSetBINFilename)
{
	ZeroMemory(BMM_CharSets, sizeof(BMM_CharSets));
	ZeroMemory(BMM_CharSet_NumChars, sizeof(BMM_CharSet_NumChars));
	ZeroMemory(BMM_CharSet_NumScreenLines, sizeof(BMM_CharSet_NumScreenLines));
	ZeroMemory(UnpackedStrips, sizeof(UnpackedStrips));
	ZeroMemory(PackedStrips, sizeof(PackedStrips));
	ZeroMemory(LogoStripIndices, sizeof(LogoStripIndices));
	ZeroMemory(ReorderedPackedStrips, sizeof(ReorderedPackedStrips));

	GPIMAGE SrcImg(InLogoFilename);

	int Width = SrcImg.Width;
	int Height = SrcImg.Height;
	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	int CurrentCharSet = 0;
	int NumScreenLines = 0;
	for (int YChar = 0; YChar < CharHeight; YChar++)
	{
		int Pass = 0;
		bool bFinished = false;
		int CurrentNumChars = BMM_CharSet_NumChars[CurrentCharSet];

		while (!bFinished)
		{
			for (int XChar = 0; XChar < CharWidth; XChar++)
			{
				unsigned char ThisChar[8];
				for (int YPixel = 0; YPixel < 8; YPixel++)
				{
					int YPos = YChar * 8 + YPixel;

					unsigned char ThisByte = 0;
					for (int XPixel = 0; XPixel < 8; XPixel += 2)
					{
						int XPos = XChar * 8 + XPixel;
						unsigned int Col = SrcImg.GetPixel(XPos, YPos);
						unsigned char OutCol = 0x00;
						if (Col == 0x00000000)
						{
							//; transparency
						}
						if (Col == 0x00808080)
						{
							OutCol = 0x02;
						}
						if (Col == 0x00ffffff)
						{
							OutCol = 0x03;
						}
						ThisByte |= (OutCol << (6 - XPixel));
					}
					ThisChar[YPixel] = ThisByte;
				}
				int FoundIndex = -1;
				for (int Index = 0; Index < CurrentNumChars; Index++)
				{
					bool bFound = true;
					for (int YPixel = 0; YPixel < 8; YPixel++)
					{
						if (BMM_CharSets[CurrentCharSet][Index][YPixel] != ThisChar[YPixel])
						{
							bFound = false;
							break;
						}
					}
					if (bFound)
					{
						FoundIndex = Index;
						break;
					}
				}
				if (FoundIndex == -1)
				{
					if (CurrentNumChars < 256)
					{
						FoundIndex = CurrentNumChars;
						memcpy(BMM_CharSets[CurrentCharSet][FoundIndex], ThisChar, 8);
					}
					CurrentNumChars++;
				}
				UnpackedStrips[XChar][YChar] = (unsigned char)FoundIndex;
			}
			if (CurrentNumChars <= 256)
			{
				bFinished = true;
				BMM_CharSet_NumChars[CurrentCharSet] = CurrentNumChars;
				NumScreenLines++;
				BMM_CharSet_NumScreenLines[CurrentCharSet] = NumScreenLines;
			}
			else
			{
				int NumCharsToBlank = 256 - BMM_CharSet_NumChars[CurrentCharSet];
				ZeroMemory(BMM_CharSets[CurrentCharSet][BMM_CharSet_NumChars[CurrentCharSet]], NumCharsToBlank);

				CurrentCharSet++;
				CurrentNumChars = 0;
			}
		}
	}

	if (BMM_CharSet_NumChars[CurrentCharSet] > 0)
	{
		CurrentCharSet++;
	}

	WriteBinaryFile(OutCharSetBINFilename, BMM_CharSets, 256 * 8 * CurrentCharSet);

	int NumPackedStrips = 0;
	for (int XChar = 0; XChar < CharWidth; XChar++)
	{
		int FoundStrip = -1;
		for (int Strip = 0; Strip < NumPackedStrips; Strip++)
		{
			if (memcmp(UnpackedStrips[XChar], PackedStrips[Strip], 24) == 0)
			{
				FoundStrip = Strip;
				break;
			}
		}
		if (FoundStrip == -1)
		{
			FoundStrip = NumPackedStrips;
			NumPackedStrips++;

			memcpy(PackedStrips[FoundStrip], UnpackedStrips[XChar], 24);
		}
		LogoStripIndices[XChar] = FoundStrip;
	}

	for (int Strip = 0; Strip < NumPackedStrips; Strip++)
	{
		for (int YChar = 0; YChar < 24; YChar++)
		{
			ReorderedPackedStrips[YChar][Strip] = PackedStrips[Strip][YChar];
		}
	}

	WriteBinaryFile(L"Out\\6502\\Parts\\BigMMLogo\\PackedStrips.bin", ReorderedPackedStrips, sizeof(ReorderedPackedStrips));
	WriteBinaryFile(L"Out\\6502\\Parts\\BigMMLogo\\LogoStripIndices.bin", LogoStripIndices, CharWidth);
}

void BigMMLogo_CalcSinTables(LPTSTR OutSinBINFilename)
{
	static const int SinTableLength = 512;

	static const double Amplitude = 1024.0 - 160.0;
	int SinTable[SinTableLength];
	for (int Index = 0; Index < SinTableLength; Index++)
	{
		double Angle = ((double)Index * 2 * PI) / (double)SinTableLength + 48 * PI / 32;
		double SinVal = sin(Angle);
		double XVal = SinVal * Amplitude + Amplitude;

		int iXVal = (int)XVal;
		SinTable[Index] = iXVal;
	}

	int LogoSinTable[SinTableLength];
	for (int Index = 0; Index < SinTableLength; Index++)
	{
		double Angle = ((double)Index * 2 * PI) / (double)SinTableLength + 50 * PI / 32;
		double SinVal = sin(Angle);
		double XVal = SinVal * 980 + 980;
		int iXVal = (int)XVal;
		LogoSinTable[Index] = iXVal;
	}

	unsigned char cSinTables[6][SinTableLength];
	for (int Index = 0; Index < SinTableLength; Index++)
	{
		int LastIndex = (Index + SinTableLength - 1) % SinTableLength;
		int XVal = SinTable[Index];
		int XColumn = XVal / 16;
		int LastXVal = SinTable[LastIndex];
		int LastXColumn = LastXVal / 16;

		XVal = max(0, XVal);

		int SpriteX = 47 - (XVal % 48);
		cSinTables[0][Index] = (unsigned char)SpriteX;

		int SpriteIndex = 7 - (XVal / 48) % 8;
		cSinTables[1][Index] = (unsigned char)SpriteIndex;

		int InputBlitColumn = 0xff;
		int OutputBlitColumn = 0x00;
		if (XColumn < LastXColumn)
		{
			InputBlitColumn = max(0, min(127, XColumn));
			OutputBlitColumn = (23 - (((SpriteIndex + 7) % 8) * 3 + SpriteX / 16)) % 24;
		}
		if (XColumn > LastXColumn)
		{
			InputBlitColumn = max(0, min(127, XColumn + 23));
			OutputBlitColumn = (23 - (((SpriteIndex + 7) % 8) * 3 + SpriteX / 16) + 23) % 24;
		}
		cSinTables[2][Index] = (unsigned char)OutputBlitColumn;
		cSinTables[3][Index] = (unsigned char)InputBlitColumn;

		int LogoXPosThisFrame = min(LogoSinTable[Index], 245 * 8 - 1);
		int LogoXPosNextFrame = min(LogoSinTable[(Index + 1) % SinTableLength], 245 * 8 - 1);
		cSinTables[4][Index] = (7 - (LogoXPosThisFrame & 7)) + 0x10;
		cSinTables[5][Index] = (LogoXPosNextFrame / 8);
	}

	WriteBinaryFile(OutSinBINFilename, cSinTables, sizeof(cSinTables));
}

int BigMMLogo_Main()
{
	BigMMLogo_ConvertLogo("6502\\Parts\\BigMMLogo\\Data\\Logo.png", L"Out\\6502\\Parts\\BigMMLogo\\CharSets.bin");
	BigMMLogo_OutputCode(L"Out\\6502\\Parts\\BigMMLogo\\ScreenIRQ.asm");
	BigMMLogo_OutputBlitCode(L"Out\\6502\\Parts\\BigMMLogo\\SpriteBlit.asm");
	BigMMLogo_ConvertBlitData("6502\\Parts\\BigMMLogo\\Data\\BackgroundSprites.png", L"Out\\6502\\Parts\\BigMMLogo\\BlitData.bin");
	BigMMLogo_CalcSinTables(L"Out\\6502\\Parts\\BigMMLogo\\SinTables.bin");

	return 0;
}
