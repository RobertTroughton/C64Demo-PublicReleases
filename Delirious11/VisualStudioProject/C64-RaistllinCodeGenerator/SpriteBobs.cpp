// Delirious 11 .. (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"

#define OUTPUT_SPRITELOCATION_DEBUGINFO 1

#define SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION 1
#define SPRITEBOBS_DO_MULTIPASS_FIND_BEST_SHIFT 1
#define SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME 1
#define SPRITEBOBS_FONT_SIZE_X 6
#define SPRITEBOBS_FONT_SIZE_Y 5
#define SPRITEBOBS_FONT_NUM_CHARS 64 // Font6x5.bin

#define SPRITE_STRIDE 3 // All c64 sprites are 24 pixels wide ... so the "stride" is 3 bytes

#define NUM_CHARS_PER_SPRITE 3
#define NUM_FRAMES_PER_SPRITE 4


#define SPRITEBOBS_SIZE_SpriteSinTableXY ( 32 * NUM_CHARS_PER_SPRITE * NUM_FRAMES_PER_SPRITE )


static unsigned char SpriteBobs_ScrollTextStr[] = {
	"\xed               .   .  . ................. "
	"\xe1         Has it really been 27 years since Delirious 10?"
	"      \xe7       In 2018, we're proud to present to you the latest iteration in one of the longest running C64 demo series ever."
	"      \xe1       Enjoy the show!"
	"                                                                                                            "
};
static unsigned int SpriteBobs_ScrollTextStrSize = sizeof(SpriteBobs_ScrollTextStr) / sizeof(unsigned char);

void SpriteBobs_OutputScrollText(LPCTSTR OutputFilename)
{
	unsigned int WriteSize = 0;
	for (unsigned int Index = 0; Index < SpriteBobs_ScrollTextStrSize - 1; Index++)
	{
		unsigned char ByteValue = SpriteBobs_ScrollTextStr[Index];
		if ((ByteValue >= 0x61) && (ByteValue <= 0x7A))
		{
			ByteValue -= 0x20; // lower to uppercase conversion
		}
		if (ByteValue < 0xe0)
		{
			ByteValue &= 0x3f;
		}

		SpriteBobs_ScrollTextStr[WriteSize++] = ByteValue;
	}
	SpriteBobs_ScrollTextStr[WriteSize++] = 0xFF;
	WriteBinaryFile(OutputFilename, SpriteBobs_ScrollTextStr, WriteSize);
}

void SpriteBobs_Output6x5FontPreShifted(ofstream& file)
{
	ostringstream FontStream;
	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

	HANDLE hFile;
	DWORD  dwBytesRead = 0;
	OVERLAPPED ol = { 0 };

	hFile = CreateFile(L"..\\..\\SourceData\\font6x5.bin", // 6x5.raw"
		GENERIC_READ,
		FILE_SHARE_READ,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED,
		NULL);

	DWORD NumBytesRead;
	ReadFile(hFile, FileReadBuffer, FILE_READ_BUFFER_SIZE, &NumBytesRead, &ol);
	CloseHandle(hFile);

	int FontOutput = 0x2f00;

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

				for (int Character = 0; Character < 64; Character++)
				{
					if (Character >= SPRITEBOBS_FONT_NUM_CHARS)
					{
						FontStream << ".byte %00000000 ; unused";
						OUTPUT_CODE(FontStream, 0, 1, true);
					}
					else
					{
						FontStream << ".byte %";


						for (int XPos = XStart; XPos < XEnd; XPos++)
						{
							if (XPos < ShiftRight)
							{
								FontStream << "0";
							}
							else
							{
								if (XPos < (ShiftRight + SPRITEBOBS_FONT_SIZE_X))
								{
									int ReadXPos = XPos - ShiftRight;
									ReadXPos += 5; // Font6x5.bin
									int ReadYPos = YPos;
									ReadYPos += 5; // Font6x5.bin
									int ReadOffset = 0;

									ReadOffset += 2; // file header
									ReadOffset += Character * 8;
									ReadOffset += (ReadXPos / 8) * 0x200;
									ReadOffset += (ReadYPos / 8) * 0x400;
									ReadOffset += ReadYPos % 8;

									unsigned char ReadByte = FileReadBuffer[ReadOffset];
									unsigned int bitShift = 7 - (ReadXPos % 8);
									bool bSet = (ReadByte & (1 << bitShift)) != 0;
									if (bSet)
									{
										FontStream << "1";
									}
									else
									{
										FontStream << "0";
									}
								}
								else
								{
									FontStream << "0";
								}
							}
						}
						FontStream << " // Char '" << int(Character) << "', Y '" << int(YPos) << "', Shift '" << int(ShiftRight) << "'";
						OUTPUT_CODE(FontStream, 0, 1, true);
					}
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
	unsigned char TouchedMemory[NUM_FRAMES_PER_SPRITE][32][64];
	ZeroMemory(TouchedMemory, NUM_FRAMES_PER_SPRITE * 32 * 64);

	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

	ostringstream SpriteCodeStream;

	unsigned char CollisionTable[64];
	static unsigned char CollisionTable_BitMask[NUM_CHARS_PER_SPRITE] = { 0xFE, 0xFD, 0xFB };
	static unsigned char CollisionTable_BitWrite[NUM_CHARS_PER_SPRITE] = { 0x01, 0x02, 0x04 };

	SpriteCodeStream << "ScrollTextRead_Temp_Store:";
	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t.byte $00";
	OUTPUT_CODE(SpriteCodeStream, 0, 1, true);
	SpriteCodeStream << "ScrollTextRead_NewSpriteColor:";
	OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\t.byte $00";
	OUTPUT_CODE(SpriteCodeStream, 0, 1, true);

	TotalCycles = TotalSize = 0;
	TotalCycles = TotalSize = 0;
	SpriteCodeStream << "AdvanceCircleText:";															OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\tldy #$00";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "ACT_ScrollTextReadPtr:";														OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\tlda ScrollText";																OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tcmp #$FF";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tbne DontResetScrollTextPtr";													OUTPUT_CODE(SpriteCodeStream, 3, 2, true);
	SpriteCodeStream << "\tlda #$01";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsta Signal_ScrollerIsFinished";												OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tlda #<ScrollText";															OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsta ACT_ScrollTextReadPtr + 1";												OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tlda #>ScrollText";															OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsta ACT_ScrollTextReadPtr + 2";												OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tlda #$20";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tjmp ACT_WriteNewCharAndFinish";												OUTPUT_CODE(SpriteCodeStream, 4, 2, true);
	SpriteCodeStream << "DontResetScrollTextPtr:";														OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\tcmp #$e0";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tbcc NotAColorControl";														OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsec";																		OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsbc #$e0";																	OUTPUT_CODE(SpriteCodeStream, 2, 2, true);
	SpriteCodeStream << "\tsta ScrollTextRead_NewSpriteColor";											OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tlda #$20";																	OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "NotAColorControl:";															OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

	SpriteCodeStream << "\tinc ACT_ScrollTextReadPtr + 1";												OUTPUT_CODE(SpriteCodeStream, 6, 3, true);
	SpriteCodeStream << "\tbne ACT_WriteNewCharAndFinish";												OUTPUT_CODE(SpriteCodeStream, 3, 2, true);
	SpriteCodeStream << "\tinc ACT_ScrollTextReadPtr + 2";												OUTPUT_CODE(SpriteCodeStream, 6, 3, true);
	SpriteCodeStream << "ACT_WriteNewCharAndFinish:";													OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
	SpriteCodeStream << "\tsta ScrollTextRead_Frame0_Char35 + 1";										OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tsta ScrollTextRead_Frame1_Char35 + 1";										OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tsta ScrollTextRead_Frame2_Char35 + 1";										OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\tsta ScrollTextRead_Frame3_Char35 + 1";										OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
	SpriteCodeStream << "\trts";																		OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
	OUTPUT_BLANK_LINE();

	for (unsigned int FrameIndex = 0; FrameIndex < NUM_FRAMES_PER_SPRITE; FrameIndex++)
	{
		TotalCycles = TotalSize = 0;
		SpriteCodeStream << "DrawSprites_Frame" << FrameIndex << ":"; OUTPUT_CODE(SpriteCodeStream, 0, 0, true);
		OUTPUT_BLANK_LINE();

		for (unsigned int SpriteIndex = 0; SpriteIndex < 32; SpriteIndex++)
		{
			int CharIndex0 = SpriteIndex * NUM_CHARS_PER_SPRITE + 0;
			int CharIndex1 = SpriteIndex * NUM_CHARS_PER_SPRITE + 1;
			int CharIndex2 = SpriteIndex * NUM_CHARS_PER_SPRITE + 2;

			int PrevCharIndex0 = CharIndex0 - 1;
			int PrevCharIndex1 = CharIndex1 - 1;
			int PrevCharIndex2 = CharIndex2 - 1;

			unsigned int BestPass = 255;
			unsigned int BestCycles = 1000000;
			unsigned int CurrentPass = 0;

			bool bFinalPass = true;
#if SPRITEBOBS_DO_MULTIPASS_FIND_BEST_SHIFT
			bFinalPass = false;
#endif // SPRITEBOBS_DO_MULTIPASS_FIND_BEST_SHIFT
			bool bFinished = false;

			unsigned int StoredTotalCycles = TotalCycles;
			unsigned int StoredTotalSize = TotalSize;

			do
			{
				ZeroMemory(&CollisionTable[0], 64);

				TotalCycles = StoredTotalCycles;
				TotalSize = StoredTotalSize;

				SpriteCodeStream << "\t// Sprite $" << hex << setw(2) << setfill('0') << int(SpriteIndex) << setfill(' ');
				OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);

				unsigned int SpriteAddress = /*0x7800 +*/ (SpriteIndex * 64);

				unsigned int SinPositionX[NUM_CHARS_PER_SPRITE], SinPositionY[NUM_CHARS_PER_SPRITE];

				unsigned int MinSinPositionX = SpriteSinTableX_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
				unsigned int MinSinPositionY = SpriteSinTableY_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
				unsigned int XShift[NUM_CHARS_PER_SPRITE], XPos[NUM_CHARS_PER_SPRITE];
				for (unsigned int SIndex = 0; SIndex < NUM_CHARS_PER_SPRITE; SIndex++)
				{
					SinPositionX[SIndex] = SpriteSinTableX[((SpriteIndex * NUM_CHARS_PER_SPRITE) + SIndex) * NUM_FRAMES_PER_SPRITE + FrameIndex] - MinSinPositionX;
					SinPositionY[SIndex] = SpriteSinTableY[((SpriteIndex * NUM_CHARS_PER_SPRITE) + SIndex) * NUM_FRAMES_PER_SPRITE + FrameIndex] - MinSinPositionY;
					XShift[SIndex] = (SinPositionX[SIndex] + CurrentPass) % 8;
					XPos[SIndex] = (SinPositionX[SIndex] + CurrentPass) / 8;
				}

#if SPRITEBOBS_DO_MULTIPASS_FIND_BEST_SHIFT
				if (bFinalPass)
				{
					SpriteSinTableX_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex] -= CurrentPass;
				}
#endif // SPRITEBOBS_DO_MULTIPASS_FIND_BEST_SHIFT

				// Pass 1: Generate "Collision" Data
				for (unsigned int SpriteChar = 0; SpriteChar < NUM_CHARS_PER_SPRITE; SpriteChar++)
				{
					unsigned int WriteYStart = 0;
					unsigned int WriteHeight = SPRITEBOBS_FONT_SIZE_Y;
					if (SpriteIndex == 11)
					{
						if (SpriteChar == 2)
						{
							WriteHeight = 4 - FrameIndex; // TODO: if NUM_FRAMES_PER_SPRITE isn't 4 then this calculation won't be as expected...
						}
					}
					if (SpriteIndex == 12)
					{
						if (SpriteChar == 0) // we want to skip this one .. it's not needed
						{
							WriteHeight = 0;
						}
						if (SpriteChar == 1)
						{
							WriteYStart = 4 - FrameIndex; // TODO: as above
							WriteHeight = SPRITEBOBS_FONT_SIZE_Y - WriteYStart;
						}
					}

					for (unsigned int SpriteYPos = WriteYStart; SpriteYPos < (WriteYStart + WriteHeight); SpriteYPos++)
					{
						unsigned int WriteOffset = ((SpriteYPos + SinPositionY[SpriteChar]) * SPRITE_STRIDE) + XPos[SpriteChar];
						CollisionTable[WriteOffset] |= (1 << (SpriteChar * 2));
						if (XShift[SpriteChar] > (8 - SPRITEBOBS_FONT_SIZE_X))
						{
							CollisionTable[WriteOffset + 1] |= (2 << (SpriteChar * 2));
						}
					}
				}

				// Pass 2: Output Assembly
				for (unsigned int CollisionPass = 0; CollisionPass < 2; CollisionPass++)
				{
					if (CollisionPass == 0)
					{
						SpriteCodeStream << "\tScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex0) << ":";
						OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);
						SpriteCodeStream << "\tldy #$20";
						OUTPUT_CODE(SpriteCodeStream, 2, 2, bFinalPass);
						if (PrevCharIndex0 >= 0)
						{
							SpriteCodeStream << "\tsty ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(PrevCharIndex0) << " + 1";
						}
						else
						{
							SpriteCodeStream << "\tsty ScrollTextRead_Temp_Store";
						}
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);

						SpriteCodeStream << "\tScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex1) << ":";
						OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);
						SpriteCodeStream << "\tldx #$20";
						OUTPUT_CODE(SpriteCodeStream, 2, 2, bFinalPass);
						SpriteCodeStream << "\tstx ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(PrevCharIndex1) << " + 1";
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);

						unsigned char SpriteYPos[NUM_CHARS_PER_SPRITE] = { 0, 0, 0 };

						for (unsigned int WriteOffset = 0; WriteOffset < 63; WriteOffset++)
						{
							unsigned int CurrentYPos = WriteOffset / SPRITE_STRIDE;
							unsigned int WriteAddress = SpriteAddress + WriteOffset;
							unsigned char CollBits = CollisionTable[WriteOffset];

							if (!CollBits)
							{
								// skip unused bytes
								continue;
							}

							// on pass 1, we want to output any bytes which include char 1
							if ((CollBits & 0x03) == 0)
							{
								continue;
							}

							unsigned char Loop[NUM_CHARS_PER_SPRITE];
							for (unsigned int iLoop = 0; iLoop < NUM_CHARS_PER_SPRITE; iLoop++)
							{
								unsigned int Shift = iLoop * 2;
								unsigned char Mask = 0x03 << Shift;
								Loop[iLoop] = (((CollBits & Mask) >> Shift) == 0x01) ? 0 : 1;
							}

#if SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION
							if (CollBits & 0x0C) // TODO: Hacky
							{
								SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[0]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[0]) << "_Loop" << int(Loop[0]) << ",y";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tora Font6x5_Shift" << hex << setw(1) << int(XShift[1]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[1]) << "_Loop" << int(Loop[1]) << ",x";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							}
							else
							{
								SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[0]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[0]) << "_Loop" << int(Loop[0]) << ",y";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							}
							SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
							OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
#else // SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION
							if (CollBits & 0x0C) // TODO: Hacky
							{
								SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[0]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[0]) << "_Loop" << int(Loop[0]) << ",y";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tlda CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[0]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[0]) << "_Loop" << int(Loop[0]) << ",y";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tora Font6x5_Shift" << hex << setw(1) << int(XShift[1]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[1]) << "_Loop" << int(Loop[1]) << ",x";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							}
							else
							{
								SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[0]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[0]) << "_Loop" << int(Loop[0]) << ",y";
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							}
#endif // SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION

							if (bFinalPass)
							{
								TouchedMemory[FrameIndex][SpriteIndex][WriteOffset] = 1;
							}
						}
					}
					else
					{
						SpriteCodeStream << "\tScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(CharIndex2) << ":";
						OUTPUT_CODE(SpriteCodeStream, 0, 0, bFinalPass);
						SpriteCodeStream << "\tldy #$20";
						OUTPUT_CODE(SpriteCodeStream, 2, 2, bFinalPass);
						SpriteCodeStream << "\tsty ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(PrevCharIndex2) << " + 1";
						OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);

						for (unsigned int WriteOffset = 0; WriteOffset < 63; WriteOffset++)
						{
							unsigned int CurrentYPos = WriteOffset / SPRITE_STRIDE;
							unsigned int WriteAddress = SpriteAddress + WriteOffset;
							unsigned char CollBits = CollisionTable[WriteOffset];

							if (!CollBits)
							{
								// skip unused bytes
								continue;
							}

							unsigned char Loop[NUM_CHARS_PER_SPRITE];
							for (unsigned int iLoop = 0; iLoop < NUM_CHARS_PER_SPRITE; iLoop++)
							{
								unsigned int Shift = iLoop * 2;
								unsigned char Mask = 0x03 << Shift;
								Loop[iLoop] = (((CollBits & Mask) >> Shift) == 0x01) ? 0 : 1;
							}

							// on pass 2, we want to output only bytes which weren't finished in pass 1
							// that is, any bytes which had char 0 but not char 2
							if (CollBits & 3) // TODO: HACK
							{
								// where a byte had char 0 and char 2, we have a (hopefully) rare special case...
								if (CollBits & 0x30) // TODO: HACK
								{
									SpriteCodeStream << "\tlda CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tora Font6x5_Shift" << hex << setw(1) << int(XShift[2]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[2]) << "_Loop" << int(Loop[2]) << ",y";
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								}
								continue;
							}
							else
							{
#if SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION
								if ((CollBits & 0x0C) && (CollBits & 0x30)) // TODO: HACK
								{
									SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[1]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[1]) << "_Loop" << int(Loop[1]) << ",x";
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tora Font6x5_Shift" << hex << setw(1) << int(XShift[2]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[2]) << "_Loop" << int(Loop[2]) << ",y";
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								}
#else // SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION
								if ((CollBits & 0x0C) && (CollBits & 0x30)) // TODO: HACK
								{
									SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[1]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[1]) << "_Loop" << int(Loop[1]) << ",x";
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tlda CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									SpriteCodeStream << "\tora Font6x5_Shift" << hex << setw(1) << int(XShift[2]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[2]) << "_Loop" << int(Loop[2]) << ",y";
									OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
								}

#endif // SPRITEBOBS_DO_REDUCED_RELOAD_OPTMIZATION
								else
								{
									if (CollBits & 0x0C) // TODO: HACK
									{
										SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[1]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[1]) << "_Loop" << int(Loop[1]) << ",x";
										OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									}
									else
									{
										SpriteCodeStream << "\tlda Font6x5_Shift" << hex << setw(1) << int(XShift[2]) << "_Y" << hex << setw(1) << int(CurrentYPos - SinPositionY[2]) << "_Loop" << int(Loop[2]) << ",y";
										OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
									}
								}
								SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(WriteAddress) << setfill(' ');
								OUTPUT_CODE(SpriteCodeStream, 4, 3, bFinalPass);
							}

							if (bFinalPass)
							{
								TouchedMemory[FrameIndex][SpriteIndex][WriteOffset] = 1;
							}
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
		SpriteCodeStream << "\tlda ScrollTextRead_Temp_Store";
		OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
		SpriteCodeStream << "\tsta ScrollTextRead_Frame" << dec << int(FrameIndex) << "_Char" << dec << int(95) << " + 1";
		OUTPUT_CODE(SpriteCodeStream, 4, 3, true);

#if SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
		SpriteCodeStream << "\tjmp ClearUnusedBytesThatWereUsedByPreviousFrame_Frame" << int(FrameIndex);
		OUTPUT_CODE(SpriteCodeStream, 3, 3, true);
		OUTPUT_BLANK_LINE();
#else // SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
		SpriteCodeStream << "\trts";
		OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
#endif // SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
	}

#if SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
	for (unsigned int FrameIndex = 0; FrameIndex < 4; FrameIndex++)
	{
		TotalCycles = TotalSize = 0;

		SpriteCodeStream << "ClearUnusedBytesThatWereUsedByPreviousFrame_Frame" << int(FrameIndex) << ":";
		OUTPUT_CODE(SpriteCodeStream, 0, 0, true);

		SpriteCodeStream << "\tlda #$00";
		OUTPUT_CODE(SpriteCodeStream, 2, 2, true);

		unsigned int PreviousFrameIndex = (FrameIndex + 2) & 3; // TODO: HACK
		for (unsigned int SpriteIndex = 0; SpriteIndex < 32; SpriteIndex++)
		{
			unsigned int SpriteAddress = /*0x7800 +*/ (SpriteIndex * 64);
			for (unsigned int WriteOffset = 0; WriteOffset < 63; WriteOffset++)
			{
				unsigned char WillTouchThisFrame = TouchedMemory[FrameIndex][SpriteIndex][WriteOffset];
				unsigned char WasTouchedLastFrame = TouchedMemory[PreviousFrameIndex][SpriteIndex][WriteOffset];
				if (WasTouchedLastFrame && !WillTouchThisFrame)
				{
					SpriteCodeStream << "\tsta CircleSpriteWriteAddress" << dec << int(FrameIndex & 1) << " + $" << hex << setw(4) << setfill('0') << int(SpriteAddress + WriteOffset) << " // SPR $" << hex << setw(2) << int(SpriteIndex) << setfill(' ');
					OUTPUT_CODE(SpriteCodeStream, 4, 3, true);
				}
			}
		}
		SpriteCodeStream << "\trts";
		OUTPUT_CODE(SpriteCodeStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
#endif // SPRITEBOBS_DO_CLEAR_UNUSED_BYTES_BY_PREVIOUS_FRAME
}

void SpriteBobs_OutputSpriteMultiplexCode(ofstream& file, int* SpriteSinTableX, int* SpriteSinTableX_Output, int* SpriteSinTableY, int* SpriteSinTableY_Output)
{
	class SpriteSetup
	{
	public:
		unsigned int NumberOfSpritesToUpdate;
		class SpriteData
		{
		public:
			unsigned int OutputIndex;
			unsigned int InputIndex;
		} SpriteDataArray[8];
	};

	static SpriteSetup MySpriteSetup[] = {
		// nb. OutputIndex's MUST be in order of lowest-to-highest within each line
		{ 8,{ { 0,0 },{ 1,1 },{ 2,2 },{ 3,3 },{ 4,4 },{ 5,5 },{ 6,6 },{ 7,7 } } },
		{ 4,{ { 2,30 },{ 3,31 },{ 4,8 },{ 5,9 }, } },
		{ 4,{ { 0,28 },{ 1,29 },{ 6,10 },{ 7,11 }, } },
		{ 4,{ { 2,26 },{ 3,27 },{ 4,12 },{ 5,13 }, } },
		{ 4,{ { 0,24 },{ 1,25 },{ 6,14 },{ 7,15 }, } },
		{ 4,{ { 2,22 },{ 3,23 },{ 4,16 },{ 5,17 }, } },
		{ 4,{ { 0,20 },{ 1,21 },{ 6,18 },{ 7,19 }, } },
	};
	static unsigned int NumSpriteSections = sizeof(MySpriteSetup) / sizeof(SpriteSetup);

	unsigned int TotalCycles = 0;
	unsigned int TotalSize = 0;

	ostringstream SpriteMultiplexStream;

	SpriteMultiplexStream << "// SpriteMultiplexor";
	OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (unsigned int Frame = 0; Frame < NUM_FRAMES_PER_SPRITE; Frame++)
	{
		SpriteMultiplexStream << "// Frame " << dec << Frame;
		OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

		for (unsigned int Section = 0; Section < NumSpriteSections; Section++)
		{
			SpriteMultiplexStream << "\tSpriteMultiplex_Frame" << dec << int(Frame) << "_Section" << dec << int(Section) << ":";
			OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

			SpriteMultiplexStream << "\t\tlda #$00";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);

			SpriteMultiplexStream << "\t\tsta SpriteMSBValue";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 2, true);
			OUTPUT_BLANK_LINE();

			unsigned int NumRORs = 0;
			unsigned char RORMap = 0;

			unsigned int RORIndex = MySpriteSetup[Section].SpriteDataArray[0].OutputIndex;

			for (unsigned int Sprite = 0; Sprite < MySpriteSetup[Section].NumberOfSpritesToUpdate; Sprite++)
			{
				unsigned int RORExtras = MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex - RORIndex;
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

				SpriteMultiplexStream << "\t\t// Sprite:" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << ", Value:" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex;
				OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

				SpriteMultiplexStream << "\t\t\tlda #$" << hex << setw(2) << setfill('0') << int(SpriteSinTableX_Output[MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex * NUM_FRAMES_PER_SPRITE + Frame]) << setfill(' ');
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tclc";
				OUTPUT_CODE(SpriteMultiplexStream, 2, 1, true);

				SpriteMultiplexStream << "\t\t\tadc XSpriteCircleMovement";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tsta spriteX + (" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << " * 2)";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tror SpriteMSBValue";
				OUTPUT_CODE(SpriteMultiplexStream, 5, 2, true);
				RORIndex++;

				SpriteMultiplexStream << "\t\t\tlda #$" << hex << setw(2) << setfill('0') << int(SpriteSinTableY_Output[MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex * NUM_FRAMES_PER_SPRITE + Frame]) << setfill(' ');
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta spriteY + (" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << " * 2)";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\t\t\tlda #(SpriteCircleBaseSprite" << dec << int(Frame & 1) << " + " << dec << int(MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex) << " )";
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta SPRITE" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex << "_Val_Bank0";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

				SpriteMultiplexStream << "\tSM_Frame" << dec << Frame << "_SPRITE" << dec << MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex << "_Color:";
				OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

				SpriteMultiplexStream << "\t\t\tlda #" << dec << int((MySpriteSetup[Section].SpriteDataArray[Sprite].InputIndex / 8) + 1);
				OUTPUT_CODE(SpriteMultiplexStream, 2, 2, true);

				SpriteMultiplexStream << "\t\t\tsta SPRITE" << dec << int(MySpriteSetup[Section].SpriteDataArray[Sprite].OutputIndex) << "_Color";
				OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);
				
				OUTPUT_BLANK_LINE();
			}

			unsigned int RORExtras = 8 - RORIndex;
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
				SpriteMultiplexStream << "\t\t\tlda spriteXMSB";
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
			SpriteMultiplexStream << "\t\t\tsta spriteXMSB";
			OUTPUT_CODE(SpriteMultiplexStream, 4, 3, true);

			SpriteMultiplexStream << "\t\t\trts";
			OUTPUT_CODE(SpriteMultiplexStream, 6, 1, true);
			OUTPUT_BLANK_LINE();
		}
		OUTPUT_BLANK_LINE();
	}


	SpriteMultiplexStream << "// Color Scroll Functions";
	OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);
	OUTPUT_BLANK_LINE();

	for (unsigned int Frame = 0; Frame < NUM_FRAMES_PER_SPRITE; Frame++)
	{
		SpriteMultiplexStream << "\tDrawSprite_ColorScroll_Frame" << dec << Frame << ":";
		OUTPUT_CODE(SpriteMultiplexStream, 0, 0, true);

		for (unsigned int SpriteIndex = 0; SpriteIndex < 31; SpriteIndex++)
		{
			unsigned int SpriteReadIndex = (SpriteIndex + 13) % 32;
			unsigned int SpriteWriteIndex = (SpriteIndex + 12) % 32;
			SpriteMultiplexStream << "\t\tlda SM_Frame" << dec << Frame << "_SPRITE" << dec << int(SpriteReadIndex) << "_Color + 1";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
			SpriteMultiplexStream << "\t\tsta SM_Frame" << dec << Frame << "_SPRITE" << dec << int(SpriteWriteIndex) << "_Color + 1";
			OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		}
		SpriteMultiplexStream << "\t\tlda ScrollTextRead_NewSpriteColor";
		OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		SpriteMultiplexStream << "\t\tsta SM_Frame" << dec << Frame << "_SPRITE" << dec << int(11) << "_Color + 1";
		OUTPUT_CODE(SpriteMultiplexStream, 3, 3, true);
		SpriteMultiplexStream << "\t\trts";
		OUTPUT_CODE(SpriteMultiplexStream, 6, 1, true);
		OUTPUT_BLANK_LINE();
	}
}

int SpriteBobs_Main(void)
{
	int SpriteSinTableX[SPRITEBOBS_SIZE_SpriteSinTableXY];
	int SpriteSinTableY[SPRITEBOBS_SIZE_SpriteSinTableXY];
	int SpriteSinTableXMovement[128];
	GenerateSinTable(SPRITEBOBS_SIZE_SpriteSinTableXY, 8, 231, 16 * NUM_CHARS_PER_SPRITE, SpriteSinTableX);
	GenerateSinTable(SPRITEBOBS_SIZE_SpriteSinTableXY, 50/*38*/, 240, 48 * NUM_CHARS_PER_SPRITE, SpriteSinTableY);
	GenerateSinTable(128, 26, 96, 0, SpriteSinTableXMovement);

	int SpriteSinTableX_Output[128 + 128];
	int SpriteSinTableY_Output[128 + 128];
	for (unsigned int OutputIndex = 0; OutputIndex < 128; OutputIndex++)
	{
		unsigned int SpriteIndex = OutputIndex / NUM_FRAMES_PER_SPRITE;
		unsigned int FrameIndex = OutputIndex % NUM_FRAMES_PER_SPRITE;

// TODO: HACK
		unsigned int ReadIndex0 = FrameIndex + ((SpriteIndex * NUM_CHARS_PER_SPRITE) + 0) * NUM_FRAMES_PER_SPRITE;
		unsigned int ReadIndex1 = FrameIndex + ((SpriteIndex * NUM_CHARS_PER_SPRITE) + 1) * NUM_FRAMES_PER_SPRITE;
		unsigned int ReadIndex2 = FrameIndex + ((SpriteIndex * NUM_CHARS_PER_SPRITE) + 2) * NUM_FRAMES_PER_SPRITE;

		int MinSinX = min(SpriteSinTableX[ReadIndex0], min(SpriteSinTableX[ReadIndex1], SpriteSinTableX[ReadIndex2]));
		int MinSinY = min(SpriteSinTableY[ReadIndex0], min(SpriteSinTableY[ReadIndex1], SpriteSinTableY[ReadIndex2]));
		SpriteSinTableX_Output[OutputIndex] = MinSinX;
		SpriteSinTableY_Output[OutputIndex] = MinSinY;
	}

	unsigned char cSpriteSinTableXMovement[128];
	for (unsigned int SinIndex = 0; SinIndex < 128; SinIndex++)
	{
		cSpriteSinTableXMovement[SinIndex] = (unsigned char)SpriteSinTableXMovement[SinIndex];
	}
	WriteBinaryFile(L"..\\..\\Intermediate\\Built\\SpriteBobs-SinTable-XSpriteMovement128.bin", cSpriteSinTableXMovement, 128);

	/* ScrollText.bin */
	SpriteBobs_OutputScrollText(L"..\\..\\Intermediate\\Built\\SpriteBobs-ScrollText.bin");

	/* SpriteDrawing.asm */
	// nb. OutputSpriteCode() will modify SpriteSinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	ofstream SpriteDrawingFile;
	SpriteDrawingFile.open("..\\..\\Intermediate\\Built\\SpriteBobs-Draw.asm");
	SpriteDrawingFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_OutputSpriteCode(SpriteDrawingFile, SpriteSinTableX, SpriteSinTableX_Output, SpriteSinTableY, SpriteSinTableY_Output);
	SpriteDrawingFile.close();

	/* FontsData.asm */
	ofstream FontsDataFile;
	FontsDataFile.open("..\\..\\Intermediate\\Built\\SpriteBobs-FontsData.asm");
	FontsDataFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_Output6x5FontPreShifted(FontsDataFile);
	FontsDataFile.close();

	/* SpriteMultipex.asm */
	// nb. OutputSpriteCode() will modify SpriteSinTableX_Output as it will move the sprites slightly (up to 7 pixels) to find the most optimal way to blit
	ofstream SpriteMultiplexFile;
	SpriteMultiplexFile.open("..\\..\\Intermediate\\Built\\SpriteBobs-Multiplex.asm");
	SpriteMultiplexFile << "// Delirious 11 .. (c) 2018, Raistlin / Genesis*Project" << endl << endl;
	SpriteBobs_OutputSpriteMultiplexCode(SpriteMultiplexFile, SpriteSinTableX, SpriteSinTableX_Output, SpriteSinTableY, SpriteSinTableY_Output);
	SpriteMultiplexFile.close();

	/* Debug Output Showing Us Where Sprites Will Be Drawn */
#if OUTPUT_SPRITELOCATION_DEBUGINFO
	ofstream SpritesPerRasterLine;
	SpritesPerRasterLine.open("..\\..\\Intermediate\\DEBUG-OUTPUT-SpritesPerRasterLine.txt");
	unsigned int SpriteMinY[32], SpriteMaxY[32];
	for (unsigned int SpriteIndex = 0; SpriteIndex < 32; SpriteIndex++)
	{
		unsigned int MinY = 1000000;
		unsigned int MaxY = 0;
		for (unsigned int FrameIndex = 0; FrameIndex < NUM_FRAMES_PER_SPRITE; FrameIndex++)
		{
			unsigned int StartY = SpriteSinTableY_Output[SpriteIndex * NUM_FRAMES_PER_SPRITE + FrameIndex];
			unsigned int EndY = StartY + 20;

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

	for (unsigned int RasterLine = 0; RasterLine < 255; RasterLine++)
	{
		int NumSpritesOnLine = 0;
		for (unsigned int SpriteIndex = 0; SpriteIndex < 32; SpriteIndex++)
		{
			if ((SpriteMinY[SpriteIndex] <= RasterLine) && (SpriteMaxY[SpriteIndex] >= RasterLine))
			{
				if (NumSpritesOnLine == 0)
				{
					SpritesPerRasterLine << setw(2) << hex << setfill('0') << int(RasterLine) << setfill(' ') << ": ";
					for (unsigned int PreFillSpaces = 0; PreFillSpaces < SpriteIndex; PreFillSpaces++)
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
#endif // OUTPUT_SPRITELOCATION_DEBUGINFO
	return 0;
}

