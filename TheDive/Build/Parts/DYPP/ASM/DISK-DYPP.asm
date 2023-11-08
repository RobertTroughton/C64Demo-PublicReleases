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

	//; DYPP -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #DYPPer

		jsr DYPP_BASE + GP_HEADER_Init

	DYPPER_MainLoop:
		lda Signal_VBlank
		beq DYPPER_MainLoop

		jsr DYPP_BASE + GP_HEADER_MainThreadFunc
		jmp DYPPER_MainLoop
	//; END DYPPer
