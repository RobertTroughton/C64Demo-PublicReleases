// (c) Genesis*Project

#define _SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING
#include <experimental/filesystem>

#include "Main.h"
#include "Common\Common.h"

int main()
{
	char temp[512];
	sprintf_s(temp, "Taskkill /im x64sc.exe /f /fi \"status eq running\" > nul");
	system((char*)temp);

	_mkdir("Build");
	_mkdir("Build\\6502");
	_mkdir("Link");
	_mkdir("Build\\6502\\MAIN");
	_mkdir("Link\\MAIN");
	_mkdir("D64");

	unsigned char* BlankBuffer = new unsigned char[65536];
	memset(BlankBuffer, 0x00, 65536);
	WriteBinaryFile(L"Link\\00Data.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0xFF, 65536);
	WriteBinaryFile(L"Link\\FFData.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0xAA, 65536);
	WriteBinaryFile(L"Link\\AAData.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0x55, 65536);
	WriteBinaryFile(L"Link\\55Data.bin", BlankBuffer, 65536);
	memset(BlankBuffer, 0x9C, 65536);
	WriteBinaryFile(L"Link\\9CData.bin", BlankBuffer, 65536);
	
	for (int i = 0; i < 256; i++)
	{
		BlankBuffer[i] = ((i & 0x03) << 6) | ((i & 0x0c) << 2) | ((i & 0x30) >> 2) | ((i & 0xc0) >> 6);
	}
	WriteBinaryFile(L"Link\\MCBitFlip.bin", BlankBuffer, 256);

	for (int i = 0; i < 256; i++)
	{
		BlankBuffer[i] = i >> 4;
	}
	WriteBinaryFile(L"Link\\NibbleLookup.bin", BlankBuffer, 256);

	delete[] BlankBuffer;


	srand(0x98093de3);
	_mkdir("Build\\6502\\BASICFADE");
	_mkdir("Link\\BASICFADE");
	BASICFADE_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\BigDXYCP");
	_mkdir("Link\\BigDXYCP");
	BigDXYCP_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\CheckerBoard");
	_mkdir("Link\\CheckerBoard");
	CheckerBoard_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\CheckerZoomer");
	_mkdir("Link\\CheckerZoomer");
	CheckerZoomer_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\ColourCycle");
	_mkdir("Link\\ColourCycle");
	ColourCycle_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\Earth");
	_mkdir("Link\\Earth");
	Earth_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\InfiniteBobs");
	_mkdir("Link\\InfiniteBobs");
	InfiniteBobs_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\PlasmaVector");
	_mkdir("Link\\PlasmaVector");
	PlasmaVector_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\NoBounds");
	_mkdir("Link\\NoBounds");
	NoBounds_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\RotatingGP");
	_mkdir("Link\\RotatingGP");
	RotatingGP_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\StarWars");
	_mkdir("Link\\StarWars");
	StarWars_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\TinyCircleScroll");
	_mkdir("Link\\TinyCircleScroll");
	TinyCircleScroll_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\Trailblazer");
	_mkdir("Link\\Trailblazer");
	TrailBlazer_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\Tunnel");
	_mkdir("Link\\Tunnel");
	Tunnel_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\TwistScroll");
	_mkdir("Link\\TwistScroll");
	TwistScroll_Main();

	srand(0x98093de3);
	_mkdir("Build\\6502\\VerticalBitmapScroll");
	_mkdir("Link\\VerticalBitmapScroll");
	VBS_Main();
}
