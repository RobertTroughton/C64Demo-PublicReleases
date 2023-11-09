// (c) 2018-2020, Genesis*Project


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

					unsigned char OutBits = 3;
					switch (Col)
					{
					case 0x0e:
						OutBits = 1;
						break;

					case 0x06:
						OutBits = 0;
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

void InfiniteBobs_ConvertBobToASM(char* InBobImageFilename, LPTSTR OutBobASMFilename)
{
	static const int NumBobs = 4;

	GPIMAGE BobImage(InBobImageFilename);

	int BobWidth = BobImage.Width;
	int BobHeight = BobImage.Height;
	int BobCharWidth = (BobWidth + 7) / 8;

	unsigned char* OutBob = new unsigned char [2 * NumBobs * BobHeight * BobCharWidth];

	CodeGen OutCodeASM(OutBobASMFilename);

	for (int bob = 0; bob < NumBobs; bob++)
	{
		int xshift = bob * 2;
		for (int xchar = 0; xchar < BobCharWidth; xchar++)
		{
			for (int y = 0; y < BobHeight; y++)
			{
				unsigned char CurrentByte = 0;
				unsigned char CurrentMask = 0;

				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int x = xchar * 8 + xpixel - xshift;

					bool bMaskedOut = false;
					if ((x < 0) || (x >= BobWidth))
					{
						bMaskedOut = true;
					}
					else
					{
						unsigned int Col = BobImage.GetPixel(x, y);
						if (Col == 0xff00ea)
						{
							bMaskedOut = true;
						}
						else
						{
							unsigned char OutBits = 0;
							switch (Col)
							{
							case 0x00ffffff:
								OutBits = 2;
								break;

							case 0x00808080:
								OutBits = 1;
								break;

							case 0x00000000:
								OutBits = 3;
								break;
							}
							CurrentByte |= (OutBits << (6 - xpixel));
						}
					}
					if (bMaskedOut)
					{
						CurrentMask |= (3 << (6 - xpixel));
					}
				}
				int OutBobMaskOffset = (((0 * NumBobs) + bob) * BobHeight + y) * BobCharWidth + xchar;
				int OutBobDataOffset = (((1 * NumBobs) + bob) * BobHeight + y) * BobCharWidth + xchar;
				OutBob[OutBobMaskOffset] = CurrentMask;
				OutBob[OutBobDataOffset] = CurrentByte;
			}
		}
	}

	for (int bob = 0; bob < NumBobs; bob++)
	{
		OutCodeASM.OutputFunctionLine(fmt::format("BlitBob_Shift{:d}", bob));
		int AValue = -1;
		for (int xchar = 0; xchar < BobCharWidth; xchar++)
		{
			OutCodeASM.OutputCodeLine(LDY_IMM, fmt::format("#${:02x}", xchar * 8));
			OutCodeASM.OutputBlankLine();

			for (int y = 0; y < BobHeight; y++)
			{
				int OutBobMaskOffset = (((0 * NumBobs) + bob) * BobHeight + y) * BobCharWidth + xchar;
				int OutBobByteOffset = (((1 * NumBobs) + bob) * BobHeight + y) * BobCharWidth + xchar;
				unsigned char MaskValue = OutBob[OutBobMaskOffset];
				unsigned char ByteValue = OutBob[OutBobByteOffset];

				bool bMaskIs00 = (MaskValue == 0x00);
				bool bMaskIsFF = (MaskValue == 0xff);
				bool bDataIs00 = (ByteValue == 0x00);

				if ((!bMaskIsFF) || (!bDataIs00))
				{
					if (!bMaskIs00)
					{
						OutCodeASM.OutputCodeLine(LDA_IZY, fmt::format("ZP_BobOutY{:d}", y));
						AValue = -1;
						if (!bMaskIsFF)
						{
							OutCodeASM.OutputCodeLine(AND_IMM, fmt::format("#${:02x}", MaskValue));
						}
						if (!bDataIs00)
						{
							OutCodeASM.OutputCodeLine(ORA_IMM, fmt::format("#${:02x}", ByteValue));
						}
					}
					else
					{
						if (ByteValue != AValue)
						{
							OutCodeASM.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", ByteValue));
							AValue = ByteValue;
						}
					}
					OutCodeASM.OutputCodeLine(STA_IZY, fmt::format("ZP_BobOutY{:d}", y));
					OutCodeASM.OutputBlankLine();
				}
			}
		}
		OutCodeASM.OutputCodeLine(RTS);
		OutCodeASM.OutputBlankLine();
		OutCodeASM.OutputBlankLine();
	}

	delete[] OutBob;
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
SINTABLESETUP SinTableSetup =
{
	253,
	{	//; x
		{1.0, 0, 0},
		{2.0, 0, 0},
		{1.0, 1.4, 1.00},
	},
	{	//; y
		{1.0, 2.65, 1.00},
		{1.0, 0, 0},
		{1.0, 0, 0},
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

		double Angle = (2 * PI * (double)i) / (double)SinTabSetup.XTableLength;

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
		double Angle = (2 * PI * (double)i) / 256.0;

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
		iSin = (int)max(0, min(iAmplitude, iSin));
		SinTables[0][i] = (unsigned char)iSin;
	}

	//; ScreenY
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 232.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double SinVal = SinTableY[i] * HalfAmplitude + HalfAmplitude;
		int iSin = (int)floor(SinVal);
		iSin = (int)max(0, min(iAmplitude, iSin));
		SinTables[1][i] = (unsigned char)(iSin / 7);
		unsigned char cSin = (iSin % 7) + 1;
		SinTables[2][i] = cSin;
	}

	//; ScreenY_ClearLine
	static const int ImageHalfCharHeight = ImageCharHeight / 2;
	for (int i = 0; i < 256; i++)
	{
		int LastI = (i + 254) % 256;
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
		double Amplitude = 494.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double InSin = SinTableX[i];//; *0.9;
		double SinVal = InSin * HalfAmplitude + HalfAmplitude;
		int iSin = (int)floor(SinVal);
		iSin = (int)max(0, min(iAmplitude, iSin));
		SinTables[3][i] = (unsigned char)(iSin / 8);
		SinTables[4][i] = (((unsigned char)(iSin % 8)) / 2);
	}

	//; BobY, BobYPix
	for (int i = 0; i < 256; i++)
	{
		double Amplitude = 386.0;
		int iAmplitude = (int)Amplitude - 1;
		double HalfAmplitude = Amplitude / 2.0;
		double InSin = SinTableY[i];//; *0.85;
		double SinVal = InSin * HalfAmplitude + HalfAmplitude + 12.0;
		int iSin = (int)floor(SinVal);
//;		iSin = (int)max(0, min(iAmplitude, iSin));
		SinTables[5][i] = (unsigned char)(iSin / 8);
		SinTables[6][i] = 7 - (unsigned char)(iSin % 8);
	}
	



	WriteBinaryFile(SinTableBINFilename, SinTables, sizeof(SinTables));
}

void InfiniteBobs_ProcessAnimation(char * InAnimationPNGFilename, int NumAnimFrames, LPTSTR OutAnimASMFilename)
{
	unsigned char ZerosBlock[32];
	ZeroMemory(ZerosBlock, sizeof(ZerosBlock));

	unsigned char* AnimationFrames = new unsigned char[NumAnimFrames * ImageCharWidth * ImageHeight];

	GPIMAGE InAnim(InAnimationPNGFilename);
	for (int Frame = 0; Frame < NumAnimFrames; Frame++)
	{
		for (int y = 0; y < ImageHeight; y++)
		{
			int InY = Frame * 512 + y;
			for (int xchar = 0; xchar < ImageCharWidth; xchar++)
			{
				unsigned char OutByte = 0;
				int OutOffset = (y * ImageCharWidth + xchar) * NumAnimFrames + Frame;
				for (int xpixel = 0; xpixel < 8; xpixel += 2)
				{
					int InX = (xchar * 8) + xpixel;

					unsigned char Col = InAnim.GetPixelPaletteColour(InX, InY);

					unsigned char OutBits = 3;
					switch (Col)
					{
					case 0x0e:
						OutBits = 1;
						break;

					case 0x06:
						OutBits = 0;
						break;
					}

					OutByte |= (OutBits << (6 - xpixel));
				}
				AnimationFrames[OutOffset] = OutByte;
			}
		}
	}

	static const int MaxNumAnimationBytes = 2048;
	int NumAnimationBytes = 0;
	int AnimationBytes[MaxNumAnimationBytes][2];

	for (int y = 0; y < ImageHeight; y++)
	{
		for (int xchar = 0; xchar < ImageCharWidth; xchar++)
		{
			bool bPixelsIdentical = true;
			int InOffsetBase = (y * ImageCharWidth + xchar) * NumAnimFrames + 0;
			for (int Frame = 1; Frame < NumAnimFrames; Frame++)
			{
				int InOffset = (y * ImageCharWidth + xchar) * NumAnimFrames + Frame;
				if (AnimationFrames[InOffsetBase] != AnimationFrames[InOffset])
				{
					bPixelsIdentical = false;
					break;
				}
			}
			if (!bPixelsIdentical)
			{
				AnimationBytes[NumAnimationBytes][0] = xchar;
				AnimationBytes[NumAnimationBytes][1] = y;
				NumAnimationBytes++;
			}
		}
	}

	CodeGen AnimCode(OutAnimASMFilename);

	int DataOffset = 0;
	for (int i = 0; i < NumAnimationBytes; i++)
	{
		int xchar = AnimationBytes[i][0];
		int y = AnimationBytes[i][1];

		int NumBytesLeftInPage = 256 - DataOffset;
		int NumBytesToOutput = NumAnimFrames;

		if (NumBytesToOutput > NumBytesLeftInPage)
		{
			AnimCode.OutputCommentLine(fmt::format("//; Padding to fill page"));
			AnimCode.OutputByteBlock(ZerosBlock, NumBytesLeftInPage, NumBytesLeftInPage);
			AnimCode.OutputBlankLine();
			DataOffset = 0;
		}
		AnimCode.OutputFunctionLine(fmt::format("Anim_{:d}", i));
		int InOffset = (y * ImageCharWidth + xchar) * NumAnimFrames;
		AnimCode.OutputByteBlock(&AnimationFrames[InOffset], NumBytesToOutput);
		AnimCode.OutputBlankLine();
		DataOffset += NumBytesToOutput;
	}
	AnimCode.OutputBlankLine();

	AnimCode.OutputFunctionLine(fmt::format("DoAnimation"));
	for (int i = 0; i < NumAnimationBytes; i++)
	{
		int xchar = AnimationBytes[i][0];
		int y = AnimationBytes[i][1];

		int CharBank = y / 32;
		int OutYChar = (y % 32) / 8;
		int OutYPixel = y % 8;
		int WriteOffset = ((OutYChar * ImageCharWidth) + xchar) * 8 + OutYPixel;

		AnimCode.OutputCodeLine(LDA_ABY, fmt::format("Anim_{:d}", i));
		AnimCode.OutputCodeLine(STA_ABS, fmt::format("CharAddress{:d} + ${:04x}", CharBank, WriteOffset));
	}
	AnimCode.OutputCodeLine(RTS);
	AnimCode.OutputBlankLine();
}


void InfiniteBobs_GenerateEaseInChars(LPTSTR OutEaseInCharsBINFilename)
{
	unsigned char EaseInChars[16][8];
	for (int i = 0; i < 16; i++)
	{
		int StartFill = max(0, 8 - i);
		int EndFill = min(16, 16 - i);
		for (int y = 0; y < 8; y++)
		{
			unsigned char OutByte = 0x00;
			if ((y >= StartFill) && (y < EndFill))
			{
				OutByte = 0xff;
			}
			EaseInChars[i][y] = OutByte;
		}
	}
	WriteBinaryFile(OutEaseInCharsBINFilename, EaseInChars, sizeof(EaseInChars));
}


int InfiniteBobs_Main()
{
	InfiniteBobs_ConvertImageToImageData("Parts\\InfiniteBobs\\Data\\pic512x448.png", L"Link\\InfiniteBobs\\ImageData.bin");

	InfiniteBobs_ConvertBobToASM("Parts\\InfiniteBobs\\Data\\bob.png", L"Build\\6502\\InfiniteBobs\\bob.asm");

	InfiniteBobs_GenerateSinTablesBIN(L"Link\\InfiniteBobs\\SinTables.bin", SinTableSetup);

	InfiniteBobs_ProcessAnimation("Parts\\InfiniteBobs\\Data\\razorback-anim-12frames.png", 12, L"Build\\6502\\InfiniteBobs\\anim.asm");

	InfiniteBobs_GenerateEaseInChars(L"Link\\InfiniteBobs\\EaseInChars.bin");

	return 0;
}
