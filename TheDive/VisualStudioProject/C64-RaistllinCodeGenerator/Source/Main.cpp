//; (c) 2018-2019, Genesis*Project

#include "Main.h"
#include "Common\Common.h"

int main()
{
	_mkdir("..\\..\\Intermediate");
	_mkdir("..\\..\\Intermediate\\Built");

	srand(0x98093de3);
	BIGDYPP_Main();

	srand(0x98093de3);
	GPLogo_Main();

	srand(0x98093de3);
	Misc_Main();

	srand(0x98093de3);
	Quote_Main();

	srand(0x98093de3);
	RotateScroller_Main();

	srand(0x98093de3);
	SBB_Main();

	srand(0x98093de3);
	SpriteBobs_Main();

	srand(0x98093de3);
	STARWARS_Main();

	srand(0x98093de3);
	VertBitmap_Main();

	srand(0x98093de3);
	Waves_Main();
}
