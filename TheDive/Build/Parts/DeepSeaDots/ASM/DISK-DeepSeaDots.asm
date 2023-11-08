//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

*= DISK_BASE "Disk Base"

Entry:

	//; BEGIN Setup
		lda #$00
		sta VIC_D011

		jsr BASECODE_StartMusic
	//; END Setup

		//; BEGIN Deep Sea Dots -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #DEEPSEADOTS

		jsr DeepSeaDots_BASE + GP_HEADER_Init

	DSD_MainLoop:
		jmp DSD_MainLoop
	//; END Deep Sea Dots -------------------------------------------------------------------------------------------------------
