// (c) 2018-2020, Genesis*Project


#include <atlstr.h>

#include "..\Common\Common.h"

#include "SkullZoomer-PetMateOutput.c"

unsigned char* pFrameData[] = {
	frame0000,
	frame0001,
	frame0002,
	frame0003,
	frame0004,
	frame0005,
	frame0006,
	frame0007,
	frame0008,
	frame0009,
	frame0010,
	frame0011,
	frame0012,
	frame0013,
	frame0014,
	frame0015,
	frame0016,
	frame0017,
	frame0018,
	frame0019,
	frame0020,
	frame0021,
	frame0022,
	frame0023,
	frame0024,
	frame0025,
	frame0026,
	frame0027,
	frame0028,
	frame0029,
	frame0030,
	frame0031,
	frame0032,
	frame0033,
	frame0034,
	frame0035,
	frame0036,
	frame0037,
	frame0038,
	frame0039,
	frame0040,
	frame0041,
	frame0042,
	frame0043,
	frame0044,
	frame0045,
	frame0046,
	frame0047,
	frame0048,
	frame0049,
	frame0050,
	frame0051,
	frame0052,
	frame0053,
	frame0054,
	frame0055,
	frame0056,
	frame0057,
	frame0058,
	frame0059,
	frame0060,
	frame0061,
	frame0062,
	frame0063,
};

unsigned char SCRData[65][25][40];
unsigned char DeltaSCRData[65][25][40];

#if DO_COLOURS
unsigned char COLData[65][25][40];
unsigned char DeltaCOLData[65][25][40];
#endif //; DO_COLOURS

void SkullZoomer_Process()
{
	//; (i) copy the screen data out into a simpler structure
	for (int ScreenIndex = 0; ScreenIndex < 64; ScreenIndex++)
	{
		unsigned char* pRawData = pFrameData[ScreenIndex];
		for (int YChar = 0; YChar < 25; YChar++)
		{
			for (int XChar = 0; XChar < 40; XChar++)
			{
				int SCRReadOffset = 2 + (YChar * 40) + XChar;
				int COLReadOffset = 2 + 1000 + (YChar * 40) + XChar;
				SCRData[ScreenIndex][YChar][XChar] = pRawData[SCRReadOffset];
#if DO_COLOURS
				COLData[ScreenIndex][YChar][XChar] = pRawData[COLReadOffset];
#endif //; DO_COLOURS
			}
		}
	}
	memset(SCRData[64], 0x20, 25 * 40);
#if DO_COLOURS
	memset(COLData[64], 0x00, 25 * 40);
#endif //; DO_COLOURS

	//; (ii) iterate over the screens and create our frame deltas (ie. Frame 1's "delta" contains only the screen bytes that changed from Frame 0, etc)
	ZeroMemory(DeltaSCRData, sizeof(DeltaSCRData));
#if DO_COLOURS
	ZeroMemory(DeltaCOLData, sizeof(DeltaCOLData));
#endif //;DO_COLOURS
	for (int ScreenIndex = 0; ScreenIndex < 65; ScreenIndex++)
	{
		for (int YChar = 0; YChar < 25; YChar++)
		{
			for (int XChar = 0; XChar < 40; XChar++)
			{
				unsigned char SCRVal0 = ScreenIndex > 0 ? SCRData[ScreenIndex - 1][YChar][XChar] : 0x20;
				unsigned char SCRVal1 = SCRData[ScreenIndex][YChar][XChar];
				DeltaSCRData[ScreenIndex][YChar][XChar] = (SCRVal0 == SCRVal1) ? 0xff : SCRVal1;

#if DO_COLOURS
				unsigned char COLVal0 = ScreenIndex > 0 ? COLData[ScreenIndex - 1][YChar][XChar] : 0x01;
				unsigned char COLVal1 = COLData[ScreenIndex][YChar][XChar];
				DeltaCOLData[ScreenIndex][YChar][XChar] = (COLVal0 == COLVal1) ? 0xff : COLVal1;
#endif //; DO_COLOURS
			}
		}
	}

/*	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 40; XChar++)
		{
			int MinFrame = -1;
			for (int FrameIndex = 64; FrameIndex >= 0; FrameIndex--)
			{
				if (SCRData[FrameIndex][YChar][XChar] != 0x20)
				{
					MinFrame = min(64, FrameIndex + 1);
					break;
				}
			}
			FrameFromWhichToBlacken[YChar][XChar] = MinFrame;
		}
	}*/

	//; (iii) Generate the ASM file for drawing the frames
	unsigned char ScreenPosWrittenTo[25][40];
	ZeroMemory(ScreenPosWrittenTo, sizeof(ScreenPosWrittenTo));

	CodeGen code(L"Out\\6502\\Parts\\SkullZoomer\\DrawFrames.asm");

	//; --Lo and Hi ptrs into the draw functions - to make it easier to call them
	code.OutputFunctionLine(fmt::format("DrawFrameJumpLo"));
	for (int ScreenIndex = 0; ScreenIndex < 65; ScreenIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte <DrawFrame{:02d}", ScreenIndex));
	}
	code.OutputBlankLine();
	code.OutputFunctionLine(fmt::format("DrawFrameJumpHi"));
	for (int ScreenIndex = 0; ScreenIndex < 65; ScreenIndex++)
	{
		code.OutputCodeLine(NONE, fmt::format(".byte >DrawFrame{:02d}", ScreenIndex));
	}
	code.OutputBlankLine();

	//; Now the main draw functions... DrawFrame00, DrawFrame01, ..., DrawFrame63
	for (int ScreenIndex = 0; ScreenIndex < 65; ScreenIndex++)
	{
		code.OutputFunctionLine(fmt::format("DrawFrame{:02d}", ScreenIndex));

//;		for (int Pass = 0; Pass < 2; Pass++) //; Pass0: screen, Pass1: colour
		{
			int CurrentXValue = 0x20;
			for (int OutputChar = 0; OutputChar < 255; OutputChar++)
			{
				for (int YChar = 0; YChar < 25; YChar++)
				{
					for (int XChar = 0; XChar < 40; XChar++)
					{
						if (DeltaSCRData[ScreenIndex][YChar][XChar] == OutputChar)
						{
							if (OutputChar != CurrentXValue)
							{
								if (OutputChar == (CurrentXValue + 1))
								{
									code.OutputCodeLine(INX);
								}
								else
								{
									code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", OutputChar));
								}
								CurrentXValue = OutputChar;
							}
							code.OutputCodeLine(STX_ABS, fmt::format("ScreenAddress    + ({:2d} * 40) + {:2d}", YChar, XChar));
						}
#if DO_COLOURS
						if (DeltaCOLData[ScreenIndex][YChar][XChar] == OutputChar)
						{
							if (OutputChar != CurrentXValue)
							{
								if (OutputChar == (CurrentXValue + 1))
								{
									code.OutputCodeLine(INX);
								}
								else
								{
									code.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", OutputChar));
								}
								CurrentXValue = OutputChar;
							}
							code.OutputCodeLine(STX_ABS, fmt::format("VIC_ColourMemory + ({:2d} * 40) + {:2d}", YChar, XChar));
						}
#endif //; DO_COLOURS
					}
				}
			}
		}
		code.OutputCodeLine(RTS);
		code.OutputBlankLine();
	}
}

int SkullZoomer_Main()
{
	SkullZoomer_Process();

	return 0;
}
