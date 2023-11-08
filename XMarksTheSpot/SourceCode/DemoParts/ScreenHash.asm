//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = ScreenHash_BASE "Screen Hash"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; - $3000-$33ff SinTable
//; - $3400-$53ff Code & Data
//; ---- $7400-77ff Screen
//; ---- $7800-7fff Charset
//; - $c000-c5ff SinTables
//; - $e000-ff00 Code+Data

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp SH_Init							//; Init
		.byte $60, $00, $00					//; MainThreadFunc
		jmp SH_End							//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------

	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)

	.var CharBank = 7 //; Bank+[3800,3fff]

	.var ScreenBank0 = 13 //; Bank+[3400,37ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))

	.var SinTable_BASE = $c000
	.var SinTable0 = SinTable_BASE + $000
	.var SinTable1 = SinTable_BASE + $200
	.var SinTable2 = SinTable_BASE + $400
	
	.var SH_XOffset = 0
	.var SH_YOffset = 0
	.var SH_Offset = SH_XOffset + (SH_YOffset * 40)
	.var SH_Width = 40
	.var SH_Height = 25
	.var SH_NumColourFadeLines = SH_Width / 2

//; SH_LocalData -------------------------------------------------------------------------------------------------------
SH_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$fe,			<SH_IRQ_VBlank,				>SH_IRQ_VBlank
		.byte	$ff

	.var SH_Num_Effects = 6
	.align 4
	SH_XAdd_Table:
		.byte $05, $f8, $fd, $05, $04, $fe
	SH_YAdd_Table:
		.byte $03, $fa, $f9, $06, $05, $04
	SH_XAdd2_Table:
		.byte $04, $fb, $06, $fd, $fb, $06

	SH_D800_Table1:
		.byte $0a, $09, $0e, $0d, $0a, $0e
	SH_D800_Table2:
		.byte $06, $06, $05, $02, $06, $05
	SH_D021_Table:
		.byte $00, $00, $00, $00, $00, $00
	SH_D022_Table:
		.byte $0a, $04, $04, $0e, $0a, $04
	SH_D023_Table:
		.byte $07, $0e, $03, $01, $07, $03
 
	SH_EyeMode:
		.byte $00
	SH_EyeOpenness:
		.byte $00

	SH_20PlusX:
		.byte (20 +  0), (20 +  1), (20 +  2), (20 +  3), (20 +  4)
		.byte (20 +  5), (20 +  6), (20 +  7), (20 +  8), (20 +  9)
		.byte (20 + 10), (20 + 11), (20 + 12), (20 + 13), (20 + 14)
		.byte (20 + 15), (20 + 16), (20 + 17), (20 + 18), (20 + 19)
	SH_19MinusX:
		.byte (19 -  0), (19 -  1), (19 -  2), (19 -  3), (19 -  4)
		.byte (19 -  5), (19 -  6), (19 -  7), (19 -  8), (19 -  9)
		.byte (19 - 10), (19 - 11), (19 - 12), (19 - 13), (19 - 14)
		.byte (19 - 15), (19 - 16), (19 - 17), (19 - 18), (19 - 19)

	.print "* $" + toHexString(SH_LocalData) + "-$" + toHexString(EndSH_LocalData - 1) + " SH_LocalData"
EndSH_LocalData:
	
//; SH_Init() -------------------------------------------------------------------------------------------------------
SH_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		ldx #$00
		lda #$00
	ClearScreenColoursLoop:
		sta ScreenAddress0 + (0 * 256), x
		sta ScreenAddress0 + (1 * 256), x
		sta ScreenAddress0 + (2 * 256), x
		sta ScreenAddress0 + (3 * 256), x
		sta VIC_ColourMemory + (0 * 256), x
		sta VIC_ColourMemory + (1 * 256), x
		sta VIC_ColourMemory + (2 * 256), x
		sta VIC_ColourMemory + (3 * 256), x
		inx
		bne ClearScreenColoursLoop
		
		jsr SH_SetEffect

		lda #$01
		sta SH_EyeMode	//; make the eye open

		lda #$00
		sta SH_EyeOpenness

		lda #$ff
		sta $bfff

		lda #((ScreenBank0 * 16) + (CharBank * 2))
 		sta VIC_D018

		lda #$18
 		sta VIC_D016

 		lda #$00
 		sta VIC_SpriteEnable

		lda #DD02Value
		sta VIC_DD02

		:IRQ_WaitForVBlank()

		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(SH_Init) + "-$" + toHexString(EndSH_Init - 1) + " SH_Init"
EndSH_Init:

//; SH_End() -------------------------------------------------------------------------------------------------------
SH_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(SH_End) + "-$" + toHexString(EndSH_End - 1) + " SH_End"
EndSH_End:

//; SH_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SH_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

		lda #$1b
		sta VIC_D011

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:
		lda FrameOf256
		and #$03
		sta FrameOf4
		and #$01
		sta FrameOf2

		ldy SH_EyeOpenness

		ldx SH_EyeMode
		cpx #$00
		beq SH_JustDrawTheEye
		cpx #$02
		bne SH_DontSetClearColour
		
		lda #$00
		ldx #$00
		jmp SH_SetColoursLines
	SH_DontSetClearColour:

	SH_D800_Value1:
		lda #$00
	SH_D800_Value2:
		ldx #$00

	SH_SetColoursLines:
		jsr SH_FillColourLines

		lda FrameOf2
		and #$01
		bne SH_JustDrawTheEye

		lda SH_EyeMode
		cmp #$01
		bne SH_CloseTheEye

	SH_OpenTheEye:
		inc SH_EyeOpenness
		lda SH_EyeOpenness
		cmp #SH_NumColourFadeLines
		bne SH_JustDrawTheEye
		lda #$00
		sta SH_EyeMode
		jmp SH_JustDrawTheEye
	
	SH_CloseTheEye:
		dec SH_EyeOpenness
		bpl SH_JustDrawTheEye
		lda #$00
		sta SH_EyeMode
		
	SH_JustDrawTheEye:

	SH_XIndex:
		ldx #$00
	SH_YIndex:
		ldy #$00

		.for(var YPos = 0; YPos < SH_Height; YPos++)
		{
			.var YMoved = YPos + 0.5 - (SH_Height / 2)
			.for(var XPos = 0; XPos < SH_Width; XPos++)
			{
				.var XMoved = XPos + 0.5 - (SH_Width / 2)
				.var XYMod = sqrt(XMoved * XMoved * 0.8 + YMoved * YMoved * 1.4)
				
				.var DistFromX1 = abs((XPos - 20) - (YPos - 12))
				.var DistFromX2 = abs((XPos - 20) + (YPos - 12))

				.if((DistFromX1 <= 6) || (DistFromX2 <= 6))
				{
					lda SinTable0 + ((XYMod * 17) & 255), x
					eor SinTable1 + ((XYMod * 21) & 255), y
					sta ScreenAddress0 + SH_Offset + XPos + YPos * 40
				}
			}
		}
		
	SH_XIndex2:
		ldx #$00

		.for(var YPos = 0; YPos < SH_Height; YPos++)
		{
			.var YMoved = YPos + 0.5 - (SH_Height / 2)
			.for(var XPos = 0; XPos < SH_Width; XPos++)
			{
				.var XMoved = XPos + 0.5 - (SH_Width / 2)
				.var XYMod = sqrt(XMoved * XMoved * 0.8 + YMoved * YMoved * 1.4)
				
				.var DistFromX1 = abs((XPos - 20) - (YPos - 12))
				.var DistFromX2 = abs((XPos - 20) + (YPos - 12))

				.if((DistFromX1 > 8) && (DistFromX2 > 8))
				{
					lda SinTable2 + ((XYMod * 19) & 255), x
					sta ScreenAddress0 + SH_Offset + XPos + YPos * 40
				}
			}
		}

		jsr SH_Update

		jsr Music_Play

		inc Signal_VBlank

		:Stop_ShowTiming(0)

		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(SH_IRQ_VBlank) + "-$" + toHexString(EndSH_IRQ_VBlank - 1) + " SH_IRQ_VBlank"
EndSH_IRQ_VBlank:
		
//; SH_Update() -------------------------------------------------------------------------------------------------------
SH_Update:

		:Start_ShowTiming(0)

	SH_XLookUp:
		ldx #$00
	SH_YLookup:
		ldy #$00
		
		lda SH_XIndex + 1
		clc
	SH_XAdd:
		adc #$00
		sta SH_XIndex + 1
		lda SH_YIndex + 1
		clc
	SH_YAdd:
		adc #$00
		sta SH_YIndex + 1

		lda SH_XIndex2 + 1
		clc
	SH_XAdd2:
		adc #$00
		sta SH_XIndex2 + 1

		lda Frame_256Counter
		cmp #$01
		beq SH_NextEffect

		lda FrameOf256
		cmp #$c0
		bne SH_Return
		
		lda #$02
		sta SH_EyeMode	//; make the eye close
		lda #(SH_NumColourFadeLines - 1)
		sta SH_EyeOpenness
		jmp SH_Return

	SH_NextEffect:
		jsr SH_SetEffect
		lda #$01
		sta SH_EyeMode	//; make the eye open
		lda #$00
		sta SH_EyeOpenness
		
		lda #$00
		sta FrameOf256
		sta Frame_256Counter

	SH_Return:
	SH_FadeChars:
		lda #$00
		beq SH_Return2

	SH_FadePosition:
		ldx #$ff
		dex
		stx SH_FadePosition + 1
		cpx #$ff
		bne SH_Return2

		inc Signal_CurrentEffectIsFinished

	SH_Return2:
		:Stop_ShowTiming(0)

		rts

		.print "* $" + toHexString(SH_Update) + "-$" + toHexString(EndSH_Update - 1) + " SH_Update"
EndSH_Update:

.macro SH_FillColourLine(XPos)
{
		.var XPos0 = 19 - XPos
		.var XPos1 = 20 + XPos

		.for(var YPos = 0; YPos < SH_Height; YPos++)
		{
			.var DistFromX1_0 = abs((XPos0 - 20) - (YPos - 12))
			.var DistFromX2_0 = abs((XPos0 - 20) + (YPos - 12))
			.var DistFromX1_1 = abs((XPos1 - 20) - (YPos - 12))
			.var DistFromX2_1 = abs((XPos1 - 20) + (YPos - 12))

			.if((DistFromX1_0 <= 6) || (DistFromX2_0 <= 6))
			{
				sta VIC_ColourMemory + YPos * 40 + XPos0
			}
			else
			{
				.if((DistFromX1_0 > 7) && (DistFromX2_0 > 8))
				{
					stx VIC_ColourMemory + YPos * 40 + XPos0
				}
				else
				{
					sty VIC_ColourMemory + YPos * 40 + XPos0
				}
			}

			.if((DistFromX1_1 <= 6) || (DistFromX2_1 <= 6))
			{
				sta VIC_ColourMemory + YPos * 40 + XPos1
			}
			else
			{
				.if((DistFromX1_1 > 7) && (DistFromX2_1 > 8))
				{
					stx VIC_ColourMemory + YPos * 40 + XPos1
				}
				else
				{
					sty VIC_ColourMemory + YPos * 40 + XPos1
				}
			}
		}
		rts
}

SH_FillColourLineJumpTableLo:
	.byte <SH_FillColourLine0,  <SH_FillColourLine1,  <SH_FillColourLine2,  <SH_FillColourLine3,  <SH_FillColourLine4
	.byte <SH_FillColourLine5,  <SH_FillColourLine6,  <SH_FillColourLine7,  <SH_FillColourLine8,  <SH_FillColourLine9
	.byte <SH_FillColourLine10, <SH_FillColourLine11, <SH_FillColourLine12, <SH_FillColourLine13, <SH_FillColourLine14
	.byte <SH_FillColourLine15, <SH_FillColourLine16, <SH_FillColourLine17, <SH_FillColourLine18, <SH_FillColourLine19
SH_FillColourLineJumpTableHi:
	.byte >SH_FillColourLine0,  >SH_FillColourLine1,  >SH_FillColourLine2,  >SH_FillColourLine3,  >SH_FillColourLine4
	.byte >SH_FillColourLine5,  >SH_FillColourLine6,  >SH_FillColourLine7,  >SH_FillColourLine8,  >SH_FillColourLine9
	.byte >SH_FillColourLine10, >SH_FillColourLine11, >SH_FillColourLine12, >SH_FillColourLine13, >SH_FillColourLine14
	.byte >SH_FillColourLine15, >SH_FillColourLine16, >SH_FillColourLine17, >SH_FillColourLine18, >SH_FillColourLine19

SH_FillColourLine0:
	SH_FillColourLine(0)
SH_FillColourLine1:
	SH_FillColourLine(1)
SH_FillColourLine2:
	SH_FillColourLine(2)
SH_FillColourLine3:
	SH_FillColourLine(3)
SH_FillColourLine4:
	SH_FillColourLine(4)
SH_FillColourLine5:
	SH_FillColourLine(5)
SH_FillColourLine6:
	SH_FillColourLine(6)
SH_FillColourLine7:
	SH_FillColourLine(7)
SH_FillColourLine8:
	SH_FillColourLine(8)
SH_FillColourLine9:
	SH_FillColourLine(9)
SH_FillColourLine10:
	SH_FillColourLine(10)
SH_FillColourLine11:
	SH_FillColourLine(11)
SH_FillColourLine12:
	SH_FillColourLine(12)
SH_FillColourLine13:
	SH_FillColourLine(13)
SH_FillColourLine14:
	SH_FillColourLine(14)
SH_FillColourLine15:
	SH_FillColourLine(15)
SH_FillColourLine16:
	SH_FillColourLine(16)
SH_FillColourLine17:
	SH_FillColourLine(17)
SH_FillColourLine18:
	SH_FillColourLine(18)
SH_FillColourLine19:
	SH_FillColourLine(19)

SH_FillColourLines:
		sta SH_ReloadColourA + 1

		lda SH_FillColourLineJumpTableLo, y
		sta SH_FillColourJump + 1
		lda SH_FillColourLineJumpTableHi, y
		sta SH_FillColourJump + 2

	SH_ReloadColourA:
		lda #$ff

		ldy #$00 //; "shadow"

	SH_FillColourJump:
		jmp $ffff
		
//; SH_SetEffect() -------------------------------------------------------------------------------------------------------
SH_SetEffect:
	SH_EffectNum:
		lda #$00
		and #$03
		tay
		lda SH_XAdd_Table, y
		sta SH_XAdd + 1
		lda SH_YAdd_Table, y
		sta SH_YAdd + 1
		lda SH_XAdd2_Table, y
		sta SH_XAdd2 + 1
		lda SH_D021_Table, y
		sta VIC_ScreenColour
		lda SH_D022_Table, y
		sta VIC_ExtraBackgroundColour0
		lda SH_D023_Table, y
		sta VIC_ExtraBackgroundColour1
		lda SH_D800_Table1, y
		sta SH_D800_Value1 + 1
		lda SH_D800_Table2, y
		sta SH_D800_Value2 + 1

		lda SH_EffectNum + 1
		clc
		adc #$01
		cmp #SH_Num_Effects
		bne SH_NotLastEffect

		ldx #$01
		stx SH_FadeChars + 1

		lda #$00
	SH_NotLastEffect:
		sta SH_EffectNum + 1
		rts

		.print "* $" + toHexString(SH_SetEffect) + "-$" + toHexString(EndSH_SetEffect - 1) + " SH_SetEffect"
EndSH_SetEffect:
