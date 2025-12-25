#include "UpdatedPaletteManager.h"
#include <filesystem>
#include <algorithm>
#include <execution>
#include <unordered_set>

// Static configuration
std::string GPIMAGE_V2::Config::paletteTextFile = "c64_palettes.txt";

UpdatedPaletteManager& UpdatedPaletteManager::getInstance() {
    static UpdatedPaletteManager instance;
    return instance;
}

void UpdatedPaletteManager::initializeFromFile(const std::string& filename) {
    std::lock_guard<std::mutex> lock(initMutex);

    if (initialized) {
        return; // Already initialized
    }

    try {
        paletteEntries = PaletteFileLoader::loadFromFile(filename);
        buildMappings();
        initialized = true;
    }
    catch (const std::exception& e) {
        throw std::runtime_error("Failed to initialize palettes from file: " + std::string(e.what()));
    }
}

void UpdatedPaletteManager::buildMappings() {
    nameToID.clear();
    nameToID.reserve(paletteEntries.size());

    for (size_t i = 0; i < paletteEntries.size(); ++i) {
        nameToID[paletteEntries[i].name] = static_cast<int>(i);
    }
}

int UpdatedPaletteManager::getPaletteID(const std::string& name) const {
    auto it = nameToID.find(name);
    return (it != nameToID.end()) ? it->second : -1;
}

std::string_view UpdatedPaletteManager::getPaletteName(int id) const {
    if (id >= 0 && id < static_cast<int>(paletteEntries.size())) {
        return paletteEntries[id].name;
    }
    return {};
}

const OptimizedPaletteData* UpdatedPaletteManager::getOptimizedPalette(int id) const {
    if (id >= 0 && id < static_cast<int>(paletteEntries.size())) {
        return &paletteEntries[id].optimizedData;
    }
    return nullptr;
}

void UpdatedPaletteManager::getPaletteColors(int id, unsigned int* outColors) const {
    if (id >= 0 && id < static_cast<int>(paletteEntries.size()) && outColors) {
        const auto& palette = paletteEntries[id];
        std::copy_n(palette.colors.begin(), 16, outColors);
    }
}

int UpdatedPaletteManager::findMatchingPaletteID(const std::vector<unsigned int>& imageColors) const {
    if (imageColors.empty() || imageColors.size() > 16) {
        return -1;
    }

    // Create set for fast lookup
    std::unordered_set<unsigned int> imageColorSet(imageColors.begin(), imageColors.end());

    // Find matching palette
    for (size_t id = 0; id < paletteEntries.size(); ++id) {
        const auto& palette = paletteEntries[id].optimizedData;

        // Check if all image colors exist in palette
        bool allColorsFound = true;
        for (unsigned int color : imageColors) {
            if (!palette.contains(color)) {
                allColorsFound = false;
                break;
            }
        }

        if (allColorsFound) {
            return static_cast<int>(id);
        }
    }

    return -1;
}