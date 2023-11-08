//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\ImageConversion.h"

#define RS_REMOVESTATICCHARS_OPT 1

#define RS_NUM_ANIMS 64
#define RS_INPUTDATA_WIDTH 32
#define RS_INPUTDATA_HEIGHT 32
#define RS_INPUTDATA_SUBWIDTH 2
#define RS_INPUTDATA_SUBHEIGHT 2
#define RS_INPUTDATA_STRIDE (RS_INPUTDATA_WIDTH * RS_NUM_ANIMS)

#define RS_OUTPUTDATA_WIDTH (RS_INPUTDATA_WIDTH / RS_INPUTDATA_SUBWIDTH)
#define RS_OUTPUTDATA_HEIGHT (RS_INPUTDATA_HEIGHT / RS_INPUTDATA_SUBHEIGHT)
#define RS_OUTPUTDATA_SIZE (RS_NUM_ANIMS * RS_OUTPUTDATA_WIDTH * RS_OUTPUTDATA_HEIGHT)

#define NUM_SHAPES 4
int RS_ShapeCoordinates[NUM_SHAPES][2] = {
	{ 20, 5 },
	{ 12, -3 },
	{ 4, 5 },
	{ 12, 13 },
};

unsigned char RS_OutputData[RS_OUTPUTDATA_SIZE];

void Output_BMPBitmapToShapesAnimation(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, ofstream& file)
{
	static const int BMPBitmapDataOffset = 0x3e;

	ReadBinaryFile(InputFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	ZeroMemory(RS_OutputData, RS_OUTPUTDATA_SIZE);

	for (int AnimIndex = 0; AnimIndex < RS_NUM_ANIMS; AnimIndex++)
	{
		for (int YVal = 0; YVal < RS_INPUTDATA_HEIGHT; YVal += RS_INPUTDATA_SUBHEIGHT)
		{
			for (int XVal = 0; XVal < RS_INPUTDATA_WIDTH; XVal += RS_INPUTDATA_SUBWIDTH)
			{
				for (int SubYVal = 0; SubYVal < RS_INPUTDATA_SUBHEIGHT; SubYVal++)
				{
					for (int SubXVal = 0; SubXVal < RS_INPUTDATA_SUBWIDTH; SubXVal++)
					{
						int ReadXPos = XVal + SubXVal;
						int ReadYPos = YVal + SubYVal;
						int WriteXPos = XVal / RS_INPUTDATA_SUBWIDTH;
						int WriteYPos = YVal / RS_INPUTDATA_SUBHEIGHT;

						int ReadOffset = 0;
						ReadOffset += (RS_INPUTDATA_HEIGHT - 1 - ReadYPos) * RS_INPUTDATA_STRIDE;
						ReadOffset += AnimIndex * RS_INPUTDATA_WIDTH;
						ReadOffset += ReadXPos;
						unsigned char ReadBitMask = 1 << (7 - (ReadOffset % 8));
						ReadOffset /= 8;
						ReadOffset += BMPBitmapDataOffset;
						if ((FileReadBuffer[ReadOffset] & ReadBitMask) == 0)
						{
							int OutputOffset = AnimIndex + (WriteXPos + (WriteYPos * RS_OUTPUTDATA_WIDTH)) * RS_NUM_ANIMS;
							RS_OutputData[OutputOffset] |= 1 << ((RS_INPUTDATA_SUBHEIGHT - 1 - SubYVal) * 2 + (RS_INPUTDATA_SUBWIDTH - 1 - SubXVal));
						}
					}
				}
			}
		}
	}
	WriteBinaryFile(OutputDataFilename, RS_OutputData, RS_OUTPUTDATA_SIZE);

	unsigned char ScreenUsage_AtLeastOnce[1000];
	ZeroMemory(ScreenUsage_AtLeastOnce, sizeof(ScreenUsage_AtLeastOnce));
#if RS_REMOVESTATICCHARS_OPT
	int ScreenUsage_StaticValue[1000];
	memset(ScreenUsage_StaticValue, -1, sizeof(ScreenUsage_StaticValue));
#endif //; RS_REMOVESTATICCHARS_OPT
	for (int AnimFrame = 0; AnimFrame < RS_NUM_ANIMS; AnimFrame++)
	{
		for (int YPos = 0; YPos < RS_OUTPUTDATA_HEIGHT; YPos++)
		{
			for (int XPos = 0; XPos < RS_OUTPUTDATA_WIDTH; XPos++)
			{
				unsigned char ReadValue = RS_OutputData[((YPos * RS_OUTPUTDATA_WIDTH) + XPos) * RS_NUM_ANIMS + AnimFrame];
				if (ReadValue > 0)
				{
					for (int ShapeIndex = 0; ShapeIndex < NUM_SHAPES; ShapeIndex++)
					{
						int ShapeXPos = XPos + RS_ShapeCoordinates[ShapeIndex][0];
						int ShapeYPos = YPos + RS_ShapeCoordinates[ShapeIndex][1];
						if (ShapeXPos >= 0 && ShapeXPos < 40 && ShapeYPos >= 0 && ShapeYPos < 25)
						{
							ScreenUsage_AtLeastOnce[ShapeXPos + ShapeYPos * 40] |= (1 << ShapeIndex);
#if RS_REMOVESTATICCHARS_OPT
							if (AnimFrame == 0)
							{
								ScreenUsage_StaticValue[ShapeXPos + ShapeYPos * 40] = ReadValue;
							}
							else
							{
								if (ReadValue != ScreenUsage_StaticValue[ShapeXPos + ShapeYPos * 40])
								{
									ScreenUsage_StaticValue[ShapeXPos + ShapeYPos * 40] = -1;
								}
							}
#endif //; RS_REMOVESTATICCHARS_OPT
						}
					}
				}
			}
		}
	}

	ostringstream CodeStream;
	int TotalCycles = 0;
	int TotalSize = 0;

#if RS_REMOVESTATICCHARS_OPT
	CodeStream << "\tRS_DrawStaticShapes:";
	OUTPUT_CODE(CodeStream, 0, 0, true);

	unsigned char CurrentValue = 0xff;
	for (int Value = 0; Value < 256; Value++)
	{
		bool bFirst = true;
		for (int YPos = 0; YPos < 25; YPos++)
		{
			for (int XPos = 0; XPos < 40; XPos++)
			{
				unsigned char Pass;
				switch (ScreenUsage_AtLeastOnce[XPos + YPos * 40])
				{
					case 1:
					Pass = 0;
					break;

					case 2:
					Pass = 1;
					break;
					
					case 4:
					Pass = 2;
					break;

					case 8:
					Pass = 3;
					break;

					default:
					Pass = 255;
					break;
				}

				int StaticValue = ScreenUsage_StaticValue[XPos + YPos * 40];
				if (Pass & 1)
				{
					StaticValue *= 16;
				}
				if (StaticValue == Value)
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
					CodeStream << "\t\tstx ScreenAddress0 + $" << hex << setw(4) << setfill('0') << int(YPos * 40 + XPos) << setfill(' ');
					OUTPUT_CODE(CodeStream, 4, 3, true);
				}
			}

		}
	}
	CodeStream << "\t\t\trts";
	OUTPUT_CODE(CodeStream, 6, 1, true);
	OUTPUT_BLANK_LINE();
#endif //; RS_REMOVESTATICCHARS_OPT

	TotalCycles = 0;
	TotalSize = 0;

	CodeStream << "\tRS_DrawShapes:";
	OUTPUT_CODE(CodeStream, 0, 0, true);

	for (int Pass = 0; Pass < 16; Pass++)
	{
		static bool ValidPasses[16] = {
			false, true, true, true,	//; 0000 | 0001 | 0010 | 0011
			 true,false, true,false,	//; 0100 | 0101 | 0110 | 0111
			 true, true,false,false,	//; 1000 | 1001 | 1010 | 1011
			 true,false,false,false,	//; 1100 | 1101 | 1110 | 1111
		};
		if (!ValidPasses[Pass])
		{
			continue;
		}
		unsigned char XVal = 0;
		unsigned char YVal = 0;
		if ((Pass & 1) && (XVal != 0xFC))
		{
			CodeStream << "\t\tldx RS_Shape_Animations + 0";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			XVal = 0xFC;
		}
		if ((Pass & 2) && (YVal != 0xFD))
		{
			CodeStream << "\t\tldy RS_Shape_Animations + 1";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			YVal = 0xFD;
		}
		if ((Pass & 4) && (XVal != 0xFE))
		{
			CodeStream << "\t\tldx RS_Shape_Animations + 2";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			XVal = 0xFE;
		}
		if ((Pass & 8) && (YVal != 0xFF))
		{
			CodeStream << "\t\tldy RS_Shape_Animations + 3";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			YVal = 0xFF;
		}
		for (int YPos = 0; YPos < 25; YPos++)
		{
			for (int XPos = 0; XPos < 40; XPos++)
			{
				if (
					(ScreenUsage_AtLeastOnce[XPos + YPos * 40] == Pass)
#if RS_REMOVESTATICCHARS_OPT
					&& (ScreenUsage_StaticValue[XPos + YPos * 40] == -1)
#endif //; RS_REMOVESTATICCHARS_OPT
				)
				{
					switch (Pass)
					{
					case 1:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[0][0]) + (YPos - RS_ShapeCoordinates[0][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 2:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[1][0]) + (YPos - RS_ShapeCoordinates[1][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						break;

					case 4:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[2][0]) + (YPos - RS_ShapeCoordinates[2][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 8:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[3][0]) + (YPos - RS_ShapeCoordinates[3][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						break;

					case 3:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[1][0]) + (YPos - RS_ShapeCoordinates[1][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[0][0]) + (YPos - RS_ShapeCoordinates[0][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 6:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[1][0]) + (YPos - RS_ShapeCoordinates[1][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[2][0]) + (YPos - RS_ShapeCoordinates[2][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 9:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[3][0]) + (YPos - RS_ShapeCoordinates[3][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[0][0]) + (YPos - RS_ShapeCoordinates[0][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 12:
						CodeStream << "\t\tlda RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[3][0]) + (YPos - RS_ShapeCoordinates[3][1]) * 16) * 64) << ", y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora RS_ScreenAnims + $" << hex << setw(4) << setfill('0') << int(((XPos - RS_ShapeCoordinates[2][0]) + (YPos - RS_ShapeCoordinates[2][1]) * 16) * 64) << ", x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;
					}
					CodeStream << "\t\tsta ScreenAddress0 + $" << hex << setw(4) << setfill('0') << int(YPos * 40 + XPos) << setfill(' ');
					OUTPUT_CODE(CodeStream, 4, 3, true);
				}
			}
		}
		OUTPUT_BLANK_LINE();
	}
	CodeStream << "\t\t\trts";
	OUTPUT_CODE(CodeStream, 6, 1, true);
	OUTPUT_BLANK_LINE();
}

void OutputRotatingShapesSinTable(void)
{
	int SinTable[256];
	GenerateSinTable(256, 0, 63, 0, SinTable);
	unsigned char cSinTable[256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex] = (unsigned char)SinTable[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\RotatingShapes\\SinTable.bin", cSinTable, 256);
}

void Output2x2DoubleOrredCharset(LPCTSTR OutputDataFilename)
{
	unsigned char CharSet[256 * 8];
	ZeroMemory(CharSet, sizeof(CharSet));

	for (int BitsSet0 = 0; BitsSet0 < 16; BitsSet0++)
	{
		unsigned char OutputValue0 = 0;
		unsigned char OutputValue1 = 0;
		if (BitsSet0 & 1)
		{
			OutputValue1 |= 0x05;
		}
		if (BitsSet0 & 2)
		{
			OutputValue1 |= 0x50;
		}
		if (BitsSet0 & 4)
		{
			OutputValue0 |= 0x05;
		}
		if (BitsSet0 & 8)
		{
			OutputValue0 |= 0x50;
		}
		for (int BitsSet1 = 0; BitsSet1 < 16; BitsSet1++)
		{
			if (BitsSet1 & 1)
			{
				OutputValue1 |= 0x0a;
			}
			if (BitsSet1 & 2)
			{
				OutputValue1 |= 0xa0;
			}
			if (BitsSet1 & 4)
			{
				OutputValue0 |= 0x0a;
			}
			if (BitsSet1 & 8)
			{
				OutputValue0 |= 0xa0;
			}

			OutputValue0 ^= 0xaa;
			OutputValue1 ^= 0xaa;

			int CharIndex = (BitsSet1 * 16) + BitsSet0;
			CharSet[CharIndex * 8 + 0] = OutputValue0;
			CharSet[CharIndex * 8 + 1] = OutputValue0;
			CharSet[CharIndex * 8 + 2] = OutputValue0;
			CharSet[CharIndex * 8 + 3] = OutputValue0;
			CharSet[CharIndex * 8 + 4] = OutputValue1;
			CharSet[CharIndex * 8 + 5] = OutputValue1;
			CharSet[CharIndex * 8 + 6] = OutputValue1;
			CharSet[CharIndex * 8 + 7] = OutputValue1;

			OutputValue0 &= 0x55;
			OutputValue1 &= 0x55;
		}
	}
	WriteBinaryFile(OutputDataFilename, CharSet, 256 * 8);
}

int RotatingShapes_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\RotatingShapes");

	//; Rotating Shapes
	ofstream RSDrawingFile;
	RSDrawingFile.open("..\\..\\Intermediate\\Built\\RotatingShapes\\Draw.asm");
	RSDrawingFile << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	Output_BMPBitmapToShapesAnimation(L"..\\..\\SourceData\\RotatingShapes\\WheelAnims-32x32.bmp", L"..\\..\\Intermediate\\Built\\RotatingShapes\\ScreenAnims.bin", RSDrawingFile);
	Output2x2DoubleOrredCharset(L"..\\..\\Intermediate\\Built\\RotatingShapes\\CharSet.bin");
	OutputRotatingShapesSinTable();

	return 0;
}
