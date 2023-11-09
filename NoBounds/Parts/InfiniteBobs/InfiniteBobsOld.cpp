// (c) 2018-2020, Genesis*Project


#include <atlstr.h>

#include "..\Common\Common.h"

static const int ImageWidth = 512;
static const int ImageHeight = 448;

static const int ImageCharWidth = ImageWidth / 8;
static const int ImageCharHeight = ImageHeight / 8;

static const int NumCharSets = ImageCharHeight / 4;

static unsigned char CharSets[NumCharSets][256][8];

void InfiniteBobs_ConvertImageToImageData(char* InImagePNG, LPTSTR OutImageDataBINFilename)
{
	GPIMAGE InImage(InImagePNG);

	unsigned char OutImageData[ImageCharHeight][ImageCharWidth / 2][8];

	for (int ychar = 0; ychar < ImageCharHeight; ychar++)
	{
		for (int xchar = 0; xchar < ImageCharWidth / 2; xchar++)
		{
			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				unsigned char OutByte = 0;
				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int x = xchar * 8 + xpixel;
					unsigned char Col = InImage.GetPixelPaletteColour(x, y);

					unsigned char OutBits = 0;
					switch (Col)
					{
					case 0x01:
						OutBits = 1;
						break;

					case 0x00:
						OutBits = 3;
						break;
					}

					OutByte |= (OutBits << (6 - xpixel));
				}

				OutImageData[ychar][xchar][ypixel] = OutByte;
			}
		}
	}
	WriteBinaryFile(OutImageDataBINFilename, OutImageData, sizeof(OutImageData));
}

void InfiniteBobs_ConvertBobToASM(char* InBobImageFilename, LPTSTR OutBobASMFilename, int bobID)
{
	static const int BobWidth = 24;
	static const int BobHeight = 32;
	static const int BobCharWidth = BobWidth / 8;
	static const int NumBobs = 4;

	unsigned char OutBob[NumBobs][BobCharWidth][2][BobHeight];

	GPIMAGE BobImage(InBobImageFilename);

	CodeGen OutCodeASM(OutBobASMFilename);

	for (int xchar = 0; xchar < BobCharWidth; xchar++)
	{
		for (int bob = 0; bob < NumBobs; bob++)
		{
			for (int y = 0; y < BobHeight; y++)
			{
				unsigned char CurrentByte = 0;
				unsigned char CurrentMask = 0;

				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int x = bob * BobWidth + xchar * 8 + xpixel;

					unsigned int Col = BobImage.GetPixel(x, y);

					if (Col == 0xff00ea)
					{
						CurrentMask |= (3 << (6 - xpixel));
					}
					else
					{
						unsigned char OutBits = 0;
						switch (Col)
						{
						case 0x00ffffff:
							OutBits = 1;
							break;

						case 0x00C0C0C0:
							OutBits = 2;
							break;

						case 0x00000000:
							OutBits = 3;
							break;
						}
						CurrentByte |= (OutBits << (6 - xpixel));
					}
				}

				OutBob[bob][xchar][0][y] = CurrentMask;
				OutBob[bob][xchar][1][y] = CurrentByte;
			}
			OutCodeASM.OutputFunctionLine(fmt::format("Bob{:d}_Mask_Shift{:d}_X{:d}", bobID, bob, xchar));
			OutCodeASM.OutputByteBlock(&OutBob[bob][xchar][0][0], BobHeight);
			OutCodeASM.OutputFunctionLine(fmt::format("Bob{:d}_Data_Shift{:d}_X{:d}", bobID, bob, xchar));
			OutCodeASM.OutputByteBlock(&OutBob[bob][xchar][1][0], BobHeight);
			OutCodeASM.OutputBlankLine();
		}
	}
}


struct SINTABLEELEMENT
{
	double AngleScale;
	double AngleOffset;
	double SinContribution;
};
struct SINTABLESETUP
{
	int XTableLength;
	SINTABLEELEMENT x[3];
	SINTABLEELEMENT y[3];
};
SINTABLESETUP SinTableSetup[2] =
{
	{
		219,
		{	//; x
			{1.0, 1.384, 0.28},
			{2.0, 2.121, 0.35},
			{2.0, 0, 1.00},
		},
		{	//; y
			{2.0, PI / 2, 1.00},
			{1.0, 0.932, 0.25},
			{1.0, 1.749, 0},
		},
	},
	{
		219,
		{	//; x
			{1.0, 2.384, 0.28},
			{2.0, 1.121, 0.33},
			{2.0, 0, 1.00},
		},
		{	//; y
			{2.0, PI / 2, 1.00},
			{1.0, 0.132, 0.25},
			{1.0, 2.749, 0},
		},
	},
};

void InfiniteBobs_GenerateSinTablesBIN(LPTSTR SinTableBINFilename, SINTABLESETUP SinTabSetup)
{
	double SinTableX[256];
	double MinSinX = 999999.0;
	double MaxSinX = -999999.0;
	for (int j = 0; j < 256; j++)
	{
		int i = j % SinTabSetup.XTableLength;

		double Angle = (2 * PI * (double)i * 1.0) / (double)SinTabSetup.XTableLength;

		double AngleX0 = (Angle * SinTabSetup.x[0].AngleScale) + SinTabSetup.x[0].AngleOffset;
		double AngleX1 = (Angle * SinTabSetup.x[1].AngleScale) + SinTabSetup.x[1].AngleOffset;
		double AngleX2 = (Angle * SinTabSetup.x[2].AngleScale) + SinTabSetup.x[2].AngleOffset;
		double ModX0 = SinTabSetup.x[0].SinContribution;
		double ModX1 = SinTabSetup.x[1].SinContribution;
		double ModX2 = SinTabSetup.x[2].SinContribution;

		double SinX = sin(AngleX0) * ModX0;
		SinX += sin(AngleX1) * ModX1;
		SinX += sin(AngleX2) * ModX2;

		SinTableX[j] = SinX;

		MinSinX = min(SinX, MinSinX);
		MaxSinX = max(SinX, MaxSinX);
	}
	double ScaleX = 2.0 / (MaxSinX - MinSinX);
	double MidX = (MaxSinX + MinSinX) / 2.0;
	for (int i = 0; i < 256; i++)
	{
		SinTableX[i] = (SinTableX[i] - MidX) * ScaleX;
	}

	double SinTableY[256];
	double MinSinY = 999999.0;
	double MaxSinY = -999999.0;
	for (int i = 0; i < 256; i++)
	{
		double Angle = (2 * PI * (double)i * 1.0) / 256.0;

		double AngleY0 = (Angle * SinTabSetup.y[0].AngleScale) + SinTabSetup.y[0].AngleOffset;
		double AngleY1 = (Angle * SinTabSetup.y[1].AngleScale) + SinTabSetup.y[1].AngleOffset;
		double AngleY2 = (Angle * SinTabSetup.y[2].AngleScale) + SinTabSetup.y[2].AngleOffset;
		double ModY0 = SinTabSetup.y[0].SinContribution;
		double ModY1 = SinTabSetup.y[1].SinContribution;
		double ModY2 = SinTabSetup.y[2].SinContribution;

		double SinY = sin(AngleY0) * ModY0;
		SinY += sin(AngleY1) * ModY1;
		SinY += sin(AngleY2) * ModY2;

		SinTableY[i] = SinY;

		MinSinY = min(SinY, MinSinY);
		MaxSinY = max(SinY, MaxSinY);
	}
	double ScaleY = 2.0 / (MaxSinY - MinSinY);
	double MidY = (MaxSinY + MinSinY) / 2.0;
	for (int i = 0; i < 256; i++)
	{
		SinTableY[i] = (SinTableY[i] - MidY) * ScaleY;
	}

	unsigned char SinTables[8][256];

	//; ScreenX
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 209.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double SinVal = SinTableX[i] * HalfAmplitude + HalfAmplitude;
		int iSin = (int)floor(SinVal);
		iSin = (int)max(0, min(iAmplitude, SinVal));
		SinTables[0][i] = (unsigned char)iSin;
	}

	//; ScreenY
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 266.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double SinVal = SinTableY[i] * HalfAmplitude + HalfAmplitude;
		int iSin = (int)floor(SinVal);
		iSin = (int)max(0, min(iAmplitude, SinVal));
		SinTables[1][i] = (unsigned char)(iSin / 8);
		SinTables[2][i] = (unsigned char)(iSin % 8);
	}

	//; ScreenY_ClearLine
	static const int ImageHalfCharHeight = ImageCharHeight / 2;
	for (int i = 0; i < 256; i++)
	{
		int LastI = (i + 255) % 256;
		int LastScreenYMin = SinTables[1][LastI];
		int ThisScreenYMin = SinTables[1][i];

		unsigned char OutVal = 255;
		if (ThisScreenYMin > LastScreenYMin)
		{
			if (ThisScreenYMin < ImageHalfCharHeight + 2)
			{
				OutVal = LastScreenYMin;
			}
		}
		if (ThisScreenYMin < LastScreenYMin)
		{
			int LastScreenYMax = LastScreenYMin + 21;
			if (LastScreenYMax > ImageHalfCharHeight - 2)
			{
				OutVal = LastScreenYMin + 21;
			}
		}
		if ((OutVal < 0) || (OutVal >= ImageCharHeight))
			OutVal = 0xff;
		SinTables[7][i] = OutVal;
	}

	//; BobX, BobXPix
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 496.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double InSin = SinTableX[i];//; *0.9;
		double SinVal = InSin * HalfAmplitude + HalfAmplitude;
		int iSin = (int)SinVal;
		iSin = (int)max(0, min(iAmplitude, SinVal));
		SinTables[3][i] = (unsigned char)(iSin / 8);
		SinTables[4][i] = (((unsigned char)(iSin % 8)) / 2) * 64;
	}

	//; BobY, BobYPix
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 432.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double InSin = SinTableY[i];//; *0.85;
		double SinVal = InSin * HalfAmplitude + HalfAmplitude;
		int iSin = (int)SinVal;
		iSin = (int)max(0, min(iAmplitude, SinVal));
		SinTables[5][i] = (unsigned char)(iSin / 8);
		SinTables[6][i] = 7 - (unsigned char)(iSin % 8);
	}

	WriteBinaryFile(SinTableBINFilename, SinTables, sizeof(SinTables));
}


int InfiniteBobs_Main()
{
	InfiniteBobs_ConvertImageToImageData("Parts\\InfiniteBobs\\Data\\pic512x448.png", L"Link\\InfiniteBobs\\ImageData.bin");

	InfiniteBobs_ConvertBobToASM("Parts\\InfiniteBobs\\Data\\bob.png", L"Link\\InfiniteBobs\\bob0.asm", 0);

	InfiniteBobs_GenerateSinTablesBIN(L"Link\\InfiniteBobs\\SinTables0.bin", SinTableSetup[0]);
	InfiniteBobs_GenerateSinTablesBIN(L"Link\\InfiniteBobs\\SinTables1.bin", SinTableSetup[1]);

	unsigned char FlipBits[256];
	for (int i = 0; i < 256; i++)
	{
		FlipBits[i] = ((i & 0x03) << 6) | ((i & 0x0c) << 2) | ((i & 0x30) >> 2) | ((i & 0xc0) >> 6);
	}
	WriteBinaryFile(L"Link\\InfiniteBobs\\FlipBits.bin", FlipBits, sizeof(FlipBits));

	unsigned char FlipY[256];
	for (int i = 0; i < 256; i++)
	{
		int x = i / 8;
		int y = i % 8;
		FlipY[i] = (31 - x) * 8 + y;
	}
	WriteBinaryFile(L"Link\\InfiniteBobs\\FlipY.bin", FlipY, sizeof(FlipY));

	return 0;
}
