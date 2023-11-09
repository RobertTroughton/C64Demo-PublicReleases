//; Genesis*Project

#include "Common.h"

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "..\..\Extras\STB\stb_image.h"
#include "..\..\Extras\STB\stb_image_write.h"

vector<vector<unsigned int>> RGBValues = {
	{0x000000,0xffffff,0x894036,0x7abfc7,0x8a46ae,0x68a941,0x3e31a2,0xd0dc71,0x905f25,0x5c4700,0xbb776d,0x555555,0x808080,0xacea88,0x7c70da,0xababab},	//; PIXCEN default
	{0x000000,0xFFFFFF,0x68372B,0x70A4B2,0x6F3D86,0x588D43,0x352879,0xB8C76F,0x6F4F25,0x433900,0x9A6759,0x444444,0x6C6C6C,0x9AD284,0x6C5EB5,0x959595},	//; Pepto
	{0x0A0A0A,0xFFF8FF,0x851F02,0x65CDA8,0xA73B9F,0x4DAB19,0x1A0C92,0xEBE353,0xA94B02,0x441E00,0xD28074,0x464646,0x8B8B8B,0x8EF68E,0x4D91D1,0xBABABA},	//; C64HQ
	{0x000000,0xFCFCFC,0xA80000,0x54FCFC,0xA800A8,0x00A800,0x0000A8,0xFCFC00,0xA85400,0x802C00,0xFC5454,0x545454,0x808080,0x54FC54,0x5454FC,0xA8A8A8},	//; C64S
	{0x101010,0xFFFFFF,0xE04040,0x60FFFF,0xE060E0,0x40E040,0x4040E0,0xFFFF40,0xE0A040,0x9C7448,0xFFA0A0,0x545454,0x888888,0xA0FFA0,0xA0A0FF,0xC0C0C0},	//; CCS64
	{0x000000,0xFFFFFF,0xCC0000,0x00FFCC,0xFF00FF,0x00CC00,0x0000CC,0xFFFF00,0xFF8800,0x884400,0xFF8888,0x444444,0x888888,0x88FF88,0x8888FF,0xCCCCCC},	//; Frodo
	{0x000000,0xFFFFFF,0x880000,0xAAFFEE,0xCC44CC,0x00CC55,0x0000AA,0xEEEE77,0xDD8855,0x664400,0xFE7777,0x333333,0x777777,0xAAFF66,0x0088FF,0xBBBBBB},	//; GODOT
	{0x212121,0xFFFFFF,0xB52121,0x73FFFF,0xB521B5,0x21B521,0x2121B5,0xFFFF21,0xB57321,0x944221,0xFF7373,0x737373,0x949494,0x73FF73,0x7373FF,0xB5B5B5},	//; PC64
	{0x000000,0xffffff,0x813338,0x75cec8,0x8e3c97,0x56ac4d,0x2e2c9b,0xedf171,0x8e5029,0x553800,0xc46c71,0x4a4a4a,0x7b7b7b,0xa9ff9f,0x706deb,0xb2b2b2},	//; Colodore
	{0x000000,0xd5d5d5,0x72352c,0x659fa6,0x733a91,0x568d35,0x2e237d,0xaeb75e,0x774f1e,0x4b3c00,0x9c635a,0x474747,0x6b6b6b,0x8fc271,0x675db6,0x8f8f8f},	//; PALette
	{0x000000,0xd5d5d5,0x7e352b,0x659fa6,0x733a91,0x568d35,0x2e237d,0xaeb75e,0xb46b61,0x85531c,0x9c635a,0x474747,0x6b6b6b,0x8fc271,0x675db6,0x8f8f8f},	//; Razorback's
};

GPIMAGE::GPIMAGE():
	Width(0),
	Height(0),
	PaletteType(-1)
{

}

GPIMAGE::GPIMAGE(int w, int h, unsigned int col)
{
	Init(w, h, col);
}

GPIMAGE::GPIMAGE(char const* filename)
{
	Read(filename);
}

GPIMAGE::~GPIMAGE()
{
}

void GPIMAGE::Init(int w, int h, unsigned int col)
{
	Width = w;
	Height = h;
	PaletteType = 0;
	ImageData.resize(Height, vector<unsigned int>(Width, col));
}

void GPIMAGE::Init(char const* filename)
{
	Read(filename);
}

unsigned char GPIMAGE::FindPaletteEntry(unsigned int Colour)
{
	for (int Index = 0; Index < 16; Index++)
	{
		if (RGBValues[PaletteType][Index] == Colour)
			return Index;
	}
	return 0;
}

void GPIMAGE::PalettiseImage(vector<unsigned int>& ImagePalette)
{
	PalettizedImageData.resize(Height, vector<unsigned char>(Width, 0));

	for (int Y = 0; Y < Height; Y++)
	{
		for (int X = 0; X < Width; X++)
		{
			unsigned int Colour = GetPixel(X, Y);
			vector<unsigned int>::iterator it = find(ImagePalette.begin(), ImagePalette.end(), Colour);

			unsigned char PaletteIndex = 0;
			if (it != ImagePalette.end())
			{
				PaletteIndex = (unsigned char)distance(ImagePalette.begin(), it);
			}
			
			PalettizedImageData[Y][X] = PaletteIndex;
		}
	}
}

unsigned char GPIMAGE::GetPixelPaletteColour(int X, int Y)
{
	if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
		return 0;

	unsigned int Colour = GetPixel(X, Y);

	return FindPaletteEntry(Colour);
}

unsigned int GPIMAGE::GetPixel(int X, int Y)
{
	if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
		return 0xffffffff;

	return ImageData[Y][X];
}

unsigned char GPIMAGE::GetPixelPaletteIndex(int X, int Y)
{
	if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
		return 0xff;

	return PalettizedImageData[Y][X];
}

void GPIMAGE::Read(char const* filename)
{
	int NumComps;
	unsigned char* Data = stbi_load(filename, &Width, &Height, &NumComps, 0);

	if (NumComps < 3)
	{
		stbi_image_free(Data);
		Width = Height = 0;
		return; //; <-- we need to fix stuff up if this happens!
	}

	ImageData.resize(Height, vector<unsigned int>(Width, 0));

	for (int YPos = 0; YPos < Height; YPos++)
	{
		for (int XPos = 0; XPos < Width; XPos++)
		{
			unsigned char* pPixel = &Data[((YPos * Width) + XPos) * NumComps];
			unsigned int Col = (pPixel[0] << 16) | (pPixel[1] << 8) | (pPixel[2] << 0);
			ImageData[YPos][XPos] = Col;
		}
	}
	stbi_image_free(Data);

	vector<unsigned int>ImagePalette;
	ExtractPalette(ImagePalette);
	PaletteType = FindMatchingPalette(ImagePalette);
	PalettiseImage(ImagePalette);

}

void GPIMAGE::ReadKoala(LPTSTR KLAInputFilename)
{
	static const size_t KLAInitialPtrSize = 2;
	static const size_t KLAMAPDataSize = 8000;
	static const size_t KLASCRDataSize = 1000;
	static const size_t KLACOLDataSize = 1000;
	static const size_t KLAD021DataSize = 1;
	static const size_t KLADataSize = KLAInitialPtrSize + KLAMAPDataSize + KLASCRDataSize + KLACOLDataSize + KLAD021DataSize;

	unsigned char* KLAData = new unsigned char[KLADataSize];
	ReadBinaryFile(KLAInputFilename, KLAData, KLADataSize);

	unsigned char* MAPData = &KLAData[KLAInitialPtrSize];
	unsigned char* SCRData = &MAPData[KLAMAPDataSize];
	unsigned char* COLData = &SCRData[KLASCRDataSize];
	unsigned char D021Value = COLData[KLACOLDataSize];

	unsigned char CharPalette[4];
	CharPalette[0] = D021Value;
	for (int ychar = 0; ychar < 25; ychar++)
	{
		for (int xchar = 0; xchar < 40; xchar++)
		{
			CharPalette[1] = (SCRData[ychar * 40 + xchar] & 0xf0) >> 4;
			CharPalette[2] = (SCRData[ychar * 40 + xchar] & 0x0f) >> 0;
			CharPalette[3] = (COLData[ychar * 40 + xchar] & 0x0f) >> 0;
			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				unsigned char ThisChar = MAPData[ychar * 320 + xchar * 8 + ypixel];
				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int x = xchar * 8 + xpixel;
					unsigned char BitMask = 0xc0 >> xpixel;
					unsigned char BitShift = 6 - xpixel;
					unsigned char PalIndex = (ThisChar & BitMask) >> BitShift;
					unsigned char C64Col = CharPalette[PalIndex];
					unsigned int Col = RGBValues[0][C64Col];
					SetPixel(x, y, Col);
					SetPixel(x + 1, y, Col);
				}
			}
		}
	}
	delete[] KLAData;
}

void GPIMAGE::Write(char const* filename)
{
	unsigned char* Data = new unsigned char[Width * Height * 3];
	for (int YPos = 0; YPos < Height; YPos++)
	{
		for (int XPos = 0; XPos < Width; XPos++)
		{
			unsigned int Colour = ImageData[YPos][XPos];
			unsigned char* pPixel = &Data[((YPos * Width) + XPos) * 3];
			pPixel[0] = (Colour & 0xff0000) >> 16;
			pPixel[1] = (Colour & 0x00ff00) >> 8;
			pPixel[2] = (Colour & 0x0000ff) >> 0;
		}
	}
	stbi_write_png(filename, Width, Height, 3, Data, Width * 3);
	delete[] Data;
}

void GPIMAGE::ExtractPalette(vector<unsigned int>& ImagePalette)
{
	for (int YPos = 0; YPos < Height; YPos++)
	{
		for (int XPos = 0; XPos < Width; XPos++)
		{
			unsigned int Colour = ImageData[YPos][XPos];
			if (find(ImagePalette.begin(), ImagePalette.end(), Colour) != ImagePalette.end())
			{
				continue;
			}
			ImagePalette.push_back(Colour);
		}
	}
}

int GPIMAGE::FindMatchingPalette(vector<unsigned int>& ImagePalette)
{
	size_t NumPalettes = RGBValues.size();
	vector<bool> PaletteMatch = vector<bool>(NumPalettes, true);

	if (ImagePalette.size() > 16)
	{
		return -1;
	}

	for (int i = 0; i < ImagePalette.size(); i++)
	{
		unsigned int Colour = ImagePalette[i];

		for (int Pal = 0; Pal < NumPalettes; Pal++)
		{
			vector<unsigned int>& rRGBValues = RGBValues[Pal];
			if (PaletteMatch[Pal] == true)
			{
				if (std::find(rRGBValues.begin(), rRGBValues.end(), Colour) == rRGBValues.end())
				{
					PaletteMatch[Pal] = false;
				}
			}
		}
	}

	int index = -1;
	auto it = std::find(PaletteMatch.begin(), PaletteMatch.end(), true);
	if (it != PaletteMatch.end())
	{
		index = (int)(it - PaletteMatch.begin());
	}
	return index;
}

void GPIMAGE::SetPixel(int X, int Y, unsigned int col)
{
	if ((X >= 0) && (X < Width) && (Y >= 0) && (Y < Height))
	{
		ImageData[Y][X] = col;
	}
}

void GPIMAGE::SetPixelPaletteColour(int X, int Y, unsigned char Index)
{
	if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
		return;

	SetPixel(X, Y, RGBValues[PaletteType][Index]);
}

void GPIMAGE::FillRectangle(int X0, int Y0, int X1, int Y1, unsigned int col)
{
	for (int YPos = Y0; YPos < Y1; YPos++)
	{
		for (int XPos = X0; XPos < X1; XPos++)
		{
			SetPixel(XPos, YPos, col);
		}
	}
}

void GPIMAGE::FillRectanglePaletteColour(int X0, int Y0, int X1, int Y1, unsigned char Index)
{
	FillRectangle(X0, Y0, X1, Y1, RGBValues[PaletteType][Index]);
}

void GPIMAGE::DrawImage(int X, int Y, GPIMAGE& Img)
{
	if ((X < 0) || (Y < 0) || (X >= Width) || (Y >= Height))
		return;

	for (int iY = 0; iY < Img.Height; iY++)
	{
		int OutY = Y + iY;
		if (OutY >= Height)
			continue;

		for (int iX = 0; iX < Img.Width; iX++)
		{
			int OutX = X + iX;
			if (OutX >= Width)
				continue;

			SetPixel(OutX, OutY, Img.GetPixel(iX, iY));
		}
	}
}
