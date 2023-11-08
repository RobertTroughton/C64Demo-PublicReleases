// (c) 2018-2020, Genesis*Project

#include "Main.h"
#include "Common\Common.h"

int main()
{
	_mkdir("D64");
	_mkdir("Out");
	_mkdir("Out\\6502");
	_mkdir("Out\\6502\\Parts");
	_mkdir("Out\\6502\\Main");
	_mkdir("Out\\6502\\Misc");

	unsigned char* BlankBuffer = new unsigned char[65536];
	memset(BlankBuffer, 0x00, 65536);
	WriteBinaryFile(L"Out\\6502\\00Data.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0xFF, 65536);
	WriteBinaryFile(L"Out\\6502\\FFData.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0xAA, 65536);
	WriteBinaryFile(L"Out\\6502\\AAData.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0x55, 65536);
	WriteBinaryFile(L"Out\\6502\\55Data.bin", BlankBuffer, 65536);
	delete[] BlankBuffer;

	unsigned char* NibbleLookupTable = new unsigned char[256];
	for (int Index = 0; Index < 256; Index++)
	{
		unsigned char Val = (unsigned char)Index;
		NibbleLookupTable[Index] = Val >> 4;
	}
	WriteBinaryFile(L"Out\\6502\\NibbleLookup.bin", NibbleLookupTable, 256);
	delete[] NibbleLookupTable;

	unsigned char* FlipByteLookup = new unsigned char[256];
	for (int Index = 0; Index < 256; Index++)
	{
		FlipByteLookup[Index] = FlipByte(Index);
	}
	WriteBinaryFile(L"Out\\6502\\FlipByteLookup.bin", FlipByteLookup, 256);

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\AllBorderDoubleDYPP");
	AllBorderDoubleDYPP_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\AllBorderDYPP");
	AllBorderDYPP_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\BigMMLogo");
	BigMMLogo_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\BigScalingScroller");
	BigScalingScroller_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\CircleScroller");
	CircleScroller_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\Quote");
	Quote_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\RotatingGP");
	RotatingGP_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\SkullZoomer");
	SkullZoomer_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\SpritePlex");
	SpritePlex_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\TurnDiskDYPP");
	TurnDiskDYPP_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\VerticalSideBorderBitmap");
	VerticalSideBorderBitmap_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Misc\\SpriteTransitions");
	SpriteTransitions_Main();
}
