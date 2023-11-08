//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

*= DISK_BASE "Disk Base"

.var StarWarsNUC_EndOfMemory = $78b1 //; reverse decrunch ... this is LastByte + 1

Entry:

	//; BEGIN Setup
		lda #$00
		sta VIC_D011

		jsr BASECODE_StartMusic
	//; END Setup

	//; BEGIN StarWars -------------------------------------------------------------------------------------------------------
		lda #$0e
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #STARWARS
		ldx #<StarWarsNUC_EndOfMemory
		lda #>(StarWarsNUC_EndOfMemory-1)
		jsr NUCRUNCH_Decrunch

		jsr StarWars_BASE
	//; END StarWars

	LoopForever:
		jmp LoopForever

