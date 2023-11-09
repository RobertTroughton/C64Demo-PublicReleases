#include "..\Common\Common.h"

unsigned char MapOut[256 * 96]{};			// (170+85) x 90
unsigned char ByteCnt[96 * 3]{};    		// FULL BYTES x 85, PIXELS in PARTIAL BYTES * 85, SPRITE OFFSET OF FIRST PIXEL * 85 
unsigned char Offsets[4320]{};              // OFFSETS OF PIXELS WITHIN MAP ROWS (max. 48*90= 4320 values)
unsigned char PixelCnt[96]{};
unsigned char SinTab[1024]{};

void CreateSineTable(LPTSTR OutSineTableBIN)
{
    unsigned char SinTab[1024]{};

    for (int i = 0; i < 200; i++)
    {
        double a = round(0x58 + 0x90 + (0x90 * cos((i + 0.5) * PI / 200)));
        unsigned int b = (unsigned int)a;
        SinTab[i] = b % 256;
        SinTab[512 + i] = b / 256;
        a = round(0x98 + 0x90 + (0x90 * cos((i + 0.5) * PI / 200)));
        b = (unsigned int)a;
        SinTab[312 + i] = b % 256;
        SinTab[512 + 312 + i] = 1 - (b / 256);
    }
    
    for (int i = 0; i < 112; i++)
    {
        double a = round(0x58 + 0x30 - (48 * cos((i + 0.5) * PI / 112)));
        unsigned int b = (unsigned int)a;
        SinTab[200 + i] = b % 256;
        SinTab[512 + 200 + i] = b / 256;
    }

    WriteBinaryFile(OutSineTableBIN, SinTab,sizeof(SinTab));

}

void ConvertMap(char* InMapPNG, LPTSTR OutMapBIN, LPTSTR OutByteCntBIN, LPTSTR OutOffsetsBIN, LPTSTR OutInterleaveTableBIN)
{

    double SL1 = round((1.0 * 96.0) / 7.0);
    double SL2 = round((2.0 * 96.0) / 7.0);
    double SL3 = round((3.0 * 96.0) / 7.0);

    int SkipLine1 = (int)SL1;
    int SkipLine2 = (int)SL2;
    int SkipLine3 = (int)SL3;
    int SkipLine4 = 95 - SkipLine3;
    int SkipLine5 = 95 - SkipLine2;
    int SkipLine6 = 95 - SkipLine1;
    int SkipLine7 = 0;
    int SkipLine8 = 88;
    int SkipLine9 = 89;
    int SkipLineA = 90;
    int SkipLineB = 95;

    GPIMAGE InMap(InMapPNG);

    int MapWidth = 170;

    for (int y = 0; y < InMap.Height; y++)
    {
        for (int x = 0; x < MapWidth; x++)      //; Only convert the first 170 pixels
        {
            unsigned int c = InMap.GetPixel(x, y);
            unsigned char PixelOut = 255;
            
            if ((c == 0x000000) || (c == 0x00137f))         //; Navy Blue (c == 0x3e31a2) orig: (c == 0x00137f)
            {
                PixelOut = 0;
            }
            else if ((c == 0x352879) || (c == 0x267f00))    //; Green (c == 0x68a941)  (c == 0x267f00)
            {
                PixelOut = 1;
            }
            else if ((c == 0x68372B) || (c == 0xffd800))    //; Yellow (c == 0x7ABFC7)  (c == 0xffd800)
            {
                PixelOut = 2;
            }
            else if ((c == 0x6F4F25) || (c == 0xffffff))    //; White  (c == 0xffffff)
            {
                PixelOut = 3;
            }
            else
            {
                cout << "Unrecognized pixel color at " << x << ":" << y << " in " << InMapPNG << "\n";
            }
            MapOut[(y * 256) + x] = PixelOut;
        }
    }

    int ThisStep = 0;
    int R = 48;
    int TotalBytes = 0;

    for (int y = -48; y < 48; y++)
    {
        double a = round(sqrt((R * R) - ((y + 0.5) * (y + 0.5))) / 2) * 2;
        int x = (int)a;
        PixelCnt[y + 48] = x % 256;
        x = (int)floor((a + 6) / 8);
        ByteCnt[y + 48] = x; //floor((a + 6) / 8);

        TotalBytes += ((x + 6) / 8) * 2;
        x = (int)a;
        for (int i = x - 1; i > -1; i--)
        {
            double aa = floor((MapWidth / 2) * (acos((-(a / 2) + 0.5 + i) / (a / 2)) / PI));
            unsigned int b = (unsigned int)aa;
            Offsets[ThisStep++] = b % 256;
        }
    }

    int RowCnt = 95;
    int OldSteps = 0;
    int NewSteps = 0;
    int ThisLine = 0;

    for (int y = 0; y < 95; y++)
    {
    SkipCheck:
        if ((y == SkipLine1) || (y == SkipLine2) || (y == SkipLine3) || (y == SkipLine4) || (y == SkipLine5) || (y == SkipLine6) || (y == SkipLine7) || (y == SkipLine8) || (y == SkipLine9) || (y == SkipLineA) || (y == SkipLineB))
        {
            OldSteps += PixelCnt[y++];
            RowCnt--;
            goto SkipCheck;
        }

        for (int i = 0; i < PixelCnt[y]; i++)
        {
            Offsets[NewSteps + i] = Offsets[OldSteps + i];
        }
        NewSteps += PixelCnt[y];
        OldSteps += PixelCnt[y];

        for (int x = 0; x <= InMap.Width; x++)
        {
            MapOut[(ThisLine * 256) + x] = MapOut[(y * 256) + x];
        }
        ByteCnt[ThisLine] = ByteCnt[y];
        PixelCnt[ThisLine++] = PixelCnt[y];
    }

    //WriteBinaryFile(L"Link\\Earth\\PixelCnt.bin", PixelCnt, ThisLine);

    unsigned char SpAddLo = 3;
    unsigned char SpAddHi = 0xE4;
    unsigned char SpIL[96 * 2]{};

    ThisLine = 0;

    for (int y = 1; y < 89; y++)
    {
    SkipCheck2:
        if ((y == 0) || (y == 82) || (y == 83) || (y == 84) || (y == 89))
        {
            SpAddLo += 3;
            if (SpAddLo >= 63)
            {
                SpAddLo = 0;
            }
            if (y % 20 == 0)
            {
                SpAddHi += 2;
            }
            y++;
            goto SkipCheck2;
        }
        SpIL[ThisLine] = SpAddLo;
        SpIL[RowCnt + ThisLine] = SpAddHi;

        SpAddLo += 3;
        if (SpAddLo >= 63)
        {
            SpAddLo = 0;
        }
        if (y % 20 == 0)
        {
            SpAddHi += 2;
        }

        ThisLine++;
    }

    for (int i = 0; i < RowCnt; i++)
    {
        int Partial = (PixelCnt[i] / 2) % 4;
        ByteCnt[RowCnt + i] = Partial;
        int Full = (ByteCnt[i] * 2) - (Partial == 0 ? 0 : 2);
        ByteCnt[i] = Full;

        unsigned char Offset = (((24 - PixelCnt[i] / 2) / 4) / 3) * 128;
        Offset += (((24 - (PixelCnt[i] / 2)) % 12)) / 4;
        SpIL[i] += Offset;
        ByteCnt[i + (RowCnt * 2)] = (Offset & 127);
    }
    
    /*
    for (int Phase = 169; Phase >= 0; Phase--)  //Rotation phases
    {
        int CurrentOffset = 0;
        int NumZeros = 0;
        for (int Y = 0; Y < RowCnt; Y++)    // Map rows
        {
            int FirstMapRowOffset = Offsets[CurrentOffset];

            for (int X = FirstMapRowOffset - 1; X >= 0 ; X--)
            {
                MapOut[(Y * 256) + X] = MapOut[(Y * 256) + X + 1];      //Bytes 0 -> First Offset in each map row are never used, clear them
            }
            
            CurrentOffset += PixelCnt[Y];

            int LastMapRowOffset = Offsets[CurrentOffset - 1];
            
            for (int X = 170 + LastMapRowOffset; X < 256; X++)
            {
                MapOut[(Y * 256) + X] = MapOut[(Y * 256) + X - 1];      //Bytes Last Offset -> 255 in each map row are never used, clear them
            }

        }
    }
    */

    unsigned char CompressedMap[85 * 64]{};

    for (int i = 0; i < 85 * 64; i++)
    {
        unsigned char ThisVal = MapOut[i * 4] + (4 * MapOut[(i * 4) + 1]) + (16 * MapOut[(i * 4) + 2]) + (64 * MapOut[(i * 4) + 3]);
        CompressedMap[i] = ThisVal;
    }

    WriteBinaryFile(OutMapBIN, CompressedMap, RowCnt * 64);
    WriteBinaryFile(OutByteCntBIN, ByteCnt, RowCnt * 3);
    WriteBinaryFile(OutOffsetsBIN, Offsets, NewSteps);
    WriteBinaryFile(OutInterleaveTableBIN, SpIL, RowCnt * 2);
}

void ConvertSprites(char* InGlobePNG, char* InShadowPNG, LPTSTR OutSpritesBIN)
{
    unsigned char Sprites[12 * 64]{}; //; 10 globe sprites and 2 shadow sprites

    GPIMAGE InGlobe(InGlobePNG);

    for (int y = 0; y < InGlobe.Height; y++)
    {
        for (int x = 0; x < InGlobe.Width; x++)
        {
            int i = (x / 8) + ((x / 24) * (64 - 3)) + ((y % 21) * 3) + ((y / 21) * 128);

            int Shift = (7 - (x % 8));

            unsigned char V = 0;

            int Pixel = InGlobe.GetPixel(x, y);
            if (Pixel == 0x000080)      //; Navy Blue
            {
                V = 1 << Shift;
            }
            else if (Pixel == 0)        //; background
            {
                V = 0;
            }
            else
            {
                cout << "Unrecognized pixel color at " << x << ":" << y << " in " << InGlobePNG << "\n";
            }
            Sprites[i] += V;
        }
    }

    for (int y = 80; y < 84; y++)
    { 
        int FromLine = ((y % 21) * 3) + ((y / 21) * 128);
        int ToLine = (((y + 21) % 21) * 3) + (((y + 21) / 21) * 128);
        for (int x = 0; x < 3; x++)
        {
            Sprites[ToLine + x] = Sprites[FromLine + x];
            Sprites[ToLine + 64 + x] = Sprites[FromLine + 64 + x];
        }
    }

    for (int y = 60; y < 63; y++)
    {
        int FromLine = ((y % 21) * 3) + ((y / 21) * 128);
        int ToLine = (((y + 21) % 21) * 3) + (((y + 21) / 21) * 128);
        for (int x = 0; x < 3; x++)
        {
            Sprites[ToLine + x] = Sprites[FromLine + x];
            Sprites[ToLine + 64 + x] = Sprites[FromLine + 64 + x];
        }
    }

    for (int y = 40; y < 42; y++)
    {
        int FromLine = ((y % 21) * 3) + ((y / 21) * 128);
        int ToLine = (((y + 21) % 21) * 3) + (((y + 21) / 21) * 128);
        for (int x = 0; x < 3; x++)
        {
            Sprites[ToLine + x] = Sprites[FromLine + x];
            Sprites[ToLine + 64 + x] = Sprites[FromLine + 64 + x];
        }
    }

    for (int y = 20; y < 21; y++)
    {
        int FromLine = ((y % 21) * 3) + ((y / 21) * 128);
        int ToLine = (((y + 21) % 21) * 3) + (((y + 21) / 21) * 128);
        for (int x = 0; x < 3; x++)
        {
            Sprites[ToLine + x] = Sprites[FromLine + x];
            Sprites[ToLine + 64 + x] = Sprites[FromLine + 64 + x];
        }
    }

    GPIMAGE InShadow(InShadowPNG);

    for (int y = 0; y < InShadow.Height; y++)
    {
        for (int x = 0; x < InShadow.Width; x++)
        {
            int i = (10 * 64) + (x / 8) + ((x / 24) * (64 - 3)) + ((y % 21) * 3) + ((y / 21) * 128);

            int Shift = (7 - (x % 8));

            unsigned char V = 0;

            int Pixel = InShadow.GetPixel(x, y);
            if (Pixel == 0x000080)      //; Navy Blue
            {
                V = 1 << Shift;
            }
            else if (Pixel == 0)        //; background
            {
                V = 0;
            }
            else
            {
                cout << "Unrecognized pixel color at " << x << ":" << y << " in " << InShadowPNG << "\n";
            }
            Sprites[i] += V;
        }
    }

    WriteBinaryFile(OutSpritesBIN, Sprites, sizeof(Sprites));

}

int Earth_Main()
{
    CreateSineTable(L"Link\\Earth\\SineTable.bin");

    ConvertMap("Parts\\Earth\\Data\\Map170x96Facet.png", L"Link\\Earth\\Map.bin", L"Link\\Earth\\ByteCnt.bin", L"Link\\Earth\\Offsets.bin", L"Link\\Earth\\SpriteInterleave.bin");

    ConvertSprites("Parts\\Earth\\Data\\BlueGlobe.png", "Parts\\Earth\\Data\\Shadow.png", L"Link\\Earth\\BlueGlobeSprites.bin");

    return 0;
}