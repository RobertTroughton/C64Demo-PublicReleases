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

	//; BEGIN Side Border Bitmap -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr BASECODE_SetScreenColour

		jsr IRQLoader_LoadNext //; #SBB

		jsr SBB_BASE + GP_HEADER_Init

	SBB_Loop:
		lda Signal_VBlank
		beq SBB_Loop
		lda #$00
		sta Signal_VBlank
		jsr SBB_BASE + GP_HEADER_MainThreadFunc
		jmp SBB_Loop
	//; END Side Border Bitmap -------------------------------------------------------------------------------------------------------

