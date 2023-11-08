//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define FSRT_INPUTDATA_WIDTH 80
#define FSRT_INPUTDATA_HEIGHT 50
#define FSRT_INPUTDATA_SUBWIDTH 2
#define FSRT_INPUTDATA_SUBHEIGHT 2
#define FSRT_NUM_THINGS 4

#define FSRT_OUTPUTDATA_WIDTH (FSRT_INPUTDATA_WIDTH / FSRT_INPUTDATA_SUBWIDTH)
#define FSRT_OUTPUTDATA_HEIGHT (FSRT_INPUTDATA_HEIGHT / FSRT_INPUTDATA_SUBHEIGHT)
#define FSRT_OUTPUTDATA_SIZE (FSRT_NUM_THINGS * FSRT_MAX_NUM_ANIMS * FSRT_OUTPUTDATA_WIDTH * FSRT_OUTPUTDATA_HEIGHT)

#define FSRT_MAX_NUM_ANIMS 16

int FSRT_NumAnims[4] = { 8,16,16,16 };
unsigned char FSRT_OutputData[FSRT_OUTPUTDATA_HEIGHT][FSRT_OUTPUTDATA_WIDTH][FSRT_NUM_THINGS][FSRT_MAX_NUM_ANIMS];

void Output_BMPBitmapToFullScreenRotatingThings(LPCTSTR InputFilename, LPCTSTR CodeFilename, LPCTSTR DataFilename)
{
	static const int BMPBitmapDataOffset = 0x3e;

	ReadBinaryFile(InputFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	ZeroMemory(FSRT_OutputData, FSRT_OUTPUTDATA_SIZE);

	//; 1: Generate our animation data
	for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
	{
		for (int AnimIndex = 0; AnimIndex < FSRT_NumAnims[ThingIndex]; AnimIndex++)
		{
			for (int YVal = 0; YVal < FSRT_INPUTDATA_HEIGHT; YVal += FSRT_INPUTDATA_SUBHEIGHT)
			{
				for (int XVal = 0; XVal < FSRT_INPUTDATA_WIDTH; XVal += FSRT_INPUTDATA_SUBWIDTH)
				{
					for (int SubYVal = 0; SubYVal < FSRT_INPUTDATA_SUBHEIGHT; SubYVal++)
					{
						for (int SubXVal = 0; SubXVal < FSRT_INPUTDATA_SUBWIDTH; SubXVal++)
						{
							int ReadXPos = XVal + SubXVal;
							int ReadYPos = YVal + SubYVal;
							int WriteXPos = XVal / FSRT_INPUTDATA_SUBWIDTH;
							int WriteYPos = YVal / FSRT_INPUTDATA_SUBHEIGHT;

							int ReadOffset = 0;
							ReadOffset += ((FSRT_INPUTDATA_HEIGHT * (FSRT_NUM_THINGS - ThingIndex)) - 1 - ReadYPos) * FSRT_INPUTDATA_WIDTH * FSRT_MAX_NUM_ANIMS;
							ReadOffset += AnimIndex * FSRT_INPUTDATA_WIDTH;
							ReadOffset += ReadXPos;
							unsigned char ReadBitMask = 1 << (7 - (ReadOffset % 8));
							ReadOffset /= 8;
							ReadOffset += BMPBitmapDataOffset;
							if ((FileReadBuffer[ReadOffset] & ReadBitMask) != 0) //!!!
							{
								unsigned char BitShift = (FSRT_INPUTDATA_SUBHEIGHT - 1 - SubYVal) * 2 + (FSRT_INPUTDATA_SUBWIDTH - 1 - SubXVal);	//; [0,3]
								FSRT_OutputData[WriteYPos][WriteXPos][ThingIndex][AnimIndex] |= 1 << BitShift;
							}
						}
					}
				}
			}
		}
	}

	//; 2: Work out what bits of the animation touches each part of the screen
	unsigned char ScreenUsage_TouchMap[25][40];
	ZeroMemory(ScreenUsage_TouchMap, 25 * 40);

	unsigned char ScreenUsage_MissMap[25][40];
	ZeroMemory(ScreenUsage_MissMap, 25 * 40);

	unsigned char ScreenUsage_AlterationMap[25][40];
	ZeroMemory(ScreenUsage_AlterationMap, 25 * 40);

	unsigned char ScreenUsage_StaticValue[25][40];
	ZeroMemory(ScreenUsage_StaticValue, 25 * 40);

	unsigned char ScreenUsage_IsStatic[25][40];
	ZeroMemory(ScreenUsage_IsStatic, 25 * 40);

	for (int YPos = 0; YPos < FSRT_OUTPUTDATA_HEIGHT; YPos++)
	{
		for (int XPos = 0; XPos < FSRT_OUTPUTDATA_WIDTH; XPos++)
		{
			for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
			{
				unsigned char ThingBit = 1 << ThingIndex;

				for (int AnimIndex = 0; AnimIndex < FSRT_NumAnims[ThingIndex]; AnimIndex++)
				{
					unsigned char ReadValue = FSRT_OutputData[YPos][XPos][ThingIndex][AnimIndex];
					if (ReadValue != 0x00)
					{
						ScreenUsage_MissMap[YPos][XPos] |= ThingBit;
					}
					else
					{
						ScreenUsage_TouchMap[YPos][XPos] |= ThingBit;
					}
				}
			}
			ScreenUsage_AlterationMap[YPos][XPos] = ScreenUsage_TouchMap[YPos][XPos] & ScreenUsage_MissMap[YPos][XPos];
		}
	}

	for (int YPos = 0; YPos < FSRT_OUTPUTDATA_HEIGHT; YPos++)
	{
		for (int XPos = 0; XPos < FSRT_OUTPUTDATA_WIDTH; XPos++)
		{
			if (ScreenUsage_AlterationMap[YPos][XPos] == 0)
			{
				bool bDone = false;
				for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
				{
					if (!bDone)
					{
						unsigned char ThingBit = 1 << ThingIndex;
						if (ScreenUsage_TouchMap[YPos][XPos] & ThingBit)
						{
							unsigned char ReadValue = FSRT_OutputData[YPos][XPos][ThingIndex][0];
							ReadValue += 0x40 * ThingIndex;
							ScreenUsage_StaticValue[YPos][XPos] = ReadValue;
							ScreenUsage_IsStatic[YPos][XPos] = 1;
							bDone = true;
						}
					}
				}
			}
		}
	}
	ostringstream CodeStream;
	int TotalCycles, TotalSize;

	//; 3: Code for drawing all the static parts - ie. the bits of the screen that never change...
	{
		ofstream file;
		file.open(CodeFilename);
		file << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;

		TotalCycles = TotalSize = 0;

		CodeStream << "FSRT_DrawStaticThings:";
		OUTPUT_CODE(CodeStream, 0, 0, true);

		unsigned char CurrentValue = 0xff;
		for (int Value = 0; Value < 256; Value++)
		{
			bool bFirst = true;
			for (int YPos = 0; YPos < 25; YPos++)
			{
				for (int XPos = 0; XPos < 40; XPos++)
				{
					if ((ScreenUsage_IsStatic[YPos][XPos] == 1) && (ScreenUsage_StaticValue[YPos][XPos] == Value))
					{
						if (bFirst)
						{
							if (Value == (CurrentValue + 1))
							{
								CodeStream << "\t\tinx";
								OUTPUT_CODE(CodeStream, 2, 1, true);
							}
							else
							{
								CodeStream << "\t\tldx #$" << hex << setw(2) << setfill('0') << int(Value) << setfill(' ');
								OUTPUT_CODE(CodeStream, 2, 2, true);
							}
							CurrentValue = Value;
							bFirst = false;
						}
						CodeStream << "\t\tstx ScreenAddress0 + (" << dec << int(YPos) << " * 40) + " << int(XPos);
						OUTPUT_CODE(CodeStream, 4, 3, true);
					}
				}
			}
		}
		CodeStream << "\t\trts";
		OUTPUT_CODE(CodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();

		//; 4: Output code for drawing the animating parts...
		static unsigned char PassMatches[11] = {
			(1 << 0),
			(1 << 0) | (1 << 1),
			(1 << 1),
			(1 << 1) | (1 << 2),
			(1 << 2),
			(1 << 2) | (1 << 3),
			(1 << 3),
			(1 << 3) | (1 << 4),
			(1 << 4),
			(1 << 4) | (1 << 5),
			(1 << 5)
		};
		TotalCycles = TotalSize = 0;

		CodeStream << "FSRT_DrawAnimatedThings:";
		OUTPUT_CODE(CodeStream, 0, 0, true);

		unsigned char FSRT_DoneMap[25][40];
		ZeroMemory(FSRT_DoneMap, 25 * 40);

		for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
		{
			bool bFirst = true;
			for (int YPos = 0; YPos < 25; YPos++)
			{
				for (int XPos = 0; XPos < 40; XPos++)
				{
					//; Skip over any bits with static data
					if (ScreenUsage_IsStatic[YPos][XPos] == 1)
					{
						continue;
					}

					if (!FSRT_DoneMap[YPos][XPos])
					{
						if (bFirst)
						{
							CodeStream << "\tFSRT_Index_Thing" << dec << int(ThingIndex) << "A:";
							OUTPUT_CODE(CodeStream, 0, 0, true);
							CodeStream << "\t\tldx #$00";
							OUTPUT_CODE(CodeStream, 2, 2, true);
							CodeStream << "\tFSRT_Index_Thing" << dec << int(ThingIndex) << "B:";
							OUTPUT_CODE(CodeStream, 0, 0, true);
							CodeStream << "\t\tldy #$00";
							OUTPUT_CODE(CodeStream, 2, 2, true);
							CodeStream << "\t\tlda FSRT_SinTable, x";
							OUTPUT_CODE(CodeStream, 4, 3, true);
							CodeStream << "\t\tclc";
							OUTPUT_CODE(CodeStream, 2, 1, true);
							CodeStream << "\t\tadc FSRT_SinTable, y";
							OUTPUT_CODE(CodeStream, 4, 3, true);
							CodeStream << "\t\tand #$" << hex << setw(2) << setfill('0') << int(FSRT_NumAnims[ThingIndex] - 1) << setfill(' ');
							OUTPUT_CODE(CodeStream, 2, 2, true);
							CodeStream << "\t\ttax";
							OUTPUT_CODE(CodeStream, 2, 1, true);
							bFirst = false;
						}

						unsigned char Alt0 = ScreenUsage_AlterationMap[YPos][XPos] & (1 << ThingIndex);
						if (Alt0)
						{
							CodeStream << "\t\tlda FSRT_ScreenAnimData_X" << dec << int(XPos) << "_Y" << dec << int(YPos) << ", x";
							OUTPUT_CODE(CodeStream, 4, 3, true);

							CodeStream << "\t\tsta ScreenAddress0 + (" << dec << int(YPos) << " * 40) + " << int(XPos);
							OUTPUT_CODE(CodeStream, 4, 3, true);
							FSRT_DoneMap[YPos][XPos] = 1;
						}
					}
				}
			}
			OUTPUT_BLANK_LINE();
		}
		CodeStream << "\t\trts";
		OUTPUT_CODE(CodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();

		//; 5: Output ColourD800 Output Code
		TotalCycles = TotalSize = 0;

		CodeStream << "\tFSRT_ScreenColourData:";
		OUTPUT_CODE(CodeStream, 0, 0, true);
		for (int YPos = 0; YPos < 25; YPos++)
		{
			for (int XPos = 0; XPos < 40; XPos++)
			{
				if ((XPos % 20) == 0)
				{
					CodeStream << "\t\t.byte ";
				}
				unsigned char Colour = 0x03;
				if (ScreenUsage_IsStatic[YPos][XPos] == 1)
				{
					Colour = ScreenUsage_StaticValue[YPos][XPos] / 64;
				}
				else
				{
					for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
					{
						unsigned char Alt0 = ScreenUsage_AlterationMap[YPos][XPos] & (1 << ThingIndex);
						if (Alt0)
						{
							Colour = ThingIndex;
							break;
						}
					}
				}
				CodeStream << "$" << hex << setw(2) << setfill('0') << int(Colour) << setfill(' ');
				if ((XPos % 20) != 19)
				{
					CodeStream << ", ";
				}
				else
				{
					OUTPUT_CODE(CodeStream, 0, 20, true);
				}
			}
		}
	}

	{
		ofstream file;
		file.open(DataFilename);
		file << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;

	//; 6: Output data to go with the code in (4)...
		TotalCycles = TotalSize = 0;

		CodeStream << ".align $10";
		OUTPUT_CODE(CodeStream, 0, 0, true);
		CodeStream << "FSRT_ScreenAnimData:";
		OUTPUT_CODE(CodeStream, 0, 0, true);

		unsigned char FSRT_DoneMap[25][40];
		ZeroMemory(FSRT_DoneMap, 25 * 40);

		for (int ThingIndex = 0; ThingIndex < FSRT_NUM_THINGS; ThingIndex++)
		{
			for (int YPos = 0; YPos < 25; YPos++)
			{
				for (int XPos = 0; XPos < 40; XPos++)
				{
					if (!FSRT_DoneMap[YPos][XPos])
					{
						//; Skip over any bits with static data
						if (ScreenUsage_IsStatic[YPos][XPos] == 1)
						{
							continue;
						}

						unsigned char Alt0 = ScreenUsage_AlterationMap[YPos][XPos] & (1 << ThingIndex);
						if (Alt0)
						{
							CodeStream << "\tFSRT_ScreenAnimData_X" << dec << int(XPos) << "_Y" << dec << int(YPos) << ":";
							OUTPUT_CODE(CodeStream, 0, 0, true);
							CodeStream << "\t\t.byte ";
							for (int AnimIndex = 0; AnimIndex < FSRT_NumAnims[ThingIndex]; AnimIndex++)
							{
								unsigned char Value = FSRT_OutputData[YPos][XPos][ThingIndex][AnimIndex];
								Value += 0x40 * ThingIndex;
								CodeStream << "$" << hex << setfill('0') << setw(2) << int(Value) << setfill(' ');
								if (AnimIndex != (FSRT_NumAnims[ThingIndex] - 1))
								{
									CodeStream << ", ";
								}
							}
							OUTPUT_CODE(CodeStream, 0, FSRT_NumAnims[ThingIndex], true);
							FSRT_DoneMap[YPos][XPos] = 1;
						}
					}
				}
			}
		}

	}
}

void Output2x2OrredCharset(LPCTSTR OutputDataFilename)
{
	unsigned char CharSet[256 * 8];
	ZeroMemory(CharSet, 256 * 8);

	for (int BitsSet0 = 0; BitsSet0 < 16; BitsSet0++)
	{
		unsigned char OutputValue0, OutputValue1;

		OutputValue0 = 0;
		OutputValue1 = 0;

		if (BitsSet0 & 1)
		{
			OutputValue1 |= 0x0f;
		}
		if (BitsSet0 & 2)
		{
			OutputValue1 |= 0xf0;
		}
		if (BitsSet0 & 4)
		{
			OutputValue0 |= 0x0f;
		}
		if (BitsSet0 & 8)
		{
			OutputValue0 |= 0xf0;
		}
		unsigned char OutputValue0Copy = OutputValue0;
		unsigned char OutputValue1Copy = OutputValue1;

		OutputValue0 = (OutputValue0Copy & 0xdb) | (OutputValue1Copy & 0x24);
		OutputValue1 = (OutputValue1Copy & 0xdb) | (OutputValue0Copy & 0x24);

		int CharIndex;
		CharIndex = BitsSet0;
		CharSet[CharIndex * 8 + 0] = OutputValue0;
		CharSet[CharIndex * 8 + 1] = OutputValue0;
		CharSet[CharIndex * 8 + 2] = OutputValue1;
		CharSet[CharIndex * 8 + 3] = OutputValue0;
		CharSet[CharIndex * 8 + 4] = OutputValue1;
		CharSet[CharIndex * 8 + 5] = OutputValue0;
		CharSet[CharIndex * 8 + 6] = OutputValue1;
		CharSet[CharIndex * 8 + 7] = OutputValue1;
	}
	WriteBinaryFile(OutputDataFilename, CharSet, 16 * 8);
}

void OutputFSRTSinTable(void)
{
	int SinTable[256];
	GenerateSinTable(256, 0, 47, 0, SinTable);
	unsigned char cSinTable[256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex] = ((unsigned char)SinTable[SinIndex]) & 15;
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\FullScreenRotatingThings\\SinTable.bin", cSinTable, 256);
}

int FullScreenRotatingThings_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\FullScreenRotatingThings");

	Output2x2OrredCharset(L"..\\..\\Intermediate\\Built\\FullScreenRotatingThings\\CharSet.bin");
	OutputFSRTSinTable();
	Output_BMPBitmapToFullScreenRotatingThings(L"..\\..\\SourceData\\FullScreenRotatingThings\\Spinny.bmp", L"..\\..\\Intermediate\\Built\\FullScreenRotatingThings\\Draw.asm", L"..\\..\\Intermediate\\Built\\FullScreenRotatingThings\\Data.asm");

	return 0;
}
