//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= ABDDYPP_JUSTRASTERS_BASE

	.var RasterTableLen = 165
	.var RasterTableMidStop = 82 //; 165 / 2 - 1
	.var FirstRasterLine = $4a

	.var FadeSineTable_Len = 82
	.var FadeSineTable_YIndexStart = $bf00
	.var FadeSineTable_YIndexEnd = FadeSineTable_YIndexStart + (FadeSineTable_Len * 1)
	.var FadeSineTable_YRasterStart = FadeSineTable_YIndexStart + (FadeSineTable_Len * 2)

	.var ZP_IRQJump = $a0		//$04 - interferes with loader!!!


//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		jmp StartEaseIn
		jmp StartEaseOut
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $1000-1fff Music
//; - $f800-ffff Code

RasterColours:
	.byte $02, $02, $00, $00, $02, $04, $04, $00, $04, $04, $04, $0a, $04, $04, $04, $0a
	.byte $0a, $04, $04, $0a, $0a, $0a, $04, $0a, $0a, $03, $0a, $0a, $0a, $03, $03, $0a
	.byte $0a, $03, $03, $03, $0a, $03, $03, $03, $03, $03, $07, $03, $03, $03, $07, $07
	.byte $03, $03, $07, $07, $07, $03, $07, $07, $07, $07, $07, $07, $01, $07, $07, $07
	.byte $01, $01, $07, $07, $01, $01, $01, $07, $01, $01, $01, $01, $01, $01, $01, $01
	.byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $07, $01, $01, $01
	.byte $07, $07, $01, $01, $07, $07, $07, $01, $07, $07, $07, $07, $07, $07, $03, $07
	.byte $07, $07, $03, $03, $07, $07, $03, $03, $03, $07, $03, $03, $03, $03, $03, $0a
	.byte $03, $03, $03, $0a, $0a, $03, $03, $0a, $0a, $0a, $03, $0a, $0a, $04, $0a, $0a
	.byte $0a, $04, $04, $0a, $0a, $04, $04, $04, $0a, $04, $04, $04, $00, $04, $04, $02
	.byte $00, $00, $02, $02, $00

StartRasterIndex:		.byte RasterTableMidStop
EndRasterIndex:			.byte RasterTableMidStop + 1
StartRasterLine:		.byte RasterTableMidStop + FirstRasterLine
EaseMode:				.byte $00
FadeFrame:				.byte $00

StartEaseIn:

		jsr BASECODE_VSync

		lda #$1b
		sta VIC_D011

		lda #$00
		ldx #$00
		jmp ABDDYPP_JustRasters_Init

StartEaseOut:
		lda #$01
		ldx #FadeSineTable_Len - 1

//; ABDDYPP_JustRasters_Init() -------------------------------------------------------------------------------------------------------
ABDDYPP_JustRasters_Init:

		sta EaseMode
		stx FadeFrame

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #JMP_ABS
		sta ZP_IRQJump + 0
		lda #<JustRastersIRQ
		sta ZP_IRQJump + 1
		lda #>JustRastersIRQ
		sta ZP_IRQJump + 2
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda StartRasterLine
		sta VIC_D012
		lda #<ZP_IRQJump
		sta $fffe
		lda #>ZP_IRQJump
		sta $ffff

		asl VIC_D019

		cli
		rts

JustRastersIRQ:
		:IRQManager_BeginIRQ(1, 0)

		ldy StartRasterIndex
	RasterBarLoop:
		lda RasterColours, y
		sta VIC_BorderColour
		sta VIC_ScreenColour
		ldx #7
	DelayLoop:
		dex
		bne DelayLoop
		nop $ff
		nop $ff
		iny

		cpy EndRasterIndex
		bne RasterBarLoop

		lda #$00
		sta VIC_BorderColour
		sta VIC_ScreenColour

		lda #250
		sta VIC_D012
		lda #<JustRastersIRQ_OpenBorder250
		sta $a1
		lda #>JustRastersIRQ_OpenBorder250
		sta $a2

		:IRQManager_EndIRQ()
		rti

JustRastersIRQ_OpenBorder250:
		:IRQManager_BeginIRQ(0, 0)

		lda #$03
		sta VIC_D011

	WaitFor256:
		bit VIC_D011
		bpl WaitFor256

		lda #$0b
		sta VIC_D011

		jsr BASECODE_PlayMusic

		ldy FadeFrame
		lda FadeSineTable_YIndexStart, y
		sta StartRasterIndex
		lda FadeSineTable_YIndexEnd, y
		sta EndRasterIndex
		lda FadeSineTable_YRasterStart, y
		sta StartRasterLine

		lda EaseMode
		bne EaseOut

	EaseIn:
		iny
		cpy #FadeSineTable_Len
		bne NotFinishedEaseIn
		inc Signal_CurrentEffectIsFinished
		dey
	NotFinishedEaseIn:
		sty FadeFrame
		jmp EndThisIRQ

	EaseOut:
		dey
		bpl NotFinishedEaseOut
		inc Signal_CurrentEffectIsFinished
		iny
	NotFinishedEaseOut:
		sty FadeFrame

	EndThisIRQ:
		lda StartRasterLine
		sta VIC_D012
		lda #<JustRastersIRQ
		sta $a1
		lda #>JustRastersIRQ
		sta $a2

		:IRQManager_EndIRQ()
		rti
