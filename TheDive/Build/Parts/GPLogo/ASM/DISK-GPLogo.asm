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

	//; GPLogo -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #GPLOGO

		jsr GPLogo_BASE + GP_HEADER_Init

	GPLOGO_Loop:
		lda Signal_VBlank
		beq GPLOGO_Loop
		jsr GPLogo_BASE + GP_HEADER_MainThreadFunc
		lda #$00
		sta Signal_VBlank
		jmp GPLOGO_Loop
	//; END GPLogo
