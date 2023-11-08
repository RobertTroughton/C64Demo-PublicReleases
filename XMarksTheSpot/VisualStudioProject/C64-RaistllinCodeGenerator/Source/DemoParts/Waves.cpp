//; (c)2018, Raistlin / Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\ImageConversion.h"

#define WAVES_NUM_FILTER_MODES 8
#define WAVES_NUM_UNDULATION_FRAMES 4

#define WAVES_CHAR_WIDTH 16
#define WAVES_CHAR_HEIGHT 2
#define WAVES_WIDTH (WAVES_CHAR_WIDTH * 8)
#define WAVES_HEIGHT (WAVES_CHAR_HEIGHT * 8)

#define VIRTUAL_HEIGHT 8

#define WAVES_CLIP_SPRITE_YPOS (16 + 16 * 8)
#define WAVES_FIRST_CLIP_SPRITE 64

unsigned char WAVES_FilterModes[8][2] = {
	{ 0xAA, 0x00 },
	{ 0xAA, 0x55 },
	{ 0xFF, 0x55 },
	{ 0xFF, 0xFF },
	{ 0x55, 0xFF },
	{ 0x55, 0xAA },
	{ 0x00, 0x55 },
	{ 0x00, 0x00 },
};

unsigned char WAVES_OutputCharSet[WAVES_NUM_UNDULATION_FRAMES][256][8];
unsigned char WAVES_ClipData[WAVES_HEIGHT][WAVES_CHAR_WIDTH][WAVES_NUM_UNDULATION_FRAMES][8 / 2];
unsigned char WAVES_HeightValues[WAVES_NUM_UNDULATION_FRAMES][WAVES_NUM_FILTER_MODES][WAVES_WIDTH / 2];

#define WAVES_CLIPDATA_SIZE (WAVES_HEIGHT * WAVES_CHAR_WIDTH * WAVES_NUM_UNDULATION_FRAMES * (8 / 2))

void Waves_OutputChars(LPCTSTR OutputCharSetFilename, LPCTSTR OutputClipDataFilename, int *SinTable)
{
	ZeroMemory(WAVES_OutputCharSet, WAVES_NUM_UNDULATION_FRAMES * 256 * 8);
	ZeroMemory(WAVES_ClipData, WAVES_CLIPDATA_SIZE);
	ZeroMemory(WAVES_HeightValues, WAVES_NUM_UNDULATION_FRAMES * WAVES_NUM_FILTER_MODES * (WAVES_WIDTH / 2));

	for (int FilterMode = 0; FilterMode < WAVES_NUM_FILTER_MODES; FilterMode++)
	{
		int XDisplacement = (rand() * 2) % WAVES_WIDTH;

		for (int UndulationFrameIndex = 0; UndulationFrameIndex < WAVES_NUM_UNDULATION_FRAMES; UndulationFrameIndex++)
		{
			for (int XCharPos = 0; XCharPos < WAVES_CHAR_WIDTH; XCharPos++)
			{
				for (int YWrite = 0; YWrite < WAVES_HEIGHT; YWrite++)
				{
					WAVES_OutputCharSet[UndulationFrameIndex][(FilterMode * WAVES_CHAR_HEIGHT * WAVES_CHAR_WIDTH) + (XCharPos * WAVES_CHAR_HEIGHT) + (YWrite / 8)][YWrite % 8] = WAVES_FilterModes[(FilterMode - 1) % WAVES_NUM_FILTER_MODES][YWrite & 1];
				}
			}
			for (int XPos = 0; XPos < WAVES_WIDTH; XPos+=2)
			{
				int XDisplacedPosition = (XPos + XDisplacement) % WAVES_WIDTH;
				int XCharPos = XDisplacedPosition / 8;
				int XPixelPos = XDisplacedPosition % 8;
				unsigned char XPixelSet = 3 << (6 - XPixelPos);

				double SinValue0 = WAVES_HEIGHT - (double)SinTable[(XPos + ((0 * WAVES_WIDTH) / 2)) % WAVES_WIDTH];
				double SinValue1 = WAVES_HEIGHT - (double)SinTable[(XPos + ((1 * WAVES_WIDTH) / 2)) % WAVES_WIDTH];
				SinValue0 = (SinValue0 * UndulationFrameIndex) / (VIRTUAL_HEIGHT - 1);
				SinValue1 = (SinValue1 * (VIRTUAL_HEIGHT - 1 - UndulationFrameIndex)) / (WAVES_NUM_UNDULATION_FRAMES * 2 - 1);

				double SinValue = WAVES_HEIGHT - (SinValue0 + SinValue1);

				int YPos = (int)SinValue;
				YPos = min(WAVES_HEIGHT - 1, max(0, YPos));

				int OutputChar = XCharPos * WAVES_CHAR_HEIGHT;
				OutputChar += FilterMode * WAVES_CHAR_HEIGHT * WAVES_CHAR_WIDTH;

				for (int YWrite = YPos; YWrite < WAVES_HEIGHT; YWrite++)
				{
					unsigned char XPixelSetMasked = XPixelSet & WAVES_FilterModes[FilterMode][YWrite & 1];
					WAVES_OutputCharSet[UndulationFrameIndex][OutputChar + YWrite / 8][YWrite % 8] &= (0xFF - XPixelSet);
					WAVES_OutputCharSet[UndulationFrameIndex][OutputChar + YWrite / 8][YWrite % 8] |= XPixelSetMasked;
				}
				WAVES_HeightValues[UndulationFrameIndex][FilterMode][XDisplacedPosition / 2] = YPos;
			}
		}
	}
	WriteBinaryFile(OutputCharSetFilename, WAVES_OutputCharSet, WAVES_NUM_UNDULATION_FRAMES * 256 * 8);

	int FilterIndex = (WAVES_CLIP_SPRITE_YPOS / 16) % WAVES_NUM_FILTER_MODES;
	for (int YPos = 0; YPos < WAVES_HEIGHT; YPos++)
	{
		for (int UndulationFrameIndex = 0; UndulationFrameIndex < WAVES_NUM_UNDULATION_FRAMES; UndulationFrameIndex++)
		{
			for (int XPixelScroll = 0; XPixelScroll < 8; XPixelScroll += 2)
			{
				for (int XPos = 0; XPos < WAVES_CHAR_WIDTH; XPos++)
				{
					unsigned char OutputByte = 0;

					for (int XPixelPos = 0; XPixelPos < 8; XPixelPos += 2)
					{
						int XReadPos = ((XPos * 8 + XPixelPos + XPixelScroll) % WAVES_WIDTH) / 2;
						int Height = WAVES_HeightValues[UndulationFrameIndex][FilterIndex][XReadPos];
						if (YPos < Height)
						{
							OutputByte |= (3 << (6 - XPixelPos));
						}
					}

					WAVES_ClipData[YPos][XPos][UndulationFrameIndex][XPixelScroll/2] = OutputByte;
				}
			}
		}
	}
	WriteBinaryFile(OutputClipDataFilename, WAVES_ClipData, WAVES_CLIPDATA_SIZE);
}

void Waves_OutputDrawCode(ofstream& file)
{
	int TotalCycles = 0;
	int TotalSize = 0;

	ostringstream WavesCodeStream;

	WavesCodeStream << "WAVES_Add1Modded:";
	OUTPUT_CODE(WavesCodeStream, 0, 0, true);
	for (int ModIndex = 0; ModIndex < 256; ModIndex++)
	{
		bool bFirstOnLine = (ModIndex & (WAVES_CHAR_WIDTH * WAVES_CHAR_HEIGHT - 1)) == 0;
		bool bLastOnLine = (ModIndex & (WAVES_CHAR_WIDTH * WAVES_CHAR_HEIGHT - 1)) == (WAVES_CHAR_WIDTH * WAVES_CHAR_HEIGHT - 1);
		if (bFirstOnLine)
		{
			WavesCodeStream << "\t.byte ";
		}
		else
		{
			WavesCodeStream << ", ";
		}
		int ModNext = ModIndex;
		if (bLastOnLine)
		{
			ModNext -= (WAVES_CHAR_WIDTH * WAVES_CHAR_HEIGHT - 1);
		}
		else
		{
			ModNext++;
		}

		WavesCodeStream << "$" << hex << setw(2) << setfill('0') << int(ModNext) << setfill(' ');

		if (bLastOnLine)
		{
			WavesCodeStream << " ";
			OUTPUT_CODE(WavesCodeStream, 0, WAVES_CHAR_WIDTH * WAVES_CHAR_HEIGHT, true);
		}
	}
	OUTPUT_BLANK_LINE();

	TotalCycles = TotalSize = 0;

	WavesCodeStream << "WAVES_DrawLayers:";
	OUTPUT_CODE(WavesCodeStream, 0, 0, true);
	int NumLayers = 24 / WAVES_CHAR_HEIGHT;
	for (int WaveLayer = NumLayers - 1; WaveLayer >= 0; WaveLayer--)
	{
		bool bLastLayer = (WaveLayer == 0);

		WavesCodeStream << "\tWAVES_DrawLayer" << dec << int(WaveLayer) << ":";
		OUTPUT_CODE(WavesCodeStream, 0, 0, true);
		int XOffset = (rand() % WAVES_CHAR_WIDTH) * WAVES_CHAR_HEIGHT;

		WavesCodeStream << "WAVES_DrawIndexValue" << dec << int(WaveLayer) << ":";
		OUTPUT_CODE(WavesCodeStream, 0, 0, true);
		WavesCodeStream << "\t\tldx #$00";
		OUTPUT_CODE(WavesCodeStream, 2, 2, true);
		WavesCodeStream << "\tWAVES_OldX" << dec << int(WaveLayer) << ":";
		OUTPUT_CODE(WavesCodeStream, 0, 0, true);
		WavesCodeStream << "\t\tcpx #$ff";
		OUTPUT_CODE(WavesCodeStream, 2, 2, true);
		WavesCodeStream << "\t\tbne WAVES_DoLayer" << dec << int(WaveLayer);
		OUTPUT_CODE(WavesCodeStream, 3, 2, true);
		if (!bLastLayer)
		{
			WavesCodeStream << "\t\tjmp WAVES_DrawLayer" << dec << int(WaveLayer - 1);
			OUTPUT_CODE(WavesCodeStream, 3, 3, true);
		}
		else
		{
			WavesCodeStream << "\t\trts";
			OUTPUT_CODE(WavesCodeStream, 6, 1, true);
		}
		WavesCodeStream << "\tWAVES_DoLayer" << dec << int(WaveLayer) << ":";
		OUTPUT_CODE(WavesCodeStream, 0, 0, true);
		WavesCodeStream << "\t\tstx WAVES_OldX" << dec << int(WaveLayer) << " + 1";
		OUTPUT_CODE(WavesCodeStream, 4, 3, true);

		for (int XVal = 0; XVal < WAVES_CHAR_WIDTH; XVal++)
		{
			bool bEvenX = (XVal & 1) == 0;
			for (int YVal = 0; YVal < WAVES_CHAR_HEIGHT; YVal++)
			{
				bool bLastLineOfLayer = (YVal == (WAVES_CHAR_HEIGHT - 1));

				int DrawScreenIndex = WaveLayer & 1;

				int ShiftedXVal = XVal;
				while (ShiftedXVal < 40)
				{
					if (bEvenX)
					{
						WavesCodeStream << "\t\tstx ScreenAddress" << dec << int(DrawScreenIndex) << " + ((" << dec << int(WaveLayer) << " * " << dec << int(WAVES_CHAR_HEIGHT) << ") + " << dec << int(YVal) << ") * 40 + " << dec << int(ShiftedXVal);
						OUTPUT_CODE(WavesCodeStream, 4, 3, true);
					}
					else
					{
						WavesCodeStream << "\t\tsty ScreenAddress" << dec << int(DrawScreenIndex) << " + ((" << dec << int(WaveLayer) << " * " << dec << int(WAVES_CHAR_HEIGHT) << ") + " << dec << int(YVal) << ") * 40 + " << dec << int(ShiftedXVal);
						OUTPUT_CODE(WavesCodeStream, 4, 3, true);
					}
					ShiftedXVal += 16;
				}
				if (!bLastLineOfLayer)
				{
					if (bEvenX)
					{
						WavesCodeStream << "\t\tinx";
						OUTPUT_CODE(WavesCodeStream, 2, 1, true);
					}
					else
					{
						WavesCodeStream << "\t\tiny";
						OUTPUT_CODE(WavesCodeStream, 2, 1, true);
					}
				}
				else
				{
					if (XVal != (WAVES_CHAR_WIDTH - 1))
					{
						if (bEvenX)
						{
							WavesCodeStream << "\t\tldy WAVES_Add1Modded, x";
							OUTPUT_CODE(WavesCodeStream, 4, 3, true);
						}
						else
						{
							WavesCodeStream << "\t\tldx WAVES_Add1Modded, y";
							OUTPUT_CODE(WavesCodeStream, 4, 3, true);
						}
					}
				}
			}
		}
		OUTPUT_BLANK_LINE();
	}
	WavesCodeStream << "\t\trts";
	OUTPUT_CODE(WavesCodeStream, 6, 1, true);
}
	
void Waves_OutputClipData(
	LPCTSTR InputPackedSpritesFilename,
	LPCTSTR InputPackedLookupFilename,
	LPCTSTR OutputClipDataFilename,
	LPCTSTR OutputClipSpriteIndicesFilename
)
{
	static const int NumAnimations = 8;
	static const int NumSpritesPerRow = NumAnimations * 8;	// 8 animations of 8 sprites
	static const int RowToClip = 8;
	static const int NumRows = 10;
	static const int NumSpriteIndices = NumRows * NumSpritesPerRow;

	static const int NumClipSprites = 8;	//; For the clip sprites, the sprites MUST be static .. so we assume that we have 8

	unsigned char PackedSprites[256][64];
	unsigned char PackedLookup[NumSpriteIndices];
	ReadBinaryFile(InputPackedSpritesFilename, PackedSprites, 256 * 64);
	ReadBinaryFile(InputPackedLookupFilename, PackedLookup, NumSpriteIndices);

	unsigned char OutputClipData[NumClipSprites][64];
	unsigned char OutputClipSpriteIndices[NumClipSprites];

	for (int SpriteLookupIndex = 0; SpriteLookupIndex < NumClipSprites; SpriteLookupIndex++)
	{
		int SpriteIndex = PackedLookup[RowToClip * NumSpritesPerRow + SpriteLookupIndex];

		OutputClipSpriteIndices[SpriteLookupIndex] = SpriteIndex;

		for (int ByteIndex = 0; ByteIndex < 64; ByteIndex++)
		{
			OutputClipData[SpriteLookupIndex][ByteIndex] = PackedSprites[SpriteIndex][ByteIndex];
		}
	}

	WriteBinaryFile(OutputClipDataFilename, OutputClipData, NumClipSprites * 64);
	WriteBinaryFile(OutputClipSpriteIndicesFilename, OutputClipSpriteIndices, NumClipSprites);
}

int Waves_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\Waves");

	unsigned char ColourRemap0[] = { 3, 2, 1, 0 };
	unsigned char ColourRemap1[] = { 0, 1, 2, 3 };

	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\Blank.bmp",														//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\Blank.bin",		 										//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-PackedSprites.bin", 								//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-PackedLookup.bin",		 							//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true, 																							//; Multicolour
		ColourRemap0, 																					//; How we want to remap each colour bit in this sprite data
		16, 																							//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		8, 																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);
	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\IntroLogos-Genesis.bmp",											//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis.bin",									//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-PackedSprites.bin",					//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-PackedLookup.bin",						//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true,																							//; Multicolour
		ColourRemap0,																					//; How we want to remap each colour bit in this sprite data
		16,																								//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		1,																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);
	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\IntroLogos-Project.bmp",											//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project.bin", 									//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-PackedSprites.bin", 					//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-PackedLookup.bin", 					//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true, 																							//; Multicolour
		ColourRemap0, 																					//; How we want to remap each colour bit in this sprite data
		16, 																							//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		1, 																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);
	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\IntroLogos-Presents.bmp",											//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents.bin", 								//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-PackedSprites.bin", 					//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-PackedLookup.bin", 					//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true, 																							//; Multicolour
		ColourRemap0, 																					//; How we want to remap each colour bit in this sprite data
		16, 																							//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		1, 																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);
	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\IntroLogos-XMarks.bmp",											//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks.bin", 									//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-PackedSprites.bin", 					//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-PackedLookup.bin", 						//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true, 																							//; Multicolour
		ColourRemap0, 																					//; How we want to remap each colour bit in this sprite data
		16, 																							//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		1, 																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);
	ImageConv_BMPToPackedSpriteData(
		L"..\\..\\SourceData\\Waves\\RedcrabShipAnimsCombined.bmp",										//; Input BMP
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip.bin", 										//; Output Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-PackedSprites.bin", 							//; Output Packed Sprites
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-PackedLookup.bin", 							//; Output Packed Sprite Lookup Data
		192,																							//; Width of sprite data (or of a single animation if animated)
		168,																							//; Height of sprite data
		true, 																							//; Multicolour
		ColourRemap0, 																					//; How we want to remap each colour bit in this sprite data
		16, 																							//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
		6, 																								//; Number of animations
		8																								//; Virtual/Scratch number of animations
	);

	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\Blank-ClipSpriteIndices.bin"
	);
	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Genesis-ClipSpriteIndices.bin"
	);
	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Project-ClipSpriteIndices.bin"
	);
	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-Presents-ClipSpriteIndices.bin"
	);
	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\IntroLogos-XMarks-ClipSpriteIndices.bin"
	);
	Waves_OutputClipData(
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-PackedSprites.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-PackedLookup.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-ClipData.bin",
		L"..\\..\\Intermediate\\Built\\Waves\\RedcrabShip-ClipSpriteIndices.bin"
	);

	int Waves_SinTab[WAVES_WIDTH * 2];
	GenerateSinTable(WAVES_WIDTH * 2, -WAVES_HEIGHT / 4, WAVES_HEIGHT, 0, Waves_SinTab);
	Waves_OutputChars(L"..\\..\\Intermediate\\Built\\Waves\\Charset.bin", L"..\\..\\Intermediate\\Built\\Waves\\ClipData.bin", Waves_SinTab);
	GenerateSinTable(WAVES_WIDTH * 2, -WAVES_HEIGHT, WAVES_HEIGHT, 0, Waves_SinTab);
	Waves_OutputChars(L"..\\..\\Intermediate\\Built\\Waves\\Charset2.bin", L"..\\..\\Intermediate\\Built\\Waves\\ClipData2.bin", Waves_SinTab);

	/* Draw.asm */
	ofstream DrawASM;
	DrawASM.open("..\\..\\Intermediate\\Built\\Waves\\Draw.asm");
	DrawASM << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	Waves_OutputDrawCode(DrawASM);
	DrawASM.close();

	//; Wave Sintables
	int Waves_XMovingSinTab[256];
	int Waves_ScalingSinTab[256];
	GenerateSinTable(256, 0, 255, 0, Waves_XMovingSinTab);
	GenerateSinTable(256, 0, 255, 0, Waves_ScalingSinTab);

	unsigned char cWaves_SinTables[4][256];
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cWaves_SinTables[0][SinIndex] = 6 - (unsigned char)(Waves_XMovingSinTab[SinIndex] & 6);
		cWaves_SinTables[1][SinIndex] = (unsigned char)(((Waves_XMovingSinTab[SinIndex] / 8) % WAVES_CHAR_WIDTH) * WAVES_CHAR_HEIGHT);
	}

	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		double SinScale = (double)Waves_ScalingSinTab[SinIndex];
		SinScale /= 255.0;
		SinScale *= (double)VIRTUAL_HEIGHT;

		int iSinScale = (int)SinScale;
		iSinScale = max(0, min(VIRTUAL_HEIGHT - 1, iSinScale));
		iSinScale += (WAVES_NUM_UNDULATION_FRAMES - VIRTUAL_HEIGHT / 2);

		int iSinScaleLo, iSinScaleHi;
		if (iSinScale >= WAVES_NUM_UNDULATION_FRAMES)
		{
			iSinScaleLo = VIRTUAL_HEIGHT - 1 - iSinScale;
			iSinScaleHi = 0;
		}
		else
		{
			iSinScaleLo = iSinScale;
			iSinScaleHi = 1;
		}
		cWaves_SinTables[2][SinIndex] = (unsigned char)iSinScaleLo;
		cWaves_SinTables[3][SinIndex] = (unsigned char)(iSinScaleHi * (WAVES_CHAR_WIDTH / 2) * WAVES_CHAR_HEIGHT);
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Waves\\SinTable.bin", cWaves_SinTables, 256 * 4);

	//; Sprite Sintables
	int Waves_SpriteXSinTab[256];
	GenerateSinTable(256, 0, 95, 128, Waves_SpriteXSinTab);

	// 64 bytes: ease in
	// 128 bytes: regular sine
	// 64 bytes: ease out

	for (int SinTableDirection = 0; SinTableDirection < 2; SinTableDirection++)
	{
		unsigned char cWaves_SpriteSinTables[8 + 3][256];
		for (int SinIndex = 0; SinIndex < 256; SinIndex++)
		{
			int SinValue = Waves_SpriteXSinTab[(SinIndex * 2) % 256] + 24 + 16;

			if (SinIndex < 64)
			{
				int NewIndex = 63 - SinIndex;
				NewIndex = NewIndex * NewIndex;
				int ScrollAmount = (NewIndex * (160 + 96 + 24)) / (64 * 64);
				if (SinTableDirection == 0)
				{
					SinValue += ScrollAmount;
				}
				else
				{
					SinValue -= ScrollAmount;
				}
			}
			if (SinIndex >= 192)
			{
				int NewIndex = SinIndex - 192;
				NewIndex = NewIndex * NewIndex;
				int ScrollAmount = (NewIndex * (160 + 96 + 24)) / (64 * 64);
				if (SinTableDirection == 0)
				{
					SinValue -= ScrollAmount;
				}
				else
				{
					SinValue += ScrollAmount;
				}
			}

			unsigned char SpriteXMSB = 0;
			for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
			{
				int ThisSpriteX = SinValue + (SpriteIndex * 24);
				if (ThisSpriteX < 0)
				{
					ThisSpriteX = 0;
				}
				if (ThisSpriteX > 344)
				{
					ThisSpriteX = 344;
				}
				cWaves_SpriteSinTables[SpriteIndex][SinIndex] = (unsigned char)(ThisSpriteX & 255);
				SpriteXMSB |= ((ThisSpriteX / 256) << SpriteIndex);
			}
			cWaves_SpriteSinTables[8][SinIndex] = (unsigned char)SpriteXMSB;

			int ClipPositionX = ((SinValue - 24) / 4) & 0x1e;
			cWaves_SpriteSinTables[9][SinIndex] = (unsigned char)ClipPositionX;

			int ClipPositionXPixel = ((SinValue - 24) / 2) & 0x3;
			cWaves_SpriteSinTables[10][SinIndex] = (unsigned char)ClipPositionXPixel;
		}
		if (SinTableDirection == 0)
		{
			WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Waves\\SpriteSinTableRightToLeft.bin", cWaves_SpriteSinTables, 256 * 11);
		}
		else
		{
			WriteBinaryFile(L"..\\..\\Intermediate\\Built\\Waves\\SpriteSinTableLeftToRight.bin", cWaves_SpriteSinTables, 256 * 11);
		}
	}

	return 0;
}
