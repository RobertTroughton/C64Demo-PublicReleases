// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

#define RS_REMOVESTATICCHARS_OPT 1

#define RS_NUM_ANIMS 64
#define RS_INPUTDATA_WIDTH 32
#define RS_INPUTDATA_HEIGHT 32
#define RS_INPUTDATA_SUBWIDTH 2
#define RS_INPUTDATA_SUBHEIGHT 2

#define RS_OUTPUTDATA_WIDTH (RS_INPUTDATA_WIDTH / RS_INPUTDATA_SUBWIDTH)
#define RS_OUTPUTDATA_HEIGHT (RS_INPUTDATA_HEIGHT / RS_INPUTDATA_SUBHEIGHT)
#define RS_OUTPUTDATA_SIZE (RS_NUM_ANIMS * RS_OUTPUTDATA_WIDTH * RS_OUTPUTDATA_HEIGHT)

#define SCREEN_ANIM_DATA_ADDRESS 0x8000

#define NUM_STARS 4
int StarCoordinates[NUM_STARS][2] = {
	{ 20, 5 },
	{ 12, -3 },
	{ 4, 5 },
	{ 12, 13 },
};

void Output_BMPBitmapToStarsAnimation(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, ofstream& file)
{
	static const int BMPBitmapDataOffset = 0x3e;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned char OutputData[RS_OUTPUTDATA_SIZE];
	ZeroMemory(OutputData, RS_OUTPUTDATA_SIZE);

	for (unsigned int AnimIndex = 0; AnimIndex < RS_NUM_ANIMS; AnimIndex++)
	{
		for (unsigned int YVal = 0; YVal < RS_INPUTDATA_HEIGHT; YVal += RS_INPUTDATA_SUBHEIGHT)
		{
			for (unsigned int XVal = 0; XVal < RS_INPUTDATA_WIDTH; XVal += RS_INPUTDATA_SUBWIDTH)
			{
				for (unsigned int SubYVal = 0; SubYVal < RS_INPUTDATA_SUBHEIGHT; SubYVal++)
				{
					for (unsigned int SubXVal = 0; SubXVal < RS_INPUTDATA_SUBWIDTH; SubXVal++)
					{
						unsigned int ReadXPos = XVal + SubXVal;
						unsigned int ReadYPos = YVal + SubYVal;
						unsigned int WriteXPos = XVal / RS_INPUTDATA_SUBWIDTH;
						unsigned int WriteYPos = YVal / RS_INPUTDATA_SUBHEIGHT;

						unsigned int ReadOffset = 0;
						ReadOffset += (RS_INPUTDATA_HEIGHT - 1 - ReadYPos) * RS_INPUTDATA_WIDTH * RS_NUM_ANIMS;
						ReadOffset += AnimIndex * RS_INPUTDATA_WIDTH;
						ReadOffset += ReadXPos;
						unsigned char ReadBitMask = 1 << (7 - (ReadOffset % 8));
						ReadOffset /= 8;
						ReadOffset += BMPBitmapDataOffset;
						if ((FileReadBuffer[ReadOffset] & ReadBitMask) == 0)
						{
							unsigned int OutputOffset = AnimIndex + (WriteXPos + (WriteYPos * RS_OUTPUTDATA_WIDTH)) * RS_NUM_ANIMS;
							OutputData[OutputOffset] |= 1 << ((RS_INPUTDATA_SUBHEIGHT - 1 - SubYVal) * 2 + (RS_INPUTDATA_SUBWIDTH - 1 - SubXVal));
						}
					}
				}
			}
		}
	}
	WriteBinaryFile(OutputDataFilename, OutputData, RS_OUTPUTDATA_SIZE);

	unsigned char ScreenUsage_AtLeastOnce[1000];
	ZeroMemory(ScreenUsage_AtLeastOnce, sizeof(ScreenUsage_AtLeastOnce));
	unsigned char ScreenUsage_Always[1000];
	memset(ScreenUsage_Always, 0xff, sizeof(ScreenUsage_Always));
#if RS_REMOVESTATICCHARS_OPT
	int ScreenUsage_StaticValue[1000];
	memset(ScreenUsage_StaticValue, -1, sizeof(ScreenUsage_StaticValue));
#endif // RS_REMOVESTATICCHARS_OPT
	for (unsigned int AnimFrame = 0; AnimFrame < RS_NUM_ANIMS; AnimFrame++)
	{
		for (int YPos = 0; YPos < RS_OUTPUTDATA_HEIGHT; YPos++)
		{
			for (int XPos = 0; XPos < RS_OUTPUTDATA_WIDTH; XPos++)
			{
				unsigned char ReadValue = OutputData[((YPos * RS_OUTPUTDATA_WIDTH) + XPos) * RS_NUM_ANIMS + AnimFrame];
				if (ReadValue > 0)
				{
					for (unsigned int StarIndex = 0; StarIndex < NUM_STARS; StarIndex++)
					{
						int StarXPos = XPos + StarCoordinates[StarIndex][0];
						int StarYPos = YPos + StarCoordinates[StarIndex][1];
						if (StarXPos >= 0 && StarXPos < 40 && StarYPos >= 0 && StarYPos < 25)
						{
							ScreenUsage_AtLeastOnce[StarXPos + StarYPos * 40] |= (1 << StarIndex);
#if RS_REMOVESTATICCHARS_OPT
							if (AnimFrame == 0)
							{
								ScreenUsage_StaticValue[StarXPos + StarYPos * 40] = ReadValue;
							}
							else
							{
								if (ReadValue != ScreenUsage_StaticValue[StarXPos + StarYPos * 40])
								{
									ScreenUsage_StaticValue[StarXPos + StarYPos * 40] = -1;
								}
							}
#endif // RS_REMOVESTATICCHARS_OPT
						}
					}
				}
			}
		}
	}

	ostringstream CodeStream;
	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

#if RS_REMOVESTATICCHARS_OPT
	CodeStream << "\tRS_DrawStaticStars:";
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
#endif // RS_REMOVESTATICCHARS_OPT

	TotalCycles = 0;
	TotalSize = 0;

	CodeStream << "\tRS_DrawStars:";
	OUTPUT_CODE(CodeStream, 0, 0, true);

	for (unsigned int Pass = 0; Pass < 16; Pass++)
	{
		static bool ValidPasses[16] = {
			false, true, true, true,	// 0000 | 0001 | 0010 | 0011
			true,false, true,false,	// 0100 | 0101 | 0110 | 0111
			true, true,false,false,	// 1000 | 1001 | 1010 | 1011
			true,false,false,false,	// 1100 | 1101 | 1110 | 1111
		};
		if (!ValidPasses[Pass])
		{
			continue;
		}
		unsigned char XVal = 0;
		unsigned char YVal = 0;
		if ((Pass & 1) && (XVal != 0xFC))
		{
			CodeStream << "\t\tldx $fc";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			XVal = 0xFC;
		}
		if ((Pass & 2) && (YVal != 0xFD))
		{
			CodeStream << "\t\tldy $fd";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			YVal = 0xFD;
		}
		if ((Pass & 4) && (XVal != 0xFE))
		{
			CodeStream << "\t\tldx $fe";
			OUTPUT_CODE(CodeStream, 3, 2, true);
			XVal = 0xFE;
		}
		if ((Pass & 8) && (YVal != 0xFF))
		{
			CodeStream << "\t\tldy $ff";
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
#endif // RS_REMOVESTATICCHARS_OPT
				)
				{
					switch (Pass)
					{
					case 1:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[0][0]) + (YPos - StarCoordinates[0][1]) * 16) * 64) << ",x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 2:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[1][0]) + (YPos - StarCoordinates[1][1]) * 16) * 64) << ",y" << setfill(' ');
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
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[2][0]) + (YPos - StarCoordinates[2][1]) * 16) * 64) << ",x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 8:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[3][0]) + (YPos - StarCoordinates[3][1]) * 16) * 64) << ",y" << setfill(' ');
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
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[1][0]) + (YPos - StarCoordinates[1][1]) * 16) * 64) << ",y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[0][0]) + (YPos - StarCoordinates[0][1]) * 16) * 64) << ",x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 6:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[1][0]) + (YPos - StarCoordinates[1][1]) * 16) * 64) << ",y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[2][0]) + (YPos - StarCoordinates[2][1]) * 16) * 64) << ",x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 9:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[3][0]) + (YPos - StarCoordinates[3][1]) * 16) * 64) << ",y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[0][0]) + (YPos - StarCoordinates[0][1]) * 16) * 64) << ",x" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						break;

					case 12:
						CodeStream << "\t\tlda $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[3][0]) + (YPos - StarCoordinates[3][1]) * 16) * 64) << ",y" << setfill(' ');
						OUTPUT_CODE(CodeStream, 4, 3, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tasl";
						OUTPUT_CODE(CodeStream, 2, 1, true);
						CodeStream << "\t\tora $" << hex << setw(4) << setfill('0') << int(SCREEN_ANIM_DATA_ADDRESS + ((XPos - StarCoordinates[2][0]) + (YPos - StarCoordinates[2][1]) * 16) * 64) << ",x" << setfill(' ');
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

void OutputRotatingStarsSinTable(void)
{
	int SinTable[256];
	GenerateSinTable(256, 0, 63, 0, SinTable);
	unsigned char cSinTable[256];
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable[SinIndex] = (unsigned char)SinTable[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\RotatingStars-SinTable.bin", cSinTable, 256);
}

void Output2x2DoubleOrredCharset(LPCTSTR OutputDataFilename)
{
	unsigned char CharSet[256 * 8];
	ZeroMemory(CharSet, 256 * 8);

	for (unsigned int BitsSet0 = 0; BitsSet0 < 16; BitsSet0++)
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
		for (unsigned int BitsSet1 = 0; BitsSet1 < 16; BitsSet1++)
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

			unsigned int CharIndex = (BitsSet1 * 16) + BitsSet0;
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

void Output_BMPBitmapGreetingsToSpriteData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, LPCTSTR OutputDataCompressedFilename, LPCTSTR OutputMappingsFilename, unsigned int Width, unsigned int Height, bool bInvertPixels)
{
	static const int BMPBitmapDataOffset = 0x3e;

	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned char SpriteOutput[1024][64];
	ZeroMemory(SpriteOutput, 1024 * 64);

	unsigned char SpriteMappings[1024];

	unsigned char CurrentSpriteOutput[64];

	unsigned int NumInputSpritesX = (Width / 24);
	unsigned int NumInputSpritesY = (Height / 21);
	unsigned int NumInputSprites = NumInputSpritesX * NumInputSpritesY;

	unsigned int ReadStride = ((Width / 8) + 3) & 0xfffffffc;

	unsigned int NumOutputSprites = 0;

	for (unsigned int SpriteIndex = 0; SpriteIndex < NumInputSprites; SpriteIndex++)
	{
		ZeroMemory(CurrentSpriteOutput, 64);

		unsigned int XStart = (SpriteIndex % NumInputSpritesX) * 24;
		unsigned int YStart = (SpriteIndex / NumInputSpritesX) * 21;

		for (unsigned int YVal = 0; YVal < 21; YVal++)
		{
			for (unsigned int XVal = 0; XVal < 3; XVal++)
			{
				unsigned int ReadOffset = (XStart / 8) + XVal + (Height - 1 - (YStart + YVal)) * ReadStride;

				unsigned char Value = 255 - FileReadBuffer[BMPBitmapDataOffset + ReadOffset];

				CurrentSpriteOutput[YVal * 3 + XVal] = Value;
			}
		}

		// Check for duplicates...
		for (unsigned int SpriteByte = 0; SpriteByte < 63; SpriteByte++)
		{
			SpriteOutput[NumOutputSprites][SpriteByte] = CurrentSpriteOutput[SpriteByte];
		}
		SpriteMappings[SpriteIndex] = (unsigned char)NumOutputSprites;
		NumOutputSprites++;
	}

	unsigned int NumSpriteSets = NumOutputSprites / (8 * 6);
	for (unsigned int SpriteSet = 0; SpriteSet < NumSpriteSets; SpriteSet++)
	{
		wstring OutputSpriteSetFilename = L"..\\..\\Intermediate\\Built\\Greetings-Sprites" + to_wstring(SpriteSet) + L".bin";
		WriteBinaryFile(OutputSpriteSetFilename.c_str(), &SpriteOutput[SpriteSet * 8 * 6], 64 * 8 * 6);
	}
}

int RotatingStars_Main()
{
	// Rotating Stars
	ofstream RSDrawingFile;
	RSDrawingFile.open("..\\..\\Intermediate\\Built\\RotatingStars-Draw.asm");
	RSDrawingFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	Output_BMPBitmapToStarsAnimation(L"..\\..\\SourceData\\Star\\StarAnims-32x32.bmp", L"..\\..\\Intermediate\\Built\\RotatingStars-ScreenAnims.bin", RSDrawingFile);
	Output2x2DoubleOrredCharset(L"..\\..\\Intermediate\\Built\\RotatingStars-CharSet.bin");
	OutputRotatingStarsSinTable();

	int SinTableSpriteXLeft[256];
	int SinTableSpriteXRight[256];
	GenerateSinTable(256, -(24 * 7), 88, 64, SinTableSpriteXLeft);
	GenerateSinTable(256, 88, 320 + 24, 192, SinTableSpriteXRight);

	unsigned char CSinTable[9][256];
	ZeroMemory(CSinTable, 9 * 256);

	for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
	{
		for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
		{
			int SinValue;
			if (SinIndex < 128)
			{
				SinValue = 88 + 24 * SpriteIndex;
				if (SinIndex < 64)
				{
					SinValue = SinTableSpriteXLeft[SinIndex * 2] + 24 * SpriteIndex;
				}
			}
			else
			{
				SinValue = 344;
				if (SinIndex < 192)
				{
					SinValue = SinTableSpriteXRight[((SinIndex - 128) * 2) + 128] + 24 * SpriteIndex;
				}
			}

			int MSB = 0;
			if (SinValue < 0)
			{
				SinValue = 0;
			}
			if (SinValue > 320 + 24)
			{
				SinValue = 320 + 24;
			}
			if(SinValue > 255)
			{
				SinValue &= 255;
				MSB = 1;
			}
			CSinTable[SpriteIndex][SinIndex] = (unsigned char)SinValue;
			CSinTable[8][SinIndex] |= (MSB << SpriteIndex);
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Greetings-SpriteSinTables.bin", CSinTable, 9 * 256);

	// Sprite Greetings
	Output_BMPBitmapGreetingsToSpriteData(L"..\\..\\SourceData\\Greetings-Sprites.bmp", L"..\\..\\Intermediate\\Built\\Greetings-Sprites.bin", L"..\\..\\Intermediate\\Built\\Greetings-Sprites-Compressed.bin", L"..\\..\\Intermediate\\Built\\Greetings-Sprites-Mappings.bin", 192, 1134, false);
	return 0;
}
