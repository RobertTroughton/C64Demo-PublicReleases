//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = FullScreenRotatingThings_BASE "Full Screen Rotating Things"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $0c00-0dff Spindle
//; - $1000-2fff Music

//; - $3800-38f7 Charset
//; - $3b00-3bff Sintable
//; ---- $3c00-3fff Screen
//; - $7000-bbff Code+Data (nb. currently includes all animation data - which we can discard if we transition to a new effect)
//;    (currently $7000-$89ea code, $89eb-$b95f data)

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp FSRT_Init						//; Init
		jmp FSRT_RenderThings				//; MainThreadFunc
		jmp FSRT_End						//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:
		
//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBankAddress = (BaseBank * $4000)
	.var CharBank = 0 //; Bank+[0000,07ff] //; nb. we only use a tiny part of this
	.var ScreenBank0 = 2 //; Bank+[0800,0bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	
	.var FSRT_SinTable = $3f00
	
//; FSRT_LocalData -------------------------------------------------------------------------------------------------------
FSRT_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$fc,			<FSRT_IRQ_VBlank,			>FSRT_IRQ_VBlank
		.byte	$00,			$33,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$48,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$5d,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$72,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$87,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$9c,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$b1,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$c6,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$00,			$db,			<FSRT_SPRITES_NEXTLAYER,	>FSRT_SPRITES_NEXTLAYER
		.byte	$ff
		
	FSRT_ThingColours:
		.byte $01, $07, $0a, $02, $ff

	.print "* $" + toHexString(FSRT_LocalData) + "-$" + toHexString(EndFSRT_LocalData - 1) + " FSRT_LocalData"
EndFSRT_LocalData:

//; FSRT_Init() -------------------------------------------------------------------------------------------------------
FSRT_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteDoubleHeight

		lda FSRT_ThingColours + 0
		sta VIC_ScreenColour

		lda VIC_BorderColour
		sta FSRT_ThingColours + 4

		ldy #00
		lda #$00
	FSRT_InnerFillColours:
		ldx FSRT_ScreenColourData + (250 * 0), y
		lda FSRT_ThingColours + 1, x
		sta VIC_ColourMemory + (250 * 0), y
		
		ldx FSRT_ScreenColourData + (250 * 1), y
		lda FSRT_ThingColours + 1, x
		sta VIC_ColourMemory + (250 * 1), y

		ldx FSRT_ScreenColourData + (250 * 2), y
		lda FSRT_ThingColours + 1, x
		sta VIC_ColourMemory + (250 * 2), y

		ldx FSRT_ScreenColourData + (250 * 3), y
		lda FSRT_ThingColours + 1, x
		sta VIC_ColourMemory + (250 * 3), y

		lda #$c0
		sta ScreenAddress0 + (250 * 0), y
		sta ScreenAddress0 + (250 * 1), y
		sta ScreenAddress0 + (250 * 2), y
		sta ScreenAddress0 + (250 * 3), y
		iny
		cpy #250
		bne FSRT_InnerFillColours

		jsr FSRT_DrawStaticThings

		lda #$00
		sta FSRT_Index_Thing0A + 1
		lda #$33
		sta FSRT_Index_Thing0B + 1
		lda #$59
		sta FSRT_Index_Thing1A + 1
		lda #$c3
		sta FSRT_Index_Thing1B + 1
		lda #$eb
		sta FSRT_Index_Thing2A + 1
		lda #$54
		sta FSRT_Index_Thing2B + 1
		lda #$13
		sta FSRT_Index_Thing3A + 1
		lda #$a2
		sta FSRT_Index_Thing3B + 1

		lda FSRT_ThingColours + 1
		sta VIC_ExtraBackgroundColour0
		lda FSRT_ThingColours + 2
		sta VIC_ExtraBackgroundColour1
		lda FSRT_ThingColours + 3
		sta VIC_ExtraBackgroundColour2

		lda #$08
		sta VIC_D016

		lda #((ScreenBank0 * 16) + (CharBank * 2))
		sta VIC_D018

		lda #(60 + BaseBank)
		sta VIC_DD02

		lda #$18
		ldx VIC_BorderColour
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta VIC_Sprite0X + SpriteIndex * 2
			.if(SpriteIndex != 6)
			{
				clc
				adc #$30
			}
			stx VIC_Sprite0Colour + SpriteIndex
		}

		lda #$60
		sta VIC_SpriteXMSB

		lda #$7f
		sta VIC_SpriteDoubleWidth

		sei
		
		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(FSRT_Init) + "-$" + toHexString(EndFSRT_Init - 1) + " FSRT_Init"
EndFSRT_Init:

//; FSRT_End() -------------------------------------------------------------------------------------------------------
FSRT_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(FSRT_End) + "-$" + toHexString(EndFSRT_End - 1) + " FSRT_End"
EndFSRT_End:


//; FSRT_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
FSRT_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)
		
		jsr Music_Play

		lda #$5b
		sta VIC_D011

		inc FrameOf256
		bne FSRT_Skip256Counter
		inc Frame_256Counter
		lda Frame_256Counter
		cmp #$03
		bcc FSRT_Skip256Counter
	FSRT_Skip256Counter:

		lda Frame_256Counter
		cmp #$00
		beq FSRT_FadeIn
		cmp #$03
		bne FSRT_FinishedFades
		jmp FSRT_FadeOut
	FSRT_FinishedFades:

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		lda #$32
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta VIC_Sprite0Y + SpriteIndex * 2
		}
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

	FSRT_FadeIn:
		lda FrameOf256
		cmp #$20
		bcc FSRT_StillFadingIn
		lda #$00
		sta VIC_SpriteEnable
		lda #$ff
		sta FrameOf256
		jmp FSRT_FinishedFades
	FSRT_StillFadingIn:
		eor #$ff
		clc
		adc #$20
	FSRT_StillFadingOut:
		clc
		adc #$30
		.for(var SpriteIndex = 0; SpriteIndex < 7; SpriteIndex++)
		{
			sta  SPRITE0_Val_Bank0 + SpriteIndex
		}
		lda #$7f
		sta VIC_SpriteEnable
		jmp FSRT_FinishedFades

	FSRT_FadeOut:
		lda FrameOf256
		cmp #$20
		bcc FSRT_StillFadingOut
		lda #$00
		sta VIC_D011
		inc Signal_CurrentEffectIsFinished
		jmp FSRT_FinishedFades

		.print "* $" + toHexString(FSRT_IRQ_VBlank) + "-$" + toHexString(EndFSRT_IRQ_VBlank - 1) + " FSRT_IRQ_VBlank"
EndFSRT_IRQ_VBlank:

//; FSRT_SPRITES_NEXTLAYER() -------------------------------------------------------------------------------------------------------
FSRT_SPRITES_NEXTLAYER:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(1)

		lda VIC_Sprite0Y
		clc
		adc #$15
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y
		sta VIC_Sprite2Y
		sta VIC_Sprite3Y
		sta VIC_Sprite4Y
		sta VIC_Sprite5Y
		sta VIC_Sprite6Y
		sta VIC_Sprite7Y

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(FSRT_SPRITES_NEXTLAYER) + "-$" + toHexString(EndFSRT_SPRITES_NEXTLAYER - 1) + " FSRT_SPRITES_NEXTLAYER"
EndFSRT_SPRITES_NEXTLAYER:

//; FSRT_RenderThings() -------------------------------------------------------------------------------------------------------
FSRT_RenderThings:

		:Start_ShowTiming(0)

		lda FSRT_Index_Thing0A + 1
		clc
		adc #$01
		sta FSRT_Index_Thing0A + 1
		lda FSRT_Index_Thing0B + 1
		sec
		sbc #$01
		sta FSRT_Index_Thing0B + 1

		lda FSRT_Index_Thing1A + 1
		sec
		sbc #$04
		sta FSRT_Index_Thing1A + 1
		lda FSRT_Index_Thing1B + 1
		clc
		adc #$02
		sta FSRT_Index_Thing1B + 1

		lda FSRT_Index_Thing2A + 1
		sec
		sbc #$02
		sta FSRT_Index_Thing2A + 1
		lda FSRT_Index_Thing2B + 1
		sec
		sbc #$03
		sta FSRT_Index_Thing2B + 1

		lda FSRT_Index_Thing3A + 1
		clc
		adc #$04
		sta FSRT_Index_Thing3A + 1
		lda FSRT_Index_Thing3B + 1
		sec
		sbc #$01
		sta FSRT_Index_Thing3B + 1

		jsr FSRT_DrawAnimatedThings

		:Stop_ShowTiming(0)
		
		rts

		.print "* $" + toHexString(FSRT_RenderThings) + "-$" + toHexString(EndFSRT_RenderThings - 1) + " FSRT_RenderThings"
EndFSRT_RenderThings:

FullScreenRotatingThingsDrawASM:
	FullScreenRotatingThings_Draw:
		.import source "..\..\Intermediate\Built\FullScreenRotatingThings\Draw.asm"
		.print "* $" + toHexString(FullScreenRotatingThingsDrawASM) + "-$" + toHexString(EndFullScreenRotatingThingsDrawASM - 1) + " FullScreenRotatingThingsDrawASM"
EndFullScreenRotatingThingsDrawASM:

FullScreenRotatingThingsDataASM:
	FullScreenRotatingThings_Data:
		.import source "..\..\Intermediate\Built\FullScreenRotatingThings\Data.asm"
		.print "* $" + toHexString(FullScreenRotatingThingsDataASM) + "-$" + toHexString(EndFullScreenRotatingThingsDataASM - 1) + " FullScreenRotatingThingsDataASM"
EndFullScreenRotatingThingsDataASM:
