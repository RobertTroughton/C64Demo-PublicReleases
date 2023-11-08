// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

// Defines and data for Sprite stuff...

#define INPUT_WIDTH (32 * 24)
#define INPUT_HEIGHT 21

#define INPUT_NUM_SPRITES 32
#define OUTPUT_NUM_SPRITES (INPUT_NUM_SPRITES * 2)

#define NUM_SPRITES_FOR_SIN 16
#define NUM_ITERATIONS_FOR_SPRITE 8 //; Must be a factor of 24 for smooth scrolling...
#define SIN_LENGTH (NUM_SPRITES_FOR_SIN * NUM_ITERATIONS_FOR_SPRITE)

// Defines and data for Helix stuff...
#define COLOR_PIPE 1
#define COLOR_BACKFACE1 64
#define COLOR_BACKFACE2 65
#define COLOR_BACKFACE3 66
#define COLOR_RIBBON1 128
#define COLOR_RIBBON2 129
#define COLOR_RIBBON3 130

template<class T> T sign(T val) { return val < 0 ? T(-1) : T(1); }
const static int blockSize = 8;
const static int helixOutputWidth = 48;
const static int helixOutputCharWidth = helixOutputWidth / 8;
const static int helixOutputHeight = 96;
const static int helixOutputCharHeight = helixOutputHeight / 8;
const static int helixCentre = 48;
const static int helixRadius = blockSize * 6;												// 12 characters in height
const static double Pi = 3.1415926536;
const static int helixBarWidth = blockSize;
const static double helixPitchBlocks = 3;
const static double helixPitch = helixPitchBlocks * double(helixBarWidth / 2);				// must be a multiple of 1/2 the helixBarWidth to join correctly
const static int numBars = 1 + (helixOutputWidth + int(helixPitch * 2) + helixBarWidth * 2 - 1) / (helixBarWidth * 2);
const static int startOffset = -int(helixPitch) * 2;
const static double dHelixRadius = double(helixRadius) - 0.5f;
const static double dHelixCentre = double(helixCentre) - 0.5f;
unsigned char helixPixelData[helixOutputHeight][helixOutputWidth];

const static int bitmapOutputWidth = (helixOutputWidth / (int)helixPitchBlocks) * 2;			// multicolour - double pixels!
const static int bitmapOutputHeight = helixOutputHeight;
const static int bitmapOutputCharWidth = bitmapOutputWidth / 8;
const static int bitmapOutputCharHeight = bitmapOutputHeight / 8;
const static int bitmapOutputColourCharWidth = (bitmapOutputWidth * (int)helixPitchBlocks) / 8;	// because we have 3 colours
const static int bitmapOutputColourCharHeight = bitmapOutputHeight / 8;
unsigned char BitmapData[bitmapOutputCharHeight][bitmapOutputCharWidth][8];
unsigned char BitmapScreen[bitmapOutputColourCharHeight][bitmapOutputColourCharWidth];
unsigned char BitmapColour[bitmapOutputColourCharHeight][bitmapOutputColourCharWidth];

unsigned char ScrollText[] = {
	"    ... i call this 'the tri-colour helix with hi-res sprite scroll' ... or TTCHWHRSS for short ...         \0"
};

void GreetingsPart_OutputSpriteData(LPCTSTR InputFilename, LPCTSTR OutputFilename)
{
	static const int BMPDataOffset = 0x46;
	static unsigned char ColourRemap[4] = { 0, 3, 2, 1 };
	static unsigned char BitMasks[4] = { 0x3f, 0xcf, 0xf3, 0xfc };

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned int SrcImageStride = (INPUT_WIDTH + 3) & 0xfffffffc;

	unsigned char SpriteOutput[OUTPUT_NUM_SPRITES * 64];
	ZeroMemory(SpriteOutput, OUTPUT_NUM_SPRITES * 64);
	for (unsigned int SpriteIndex = 0; SpriteIndex < INPUT_NUM_SPRITES; SpriteIndex++)
	{
		for (unsigned int YVal = 0; YVal < 21; YVal++)
		{
			for (unsigned int XVal = 0; XVal < 24; XVal++)
			{
				unsigned int ReadOffset = 0;
				ReadOffset += BMPDataOffset;
				ReadOffset += SpriteIndex * 24;
				ReadOffset += (21 - 1 - YVal) * SrcImageStride;
				ReadOffset += XVal;
				unsigned char PixelColour = FileReadBuffer[ReadOffset];
				unsigned char PixelColourRemapped = ColourRemap[PixelColour];

				unsigned int OutputOffset = 0;
				OutputOffset += 128 * SpriteIndex;
				OutputOffset += (XVal / 12) * 64;
				OutputOffset += (XVal % 12) / 4;
				OutputOffset += YVal * 3;
				unsigned char OutputMask = BitMasks[(XVal % 4)];
				unsigned int OutputLeftShift = (3 - (XVal % 4)) * 2;

				SpriteOutput[OutputOffset] = (SpriteOutput[OutputOffset] & OutputMask) | (PixelColourRemapped << OutputLeftShift);

			}
		}
	}
	WriteBinaryFile(OutputFilename, SpriteOutput, OUTPUT_NUM_SPRITES * 64);
}

void GreetingsPart_OutputSinTables(LPCTSTR OutputFilename)
{
	unsigned char ColourLookup[4] = { 1, 15, 12, 11 };
	int SinTable[SIN_LENGTH];
	GenerateSinTable(SIN_LENGTH, 57, 196, 32, SinTable);

	unsigned char cSinTable[SIN_LENGTH * 10];
	for (unsigned int SinIndex = 0; SinIndex < SIN_LENGTH; SinIndex++)
	{
		cSinTable[SinIndex + SIN_LENGTH * 0] = cSinTable[SinIndex + SIN_LENGTH * 1] = (unsigned char)(SinTable[SinIndex]);
		cSinTable[SinIndex + SIN_LENGTH * 2] = cSinTable[SinIndex + SIN_LENGTH * 3] = (SinIndex > SIN_LENGTH / 2) ? 1 : 0;
		cSinTable[SinIndex + SIN_LENGTH * 4] = cSinTable[SinIndex + SIN_LENGTH * 5] = (unsigned char)((SinIndex * 3) & 255);
		cSinTable[SinIndex + SIN_LENGTH * 6] = cSinTable[SinIndex + SIN_LENGTH * 7] = (unsigned char)((SinIndex * 3) / 256);

		unsigned char Col = 3;
		switch (SinIndex / 16)
		{
			case 1:
			case 2:
				Col = 0;
				break;

			case 0:
			case 3:
				Col = 1;
				break;

			case 7:
			case 4:
				Col = 2;
				break;
		}

		cSinTable[SinIndex + SIN_LENGTH * 8] = cSinTable[SinIndex + SIN_LENGTH * 9] = ColourLookup[Col];
	}
	WriteBinaryFile(OutputFilename, cSinTable, SIN_LENGTH * 10);
}

void GreetingsPart_OutputCode(ofstream& file)
{
	unsigned int TotalCycles;
	unsigned int TotalSize;

	ostringstream HelixBitmapCodeStream;

	unsigned int LoopCount = 0;

	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Scroll Text
	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	TotalCycles = TotalSize = 0;
	HelixBitmapCodeStream << "GREET_ScrollText:";
	OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
	int ScrollTextPos = 0;
	bool bFinished = false;
	while(!bFinished)
	{
		unsigned char CurrentChar = ScrollText[ScrollTextPos];
		if (CurrentChar == 0)
		{
			bFinished = true;
			CurrentChar = 255;
		}
		else if (CurrentChar == '!')
		{
			CurrentChar = 27;
		}
		else if (CurrentChar == '\'')
		{
			CurrentChar = 28;
		}
		else if (CurrentChar == '.')
		{
			CurrentChar = 29;
		}
		else if (CurrentChar == ',')
		{
			CurrentChar = 30;
		}
		else if (CurrentChar == '-')
		{
			CurrentChar = 31;
		}
		else
		{
			CurrentChar = CurrentChar & 31;
		}
		if (!(ScrollTextPos & 15))
		{
			HelixBitmapCodeStream << "\t\t.byte";
		}
		HelixBitmapCodeStream << " $" << hex << setw(2) << setfill('0') << int(CurrentChar) << setfill(' ');
		if ((ScrollTextPos & 15) != 15 && !bFinished)
		{
			HelixBitmapCodeStream << ", ";
		}
		else
		{
			OUTPUT_CODE(HelixBitmapCodeStream, 0, (ScrollTextPos & 15) + 1, true);
		}
		ScrollTextPos++;
	}

	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Bitmap Copy
	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	for (int Base = 0; Base < 2; Base++)
	{
		TotalCycles = TotalSize = 0;
		HelixBitmapCodeStream << "Helix_Bitmap_Copy_Base" << dec << int(Base) << ":";
		OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
		for (int Page = 0; Page < 2; Page++)
		{
			for (int XLine = 0; XLine < 4; XLine++)
			{
				HelixBitmapCodeStream << "\tHelix_Loop_" << dec << int(LoopCount) << "_Base" << dec << int(Base) << ":";
				OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);

				for (int CharValue = 0; CharValue < 256; CharValue++)
				{
					bool bCharWasLoaded = false;

					for (int YPos = 0; YPos < helixOutputHeight; YPos++)
					{
						unsigned int OutputOffset = ((YPos / 8) + 6) * 40 * 8 + (YPos % 8) + (Page * 256);// +(XLine * 8) - 24;

						if (CharValue == BitmapData[YPos / 8][XLine][YPos % 8])
						{
							if (!bCharWasLoaded)
							{
								HelixBitmapCodeStream << "\t\tlda #$" << hex << setw(2) << setfill('0') << int(CharValue);
								OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
								bCharWasLoaded = true;
							}
							HelixBitmapCodeStream << "\t\tsta GREET_HelixOutputBitmapData" << dec << int(Base) << " + $" << hex << setw(4) << setfill('0') << int(OutputOffset) << setfill(' ') << ", y";
							OUTPUT_CODE(HelixBitmapCodeStream, 5, 3, true);
						}
					}
				}
				HelixBitmapCodeStream << "\t\ttya";
				OUTPUT_CODE(HelixBitmapCodeStream, 2, 1, true);
				HelixBitmapCodeStream << "\t\tclc";
				OUTPUT_CODE(HelixBitmapCodeStream, 2, 1, true);
				HelixBitmapCodeStream << "\t\tadc #$20";
				OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
				if (Page == 1)
				{
					HelixBitmapCodeStream << "\t\tcmp #$40";
					OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
				}
				HelixBitmapCodeStream << "\t\tbcs Skip_Helix_Loop_" << dec << int(LoopCount) << "_Base" << dec << int(Base);
				OUTPUT_CODE(HelixBitmapCodeStream, 3, 2, true);
				HelixBitmapCodeStream << "\t\ttay";
				OUTPUT_CODE(HelixBitmapCodeStream, 2, 1, true);
				HelixBitmapCodeStream << "\t\tjmp Helix_Loop_" << dec << int(LoopCount) << "_Base" << dec << int(Base);
				OUTPUT_CODE(HelixBitmapCodeStream, 3, 3, true);
				HelixBitmapCodeStream << "\tSkip_Helix_Loop_" << dec << int(LoopCount) << "_Base" << dec << int(Base) << ":";
				OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
				if ((XLine != 3) || (Page != 1))
				{
					HelixBitmapCodeStream << "\t\tclc";
					OUTPUT_CODE(HelixBitmapCodeStream, 2, 1, true);
					HelixBitmapCodeStream << "\t\tadc #$08";
					OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
					HelixBitmapCodeStream << "\t\tand #$1f";
					OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
					HelixBitmapCodeStream << "\t\ttay";
					OUTPUT_CODE(HelixBitmapCodeStream, 2, 1, true);
				}
				OUTPUT_BLANK_LINE();
				LoopCount++;
			}
		}
		HelixBitmapCodeStream << "\t\trts";
		OUTPUT_CODE(HelixBitmapCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}

	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Colour Copy
	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	TotalCycles = TotalSize = 0;
	HelixBitmapCodeStream << "Helix_Colour_Copy:";
	OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
	for (int XLine = 0; XLine < 40 + 11; XLine++)
	{
		int XPos = XLine % 12;
		HelixBitmapCodeStream << "\tHelix_ColLine" << dec << int(XLine) << ":";
		OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);

		for (int ColValue = 0; ColValue < 256; ColValue++)
		{
			bool bColWasLoaded = false;

			for (int YPos = 0; YPos < helixOutputCharHeight; YPos++)
			{
				if (ColValue == BitmapColour[YPos][XPos])
				{
					if (!bColWasLoaded)
					{
						HelixBitmapCodeStream << "\t\tlda #$" << hex << setw(2) << setfill('0') << int(ColValue);
						OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
						bColWasLoaded = true;
					}
					HelixBitmapCodeStream << "\t\tsta GREET_HelixOutputColourData + (" << dec << int(YPos + 6) << " * 40) + "<< dec << int(XLine) << " - 11, y";
					OUTPUT_CODE(HelixBitmapCodeStream, 5, 3, true);
				}
			}
		}
	}
	HelixBitmapCodeStream << "\tHelix_ColLine_FIN:";
	OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
	HelixBitmapCodeStream << "\t\trts";
	OUTPUT_CODE(HelixBitmapCodeStream, 6, 1, true);
	OUTPUT_BLANK_LINE();

	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Screen Copy
	// -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	for (int Bank = 0; Bank < 2; Bank++)
	{
		TotalCycles = TotalSize = 0;
		HelixBitmapCodeStream << "Helix_Screen_Copy_Bank" << dec << int(Bank) << ":";
		OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
		for (int XLine = 0; XLine < 40 + 11; XLine++)
		{
			int XPos = XLine % 12;
			HelixBitmapCodeStream << "\tHelix_ScrLine" << dec << int(XLine) << "_Bank" << dec << int(Bank) << ":";
			OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);

			for (int ColValue = 0; ColValue < 256; ColValue++)
			{
				bool bColWasLoaded = false;

				for (int YPos = 0; YPos < helixOutputCharHeight; YPos++)
				{
					if (ColValue == BitmapScreen[YPos][XPos])
					{
						if (!bColWasLoaded)
						{
							HelixBitmapCodeStream << "\t\tlda #$" << hex << setw(2) << setfill('0') << int(ColValue);
							OUTPUT_CODE(HelixBitmapCodeStream, 2, 2, true);
							bColWasLoaded = true;
						}
						HelixBitmapCodeStream << "\t\tsta GREET_HelixOutputScreenData" << dec << int(Bank) << " + (" << dec << int(YPos + 6) << " * 40) + " << dec << int(XLine) << " - 11, y";
						OUTPUT_CODE(HelixBitmapCodeStream, 5, 3, true);
					}
				}
			}
		}
		HelixBitmapCodeStream << "\tHelix_ScrLine_FIN_Bank" << dec << int(Bank) << ":";
		OUTPUT_CODE(HelixBitmapCodeStream, 0, 0, true);
		HelixBitmapCodeStream << "\t\trts";
		OUTPUT_CODE(HelixBitmapCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
}

void RenderHelix(bool bFront)
{
	double offset = (int(helixPitchBlocks) % 2)*helixBarWidth;
	double signmul = -1.0;

	if (bFront)
	{
		offset = 0;
		signmul = 1.0;
	}

	for (int iY = -helixRadius; iY < helixRadius; ++iY)
	{
		double t = signmul * asin(double(iY) / dHelixRadius)*(2.0 / Pi);
		int YValue = (iY + helixCentre);

		if (!bFront && ((YValue == 31) || (YValue == 39) || (YValue == 64) || (YValue == 56)))
		{
			continue;
		}

		double dX = helixPitch * t + offset;

		int iX = int(dX + 0.5*sign(dX)) + startOffset;

		for (int n = 0; n < numBars; ++n)
		{
			for (int i = 0; i < helixBarWidth; ++i)
			{
				int XValue = iX + i + n * helixBarWidth * 2;
				if (XValue >= 0 && XValue < helixOutputWidth && YValue >= 0 && YValue < helixOutputHeight)
				{
					helixPixelData[YValue][XValue] = bFront ? COLOR_RIBBON1 + (n % 3) : COLOR_BACKFACE1 + ((n + 2) % 3);
				}
			}
		}
	}
}

void GreetingsPart_GenerateHelix(LPCTSTR OutputFilename)
{
	ZeroMemory(helixPixelData, helixOutputWidth * helixOutputHeight);

	// render back face
	RenderHelix(false);

	// render centre bar
	for (int BarY = 3 * 8; BarY < 9 * 8; BarY++)
	{
		if ((BarY != 31) && (BarY != 39) && (BarY != 64) && (BarY != 56))
		{
			for (int BarX = 0; BarX < helixOutputWidth; BarX++)
			{
				helixPixelData[BarY][BarX] = COLOR_PIPE;
			}
		}
	}

	// render front face
	RenderHelix(true);

	// write out the RAW file for testing in Photoshop
	WriteBinaryFile(OutputFilename, helixPixelData, helixOutputWidth * helixOutputHeight);

	ZeroMemory(BitmapData, bitmapOutputCharHeight * bitmapOutputCharWidth * 8);
	ZeroMemory(BitmapScreen, bitmapOutputColourCharHeight * bitmapOutputColourCharWidth);
	ZeroMemory(BitmapColour, bitmapOutputColourCharHeight * bitmapOutputColourCharWidth);

	for (int YChar = 0; YChar < bitmapOutputColourCharHeight; YChar++)
	{
		for (int XChar = 0; XChar < bitmapOutputColourCharWidth; XChar++)
		{
			unsigned char BitmapCol;
			unsigned char BFBitmapCol = 0x02;
			switch (YChar)
			{
				case 3:
				case 8:
				BitmapCol = 0x0b;
				break;

				case 4:
				BitmapCol = 0x01;
				break;

				case 5:
				case 6:
				BitmapCol = 0x0f;
				break;

				case 7:
				BitmapCol = 0x0c;
				break;

				default:
				BitmapCol = 0x00;
				break;
			}

			unsigned char ScreenCol = 0x0a;	// We choose one of the colours from below so that our pre-gen'ed code is optimal 
			for (unsigned int YLookup = 0; YLookup < 8; YLookup++)
			{
				int YPos = YChar * 8 + YLookup;
				for (unsigned int XLookup = 0; XLookup < 4; XLookup++)
				{
					int XPos = (XChar * 4 + XLookup) % helixOutputWidth;
					unsigned char Color = helixPixelData[YPos][XPos];
					switch (Color)
					{
						case COLOR_RIBBON1: ScreenCol = 0x0e; break;
						case COLOR_RIBBON2: ScreenCol = 0x0a; break;
						case COLOR_RIBBON3: ScreenCol = 0x04; break;
						case COLOR_BACKFACE1: BFBitmapCol = 0x06; break;
						case COLOR_BACKFACE2: BFBitmapCol = 0x08; break;
						case COLOR_BACKFACE3: BFBitmapCol = 0x09; break;
					}
				}
			}
			BitmapColour[YChar][XChar] = BitmapCol == 0x00 ? BFBitmapCol : BitmapCol;
			BitmapScreen[YChar][XChar] = ScreenCol;
		}
	}

	for (int YPos = 0; YPos < bitmapOutputHeight; YPos++)
	{
		int YCharPos = YPos / 8;
		int YBitPos = YPos % 8;
		for (int XPos = 0; XPos < bitmapOutputWidth; XPos+=2)
		{
			int XCharPos = XPos / 8;
			int XBitPos = (XPos % 8);

			unsigned char Color = 0;
			int HelixReadXPos = (XPos / 2) % helixOutputWidth;
			if (YPos < helixOutputHeight)
			{
				Color = helixPixelData[YPos][HelixReadXPos];
			}

			unsigned char OutputBits = 0;
			switch(Color)
			{
				case COLOR_RIBBON1:
				case COLOR_RIBBON2:
				case COLOR_RIBBON3:
				OutputBits = 2;
				break;

				case COLOR_PIPE:
				case COLOR_BACKFACE1:
				case COLOR_BACKFACE2:
				case COLOR_BACKFACE3:
				OutputBits = 3;
				break;

				default:
				OutputBits = 0;
				break;
			}

			BitmapData[YCharPos][XCharPos][YBitPos] |= (OutputBits << (6 - XBitPos));
		}
	}

	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Greetings-HelixBitmapData.bin", BitmapData, bitmapOutputWidth * bitmapOutputHeight / 8);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Greetings-HelixBitmapScreen.bin", BitmapScreen, bitmapOutputColourCharWidth * bitmapOutputColourCharHeight);
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Greetings-HelixBitmapColour.bin", BitmapColour, bitmapOutputColourCharWidth * bitmapOutputColourCharHeight);

	// Output the assembly code for drawing the helix...
	ofstream HelixCodeFile;
	HelixCodeFile.open("..\\..\\Intermediate\\Built\\Greetings-HelixCode.asm");
	HelixCodeFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	GreetingsPart_OutputCode(HelixCodeFile);
	HelixCodeFile.close();

}

int GreetingsPart_Main()
{
	Output_BMPBitmapToSpriteData(L"..\\..\\SourceData\\SpriteFont-48x21x32x1Colsx1Bit-NoDither.bmp", L"..\\..\\Intermediate\\Built\\Greetings-SpriteFont.bin", 64, false);

	GreetingsPart_OutputSinTables(L"..\\..\\Intermediate\\Built\\Greetings-SinTable.bin");
	GreetingsPart_GenerateHelix(L"..\\..\\Intermediate\\Built\\Greetings-HelixData.raw");

	return 0;
}




