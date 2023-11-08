// (c) 2018-2020, Genesis*Project

#include "Main.h"
#include "Common\Common.h"

int main()
{
	_mkdir("Out");
	_mkdir("Out\\6502");
	_mkdir("Out\\6502\\Parts");
	_mkdir("Out\\6502\\Main");

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

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\ChristmasBall");
	ChristmasBall_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\GreetingScroller");
	GreetingScroller_Main();

	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\ProudlyPresent");
	ProudlyPresent_Main();
		
	srand(0x98093de3);
	_mkdir("Out\\6502\\Parts\\TechTechTree");
	TechTechTree_Main();
}
