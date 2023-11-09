//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* = $0500

//; Local Defines -------------------------------------------------------------------------------------------------------
	
.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
.import source "../../Build/6502/RotatingGP/FadeToNoBounds_RasterUpdateData.sym"
.import source "../../Build/6502/RotatingGP/FadeToNoBounds_RasterUpdateDefines.asm"

.var FadeToNoBounds_RasterColours = $0400

.var ZP_NumColourChanges = $f0
.var ZP_RasterDataPtr_YValues = $f2
.var ZP_RasterDataPtr_ColValues = $f4


//; FadeToNoBounds_Go() -------------------------------------------------------------------------------------------------------

FadeToNoBounds_Go:

		vsync()

		lda #0
		sta VIC_D011

		ldy #$00
		lda #$00
	FillRasterColoursLoop:
		sta FadeToNoBounds_RasterColours, y
		iny
		bne FillRasterColoursLoop

		vsync()

		sei

		lda #0
		sta PART_Done

		lda #<FadeToNoBounds_RasterData_YValues
		sta ZP_RasterDataPtr_YValues + 0
		lda #>FadeToNoBounds_RasterData_YValues
		sta ZP_RasterDataPtr_YValues + 1
		lda #<FadeToNoBounds_RasterData_ColValues
		sta ZP_RasterDataPtr_ColValues + 0
		lda #>FadeToNoBounds_RasterData_ColValues
		sta ZP_RasterDataPtr_ColValues + 1

		lda #$9e
		sta VIC_D012
		lda #$00
		sta VIC_D011
		sta VIC_SpriteEnable
		lda #<FadeToNoBounds_IRQ_Main
		sta $fffe
		lda #>FadeToNoBounds_IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		jsr IRQLoader_LoadNext				//; DISK-NoBounds.prg, NoBound.prg

		jsr IRQLoader_LoadNext				//; First 4 chunks loaded here to fill buffers

	Loopity2:
		lda PART_Done
		beq Loopity2

		rts


//; FadeToNoBounds_IRQ_Main() -------------------------------------------------------------------------------------------------------

FadeToNoBounds_IRQ_Main:

		IRQManager_BeginIRQ(1, 0)

		ldx #11
	FadeToNoBounds_FirstDelays:
		dex
		bne FadeToNoBounds_FirstDelays
		nop $ff

	FadeToNoBounds_RasterYIndex:
		ldy #0
	FadeToNoBounds_Loop:
		lda FadeToNoBounds_RasterColours, y
		sta VIC_BorderColour

		ldx #9
	FadeToNoBounds_InnerDelays:
		dex
		bne FadeToNoBounds_InnerDelays
		nop

		iny
	FadeToNoBounds_EndY:
		cpy #1
		bne FadeToNoBounds_Loop

		lda PART_Done
		beq FadeToNoBounds_FrameIndex
		jmp FadeToNoBounds_FadeIsFinished_SetOtherIRQ

	FadeToNoBounds_FrameIndex:
		ldy #0

		lda FadeToNoBounds_RasterData_MinYValues, y
		sta D012ValueToSet + 1
		sta FadeToNoBounds_RasterYIndex + 1

		lda FadeToNoBounds_RasterData_MaxYValues, y
		sta FadeToNoBounds_EndY + 1

		lda FadeToNoBounds_RasterData_NumColourChanges, y
		beq FadeToNoBounds_FinishedFrame
		sta ZP_NumColourChanges
		sta IncZPPointers_A + 1
		sta IncZPPointers_B + 1

		ldy #$00

	FadeToNoBounds_UpdateRastersLoop:

		lda (ZP_RasterDataPtr_YValues), y
		tax
		lda (ZP_RasterDataPtr_ColValues), y
		sta FadeToNoBounds_RasterColours, x

		iny
		dec ZP_NumColourChanges
		bne FadeToNoBounds_UpdateRastersLoop

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

	FadeToNoBounds_FinishedFrame:
		ldy FadeToNoBounds_FrameIndex + 1
		iny
		sty FadeToNoBounds_FrameIndex + 1
		cpy #FadeToNoBounds_NumFrames
		bne FadeToNoBounds_FinishedUpdateRasters

		inc PART_Done

	FadeToNoBounds_FinishedUpdateRasters:

		lda #$80
		sta VIC_D011
		lda #$10
		sta VIC_D012
		lda #<FadeToNoBounds_IRQ_Music
		sta $fffe
		lda #>FadeToNoBounds_IRQ_Music
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; FadeToNoBounds_IRQ_Music() -------------------------------------------------------------------------------------------------------

FadeToNoBounds_IRQ_Music:

		IRQManager_BeginIRQ(0, 0)

		jsr BASE_PlayMusic

		lda #0
		sta VIC_D011
	D012ValueToSet:
		lda #$00
		sta VIC_D012
		lda #<FadeToNoBounds_IRQ_Main
		sta $fffe
		lda #>FadeToNoBounds_IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; FadeToNoBounds_FadeIsFinished_SetOtherIRQ() -------------------------------------------------------------------------------------------------------

FadeToNoBounds_FadeIsFinished_SetOtherIRQ:

		lda #98
		sta FadeToNoBounds_RasterYIndex + 1

		lda #0
		sta VIC_D011
		sta VIC_D012
		lda #<FadeToNoBounds_IRQ_Final
		sta $fffe
		lda #>FadeToNoBounds_IRQ_Final
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; FadeToNoBounds_IRQ_Final() -------------------------------------------------------------------------------------------------------

FadeToNoBounds_IRQ_Final:

		IRQManager_BeginIRQ(1, 0)

		lda #$03
		sta VIC_BorderColour

		jsr BASE_PlayMusic

		lda #98
		sta VIC_D012
		lda #<FadeToNoBounds_IRQ_Main
		sta $fffe
		lda #>FadeToNoBounds_IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti
