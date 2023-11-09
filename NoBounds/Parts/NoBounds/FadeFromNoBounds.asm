//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* = $c000

//; Local Defines -------------------------------------------------------------------------------------------------------
	
.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
.import source "../../Build/6502/NoBounds/FadeFromNoBounds_RasterUpdateDefines.asm"
.import source "../../Build/6502/NoBounds/FadeFromNoBounds_RasterUpdateData.sym"

.var FadeFromNoBounds_RasterColours = $0400

.var ZP_NumColourChanges = $f0
.var ZP_RasterDataPtr_YValues = $f2
.var ZP_RasterDataPtr_ColValues = $f4


//; FadeFromNoBounds_Go() -------------------------------------------------------------------------------------------------------

FadeFromNoBounds_Go:

		dec $01
		ldy #$08
		ldx #$00
Src:	lda $d000,x
Dst:	sta $9000,x
		inx
		bne Src
		inc Src+2
		inc Dst+2
		dey
		bpl Src
		inc $01

	!vb:
		bit VIC_D011
		bpl !vb-
		
		sei

		lda #<FadeFromNoBounds_RasterData_YValues
		sta ZP_RasterDataPtr_YValues + 0
		lda #>FadeFromNoBounds_RasterData_YValues
		sta ZP_RasterDataPtr_YValues + 1
		lda #<FadeFromNoBounds_RasterData_ColValues
		sta ZP_RasterDataPtr_ColValues + 0
		lda #>FadeFromNoBounds_RasterData_ColValues
		sta ZP_RasterDataPtr_ColValues + 1

		lda #$00
		sta VIC_SpriteEnable
		sta PART_Done
		sta FadeFromNoBounds_RasterColours + 250
		sta FadeFromNoBounds_RasterColours + 251

		sta VIC_D011
		sta VIC_D012
		lda #<FadeFromNoBounds_IRQ_Music_FirstFrame
		sta $fffe
		lda #>FadeFromNoBounds_IRQ_Music_FirstFrame
		sta $ffff

		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		//; jsr IRQLoader_LoadNext				//; We preloaded the two PRGs during the last streaming loader call, RasterData goes under I/O temporarily

		dec IsRasterTransitionFinished + 1

		jsr IRQLoader_LoadNext					//; Preloading Trailblazer

	WaitForEndOfFadeFromNoBounds:
		lda IsRasterTransitionFinished + 1
		beq WaitForEndOfFadeFromNoBounds

		//; jmp IRQLoader_LoadNext				//; Trailblazer.prg is preloaded to $4000, this is no longer needed
		rts


//; FadeFromNoBounds_IRQ_Music_FirstFrame() -------------------------------------------------------------------------------------------------------

FadeFromNoBounds_IRQ_Music_FirstFrame:

		IRQManager_BeginIRQ(0, 0)

		lda #$03
		sta VIC_BorderColour
		bne FadeFromNoBounds_IRQ_Music_Continue


//; FadeFromNoBounds_IRQ_Music() -------------------------------------------------------------------------------------------------------

FadeFromNoBounds_IRQ_Music:

		IRQManager_BeginIRQ(0, 0)

	FadeFromNoBounds_IRQ_Music_Continue:

		jsr BASE_PlayMusic

		lda #$00
		sta VIC_D011

	D012ValueToSet:
		lda #$28
		sta VIC_D012
		lda #<FadeFromNoBounds_IRQ_Main
		sta $fffe
		lda #>FadeFromNoBounds_IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; FadeFromNoBounds_IRQ_Main() -------------------------------------------------------------------------------------------------------

FadeFromNoBounds_IRQ_Main:

		IRQManager_BeginIRQ(1, 0)

		ldx #11
	FadeFromNoBounds_FirstDelays:
		dex
		bne FadeFromNoBounds_FirstDelays
		nop $ff

	Fade_MinY:
		ldy #$28
	FadeFromNoBounds_Loop:
		lda FadeFromNoBounds_RasterColours, y
		sta VIC_BorderColour

		ldx #9
	FadeFromNoBounds_InnerDelays:
		dex
		bne FadeFromNoBounds_InnerDelays
		nop
		nop

		iny
		bne FadeFromNoBounds_Loop

	IsRasterTransitionFinished:
		lda #$01
		bne FadeFromNoBounds_FinishedUpdateRasters

	FadeFromNoBounds_FrameIndex:
		ldy #0

		lda FadeFromNoBounds_RasterData_MinYValues, y
		sta D012ValueToSet + 1
		sta Fade_MinY + 1
		
		lda FadeFromNoBounds_RasterData_NumColourChanges, y
		beq FadeFromNoBounds_FinishedFrame
		sta ZP_NumColourChanges
		sta IncZPPointers_A + 1
		sta IncZPPointers_B + 1

		ldy #$00

	FadeFromNoBounds_UpdateRastersLoop:

		lda (ZP_RasterDataPtr_YValues), y
		tax
		lda (ZP_RasterDataPtr_ColValues), y
		sta FadeFromNoBounds_RasterColours, x

		iny
		dec ZP_NumColourChanges
		bne FadeFromNoBounds_UpdateRastersLoop

		lda ZP_RasterDataPtr_YValues + 0
		clc
	IncZPPointers_A:
		adc #$00
		sta ZP_RasterDataPtr_YValues + 0
		lda ZP_RasterDataPtr_YValues + 1
		adc #$00
		sta ZP_RasterDataPtr_YValues + 1

		lda ZP_RasterDataPtr_ColValues + 0
		clc
	IncZPPointers_B:
		adc #$00
		sta ZP_RasterDataPtr_ColValues + 0
		lda ZP_RasterDataPtr_ColValues + 1
		adc #$00
		sta ZP_RasterDataPtr_ColValues + 1

	FadeFromNoBounds_FinishedFrame:
		ldy FadeFromNoBounds_FrameIndex + 1
		iny
		sty FadeFromNoBounds_FrameIndex + 1
		cpy #FadeFromNoBounds_NumFrames
		bne FadeFromNoBounds_FinishedUpdateRasters

		inc IsRasterTransitionFinished + 1

	FadeFromNoBounds_FinishedUpdateRasters:

		lda #$80
		sta VIC_D011
		lda #$10
		sta VIC_D012
		lda #<FadeFromNoBounds_IRQ_Music
		sta $fffe
		lda #>FadeFromNoBounds_IRQ_Music
		sta $ffff

		IRQManager_EndIRQ()
		rti
