#pragma once

#include <fstream>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <array>
#include <immintrin.h> // For SIMD operations

// Forward declarations
class OptimizedPaletteData;

// Optimized palette data structures
class OptimizedPaletteData {
public:
    static constexpr size_t PALETTE_SIZE = 16;
    static constexpr size_t COLOR_BITS = 24; // RGB 24-bit

    // Optimized color matching using SIMD
    bool contains(unsigned int color) const;

    // Fast index lookup using binary search
    unsigned char getIndex(unsigned int color) const;

    // Fast color lookup using direct indexing
    unsigned int getColor(unsigned char index) const;

    // Initialize from raw data
    void initialize(const unsigned int* colors);

    // Pre-computed lookup tables for fast operations
    struct ColorEntry {
        unsigned int color;
        unsigned char index;
    };

private:
    // Original palette colors
    std::array<unsigned int, PALETTE_SIZE> colors;

    // Sorted entries for binary search
    std::array<ColorEntry, PALETTE_SIZE> sortedEntries;

    // SIMD-friendly packed data
    alignas(32) unsigned int packedColors[PALETTE_SIZE];

    // Hash-based lookup for O(1) average case
    std::unordered_map<unsigned int, unsigned char> colorToIndex;

    // Optional: Color distance cache for approximate matching
    mutable std::unordered_map<unsigned int, unsigned char> distanceCache;
};

// Palette file loader
class PaletteFileLoader {
public:
    struct PaletteEntry {
        std::string name;
        std::array<unsigned int, 16> colors;
        OptimizedPaletteData optimizedData;
    };

    // Load palettes from text file
    static std::vector<PaletteEntry> loadFromFile(const std::string& filename);

    // Parse hex color string
    static unsigned int parseHexColor(const std::string& hexStr);

private:
    // Parse single line from text file
    static PaletteEntry parseLine(const std::string& line);

    // Validate palette data
    static bool validatePalette(const PaletteEntry& entry);
};