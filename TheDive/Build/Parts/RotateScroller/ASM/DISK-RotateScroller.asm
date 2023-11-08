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

	//; BEGIN RotateScroller -------------------------------------------------------------------------------------------------------
		lda #$00
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #ROTATESCROLLER

		jsr RotateScroller_BASE + GP_HEADER_Init

	LoopForever:
		jmp LoopForever
	//; END RotateScroller

