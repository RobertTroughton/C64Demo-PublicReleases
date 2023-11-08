//; (c) 2018-2019, Genesis*Project

#include "..\Common\CodeGen.h"
#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define WAVE_WIDTH (24 * 8)
#define WAVE_HEIGHT 96
#define NUM_LAYERS 8
#define NUM_SINVALUES (WAVE_WIDTH * NUM_LAYERS)
#define IMAGE_WIDTH (WAVE_WIDTH)
#define IMAGE_HEIGHT (WAVE_HEIGHT * NUM_LAYERS)
#define WAVE_CHAR_WIDTH (WAVE_WIDTH / 8)
#define WAVE_CHAR_HEIGHT (WAVE_HEIGHT / 8)

void Waves_OutputImage(char* OutputFilename_WavesBMP, LPCTSTR OutputFilename_WavesIMAP, LPCTSTR OutputFilename_WavesISCR)
{
	unsigned char MAPData[IMAGE_HEIGHT][IMAGE_WIDTH / 8];
	ZeroMemory(MAPData, sizeof(MAPData));

	const unsigned char WhiteColour[] = { 255, 255, 255 };

	CImg<unsigned char> img(IMAGE_WIDTH, IMAGE_HEIGHT, 1, 3);
	img.fill(0);

	int SinTable[NUM_SINVALUES];
	GenerateSinTable(NUM_SINVALUES, 0, WAVE_HEIGHT - 1, 0, SinTable);

	for (int SinIndex = 0; SinIndex < NUM_SINVALUES; SinIndex++)
	{
		int SinValue = SinTable[SinIndex];
		int XPos = SinIndex / NUM_LAYERS;
		int Layer = SinIndex % NUM_LAYERS;
		int LayerMaxY = WAVE_HEIGHT * (Layer + 1);
		int YPos0 = LayerMaxY - 1 - SinValue;
		int YPos1 = LayerMaxY - 1;
		img.draw_line(XPos, YPos0, XPos, YPos1, WhiteColour);

		for (int YPos = YPos0; YPos <= YPos1; YPos++)
		{
			MAPData[YPos][XPos / 8] |= (0x80 >> (XPos % 8));
		}
	}

	int NumCharsUsed = 0;
	unsigned char CharsetData[4096][8];
	
	unsigned char CharScreen[WAVE_CHAR_HEIGHT][WAVE_CHAR_WIDTH][NUM_LAYERS];

	for (int LayerIndex = 0; LayerIndex < NUM_LAYERS; LayerIndex++)
	{
		for (int YCharIndex = 0; YCharIndex < WAVE_CHAR_HEIGHT; YCharIndex++)
		{
			for (int XCharIndex = 0; XCharIndex < WAVE_CHAR_WIDTH; XCharIndex++)
			{
				unsigned char ThisChar[8];
				for (int ByteIndex = 0; ByteIndex < 8; ByteIndex++)
				{
					ThisChar[ByteIndex] = MAPData[LayerIndex * WAVE_HEIGHT + YCharIndex * 8 + ByteIndex][XCharIndex];
				}

				int FoundIndex = -1;
				for (int CheckCharIndex = 0; CheckCharIndex < NumCharsUsed; CheckCharIndex++)
				{
					bool bMatch = true;
					for (int ByteIndex = 0; ByteIndex < 8; ByteIndex++)
					{
						if (ThisChar[ByteIndex] != CharsetData[CheckCharIndex][ByteIndex])
						{
							bMatch = false;
							break;
						}
					}
					if (bMatch)
					{
						FoundIndex = CheckCharIndex;
						break;
					}
				}

				if (FoundIndex == -1)
				{
					FoundIndex = NumCharsUsed++;
					for (int ByteIndex = 0; ByteIndex < 8; ByteIndex++)
					{
						CharsetData[FoundIndex][ByteIndex] = ThisChar[ByteIndex];
					}
				}

				CharScreen[YCharIndex][XCharIndex][LayerIndex] = (unsigned char)FoundIndex;
			}
		}
	}

	img.save_bmp(OutputFilename_WavesBMP);

	WriteBinaryFile(OutputFilename_WavesISCR, CharScreen, sizeof(CharScreen));
	WriteBinaryFile(OutputFilename_WavesIMAP, CharsetData, NumCharsUsed * 8);
}

int Waves_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\Waves");

	Waves_OutputImage("..\\..\\Intermediate\\Built\\Waves\\Waves.bmp", L"..\\..\\Intermediate\\Built\\Waves\\Waves.imap", L"..\\..\\Intermediate\\Built\\Waves\\Waves.iscr");

	return 0;
}
