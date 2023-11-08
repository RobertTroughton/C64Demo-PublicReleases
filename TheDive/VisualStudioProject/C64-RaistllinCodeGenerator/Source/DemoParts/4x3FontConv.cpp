//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\CodeGen.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

void Font4x3_OutputASM(LPCTSTR InputSCRFilename, LPCTSTR OutputASMFilename)
{
	CodeGen code(OutputASMFilename);

	ReadBinaryFile(InputSCRFilename, FileReadBuffer, 1000);

	for (int YPos = 0; YPos < 3; YPos++)
	{
		for (int XPos = 0; XPos < 4; XPos++)
		{
			unsigned char OutputChar[40];
			for (int CharIndex = 0; CharIndex < 40; CharIndex++)
			{
				int ReadCharIndex = (CharIndex == 0) ? 39 : CharIndex - 1;

				int ReadY = (ReadCharIndex / 10) * 3 + YPos;
				int ReadX = (ReadCharIndex % 10) * 4 + XPos;

				OutputChar[CharIndex] = FileReadBuffer[ReadX + ReadY * 40];
			}

			code.OutputFunctionLine(fmt::format("SoyaFont_X{:d}_Y{:d}", XPos, YPos));
			for (int SetOfBytes = 0; SetOfBytes < 40; SetOfBytes += 8)
			{
				code.OutputCodeLine(NONE, fmt::format(".byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}",
					OutputChar[SetOfBytes + 0], OutputChar[SetOfBytes + 1], OutputChar[SetOfBytes + 2], OutputChar[SetOfBytes + 3],
					OutputChar[SetOfBytes + 4], OutputChar[SetOfBytes + 5], OutputChar[SetOfBytes + 6], OutputChar[SetOfBytes + 7]));
			}
			code.OutputCodeLine(NONE, fmt::format(".fill 24, 0 //; 24byte padding"));
		}
	}
}

int Font4x3_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\DYPP");

	Font4x3_OutputASM(L"..\\..\\Build\\Parts\\DYPP\\Data\\SoyaFont.iscr", L"..\\..\\Intermediate\\Built\\DYPP\\SoyaFont.asm");

	return 0;
}


