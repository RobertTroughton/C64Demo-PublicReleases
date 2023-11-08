//; (c)2018, Raistlin / Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

int WavyScroller_OutputCharSetAndCode(LPCTSTR OutputCharDataFilename, LPCTSTR OutputCharInfoFilename)
{
	CImg<unsigned char> img1("..\\..\\SourceData\\WavyScroller\\" "Font-64High-Horizontal.bmp");

	static const int MaxNumChars = 32;
	int CharIndex = 0;
	int CharXMin[MaxNumChars], CharXMax[MaxNumChars], CharYMin[MaxNumChars], CharYMax[MaxNumChars];
	ZeroMemory(CharXMin, sizeof(int) * MaxNumChars);
	ZeroMemory(CharXMax, sizeof(int) * MaxNumChars);
	ZeroMemory(CharYMin, sizeof(int) * MaxNumChars);
	ZeroMemory(CharYMax, sizeof(int) * MaxNumChars);

	int TotalCharWidth = 0;

	bool bFoundMinX = false;
	int MaxCharWidth = 0;
	cimg_forX(img1, x)
	{
		bool bFoundMaxX = true;
		cimg_forY(img1, y)
		{
			if (img1(x, y))
			{
				if (!bFoundMinX)
				{
					bFoundMinX = true;
					bFoundMaxX = false;
					CharXMin[CharIndex] = x;
				}
				else
				{
					bFoundMaxX = false;
				}
				break;
			}
		}
		if (bFoundMinX && bFoundMaxX)
		{
			CharXMax[CharIndex] = x;
			bFoundMinX = false;
			if (CharIndex == MaxNumChars)
			{
				break;
			}
			CharXMin[CharIndex] = max(0, CharXMin[CharIndex] - 8);
//			CharXMax[CharIndex] += 8;

			int CharWidth = min(64, CharXMax[CharIndex] - CharXMin[CharIndex]);

			CharXMax[CharIndex] = CharXMin[CharIndex] + CharWidth;

			MaxCharWidth = max(CharWidth, MaxCharWidth);

			TotalCharWidth += CharWidth;

			CharIndex++;
		}
	}

	int NumChars = MaxNumChars;
	int CharWidth = ((MaxCharWidth + 7) / 8) * 8;

	int MaxCharHeight = 0;
	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		int MinX = CharXMin[CharIndex];
		int MaxX = CharXMax[CharIndex];
		int MinY = 1000000;
		int MaxY = 0;

		for (int x = MinX; x < MaxX; x++)
		{
			cimg_forY(img1, y)
			{
				if (img1(x, y))
				{
					MinY = min(MinY, y);
					MaxY = max(MaxY, y);
				}
			}
		}
		CharYMin[CharIndex] = 0;// MinY;
		CharYMax[CharIndex] = 63;// MaxY;
		MaxCharHeight = max(MaxCharHeight, MaxY - MinY + 1);
	}

	//; 1. rotate each char 90 degrees counter clockwise
	//; 2. skew vertically by x-offset pixels

	int OutputWidth = 64;
	int OutputHeight = TotalCharWidth;
	OutputHeight += (OutputWidth - 1) * NumChars; //; vertical skew

	unsigned char CharInfo[MaxNumChars][2];
	ZeroMemory(CharInfo, MaxNumChars * 2);

	int TotalYOutput = 0;
	int PreviousYOutput = 0;

	CImg<unsigned char> img2(OutputWidth, OutputHeight, 1, 1, 0);

	for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
	{
		int CurrentYOutput = TotalYOutput;
		int MaxYOutput = 0;

		int ThisCharWidth = CharXMax[CharIndex] - CharXMin[CharIndex];
		int ThisCharHeight = CharYMax[CharIndex] - CharYMin[CharIndex];
		int NumDiagonals = ThisCharWidth + ThisCharHeight - 1;

		for (int Diagonal = 0; Diagonal < NumDiagonals; Diagonal++)
		{
			int DiagonalLength;
			if (Diagonal < ThisCharWidth)
			{
				DiagonalLength = Diagonal + 1;
			}
			else
			{
				DiagonalLength = ThisCharHeight - (Diagonal - ThisCharWidth);
			}
			DiagonalLength = min(ThisCharWidth, DiagonalLength);
			DiagonalLength = min(ThisCharHeight, DiagonalLength);

			for (int DiagonalIndex = 0; DiagonalIndex < DiagonalLength; DiagonalIndex++)
			{
				int InputX, InputY;
				int OutputX, OutputY;
				if (Diagonal < ThisCharWidth)
				{
					InputX = CharXMin[CharIndex] + (ThisCharWidth - 1 - Diagonal) + DiagonalIndex;
					InputY = CharYMin[CharIndex] + DiagonalIndex;

					OutputX = DiagonalIndex;
					OutputY = CurrentYOutput;

				}
				else
				{
					int NewDiagonal = Diagonal - ThisCharWidth;

					InputX = CharXMin[CharIndex] + DiagonalIndex;
					InputY = CharYMin[CharIndex] + NewDiagonal + DiagonalIndex;

					OutputX = DiagonalIndex + NewDiagonal;
					OutputY = CurrentYOutput;
				}
				OutputY -= (OutputX / 8) * 8; //; Reverse Skew
				if (OutputY >= 0)
				{
					img2(OutputX, OutputY) = img1(InputX, InputY);
					if (img1(InputX, InputY))
					{
						MaxYOutput = max(MaxYOutput, OutputY);
					}
				}
			}
			CurrentYOutput++;
		}

		TotalYOutput += MaxCharWidth;

		int ActualOutputHeight = TotalYOutput - PreviousYOutput;

		CharInfo[CharIndex][0] = PreviousYOutput;
		CharInfo[CharIndex][1] = ActualOutputHeight;

		PreviousYOutput = TotalYOutput;
	}

	img2.crop(0, 0, img2.width() - 1, TotalYOutput - 1);

	img2.save_bmp("..\\..\\Intermediate\\Built\\WavyScroller\\" "font.bmp");
	WriteBinaryFile(OutputCharInfoFilename, CharInfo, NumChars * 2);

	unsigned char CompressedCharData[65536];
	ZeroMemory(CompressedCharData, 65536);
	for (int YVal = 0; YVal < MaxCharWidth; YVal++)
	{
		for (int XVal = 0; XVal < 64; XVal += 8)
		{
			int XCharVal = XVal / 8;
			for (int CharIndex = 0; CharIndex < NumChars; CharIndex++)
			{
				unsigned char CharValue = 0;
				for (int XSubPixel = 0; XSubPixel < 8; XSubPixel++)
				{
					unsigned char PixelValue = img2(XVal + XSubPixel, YVal + CharIndex * MaxCharWidth) == 0 ? 0 : 1;
					CharValue |= PixelValue << (7 - XSubPixel);
				}
				int OutputOffset = ((XCharVal * 64) + YVal) * 32 + CharIndex;
				CompressedCharData[OutputOffset] = CharValue;
			}
		}
	}
	WriteBinaryFile(OutputCharDataFilename, CompressedCharData, 8 * 64 * 32);

	return 0;
}

void WavyScroller_OutputSinTables(LPCTSTR OutputFilename)
{
	int WavyScroller_SinTab[128];
	GenerateSinTable(128, 0, 23, 0, WavyScroller_SinTab);

	unsigned char WavyScroller_SinTab_CharAndPixelOffset[2][8][2][128];
	for (int XOffset = 0; XOffset < 8; XOffset++)
	{
		for (int Index = 0; Index < 128; Index++)
		{
			int SinValue = WavyScroller_SinTab[Index] + XOffset;
			unsigned char cSinValue = (unsigned char)(max(0, min(255, SinValue)));

			WavyScroller_SinTab_CharAndPixelOffset[0][XOffset][0][Index] = WavyScroller_SinTab_CharAndPixelOffset[0][XOffset][1][Index] = (cSinValue / 8) * 16;
			WavyScroller_SinTab_CharAndPixelOffset[1][XOffset][0][Index] = WavyScroller_SinTab_CharAndPixelOffset[1][XOffset][1][Index] = (cSinValue % 8) + 0;
		}
	}
	WriteBinaryFile(OutputFilename, WavyScroller_SinTab_CharAndPixelOffset, 128 * 2 * 8 * 2);
}


#define NUM_CHARSETS 4
char* CharSetShortName[NUM_CHARSETS] = {
	"A",
	"B",
	"C",
	"D",
};

#define NUM_CHARSET_PARTS 2
unsigned char CharSetOffset[NUM_CHARSET_PARTS] = {
	0x00,
	0x80
};

#define NUM_BLIT_LINES 8
#define BLIT_LINE_WIDTH 8
int BlitLine_WhichChar[NUM_BLIT_LINES][BLIT_LINE_WIDTH] = {
	{0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
	{0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
	{0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00},
	{0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00},
	{0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00},
	{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00},
	{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00},
	{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01},
};
int BlitLine_WhichLine[NUM_BLIT_LINES][BLIT_LINE_WIDTH] = {
	{0x00, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01},
	{0x01, 0x00, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02},
	{0x02, 0x01, 0x00, 0x07, 0x06, 0x05, 0x04, 0x03},
	{0x03, 0x02, 0x01, 0x00, 0x07, 0x06, 0x05, 0x04},
	{0x04, 0x03, 0x02, 0x01, 0x00, 0x07, 0x06, 0x05},
	{0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x07, 0x06},
	{0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x07},
	{0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00},
};

#define NUM_PASSES 3
unsigned char PassValue[NUM_PASSES] = {
	0xff,
	0x00,
	0x01
};

void WavyScroller_OutputBlitCode(ofstream& file)
{
	int TotalCycles = 0;
	int TotalSize = 0;

	ostringstream WavyScrollerCodeStream;

	WavyScrollerCodeStream << ".import source \"..\\..\\..\\SourceCode\\Main-CommonDefines.asm\"";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);
	WavyScrollerCodeStream << ".import source \"..\\..\\..\\SourceCode\\Main-CommonCode.asm\"";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);
	WavyScrollerCodeStream << ".import source \"..\\..\\..\\SourceCode\\DemoParts\\WavyScroller-Defines.asm\"";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	WavyScrollerCodeStream << "* = WAVYSCROLLER_BLITCODE_BASE";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);

	WavyScrollerCodeStream << "//; incoming $48-$49 NewCharA/NewCharB";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);
	WavyScrollerCodeStream << "//; incoming Y: char-index (0-f) * 8";
	OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (int BlitLineIndex = 0; BlitLineIndex < NUM_BLIT_LINES; BlitLineIndex++)
	{
		for(int CharSetIndex = 0; CharSetIndex < NUM_CHARSETS; CharSetIndex++)
		{
			WavyScrollerCodeStream << "WAVYSCROLLER_Blit_Line" << dec << int(BlitLineIndex) << "_CharSet" << CharSetShortName[CharSetIndex] << ":";
			OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);

			bool bLoadedCharA = false;
			bool bLoadedCharB = false;
			bool bLoaded00 = false;
			bool bUsesCharA = false;
			bool bUsesCharB = false;

			int AdditionalReadOffset = 6 - CharSetIndex * 2;

			for (int XPos = 0; XPos < BLIT_LINE_WIDTH; XPos++)
			{
				if (BlitLine_WhichChar[BlitLineIndex][XPos] == 0)
				{
					bUsesCharA = true;
				}
				if (BlitLine_WhichChar[BlitLineIndex][XPos] == 1)
				{
					bUsesCharB = true;
				}
			}
			if (bUsesCharA && !bUsesCharB)
			{
				WavyScrollerCodeStream << "\t\tldx $48";
				OUTPUT_CODE(WavyScrollerCodeStream, 3, 2, true);
				bLoadedCharA = true;
			}
			if (!bUsesCharA && bUsesCharB)
			{
				WavyScrollerCodeStream << "\t\tldx $49";
				OUTPUT_CODE(WavyScrollerCodeStream, 3, 2, true);
				bLoadedCharB = true;
			}

			WavyScrollerCodeStream << "\tWAVYSCROLLER_Blit_Line" << dec << int(BlitLineIndex) << "_CharSet" << CharSetShortName[CharSetIndex] << "_Loop:";
			OUTPUT_CODE(WavyScrollerCodeStream, 0, 0, true);

			for (int PassIndex = 0; PassIndex < 3; PassIndex++)
			{
				for (int XPos = 0; XPos < BLIT_LINE_WIDTH; XPos++)
				{
					int WhichLine = BlitLine_WhichLine[BlitLineIndex][XPos];
					int WhichChar = BlitLine_WhichChar[BlitLineIndex][XPos];
					int PassV = PassValue[PassIndex];

					if (WhichChar == PassV)
					{
						switch (PassV)
						{
							case 0:
							if (!bLoadedCharA)
							{
								WavyScrollerCodeStream << "\t\tldx $48";
								OUTPUT_CODE(WavyScrollerCodeStream, 3, 2, true);
								bLoadedCharA = true;
								bLoadedCharB = false;
							}
							break;

							case 1:
							if (!bLoadedCharB)
							{
								WavyScrollerCodeStream << "\t\tldx $49";
								OUTPUT_CODE(WavyScrollerCodeStream, 3, 2, true);
								bLoadedCharB = true;
								bLoadedCharA = false;
							}
							break;

							case 0xff:
							if (!bLoaded00)
							{
								WavyScrollerCodeStream << "\t\tlda #$00";
								OUTPUT_CODE(WavyScrollerCodeStream, 2, 2, true);
								bLoaded00 = true;
							}
							break;
						}
						if (PassV != 0xff)
						{
							WavyScrollerCodeStream << "\t\tlda WAVYSCROLLER_CharSet + (" << dec << int(XPos) << " * 64 + " << dec << int(WhichLine * 8) << " - 6 + " << dec << int(AdditionalReadOffset) << ") * 32, x";
							OUTPUT_CODE(WavyScrollerCodeStream, 4, 3, true);
						}
						//; sta CharAddress%CharSetShortName[CharSetIndex] + XVal * 16 * 8, y	//;
						WavyScrollerCodeStream << "\t\tsta CharAddress" << CharSetShortName[CharSetIndex] << " + " << dec << int(XPos) << " * 16 * 8, y";
						OUTPUT_CODE(WavyScrollerCodeStream, 4, 3, true);
					}
				}
			}
			OUTPUT_BLANK_LINE();

			if (bUsesCharA)
			{
				if (bUsesCharA)
				{
					WavyScrollerCodeStream << "\t\tlda $48";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}
				else
				{
					WavyScrollerCodeStream << "\t\ttxa";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}

				WavyScrollerCodeStream << "\t\tclc";
				OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);

				WavyScrollerCodeStream << "\t\tadc #$20";
				OUTPUT_CODE(WavyScrollerCodeStream, 2, 2, true);

				if (bUsesCharA)
				{
					WavyScrollerCodeStream << "\t\tsta $48";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}
				else
				{
					WavyScrollerCodeStream << "\t\ttax";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}

				OUTPUT_BLANK_LINE();
			}

			if (bUsesCharB)
			{
				if (bUsesCharA)
				{
					WavyScrollerCodeStream << "\t\tlda $49";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}
				else
				{
					WavyScrollerCodeStream << "\t\ttxa";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}

				WavyScrollerCodeStream << "\t\tclc";
				OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);

				WavyScrollerCodeStream << "\t\tadc #$20";
				OUTPUT_CODE(WavyScrollerCodeStream, 2, 2, true);

				if (bUsesCharA)
				{
					WavyScrollerCodeStream << "\t\tsta $49";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}
				else
				{
					WavyScrollerCodeStream << "\t\ttax";
					OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);
				}

				OUTPUT_BLANK_LINE();
			}

			WavyScrollerCodeStream << "\t\tiny";
			OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);

			WavyScrollerCodeStream << "\t\ttya";
			OUTPUT_CODE(WavyScrollerCodeStream, 2, 1, true);

			WavyScrollerCodeStream << "\t\tand #$07";
			OUTPUT_CODE(WavyScrollerCodeStream, 2, 2, true);

			WavyScrollerCodeStream << "\t\tbne WAVYSCROLLER_Blit_Line" << dec << int(BlitLineIndex) << "_CharSet" << CharSetShortName[CharSetIndex] << "_Loop";
			OUTPUT_CODE(WavyScrollerCodeStream, 3, 3, true);

			WavyScrollerCodeStream << "\t\trts";
			OUTPUT_CODE(WavyScrollerCodeStream, 6, 1, true);

			OUTPUT_BLANK_LINE();
		}
	}
}

char WAVY_ScrollText[] = "something stirs from the abyss...    ";
void WavyScroller_OutputScrolltext(LPCTSTR OutputScrollTextFilename)
{
	int ScrollTextLen = (int)strlen(WAVY_ScrollText);
	for (int ScrollTextPos = 0; ScrollTextPos < ScrollTextLen; ScrollTextPos++)
	{
		if (WAVY_ScrollText[ScrollTextPos] == '.')
		{
			WAVY_ScrollText[ScrollTextPos] = 26;
		}
		else if (WAVY_ScrollText[ScrollTextPos] == ',')
		{
			WAVY_ScrollText[ScrollTextPos] = 27;
		}
		else if (WAVY_ScrollText[ScrollTextPos] == '!')
		{
			WAVY_ScrollText[ScrollTextPos] = 28;
		}
		else if (WAVY_ScrollText[ScrollTextPos] == '"')
		{
			WAVY_ScrollText[ScrollTextPos] = 29;
		}
		else if (WAVY_ScrollText[ScrollTextPos] == '-')
		{
			WAVY_ScrollText[ScrollTextPos] = 30;
		}
		else if (WAVY_ScrollText[ScrollTextPos] == ' ')
		{
			WAVY_ScrollText[ScrollTextPos] = 31;
		}
		else
		{
			WAVY_ScrollText[ScrollTextPos] = (WAVY_ScrollText[ScrollTextPos] - 1) & 0x1f;
		}
	}
	WAVY_ScrollText[ScrollTextLen - 1] = -1;

	WriteBinaryFile(OutputScrollTextFilename, WAVY_ScrollText, ScrollTextLen);
}


int WavyScroller_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\WavyScroller");

	WavyScroller_OutputSinTables(L"..\\..\\Intermediate\\Built\\WavyScroller\\SinTables.bin");

	WavyScroller_OutputCharSetAndCode(L"..\\..\\Intermediate\\Built\\WavyScroller\\CharData.bin", L"..\\..\\Intermediate\\Built\\WavyScroller\\CharInfo.bin");

	/* Blit.asm */
	ofstream BlitASM;
	BlitASM.open("..\\..\\Intermediate\\Built\\WavyScroller\\Blit.asm");
	BlitASM << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	WavyScroller_OutputBlitCode(BlitASM);
	BlitASM.close();

	WavyScroller_OutputScrolltext(L"..\\..\\Intermediate\\Built\\WavyScroller\\ScrollText.bin");
	return 0;
}