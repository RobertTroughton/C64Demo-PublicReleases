#pragma once

void GenerateSinTable(int Length, int MinValue, int MaxValue, int ShiftDistance, int* OutputTable);
void OutputSinTable(ofstream& file, int* SinTable, int Length);
