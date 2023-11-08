//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

.var BundleIndex_FirstBlock = 2

*= DISK_BASE

Entry:

	//; BEGIN Setup
		lda #$00
		sta VIC_D011
		sta VIC_BorderColour

		jsr BASECODE_StartMusic
	//; END Setup

	//; VerticalSideBorderBitmap -------------------------------------------------------------------------------------------------------
		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap (1)
		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap (2)
		jsr IRQLoader_LoadNext //; #VerticalSideBorderBitmap (2)

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
		
		lda	#1
		.if (USE_SPINDLE) jsr IRQLoader_SpindleLoadA
		.if (USE_SPARKLE) jsr IRQLoader_LoadA

		jmp	VertBitmapLoop
	//; END VerticalSideBorderBitmap

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