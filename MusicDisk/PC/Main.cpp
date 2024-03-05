#include "Common\Common.h"
#include "Common\SinTables.h"

#include "ThirdParty\CImg.h"
using namespace cimg_library;

#define NUM_FREQS_ON_SCREEN 40

static const int SineTableLength = 128;

unsigned short FreqTable[] = {
	0x0117,0x0127,0x0139,0x014b,0x015f,0x0174,0x018a,0x01a1,0x01ba,0x01d4,0x01f0,0x020e,
	0x022d,0x024e,0x0271,0x0296,0x02be,0x02e8,0x0314,0x0343,0x0374,0x03a9,0x03e1,0x041c,
	0x045a,0x049c,0x04e2,0x052d,0x057c,0x05cf,0x0628,0x0685,0x06e8,0x0752,0x07c1,0x0837,
	0x08b4,0x0939,0x09c5,0x0a5a,0x0af7,0x0b9e,0x0c4f,0x0d0a,0x0dd1,0x0ea3,0x0f82,0x106e,
	0x1168,0x1271,0x138a,0x14b3,0x15ee,0x173c,0x189e,0x1a15,0x1ba2,0x1d46,0x1f04,0x20dc,
	0x22d0,0x24e2,0x2714,0x2967,0x2bdd,0x2e79,0x313c,0x3429,0x3744,0x3a8d,0x3e08,0x41b8,
	0x45a1,0x49c5,0x4e28,0x52cd,0x57ba,0x5cf1,0x6278,0x6853,0x6e87,0x751a,0x7c10,0x8371,
	0x8b42,0x9389,0x9c4f,0xa59b,0xaf74,0xb9e2,0xc4f0,0xd0a6,0xdd0e,0xea33,0xf820,0xffff,
};
static const int NumFreqs = sizeof(FreqTable) / sizeof(FreqTable[0]);

struct OUT_SONG_DATA
{
	unsigned char SongName_Artist[40];
	unsigned char InitAddr[2];
	unsigned char PlayAddr[2];
	unsigned char VolumeAddr[2];
	unsigned char NumPlayCallsPerFrame;
};

struct SONG_SETUP
{
	wchar_t InSIDFilename[64];
	wchar_t OutBINFilename[64];
	char SongName[32];
	char ArtistName[32];
	unsigned short InitAddr;
	unsigned short PlayAddr;
	unsigned short VolumeAddr;
	int NumPlayCallsPerFrame;
} SongSetup[] =
{
	{
		L"6502\\Music\\Psych858o-NoBounds.sid",
		L"Out\\Built\\MusicData\\Psych858o-NoBounds.bin",
		"No Bounds",
		"Psych858o",
		0x0900,
		0x0903,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Flex-Hawkeye.sid",
		L"Out\\Built\\MusicData\\Flex-Hawkeye.bin",
		"Hawkeye",
		"Flex",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Nordischsound-MonkeyIslandLeChuck.sid",
		L"Out\\Built\\MusicData\\Nordischsound-MonkeyIslandLeChuck.bin",
		"Monkey Island - LeChuck",
		"Nordischsound",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	

	{
		L"6502\\Music\\Psych858o-LastNightOnTheLonelyIsland.sid",
		L"Out\\Built\\MusicData\\Psych858o-LastNightOnTheLonelyIsland.bin",
		"Last Night",
		"Psych858o",
		0x2551,
		0x2564,
		0x07ff,
		6
	},

	{
		L"6502\\Music\\DJSpace-MontyIsAManiac.sid",
		L"Out\\Built\\MusicData\\DJSpace-MontyIsAManiac.bin",
		"Monty is a Maniac",
		"DJ Space",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Dane-SlowMotionSong.sid",
		L"Out\\Built\\MusicData\\Dane-SlowMotionSong.bin",
		"Slow Motion Song",
		"Dane",
		0x2400,
		0x1000,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Dane-CopperBooze.sid",
		L"Out\\Built\\MusicData\\Dane-CopperBooze.bin",
		"Copper Booze",
		"Dane",
		0x12f0,
		0x0800,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Toggle-Fireflies.sid",
		L"Out\\Built\\MusicData\\Toggle-Fireflies.bin",
		"Fireflies",
		"Toggle",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Laxity-LastNightOf89.sid",
		L"Out\\Built\\MusicData\\Laxity-LastNightOf89.bin",
		"Last Night of 89",
		"Laxity",
		0x1000,
		0x1006,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Psych858o-SabreWulfPrev.sid",
		L"Out\\Built\\MusicData\\Psych858o-SabreWulfPrev.bin",
		"Sabre Wulf Remastered Prev",
		"Psych858o",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Magnar-MagnumPI.sid",
		L"Out\\Built\\MusicData\\Magnar-MagnumPI.bin",
		"Magnum PI Theme",
		"Magnar",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Psych858o-CrockettsTheme.sid",
		L"Out\\Built\\MusicData\\Psych858o-CrockettsTheme.bin",
		"Crockett's Theme",
		"Psych858o",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Magnar-OldSkool.sid",
		L"Out\\Built\\MusicData\\Magnar-OldSkool.bin",
		"Airwolf",
		"Magnar",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Psych858o-OnTheWaves.sid",
		L"Out\\Built\\MusicData\\Psych858o-OnTheWaves.bin",
		"On The Waves",
		"Psych858o",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Jammer-TakeYourTimeBabe-6x.sid",
		L"Out\\Built\\MusicData\\Jammer-TakeYourTimeBabe-6x.bin",
		"Take Your Time Babe",
		"Jammer",
		0x0ff6,
		0x1003,
		0x07ff,
		6
	},

	{
		L"6502\\Music\\PartyPiratesSide1.sid",
		L"Out\\Built\\MusicData\\PartyPiratesSide1.bin",
		"Party Pirates 1",
		"Stinsen and Steel",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Zardax-NoConocida.sid",
		L"Out\\Built\\MusicData\\Zardax-NoConocida.bin",
		"No Conocida",
		"Zardax",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Drax-ExpandSide2.sid",
		L"Out\\Built\\MusicData\\Drax-ExpandSide2.bin",
		"Expand Side 2",
		"Drax",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Flex-Lundia.sid",
		L"Out\\Built\\MusicData\\Flex-Lundai.bin",
		"Lundia",
		"Flex",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Jangler-Dynamite-2x.sid",
		L"Out\\Built\\MusicData\\Jangler-Dynamite-2x.bin",
		"Dynamite",
		"Jangler",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\PartyPiratesSide2.sid",
		L"Out\\Built\\MusicData\\PartyPiratesSide2.bin",
		"Party Pirates 2",
		"Stinsen and Steel",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Stinsen-Arpalooza.sid",
		L"Out\\Built\\MusicData\\Stinsen-Arpalooza.bin",
		"Arpalooza",
		"Stinsen",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Linus-Commando.sid",
		L"Out\\Built\\MusicData\\Linus-Commando.bin",
		"Commando",
		"Linus",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Linus-Monty.sid",
		L"Out\\Built\\MusicData\\Linus-Monty.bin",
		"Monty",
		"Linus",
		0x0800,
		0x0803,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Flex-Lundia-2x.sid",
		L"Out\\Built\\MusicData\\Flex-Lundia-2x.bin",
		"Lundia",
		"Flex",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Zardax-NoConocida-2x.sid",
		L"Out\\Built\\MusicData\\Zardax-NoConocida-2x.bin",
		"No Conocida",
		"Zardax",
		0x1000,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Jangler-Dynamite-2x.sid",
		L"Out\\Built\\MusicData\\Jangler-Dynamite-2x.bin",
		"Dynamite",
		"Jangler",
		0x0ff6,
		0x1003,
		0x07ff,
		2
	},

	{
		L"6502\\Music\\Fegolhuzz-AntikrundanAllstars.sid",
		L"Out\\Built\\MusicData\\Fegolhuzz-AntikrundanAllstars.bin",
		"Antikrundan Allstars",
		"Fegolhuzz",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Steel-TheCIsMine.sid",
		L"Out\\Built\\MusicData\\Steel-TheCIsMine.bin",
		"The C Is Mine",
		"Steel",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\DangerDawg.sid",
		L"Out\\Built\\MusicData\\DangerDawg.bin",
		"Danger Dawg",
		"MCH",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\demo-mch.sid",
		L"Out\\Built\\MusicData\\demo-mch.bin",
		"Delirious 11",
		"MCH",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Magnar-Wonderland12.sid",
		L"Out\\Built\\MusicData\\Magnar-Wonderland12.bin",
		"Wonderland 12",
		"Magnar",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Stinsen-Alla.sid",
		L"Out\\Built\\MusicData\\Stinsen-Alla.bin",
		"Alla",
		"Stinsen",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\MCH-GirlInTown.sid",
		L"Out\\Built\\MusicData\\MCH-GirlInTown.bin",
		"Girl In Town",
		"MCH",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Dive.sid",
		L"Out\\Built\\MusicData\\Dive.bin",
		"The Dive",
		"MCH",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Deek-Endtune.sid",
		L"Out\\Built\\MusicData\\Deek-Endtune.bin",
		"The Dive End Tune",
		"Deek",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Drax-FadeIn.sid",
		L"Out\\Built\\MusicData\\Drax-FadeIn.bin",
		"Fade In",
		"Drax",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\MarioIsDead.sid",
		L"Out\\Built\\MusicData\\MarioIsDead.bin",
		"Mario is Dead",
		"MCH and Jammer",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Fegolhuzz-AntikrundanAllstars.sid",
		L"Out\\Built\\MusicData\\Fegolhuzz-AntikrundanAllstars.bin",
		"Antikrundan Allstars",
		"Fegolhuzz",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\MrDeath-Bongo.sid",
		L"Out\\Built\\MusicData\\MrDeath-Bongo.bin",
		"Bongo",
		"Mr Death",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\.sid",
		L"Out\\Built\\MusicData\\.bin",
		"",
		"",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\Stinsen-BaitAndSwitch.sid",
		L"Out\\Built\\MusicData\\Stinsen-BaitAndSwitch.bin",
		"Bait and Switch",
		"Stinsen",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

/*{
		L"6502\\Music\\.sid",
		L"Out\\Built\\MusicData\\.bin",
		"",
		"",
		0x1000,
		0x1003,
		0x07ff,
		1
	},

	{
		L"6502\\Music\\.sid",
		L"Out\\Built\\MusicData\\.bin",
		"",
		"",
		0x1000,
		0x1003,
		0x07ff,
		1
	},*/

};
static const int NumSongs = sizeof(SongSetup) / sizeof(SONG_SETUP);

unsigned char RemapChar(unsigned char InChar)
{
	unsigned char OutChar = 0;

	if ((InChar >= 'A') && (InChar <= 'Z'))
		OutChar = 0x40 + (InChar & 0x1f);
	else if ((InChar >= 'a') && (InChar <= 'z'))
		OutChar = 0x00 + (InChar & 0x1f);
	else
	{
		OutChar = InChar & 0x7f;
		if (OutChar >= 0x60)
			OutChar = 0x20;
	}

	return OutChar;
}

void OutputSongData(void)
{
	OUT_SONG_DATA OutSongData;
	for (int Index = 0; Index < NumSongs; Index++)
	{
		SONG_SETUP& rSong = SongSetup[Index];

		ZeroMemory(&OutSongData, sizeof(OUT_SONG_DATA));

		OutSongData.InitAddr[0] = (rSong.InitAddr % 256);
		OutSongData.InitAddr[1] = (rSong.InitAddr / 256);

		OutSongData.PlayAddr[0] = (rSong.PlayAddr % 256);
		OutSongData.PlayAddr[1] = (rSong.PlayAddr / 256);

		OutSongData.VolumeAddr[0] = (rSong.VolumeAddr % 256);
		OutSongData.VolumeAddr[1] = (rSong.VolumeAddr / 256);

		OutSongData.NumPlayCallsPerFrame = rSong.NumPlayCallsPerFrame;

		memset(OutSongData.SongName_Artist, 0x20, sizeof(OutSongData.SongName_Artist));

		int nameStringLen = strlen(rSong.SongName);
		int artistStringLen = strlen(rSong.ArtistName);
		int stringLen = 1 + nameStringLen + 5 + artistStringLen;

		int OutIndex = (40 - stringLen) / 2;

		OutSongData.SongName_Artist[OutIndex++] = '\"';
		for (int i = 0; i < nameStringLen; i++)
		{
			unsigned char OutChar = 0;
			char InChar = rSong.SongName[i];

			if (InChar == 0)
				break;

			OutChar = RemapChar(InChar);

			OutSongData.SongName_Artist[OutIndex++] = OutChar;
		}
		OutSongData.SongName_Artist[OutIndex++] = '\"';
		OutSongData.SongName_Artist[OutIndex++] = ' ';
		OutSongData.SongName_Artist[OutIndex++] = RemapChar('b');
		OutSongData.SongName_Artist[OutIndex++] = RemapChar('y');
		OutSongData.SongName_Artist[OutIndex++] = ' ';
		for (int i = 0; i < artistStringLen; i++)
		{
			unsigned char OutChar = 0;
			char InChar = rSong.ArtistName[i];

			if (InChar == 0)
				break;

			OutChar = RemapChar(InChar);

			OutSongData.SongName_Artist[OutIndex++] = OutChar;
		}

		WriteBinaryFile(rSong.OutBINFilename, &OutSongData, sizeof(OUT_SONG_DATA));
	}
}


void GenerateFreqLookups(LPCTSTR FreqBINFilename)
{
	unsigned short NewFreqTable[NUM_FREQS_ON_SCREEN];
	for (int FreqIndex = 0; FreqIndex < NUM_FREQS_ON_SCREEN; FreqIndex++)
	{
		NewFreqTable[FreqIndex] = FreqTable[(FreqIndex * NumFreqs) / NUM_FREQS_ON_SCREEN + 2];
	}

	unsigned char OutFreqTable[2][256];
	for (int Index = 0; Index < 256; Index++)
	{
		unsigned short FreqHiMid = Index * 256 + 128;
		unsigned short FreqLoMid = Index * 4 + 2;

		unsigned char FreqHiVal = 0;
		unsigned char FreqLoVal = 0;
		for (int FreqIndex = 0; FreqIndex < NUM_FREQS_ON_SCREEN; FreqIndex++)
		{
			if (NewFreqTable[FreqIndex] < FreqHiMid)
			{
				FreqHiVal++;
			}
			if (NewFreqTable[FreqIndex] < FreqLoMid)
			{
				FreqLoVal++;
			}
		}

		OutFreqTable[0][Index] = FreqHiVal;
		OutFreqTable[1][Index] = FreqLoVal;
	}
	WriteBinaryFile(FreqBINFilename, OutFreqTable, sizeof(OutFreqTable));
}

void GenerateSoundSineBar(LPCTSTR SoundSineBarBINFilename)
{
	unsigned char SinTable[SineTableLength];
	for (int Index = 0; Index < SineTableLength; Index++)
	{
		double Angle = (Index * (PI / 2.0)) / SineTableLength;
		double SineVal = sin(Angle) * 79;
		SinTable[Index] = (unsigned char)SineVal;
	}

	WriteBinaryFile(SoundSineBarBINFilename, SinTable, SineTableLength);
}

void GenerateSpriteSineBar(LPCTSTR SpriteSineBarBINFilename)
{
	unsigned char SinTable[2][128];
	for (int Index = 0; Index < 128; Index++)
	{
		double Angle0 = (Index * 2 * PI) / 128;
		double SineVal = sin(Angle0) * 27.5 + 27.5;
		int iSineVal = (int)SineVal;
		int XPos = iSineVal;
		SinTable[0][Index] = (unsigned char)(iSineVal % 256);

		unsigned char XMSB = 0;
		for (int SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			if ((XPos >= 256) || (XPos < 0))
			{
				XMSB |= (1 << SpriteIndex);
			}
			XPos += 48;
		}
		SinTable[1][Index] = XMSB;
	}

	WriteBinaryFile(SpriteSineBarBINFilename, SinTable, sizeof(SinTable));
}

void UpdateBarChars(unsigned char* BarChars)
{
	for (int c = 0; c < 10; c++)
	{
		int TopPos = 8 - c;
		if ((TopPos & 3) == 1)
			TopPos++;

		for (int y = 0; y < 8; y++)
		{
			unsigned char OutChar = 0;
			unsigned char ReflectionOutChar0 = 0;
			unsigned char ReflectionOutChar1 = 0;

			if (y == TopPos)
			{
				OutChar = 0x7c;
			}
			else if (y > TopPos)
			{
				OutChar = 0xbe;
			}

			if (OutChar != 0)
			{
				ReflectionOutChar0 = (((y + c) & 1) == 0) ? 0x54 : 0xaa;
				ReflectionOutChar1 = (((y + c) & 1) == 1) ? 0x54 : 0xaa;
			}

			if ((y & 3) == 1)
				OutChar = 0;

			int OutIndex = ((c + 0) * 8) + y;
			BarChars[OutIndex] = OutChar;

			int ReflectionOutIndex0 = ((c + 10) * 8) + (7 - y);
			int ReflectionOutIndex1 = ((c + 20) * 8) + (7 - y);
			BarChars[ReflectionOutIndex0] = ReflectionOutChar0;
			BarChars[ReflectionOutIndex1] = ReflectionOutChar1;
		}
	}
}


void MergeCharSets(LPCTSTR InCharSetMAPFilename, LPCTSTR OutCharSetMAPFilename)
{
	unsigned char CharSet[256 * 8];

	ReadBinaryFile(InCharSetMAPFilename, CharSet, sizeof(CharSet));

	UpdateBarChars(&CharSet[224 * 8]);

	WriteBinaryFile(OutCharSetMAPFilename, CharSet, sizeof(CharSet));
}

int main()
{
	_mkdir("Out");
	_mkdir("Out\\Built");
	_mkdir("Out\\Built\\MusicData");

	GenerateFreqLookups(L"Out\\Built\\FreqTable.bin");

	GenerateSoundSineBar(L"Out\\Built\\SoundbarSine.bin");

	GenerateSpriteSineBar(L"Out\\Built\\SpriteSine.bin");

	OutputSongData();

	MergeCharSets(L"SourceData\\scrap-1x2font.map", L"Out\\Built\\CharSet.map");
}
