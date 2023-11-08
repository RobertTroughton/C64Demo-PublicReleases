// (c) 2018-2020, Genesis*Project

#pragma once

static const int PALETTETYPE_PIXCEN = 0;

class GPIMAGE
{
public:
	GPIMAGE();
	GPIMAGE(int W, int H, unsigned int col = 0x00000000);
	GPIMAGE(char const* filename);
	GPIMAGE::~GPIMAGE();

	void Read(char const* filename);
	void Write(char const* filename);
	unsigned int GetPixel(int X, int Y);
	unsigned char GetPixelPaletteColour(int X, int Y);
	unsigned char FindPaletteEntry(unsigned int Colour);
	void ExtractPalette(vector<unsigned int>& ImagePalette);
	int FindMatchingPalette(vector<unsigned int>& ImagePalette);
	unsigned char GetPixelPaletteIndex(int X, int Y);

	void SetPixel(int X, int Y, unsigned int col);
	void FillRectangle(int X0, int Y0, int X1, int Y1, unsigned int col);

	void SplitToBitmapData(unsigned char* MAPData, unsigned char* SCRData, unsigned char* COLData, unsigned char BackgroundColour);

	int Width;
	int Height;

private:
	unsigned int* ImageData;
	int PaletteType;
	unsigned char* PalettizedImageData;

	void PalettiseImage(vector<unsigned int>& ImagePalette);
};
