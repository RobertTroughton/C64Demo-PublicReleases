// (c) 2018-2019, Genesis*Project

#include <atlstr.h>

#include "..\Common\Common.h"

constexpr auto NUM_CIRCLES = 8;
constexpr auto MIN_CIRCLE_SIZE = 26.0;
constexpr auto MAX_CIRCLE_SIZE = 63.0;

constexpr auto CIRCLE_XMOVE = 40.0;
constexpr auto CIRCLE_YMOVE = 88.0;

constexpr auto NUM_FRAMES = 8;

unsigned int SpriteColours[] = {
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
	0x00ff0000, 0x0000ff00, 0x000000ff, 0x00800080,
};

void SpritePlex_CalcData(void)
{
	static const int SinTableSize = NUM_FRAMES * NUM_CIRCLES;
	GPIMAGE SineImage(320, 256 * NUM_FRAMES);

	unsigned char* ZPosValues = new unsigned char[320 * 256];

	for (int FrameIndex = 0; FrameIndex < NUM_FRAMES; FrameIndex++)
	{
		ZeroMemory(ZPosValues, 320 * 256);
		for (int CircleIndex = 0; CircleIndex < NUM_CIRCLES; CircleIndex++)
		{
			int Index = CircleIndex * NUM_FRAMES + FrameIndex;
			double Angle = (2 * PI * Index) / SinTableSize;
			double SineValueX = cos(Angle) * CIRCLE_XMOVE;
			double SineValueY = sin(Angle) * CIRCLE_YMOVE;
			double SineZ = (cos(Angle) + 1.0) / 2.0;
			double CircleSize = SineZ * MIN_CIRCLE_SIZE + (1.0 - SineZ) * MAX_CIRCLE_SIZE;
			unsigned char cCircleSize = (unsigned char)CircleSize;

			double CircleHalfSize = CircleSize * 0.5;

			double XPos = 160.0 + SineValueX;
			double YPos = 128.0 + SineValueY;

			int XPos0 = (int)(XPos - CircleHalfSize);
			int XPos1 = (int)(XPos + CircleHalfSize);
			int YPos0 = (int)(YPos - CircleHalfSize);
			int YPos1 = (int)(YPos + CircleHalfSize);
			double CircleSizeSq = (CircleHalfSize * CircleHalfSize);
			for (int Y = YPos0; Y <= YPos1; Y++)
			{
				for (int X = XPos0; X <= XPos1; X++)
				{
					double DistXSq = (X - XPos) * (X - XPos);
					double DistYSq = (Y - YPos) * (Y - YPos);
					double DistSq = DistXSq + DistYSq;
					if (cCircleSize > ZPosValues[X + Y * 320])
					{
						if (DistSq < CircleSizeSq)
						{
							SineImage.SetPixel(X, Y + (256 * FrameIndex), SpriteColours[CircleIndex]);
							ZPosValues[X + Y * 320] = cCircleSize;
						}
					}
				}
			}
		}
	}

	delete[] ZPosValues;

	SineImage.Write("Out\\6502\\Parts\\SpritePlex\\SpritePlex.png");
}


int SpritePlex_Main()
{
	SpritePlex_CalcData();

	return 0;
}
