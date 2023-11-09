#include "..\Common\Common.h" 

void CreateHorizontalRotationTables(LPTSTR OutPhaseTabBINFileName, LPTSTR OutDeltaTabBINFileName, LPTSTR OutOffsetTabBINFileName) {

	int NumPhases = 32;

	unsigned char PhaseTables[32][8]{};
	unsigned char DeltaTables[2][32]{};
	unsigned char OffsetTable[32]{};
	
	float Dist = 24;

	for (int phase = 0; phase < NumPhases; phase++)
	{
	
		float Height = 96 * cos((phase * 0.5) * PI / 32);

		float Depth = 24 * sin((phase * 0.5) * PI / 32);

		float H8 = Height * Dist / (Dist + Depth);
		
		PhaseTables[NumPhases - 1 - phase][7] = 0;
		OffsetTable[NumPhases - 1 - phase] = (96-H8)/2;

		int Offset = (96 - H8) / 2;
		
		for (int i = 1; i < 8; i++)
		{
			float H = i * 12 * cos((phase * 0.5) * PI / 32);
			float D = i * 3 * sin((phase * 0.5) * PI / 32);
			float HP = H * Dist / (Dist + D);
			PhaseTables[NumPhases - 1 - phase][i - 1] = H8-HP;
		}
		
		float Delta = Depth / H8;
		int DeltaHi = (int)Delta;
		int DeltaLo = (int)(Delta * 256) % 256;

		DeltaTables[0][NumPhases - 1 - phase] = DeltaLo;
		DeltaTables[1][NumPhases - 1 - phase] = DeltaHi;
	}

	WriteBinaryFile(OutPhaseTabBINFileName, PhaseTables, 8 * NumPhases);
	
	WriteBinaryFile(OutDeltaTabBINFileName, DeltaTables, 2 * NumPhases);

	WriteBinaryFile(OutOffsetTabBINFileName, OffsetTable, NumPhases);
}

void CreateZoomPhases(LPTSTR OutBINFileName) {

	unsigned char ZoomPhases[49][128]{};

	int NumPhases = 49;
	int TableSize = 96;

	for (int phase = 0; phase < NumPhases; phase++)
	{
		int ZoomSize = phase * 2;
		int ZoomStart = (TableSize - ZoomSize) / 2;

		//for (int i = 0; i < TableSize; i++)
		//{
			//ZoomPhases[phase][i] = 0;
		//}
		
		for (int i = 0; i < ZoomSize; i++)
		{
			ZoomPhases[phase][ZoomStart + i] = phase;
		}

		if (phase == 0)
		{
		}
		else if (phase < 6)		//Special handling of first 6 phases
		{
			ZoomPhases[phase][ZoomStart] += 0x80;
			ZoomPhases[phase][ZoomStart + ZoomSize - 1] += 0x80;

			for (int i = 1; i < ZoomSize; i += 2)
			{
				ZoomPhases[phase][ZoomStart+i] += 0x40;
			}
		}
		else
		{
			double PhaseDelta = (double)ZoomSize / 8;
			double PhaseStep = PhaseDelta;
			unsigned char PhaseSwap = 0;
			
			int j = 0;
			while (PhaseStep <= ZoomSize)
			{
				while (j < PhaseStep)
				{
					ZoomPhases[phase][ZoomStart + j++] ^= PhaseSwap;
				}
				PhaseStep += PhaseDelta;
				PhaseSwap ^= 0x40;
			}

			int BorderWidth = phase <= NumPhases / 2 ? 1 : 2;

			for (int i = 0; i < BorderWidth; i++)
			{
				ZoomPhases[phase][ZoomStart + i] += 0x80;
				ZoomPhases[phase][ZoomStart + ZoomSize - 1 - i] += 0x80;
			}
		}
	}

	WriteBinaryFile(OutBINFileName, ZoomPhases, 49 * 128);

}

void CreatePatternTable(char* InPNGFileName, LPTSTR OutSpriteBINFileName, LPTSTR OutPointerBINFileName) {

	GPIMAGE PatternImage(InPNGFileName);

	int W = PatternImage.Width;
	int H = PatternImage.Height;

	unsigned char PatternData[256 * 4]{};
	unsigned char PointerData[48 * 8]{};

	int ThisVal = 1;
	int PtrI = 0;
	int DataI = 0;
	int StartI = 0;

	for (int i = 0; i < 6; i++)
	{
		if ((i == 1) || (i == 3) || (i == 4))
		{
			StartI++;
			DataI = 0;
		}

		for (int y = 0; y < 8; y++)
		{
			for (int x = 0; x < W; x += 2)
			{
				ThisVal <<= 2;

				unsigned char Col = PatternImage.GetPixelPaletteColour(x, (i * 8) + y);

				if (Col == 0)
				{
					ThisVal += 0x01;
				}
				else if (Col == 1)
				{
					ThisVal += 0x03;
				}
				else if (Col == 2)
				{
					ThisVal += 0x02;
				}
				else
				{
					ThisVal += 0x00;
				}

				if (ThisVal > 0xffffff)
				{
					ThisVal %= 0x1000000;
					if (ThisVal == 0)
					{
						ThisVal += 0;
					}

					int Val0 = ThisVal >> 16;
					int Val1 = (ThisVal & 0x00ff00) >> 8;
					int Val2 = ThisVal & 0xff;
					ThisVal = 1;

					if (DataI == 0)
					{
						PatternData[(StartI * 256) + DataI++] = Val0;
						PatternData[(StartI * 256) + DataI++] = Val1;
						PatternData[(StartI * 256) + DataI++] = Val2;
					}
					int j = 0;
					while (j < DataI)
					{
						if ((PatternData[(StartI * 256) + j] == Val0) && (PatternData[(StartI * 256) + j + 1] == Val1) && (PatternData[(StartI * 256) + j + 2] == Val2))
							break;
						j += 3;
					}
					if (j == DataI)
					{
						PatternData[(StartI * 256) + DataI++] = Val0;
						PatternData[(StartI * 256) + DataI++] = Val1;
						PatternData[(StartI * 256) + DataI++] = Val2;
					}
					PointerData[PtrI++] = 0xc0 + j / 3;
				}
			}
		}
		if ((i != 1) && (i != 4))
		{
			PatternData[(StartI * 256) + DataI] = 0xaa;
		}
	}

	WriteBinaryFile(OutSpriteBINFileName, PatternData, 256 * 4);
	WriteBinaryFile(OutPointerBINFileName, PointerData, 48 * 8);

}



int CheckerZoomer_Main() {

	CreatePatternTable("Parts\\CheckerZoomer\\Data\\Pattern.png", L"Link\\CheckerZoomer\\SpriteData.bin", L"Link\\CheckerZoomer\\PointerData.bin");

	CreateZoomPhases(L"Link\\CheckerZoomer\\ZoomPhases.bin");

	CreateHorizontalRotationTables(L"Link\\CheckerZoomer\\PhaseTables.bin", L"Link\\CheckerZoomer\\DeltaTables.bin", L"Link\\CheckerZoomer\\OffsetTable.bin");


	return 0;
}