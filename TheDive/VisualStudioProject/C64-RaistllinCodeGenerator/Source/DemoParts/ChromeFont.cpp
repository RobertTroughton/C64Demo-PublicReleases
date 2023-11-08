//; (c) 2018-2019, Genesis*Project

#include "..\Common\Common.h"
#include "..\Common\SinTables.h"

#include "..\ThirdParty\CImg.h"
using namespace cimg_library;

#define MAX_NUM_COLOURS 16
#define MAX_NUM_CHARS 64
#define MAX_WIDTH 80

class CHROMEFONT_CHAR
{
public:
	int X0;
	int X1;
	int Width;
} ChromeFontChar[MAX_NUM_CHARS];

void CHROMEFONT_OutputCharData(void)
{
	CImg<unsigned char> SrcCharSet("..\\..\\Build\\Parts\\ChromeFont\\Data\\Facet-LargeChrome.png");
	int Width = SrcCharSet.width();
	int Height = SrcCharSet.height();

	//; Determine the widths of each char...
	int StartXValForThisChar = 0;
	int XVal = 0;
	bool bLookingForNextChar = true;
	bool bLookingForGap = false;
	int NumCharsInFont = 0;
	while (XVal < Width)
	{
		bool bHasPixels = false;
		for (int YVal = 0; YVal < Height; YVal++)
		{
			unsigned char cR = SrcCharSet(XVal, YVal, 0, 0);
			unsigned char cG = SrcCharSet(XVal, YVal, 0, 0);
			unsigned char cB = SrcCharSet(XVal, YVal, 0, 0);
			unsigned char cMerge = cR | cG | cB;
			if ((cR != 0x95) || (cG != 0x95) || (cB != 0x95))
			{
				bHasPixels = true;
				break;
			}
		}
		if (bLookingForNextChar)
		{
			if (bHasPixels)
			{
				ChromeFontChar[NumCharsInFont].X0 = XVal;
				bLookingForNextChar = false;
			}
		}
		else
		{
			if (!bHasPixels)
			{
				ChromeFontChar[NumCharsInFont].X1 = XVal;
				ChromeFontChar[NumCharsInFont].Width = ChromeFontChar[NumCharsInFont].X1 - ChromeFontChar[NumCharsInFont].X0;
				bLookingForNextChar = true;
				NumCharsInFont++;
			}
		}
		XVal++;
	}
	if (bLookingForGap)
	{
		ChromeFontChar[NumCharsInFont].X1 = XVal;
		ChromeFontChar[NumCharsInFont].Width = ChromeFontChar[NumCharsInFont].X1 - ChromeFontChar[NumCharsInFont].X0;
		NumCharsInFont++;
	}

	int OutputWidth = MAX_WIDTH * NumCharsInFont;

	//; We use expanded sprites - so these will be Width/2 by Height
	CImg<unsigned char> DstSpriteData(OutputWidth / 2, Height, 1, 3);
	DstSpriteData.fill(0);

	//; char data - this has the sprite overlay removed
	CImg<unsigned char> DstCharData(OutputWidth, Height, 1, 3);
	DstCharData.fill(0);

	unsigned int PaletteValues[MAX_NUM_COLOURS] = { 0x000000, 0x00ffffff, 0x00959595 };
	int NumColours = 3;

	int XWriteVal = 0;
	for (int CharIndex = 0; CharIndex < NumCharsInFont; CharIndex++)
	{
//;		if (ChromeFontChar[CharIndex].Width > 0)
		{
			int XReadVal = ChromeFontChar[CharIndex].X0;
			XWriteVal = ((XWriteVal + 15) / 16) * 16;
			for (int XPixel = 0; XPixel < ChromeFontChar[CharIndex].Width; XPixel++)
			{
				for (int YVal = 0; YVal < Height; YVal++)
				{
					unsigned int ColValue;
					unsigned char cR = SrcCharSet(XReadVal, YVal, 0, 0);
					unsigned char cG = SrcCharSet(XReadVal, YVal, 0, 0);
					unsigned char cB = SrcCharSet(XReadVal, YVal, 0, 0);
					ColValue = (cR << 0) | (cG << 8) | (cB << 16);

					int FoundIndex = -1;
					for (int ColCheckIndex = 0; ColCheckIndex < NumColours; ColCheckIndex++)
					{
						if (ColValue == PaletteValues[ColCheckIndex])
						{

							FoundIndex = ColCheckIndex;
							break;
						}
					}
					if ((FoundIndex == -1) && (NumColours < MAX_NUM_COLOURS))
					{
						FoundIndex = NumColours;
						PaletteValues[NumColours] = ColValue;
						NumColours++;
					}
					if (FoundIndex == 2)
					{
						DstSpriteData(XWriteVal / 2, YVal, 0, 0) = cR;
						DstSpriteData(XWriteVal / 2, YVal, 0, 1) = cG;
						DstSpriteData(XWriteVal / 2, YVal, 0, 2) = cB;
					}
					else
					{
						DstCharData(XWriteVal, YVal, 0, 0) = cR;
						DstCharData(XWriteVal, YVal, 0, 1) = cG;
						DstCharData(XWriteVal, YVal, 0, 2) = cB;
					}
				}

				XReadVal++;
				XWriteVal++;
			}
		}
	}
	DstCharData.crop(0, 0, XWriteVal, Height);
	DstSpriteData.crop(0, 0, XWriteVal / 2, Height);
	DstSpriteData.save_png("..\\..\\Intermediate\\Built\\ChromeFont\\Facet-LargeChrome-SpriteData.png");
	DstCharData.save_png("..\\..\\Intermediate\\Built\\ChromeFont\\Facet-LargeChrome-CharData.png");
}

int CHROMEFONT_Main()
{
	_mkdir("..\\..\\Intermediate\\Built\\ChromeFont");

	CHROMEFONT_OutputCharData();

	return 0;
}

