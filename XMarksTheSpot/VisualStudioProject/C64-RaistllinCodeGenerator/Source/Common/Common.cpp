//; (c) 2018, Raistlin of Genesis*Project

#include "Common.h"

unsigned char FileReadBuffer[FILE_READ_BUFFER_SIZE];

void WriteBinaryFile(LPCTSTR OutputFilename, void* Ptr, int Size)
{
	HANDLE hFile = CreateFile(OutputFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	DWORD dwBytesWritten;
	WriteFile(hFile, Ptr, Size, &dwBytesWritten, NULL);
	CloseHandle(hFile);
}

int ReadBinaryFile(LPCTSTR InputFilename, void* Ptr, int Size)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	if (!hFile)
	{
		return 0;
	}
	ReadFile(hFile, Ptr, Size, &dwBytes, &ol);
	CloseHandle(hFile);
	return dwBytes;
}

