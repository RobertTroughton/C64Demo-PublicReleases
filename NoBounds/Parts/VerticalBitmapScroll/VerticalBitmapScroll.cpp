//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h" 
#include "..\Common\SinTables.h" 

static const bool bUsePairedChunks = false;

static const int NumBuffersPerChunkLoad = bUsePairedChunks ? 2 : 1;

static const int ImageWidth = 320;
static const int ImageHeight = 1024;

static const int ImageCharWidth = ImageWidth / 8;
static const int ImageCharHeight = ImageHeight / 8;

static const int StreamingImageHeight = ImageHeight;
static const int StreamingImageCharHeight = StreamingImageHeight / 8;
static const int ImageChunkHeight = 32;
static const int ImageChunkCharHeight = ImageChunkHeight / 8;
static const int NumStreamingChunks = StreamingImageHeight / ImageChunkHeight;

static const int sizeMAPLine = 40 * 8;
static const int sizeSCRLine = 40;
static const int sizeCOLLine = 40 / 2;
static const int sizeDataLine = sizeMAPLine + sizeSCRLine + sizeCOLLine;
static const int sizeChunkData = sizeDataLine * ImageChunkCharHeight;
static const int sizeStreamData = NumStreamingChunks * sizeChunkData;

static const int NumLoadBuffers = 4;
static const int LoadAddresses[NumLoadBuffers] = { 0x5600, 0x5000, 0x4a00, 0x4400 };

static const int NumDBuffers = 2;

bool compareFiles(const string p1, const string p2) {

	std::ifstream f1(p1, std::ifstream::binary | std::ifstream::ate);
	std::ifstream f2(p2, std::ifstream::binary | std::ifstream::ate);

	if (f1.fail() || f2.fail()) {
		return false; //file problem
	}

	if (f1.tellg() != f2.tellg()) {
		return false; //size mismatch
	}

	//seek back to beginning and use std::equal to compare contents
	f1.seekg(0, std::ifstream::beg);
	f2.seekg(0, std::ifstream::beg);
	return std::equal(std::istreambuf_iterator<char>(f1.rdbuf()),
		std::istreambuf_iterator<char>(),
		std::istreambuf_iterator<char>(f2.rdbuf()));
}

void VBS_CreateBitmapBinariesUsingSPOT(string BitmapPNGFileName)
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

void VBS_ProcessBitmap(LPTSTR InImageMAPFilename, LPTSTR InImageSCRFilename, LPTSTR InImageCOLFilename, LPTSTR OutStreamingBINFilename, LPTSTR OutStreamDataSLSFilename)
{
	int sizeBitmapMAPData = ImageCharWidth * ImageCharHeight * 8;
	int sizeBitmapSCRData = ImageCharWidth * ImageCharHeight;
	int sizeBitmapCOLData = ImageCharWidth * ImageCharHeight;
	int sizeBitmapPackedCOLData = sizeBitmapCOLData / 2;

	unsigned char* BitmapMAPData = new unsigned char[sizeBitmapMAPData];
	unsigned char* BitmapSCRData = new unsigned char[sizeBitmapSCRData];
	unsigned char* BitmapCOLData = new unsigned char[sizeBitmapCOLData];
	unsigned char* BitmapPackedCOLData = new unsigned char[sizeBitmapPackedCOLData];

	ReadBinaryFile(InImageMAPFilename, BitmapMAPData, sizeBitmapMAPData);
	ReadBinaryFile(InImageSCRFilename, BitmapSCRData, sizeBitmapSCRData);
	ReadBinaryFile(InImageCOLFilename, BitmapCOLData, sizeBitmapCOLData);

	for (int i = 0; i < sizeBitmapPackedCOLData; i++)
	{
		BitmapPackedCOLData[i] = (BitmapCOLData[i * 2 + 0] << 0) | (BitmapCOLData[i * 2 + 1] << 4);
	}

	unsigned char* StreamData = new unsigned char[sizeStreamData];
	ZeroMemory(StreamData, sizeStreamData);

	CodeGen codeSLS(OutStreamDataSLSFilename);

	int LastChunk = -1;

	for (int ChunkIndex = 0; ChunkIndex < NumStreamingChunks / NumBuffersPerChunkLoad; ChunkIndex++)
	{
		codeSLS.OutputCommentLine(fmt::format("#Chunk {:d}", ChunkIndex));

	/*	if (LastChunk != -1)
		{
			for (int i = 0; i < NumBuffersPerChunkLoad; i++)
			{
				int ThisChunkIndex = LastChunk * NumBuffersPerChunkLoad + i;
				int LastLoadAddress = LoadAddresses[ThisChunkIndex % NumLoadBuffers];
				int LastChunkOffset = ThisChunkIndex * sizeChunkData;
				codeSLS.OutputCommentLine(fmt::format("Mem:\t\t..\\..\\Link\\VerticalBitmapScroll\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LastLoadAddress, LastChunkOffset, sizeChunkData));
			}
		}
*/
		for (int i = 4 - NumBuffersPerChunkLoad; i >= 1 ; i--)
		{
			int MemChunkIndex = ChunkIndex * NumBuffersPerChunkLoad - i;
			if (MemChunkIndex >= 0)
			{
				int LastLoadAddress = LoadAddresses[MemChunkIndex % NumLoadBuffers];
				int LastChunkOffset = MemChunkIndex * sizeChunkData;
				codeSLS.OutputCommentLine(fmt::format("Mem:\t\t..\\..\\Link\\VerticalBitmapScroll\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LastLoadAddress, LastChunkOffset, sizeChunkData));
			}
		}

		for (int i = 0; i < NumBuffersPerChunkLoad; i++)
		{
			int ThisChunkIndex = ChunkIndex * NumBuffersPerChunkLoad + i;
			int LoadAddress = LoadAddresses[ThisChunkIndex % NumLoadBuffers];
			int OutChunkOffset = ThisChunkIndex * sizeChunkData;
			codeSLS.OutputCommentLine(fmt::format("File:\t\t..\\..\\Link\\VerticalBitmapScroll\\StreamData.bin\t\t\t\t\t\t{:04x}\t{:05x}\t{:04x}", LoadAddress, OutChunkOffset, sizeChunkData));
		}

		codeSLS.OutputBlankLine();
		LastChunk = ChunkIndex;
	}

	for (int ChunkIndex = 0; ChunkIndex < NumStreamingChunks; ChunkIndex++)
	{
		int OutChunkOffset = ChunkIndex * sizeChunkData;

		int OutChunkOffset_MAPData = OutChunkOffset + 0;
		int OutChunkOffset_SCRData = OutChunkOffset_MAPData + (sizeMAPLine * ImageChunkCharHeight);
		int OutChunkOffset_COLData = OutChunkOffset_SCRData + (sizeSCRLine * ImageChunkCharHeight);

		for (int YChar = 0; YChar < ImageChunkCharHeight; YChar++)
		{
			int InvYChar = (ImageChunkCharHeight - 1) - YChar;

			int InOffsetMAPData = ((ChunkIndex * ImageChunkCharHeight) + YChar) * sizeMAPLine;
			int OutOffsetMAPData = OutChunkOffset_MAPData + (InvYChar * sizeMAPLine);
			memcpy(&StreamData[OutOffsetMAPData], &BitmapMAPData[InOffsetMAPData], sizeMAPLine);

			int InOffsetSCRData = ((ChunkIndex * ImageChunkCharHeight) + YChar) * sizeSCRLine;
			int OutOffsetSCRData = OutChunkOffset_SCRData + (InvYChar * sizeSCRLine);
			memcpy(&StreamData[OutOffsetSCRData], &BitmapSCRData[InOffsetSCRData], sizeSCRLine);

			int InOffsetCOLData = ((ChunkIndex * ImageChunkCharHeight) + YChar) * sizeCOLLine;
			int OutOffsetCOLData = OutChunkOffset_COLData + (InvYChar * sizeCOLLine);
			memcpy(&StreamData[OutOffsetCOLData], &BitmapPackedCOLData[InOffsetCOLData], sizeCOLLine);
		}
	}

	WriteBinaryFile(OutStreamingBINFilename, StreamData, sizeStreamData);

	delete[] StreamData;

	delete[] BitmapMAPData;
	delete[] BitmapSCRData;
	delete[] BitmapCOLData;
	delete[] BitmapPackedCOLData;
}

void VBS_GenerateUpdateCode(LPTSTR OutUpdateCodeASMFilename)
{
	CodeGen UpdateCode(OutUpdateCodeASMFilename);

	UpdateCode.OutputFunctionLine(fmt::format("ADDR_BitmapUpdate_JumpPtrs_Lo"));
	for (int line = 0; line < 16; line++)
	{
		UpdateCode.OutputCodeLine(NONE, fmt::format(".byte <(BitmapUpdate_Line{:d} - 1)", line));
	}
	UpdateCode.OutputFunctionLine(fmt::format("ADDR_BitmapUpdate_JumpPtrs_Hi"));
	for (int line = 0; line < 16; line++)
	{
		UpdateCode.OutputCodeLine(NONE, fmt::format(".byte >(BitmapUpdate_Line{:d} - 1)", line));
	}
	UpdateCode.OutputBlankLine();
	UpdateCode.OutputBlankLine();

	UpdateCode.OutputFunctionLine(fmt::format("BitmapUpdate"));
	UpdateCode.OutputCodeLine(LDA_ABY, fmt::format("ADDR_BitmapUpdate_JumpPtrs_Hi"));
	UpdateCode.OutputCodeLine(PHA);
	UpdateCode.OutputCodeLine(LDA_ABY, fmt::format("ADDR_BitmapUpdate_JumpPtrs_Lo"));
	UpdateCode.OutputCodeLine(PHA);
	UpdateCode.OutputCodeLine(RTS);
	UpdateCode.OutputBlankLine();
	UpdateCode.OutputBlankLine();

	for (int line = 0; line < 16; line++)
	{
		int InBuffer = line / ImageChunkCharHeight;
		int ScreenLine = line % ImageChunkCharHeight;
		int InvScreenLine = (ImageChunkCharHeight - 1) - ScreenLine;

		int OutBuffer0 = (line % (ImageChunkCharHeight * NumDBuffers)) / ImageChunkCharHeight;
		int OutBuffer1 = (OutBuffer0 + 1) % NumDBuffers;

		UpdateCode.OutputFunctionLine(fmt::format("BitmapUpdate_Line{:d}", line));
		UpdateCode.OutputBlankLine();

	//; update MAP data
		UpdateCode.OutputCodeLine(LDY_IMM, fmt::format("#63"));
		UpdateCode.OutputFunctionLine(fmt::format("!LoopMAP"));
		for (int column = 0; column < 5; column++)
		{
			int InMAPDataOffset = (InvScreenLine * 320) + (column * 64);
			int OutDataOffset0 = (((ScreenLine + 25) * 320) + (column * 64)) % 8192;
			int OutDataOffset1 = (((ScreenLine + 21) * 320) + (column * 64)) % 8192;

			UpdateCode.OutputCodeLine(LDA_ABY, fmt::format("ADDR_StreamData{:d} + ${:04x} + ${:04x}", InBuffer, 0, InMAPDataOffset));
			UpdateCode.OutputCodeLine(STA_ABY, fmt::format("BitmapAddress{:d} + ${:04x}", OutBuffer0, OutDataOffset0));
			UpdateCode.OutputCodeLine(STA_ABY, fmt::format("BitmapAddress{:d} + ${:04x}", OutBuffer1, OutDataOffset1));
		}
		UpdateCode.OutputCodeLine(DEY);
		UpdateCode.OutputCodeLine(BPL, fmt::format("!LoopMAP-"));
		UpdateCode.OutputBlankLine();

		//; update SCR data
		UpdateCode.OutputCodeLine(LDY_IMM, fmt::format("#07"));
		UpdateCode.OutputFunctionLine(fmt::format("!LoopSCR"));
		for (int column = 0; column < 5; column++)
		{
			int InSCRDataOffset = (InvScreenLine * 40) + (column * 8);
			int OutDataOffset0 = (((ScreenLine + 25) * 40) + (column * 8)) % 1024;
			int OutDataOffset1 = (((ScreenLine + 21) * 40) + (column * 8)) % 1024;

			UpdateCode.OutputCodeLine(LDA_ABY, fmt::format("ADDR_StreamData{:d} + ${:04x} + ${:04x}", InBuffer, ImageChunkCharHeight * 320, InSCRDataOffset));
			if (OutDataOffset0 != 0x3f8)
			{
				UpdateCode.OutputCodeLine(STA_ABY, fmt::format("ScreenAddress{:d} + ${:04x}", OutBuffer0, OutDataOffset0));
			}
			else
			{
				UpdateCode.OutputCodeLine(STA_ABY, fmt::format("SpriteIndicesRestoreBuffer{:d}", OutBuffer0));
			}
			UpdateCode.OutputCodeLine(STA_ABY, fmt::format("ScreenAddress{:d} + ${:04x}", OutBuffer1, OutDataOffset1));
		}
		UpdateCode.OutputCodeLine(DEY);
		UpdateCode.OutputCodeLine(BPL, fmt::format("!LoopSCR-"));
		UpdateCode.OutputBlankLine();

		//; update COL data
		UpdateCode.OutputFunctionLine(fmt::format("!ColoursUpdate"));
		for (int column = 0; column < 20; column++)
		{
			int InCOLDataOffset = (InvScreenLine * 20) + column;
			int OutDataOffset = (((ScreenLine + 25) * 40) + column * 2) % 1024;

			UpdateCode.OutputCodeLine(LAX_ABS, fmt::format("ADDR_StreamData{:d} + ${:04x} + ${:04x}", InBuffer, ImageChunkCharHeight * (320 + 40), InCOLDataOffset));
			UpdateCode.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ${:04x}", OutDataOffset + 0));
//;			UpdateCode.OutputCodeLine(STA_ABS, fmt::format("ColourMemoryRestoreBuffer + ${:04x}", (ScreenLine * 40) + (column * 2) + 0));
			UpdateCode.OutputCodeLine(LDA_ABX, fmt::format("ADDR_HighNibbleToLowNibbleTable"));
			UpdateCode.OutputCodeLine(STA_ABS, fmt::format("VIC_ColourMemory + ${:04x}", OutDataOffset + 1));
//;			UpdateCode.OutputCodeLine(STA_ABS, fmt::format("ColourMemoryRestoreBuffer + ${:04x}", (ScreenLine * 40) + (column * 2) + 1));
		}
		UpdateCode.OutputBlankLine();

		UpdateCode.OutputCodeLine(RTS);
		UpdateCode.OutputBlankLine();
		UpdateCode.OutputBlankLine();
	}
}

void VBS_OutputChunkLoadDefineSYM(LPTSTR OutChunkLoadDefineSYMFilename)
{
	CodeGen ChunkLoadDefineCode(OutChunkLoadDefineSYMFilename);

	ChunkLoadDefineCode.OutputCodeLine(NONE, fmt::format(".var NumBuffersPerChunkLoad = {:d}", NumBuffersPerChunkLoad));
	ChunkLoadDefineCode.OutputBlankLine();
}

void VBS_ConvertCreditSprites(char* InCreditSpritesPNGFilename, LPTSTR OutCreditSpritesMAPFilename)
{
	GPIMAGE InImage(InCreditSpritesPNGFilename);

	int InHeight = InImage.Height;
	int NumSpriteRows = InHeight / 23;

	int SizeOutSprites = NumSpriteRows * 8 * 64;
	unsigned char* OutSprites = new unsigned char[SizeOutSprites];
	ZeroMemory(OutSprites, SizeOutSprites);

	for (int row = 0; row < NumSpriteRows; row++)
	{
		for (int y = 0; y < 21; y++)
		{
			for (int x = 0; x < 192; x++)
			{
				unsigned char Col = InImage.GetPixelPaletteColour(x, row * 23 + y);
				if (Col != 0)
				{
					int SpriteIndex = (row * 8) + (x / 24);
					int ByteOffset = (y * 3) + ((x % 24) / 8);
					int BitShift = 7 - (x & 7);
					OutSprites[SpriteIndex * 64 + ByteOffset] |= 1 << BitShift;
				}
			}
		}
	}
	WriteBinaryFile(OutCreditSpritesMAPFilename, OutSprites, SizeOutSprites);
}


void VBS_GenerateCreditsRandomisedLinesCode(LPTSTR OutCreditsRandomisedLinesASMFilename)
{
	CodeGen OutCredits(OutCreditsRandomisedLinesASMFilename);

	unsigned int LineDone = 0;
	unsigned char Line[21];

	for (int i = 0; i < 21; i++)
	{
		bool bFound = false;
		int randval = -1;
		while (!bFound)
		{
			randval = rand() % 21;
			unsigned int BitMask = (1 << randval);
			if ((LineDone & BitMask) == 0)
			{
				LineDone += BitMask;
				bFound = true;
			}
		}
		Line[i] = randval * 3;
	}

	OutCredits.OutputByteBlock(Line, 21, 21);
}


int VBS_Main()
{
	VBS_CreateBitmapBinariesUsingSPOT("Parts\\VerticalBitmapScroll\\Data\\Image");

	MoveFileA("Parts\\VerticalBitmapScroll\\Data\\Image.map", "Build\\6502\\VerticalBitmapScroll\\Image.map");
	MoveFileA("Parts\\VerticalBitmapScroll\\Data\\Image.scr", "Build\\6502\\VerticalBitmapScroll\\Image.scr");
	MoveFileA("Parts\\VerticalBitmapScroll\\Data\\Image.col", "Build\\6502\\VerticalBitmapScroll\\Image.col");
	DeleteFileA("Parts\\VerticalBitmapScroll\\Data\\Image.map");
	DeleteFileA("Parts\\VerticalBitmapScroll\\Data\\Image.scr");
	DeleteFileA("Parts\\VerticalBitmapScroll\\Data\\Image.col");

	VBS_ProcessBitmap(
		L"Build\\6502\\VerticalBitmapScroll\\Image.map",
		L"Build\\6502\\VerticalBitmapScroll\\Image.scr",
		L"Build\\6502\\VerticalBitmapScroll\\Image.col",

		L"Link\\VerticalBitmapScroll\\StreamData.bin",

		L"Link\\VerticalBitmapScroll\\StreamData.sls"
	);

	VBS_GenerateUpdateCode(L"Build\\6502\\VerticalBitmapScroll\\UpdateCode.asm");

	VBS_OutputChunkLoadDefineSYM(L"Build\\6502\\VerticalBitmapScroll\\VerticalBitmapScroll-ChunkLoadDefine.sym");

	VBS_ConvertCreditSprites("Parts\\VerticalBitmapScroll\\Data\\Redcrab-Credits.png", L"Link\\VerticalBitmapScroll\\Redcrab-Credits.map");

	VBS_GenerateCreditsRandomisedLinesCode(L"Build\\6502\\VerticalBitmapScroll\\CreditsRandomisedLines.asm");


	return 0;
}
