// Genesis*Project

#pragma once

#include <memory>
#include <mutex>
#include <png.h>
#include <cstdint>
#include <array>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <cmath>
#include <limits>
#include <unordered_set>
#include <algorithm>
#include <span>
#include <filesystem>
#include <mutex>
#include "PaletteLoader.h"
#include "UpdatedPaletteManager.h"

struct C64RGBPalette { std::vector<unsigned int> colors; };

class GPIMAGE
{
public:
    // Constants
    static constexpr int TARGET_INNER_WIDTH = 320;
    static constexpr int TARGET_INNER_HEIGHT = 200;
    static constexpr int LEFT_BORDER_SIZE = 32;
    static constexpr int RIGHT_BORDER_SIZE = 32;
    static constexpr int TOP_BORDER_SIZE = 35;
    static constexpr int BOTTOM_BORDER_SIZE = 37;
    static constexpr int TARGET_WIDTH = TARGET_INNER_WIDTH + LEFT_BORDER_SIZE + RIGHT_BORDER_SIZE;
    static constexpr int TARGET_HEIGHT = TARGET_INNER_HEIGHT + TOP_BORDER_SIZE + BOTTOM_BORDER_SIZE;
    static constexpr unsigned int DEFAULT_BORDER_COLOR = 0x000000;

    // Static initialization function for palettes - MUST be called before using GPIMAGE
    static void InitializePalettes(const std::string& paletteTextFile = "c64_palettes.txt");

    // Alternative initialization using default paths
    static void InitializePalettesFromDefaults();

    // Check if palettes have been initialized
    static bool ArePalettesInitialized();

    GPIMAGE();
    GPIMAGE(int W, int H, unsigned int col = 0x00000000);
    explicit GPIMAGE(const char* filename);
    GPIMAGE(const char* filename, bool bAutoAlign, bool bFullImage);
    ~GPIMAGE() = default;

    // Rule of 5
    GPIMAGE(const GPIMAGE&) = delete;
    GPIMAGE& operator=(const GPIMAGE&) = delete;
    GPIMAGE(GPIMAGE&&) = default;
    GPIMAGE& operator=(GPIMAGE&&) = default;

    void Init(int w, int h, unsigned int col);
    void Init(const char* filename);
    void Init(const char* filename, bool bAutoAlign, bool bFullImage);

    void Fill(unsigned int col);

    bool Read(const char* filename, bool bAutoAlign = true, bool bFullImage = false);
    void Write(const char* filename);

    // Performance-optimized pixel access
    inline unsigned int GetPixel(int X, int Y) const noexcept {
#ifdef _DEBUG
        if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
            return 0xffffffff;
#endif
        return ImageData[Y * Width + X];
    }

    // Batch pixel operations with C++20 spans
    std::span<const unsigned int> GetPixelRow(int Y) const noexcept {
        if (Y < 0 || Y >= Height) return {};
        return std::span<const unsigned int>(&ImageData[Y * Width], Width);
    }

    std::span<unsigned int> GetPixelRowMutable(int Y) noexcept {
        if (Y < 0 || Y >= Height) return {};
        return std::span<unsigned int>(&ImageData[Y * Width], Width);
    }

    unsigned char GetPixelPaletteColour(int X, int Y) const;
    int ExtractPalette(std::vector<unsigned int>& ImagePalette);
    unsigned char GetPixelPaletteIndex(int X, int Y) const;

    inline void SetPixel(int X, int Y, unsigned int col) noexcept {
#ifdef _DEBUG
        if ((X < 0) || (X >= Width) || (Y < 0) || (Y >= Height))
            return;
#endif
        ImageData[Y * Width + X] = col;
    }

    void SetPixelPaletteColour(int X, int Y, unsigned char Index);

    void FixBorder(bool bAutoAlign, bool bFullImage);

    void UpdateImageDataWithPalette(const unsigned int* Palette, const std::string& NewPaletteType);
    void WriteCompressedPNG(const char* filename);

    int Width;
    int Height;
    int NumColours;
    bool validC64Border;
    std::string PaletteType;

    std::string calculateColorIndependentHash() const;

    // New utility functions
    bool IsValidCoordinate(int X, int Y) const noexcept {
        return X >= 0 && X < Width && Y >= 0 && Y < Height;
    }

    size_t GetPixelCount() const noexcept { return static_cast<size_t>(Width) * Height; }

private:
    // Use smart pointers for automatic memory management
    std::unique_ptr<unsigned int[]> ImageData;
    std::unique_ptr<unsigned char[]> PalettizedImageData;

    // Cache palette ID instead of string lookups
    int PaletteID = -1;
    static constexpr int INVALID_PALETTE_ID = -1;

    // Store direct reference to palette for fast lookup
    const OptimizedPaletteData* PalettePtr = nullptr;

    void PalettiseImage();
    int FindMatchingPaletteID(const std::vector<unsigned int>& imagePalette);
    inline unsigned int ConvertToGrey(const unsigned char* pixel);
    inline unsigned int ConvertToRGB(const unsigned char* pixel);

    // Static member to track initialization state
    static bool s_palettesInitialized;
    static std::mutex s_initMutex;
    static std::once_flag s_initOnceFlag;

    // Ensure palettes are loaded (internal use)
    void EnsurePalettesLoaded();
};

// Global functions for backward compatibility
bool GetPalette(const std::string& NewPaletteType, unsigned int* Palette);
void _WriteCompressedPNG(const char* filename, const unsigned int* ImageData, int Width, int Height);