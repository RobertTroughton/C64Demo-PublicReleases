#include "..\Common\Common.h" 

void PV_CreateBitmapBinariesUsingSPOT(string BitmapPNGFileName)
{
	//; Create MAP, COL, and SCR files using SPOT
	string ParameterString = BitmapPNGFileName + ".png msc " + BitmapPNGFileName + " 0";
	CHAR* Parameters = new CHAR[ParameterString.size() + 1];
	Parameters[ParameterString.size()] = 0;
	std::copy(ParameterString.begin(), ParameterString.end(), Parameters);

	char temp[512];
	sprintf_s(temp, "Extras\\SPOT.exe %s", Parameters);
	system((char*)temp);
}

void PV_CreateBitmapBinaries(LPTSTR InRLFileName, LPTSTR InScrFileName, LPTSTR InColFileName, LPTSTR OutScrFileName, LPTSTR OutColFileName)
{
	int InRowLen = 40;
	int OutRowLen = 18;
	int InSize = InRowLen * 25;
	int OutSize = OutRowLen * 25;
	int RLSize = 25;
	
	unsigned char* RowLength = new unsigned char[RLSize] {};
	unsigned char* InScr = new unsigned char[InSize] {};
	unsigned char* InCol = new unsigned char[InSize] {};

	unsigned char* OutScr = new unsigned char[OutSize] {};
	unsigned char* OutCol = new unsigned char[OutSize] {};

	ReadBinaryFile(InRLFileName, RowLength, RLSize);

	ReadBinaryFile(InScrFileName, InScr, InSize);
	ReadBinaryFile(InColFileName, InCol, InSize);

	for (int y = 0; y < 25; y++)
	{
		for (int x = 0; x < OutRowLen; x++)
		{
			if (InRowLen - OutRowLen + x >= RowLength[y])
			{
				OutScr[(y * OutRowLen) + x] = InScr[(y * InRowLen) + InRowLen - OutRowLen + x];
				OutCol[(y * OutRowLen) + x] = InCol[(y * InRowLen) + InRowLen - OutRowLen + x];
			}
		}
	}

	WriteBinaryFile(OutScrFileName, OutScr, OutSize);
	WriteBinaryFile(OutColFileName, OutCol, OutSize);

}

int PlasmaVector_Main()
{

	PV_CreateBitmapBinariesUsingSPOT("Parts\\PlasmaVector\\Data\\RazorbackUnbound");
	
	PV_CreateBitmapBinaries(L"Parts\\PlasmaVector\\Data\\RowLength.bin",L"Parts\\PlasmaVector\\Data\\RazorbackUnbound.scr", L"Parts\\PlasmaVector\\Data\\RazorbackUnbound.col", L"Link\\PlasmaVector\\RazorbackUnboundScr.bin", L"Link\\PlasmaVector\\RazorbackUnboundCol.bin");

	return 0;
}