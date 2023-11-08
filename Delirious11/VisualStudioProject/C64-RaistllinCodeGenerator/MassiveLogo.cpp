// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"
#include "ImageConversion.h"

#define MASSIVELOGO_WIDTH 720
#define MASSIVELOGO_HEIGHT 200

#define MASSIVELOGO_YSTART0 0
#define MASSIVELOGO_YEND0 11

#define MASSIVELOGO_YSTART1 14
#define MASSIVELOGO_YEND1 25


void MassiveLogo_OutputCode(ofstream& file, LPCTSTR LogoScreenDataFilename)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(LogoScreenDataFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

	unsigned char* LogoData = FileReadBuffer;
	unsigned int ImageStride = MASSIVELOGO_WIDTH / 8;

	ostringstream MassiveLogoCodeStream;

	for (unsigned int LogoPass = 0; LogoPass < 2; LogoPass++)
	{
		MassiveLogoCodeStream << "\tMassiveLogo_Draw_Pass" << dec << int(LogoPass) << "_Go:";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tstx ML_YOffset" << dec << int(LogoPass) << " + 1";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tlda MassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Lo, y";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_SetReturnAddress" << dec << int(LogoPass) << " + 1";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_RestoreLoadAddress" << dec << int(LogoPass) << " + 1";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tlda MassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Hi, y";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_SetReturnAddress" << dec << int(LogoPass) << " + 2";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_RestoreLoadAddress" << dec << int(LogoPass) << " + 2";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tlda MassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Lo, x";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_JumpAddress" << dec << int(LogoPass) << " + 1";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tlda MassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Hi, x";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\tsta ML_JumpAddress" << dec << int(LogoPass) << " + 2";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tlda #$60 // rts";
		OUTPUT_CODE(MassiveLogoCodeStream, 2, 2, true);
		MassiveLogoCodeStream << "\tML_SetReturnAddress" << dec << int(LogoPass) << ":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		MassiveLogoCodeStream << "\t\tsta $ffff";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tlda #$80";
		OUTPUT_CODE(MassiveLogoCodeStream, 2, 2, true);
		MassiveLogoCodeStream << "\t\tsec";
		OUTPUT_CODE(MassiveLogoCodeStream, 1, 1, true);
		MassiveLogoCodeStream << "\tML_YOffset" << dec << int(LogoPass) << ":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		MassiveLogoCodeStream << "\t\tsbc #$00";
		OUTPUT_CODE(MassiveLogoCodeStream, 2, 2, true);
		MassiveLogoCodeStream << "\t\ttay";
		OUTPUT_CODE(MassiveLogoCodeStream, 1, 1, true);
		MassiveLogoCodeStream << "\tML_JumpAddress" << dec << int(LogoPass) << ":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		MassiveLogoCodeStream << "\t\tjsr $ffff // Jump to our draw routine";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);

		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\t\tlda #$a9 // lda #";
		OUTPUT_CODE(MassiveLogoCodeStream, 2, 2, true);
		MassiveLogoCodeStream << "\tML_RestoreLoadAddress" << dec << int(LogoPass) << ":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		MassiveLogoCodeStream << "\t\tsta $ffff";
		OUTPUT_CODE(MassiveLogoCodeStream, 4, 3, true);
		MassiveLogoCodeStream << "\t\trts";
		OUTPUT_CODE(MassiveLogoCodeStream, 6, 1, true);

		OUTPUT_BLANK_LINE();
	}

	for (unsigned int LogoPass = 0; LogoPass < 2; LogoPass++)
	{
		MassiveLogoCodeStream << "\tMassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Lo:";
		OUTPUT_CODE(MassiveLogoCodeStream, 6, 3, true);
		for (unsigned int ColumnIndex = 0; ColumnIndex <= MASSIVELOGO_WIDTH / 8; ColumnIndex++)
		{
			MassiveLogoCodeStream << "\t\t.byte <MassiveLogo_Draw_Pass" << dec << int(LogoPass) << "_Column" << dec << int(ColumnIndex);
			OUTPUT_CODE(MassiveLogoCodeStream, 0, 1, true);
		}
		OUTPUT_BLANK_LINE();

		MassiveLogoCodeStream << "\tMassiveLogo_JumpTable_Pass" << dec << int(LogoPass) << "_Hi:";
		OUTPUT_CODE(MassiveLogoCodeStream, 6, 3, true);
		for (unsigned int ColumnIndex = 0; ColumnIndex <= MASSIVELOGO_WIDTH / 8; ColumnIndex++)
		{
			MassiveLogoCodeStream << "\t\t.byte >MassiveLogo_Draw_Pass" << dec << int(LogoPass) << "_Column" << dec << int(ColumnIndex);
			OUTPUT_CODE(MassiveLogoCodeStream, 0, 1, true);
		}
		OUTPUT_BLANK_LINE();
	}

	for (unsigned int LogoPass = 0; LogoPass < 2; LogoPass++)
	{
		MassiveLogoCodeStream << "MassiveLogo_Draw_Pass" << dec << int(LogoPass) << ":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		OUTPUT_BLANK_LINE();

		unsigned int YStart = LogoPass == 0 ? MASSIVELOGO_YSTART0 : MASSIVELOGO_YSTART1;
		unsigned int YEnd = LogoPass == 0 ? MASSIVELOGO_YEND0 : MASSIVELOGO_YEND1;

		for (unsigned int XPos = 0; XPos < MASSIVELOGO_WIDTH / 8; XPos++)
		{
			MassiveLogoCodeStream << "\tMassiveLogo_Draw_Pass" << dec << int(LogoPass) << "_Column" << dec << int(XPos) << ":";
			OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);

			for (unsigned int iValue = 0; iValue < 256; iValue++)
			{
				bool bFirst = true;
				for (unsigned int YPos = YStart; YPos < YEnd; YPos++)
				{
					unsigned char Value = LogoData[XPos + YPos * ImageStride];
					if (Value == (unsigned char)iValue)
					{
						if (bFirst)
						{
							MassiveLogoCodeStream << "\t\tlda #$" << hex << setw(2) << setfill('0') << int(Value);
							OUTPUT_CODE(MassiveLogoCodeStream, 2, 2, true);
							bFirst = false;
						}
						MassiveLogoCodeStream << "\t\tsta ScreenAddress + (" << dec << int(XPos + YPos * 40 + (40 - 80 * LogoPass)) << " - 128),y";
						OUTPUT_CODE(MassiveLogoCodeStream, 5, 3, true);
					}
				}
			}
			OUTPUT_BLANK_LINE();
		}

		MassiveLogoCodeStream << "\tMassiveLogo_Draw_Pass" << dec << int(LogoPass) << "_Column" << dec << int(MASSIVELOGO_WIDTH / 8) <<":";
		OUTPUT_CODE(MassiveLogoCodeStream, 0, 0, true);
		MassiveLogoCodeStream << "\t\trts";
		OUTPUT_CODE(MassiveLogoCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
}

void MassiveLogo_OutputSinTables(LPCTSTR SinTablesFilename)
{
	int ML_SinTable[256];
	GenerateSinTable(256, 0, 407, 0, ML_SinTable);
	unsigned char cSinTable_LoHi[512];
	for (unsigned int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTable_LoHi[SinIndex] = (unsigned char)(ML_SinTable[SinIndex] & 7);
		cSinTable_LoHi[SinIndex + 256] = (unsigned char)(ML_SinTable[SinIndex] / 8);
	}
	WriteBinaryFile(SinTablesFilename, cSinTable_LoHi, 512);
}

int MassiveLogo_Main(void)
{
	Output_BMPBitmapToCharScreenData(L"..\\..\\SourceData\\GenesisProjectBig.bmp", L"..\\..\\Intermediate\\Built\\MassiveLogo-GPBigData.bin", L"..\\..\\Intermediate\\Built\\MassiveLogo-GPBigScreen.bin", 720, 200, 90, 25, false, 3);

	MassiveLogo_OutputSinTables(L"..\\..\\Intermediate\\Built\\MassiveLogo-SinTables.bin");

	ofstream MassiveLogoFile;
	MassiveLogoFile.open("..\\..\\Intermediate\\Built\\MassiveLogo-Draw.asm");
	MassiveLogoFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	MassiveLogo_OutputCode(MassiveLogoFile, L"..\\..\\Intermediate\\Built\\MassiveLogo-GPBigScreen.bin");
	MassiveLogoFile.close();

	return 0;
}

