//; (c) 2018, Raistlin / Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = WavySnake_BASE "Wavy Snake"

	jmp DoTheWavySnake

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; ---- $4000-5fff Screens (1st Bank)
//; - $6000-7fff Charset (1st Bank)
//; ---- $8000-9fff Screens (2nd Bank)
//; ---- $a000-bfff Charset (2nd Bank)
//; - $c000-cfff SinTables
//; - $e000-ff00 Code+Data

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var CharBankA = 4 //; 4=Bank+[2000,27ff]
	.var CharBankB = 5 //; 5=Bank+[2800,2fff]
	.var CharBankC = 6 //; 6=Bank+[3000,37ff]
	.var CharBankD = 7 //; 7=Bank+[3800,3fff]
	.var ScreenBank = 0 //; 0=Bank+[0000,03ff], ..., 7=Bank+[1c00,1fff]

	.var BaseBankAddress0 = (BaseBank0 * $4000)
	.var ScreenAddress0 = (BaseBankAddress0 + (ScreenBank * 1024))
	.var CharAddress0A = (BaseBankAddress0 + (CharBankA * $800))
	.var CharAddress0B = (BaseBankAddress0 + (CharBankB * $800))
	.var CharAddress0C = (BaseBankAddress0 + (CharBankC * $800))
	.var CharAddress0D = (BaseBankAddress0 + (CharBankD * $800))

	.var BaseBankAddress1 = (BaseBank1 * $4000)
	.var ScreenAddress1 = (BaseBankAddress1 + (ScreenBank * 1024))
	.var CharAddress1A = (BaseBankAddress1 + (CharBankA * $800))
	.var CharAddress1B = (BaseBankAddress1 + (CharBankB * $800))
	.var CharAddress1C = (BaseBankAddress1 + (CharBankC * $800))
	.var CharAddress1D = (BaseBankAddress1 + (CharBankD * $800))

	.var WAVYSNAKE_SinTab_CharAndPixelTable = $c000
	.var WAVYSNAKE_StartD011Offset = 2
	.var WAVYSNAKE_XOffset = 6
	.var WAVYSNAKE_STARTY = 3
	.var WAVYSNAKE_YLEN = 20
	.var WAVYSNAKE_ENDY = WAVYSNAKE_STARTY + WAVYSNAKE_YLEN
	.var WAVYSNAKE_YRASTER = $30 + (WAVYSNAKE_STARTY * 8) + (WAVYSNAKE_StartD011Offset) - 1
	.var WAVYSNAKE_FINALD011 = $18 + ((WAVYSNAKE_StartD011Offset + 1) & 7)

	.var WAVYSNAKE_Colours_Screen = 0
	.var WAVYSNAKE_Colours_D800 = (1 + 8)

	.var WAVYSNAKE_NumLines = (WAVYSNAKE_YLEN * 8) + 1

	.var WAVYSNAKE_NUM_NOPS_BEFORE_D011S = 3
	.var WAVYSNAKE_NUM_NOPS_BETWEEN_D011S = 4

//; WAVYSNAKE_LocalData -------------------------------------------------------------------------------------------------------
WAVYSNAKE_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,				LoPtr,						HiPtr
		.byte	$00,			$f6,				<WAVYSNAKE_IRQ_VBlank,		>WAVYSNAKE_IRQ_VBlank
		.byte	$00,			WAVYSNAKE_YRASTER,	<WAVYSNAKE_IRQ_Function,	>WAVYSNAKE_IRQ_Function
		.byte	$ff

	.var WAVYSNAKE_NumColourSchemes = 3
	WAVYSNAKE_SnakeColours:
		.byte $0b, $0c
		.byte $06, $0e
		.byte $09, $0a

	.var WAVYSNAKE_NUM_CHARS_IN_CHARSET = 85
	.var WAVYSNAKE_CHAR_START = 0

	WAVYSNAKE_Mul8_ModLEN:
		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255															//; Empty space
		.byte (8 *  0), (8 *  1), (8 *  2), (8 *  3), (8 *  4), (8 *  5), (8 *  6), (8 *  7)	//; Tail
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 * 16), (8 * 17), (8 * 18), (8 * 19), (8 * 20), (8 * 21), (8 * 22), (8 * 23)	//; Head
		.byte (8 * 24), (8 * 25), (8 * 26), (8 * 27), (8 * 28), (8 * 29), (8 * 30), (8 * 31)	//; Head

		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255, 255, 255, 255											//; Empty space
		.byte 255, 255, 255, 255, 255															//; Empty space
		.byte (8 *  0), (8 *  1), (8 *  2), (8 *  3), (8 *  4), (8 *  5), (8 *  6), (8 *  7)	//; Tail
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 *  8), (8 *  9), (8 * 10), (8 * 11), (8 * 12), (8 * 13), (8 * 14), (8 * 15)	//; Body
		.byte (8 * 16), (8 * 17), (8 * 18), (8 * 19), (8 * 20), (8 * 21), (8 * 22), (8 * 23)	//; Head
		.byte (8 * 24), (8 * 25), (8 * 26), (8 * 27), (8 * 28), (8 * 29), (8 * 30), (8 * 31)	//; Head

	WAVYSNAKE_Frame_DD02:
		.byte BaseBank1 + 60
		.byte BaseBank1 + 60
		.byte BaseBank1 + 60
		.byte BaseBank1 + 60
		.byte BaseBank0 + 60
		.byte BaseBank0 + 60
		.byte BaseBank0 + 60
		.byte BaseBank0 + 60

	WAVYSNAKE_Frame_D018:
		.byte ((ScreenBank * 16) + (CharBankA * 2))
		.byte ((ScreenBank * 16) + (CharBankB * 2))
		.byte ((ScreenBank * 16) + (CharBankC * 2))
		.byte ((ScreenBank * 16) + (CharBankD * 2))

	.print "* $" + toHexString(WAVYSNAKE_LocalData) + "-$" + toHexString(EndWAVYSNAKE_LocalData - 1) + " WAVYSNAKE_LocalData"
EndWAVYSNAKE_LocalData:

//; WAVYSNAKE_Init() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_Init:
		clc
		asl
		sta WAVYSNAKE_Init_SetSnakeColours + 1

		:ClearGlobalVariables() //; nb. corrupts A and X

		:IRQ_WaitForVBlank()

	WAVYSNAKE_Init_SetSnakeColours:
		ldy #$00
		lda WAVYSNAKE_SnakeColours + 0, y
		sta VIC_ExtraBackgroundColour0
		lda WAVYSNAKE_SnakeColours + 1, y
		sta VIC_ExtraBackgroundColour1

		ldx #$00
		ldy #(4 * 8)
		lda #$ff //; Clear Char
	WAVYSNAKE_ClearScreenLoop:
		sta ScreenAddress0, x
		sta ScreenAddress1, x
		inx
		bne WAVYSNAKE_ClearScreenLoop
		inc WAVYSNAKE_ClearScreenLoop + 2
		inc WAVYSNAKE_ClearScreenLoop + 5
		dey
		bne WAVYSNAKE_ClearScreenLoop

		ldx #$00
		lda #WAVYSNAKE_Colours_D800
	WAVYSNAKE_ClearColourLoop:
		sta VIC_ColourMemory, x
		sta VIC_ColourMemory + (1 * 256), x
		sta VIC_ColourMemory + (2 * 256), x
		sta VIC_ColourMemory + (3 * 256), x
		inx
		bne WAVYSNAKE_ClearColourLoop

		ldx #$20
		ldy #$00
	WAVYSNAKE_CopyCharBufferTo2nd:
	WAVYSNAKE_CCB_LDA:
		lda CharAddress0A, y
	WAVYSNAKE_CCB_STA:
		sta CharAddress1A, y
		iny
		bne WAVYSNAKE_CopyCharBufferTo2nd
		inc WAVYSNAKE_CCB_LDA + 2
		inc WAVYSNAKE_CCB_STA + 2
		dex
		bne WAVYSNAKE_CopyCharBufferTo2nd

		lda #WAVYSNAKE_Colours_Screen
		sta VIC_ScreenColour

		lda #(60 + BaseBank0)
		sta VIC_DD02
		
		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta VIC_SpriteEnable
		sta FrameOf256

		cli
		rts

		.print "* $" + toHexString(WAVYSNAKE_Init) + "-$" + toHexString(EndWAVYSNAKE_Init - 1) + " WAVYSNAKE_Init"
EndWAVYSNAKE_Init:

//; WAVYSNAKE_Exit() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_Exit:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(WAVYSNAKE_Exit) + "-$" + toHexString(EndWAVYSNAKE_Exit - 1) + " WAVYSNAKE_Exit"
EndWAVYSNAKE_Exit:

//; WAVYSNAKE_IRQ_Function() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_IRQ_Function:

		:IRQManager_BeginIRQ(1, 10)

		:Start_ShowTiming(0)

		lda Signal_CurrentEffectIsFinished
		beq WAVYSNAKE_DoTechTech
		jmp WAVYSNAKE_SkipWholeTechTech

	WAVYSNAKE_DoTechTech:
		.for(var nops = 0; nops < WAVYSNAKE_NUM_NOPS_BEFORE_D011S; nops++)
		{
			nop
		}

	WAVYSNAKE_MegaLoop:
		.for(var loop = 0; loop < WAVYSNAKE_NumLines; loop++)
		{
			lda #$18 + ((WAVYSNAKE_StartD011Offset + loop) & 7)		//; 2 (2)
			ldx #$ff											//; 2 (4)
			ldy #$ff											//; 2 (6)
			sta VIC_D011										//; 3 (9)
			stx VIC_D016										//; 3 (12)
			sty VIC_D018										//; 3 (15)
			.for(var nops2 = 0; nops2 < WAVYSNAKE_NUM_NOPS_BETWEEN_D011S; nops2++)
			{
				nop
			}
		}

		lda #WAVYSNAKE_FINALD011
		sta VIC_D011

	WAVYSNAKE_SkipWholeTechTech:
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVYSNAKE_IRQ_Function) + "-$" + toHexString(EndWAVYSNAKE_IRQ_Function - 1) + " WAVYSNAKE_IRQ_Function"
EndWAVYSNAKE_IRQ_Function:
		
//; WAVYSNAKE_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 10)

		:Start_ShowTiming(0)

		inc FrameOf256
		lda FrameOf256
		and #$07
		sta FrameOf8
		and #$03
		sta FrameOf4

		jsr WAVYSNAKE_UpdateAValue
		jsr WAVYSNAKE_UpdateScreen
		jsr WAVYSNAKE_SinusUpdate

		ldx FrameOf8
		lda WAVYSNAKE_Frame_DD02, x
		sta VIC_DD02

	 	jsr Music_Play
		
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVYSNAKE_IRQ_VBlank) + "-$" + toHexString(EndWAVYSNAKE_IRQ_VBlank - 1) + " WAVYSNAKE_IRQ_VBlank"
EndWAVYSNAKE_IRQ_VBlank:

//; WAVYSNAKE_SinusUpdate() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_SinusUpdate:
	WAVYSNAKE_SinusValue:
		lda #$00
		tay
		clc
		adc #$03
		and #$7f
		sta WAVYSNAKE_SinusValue + 1

		.var WriteOffset = 0
		.var SinTableReadOffset = 0

		ldx FrameOf4
		.for(var loop = 0; loop < WAVYSNAKE_NumLines; loop++)
		{
			.var AdjustedLoop = loop & 7
			.if(bLeftToRightSnake == 0)
			{
				.eval AdjustedLoop = 7 - AdjustedLoop
			}
			lda WAVYSNAKE_SinTab_CharAndPixelTable + (256 * AdjustedLoop) + (1 * 256 * 8) + SinTableReadOffset, y
			sta WAVYSNAKE_MegaLoop + WriteOffset + 3

			lda WAVYSNAKE_SinTab_CharAndPixelTable + (256 * AdjustedLoop) + (0 * 256 * 8) + SinTableReadOffset, y
			ora WAVYSNAKE_Frame_D018, x
			sta WAVYSNAKE_MegaLoop + WriteOffset + 5

			.eval WriteOffset += (WAVYSNAKE_NUM_NOPS_BETWEEN_D011S + 15)
			.eval SinTableReadOffset = (SinTableReadOffset + 1)&127
		}
		rts

		.print "* $" + toHexString(WAVYSNAKE_SinusUpdate) + "-$" + toHexString(EndWAVYSNAKE_SinusUpdate - 1) + " WAVYSNAKE_SinusUpdate"
EndWAVYSNAKE_SinusUpdate:

WAVYSNAKE_UpdateScreenTableLo:
	.byte <WAVYSNAKE_UpdateScreen0A
	.byte <WAVYSNAKE_UpdateScreen1A
	.byte <WAVYSNAKE_UpdateScreen2A
	.byte <WAVYSNAKE_UpdateScreen3A
	.byte <WAVYSNAKE_UpdateScreen0B
	.byte <WAVYSNAKE_UpdateScreen1B
	.byte <WAVYSNAKE_UpdateScreen2B
	.byte <WAVYSNAKE_UpdateScreen3B
WAVYSNAKE_UpdateScreenTableHi:
	.byte >WAVYSNAKE_UpdateScreen0A
	.byte >WAVYSNAKE_UpdateScreen1A
	.byte >WAVYSNAKE_UpdateScreen2A
	.byte >WAVYSNAKE_UpdateScreen3A
	.byte >WAVYSNAKE_UpdateScreen0B
	.byte >WAVYSNAKE_UpdateScreen1B
	.byte >WAVYSNAKE_UpdateScreen2B
	.byte >WAVYSNAKE_UpdateScreen3B

.macro WAVYSNAKE_ScreenUpdate(ScreenAddress, ByteOffset)
{
	.for(var YVal = 0; YVal < WAVYSNAKE_YLEN; YVal++)
	{
		.var AdjustedYVal = YVal + WAVYSNAKE_STARTY
		.var AdditionalXValue = AdjustedYVal
		.if(bLeftToRightSnake == 0)
		{
			.eval AdditionalXValue = (WAVYSNAKE_ENDY - 1) - AdjustedYVal
		}
		txa
		ora WAVYSNAKE_Mul8_ModLEN + YVal, y
		sta ScreenAddress + (ByteOffset + 0) * 1024 + WAVYSNAKE_XOffset + AdditionalXValue + AdjustedYVal * 40 + (ByteOffset + 0), x
		sta ScreenAddress + (ByteOffset + 1) * 1024 + WAVYSNAKE_XOffset + AdditionalXValue + AdjustedYVal * 40 + (ByteOffset + 1), x
	}
}


//; WAVYSNAKE_UpdateScreen() -------------------------------------------------------------------------------------------------------
WAVYSNAKE_UpdateScreen:
		ldx FrameOf8
		lda WAVYSNAKE_UpdateScreenTableLo, x
		sta WAVYSNAKE_UpdateScreen_Jump + 1
		lda WAVYSNAKE_UpdateScreenTableHi, x
		sta WAVYSNAKE_UpdateScreen_Jump + 2
	WAVYSNAKE_UpdateScreen_Jump:
		jmp $ffff

WAVYSNAKE_UpdateAValue:
		lda FrameOf4
		cmp #$03
		bne WAVYSNAKE_DontUpdateAThisFrame

		ldy WAVYSNAKE_AValue + 1
		dey
		bpl WAVYSNAKE_AValueWithinRangeB

		ldy #(WAVYSNAKE_NUM_CHARS_IN_CHARSET - 1)
	WAVYSNAKE_AValueWithinRangeB:
		sty WAVYSNAKE_AValue + 1

		cpy #WAVYSNAKE_CHAR_START
		bne WAVYSNAKE_DontUpdateAThisFrame
		inc Signal_CurrentEffectIsFinished

	WAVYSNAKE_DontUpdateAThisFrame:
		rts

	WAVYSNAKE_UpdateScreen0A:

	WAVYSNAKE_AValue:
		ldy #WAVYSNAKE_CHAR_START
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop0A:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress0, 0)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen0A
		jmp WAVYSNAKE_UpdateScreen_Loop0A
	WAVYSNAKE_FinishedFillScreen0A:
		rts

	WAVYSNAKE_UpdateScreen1A:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop1A:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress0, 2)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen1A
		jmp WAVYSNAKE_UpdateScreen_Loop1A
	WAVYSNAKE_FinishedFillScreen1A:
		rts

	WAVYSNAKE_UpdateScreen2A:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop2A:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress0, 4)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen2A
		jmp WAVYSNAKE_UpdateScreen_Loop2A
	WAVYSNAKE_FinishedFillScreen2A:
		rts

	WAVYSNAKE_UpdateScreen3A:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop3A:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress0, 6)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen3A
		jmp WAVYSNAKE_UpdateScreen_Loop3A
	WAVYSNAKE_FinishedFillScreen3A:

		rts

	WAVYSNAKE_UpdateScreen0B:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop0B:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress1, 0)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen0B
		jmp WAVYSNAKE_UpdateScreen_Loop0B
	WAVYSNAKE_FinishedFillScreen0B:
		rts

	WAVYSNAKE_UpdateScreen1B:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop1B:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress1, 2)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen1B
		jmp WAVYSNAKE_UpdateScreen_Loop1B
	WAVYSNAKE_FinishedFillScreen1B:
		rts

	WAVYSNAKE_UpdateScreen2B:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop2B:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress1, 4)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen2B
		jmp WAVYSNAKE_UpdateScreen_Loop2B
	WAVYSNAKE_FinishedFillScreen2B:
		rts

	WAVYSNAKE_UpdateScreen3B:
		ldy WAVYSNAKE_AValue + 1
		ldx #$00
	WAVYSNAKE_UpdateScreen_Loop3B:
		:WAVYSNAKE_ScreenUpdate(ScreenAddress1, 6)
		inx
		cpx #$08
		beq WAVYSNAKE_FinishedFillScreen3B
		jmp WAVYSNAKE_UpdateScreen_Loop3B
	WAVYSNAKE_FinishedFillScreen3B:

		rts

		.print "* $" + toHexString(WAVYSNAKE_UpdateScreen) + "-$" + toHexString(EndWAVYSNAKE_UpdateScreen - 1) + " WAVYSNAKE_UpdateScreen"
EndWAVYSNAKE_UpdateScreen:

//; DoTheWavySnake() -------------------------------------------------------------------------------------------------------
DoTheWavySnake:
		sta WhichSnake + 1

	WhichSnake:
		lda #$00
		jsr WAVYSNAKE_Init

	WAVYSNAKE_MainLoop:
		lda Signal_CurrentEffectIsFinished
		beq WAVYSNAKE_MainLoop

		jmp WAVYSNAKE_Exit

		.print "* $" + toHexString(DoTheWavySnake) + "-$" + toHexString(EndDoTheWavySnake - 1) + " DoTheWavySnake"
EndDoTheWavySnake:

