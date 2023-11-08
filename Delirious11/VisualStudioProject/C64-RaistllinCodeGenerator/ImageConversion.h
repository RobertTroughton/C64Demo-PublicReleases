// (c)2018, Raistlin / Genesis*Project

#pragma once

void OutputRandomScreenFillPointers(LPCTSTR OutputDataFilename);
void Output_BMPToSpriteData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, bool bMulticolour, unsigned int Width, unsigned int Height);
void Output_BMPBitmapToSpriteData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, unsigned int NumSprites, bool bInvertPixels);
void Output_BMPBitmapToCharScreenData(LPCTSTR InputFilename, LPCTSTR OutputDataFilename, LPCTSTR OutputScreenFilename, unsigned int ImageWidth, unsigned int ImageHeight, unsigned int OutputWidth, unsigned int OutputHeight, bool bInvertPixels, int NumExtraChars);

