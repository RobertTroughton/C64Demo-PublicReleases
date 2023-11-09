//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h" 
#include "..\Common\SinTables.h" 

static const int ImageWidth = 1600;
static const int ImageHeight = 200;

static const int ImageCharWidth = ImageWidth / 8;
static const int ImageCharHeight = ImageHeight / 8;

static const int StreamingImageWidth = ImageWidth - 320;
static const int StreamingImageCharWidth = StreamingImageWidth / 8;
static const int ImageChunkWidth = 64;
static const int ImageChunkCharWidth = ImageChunkWidth / 8;
static const int NumStreamingChunks = StreamingImageWidth / ImageChunkWidth;

unsigned char RasterColours[ImageHeight + 1];

static int GCurrentBuffer = -1;
static int GRasterLine = -1;

unsigned char BitmapMAPData[ImageCharHeight][ImageCharWidth][8];
unsigned char BitmapSCRData[ImageCharHeight][ImageCharWidth];
unsigned char BitmapCOLData[ImageCharHeight][ImageCharWidth];

void NoBounds_CreateBitmapBinariesUsingSPOT(string BitmapPNGFileName)
{
	
	//; Create MAP, COL, and SCR files using SPOT
	string ParameterString = BitmapPNGFileName + ".png msc " + BitmapPNGFileName;
	CHAR* Parameters = new CHAR[ParameterString.size() + 1];
	Parameters[ParameterString.size()] = 0;
	std::copy(ParameterString.begin(), ParameterString.end(), Parameters);

	char temp[512];
	sprintf_s(temp, "Extras\\SPOT.exe %s", Parameters);
	system((char*)temp);

}

void NoBounds_CreateFirstScreenBitmap(char* BitmapPNGFilename, LPTSTR BitmapMAPFileName, LPTSTR BitmapSCRFileName, LPTSTR BitmapCOLFileName, LPTSTR OutFirstScreenBitmapMAPFilename, LPTSTR OutFirstScreenBitmapSCRFilename, LPTSTR OutFirstScreenBitmapCOLFilename)
{

	GPIMAGE InBitmapImage(BitmapPNGFilename);

	ReadBinaryFile(BitmapMAPFileName, BitmapMAPData, sizeof(BitmapMAPData));
	ReadBinaryFile(BitmapSCRFileName, BitmapSCRData, sizeof(BitmapSCRData));
	ReadBinaryFile(BitmapCOLFileName, BitmapCOLData, sizeof(BitmapCOLData));

	unsigned char FirstScreenBitmapMAPData[25][40][8];
	unsigned char FirstScreenBitmapSCRData[25][40];
	unsigned char FirstScreenBitmapCOLData[25][40];

	ZeroMemory(FirstScreenBitmapMAPData, sizeof(FirstScreenBitmapMAPData));
	ZeroMemory(FirstScreenBitmapSCRData, sizeof(FirstScreenBitmapSCRData));
	ZeroMemory(FirstScreenBitmapCOLData, sizeof(FirstScreenBitmapCOLData));

	for (int y = 0; y < ImageHeight; y++)
	{
		RasterColours[y] = InBitmapImage.GetPixelPaletteColour(0, y);
	}
	RasterColours[ImageHeight] = 0;

	for (int ychar = 0; ychar < ImageCharHeight; ychar++)
	{
		for (int xchar = 0; xchar < 40; xchar++)
		{
			for (int ypix = 0; ypix < 8; ypix++)
			{
					FirstScreenBitmapMAPData[ychar][xchar][ypix] = BitmapMAPData[ychar][xchar][ypix];
			}
			FirstScreenBitmapSCRData[ychar][xchar] = BitmapSCRData[ychar][xchar];
			FirstScreenBitmapCOLData[ychar][xchar] = BitmapCOLData[ychar][xchar];
		}
	}

	WriteBinaryFile(OutFirstScreenBitmapMAPFilename, FirstScreenBitmapMAPData, sizeof(FirstScreenBitmapMAPData));
	WriteBinaryFile(OutFirstScreenBitmapSCRFilename, FirstScreenBitmapSCRData, sizeof(FirstScreenBitmapSCRData));
	WriteBinaryFile(OutFirstScreenBitmapCOLFilename, FirstScreenBitmapCOLData, sizeof(FirstScreenBitmapCOLData));

}

void NoBounds_ProcessBitmap(char* BitmapPNGFilename, LPTSTR OutFirstScreenBitmapMAPFilename, LPTSTR OutFirstScreenBitmapSCRFilename, LPTSTR OutFirstScreenBitmapCOLFilename, LPTSTR OutBitmapMAPFilename, LPTSTR OutBitmapSCRFilename, LPTSTR OutBitmapCOLFilename)
{
	GPIMAGE InBitmapImage(BitmapPNGFilename);

	unsigned char FirstScreenBitmapMAPData[25][40][8];
	unsigned char FirstScreenBitmapSCRData[25][40];
	unsigned char FirstScreenBitmapCOLData[25][40];

	ZeroMemory(BitmapMAPData, sizeof(BitmapMAPData));
	ZeroMemory(BitmapSCRData, sizeof(BitmapSCRData));
	ZeroMemory(BitmapCOLData, sizeof(BitmapCOLData));
	ZeroMemory(FirstScreenBitmapMAPData, sizeof(FirstScreenBitmapMAPData));
	ZeroMemory(FirstScreenBitmapSCRData, sizeof(FirstScreenBitmapSCRData));
	ZeroMemory(FirstScreenBitmapCOLData, sizeof(FirstScreenBitmapCOLData));

	for (int y = 0; y < ImageHeight; y++)
	{
		RasterColours[y] = InBitmapImage.GetPixelPaletteColour(0, y);
	}
	RasterColours[ImageHeight] = 0;

	for (int ychar = 0; ychar < ImageCharHeight; ychar++)
	{
		for (int xchar = 0; xchar < ImageCharWidth; xchar++)
		{
			unsigned char ThisPal[4];
			int NumColsThisChar = 0;

			ThisPal[0] = ThisPal[1] = ThisPal[2] = ThisPal[3] = 0;
			NumColsThisChar++;

			for (int ypix = 0; ypix < 8; ypix++)
			{
				int y = ychar * 8 + ypix;

				for (int xpix = 0; xpix < 8; xpix += 2)
				{
					int x = xchar * 8 + xpix;

					unsigned char col = InBitmapImage.GetPixelPaletteColour(x, y);

					int FoundCol = -1;
					for (int i = 0; i < NumColsThisChar; i++)
					{
						if (col == ThisPal[i])
						{
							FoundCol = i;
							break;
						}
					}
					if (FoundCol == -1)
					{
						if (NumColsThisChar < 4)
						{
							ThisPal[NumColsThisChar] = col;
							FoundCol = NumColsThisChar;
							NumColsThisChar++;
						}
						else
						{
							FoundCol = 0;
						}
					}
					int ColShift = 6 - xpix;
					BitmapMAPData[ychar][xchar][ypix] |= (FoundCol << ColShift);
				}
				if (xchar < 40)
				{
					FirstScreenBitmapMAPData[ychar][xchar][ypix] = BitmapMAPData[ychar][xchar][ypix];
				}
			}
			BitmapSCRData[ychar][xchar] = (ThisPal[1] << 4) | ThisPal[2];
			BitmapCOLData[ychar][xchar] = ThisPal[3];

			if (xchar < 40)
			{
				FirstScreenBitmapSCRData[ychar][xchar] = (ThisPal[1] << 4) | ThisPal[2];
				FirstScreenBitmapCOLData[ychar][xchar] = ThisPal[3];
			}
		}
	}

	WriteBinaryFile(OutFirstScreenBitmapMAPFilename, FirstScreenBitmapMAPData, sizeof(FirstScreenBitmapMAPData));
	WriteBinaryFile(OutFirstScreenBitmapSCRFilename, FirstScreenBitmapSCRData, sizeof(FirstScreenBitmapSCRData));
	WriteBinaryFile(OutFirstScreenBitmapCOLFilename, FirstScreenBitmapCOLData, sizeof(FirstScreenBitmapCOLData));
}

void NoBounds_UseCycles(CodeGen& OutASM, int NumCyclesToUse)
{
	int NumCyclesRemaining = NumCyclesToUse == -1 ? INT_MAX : NumCyclesToUse;

	static int CurrentMode = -1;
	static int CurrentCounterForMode = 0;

	if (NumCyclesToUse == 0)
	{
		CurrentMode = 0;
		CurrentCounterForMode = 0;
		return;
	}

	if ((GCurrentBuffer == 2) && (CurrentMode == 0))
	{
		bool bFinishedHere = false;
		while (!bFinishedHere)
		{
			int CurrentLDAorSTA = CurrentCounterForMode % 2;
			int CurrentCopyByte = (CurrentCounterForMode / 2) % 40;
			int CurrentRow = CurrentCounterForMode / (2 * 40);
			int MinRasterLine = 58 + (CurrentRow * 8);
			if (GRasterLine < MinRasterLine)
			{
				bFinishedHere = true;
				continue;
			}
			if (CurrentRow < 25)
			{
				if (CurrentLDAorSTA == 0)
				{
					if ((NumCyclesRemaining < 6) && (NumCyclesRemaining != 4))
					{
						bFinishedHere = true;
					}
					else
					{
						NumCyclesRemaining -= OutASM.OutputCodeLine(LDA_ABS, fmt::format("VIC_ColourMemory + ({:2d} * 40) + {:d} + 8", CurrentRow, CurrentCopyByte));
					}
				}
				else
				{
					if ((NumCyclesRemaining < 6) && (NumCyclesRemaining != 4))
					{
						bFinishedHere = true;
					}
					else
					{
						NumCyclesRemaining -= OutASM.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ({:2d} * 40) + {:d} + 0", CurrentRow, CurrentCopyByte));
					}
				}
				if (!bFinishedHere)
				{
					CurrentCounterForMode++;
				}
			}
			else
			{
				bFinishedHere = true;
				CurrentMode++;
				CurrentCounterForMode = 0;
			}
		}
	}

	if(NumCyclesToUse != -1)
		OutASM.WasteCycles(NumCyclesRemaining);
}


void NoBounds_GenerateRasterCode(LPTSTR OutRasterASMFilename)
{
	CodeGen OutRasterASM(OutRasterASMFilename);

	for (GCurrentBuffer = 0; GCurrentBuffer < 3; GCurrentBuffer++)
	{
		NoBounds_UseCycles(OutRasterASM, 0);

		OutRasterASM.OutputCodeLine(NONE, fmt::format(".align 128"));
		OutRasterASM.OutputFunctionLine(fmt::format("IRQ_Main{:d}", GCurrentBuffer));
		OutRasterASM.OutputBlankLine();
		OutRasterASM.OutputCodeLine(NONE, fmt::format("IRQManager_BeginIRQ(1, 0)"));
		OutRasterASM.OutputBlankLine();

		OutRasterASM.WasteCycles(5);
		OutRasterASM.OutputBlankLine();

		OutRasterASM.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
		OutRasterASM.OutputFunctionLine(fmt::format("VSP_Distance{:d}", GCurrentBuffer));
		OutRasterASM.OutputCodeLine(BEQ, fmt::format("VSP_Distance{:d} + 2", GCurrentBuffer));
		for (int i = 0; i < 19; i++)
		{
			OutRasterASM.OutputCodeLine(CPX_IMM, fmt::format("#$e0"));
		}
		OutRasterASM.OutputCodeLine(BIT_ZP, fmt::format("$ea"
		));
		OutRasterASM.OutputCodeLine(LDX_IMM, fmt::format("#$3b"));
		OutRasterASM.OutputCodeLine(LDA_IMM, fmt::format("#$39"));
		OutRasterASM.OutputCodeLine(STA_ABS, fmt::format("VIC_D011"));
		OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_D011"));
		OutRasterASM.OutputBlankLine();

		OutRasterASM.OutputBlankLine();

		NoBounds_UseCycles(OutRasterASM, 57);
		OutRasterASM.OutputBlankLine();

		int SpriteY = 50;

		for (int i = 0; i < ImageHeight + 1; i++)
		{
			int RasterLine = 51 + i;
			GRasterLine = RasterLine;
			OutRasterASM.OutputCommentLine(fmt::format("//; {:3d} ... vsync = {:d}", i, RasterLine));

			int NumCycles = 52;

			if ((RasterLine % 8) == 3)
			{
				NumCycles = 10;
			}
			NumCycles -= OutRasterASM.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", RasterColours[i]));
			NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_SpriteExtraColour0"));
			NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_BorderColour"));
			OutRasterASM.OutputBlankLine();

			if (RasterLine > SpriteY)
			{
				if (NumCycles >= (2 + 4 * 4 + 2))
				{
					SpriteY += 21;
					if (SpriteY < 250)
					{
						NumCycles -= OutRasterASM.OutputCodeLine(LDX_IMM, fmt::format("#${:02x}", SpriteY));
						NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_Sprite4Y"));
						NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_Sprite5Y"));
						NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_Sprite6Y"));
						NumCycles -= OutRasterASM.OutputCodeLine(STX_ABS, fmt::format("VIC_Sprite7Y"));
						OutRasterASM.OutputBlankLine();
					}
				}
			}

			if (NumCycles)
			{
				NoBounds_UseCycles(OutRasterASM, NumCycles);
				OutRasterASM.OutputBlankLine();
			}
			OutRasterASM.OutputBlankLine();
		}

		NoBounds_UseCycles(OutRasterASM, -1);	//; finish everything...
		OutRasterASM.OutputBlankLine();

		OutRasterASM.OutputCodeLine(JMP_ABS, fmt::format("ScrollScreenAndFinishIRQ"));

		OutRasterASM.OutputBlankLine();
		OutRasterASM.OutputBlankLine();
		OutRasterASM.OutputBlankLine();
	}
}

class CHUNK
{
public:
	unsigned char MAPData[25][8][8];
	unsigned char SCRData[25][8];
	unsigned char COLData[25][8];
} ChunkData[NumStreamingChunks];

void NoBounds_GenerateLinkingSLS(LPTSTR OutputStreamingSLSFilename, LPTSTR OutputStreamingBINFilename)
{
	CodeGen codeSLS(OutputStreamingSLSFilename, false);

	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < StreamingImageCharWidth; XChar++)
		{
			int ChunkIndex = XChar / ImageChunkCharWidth;
			int RelXChar = XChar % ImageChunkCharWidth;

			unsigned char SCRByte = BitmapSCRData[YChar][XChar + 40];
			unsigned char COLByte = BitmapCOLData[YChar][XChar + 40];
			ChunkData[ChunkIndex].SCRData[YChar][RelXChar] = SCRByte;
			ChunkData[ChunkIndex].COLData[YChar][RelXChar] = COLByte;

			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				unsigned char MAPByte = BitmapMAPData[YChar][XChar + 40][YPixel];
				ChunkData[ChunkIndex].MAPData[YChar][RelXChar][YPixel] = MAPByte;
			}
		}
	}
	WriteBinaryFile(OutputStreamingBINFilename, ChunkData, sizeof(ChunkData));

	int StreamDataSize = sizeof(ChunkData[0]);
	int DataLoadAddress;
	int StreamDataOffset;
	int db = 0;
	int ChunkCount = 0;
	int LastChunkCount = -1;
	int LoadAddress[4]{ 0x7c00,0x7400, 0x9800, 0x9000 };

	for (int Chunk = 0; Chunk < NumStreamingChunks; Chunk++)
	{
		if (ChunkCount != LastChunkCount)
		{
			codeSLS.OutputBlankLine();
			codeSLS.OutputCommentLine(fmt::format("#Chunk {:d}", ChunkCount));
			LastChunkCount = ChunkCount;
		}

		StreamDataOffset = StreamDataSize * Chunk;

		if (ChunkCount > 0)
		{
			//; add Mem: entry to chunks 2+ using the last load address and offset
			DataLoadAddress = LoadAddress[(Chunk - 3) % 4];
			codeSLS.OutputCommentLine(fmt::format("Mem:\t\t..\\..\\Link\\NoBounds\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", DataLoadAddress, StreamDataOffset - (3* StreamDataSize), StreamDataSize));
			DataLoadAddress = LoadAddress[(Chunk - 2) % 4];
			codeSLS.OutputCommentLine(fmt::format("Mem:\t\t..\\..\\Link\\NoBounds\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", DataLoadAddress, StreamDataOffset - (2 * StreamDataSize), StreamDataSize));
			DataLoadAddress = LoadAddress[(Chunk - 1) % 4];
			codeSLS.OutputCommentLine(fmt::format("Mem:\t\t..\\..\\Link\\NoBounds\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", DataLoadAddress, StreamDataOffset - (1 * StreamDataSize), StreamDataSize));
		}

		DataLoadAddress = LoadAddress[Chunk % 4];

		codeSLS.OutputCommentLine(fmt::format("File:\t\t..\\..\\Link\\NoBounds\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", DataLoadAddress, StreamDataOffset, StreamDataSize));

		if (Chunk > 2)	//; merge chunks 0-3
		{
			ChunkCount++;
		}
	}

	codeSLS.OutputBlankLine();
}

void NoBounds_GenerateFadeSprites(LPTSTR OutputFadeSpritesBINFilename, char* OutputFadeSpritesPNGFilename)
{
	unsigned char FadeSprites[17][64];
	memset(FadeSprites, 0x55, sizeof(FadeSprites));

	for (int AnimFrame = 0; AnimFrame < 17; AnimFrame++)
	{
		for (int Column = 0; Column < 12; Column++)
		{
			int NumWrites = max(0, min(21, (AnimFrame * 2) - Column));	//; (0, 1, 2, 3, ..., 21, 21, ...) for Col0, (12 * 0, 1, 2, ..., 21) for Col11

			int Y;
			int ByteIndex;

			int BitShift = 6 - ((Column * 2) % 8);
			unsigned char BitMask = 3 << BitShift;

			for (int iW = 0; iW < NumWrites; iW++)
			{
				bool bFound = false;
				while (!bFound)
				{
					Y = rand() % 21;
					ByteIndex = (Column * 2) / 8 + (Y * 3);

					if ((FadeSprites[AnimFrame][ByteIndex] & BitMask) != 0)
					{
						bFound = true;
					}
				}
				FadeSprites[AnimFrame][ByteIndex] &= (0xff - BitMask);
			}
		}
	}

	//; make the 64th byte of each sprite the same as the 63rd - hopefully improving compression?
	for (int AnimFrame = 0; AnimFrame < 17; AnimFrame++)
	{
		FadeSprites[AnimFrame][63] = FadeSprites[AnimFrame][62];
	}

	WriteBinaryFile(OutputFadeSpritesBINFilename, FadeSprites, sizeof(FadeSprites));

	GPIMAGE FadeSpritesImages(24 * 8, 21 * 4);
	for (int AnimFrame = 0; AnimFrame < 17; AnimFrame++)
	{
		int xSpriteCoord = 24 * (AnimFrame % 8);
		int ySpriteCoord = 21 * (AnimFrame / 8);

		for (int ByteIndex = 0; ByteIndex < 63; ByteIndex++)
		{
			unsigned char ThisChar = FadeSprites[AnimFrame][ByteIndex];

			int xchar = ByteIndex % 3;
			int y = ByteIndex / 3;

			for (int xpixel = 0; xpixel < 8; xpixel += 2)
			{
				unsigned int OutColour = ((ThisChar & (0xc0 >> xpixel))) ? 0x00ffffff : 0x00000000;
				FadeSpritesImages.SetPixel(xSpriteCoord + (xchar * 8) + xpixel, ySpriteCoord + y, OutColour);
				FadeSpritesImages.SetPixel(xSpriteCoord + (xchar * 8) + xpixel + 1, ySpriteCoord + y, OutColour);
			}
		}
	}
	FadeSpritesImages.Write(OutputFadeSpritesPNGFilename);
}

void NoBounds_GenerateScaledRasters(char* InPNGFilename, int Direction, char* OutPNGFilename)
{
	static const int NumFrames = 40;
	static const double dNumFrames = (double)NumFrames;
	static const int RasterHeight = 256;
	static const int StripHeight = 16;
	static const double dStripHeight = (double)StripHeight;
	static const double dHalfStripHeight = dStripHeight / 2.0;
	static const int NumStrips = RasterHeight / StripHeight;

	static const int StripFrameDelay = 6;
	static const int TotalNumFrames = ((NumStrips - 1) * StripFrameDelay) + NumFrames;

	GPIMAGE InImage(InPNGFilename);
	unsigned char RasterColours[RasterHeight];
	ZeroMemory(RasterColours, sizeof(RasterColours));

	for (int y = 0; y < InImage.Height; y++)
	{
		RasterColours[y] = InImage.GetPixelPaletteColour(0, y);
	}

	unsigned char RasterStripFrames[NumFrames][StripHeight];
	for (int Frame = 0; Frame < NumFrames; Frame++)
	{
		double dFrame = (double)Frame;
		double dStripH = dStripHeight * (dFrame / (dNumFrames - 1.0));;
		if (Direction == 0)
		{
			dStripH = dStripHeight - dStripH;
		}
		double dInterpY = dStripHeight / dStripH;

		for (int y = 0; y < StripHeight; y++)
		{
			double dY = (double)y;
			double dReadY = dHalfStripHeight + (dY - dHalfStripHeight) * dInterpY;
			int ReadY = (int)round(dReadY);
			if ((ReadY < 0) || (ReadY >= StripHeight))
			{
				ReadY = 0xff;
			}
			RasterStripFrames[Frame][y] = ReadY;
		}
	}

	GPIMAGE OutImage(TotalNumFrames, RasterHeight);
	for (int Strip = 0; Strip < NumStrips; Strip++)
	{
		for (int y = 0; y < StripHeight; y++)
		{
			for (int Frame = 0; Frame < NumFrames; Frame++)
			{
				int OutX = Strip * StripFrameDelay + Frame;

				unsigned char Index = RasterStripFrames[Frame][y];

				unsigned char Col = 0;
				if (Index != 0xff)
				{
					Col = RasterColours[Strip * StripHeight + Index];
				}

				int OutY = Strip * StripHeight + y;
				if ((Frame == 0) && (Strip > 0) && (Direction == 0))
				{
					OutImage.FillRectanglePaletteColour(0, OutY, OutX + 1, OutY + 1, Col);
				}
				else if ((Frame == (NumFrames - 1)) && (Strip < (NumStrips - 1)) && (Direction == 1))
				{
					OutImage.FillRectanglePaletteColour(OutX, OutY, TotalNumFrames, OutY + 1, Col);
				}
				else
				{
					OutImage.SetPixelPaletteColour(OutX, OutY, Col);

				}
			}
		}
	}
	OutImage.Write(OutPNGFilename);
}

static const int MaxNumFrames = 512;
static const int MaxNumColourChanges = 16384;
unsigned char OutRasterUpdateData_MinY[MaxNumFrames]; 
unsigned char OutRasterUpdateData_NumColourChanges[MaxNumFrames];
unsigned char OutRasterUpdateData_YValues[MaxNumColourChanges];
unsigned char OutRasterUpdateData_ColValues[MaxNumColourChanges];

void FadeFromNoBounds_ProcessRasterColours(char* InRasterPNG, LPTSTR OutStartRastersBINFilename, LPTSTR OutRasterUpdateDataASMFilename, LPTSTR OutRasterUpdateDefinesASMFilename)
{
	GPIMAGE InImage(InRasterPNG);

	unsigned char Cols[256];
	for (int y = 0; y < InImage.Height; y++)
	{
		Cols[y] = InImage.GetPixelPaletteColour(0, y);
	}
	WriteBinaryFile(OutStartRastersBINFilename, Cols, sizeof(Cols));

	int NumColourChanges = 0;

	int NumFrames = InImage.Width;

	for (int x = 0; x < NumFrames; x++)
	{
		int MinY = INT_MAX;

		int LastNumColourChanges = NumColourChanges;
		for (int y = 0; y < InImage.Height; y++)
		{
			unsigned char Col = InImage.GetPixelPaletteColour(x, y);
			if (Col != 0)
			{
				MinY = min(y, MinY);
			}
			if (Col != Cols[y])
			{
				OutRasterUpdateData_YValues[NumColourChanges] = y;
				OutRasterUpdateData_ColValues[NumColourChanges] = Col;
				NumColourChanges++;

				Cols[y] = Col;
			}
		}
		OutRasterUpdateData_NumColourChanges[x] = NumColourChanges - LastNumColourChanges;;
		OutRasterUpdateData_MinY[x] = MinY;
	}

	CodeGen OutRasterUpdateDefinesASM(OutRasterUpdateDefinesASMFilename);
	OutRasterUpdateDefinesASM.OutputCodeLine(NONE, fmt::format(".var FadeFromNoBounds_NumFrames = {:d}", NumFrames));
	OutRasterUpdateDefinesASM.OutputBlankLine();

	CodeGen OutRasterUpdateDataASM(OutRasterUpdateDataASMFilename);
	OutRasterUpdateDataASM.OutputCodeLine(NONE, fmt::format("* = $9000"));
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeFromNoBounds_RasterData_MinYValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_MinY, NumFrames, 32);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeFromNoBounds_RasterData_NumColourChanges"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_NumColourChanges, NumFrames, 32);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeFromNoBounds_RasterData_YValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_YValues, NumColourChanges, 32);
	OutRasterUpdateDataASM.OutputBlankLine();

	OutRasterUpdateDataASM.OutputFunctionLine(fmt::format("FadeFromNoBounds_RasterData_ColValues"));
	OutRasterUpdateDataASM.OutputByteBlock(OutRasterUpdateData_ColValues, NumColourChanges, 32);
	OutRasterUpdateDataASM.OutputBlankLine();
}

void NoBounds_CombineRasterImages(char* InPNG0, char* InPNG1, char* OutPNG, int Spacing, int Width)
{
	GPIMAGE InImage0(InPNG0);
	GPIMAGE InImage1(InPNG1);


	int OutSpacing = Spacing;
	if (OutSpacing == -1)
	{
		OutSpacing = InImage0.Width;
	}

	int OutWidth = Width;
	if (OutWidth == -1)
	{
		OutWidth = InImage0.Width + InImage1.Width;
	}

	int OutHeight = InImage0.Height;

	GPIMAGE OutImage(OutWidth, OutHeight);

	for (int y = 0; y < InImage0.Height; y++)
	{
		for (int x = 0; x < InImage0.Width; x++)
		{
			OutImage.SetPixel(x, y, InImage0.GetPixel(x, y));
		}
	}
	for (int y = 0; y < InImage1.Height; y++)
	{
		for (int x = 0; x < InImage1.Width; x++)
		{
			int OutX = x + OutSpacing;
			if (x < OutWidth)
			{
				unsigned int Colour = InImage1.GetPixel(x, y);
				if (Colour != 0)
				{
					OutImage.SetPixel(x + OutSpacing, y, InImage1.GetPixel(x, y));
				}
			}
		}
	}

	OutImage.Write(OutPNG);
}

void NoBounds_GenerateBarSprites(LPTSTR OutBarSpritesBINFilename, LPTSTR OutBarSintabBINFilename)
{
	static const int NumFrames = 15;
	static const int NumSplitsPer180 = 5;

	unsigned char OutSpriteData[NumFrames][64];
	ZeroMemory(OutSpriteData, sizeof(OutSpriteData));

	for (int Frame = 0; Frame < NumFrames; Frame++)
	{
		unsigned char OutSpriteLine[3] = {0,0,0};
		for (int Split = 0; Split < NumSplitsPer180; Split++)
		{
			double FrameInterp = ((double)Frame) / (double)NumFrames - 0.5;	//; 0-1

			double Interp0 = ((double)Split - 0.25 + FrameInterp) / NumSplitsPer180;
			double Interp1 = ((double)Split + 0.25 + FrameInterp) / NumSplitsPer180;

			double Angle0 = 2 * PI * Interp0;
			double Angle1 = 2 * PI * Interp1;

			Angle0 = max(0, min(PI, Angle0));
			Angle1 = max(0, min(PI, Angle1));

			double S0 = cos(Angle0) * 12.0 + 12.0;
			double S1 = cos(Angle1) * 12.0 + 12.0;

			S0 = max(0, min(S0, 24.0));
			S1 = max(0, min(S1, 24.0));

			unsigned char cS0 = S1 > S0 ? (unsigned char)round(S0) : (unsigned char)round(S1);
			unsigned char cS1 = S1 > S0 ? (unsigned char)round(S1) : (unsigned char)round(S0);

			for (int i = cS0; i < cS1; i++)
			{
				int OutByte = i / 8;
				unsigned char OutBlit = 0x40 >> ((i % 8) & 0xfe);

				OutSpriteLine[OutByte] |= OutBlit;
			}
		}
		for (int y = 0; y < 21; y++)
		{
			OutSpriteData[Frame][y * 3 + 0] = OutSpriteLine[0];
			OutSpriteData[Frame][y * 3 + 1] = OutSpriteLine[1];
			OutSpriteData[Frame][y * 3 + 2] = OutSpriteLine[2];
		}
	}
	WriteBinaryFile(OutBarSpritesBINFilename, OutSpriteData, sizeof(OutSpriteData));

	static const int SinTableLength = 200;
	unsigned char cSinTable[2][256];

	unsigned int SinTable[256];
	for (int i = 0; i < SinTableLength; i++)
	{
		double Angle = ((double)i * 2.0 * PI) / SinTableLength;

		double SinVal = sin(Angle) * 138.5 + 139.0 + 32.0;

		SinVal = max(0, min(SinVal, 312.0));

		unsigned int sin = (unsigned int)floor(SinVal + 0.5);

		SinTable[i] = sin;
		if ((i + SinTableLength) < 256)
		{
			SinTable[i + SinTableLength] = sin;
		}
	}

	for (int i = 0; i < SinTableLength; i++)
	{
		cSinTable[0][i] = SinTable[i] % 256;

		unsigned char XMSB = 0;
		for (int s = 0; s < 4; s++)
		{
			XMSB += (SinTable[i + (s * 9)] / 256) << (4 + s);
		}
		cSinTable[1][i] = XMSB;

		if ((i + SinTableLength) < 256)
		{
			cSinTable[0][i + SinTableLength] = cSinTable[0][i];
			cSinTable[1][i + SinTableLength] = cSinTable[1][i];
		}
	}

	WriteBinaryFile(OutBarSintabBINFilename, cSinTable, sizeof(cSinTable));
}

int NoBounds_Main()
{
	NoBounds_CreateBitmapBinariesUsingSPOT("Parts\\NoBounds\\Data\\NoBounds");
	
	NoBounds_CreateFirstScreenBitmap("Parts\\NoBounds\\Data\\NoBounds.png", L"Parts\\NoBounds\\Data\\NoBounds.map", L"Parts\\NoBounds\\Data\\NoBounds.scr", L"Parts\\NoBounds\\Data\\NoBounds.col", L"Link\\NoBounds\\NoBounds.map", L"Link\\NoBounds\\NoBounds.scr", L"Link\\NoBounds\\NoBounds.col");
	
	//NoBounds_ProcessBitmap("Parts\\NoBounds\\Data\\NoBounds.png", L"Link\\NoBounds\\NoBounds.map", L"Link\\NoBounds\\NoBounds.scr", L"Link\\NoBounds\\NoBounds.col", L"Link\\NoBounds\\NoBoundsMAP.bin", L"Link\\NoBounds\\NoBoundsSCR.bin", L"Link\\NoBounds\\NoBoundsCOL.bin");

	NoBounds_GenerateRasterCode(L"Build\\6502\\NoBounds\\RasterCode.asm");

	NoBounds_GenerateLinkingSLS(L"Link\\NoBounds\\StreamData.sls", L"Link\\NoBounds\\StreamData.bin");

	NoBounds_GenerateFadeSprites(L"Link\\NoBounds\\FadeSprites.bin", "Build\\6502\\NoBounds\\FadeSprites.png");

	NoBounds_GenerateScaledRasters("Parts\\NoBounds\\Data\\NoBoundsRasters.png", 0, "Build\\6502\\NoBounds\\RotRastersLeft.png");
	NoBounds_GenerateScaledRasters("Parts\\NoBounds\\Data\\TrailblazerRasters.png", 1, "Build\\6502\\NoBounds\\RotRastersRight.png");

	NoBounds_CombineRasterImages("Build\\6502\\NoBounds\\RotRastersLeft.png", "Build\\6502\\NoBounds\\RotRastersRight.png", "Build\\6502\\NoBounds\\RotRastersCombined.png", 112, 242);

	FadeFromNoBounds_ProcessRasterColours("Build\\6502\\NoBounds\\RotRastersCombined.png", L"Link\\NoBounds\\StartRasters.bin", L"Build\\6502\\NoBounds\\FadeFromNoBounds_RasterUpdateData.asm", L"Build\\6502\\NoBounds\\FadeFromNoBounds_RasterUpdateDefines.asm");

	NoBounds_GenerateBarSprites(L"Link\\NoBounds\\BarSpriteData.bin", L"Link\\NoBounds\\BarSpriteSinTables.bin");

	return 0;
}
