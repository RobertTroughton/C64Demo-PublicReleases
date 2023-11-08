//; (c) 2018-2019, Genesis*Project

#pragma once

//; Common Includes
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
#include <direct.h> //; Needed for _mkdir

using namespace std;

//; Common Definitions
#define PI 3.14159265

#define FILE_READ_BUFFER_SIZE (65536 * 4)
extern unsigned char FileReadBuffer[];

int ReadBinaryFile(LPCTSTR InputFilename, void* Ptr, int Size);
void WriteBinaryFile(LPCTSTR OutputFilename, void* Ptr, int Size);
