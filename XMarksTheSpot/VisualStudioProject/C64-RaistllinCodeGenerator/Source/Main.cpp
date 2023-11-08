//; (c) 2018, Raistlin of Genesis*Project

#include "Main.h"
#include "Common\Common.h"

int main()
{
	_mkdir("..\\..\\Intermediate");
	_mkdir("..\\..\\Intermediate\\Built");

	DiagonalBitmap_Main();
	FullScreenRotatingThings_Main();
	HorizontalBitmap_Main();
	RotatingShapes_Main();
	ScreenEffects_Main();
	ScreenFadeAndTurnDisk_Main();
	ScreenHashChars_Main();
	SpriteBobs_Main();
	TreasureMap_Main();
	UpScrollCredits_Main();
	Waves_Main();
	WavyScroller_Main();
	WavySnake_Main();
}
