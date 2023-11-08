// (c) 2018-2020, Genesis*Project

#include "Common.h"

void WriteBinaryFile(LPTSTR OutputFilename, void* Ptr, int Size)
{
	HANDLE hFile = CreateFile(OutputFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	DWORD dwBytesWritten;
	WriteFile(hFile, Ptr, Size, &dwBytesWritten, NULL);
	CloseHandle(hFile);
}

int ReadBinaryFile(LPTSTR InputFilename, void* Ptr, int Size)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (!hFile)
	{
		return 0;
	}
	if (!ReadFile(hFile, Ptr, Size, &dwBytes, &ol))
	{
		dwBytes = 0;
	}
	CloseHandle(hFile);
	return dwBytes;
}

unsigned char FlipByte(unsigned char Byte)
{
	unsigned char Value = 0;
	Value |= (Byte & 1) << 7;
	Value |= (Byte & 2) << 5;
	Value |= (Byte & 4) << 3;
	Value |= (Byte & 8) << 1;
	Value |= (Byte & 16) >> 1;
	Value |= (Byte & 32) >> 3;
	Value |= (Byte & 64) >> 5;
	Value |= (Byte & 128) >> 7;
	return Value;
}


