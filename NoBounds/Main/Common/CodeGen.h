// Genesis*Project

#pragma once

// Common Includes
#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <strsafe.h>

#include <fstream>
#include <string.h>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <math.h>
#include <algorithm>
#include <direct.h> // Needed for _mkdir

#include "fmt\core.h"

using namespace std;

// Common Definitions
#define PI 3.14159265

void SubtractCycles(int& NumCycles, int NumToSubtract);
bool EnoughFreeCycles(int NumCycles, int NumCyclesNeeded, bool bFailOnOneCycleRemaining = true);

int GetNumCyclesForOpcode(int Opcode);
int GetNumBytesForOpcode(int Opcode);

class CodeGen
{
public:
	CodeGen(LPTSTR Filename, bool bOutputHeader = true, int Compiler = 0);
	~CodeGen();

	void OutputBlankLine();
	int OutputCodeLine(int Opcode);
	int OutputCodeLine(int Opcode, std::string& StringLine);
	void OutputCommentLine(std::string& StringLine);
	void OutputFunctionLine(std::string& StringLine);
	void OutputByteBlock(unsigned char*, int NumBytes, int NumBytesPerLine = -1);

	void ResetCounters();
	void QueryCounters(int& Cycles, int& Bytes);
	void SetCounters(int& Cycles, int& Bytes);

	int WasteCycles(int NumCycles);

	int totalCycles;
	int totalBytes;
	bool bActuallyOutput;

	LPTSTR filename;
	TCHAR TmpFilename[128];

protected:
private:
	void OutputLine(std::string& StringLine, int Bytes, int Cycles);

	ofstream stream;

	int CompilerFormat;	//; 0=KICKASS, 1=BADASS(BASS)
};

enum /*E6502OPCODE*/
{
	NONE = 0,

	ADC_IMM,
	ADC_ZP,
	ADC_ZPX,
	ADC_ABS,
	ADC_ABX,
	ADC_ABY,
	ADC_IZX,
	ADC_IZY,

	AND_IMM,
	AND_ZP,
	AND_ZPX,
	AND_ABS,
	AND_ABX,
	AND_ABY,
	AND_IZX,
	AND_IZY,

	ASL,
	ASL_ZP,
	ASL_ZPX,
	ASL_ABS,
	ASL_ABX,

	BIT_ZP,
	BIT_ABS,

	BPL,
	BMI,
	BVC,
	BVS,
	BCC,
	BCS,
	BNE,
	BEQ,

	BRK,

	CMP_IMM,
	CMP_ZP,
	CMP_ZPX,
	CMP_ABS,
	CMP_ABX,
	CMP_ABY,
	CMP_IZX,
	CMP_IZY,

	CPX_IMM,
	CPX_ZP,
	CPX_ABS,

	CPY_IMM,
	CPY_ZP,
	CPY_ABS,

	DEC_ZP,
	DEC_ZPX,
	DEC_ABS,
	DEC_ABX,

	EOR_IMM,
	EOR_ZP,
	EOR_ZPX,
	EOR_ABS,
	EOR_ABX,
	EOR_ABY,
	EOR_IZX,
	EOR_IZY,

	CLC,
	SEC,
	CLI,
	SEI,
	CLV,
	CLD,
	SED,

	INC_ZP,
	INC_ZPX,
	INC_ABS,
	INC_ABX,

	JMP_ABS,
	JMP_IND,

	JSR_ABS,

	LDA_IMM,
	LDA_ZP,
	LDA_ZPX,
	LDA_ABS,
	LDA_ABX,
	LDA_ABY,
	LDA_IZX,
	LDA_IZY,

	LDX_IMM,
	LDX_ZP,
	LDX_ZPY,
	LDX_ABS,
	LDX_ABY,

	LDY_IMM,
	LDY_ZP,
	LDY_ZPX,
	LDY_ABS,
	LDY_ABX,

	LSR,
	LSR_ZP,
	LSR_ZPX,
	LSR_ABS,
	LSR_ABX,

	NOP,
	NOP_ZP,

	ORA_IMM,
	ORA_ZP,
	ORA_ZPX,
	ORA_ABS,
	ORA_ABX,
	ORA_ABY,
	ORA_IZX,
	ORA_IZY,

	TAX,
	TXA,
	DEX,
	INX,
	TAY,
	TYA,
	DEY,
	INY,

	ROL,
	ROL_ZP,
	ROL_ZPX,
	ROL_ABS,
	ROL_ABX,

	ROR,
	ROR_ZP,
	ROR_ZPX,
	ROR_ABS,
	ROR_ABX,

	RTI,

	RTS,

	SBC_IMM,
	SBC_ZP,
	SBC_ZPX,
	SBC_ABS,
	SBC_ABX,
	SBC_ABY,
	SBC_IZX,
	SBC_IZY,

	STA_ZP,
	STA_ZPX,
	STA_ABS,
	STA_ABX,
	STA_ABY,
	STA_IZX,
	STA_IZY,

	TXS,
	TSX,
	PHA,
	PLA,
	PHP,
	PLP,

	LAX_IMM,
	LAX_ZP,
	LAX_ABS,
	LAX_ABY,
	LAX_IZX,
	LAX_IZY,

	SAX_ZP,
	SAX_ZPY,
	SAX_ABS,

	STX_ZP,
	STX_ZPY,
	STX_ABS,

	STY_ZP,
	STY_ZPX,
	STY_ABS,

	CALLMACRO,
};
