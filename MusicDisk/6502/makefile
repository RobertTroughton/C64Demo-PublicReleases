#define macros
DIR_EXTRAS = ..\extras
DIR_SPARKLE = $(DIR_EXTRAS)\Sparkle
SPARKLE = $(DIR_SPARKLE)\Sparkle2MM.exe
DIR_KICKASS = $(DIR_EXTRAS)\KickAss
KICKASS = Java -jar $(DIR_KICKASS)\KickAss.jar

..\D64\MusicDisk.d64: MusicDisk.sls ..\Out\6502\MusicDisk.prg
	$(SPARKLE) MusicDisk.sls

..\Out\6502\MusicDisk.prg: Main-CommonDefines.asm Main-CommonMacros.asm MusicDisk.asm 
	$(KICKASS) MusicDisk.asm -odir ..\Out\6502
