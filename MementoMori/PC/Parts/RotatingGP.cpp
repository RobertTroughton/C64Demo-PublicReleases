// (c) 2018-2020, Genesis*Project


//; TODO: optimise sprite memory:-
//;		- change the sprite X/MSB code so that the sprites only scroll by 0-47 pixels... and then update SpriteVals instead to scroll!
//;		- look for duplicate sprites and remove them
//;		- split the sprite data into the 2 banks
//;		- weave the sprite data into screen memory where possible?

#include <atlstr.h>

#include "..\Common\Common.h"

constexpr auto ANIM_FRAME_PIXEL_WIDTH = 192;
constexpr auto ANIM_FRAME_PIXEL_HEIGHT = 189;
constexpr auto ANIM_FRAME_CHAR_WIDTH = ANIM_FRAME_PIXEL_WIDTH / 8;

unsigned char UncompressedAnimData[ANIM_FRAME_PIXEL_HEIGHT * ANIM_FRAME_CHAR_WIDTH][16];	//; HACK! 16 is NumAnims
unsigned char CompressedAnimData[ANIM_FRAME_PIXEL_HEIGHT * ANIM_FRAME_CHAR_WIDTH][16];	//; HACK! 16 is NumAnims

class INTERLEAVELOOKUP
{
public:
	int Num;
	int DstY[2];
} InterleaveLookups[256];


constexpr auto MAX_SPRITE_BLITS = 65536;
class SPRITEBLITS
{
public:
	int BlitDataOffset;
	int SRCYPixelPos;
	int DSTXCharPos;
	int DSTYPixelPos;
} SpriteBlits[2][MAX_SPRITE_BLITS];

void RotatingGP_InterleaveSprites(char* SRCFilename, LPTSTR DSTFilename)
{
	GPIMAGE SRCImg(SRCFilename);

	ZeroMemory(InterleaveLookups, sizeof(InterleaveLookups));

	int IMGWidth = SRCImg.Width;
	int IMGCharWidth = (int)(IMGWidth / 8);

	int SRCIMGHeight = SRCImg.Height;
	int DSTIMGHeight = (int)(SRCIMGHeight + 21);

	int NumSpritesNeeded = ((DSTIMGHeight + 20) / 21) * 8;
	int SizeOutBIN = NumSpritesNeeded * 64;
	unsigned char* OutBIN = new unsigned char[SizeOutBIN];
	ZeroMemory(OutBIN, SizeOutBIN);

	for (int YPos = 0; YPos < DSTIMGHeight; YPos++)
	{
		int DST_Y = YPos;

		int YSpriteRow = YPos / 21;

		int SRC_MinY = YSpriteRow * 20;
		int SRC_MaxY = (YSpriteRow + 1) * 20;

		int SRC_Y = YPos;
		if (SRC_Y > SRC_MaxY)
		{
			SRC_Y -= 21;
		}

		if (SRC_Y >= SRCIMGHeight)
		{
			continue;
		}

		InterleaveLookups[SRC_Y].DstY[InterleaveLookups[SRC_Y].Num] = DST_Y;
		InterleaveLookups[SRC_Y].Num++;

		for (int XCharPos = 0; XCharPos < IMGCharWidth; XCharPos++)
		{
			unsigned char OutChar = 0;
			for (int XPixel = 0; XPixel < 8; XPixel++)
			{
				int XPos = (XCharPos * 8) + XPixel;

				unsigned int Colour = SRCImg.GetPixel(XPos, SRC_Y);
				if (Colour != 0x000000)
				{
					OutChar |= 1 << (7 - XPixel);
				}
			}
			int OutSpriteIndex = (YPos / 21) * 8 + XCharPos / 3;
			int WriteOffset = (YPos % 21) * 3 + (XCharPos % 3);
			OutBIN[OutSpriteIndex * 64 + WriteOffset] = OutChar;
		}
	}
	WriteBinaryFile(DSTFilename, OutBIN, SizeOutBIN);
}

void RotatingGP_ConvertSprites(char* SRCFilename, LPTSTR DrawSpriteASM, LPTSTR BlitDataBIN)
{
	ZeroMemory(UncompressedAnimData, sizeof(UncompressedAnimData));
	ZeroMemory(CompressedAnimData, sizeof(CompressedAnimData));
	ZeroMemory(SpriteBlits, sizeof(SpriteBlits));

	CodeGen DrawSpriteCode(DrawSpriteASM);

	GPIMAGE SRCImg(SRCFilename);

	int SRCWidth = SRCImg.Width;
	int SRCHeight = SRCImg.Height;
	int SRCCharWidth = SRCWidth / 8;

	GPIMAGE DSTHitImg(SRCWidth, SRCHeight);

	int NumAnimsX = SRCWidth / ANIM_FRAME_PIXEL_WIDTH;
	int NumAnimsY = SRCHeight / ANIM_FRAME_PIXEL_HEIGHT;

	int NumAnims = NumAnimsX * NumAnimsY;

	int NumUniqueAnimDatas = 0;

	int NumSpriteBlits[2] = {0, 0};

	int NumBlitLinesPerHalf = (ANIM_FRAME_PIXEL_HEIGHT / 2);

	for (int BlitCallIndex = 0; BlitCallIndex < 2; BlitCallIndex++)
	{
		int NumBlits = 0;
		for (int YPos = 0; YPos < SRCHeight; YPos++)
		{
			for (int XCharPos = 0; XCharPos < SRCCharWidth; XCharPos++)
			{
				unsigned char CurrentByte = 0;
				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XCharPos * 8 + XPixel;

					unsigned int Colour = SRCImg.GetPixel(XPos, YPos);
					if (Colour != 0x000000)
					{
						CurrentByte |= (1 << (7 - XPixel));
					}

					DSTHitImg.SetPixel(XPos, YPos, Colour);
				}

				int AnimIndex = ((YPos / ANIM_FRAME_PIXEL_HEIGHT) * NumAnimsX) + (XCharPos / ANIM_FRAME_CHAR_WIDTH);
				int OutputByteIndex = ((YPos % ANIM_FRAME_PIXEL_HEIGHT) * ANIM_FRAME_CHAR_WIDTH) + (XCharPos % ANIM_FRAME_CHAR_WIDTH);
				UncompressedAnimData[OutputByteIndex][AnimIndex] = CurrentByte;
			}
		}

		for (int YPos = 0; YPos < ANIM_FRAME_PIXEL_HEIGHT; YPos++)
		{
			for (int XCharPos = 0; XCharPos < ANIM_FRAME_CHAR_WIDTH; XCharPos++)
			{
				int OutputByteIndex = YPos * ANIM_FRAME_CHAR_WIDTH + XCharPos;

				unsigned char FirstByte = UncompressedAnimData[OutputByteIndex][0];
				bool bMatch = true;
				for (int AnimIndex = 1; AnimIndex < NumAnims; AnimIndex++)
				{
					unsigned char CurrentByte = UncompressedAnimData[OutputByteIndex][AnimIndex];
					if (CurrentByte != FirstByte)
					{
						bMatch = false;
						break;
					}
				}

				for (int XPixel = 0; XPixel < 8; XPixel++)
				{
					int XPos = XCharPos * 8 + XPixel;
					unsigned int NewColour = DSTHitImg.GetPixel(XPos, YPos);
					if (bMatch)
					{
						NewColour |= 0x000000ff;
					}
					else
					{
						NewColour |= 0x00ff0000;
					}
					DSTHitImg.SetPixel(XPos, YPos, NewColour);
				}

				if (!bMatch)
				{
					int DupeIndex = -1;
					for (int DupeCheckIndex = 0; DupeCheckIndex < NumUniqueAnimDatas; DupeCheckIndex++)
					{
						if (memcmp(CompressedAnimData[DupeCheckIndex], UncompressedAnimData[OutputByteIndex], NumAnims) == 0)
						{
							DupeIndex = DupeCheckIndex;
							break;
						}
					}
					if (DupeIndex == -1)
					{
						DupeIndex = NumUniqueAnimDatas;
						memcpy(CompressedAnimData[DupeIndex], UncompressedAnimData[OutputByteIndex], NumAnims);
						NumUniqueAnimDatas++;
					}

					for (int YRowIndex = 0; YRowIndex < InterleaveLookups[YPos].Num; YRowIndex++)
					{
						int DSTYPos = InterleaveLookups[YPos].DstY[YRowIndex];
						int DstHalf = (YPos < NumBlitLinesPerHalf) ? 0 : 1;

						if (DstHalf == BlitCallIndex)
						{
							SpriteBlits[BlitCallIndex][NumBlits].BlitDataOffset = DupeIndex * NumAnims;
							SpriteBlits[BlitCallIndex][NumBlits].SRCYPixelPos = YPos;
							SpriteBlits[BlitCallIndex][NumBlits].DSTXCharPos = XCharPos;
							SpriteBlits[BlitCallIndex][NumBlits].DSTYPixelPos = DSTYPos;
							NumBlits++;
						}
					}
				}
			}
		}
		NumSpriteBlits[BlitCallIndex] = NumBlits;
	}

	for (int BlitCallIndex = 0; BlitCallIndex < 2; BlitCallIndex++)
	{
		DrawSpriteCode.OutputFunctionLine(fmt::format("BlitRotatingGP{:d}", BlitCallIndex));

		int StartY = (BlitCallIndex + 0) * NumBlitLinesPerHalf;
		int EndY = (BlitCallIndex + 1) * NumBlitLinesPerHalf;

		for (int YPos = StartY; YPos < EndY; YPos++)
		{
			int SrcY = (BlitCallIndex == 0) ? YPos : (ANIM_FRAME_PIXEL_HEIGHT - 1 - YPos) + NumBlitLinesPerHalf;
			for (int Index = 0; Index < NumSpriteBlits[BlitCallIndex]; Index++)
			{
				SPRITEBLITS& rBlit = SpriteBlits[BlitCallIndex][Index];
				if (rBlit.SRCYPixelPos == SrcY)
				{
					int SpriteIndex = (rBlit.DSTYPixelPos / 21) * 8 + rBlit.DSTXCharPos / 3;
					int SpriteDataOffset = (rBlit.DSTYPixelPos % 21) * 3 + (rBlit.DSTXCharPos % 3);
					DrawSpriteCode.OutputCodeLine(LDA_ABX, fmt::format("BlitDataAddress + {:5d}", rBlit.BlitDataOffset));
					DrawSpriteCode.OutputCodeLine(STA_ABS, fmt::format("SpriteMem + ({:d} * 64) + {:d}", SpriteIndex, SpriteDataOffset));
				}
			}
		}

		DrawSpriteCode.OutputCodeLine(RTS);
		DrawSpriteCode.OutputBlankLine();
		DrawSpriteCode.OutputBlankLine();
	}
	WriteBinaryFile(BlitDataBIN, CompressedAnimData, NumUniqueAnimDatas * NumAnims);

	DSTHitImg.Write("Out\\6502\\Parts\\RotatingGP\\HitImage.png");
}

void RotatingGP_OutputColourFadeTables(LPTSTR FramesDarkerBINFilename)
{
	unsigned char FramesDarker4[16] = { 0x00, 0x09, 0x00, 0x09, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x09 };
	unsigned char FramesDarker3[16] = { 0x00, 0x04, 0x00, 0x02, 0x00, 0x09, 0x00, 0x02, 0x00, 0x00, 0x09, 0x00, 0x09, 0x02, 0x09, 0x02 };
	unsigned char FramesDarker2[16] = { 0x00, 0x03, 0x00, 0x04, 0x09, 0x02, 0x00, 0x08, 0x09, 0x00, 0x02, 0x00, 0x02, 0x04, 0x02, 0x08 };
	unsigned char FramesDarker1[16] = { 0x00, 0x0d, 0x09, 0x0c, 0x02, 0x08, 0x00, 0x05, 0x02, 0x00, 0x08, 0x09, 0x04, 0x03, 0x04, 0x0f };

	unsigned char FramesDarker[4][256];
	for (unsigned char HiChar = 0; HiChar < 16; HiChar++)
	{
		for (unsigned char LoChar = 0; LoChar < 16; LoChar++)
		{
			FramesDarker[3][HiChar * 16 + LoChar] = FramesDarker4[LoChar] | (FramesDarker4[HiChar] << 4);
			FramesDarker[2][HiChar * 16 + LoChar] = FramesDarker3[LoChar] | (FramesDarker3[HiChar] << 4);
			FramesDarker[1][HiChar * 16 + LoChar] = FramesDarker2[LoChar] | (FramesDarker2[HiChar] << 4);
			FramesDarker[0][HiChar * 16 + LoChar] = FramesDarker1[LoChar] | (FramesDarker1[HiChar] << 4);
		}
	}

	WriteBinaryFile(FramesDarkerBINFilename, FramesDarker, sizeof(FramesDarker));
}

int RotatingGP_Main()
{
	RotatingGP_OutputColourFadeTables(L"Out\\6502\\Parts\\RotatingGP\\FramesDarker.bin");
		
	RotatingGP_InterleaveSprites("6502\\Parts\\RotatingGP\\Data\\RotatingGP-Base.png", L"Out\\6502\\Parts\\RotatingGP\\BaseSpritesInterleaved.bin");
	RotatingGP_ConvertSprites("6502\\Parts\\RotatingGP\\Data\\RotatingGP.png", L"Out\\6502\\Parts\\RotatingGP\\DrawSprite.asm", L"Out\\6502\\Parts\\RotatingGP\\BlitData.bin");

	int XPosSinTable[256];
	GenerateSinTable(256, 0, 128, 0, XPosSinTable);

	int NewXPosSinTable[256];

	unsigned char cXPosSinTable[4][256];
	for (int Index = 0; Index < 256; Index++)
	{
		int Index0 = ((Index + 45) * 3) % 256;
		int Index1 = (Index * 2) % 256;

		NewXPosSinTable[Index] = (XPosSinTable[Index0] + XPosSinTable[Index1]) / 2 + 24;
	}


	for (int Index = 0; Index < 256; Index++)
	{
		int XPos = NewXPosSinTable[Index];

		unsigned char XMSB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			int SpriteXPos = XPos + SpriteIndex * 24;
			if (SpriteXPos >= 256)
			{
				XMSB |= (1 << SpriteIndex);
			}
		}
		cXPosSinTable[0][Index] = (unsigned char)XPos;
		cXPosSinTable[1][Index] = XMSB;
	}

	for (int Index = 0; Index < 128; Index++)
	{
		double dStartX = 344.0;
		double dIndex = (double)Index;
		double dXPos = (double)NewXPosSinTable[Index];
		dXPos = (((127.0 - dIndex) * dStartX) + dIndex * dXPos) / 128.0;

		int XPos = (int)dXPos;

		if (XPos > 344)
		{
			XPos = 344;
		}

		unsigned char XMSB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			int SpriteXPos = XPos + SpriteIndex * 24;
			if (SpriteXPos >= 256)
			{
				XMSB |= (1 << SpriteIndex);
			}
		}
		cXPosSinTable[2][Index +   0] = (unsigned char)XPos;
		cXPosSinTable[2][Index + 128] = XMSB;
	}
		
	for (int Index = 0; Index < 128; Index++)
	{
		double dEndX = -168.0;
		double dIndex = (double)Index;
		double dXPos = (double)NewXPosSinTable[Index];
		dXPos = (((127.0 - dIndex) * dXPos) + dIndex * dEndX) / 128.0;

		int XPos = (int)dXPos;

		unsigned char XMSB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			int SpriteXPos = XPos + SpriteIndex * 24;

			if (SpriteXPos < 0)
			{
				SpriteXPos += 512;
			}
			if (SpriteXPos >= 256)
			{
				XMSB |= (1 << SpriteIndex);
			}
		}
		if (XPos < 0)
		{
			XPos += 512;
		}
		cXPosSinTable[3][Index + 0] = (unsigned char)XPos;
		cXPosSinTable[3][Index + 128] = XMSB;
	}

	WriteBinaryFile(L"Out\\6502\\Parts\\RotatingGP\\XPosSinTable.bin", cXPosSinTable, 256 * 4);

	return 0;
}
