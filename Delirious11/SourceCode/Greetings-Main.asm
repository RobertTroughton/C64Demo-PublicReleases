//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var GREET_SinTable = $3b00
	.var GREET_SinTable_YVals		= GREET_SinTable + $0
	.var GREET_SinTable_Priority	= GREET_SinTable + $100
	.var GREET_SinTable_XVals		= GREET_SinTable + $200
	.var GREET_SinTable_XMSB		= GREET_SinTable + $300
	.var GREET_SinTable_Colour		= GREET_SinTable + $400
	
	.var GREET_HelixOutputColourData = $d800

	.var ScreenBank = 0 // 7 //; 7=Bank+[1c00,1fff]
	.var BitmapBank = 1 //; 1=Bank+[2000,3fff]
	
	.var GREET_BaseBank0 = 2
	.var GREET_BaseBank0_Addr = $c000 - $4000 * GREET_BaseBank0
	.var GREET_SpriteData0 = GREET_BaseBank0_Addr + (64 * 64)
	.var GREET_HelixOutputBitmapData0 = GREET_BaseBank0_Addr + (BitmapBank * $2000)
	.var GREET_HelixOutputScreenData0 = GREET_BaseBank0_Addr + (ScreenBank * $400)
	.var SPRITE0_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (GREET_HelixOutputScreenData0 + $3F8 + 7)

	.var GREET_BaseBank1 = 0
	.var GREET_BaseBank1_Addr = $c000 - $4000 * GREET_BaseBank1
	.var GREET_SpriteData1 = GREET_BaseBank1_Addr + (64 * 64)
	.var GREET_HelixOutputBitmapData1 = GREET_BaseBank1_Addr + (BitmapBank * $2000)
	.var GREET_HelixOutputScreenData1 = GREET_BaseBank1_Addr + (ScreenBank * $400)
	.var SPRITE0_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 0)
	.var SPRITE1_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 1)
	.var SPRITE2_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 2)
	.var SPRITE3_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 3)
	.var SPRITE4_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 4)
	.var SPRITE5_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 5)
	.var SPRITE6_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 6)
	.var SPRITE7_Val_Bank1 = (GREET_HelixOutputScreenData1 + $3F8 + 7)

* = Greetings_BASE "Greetings"

	JumpTable:
		jmp GREET_Init
		jmp GREET_End
		jmp GREET_MainThread
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; GREET_LocalData -------------------------------------------------------------------------------------------------------
GREET_LocalData:
	.var IRQNum = 5
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$f7,			<GREET_IRQ_BottomBorder,		>GREET_IRQ_BottomBorder
		.byte	$00,			$fd,			<GREET_IRQ_BottomBorder2,		>GREET_IRQ_BottomBorder2
		.byte	$80,			$18,			<GREET_IRQ_VBlank,				>GREET_IRQ_VBlank
	IRQ_Plex0:
		.byte	$00,			$73,			<GREET_IRQ_SpritePlex0,			>GREET_IRQ_SpritePlex0
	IRQ_Plex1:
		.byte	$00,			$ac,			<GREET_IRQ_SpritePlex1,			>GREET_IRQ_SpritePlex1
		
	GREET_CurrentBank:
		.byte $01
	
	GREET_DD02_Values:
		.byte $3d, $3f

	GREET_SpriteFirstIndex:
		.byte $00

	GREET_SpritePositions:
		.byte $30, $60
		.byte $48, $60
		.byte $60, $60
		.byte $78, $60
		.byte $90, $60
		.byte $a8, $60
		.byte $c0, $60
		.byte $d8, $60
	
	GREET_XScrollLookup:
		.byte (0 * 3), (1 * 3), (2 * 3), (3 * 3), (4 * 3), (5 * 3), (6 * 3), (7 * 3)

	GREET_SpriteXCoordsLo:
		.fill 16, 0
		.fill 16, 0
		
	GREET_SpriteXCoordsHi:
		.fill 16, 0
		.fill 16, 0
		
	GREET_SpriteVals:
		.fill 16, $40
		.fill 16, $40
		
	GREET_Mul3:
		.byte ( 0 * 3), ( 1 * 3), ( 2 * 3), ( 3 * 3), ( 4 * 3), ( 5 * 3), ( 6 * 3), ( 7 * 3)
		.byte ( 8 * 3), ( 9 * 3), (10 * 3), (11 * 3), (12 * 3), (13 * 3), (14 * 3), (15 * 3)
		
	Sprite0MSB:
		.byte $00, $01
	Sprite1MSB:
		.byte $00, $02
	Sprite2MSB:
		.byte $00, $04
	Sprite3MSB:
		.byte $00, $08
	Sprite4MSB:
		.byte $00, $10
	Sprite5MSB:
		.byte $00, $20
	Sprite6MSB:
		.byte $00, $40
	Sprite7MSB:
		.byte $00, $80
		
	GREET_WavePost_Mod128:
		.byte $00
	GREET_WavePost_Mod16:
		.byte $00
	GREET_WavePost_Mod8:
		.byte $00
		
	GREET_ShouldUpdateBitmap:
		.byte $00
	GREET_DrawFrame:
		.byte $00
	GREET_ScrollAmount:
		.byte $00

GREET_Mod4Mul8:
	.byte $00, $08, $10, $18, $00, $08, $10, $18, $00, $08, $10, $18, $00, $08, $10, $18
GREET_11SubMul2:
	.byte 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0
GREET_INCMod12:
	.byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0
GREET_ColourCopyJumps:
	.byte <Helix_ColLine0, >Helix_ColLine0
	.byte <Helix_ColLine1, >Helix_ColLine1
	.byte <Helix_ColLine2, >Helix_ColLine2
	.byte <Helix_ColLine3, >Helix_ColLine3
	.byte <Helix_ColLine4, >Helix_ColLine4
	.byte <Helix_ColLine5, >Helix_ColLine5
	.byte <Helix_ColLine6, >Helix_ColLine6
	.byte <Helix_ColLine7, >Helix_ColLine7
	.byte <Helix_ColLine8, >Helix_ColLine8
	.byte <Helix_ColLine9, >Helix_ColLine9
	.byte <Helix_ColLine10, >Helix_ColLine10
	.byte <Helix_ColLine11, >Helix_ColLine11
	.byte <Helix_ColLine12, >Helix_ColLine12
	.byte <Helix_ColLine13, >Helix_ColLine13
	.byte <Helix_ColLine14, >Helix_ColLine14
	.byte <Helix_ColLine15, >Helix_ColLine15
	.byte <Helix_ColLine16, >Helix_ColLine16
	.byte <Helix_ColLine17, >Helix_ColLine17
	.byte <Helix_ColLine18, >Helix_ColLine18
	.byte <Helix_ColLine19, >Helix_ColLine19
	.byte <Helix_ColLine20, >Helix_ColLine20
	.byte <Helix_ColLine21, >Helix_ColLine21
	.byte <Helix_ColLine22, >Helix_ColLine22
	.byte <Helix_ColLine23, >Helix_ColLine23
	.byte <Helix_ColLine24, >Helix_ColLine24
	.byte <Helix_ColLine25, >Helix_ColLine25
	.byte <Helix_ColLine26, >Helix_ColLine26
	.byte <Helix_ColLine27, >Helix_ColLine27
	.byte <Helix_ColLine28, >Helix_ColLine28
	.byte <Helix_ColLine29, >Helix_ColLine29
	.byte <Helix_ColLine30, >Helix_ColLine30
	.byte <Helix_ColLine31, >Helix_ColLine31
	.byte <Helix_ColLine32, >Helix_ColLine32
	.byte <Helix_ColLine33, >Helix_ColLine33
	.byte <Helix_ColLine34, >Helix_ColLine34
	.byte <Helix_ColLine35, >Helix_ColLine35
	.byte <Helix_ColLine36, >Helix_ColLine36
	.byte <Helix_ColLine37, >Helix_ColLine37
	.byte <Helix_ColLine38, >Helix_ColLine38
	.byte <Helix_ColLine39, >Helix_ColLine39
	.byte <Helix_ColLine40, >Helix_ColLine40
	.byte <Helix_ColLine41, >Helix_ColLine41
	.byte <Helix_ColLine42, >Helix_ColLine42
	.byte <Helix_ColLine43, >Helix_ColLine43
	.byte <Helix_ColLine44, >Helix_ColLine44
	.byte <Helix_ColLine45, >Helix_ColLine45
	.byte <Helix_ColLine46, >Helix_ColLine46
	.byte <Helix_ColLine47, >Helix_ColLine47
	.byte <Helix_ColLine48, >Helix_ColLine48
	.byte <Helix_ColLine49, >Helix_ColLine49
	.byte <Helix_ColLine50, >Helix_ColLine50
	.byte <Helix_ColLine_FIN, >Helix_ColLine_FIN
GREET_ScreenCopyJumps_Bank0:
	.byte <Helix_ScrLine0_Bank0, >Helix_ScrLine0_Bank0
	.byte <Helix_ScrLine1_Bank0, >Helix_ScrLine1_Bank0
	.byte <Helix_ScrLine2_Bank0, >Helix_ScrLine2_Bank0
	.byte <Helix_ScrLine3_Bank0, >Helix_ScrLine3_Bank0
	.byte <Helix_ScrLine4_Bank0, >Helix_ScrLine4_Bank0
	.byte <Helix_ScrLine5_Bank0, >Helix_ScrLine5_Bank0
	.byte <Helix_ScrLine6_Bank0, >Helix_ScrLine6_Bank0
	.byte <Helix_ScrLine7_Bank0, >Helix_ScrLine7_Bank0
	.byte <Helix_ScrLine8_Bank0, >Helix_ScrLine8_Bank0
	.byte <Helix_ScrLine9_Bank0, >Helix_ScrLine9_Bank0
	.byte <Helix_ScrLine10_Bank0, >Helix_ScrLine10_Bank0
	.byte <Helix_ScrLine11_Bank0, >Helix_ScrLine11_Bank0
	.byte <Helix_ScrLine12_Bank0, >Helix_ScrLine12_Bank0
	.byte <Helix_ScrLine13_Bank0, >Helix_ScrLine13_Bank0
	.byte <Helix_ScrLine14_Bank0, >Helix_ScrLine14_Bank0
	.byte <Helix_ScrLine15_Bank0, >Helix_ScrLine15_Bank0
	.byte <Helix_ScrLine16_Bank0, >Helix_ScrLine16_Bank0
	.byte <Helix_ScrLine17_Bank0, >Helix_ScrLine17_Bank0
	.byte <Helix_ScrLine18_Bank0, >Helix_ScrLine18_Bank0
	.byte <Helix_ScrLine19_Bank0, >Helix_ScrLine19_Bank0
	.byte <Helix_ScrLine20_Bank0, >Helix_ScrLine20_Bank0
	.byte <Helix_ScrLine21_Bank0, >Helix_ScrLine21_Bank0
	.byte <Helix_ScrLine22_Bank0, >Helix_ScrLine22_Bank0
	.byte <Helix_ScrLine23_Bank0, >Helix_ScrLine23_Bank0
	.byte <Helix_ScrLine24_Bank0, >Helix_ScrLine24_Bank0
	.byte <Helix_ScrLine25_Bank0, >Helix_ScrLine25_Bank0
	.byte <Helix_ScrLine26_Bank0, >Helix_ScrLine26_Bank0
	.byte <Helix_ScrLine27_Bank0, >Helix_ScrLine27_Bank0
	.byte <Helix_ScrLine28_Bank0, >Helix_ScrLine28_Bank0
	.byte <Helix_ScrLine29_Bank0, >Helix_ScrLine29_Bank0
	.byte <Helix_ScrLine30_Bank0, >Helix_ScrLine30_Bank0
	.byte <Helix_ScrLine31_Bank0, >Helix_ScrLine31_Bank0
	.byte <Helix_ScrLine32_Bank0, >Helix_ScrLine32_Bank0
	.byte <Helix_ScrLine33_Bank0, >Helix_ScrLine33_Bank0
	.byte <Helix_ScrLine34_Bank0, >Helix_ScrLine34_Bank0
	.byte <Helix_ScrLine35_Bank0, >Helix_ScrLine35_Bank0
	.byte <Helix_ScrLine36_Bank0, >Helix_ScrLine36_Bank0
	.byte <Helix_ScrLine37_Bank0, >Helix_ScrLine37_Bank0
	.byte <Helix_ScrLine38_Bank0, >Helix_ScrLine38_Bank0
	.byte <Helix_ScrLine39_Bank0, >Helix_ScrLine39_Bank0
	.byte <Helix_ScrLine40_Bank0, >Helix_ScrLine40_Bank0
	.byte <Helix_ScrLine41_Bank0, >Helix_ScrLine41_Bank0
	.byte <Helix_ScrLine42_Bank0, >Helix_ScrLine42_Bank0
	.byte <Helix_ScrLine43_Bank0, >Helix_ScrLine43_Bank0
	.byte <Helix_ScrLine44_Bank0, >Helix_ScrLine44_Bank0
	.byte <Helix_ScrLine45_Bank0, >Helix_ScrLine45_Bank0
	.byte <Helix_ScrLine46_Bank0, >Helix_ScrLine46_Bank0
	.byte <Helix_ScrLine47_Bank0, >Helix_ScrLine47_Bank0
	.byte <Helix_ScrLine48_Bank0, >Helix_ScrLine48_Bank0
	.byte <Helix_ScrLine49_Bank0, >Helix_ScrLine49_Bank0
	.byte <Helix_ScrLine50_Bank0, >Helix_ScrLine50_Bank0
	.byte <Helix_ScrLine_FIN_Bank0, >Helix_ScrLine_FIN_Bank0
GREET_ScreenCopyJumps_Bank1:
	.byte <Helix_ScrLine0_Bank1, >Helix_ScrLine0_Bank1
	.byte <Helix_ScrLine1_Bank1, >Helix_ScrLine1_Bank1
	.byte <Helix_ScrLine2_Bank1, >Helix_ScrLine2_Bank1
	.byte <Helix_ScrLine3_Bank1, >Helix_ScrLine3_Bank1
	.byte <Helix_ScrLine4_Bank1, >Helix_ScrLine4_Bank1
	.byte <Helix_ScrLine5_Bank1, >Helix_ScrLine5_Bank1
	.byte <Helix_ScrLine6_Bank1, >Helix_ScrLine6_Bank1
	.byte <Helix_ScrLine7_Bank1, >Helix_ScrLine7_Bank1
	.byte <Helix_ScrLine8_Bank1, >Helix_ScrLine8_Bank1
	.byte <Helix_ScrLine9_Bank1, >Helix_ScrLine9_Bank1
	.byte <Helix_ScrLine10_Bank1, >Helix_ScrLine10_Bank1
	.byte <Helix_ScrLine11_Bank1, >Helix_ScrLine11_Bank1
	.byte <Helix_ScrLine12_Bank1, >Helix_ScrLine12_Bank1
	.byte <Helix_ScrLine13_Bank1, >Helix_ScrLine13_Bank1
	.byte <Helix_ScrLine14_Bank1, >Helix_ScrLine14_Bank1
	.byte <Helix_ScrLine15_Bank1, >Helix_ScrLine15_Bank1
	.byte <Helix_ScrLine16_Bank1, >Helix_ScrLine16_Bank1
	.byte <Helix_ScrLine17_Bank1, >Helix_ScrLine17_Bank1
	.byte <Helix_ScrLine18_Bank1, >Helix_ScrLine18_Bank1
	.byte <Helix_ScrLine19_Bank1, >Helix_ScrLine19_Bank1
	.byte <Helix_ScrLine20_Bank1, >Helix_ScrLine20_Bank1
	.byte <Helix_ScrLine21_Bank1, >Helix_ScrLine21_Bank1
	.byte <Helix_ScrLine22_Bank1, >Helix_ScrLine22_Bank1
	.byte <Helix_ScrLine23_Bank1, >Helix_ScrLine23_Bank1
	.byte <Helix_ScrLine24_Bank1, >Helix_ScrLine24_Bank1
	.byte <Helix_ScrLine25_Bank1, >Helix_ScrLine25_Bank1
	.byte <Helix_ScrLine26_Bank1, >Helix_ScrLine26_Bank1
	.byte <Helix_ScrLine27_Bank1, >Helix_ScrLine27_Bank1
	.byte <Helix_ScrLine28_Bank1, >Helix_ScrLine28_Bank1
	.byte <Helix_ScrLine29_Bank1, >Helix_ScrLine29_Bank1
	.byte <Helix_ScrLine30_Bank1, >Helix_ScrLine30_Bank1
	.byte <Helix_ScrLine31_Bank1, >Helix_ScrLine31_Bank1
	.byte <Helix_ScrLine32_Bank1, >Helix_ScrLine32_Bank1
	.byte <Helix_ScrLine33_Bank1, >Helix_ScrLine33_Bank1
	.byte <Helix_ScrLine34_Bank1, >Helix_ScrLine34_Bank1
	.byte <Helix_ScrLine35_Bank1, >Helix_ScrLine35_Bank1
	.byte <Helix_ScrLine36_Bank1, >Helix_ScrLine36_Bank1
	.byte <Helix_ScrLine37_Bank1, >Helix_ScrLine37_Bank1
	.byte <Helix_ScrLine38_Bank1, >Helix_ScrLine38_Bank1
	.byte <Helix_ScrLine39_Bank1, >Helix_ScrLine39_Bank1
	.byte <Helix_ScrLine40_Bank1, >Helix_ScrLine40_Bank1
	.byte <Helix_ScrLine41_Bank1, >Helix_ScrLine41_Bank1
	.byte <Helix_ScrLine42_Bank1, >Helix_ScrLine42_Bank1
	.byte <Helix_ScrLine43_Bank1, >Helix_ScrLine43_Bank1
	.byte <Helix_ScrLine44_Bank1, >Helix_ScrLine44_Bank1
	.byte <Helix_ScrLine45_Bank1, >Helix_ScrLine45_Bank1
	.byte <Helix_ScrLine46_Bank1, >Helix_ScrLine46_Bank1
	.byte <Helix_ScrLine47_Bank1, >Helix_ScrLine47_Bank1
	.byte <Helix_ScrLine48_Bank1, >Helix_ScrLine48_Bank1
	.byte <Helix_ScrLine49_Bank1, >Helix_ScrLine49_Bank1
	.byte <Helix_ScrLine50_Bank1, >Helix_ScrLine50_Bank1
	.byte <Helix_ScrLine_FIN_Bank1, >Helix_ScrLine_FIN_Bank1

	.print "* $" + toHexString(GREET_LocalData) + "-$" + toHexString(EndGREET_LocalData - 1) + " GREET_LocalData"
	
EndGREET_LocalData:

//; GREET_Init() -------------------------------------------------------------------------------------------------------
GREET_Init:

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta spriteDoubleWidth	//; make no sprites double-width
		sta spriteDrawPriority
		sta spriteXMSB
		sta spriteMulticolorMode
		
		lda #$10
		sta ValueD016
		
		lda #$00
		sta $D021
		sta ValueD021

		ldx GREET_CurrentBank
		lda GREET_DD02_Values,x
		sta ValueDD02
		
		ldy #$07
		lda #$01
	GREET_SetupSprites:
		sta SPRITE0_Color,y
		dey
		bpl GREET_SetupSprites
		
		lda #$ff
		sta spriteDoubleHeight	//; make all sprites double-height
		
		jsr GREET_InitializeBitmap

		lda #$3b
		sta ValueD011
		lda #((ScreenBank * 16) + (BitmapBank * 8))
 		sta $d018
		
		sei
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(GREET_Init) + "-$" + toHexString(EndGREET_Init - 1) + " GREET_Init"
EndGREET_Init:

//; GREET_End() -------------------------------------------------------------------------------------------------------
GREET_End:
		lda #$00
		sta ValueD011
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(GREET_End) + "-$" + toHexString(EndGREET_End - 1) + " GREET_End"
EndGREET_End:

//; GREET_IRQ_BottomBorder() -------------------------------------------------------------------------------------------------------
GREET_IRQ_BottomBorder:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #$f9
	GREET_VBWaitF9:
		cmp $d012
		bne GREET_VBWaitF9
		
		lda ValueD011
		and #$f7
		sta $d011
		
		.if(ShowTimings)
		{
			inc $d020
		}

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_BottomBorder) + "-$" + toHexString(EndGREET_IRQ_BottomBorder - 1) + " GREET_IRQ_BottomBorder"
EndGREET_IRQ_BottomBorder:
		
//; GREET_IRQ_BottomBorder2() -------------------------------------------------------------------------------------------------------
GREET_IRQ_BottomBorder2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #$ff
	GREET_VBWaitFF:
		cmp $d012
		bne GREET_VBWaitFF
		
		lda ValueD011
 		sta $d011

//;		jsr Music_Play
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_BottomBorder2) + "-$" + toHexString(EndGREET_IRQ_BottomBorder2 - 1) + " GREET_IRQ_BottomBorder2"
EndGREET_IRQ_BottomBorder2:

//; GREET_IRQ_SpriteEnable() -------------------------------------------------------------------------------------------------------
GREET_IRQ_SpriteEnable:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #$ff
		sta spriteEnable

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_SpriteEnable) + "-$" + toHexString(EndGREET_IRQ_SpriteEnable - 1) + " GREET_IRQ_SpriteEnable"
EndGREET_IRQ_SpriteEnable:

//; GREET_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
GREET_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		dec GREET_WavePost_Mod128
		lda GREET_WavePost_Mod128
		and #$7f
		sta GREET_WavePost_Mod128
		
		lda GREET_WavePost_Mod8
		clc
		adc #$02
		and #$07
		sta GREET_WavePost_Mod8
		tax
		ora ValueD016
		sta $d016
		lda #$00
		cpx #$00
		bne GREET_DontScrollHelix

		lda GREET_CurrentBank
		tax
		eor #$01
		sta GREET_CurrentBank
		lda GREET_DD02_Values,x
		sta $dd02

	//; Update colour memory
		lda #$60
	GREET_ColCodeInject1:
		sta $ffff

		GREET_ReloadY2:
		ldy #$00
	GREET_ColJumpAddress:
		jsr GREET_SafeReturn

		lda #$a9
	GREET_ColCodeInject2:
		sta $ffff

		lda #$01
		
	GREET_DontScrollHelix:
		sta GREET_ShouldUpdateBitmap
		
		lda GREET_WavePost_Mod16
		clc
		adc #$01
		and #$0f
		sta GREET_WavePost_Mod16
		cmp #$00
		bne GREET_SkipUpdates
		
		lda GREET_SpriteFirstIndex
		sec
		sbc #$02
		and #$0f
		sta GREET_SpriteFirstIndex
		
	GREET_ScrollTextPointer:
		lda GREET_ScrollText
		cmp #$ff
		bne GREET_NotEndOfScrollText
		inc Signal_CurrentEffectIsFinished
		lda #<GREET_ScrollText
		sta GREET_ScrollTextPointer + 1
		lda #>GREET_ScrollText
		sta GREET_ScrollTextPointer + 2
		lda #$00
	GREET_NotEndOfScrollText:
		tay
		lda GREET_SpriteFirstIndex
		eor #$0e
		tax
		tya
		asl
		ora #$40
		sta GREET_SpriteVals,x
		sta GREET_SpriteVals + 16,x
		clc
		adc #$01
		sta GREET_SpriteVals + 1,x
		sta GREET_SpriteVals + 17,x
		
		inc GREET_ScrollTextPointer + 1
		bne GREET_SkipUpdates
		inc GREET_ScrollTextPointer + 2
	GREET_SkipUpdates:

	GREET_Wave:
		ldx GREET_WavePost_Mod128
		.for (var SpriteXIndex = 0; SpriteXIndex < 16; SpriteXIndex++)
		{
			lda GREET_SinTable_XVals + SpriteXIndex * 8,x
			sta GREET_SpriteXCoordsLo + SpriteXIndex
			sta GREET_SpriteXCoordsLo + SpriteXIndex + 16
			lda GREET_SinTable_XMSB + SpriteXIndex * 8,x
			sta GREET_SpriteXCoordsHi + SpriteXIndex
			sta GREET_SpriteXCoordsHi + SpriteXIndex + 16
		}
	
		ldx GREET_WavePost_Mod16
		lda GREET_SinTable_YVals + (12 * 8),x
		sta $d001
		sta $d003
		clc
		adc #42
		sta IRQ_Plex1 + 1

		lda GREET_SinTable_YVals + (14 * 8),x
		sta $d005
		sta $d007
		clc
		adc #42
		sta IRQ_Plex0 + 1
	GREET_PLEX0OK:

		lda GREET_SinTable_YVals + (0 * 8),x
		sta $d009
		sta $d00b
		clc
		adc #42
		cmp IRQ_Plex0 + 1
		bcc GREET_PLEX1OK
		sta IRQ_Plex0 + 1
	GREET_PLEX1OK:

		lda GREET_SinTable_YVals + (2 * 8),x
		sta $d00d
		sta $d00f
		clc
		adc #42
		cmp IRQ_Plex1 + 1
		bcc GREET_PLEX2OK
		sta IRQ_Plex1 + 1
	GREET_PLEX2OK:

		lda GREET_SinTable_Colour + (12 * 8),x
		sta SPRITE0_Color
		sta SPRITE1_Color
		lda GREET_SinTable_Colour + (14 * 8),x
		sta SPRITE2_Color
		sta SPRITE3_Color
		lda GREET_SinTable_Colour + (0 * 8),x
		sta SPRITE4_Color
		sta SPRITE5_Color
		lda GREET_SinTable_Colour + (2 * 8),x
		sta SPRITE6_Color
		sta SPRITE7_Color

		ldy GREET_SinTable_Priority + (12 * 8),x
		lda Sprite0MSB,y
		ora Sprite1MSB,y
		ldy GREET_SinTable_Priority + (14 * 8),x
		ora Sprite2MSB,y
		ora Sprite3MSB,y
		ldy GREET_SinTable_Priority + (0 * 8),x
		ora Sprite4MSB,y
		ora Sprite5MSB,y
		ldy GREET_SinTable_Priority + (2 * 8),x
		ora Sprite6MSB,y
		ora Sprite7MSB,y
		sta spriteDrawPriority

		ldx GREET_SpriteFirstIndex
		lda GREET_SpriteXCoordsLo + 12,x
		sta $d000
		lda GREET_SpriteXCoordsLo + 13,x
		sta $d002
		lda GREET_SpriteXCoordsLo + 14,x
		sta $d004
		lda GREET_SpriteXCoordsLo + 15,x
		sta $d006
		lda GREET_SpriteXCoordsLo + 0,x
		sta $d008
		lda GREET_SpriteXCoordsLo + 1,x
		sta $d00a
		lda GREET_SpriteXCoordsLo + 2,x
		sta $d00c
		lda GREET_SpriteXCoordsLo + 3,x
		sta $d00e
		
		ldy GREET_SpriteXCoordsHi + 12,x
		lda Sprite0MSB,y
		ldy GREET_SpriteXCoordsHi + 13,x
		ora Sprite1MSB,y
		ldy GREET_SpriteXCoordsHi + 14,x
		ora Sprite2MSB,y
		ldy GREET_SpriteXCoordsHi + 15,x
		ora Sprite3MSB,y
		ldy GREET_SpriteXCoordsHi + 0,x
		ora Sprite4MSB,y
		ldy GREET_SpriteXCoordsHi + 1,x
		ora Sprite5MSB,y
		ldy GREET_SpriteXCoordsHi + 2,x
		ora Sprite6MSB,y
		ldy GREET_SpriteXCoordsHi + 3,x
		ora Sprite7MSB,y
		sta spriteXMSB

		ldx GREET_SpriteFirstIndex
		lda GREET_SpriteVals + 12,x
		sta SPRITE0_Val_Bank0
		sta SPRITE0_Val_Bank1
		lda GREET_SpriteVals + 13,x
		sta SPRITE1_Val_Bank0
		sta SPRITE1_Val_Bank1
		lda GREET_SpriteVals + 14,x
		sta SPRITE2_Val_Bank0
		sta SPRITE2_Val_Bank1
		lda GREET_SpriteVals + 15,x
		sta SPRITE3_Val_Bank0
		sta SPRITE3_Val_Bank1
		lda GREET_SpriteVals + 0,x
		sta SPRITE4_Val_Bank0
		sta SPRITE4_Val_Bank1
		lda GREET_SpriteVals + 1,x
		sta SPRITE5_Val_Bank0
		sta SPRITE5_Val_Bank1
		lda GREET_SpriteVals + 2,x
		sta SPRITE6_Val_Bank0
		sta SPRITE6_Val_Bank1
		lda GREET_SpriteVals + 3,x
		sta SPRITE7_Val_Bank0
		sta SPRITE7_Val_Bank1
		
		lda #$ff
		sta spriteEnable
		
		jsr Music_Play

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:
	
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_VBlank) + "-$" + toHexString(EndGREET_IRQ_VBlank - 1) + " GREET_IRQ_VBlank"
EndGREET_IRQ_VBlank:

//; GREET_IRQ_SpritePlex0() -------------------------------------------------------------------------------------------------------
GREET_IRQ_SpritePlex0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx GREET_WavePost_Mod16
		lda GREET_SinTable_YVals + (10 * 8),x
		sta $d005
		sta $d007
		lda GREET_SinTable_YVals + (4 * 8),x
		sta $d009
		sta $d00b

		lda GREET_SinTable_Colour + (10 * 8),x
		sta SPRITE2_Color
		sta SPRITE3_Color
		lda GREET_SinTable_Colour + (4 * 8),x
		sta SPRITE4_Color
		sta SPRITE5_Color
		
		lda spriteDrawPriority
		and #$c3
		ldy GREET_SinTable_Priority + (10 * 8),x
		ora Sprite2MSB,y
		ora Sprite3MSB,y
		ldy GREET_SinTable_Priority + (4 * 8),x
		ora Sprite4MSB,y
		ora Sprite5MSB,y
		sta spriteDrawPriority

		ldx GREET_SpriteFirstIndex
		lda GREET_SpriteXCoordsLo + 10,x
		sta $d004
		lda GREET_SpriteXCoordsLo + 11,x
		sta $d006
		lda GREET_SpriteXCoordsLo + 4,x
		sta $d008
		lda GREET_SpriteXCoordsLo + 5,x
		sta $d00a

		lda spriteXMSB
		and #$c3
		ldy GREET_SpriteXCoordsHi + 10,x
		ora Sprite2MSB,y
		ldy GREET_SpriteXCoordsHi + 11,x
		ora Sprite3MSB,y
		ldy GREET_SpriteXCoordsHi + 4,x
		ora Sprite4MSB,y
		ldy GREET_SpriteXCoordsHi + 5,x
		ora Sprite5MSB,y
		sta spriteXMSB

		lda GREET_SpriteVals + 10,x
		sta SPRITE2_Val_Bank0
		sta SPRITE2_Val_Bank1
		lda GREET_SpriteVals + 11,x
		sta SPRITE3_Val_Bank0
		sta SPRITE3_Val_Bank1
		lda GREET_SpriteVals + 4,x
		sta SPRITE4_Val_Bank0
		sta SPRITE4_Val_Bank1
		lda GREET_SpriteVals + 5,x
		sta SPRITE5_Val_Bank0
		sta SPRITE5_Val_Bank1

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_SpritePlex0) + "-$" + toHexString(EndGREET_IRQ_SpritePlex0 - 1) + " GREET_IRQ_SpritePlex0"
EndGREET_IRQ_SpritePlex0:

//; GREET_IRQ_SpritePlex1() -------------------------------------------------------------------------------------------------------
GREET_IRQ_SpritePlex1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx GREET_WavePost_Mod16
		lda GREET_SinTable_YVals + (8 * 8),x
		sta $d001
		sta $d003
		lda GREET_SinTable_YVals + (6 * 8),x
		sta $d00d
		sta $d00f

		lda GREET_SinTable_Colour + (8 * 8),x
		sta SPRITE0_Color
		sta SPRITE1_Color
		lda GREET_SinTable_Colour + (6 * 8),x
		sta SPRITE6_Color
		sta SPRITE7_Color

		lda spriteDrawPriority
		and #$3c
		ldy GREET_SinTable_Priority + (8 * 8),x
		ora Sprite0MSB,y
		ora Sprite1MSB,y
		ldy GREET_SinTable_Priority + (6 * 8),x
		ora Sprite6MSB,y
		ora Sprite7MSB,y
		sta spriteDrawPriority

		ldx GREET_SpriteFirstIndex
		lda GREET_SpriteXCoordsLo + 8,x
		sta $d000
		lda GREET_SpriteXCoordsLo + 9,x
		sta $d002
		lda GREET_SpriteXCoordsLo + 6,x
		sta $d00c
		lda GREET_SpriteXCoordsLo + 7,x
		sta $d00e

		lda spriteXMSB
		and #$3c
		ldy GREET_SpriteXCoordsHi + 8,x
		ora Sprite0MSB,y
		ldy GREET_SpriteXCoordsHi + 9,x
		ora Sprite1MSB,y
		ldy GREET_SpriteXCoordsHi + 6,x
		ora Sprite6MSB,y
		ldy GREET_SpriteXCoordsHi + 7,x
		ora Sprite7MSB,y
		sta spriteXMSB

		lda GREET_SpriteVals + 8,x
		sta SPRITE0_Val_Bank0
		sta SPRITE0_Val_Bank1
		lda GREET_SpriteVals + 9,x
		sta SPRITE1_Val_Bank0
		sta SPRITE1_Val_Bank1
		lda GREET_SpriteVals + 6,x
		sta SPRITE6_Val_Bank0
		sta SPRITE6_Val_Bank1
		lda GREET_SpriteVals + 7,x
		sta SPRITE7_Val_Bank0
		sta SPRITE7_Val_Bank1

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(GREET_IRQ_SpritePlex1) + "-$" + toHexString(EndGREET_IRQ_SpritePlex1 - 1) + " GREET_IRQ_SpritePlex1"
EndGREET_IRQ_SpritePlex1:

//; GREET_InitializeBitmap() -------------------------------------------------------------------------------------------------------
GREET_InitializeBitmap:

		ldy #$1f
		ldx #$00
		lda #$00
	GREET_ClearBitmapData0:
		sta GREET_HelixOutputBitmapData0,x
	GREET_ClearBitmapData1:
		sta GREET_HelixOutputBitmapData1,x
		inx
		bne GREET_ClearBitmapData0
		inc GREET_ClearBitmapData0 + 2
		inc GREET_ClearBitmapData1 + 2
		dey
		bne GREET_ClearBitmapData0

		ldx #$00
		lda #$00
	GREET_ClearBitmapDataLastLine:
		sta GREET_HelixOutputBitmapData0 + $1f00,x
		sta GREET_HelixOutputBitmapData1 + $1f00,x
		inx
		cpx #$40
		bne GREET_ClearBitmapDataLastLine
	
		ldx #$00
		lda #$00
	GREET_ClearScreenColours:
		sta GREET_HelixOutputColourData + (256 * 0),x
		sta GREET_HelixOutputColourData + (256 * 1),x
		sta GREET_HelixOutputColourData + (256 * 2),x
		sta GREET_HelixOutputColourData + (1000 - 256),x
		sta GREET_HelixOutputScreenData0 + (256 * 0),x
		sta GREET_HelixOutputScreenData0 + (256 * 1),x
		sta GREET_HelixOutputScreenData0 + (256 * 2),x
		sta GREET_HelixOutputScreenData0 + (1000 - 256),x
		inx
		bne GREET_ClearScreenColours
		
		rts
		
		.print "* $" + toHexString(GREET_InitializeBitmap) + "-$" + toHexString(EndGREET_InitializeBitmap - 1) + " GREET_InitializeBitmap"
EndGREET_InitializeBitmap:

GreetingsHelixCodeASM:
		.import source "\Intermediate\Built\Greetings-HelixCode.asm"
		.print "* $" + toHexString(GreetingsHelixCodeASM) + "-$" + toHexString(EndGreetingsHelixCodeASM - 1) + " GreetingsHelixCodeASM"
EndGreetingsHelixCodeASM:

//; GREET_MainThread() -------------------------------------------------------------------------------------------------------
GREET_MainThread:
		.if(ShowTimings)
		{
			inc $d020
		}

		lda GREET_ShouldUpdateBitmap
		bne GREET_ScrollHelix
		jmp GREET_SkipBitmapUpdate
		
	GREET_ScrollHelix:
		ldy #$00
		ldx GREET_INCMod12, y
		stx GREET_ScrollHelix + 1

		ldy GREET_Mod4Mul8,x

		lda GREET_CurrentBank

		bne GREET_UseOtherBankForBitmapCopy
		jsr Helix_Bitmap_Copy_Base0
		jmp GREET_DoneBitmapCopy
	GREET_UseOtherBankForBitmapCopy:
		jsr Helix_Bitmap_Copy_Base1
GREET_DoneBitmapCopy:

		//; grab our jump address .. and our code injection address
		ldy GREET_ScrollHelix + 1
		dey
		bpl GREET_YIsGood
		ldy #11
	GREET_YIsGood:
		sty GREET_ReloadY1 + 1
		sty GREET_ReloadY2 + 1
		ldx GREET_11SubMul2,y
		txa
		clc
		adc #(39 * 2)
		tay

		lda GREET_ColourCopyJumps + 0,x
		sta GREET_ColJumpAddress + 1
		lda GREET_ColourCopyJumps + 1,x
		sta GREET_ColJumpAddress + 2
		lda GREET_ColourCopyJumps + 0,y
		sta GREET_ColCodeInject1 + 1
		sta GREET_ColCodeInject2 + 1
		lda GREET_ColourCopyJumps + 1,y
		sta GREET_ColCodeInject1 + 2
		sta GREET_ColCodeInject2 + 2
		
		lda GREET_CurrentBank
		bne GREET_UseOtherBank
		lda GREET_ScreenCopyJumps_Bank0 + 0,x
		sta GREET_ScrJumpAddress + 1
		lda GREET_ScreenCopyJumps_Bank0 + 1,x
		sta GREET_ScrJumpAddress + 2
		lda GREET_ScreenCopyJumps_Bank0 + 0,y
		sta GREET_ScrCodeInject1 + 1
		sta GREET_ScrCodeInject2 + 1
		lda GREET_ScreenCopyJumps_Bank0 + 1,y
		sta GREET_ScrCodeInject1 + 2
		sta GREET_ScrCodeInject2 + 2
		jmp GREET_ReadyToGo

	GREET_UseOtherBank:
		lda GREET_ScreenCopyJumps_Bank1 + 0,x
		sta GREET_ScrJumpAddress + 1
		lda GREET_ScreenCopyJumps_Bank1 + 1,x
		sta GREET_ScrJumpAddress + 2
		lda GREET_ScreenCopyJumps_Bank1 + 0,y
		sta GREET_ScrCodeInject1 + 1
		sta GREET_ScrCodeInject2 + 1
		lda GREET_ScreenCopyJumps_Bank1 + 1,y
		sta GREET_ScrCodeInject1 + 2
		sta GREET_ScrCodeInject2 + 2
	
	GREET_ReadyToGo:
		
		//; inject an RTS into the colour copy code at the appropriate point
		lda #$60
	GREET_ScrCodeInject1:
		sta $ffff
	
	GREET_ReloadY1:
		ldy #$00
	GREET_ScrJumpAddress:
		jsr $ffff

		//; restore the original code (LDA abs) that we injected over
		lda #$a9
	GREET_ScrCodeInject2:
		sta $ffff

		lda #$00
		sta GREET_ShouldUpdateBitmap

	GREET_SkipBitmapUpdate:
		
		.if(ShowTimings)
		{
			dec $d020
		}
		rts

		.print "* $" + toHexString(GREET_MainThread) + "-$" + toHexString(EndGREET_MainThread - 1) + " GREET_MainThread"
EndGREET_MainThread:

GREET_SafeReturn:
		rts