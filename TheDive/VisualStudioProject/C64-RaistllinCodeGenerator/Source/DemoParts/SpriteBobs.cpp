//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"
#include "..\Common\CodeGen.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define ADDITIONALYVALUE 0

#define OUTPUT_SPRITELOCATION_DEBUGINFO 1

#define SB_FONT_WIDTH 5
#define SB_FONT_HEIGHT 5
#define SB_FONT_NUM_CHARS 32 //; Font5x5.bin

#define SB_SCROLLER_SHOULD_REPEATFOREVER 0

#define SB_NUM_TOTAL_CHARS 212
#define SB_NUM_FRAMES 2

#define SB_MAX_NUM_SECTIONS 16

#define SB_SPRITE_MEMORYSIZE 64
#define SB_SPRITE_MEMORY_DATASIZE 63
#define SB_SPRITE_BYTESTRIDE 3 //; All c64 sprites are 24 pixels wide ... so the "stride" is 3 bytes

#define SB_MAX_NUM_SPRITES 48
#define SB_MAX_NUM_CHARS_PER_SPRITE 32

#define SIZE_SINTABLE (SB_NUM_TOTAL_CHARS * SB_NUM_FRAMES)

#define SB_MULTPLEXOR_NEEDED_BLANK_LINES 3	//; how many raster lines we need to setup our sprites...

int SB_CharIndexToSpriteIndex[SB_NUM_TOTAL_CHARS];
struct
{
	int NumChars;
	int MinX;
	int MaxX;
	int MinY;
	int MaxY;
} SB_SpriteSetupData[SB_NUM_FRAMES][SB_MAX_NUM_SPRITES];
int SB_SpriteSetupDataNum[SB_NUM_FRAMES];

int SB_SinTableX[SIZE_SINTABLE];
int SB_SinTableY[SIZE_SINTABLE];

char SB_XYIndexes[2] = { 'x', 'y' };

#define SB_NUM_CHAR_COMBINATIONS (SB_MAX_NUM_CHARS_PER_SPRITE * 2 - 1)
struct
{
	int Index0;
	int Index1;
} SB_CharCombinations[SB_NUM_CHAR_COMBINATIONS];

int SB_SortedSpriteIndices[SB_NUM_FRAMES][SB_MAX_NUM_SPRITES];

static unsigned char SB_ScrollTextStr[] = {
	"   "
	"H e r e   i s   a   n e w   w o r l d   r e c o r d !   "
	"A    T w o    h u n d r e d    a n d    t w e l v e    b o b    c i r c l e - s c r o l l !     "
	"G o o d   l u c k   r e a d i n g   i t !      "
	"The problem with having so many bobs is that it becomes very difficult to read ... "
	"But... I had to do this. I challenged Burnzai to beat our record in X Marks the Spot... "
	"already knowing that I could beat it myself."
	"                                                                                                          "
	"                                                                                                          "
};
static int SB_ScrollTextStrSize = sizeof(SB_ScrollTextStr) / sizeof(SB_ScrollTextStr[0]);

void SpriteBobs_OutputScrollText(LPCTSTR OutputFilename)
{
	int WriteSize = 0;
	for (int Index = 0; Index < SB_ScrollTextStrSize - 1; Index++)
	{
		unsigned char ByteValue = SB_ScrollTextStr[Index];
		if (ByteValue < 0xe0)
		{
			switch (ByteValue)
			{
				case '.':
				ByteValue = 27;
				break;

				case '!':
				ByteValue = 28;
				break;

				case '-':
				ByteValue = 29;
				break;

				default:
				ByteValue &= 31;
				break;
			}
		}

		SB_ScrollTextStr[WriteSize++] = ByteValue;
	}
	SB_ScrollTextStr[WriteSize++] = 0xFF;
	WriteBinaryFile(OutputFilename, SB_ScrollTextStr, WriteSize);
}

void SpriteBobs_BMPSpacedFontToPreShifted(LPCTSTR FontFilename, LPCTSTR OutputASMFilename, int CharWidth, int CharHeight, int NumChars, int CharStride)
{
	CodeGen code(OutputASMFilename);

	int BMPHeader = 0x3e;

	int TotalCycles = 0;
	int TotalSize = 0;

	ReadBinaryFile(FontFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	code.OutputCodeLine(NONE, fmt::format(".align $40"));
	code.OutputBlankLine();

	for (int ShiftRight = 0; ShiftRight < 8; ShiftRight++)
	{
		for (int YPos = 0; YPos < CharHeight; YPos++)
		{
			int BitsToOutput = 8;
			int XStart = 0;
			int XLoops = 1;
			if (ShiftRight >(8 - CharWidth))
			{
				XLoops = 2;
			}

			for (int XLoop = 0; XLoop < XLoops; XLoop++)
			{
				code.OutputFunctionLine(fmt::format("Font5x5_Shift{:d}_Y{:d}_Loop{:d}", ShiftRight, YPos, XLoop));

				for (int Character = 0; Character < NumChars; Character++)
				{
					unsigned char Byte = 0;
					for (int SubX = 0; SubX < 8; SubX++)
					{
						int XPos = XStart + SubX;
						if (XPos >= ShiftRight)
						{
							int OutputBit = 0;
							if ((XPos < (ShiftRight + CharWidth)) && (XPos >= ShiftRight))
							{
								int ReadXPos = Character * CharStride + XPos - ShiftRight;
								int ReadOffset = 0;

								ReadOffset += BMPHeader;
								ReadOffset += (CharHeight - 1 - YPos) * ((CharStride * NumChars) / 8);
								ReadOffset += ReadXPos / 8;

								unsigned char ReadByte = FileReadBuffer[ReadOffset];
								int bitShift = 7 - (ReadXPos % 8);
								OutputBit = ((ReadByte & (1 << bitShift)) != 0) ? 0 : 1;
							}
							Byte |= (OutputBit << (7 - SubX));
						}
					}
					code.OutputCodeLine(NONE, fmt::format(".byte %{:08b} //; Char '{:02x}', Y '{:d}, Shift '{:d}'", Byte, Character, YPos, ShiftRight));
				}
				code.OutputBlankLine();
				XStart += 8;
			}
		}
		code.OutputBlankLine();
	}
}

void SpriteBobs_OutputScrollTextUpdateCode(LPCTSTR Filename)
{
	CodeGen code(Filename);

	code.OutputFunctionLine(fmt::format("AdvanceCircleText"));

	for (int CopyIndex = 0; CopyIndex < SB_NUM_TOTAL_CHARS - 1; CopyIndex++)
	{
		code.OutputCodeLine(LDA_ZP, fmt::format("ZP_ScrollText + ${:02x}", CopyIndex + 1));
		code.OutputCodeLine(STA_ZP, fmt::format("ZP_ScrollText + ${:02x}", CopyIndex));
	}

	code.OutputFunctionLine(fmt::format("ACT_ScrollTextReadPtr"));

	code.OutputCodeLine(LDA_ABS, fmt::format("ScrollText"));
	code.OutputCodeLine(BPL, fmt::format("DontResetScrollTextPtr"));

	code.OutputCodeLine(LDA_ABS, fmt::format("#<ScrollText"));
	code.OutputCodeLine(STA_ABS, fmt::format("ACT_ScrollTextReadPtr + 1"));
	code.OutputCodeLine(LDA_ABS, fmt::format("#>ScrollText"));
	code.OutputCodeLine(STA_ABS, fmt::format("ACT_ScrollTextReadPtr + 2"));
	code.OutputCodeLine(INC_ABS, fmt::format("Signal_CustomSignal0"));
		
	code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));

	code.OutputFunctionLine(fmt::format("DontResetScrollTextPtr"));
	
	code.OutputCodeLine(STA_ZP, fmt::format("ZP_ScrollText + ${:02x}", SB_NUM_TOTAL_CHARS - 1));

	code.OutputCodeLine(INC_ABS, fmt::format("ACT_ScrollTextReadPtr + 1"));
	code.OutputCodeLine(BNE, fmt::format("ACT_Return"));
	code.OutputCodeLine(INC_ABS, fmt::format("ACT_ScrollTextReadPtr + 2"));

	code.OutputFunctionLine(fmt::format("ACT_Return"));
	code.OutputCodeLine(RTS);

	code.OutputBlankLine();
}

void SpriteBobs_SetupCharCombinations(void)
{
	//; Setup the "char combinations" structure defining intersections of chars that we allow...
	int Index0 = 0;
	int Index1 = -1;
	for (int CombinationIndex = 0; CombinationIndex < SB_NUM_CHAR_COMBINATIONS; CombinationIndex++)
	{
		SB_CharCombinations[CombinationIndex].Index0 = Index0;
		SB_CharCombinations[CombinationIndex].Index1 = Index1;

		if (Index1 == -1)
		{
			Index1 = Index0 + 1;
		}
		else
		{
			Index0 = Index1;
			Index1 = -1;
		}
	}
}

void SpriteBobs_OutputSpriteCode(LPCTSTR Filename, int FrameIndex)
{
	CodeGen code(Filename);

	int CollisionTable[SB_SPRITE_MEMORYSIZE];
	int CollisionTablePassCount[SB_SPRITE_MEMORYSIZE];

	code.OutputFunctionLine(fmt::format("DrawSprites_Frame{:d}", FrameIndex));

	code.OutputBlankLine();

	int CurrentCharIndex = 0;

	for (int SpriteIndex = 0; SpriteIndex < SB_SpriteSetupDataNum[FrameIndex]; SpriteIndex++)
	{
		int BestPass = 0;
		int BestCycles = INT_MAX;
		int CurrentPass = 0;

		bool bFinalPass = false;
		bool bFinished = false;

		int CurrentCycles, CurrentBytes;
		code.QueryCounters(CurrentCycles, CurrentBytes);

		do
		{
			code.SetCounters(CurrentCycles, CurrentBytes);

			bool bThisPassFailed = false;
			ZeroMemory(CollisionTable, sizeof(CollisionTable));
			ZeroMemory(CollisionTablePassCount, sizeof(CollisionTablePassCount));

			code.OutputCommentLine(fmt::format("//; Sprite ${:02x}", SpriteIndex), bFinalPass);

			int SpriteWriteOffset = SpriteIndex * SB_SPRITE_MEMORYSIZE;

			int SinPositionX[SB_MAX_NUM_CHARS_PER_SPRITE];
			int SinPositionY[SB_MAX_NUM_CHARS_PER_SPRITE];
			int XShift[SB_MAX_NUM_CHARS_PER_SPRITE];
			int XPos[SB_MAX_NUM_CHARS_PER_SPRITE];

			int MinSinPositionX = SB_SpriteSetupData[FrameIndex][SpriteIndex].MinX;
			int MinSinPositionY = SB_SpriteSetupData[FrameIndex][SpriteIndex].MinY;
			for (int SpriteCharIndex = 0; SpriteCharIndex < SB_SpriteSetupData[FrameIndex][SpriteIndex].NumChars; SpriteCharIndex++)
			{
				int CharIndex = CurrentCharIndex + SpriteCharIndex;

				int ThisXPos = SB_SinTableX[CharIndex * SB_NUM_FRAMES + FrameIndex] - MinSinPositionX;
				int ShiftedXPos = ThisXPos + CurrentPass;
				if (ShiftedXPos > (24 - SB_FONT_WIDTH))
				{
					bThisPassFailed = true;
				}
				int ThisYPos = SB_SinTableY[CharIndex * SB_NUM_FRAMES + FrameIndex] - MinSinPositionY;
				if (ThisXPos < 0)
				{
					ThisXPos = 0;
				}

				SinPositionX[SpriteCharIndex] = ThisXPos;
				SinPositionY[SpriteCharIndex] = ThisYPos;
				XShift[SpriteCharIndex] = ShiftedXPos % 8;
				XPos[SpriteCharIndex] = ShiftedXPos / 8;
			}

			if (bFinalPass)
			{
				SB_SpriteSetupData[FrameIndex][SpriteIndex].MinX -= CurrentPass;
			}

			//; Pass 1: Generate "Collision" Data
			for (int SpriteCharIndex = 0; SpriteCharIndex < SB_SpriteSetupData[FrameIndex][SpriteIndex].NumChars; SpriteCharIndex++)
			{
				int WriteYStart = 0;
				int WriteHeight = SB_FONT_HEIGHT;

				int CharIndex = CurrentCharIndex + SpriteCharIndex;

				//; Deal with the start/end of the scroller in a nice way...
				if(CharIndex == 50)
				{
					//; linear interpolation of [SB_FONT_HEIGHT, 0] for a frame index of [-1, SB_NUM_FRAMES]
					WriteHeight = SB_FONT_HEIGHT - (((FrameIndex + 1) * SB_FONT_HEIGHT) / (SB_NUM_FRAMES + 1));
				}
				if (CharIndex == 51)
				{
					WriteYStart = SB_FONT_HEIGHT - (((FrameIndex + 1) * SB_FONT_HEIGHT) / (SB_NUM_FRAMES + 1));
					WriteHeight = SB_FONT_HEIGHT - WriteYStart;
				}

				for (int SpriteYPos = WriteYStart; SpriteYPos < (WriteYStart + WriteHeight); SpriteYPos++)
				{
					int WriteOffset = ((SpriteYPos + SinPositionY[SpriteCharIndex]) * SB_SPRITE_BYTESTRIDE) + XPos[SpriteCharIndex];
					CollisionTable[WriteOffset] |= (1 << (SpriteCharIndex * 2));
					if (XShift[SpriteCharIndex] > (8 - SB_FONT_WIDTH))
					{
						CollisionTable[WriteOffset + 1] |= (2 << (SpriteCharIndex * 2));
					}
				}
			}

			//; Pass 2: Output Assembly
			char bWasLoaded[SB_MAX_NUM_CHARS_PER_SPRITE];
			ZeroMemory(bWasLoaded, sizeof(bWasLoaded));
			for (int CharCombinationIndex = 0; CharCombinationIndex < SB_NUM_CHAR_COMBINATIONS; CharCombinationIndex++)
			{
				int Index0 = SB_CharCombinations[CharCombinationIndex].Index0;
				int Index1 = Index0 + 1;
				bool bOring = (SB_CharCombinations[CharCombinationIndex].Index1 != -1);

				if ((Index0 >= SB_SpriteSetupData[FrameIndex][SpriteIndex].NumChars) || (bOring && (Index1 >= SB_SpriteSetupData[FrameIndex][SpriteIndex].NumChars)))
				{
					break;
				}

				int CollMask_Match0 = 0x03 << (Index0 * 2);
				int CollMask_Match1 = 0x03 << (Index1 * 2);
				int CollMask_Match_Combined = CollMask_Match0 | CollMask_Match1;

				int CharIndex0 = CurrentCharIndex + Index0;
				int CharIndex1 = CurrentCharIndex + Index1;

				int XOrYIndex0 = Index0 % 2;
				int XOrYIndex1 = Index1 % 2;

				if (!bWasLoaded[Index0])
				{
					int ScrollTextIndex = ((CharIndex0 + (SB_NUM_TOTAL_CHARS - 51)) % SB_NUM_TOTAL_CHARS);
					code.OutputCodeLine(XOrYIndex0 ? LDX_ZP : LDY_ZP, fmt::format("ZP_ScrollText + ${:02x}", ScrollTextIndex), bFinalPass);
					bWasLoaded[Index0] = 1;
				}
				if (bOring)
				{
					if (!bWasLoaded[Index1])
					{
						int ScrollTextIndex = ((CharIndex1 + (SB_NUM_TOTAL_CHARS - 51)) % SB_NUM_TOTAL_CHARS);
						code.OutputCodeLine(XOrYIndex1 ? LDX_ZP : LDY_ZP, fmt::format("ZP_ScrollText + ${:02x}", ScrollTextIndex), bFinalPass);
						bWasLoaded[Index1] = 1;
					}
				}

				for (int WriteOffsetWithinSprite = 0; WriteOffsetWithinSprite < SB_SPRITE_MEMORY_DATASIZE; WriteOffsetWithinSprite++)
				{
					int CollBits = CollisionTable[WriteOffsetWithinSprite];
					if (!(CollBits & CollMask_Match0))
					{
						continue;
					}
					if (bOring)
					{
						if (!(CollBits & CollMask_Match1))
						{
							continue;
						}
					}
					else
					{
						if ((CollBits & CollMask_Match1))
						{
							continue;
						}
					}
					int ReverseMask = (0xffffffff - CollMask_Match_Combined);

					//; check for 3+ char clash
					bool bMorePassesNeeded = false;
					if ((CollBits & ReverseMask) != 0)
					{
						bMorePassesNeeded = true;
					}
					int PassCountForThisByte = CollisionTablePassCount[WriteOffsetWithinSprite];
					CollisionTable[WriteOffsetWithinSprite] &= ReverseMask;
					CollisionTablePassCount[WriteOffsetWithinSprite]++;

					int CurrentYPos = WriteOffsetWithinSprite / SB_SPRITE_BYTESTRIDE;
					int ByteWriteOffset = SpriteWriteOffset + WriteOffsetWithinSprite;

					unsigned char Loop[SB_MAX_NUM_CHARS_PER_SPRITE];
					for (int iLoop = 0; iLoop < SB_MAX_NUM_CHARS_PER_SPRITE; iLoop++)
					{
						int Shift = iLoop * 2;
						int Mask = 0x03 << Shift;
						Loop[iLoop] = (((CollBits & Mask) >> Shift) == 0x01) ? 0 : 1;
					}

					int YOffset0 = CurrentYPos - SinPositionY[Index0];
					code.OutputCodeLine(XOrYIndex0 ? LDA_ABX : LDA_ABY, fmt::format("Font5x5_Shift{:d}_Y{:d}_Loop{:d}", XShift[Index0], YOffset0, Loop[Index0]), bFinalPass);
					if (PassCountForThisByte > 0)
					{
						code.OutputFunctionLine(fmt::format("SB_ExtraBlits_Frame{:d}_Offset{:d}", FrameIndex, ByteWriteOffset), bFinalPass);
						code.OutputCodeLine(ORA_IMM, fmt::format("#$ff"), bFinalPass);
					}
					if (bOring)
					{
						int YOffset1 = CurrentYPos - SinPositionY[Index1];
						code.OutputCodeLine(XOrYIndex1 ? ORA_ABX : ORA_ABY, fmt::format("Font5x5_Shift{:d}_Y{:d}_Loop{:d}", XShift[Index1], YOffset1, Loop[Index1]), bFinalPass);
					}
					if(bMorePassesNeeded)
					{
						code.OutputCodeLine(STA_ABS, fmt::format("SB_ExtraBlits_Frame{:d}_Offset{:d} + 1", FrameIndex, ByteWriteOffset), bFinalPass);
					}
					else
					{
						code.OutputCodeLine(STA_ABS, fmt::format("CircleSpriteWriteAddress{:d} + ${:04x}", FrameIndex, ByteWriteOffset), bFinalPass);
					}
				}
			}
			if (bFinalPass)
			{
				bFinished = true;
			}
			else
			{
				if (!bThisPassFailed)
				{
					int TotalCycles, TotalBytes;
					code.QueryCounters(TotalCycles, TotalBytes);
					if (TotalCycles < BestCycles)
					{
						BestPass = CurrentPass;
						BestCycles = TotalCycles;
					}
				}
				CurrentPass++;
				if (CurrentPass == 8)
				{
					CurrentPass = BestPass;
					bFinalPass = true;
				}
			}
		} while (!bFinished);

		CurrentCharIndex += SB_SpriteSetupData[FrameIndex][SpriteIndex].NumChars;
	}

	code.OutputCodeLine(RTS);
	code.OutputBlankLine();
}

void SpriteBobs_SortSpriteData(void)
{
	bool SpriteIndexAlreadySorted[SB_MAX_NUM_SPRITES];

	for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
	{
		ZeroMemory(SpriteIndexAlreadySorted, sizeof(SpriteIndexAlreadySorted));

		int NumSpritesSorted = 0;
		while (NumSpritesSorted < SB_SpriteSetupDataNum[FrameIndex])
		{
			int MinY = 999999;
			int BestSpriteIndex = -1;

			for (int SpriteIndex = 0; SpriteIndex < SB_SpriteSetupDataNum[FrameIndex]; SpriteIndex++)
			{
				if (SpriteIndexAlreadySorted[SpriteIndex])
				{
					continue;
				}
				if (SB_SpriteSetupData[FrameIndex][SpriteIndex].MinY < MinY)
				{
					MinY = SB_SpriteSetupData[FrameIndex][SpriteIndex].MinY;
					BestSpriteIndex = SpriteIndex;
				}
			}

			SB_SortedSpriteIndices[FrameIndex][NumSpritesSorted] = BestSpriteIndex;
			SpriteIndexAlreadySorted[BestSpriteIndex] = true;
			NumSpritesSorted++;
		}
	}
}

void SpriteBobs_OutputSpriteMultiplexCode(LPCTSTR Filename)
{
	CodeGen code(Filename);

	int StoredSpriteYPositions[8];
	int SafeRasterInterruptLine[SB_NUM_FRAMES][SB_MAX_NUM_SECTIONS];

	int NumSections[SB_NUM_FRAMES];
	ZeroMemory(NumSections, sizeof(NumSections));

	for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
	{
		int NumSpritesProcessed = 0;
		bool bFinished = false;

		int NumSpritesForThisSection = 8;	//; the first section should fill all 8 sprites of course...
		int SpriteOutputIndex = 0;

		int iSection = 0;

		while (NumSpritesForThisSection > 0)
		{
			bool bFirstStage = (iSection == 0);

			code.OutputFunctionLine(fmt::format("SpriteMultiplex_Frame{:d}_Section{:d}", FrameIndex, NumSections[FrameIndex]));

			code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));

			code.OutputCodeLine(TAX);
			code.OutputBlankLine();

			int MSBMask = 0;

			for (int SpriteIndex = 0; SpriteIndex < NumSpritesForThisSection; SpriteIndex++)
			{
				int SpriteDataIndex = SB_SortedSpriteIndices[FrameIndex][NumSpritesProcessed];

				int SpriteXPos = SB_SpriteSetupData[FrameIndex][SpriteDataIndex].MinX;
				int SpriteYPos = SB_SpriteSetupData[FrameIndex][SpriteDataIndex].MinY;

				code.OutputCommentLine(fmt::format("//; Sprite:{:d}, Value:{:d}", SpriteOutputIndex, SpriteDataIndex));

				//; XValue
				code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", SpriteXPos & 255));
				code.OutputCodeLine(CLC);
				code.OutputCodeLine(ADC_ABS, fmt::format("XSpriteCircleMovement"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}X", SpriteOutputIndex));

				//; MSB
				MSBMask |= (1 << SpriteOutputIndex);
				code.OutputCodeLine(BCC, fmt::format("SB_Multiplex_NoMSB_Frame{:d}_Sprite{:d}", FrameIndex, SpriteDataIndex));
				if (SpriteDataIndex < 2)
				{
					for (int Increments = 0; Increments < SpriteDataIndex; Increments++)
					{
						code.OutputCodeLine(INX);
					}
				}
				code.OutputCodeLine(TXA);
				code.OutputCodeLine(ORA_IMM, fmt::format("#${:02x}", 1 << SpriteOutputIndex));
				code.OutputCodeLine(TAX);
				code.OutputFunctionLine(fmt::format("SB_Multiplex_NoMSB_Frame{:d}_Sprite{:d}", FrameIndex, SpriteDataIndex));

				//; YValue
				code.OutputCodeLine(LDA_IMM, fmt::format("#${:02x}", (SpriteYPos + ADDITIONALYVALUE) & 255));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_Sprite{:d}Y", SpriteOutputIndex));
				StoredSpriteYPositions[SpriteOutputIndex] = (SpriteYPos + ADDITIONALYVALUE);// &255;

				//; Sprite Value
				code.OutputCodeLine(LDA_IMM, fmt::format("#(SpriteCircleBaseSprite{:d} + {:d})", FrameIndex, SpriteDataIndex));
				code.OutputCodeLine(STA_ABS, fmt::format("Bank_SpriteVals + {:d}", SpriteOutputIndex));

				code.OutputBlankLine();

				NumSpritesProcessed++;
				SpriteOutputIndex = (SpriteOutputIndex + 1) & 7;
			}

			//; MSB...
			if (MSBMask == 0xff)
			{
				code.OutputCodeLine(STX_ABS, fmt::format("VIC_SpriteXMSB"));
			}
			else
			{
				code.OutputCodeLine(STX_ABS, fmt::format("SB_Multiple_MSB_ORA_Frame{:d}_Section{:d} + 1", FrameIndex, NumSections[FrameIndex]));
				code.OutputCodeLine(LDA_ABS, fmt::format("VIC_SpriteXMSB"));
				code.OutputCodeLine(AND_IMM, fmt::format("#${:02x}", 0xff - MSBMask));
				code.OutputFunctionLine(fmt::format("SB_Multiple_MSB_ORA_Frame{:d}_Section{:d}", FrameIndex, NumSections[FrameIndex]));
				code.OutputCodeLine(ORA_IMM, fmt::format("#$ff"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_SpriteXMSB"));
			}

			//; Next Section...

			//; (i) get the Y-position of the next sprite
			int NextSpriteDataIndex = SB_SortedSpriteIndices[FrameIndex][NumSpritesProcessed];
			int NextSpriteYPos = SB_SpriteSetupData[FrameIndex][NextSpriteDataIndex].MinY;

			//; (ii) determine how many sprites above this sprite (including "clearance") are finished with
			int NumSpritesFinishedWith = 0;
			int FirstTestSpriteIndex = max(0, NumSpritesProcessed - 8);
			for (int TestSpriteIndex = FirstTestSpriteIndex; TestSpriteIndex < NumSpritesProcessed; TestSpriteIndex++)
			{
				int TestSpriteDataIndex = SB_SortedSpriteIndices[FrameIndex][TestSpriteIndex];
				int TestSpriteYPos = SB_SpriteSetupData[FrameIndex][TestSpriteDataIndex].MinY;
				int TestSpriteMaxYPos = TestSpriteYPos + 21;

				if ((TestSpriteMaxYPos/* + SB_MULTPLEXOR_NEEDED_BLANK_LINES*/) < NextSpriteYPos)
				{
					NumSpritesFinishedWith++;
				}
			}

			//; Set the number of sprites we can update in the next section
			NumSpritesForThisSection = min(NumSpritesFinishedWith, SB_SpriteSetupDataNum[FrameIndex] - NumSpritesProcessed);

			NumSections[FrameIndex]++;

			int LastSpriteOutputIndex = (SpriteOutputIndex + NumSpritesForThisSection - 1) & 7;
			SafeRasterInterruptLine[FrameIndex][NumSections[FrameIndex]] = StoredSpriteYPositions[LastSpriteOutputIndex] + 20;

			int NextIRQLine = SafeRasterInterruptLine[FrameIndex][NumSections[FrameIndex]];
			int Stage = 1;
			if (bFirstStage)
			{
				Stage = 0;
				bFirstStage = false;
			}
			if (NumSpritesForThisSection == 0)
			{
				NextIRQLine = -1;
				Stage = 2;
			}

			if (iSection == 1)
			{
				code.OutputCodeLine(LDA_IMM, fmt::format("#$00"));
				code.OutputCodeLine(STA_ABS, fmt::format("VIC_ScreenColour"));
			}

			code.OutputCodeLine(NONE, fmt::format(":SB_NextIRQ({:d},{:d})", NextIRQLine, Stage));
			code.OutputBlankLine();

			iSection++;
		}
	}

	bool bGood = true;
	for (int SectionIndex = 1; SectionIndex < SB_NUM_FRAMES; SectionIndex++)
	{
		if (NumSections[0] != NumSections[SectionIndex])
		{
			bGood = false;
		}
	}
	for (int SectionIndex = 0; SectionIndex < SB_NUM_FRAMES; SectionIndex++)
	{
		if (NumSections[SectionIndex] == 1)
		{
			bGood = false;
		}
	}

	code.OutputFunctionLine(fmt::format("SpriteMultiplexJumpTable_Lo"));
	for (int SectionIndex = 0; SectionIndex < NumSections[0]; SectionIndex++)	//; TODO: Assumption: NumSections is the same for all..?
	{
		for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
		{
			code.OutputCodeLine(NONE, fmt::format(".byte <SpriteMultiplex_Frame{:d}_Section{:d}", FrameIndex, SectionIndex));
		}
	}
	code.OutputFunctionLine(fmt::format("SpriteMultiplexJumpTable_Hi"));
	for (int SectionIndex = 0; SectionIndex < NumSections[0]; SectionIndex++)	//; TODO: Assumption: NumSections is the same for all..?
	{
		for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
		{
			code.OutputCodeLine(NONE, fmt::format(".byte >SpriteMultiplex_Frame{:d}_Section{:d}", FrameIndex, SectionIndex));
		}
	}
}

void SpriteBobs_CalculateSpriteSetupData(void)
{
	ZeroMemory(SB_SpriteSetupData, sizeof(SB_SpriteSetupData));
	ZeroMemory(SB_SpriteSetupDataNum, sizeof(SB_SpriteSetupDataNum));
	for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
	{
		for (int CharIndex = 0; CharIndex < SB_NUM_TOTAL_CHARS; CharIndex++)
		{
			int XMin, YMin, XMax, YMax;
			int SinIndex = CharIndex * SB_NUM_FRAMES + FrameIndex;
			int XVal = SB_SinTableX[SinIndex];
			int YVal = SB_SinTableY[SinIndex];

			XMin = XVal;
			YMin = YVal;
			XMax = XVal + SB_FONT_WIDTH;
			YMax = YVal + SB_FONT_HEIGHT;

			int NewXMin, NewXMax, NewYMin, NewYMax;
			if (SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].NumChars > 0)
			{
				NewXMin = min(SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MinX, XMin);
				NewXMax = max(SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MaxX, XMax);
				NewYMin = min(SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MinY, YMin);
				NewYMax = max(SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MaxY, YMax);
			}
			else
			{
				NewXMin = XMin;
				NewXMax = XMax;
				NewYMin = YMin;
				NewYMax = YMax;
			}

			int Width = NewXMax - NewXMin;
			int Height = NewYMax - NewYMin;
			if ((Width > 24) || (Height > 21))
			{
				SB_SpriteSetupDataNum[FrameIndex]++;

				NewXMin = XMin;
				NewXMax = XMax;
				NewYMin = YMin;
				NewYMax = YMax;
			}

			SB_CharIndexToSpriteIndex[CharIndex] = SB_SpriteSetupDataNum[FrameIndex];
			SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].NumChars++;
			SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MinX = NewXMin;
			SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MaxX = NewXMax;
			SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MinY = NewYMin;
			SB_SpriteSetupData[FrameIndex][SB_SpriteSetupDataNum[FrameIndex]].MaxY = NewYMax;
		}
		SB_SpriteSetupDataNum[FrameIndex]++;
	}
}

void SpriteBobs_InvertCharset(LPCTSTR InputFilename, LPCTSTR OutputFilename)
{
	DWORD  dwBytes;
	OVERLAPPED ol = { 0 };
	HANDLE hFile = CreateFile(InputFilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, NULL);
	if (!hFile)
	{
		return;
	}
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &dwBytes, &ol);
	CloseHandle(hFile);

	for (int Offset = 0; Offset < 2048; Offset++)
	{
		FileReadBuffer[Offset] ^= 0xff;
	}

	WriteBinaryFile(OutputFilename, FileReadBuffer, 2048);
}

#define NUM_FADE_SPRITES 28
void GenerateFadeSprites(LPCTSTR OutputMAPFilename, char* OutPNGFilename)
{
	double SmallSine[21];
	for (int SineIndex = 0; SineIndex < 21; SineIndex++)
	{
		double angle = (2 * PI * SineIndex) / 21;
		SmallSine[SineIndex] = max(0.0, min(1.0, (sin(angle) + 1.0) / 2.0)); //; sin in range [0, 1]
	}

	double SmallSine2[NUM_FADE_SPRITES];
	for (int SineIndex = 0; SineIndex < NUM_FADE_SPRITES; SineIndex++)
	{
		double angle = (2 * PI * SineIndex) / NUM_FADE_SPRITES;
		SmallSine2[SineIndex] = max(0.0, min(1.0, (sin(angle) + 1.0) / 2.0)); //; sin in range [0, 1]
	}

	unsigned char FadeSprites[NUM_FADE_SPRITES][64];
	memset(FadeSprites, 255, sizeof(FadeSprites));

	int OutWidth = NUM_FADE_SPRITES * 24;
	int OutHeight = 21;
	CImg<unsigned char> DstSpriteData(OutWidth, OutHeight, 1, 3);
	DstSpriteData.fill(0);

	double dNumFadeSprites = NUM_FADE_SPRITES;
	for (int SpriteIndex = 0; SpriteIndex < NUM_FADE_SPRITES; SpriteIndex++)
	{
		bool bLastSprite = (SpriteIndex == (NUM_FADE_SPRITES - 1));

		double Width = (((double)SpriteIndex + 1.0) * 24.0) / dNumFadeSprites;
		for (int YPos = 0; YPos < 21; YPos++)
		{
			double LineSineCentre = 12.0 + (SmallSine[(YPos + SpriteIndex) % 21] * 4.0);

			int XPos0 = (int)(LineSineCentre - (Width / 2.0));
			int XPos1 = (int)(LineSineCentre + (Width / 2.0));

			if (bLastSprite)
			{
				XPos0 = 0;
				XPos1 = 24;
			}

			for (int XPos = XPos0; XPos < XPos1; XPos++)
			{
				int XPosModded = XPos;
				while (XPosModded < 0)
				{
					XPosModded += 24;
				}
				while (XPosModded >= 24)
				{
					XPosModded -= 24;
				}
				int ByteIndex = YPos * 3 + (XPosModded / 8);
				unsigned char BitSet = 1 << (7 - (XPosModded % 8));
				unsigned char BitMask = 0xff - BitSet;
				FadeSprites[SpriteIndex][ByteIndex] &= BitMask;


				DstSpriteData(SpriteIndex * 24 + XPosModded, YPos, 0, 0) = DstSpriteData(XPos, YPos, 0, 1) = DstSpriteData(XPos, YPos, 0, 2) = 255;
			}
		}
	}
	WriteBinaryFile(OutputMAPFilename, FadeSprites, sizeof(FadeSprites));

	DstSpriteData.save_png(OutPNGFilename);
}



int SpriteBobs_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\SpriteBobs");

	/* ScrollText.bin */
	SpriteBobs_OutputScrollText(L"..\\..\\Intermediate\\Built\\SpriteBobs\\ScrollText.bin");

	SpriteBobs_InvertCharset(L"..\\..\\Build\\Parts\\SpriteBobs\\Data\\gplogo.map", L"..\\..\\Intermediate\\Built\\SpriteBobs\\gplogo.bin");

	/* FontsData.asm */
	SpriteBobs_BMPSpacedFontToPreShifted(L"..\\..\\Build\\Parts\\SpriteBobs\\Data\\Font-5x5.bmp", L"..\\..\\Intermediate\\Built\\SpriteBobs\\FontsData.asm", 5, 5, 32, 6);

	//; (i) X-Movement sintable
	unsigned char cSinTableXMovement[256];
	int SinTableXMovement[256];
	GenerateSinTable(256, 24, 100, 0, SinTableXMovement);
	for (int SinIndex = 0; SinIndex < 256; SinIndex++)
	{
		cSinTableXMovement[SinIndex] = (unsigned char)SinTableXMovement[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\SpriteBobs\\SinTable-XSpriteMovement256.bin", cSinTableXMovement, 256);

	//; (ii) X sintable
	static const int SinTableOffsetX = (SIZE_SINTABLE * 0) / 8;
	GenerateSinTable(SIZE_SINTABLE, 0, 239, SinTableOffsetX, SB_SinTableX);

	//; (iii) Y sintable
	static const int SinTableOffsetY = (SIZE_SINTABLE * 2) / 8;	//; HACK... what's a better way to offset this..? Or we change the other code to index differently..?
	GenerateSinTable(SIZE_SINTABLE, 16, 274, SinTableOffsetY, SB_SinTableY);

	//; (iv) convert to final output format
	SpriteBobs_CalculateSpriteSetupData();

	//; (v) sort the sprites into top-to-bottom order
	SpriteBobs_SortSpriteData();

	/* ScrollTextUpdate.asm */
	SpriteBobs_OutputScrollTextUpdateCode(L"..\\..\\Intermediate\\Built\\SpriteBobs\\ScrollTextUpdate.asm");

	/* Draw.asm */
	//; nb. OutputSpriteCode() will modify SinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	ofstream DrawASMStream;

	SpriteBobs_SetupCharCombinations();

	SpriteBobs_OutputSpriteCode(L"..\\..\\Intermediate\\Built\\SpriteBobs\\Draw-Frame0.asm", 0);
	SpriteBobs_OutputSpriteCode(L"..\\..\\Intermediate\\Built\\SpriteBobs\\Draw-Frame1.asm", 1);

	/* SpriteMultipex.asm */
	//; nb. OutputSpriteCode() will modify SinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	SpriteBobs_OutputSpriteMultiplexCode(L"..\\..\\Intermediate\\Built\\SpriteBobs\\Multiplex.asm");

	GenerateFadeSprites(L"..\\..\\Intermediate\\Built\\SpriteBobs\\FadeSprites.map", "..\\..\\Intermediate\\Built\\SpriteBobs\\FadeSprites.png");

	/* Debug Output Showing Us Where Sprites Will Be Drawn */
#if OUTPUT_SPRITELOCATION_DEBUGINFO
	ofstream SpritesPerRasterLine;
	SpritesPerRasterLine.open("..\\..\\Intermediate\\Built\\SpriteBobs\\DEBUG-OUTPUT-SpritesPerRasterLine.txt");
	unsigned char SpriteUsedAlready[SB_NUM_FRAMES][SB_MAX_NUM_SPRITES];
	ZeroMemory(SpriteUsedAlready, sizeof(SpriteUsedAlready));

	for (int RasterLine = 0; RasterLine < 320; RasterLine++)
	{
		bool bFirst = true;
		for (int FrameIndex = 0; FrameIndex < SB_NUM_FRAMES; FrameIndex++)
		{
			int NumSpritesOnLine = 0;
			for (int SpriteIndex = 0; SpriteIndex < SB_SpriteSetupDataNum[FrameIndex]; SpriteIndex++)
			{
				int SpriteYPos = SB_SpriteSetupData[FrameIndex][SpriteIndex].MinY;
				if (bFirst)
				{
					SpritesPerRasterLine << setw(2) << hex << setfill('0') << int(RasterLine) << setfill(' ') << ": ";
					bFirst = false;
				}
				if ((RasterLine >= SpriteYPos) && (RasterLine < (SpriteYPos + 21)))
				{
					if (SpriteUsedAlready[FrameIndex][SpriteIndex] == 0)
					{
						SpriteUsedAlready[FrameIndex][SpriteIndex] = 1;
						SpritesPerRasterLine << "+";
					}
					else
					{
						SpritesPerRasterLine << "=";
					}
					NumSpritesOnLine++;
				}
				else
				{
					SpritesPerRasterLine << " ";
				}
			}
			SpritesPerRasterLine << "(" << dec << setw(2) << int(NumSpritesOnLine) << ") ... ";
		}
		SpritesPerRasterLine << endl;
	}
	SpritesPerRasterLine.close();
#endif //; OUTPUT_SPRITELOCATION_DEBUGINFO
	return 0;
}

