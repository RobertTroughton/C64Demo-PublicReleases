// (c) Genesis*Project

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

#include <vector>

using namespace std;

#include "SinTables.h"
#include "CodeGen.h"
#include "GPImage.h"

// Common Definitions
#define PI 3.14159265

int ReadBinaryFile(LPTSTR InputFilename, void* Ptr, int Size);
void WriteBinaryFile(LPTSTR OutputFilename, void* Ptr, int Size);

