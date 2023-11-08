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

	//; RotatingGP -------------------------------------------------------------------------------------------------------
	//; FadeIn Bitmap
		jsr IRQLoader_LoadNext //; #RotatingGPBitmap
		jsr RotatingGPBitmap_BASE

		jsr IRQLoader_LoadNext //; #RotatingGP - part 1

	WaitForSignal_FadeIn:
		lda Signal_CurrentEffectIsFinished
		beq WaitForSignal_FadeIn
		jsr BASECODE_SetDefaultIRQ

		jsr IRQLoader_LoadNext //; #RotatingGP - part 2

		jsr RotatingGP_BASE + GP_HEADER_Init

	WaitForSignal:
		lda Signal_CustomSignal0
		beq WaitForSignal

		jsr RotatingGP_BASE + GP_HEADER_MainThreadFunc

		lda Signal_CurrentEffectIsFinished
		beq WaitForSignal

		jsr RotatingGP_BASE + GP_HEADER_Exit

	//; FadeOut Bitmap
		jsr IRQLoader_LoadNext
		jsr RotatingGPBitmap_BASE + 3 //; start fadeout

	WaitForSignal_FadeOut:
		lda Signal_CurrentEffectIsFinished
		beq WaitForSignal_FadeOut
		jsr BASECODE_TurnOffScreenAndSetDefaultIRQ

	WaitForever:
		jmp WaitForever
	//; END RotatingGP
