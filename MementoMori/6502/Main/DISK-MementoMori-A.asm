//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Out/6502/Main/Main-BaseCode.sym"
.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

//.const	BundleIndex_ColorTabs	=$08		//; #Bundle Index of the color tabs needed for fade-in and fade-out
//.const	BundleIndex_RotatingGP1	=$05		//; #Bundle Index of RotatingGP part 1

* = DISK_BASE

Entry:

	//; Sparkle -------------------------------------------------------------------------------------------------------
		jsr Sparkle_BASE + 0

		jsr IRQLoader_LoadNext //; #RCTunnel

	WaitForSparkle:
		lda Signal_CurrentEffectIsFinished
		beq WaitForSparkle

		jsr Sparkle_BASE + 3
	//; END Sparkle -------------------------------------------------------------------------------------------------------

	//; RCTunnel -------------------------------------------------------------------------------------------------------
		jsr RCTunnel_BASE //; + GP_HEADER_Init
	//; END RCTunnel -------------------------------------------------------------------------------------------------------

	//; RotatingGP -------------------------------------------------------------------------------------------------------
	//; FadeIn Bitmap
		jsr IRQLoader_LoadNext //; #RotatingGPBitmap
		
		//;lda	#<BundleIndex_ColorTabs
		//;jsr	IRQLoader_LoadA		//; #Colors and FramesDarker.bin
		
		jsr RotatingGPBitmap_BASE

		jsr	IRQLoader_LoadNext	//; #RotatingGP - part 1

		//;lda	#<BundleIndex_RotatingGP1
		//;jsr	IRQLoader_LoadA		//; #RotatingGP - part 1 - instead of jsr IRQLoader_LoadNext as we need to move the RW head back to continue

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
		jsr	IRQLoader_LoadNext	//; #Colors and FramesDarker.bin
		//;jsr	IRQLoader_LoadNext	//; #Colors and FramesDarker.bin

		jsr RotatingGPBitmap_BASE + 3 //; start fadeout

	WaitForSignal_FadeOut:
		lda Signal_CurrentEffectIsFinished
		beq WaitForSignal_FadeOut
		jsr BASECODE_TurnOffScreenAndSetDefaultIRQ
	//; END RotatingGP -------------------------------------------------------------------------------------------------------

	//; Presents -------------------------------------------------------------------------------------------------------
		jsr	IRQLoader_LoadNext	//; #Presents

		:GlobalSync($0990)

		jsr Presents_BASE + 0
		jsr IRQLoader_LoadNext
		jsr Presents_BASE + 3
	//; END Presents -------------------------------------------------------------------------------------------------------

	//; BigMMLogo -------------------------------------------------------------------------------------------------------
//;		jsr IRQLoader_LoadNext //; #BigMMLogo

		jsr BigMMLogo_BASE + GP_HEADER_Init

	BMM_Wait:
		lda Signal_CurrentEffectIsFinished
		beq BMM_Wait

		jsr BigMMLogo_BASE + GP_HEADER_Exit
	//; END BigMMLogo -------------------------------------------------------------------------------------------------------

	//; AllBorderDYPP -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #AllBorderDYPP

		:GlobalSync($0f80)

		jsr AllBorderDYPP_BASE + GP_HEADER_Init

		jsr	IRQLoader_LoadNext	//; Preloading part of HorseMenPic

	AllBorderDYPP_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq AllBorderDYPP_MainLoop

		jsr AllBorderDYPP_BASE + GP_HEADER_Exit
	//; END AllBorderDYPP -------------------------------------------------------------------------------------------------------

	//; HorseMenPic -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #HorseMenPic

		lda #$0c
		jsr HorseMenPic_BASE + GP_HEADER_Init

		jsr IRQLoader_LoadNext //; #TurnDiskDYPP-Preload

		lda #1
	HorseMenPic_MainLoop:
		cmp Frame_256Counter
		bne HorseMenPic_MainLoop
		lda #$38
	HorseMenPic_MainLoop2:
		cmp FrameOf256
		bcs HorseMenPic_MainLoop2

		jsr HorseMenPic_BASE + GP_HEADER_MainThreadFunc //; Start fade out...

	WaitForFadeOut:
		lda Signal_CurrentEffectIsFinished
		beq WaitForFadeOut

		jsr HorseMenPic_BASE + GP_HEADER_Exit
	//; END HorseMenPic -------------------------------------------------------------------------------------------------------

	//; TurnDiskDYPP -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #TurnDiskDYPP

		:GlobalSync($16fc)

		jsr TurnDiskDYPP_BASE + GP_HEADER_Init
		jmp DoNextDisk

	* = DISK_BASE + $f7
	DoNextDisk:
		nop
		nop
		nop
		jsr TurnDiskDYPP_BASE + GP_HEADER_MainThreadFunc
		jmp DISK_BASE + 3

	//; END TurnDiskDYPP -------------------------------------------------------------------------------------------------------
