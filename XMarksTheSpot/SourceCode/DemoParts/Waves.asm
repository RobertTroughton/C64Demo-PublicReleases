//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = Waves_BASE "Waves"

		jmp DoTheWavesPart

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music
//; - $3000-33ff SinTables
//; - $3e00-3fff SourceSpriteDataToClip
//; - $4000-5fff Charset
//; ---- $6000-67ff Screen
//; - $6800-7bff Sprite Data
//; - $8000-91ff Sprite Clip Code
//; - $b000-bfff ClipData
//; - $c000-caff Sprite Sintables
//; - $e000-feff Code & Data

//; Local Defines -------------------------------------------------------------------------------------------------------
.import source "Waves-Defines.asm"

	.var D016Value = List().add(WAVES_D016Value0, WAVES_D016Value1, WAVES_D016Value2, WAVES_D016Value3, WAVES_D016Value4, WAVES_D016Value5, WAVES_D016Value6, WAVES_D016Value7, WAVES_D016Value8, WAVES_D016Value9, WAVES_D016Value10, WAVES_D016Value11)
	.var D018Value = List().add(WAVES_D018Value0, WAVES_D018Value1, WAVES_D018Value2, WAVES_D018Value3, WAVES_D018Value4, WAVES_D018Value5, WAVES_D018Value6, WAVES_D018Value7, WAVES_D018Value8, WAVES_D018Value9, WAVES_D018Value10, WAVES_D018Value11)
	.var DrawIndexValue = List().add(WAVES_DrawIndexValue0, WAVES_DrawIndexValue1, WAVES_DrawIndexValue2, WAVES_DrawIndexValue3, WAVES_DrawIndexValue4, WAVES_DrawIndexValue5, WAVES_DrawIndexValue6, WAVES_DrawIndexValue7, WAVES_DrawIndexValue8, WAVES_DrawIndexValue9, WAVES_DrawIndexValue10, WAVES_DrawIndexValue11)

//; WAVES_LocalData -------------------------------------------------------------------------------------------------------
WAVES_LocalData:
	.var WAVES_Sprite_Y0 = $42
	.var WAVES_Sprite_Y1 = WAVES_Sprite_Y0 + (21 * 1)	//; $57
	.var WAVES_Sprite_Y2 = WAVES_Sprite_Y0 + (21 * 2)	//; $6c
	.var WAVES_Sprite_Y3 = WAVES_Sprite_Y0 + (21 * 3)	//; $81
	.var WAVES_Sprite_Y4 = WAVES_Sprite_Y0 + (21 * 4)	//; $96
	.var WAVES_Sprite_Y5 = WAVES_Sprite_Y0 + (21 * 5)	//; $ab
	.var WAVES_Sprite_Y6 = WAVES_Sprite_Y0 + (21 * 6)	//; $c0
	.var WAVES_Sprite_Y7 = WAVES_Sprite_Y0 + (21 * 7)	//; $d5

	.var WAVES_NumSprites_X = 8

	IRQList:
		//;		MSB($00/$80),	LINE,		LoPtr,						HiPtr
		.byte	$00,			$f9,		<WAVES_IRQ_VBlank,			>WAVES_IRQ_VBlank
		.byte	$80,			$34,		<WAVES_IRQ_TopScreenColour,	>WAVES_IRQ_TopScreenColour
		.byte	$00,			$40,		<WAVES_IRQ_WaveLayer_40,	>WAVES_IRQ_WaveLayer_40
		.byte	$00,			$50,		<WAVES_IRQ_WaveLayer_50,	>WAVES_IRQ_WaveLayer_50
		.byte	$00,			$60,		<WAVES_IRQ_WaveLayer_60,	>WAVES_IRQ_WaveLayer_60
		.byte	$00,			$70,		<WAVES_IRQ_WaveLayer_70,	>WAVES_IRQ_WaveLayer_70
		.byte	$00,			$80,		<WAVES_IRQ_WaveLayer_80,	>WAVES_IRQ_WaveLayer_80
		.byte	$00,			$90,		<WAVES_IRQ_WaveLayer_90,	>WAVES_IRQ_WaveLayer_90
		.byte	$00,			$a0,		<WAVES_IRQ_WaveLayer_A0,	>WAVES_IRQ_WaveLayer_A0
		.byte	$00,			$b0,		<WAVES_IRQ_WaveLayer_B0,	>WAVES_IRQ_WaveLayer_B0
		.byte	$00,			$c0,		<WAVES_IRQ_WaveLayer_C0,	>WAVES_IRQ_WaveLayer_C0
		.byte	$00,			$d0,		<WAVES_IRQ_WaveLayer_D0,	>WAVES_IRQ_WaveLayer_D0
		.byte	$00,			$e0,		<WAVES_IRQ_WaveLayer_E0,	>WAVES_IRQ_WaveLayer_E0
		.byte	$00,			$f0,		<WAVES_IRQ_WaveLayer_F0,	>WAVES_IRQ_WaveLayer_F0
		.byte	$ff

	.var WAVES_NumSeparateWaves = ((25 + 1) / 2)

	 WAVES_D011OpenScreen:
		.fill 11, $01
		.fill 1, $02	//; 12

		.fill 5, $01
		.fill 1, $02
		.fill 5, $01
		.fill 1, $02	//; 24

		.fill 3, $01
		.fill 1, $02	
		.fill 3, $01
		.fill 1, $02	//; 32

	WAVES_LayerColour0:
		.byte $00
	WAVES_LayerColour1:
		.byte $00
	WAVES_LayerColour2:
		.byte $00
	WAVES_LayerColour3:
		.byte $00

	WAVES_IsFadingIn:
		.byte $01
	WAVES_IsFadingOut:
		.byte $00
	WAVES_SpritesAreReady:
		.byte $00
	WAVES_SineRepeatCount:
		.byte $01

	WAVES_AnimationIndex:
		.byte $00
	WAVES_NumAnimationsTimes8:
		.byte $00

	WAVES_Multiply3:
		.byte (3 * 0), (3 * 1), (3 * 2), (3 * 3), (3 * 4), (3 * 5), (3 * 6), (3 * 7)

	.print "* $" + toHexString(WAVES_LocalData) + "-$" + toHexString(EndWAVES_LocalData - 1) + " WAVES_LocalData"

EndWAVES_LocalData:

.macro WAVES_Sprites_Update_YPos()
{
	ldy #$0e
	{
		sta VIC_Sprite0Y, y
		dey
		dey
		bpl *-5
	}
}

.macro WAVES_Sprites_Update_Values(set, row)
{
	ldx WAVES_AnimationIndex
	ldy #$00
	{
		.label WAVES_SUV_LoopPoint = *
		lda WAVES_AnimationLookup + (row * 64), x
		.if(set == 1)
		{
			sta SPRITE_Vals0, y
		}
		else
		{
			sta SPRITE_Vals1, y
		}
		inx
		iny
		cpy #8
		bne WAVES_SUV_LoopPoint //;* - 10
	}
}

//; WAVES_PreInit() -------------------------------------------------------------------------------------------------------
WAVES_PreInit:

		ldy #$00

		lda ($20),y //; Num Parts
		clc
		adc #$01
		sta WAVES_NumParts + 1
		iny

		lda ($20),y //; Sin Speed
		sta WAVES_SetSinSpeed + 1
		iny

		lda ($20), y //; WAVES_SineRepeatCount
		sta WAVES_SineRepeatCount
		sec
		sbc #$01
		sta WAVES_SineRepeat + 1 // first pass should never need repeats
		iny

		lda ($20), y //; NumSkipFramesOnFirstPass
		sta WAVES_SpriteSinTableIndex + 1
		iny

		lda ($20), y //; LayerColour0
		sta WAVES_LayerColour0
		iny

		lda ($20), y //; LayerColour1
		sta WAVES_LayerColour1
		iny

		lda ($20), y //; LayerColour2
		sta WAVES_LayerColour2
		iny

		lda ($20), y //; LayerColour3
		sta WAVES_LayerColour3
		iny

		lda ($20), y //; NumAnimations
		sta WAVES_NumAnimationsTimes8

		rts

		.print "* $" + toHexString(WAVES_PreInit) + "-$" + toHexString(EndWWAVES_PreInit - 1) + " WAVES_PreInit"
EndWWAVES_PreInit:


//; WAVES_Init() -------------------------------------------------------------------------------------------------------
WAVES_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda WAVES_LayerColour0
		sta VIC_ScreenColour

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteDrawPriority
		sta BaseBankAddress + $3fff
		
		ldx #(4 * 40)
		lda WAVES_LayerColour1
	WAVES_FillScreenLoop0:
		.for(var Offset = 0; Offset < (16 * 40); Offset += (4 * 40))
		{
			sta VIC_ColourMemory + Offset - 1, x
		}
		dex
		bne WAVES_FillScreenLoop0

		ldx #180
		lda WAVES_LayerColour3
	WAVES_FillScreenLoop1:
		.for(var Offset = (16 * 40); Offset < ((16 *40) + (9 * 40)); Offset += 180)
		{
			sta VIC_ColourMemory + Offset - 1, x
		}
		dex
		bne WAVES_FillScreenLoop1

		ldx #$00
		ldy #$08
		lda #$10
	WAVES_ClearScreen:
		sta ScreenAddress0 + (0 * 256),x
		inx
		bne WAVES_ClearScreen
		inc WAVES_ClearScreen + 2
		dey
		bne WAVES_ClearScreen

		lda #$ff
		sta VIC_SpriteMulticolourMode

		lda #DD02Value
		sta VIC_DD02

		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256

		cli
		rts

		.print "* $" + toHexString(WAVES_Init) + "-$" + toHexString(EndWAVES_Init - 1) + " WAVES_Init"
EndWAVES_Init:

//; WAVES_RequestNextSpriteSet() -------------------------------------------------------------------------------------------------------
WAVES_RequestNextSpriteSet:

		lda #$00
		sta WAVES_SpritesAreReady //; disable the sprite updates until they're loaded
		sta WAVES_SpriteSinTableIndex + 1

		sta WAVES_XPosition0 + 1
		sta WAVES_XPosition1 + 1
		sta WAVES_XPosition2 + 1
		sta WAVES_XPosition3 + 1
		sta WAVES_XPosition4 + 1
		sta WAVES_XPosition5 + 1
		sta WAVES_XPosition6 + 1
		sta WAVES_XPosition7 + 1
		sta WAVES_XMSB + 1

		rts

		.print "* $" + toHexString(WAVES_RequestNextSpriteSet) + "-$" + toHexString(EndWAVES_RequestNextSpriteSet - 1) + " WAVES_RequestNextSpriteSet"
EndWAVES_RequestNextSpriteSet:

//; WAVES_NextSpriteSetReady() -------------------------------------------------------------------------------------------------------
WAVES_NextSpriteSetReady:

		stx VIC_SpriteExtraColour0
		sty VIC_SpriteExtraColour1

		ldx #$07
	WAVES_SetupSpriteLoop:
		sta VIC_Sprite0Colour, x
		dex
		bpl WAVES_SetupSpriteLoop

		ldx #$00
	WAVES_UpdateAnimationLookupData:
		.for( var Row = 0; Row < 10; Row += 2)
		{
			lda WAVES_AnimationLookup + (Row * 64), x
			clc
			adc #WAVES_FirstSpriteValue
			sta WAVES_AnimationLookup + (Row * 64), x
		}
		inx
		cpx #(2 * 64)
		bne WAVES_UpdateAnimationLookupData

		lda #$01
		sta WAVES_SpritesAreReady

		rts

		.print "* $" + toHexString(WAVES_NextSpriteSetReady) + "-$" + toHexString(EndWAVES_NextSpriteSetReady - 1) + " WAVES_NextSpriteSetReady"
EndWAVES_NextSpriteSetReady:

//; WAVES_Exit() -------------------------------------------------------------------------------------------------------
WAVES_Exit:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(WAVES_Exit) + "-$" + toHexString(EndWAVES_Exit - 1) + " WAVES_Exit"
EndWAVES_Exit:

//; WAVES_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

	WAVES_D011_A:
		lda #$00
		sta VIC_D011

		jsr WAVES_UpdateSinPositions

	WAVES_D011_B:
		lda #$00
		sta VIC_D011

		lda Signal_CustomSignal1
		beq WAVES_NoCustomSignalReceived
		lda #$00
		sta Signal_CustomSignal1
		sta FrameOf256
		inc WAVES_IsFadingOut
	WAVES_NoCustomSignalReceived:

		lda WAVES_IsFadingOut
		bne WAVES_DoFadeOut
		lda WAVES_IsFadingIn
		beq WAVES_SkipScreenFlipping

	WAVES_DoFadeIn:
		ldx FrameOf256
		cpx #32
		bcs WAVES_FinishedFadeIn

		lda WAVES_D011OpenScreen, x
		sta WAVES_FlipScreenVisibility + 1
		jmp WAVES_SkipScreenFlipping

	WAVES_FinishedFadeIn:
		dec WAVES_IsFadingIn
		jmp WAVES_SkipScreenFlipping

	WAVES_DoFadeOut:
		lda #32
		sec
		sbc FrameOf256
		tax
		bcc WAVES_FinishedFadeOut
		lda WAVES_D011OpenScreen, x
		sta WAVES_FlipScreenVisibility + 1
		jmp WAVES_SkipScreenFlipping

	WAVES_FinishedFadeOut:
		dec WAVES_IsFadingOut
		lda #$01
		sta Signal_CurrentEffectIsFinished
		jmp WAVES_SkipScreenFlipping

	WAVES_SkipScreenFlipping:

		inc FrameOf256
		lda FrameOf256
		and #$07
		bne WAVES_NoAnimUpdate
		lda WAVES_AnimationIndex
		clc
		adc #$08
		cmp WAVES_NumAnimationsTimes8
		bne WAVES_AnimWithinRange
		lda #$00
	WAVES_AnimWithinRange:
		sta WAVES_AnimationIndex
	WAVES_NoAnimUpdate:

		lda #WAVES_Sprite_Y0
		:WAVES_Sprites_Update_YPos()
		:WAVES_Sprites_Update_Values(0, 0)
		:WAVES_Sprites_Update_Values(1, 1)

	WAVES_XPosition0:
		lda #$00
		sta VIC_Sprite0X
	WAVES_XPosition1:
		lda #$00
		sta VIC_Sprite1X
	WAVES_XPosition2:
		lda #$00
		sta VIC_Sprite2X
	WAVES_XPosition3:
		lda #$00
		sta VIC_Sprite3X
	WAVES_XPosition4:
		lda #$00
		sta VIC_Sprite4X
	WAVES_XPosition5:
		lda #$00
		sta VIC_Sprite5X
	WAVES_XPosition6:
		lda #$00
		sta VIC_Sprite6X
	WAVES_XPosition7:
		lda #$00
		sta VIC_Sprite7X
	WAVES_XMSB:
		lda #$00
		sta VIC_SpriteXMSB

		jsr Music_Play

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_VBlank) + "-$" + toHexString(EndWAVES_IRQ_VBlank - 1) + " WAVES_IRQ_VBlank"
EndWAVES_IRQ_VBlank:

//; WAVES_IRQ_TopScreenColour() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_TopScreenColour:

		:IRQManager_BeginIRQ(0,0)

		:Start_ShowTiming(1)

	WAVES_FlipScreenVisibility:
		ldx #$00
		beq WAVES_SkipFlipScreen
		cpx #$02
		beq WAVES_FlipScreen_On
	WAVES_FlipScreen_Off:
		lda #$0b
		sta VIC_D011
		sta WAVES_D011_B + 1
		lda #$03
		sta WAVES_D011_A + 1
		lda #LDX_ABS
		sta WAVES_STXScreenColour1
		sta WAVES_STXScreenColour2
		jmp WAVES_SkipFlipScreen
	WAVES_FlipScreen_On:
		lda #$1b
		sta VIC_D011
		sta WAVES_D011_B + 1
		lda #$13
		sta WAVES_D011_A + 1
		lda #STX_ABS
		sta WAVES_STXScreenColour1
		sta WAVES_STXScreenColour2
	WAVES_SkipFlipScreen:

		lda WAVES_LayerColour0
		sta VIC_ScreenColour
	WAVES_SkipScreenUpdate:

	WAVES_D016Value0:
		lda #$ff
		sta VIC_D016

	WAVES_D018Value0:
		lda #$ff
		sta VIC_D018

		lda #$ff
		sta VIC_SpriteEnable

		jsr WAVES_DrawLayers

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_TopScreenColour) + "-$" + toHexString(EndWAVES_IRQ_TopScreenColour - 1) + " WAVES_IRQ_TopScreenColour"
EndWAVES_IRQ_TopScreenColour:

//; WAVES_IRQ_WaveLayer_40() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_40:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 2; InitialNOPs++)
		{
			nop
		}

		ldx #$09
	WAVES_WasteCycleTimeLoop_40:
		dex
		bne WAVES_WasteCycleTimeLoop_40

		ldx #$00
	WAVES_D016Value1:
		ldy #$ff
	WAVES_D018Value1:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_40) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_40 - 1) + " WAVES_IRQ_WaveLayer_40"
EndWAVES_IRQ_WaveLayer_40:

//; WAVES_IRQ_WaveLayer_50() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_50:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value2:
		ldy #$ff
	WAVES_D018Value2:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y1
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(0, 2)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_50) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_50 - 1) + " WAVES_IRQ_WaveLayer_50"
EndWAVES_IRQ_WaveLayer_50:

//; WAVES_IRQ_WaveLayer_60() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_60:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value3:
		ldy #$ff
	WAVES_D018Value3:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y2
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(1, 3)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_60) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_60 - 1) + " WAVES_IRQ_WaveLayer_60"
EndWAVES_IRQ_WaveLayer_60:

//; WAVES_IRQ_WaveLayer_70() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_70:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx WAVES_LayerColour2
	WAVES_D016Value4:
		ldy #$ff
	WAVES_D018Value4:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
	WAVES_STXScreenColour1:
		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y3
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(0, 4)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_70) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_70 - 1) + " WAVES_IRQ_WaveLayer_70"
EndWAVES_IRQ_WaveLayer_70:

//; WAVES_IRQ_WaveLayer_80() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_80:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value5:
		ldy #$ff
	WAVES_D018Value5:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		:WAVES_Sprites_Update_Values(1, 5)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_80) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_80 - 1) + " WAVES_IRQ_WaveLayer_80"
EndWAVES_IRQ_WaveLayer_80:

//; WAVES_IRQ_WaveLayer_90() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_90:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value6:
		ldy #$ff
	WAVES_D018Value6:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y4
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(0, 6)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_90) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_90 - 1) + " WAVES_IRQ_WaveLayer_90"
EndWAVES_IRQ_WaveLayer_90:

//; WAVES_IRQ_WaveLayer_A0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_A0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value7:
		ldy #$ff
	WAVES_D018Value7:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y5
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(1, 7)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_A0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_A0 - 1) + " WAVES_IRQ_WaveLayer_A0"
EndWAVES_IRQ_WaveLayer_A0:

//; WAVES_IRQ_WaveLayer_B0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_B0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value8:
		ldy #$ff
	WAVES_D018Value8:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		lda #WAVES_Sprite_Y6
		:WAVES_Sprites_Update_YPos()

		:WAVES_Sprites_Update_Values(0, 8)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_B0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_B0 - 1) + " WAVES_IRQ_WaveLayer_B0"
EndWAVES_IRQ_WaveLayer_B0:

//; WAVES_IRQ_WaveLayer_C0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_C0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value9:
		ldy #$ff
	WAVES_D018Value9:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		:WAVES_Sprites_Update_Values(1, 9)

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_C0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_C0 - 1) + " WAVES_IRQ_WaveLayer_C0"
EndWAVES_IRQ_WaveLayer_C0:

//; WAVES_IRQ_WaveLayer_D0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_D0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		.for(var InitialNOPs = 0; InitialNOPs < 8; InitialNOPs++)
		{
			nop
		}
		lda $ea

		ldx #$00
	WAVES_D016Value10:
		ldy #$ff
	WAVES_D018Value10:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		.for(var InitialNOPs = 0; InitialNOPs < 30; InitialNOPs++)
		{
			nop
		}
		lda #$00
		sta VIC_SpriteEnable

		lda #WAVES_Sprite_Y7
		:WAVES_Sprites_Update_YPos()

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_D0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_D0 - 1) + " WAVES_IRQ_WaveLayer_D0"
EndWAVES_IRQ_WaveLayer_D0:

//; WAVES_IRQ_WaveLayer_E0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_E0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		ldx #$09
	WAVES_WasteCycleTimeLoop_E0:
		dex
		bne WAVES_WasteCycleTimeLoop_E0
		nop

		ldx #$00
	WAVES_D016Value11:
		ldy #$ff
	WAVES_D018Value11:
		lda #$ff
		sty VIC_D016
		sta VIC_D018
//;		stx VIC_ScreenColour

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_E0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_E0 - 1) + " WAVES_IRQ_WaveLayer_E0"
EndWAVES_IRQ_WaveLayer_E0:

//; WAVES_IRQ_WaveLayer_F0() -------------------------------------------------------------------------------------------------------
WAVES_IRQ_WaveLayer_F0:

		:IRQManager_BeginIRQ(1, 19)

		:Start_ShowTiming(1)

		ldx #$0a
	WAVES_WasteCycleTimeLoop_F0:
		dex
		bne WAVES_WasteCycleTimeLoop_F0
	
		ldx WAVES_LayerColour3
	WAVES_STXScreenColour2:
		stx VIC_ScreenColour

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(WAVES_IRQ_WaveLayer_F0) + "-$" + toHexString(EndWAVES_IRQ_WaveLayer_F0 - 1) + " WAVES_IRQ_WaveLayer_F0"
EndWAVES_IRQ_WaveLayer_F0:

//; WAVES_UpdateSinPositions() -------------------------------------------------------------------------------------------------------
WAVES_UpdateSinPositions:
	WAVES_UpdateSin_X:
		ldx #$00
	WAVES_UpdateSin_Y:
		ldy #$00

		.for(var LayerIndex = 0; LayerIndex < WAVES_NumSeparateWaves; LayerIndex++)
		{
			.if(LayerIndex < (WAVES_NumSeparateWaves - 1))
			{
				//; D016 Values
				lda WAVES_SinTable_Pixel, x
				sta D016Value.get(LayerIndex) + 1

				//; D018 Values
				lda WAVES_SinTable_Undulation, y
				asl	//; (CharBank * 2)
				.if((LayerIndex & 1) == 0)
				{
					ora #(ScreenBank0 * 16)
				}
				else
				{
					ora #(ScreenBank1 * 16)
				}
				sta D018Value.get(LayerIndex) + 1

				//; DrawIndex Values
				lda WAVES_SinTable_Char, x
				eor WAVES_SinTable_UndulationHi, y
				.if((LayerIndex & 7) > 0)
				{
					ora #(32 * (LayerIndex & 7))
				}
				sta DrawIndexValue.get(LayerIndex) + 1

				txa
				clc
				adc #WAVES_SinMovementSpacing
				tax

				tya
				clc
				adc #WAVES_SinScaleSpacing
				tay
			}
		}

		lda WAVES_SpritesAreReady
		bne WAVES_UpdateSprites
		jmp WAVES_DontUpdateSprites

	WAVES_UpdateSprites:

	WAVES_SpriteSinTableIndex:
		ldx #$00

		lda WAVES_SinTable_SpriteX0, x
		sta WAVES_XPosition0 + 1
		lda WAVES_SinTable_SpriteX1, x
		sta WAVES_XPosition1 + 1
		lda WAVES_SinTable_SpriteX2, x
		sta WAVES_XPosition2 + 1
		lda WAVES_SinTable_SpriteX3, x
		sta WAVES_XPosition3 + 1
		lda WAVES_SinTable_SpriteX4, x
		sta WAVES_XPosition4 + 1
		lda WAVES_SinTable_SpriteX5, x
		sta WAVES_XPosition5 + 1
		lda WAVES_SinTable_SpriteX6, x
		sta WAVES_XPosition6 + 1
		lda WAVES_SinTable_SpriteX7, x
		sta WAVES_XPosition7 + 1
		lda WAVES_SinTable_SpriteXMSB, x
		sta WAVES_XMSB + 1
		lda WAVES_SinTable_SpriteClipX, x
		sta WAVES_SpriteCharAdjust + 1
		lda WAVES_SinTable_SpriteClipXPixel, x
		sta WAVES_SpriteClipASM + 1

		inc WAVES_SpriteSinTableIndex + 1
		lda WAVES_SpriteSinTableIndex + 1
		beq WAVES_FinishedSine
		cmp #(128 + 64)
		bne WAVES_NotFinishedSine

	WAVES_SineRepeat:
		ldx #$00
		inx
		stx WAVES_SineRepeat + 1
		cpx WAVES_SineRepeatCount
		beq WAVES_NotFinishedSine //; Don't reset the sine if we're on the last repeat

		lda #64
		sta WAVES_SpriteSinTableIndex + 1 //; loop the "regular" sine part...
		jmp WAVES_NotFinishedSine

	WAVES_FinishedSine:
		inc Signal_CustomSignal0
		lda #$00
		sta WAVES_SineRepeat + 1
		jsr WAVES_RequestNextSpriteSet
	WAVES_NotFinishedSine:

		lda WAVES_UpdateSin_Y + 1
		clc
		adc #(WAVES_SinScaleSpacing * 9)
		tay

		lda WAVES_SinTable_Undulation, y
		asl
		asl
		eor WAVES_SpriteClipASM + 1
		sta WAVES_SpriteClipASM + 1

		lda WAVES_UpdateSin_X + 1
		clc
		adc #(WAVES_SinMovementSpacing * 9)
		tax

		lda WAVES_SinTable_Char, x
		clc
	WAVES_SpriteCharAdjust:
		adc #$00
		eor WAVES_SinTable_UndulationHi, y
		asl
		asl
		asl
		and #$f0
		ora WAVES_SpriteClipASM + 1
		sta WAVES_SpriteClipASM + 1

	WAVES_DontUpdateSprites:
		inc WAVES_UpdateSin_X + 1

		lda WAVES_UpdateSin_Y + 1
		clc
	WAVES_SetSinSpeed:
		adc #WAVES_SinScaleSpeed
		sta WAVES_UpdateSin_Y + 1
		
		rts

		.print "* $" + toHexString(WAVES_UpdateSinPositions) + "-$" + toHexString(EndWAVES_UpdateSinPositions - 1) + " WAVES_UpdateSinPositions"
EndWAVES_UpdateSinPositions:

//; WavesDrawASM() -------------------------------------------------------------------------------------------------------
WavesDrawASM:
		.import source "..\..\Intermediate\Built\Waves\Draw.asm"

		.print "* $" + toHexString(WavesDrawASM) + "-$" + toHexString(EndWavesDrawASM - 1) + " WavesDrawASM"
EndWavesDrawASM:

//; DoTheWavesPart() -------------------------------------------------------------------------------------------------------
DoTheWavesPart:
		stx $20
		sty $21

		jsr WAVES_PreInit

		lda #$00
		sta WAVES_SpriteSet + 1

		lda $20
		clc
		adc #$09
		sta $20
		lda $21
		adc #$00
		sta $21

		jsr WAVES_Init

	WAVES_NextSpriteSet:
		ldx WAVES_SpriteSet + 1
		ldy WAVES_Multiply3, x
		lda ($20), y
		tax
		iny
		lda ($20), y
		sta WAVES_YValue + 1
		iny
		lda ($20), y
	WAVES_YValue:
		ldy #$ff
		jsr WAVES_NextSpriteSetReady

	WAVES_MainLoop:
		:IRQ_WaitForVBlank()

		lda Signal_CurrentEffectIsFinished
		bne WAVES_Finished

		jsr WAVES_SpriteClipASM	//; MainThreadFunc

		lda Signal_CustomSignal0
		beq WAVES_MainLoop

		lda #$00
		sta Signal_CustomSignal0

	WAVES_SpriteSet:
		ldx #$00
		inx
		stx WAVES_SpriteSet + 1
	WAVES_NumParts:
		cpx #$05
		beq WAVES_NoMoreLogosToLoad

		jsr Spindle_LoadNextFile //; #NextWAVESLogo

		jmp WAVES_NextSpriteSet

	WAVES_NoMoreLogosToLoad:
		inc Signal_CustomSignal1
		jmp WAVES_MainLoop

	WAVES_Finished:
		jmp WAVES_Exit

		.print "* $" + toHexString(DoTheWavesPart) + "-$" + toHexString(EndDoTheWavesPart - 1) + " DoTheWavesPart"
EndDoTheWavesPart:

