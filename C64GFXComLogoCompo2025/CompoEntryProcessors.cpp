#include <string>
#include <iostream>
#include <fstream>
#include <optional>
#include <filesystem>

#include "Common/Common.h"

struct ParsedEntry {
	int placing;
	std::string artistName;
	int releaseID;
};

unsigned char BINBuffer[65536];
unsigned char SparkleBIN[65536];

static int ReleasesToOverride[] = { 253149, 253361 };

bool RecursiveCopyDirectory(const std::string& source, const std::string& destination, bool overwrite) {
	namespace fs = std::filesystem;

	try {
		// Check if source exists
		if (!fs::exists(source) || !fs::is_directory(source)) {
			std::cerr << "Source directory does not exist or is not a directory: " << source << std::endl;
			return false;
		}

		// Create destination directory if it doesn't exist
		if (!fs::exists(destination)) {
			fs::create_directories(destination);
		}

		// Copy options
		auto copyOptions = fs::copy_options::recursive;
		if (overwrite) {
			copyOptions |= fs::copy_options::overwrite_existing;
		}
		else {
			copyOptions |= fs::copy_options::skip_existing;
		}

		// Perform the copy
		fs::copy(source, destination, copyOptions);
		return true;

	}
	catch (const fs::filesystem_error& ex) {
		std::cerr << "Filesystem error: " << ex.what() << std::endl;
		return false;
	}
	catch (const std::exception& ex) {
		std::cerr << "Error: " << ex.what() << std::endl;
		return false;
	}
}

static std::optional<std::vector<ParsedEntry>> ParseReleases(std::filesystem::path releasesTXTFilepath)
{
	std::vector<ParsedEntry> entries;

	std::ifstream csvFile(releasesTXTFilepath);
	if (!csvFile.is_open())
	{
		return std::nullopt;
	}

	std::string line;
	while (std::getline(csvFile, line))
	{
		ParsedEntry entry;

		// Parse CSV line with quoted fields
		std::stringstream ss(line);
		std::string field;

		// Read placing (first field)
		if (!std::getline(ss, field, ','))
			continue;
		entry.placing = std::stoi(field);

		// Read artist name (second field - quoted)
		if (!std::getline(ss, field, ','))
			continue;

		// Handle quoted field
		if (!field.empty() && field[0] == '"')
		{
			// Remove leading quote
			field = field.substr(1);

			// If field doesn't end with quote, keep reading until we find the closing quote
			while (!field.empty() && field.back() != '"')
			{
				std::string nextPart;
				if (!std::getline(ss, nextPart, ','))
					break;
				field += "," + nextPart;
			}

			// Remove trailing quote
			if (!field.empty() && field.back() == '"')
				field.pop_back();

			// Unescape doubled quotes
			size_t pos = 0;
			while ((pos = field.find("\"\"", pos)) != std::string::npos)
			{
				field.erase(pos, 1);
				pos++;
			}
		}
		entry.artistName = field;

		// Read releaseID (third field)
		if (!std::getline(ss, field))
			continue;
		entry.releaseID = std::stoi(field);

		entries.push_back(entry);
	}

	csvFile.close();

	return entries;
}

static void OutputGFXCompoEntries(void)
{
	const std::filesystem::path inputIMGDirectory = "IMG";
	const std::filesystem::path inputReleasesTXTFile = inputIMGDirectory / "releases.txt";
	const std::filesystem::path outputPRGDirectory = "PRG";
	const std::filesystem::path outputBINDirectory = "BIN";
	const std::filesystem::path outputSparkleBINsDirectory = "SparkleBINs";
	const std::filesystem::path outputSparkleDaliBINsDirectory = "SparkleDaliBINs";

	std::filesystem::create_directories(outputPRGDirectory);
	std::filesystem::create_directories(outputBINDirectory);
	std::filesystem::create_directories(outputSparkleBINsDirectory);
	std::filesystem::create_directories(outputSparkleDaliBINsDirectory);

	auto entries = ParseReleases(inputReleasesTXTFile);
	if (!entries)
	{
		// Handle error case
		return;
	}

	const char* PNG2PRGEXE = "png2prg_win_amd64.exe";
	const char* DALIEXE = "dali.exe";

	unsigned char D011Values[256];
	unsigned char D018Indices[256];
	unsigned char D016Values[256];
	unsigned char D020Values[256];
	unsigned char D021Values[256];
	unsigned char D022Values[256];
	unsigned char D023Values[256];
	unsigned char D024Values[256];
	memset(D011Values, 0, sizeof(D011Values));
	memset(D018Indices, 0, sizeof(D018Indices));
	memset(D016Values, 0, sizeof(D016Values));
	memset(D020Values, 0, sizeof(D016Values));
	memset(D021Values, 0, sizeof(D016Values));
	memset(D022Values, 0, sizeof(D016Values));
	memset(D023Values, 0, sizeof(D016Values));
	memset(D024Values, 0, sizeof(D016Values));

	int orderedIndexes[256];
	memset(orderedIndexes, -1, sizeof(orderedIndexes));
	for (int i = 0; i < 256; i++)
	{
		orderedIndexes[i] = i;
	}

	std::vector<std::filesystem::path> BINFileNames;

	int numPicsTotal = 0;
	for (auto& entry : *entries)
	{
		int placing = entry.placing;
		std::string& artistName = entry.artistName;
		int releaseID = entry.releaseID;

		std::filesystem::path outputBINPath = outputBINDirectory / (std::to_string(releaseID) + ".bin");

		if (releaseID == 253149)
		{
			D020Values[numPicsTotal] = 0;
			D021Values[numPicsTotal] = 0;
			D022Values[numPicsTotal] = 10;
			D023Values[numPicsTotal] = 14;
			D024Values[numPicsTotal] = 3;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x18;
			D018Indices[numPicsTotal] = 0;
		}
		else if (releaseID == 253361)
		{
			D020Values[numPicsTotal] = 0;
			D021Values[numPicsTotal] = 0;
			D022Values[numPicsTotal] = 0;
			D023Values[numPicsTotal] = 0;
			D024Values[numPicsTotal] = 0;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x08;
			D018Indices[numPicsTotal] = 0;
		}
		else if (releaseID == 253538)
		{
			D020Values[numPicsTotal] = 0;
			D021Values[numPicsTotal] = 11;
			D022Values[numPicsTotal] = 9;
			D023Values[numPicsTotal] = 6;
			D024Values[numPicsTotal] = 3;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x18;
			D018Indices[numPicsTotal] = 0;
		}
		else if (releaseID == 253935)
		{
			D020Values[numPicsTotal] = 0;
			D021Values[numPicsTotal] = 1;
			D022Values[numPicsTotal] = 0;
			D023Values[numPicsTotal] = 0;
			D024Values[numPicsTotal] = 0;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x08;
			D018Indices[numPicsTotal] = 2;
		}
		else if (releaseID == 253435)
		{
			D020Values[numPicsTotal] = 15;
			D021Values[numPicsTotal] = 15;
			D022Values[numPicsTotal] = 5;
			D023Values[numPicsTotal] = 11;
			D024Values[numPicsTotal] = 3;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x18;
			D018Indices[numPicsTotal] = 0;
		}
		else if (releaseID == 254134)
		{
			D020Values[numPicsTotal] = 12;
			D021Values[numPicsTotal] = 15;
			D022Values[numPicsTotal] = 0;
			D023Values[numPicsTotal] = 0;
			D024Values[numPicsTotal] = 0;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x08;
			D018Indices[numPicsTotal] = 2;
		}
		else if (releaseID == 254254)
		{
			D020Values[numPicsTotal] = 0;
			D021Values[numPicsTotal] = 0;
			D022Values[numPicsTotal] = 0;
			D023Values[numPicsTotal] = 0;
			D024Values[numPicsTotal] = 0;
			D011Values[numPicsTotal] = 0x1b;
			D016Values[numPicsTotal] = 0x08;
			D018Indices[numPicsTotal] = 0;
		}
		else
		{
			std::filesystem::path imagePath(inputIMGDirectory / (std::to_string(releaseID) + ".png"));

			std::filesystem::path outputPRGPath = outputPRGDirectory / (std::to_string(releaseID) + ".prg");

			std::string PNG2PRGCommandLine = std::string(PNG2PRGEXE) + " -nc -td \"" + outputPRGDirectory.string() + "\" -d \"" + imagePath.string() + "\" >> output.txt";
			int result = system(PNG2PRGCommandLine.c_str());
			if (result != 0)
			{
				std::cerr << "Failed to execute command for image: " << imagePath.string() << ". Error code: " << result << std::endl;
				continue;
			}

			memset(BINBuffer, 0, sizeof(BINBuffer));

			std::string outputPRGPathStr = outputPRGPath.string();
			ReadBinaryFile(const_cast<char*>(outputPRGPathStr.c_str()), &BINBuffer[0x7ff], sizeof(BINBuffer) - 0x7ff);

			int dataStart = 0x2000;
			int dataEnd = 0x2fe8;
			int dataSize = dataEnd - dataStart;

			D020Values[numPicsTotal] = BINBuffer[0x2fe8];
			D021Values[numPicsTotal] = BINBuffer[0x2fe9];
			D022Values[numPicsTotal] = BINBuffer[0x2fea];
			D023Values[numPicsTotal] = BINBuffer[0x2feb];
			D024Values[numPicsTotal] = BINBuffer[0x2fec];

			if ((BINBuffer[0x08E0] == 0x8d) && (BINBuffer[0x08E1] == 0x11) && (BINBuffer[0x08E2] == 0xd0) && ((BINBuffer[0x08DF] & 0x40) == 0x40))
			{
				D011Values[numPicsTotal] = 0x5b;
			}
			else
			{
				D011Values[numPicsTotal] = 0x1b;
			}

			for (int i = 0; i < 256; i++)
			{
				if ((BINBuffer[0x800 + i] == 0x8d) && (BINBuffer[0x801 + i] == 0x16) && (BINBuffer[0x802 + i] == 0xd0))
				{
					if ((BINBuffer[0x7ff + i] & 0x10) == 0x10)
					{
						D016Values[numPicsTotal] = 0x18;
					}
					else
					{
						D016Values[numPicsTotal] = 0x08;
					}
				}
				if ((BINBuffer[0x800 + i] == 0x8d) && (BINBuffer[0x801 + i] == 0x18) && (BINBuffer[0x802 + i] == 0xd0))
				{
					if ((BINBuffer[0x7ff + i] != 0xa8) && (BINBuffer[0x7ff + i] != 0xa9))
					{
						D018Indices[numPicsTotal] = BINBuffer[0x821] * 2 + 2;
					}
					else
					{
						D018Indices[numPicsTotal] = 0;
					}
				}
			}

			std::string outputBINPathStr = outputBINPath.string();
			WriteBinaryFile(const_cast<char*>(outputBINPathStr.c_str()), &BINBuffer[dataStart], dataSize);
		}

		BINFileNames.push_back(outputBINPath);

		if (releaseID == 251651)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 253486)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 252415)
		{
			D020Values[numPicsTotal] = 3;
		}
		else if (releaseID == 252634)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 254255)
		{
			D020Values[numPicsTotal] = 15;
		}
		else if (releaseID == 251643)
		{
			D020Values[numPicsTotal] = 5;
		}
		else if (releaseID == 251665)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 252178)
		{
			D020Values[numPicsTotal] = 14;
		}
		else if (releaseID == 253980)
		{
			D020Values[numPicsTotal] = 14;
		}
		else if (releaseID == 252266)
		{
			D020Values[numPicsTotal] = 8;
		}
		else if (releaseID == 251667)
		{
			D020Values[numPicsTotal] = 4;
		}
		else if (releaseID == 252809)
		{
			D020Values[numPicsTotal] = 12;
		}
		else if (releaseID == 254258)
		{
			D020Values[numPicsTotal] = 12;
		}
		else if (releaseID == 251842)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 254130)
		{
			D020Values[numPicsTotal] = 1;
		}
		else if (releaseID == 253750)
		{
			D020Values[numPicsTotal] = 6;
		}
		else if (releaseID == 252101)
		{
			D020Values[numPicsTotal] = 4;
		}
		else if (releaseID == 251605)
		{
			D020Values[numPicsTotal] = 1;
		}
		else if (releaseID == 251788)
		{
			D020Values[numPicsTotal] = 6;
		}
		else if (releaseID == 254328)
		{
			D020Values[numPicsTotal] = 1;
		}
		else if (releaseID == 251810)
		{
			D020Values[numPicsTotal] = 13;
		}
		else if (releaseID == 251602)
		{
			D020Values[numPicsTotal] = 2;
		}
		else if (releaseID == 251682)
		{
			D020Values[numPicsTotal] = 2;
		}
		else if (releaseID == 251792)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 253937)
		{
			D020Values[numPicsTotal] = 15;
		}
		else if (releaseID == 254074)
		{
			D020Values[numPicsTotal] = 11;
		}
		else if (releaseID == 253170)
		{
			D020Values[numPicsTotal] = 4;
		}
		else if (releaseID == 252501)
		{
			D020Values[numPicsTotal] = 15;
		}
		else if (releaseID == 252248)
		{
			D020Values[numPicsTotal] = 12;
		}
		else if (releaseID == 253631)
		{
			D020Values[numPicsTotal] = 1;
		}
		else if (releaseID == 252596)
		{
			D020Values[numPicsTotal] = 14;
		}
		else if (releaseID == 251673)
		{
			D020Values[numPicsTotal] = 3;
		}
		else if (releaseID == 252675)
		{
			D020Values[numPicsTotal] = 2;
		}
		else if (releaseID == 253938)
		{
			D020Values[numPicsTotal] = 2;
		}
		else if (releaseID == 251717)
		{
			D020Values[numPicsTotal] = 15;
		}



		numPicsTotal++;
	}

	std::ofstream incFile("ASM\\picdata.inc");

	if (incFile.is_open())
	{
		incFile << ".var NumLogos = " << to_string(numPicsTotal) << "\n\n";

		incFile << "D011Values:\n";
		size_t startIndex = 0;
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D011Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD018Indices:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D018Indices[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD016Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D016Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD020Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D020Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD021Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D021Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD022Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D022Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD023Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D023Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
		incFile << "\n\nD024Values:\n";
		for (size_t i = 0; i < numPicsTotal; ++i)
		{
			if ((i % 16) == 0)
			{
				startIndex = i;
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(D024Values[orderedIndexes[i]]);
			if (((i % 16) == 15) || (i == numPicsTotal - 1))
			{
				incFile << " //; " << to_string(startIndex + 1) << "-" << to_string(i + 1) << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
	}

	RecursiveCopyDirectory("BINPatch", "BIN", true);

	//; pair up the binaries for Sparkle
	static const int NumToGroup = 2;
	static const int SparkleBINFileSize = 0x1000;
	int NumSparkleFiles = (numPicsTotal + (NumToGroup - 1)) / 2;
	for (size_t i = 0; i < NumSparkleFiles; i++)
	{
		int Offset = 0;
		SparkleBIN[0] = 0x00;
		SparkleBIN[1] = 0xA0;
		Offset += 2;

		for (size_t j = 0; j < NumToGroup; j++)
		{
			size_t index = i * NumToGroup + j;
			if (index < numPicsTotal)
			{
				int BINIndex = orderedIndexes[index];
				if (BINIndex >= 0)
				{
					std::string mypathStr = BINFileNames[BINIndex].string();
					ReadBinaryFile(const_cast<char*>(mypathStr.c_str()), &SparkleBIN[Offset], SparkleBINFileSize);

					Offset += SparkleBINFileSize;
				}
			}
		}
		Offset -= 0x18;

		std::filesystem::path myoutpath = outputSparkleBINsDirectory / (to_string(i) + ".bin");
		std::string myoutpathStr = myoutpath.string();
		WriteBinaryFile(const_cast<char*>(myoutpathStr.c_str()), SparkleBIN, Offset);

		//; Dali Compress
		std::filesystem::path outdalipath = outputSparkleDaliBINsDirectory / (to_string(i) + ".bin.lz");
		std::string outdalipathStr = outdalipath.string();
		std::string DALICommandLine = std::string(DALIEXE) + " -o " + outdalipathStr + " " + myoutpathStr + "  >> output.txt";
		int result = system(DALICommandLine.c_str());
		if (result != 0)
		{
			std::cerr << "Failed to execute command for image: " << myoutpathStr << ". Error code: " << result << std::endl;
		}
	}

	unsigned char DALIAddrLoHi[2][256];
	for (size_t i = 0; i < NumSparkleFiles; i++)
	{
		unsigned char InData[4];
		std::filesystem::path indalipath = outputSparkleDaliBINsDirectory / (to_string(i) + ".bin.lz");
		std::string indalipathstr = indalipath.string();
		ReadBinaryFile(const_cast<char*>(indalipathstr.c_str()), InData, 4);

		int DALIAddr = InData[1] * 256 + InData[0];
		DALIAddr += 2; //; because we're cropping the "unpack address" data. It's fixed anyway... no need for it to be in the data!

		DALIAddrLoHi[0][i] = DALIAddr % 256;
		DALIAddrLoHi[1][i] = DALIAddr / 256;
	}
	for (int Pass = 0; Pass < 2; Pass++)
	{
		if (Pass == 0)
		{
			incFile << "\n\nDALIAddrLo:\n";
		}
		else
		{
			incFile << "\n\nDALIAddrHi:\n";
		}
		for (size_t i = 0; i < NumSparkleFiles; i++)
		{
			if ((i % 16) == 0)
			{
				incFile << ".byte ";
			}
			incFile << "$" << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(DALIAddrLoHi[Pass][i]);
			if (((i % 16) == 15) || (i == NumSparkleFiles - 1))
			{
				incFile << "\n";
			}
			else
			{
				incFile << ", ";
			}
		}
	}
	incFile << "\n\n";

	// Create the Disk.SLS file
	std::ofstream slsFile("Disk.SLS");
	if (slsFile.is_open())
	{
		slsFile << "[Sparkle Loader Script]\n\n";
		slsFile << "Path:\t\tC64GFXLogoCompo.d64\n";
		slsFile << "Header:\t\tGenesis  Project\n";
		slsFile << "ID:\t\tC64GFX\n";
		slsFile << "Name:\t\tC64GFX Logo Compo\n";
		slsFile << "IL0:\t\t4\n";
		slsFile << "IL1:\t\t3\n";
		slsFile << "ProdID:\t\t9F32\n\n";

		slsFile << "File:\tOBJ\\LogoDisplay.prg\n";
		slsFile << "File:\tXiny-Laxity.sid\n";
		slsFile << "File:\tSpriteBKG.map\t\t\t\t\t\t\t8fc0\n";
		slsFile << "File:\tGPLogo.map\t\t\t\t\t\t\tb000\n";
		slsFile << "File:\tIntro.scr\t\t\t\t\t\t\ta800\n";
		slsFile << "File:\tIntro.map\t\t\t\t\t\t\ta000\n";
		slsFile << "File:\tChooseScreen.scr\t\t\t\t\t\t\t8800\n";
		slsFile << "File:\tChooseScreen.map\t\t\t\t\t\t\t8000\n";
		slsFile << "\n";

		int SpriteDataOffset = 0;
		int SpriteDataLen = 0x280;
		for (size_t i = 0; i < NumSparkleFiles; i++)
		{
			int DALILoadAddress = DALIAddrLoHi[1][i] * 256 + DALIAddrLoHi[0][i];
			std::filesystem::path outpath = outputSparkleDaliBINsDirectory / (std::to_string(i) + ".bin.lz");
			std::string outpathstr = outpath.string();
			slsFile << "File:\t" << outpathstr << "\t" << std::hex << std::setw(4) << std::setfill('0') << DALILoadAddress << "\t0004\n";
			slsFile << "File:\tspritetext.map\t8d40\t" << std::hex << std::setw(4) << std::setfill('0') << SpriteDataOffset;
			if (i != (NumSparkleFiles - 1))
			{
				slsFile << "\t" << SpriteDataLen;
			}
			slsFile << "\n";
			slsFile << "\n";
			SpriteDataOffset += SpriteDataLen;
		}
		slsFile.close();
	}
	else
	{
		std::cerr << "Failed to create Disk.SLS file." << std::endl;
	}

}

void LoadProportionalCharSet(void)
{
	int GlyphCoords[256][4];

	GPIMAGE InFont("charset.png", false, false);
	for (int glyph = 0; glyph < 256; glyph++)
	{
		int XOffset = (glyph % 40) * 8;
		int YOffset = (glyph / 40) * 8;

		int MinX = 7;
		int MaxX = 0;
		for (int x = 0; x < 8; x++)
		{
			int InX = XOffset + x;
			bool bColumnHasPixels = false;
			for (int y = 0; y < 8; y++)
			{
				int InY = YOffset + y;

				unsigned int Col = InFont.GetPixel(InX, InY);

				if (Col)
				{
					bColumnHasPixels = true;
					break;
				}
			}
			if (bColumnHasPixels)
			{
				MinX = std::min(MinX, x);
				MaxX = std::max(MaxX, x);
			}
		}
		if (MinX > MaxX)
		{
			//; SPACE - make it 4px wide
			MinX = 0;
			MaxX = 1;
		}

		GlyphCoords[glyph][0] = MinX + XOffset;
		GlyphCoords[glyph][1] = MaxX + XOffset;
		GlyphCoords[glyph][2] = YOffset + 0;
		GlyphCoords[glyph][3] = YOffset + 7;
	}

	const std::filesystem::path inputIMGDirectory = "IMG";
	const std::filesystem::path inputReleasesTXTFile = inputIMGDirectory / "releases.txt";
	auto entries = ParseReleases(inputReleasesTXTFile);
	if (!entries)
	{
		// Handle error case
		return;
	}

	int NumSpritesX = 5;
	int NumSpritesY = static_cast<int>((*entries).size());

	int TotalSpriteWidth = NumSpritesX * 24;
	int TotalSpriteHeight = 21 * NumSpritesY;

	GPIMAGE OutSprite(TotalSpriteWidth, TotalSpriteHeight);
	int i = 0; // Line counter for Y positioning
	for (auto& entry : *entries)
	{
		int placing = entry.placing;
		std::string& artistName = entry.artistName;

		// Create the formatted string "[index]: [name]"
		std::string line = std::to_string(placing) + ": " + artistName;

		int OutX = 0;
		for (char ch : line)
		{
			// Handle special character mappings
			if (ch == '_')
				ch = '-';

			// Convert lowercase letters to 1-26 range
			if ((ch >= 'a') && (ch <= 'z'))
				ch = ch - 'a' + 1;
			if ((ch >= 'A') && (ch <= 'Z'))
				ch = ch - 'A' + 65;

			// Skip characters that don't have glyph data
			// You'll need to handle digits, colon, space, etc.
			// based on how your GlyphCoords array is set up

			int X0 = GlyphCoords[ch][0];
			int X1 = GlyphCoords[ch][1] + 1;
			int Y0 = GlyphCoords[ch][2];
			int Y1 = GlyphCoords[ch][3] + 1;
			int w = X1 - X0;

			for (int x = 0; x < w; x++)
			{
				int InX = X0 + x;
				for (int y = 0; y < 8; y++)
				{
					int InY = Y0 + y;
					unsigned int Col = InFont.GetPixel(InX, InY);
					if ((Col) && (OutX < 320))
					{
						OutSprite.SetPixel(OutX, i * 21 + y + 1, 0xffffff);
					}
				}
				OutX++;
			}
			OutX++; // 1px spacer between characters
		}
		i++; // Move to next line
	}
	OutSprite.Write("SpriteText.png");

	static constexpr int MaxNumSprites = 1024;
	unsigned char OutSpriteMAP[MaxNumSprites][64];
	memset(OutSpriteMAP, 0, sizeof(OutSpriteMAP));

	for (int y = 0; y < TotalSpriteHeight; y++)
	{
		for (int x = 0; x < TotalSpriteWidth; x++)
		{
			unsigned int Col = OutSprite.GetPixel(x, y);
			if (Col)
			{
				int OutSpriteIndex = ((y / 21) * 5) + (x / 24);
				int OutByteOffset = (y % 21) * 3 + (x % 24) / 8;
				int OutByteLeftShift = 7 - (x % 8);

				OutSpriteMAP[OutSpriteIndex][OutByteOffset] |= (1 << OutByteLeftShift);
			}
		}
	}
	WriteBinaryFile((LPTSTR)"SpriteText.map", OutSpriteMAP, NumSpritesX * NumSpritesY * 64);
}

void ConvertGPLogo(void)
{
	GPIMAGE InImage("GPLogo.png", false, false);

	unsigned long long CharData[1024];
	unsigned char ScreenData[25][40];
	int NumChars = 0;
	for (int YChar = 0; YChar < 25; YChar++)
	{
		for (int XChar = 0; XChar < 40; XChar++)
		{
			unsigned long long ThisChar = 0;
			for (int YPixel = 0; YPixel < 8; YPixel++)
			{
				int y = YChar * 8 + YPixel;
				for (int XPixel = 0; XPixel < 8; XPixel += 2)
				{
					int x = XChar * 8 + XPixel;

					unsigned int Col = InImage.GetPixel(x, y);
					unsigned long long OutBits = 0;
					switch (Col)
					{
					case 0x000000:
						OutBits = 3;
						break;

					case 0x4a4a4a:
					case 0x3e31a2:
					case 0x555555:
						OutBits = 1;
						break;

					case 0x7b7b7b:
					case 0x7c70da:
					case 0xababab:
						OutBits = 2;
						break;

					case 0xb2b2b2:
					case 0xffffff:
						OutBits = 0;
						break;
					}

					int ShiftValue = (YPixel * 8) + (6 - XPixel);

					ThisChar |= (OutBits << ShiftValue);
				}
			}

			int CharIndex = -1;
			for (int i = 0; i < NumChars; i++)
			{
				if (CharData[i] == ThisChar)
				{
					CharIndex = i;
					break;
				}
			}

			if (CharIndex == -1)
			{
				CharData[NumChars] = ThisChar;
				CharIndex = NumChars;
				NumChars++;
			}
			ScreenData[YChar][XChar] = CharIndex;
		}
	}

	WriteBinaryFile((LPTSTR)"GPLogo.map", CharData, sizeof(CharData[0]) * NumChars);
	WriteBinaryFile((LPTSTR)"GPLogo.scr", ScreenData, sizeof(ScreenData));

	static const int LogoY0 = 0;
	static const int LogoCharW = 40;
	static const int LogoCharH = 16;

	static int LogoLines[] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 18, 19, 20, 21, 22, 23 };
	static const int NumLogoLines = sizeof(LogoLines) / sizeof(LogoLines[0]);

	std::ofstream incFile("ASM\\GPLogoData.inc");
	if (incFile.is_open())
	{
		for (int iY = 0; iY < NumLogoLines; iY++)
		{
			int y = LogoLines[iY];

			incFile << "Logo_Line" << to_string(y) << ":\n";
			incFile << "\t.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n";
			incFile << "\t.byte ";
			for (int x = 0; x < LogoCharW; x++)
			{
				if (x)
				{
					incFile << ", ";
				}
				incFile << to_string(ScreenData[y + LogoY0][x]);
			}
			incFile << "\n";
		}
		incFile << "\n";
		incFile << "\t.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n";
	}
	incFile << "\n";

	unsigned char SinTable[2][256];
	for (int i = 0; i < 256; i++)
	{
		double SinValue = 0;
		if (i < 148)
		{
			SinValue = sin(i * 2 * 3.1415 / (148.0 * 4.0)) * 320.0;
			SinValue = std::max(0.0, std::min(319.0, SinValue));
		}
		else if (i >= 192)
		{
			SinValue = sin((i - 128) * 2 * 3.1415 / (64.0 * 4.0)) * 320.0;
			SinValue = std::max(0.0, std::min(319.0, SinValue));
			SinValue = 638.0 - SinValue;
		}
		else
		{
			SinValue = 319.0;
		}
		SinValue += sin(i * 3.1415 * 8 / 256.0) * 20.0;

		unsigned int iSinValue = static_cast<unsigned int>(SinValue);
		unsigned int iSinCharScroll = iSinValue / 8;
		unsigned int iSinPixelScroll = 7 - (iSinValue % 8);
		SinTable[0][i] = (unsigned char)iSinCharScroll;
		SinTable[1][i] = (unsigned char)iSinPixelScroll;
	}
	incFile << "LogoSinValsHi:\n";
	incFile << "\t.byte ";
	for (int i = 0; i < 256; i++)
	{
		if (i)
		{
			incFile << ", ";
		}
		incFile << to_string(SinTable[0][i]);
	}
	incFile << "\n";

	incFile << "LogoSinValsLo:\n";
	incFile << "\t.byte ";
	for (int i = 0; i < 256 + 64; i++)
	{
		if (i)
		{
			incFile << ", ";
		}
		incFile << to_string(SinTable[1][i]);
	}
	incFile << "\n";
}

int main()
{
	//;		std::string inputFilename = "votes.csv";
	//;		std::string outputFilename = "results.csv";

	//;		std::vector<VoteEntry> votes = parseCSV(inputFilename);
	//;		createXYTable(votes, outputFilename);

	OutputGFXCompoEntries();

	LoadProportionalCharSet();

	ConvertGPLogo();
	return 0;
}

