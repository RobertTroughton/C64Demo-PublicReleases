#pragma once

void GenerateSinTable(unsigned int Length, int MinValue, int MaxValue, unsigned int ShiftDistance, int* OutputTable);
void OutputSinTable(ofstream& file, unsigned int* SinTable, unsigned int Length);
