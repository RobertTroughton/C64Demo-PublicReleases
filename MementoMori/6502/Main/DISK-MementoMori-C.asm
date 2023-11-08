//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Out/6502/Main/Main-BaseCode.sym"
.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

.const	SID_Volume				=$095a
.const	BundleIndex_Quote		=$01
.const	BundleIndex_VSBB2		=$04
.const	BundleIndex_FirstBlock	=$05
.const	BundleIndex_Music		=$33

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

		lda	#BundleIndex_Music
		.if (USE_SPINDLE) jsr IRQLoader_SpindleLoadA
		.if (USE_SPARKLE) jsr IRQLoader_LoadA
		
		//;jsr IRQLoader_LoadNext //; Next Tune

		:IRQ_WaitForVBlank()

		jsr BASECODE_StartMusic
		//; END Fade out old music ... and start the new -------------------------------------------------------------------------------------------------------

	//; Quote -------------------------------------------------------------------------------------------------------
		lda	#BundleIndex_Quote
		.if (USE_SPINDLE) jsr IRQLoader_SpindleLoadA
		.if (USE_SPARKLE) jsr IRQLoader_LoadA

		jsr Quote_BASE + 0

		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap-Preload

	Quote_MainLoop:
		lda Frame_256Counter
		beq Quote_MainLoop

		jsr Quote_BASE + 3 //; Start fade out...

	Quote_WaitForFadeOut:
		lda Signal_CurrentEffectIsFinished
		beq Quote_WaitForFadeOut

		jsr BASECODE_TurnOffScreenAndSetDefaultIRQ
	//; END Quote -------------------------------------------------------------------------------------------------------

	//; VerticalSideBorderBitmap -------------------------------------------------------------------------------------------------------
		
		lda	#BundleIndex_VSBB2
		.if (USE_SPINDLE) jsr IRQLoader_SpindleLoadA
		.if (USE_SPARKLE) jsr IRQLoader_LoadA
		
		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap (2) - First data steam block
		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap (2) - Second data steam block

		jsr VerticalSideBorderBitmap_BASE + GP_HEADER_Init

	VertBitmapLoop:
		lda Signal_CustomSignal0
		beq VertBitmapLoop
		dec Signal_CustomSignal0

		lda Signal_CustomSignal1
		bne FinishedSideBorderBitmap

		jsr IRQLoader_LoadNext

		jmp VertBitmapLoop

	FinishedSideBorderBitmap:
		
		lda	#$00
		sta	Signal_CustomSignal1
		
		lda	#BundleIndex_FirstBlock
		.if (USE_SPINDLE) jsr IRQLoader_SpindleLoadA
		.if (USE_SPARKLE) jsr IRQLoader_LoadA
		
		jmp	VertBitmapLoop

		lda Signal_CustomSignal0		//; do one extra final delay, waiting for the last frames to scroll off (due to double buffering)
		beq FinishedSideBorderBitmap

		jsr VerticalSideBorderBitmap_BASE + GP_HEADER_Exit
	//; END VerticalSideBorderBitmap -------------------------------------------------------------------------------------------------------

	LoopForever:
		jmp LoopForever

IRQLoader_SpindleLoadA:
.if (USE_SPINDLE)
{
	//; A = desired seek point, 00-3f
	ora	#$80
	sec
	rol
	ldx	#$18

spin_seek_bitloop:
	stx	$dd00		//; Pull clock and atn.

	bcc	*+4
	ldy	#$10		//; Y becomes 00 or 10 according to bit.

	bit	$dd00		//; Wait for the drive to become ready.
	bpl	*-3

	sty	$dd00		//; Release atn; clock carries the bit.

	ldy	#5		//; Give the drive enough time to read the bit
	dey			//; and to pull the data line again.
	bne	*-1

	asl
	bne	spin_seek_bitloop

	ldx	#$08
	stx	$dd00		//; Pull atn after the last bit.

	jmp IRQLoader_LoadNext
}