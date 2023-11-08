// (c) 2018-2020, Genesis*Project

#include "Common.h"

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "..\..\Extras\STB\stb_image.h"
#include "..\..\Extras\STB\stb_image_write.h"

static unsigned int RGBValues[][16] = {
	{0x000000,0xffffff,0x894036,0x7abfc7,0x8a46ae,0x68a941,0x3e31a2,0xd0dc71,0x905f25,0x5c4700,0xbb776d,0x555555,0x808080,0xacea88,0x7c70da,0xababab},	//; PIXCEN
};
static int NumPalettes = sizeof(RGBValues) / sizeof(RGBValues[0]);

GPIMAGE::GPIMAGE():
	ImageData(NULL),
	PalettizedImageData(NULL),
	Width(0),
	Height(0),
	PaletteType(-1)
{

}

GPIMAGE::GPIMAGE(int w, int h, unsigned int col):
	ImageData(NULL),
	PalettizedImageData(NULL),
	Width(w),
	Height(h),
	PaletteType(-1)
{
	ImageData = new unsigned int[w * h];
	unsigned int* pU32 = ImageData;
	for (int i = 0; i < w * h; i++)
	{
		*pU32++ = col;
	}
}

GPIMAGE::GPIMAGE(char const* filename):
	ImageData(NULL),
	PalettizedImageData(NULL),
	Width(0),
	Height(0),
	PaletteType(-1)
{
	Read(filename);
}

GPIMAGE::~GPIMAGE()
{
	delete[] ImageData;
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
	PalettizedImageData = new unsigned char[Width * Height];
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
			
			PalettizedImageData[Y * Width + X] = PaletteIndex;
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

	return ImageData[(Y * Width) + X];
}

unsigned char GPIMAGE::GetPixelPaletteIndex(int X, int Y)
{
	if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
		return 0xff;

	return PalettizedImageData[(Y * Width) + X];
}

void GPIMAGE::Read(char const* filename)
{
	int NumComps;
	unsigned char* Data = stbi_load(filename, &Width, &Height, &NumComps, 0);

	ImageData = new unsigned int[Width * Height];

	for (int YPos = 0; YPos < Height; YPos++)
	{
		for (int XPos = 0; XPos < Width; XPos++)
		{
			unsigned char* pPixel = &Data[((YPos * Width) + XPos) * NumComps];
			unsigned int* pU32 = &ImageData[(YPos * Width) + XPos];

			//; TODO: this assumes NumComps = 3!!!
			*pU32 = (pPixel[0] << 16) | (pPixel[1] << 8) | (pPixel[2] << 0);
		}
	}

	vector<unsigned int>ImagePalette;
	ExtractPalette(ImagePalette);
	PaletteType = FindMatchingPalette(ImagePalette);
	PalettiseImage(ImagePalette);

	stbi_image_free(Data);
}

void GPIMAGE::Write(char const* filename)
{
	unsigned char *Data = new unsigned char[Width * Height * 3];
	for (int YPos = 0; YPos < Height; YPos++)
	{
		for (int XPos = 0; XPos < Width; XPos++)
		{
			unsigned int Colour = ImageData[(YPos * Width) + XPos];
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
			unsigned int Colour = ImageData[(YPos * Width) + XPos];
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
	int RetVal = -1;
	if (ImagePalette.size() > 16)
	{
		return -1;
	}

	bool* PaletteMatch = new bool[NumPalettes];
	for (int Pal = 0; Pal < NumPalettes; Pal++)
	{
		PaletteMatch[Pal] = true;
	}

	for (int i = 0; i < ImagePalette.size(); i++)
	{
		unsigned int Colour = ImagePalette[i];

		for (int Pal = 0; Pal < NumPalettes; Pal++)
		{
			bool bFound = false;
			for (int Index = 0; Index < 16; Index++)
			{
				if (RGBValues[Pal][Index] == Colour)
				{
					bFound = true;
					break;
				}
			}
			if (!bFound)
			{
				PaletteMatch[Pal] = false;
			}
		}
	}

	for (int Pal = 0; Pal < NumPalettes; Pal++)
	{
		if (PaletteMatch[Pal])
		{
			RetVal = Pal;
		}
	}
	
	return RetVal;
}


void GPIMAGE::SetPixel(int X, int Y, unsigned int col)
{
	if ((X >= 0) && (X < Width) && (Y >= 0) && (Y < Height))
	{
		ImageData[Y * Width + X] = col;
	}
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

void GPIMAGE::SplitToBitmapData(unsigned char* MAPData, unsigned char* SCRData, unsigned char* COLData, unsigned char BackgroundColour)
{
	int CharWidth = Width / 8;
	int CharHeight = Height / 8;

	for (int YChar = 0; YChar < CharHeight; YChar++)
	{
		for (int XChar = 0; XChar < CharWidth; XChar++)
		{
			unsigned char PalValues[4] = {BackgroundColour, BackgroundColour, BackgroundColour, BackgroundColour};
			int NumPalVals = 1;
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int YPos = YChar * 8 + YPixel;

				unsigned char OutByte = 0;
				for (int XPixel = 0; XPixel < 8; XPixel += 2)
				{
					int XPos = XChar * 8 + XPixel;
					unsigned char ColValue = GetPixelPaletteColour(XPos, YPos);

					int PalIndex = -1;
					for (int i = 0; i < NumPalVals; i++)
					{
						if (PalValues[i] == ColValue)
						{
							PalIndex = i;
							break;
						}
					}
					if (PalIndex == -1)
					{
						PalIndex = 0;
						if (NumPalVals < 4)
						{
							PalIndex = NumPalVals;
							PalValues[PalIndex] = ColValue;
							NumPalVals++;
						}
					}

					OutByte |= (PalIndex << (6 - XPixel));
				}
				MAPData[(YChar * 40 + XChar) * 8 + YPixel] = OutByte;
			}
			COLData[YChar * 40 + XChar] = PalValues[3];
			SCRData[YChar * 40 + XChar] = (PalValues[1] << 4) + PalValues[2];
		}
	}
}