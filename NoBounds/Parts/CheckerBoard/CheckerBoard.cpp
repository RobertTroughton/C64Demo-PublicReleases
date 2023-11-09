#include "..\Common\Common.h" 

void CreateShiftedData(char* InPNGFileName, LPTSTR OutBINFileName)
{
	GPIMAGE InPNG(InPNGFileName);

	int W = InPNG.Width;
	int H = InPNG.Height;
	unsigned char ShiftedData[20][64][4]{};

	for (int i = 0; i < 8; i += 2)
	{
		//GPIMAGE OutPNG(160, 40, 0);

		for (int x = i; x < (i + 160); x += 8)
		{
			for (int y = 0; y < H / 2; y++)
			{
				unsigned char V = 0;
				for (int s = 0; s < 8; s += 2)
				{
					//int dy = y;
					//if ((((x - i + s) / 20) & 1) == 1)
					//{
						//dy += 20;
						//if (dy >= H)
						//{
							//dy -= H;
						//}
					//}
					V <<= 2;
					int c = InPNG.GetPixelPaletteColour(x + s, y);
					//unsigned char Col = InPNG.GetPixelPaletteColour(x + s, dy);
					//OutPNG.SetPixelPaletteColour((x + s - i), y, Col);
					//OutPNG.SetPixelPaletteColour((x + s - i + 1), y, Col);
					if (c == 0)
					{
						V |= 0;
					}
					else if (c == 1)
					{
						V |= 3;
					}
					else if (c == 11)
					{
						V |= 1;
					}
					else if (c == 15)
					{
						V |= 2;
					}
				}
				int NextX = (x - i) / 8;
				ShiftedData[y][NextX][i / 2] = V;
				ShiftedData[y][NextX + 20][i / 2] = V;
			}
		}
		
		//OutPNG.Write("Parts\\CheckerBoard\\Data\\Test.png");
	}

	WriteBinaryFile(OutBINFileName, ShiftedData, sizeof(ShiftedData));

}

void CreateRandomNumbers(LPTSTR OutBINFileName)
{
	unsigned char RandomNumbers[200]{};
	unsigned char Hit[200]{};
	int NumRnd = 0;

	srand((unsigned int)time(0));

	while (NumRnd < 200)
	{
		int Rndm = rand() % 200;
		if (Hit[Rndm] == 0)
		{
			Hit[Rndm]++;
			RandomNumbers[NumRnd++] = (unsigned char)Rndm;
		}
	}

	WriteBinaryFile(OutBINFileName, RandomNumbers, sizeof(RandomNumbers));
}

int CheckerBoard_Main()
{
		
	CreateShiftedData("Parts\\CheckerBoard\\Data\\Sine.png", L"Link\\CheckerBoard\\ShiftedData.bin");

	//CreateRandomNumbers(L"Link\\CheckerBoard\\Random.bin");
	
	return 0;
}