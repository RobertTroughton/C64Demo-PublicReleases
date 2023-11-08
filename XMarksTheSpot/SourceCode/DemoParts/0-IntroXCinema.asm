//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = IntroXCinema_BASE "Intro - X Cinema"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $60, $60					//; Pre-Init
		jmp XCINEMA_Init					//; Init
		.byte $60, $60, $60					//; MainThreadFunc
		jmp XCINEMA_Exit					//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines0
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)
	.var CharBank = 0 //; Bank+[0000,07ff]
	.var ScreenBank0 = 2 //; Bank+[0800,0bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE_Vals0 = (ScreenAddress0 + $3F8 + 0)

	.var XCINEMA_ColourData = $4c00

//; XCINEMA_LocalData -------------------------------------------------------------------------------------------------------
XCINEMA_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,		LoPtr,								HiPtr
		.byte	$80,			$30,		<XCINEMA_IRQ_VBlank,				>XCINEMA_IRQ_VBlank
		.byte	$ff

	.print "* $" + toHexString(XCINEMA_LocalData) + "-$" + toHexString(EndXCINEMA_LocalData - 1) + " XCINEMA_LocalData"

EndXCINEMA_LocalData:

//; XCINEMA_Init() -------------------------------------------------------------------------------------------------------
XCINEMA_Init:

		lda #$00
		sta VIC_D011

		:IRQ_WaitForVBlank()

		lda #$00
		sta VIC_SpriteEnable
	
		lda #$00
		lda #DD02Value
		sta VIC_DD02

		lda #$09
 		sta VIC_ScreenColour
		lda #$0c
		sta VIC_MultiColour0
		lda #$0b
		sta VIC_MultiColour1

		ldx #$00
		lda #$00
	XCINEMA_FillScreenColours:
		lda XCINEMA_ColourData + (0 * 256), x
		sta VIC_ColourMemory + (0 * 256), x
		lda XCINEMA_ColourData + (1 * 256), x
		sta VIC_ColourMemory + (1 * 256), x
		lda XCINEMA_ColourData + (2 * 256), x
		sta VIC_ColourMemory + (2 * 256), x
		lda XCINEMA_ColourData + (3 * 256), x
		sta VIC_ColourMemory + (3 * 256), x
		inx
		bne XCINEMA_FillScreenColours

		:IRQ_WaitForVBlank()

		lda #((ScreenBank0 * 16) + (CharBank * 2))
 		sta VIC_D018
		lda #$18
 		sta VIC_D016

		sei

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter

		lda #$1b
		sta VIC_D011

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		cli
		rts

		.print "* $" + toHexString(XCINEMA_Init) + "-$" + toHexString(EndXCINEMA_Init - 1) + " XCINEMA_Init"
EndXCINEMA_Init:

//; XCINEMA_Exit() -------------------------------------------------------------------------------------------------------
XCINEMA_Exit:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(XCINEMA_Exit) + "-$" + toHexString(EndXCINEMA_Exit - 1) + " XCINEMA_Exit"
EndXCINEMA_Exit:

//; XCINEMA_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
XCINEMA_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 10)

		:Start_ShowTiming(1)

		jsr Music_Play

		inc FrameOf256
		bne XCINEMA_NotFinished
		inc Frame_256Counter
		lda Frame_256Counter
		cmp #$02
		bne XCINEMA_NotFinished
		inc Signal_CurrentEffectIsFinished
	XCINEMA_NotFinished:

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(XCINEMA_IRQ_VBlank) + "-$" + toHexString(EndXCINEMA_IRQ_VBlank - 1) + " XCINEMA_IRQ_VBlank"
EndXCINEMA_IRQ_VBlank:
