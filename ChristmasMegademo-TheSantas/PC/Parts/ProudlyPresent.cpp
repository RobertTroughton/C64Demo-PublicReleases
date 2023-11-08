// (c) 2018-2020, Genesis*Project

#include "..\Common\Common.h"

void PP_ConvertBitmap(char* InPNGFilename, LPTSTR OutMAPFilename, LPTSTR OutScreenBINFilename)
{
	GPIMAGE Img(InPNGFilename);

	unsigned char MAPData[25 * 40 * 8];
	unsigned char SCRData[25 * 40];
	unsigned char COLData[25 * 40];

	Img.SplitToBitmapData(MAPData, SCRData, COLData, 0x01);

	unsigned char SCRDataSplit[3][10 * 40];
	ZeroMemory(SCRDataSplit, sizeof(SCRDataSplit));
	for (int i = 0; i < 10 * 40; i++)
	{
		SCRDataSplit[0][i] = SCRData[7 * 40 + i] & 0x0f;
		SCRDataSplit[1][i] = SCRData[7 * 40 + i] >> 4;
		SCRDataSplit[2][i] = COLData[7 * 40 + i];
	}

	WriteBinaryFile(OutMAPFilename, MAPData, sizeof(MAPData));
	WriteBinaryFile(OutScreenBINFilename, SCRDataSplit, sizeof(SCRDataSplit));
}

void PP_GenerateSinTable(LPTSTR OutSineBINFilename)
{
	unsigned char SineTable[2][64];
	for (int i = 0; i < 64; i++)
	{
		double MoveAngle0 = ((double)i * 2.0 * PI) / 63.0;
		double MoveValue0 = sin(MoveAngle0) * 45.0;
		double MoveAngle1 = ((double)(i + 3) * 2.0 * PI) / 63.0;
		double MoveValue1 = sin(MoveAngle0) * 45.0;

		double Angle = ((double)i * PI / 2.0) / 63.0;
		double SineValue = sin(Angle) * 58.0;

		int iSin0 = max(  0, (int)(142.0 - SineValue));
		int iSin1 = min((int)(SineValue + 144.0), 202);

		if ((i != 0) && (i != 63))
		{
			iSin0 += (int)MoveValue0;
			iSin1 += (int)MoveValue1;
		}

		unsigned char cSin0 = (unsigned char)iSin0;
		unsigned char cSin1 = (unsigned char)iSin1;

		SineTable[0][i] = cSin0;
		SineTable[1][i] = cSin1;
	}
	WriteBinaryFile(OutSineBINFilename, SineTable, sizeof(SineTable));
}

int ProudlyPresent_Main()
{
	PP_ConvertBitmap("6502\\Parts\\ProudlyPresent\\Data\\ProudlyPresent.png", L"Out\\6502\\Parts\\ProudlyPresent\\ProudlyPresent.map", L"Out\\6502\\Parts\\ProudlyPresent\\ProudlyPresent-Screens.bin");

	PP_GenerateSinTable(L"Out\\6502\\Parts\\ProudlyPresent\\SineTable.bin");
		
	return 0;
}
