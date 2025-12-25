//; Genesis*Project

#include "Common.h"

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#include "..\ThirdParty\STB\stb_image.h"
#include "..\ThirdParty\STB\stb_image_write.h"
#include "..\ThirdParty\STB\stb_image_resize.h"

#include <execution> // For parallel algorithms
#include <numeric>   // For std::iota
#include <filesystem>
#include <iostream>

// Static members initialization
bool GPIMAGE::s_palettesInitialized = false;
std::mutex GPIMAGE::s_initMutex;
std::once_flag GPIMAGE::s_initOnceFlag;

// GPIMAGE Implementation
GPIMAGE::GPIMAGE()
    : Width(0)
    , Height(0)
    , NumColours(0)
    , validC64Border(false)
    , PaletteID(INVALID_PALETTE_ID)
{
    // Ensure palettes are initialized just once
    std::call_once(s_initOnceFlag, []() {
        InitializePalettesFromDefaults();
        });
}

GPIMAGE::GPIMAGE(int w, int h, unsigned int col)
    : GPIMAGE() // Delegate to default constructor
{
    Init(w, h, col);
}

GPIMAGE::GPIMAGE(const char* filename)
    : GPIMAGE() // Delegate to default constructor
{
    Read(filename);
}

GPIMAGE::GPIMAGE(const char* filename, bool bAutoAlign, bool bFullImage)
    : GPIMAGE() // Delegate to default constructor
{
    Read(filename, bAutoAlign, bFullImage);
}

void GPIMAGE::InitializePalettes(const std::string& paletteTextFile) {
    std::lock_guard<std::mutex> lock(s_initMutex);

    if (s_palettesInitialized) {
        return; // Already initialized
    }

    auto& pm = UpdatedPaletteManager::getInstance();

    try {
        pm.initializeFromFile(paletteTextFile);
        s_palettesInitialized = true;
    }
    catch (const std::exception& e) {
        throw std::runtime_error("Failed to initialize palettes: " + std::string(e.what()));
    }
}

void GPIMAGE::InitializePalettesFromDefaults() {
    InitializePalettes("c64_palettes.txt");
}

bool GPIMAGE::ArePalettesInitialized() {
    std::lock_guard<std::mutex> lock(s_initMutex);
    return s_palettesInitialized;
}

void GPIMAGE::EnsurePalettesLoaded() {
    // This is now a simple check since initialization happens in constructor
    if (!s_palettesInitialized) {
        throw std::runtime_error("Palettes initialization failed.");
    }
}

void GPIMAGE::Init(int w, int h, unsigned int col) {
    Width = w;
    Height = h;
    ImageData = std::make_unique<unsigned int[]>(w * h);
    Fill(col);
}

void GPIMAGE::Init(const char* filename) {
    Read(filename);
}

void GPIMAGE::Init(const char* filename, bool bAutoAlign, bool bFullImage) {
    Read(filename, bAutoAlign, bFullImage);
}

void GPIMAGE::Fill(unsigned int col) {
    if (ImageData) {
        std::fill_n(ImageData.get(), static_cast<size_t>(Width) * Height, col);
    }
}

void GPIMAGE::PalettiseImage() {
    if (!PalettePtr) return;

    PalettizedImageData = std::make_unique<unsigned char[]>(Width * Height);

    // Process in chunks for better cache locality
    constexpr size_t CHUNK_SIZE = 64;

#pragma omp parallel for schedule(dynamic)
    for (int y = 0; y < Height; y++) {
        const unsigned int* row = &ImageData[y * Width];
        unsigned char* outRow = &PalettizedImageData[y * Width];

        for (int x = 0; x < Width; x += CHUNK_SIZE) {
            int chunkEnd = std::min(x + static_cast<int>(CHUNK_SIZE), Width);
            for (int i = x; i < chunkEnd; i++) {
                outRow[i] = PalettePtr->getIndex(row[i]);
            }
        }
    }
}

unsigned char GPIMAGE::GetPixelPaletteColour(int x, int y) const {
    if (!IsValidCoordinate(x, y) || !PalettePtr) return 0;
    unsigned int color = GetPixel(x, y);
    return PalettePtr->getIndex(color);
}

unsigned char GPIMAGE::GetPixelPaletteIndex(int x, int y) const {
    if (!IsValidCoordinate(x, y) || !PalettizedImageData) return 0xff;
    return PalettizedImageData[y * Width + x];
}

bool GPIMAGE::Read(const char* filename, bool bAutoAlign, bool bFullImage) {
    // No need to check palettes here anymore - done in constructor

    int NumComps;
    unsigned char* Data = stbi_load(filename, &Width, &Height, &NumComps, 0);

    if (!Data) {
        std::cerr << "GPImage::Read() failed to load '" << filename << "'\n";
        Width = Height = 0;
        return false;
    }

    // Create unique_ptr for image data with custom deleter
    auto dataDeleter = [](unsigned char* p) { stbi_image_free(p); };
    std::unique_ptr<unsigned char, decltype(dataDeleter)> dataPtr(Data, dataDeleter);

    ImageData = std::make_unique<unsigned int[]>(Width * Height);

    // Parallel conversion for large images
    const size_t pixelCount = Width * Height;

    unsigned char* pPixelData = Data;
    if (NumComps == 1 || NumComps == 2) {
        for (int i = 0; i < static_cast<int>(pixelCount); i++) {
            ImageData[i] = (pPixelData[0] << 16) | (pPixelData[0] << 8) | (pPixelData[0] << 0);
            pPixelData += NumComps;
        }
    }
    else {
        for (int i = 0; i < static_cast<int>(pixelCount); i++) {
            ImageData[i] = (pPixelData[0] << 16) | (pPixelData[1] << 8) | (pPixelData[2] << 0);
            pPixelData += NumComps;
        }
    }

//;    FixBorder(bAutoAlign, bFullImage);

    std::vector<unsigned int> ImagePalette;
    NumColours = ExtractPalette(ImagePalette);

    if (NumColours <= 16) {
        PaletteID = FindMatchingPaletteID(ImagePalette);
        if (PaletteID != INVALID_PALETTE_ID) {
            auto& pm = UpdatedPaletteManager::getInstance();
            PaletteType = std::string(pm.getPaletteName(PaletteID));
            PalettePtr = pm.getOptimizedPalette(PaletteID);
            PalettiseImage();
        }
    }

    return true;
}

void GPIMAGE::SetPixelPaletteColour(const int x, const int y, const unsigned char Index) {
    if (!PalettePtr || !IsValidCoordinate(x, y)) return;

    if (Index < 16) {
        unsigned int Colour = PalettePtr->getColor(Index);
        SetPixel(x, y, Colour);
    }
}

int GPIMAGE::ExtractPalette(std::vector<unsigned int>& imagePalette) {
    std::unordered_set<unsigned int> paletteSet;
    paletteSet.reserve(16);

    // Process in blocks for better cache performance
    const size_t blockSize = 1024;
    unsigned int lastColor = 0xffffffff;

    for (size_t offset = 0; offset < static_cast<size_t>(Width) * Height; offset += blockSize) {
        size_t end = std::min(offset + blockSize, static_cast<size_t>(Width) * Height);

        for (size_t i = offset; i < end; ++i) {
            unsigned int newColor = ImageData[i];
            if (newColor != lastColor) {
                paletteSet.insert(newColor);
                lastColor = newColor;

                // Early exit if too many colors
                if (paletteSet.size() > 16) {
                    imagePalette.assign(paletteSet.begin(), paletteSet.end());
                    return static_cast<int>(paletteSet.size());
                }
            }
        }
    }

    imagePalette.assign(paletteSet.begin(), paletteSet.end());
    return static_cast<int>(paletteSet.size());
}

int GPIMAGE::FindMatchingPaletteID(const std::vector<unsigned int>& imagePalette) {
    auto& pm = UpdatedPaletteManager::getInstance();
    return pm.findMatchingPaletteID(imagePalette);
}

void GPIMAGE::FixBorder(bool bAutoAlign, bool bFullImage) {
    if (!bAutoAlign && Width == TARGET_WIDTH && Height == TARGET_HEIGHT) {
        return;
    }

    int leftBorder = 0, rightBorder = 0, topBorder = 0, bottomBorder = 0;
    unsigned int borderColor = DEFAULT_BORDER_COLOR;

    if ((Width > 320) || (Height > 200)) {
        borderColor = ImageData[0];
    }

    if (bAutoAlign) {
        // Efficient border detection using row-wise operations

        // Check top border
        for (int y = 0; y < Height; y++) {
            auto row = GetPixelRow(y);
            bool isBorder = true;
            for (unsigned int pixel : row) {
                if (pixel != borderColor) {
                    topBorder = y;
                    isBorder = false;
                    break;
                }
            }
            if (!isBorder) break;
        }

        // Check bottom border
        for (int y = Height - 1; y >= 0; y--) {
            auto row = GetPixelRow(y);
            bool isBorder = true;
            for (unsigned int pixel : row) {
                if (pixel != borderColor) {
                    bottomBorder = Height - 1 - y;
                    isBorder = false;
                    break;
                }
            }
            if (!isBorder) break;
        }

        // Check left border (column-wise)
        for (int x = 0; x < Width; x++) {
            bool isBorder = true;
            for (int y = 0; y < Height; y++) {
                if (GetPixel(x, y) != borderColor) {
                    leftBorder = x;
                    isBorder = false;
                    break;
                }
            }
            if (!isBorder) break;
        }

        // Check right border
        for (int x = Width - 1; x >= 0; x--) {
            bool isBorder = true;
            for (int y = 0; y < Height; y++) {
                if (GetPixel(x, y) != borderColor) {
                    rightBorder = Width - 1 - x;
                    isBorder = false;
                    break;
                }
            }
            if (!isBorder) break;
        }

        // Check if already correct
        if (leftBorder == LEFT_BORDER_SIZE && rightBorder == RIGHT_BORDER_SIZE &&
            topBorder == TOP_BORDER_SIZE && bottomBorder == BOTTOM_BORDER_SIZE &&
            Width == TARGET_WIDTH && Height == TARGET_HEIGHT) {
            return;
        }
    }

    validC64Border = (topBorder >= TOP_BORDER_SIZE && bottomBorder >= BOTTOM_BORDER_SIZE &&
        leftBorder >= LEFT_BORDER_SIZE && rightBorder >= RIGHT_BORDER_SIZE);

    // Calculate new dimensions
    int sourceInnerWidth = Width - (leftBorder + rightBorder);
    int sourceInnerHeight = Height - (topBorder + bottomBorder);

    int targetWidth = TARGET_WIDTH;
    int targetHeight = TARGET_HEIGHT;

    if (bFullImage) {
        if (sourceInnerWidth > TARGET_INNER_WIDTH) {
            targetWidth = sourceInnerWidth + 64;
        }
        if (sourceInnerHeight > TARGET_INNER_HEIGHT) {
            targetHeight = sourceInnerHeight + 72;
        }
    }
    else {
        if (sourceInnerWidth > TARGET_INNER_WIDTH) {
            if (sourceInnerHeight > TARGET_INNER_HEIGHT) {
                return; // Nothing to do
            }
            sourceInnerWidth = Width;
            leftBorder = rightBorder = 0;
        }

        if (sourceInnerHeight > TARGET_INNER_HEIGHT) {
            sourceInnerHeight = Height;
            topBorder = bottomBorder = 0;
        }
    }

    // Only resize if necessary
    if (sourceInnerWidth <= targetWidth && sourceInnerHeight <= targetHeight) {
        int newWidth = targetWidth;
        int newHeight = targetHeight;

        int startInX = leftBorder;
        int startInY = topBorder;
        int startOutX = (targetWidth - sourceInnerWidth) / 2;
        int startOutY = std::max(0, (targetHeight - sourceInnerHeight) / 2 - 1);

        // Create new image with border
        auto newImageData = std::make_unique<unsigned int[]>(newWidth * newHeight);
        std::fill_n(newImageData.get(), static_cast<size_t>(newWidth) * newHeight, borderColor);

        // Copy image data efficiently
        for (int y = 0; y < sourceInnerHeight; ++y) {
            const int srcOffset = (y + startInY) * Width + startInX;
            const int dstOffset = (y + startOutY) * newWidth + startOutX;
            std::copy_n(&ImageData[srcOffset], sourceInnerWidth, &newImageData[dstOffset]);
        }

        Width = newWidth;
        Height = newHeight;
        ImageData = std::move(newImageData);
    }
}

void GPIMAGE::UpdateImageDataWithPalette(const unsigned int* Palette, const std::string& NewPaletteType) {
    if (!PalettizedImageData || PaletteType == NewPaletteType) {
        return;
    }

    auto& pm = UpdatedPaletteManager::getInstance();
    int newPaletteID = pm.getPaletteID(NewPaletteType);
    if (newPaletteID == INVALID_PALETTE_ID) {
        return;
    }

    // Update image data with new palette
#pragma omp parallel for
    for (int i = 0; i < Width * Height; i++) {
        unsigned char originalIndex = PalettizedImageData[i] % 16;
        ImageData[i] = Palette[originalIndex];
    }

    PaletteType = NewPaletteType;
    PaletteID = newPaletteID;
    PalettePtr = pm.getOptimizedPalette(PaletteID);
}

std::string GPIMAGE::calculateColorIndependentHash() const {
    if ((Width != 384) || (Height != 272) || (!PalettizedImageData)) {
        return "";
    }

    int startX = validC64Border ? 32 : 0;
    int startY = validC64Border ? 35 : 0;
    int endX = validC64Border ? 384 - 32 : 384;
    int endY = validC64Border ? 272 - 37 : 272;

    std::vector<unsigned char> normalizedPalettedImage(Width * Height, 0);

    // Process line by line for color normalization
    for (int y = startY; y < endY; ++y) {
        unsigned char colorMap[16] = { 0 };
        unsigned char nextColor = 0;

        for (int x = startX; x < endX; ++x) {
            unsigned char originalColor = PalettizedImageData[y * 384 + x];

            if (colorMap[originalColor] == 0) {
                colorMap[originalColor] = ++nextColor;
            }

            normalizedPalettedImage[y * 384 + x] = colorMap[originalColor] - 1;
        }
    }

    // Calculate hash
    std::array<unsigned char, EVP_MAX_MD_SIZE> combinedHash;
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    const EVP_MD* md = EVP_md5();
    unsigned int mdLen = 0;

    EVP_DigestInit_ex(mdctx, md, NULL);
    EVP_DigestUpdate(mdctx, normalizedPalettedImage.data(), normalizedPalettedImage.size());
    EVP_DigestFinal_ex(mdctx, combinedHash.data(), &mdLen);
    EVP_MD_CTX_free(mdctx);

    // Convert to hex string
    std::ostringstream hashString;
    for (unsigned int i = 0; i < mdLen; i++) {
        hashString << std::hex << std::setw(2) << std::setfill('0')
            << static_cast<int>(combinedHash[i]);
    }

    return hashString.str();
}

void GPIMAGE::Write(const char* filename) {
    WriteCompressedPNG(filename);
}

void GPIMAGE::WriteCompressedPNG(const char* filename) {
    _WriteCompressedPNG(filename, ImageData.get(), Width, Height);
}

// Global function implementations for backward compatibility
bool GetPalette(const std::string& NewPaletteType, unsigned int* Palette) {
    if (!Palette)
        return false;

    // The palette system will be initialized automatically when first GPIMAGE is created
    auto& pm = UpdatedPaletteManager::getInstance();
    int paletteID = pm.getPaletteID(NewPaletteType);
    if (paletteID < 0) {
        return false;
    }
    pm.getPaletteColors(paletteID, Palette);
    return true;
}

void _WriteCompressedPNG(const char* filename, const unsigned int* ImageData, int Width, int Height) {
    std::filesystem::path path(filename);
    if (path.has_parent_path()) {
        std::filesystem::create_directories(path.parent_path());
    }

    FILE* fp;
    errno_t err = fopen_s(&fp, filename, "wb");
    if (err != 0 || !fp) {
        std::cerr << "Could not open file for writing\n";
        return;
    }

    png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
    if (!png_ptr) {
        std::cerr << "Could not allocate write struct\n";
        fclose(fp);
        return;
    }

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        std::cerr << "Could not allocate info struct\n";
        fclose(fp);
        png_destroy_write_struct(&png_ptr, nullptr);
        return;
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        std::cerr << "Error during PNG creation\n";
        fclose(fp);
        png_destroy_write_struct(&png_ptr, &info_ptr);
        return;
    }

    png_init_io(png_ptr, fp);
    png_set_IHDR(png_ptr, info_ptr, Width, Height, 8, PNG_COLOR_TYPE_RGB,
        PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

    png_write_info(png_ptr, info_ptr);

    // Write rows efficiently
    std::vector<png_byte> row(Width * 3);

    for (int y = 0; y < Height; y++) {
        // Convert row to RGB
#pragma omp parallel for
        for (int x = 0; x < Width; x++) {
            unsigned int pixel = ImageData[y * Width + x];
            row[x * 3 + 0] = (pixel >> 16) & 0xFF; // Red
            row[x * 3 + 1] = (pixel >> 8) & 0xFF;  // Green
            row[x * 3 + 2] = (pixel) & 0xFF;       // Blue
        }
        png_write_row(png_ptr, row.data());
    }

    png_write_end(png_ptr, nullptr);

    fclose(fp);
    png_destroy_write_struct(&png_ptr, &info_ptr);
}