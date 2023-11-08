//; (c) 2018-2019, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

void SpinnyShapes_RemapSprites(LPCTSTR InputSpriteFilename, LPCTSTR OutputSpriteFilename)
{
	unsigned char RemapTable[4] = { 0, 2, 1, 3 };
	ReadBinaryFile(InputSpriteFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	for (int ByteIndex = 0; ByteIndex < 12800; ByteIndex++)
	{
		unsigned char ByteVal = FileReadBuffer[ByteIndex];
		for (int XPixel = 0; XPixel < 4; XPixel++)
		{
			int BitShift = XPixel * 2;
			unsigned char BitMask = 3 << BitShift;
			unsigned char Value = (ByteVal & BitMask) >> BitShift;
			unsigned char RemappedValue = RemapTable[Value];

			ByteVal &= (0xff - BitMask);
			ByteVal |= (RemappedValue << BitShift);
		}
		FileReadBuffer[ByteIndex] = ByteVal;
	}

	WriteBinaryFile(OutputSpriteFilename, FileReadBuffer, 12800);
}

int SpinnyShapes_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\SpinnyShapes");

	SpinnyShapes_RemapSprites(L"..\\..\\SourceData\\SpinnyShapes\\sprite_vector_3d_3.map", L"..\\..\\Intermediate\\Built\\SpinnyShapes\\SpriteData.bin");

	return 0;
}

