//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $e300 "BASICFade2Base"

		jmp BASICFade2_Go

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $1e-1f Raster Fade Ptr
//; ---- $20-$e8 Raster Colour Tables
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $e300-e7ff Code

.var ZP_RasterColoursTop = $20
.var ZP_RasterColoursBottom = $60

.var ScreenRasterFadeWrites = $e800

.import source "../../Build/6502/BASICFADE/FadeCode.asm"


RasterBars:
		.fill 25, $0e
		.byte $00

RasterBarIndex:
		.byte -$09 * 4 + 0, -$04 * 4 + 1, -$15 * 4 + 2, -$0d * 4 + 3, -$11 * 4 + 0
		.byte -$0b * 4 + 1, -$01 * 4 + 2, -$06 * 4 + 3, -$00 * 4 + 0, -$16 * 4 + 1
		.byte -$13 * 4 + 2, -$0f * 4 + 3, -$08 * 4 + 0, -$0a * 4 + 1, -$14 * 4 + 2
		.byte -$02 * 4 + 3, -$18 * 4 + 0, -$10 * 4 + 1, -$05 * 4 + 2, -$0e * 4 + 3
		.byte -$07 * 4 + 0, -$0c * 4 + 1, -$12 * 4 + 2, -$17 * 4 + 3, -$03 * 4 + 0
		.byte $80

RasterBarColTableIndex:
		.fill 12, (8 * 0)
		.fill  1, (8 * 1)
		.fill 12, (8 * 2)

ColourFadeTables:
		.byte $07, $01, $0d, $05, $09, $09, $02, $0a
		.byte $07, $01, $03, $0e, $06, $02, $0a, $07
		.byte $07, $01, $07, $0a, $02, $09, $02, $02


//; BASICFade2_Go() -------------------------------------------------------------------------------------------------------

BASICFade2_Go:
		
	//; push the return address so that our RTS will drop back into the disk code for the next part!
		tya
		pha
		txa
		pha

		lda #$00
		sta PART_Done

		ldy #$3f
		lda #$0e
	FillRasterColoursLoop:
		sta ZP_RasterColoursTop, y
		sta ZP_RasterColoursBottom, y
		dey
		bpl FillRasterColoursLoop

		vsync()

		sei

		lda #$c8
		sta VIC_D012
		lda #<IRQ_BASICFADE_PartTwo_IRQ_Music
		sta $fffe
		lda #>IRQ_BASICFADE_PartTwo_IRQ_Music
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		jsr IRQLoader_LoadNext

	WaitForPartFinished:
		bit PART_Done
		beq WaitForPartFinished
		
		rts


//; IRQ_BASICFADE_PartTwo_IRQ() -------------------------------------------------------------------------------------------------------

IRQ_BASICFADE_PartTwo_IRQ:
		
		IRQManager_BeginIRQ(1, 0)

		ldx #11
	FirstDelays:
		dex
		bne FirstDelays
		nop $ff

		ldy #0
	Loop:
		lda ZP_RasterColoursBottom,y
		sta VIC_BorderColour

		ldx #9
	InnerDelays:
		dex
		bne InnerDelays
		nop

		iny
		cpy #NumRastersBottom
		bne Loop

	FadeB_Frame:
		ldy #0
		iny
		sty FadeB_Frame + 1
		cpy #NumFadeFrames
		bne NotFinishedDemoPart
		jmp StartBASICFadePartThree

	NotFinishedDemoPart:
		jsr BASICFADE_UpdateRasterColours

		lda #$06
		sta VIC_D012
		lda #$00
		sta VIC_D011
		lda #<IRQ_BASICFADE_PartTwo_IRQ_B
		sta $fffe
		lda #>IRQ_BASICFADE_PartTwo_IRQ_B
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_BASICFADE_PartTwo_IRQ_B() -------------------------------------------------------------------------------------------------------

IRQ_BASICFADE_PartTwo_IRQ_B:
		
		IRQManager_BeginIRQ(1, 0)

		ldx #11
	FirstDelays_B:
		dex
		bne FirstDelays_B
		nop $ff

		ldy #0
	Loop_B:
		lda ZP_RasterColoursTop,y
		sta VIC_BorderColour

		ldx #9
	InnerDelays_B:
		dex
		bne InnerDelays_B
		nop

		iny
		cpy #(NumRastersTop + 1)
		bne Loop_B

		lda #$c8
		sta VIC_D012
		lda #<IRQ_BASICFADE_PartTwo_IRQ_Music
		sta $fffe
		lda #>IRQ_BASICFADE_PartTwo_IRQ_Music
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_BASICFADE_PartTwo_IRQ_Music() -------------------------------------------------------------------------------------------------------

IRQ_BASICFADE_PartTwo_IRQ_Music:

		IRQManager_BeginIRQ(0, 0)

		jsr BASE_PlayMusic

		lda #$f9
		sta VIC_D012
		lda #<IRQ_BASICFADE_PartTwo_IRQ
		sta $fffe
		lda #>IRQ_BASICFADE_PartTwo_IRQ
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; IRQ_BASICFADE_PartThree_IRQ() -------------------------------------------------------------------------------------------------------

IRQ_BASICFADE_PartThree_IRQ:
		
		IRQManager_BeginIRQ(1, 0)

	NextBarColour:
		lda #$0e
		sta VIC_BorderColour

	BarLineIndex:
		ldx #0
		inx
		cpx #26
		bne NotLastLine
		ldx #0
	NotLastLine:
		stx BarLineIndex + 1

		ldy RasterBarIndex, x
		bmi NoRasterUpdate

		cpy #32
		bcs NoRasterUpdate

		tya
		lsr
		lsr
		clc
		adc RasterBarColTableIndex, x
		tay
		lda ColourFadeTables, y
		sta RasterBars, x

	NoRasterUpdate:
		inc RasterBarIndex, x

		lda RasterBars, x
		sta NextBarColour + 1

		txa
		asl
		asl
		asl
		clc
		adc #50
		sta SetPartThreeIRQ + 1

		cpx #$00
		bne DontPlayMusic

		jsr BASE_PlayMusic

	FrameCounter:
		ldx #$00
		inx
		stx FrameCounter + 1

		bpl DontPlayMusic

		inc PART_Done
		bne SetPartThreeIRQ
	DontPlayMusic:

	SetPartThreeIRQ:
		lda #50
		sta VIC_D012
		lda #<IRQ_BASICFADE_PartThree_IRQ
		sta $fffe
		lda #>IRQ_BASICFADE_PartThree_IRQ
		sta $ffff

		IRQManager_EndIRQ()
		rti


//; StartBASICFadePartThree() -------------------------------------------------------------------------------------------------------

StartBASICFadePartThree:

		ldy #49
		lda #$0e
	FillRasterLoop:
		sta ZP_RasterColoursTop, y
		sta ZP_RasterColoursTop + (50 * 1), y
		sta ZP_RasterColoursTop + (50 * 2), y
		sta ZP_RasterColoursTop + (50 * 3), y
		dey
		bpl FillRasterLoop

		lda #0
		sta ZP_RasterColoursTop + 200

		jmp SetPartThreeIRQ