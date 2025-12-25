// Genesis*Project

#pragma once

// Common Includes
#define NOMINMAX
#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <strsafe.h>

#include <fstream>
#include <string.h>
#include <string_view>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <math.h>
#include <algorithm>
#include <direct.h>
#include <map>
#include <filesystem>

#include <vector>

#include <new>
#include <cstddef>
#include <cstdlib>
#include <mutex>
#include <unordered_map>
#include <unordered_set>

#include <openssl/evp.h>

using namespace std;

#include "GPImage.h"

// Common Definitions
#define PI 3.14159265

int ReadBinaryFile(LPTSTR InputFilename, void* Ptr, int Size);
void WriteBinaryFile(LPTSTR OutputFilename, void* Ptr, int Size);