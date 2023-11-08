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

	//; BEGIN VertBitmap -------------------------------------------------------------------------------------------------------
		lda #$03
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #VERTBITMAP
		jsr VertBitmap_BASE + GP_HEADER_Init

	VB_MainLoop:
		lda Signal_CustomSignal0
		beq VB_MainLoop

		jsr VertBitmap_BASE + GP_HEADER_MainThreadFunc

		jmp VB_MainLoop
	//; END VertBitmap

