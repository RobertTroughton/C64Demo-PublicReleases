//; (c)2018, Raistlin / Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

unsigned char WAVYSNAKE_OutputCharSet[4][256][8];

void WavySnake_Output_4BitPaletteToDYCPLogoData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, int ImageWidth, int ImageHeight, bool bInvertPixels)
{
	unsigned char ColorRemap[4] = {1, 2, 3, 0};	//3201
	static const int BMPDataOffset = 0x46;

	ZeroMemory(WAVYSNAKE_OutputCharSet, 4 * 256 * 8);

	ReadBinaryFile(InputFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	int ReadStride = ImageWidth;
	int WriteStride = (ImageWidth / 4) & 0xFFFFFFF8;
	for (int CharSetIndex = 0; CharSetIndex < 4; CharSetIndex++)
	{
		for (int YPos = 0; YPos < ImageHeight; YPos++)
		{
			for (int XPos = 0; XPos < ImageWidth; XPos++)
			{
				unsigned char ReadValue;

				int XReadPosition = XPos;
				int YReadPosition = YPos;

				int YWritePosition = YPos;
				int XWritePosition = XPos * 2;

				YReadPosition -= CharSetIndex * 2;
				if (YReadPosition < 0)
				{
					ReadValue = 3;
				}
				else
				{
					//; Make the texture repeat on the body part
					if (YPos >= 64 && YReadPosition < 64)
					{
						YReadPosition += 64;
					}

					//; Invert Y because, yeah, BMP
					YReadPosition = ImageHeight - 1 - YReadPosition;

					int ReadOffset = BMPDataOffset + YReadPosition * ReadStride + XReadPosition;
					unsigned char* ReadPtr = &FileReadBuffer[ReadOffset];

					ReadValue = ReadPtr[0] & 3;
				}

				unsigned char WriteValue = ColorRemap[ReadValue];

				int OutputChar = (YWritePosition / 8) * WriteStride + (XWritePosition / 8);
				int OutputOffset = YWritePosition & 7;

				unsigned char OutputShift = (6 - (XWritePosition & 7));

				WAVYSNAKE_OutputCharSet[CharSetIndex][OutputChar][OutputOffset] |= (WriteValue << OutputShift);
			}
		}
		for (int OutputOffset = 0; OutputOffset < 8; OutputOffset++)
		{
			WAVYSNAKE_OutputCharSet[CharSetIndex][255][OutputOffset] = 0;
		}
	}
	WriteBinaryFile(OutputDataFilename, WAVYSNAKE_OutputCharSet, 4 * 256 * 8);
}

int WavySnake_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\WavySnake");

	//; Sideways Logo
	WavySnake_Output_4BitPaletteToDYCPLogoData(L"..\\..\\SourceData\\WavySnake\\snake.bmp", L"..\\..\\Intermediate\\Built\\WavySnake\\charset.bin", 32, 256, false);

	int WavySnake_SinTab[128];
	GenerateSinTable(128, 0, 24, 0, WavySnake_SinTab); //; make it "Only" wave by 3 chars (+1 pixel)... the additional 7 pixels come from the diagonal. We only have memory for 4 screens otherwise we could do a 56-pixel amplitude!

	unsigned char WavySnake_SinTab_CharAndPixelOffset[2][8][2][128];
	for (int XOffset = 0; XOffset < 8; XOffset++)
	{
		for (int Index = 0; Index < 128; Index++)
		{
			WavySnake_SinTab_CharAndPixelOffset[0][XOffset][0][Index] =
				WavySnake_SinTab_CharAndPixelOffset[0][XOffset][1][Index] =
				((max(0, min(56, WavySnake_SinTab[Index])) + XOffset) / 8) * 16;
			WavySnake_SinTab_CharAndPixelOffset[1][XOffset][0][Index] =
				WavySnake_SinTab_CharAndPixelOffset[1][XOffset][1][Index] =
				((max(0, min(56, WavySnake_SinTab[Index])) + XOffset) % 8) + 16;
		}
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\WavySnake\\SinTables.bin", WavySnake_SinTab_CharAndPixelOffset, 128 * 2 * 8 * 2);

	return 0;
}
