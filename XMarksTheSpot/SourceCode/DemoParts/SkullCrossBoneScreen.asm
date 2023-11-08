//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = SkullCrossBoneScreen_BASE "Skull & Crossbone Screen"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $60, $60					//; Pre-Init
		jmp SKULL_Init						//; Init
		.byte $60, $60, $60					//; MainThreadFunc
		jmp SKULL_Exit						//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines0
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)
	.var CharBank = 0 //; Bank+[0000,07ff]
	.var ScreenBank0 = 1 //; Bank+[0400,07ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE_Vals0 = (ScreenAddress0 + $3F8 + 0)

	.var SKULL_SinTables = $cc00
	.var SKULL_SinTableXLo = SKULL_SinTables + ($100 * 0)
	.var SKULL_SinTableXHi = SKULL_SinTables + ($100 * 1)
	.var SKULL_SinTableYLo = SKULL_SinTables + ($100 * 2)
	.var SKULL_SinTableYHi = SKULL_SinTables + ($100 * 3)

//; SKULL_LocalData -------------------------------------------------------------------------------------------------------
SKULL_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,		LoPtr,							HiPtr
		.byte	$80,			$00,		<SKULL_IRQ_VBlank,				>SKULL_IRQ_VBlank
		.byte	$ff

	.print "* $" + toHexString(SKULL_LocalData) + "-$" + toHexString(EndSKULL_LocalData - 1) + " SKULL_LocalData"

	SKULL_CharLookup:
		.byte $00, $01, $02, $03, $08, $09, $0a, $0b, $00, $01, $02, $03, $08, $09, $0a, $0b
		.byte $04, $05, $06, $07, $0c, $0d, $0e, $0f, $04, $05, $06, $07, $0c, $0d, $0e, $0f
		.byte $08, $09, $0a, $0b, $00, $01, $02, $03, $08, $09, $0a, $0b, $00, $01, $02, $03
		.byte $0c, $0d, $0e, $0f, $04, $05, $06, $07, $0c, $0d, $0e, $0f, $04, $05, $06, $07
		.byte $00, $01, $02, $03, $08, $09, $0a, $0b, $00, $01, $02, $03, $08, $09, $0a, $0b
		.byte $04, $05, $06, $07, $0c, $0d, $0e, $0f, $04, $05, $06, $07, $0c, $0d, $0e, $0f
		.byte $08, $09, $0a, $0b, $00, $01, $02, $03, $08, $09, $0a, $0b, $00, $01, $02, $03
		.byte $0c, $0d, $0e, $0f, $04, $05, $06, $07, $0c, $0d, $0e, $0f, $04, $05, $06, $07

EndSKULL_LocalData:

//; SKULL_Init() -------------------------------------------------------------------------------------------------------
SKULL_Init:

		lda #$00
		sta VIC_D011

		:IRQ_WaitForVBlank()

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta VIC_SpriteEnable
 		sta VIC_ScreenColour

		lda #DD02Value
		sta VIC_DD02
		lda #$08
		sta VIC_D016
		lda #((ScreenBank0 * 16) + (CharBank * 2))
		sta VIC_D018

		ldy #$00
		lda #$0f
	SKULL_InitScreenColours:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne SKULL_InitScreenColours

		:IRQ_WaitForVBlank()

		sei
		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		cli
		rts

		.print "* $" + toHexString(SKULL_Init) + "-$" + toHexString(EndSKULL_Init - 1) + " SKULL_Init"
EndSKULL_Init:

//; SKULL_Exit() -------------------------------------------------------------------------------------------------------
SKULL_Exit:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(SKULL_Exit) + "-$" + toHexString(EndSKULL_Exit - 1) + " SKULL_Exit"
EndSKULL_Exit:

//; SKULL_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SKULL_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 10)

		lda #$0e
		sta VIC_ScreenColour
		sta VIC_BorderColour

		:Start_ShowTiming(1)

	SKULL_SinLookup:
		ldx #$00

		lda SKULL_SinTableXHi, x
		and #$07
		sta SKULL_XScrollValue + 1

		lda SKULL_SinTableYHi, x
		and #$03
		sta SKULL_YScrollValue + 1

		lda SKULL_SinTableXLo, x
		and #$07
		sta VIC_D016

		lda SKULL_SinTableYLo, x
		and #$07
		ora #$10
		sta VIC_D011

		inc SKULL_SinLookup + 1

		jsr SKULL_Draw

		jsr Music_Play

		inc FrameOf256
		bne SKULL_NotNextFrame
		inc Signal_CurrentEffectIsFinished
	SKULL_NotNextFrame:

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(SKULL_IRQ_VBlank) + "-$" + toHexString(EndSKULL_IRQ_VBlank - 1) + " SKULL_IRQ_VBlank"
EndSKULL_IRQ_VBlank:


SKULL_Draw:

	SKULL_YScrollValue:
		lda #$00
		asl
		asl
		asl
		asl
	SKULL_XScrollValue:
		ora #$00
		tay

		.for(var YChar = 0; YChar < 4; YChar++)
		{
			.for(var XChar = 0; XChar < 8; XChar++)
			{
				lda SKULL_CharLookup + (YChar * 16) + XChar, y

				.for(var YScreen = 0; YScreen < 25; YScreen += 4)
				{
					.for(var XScreen = 0; XScreen < 40; XScreen += 8)
					{
						.var OutputX = XScreen + XChar
						.var OutputY = YScreen + YChar
						.if((OutputY >= 0) && (OutputY < 25) && (OutputX < 39))
						{
							sta ScreenAddress0 + (OutputY * 40) + OutputX
						}
					}
				}
			}
		}

		rts
