//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $b800 "StarWarsRasterTransBase"

	jmp RasterTrans_Go



//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-b00d Code + Data
//; - $c800-cbff Screen
//; ---- $ce00-dfff Scroll buffers
//; - $e000-e3bf ScrollText
//; ---- $e3c0-fcbf Bitmap (nb. only bottom 10 lines currently used)
//; - $fd00-feff Remapped Font

//; Local Defines -------------------------------------------------------------------------------------------------------
	
.var RasterData = $b500
.var RasterColours = $b400

.var RingBufferLength = 8

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

RasterRingBuffer:
		.fill RingBufferLength, $ff

NextRingBufferIndex:
		.fill RingBufferLength - 1, i + 1
		.byte 0

ColFadeTable:
		.byte $02, $0a, $07, $01, $0d, $05, $09, $00

FinalBarColourTable:
		.byte $00, $09, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $02, $0a, $02, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $06, $0e, $0f, $0e, $06, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $09, $05, $0d, $01
		
//; RasterTrans_Go() -------------------------------------------------------------------------------------------------------
RasterTrans_Go:

		vsync()

		sei	

		lda #0
		sta PART_Done

		lda #49
		sta VIC_D012
		lda #$00
		sta VIC_D011
		sta VIC_SpriteEnable
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		jsr IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	WaitTillRastersAreFinished:
		ldx #$00
		lda FinalBarColourTable, x
		sta FinalBarColour + 1
		cmp #1
		bne WaitTillRastersAreFinished
		rts

IRQ_Main:
		IRQManager_BeginIRQ(1, 0)

		ldx #11
	FirstDelays:
		dex
		bne FirstDelays
		nop $ff

		ldy #0
	Loop:
		lda RasterColours + 28,y
		sta VIC_BorderColour

		ldx #9
	InnerDelays:
		dex
		bne InnerDelays
		nop

		iny
	RasterHeight:
		cpy #200
		bne Loop

		nop
		nop
		nop $ff

		lda #$00
		sta VIC_BorderColour

	UpdateRasters:
		ldy #0
		lda RasterData + (1 * 256), y
		clc
		adc #28
		sta Loop + 1
		adc #21
		sta NextD012 + 1
		lda RasterData + (2 * 256), y
		sta RasterHeight + 1

		lda RasterData + (0 * 256), y
		
	RasterRingBufferIndex:
		ldx #$00
		sta RasterRingBuffer, x
		lda NextRingBufferIndex, x
		sta RasterRingBufferIndex + 1

	UpdateRastersLoop:

		ldx RasterRingBufferIndex + 1

		.for (var i = 0; i < RingBufferLength; i++)
		{
			ldy RasterRingBuffer, x
			cpy #$ff
			beq !SkipToNextRaster+
			lda ColFadeTable + (7 - i)
			sta RasterColours + 28, y
		!SkipToNextRaster:
			.if (i != (RingBufferLength - 1))
			{
				lda NextRingBufferIndex, x
				tax
			}
		}

		inc UpdateRasters + 1
		lda UpdateRasters + 1
		cmp #200 + RingBufferLength
		bne NotFinishedUpdatingRasters

		jmp SetFinalIRQ
	NotFinishedUpdatingRasters:

		lda #$80
		sta VIC_D011
		lda #$08
		sta VIC_D012
		lda #<IRQ_Music
		sta $fffe
		lda #>IRQ_Music
		sta $ffff

		IRQManager_EndIRQ()
		rti


IRQ_Music:

		IRQManager_BeginIRQ(1, 0)

		jsr BASE_PlayMusic

		lda #0
		sta VIC_D011
	NextD012:
		lda #49
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		IRQManager_EndIRQ()
		rti


IRQ_Final:
		IRQManager_BeginIRQ(1, 0)

	FinalBarColour:
		lda #$00
		sta VIC_BorderColour

		ldx #49
	FinalDelays:
		dex
		bne FinalDelays

		lda #$00
		sta VIC_BorderColour

		inc WaitTillRastersAreFinished + 1

	SetFinalIRQ:
		lda #$80
		sta VIC_D011
		lda #$08
		sta VIC_D012
		lda #<IRQ_Final_Music
		sta $fffe
		lda #>IRQ_Final_Music
		sta $ffff

		IRQManager_EndIRQ()
		rti


IRQ_Final_Music:

		IRQManager_BeginIRQ(1, 0)

		jsr BASE_PlayMusic

		lda #$00
		sta VIC_D011
		lda #147
		sta VIC_D012
		lda #<IRQ_Final
		sta $fffe
		lda #>IRQ_Final
		sta $ffff

		IRQManager_EndIRQ()
		rti

