// (c)2018, Raistlin / Genesis*Project

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

using namespace std;

// Common Definitions
#define PI 3.14159265

// Standard Code Output Macros
#define OUTPUT_CODE( stream, cycles, bytes, shouldoutput ) \
	TotalCycles += cycles; \
	TotalSize += bytes; \
	if(shouldoutput) \
	{\
		if(bytes || cycles) \
			file << left << setw(120);\
		file << stream.str(); \
		if(bytes) \
			file << "//; SIZE:" << dec << right << setw(5) << bytes << "(" << right << setw(5) << TotalSize << ")"; \
		if(cycles) \
			file << ",   CYCLES:" << dec << right << setw(5) << cycles << "(" << right << setw(5) << TotalCycles << ")"; \
		file << endl; \
	} \
	stream.str("");

#define OUTPUT_BLANK_LINE() \
	file << endl;

#define FILE_READ_BUFFER_SIZE (65536 * 4)
extern unsigned char FileReadBuffer[];

void WriteBinaryFile(LPCTSTR OutputFilename, void* Ptr, unsigned int Size);

