#include "PaletteLoader.h"
#include <algorithm>
#include <execution>
#include <fstream>
#include <sstream>
#include <filesystem>
#include <unordered_set>
#include <limits>
#include <iostream>

// OptimizedPaletteData implementation
bool OptimizedPaletteData::contains(unsigned int color) const {
    // First check hash map for O(1) lookup
    return colorToIndex.find(color) != colorToIndex.end();
}

unsigned char OptimizedPaletteData::getIndex(unsigned int color) const {
    // Hash lookup first
    auto it = colorToIndex.find(color);
    if (it != colorToIndex.end()) {
        return it->second;
    }

    // If exact match not found, could implement approximate matching here
    // For now, return invalid index
    return 0xFF;
}

unsigned int OptimizedPaletteData::getColor(unsigned char index) const {
    if (index >= PALETTE_SIZE) {
        return 0; // Return black for invalid index
    }
    return colors[index];
}

void OptimizedPaletteData::initialize(const unsigned int* inputColors) {
    // Copy colors
    std::copy_n(inputColors, PALETTE_SIZE, colors.begin());

    // Build sorted entries for binary search
    for (unsigned char i = 0; i < PALETTE_SIZE; ++i) {
        sortedEntries[i] = { colors[i], i };
        colorToIndex[colors[i]] = i;
    }

    // Sort by color value for binary search
    std::sort(sortedEntries.begin(), sortedEntries.end(),
        [](const ColorEntry& a, const ColorEntry& b) {
            return a.color < b.color;
        });

    // Pack colors for SIMD operations
    std::copy_n(colors.begin(), PALETTE_SIZE, packedColors);
}

// PaletteFileLoader implementation
std::vector<PaletteFileLoader::PaletteEntry> PaletteFileLoader::loadFromFile(const std::string& filename) {
    std::vector<PaletteEntry> palettes;
    std::ifstream file(filename);

    if (!file.is_open()) {
        throw std::runtime_error("Failed to open palette file: " + filename);
    }

    std::string line;

    // Skip header comments
    while (std::getline(file, line)) {
        if (line.empty() || line[0] == '#') {
            continue;
        }

        try {
            PaletteEntry entry = parseLine(line);
            if (validatePalette(entry)) {
                // Initialize optimized data
                entry.optimizedData.initialize(entry.colors.data());
                palettes.push_back(std::move(entry));
            }
        }
        catch (const std::exception& e) {
            // Log error and continue
            std::cerr << "Error parsing line: " << e.what() << std::endl;
        }
    }

    return palettes;
}

unsigned int PaletteFileLoader::parseHexColor(const std::string& hexStr) {
    // Remove any leading # if present
    std::string hex = hexStr;
    if (!hex.empty() && hex[0] == '$') {
        hex = hex.substr(1);
    }

    // Parse hex string
    unsigned int color = std::stoul(hex, nullptr, 16);

    // Ensure it's a valid RGB color (24-bit)
    color &= 0xFFFFFF;

    return color;
}

PaletteFileLoader::PaletteEntry PaletteFileLoader::parseLine(const std::string& line) {
    PaletteEntry entry;
    std::stringstream ss(line);
    std::string token;

    // Parse name
    if (!std::getline(ss, token, ',')) {
        throw std::runtime_error("Failed to parse palette name");
    }
    entry.name = token;

    // Parse 16 colors
    int colorIndex = 0;
    while (std::getline(ss, token, ',') && colorIndex < 16) {
        entry.colors[colorIndex++] = parseHexColor(token);
    }

    // Verify we got exactly 16 colors
    if (colorIndex != 16) {
        throw std::runtime_error("Palette must have exactly 16 colors, got " +
            std::to_string(colorIndex));
    }

    return entry;
}

bool PaletteFileLoader::validatePalette(const PaletteEntry& entry) {
    // Basic validation
    if (entry.name.empty()) {
        return false;
    }

    // Check for duplicate colors (optional)
    std::unordered_set<unsigned int> uniqueColors(entry.colors.begin(), entry.colors.end());
    if (uniqueColors.size() != entry.colors.size()) {
        std::cerr << "Warning: Palette '" << entry.name << "' has duplicate colors" << std::endl;
        // Not a hard error, just a warning
    }

    return true;
}
