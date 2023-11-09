#include "..\Common\Common.h" 

void CreateColorTab(char* InPNGFileName, LPTSTR OutBINFileName) {

	GPIMAGE ColorImage(InPNGFileName);

	int W = ColorImage.Width;
	int H = ColorImage.Height;

	unsigned char* ColorData = new unsigned char[H * 2];

	for (int i = 0; i < H; i++)
	{
		unsigned char Col = ColorImage.GetPixelPaletteColour(0, i);
		ColorData[i * 2] = Col;
		Col = ColorImage.GetPixelPaletteColour(W - 1, i);
		ColorData[(i * 2) + 1] = Col;
	}

	WriteBinaryFile(OutBINFileName, ColorData, H * 2);

	delete[] ColorData;
}

void CreateRasterColorTab(char* InPNGFileName, LPTSTR OutBINFileName) {

	GPIMAGE ColorImage(InPNGFileName);

	int W = ColorImage.Width;
	int H = ColorImage.Height;

	unsigned char* RasterColorData = new unsigned char[H];

	for (int i = 0; i < H; i++)
	{
		unsigned char Col = ColorImage.GetPixelPaletteColour(W - 1, i);
		RasterColorData[i] = Col;
	}

	WriteBinaryFile(OutBINFileName, RasterColorData, H);

	delete[] RasterColorData;

}

void CreateRowTab(LPTSTR InBIN, LPTSTR OutBIN)
{
	unsigned char RowTab[192]{};
	unsigned char FadeTab[512]{};
	
	ReadBinaryFile(InBIN, RowTab, sizeof(RowTab));

	int f = 0;
	unsigned char v = 0;
	for (int i = 0; i < 192; i++)
	{
		v = RowTab[i];
		if (i > 0)
		{
			if (v < RowTab[i - 1])
				v += 0x20;
			v -= RowTab[i - 1];
		}

		for (int j = f; j < f + v; j++)
		{
			FadeTab[j] = i;
		}
		f += v;
	}
	
	for (int i = 0; i < 256; i++)
	{
		FadeTab[i] = FadeTab[(i * 2) + 1];
	}

	FadeTab[255] = 192;

	for (int i = 255; i > 0; i--)
	{
		FadeTab[i] -= FadeTab[i - 1];
	}
	
	WriteBinaryFile(OutBIN, FadeTab, 256);
}

void CreateRasterTransitionColors(char* BitmapPNGFileName, LPTSTR OutBINFileName)
{
	GPIMAGE InBitmap(BitmapPNGFileName);
	
	unsigned char RasterColors[200]{};

	for (int y = 0; y < InBitmap.Height; y++)
	{
		RasterColors[y] = InBitmap.GetPixelPaletteColour(16, y);
	}

	WriteBinaryFile(OutBINFileName, RasterColors, sizeof(RasterColors));

}

void CreateYDiffTable(LPTSTR InTabFileName, LPTSTR OutTabFileName)
{
	unsigned char YDiffTable[192]{};

	ReadBinaryFile(InTabFileName, YDiffTable, sizeof(YDiffTable));

	for (int i = 0; i < 0xc0; i++)
	{
		int ThisVal = YDiffTable[i] - (i == 0xbf ? 0 : YDiffTable[i + 1]);

		if (ThisVal < 0)
			ThisVal += 256;

		YDiffTable[i] = ThisVal;
	}

	WriteBinaryFile(OutTabFileName, YDiffTable, sizeof(YDiffTable));

}

int TrailBlazer_Main() {
	
		CreateColorTab("Parts\\Trailblazer\\Data\\Colors5.png", L"Link\\Trailblazer\\ColorData.bin");
		//CreateColorTab("Parts\\Trailblazer\\Data\\Colors7.png", L"Link\\Trailblazer\\ColorData.bin");		// color pattern that avoids bad lines

		CreateRasterColorTab("Parts\\Trailblazer\\Data\\Colors5.png", L"Link\\Trailblazer\\RasterColorData.bin");

		CreateRowTab(L"Parts\\Trailblazer\\Data\\RowData.bin", L"Link\\Trailblazer\\FadeData.bin");

		CreateRasterTransitionColors("Parts\\Trailblazer\\Data\\Colors5.png", L"Link\\Trailblazer\\FadeInColors.bin");

		CreateYDiffTable(L"Parts\\Trailblazer\\Data\\YData.bin", L"Link\\Trailblazer\\YDiffTable.bin");

		return 0;
}
