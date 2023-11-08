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

	//; AllBorderDYPP -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #AllBorderDYPP

		jsr ABDDYPP_BASE + GP_HEADER_PreInit
		jsr ABDDYPP_JUSTRASTERS_BASE + 0	//; Ease In

	EaseInWait:
		lda Signal_CurrentEffectIsFinished
		beq EaseInWait

		jsr ABDDYPP_BASE + GP_HEADER_Init

	LoopAllBorderDYPP:
		lda Signal_CustomSignal0
		beq DontLoadNext
		dec Signal_CustomSignal0

		jsr ABDDYPP_JUSTRASTERS_BASE + 3	//; Ease Out

	DontLoadNext:
		lda Signal_CurrentEffectIsFinished
		beq LoopAllBorderDYPP
	//; END AllBorderDYPP

	InfiniteLoop:
		jmp InfiniteLoop
