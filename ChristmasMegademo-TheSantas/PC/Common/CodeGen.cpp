// (c) 2018-2020, Genesis*Project

#include "Common.h"

#include "fmt\core.h"

class 
{
public:
	std::string OpcodeString;
	int NumCycles;
	int NumBytes;
} OpcodeDetails[] = {
	{"{}",				0,	0},

	{"adc {}",		2,	2},
	{"adc {}",		3,	2},
	{"adc {},x",	4,	2},
	{"adc {}",		4,	3},
	{"adc {},x",	4,	3},
	{"adc {},y",	4,	3},
	{"adc ({},x)",	6,	2},
	{"adc ({}),y",	5,	2},

	{"and {}",		2,	2},
	{"and {}",		3,	2},
	{"and {},x",	4,	2},
	{"and {}",		4,	3},
	{"and {},x",	4,	3},
	{"and {},y",	4,	3},
	{"and ({},x)",	6,	2},
	{"and ({}),y",	5,	2},

	{"asl",				2,	1},
	{"asl {}",		5,	2},
	{"asl {},x",	6,	2},
	{"asl {}",		6,	3},
	{"asl {},x",	7,	3},

	{"bit {}",		3,	2},
	{"bit {}",		4,	3},

	{"bpl {}",			2,	2},
	{"bmi {}",			2,	2},
	{"bvc {}",			2,	2},
	{"bvs {}",			2,	2},
	{"bcc {}",			2,	2},
	{"bcs {}",			2,	2},
	{"bne {}",			2,	2},
	{"beq {}",			2,	2},

	{"brk",				7,	1},

	{"cmp {}",		2,	2},
	{"cmp {}",		3,	2},
	{"cmp {},x",	4,	2},
	{"cmp {}",		4,	3},
	{"cmp {},x",	4,	3},
	{"cmp {},y",	4,	3},
	{"cmp ({},x)",	6,	2},
	{"cmp ({}),y",	5,	2},

	{"cpx {}",		2,	2},
	{"cpx {}",		3,	2},
	{"cpx {}",		4,	3},

	{"cpy {}",		2,	2},
	{"cpy {}",		3,	2},
	{"cpy {}",		4,	3},

	{"dec {}",		5,	2},
	{"dec {},x",	6,	2},
	{"dec {}",		6,	3},
	{"dec {},x",	7,	3},

	{"eor {}",		2,	2},
	{"eor {}",		3,	2},
	{"eor {},x",	4,	2},
	{"eor {}",		4,	3},
	{"eor {},x",	4,	3},
	{"eor {},y",	4,	3},
	{"eor ({},x)",	6,	2},
	{"eor ({}),y",	5,	2},

	{"clc",				2,	1},
	{"sec",				2,	1},
	{"cli",				2,	1},
	{"sei",				2,	1},
	{"clv",				2,	1},
	{"cld",				2,	1},
	{"sed",				2,	1},

	{"inc {}",		5,	2},
	{"inc {},x",	6,	2},
	{"inc {}",		6,	3},
	{"inc {},x",	7,	3},

	{"jmp {}",		3,	3},
	{"jmp ({})",	5,	3},

	{"jsr {}",		6,	3},

	{"lda {}",			2,	2},
	{"lda {}",		3,	2},
	{"lda {},x",	4,	2},
	{"lda {}",		4,	3},
	{"lda {},x",	4,	3},
	{"lda {},y",	4,	3},
	{"lda ({},x)",	6,	2},
	{"lda ({}),y",	5,	2},

	{"ldx {}",		2,	2},
	{"ldx {}",		3,	2},
	{"ldx {},y",	4,	2},
	{"ldx {}",		4,	3},
	{"ldx {},y",	4,	3},

	{"ldy {}",		2,	2},
	{"ldy {}",		3,	2},
	{"ldy {},x",	4,	2},
	{"ldy {}",		4,	3},
	{"ldy {},x",	4,	3},

	{"lsr",				2,	1},
	{"lsr {}",		5,	2},
	{"lsr {},x",	6,	2},
	{"lsr {}",		6,	3},
	{"lsr {},x",	7,	3},

	{"nop",				2,	1},
	{"nop {}",		3,	2},

	{"ora {}",		2,	2},
	{"ora {}",		3,	2},
	{"ora {},x",	4,	2},
	{"ora {}",		4,	3},
	{"ora {},x",	4,	3},
	{"ora {},y",	4,	3},
	{"ora ({},x)",	6,	2},
	{"ora ({}),y",	5,	2},

	{"tax",				2,	1},
	{"txa",				2,	1},
	{"dex",				2,	1},
	{"inx",				2,	1},
	{"tay",				2,	1},
	{"tya",				2,	1},
	{"dey",				2,	1},
	{"iny",				2,	1},

	{"rol",				2,	1},
	{"rol {}",		5,	2},
	{"rol {},x",	6,	2},
	{"rol {}",		6,	3},
	{"rol {},x",	7,	3},

	{"ror",				2,	1},
	{"ror {}",		5,	2},
	{"ror {},x",	6,	2},
	{"ror {}",		6,	3},
	{"ror {},x",	7,	3},

	{"rti",				6,	1},

	{"rts",				6,	1},

	{"sbc {}",		2,	2},
	{"sbc {}",		3,	2},
	{"sbcx {}",		4,	2},
	{"sbc {}",		4,	3},
	{"sbc {},x",	4,	3},
	{"sbc {},y",	4,	3},
	{"sbc ({},x)",	6,	2},
	{"sbc ({}),y",	5,	2},

	{"sta {}",		3,	2},
	{"sta {},x",	4,	2},
	{"sta {}",		4,	3},
	{"sta {},x",	5,	3},
	{"sta {},y",	5,	3},
	{"sta ({},x)",	6,	2},
	{"sta ({}),y",	5,	2},

	{"txs",				2,	1},
	{"tsx",				2,	1},
	{"pha",				3,	1},
	{"pla",				4,	1},
	{"php",				3,	1},
	{"plp",				4,	1},

	{"stx {}",		3,	2},
	{"stx {},y",	4,	2},
	{"stx {}",		4,	3},

	{"sty {}",		3,	2},
	{"sty {},x",		4,	2},
	{"sty {}",		4,	3},

	{":{}",			0,	0}, // CALLMACRO
};

CodeGen::CodeGen(LPTSTR Filename, bool bOutputHeader)
{
	stream.open(Filename);
	if (bOutputHeader)
	{
		stream << "//; (c) 2018-2020, Raistlin / Genesis*Project" << endl << endl;
	}
	totalCycles = totalBytes = 0;
}

CodeGen::~CodeGen()
{
	stream.close();
}

void CodeGen::OutputBlankLine(bool bActuallyOutput)
{
	if (bActuallyOutput)
	{
		stream << endl;
	}
}

int CodeGen::OutputCodeLine(int Opcode, bool bActuallyOutput)
{
	return OutputCodeLine(Opcode, std::string(""), bActuallyOutput);
}

int CodeGen::OutputCodeLine(int Opcode, std::string& StringLine, bool bActuallyOutput)
{
	int Bytes = OpcodeDetails[Opcode].NumBytes;
	int Cycles = OpcodeDetails[Opcode].NumCycles;

	std::string CodeString = fmt::format(OpcodeDetails[Opcode].OpcodeString, StringLine);
	std::string TabbedCodeLine = fmt::format("        {}", CodeString);

	OutputLine(TabbedCodeLine, Bytes, Cycles, bActuallyOutput);

	return Cycles;
}

void CodeGen::OutputCommentLine(std::string& StringLine, bool bActuallyOutput)
{
	OutputLine(StringLine, 0, 0, bActuallyOutput);
}

void CodeGen::OutputFunctionLine(std::string& StringLine, bool bActuallyOutput)
{
	std::string FunctionString = fmt::format("    {}:", StringLine);

	OutputLine(FunctionString, 0, 0, bActuallyOutput);
}

void CodeGen::OutputLine(std::string& StringLine, int Bytes, int Cycles, bool bActuallyOutput)
{
	totalCycles += Cycles;
	totalBytes += Bytes;

	if (!bActuallyOutput)
	{
		return;
	}

	if (Bytes || Cycles)
	{
		std::string ByteInfo = fmt::format("{:d} ({:5d}) bytes", Bytes, totalBytes);
		std::string CycleInfo = fmt::format("{:d} ({:6d}) cycles", Cycles, totalCycles);

		std::string Line = fmt::format("{:<120}//; {}   {}", StringLine, ByteInfo, CycleInfo);

		stream << Line << endl;
	}
	else
	{
		stream << StringLine << endl;
	}
}

void CodeGen::QueryCounters(int& Cycles, int& Bytes)
{
	Cycles = totalCycles;
	Bytes = totalBytes;
}

void CodeGen::SetCounters(int& Cycles, int& Bytes)
{
	totalCycles = Cycles;
	totalBytes = Bytes;
}

void CodeGen::ResetCounters(void)
{
	totalCycles = 0;
	totalBytes = 0;
}

void CodeGen::OutputByteBlock(unsigned char* pByte, int NumBytes, int NumBytesPerLine)
{
	if (NumBytesPerLine == -1)
	{
		NumBytesPerLine = min(16, NumBytes);
	}
	int CurrentByteCount;
	for (CurrentByteCount = NumBytes; CurrentByteCount >= NumBytesPerLine; CurrentByteCount -= NumBytesPerLine)
	{
		std::string ByteLine = fmt::format("");
		switch (NumBytesPerLine)
		{
			case  1:	ByteLine = fmt::format("        .byte ${:02x}", pByte[0]); break;
			case  2:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}", pByte[0], pByte[1]); break;
			case  3:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2]); break;
			case  4:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3]); break;
			case  5:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4]); break;
			case  6:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5]); break;
			case  7:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6]); break;
			case  8:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7]); break;
			case  9:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8]); break;
			case 10:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9]); break;
			case 11:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10]); break;
			case 12:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11]); break;
			case 13:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12]); break;
			case 14:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12], pByte[13]); break;
			case 15:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12], pByte[13], pByte[14]); break;
			case 16:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12], pByte[13], pByte[14], pByte[15]); break;
			case 21:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12], pByte[13], pByte[14], pByte[15], pByte[16], pByte[17], pByte[18], pByte[19], pByte[20]); break;
			case 24:	ByteLine = fmt::format("        .byte ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}, ${:02x}", pByte[0], pByte[1], pByte[2], pByte[3], pByte[4], pByte[5], pByte[6], pByte[7], pByte[8], pByte[9], pByte[10], pByte[11], pByte[12], pByte[13], pByte[14], pByte[15], pByte[16], pByte[17], pByte[18], pByte[19], pByte[20], pByte[21], pByte[22], pByte[23]); break;
			default:	ByteLine = fmt::format(" ERROR! {:d} not supported for NumBytesPerLine in OutputByteBlock()", NumBytesPerLine);
		}

		stream << ByteLine << endl;

		pByte += NumBytesPerLine;
	}

	int NumFinalBytes = NumBytes % NumBytesPerLine;
	if (NumFinalBytes > 0)
	{
		OutputByteBlock(pByte, NumFinalBytes, NumFinalBytes);
	}
}

int CodeGen::WasteCycles(int NumCycles)
{
	if (NumCycles == -1)
	{
		return 0;
	}
	if (NumCycles == 1)
	{
		return 1;
	}

	if (NumCycles & 1)
	{
		int CyclesTaken = OutputCodeLine(NOP_ZP, fmt::format("$ff"));
		NumCycles -= CyclesTaken;
	}

	while (NumCycles >= 2)
	{
		int CyclesTaken = OutputCodeLine(NOP);
		NumCycles -= CyclesTaken;
	}
	return NumCycles;
}



void SubtractCycles(int& NumCycles, int NumToSubtract)
{
	if (NumCycles == -1)
		return;
	else
		NumCycles -= NumToSubtract;
}

bool EnoughFreeCycles(int NumCycles, int NumCyclesNeeded, bool bFailOnOneCycleRemaining)
{
	// Special case for "unlimited cycles"
	if (NumCycles == -1)
	{
		return true;
	}

	int NumCyclesLeft = NumCycles - NumCyclesNeeded;

	// If it doesn't fit, fail
	if (NumCyclesLeft < 0)
	{
		return false;
	}

	// If it leaves a gap that we can fill, fail
	if (bFailOnOneCycleRemaining && (NumCyclesLeft == 1))
	{
		return false;
	}

	// All good
	return true;
}

