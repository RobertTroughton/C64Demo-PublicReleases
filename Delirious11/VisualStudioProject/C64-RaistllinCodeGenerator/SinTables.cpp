// (c)2018, Raistlin / Genesis*Project

#include "Common.h"
#include "SinTables.h"

void GenerateSinTable(unsigned int Length, int MinValue, int MaxValue, unsigned int ShiftDistance, int* OutputTable)
{
	for (unsigned int SinIndex = 0; SinIndex < Length; SinIndex++)
	{
		unsigned int ShiftedSinIndex = (SinIndex + Length - ShiftDistance) % Length;
		double angle = (2 * PI * ShiftedSinIndex) / Length;
		double SinValue = max(0.0, min(1.0, (sin(angle) + 1.0) / 2.0)); // sin in range [0, 1]
		OutputTable[SinIndex] = max(MinValue, min(MaxValue, (int)(SinValue * (MaxValue - MinValue + 1) + MinValue))); // sin in range [MinValue, MaxValue]
	}
}
