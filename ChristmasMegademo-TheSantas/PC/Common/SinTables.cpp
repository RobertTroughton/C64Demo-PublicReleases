// (c) 2018-2020, Genesis*Project

#include "Common.h"

void GenerateSinTable(int Length, int MinValue, int MaxValue, int ShiftDistance, int* OutputTable)
{
	double fMinValue = (double)MinValue;
	double fMaxValue = (double)MaxValue;
	for (int SinIndex = 0; SinIndex < Length; SinIndex++)
	{
		int ShiftedSinIndex = (SinIndex + Length - ShiftDistance) % Length;
		double angle = (2 * PI * ShiftedSinIndex) / Length;
		double SinValue = max(0.0, min(1.0, (sin(angle) + 1.0) / 2.0)); // sin in range [0, 1]
		SinValue = SinValue * ((fMaxValue + 1) - fMinValue) + fMinValue;
		int iSinValue = (int)SinValue;
		iSinValue = min(MaxValue, iSinValue);
		iSinValue = max(MinValue, iSinValue);
		OutputTable[SinIndex] = iSinValue;
	}
}
