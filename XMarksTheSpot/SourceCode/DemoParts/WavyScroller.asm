//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"
.import source "WavyScroller-Defines.asm"
.import source "..\..\Intermediate\KickAss\DemoParts\Blit.sym"

* = WavyScroller_BASE "Wavy Scroller"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; - $3000-3fff SinTables
//; ---- $4000-4fff Screens (0 - 3)
//; ---- $5000-5fff Screens (4 - 7)
//; ---- $6000-7fff Charset (0 - 3)
//; - $8000-bfff CharSet
//; - $e000-feff Code+Data
//; - $ff00-ff3f CharInfo

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp WAVYSCROLLER_Init				//; Init
		.byte $60, $00, $00					//; MainThreadFunc
		jmp WAVYSCROLLER_End				//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; WAVYSCROLLER_LocalData -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,					LoPtr,							HiPtr
		.byte	$00,			WAVYSCROLLER_YRASTER,	<WAVYSCROLLER_IRQ_Function,		>WAVYSCROLLER_IRQ_Function
		.byte	$ff

	.align 16
	WAVYSCROLLER_CharVal_Mul:
		.byte (16 * 0), (16 * 0), (16 * 0), (16 * 0)

	.align 4
	WAVYSCROLLER_Frame_D018:
		.byte ((ScreenBank0 * 16) + (CharBankA * 2))
		.byte ((ScreenBank0 * 16) + (CharBankB * 2))
		.byte ((ScreenBank0 * 16) + (CharBankC * 2))
		.byte ((ScreenBank0 * 16) + (CharBankD * 2))

	WAVYSCROLLER_ScrollPos:
		.byte (4 * 8 - 1)
	WAVYSCROLLER_AValue:
		.byte WAVYSCROLLER_NUM_CHARS_IN_CHARSET - 1
	WAVY_Char0:
		.byte $1f
	WAVY_Char1:
		.byte $1f

	WAVY_SCROLLTEXT:
		.import binary "..\..\Intermediate\Built\WavyScroller\ScrollText.bin"

WAVYSCROLLER_Blit_JMPs_Lo:
	.byte <WAVYSCROLLER_Blit_Line0_CharSetA,  <WAVYSCROLLER_Blit_Line0_CharSetB,  <WAVYSCROLLER_Blit_Line0_CharSetC,  <WAVYSCROLLER_Blit_Line0_CharSetD
	.byte <WAVYSCROLLER_Blit_Line1_CharSetA,  <WAVYSCROLLER_Blit_Line1_CharSetB,  <WAVYSCROLLER_Blit_Line1_CharSetC,  <WAVYSCROLLER_Blit_Line1_CharSetD
	.byte <WAVYSCROLLER_Blit_Line2_CharSetA,  <WAVYSCROLLER_Blit_Line2_CharSetB,  <WAVYSCROLLER_Blit_Line2_CharSetC,  <WAVYSCROLLER_Blit_Line2_CharSetD
	.byte <WAVYSCROLLER_Blit_Line3_CharSetA,  <WAVYSCROLLER_Blit_Line3_CharSetB,  <WAVYSCROLLER_Blit_Line3_CharSetC,  <WAVYSCROLLER_Blit_Line3_CharSetD
	.byte <WAVYSCROLLER_Blit_Line4_CharSetA,  <WAVYSCROLLER_Blit_Line4_CharSetB,  <WAVYSCROLLER_Blit_Line4_CharSetC,  <WAVYSCROLLER_Blit_Line4_CharSetD
	.byte <WAVYSCROLLER_Blit_Line5_CharSetA,  <WAVYSCROLLER_Blit_Line5_CharSetB,  <WAVYSCROLLER_Blit_Line5_CharSetC,  <WAVYSCROLLER_Blit_Line5_CharSetD
	.byte <WAVYSCROLLER_Blit_Line6_CharSetA,  <WAVYSCROLLER_Blit_Line6_CharSetB,  <WAVYSCROLLER_Blit_Line6_CharSetC,  <WAVYSCROLLER_Blit_Line6_CharSetD
	.byte <WAVYSCROLLER_Blit_Line7_CharSetA,  <WAVYSCROLLER_Blit_Line7_CharSetB,  <WAVYSCROLLER_Blit_Line7_CharSetC,  <WAVYSCROLLER_Blit_Line7_CharSetD

WAVYSCROLLER_Blit_JMPs_Hi:
	.byte >WAVYSCROLLER_Blit_Line0_CharSetA,  >WAVYSCROLLER_Blit_Line0_CharSetB,  >WAVYSCROLLER_Blit_Line0_CharSetC,  >WAVYSCROLLER_Blit_Line0_CharSetD
	.byte >WAVYSCROLLER_Blit_Line1_CharSetA,  >WAVYSCROLLER_Blit_Line1_CharSetB,  >WAVYSCROLLER_Blit_Line1_CharSetC,  >WAVYSCROLLER_Blit_Line1_CharSetD
	.byte >WAVYSCROLLER_Blit_Line2_CharSetA,  >WAVYSCROLLER_Blit_Line2_CharSetB,  >WAVYSCROLLER_Blit_Line2_CharSetC,  >WAVYSCROLLER_Blit_Line2_CharSetD
	.byte >WAVYSCROLLER_Blit_Line3_CharSetA,  >WAVYSCROLLER_Blit_Line3_CharSetB,  >WAVYSCROLLER_Blit_Line3_CharSetC,  >WAVYSCROLLER_Blit_Line3_CharSetD
	.byte >WAVYSCROLLER_Blit_Line4_CharSetA,  >WAVYSCROLLER_Blit_Line4_CharSetB,  >WAVYSCROLLER_Blit_Line4_CharSetC,  >WAVYSCROLLER_Blit_Line4_CharSetD
	.byte >WAVYSCROLLER_Blit_Line5_CharSetA,  >WAVYSCROLLER_Blit_Line5_CharSetB,  >WAVYSCROLLER_Blit_Line5_CharSetC,  >WAVYSCROLLER_Blit_Line5_CharSetD
	.byte >WAVYSCROLLER_Blit_Line6_CharSetA,  >WAVYSCROLLER_Blit_Line6_CharSetB,  >WAVYSCROLLER_Blit_Line6_CharSetC,  >WAVYSCROLLER_Blit_Line6_CharSetD
	.byte >WAVYSCROLLER_Blit_Line7_CharSetA,  >WAVYSCROLLER_Blit_Line7_CharSetB,  >WAVYSCROLLER_Blit_Line7_CharSetC,  >WAVYSCROLLER_Blit_Line7_CharSetD

WAVYSCROLLER_XEOR:
	.byte $10, $30, $10, $70, $10, $30, $10, $70
WAVYSCROLLER_Minus1Modded:
	.byte 14, 0
WAVYSCROLLER_Plus1Modded:
	.byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0

	.print "* $" + toHexString(WAVYSCROLLER_LocalData) + "-$" + toHexString(EndWAVYSCROLLER_LocalData - 1) + " WAVYSCROLLER_LocalData"
EndWAVYSCROLLER_LocalData:

//; WAVYSCROLLER_Init() -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		ldx #$00
		ldy #(4 * 4 / 2)
		lda #$ff //; Clear Char
	WAVYSCROLLER_ClearScreenLoop:
		sta ScreenAddress0, x
		sta ScreenAddress2, x
		inx
		bne WAVYSCROLLER_ClearScreenLoop
		inc WAVYSCROLLER_ClearScreenLoop + (3 * 0) + 2
		inc WAVYSCROLLER_ClearScreenLoop + (3 * 1) + 2
		dey
		bne WAVYSCROLLER_ClearScreenLoop

		ldy #$00
		lda #WAVYSCROLLER_Colours_Screen
	WAVYSCROLLER_SetColourLoop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (1000 - 256), y
		iny
		bne WAVYSCROLLER_SetColourLoop

		ldy #$00
	WAVYSCROLLER_FillColourMemoryOuterLoop:
		ldx #(7 + 3)
	WAVYSCROLLER_FillColourMemoryLoop:
		lda #WAVYSCROLLER_Colour_0
	WAVYSCROLLER_ColMemPtr0:
		sta VIC_ColourMemory + WAVYSCROLLER_XOffset + ((WAVYSCROLLER_ENDY - 1) - WAVYSCROLLER_STARTY) + (WAVYSCROLLER_STARTY + 1) * 40 - 1, x
		lda #WAVYSCROLLER_Colour_1
	WAVYSCROLLER_ColMemPtr1:
		sta VIC_ColourMemory + WAVYSCROLLER_XOffset + ((WAVYSCROLLER_ENDY - 1) - WAVYSCROLLER_STARTY) + (WAVYSCROLLER_STARTY + 1) * 40 + 89 - 1, x
		dex
		bpl WAVYSCROLLER_FillColourMemoryLoop

		lda WAVYSCROLLER_ColMemPtr0 + 1
		clc
		adc #$27
		sta WAVYSCROLLER_ColMemPtr0 + 1
		lda WAVYSCROLLER_ColMemPtr0 + 2
		adc #$00
		sta WAVYSCROLLER_ColMemPtr0 + 2

		lda WAVYSCROLLER_ColMemPtr1 + 1
		clc
		adc #$27
		sta WAVYSCROLLER_ColMemPtr1 + 1
		lda WAVYSCROLLER_ColMemPtr1 + 2
		adc #$00
		sta WAVYSCROLLER_ColMemPtr1 + 2

		iny
		cpy #(WAVYSCROLLER_YCHARLEN - 1)
		bne WAVYSCROLLER_FillColourMemoryOuterLoop

		ldy #$08
		ldx #$00
	ClearCharSetLoopOuter:
		lda #$00
	ClearCharSetLoop:
		sta CharAddressA, x
		sta CharAddressB, x
		sta CharAddressC, x
		sta CharAddressD, x
		inx
		bne ClearCharSetLoop
		inc ClearCharSetLoop + 2
		inc ClearCharSetLoop + 5
		inc ClearCharSetLoop + 8
		inc ClearCharSetLoop + 11
		dey
		bne ClearCharSetLoopOuter

		lda #WAVYSCROLLER_Colours_Screen
		sta VIC_ScreenColour

		lda #$00
		sta VIC_SpriteEnable

		lda #(60 + BaseBank)
		sta VIC_DD02

		sei
		
		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(WAVYSCROLLER_Init) + "-$" + toHexString(EndWAVYSCROLLER_Init - 1) + " WAVYSCROLLER_Init"
EndWAVYSCROLLER_Init:

//; WAVYSCROLLER_End() -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(WAVYSCROLLER_End) + "-$" + toHexString(EndWAVYSCROLLER_End - 1) + " WAVYSCROLLER_End"
EndWAVYSCROLLER_End:

//; WAVYSCROLLER_IRQ_Function() -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_IRQ_Function:

		:IRQManager_BeginIRQ(1, 9)

		:Start_ShowTiming(1)

		.for(var nops = 0; nops < WAVYSCROLLER_NUM_NOPS_BEFORE_D011S; nops++)
		{
			nop
		}

	WAVYSCROLLLoop:
		.for(var loop = 0; loop < WAVYSCROLLER_NumLines; loop++)
		{
			.if((loop < 1) || (loop >= (WAVYSCROLLER_NumLines - 1)))
			{
				lda #$18 + ((WAVYSCROLLER_StartD011Offset + loop) & 7)
			}
			else
			{
				lda #$18 + ((WAVYSCROLLER_StartD011Offset + loop) & 7)
			}
			ldx #$ff
			ldy #$ff

			sta VIC_D011
			stx VIC_D016
			sty VIC_D018
			nop
			nop
			nop
			nop
		}
	WAVYSCROLLLoopEnd:

		inc FrameOf256
		bne WAVYSCROLLER_Not256
		inc Frame_256Counter
	WAVYSCROLLER_Not256:

		lda WAVYSCROLLER_ScrollPos
		sec
		sbc #$01
		bcs WAVYSCROLLER_ScrollPos_WithinRange

		lda WAVY_Char0
		sta WAVY_Char1
	WAVYSCROLLER_ScrollTextIndex:
		ldy #$00
		lda WAVY_SCROLLTEXT, y
		cmp #$ff
		bne WAVYSCROLLER_NotEndOfScrollText
		inc Signal_CurrentEffectIsFinished
		ldy #$00
		lda WAVY_SCROLLTEXT, y
	WAVYSCROLLER_NotEndOfScrollText:
		sta WAVY_Char0
		iny
		sty WAVYSCROLLER_ScrollTextIndex + 1

		lda #(4 * 8 - 1)
	WAVYSCROLLER_ScrollPos_WithinRange:
		sta WAVYSCROLLER_ScrollPos
		and #$03
		eor #$03
		sta FrameOf4

		lda FrameOf4
		cmp #$00
		bne WAVYSCROLLER_DontUpdateAThisFrame

		ldy WAVYSCROLLER_AValue
		lda WAVYSCROLLER_Plus1Modded, y
		sta WAVYSCROLLER_AValue
	WAVYSCROLLER_DontUpdateAThisFrame:

		jsr WAVYSCROLLER_UpdateSinus
		jsr WAVYSCROLLER_BlitNewChars
		jsr WAVYSCROLLER_UpdateScreen

	 	jsr Music_Play
		
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(1)

		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVYSCROLLER_IRQ_Function) + "-$" + toHexString(EndWAVYSCROLLER_IRQ_Function - 1) + " WAVYSCROLLER_IRQ_Function"
EndWAVYSCROLLER_IRQ_Function:
		
	.var WAVYSCROLL_LoopSize = (WAVYSCROLLLoopEnd - WAVYSCROLLLoop) / WAVYSCROLLER_NumLines

//; WAVYSCROLLER_UpdateSinus() -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_UpdateSinus:
		ldy #$00
		iny
		iny
		iny
		sty WAVYSCROLLER_UpdateSinus + 1

		ldx FrameOf4
		lda WAVYSCROLLER_Frame_D018, x

		.for(var loop = 0; loop < WAVYSCROLLER_NumLines; loop++)
		{
			.var AdjustedLoop = loop + WAVYSCROLLER_StartD011Offset
			.eval AdjustedLoop = 7 - (AdjustedLoop & 7)

			and #$8e
			ora WAVYSCROLLER_SinTab_CharAndPixelTable + (AdjustedLoop + (0 * 8)) * 256, y
			sta WAVYSCROLLLoop + WAVYSCROLL_LoopSize * loop + 5
			ldx WAVYSCROLLER_SinTab_CharAndPixelTable + (AdjustedLoop + (1 * 8)) * 256, y
			stx WAVYSCROLLLoop + WAVYSCROLL_LoopSize * loop + 3
			iny
		}

		rts

		.print "* $" + toHexString(WAVYSCROLLER_UpdateSinus) + "-$" + toHexString(EndWAVYSCROLLER_UpdateSinus - 1) + " WAVYSCROLLER_UpdateSinus"

EndWAVYSCROLLER_UpdateSinus:

//; WAVYSCROLLER_UpdateScreen() -------------------------------------------------------------------------------------------------------
WAVYSCROLLER_UpdateScreen:

		ldy FrameOf4
		lda WAVYSCROLLER_AValue

		.for(var YVal = 0; YVal < WAVYSCROLLER_YCHARLEN; YVal++)
		{
			tax
			lda WAVYSCROLLER_Minus1Modded, x

			ldy #$00

			.label WAVYSCROLLER_LoopPoint = *

			.for(var ScreenIndex = 0; ScreenIndex < 4; ScreenIndex++)
			{
				sta ScreenAddress0 + (ScreenIndex * 1024) + WAVYSCROLLER_XOffset + ((WAVYSCROLLER_ENDY - 1) - (YVal + WAVYSCROLLER_STARTY)) + ((YVal + WAVYSCROLLER_STARTY) * 40) + ScreenIndex, y
				sta ScreenAddress0 + (ScreenIndex * 1024) + WAVYSCROLLER_XOffset + ((WAVYSCROLLER_ENDY - 1) - (YVal + WAVYSCROLLER_STARTY)) + ((YVal + WAVYSCROLLER_STARTY) * 40) + ScreenIndex + 89, y
			}

			eor WAVYSCROLLER_XEOR, y
			iny
			cpy #$08
			bne WAVYSCROLLER_LoopPoint

/*			.if(YVal != WAVYSCROLLER_YCHARLEN - 1)
			{
				tax
				lda WAVYSCROLLER_Minus1Modded, x
			}*/
		}
		rts

		.print "* $" + toHexString(WAVYSCROLLER_UpdateScreen) + "-$" + toHexString(EndWAVYSCROLLER_UpdateScreen - 1) + " WAVYSCROLLER_UpdateScreen"

EndWAVYSCROLLER_UpdateScreen:

WAVYSCROLLER_BlitNewChars:

		ldy WAVYSCROLLER_ScrollPos

		lda WAVYSCROLLER_Blit_JMPs_Lo, y
		sta WAVYSCROLLER_BlitJMP + 1
		lda WAVYSCROLLER_Blit_JMPs_Hi, y
		sta WAVYSCROLLER_BlitJMP + 2

		lda WAVYSCROLLER_AValue
		asl
		asl
		asl
		tay

		lda WAVY_Char0
		sta $48
		lda WAVY_Char1
		sta $49

	WAVYSCROLLER_BlitJMP:
		jsr $ffff

		rts
