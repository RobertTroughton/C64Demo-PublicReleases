#pragma once

#include "PaletteLoader.h"
#include <memory>
#include <mutex>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <filesystem>

class UpdatedPaletteManager {
public:
    static UpdatedPaletteManager& getInstance();

    // Initialize from file
    void initializeFromFile(const std::string& filename);

    // Get palette ID by name
    int getPaletteID(const std::string& name) const;

    // Get palette name by ID
    std::string_view getPaletteName(int id) const;

    // Get optimized palette data for fast operations
    const OptimizedPaletteData* getOptimizedPalette(int id) const;

    // Get palette colors (for compatibility)
    void getPaletteColors(int id, unsigned int* outColors) const;

    // Get number of palettes
    size_t getPaletteCount() const { return paletteEntries.size(); }

    // Find matching palette for an image
    int findMatchingPaletteID(const std::vector<unsigned int>& imageColors) const;

private:
    UpdatedPaletteManager() = default;

    // Palette data
    std::vector<PaletteFileLoader::PaletteEntry> paletteEntries;

    // Fast name-to-ID mapping
    std::unordered_map<std::string, int> nameToID;

    // Mutex for thread safety during initialization
    mutable std::mutex initMutex;
    bool initialized = false;

    // Helper to build name-to-ID mapping
    void buildMappings();
};

// Updated GPIMAGE class to use new palette system
class GPIMAGE_V2 {
public:
    // Configuration for palette file locations
    struct Config {
        static std::string paletteTextFile;
    };

    static void initializePalettes() {
        auto& pm = UpdatedPaletteManager::getInstance();
        pm.initializeFromFile(Config::paletteTextFile);
    }
};