//; (c) 2018, Raistlin of Genesis*Project

#include "..\Common\Common.h" 
#include "..\Common\SinTables.h" 
 
static const int Font_NumCharsX = 32; 
static const int Font_NumCharsY = 1; 
static const int Font_MaxNumChars = 32; 
static const int Font_CharW = 5; 
static const int Font_CharH = 5; 
static const int Font_CharXSpacing = 8;
static const int Font_CharYSpacing = 0; 
 
static int ZP_Num;
 
static unsigned char AvailableZP[256];

static unsigned char ScrollText[] = {
	//; Quote from the book "Spin" by Robert Charles Wilson
	"there are many kinds of time. the time by which we measure our lives. months and years. or the big time. the time that raises mountains and makes stars. all the things that happen between one heartbeat and the next. it is hard to live in all those kinds of times. easy to forget you live in all of them."
	"                                                                                                                                              "
	">"
};

class WRITE_MATCH_DATA
{
public:
	int BobX_Index;
	int BobX_YPix;
	unsigned char BobX_Shift;
	unsigned char BobX_Side;

	int BobY_Index;
	int BobY_YPix;
	unsigned char BobY_Shift;
	unsigned char BobY_Side;
} WriteMatchData[2][200][40];

void BigDXYCP_ProcessBitmap(char* BitmapPNGFilename, LPTSTR OutBitmapMAPFilename, LPTSTR OutBitmapSCRFilename)
{
	GPIMAGE InBitmapImage(BitmapPNGFilename);

	unsigned char BitmapMAPData[25][40][8];
	unsigned char BitmapSCRData[25][40];

	for (int ychar = 0; ychar < 25; ychar++)
	{
		for (int xchar = 0; xchar < 40; xchar++)
		{
			bool bCharHasPixels = false;
			unsigned char Col0 = 1;
			unsigned char Col1 = 1;
			int NumCols = 0;

			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				for (int xpixel = 0; xpixel < 8; xpixel++)
				{
					int x = xchar * 8 + xpixel;

					unsigned int Col = InBitmapImage.GetPixelPaletteColour(x, y);
					switch (NumCols)
					{
					case 0:
						Col0 = Col1 = Col;
						NumCols++;
						break;

					case 1:
						if (Col != Col0)
						{
							Col1 = Col;
							NumCols++;
						}
						break;
					}
				}
			}
			if (Col0 > Col1)
			{
				unsigned char TmpCol = Col0;
				Col0 = Col1;
				Col1 = TmpCol;
			}

			if (NumCols == 1)
			{
				Col0 = (Col1 == 0) ? 1 : 12;
			}

			BitmapSCRData[ychar][xchar] = (Col0 << 4) | (Col1 << 0);

			for (int ypixel = 0; ypixel < 8; ypixel++)
			{
				int y = ychar * 8 + ypixel;
				unsigned char OutByte = 0;
				for (int xpixel = 0; xpixel < 8; xpixel++)
				{
					int x = xchar * 8 + xpixel;

					unsigned int Col = InBitmapImage.GetPixelPaletteColour(x, y);

					unsigned char BitToSet = (Col == Col0) ? 0 : 1;
					if (!BitToSet)
					{
						OutByte |= 0x80 >> xpixel;
					}
				}
				BitmapMAPData[ychar][xchar][ypixel] = OutByte;
			}
		}
	}
	WriteBinaryFile(OutBitmapMAPFilename, BitmapMAPData, sizeof(BitmapMAPData));
	WriteBinaryFile(OutBitmapSCRFilename, BitmapSCRData, sizeof(BitmapSCRData));
}


void BigDXYCP_ProcessFont(char* FontPNGFilename, LPTSTR OutFontASMFilename, LPTSTR OutFontBINFilename)
{
	GPIMAGE FontIMG(FontPNGFilename);
	CodeGen OutFontASM(OutFontASMFilename);

	unsigned char CharSet[Font_CharH][Font_MaxNumChars];
	ZeroMemory(CharSet, sizeof(CharSet));
	for (int ychar = 0; ychar < Font_NumCharsY; ychar++)
	{
		for (int xchar = 0; xchar < Font_NumCharsX; xchar++)
		{
			int charindex = ychar * Font_NumCharsX + xchar;
			for (int ypixel = 0; ypixel < Font_CharH; ypixel++)
			{
				int InY = ychar * Font_CharYSpacing + ypixel;
				unsigned char ThisLine = 0;
				for (int xpixel = 0; xpixel <= Font_CharW; xpixel++)
				{
					int InX = xchar * Font_CharXSpacing + xpixel;
					unsigned int Col = FontIMG.GetPixel(InX, InY);
					if (Col != 0x00000000)
					{
						ThisLine |= 0x80 >> xpixel;
					}
				}
				CharSet[ypixel][charindex] = ThisLine;
			}
		}
	}
	WriteBinaryFile(OutFontBINFilename, CharSet, sizeof(CharSet));

	int FontBINCount = 0;
	for (int shift = 0; shift < 8; shift++)
	{
		int NumSides = 1;
		if (shift + Font_CharW > 8)
		{
			NumSides++;
		}
		for (int side = 0; side < NumSides; side++)
		{
			for (int y = 0; y < Font_CharH; y++)
			{
				OutFontASM.OutputCodeLine(NONE, fmt::format(".var Font_Y{:d}_Shift{:d}_Side{:d} = FONTBIN_ADDR + ({:d} * $20)", y, shift, side, FontBINCount));
				FontBINCount++;
			}
		}
	}
}

static const int MaxNumBobs = 320;
static const int NumFrames = 2;
static const int MaxOverlaps = 7;

int TestCycleCount[2] = {INT_MAX, 0};

unsigned char WrittenAlready[200][40];

#define DOTESTPASSES 0

void BigDXYCP_ProcessPlot(LPTSTR OutPlotASMFilename, char* OutHitMapImageFilename)
{
	double Start_dY = 11.9;

	CodeGen OutPlotASM(OutPlotASMFilename);

	GPIMAGE HitMapImage(320, 200);

	int OptimumTestIndex = 0;
	int LowestCycles = INT_MAX;
	int NumBobs = 302;
	double CheckDist = 1.25;

#if DOTESTPASSES
	OutPlotASM.bActuallyOutput = false;// (CurrentPass == 1);
	int NumTestPasses = 32 * 8 * 16000;
	for (int TestPass = 0; TestPass < NumTestPasses; TestPass++)
#else
	int CycleCount[NumFrames];
	int TestPass = 1166761;

#endif
	{
		memset(WriteMatchData, 0xee, sizeof(WriteMatchData));

		int TmpTestPass = TestPass;
		CheckDist = 14.0 + (0.25 * (TestPass % 32));
		TmpTestPass /= 32;
		int XStartShift = TmpTestPass % 8;
		TmpTestPass /= 8;
		Start_dY = 0.0125 * TmpTestPass;

		for (int CurrentPass = 0; CurrentPass < 2; CurrentPass++)
		{
#if !DOTESTPASSES
			OutPlotASM.bActuallyOutput = (CurrentPass == 1);
#endif

			int TotalCycles = 0;
			int TotalBytes = 0;

			double DistY = 30.0455;
			double DistX = 56.0;

			unsigned short ScreenBobsMap[NumFrames][200][40][MaxOverlaps + 1];
			ZeroMemory(ScreenBobsMap, sizeof(ScreenBobsMap));

			int NumSineValues = NumBobs * NumFrames;

			int BobSines[NumFrames * MaxNumBobs][2];
			for (int i = 0; i < NumSineValues; i++)
			{
				int ItIndex = i;
				int ItIndexInv = NumSineValues - 1 - ItIndex;

				double ScaleX = 156.0 - (DistX * ItIndexInv) / NumSineValues;
				double ScaleY = 76.0 - (DistY * ItIndexInv) / NumSineValues;

				static double dI;
				static double SinX;
				static double SinY;
				static double last_SinX;
				static double last_SinY;
				if (i == 0)
				{
					dI = Start_dY;
					SinX = sin((2.0 * PI * dI) / NumSineValues) * ScaleX;
					SinY = -cos((2.0 * PI * dI) / NumSineValues) * ScaleY;
				}
				else
				{

					double dI_Jump = 10.0;
					int PassCount = 0;

					dI = dI + dI_Jump;

					while (PassCount < 32)
					{
						SinX = sin((2.0 * PI * dI) / NumSineValues) * ScaleX;
						SinY = -cos((2.0 * PI * dI) / NumSineValues) * ScaleY;

						double DistX = (SinX - last_SinX);
						double DistY = (SinY - last_SinY);
						double DistSq = (DistX * DistX) + (DistY * DistY);

						dI_Jump *= 0.5;

						if (DistSq >= CheckDist)
						{
							dI -= dI_Jump;
						}
						else
						{
							dI += dI_Jump;
						}
						PassCount++;
					}
					SinX = sin((2.0 * PI * dI) / NumSineValues) * ScaleX;
					SinY = -cos((2.0 * PI * dI) / NumSineValues) * ScaleY;
				}
				if (SinX == -ScaleX)
					SinX += 1;
				if (SinX == ScaleX)
					SinX -= 1;
				if (SinY == -ScaleY)
					SinY += 1;
				if (SinY == ScaleY)
					SinY -= 1;
				last_SinX = SinX;
				last_SinY = SinY;
				SinX += 160.5 - 8.0 + (double)XStartShift;
				SinY += 124.0;

				int iX = (int)floor(SinX);
				int iY = (int)floor(SinY);
				BobSines[i][0] = max(iX, 0);
				BobSines[i][1] = max(iY, 0);

				int iLastX = iX + Font_CharW - 1;
				int iLastY = iY + Font_CharH - 1;
				int ImageMinX = (iX / 8) * 8;
				int ImageMinY = (iY / 8) * 8;
				int ImageMaxX = (iLastX / 8 + 1) * 8;
				int ImageMaxY = (iLastY / 8 + 1) * 8;
				HitMapImage.FillRectangle(ImageMinX, ImageMinY, ImageMaxX, ImageMaxY, 0x00ffffff);
			}

			HitMapImage.Write(OutHitMapImageFilename);

			for (int Frame = 0; Frame < NumFrames; Frame++)
			{
				for (int i = 0; i < NumBobs; i++)
				{
					int SinIndex = i * NumFrames + Frame;

					int iX = BobSines[SinIndex][0];
					int iY = BobSines[SinIndex][1];
					int iXChar = iX / 8;
					int shift = iX % 8;

					int NumSides = 1;
					if (shift + Font_CharW > 8)
					{
						NumSides = 2;
					}

					for (int ypixel = 0; ypixel < Font_CharH; ypixel++)
					{
						int ypos = iY + ypixel;
						for (int side = 0; side < NumSides; side++)
						{
							int NumHere = ScreenBobsMap[Frame][ypos][iXChar + side][0];
							if (NumHere < 8)
							{
								if (iXChar + side < 40)
								{
									ScreenBobsMap[Frame][ypos][iXChar + side][NumHere + 1] = i + (0x8000 * side);
									ScreenBobsMap[Frame][ypos][iXChar + side][0]++;
								}
							}
						}
					}
				}
			}

			for (int Frame = 0; Frame < NumFrames; Frame++)
			{
				ZeroMemory(WrittenAlready, sizeof(WrittenAlready));

				OutPlotASM.OutputFunctionLine(fmt::format("PlotFrame{:d}", Frame));

				int BobX_Index = 0;
				int BobY_Index = 1;

				if (Frame == 1)
				{
					if (BobX_Index < NumBobs)
					{
						if (BobX_Index < ZP_Num)
						{
							OutPlotASM.OutputCodeLine(LDX_ZP, fmt::format("${:02x}", AvailableZP[BobX_Index]));
						}
						else
						{
							OutPlotASM.OutputFunctionLine(fmt::format("Char{:d}", BobX_Index));
							OutPlotASM.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
						}
					}
					if (BobY_Index < NumBobs)
					{
						if (BobY_Index < ZP_Num)
						{
							OutPlotASM.OutputCodeLine(LDY_ZP, fmt::format("${:02x}", AvailableZP[BobY_Index]));
						}
						else
						{
							OutPlotASM.OutputFunctionLine(fmt::format("Char{:d}", BobY_Index));
							OutPlotASM.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
						}
					}
				}
				else
				{
					if (BobX_Index < NumBobs)
					{
						if (BobX_Index < ZP_Num)
						{
							OutPlotASM.OutputCodeLine(LDX_ZP, fmt::format("${:02x}", AvailableZP[BobX_Index]));
						}
						else
						{
							OutPlotASM.OutputCodeLine(LDX_ABS, fmt::format("Char{:d} + 1", BobX_Index));
						}
					}
					if (BobY_Index < NumBobs)
					{
						if (BobY_Index < ZP_Num)
						{
							OutPlotASM.OutputCodeLine(LDY_ZP, fmt::format("${:02x}", AvailableZP[BobY_Index]));
							OutPlotASM.OutputCodeLine(STY_ZP, fmt::format("${:02x}", AvailableZP[BobX_Index]));
						}
						else
						{
							OutPlotASM.OutputCodeLine(LDY_ABS, fmt::format("Char{:d} + 1", BobY_Index));
							OutPlotASM.OutputCodeLine(STY_ABS, fmt::format("Char{:d} + 1", BobX_Index));
						}
					}
				}

				int FocusBob_XOrY = 0;
				int NextBob = 2;
				int PrevBob = (NextBob + NumBobs - 1) % NumBobs;

				bool bFinished = false;
				while (!bFinished)
				{
					int BobX_SinIndex = BobX_Index * NumFrames + Frame;
					int BobY_SinIndex = BobY_Index * NumFrames + Frame;
					int NextBob_SinIndex = NextBob * NumFrames + Frame;

					int BobX_XVal = BobSines[BobX_SinIndex][0];
					int BobX_YVal = BobSines[BobX_SinIndex][1];
					int BobY_XVal = BobSines[BobY_SinIndex][0];
					int BobY_YVal = BobSines[BobY_SinIndex][1];
					int NextBob_XVal = BobSines[NextBob_SinIndex][0];
					int NextBob_YVal = BobSines[NextBob_SinIndex][1];

					int BobX_Shift = BobX_XVal % 8;
					int BobY_Shift = BobY_XVal % 8;
					int NextBob_Shift = NextBob_XVal % 8;

					int x0, x1, y0, y1;
					if (FocusBob_XOrY == 0)
					{
						x0 = BobX_XVal / 8;
						x1 = x0 + 2;
						y0 = BobX_YVal;
						y1 = BobX_YVal + Font_CharH;
					}
					else
					{
						x0 = BobY_XVal / 8;
						x1 = x0 + 2;
						y0 = BobY_YVal;
						y1 = y0 + Font_CharH;
					}

					for (int y = y0; y < y1; y++)
					{
						for (int x = x0; x < x1; x++)
						{
							int BobX_Found = -1;
							int BobY_Found = -1;
							int BobX_Side;
							int BobY_Side;
							int NumHere = ScreenBobsMap[Frame][y][x][0];
							for (int pos = 0; pos < NumHere; pos++)
							{
								if ((ScreenBobsMap[Frame][y][x][pos + 1] & 0x7fff) == BobX_Index)
								{
									BobX_Found = pos;
									BobX_Side = (ScreenBobsMap[Frame][y][x][pos + 1] & 0x8000) ? 1 : 0;
								}
								if ((ScreenBobsMap[Frame][y][x][pos + 1] & 0x7fff) == BobY_Index)
								{
									BobY_Found = pos;
									BobY_Side = (ScreenBobsMap[Frame][y][x][pos + 1] & 0x8000) ? 1 : 0;
								}
							}

							bool bPlot = false;
							int BobX_YPix = y - BobX_YVal;
							int BobY_YPix = y - BobY_YVal;

							if (FocusBob_XOrY == 0)
							{
								if (BobX_Found != -1)
								{
									if (BobY_Found == -1)
									{
										OutPlotASM.OutputCodeLine(LDA_ABX, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobX_YPix, BobX_Shift, BobX_Side));
										ScreenBobsMap[Frame][y][x][BobX_Found + 1] = 0xffff;
									}
									else
									{
										bool bOptimisedLoad = false;
										if (CurrentPass == 0)
										{
											WriteMatchData[Frame][y][x].BobX_Index = BobX_Index;
											WriteMatchData[Frame][y][x].BobX_YPix = BobX_YPix;
											WriteMatchData[Frame][y][x].BobX_Shift = BobX_Shift;
											WriteMatchData[Frame][y][x].BobX_Side = BobX_Side;

											WriteMatchData[Frame][y][x].BobY_Index = BobY_Index;
											WriteMatchData[Frame][y][x].BobY_YPix = BobY_YPix;
											WriteMatchData[Frame][y][x].BobY_Shift = BobY_Shift;
											WriteMatchData[Frame][y][x].BobY_Side = BobY_Side;
										}
										else
										{
											for (int y2 = 0; y2 < 200; y2++)
											{
												for (int x2 = 0; x2 < 40; x2++)
												{
													if (!bOptimisedLoad
														&& (WriteMatchData[Frame][y2][x2].BobY_Index == (BobX_Index + 1)) && (WriteMatchData[Frame][y2][x2].BobX_Index == (BobY_Index + 1))
														&& (WriteMatchData[Frame][y2][x2].BobY_YPix == BobX_YPix) && (WriteMatchData[Frame][y2][x2].BobX_YPix == BobY_YPix)
														&& (WriteMatchData[Frame][y2][x2].BobY_Side == BobX_Side) && (WriteMatchData[Frame][y2][x2].BobX_Side == BobY_Side))
													{
														int BobXY_ShiftDiff = WriteMatchData[Frame][y2][x2].BobY_Shift - BobX_Shift;
														int BobYX_ShiftDiff = WriteMatchData[Frame][y2][x2].BobX_Shift - BobY_Shift;
														if ((BobXY_ShiftDiff == 0) && (BobYX_ShiftDiff == 0))
														{
															OutPlotASM.OutputCodeLine(LDA_ABS, fmt::format("BitmapAddress{:d} + ({:d} * 320) + ({:d} * 8) + {:d}		//; OPT-1", Frame, y2 / 8, x2, y2 % 8));
															bOptimisedLoad = true;
														}
													}
												}
											}
										}
										if (!bOptimisedLoad)
										{
											OutPlotASM.OutputCodeLine(LDA_ABX, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobX_YPix, BobX_Shift, BobX_Side));
											OutPlotASM.OutputCodeLine(ORA_ABY, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobY_YPix, BobY_Shift, BobY_Side));
										}
										ScreenBobsMap[Frame][y][x][BobX_Found + 1] = 0xffff;
										ScreenBobsMap[Frame][y][x][BobY_Found + 1] = 0xffff;
									}
									bPlot = true;
								}
							}
							else
							{
								if (BobY_Found != -1)
								{
									if (BobX_Found == -1)
									{
										OutPlotASM.OutputCodeLine(LDA_ABY, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobY_YPix, BobY_Shift, BobY_Side));
										ScreenBobsMap[Frame][y][x][BobY_Found + 1] = 0xffff;
									}
									else
									{
										bool bOptimisedLoad = false;
										if (CurrentPass == 0)
										{
											WriteMatchData[Frame][y][x].BobX_Index = BobX_Index;
											WriteMatchData[Frame][y][x].BobX_YPix = BobX_YPix;
											WriteMatchData[Frame][y][x].BobX_Shift = BobX_Shift;
											WriteMatchData[Frame][y][x].BobX_Side = BobX_Side;

											WriteMatchData[Frame][y][x].BobY_Index = BobY_Index;
											WriteMatchData[Frame][y][x].BobY_YPix = BobY_YPix;
											WriteMatchData[Frame][y][x].BobY_Shift = BobY_Shift;
											WriteMatchData[Frame][y][x].BobY_Side = BobY_Side;
										}
										else
										{
											for (int y2 = 0; y2 < 200; y2++)
											{
												for (int x2 = 0; x2 < 40; x2++)
												{
													if ((WriteMatchData[Frame][y2][x2].BobY_Index == (BobX_Index + 1)) && (WriteMatchData[Frame][y2][x2].BobX_Index == (BobY_Index + 1))
														&& (WriteMatchData[Frame][y2][x2].BobY_YPix == BobX_YPix) && (WriteMatchData[Frame][y2][x2].BobX_YPix == BobY_YPix)
														&& (WriteMatchData[Frame][y2][x2].BobY_Side == BobX_Side) && (WriteMatchData[Frame][y2][x2].BobX_Side == BobY_Side))
													{
														int BobXY_ShiftDiff = WriteMatchData[Frame][y2][x2].BobY_Shift - BobX_Shift;
														int BobYX_ShiftDiff = WriteMatchData[Frame][y2][x2].BobX_Shift - BobY_Shift;
														if ((BobXY_ShiftDiff == 0) && (BobYX_ShiftDiff == 0))
														{
															OutPlotASM.OutputCodeLine(LDA_ABS, fmt::format("BitmapAddress{:d} + ({:d} * 320) + ({:d} * 8) + {:d}		//; OPT-1", Frame, y2 / 8, x2, y2 % 8));
															bOptimisedLoad = true;
														}
													}
												}
											}
										}
										if (!bOptimisedLoad)
										{
											OutPlotASM.OutputCodeLine(LDA_ABX, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobX_YPix, BobX_Shift, BobX_Side));
											OutPlotASM.OutputCodeLine(ORA_ABY, fmt::format("Font_Y{:d}_Shift{:d}_Side{:d}", BobY_YPix, BobY_Shift, BobY_Side));
										}
										ScreenBobsMap[Frame][y][x][BobY_Found + 1] = 0xffff;
										ScreenBobsMap[Frame][y][x][BobX_Found + 1] = 0xffff;
									}
									bPlot = true;
								}
							}
							if (bPlot)
							{
								if (WrittenAlready[y][x])
								{
									OutPlotASM.OutputCodeLine(ORA_ABS, fmt::format("BitmapAddress{:d} + ({:d} * 320) + ({:d} * 8) + {:d}", Frame, y / 8, x, y % 8));
								}
								OutPlotASM.OutputCodeLine(STA_ABS, fmt::format("BitmapAddress{:d} + ({:d} * 320) + ({:d} * 8) + {:d}", Frame, y / 8, x, y % 8));
								WrittenAlready[y][x] = 1;

							}
						}
					}

					if ((BobX_Index >= NumBobs) && (BobY_Index >= NumBobs))
					{
						bFinished = true;
					}
					else
					{
						if (Frame == 1)
						{
							if (NextBob < NumBobs)
							{
								if (NextBob >= ZP_Num)
								{
									if (NextBob == (NumBobs - 1))
									{
										OutPlotASM.OutputFunctionLine(fmt::format("LastChar"));
									}
									else
									{
										OutPlotASM.OutputFunctionLine(fmt::format("Char{:d}", NextBob));
									}
								}
							}
						}

						if (FocusBob_XOrY == 0)
						{
							if (NextBob < NumBobs)
							{
								if (NextBob < ZP_Num)
								{
									OutPlotASM.OutputCodeLine(LDX_ZP, fmt::format("${:02x}", AvailableZP[NextBob]));
								}
								else
								{
									if (Frame == 1)
									{
										OutPlotASM.OutputCodeLine(LDX_IMM, fmt::format("#$00"));
									}
									else
									{
										if (NextBob == (NumBobs - 1))
										{
											OutPlotASM.OutputCodeLine(LDX_ABS, fmt::format("LastChar + 1"));
										}
										else
										{
											OutPlotASM.OutputCodeLine(LDX_ABS, fmt::format("Char{:d} + 1", NextBob));
										}
									}
								}
							}
							if (Frame == 0)
							{
								if (PrevBob < (NumBobs - 1))
								{
									if (PrevBob < ZP_Num)
									{
										OutPlotASM.OutputCodeLine(STX_ZP, fmt::format("${:02x}", AvailableZP[PrevBob]));
									}
									else
									{
										OutPlotASM.OutputCodeLine(STX_ABS, fmt::format("Char{:d} + 1", PrevBob));
									}
								}
							}
						}
						else
						{
							if (NextBob < NumBobs)
							{
								if (NextBob < ZP_Num)
								{
									OutPlotASM.OutputCodeLine(LDY_ZP, fmt::format("${:02x}", AvailableZP[NextBob]));
								}
								else
								{
									if (Frame == 1)
									{
										OutPlotASM.OutputCodeLine(LDY_IMM, fmt::format("#$00"));
									}
									else
									{
										if (NextBob == (NumBobs - 1))
										{
											OutPlotASM.OutputCodeLine(LDY_ABS, fmt::format("LastChar + 1"));
										}
										else
										{
											OutPlotASM.OutputCodeLine(LDY_ABS, fmt::format("Char{:d} + 1", NextBob));
										}
									}
								}
							}
							if (Frame == 0)
							{
								if (PrevBob < (NumBobs - 1))
								{
									if (PrevBob < ZP_Num)
									{
										OutPlotASM.OutputCodeLine(STY_ZP, fmt::format("${:02x}", AvailableZP[PrevBob]));
									}
									else
									{
										OutPlotASM.OutputCodeLine(STY_ABS, fmt::format("Char{:d} + 1", PrevBob));
									}
								}
							}
						}

						if (FocusBob_XOrY == 0)
							BobX_Index = NextBob;
						else
							BobY_Index = NextBob;

						FocusBob_XOrY = 1 - FocusBob_XOrY;
						PrevBob = NextBob;
						NextBob++;
					}
					if ((BobX_Index >= NumBobs) && (BobY_Index >= NumBobs))
					{
						bFinished = true;
					}
				}

#if !DOTESTPASSES
				OutPlotASM.OutputCodeLine(RTS);
				OutPlotASM.OutputBlankLine();
				CycleCount[Frame] = OutPlotASM.totalCycles;
				OutPlotASM.totalCycles = 0;
				OutPlotASM.totalBytes = 0;
#else
				if (CurrentPass == 0)
					OutPlotASM.totalCycles = 0;
#endif
			}
		}
#if DOTESTPASSES
		int TotalCyclesHere = OutPlotASM.totalCycles;

		if (TotalCyclesHere < TestCycleCount[0])
		{
			TestCycleCount[0] = TotalCyclesHere;
			TestCycleCount[1] = TestPass;

			cout << "(" << TestPass << " / " << NumTestPasses << " ) ..Cycles: (" << TestCycleCount[0] << ")" << endl;

		}
		else
		{
			if ((TestPass & 1023) == 0)
			{
				cout << "(" << TestPass << " / " << NumTestPasses << " )\n";
			}
		}

		OutPlotASM.ResetCounters();
#endif
	}

#if !DOTESTPASSES
	int TotalCycles = 0;
	OutPlotASM.OutputBlankLine();
	for (int Frame = 0; Frame < NumFrames; Frame++)
	{
		OutPlotASM.OutputCommentLine(fmt::format("//; Frame{:d}: {:d} cycles", Frame, CycleCount[Frame]));
		TotalCycles += CycleCount[Frame];
	}
	OutPlotASM.OutputCommentLine(fmt::format("//; TOTAL: {:6d} cycles", TotalCycles));
#endif
}

void BigDXYCP_OutputScrollText(LPTSTR OutScrolltextBINFilename)
{
	bool bFinishedST = false;
	int ScrollTextIndex = 0;
	while (!bFinishedST)
	{
		unsigned char CurrentChar = ScrollText[ScrollTextIndex];

		switch (CurrentChar)
		{
		case '>':
			CurrentChar = 255;
			bFinishedST = true;
			break;

		case ' ':
			CurrentChar = 0;
			break;

		case '.':
			CurrentChar = 27;
			break;

		case ',':
			CurrentChar = 28;
			break;

		case '!':
			CurrentChar = 29;
			break;

		case '?':
			CurrentChar = 30;
			break;

		case '\'':
			CurrentChar = 31;
			break;

		default:
			CurrentChar = CurrentChar & 0x1f;
			if (CurrentChar > 26)
				CurrentChar = 0;
			break;
		}

		ScrollText[ScrollTextIndex] = CurrentChar;
		ScrollTextIndex++;
	}

	WriteBinaryFile(OutScrolltextBINFilename, ScrollText, ScrollTextIndex);
}

int BigDXYCP_Main()
{
	for (int i = 0; i < 250; i++)
	{
		AvailableZP[i] = 0x02 + i;	// $02, $03, ..., $fb
	}
	ZP_Num = 250;

	BigDXYCP_ProcessFont("Parts\\BigDXYCP\\Data\\Scrap-5x5Font.png", L"Build\\6502\\BigDXYCP\\FontData.asm", L"Link\\BigDXYCP\\FontData.bin");

	BigDXYCP_ProcessPlot(L"Build\\6502\\BigDXYCP\\Plot.asm", "Build\\6502\\BigDXYCP\\Hitmap.png");

	BigDXYCP_ProcessBitmap("Parts\\BigDXYCP\\Data\\Facet-Bitmap.png", L"Link\\BigDXYCP\\Bitmap.map", L"Link\\BigDXYCP\\Bitmap.scr");

	BigDXYCP_OutputScrollText(L"Link\\BigDXYCP\\Scrolltext.bin");

	return 0;
}
