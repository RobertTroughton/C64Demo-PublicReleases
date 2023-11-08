//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = AllBorders_BASE "AllBorders"

ALLBorders_Do:
		jsr ALLBORDERS_Init

	AllBorders_Loop:
		lda Signal_CurrentEffectIsFinished
		beq AllBorders_Loop

		jmp ALLBORDERS_Exit

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines0
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)
	.var CharBank = 0 //; Bank+[0000,07ff]
	.var ScreenBank0 = 8 //; Bank+[3000,33ff]
	.var ScreenBank1 = 9 //; Bank+[3400,37ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (BaseBankAddress + (ScreenBank1 * 1024))
	.var SPRITE_Vals0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE_Vals1 = (ScreenAddress1 + $3F8 + 0)

//; ALLBORDERS_LocalData -------------------------------------------------------------------------------------------------------
ALLBORDERS_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,		LoPtr,								HiPtr
		.byte	$80,			$30,		<ALLBORDERS_IRQ_VBlank,				>ALLBORDERS_IRQ_VBlank
	IRQList_SetBorderColour:
		.byte	$00,			$00,		<ALLBORDERS_SetBorderColour,		>ALLBORDERS_SetBorderColour
		.byte	$ff

	SCRWIPE_FinalColour:
		.byte $00
	SCRWIPE_TopColour:
		.byte $00
	SCRWIPE_BarColour:
		.byte $00
	SCRWIPE_BottomColour:
		.byte $00

	.align 16
	ALLBORDERS_Mul4Lo:
		.fill	$50, <(i * 4)
	ALLBORDERS_Mul4Hi:
		.fill	$50, (>(i * 4)) * $80

	.print "* $" + toHexString(ALLBORDERS_LocalData) + "-$" + toHexString(EndALLBORDERS_LocalData - 1) + " ALLBORDERS_LocalData"

EndALLBORDERS_LocalData:

//; ALLBORDERS_Init() -------------------------------------------------------------------------------------------------------
ALLBORDERS_Init:

		sta SCRWIPE_FinalColour
		stx SCRWIPE_BarColour
		sty ALLBORDERS_FadeDirection + 1

		cpy #$00
		bne ALLBORDERS_InitBottomToTopSwipe

	//; Top-to-Bottom
		ldy VIC_BorderColour
		jmp ALLBORDERS_FinishedWithInitialVars

	//; Bottom-to-Top
	ALLBORDERS_InitBottomToTopSwipe:
		tay
		lda VIC_BorderColour
	ALLBORDERS_FinishedWithInitialVars:

		sta SCRWIPE_TopColour
		sty SCRWIPE_BottomColour

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
		sta VIC_D011

		:IRQ_WaitForVBlank()

		lda #$00
		sta VIC_SpriteEnable
		sta IRQList_SetBorderColour + 0
		sta IRQList_SetBorderColour + 1

		lda SCRWIPE_FinalColour
 		sta VIC_ScreenColour

		sei
		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		cli
		rts

		.print "* $" + toHexString(ALLBORDERS_Init) + "-$" + toHexString(EndALLBORDERS_Init - 1) + " ALLBORDERS_Init"
EndALLBORDERS_Init:

//; ALLBORDERS_Exit() -------------------------------------------------------------------------------------------------------
ALLBORDERS_Exit:

		:IRQManager_RestoreDefault(1, 0)

		rts

		.print "* $" + toHexString(ALLBORDERS_Exit) + "-$" + toHexString(EndALLBORDERS_Exit - 1) + " ALLBORDERS_Exit"
EndALLBORDERS_Exit:

//; ALLBORDERS_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
ALLBORDERS_IRQ_VBlank:

		:IRQManager_BeginIRQ(1, 10)

		:Start_ShowTiming(1)

		lda SCRWIPE_TopColour
		sta VIC_BorderColour

		lda Signal_CurrentEffectIsFinished
		bne ALLBORDERS_Finished

		lda FrameOf256
		cmp #$47
		bne ALLBORDERS_NotFinishedPart

		inc Signal_CurrentEffectIsFinished

		lda SCRWIPE_FinalColour
		sta SCRWIPE_TopColour
		sta SCRWIPE_BarColour
		sta SCRWIPE_BottomColour

		jmp ALLBORDERS_Finished

	ALLBORDERS_NotFinishedPart:
	ALLBORDERS_FadeDirection:
		lda #$00
		beq ALLBORDERS_TopToBottom

	ALLBORDERS_BottomToTop:
		lda #$46
		sec
		sbc FrameOf256
		jmp ALLBORDERS_DoSetBorder

	ALLBORDERS_TopToBottom:
		lda FrameOf256
	ALLBORDERS_DoSetBorder:
		tax
		lda ALLBORDERS_Mul4Lo, x
		sta IRQList_SetBorderColour + 1
		lda ALLBORDERS_Mul4Hi, x
		sta IRQList_SetBorderColour + 0

	ALLBORDERS_Finished:
		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(ALLBORDERS_IRQ_VBlank) + "-$" + toHexString(EndALLBORDERS_IRQ_VBlank - 1) + " ALLBORDERS_IRQ_VBlank"
EndALLBORDERS_IRQ_VBlank:

ALLBORDERS_SetBorderColour:
		:IRQManager_BeginIRQ(1, 10)

		nop
		lda SCRWIPE_BarColour
		sta VIC_BorderColour
		
		ldx #$16
	ALLBORDERS_Wait:
		dex
		bpl ALLBORDERS_Wait
		nop
		nop

		lda SCRWIPE_BottomColour
		sta VIC_BorderColour

		jsr Music_Play

		inc FrameOf256

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(ALLBORDERS_SetBorderColour) + "-$" + toHexString(EndALLBORDERS_SetBorderColour - 1) + " ALLBORDERS_SetBorderColour"
EndALLBORDERS_SetBorderColour:
