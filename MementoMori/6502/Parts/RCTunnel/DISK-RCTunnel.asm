//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= DISK_BASE

Entry:

	//; BEGIN Setup
		lda #$00
		sta VIC_D011
		sta VIC_BorderColour

		jsr BASECODE_StartMusic
	//; END Setup

	//; RCTunnel -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #RotatingGP

		jsr RCTunnel_BASE //; + GP_HEADER_Init
	//; END RCTunnel -------------------------------------------------------------------------------------------------------

	LoopForever:
		jmp LoopForever
	//; END RCTunnel
