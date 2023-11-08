// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"

#define NUM_SPRITES_FOR_FULL_FADE 64
#define NUM_PIXELS_IN_SPRITE (24 * 21)
#define NUM_NEW_PIXELS_PER_SPRITE ((NUM_PIXELS_IN_SPRITE + (NUM_SPRITES_FOR_FULL_FADE - 1)) / NUM_SPRITES_FOR_FULL_FADE)

void OutputSpriteFadeData(LPCTSTR OutputFilename)
{
	unsigned char SpritePosUsed[NUM_PIXELS_IN_SPRITE];
	unsigned char SpriteOutputData[64];

	HANDLE hFile = CreateFile(OutputFilename, GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	DWORD dwBytesWritten;

	unsigned int CurrentNumPixels = 0;

	ZeroMemory(SpritePosUsed, NUM_PIXELS_IN_SPRITE);
	ZeroMemory(SpriteOutputData, 64);
	CurrentNumPixels = 0;
	for (unsigned int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_FOR_FULL_FADE; SpriteIndex++)
	{
		unsigned int TargetPixels = (NUM_PIXELS_IN_SPRITE * SpriteIndex) / (NUM_SPRITES_FOR_FULL_FADE - 1);
		unsigned int NumNewPixels = TargetPixels - CurrentNumPixels;
		CurrentNumPixels += NumNewPixels;
		for (unsigned int Loop = 0; Loop < NumNewPixels; Loop++)
		{
			bool bFound = false;
			while (!bFound)
			{
				unsigned int TryPos = rand() % (NUM_PIXELS_IN_SPRITE);
				if (SpritePosUsed[TryPos] == 0)
				{
					SpritePosUsed[TryPos] = 1;
					unsigned char OutputBits = 1;
					SpriteOutputData[TryPos / 8] |= OutputBits << (TryPos % 8);
					bFound = true;
				}
			}
		}
		WriteFile(hFile, SpriteOutputData, 64, &dwBytesWritten, NULL);
	}
	CloseHandle(hFile);
}

#define GrowingCircle_NumSpriteAnims 64
void OutputGrowingCircleSprites(LPCTSTR OutputSpriteFilename, LPCTSTR OutputSinTableFilename)
{
	unsigned char SpriteOutputData[GrowingCircle_NumSpriteAnims][64];
	ZeroMemory(SpriteOutputData, 64 * GrowingCircle_NumSpriteAnims);

	for (unsigned int SpriteAnim = 0; SpriteAnim < GrowingCircle_NumSpriteAnims; SpriteAnim++)
	{
		unsigned int SpriteAnim2 = (SpriteAnim + (GrowingCircle_NumSpriteAnims / 8)) % GrowingCircle_NumSpriteAnims;
		double CircleWidth = ((double)(SpriteAnim + 1)) / ((double)GrowingCircle_NumSpriteAnims);
		double CircleWidth2 = min(CircleWidth * 1.5, 1.0);
		for (unsigned int YPos = 0; YPos < 21; YPos++)
		{
			for (unsigned int XPos = 0; XPos < 24; XPos++)
			{
				unsigned int OutputOffset = (XPos / 8) + (YPos * 3);
				unsigned char OutputBit = 1 << (7 - (XPos % 8));
				unsigned char OutputMask = 0xFF - OutputBit;

				double fXPos = (10.0 - (double)XPos) / 10.0;
				double fYPos = (10.0 - (double)YPos) / 10.0;

				double DistFromCentre = sqrt(fXPos * fXPos + fYPos * fYPos);

				bool bShouldDrawPixel = ((DistFromCentre <= CircleWidth2) && (DistFromCentre >= CircleWidth));

				if (bShouldDrawPixel)
				{
					SpriteOutputData[SpriteAnim][OutputOffset] = (SpriteOutputData[SpriteAnim][OutputOffset] & OutputMask) | OutputBit;
				}
			}
		}
	}
	WriteBinaryFile(OutputSpriteFilename, SpriteOutputData, 64 * GrowingCircle_NumSpriteAnims);

	int SinTableX[256];
	int SinTableY[256];
	GenerateSinTable(256, 24, 115, 0, SinTableX);
	GenerateSinTable(256, 80, 200, 32, SinTableY); 

	unsigned char cSinTable[256 * 2 * 2];
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex + 256 * 0] = cSinTable[SinIndex + 256 * 1] = (unsigned char)(SinTableX[SinIndex]);
		cSinTable[SinIndex + 256 * 2] = cSinTable[SinIndex + 256 * 3] = (unsigned char)(SinTableY[SinIndex]);
	}
	WriteBinaryFile(OutputSinTableFilename, cSinTable, 256 * 2 * 2);
}

// (iv) Our planet-draw code
//	PLANET_DrawScreen_Buffer0:
//		lda #$ff
//		sta ScreenAddress0 + 2 * 40 + 8, x
//		sta ScreenAddress0 + 2 * 40 + 8, x
//		...
//
//		lda PLANET_CharLookups + 0, y
//		sta ScreenAddress0 + 2 * 40 + 8, x
//		sta ScreenAddress0 + 2 * 40 + 8, x
//		...

void WritePlanetDrawCode(ofstream& file)
{
	ostringstream PlanetDrawStream;
	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

	static const unsigned int CharWidth = 192 / 8;
	static const unsigned int CharHeight = 168 / 8;

	static const unsigned int CharMapWidth = 192 / 8 + 2;

	unsigned char CharMap[CharHeight][CharMapWidth];

	for (unsigned int YPos = 0; YPos < CharHeight; YPos++)
	{
		CharMap[YPos][0] = CharMap[YPos][CharMapWidth - 1] = 255;

		for (unsigned int XPos = 0; XPos < CharWidth; XPos++)
		{
			unsigned char CharValue = (YPos % 3) + ((XPos % 12) * 3);
			bool bShouldDraw = false;
			for (unsigned int SubYPos = 0; SubYPos < 8; SubYPos++)
			{
				double fYPos = ((double)(YPos * 8 + SubYPos) - 87.5) / 79.5;
				for (unsigned int SubXPos = 0; SubXPos < 8 + 7; SubXPos++) // nb. We need an additional 7 here to cover "smooth-scrolling"...
				{
					double fXPos = ((double)(XPos * 8 + SubXPos) - 95.5) / 87.0;
					double fDist = sqrt(fXPos * fXPos + fYPos * fYPos);
					if (fDist <= 1.0)
					{
						bShouldDraw = true;
					}
				}
			}
			CharMap[YPos][XPos + 1] = bShouldDraw ? CharValue : 255;
		}
	}

	for (unsigned int YPos = 0; YPos < CharHeight; YPos++)
	{
		for (unsigned int XPos = 0; XPos < CharMapWidth; XPos++)
		{
			bool bShouldDraw = CharMap[YPos][XPos] != 255 ? true : false;
			if (!bShouldDraw)
			{
				bool bShouldDrawPrev = false;
				bool bShouldDrawNext = false;

				if (XPos < (CharMapWidth - 1))
				{
					if (CharMap[YPos][XPos + 1] < 254)
					{
						bShouldDrawNext = true;
					}
				}
				if (XPos > 0)
				{
					if (CharMap[YPos][XPos - 1] < 254)
					{
						bShouldDrawPrev = true;
					}
				}

				if (bShouldDrawNext || bShouldDrawPrev)
				{
					CharMap[YPos][XPos] = 255;
				}
				else
				{
					CharMap[YPos][XPos] = 254; // 254 => don't draw this char...
				}
			}
		}
	}

	TotalCycles = 0;
	TotalSize = 0;

	for (unsigned int PlanetPart = 0; PlanetPart < 4; PlanetPart++)
	{
		PlanetDrawStream << "PLANET_DrawScreen_Part" << dec << int(PlanetPart) << ":";
		OUTPUT_CODE(PlanetDrawStream, 0, 0, true);

		for (unsigned int CharMatch = 0; CharMatch < 256; CharMatch++)
		{
			if (CharMatch == 254)
			{
				continue;
			}
			bool bFirstMatch = true;
			for (unsigned int YPos = 0; YPos < CharHeight; YPos++)
			{
				bool bShouldDoSomething = false;
				switch (PlanetPart)
				{
					case 0:
					if ((YPos >= 0 && YPos < 3) || (YPos >= 18 && YPos < 21))
						bShouldDoSomething = true;
					break;

					case 1:
					if ((YPos >= 3 && YPos < 6) || (YPos >= 15 && YPos < 18))
						bShouldDoSomething = true;
					break;

					case 2:
					if ((YPos >= 6 && YPos < 9) || (YPos >= 12 && YPos < 15))
						bShouldDoSomething = true;
					break;

					case 3:
					if (YPos >= 9 && YPos < 12)
						bShouldDoSomething = true;
					break;
				}
				if (bShouldDoSomething)
				{
					for (unsigned int XPos = 0; XPos < CharMapWidth; XPos++)
					{
						if (CharMap[YPos][XPos] == CharMatch)
						{
							if (bFirstMatch)
							{
								if (CharMatch != 255)
								{
									PlanetDrawStream << "\tlda PLANET_CharLookups + ($" << hex << setw(2) << setfill('0') << int((CharMatch / 3) + (CharMatch % 3) * (12 * 2)) << " * 4), y" << setfill(' ');
									OUTPUT_CODE(PlanetDrawStream, 4, 3, true);
								}
								else
								{
									PlanetDrawStream << "\tlda #$ff";
									OUTPUT_CODE(PlanetDrawStream, 2, 2, true);
								}
								bFirstMatch = false;
							}
							PlanetDrawStream << "\tsta ScreenAddress0 + " << dec << int(YPos + 1) << " * 40 + " << dec << int(XPos) << ", x";
							OUTPUT_CODE(PlanetDrawStream, 5, 3, true);
							PlanetDrawStream << "\tsta ScreenAddress1 + " << dec << int(YPos + 1) << " * 40 + " << dec << int(XPos) << ", x";
							OUTPUT_CODE(PlanetDrawStream, 5, 3, true);
						}
					}
				}
			}
			if (!bFirstMatch)
			{
				OUTPUT_BLANK_LINE();
			}
		}
		PlanetDrawStream << "\trts";
		OUTPUT_CODE(PlanetDrawStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}

	PlanetDrawStream << "PLANET_DrawScreen_Colours:";
	OUTPUT_CODE(PlanetDrawStream, 0, 0, true);
	for (unsigned int Pass = 0; Pass < 2; Pass++)
	{
		if (Pass == 0)
		{
			PlanetDrawStream << "\tlda #$00";
		}
		else
		{
			PlanetDrawStream << "\tlda #$0e";
		}
		OUTPUT_CODE(PlanetDrawStream, 2, 2, true);

		for (unsigned int YPos = 0; YPos < CharHeight; YPos++)
		{
			for (unsigned int XPos = 0; XPos < CharMapWidth; XPos++)
			{
				if ((Pass == 0 && CharMap[YPos][XPos] == 255) || (Pass == 1 && CharMap[YPos][XPos] < 254))
				{
					PlanetDrawStream << "\tsta $d800 + " << dec << int(YPos + 1) << " * 40 + " << dec << int(XPos) << ", x";
					OUTPUT_CODE(PlanetDrawStream, 5, 3, true);
				}
			}
		}
		OUTPUT_BLANK_LINE();
	}

	PlanetDrawStream << "\trts";
	OUTPUT_CODE(PlanetDrawStream, 6, 1, true);
	OUTPUT_BLANK_LINE();
}


void OutputWavyCircleSpritesAndChars(LPCTSTR OutputSpriteFilename, LPCTSTR OutputCharsFilename, LPCTSTR OutputSinTableFilename)
{
	// (i) our sprite circle mask..
	unsigned char SpriteCircleData[256][64];
	ZeroMemory(SpriteCircleData, 256 * 64);
	for (unsigned int SpriteIndex = 0; SpriteIndex < 64; SpriteIndex++)
	{
		unsigned int SpriteXIndex = SpriteIndex % 8;
		unsigned int SpriteYIndex = SpriteIndex / 8;

		unsigned int XSpriteOffset = 24 * SpriteXIndex;
		unsigned int YSpriteOffset = 21 * SpriteYIndex;

		for (unsigned int YPixelPos = 0; YPixelPos < 21; YPixelPos++)
		{
			unsigned int YPos = YSpriteOffset + YPixelPos;
			double fYPos = ((double)YPos - 87.5) / 79.5;
			for (unsigned int XPixelPos = 0; XPixelPos < 24; XPixelPos++)
			{
				unsigned int XPos = XSpriteOffset + XPixelPos;
				double fXPos = ((double)XPos - 95.5) / 87.0;

				double fDist = sqrt(fXPos * fXPos + fYPos * fYPos);

				bool bShouldDraw = false;
				if (fDist > 1.0)
				{
					bShouldDraw = true;
				}
				else if (fDist > 0.975)
				{
					bShouldDraw = rand() % 2 == 0 ? true : false;
				}
				else if (fDist > 0.95)
				{
					bShouldDraw = rand() % 4 == 0 ? true : false;
				}
				else if (fDist > 0.925)
				{
					bShouldDraw = rand() % 8 == 0 ? true : false;
				}

				if (bShouldDraw)
				{
					unsigned int OutputSprite = (YPos / 21) * 8 + (XPos / 24);
					unsigned int OutputOffset = (YPos % 21) * 3 + (XPos % 24) / 8;
					unsigned int OutputBit = 1 << (7 - (XPos % 8));
					unsigned int OutputMask = 0xFF - OutputBit;

					SpriteCircleData[OutputSprite][OutputOffset] = (SpriteCircleData[OutputSprite][OutputOffset] & OutputMask) | OutputBit;
				}
			}
		}
	}
	WriteBinaryFile(OutputSpriteFilename, SpriteCircleData, 8 * 8 * 64);
	// nb. a lot of the sprites will be blank .. we should optimize these out..!

// (ii) our wavy sin-chars
	int SinTable[192];
	GenerateSinTable(192, 2, 13, 0, SinTable);

	unsigned char CharData[4 * 12 * 3 * 8];
	ZeroMemory(CharData, 4 * 12 * 3 * 8);

	for (unsigned int XScroll = 0; XScroll < 4; XScroll++)
	{
		for (unsigned int XPos = 0; XPos < 12 * 8; XPos += 2)
		{
			int SinPos0 = SinTable[(XPos * 2 + XScroll * 4 + 0) % 192];
			int SinPos1 = SinTable[(XPos * 2 + XScroll * 4 + 64) % 192];
			int SinPos2 = SinTable[(XPos * 2 + XScroll * 4 + 128) % 192];

			unsigned int OutputOffset = (XScroll * 12 + (XPos / 8)) * 3 * 8;
			unsigned int OutputLeftShift = (6 - (XPos % 8));
			unsigned int OutputMask = 0xff - (3 << OutputLeftShift);

			for (unsigned int YPos = 0; YPos < 10; YPos++)
			{
				CharData[OutputOffset + YPos + SinPos0] = (CharData[OutputOffset + YPos + SinPos0] & (0xff - (3 << OutputLeftShift))) | (1 << OutputLeftShift);
			}
			for (unsigned int YPos = 0; YPos < 10; YPos++)
			{
				CharData[OutputOffset + YPos + SinPos1] = (CharData[OutputOffset + YPos + SinPos1] & (0xff - (3 << OutputLeftShift))) | (2 << OutputLeftShift);
			}
			for (unsigned int YPos = 0; YPos < 10; YPos++)
			{
				CharData[OutputOffset + YPos + SinPos2] = (CharData[OutputOffset + YPos + SinPos2] & (0xff - (3 << OutputLeftShift))) | (3 << OutputLeftShift);
			}
		}
	}
	// invert char data...
	for (unsigned int Index = 0; Index < 4 * 12 * 3 * 8; Index++)
	{
		CharData[Index] = 0xFF - CharData[Index];
	}
	WriteBinaryFile(OutputCharsFilename, CharData, 4 * 12 * 3 * 8);

	// (iii) X-Sintables for waving sprites
	int SinTableX[128];
	GenerateSinTable(128, 24, 344 - 192, 0, SinTableX);

	unsigned char cSinTable[128 * 2];
	for (unsigned int SinIndex = 0; SinIndex < 128; SinIndex++)
	{
		int SinValue = SinTableX[SinIndex];
		cSinTable[SinIndex] = (unsigned char)(SinValue & 0xFE); // due to the nature of the wavy-sign chars and how they're drawn, we need to lose the bottom bit of accuracy... double pixels!

		unsigned int FirstChar = (SinValue - 24) / 8;
		cSinTable[SinIndex + 128] = (unsigned char)(FirstChar);
	}
	WriteBinaryFile(OutputSinTableFilename, cSinTable, 128 * 2);

	/* FontsData.asm */
	ofstream PlanetDrawCodeFile;
	PlanetDrawCodeFile.open("..\\..\\Intermediate\\Built\\WavyLineCircle-DrawPlanet.asm");
	PlanetDrawCodeFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	WritePlanetDrawCode(PlanetDrawCodeFile);
	PlanetDrawCodeFile.close();
}



int SpriteEffects_Main(void)
{
	OutputSpriteFadeData(L"..\\..\\Intermediate\\Built\\SpriteEffects-FadeSprites.bin");
	OutputGrowingCircleSprites(L"..\\..\\Intermediate\\Built\\SpriteEffects-GrowingCircles-Sprites.bin", L"..\\..\\Intermediate\\Built\\SpriteEffects-GrowingCircles-SinTable.bin");
	OutputWavyCircleSpritesAndChars(L"..\\..\\Intermediate\\Built\\WavyLineCircle-Sprites.bin", L"..\\..\\Intermediate\\Built\\WavyLineCircle-Chars.bin", L"..\\..\\Intermediate\\Built\\WavyLineCircle-SpriteSinTable.bin");

	return 0;
}
