//; (c) 2018, Raistlin of Genesis*Project

void ImageConv_BMPToPackedSpriteData(
	LPCTSTR InputFilename,												//; Input BMP
	LPCTSTR OutputSpriteDataFilename,									//; Output Sprites
	LPCTSTR OutputPackedSpriteDataFilename,								//; Output Packed Sprites
	LPCTSTR OutputPackedSpriteLookupFilename,							//; Output Packed Sprite Lookup Data
	int Width,													//; Width of sprite data (or of a single animation if animated)
	int Height,												//; Height of sprite data
	bool bMulticolour,													//; Multicolour
	unsigned char* ColourRemap,											//; How we want to remap each colour bit in this sprite data
	int InterleaveHeight,												//; Interleave height: usually should be 21 (non-interleaved), 16 or 8 (interleaved)
	int NumAnims,														//; Number of animations
	int VirtualNumAnims													//; Virtual/Scratch number of animations
);
