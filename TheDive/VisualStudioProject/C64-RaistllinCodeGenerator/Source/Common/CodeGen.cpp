//; (c) 2018-2019, Genesis*Project

#include "CodeGen.h"

#include "fmt\core.h"

class 
{
public:
	std::string OpcodeString;
	int NumCycles;
	int NumBytes;
} OpcodeDetails[] = {
	{"{}",				0,	0},

	{"adc.imm {}",		2,	2},
	{"adc.zp {}",		3,	2},
	{"adc.zpx {}",		4,	2},
	{"adc.abs {}",		4,	3},
	{"adc.abs {}, x",	4,	3},
	{"adc.abs {}, y",	4,	3},
	{"adc.zp ({}, x)",	6,	2},
	{"adc.zp ({}), y",	5,	2},

	{"and.imm {}",		2,	2},
	{"and.zp {}",		3,	2},
	{"and.zp {}, x",	4,	2},
	{"and.abs {}",		4,	3},
	{"and.abs {}, x",	4,	3},
	{"and.abs {}, y",	4,	3},
	{"and.zp ({}, x)",	6,	2},
	{"and.zp ({}), y",	5,	2},

	{"asl",				2,	1},
	{"asl.zp {}",		5,	2},
	{"asl.zp {}, x",	6,	2},
	{"asl.abs {}",		6,	3},
	{"asl.abs {}, x",	7,	3},

	{"bit.zp {}",		3,	2},
	{"bit.abs {}",		4,	3},

	{"bpl {}",			2,	2},
	{"bmi {}",			2,	2},
	{"bvc {}",			2,	2},
	{"bvs {}",			2,	2},
	{"bcc {}",			2,	2},
	{"bcs {}",			2,	2},
	{"bne {}",			2,	2},
	{"beq {}",			2,	2},

	{"brk",				7,	1},

	{"cmp.imm {}",		2,	2},
	{"cmp.zp {}",		3,	2},
	{"cmp.zpx {}",		4,	2},
	{"cmp.abs {}",		4,	3},
	{"cmp.abs {}, x",	4,	3},
	{"cmp.abs {}, y",	4,	3},
	{"cmp.zp ({}, x)",	6,	2},
	{"cmp.zp ({}), y",	5,	2},

	{"cpx.imm {}",		2,	2},
	{"cpx.zp {}",		3,	2},
	{"cpx.abs {}",		4,	3},

	{"cpy.imm {}",		2,	2},
	{"cpy.zp {}",		3,	2},
	{"cpy.abs {}",		4,	3},

	{"dec.zp {}",		5,	2},
	{"dec.zp {}, x",	6,	2},
	{"dec.abs {}",		6,	3},
	{"dec.abs {}, x",	7,	3},

	{"eor.imm {}",		2,	2},
	{"eor.zp {}",		3,	2},
	{"eor.zp {}, x",	4,	2},
	{"eor.abs {}",		4,	3},
	{"eor.abs {}, x",	4,	3},
	{"eor.abs {}, y",	4,	3},
	{"eor.zp ({}, x)",	6,	2},
	{"eor.zp ({}), y",	5,	2},

	{"clc",				2,	1},
	{"sec",				2,	1},
	{"cli",				2,	1},
	{"sei",				2,	1},
	{"clv",				2,	1},
	{"cld",				2,	1},
	{"sed",				2,	1},

	{"inc.zp {}",		5,	2},
	{"inc.zp {}, x",	6,	2},
	{"inc.abs {}",		6,	3},
	{"inc.abs {}, x",	7,	3},

	{"jmp.abs {}",		3,	3},
	{"jmp.abs ({})",	5,	3},

	{"jsr.abs {}",		6,	3},

	{"lda.imm {}",		2,	2},
	{"lda.zp {}",		3,	2},
	{"lda.zp {}, x",	4,	2},
	{"lda.abs {}",		4,	3},
	{"lda.abs {}, x",	4,	3},
	{"lda.abs {}, y",	4,	3},
	{"lda.zp ({}, x)",	6,	2},
	{"lda.zp ({}), y",	5,	2},

	{"ldx.imm {}",		2,	2},
	{"ldx.zp {}",		3,	2},
	{"ldx.zp {}, y",	4,	2},
	{"ldx.abs {}",		4,	3},
	{"ldx.abs {}, y",	4,	3},

	{"ldy.imm {}",		2,	2},
	{"ldy.zp {}",		3,	2},
	{"ldy.zp {}, x",	4,	2},
	{"ldy.abs {}",		4,	3},
	{"ldy.abs {}, x",	4,	3},

	{"lsr",				2,	1},
	{"lsr.zp {}",		5,	2},
	{"lsr.zp {}, x",	6,	2},
	{"lsr.abs {}",		6,	3},
	{"lsr.abs {}, x",	7,	3},

	{"nop",				2,	1},
	{"nop.zp {}",		3,	2},

	{"ora.imm {}",		2,	2},
	{"ora.zp {}",		3,	2},
	{"ora.zp {}, x",	4,	2},
	{"ora.abs {}",		4,	3},
	{"ora.abs {}, x",	4,	3},
	{"ora.abs {}, y",	4,	3},
	{"ora.zp ({}, x)",	6,	2},
	{"ora.zp ({}), y",	5,	2},

	{"tax",				2,	1},
	{"txa",				2,	1},
	{"dex",				2,	1},
	{"inx",				2,	1},
	{"tay",				2,	1},
	{"tya",				2,	1},
	{"dey",				2,	1},
	{"iny",				2,	1},

	{"rol",				2,	1},
	{"rol.zp {}",		5,	2},
	{"rol.zp {}, x",	6,	2},
	{"rol.abs {}",		6,	3},
	{"rol.abs {}, x",	7,	3},

	{"ror",				2,	1},
	{"ror.zp {}",		5,	2},
	{"ror.zp {}, x",	6,	2},
	{"ror.abs {}",		6,	3},
	{"ror.abs {}, x",	7,	3},

	{"rti",				6,	1},

	{"rts",				6,	1},

	{"sbc.imm {}",		2,	2},
	{"sbc.zp {}",		3,	2},
	{"sbc.zpx {}",		4,	2},
	{"sbc.abs {}",		4,	3},
	{"sbc.abs {}, x",	4,	3},
	{"sbc.abs {}, y",	4,	3},
	{"sbc.zp ({}, x)",	6,	2},
	{"sbc.zp ({}), y",	5,	2},

	{"sta.zp {}",		3,	2},
	{"sta.zp {}, x",	4,	2},
	{"sta.abs {}",		4,	3},
	{"sta.abs {}, x",	5,	3},
	{"sta.abs {}, y",	5,	3},
	{"sta.zp ({}, x)",	6,	2},
	{"sta.zp ({}), y",	5,	2},

	{"txs",				2,	1},
	{"tsx",				2,	1},
	{"pha",				3,	1},
	{"pla",				4,	1},
	{"php",				3,	1},
	{"plp",				4,	1},

	{"stx.zp {}",		3,	2},
	{"stx.zp {}, y",	4,	2},
	{"stx.abs {}",		4,	3},

	{"sty.zp {}",		3,	2},
	{"sty.zp {}, x",	4,	2},
	{"sty.abs {}",		4,	3},
};

CodeGen::CodeGen(LPCTSTR Filename)
{
	stream.open(Filename);
	stream << "//; (c) 2018-2019, Raistlin / Genesis*Project" << endl << endl;
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

		std::string Line = fmt::format("{:<120}//; {}, {}", StringLine, ByteInfo, CycleInfo);

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

