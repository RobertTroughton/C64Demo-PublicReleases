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

	//; BEGIN SpriteBobs -------------------------------------------------------------------------------------------------------
		lda #$03
		jsr BASECODE_SetScreenColour
		jsr IRQLoader_LoadNext //; #SPRITEBOBS

		jsr SpriteBobs_BASE + GP_HEADER_Init

	SB_MainLoop:
		:IRQ_WaitForVBlank()

		jsr SpriteBobs_BASE + GP_HEADER_MainThreadFunc

		lda Signal_CurrentEffectIsFinished
		beq SB_MainLoop

		jsr SpriteBobs_BASE + GP_HEADER_Exit
	//; END SpriteBobs

LoopForever:
		jmp LoopForever
