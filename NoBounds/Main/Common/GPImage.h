//; Genesis*Project

#pragma once

static const int PALETTETYPE_PIXCEN = 0;

class GPIMAGE
{
public:
	GPIMAGE();
	GPIMAGE(int W, int H, unsigned int col = 0x00000000);
	GPIMAGE(char const* filename);
	~GPIMAGE();

	void Init(int w, int h, unsigned int col);
	void Init(char const* filename);

	void Read(char const* filename);
	void ReadKoala(LPTSTR KLAInputFilename);
	void Write(char const* filename);
	unsigned int GetPixel(int X, int Y);
	unsigned char GetPixelPaletteColour(int X, int Y);
	unsigned char FindPaletteEntry(unsigned int Colour);
	void ExtractPalette(vector<unsigned int>& ImagePalette);
	int FindMatchingPalette(vector<unsigned int>& ImagePalette);
	unsigned char GetPixelPaletteIndex(int X, int Y);

	void SetPixel(int X, int Y, unsigned int col);
	void SetPixelPaletteColour(int X, int Y, unsigned char Index);

	void FillRectangle(int X0, int Y0, int X1, int Y1, unsigned int col);
	void FillRectanglePaletteColour(int X0, int Y0, int X1, int Y1, unsigned char Index);

	void DrawImage(int X, int Y, GPIMAGE& Img);

	int Width;
	int Height;

private:
	int PaletteType;
	vector<vector<unsigned int>> ImageData;
	vector<vector<unsigned char>> PalettizedImageData;

	void PalettiseImage(vector<unsigned int>& ImagePalette);
};
