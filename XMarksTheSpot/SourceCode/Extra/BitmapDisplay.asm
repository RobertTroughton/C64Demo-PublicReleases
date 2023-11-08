//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

*= BitmapDisplay_BASE "Bitmap Display"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-1fff Music

//; - $c000-c1ff Code
//; --- $8c00-8fff Screen
//; - $a000-bfff Bitmap

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp BITMAPDISP_Init					//; Init
		.byte $60, $00, $00					//; MainThreadFunc
		jmp BITMAPDISP_End					//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BITMAPDISP_NumSpriteFadeFrames = 32
	.var TURNSIDE_SpriteSinX = $8a00
	.var TURNSIDE_SpriteSinY = $8b00

//; BITMAPDISP_LocalData -------------------------------------------------------------------------------------------------------
BITMAPDISP_LocalData:

	IRQList:
		//;		MSB($00/$80),	LINE,		LoPtr,						HiPtr
		.byte	$80,			$00,		<BITMAPDISP_IRQ_VBlank,			>BITMAPDISP_IRQ_VBlank
	IRQList_SpritesLayers:
		.byte	$00,			$33,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$48,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$5d,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$72,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$87,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$9c,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$b1,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$c6,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$00,			$db,		<BITMAPDISP_SPRITES_NEXTLAYER,	>BITMAPDISP_SPRITES_NEXTLAYER
		.byte	$ff

	BITMAPDISP_Mul64:
		.byte $00, $40, $80, $c0

	BITMAPDISP_ShouldShowSprites:
		.byte $00
	BITMAPDISP_IsShowingSprites:
		.byte $00
	BITMAPDISP_FirstSpriteIndex:
		.byte $00

	.print "* $" + toHexString(BITMAPDISP_LocalData) + "-$" + toHexString(EndBITMAPDISP_LocalData - 1) + " BITMAPDISP_LocalData"

EndBITMAPDISP_LocalData:

//; BITMAPDISP_Init() -------------------------------------------------------------------------------------------------------
BITMAPDISP_Init:

		stx $20
		sty $21

		sta BITMAPDISP_ShouldShowSprites

		:ClearGlobalVariables() //; nb. corrupts A and X

		ldy #$00

		lda ($20), y	//; FrameCounterHi
		sta BITMAPDISP_DemoFrameCounterHi + 1
		iny
		lda ($20), y	//; FrameCounterLo
		sta BITMAPDISP_DemoFrameCounterLo + 1
		iny

		lda ($20), y	//; Screen Colour ($ff = don't change)
		cmp #$ff
		beq BITMAPDISP_DontSetScreenColour
		sta VIC_ScreenColour
	BITMAPDISP_DontSetScreenColour:
		iny

		lda ($20), y	//; Bank
		and #$03
		sta BITMAPDISP_Bank + 1
		ora #60
		sta VIC_DD02
		iny

		lda ($20), y	//; D800 Colour Data Ptr Hi
		sta BITMAPDisk_ColourDataPtrHi + 1
		iny

		//; D018Value = ((ScreenBank * 16) + (BitmapBank * 8))
		lda ($20), y	//; Screen Bank
		tax
		asl
		iny
		ora ($20), y	//; Bitmap Bank
		asl
		asl
		asl
 		sta VIC_D018

		lda #$00
		sta BITMAPDISP_FirstSpriteIndex
		lda ($20), y	//; Bitmap Bank (again)
		bne BITMAPDISP_00SpriteIndex
		lda #$80
		sta BITMAPDISP_FirstSpriteIndex
	BITMAPDISP_00SpriteIndex:
		iny

		lda ($20), y	//; D016 Value
		sta VIC_D016
		iny

		lda ($20), y	//; D011 Value
		sta BITMAPDISP_D011Value + 1

//;	.var Bank_SpriteVals = Bank_BaseAddress + (ScreenBank * $0400) + $3f8
		txa
		asl
		asl
	BITMAPDISP_Bank:
		ldx #$00
		ora BITMAPDISP_Mul64, x
		ora #$03
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (0 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (1 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (2 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (3 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (4 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (5 * 3)
		sta BITMAPDISP_SetSpriteVals_STAs + 2 + (6 * 3)

	BITMAPDisk_ColourDataPtrHi:
		ldx #$ff
		stx BITMAPDISP_ColourRead0 + 2
		inx
		stx BITMAPDISP_ColourRead1 + 2
		inx
		stx BITMAPDISP_ColourRead2 + 2
		inx
		stx BITMAPDISP_ColourRead3 + 2

		ldy #$00
	BITMAPDISP_ColourRead0:
		lda $ff00, y
		sta VIC_ColourMemory + (0 * 256), y
	BITMAPDISP_ColourRead1:
		lda $ff00, y
		sta VIC_ColourMemory + (1 * 256), y
	BITMAPDISP_ColourRead2:
		lda $ff00, y
		sta VIC_ColourMemory + (2 * 256), y
	BITMAPDISP_ColourRead3:
		lda $ff00, y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne BITMAPDISP_ColourRead0

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta Signal_CustomSignal0
		sta Signal_CustomSignal1
		sta BITMAPDISP_IsShowingSprites

		lda #JSR_ABS
		sta BITMAPDISP_JSRToFadeIn
		lda #LDA_ABS
		sta BITMAPDISP_JSRToFadeOut
		sta BITMAPDISP_JSRToTimedDisplay

		:IRQ_WaitForVBlank()

		jsr BITMAPDISP_InitSpritesForSpriteFade

		sei
		
		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli

		rts

		.print "* $" + toHexString(BITMAPDISP_Init) + "-$" + toHexString(EndBITMAPDISP_Init - 1) + " BITMAPDISP_Init"
EndBITMAPDISP_Init:

//; BITMAPDISP_End() -------------------------------------------------------------------------------------------------------
BITMAPDISP_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(BITMAPDISP_End) + "-$" + toHexString(EndBITMAPDISP_End - 1) + " BITMAPDISP_End"
EndBITMAPDISP_End:

//; BITMAPDISP_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
BITMAPDISP_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

	BITMAPDISP_D011Value:
		lda #$3b
		sta VIC_D011

		jsr Music_Play

		lda BITMAPDISP_IsShowingSprites
		bne BITMAPDISP_DontChangeYValsVB
		lda #$32
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta VIC_Sprite0Y + SpriteIndex * 2
		}
	BITMAPDISP_DontChangeYValsVB:

		inc FrameOf256
		bne BITMAPDISP_Not256th
		inc Frame_256Counter
	BITMAPDISP_Not256th:

	BITMAPDISP_JSRToFadeIn:
		jsr BITMAPDISP_FadeIn
	BITMAPDISP_JSRToTimedDisplay:
		lda BITMAPDISP_TimedDisplay
	BITMAPDISP_JSRToFadeOut:
		lda BITMAPDISP_FadeOut

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

BITMAPDISP_FadeIn:
		lda FrameOf256
		cmp #BITMAPDISP_NumSpriteFadeFrames
		bne BITMAPDISP_FadeInNotFinished

		lda #LDA_ABS
		sta BITMAPDISP_JSRToFadeIn
		lda #JSR_ABS
		sta BITMAPDISP_JSRToTimedDisplay
		lda #$00
		sta VIC_SpriteEnable
		sta FrameOf256
		sta Frame_256Counter

		inc Signal_CustomSignal2

		ldx BITMAPDISP_SetSpriteVals_STAs + 1
		ldy BITMAPDISP_SetSpriteVals_STAs + 2
		lda BITMAPDISP_ShouldShowSprites
		sta BITMAPDISP_IsShowingSprites
		beq BITMAPDISP_DontShowSprites
		cmp #$01
		bne BITMAPDISP_ShowCreditSprites
		jmp TurnSide_BASE + 0
	BITMAPDISP_ShowCreditSprites:
		jmp CreditSprites_BASE + 0
	BITMAPDISP_DontShowSprites:
		rts

	BITMAPDISP_FadeInNotFinished:
		ldx #$7f
		stx VIC_SpriteEnable

		eor #$ff
		clc
		adc #BITMAPDISP_NumSpriteFadeFrames
		jmp BITMAPDISP_SetSpriteVals

BITMAPDISP_FadeOut:
		lda FrameOf256
		cmp #BITMAPDISP_NumSpriteFadeFrames
		bne BITMAPDISP_FadeOutNotFinished

		lda #LDA_ABS
		sta BITMAPDISP_JSRToFadeOut
		inc Signal_CurrentEffectIsFinished
		rts

	BITMAPDISP_FadeOutNotFinished:
		ldx #$7f
		stx VIC_SpriteEnable
	BITMAPDISP_SetSpriteVals:
		clc
		adc BITMAPDISP_FirstSpriteIndex
	BITMAPDISP_SetSpriteVals_STAs:
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta $fff8 + SpriteIndex	//; this pointer will be updated through the init function - we just need the [$xxf8, $xxff] part here
		}
		rts

BITMAPDISP_TimedDisplay:

		lda BITMAPDISP_ShouldShowSprites
		beq BITMAPDISP_DontShowSprites2

		cmp #$01
		bne BITMAPDISP_ShowCreditSprites2

		lda Signal_CustomSignal0			//; Have we received the signal to say that we're waiting for the disk swap..?
		beq BITMAPDISP_DontShowSprites2

		jsr TurnSide_BASE + 3
		jmp BITMAPDISP_DontShowSprites2

	BITMAPDISP_ShowCreditSprites2:
		jsr CreditSprites_BASE + 3
		jmp BITMAPDISP_DemoFrameCounterHi
	BITMAPDISP_DontShowSprites2:

	BITMAPDISP_DemoFrameCounterHi:
		lda #$ff
		cmp #$ff
		bne BITMAPDISP_ShouldBeTimed

		lda Signal_CustomSignal1			//; Have we received the signal to say that the disk has been swapped..?
		bne BITMAPDISP_StartFadeOut
		rts

	BITMAPDISP_ShouldBeTimed:
		cmp Frame_256Counter
		bne BITMAPDISP_NotFinishedTimer
		lda FrameOf256
	BITMAPDISP_DemoFrameCounterLo:
		cmp #$ff
		bne BITMAPDISP_NotFinishedTimer

	BITMAPDISP_StartFadeOut:
		lda BITMAPDISP_ShouldShowSprites
		bne BITMAPDISP_DontShowSprites3
		lda #$00
		sta VIC_SpriteEnable
	BITMAPDISP_DontShowSprites3:

		jsr BITMAPDISP_InitSpritesForSpriteFade

		lda #LDA_ABS
		sta BITMAPDISP_JSRToTimedDisplay
		lda #JSR_ABS
		sta BITMAPDISP_JSRToFadeOut
		lda #$00
		sta BITMAPDISP_IsShowingSprites
		sta FrameOf256
		sta Frame_256Counter
	BITMAPDISP_NotFinishedTimer:
		rts

		.print "* $" + toHexString(BITMAPDISP_IRQ_VBlank) + "-$" + toHexString(EndBITMAPDISP_IRQ_VBlank - 1) + " BITMAPDISP_IRQ_VBlank"
EndBITMAPDISP_IRQ_VBlank:

//; BITMAPDISP_SPRITES_NEXTLAYER() -------------------------------------------------------------------------------------------------------
BITMAPDISP_SPRITES_NEXTLAYER:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

		lda BITMAPDISP_IsShowingSprites
		bne BITMAPDISP_DontChangeYVals
		lda VIC_Sprite0Y
		clc
		adc #$15
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta VIC_Sprite0Y + SpriteIndex * 2
		}
BITMAPDISP_DontChangeYVals:

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(BITMAPDISP_SPRITES_NEXTLAYER) + "-$" + toHexString(EndBITMAPDISP_SPRITES_NEXTLAYER - 1) + " BITMAPDISP_SPRITES_NEXTLAYER"
EndBITMAPDISP_SPRITES_NEXTLAYER:

BITMAPDISP_InitSpritesForSpriteFade:

		lda VIC_BorderColour
		ldy #$06
	BITMAPDISP_SetSpriteCols:
		sta VIC_Sprite0Colour, y
		dey
		bpl BITMAPDISP_SetSpriteCols

		lda #$18
		ldy #$00
	BITMAPDISP_SetSpriteXVals:
		sta VIC_Sprite0X, y
		clc
		adc #$30
		iny
		iny
		cpy #$0e
		bne BITMAPDISP_SetSpriteXVals

		lda #$00
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteDrawPriority
		sta VIC_SpriteMulticolourMode

		lda #$7f
		sta VIC_SpriteDoubleWidth

		lda #$60
		sta VIC_SpriteXMSB

		rts

