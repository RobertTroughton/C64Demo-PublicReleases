//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#define OUTPUT_SPRITELOCATION_DEBUGINFO 0

#define SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME 1
#define SPRITEBOBS_FONT_SIZE_X 5
#define SPRITEBOBS_FONT_SIZE_Y 5
#define SPRITEBOBS_FONT_NUM_CHARS 32 //; Font5x5.bin

#define SPRITE_STRIDE 3 //; All c64 sprites are 24 pixels wide ... so the "stride" is 3 bytes

#define NUM_CHARS_PER_SPRITE 4
#define NUM_FRAMES_PER_SPRITE 4

#define SPRITE_MEMORYSIZE 64
#define SPRITE_MEMORY_DATASIZE 63

#define NUM_SPRITES_TO_USE 32

#define SPRITEBOBS_SIZE_SpriteSinTableXY ( NUM_SPRITES_TO_USE * NUM_CHARS_PER_SPRITE * NUM_FRAMES_PER_SPRITE )

static unsigned char SpriteBobs_ScrollTextStr[] = {
	"    \xe0    .   .  . ................."
	"    \xe2    What you are looking at here..."
	"    \xe6    Is a new world record!"
	"    \xeb    A multicolour one hundred and twenty eight bob circle scroller over a bitmap!"
	"    \xe4    Yarrr.. beat that ye dirty scallywags!"
	"    \xe0    And yes"
	"    \xe2    ... Bonzai ..."
	"    \xe0    We are looking at you with your love of old school DYCP!"
	"                                                                                                                                "
};
static int SpriteBobs_ScrollTextStrSize = sizeof(SpriteBobs_ScrollTextStr) / sizeof(unsigned char);

void SpriteBobs_OutputScrollText(LPCTSTR OutputFilename)
{
	int WriteSize = 0;
	for (int Index = 0; Index < SpriteBobs_ScrollTextStrSize - 1; Index++)
	{
		unsigned char ByteValue = SpriteBobs_ScrollTextStr[Index];
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

		SpriteBobs_ScrollTextStr[WriteSize++] = ByteValue;
	}
	SpriteBobs_ScrollTextStr[WriteSize++] = 0xFF;
	WriteBinaryFile(OutputFilename, SpriteBobs_ScrollTextStr, WriteSize);
}

void SpriteBobs_Output6x5FontPreShifted(ofstream& file)
{
	ostringstream FontStream;
	int TotalCycles = 0;
	int TotalSize = 0;

	ReadBinaryFile(L"..\\..\\SourceData\\font6x5.bin", FileReadBuffer, FILE_READ_BUFFER_SIZE);

	FontStream << ".align $40";
	OUTPUT_CODE(FontStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (int ShiftRight = 0; ShiftRight < 8; ShiftRight++)
	{
		for (int YPos = 0; YPos < SPRITEBOBS_FONT_SIZE_Y; YPos++)
		{
			int BitsToOutput = 8;
			int XStart = 0;
			int XEnd = 8;
			int XLoops = 1;
			if (ShiftRight > (8 - SPRITEBOBS_FONT_SIZE_X))
			{
				XLoops = 2;
			}

			for (int XLoop = 0; XLoop < XLoops; XLoop++)
			{
				FontStream << "Font6x5_Shift" << int(ShiftRight) << "_Y" << int(YPos) << "_Loop" << int(XLoop) << ":";
				OUTPUT_CODE(FontStream, 0, 0, true);

				for (int Character = 0; Character < SPRITEBOBS_FONT_NUM_CHARS; Character++)
				{
					FontStream << "\t\t.byte %";
					for (int XPos = XStart; XPos < XEnd; XPos++)
					{
						if (XPos < ShiftRight)
						{
							FontStream << "0";
						}
						else
						{
							int OutputBit = 0;
							if (XPos < (ShiftRight + SPRITEBOBS_FONT_SIZE_X))
							{
								int ReadXPos = XPos - ShiftRight;
//;								ReadXPos += 5; //; Font6x5.bin
								int ReadYPos = YPos;
//;								ReadYPos += 5; //; Font6x5.bin
								int ReadOffset = 0;

								ReadOffset += 2; //; file header
								ReadOffset += Character * 8;
								ReadOffset += (ReadXPos / 8) * 0x200;
								ReadOffset += (ReadYPos / 8) * 0x400;
								ReadOffset += ReadYPos % 8;

								unsigned char ReadByte = FileReadBuffer[ReadOffset];
								int bitShift = 7 - (ReadXPos % 8);
								OutputBit = ((ReadByte & (1 << bitShift)) != 0) ? 1 : 0;
							}
							FontStream << dec << int(OutputBit);
						}
					}
					FontStream << " //; Char '" << int(Character) << "', Y '" << int(YPos) << "', Shift '" << int(ShiftRight) << "'";
					OUTPUT_CODE(FontStream, 0, 1, true);
				}
				OUTPUT_BLANK_LINE();
				XStart += 8;
				XEnd += 8;
			}
		}
		OUTPUT_BLANK_LINE();
	}
}

void SpriteBobs_BMPSpacedFontToPreShifted(LPCTSTR FontFilename, ofstream& file, int CharWidth, int CharHeight, int NumChars, int CharStride)
{
	ostringstream FontStream;
	int TotalCycles = 0;
	int TotalSize = 0;

	int BMPHeader = 0x3e;

	ReadBinaryFile(FontFilename, FileReadBuffer, FILE_READ_BUFFER_SIZE);

	FontStream << ".align $40";
	OUTPUT_CODE(FontStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (int ShiftRight = 0; ShiftRight < 8; ShiftRight++)
	{
		for (int YPos = 0; YPos < CharHeight; YPos++)
		{
			int BitsToOutput = 8;
			int XStart = 0;
			int XEnd = 8;
			int XLoops = 1;
			if (ShiftRight >(8 - CharWidth))
			{
				XLoops = 2;
			}

			for (int XLoop = 0; XLoop < XLoops; XLoop++)
			{
				FontStream << "Font6x5_Shift" << int(ShiftRight) << "_Y" << int(YPos) << "_Loop" << int(XLoop) << ":";
				OUTPUT_CODE(FontStream, 0, 0, true);

				for (int Character = 0; Character < NumChars; Character++)
				{
					FontStream << "\t\t.byte %";
					for (int XPos = XStart; XPos < XEnd; XPos++)
					{
						if (XPos < ShiftRight)
						{
							FontStream << "0";
						}
						else
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
							FontStream << dec << int(OutputBit);
						}
					}
					FontStream << " //; Char '" << int(Character) << "', Y '" << int(YPos) << "', Shift '" << int(ShiftRight) << "'";
					OUTPUT_CODE(FontStream, 0, 1, true);
				}
				OUTPUT_BLANK_LINE();
				XStart += 8;
				XEnd += 8;
			}
		}
		OUTPUT_BLANK_LINE();
	}
}

void SpriteBobs_OutputSpriteCode(ofstream& file, int* SpriteSinTableX, int* SpriteSinTableX_Output, int* SpriteSinTableY, int* SpriteSinTableY_Output)
{
	unsigned char TouchedMemory[NUM_FRAMES_PER_SPRITE][NUM_SPRITES_TO_USE][SPRITE_MEMORYSIZE];
	ZeroMemory(TouchedMemory, NUM_FRAMES_PER_SPRITE * NUM_SPRITES_TO_USE * SPRITE_MEMORYSIZE);

	int TotalCycles = 0;
	int TotalSize = 0;

	ostringstream SpriteCodeStream;

	int CollisionTable[SPRITE_MEMORYSIZE];

	SpriteCodeStream << "ScrollTextRead_Temp_Store:";
	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t.byte $00";
	OUTPUT_CODE(SpriteCodeStream, 0, 1, true);
	SpriteCodeStream << "ScrollTextRead_NewSpriteColour:";
	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t.byte $00";
	OUTPUT_CODE(SpriteCodeStream, 0, 1, true);

	TotalCycles = TotalSize = 0;
	TotalCycles = TotalSize = 0;
	SpriteCodeStream << "AdvanceCircleText:";																			OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\t\tldy #$00";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tACT_ScrollTextReadPtr:";																		OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t\tlda ScrollText";																			OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tcmp #$FF";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tbne DontResetScrollTextPtr";																OUTPUT_CODE(SpriteCodeStream, 3, 2, true);
	SpriteCodeStream << "\t\tlda #$01";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsta Signal_ScrollerIsFinished";															OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tlda #<ScrollText";																			OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsta ACT_ScrollTextReadPtr + 1";															OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tlda #>ScrollText";																			OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsta ACT_ScrollTextReadPtr + 2";															OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tlda #$00";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tjmp ACT_WriteNewCharAndFinish";															OUTPUT_CODE(SpriteCodeStream, 4, 2, true);
	SpriteCodeStream << "\tDontResetScrollTextPtr:";																	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\t\tcmp #$e0";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tbcc NotAColourControl";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsec";																						OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsbc #$e0";																					OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\t\tsta ScrollTextRead_NewSpriteColour";														OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tlda #$00";																					OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tNotAColourControl:";																			OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\t\tinc ACT_ScrollTextReadPtr + 1";															OUTPUT_CODE(SpriteCodeStream, 6, 3, true);
	SpriteCodeStream << "\t\tbne ACT_WriteNewCharAndFinish";															OUTPUT_CODE(SpriteCodeStream, 3, 2, true);
	SpriteCodeStream << "\t\tinc ACT_ScrollTextReadPtr + 2";															OUTPUT_CODE(SpriteCodeStream, 6, 3, true);
	SpriteCodeStream << "\tACT_WriteNewCharAndFinish:";																	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t\tsta ScrollTextRead_Frame0_Char" << dec << int(12 * NUM_CHARS_PER_SPRITE - 1) << " + 1";	OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tsta ScrollTextRead_Frame1_Char" << dec << int(12 * NUM_CHARS_PER_SPRITE - 1) << " + 1";	OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tsta ScrollTextRead_Frame2_Char" << dec << int(12 * NUM_CHARS_PER_SPRITE - 1) << " + 1";	OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\tsta ScrollTextRead_Frame3_Char" << dec << int(12 * NUM_CHARS_PER_SPRITE - 1) << " + 1";	OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\t\trts";																						OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
	OUTPUT_BLANK_LINE();

	for (int FrameIndex = 0; FrameIndex < NUM_FRAMES_PER_SPRITE; FrameIndex++)
	{
		TotalCycles = TotalSize = 0;
		SpriteCodeStream << "DrawSprites_Frame" << FrameIndex << ":"; OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
		OUTPUT_BLANK_LINE();

		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			int BestPass = 255;
			int BestCycles = 1000000;
			int CurrentPass = 0;

			bool bFinalPass = true;
			bFinalPass = false;
			bool bFinished = false;

			int StoredTotalCycles = TotalCycles;
			int StoredTotalSize = TotalSize;

			do
			{
				ZeroMemory(&CollisionTable[0], SPRITE_MEMORYSIZE * sizeof(CollisionTable[0]));

				TotalCycles = StoredTotalCycles;
				TotalSize = StoredTotalSize;

				SpriteCodeStream << "\t//; Sprite $" << hex << setw(2) << setfill('0') << int(SpriteIndex) << setfill(' ');
				OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);

				int SpriteAddress = SpriteIndex * SPRITE_MEMORYSIZE;

				int SinPositionX[NUM_CHARS_PER_SPRITE], SinPositionY[NUM_CHARS_PER_SPRITE];

				int MinSinPositionX = SpriteSinTableX_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
				int MinSinPositionY = SpriteSinTableY_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
				int XShift[NUM_CHARS_PER_SPRITE], XPos[NUM_CHARS_PER_SPRITE];
				for (int SIndex = 0; SIndex < NUM_CHARS_PER_SPRITE; SIndex++)
				{
					SinPositionX[SIndex] = SpriteSinTableX[((SpriteIndex * NUM_CHARS_PER_SPRITE) + SIndex) * NUM_FRAMES_PER_SPRITE + FrameIndex] - MinSinPositionX;
					SinPositionY[SIndex] = SpriteSinTableY[((SpriteIndex * NUM_CHARS_PER_SPRITE) + SIndex) * NUM_FRAMES_PER_SPRITE + FrameIndex] - MinSinPositionY;
					XShift[SIndex] = (SinPositionX[SIndex] + CurrentPass) % 8;
					XPos[SIndex] = (SinPositionX[SIndex] + CurrentPass) / 8;
				}

				if (bFinalPass)
				{
					SpriteSinTableX_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex] -= CurrentPass;
				}

				//; Pass 1: Generate "Collision" Data
				for (int SpriteChar = 0; SpriteChar < NUM_CHARS_PER_SPRITE; SpriteChar++)
				{
					int WriteYStart = 0;
					int WriteHeight = SPRITEBOBS_FONT_SIZE_Y;

					//; Deal with the start/end of the scroller in a nice way...
					if (SpriteIndex == 11)
					{
						if (SpriteChar == (NUM_CHARS_PER_SPRITE - 1))
						{
							WriteHeight = 4 - FrameIndex; //; TODO: if NUM_FRAMES_PER_SPRITE isn't 4 then this calculation won't be as expected...
						}
					}
					if (SpriteIndex == 12)
					{
						if (SpriteChar == 0)
						{
							WriteYStart = 4 - FrameIndex; //; TODO: as above
							WriteHeight = min(5, SPRITEBOBS_FONT_SIZE_Y - WriteYStart);
						}
					}

					for (int SpriteYPos = WriteYStart; SpriteYPos < (WriteYStart + WriteHeight); SpriteYPos++)
					{
						int WriteOffset = ((SpriteYPos + SinPositionY[SpriteChar]) * SPRITE_STRIDE) + XPos[SpriteChar];
						CollisionTable[WriteOffset] |= (1 << (SpriteChar * 2));
						if (XShift[SpriteChar] > (8 - SPRITEBOBS_FONT_SIZE_X))
						{
							CollisionTable[WriteOffset + 1] |= (2 << (SpriteChar * 2));
						}
					}
				}

				//; Pass 2: Output Assembly

				char XYIndexes[2] = {'x', 'y'};

				struct
				{
					int Index0;
					int Index1;
				} PassValues[] = {
					{0,	-1},	//; Char 0
					{0,	 1},	//; Char 0|1
					{1,	-1},	//; Char 1
					{1,	 2},	//; Char 1|2
					{2,	-1},	//; Char 2
					{2,	 3},	//; Char 2|3
					{3,	-1},	//; Char 3
					{3,	 4},	//; Char 3|4
					{4,	-1},	//; Char 4
					{4,	 5},	//; Char 4|5
					{5,	-1},	//; Char 5
					{5,	 6},	//; Char 5|6
					{6,	-1},	//; Char 6
				};
				char bWasLoaded[NUM_CHARS_PER_SPRITE];
				ZeroMemory(bWasLoaded, NUM_CHARS_PER_SPRITE);
				for (int CollisionPass = 0; CollisionPass < NUM_CHARS_PER_SPRITE * 2 - 1; CollisionPass++)
				{
					bool bOring = PassValues[CollisionPass].Index1 >= 0;

					int Index0 = PassValues[CollisionPass].Index0;
					int Index1 = Index0 + 1;
					int CollMask_Match0 = 0x03 << (Index0 * 2);
					int CollMask_Match1 = 0x03 << (Index1 * 2);
					int CollMask_Match_Combined = CollMask_Match0 | CollMask_Match1;
					int CharIndex0 = SpriteIndex * NUM_CHARS_PER_SPRITE + Index0;
					int CharIndex1 = SpriteIndex * NUM_CHARS_PER_SPRITE + Index1;

					if (!bWasLoaded[Index0])
					{
						SpriteCodeStream << "\tScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex0) << ":";
						OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);
						SpriteCodeStream << "\t\tld" << XYIndexes[Index0 % 2] << " #$00";
						OUTPUT_CODE(SpriteCodeStream, 2, 2, bFinalPass);
						if (CharIndex0 > 0)
						{
							SpriteCodeStream << "\t\tst" << XYIndexes[Index0 % 2] << " ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex0 - 1) << " + 1";
						}
						else
						{
							SpriteCodeStream << "\t\tst" << XYIndexes[Index0 % 2] << " ScrollTextRead_Temp_Store";
						}
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
						bWasLoaded[Index0] = 1;
					}
					if (bOring)
					{
						if (!bWasLoaded[Index1])
						{
							SpriteCodeStream << "\tScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex1) << ":";
							OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);
							SpriteCodeStream << "\t\tld" << XYIndexes[Index1 % 2] << " #$00";
							OUTPUT_CODE(SpriteCodeStream, 2, 2, bFinalPass);
							if (CharIndex1 > 0)
							{
								SpriteCodeStream << "\t\tst" << XYIndexes[Index1 % 2] << " ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex1 - 1) << " + 1";
							}
							else
							{
								SpriteCodeStream << "\t\tst" << XYIndexes[Index1 % 2] << " ScrollTextRead_Temp_Store";
							}
							OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							bWasLoaded[Index1] = 1;
						}
					}

					for (int WriteOffset = 0; WriteOffset < SPRITE_MEMORY_DATASIZE; WriteOffset++)
					{
						int CollBits = CollisionTable[WriteOffset];
						if (!(CollBits & CollMask_Match0))
						{
							continue;
						}
						if (bOring && !(CollBits & CollMask_Match1))
						{
							continue;
						}
						if (!bOring && (CollBits & CollMask_Match1))
						{
							continue;
						}

						CollisionTable[WriteOffset] &= (0xffffffff - CollMask_Match_Combined);

						int CurrentYPos = WriteOffset / SPRITE_STRIDE;
						int WriteAddress = SpriteAddress + WriteOffset;

						unsigned char Loop[NUM_CHARS_PER_SPRITE];
						for (int iLoop = 0; iLoop < NUM_CHARS_PER_SPRITE; iLoop++)
						{
							int Shift = iLoop * 2;
							unsigned char Mask = 0x03 << Shift;
							Loop[iLoop] = (((CollBits & Mask) >> Shift) == 0x01) ? 0 : 1;
						}

						int YOffset0 = CurrentYPos - SinPositionY[Index0];
						SpriteCodeStream << "\t\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[Index0]) << "_Y" << hex << setw(1) << int(YOffset0) << "_Loop" << int(Loop[Index0]) << "," << XYIndexes[Index0 % 2];
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
						if (bOring)
						{
							int YOffset1 = CurrentYPos - SinPositionY[Index1];
							SpriteCodeStream << "\t\tora Font6x5_Shift" << hex << setw(1) << int(XShift[Index1]) << "_Y" << hex << setw(1) << int(YOffset1) << "_Loop" << int(Loop[Index1]) << "," << XYIndexes[Index1 % 2];
							OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
						}
						SpriteCodeStream << "\t\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);

						if (bFinalPass)
						{
							TouchedMemory[FrameIndex][SpriteIndex][WriteOffset] = 1;
						}
					}
				}
				if (bFinalPass)
				{
					bFinished = true;
				}
				else
				{
					if (TotalCycles < BestCycles)
					{
						BestPass = CurrentPass;
						BestCycles = TotalCycles;
					}
					CurrentPass++;
					if (CurrentPass == 8)
					{
						CurrentPass = BestPass;
						bFinalPass = true;
					}
				}
			} while (!bFinished);
		}
		SpriteCodeStream << "\t\tlda ScrollTextRead_Temp_Store";
		OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
		SpriteCodeStream << "\t\tsta ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(NUM_SPRITES_TO_USE * NUM_CHARS_PER_SPRITE - 1) << " + 1";
		OUTPUT_CODE(SpriteCodeStream, 4, 3, true);

#if SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
		SpriteCodeStream << "\t\tjmp ClearUnusedBytesThatWereUsedByPreviousFrame_Frame" << int(FrameIndex);
		OUTPUT_CODE(SpriteCodeStream, 3, 3, true);
		OUTPUT_BLANK_LINE();
#else //; SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
		SpriteCodeStream << "\t\trts";
		OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
#endif //; SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
	}

#if SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
	for (int FrameIndex = 0; FrameIndex < 4; FrameIndex++)
	{
		TotalCycles = TotalSize = 0;

		SpriteCodeStream << "ClearUnusedBytesThatWereUsedByPreviousFrame_Frame" << int(FrameIndex) << ":";
		OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

		SpriteCodeStream << "\t\tlda #$00";
		OUTPUT_CODE(SpriteCodeStream, 2, 2, true);

		int PreviousFrameIndex = (FrameIndex + 2) & 3; //; TODO: HACK
		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			int SpriteAddress = SpriteIndex * SPRITE_MEMORYSIZE;
			for (int WriteOffset = 0; WriteOffset < SPRITE_MEMORY_DATASIZE; WriteOffset++)
			{
				unsigned char WillTouchThisFrame = TouchedMemory[FrameIndex][SpriteIndex][WriteOffset];
				unsigned char WasTouchedLastFrame = TouchedMemory[PreviousFrameIndex][SpriteIndex][WriteOffset];
				if (WasTouchedLastFrame && !WillTouchThisFrame)
				{
					SpriteCodeStream << "\t\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex) << " + $" << hex << setw(4) << setfill('0') << int(SpriteAddress + WriteOffset) << " //; SPR $" << hex << setw(2) << int(SpriteIndex) << setfill(' ');
					OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
				}
			}
		}
		SpriteCodeStream << "\trts";
		OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
#endif //; SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
}

void SpriteBobs_OutputSpriteMultiplexCode(ofstream& file, int* SpriteSinTableX, int* SpriteSinTableX_Output, int* SpriteSinTableY, int* SpriteSinTableY_Output)
{
	class SpriteSetup
	{
	public:
		int NumberOfSpritesToUpdate;
		class SpriteData
		{
		public:
			int OutputIndex;
			int InputIndex;
		} SpriteDataArray[8];
	};

	//; 32 sprites
	static SpriteSetup MySpriteSetup[] = {
		//; nb. OutputIndex's MUST be in order of lowest-to-highest within each line
		{ 8,{ { 0,0 },{ 1,1 },{ 2,2 },{ 3,3 },{ 4,4 },{ 5,5 },{ 6,6 },{ 7,7 } } },
		{ 4,{ { 2,30 },{ 3,31 },{ 4,8 },{ 5,9 }, } },
		{ 4,{ { 0,28 },{ 1,29 },{ 6,10 },{ 7,11 }, } },
		{ 4,{ { 2,26 },{ 3,27 },{ 4,12 },{ 5,13 }, } },
		{ 4,{ { 0,24 },{ 1,25 },{ 6,14 },{ 7,15 }, } },
		{ 4,{ { 2,22 },{ 3,23 },{ 4,16 },{ 5,17 }, } },
		{ 4,{ { 0,20 },{ 1,21 },{ 6,18 },{ 7,19 }, } },
	};
	static int NumSpriteSections = sizeof(MySpriteSetup) / sizeof(SpriteSetup);

	int TotalCycles = 0;
	int TotalSize = 0;

	ostringstream SpriteMultiplexStream;

	SpriteMultiplexStream << "//; SpriteMultiplexor";
	OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (int Frame = 0; Frame < NUM_FRAMES_PER_SPRITE; Frame++)
	{
		SpriteMultiplexStream << "//; Frame " << dec << Frame;
		OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

		for (int Section = 0; Section < NumSpriteSections; Section++)
		{
			SpriteMultiplexStream << "\tSpriteMultiplex_Frame" << dec << int(Frame) << "_Section" << dec << int(Section) << ":";
			OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

			SpriteMultiplexStream << "\t\tlda #$00";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);

			SpriteMultiplexStream << "\t\tsta SpriteMSBValue";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);
			OUTPUT_BLANK_LINE();

			int NumRORs = 0;
			unsigned char RORMap = 0;

			int RORIndex = MySpriteSetup[Section].SpriteDataArray[0].OutputIndex;

			for (int Sprite = 0; Sprite < MySpriteSetup[Section].NumberOfSpritesToUpdate; Sprite++)
			{
				int RORExtras = MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex - RORIndex;
				if (RORExtras)
				{
					SpriteMultiplexStream << "\t\t\tlda SpriteMSBValue";
					OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
					while (RORExtras)
					{
						SpriteMultiplexStream << "\t\t\tlsr";
						OUTPUT_CODE(SpriteMultiplexStream, 2, 1, true);
						RORIndex++;
						RORExtras--;
					}
					SpriteMultiplexStream << "\t\t\tsta SpriteMSBValue";
					OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
					OUTPUT_BLANK_LINE();
				}

				RORMap |= (1 << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex);

				SpriteMultiplexStream << "\t\t//; Sprite:" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << ", Value:" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex;
				OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

				SpriteMultiplexStream << "\t\t\tlda #$" << hex << setw(2) << setfill('0') << int(SpriteSinTableX_Output[MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex * NUM_FRAMES_PER_SPRITE + Frame]) << setfill(' ');
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tclc";
				OUTPUT_CODE(SpriteMultiplexStream, 2, 1, true);

				SpriteMultiplexStream << "\t\t\tadc XSpriteCircleMovement";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tsta VIC_Sprite" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << "X";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tror SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 5, 2, true);
				RORIndex++;

				SpriteMultiplexStream << "\t\t\tlda #$" << hex << setw(2) << setfill('0') << int(SpriteSinTableY_Output[MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex * NUM_FRAMES_PER_SPRITE + Frame]) << setfill(' ');
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta VIC_Sprite" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << "Y";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tlda #(SpriteCircleBaseSprite" << dec << int(Frame) << " + " << dec << int(MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex) << " )";
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta Bank_SpriteVals + " << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex;
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\tSM_Frame" << dec << Frame << "_SPRITE" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex << "_Colour:";
				OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

				SpriteMultiplexStream << "\t\t\tlda #" << dec << int((MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex / 8) + 1);
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta VIC_Sprite" << dec << int(MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex) << "Colour";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
				
				OUTPUT_BLANK_LINE();
			}

			int RORExtras = 8 - RORIndex;
			if (RORExtras)
			{
				SpriteMultiplexStream << "\t\t\tlda SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
				while (RORExtras)
				{
					SpriteMultiplexStream << "\t\t\tlsr";
					OUTPUT_CODE(SpriteMultiplexStream, 2, 1, true);
					RORIndex++;
					RORExtras--;
				}
				SpriteMultiplexStream << "\t\t\tsta SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
			}

			unsigned char RORMask = 255 - RORMap;

			if (RORMap != 0xFF)
			{
				SpriteMultiplexStream << "\t\t\tlda VIC_SpriteXMSB";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tand #$" << hex << setw(2) << setfill('0') << int(RORMask) << setfill(' ');
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tora SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);
			}
			else
			{
				SpriteMultiplexStream << "\t\t\tlda SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);
			}
			SpriteMultiplexStream << "\t\t\tsta VIC_SpriteXMSB";
			OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

			SpriteMultiplexStream << "\t\t\trts";
			OUTPUT_CODE(SpriteMultiplexStream, 6, 1, true);
			OUTPUT_BLANK_LINE();
		}
		OUTPUT_BLANK_LINE();
	}


	SpriteMultiplexStream << "//; Colour Scroll Functions";
	OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (int Frame = 0; Frame < NUM_FRAMES_PER_SPRITE; Frame++)
	{
		SpriteMultiplexStream << "\tDrawSprite_ColourScroll_Frame" << dec << Frame << ":";
		OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_TO_USE - 1; SpriteIndex++)
		{
			int SpriteReadIndex = (SpriteIndex + 13) % NUM_SPRITES_TO_USE;
			int SpriteWriteIndex = (SpriteIndex + 12) % NUM_SPRITES_TO_USE;
			SpriteMultiplexStream << "\t\tlda SM_Frame" << dec << Frame << "_SPRITE" << dec << int(SpriteReadIndex) << "_Colour + 1";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
			SpriteMultiplexStream << "\t\tsta SM_Frame" << dec << Frame << "_SPRITE" << dec << int(SpriteWriteIndex) << "_Colour + 1";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		}
		SpriteMultiplexStream << "\t\tlda ScrollTextRead_NewSpriteColour";
		OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		SpriteMultiplexStream << "\t\tsta SM_Frame" << dec << Frame << "_SPRITE" << dec << int(11) << "_Colour + 1";
		OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		SpriteMultiplexStream << "\t\trts";
		OUTPUT_CODE(SpriteMultiplexStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
}

int SpriteBobs_Main(void)
{
	_mkdir("..\\..\\Intermediate\\Built\\SpriteBobs");

	//; Circle sprite sintables

	//; (i) Y sintable
	int SpriteSinTableY[SPRITEBOBS_SIZE_SpriteSinTableXY];
	GenerateSinTable(SPRITEBOBS_SIZE_SpriteSinTableXY, 50, 240, (NUM_SPRITES_TO_USE * NUM_CHARS_PER_SPRITE * 3) / 2, SpriteSinTableY);

	//; (ii) X sintable
	int SpriteSinTableX[SPRITEBOBS_SIZE_SpriteSinTableXY];
	GenerateSinTable(SPRITEBOBS_SIZE_SpriteSinTableXY, 0, 244, (NUM_SPRITES_TO_USE * NUM_CHARS_PER_SPRITE * 1) / 2, SpriteSinTableX);

	//; (iii) convert to final output format
	const int SpriteSinTableLength = NUM_SPRITES_TO_USE * NUM_FRAMES_PER_SPRITE;
	int SpriteSinTableX_Output[SpriteSinTableLength];
	int SpriteSinTableY_Output[SpriteSinTableLength];
	for (int OutputIndex = 0; OutputIndex < SpriteSinTableLength; OutputIndex++)
	{
		int SpriteIndex = OutputIndex / NUM_FRAMES_PER_SPRITE;
		int FrameIndex = OutputIndex % NUM_FRAMES_PER_SPRITE;

		int MinX, MinY, MaxY;
		MinX = MinY = 10000;
		MaxY = -10000;
		for (int ReadIndex = 0; ReadIndex < NUM_CHARS_PER_SPRITE; ReadIndex++)
		{
			int ReadX = SpriteSinTableX[FrameIndex + ((SpriteIndex * NUM_CHARS_PER_SPRITE) + ReadIndex) * NUM_FRAMES_PER_SPRITE];
			int ReadY = SpriteSinTableY[FrameIndex + ((SpriteIndex * NUM_CHARS_PER_SPRITE) + ReadIndex) * NUM_FRAMES_PER_SPRITE];
			MinX = min(MinX, ReadX);
			MinY = min(MinY, ReadY);
			MaxY = max(MaxY, ReadY);
		}
		int SinYValue = MinY;

		SpriteSinTableX_Output[OutputIndex] = MinX;
		SpriteSinTableY_Output[OutputIndex] = SinYValue;
	}

	//; X-Movement sintable
	unsigned char cSpriteSinTableXMovement[128];
	int SpriteSinTableXMovement[128];
	GenerateSinTable(128, 26, 96, 0, SpriteSinTableXMovement);
	for (int SinIndex = 0; SinIndex < 128; SinIndex++)
	{
		cSpriteSinTableXMovement[SinIndex] = (unsigned char)SpriteSinTableXMovement[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\SpriteBobs\\SinTable-XSpriteMovement128.bin", cSpriteSinTableXMovement, 128);

	/* ScrollText.bin */
	SpriteBobs_OutputScrollText(L"..\\..\\Intermediate\\Built\\SpriteBobs\\ScrollText.bin");

	/* SpriteDrawing.asm */
	//; nb. OutputSpriteCode() will modify SpriteSinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	ofstream SpriteDrawingFile;
	SpriteDrawingFile.open("..\\..\\Intermediate\\Built\\SpriteBobs\\Draw.asm");
	SpriteDrawingFile << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_OutputSpriteCode(SpriteDrawingFile, SpriteSinTableX, SpriteSinTableX_Output, SpriteSinTableY, SpriteSinTableY_Output);
	SpriteDrawingFile.close();

	/* FontsData.asm */
	ofstream FontsDataFile;
	FontsDataFile.open("..\\..\\Intermediate\\Built\\SpriteBobs\\FontsData.asm");
	FontsDataFile << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_BMPSpacedFontToPreShifted(L"..\\..\\SourceData\\SpriteBobs\\Font-6x5.bmp", FontsDataFile, 5, 5, 32, 6);
	FontsDataFile.close();

	/* SpriteMultipex.asm */
	//; nb. OutputSpriteCode() will modify SpriteSinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	ofstream SpriteMultiplexFile;
	SpriteMultiplexFile.open("..\\..\\Intermediate\\Built\\SpriteBobs\\Multiplex.asm");
	SpriteMultiplexFile << "//; (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_OutputSpriteMultiplexCode(SpriteMultiplexFile, SpriteSinTableX, SpriteSinTableX_Output, SpriteSinTableY, SpriteSinTableY_Output);
	SpriteMultiplexFile.close();

	/* Debug Output Showing Us Where Sprites Will Be Drawn */
#if OUTPUT_SPRITELOCATION_DEBUGINFO
	ofstream SpritesPerRasterLine;
	SpritesPerRasterLine.open("..\\DEBUG-OUTPUT-SpritesPerRasterLine.txt");
	int SpriteMinY[NUM_SPRITES_TO_USE], SpriteMaxY[NUM_SPRITES_TO_USE];
	for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_TO_USE; SpriteIndex++)
	{
		int MinY = 1000000;
		int MaxY = 0;
		for (int FrameIndex = 0; FrameIndex < NUM_FRAMES_PER_SPRITE; FrameIndex++)
		{
			int StartY = SpriteSinTableY_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
			int EndY = StartY + 20;

			if (StartY < MinY)
			{
				MinY = StartY;
			}
			if (EndY > MaxY)
			{
				MaxY = EndY;
			}
		}
		SpriteMinY[SpriteIndex] = MinY;
		SpriteMaxY[SpriteIndex] = MaxY;
	}

	for (int RasterLine = 0; RasterLine < 255; RasterLine++)
	{
		int NumSpritesOnLine = 0;
		for (int SpriteIndex = 0; SpriteIndex < NUM_SPRITES_TO_USE; SpriteIndex++)
		{
			if ((SpriteMinY[SpriteIndex] <= RasterLine) && (SpriteMaxY[SpriteIndex] >= RasterLine))
			{
				if (NumSpritesOnLine == 0)
				{
					SpritesPerRasterLine << setw(2) << hex << setfill('0') << int(RasterLine) << setfill(' ') << ": ";
					for (int PreFillSpaces = 0; PreFillSpaces < SpriteIndex; PreFillSpaces++)
					{
						SpritesPerRasterLine << " ";
					}
				}
				SpritesPerRasterLine << setw(1) << int(1);
				NumSpritesOnLine++;
			}
			else
			{
				if (NumSpritesOnLine > 0)
				{
					SpritesPerRasterLine << " ";
				}
			}
		}
		if (NumSpritesOnLine > 0)
		{
			SpritesPerRasterLine << "//; " << dec << setw(2) << int(NumSpritesOnLine) << " sprites" << endl;
		}
	}
	SpritesPerRasterLine.close();
#endif //; OUTPUT_SPRITELOCATION_DEBUGINFO
	return 0;
}

