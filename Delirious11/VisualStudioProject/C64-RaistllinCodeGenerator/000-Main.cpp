// (c)2018, Raistlin / Genesis*Project

#include "000-Main.h"
#include <direct.h> // Needed for _mkdir

int main()
{
	_mkdir("..\\..\\Intermediate");
	_mkdir("..\\..\\Intermediate\\Built");

	UpScrollCredits_Main();
	BedIntro_Main();
	QuickCredits_Main();
	ScreenHashChars_Main();
	ScreenEOR_Main();

	RotatingStars_Main();
	SpriteBobs_Main();
	Images_Main();
	SpriteEffects_Main();
	MassiveLogo_Main();
	GreetingsPart_Main();
	EndCredits_Main();
}
