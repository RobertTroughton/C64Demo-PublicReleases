//; (c) Genesis*Project

#include <vector>
#include <io.h>

#include "..\Common\Common.h"

static const int NumAnimFrames = 3;
static const int NumColoursInColourTable = 48;

static unsigned int RGBValues[16] = {0x000000,0xffffff,0x894036,0x7abfc7,0x8a46ae,0x68a941,0x3e31a2,0xd0dc71,0x905f25,0x5c4700,0xbb776d,0x555555,0x808080,0xacea88,0x7c70da,0xababab};
unsigned char RingColours[] = {
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
	0x0b, 0x09, 0x02, 0x04, 0x0c, 0x03, 0x0d, 0x01, 0x0f, 0x05, 0x08, 0x02, 0x09,
	0x0b, 0x02, 0x04, 0x0a, 0x0f, 0x07, 0x01, 0x03, 0x0c, 0x04, 0x06,
};

unsigned char ScreenColours[25][40][3];

unsigned char OutMAP[25][40][8];
unsigned char OutSCR[25][40];
unsigned char OutCOL[25][40];
unsigned char OutKLA[2 + 8000 + 2000 + 1];

void CC_GenColourTable(char* InColourPicPNG, LPTSTR OutColourBIN)
{
	unsigned char ColTable[200 + 56];
	GPIMAGE InColours(InColourPicPNG);
	for (int y = 0; y < 200; y++)
	{
		ColTable[y] = InColours.GetPixelPaletteColour(0, y);
	}
	for (int y = 0; y < 56; y++)
	{
		ColTable[200 + y] = ColTable[y];
	}

	WriteBinaryFile(OutColourBIN, ColTable, sizeof(ColTable));
}

void CC_Generate(int Frame, char* OutImagePNG, LPTSTR OutImageMAP, LPTSTR OutImageKLA, LPTSTR OutASMFilename, LPTSTR OutASMFilenameA, LPTSTR OutASMFilenameB)
{
	double Offset = (double)Frame / (double)NumAnimFrames;

	static const int NumRings = 33;
	int iNumClashes = 0;

	memset(ScreenColours, 0xff, sizeof(ScreenColours));

	ZeroMemory(OutMAP, sizeof(OutMAP));
	ZeroMemory(OutSCR, sizeof(OutSCR));
	ZeroMemory(OutCOL, sizeof(OutCOL));

	GPIMAGE OutImg(320, 200);

	for (int Ring = 0; Ring < NumRings; Ring++)
	{
		double dRing = (double)Ring;
		double BaseCircleInner = ((dRing - Offset + 0.0) * 200.0) / (double)NumRings;
		double BaseCircleOuter = ((dRing - Offset + 1.0) * 200.0) / (double)NumRings;

		for (int YPos = 0; YPos < 200; YPos++)
		{
			int YCharPos = YPos / 8;
			for (int XPos = 0; XPos < 320; XPos+=2)
			{
				double ScaleX = cos(((double)XPos + 0.5) * PI * 2.0 / 320.0 * 5.0) * 0.03 + 0.97;
				double ScaleY = sin(((double)YPos + 0.5) * PI * 2.0 / 200.0 * 2.0 + 0.2) * 0.04 + 0.96;
				double Scale = ScaleX * ScaleX + ScaleY * ScaleY;

				double CircleInner = Scale * BaseCircleInner;
				double CircleOuter = Scale * BaseCircleOuter;

				int XCharPos = XPos / 8;

				double XDist = (159.5 - XPos);
				double YDist = (99.5 - YPos);
				double DistSq = XDist * XDist + YDist * YDist;
				double Dist = sqrt(DistSq);

				if ((Dist >= CircleInner) && (Dist < CircleOuter))
				{
					double dUne = (Dist - CircleInner) / (CircleOuter - CircleInner);

					int Ring_ToPlot = Ring + 1;

//;					int XYPosModded = YPos % 2;						//; Horizontal Dither
					int XYPosModded = ((XPos / 2) + YPos) % 2;		//; Chequered Ditgher
					if (dUne < 0.25)
					{
						if (XYPosModded == 1)
							Ring_ToPlot = Ring + 0;
					}
					if (dUne > 0.75)
					{
						if (XYPosModded == 0)
							Ring_ToPlot = Ring + 2;
					}

					unsigned char C64Colour = RingColours[Ring_ToPlot];
					unsigned int OutColour = RGBValues[C64Colour];

					unsigned char Current = ScreenColours[YCharPos][XCharPos][Ring_ToPlot % 3];
					if ((Current != 0xff) && (Current != Ring_ToPlot))
					{
						Ring_ToPlot++;
					}
					ScreenColours[YCharPos][XCharPos][Ring_ToPlot % 3] = Ring_ToPlot;

					OutImg.SetPixel(XPos, YPos, OutColour);
					OutImg.SetPixel(XPos + 1, YPos, OutColour);

					int YPixel = YPos % 8;
					int XPixel = XPos % 8;
					unsigned char ThisPlot = (Ring_ToPlot % 3) + 1;
					OutMAP[YCharPos][XCharPos][YPixel] |= (ThisPlot << (6 - XPixel));
				}
			}
		}
	}
	OutImg.Write(OutImagePNG);

	for (int YCharPos = 0; YCharPos < 25; YCharPos++)
	{
		for (int XCharPos = 0; XCharPos < 40; XCharPos++)
		{
			unsigned char Cols[3] = {0, 0, 0};
			
			for (int i = 0; i < 3; i++)
			{
				unsigned char ColIndex = ScreenColours[YCharPos][XCharPos][i];
				if (ColIndex != 0xff)
					Cols[i] = RingColours[ColIndex];
			}
			OutSCR[YCharPos][XCharPos] = (Cols[0] * 16) + Cols[1];
			OutCOL[YCharPos][XCharPos] = Cols[2];
		}
	}
	WriteBinaryFile(OutImageMAP, OutMAP, sizeof(OutMAP));

	OutKLA[0] = 0x00;
	OutKLA[1] = 0x20;
	memcpy(&OutKLA[2], OutMAP, 8000);
	memcpy(&OutKLA[8002], OutSCR, 1000);
	memcpy(&OutKLA[9002], OutCOL, 1000);
	WriteBinaryFile(OutImageKLA, OutKLA, 10003);

	CodeGen OutASM(OutASMFilename); // , true, 1); <-- select BadAss(Bass)
	CodeGen OutASMA(OutASMFilenameA); // , true, 1); <-- select BadAss(Bass)
	CodeGen OutASMB(OutASMFilenameB); // , true, 1); <-- select BadAss(Bass)

	OutASM.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonDefines.asm\""));
	OutASM.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonMacros.asm\""));
	OutASM.OutputCodeLine(NONE, fmt::format(".import source \"ColourCycle.sym\""));
	OutASM.OutputBlankLine();
	OutASM.OutputCodeLine(NONE, fmt::format(".var ScreenAddress0 = $4000"));
	OutASM.OutputCodeLine(NONE, fmt::format(".var ScreenAddress1 = $8000"));
	OutASM.OutputCodeLine(NONE, fmt::format(".var ScreenAddress2 = $e000"));
	OutASM.OutputBlankLine();

	OutASM.OutputFunctionLine(fmt::format("UpdateColours_Frame{:d}", Frame));

	OutASMA.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonDefines.asm\""));
	OutASMA.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonMacros.asm\""));
	OutASMA.OutputCodeLine(NONE, fmt::format(".import source \"ColourCycle.sym\""));
	OutASMA.OutputBlankLine();
	OutASMA.OutputCodeLine(NONE, fmt::format(".var ScreenAddress0 = $4000"));
	OutASMA.OutputCodeLine(NONE, fmt::format(".var ScreenAddress1 = $8000"));
	OutASMA.OutputCodeLine(NONE, fmt::format(".var ScreenAddress2 = $e000"));
	OutASMA.OutputBlankLine();

	OutASMA.OutputFunctionLine(fmt::format("UpdateColours_Frame{:d}", Frame));

	OutASMB.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonDefines.asm\""));
	OutASMB.OutputCodeLine(NONE, fmt::format(".import source \"../../../Main/Main-CommonMacros.asm\""));
	OutASMB.OutputCodeLine(NONE, fmt::format(".import source \"ColourCycle.sym\""));
	OutASMB.OutputBlankLine();
	OutASMB.OutputCodeLine(NONE, fmt::format(".var ScreenAddress0 = $4000"));
	OutASMB.OutputCodeLine(NONE, fmt::format(".var ScreenAddress1 = $8000"));
	OutASMB.OutputCodeLine(NONE, fmt::format(".var ScreenAddress2 = $e000"));
	OutASMB.OutputBlankLine();

	OutASMB.OutputFunctionLine(fmt::format("UpdateColours_Frame{:d}", Frame));

	int RollingSum = 0;

	for (int Ring = NumRings; Ring >= 0; Ring-=3)
	{
		for (int Pass = 0; Pass < 2; Pass++)
		{
			int ColMatch[2] = {0, 0};

			if (Pass == 0)
			{
				ColMatch[0] = Ring + 0;
				ColMatch[1] = Ring + 1;
			}
			if (Pass == 1)
			{
				ColMatch[0] = Ring + 3;
				ColMatch[1] = Ring + 1;
			}

			bool bFirst = true;
			for (int YCharPos = 0; YCharPos < 25; YCharPos++)
			{
				for (int XCharPos = 0; XCharPos < 40; XCharPos++)
				{
					bool bUsed[2] = {true, true};
					bool bMatch[2] = {false, false};
					for (int i = 0; i < 2; i++)
					{
						if (ScreenColours[YCharPos][XCharPos][i] == 0xff)
							bUsed[i] = false;
						if (ScreenColours[YCharPos][XCharPos][i] == ColMatch[i])
							bMatch[i] = true;
					}
					if ((bMatch[0] && bMatch[1]) || (bMatch[0] && !bUsed[1]) || (bMatch[1] && !bUsed[0]))
					{
						if (bFirst)
						{
							OutASM.OutputCodeLine(LDX_ZP, fmt::format("ZP_Colours + ${:02x}", ColMatch[0]));
							OutASM.OutputCodeLine(LDA_ABX, fmt::format("Mul16Table"));
							OutASM.OutputCodeLine(ORA_ZP, fmt::format("ZP_Colours + ${:02x}", ColMatch[1]));

							OutASMA.OutputCodeLine(LDX_ZP, fmt::format("ZP_Colours + ${:02x}", ColMatch[0]));
							OutASMA.OutputCodeLine(LDA_ABX, fmt::format("Mul16Table"));
							OutASMA.OutputCodeLine(ORA_ZP, fmt::format("ZP_Colours + ${:02x}", ColMatch[1]));

							OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, $00"));
							OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, $00, $00"));
							OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, $00"));

							bFirst = false;
						}

						int ScrAddHi = ((YCharPos * 40) + XCharPos) & 0xFF00;
						int ScrAddLo = ((YCharPos * 40) + XCharPos) % 256;

						RollingSum = ScrAddLo - RollingSum;

						if (RollingSum < 0)
							RollingSum += 256;

						if (RollingSum == 0)
							ScrAddHi += ScrAddLo;

						OutASM.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress{:d} + ({:d} * 40) + {:d}", Frame, YCharPos, XCharPos));
						OutASMA.OutputCodeLine(STA_ABS, fmt::format("ScreenAddress{:d} + ${:03x}", Frame, ScrAddHi));
						OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, ${:02x}, $00", RollingSum));

						RollingSum = ScrAddLo;

						ScreenColours[YCharPos][XCharPos][0] = 0xff;
						ScreenColours[YCharPos][XCharPos][1] = 0xff;
					}
				}
			}
		}

		bool bFirst = true;
		for (int YCharPos = 0; YCharPos < 25; YCharPos++)
		{
			for (int XCharPos = 0; XCharPos < 40; XCharPos++)
			{
				if (ScreenColours[YCharPos][XCharPos][2] == Ring + 2)
				{
					if (bFirst)
					{
						OutASM.OutputCodeLine(LDA_ZP, fmt::format("ZP_Colours + ${:02x}", Ring + 2));
						OutASMA.OutputCodeLine(LDA_ZP, fmt::format("ZP_Colours + ${:02x}", Ring + 2));
						OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, $00"));

						bFirst = false;
					}

					int ColAddHi = ((YCharPos * 40) + XCharPos) & 0xFF00;
					int ColAddLo = ((YCharPos * 40) + XCharPos) % 256;

					RollingSum = ColAddLo - RollingSum;

					if (RollingSum < 0)
						RollingSum += 256;

					if (RollingSum == 0)
						ColAddHi += ColAddLo;

					OutASM.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ({:d} * 40) + {:d}", YCharPos, XCharPos));
					OutASMA.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ${:03x}", ColAddHi));
					OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, ${:02x}, $00", RollingSum));

					RollingSum = ColAddLo;

					ScreenColours[YCharPos][XCharPos][2] = 0xff;
				}
			}
		}
	}
	OutASM.OutputCodeLine(JMP_ABS, fmt::format("ReturnFromCCCode"));
	OutASMA.OutputCodeLine(JMP_ABS, fmt::format("ReturnFromCCCode"));
	OutASMB.OutputCodeLine(NONE, fmt::format(".byte $00, $00, $00"));
}

void CC_GenerateSinTables(LPTSTR OutSineBIN)
{
	unsigned char SinTables[2][256];

	double SineValues[256];
	double MaxSine = -100000.0;
	double MinSine = 100000.0;

	for (int i = 0; i < 256; i++)
	{
		double Angle0 = ((double)(i + 31) * 2.0 * PI * 2.0) / 256.0;
		double Angle1 = ((double)(i + 178) * 2.0 * PI * 3.0) / 256.0;
		double Angle2 = ((double)(i + 100) * 2.0 * PI * 5.0) / 256.0;

		double SineValue = (sin(Angle0) + sin(Angle1) * 0.7 + sin(Angle2) * 0.3) * 0.6;

		SineValues[i] = SineValue;

		MaxSine = max(MaxSine, SineValue);
		MinSine = min(MinSine, SineValue);
	}

	double MaxSineValue = NumColoursInColourTable * NumAnimFrames * 0.5;
	double SineScale = ((double)MaxSineValue) / (MaxSine - MinSine);

	for (int i = 0; i < 256; i++)
	{
		double SineValue = SineValues[i];
		SineValue -= MinSine;
		SineValue *= SineScale;
		SineValue += (double)(i * NumColoursInColourTable * NumAnimFrames) / 256.0;

		while (SineValue < 0)
			SineValue += MaxSineValue;
		while (SineValue >= MaxSineValue)
			SineValue -= MaxSineValue;

		unsigned int cSineValue = (unsigned int)SineValue;
		cSineValue = NumColoursInColourTable * NumAnimFrames - 1 - cSineValue;	//; invert

		SinTables[0][i] = (unsigned char)(cSineValue / NumAnimFrames);
		SinTables[1][i] = (unsigned char)(cSineValue % NumAnimFrames);
	}

	WriteBinaryFile(OutSineBIN, SinTables, sizeof(SinTables));
}



void CC_ConvertSprites(char* InImagePNG, LPTSTR OutImageMAP)
{
	GPIMAGE InSpritesImage(InImagePNG);

	unsigned char OutSprites[8][64];
	ZeroMemory(OutSprites, sizeof(OutSprites));

	for (int y = 0; y < 84; y++)
	{
		for (int x = 0; x < 48; x += 2)
		{
			unsigned char Col = InSpritesImage.GetPixelPaletteColour(x, y);
			unsigned char OutCol = 0;

			if ((Col == 1) || (Col == 0))
			{
				OutCol = 2;
			}
			if (Col == 6)
			{
				OutCol = 1;
			}
			if (Col == 14)
			{
				OutCol = 3;
			}

			int SpriteIndex = (y / 21) * 2 + (x / 24);
			int ByteIndex = (y % 21) * 3 + ((x % 24) / 8);
			int OutShift = 6 - (x % 8);

			OutSprites[SpriteIndex][ByteIndex] |= OutCol << OutShift;
		}
	}
	WriteBinaryFile(OutImageMAP, OutSprites, sizeof(OutSprites));
}

void CC_GenerateSpriteSinus(LPTSTR OutSpriteSinusBIN)
{
	static const int NumSinEntries = 64;

	unsigned char SinTable[2][NumSinEntries];

	for (int i = 0; i < NumSinEntries; i++)
	{
		double XAngle = (2.0 * PI * (double)i) / (double)NumSinEntries;
		double YAngle = (2.0 * PI * (double)i * 2.0) / (double)NumSinEntries + PI * 0.5;

		double XSin = sin(XAngle) * 14.0 + 160.0;
		double YSin = -cos(YAngle) * 3.0 + 8.0;

		SinTable[0][i] = (unsigned char)floor(XSin);
		SinTable[1][i] = (unsigned char)floor(YSin);
	}
	WriteBinaryFile(OutSpriteSinusBIN, SinTable, sizeof(SinTable));
}

int ColourCycle_Main()
{
	CC_Generate(0, "Build\\6502\\ColourCycle\\CC0.png", L"Link\\ColourCycle\\CC0.map", L"Build\\6502\\ColourCycle\\CC0.kla", L"Build\\6502\\ColourCycle\\CC0.asm", L"Build\\6502\\ColourCycle\\CC0A.asm", L"Build\\6502\\ColourCycle\\CC0B.asm");
	CC_Generate(1, "Build\\6502\\ColourCycle\\CC1.png", L"Link\\ColourCycle\\CC1.map", L"Build\\6502\\ColourCycle\\CC1.kla", L"Build\\6502\\ColourCycle\\CC1.asm", L"Build\\6502\\ColourCycle\\CC1A.asm", L"Build\\6502\\ColourCycle\\CC1B.asm");
	CC_Generate(2, "Build\\6502\\ColourCycle\\CC2.png", L"Link\\ColourCycle\\CC2.map", L"Build\\6502\\ColourCycle\\CC2.kla", L"Build\\6502\\ColourCycle\\CC2.asm", L"Build\\6502\\ColourCycle\\CC2A.asm", L"Build\\6502\\ColourCycle\\CC2B.asm");

	CC_GenerateSinTables(L"Link\\ColourCycle\\SinTables.bin");

	CC_GenColourTable("Parts\\ColourCycle\\Data\\Facet-Colours-1200High.png", L"Link\\ColourCycle\\ColourTable.bin");

	CC_ConvertSprites("Parts\\ColourCycle\\Data\\Scrap-TardisSpritesMC.png", L"Link\\ColourCycle\\Scrap-TardisSpritesMC.map");

	CC_GenerateSpriteSinus(L"Link\\ColourCycle\\SpriteSinus.bin");

	return 0;
}


