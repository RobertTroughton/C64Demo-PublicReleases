//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Out/6502/Main/Main-BaseCode.sym"
.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

.const	SID_Volume	=$0957

* = DISK_BASE

		jmp Entry_DirectBoot

Entry:

	//; Fade out old music ... and start the new -------------------------------------------------------------------------------------------------------
		ldx #(14 * 8)
	MusicFade_OuterLoop:
		txa
		lsr
		lsr
		lsr
		sta SID_Volume
		lda #$00
		sta Signal_VBlank
	MusicFade_WaitForVBlank:
		lda Signal_VBlank
		beq MusicFade_WaitForVBlank
		dex
		bpl MusicFade_OuterLoop

		jsr BASECODE_StopMusic

Entry_DirectBoot:
		ldy #$18
		lda #$00
	ClearSIDRegistersLoop:
		sta $d400, y
		dey
		bpl ClearSIDRegistersLoop

		jsr IRQLoader_LoadNext //; Next Tune

		:IRQ_WaitForVBlank()

		jsr BASECODE_StartMusic
	//; END Fade out old music ... and start the new -------------------------------------------------------------------------------------------------------

	//; OdinQuote -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #Odin

		jsr OdinQuote_BASE + 0 //; fade in...

		jsr IRQLoader_LoadNext //; #BigScalingScroller

	WaitForTimer:
		lda Frame_256Counter
		beq WaitForTimer
	WaitForTimer2:
		lda FrameOf256
		cmp #$80
		bne WaitForTimer2

		jsr OdinQuote_BASE + 3 //; fade out...

	//; END OdinQuote -------------------------------------------------------------------------------------------------------

	//; BigScalingScroller -------------------------------------------------------------------------------------------------------
//;		jsr IRQLoader_LoadNext //; #BigScalingScroller

		jsr BigScalingScroller_BASE + GP_HEADER_Init

		jsr	IRQLoader_LoadNext	//; #Preload Hourglass.prg

	ScalingScrollerLoop:
		lda Signal_CurrentEffectIsFinished
		beq ScalingScrollerLoop

		jsr BigScalingScroller_BASE + GP_HEADER_Exit
	//; END BigScalingScroller -------------------------------------------------------------------------------------------------------

	//; Hourglass -------------------------------------------------------------------------------------------------------
		//; #jsr IRQLoader_LoadNext //; #Hourglass bitmap and sprites

		jsr Hourglass_BASE + GP_HEADER_Init

		jsr IRQLoader_LoadNext		//; #Preload PlotSkull.prg, Bitmap.map, and Bitmap.scr

	Hourglass_WaitForFinish:
		lda Signal_CurrentEffectIsFinished
		beq Hourglass_WaitForFinish

		jsr Hourglass_BASE + GP_HEADER_Exit
	//; END Hourglass -------------------------------------------------------------------------------------------------------

	//; PlotSkull -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #PlotSkull

		jsr PlotSkull_START
	//; END PlotSkull -------------------------------------------------------------------------------------------------------

	//; AllBorderDoubleDYPP -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #AllBorderDYPP

		jsr ABDDYPP_BASE + GP_HEADER_PreInit
		jsr ABDDYPP_JUSTRASTERS_BASE + 0	//; Ease In

	EaseInWait:
		lda Signal_CurrentEffectIsFinished
		beq EaseInWait

		jsr ABDDYPP_BASE + GP_HEADER_Init
		jsr	IRQLoader_LoadNext	//; #Preload Plasma Bitmap

	ABDDYPP_MainLoop:
		lda Signal_CustomSignal0
		beq DontLoadNext
		dec Signal_CustomSignal0
		jsr ABDDYPP_JUSTRASTERS_BASE + 3	//; Ease Out
		jsr IRQLoader_LoadNext //; #MCPlasma

	DontLoadNext:
		lda Signal_CurrentEffectIsFinished
		beq ABDDYPP_MainLoop

		jsr BASECODE_TurnOffScreenAndSetDefaultIRQ
	//; END AllBorderDoubleDYPP -------------------------------------------------------------------------------------------------------

	//; MCPlasma -------------------------------------------------------------------------------------------------------
//;		jsr IRQLoader_LoadNext //; #MCPlasma

		jsr MCPlasma_BASE

		jsr	IRQLoader_LoadNext	//; Preload FacetSkullPic

		lda	Signal_CustomSignal0
		beq	*-3

		jsr	MCPlasma_BASE+3

	//; END MCPlasma -------------------------------------------------------------------------------------------------------

	//; FacetSkullPic -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #HorseMenPic

		lda #$00
		jsr HorseMenPic_BASE + GP_HEADER_Init

		jsr IRQLoader_LoadNext //; #CircleScroller-Preload

		lda #1
	SkullPic_MainLoop:
		cmp Frame_256Counter
		bne SkullPic_MainLoop
		lda #$20
	SkullPic_MainLoop2:
		cmp FrameOf256
		bcs SkullPic_MainLoop2

		jsr HorseMenPic_BASE + GP_HEADER_MainThreadFunc //; Start fade out...

	WaitForFadeOut:
		lda Signal_CurrentEffectIsFinished
		beq WaitForFadeOut

		jsr HorseMenPic_BASE + GP_HEADER_Exit
	//; END FacetSkullPic -------------------------------------------------------------------------------------------------------

	//; CircleScroller -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #CircleScroller

		:GlobalSync($12f8)

		jsr CircleScroller_BASE + GP_HEADER_Init

		jmp DoNextDisk
	//; END CircleScroller -------------------------------------------------------------------------------------------------------

	* = DISK_BASE + $f7
	DoNextDisk:
		jsr IRQLoader_LoadNext
		jsr CircleScroller_BASE + GP_HEADER_MainThreadFunc
		jmp DISK_BASE + 3

	//; END TurnDiskDYPP -------------------------------------------------------------------------------------------------------
