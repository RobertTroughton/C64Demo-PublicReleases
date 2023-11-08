// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"

unsigned char FileReadBuffer[FILE_READ_BUFFER_SIZE];

void WriteBinaryFile(LPCTSTR OutputFilename, void* Ptr, unsigned int Size)
{
	HANDLE hFile = CreateFile(OutputFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	DWORD dwBytesWritten;
	WriteFile(hFile, Ptr, Size, &dwBytesWritten, NULL);
	CloseHandle(hFile);
}
