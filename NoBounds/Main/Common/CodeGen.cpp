// Genesis*Project

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

	{"adc {}",			2,	2},		//; ADC_IMM
	{"adc {}",			3,	2},		//; ADC_ZP
	{"adc {},x",		4,	2},		//; ADC_ZPX
	{"adc {}",			4,	3},		//; ADC_ABS
	{"adc {},x",		4,	3},		//; ADC_ABX
	{"adc {},y",		4,	3},		//; ADC_ABY
	{"adc ({},x)",		6,	2},		//; ADC_IZX
	{"adc ({}),y",		5,	2},		//; ADC_IZY

	{"and {}",			2,	2},		//; AND_IMM
	{"and {}",			3,	2},		//; AND_ZP
	{"and {},x",		4,	2},		//; AND_ZPX
	{"and {}",			4,	3},		//; AND_ABS
	{"and {},x",		4,	3},		//; AND_ABX
	{"and {},y",		4,	3},		//; AND_ABY
	{"and ({},x)",		6,	2},		//; AND_IZX
	{"and ({}),y",		5,	2},		//; AND_IZY

	{"asl",				2,	1},		//; ASL
	{"asl {}",			5,	2},		//; ASL_ZP
	{"asl {},x",		6,	2},		//; ASL_ZPX
	{"asl {}",			6,	3},		//; ASL_ABS
	{"asl {},x",		7,	3},		//; ASL_ABX

	{"bit {}",			3,	2},		//; BIT_ZP
	{"bit {}",			4,	3},		//; BIT_ABS

	{"bpl {}",			2,	2},		//; BPL
	{"bmi {}",			2,	2},		//; BMI
	{"bvc {}",			2,	2},		//; BVC
	{"bvs {}",			2,	2},		//; BVS
	{"bcc {}",			2,	2},		//; BCC
	{"bcs {}",			2,	2},		//; BCS
	{"bne {}",			2,	2},		//; BNE
	{"beq {}",			2,	2},		//; BEQ

	{"brk",				7,	1},		//; BRK

	{"cmp {}",			2,	2},		//; CMP_IMM
	{"cmp {}",			3,	2},		//; CMP_ZP
	{"cmp {},x",		4,	2},		//; CMP_ZPX
	{"cmp {}",			4,	3},		//; CMP_ABS
	{"cmp {},x",		4,	3},		//; CMP_ABX
	{"cmp {},y",		4,	3},		//; CMP_ABY
	{"cmp ({},x)",		6,	2},		//; CMP_IZX
	{"cmp ({}),y",		5,	2},		//; CMP_IZY

	{"cpx {}",			2,	2},		//; CPX_IMM
	{"cpx {}",			3,	2},		//; CPX_ZP
	{"cpx {}",			4,	3},		//; CPX_ABS

	{"cpy {}",			2,	2},		//; CPY_IMM
	{"cpy {}",			3,	2},		//; CPY_ZP
	{"cpy {}",			4,	3},		//; CPY_ABS

	{"dec {}",			5,	2},		//; DEC_ZP
	{"dec {},x",		6,	2},		//; DEC_ZPX
	{"dec {}",			6,	3},		//; DEC_ABS
	{"dec {},x",		7,	3},		//; DEC_ABX

	{"eor {}",			2,	2},		//; EOR_IMM
	{"eor {}",			3,	2},		//; EOR_ZP
	{"eor {},x",		4,	2},		//; EOR_ZPX
	{"eor {}",			4,	3},		//; EOR_ABS
	{"eor {},x",		4,	3},		//; EOR_ABX
	{"eor {},y",		4,	3},		//; EOR_ABY
	{"eor ({},x)",		6,	2},		//; EOR_IZX
	{"eor ({}),y",		5,	2},		//; EOR_IZY

	{"clc",				2,	1},		//; CLC
	{"sec",				2,	1},		//; SEC
	{"cli",				2,	1},		//; CLI
	{"sei",				2,	1},		//; SEI
	{"clv",				2,	1},		//; CLV
	{"cld",				2,	1},		//; CL
	{"sed",				2,	1},		//; SE

	{"inc {}",			5,	2},		//; INC_ZP
	{"inc {},x",		6,	2},		//; INC_ZPX
	{"inc {}",			6,	3},		//; INC_ABS
	{"inc {},x",		7,	3},		//; INC_ABX

	{"jmp {}",			3,	3},		//; JMP_ABS
	{"jmp ({})",		5,	3},		//; JMP_IND

	{"jsr {}",			6,	3},		//; JSR_ABS

	{"lda {}",			2,	2},		//; LDA_IMM
	{"lda {}",			3,	2},		//; LDA_ZP
	{"lda {},x",		4,	2},		//; LDA_ZPX
	{"lda {}",			4,	3},		//; LDA_ABS
	{"lda {},x",		4,	3},		//; LDA_ABX
	{"lda {},y",		4,	3},		//; LDA_ABY
	{"lda ({},x)",		6,	2},		//; LDA_IZX
	{"lda ({}),y",		5,	2},		//; LDA_IZY

	{"ldx {}",			2,	2},		//; LDX_IMM
	{"ldx {}",			3,	2},		//; LDX_ZP
	{"ldx {},y",		4,	2},		//; LDX_ZPY
	{"ldx {}",			4,	3},		//; LDX_ABS
	{"ldx {},y",		4,	3},		//; LDX_ABY

	{"ldy {}",			2,	2},		//; LDY_IMM
	{"ldy {}",			3,	2},		//; LDY_ZP
	{"ldy {},x",		4,	2},		//; LDY_ZPX
	{"ldy {}",			4,	3},		//; LDY_ABS
	{"ldy {},x",		4,	3},		//; LDY_ABX

	{"lsr",				2,	1},		//; LSR
	{"lsr {}",			5,	2},		//; LSR_ZP
	{"lsr {},x",		6,	2},		//; LSR_ZPX
	{"lsr {}",			6,	3},		//; LSR_ABS
	{"lsr {},x",		7,	3},		//; LSR_ABX

	{"nop",				2,	1},		//; NOP
	{"nop {}",			3,	2},		//; NOP_ZP

	{"ora {}",			2,	2},		//; ORA_IMM
	{"ora {}",			3,	2},		//; ORA_ZP
	{"ora {},x",		4,	2},		//; ORA_ZPX
	{"ora {}",			4,	3},		//; ORA_ABS
	{"ora {},x",		4,	3},		//; ORA_ABX
	{"ora {},y",		4,	3},		//; ORA_ABY
	{"ora ({},x)",		6,	2},		//; ORA_IZX
	{"ora ({}),y",		5,	2},		//; ORA_IZY

	{"tax",				2,	1},		//; TAX
	{"txa",				2,	1},		//; TXA
	{"dex",				2,	1},		//; DEX
	{"inx",				2,	1},		//; INX
	{"tay",				2,	1},		//; TAY
	{"tya",				2,	1},		//; TYA
	{"dey",				2,	1},		//; DEY
	{"iny",				2,	1},		//; INY

	{"rol",				2,	1},		//; ROL
	{"rol {}",			5,	2},		//; ROL_ZP
	{"rol {},x",		6,	2},		//; ROL_ZPX
	{"rol {}",			6,	3},		//; ROL_ABS
	{"rol {},x",		7,	3},		//; ROL_ABX

	{"ror",				2,	1},		//; ROR,
	{"ror {}",			5,	2},		//; ROR_ZP
	{"ror {},x",		6,	2},		//; ROR_ZPX
	{"ror {}",			6,	3},		//; ROR_ABS
	{"ror {},x",		7,	3},		//; ROR_ABX

	{"rti",				6,	1},		//; RTI

	{"rts",				6,	1},		//; RTS

	{"sbc {}",			2,	2},		//; SBC_IMM
	{"sbc {}",			3,	2},		//; SBC_ZP
	{"sbcx {}",			4,	2},		//; SBC_ZPX
	{"sbc {}",			4,	3},		//; SBC_ABS
	{"sbc {},x",		4,	3},		//; SBC_ABX
	{"sbc {},y",		4,	3},		//; SBC_ABY
	{"sbc ({},x)",		6,	2},		//; SBC_IZX
	{"sbc ({}),y",		5,	2},		//; SBC_IZY

	{"sta {}",			3,	2},		//; STA_ZP
	{"sta {},x",		4,	2},		//; STA_ZPX
	{"sta {}",			4,	3},		//; STA_ABS
	{"sta {},x",		5,	3},		//; STA_ABX
	{"sta {},y",		5,	3},		//; STA_ABY
	{"sta ({},x)",		6,	2},		//; STA_IZX
	{"sta ({}),y",		5,	2},		//; STA_IZY

	{"txs",				2,	1},		//; TXS
	{"tsx",				2,	1},		//; TSX
	{"pha",				3,	1},		//; PHA
	{"pla",				4,	1},		//; PLA
	{"php",				3,	1},		//; PHP
	{"plp",				4,	1},		//; PLP

	{"lax {}",			2,	2},		//; LAX_IMM
	{"lax {}",			3,	2},		//; LAX_ZP
	{"lax {}",			4,	3},		//; LAX_ABS
	{"lax {},y",		4,	3},		//; LAX_ABY
	{"lax ({},x)",		6,	2},		//; LAX_IZX
	{"lax ({}),y",		5,	2},		//; LAX_IZY

	{"sax {}",			3,	2},		//; SAX_ZP
	{"sax {},y",		4,	2},		//; SAX_ZPY
	{"sax {}",			4,	3},		//; SAX_ABS

	{"stx {}",			3,	2},		//; STX_ZP
	{"stx {},y",		4,	2},		//; STX_ZPY
	{"stx {}",			4,	3},		//; STX_ABS

	{"sty {}",			3,	2},		//; STY_ZP
	{"sty {},x",		4,	2},		//; STX_ZPX
	{"sty {}",			4,	3},		//; STY_ABS

	{":{}",				0,	0},		//; CALLMACRO
};

int GetNumCyclesForOpcode(int Opcode)
{
	return OpcodeDetails[Opcode].NumCycles;
}
int GetNumBytesForOpcode(int Opcode)
{
	return OpcodeDetails[Opcode].NumBytes;
}

static int CodeGenCount = 0x00000000;

CodeGen::CodeGen(LPTSTR Filename, bool bOutputHeader, int Compiler)
{
	filename = Filename;

	bActuallyOutput = true;
	CompilerFormat = Compiler;

	int i = CodeGenCount++;

#if USE_TEMP_FILE
	swprintf(TmpFilename, 128, L"Build\\temp_%08x.bin", i);

	stream.open(TmpFilename);
#else // USE_TEMP_FILE
	stream.open(Filename);
#endif // USE_TEMP_FILE

	if (bOutputHeader)
	{
		if (CompilerFormat == 1)
			stream << ";// Raistlin / Genesis*Project" << endl << endl;
		else
			stream << "//; Raistlin / Genesis*Project" << endl << endl;

	}
	totalCycles = totalBytes = 0;
}

bool compareFiles(const LPTSTR p1, const LPCWSTR p2)
{
	std::ifstream f1(p1, std::ifstream::binary | std::ifstream::ate);
	std::ifstream f2(p2, std::ifstream::binary | std::ifstream::ate);

	if (f1.fail() || f2.fail()) {
		return false; //file problem
	}

	if (f1.tellg() != f2.tellg()) {
		return false; //size mismatch
	}

	//seek back to beginning and use std::equal to compare contents
	f1.seekg(0, std::ifstream::beg);
	f2.seekg(0, std::ifstream::beg);
	return std::equal(std::istreambuf_iterator<char>(f1.rdbuf()),
		std::istreambuf_iterator<char>(),
		std::istreambuf_iterator<char>(f2.rdbuf()));
}

CodeGen::~CodeGen()
{
	stream.close();
	stream.flush();

#if USE_TEMP_FILE
	if (compareFiles(filename, TmpFilename) == true)
	{
		DeleteFileW(TmpFilename);
	}
	else
	{
		CopyFileW(TmpFilename, filename, TRUE);
		DeleteFileW(TmpFilename);
	}
#endif // USE_TEMP_FILE
}

void CodeGen::OutputBlankLine(void)
{
	if (bActuallyOutput)
	{
		stream << endl;
	}
}

int CodeGen::OutputCodeLine(int Opcode)
{
	return OutputCodeLine(Opcode, std::string(""));
}

int CodeGen::OutputCodeLine(int Opcode, std::string& StringLine)
{
	int Cycles = OpcodeDetails[Opcode].NumCycles;
	int Bytes = OpcodeDetails[Opcode].NumBytes;

	if (bActuallyOutput)
	{
		std::string CodeString = fmt::format(OpcodeDetails[Opcode].OpcodeString, StringLine);
		std::string TabbedCodeLine = fmt::format("        {}", CodeString);

		OutputLine(TabbedCodeLine, Bytes, Cycles);
	}
	totalCycles += Cycles;
	totalBytes += Bytes;

	return Cycles;
}

void CodeGen::OutputCommentLine(std::string& StringLine)
{
	OutputLine(StringLine, 0, 0);
}

void CodeGen::OutputFunctionLine(std::string& StringLine)
{
	if (!bActuallyOutput)
	{
		return;
	}

	std::string FunctionString = fmt::format("    {}:", StringLine);
	OutputLine(FunctionString, 0, 0);
}

void CodeGen::OutputLine(std::string& StringLine, int Bytes, int Cycles)
{
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
		std::string ByteLine = "        .byte ";
		for (int i = 0; i < NumBytesPerLine; i++)
		{
			ByteLine += fmt::format("{}${:02x}", i > 0 ? ", " : "", *pByte++);
		}
		stream << ByteLine << endl;
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

	while (NumCycles >= 2)
	{
		if ((NumCycles == 7) || (NumCycles >= 9))
		{
			NumCycles -= OutputCodeLine(PHA);
			NumCycles -= OutputCodeLine(PLA);
		}
		else
		{
			if (NumCycles == 3)
			{
				NumCycles -= OutputCodeLine(NOP_ZP, fmt::format("$ff"));
			}
			else
			{
				NumCycles -= OutputCodeLine(NOP);
			}
		}
	}
	return 0; //; at this point, we know that we have zero cycles remaining
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

