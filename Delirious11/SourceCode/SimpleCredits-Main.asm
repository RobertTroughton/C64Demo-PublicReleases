//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 1 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 4 //; 1=Bank+[2000,27ff]
	.var ScreenBank0 = 14 //; 4=Bank+[3c00,3fff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)

* = SimpleCredits_BASE "Simple Credits"

	JumpTable:
		jmp SC_Init
		jmp IRQManager_RestoreDefaultIRQ
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; SC_LocalData -------------------------------------------------------------------------------------------------------
SC_LocalData:
	.var SC_NumCreditScreens = 4 //; (CODE) Raistlin, (AUDIO) MCH, (ART) Razorback, Redcrab
	
	SC_Frame_Colours:
		.byte $00,$0b,$00,$0b,$00,$00,$00,$0b
	SC_ReadyForSpindle:
		.byte $00

	.var IRQNum = 10
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$f7,			<SC_IRQ_BottomBorder,		>SC_IRQ_BottomBorder
		.byte	$00,			$fd,			<SC_IRQ_BottomBorder2,		>SC_IRQ_BottomBorder2
		.byte	$80,			$08,			<SC_IRQ_VBlank,				>SC_IRQ_VBlank
	IRQList_Sprites0:
		.byte	$00,			$40,			<SC_IRQ_EnableSprites,		>SC_IRQ_EnableSprites
	IRQList_Sprites1:
		.byte	$00,			$55,			<SC_IRQ_SpriteSection0,		>SC_IRQ_SpriteSection0
	IRQList_Sprites2:
		.byte	$00,			$6a,			<SC_IRQ_SpriteSection1,		>SC_IRQ_SpriteSection1
	IRQList_Sprites3:
		.byte	$00,			$7f,			<SC_IRQ_SpriteSection2,		>SC_IRQ_SpriteSection2
	IRQList_Sprites4:
		.byte	$00,			$94,			<SC_IRQ_SpriteSection3,		>SC_IRQ_SpriteSection3
	IRQList_Sprites5:
		.byte	$00,			$a9,			<SC_IRQ_SpriteSection4,		>SC_IRQ_SpriteSection4
	IRQList_Sprites6:
		.byte	$00,			$be,			<SC_IRQ_SpriteSection5,		>SC_IRQ_SpriteSection5
		
	SC_SpritePositions:
		.byte $2c, $40, $44, $40, $5c, $40, $74, $40
		.byte $41, $55, $59, $55, $71, $55, $89, $55
		.byte $56, $6a, $6e, $6a, $86, $6a, $9e, $6a
		.byte $6b, $7f, $83, $7f, $9b, $7f, $b3, $7f
		.byte $80, $94, $98, $94, $b0, $94, $c8, $94
		.byte $95, $a9, $ad, $a9, $c5, $a9, $dd, $a9
		.byte $aa, $be, $c2, $be, $da, $be, $f2, $be
		.byte $bf, $d3, $d7, $d3, $ef, $d3, $07, $d3
		
	SC_FirstSpriteValue:
		.byte 0
		
	SC_LastFrameOf256:
		.byte 0

	.var SC_NumBytesPerLine = 12
	.var SpriteData = $0000
	SpriteLineOffset:
		.byte $00, $01, $02, $40, $41, $42, $80, $81, $82, $c0, $c1, $c2
	SpriteDataOffsetLo:
		.byte <(SpriteData +  0 + 0 * 4 * 64), <(SpriteData +  3 + 0 * 4 * 64), <(SpriteData +  6 + 0 * 4 * 64), <(SpriteData +  9 + 0 * 4 * 64), <(SpriteData + 12 + 0 * 4 * 64), <(SpriteData + 15 + 0 * 4 * 64), <(SpriteData + 18 + 0 * 4 * 64)
		.byte <(SpriteData + 21 + 0 * 4 * 64), <(SpriteData + 24 + 0 * 4 * 64), <(SpriteData + 27 + 0 * 4 * 64), <(SpriteData + 30 + 0 * 4 * 64), <(SpriteData + 33 + 0 * 4 * 64), <(SpriteData + 36 + 0 * 4 * 64), <(SpriteData + 39 + 0 * 4 * 64)
		.byte <(SpriteData + 42 + 0 * 4 * 64), <(SpriteData + 45 + 0 * 4 * 64), <(SpriteData + 48 + 0 * 4 * 64), <(SpriteData + 51 + 0 * 4 * 64), <(SpriteData + 54 + 0 * 4 * 64), <(SpriteData + 57 + 0 * 4 * 64), <(SpriteData + 60 + 0 * 4 * 64)
		.byte <(SpriteData +  0 + 1 * 4 * 64), <(SpriteData +  3 + 1 * 4 * 64), <(SpriteData +  6 + 1 * 4 * 64), <(SpriteData +  9 + 1 * 4 * 64), <(SpriteData + 12 + 1 * 4 * 64), <(SpriteData + 15 + 1 * 4 * 64), <(SpriteData + 18 + 1 * 4 * 64)
		.byte <(SpriteData + 21 + 1 * 4 * 64), <(SpriteData + 24 + 1 * 4 * 64), <(SpriteData + 27 + 1 * 4 * 64), <(SpriteData + 30 + 1 * 4 * 64), <(SpriteData + 33 + 1 * 4 * 64), <(SpriteData + 36 + 1 * 4 * 64), <(SpriteData + 39 + 1 * 4 * 64)
		.byte <(SpriteData + 42 + 1 * 4 * 64), <(SpriteData + 45 + 1 * 4 * 64), <(SpriteData + 48 + 1 * 4 * 64), <(SpriteData + 51 + 1 * 4 * 64), <(SpriteData + 54 + 1 * 4 * 64), <(SpriteData + 57 + 1 * 4 * 64), <(SpriteData + 60 + 1 * 4 * 64)
		.byte <(SpriteData +  0 + 2 * 4 * 64), <(SpriteData +  3 + 2 * 4 * 64), <(SpriteData +  6 + 2 * 4 * 64), <(SpriteData +  9 + 2 * 4 * 64), <(SpriteData + 12 + 2 * 4 * 64), <(SpriteData + 15 + 2 * 4 * 64), <(SpriteData + 18 + 2 * 4 * 64)
		.byte <(SpriteData + 21 + 2 * 4 * 64), <(SpriteData + 24 + 2 * 4 * 64), <(SpriteData + 27 + 2 * 4 * 64), <(SpriteData + 30 + 2 * 4 * 64), <(SpriteData + 33 + 2 * 4 * 64), <(SpriteData + 36 + 2 * 4 * 64), <(SpriteData + 39 + 2 * 4 * 64)
		.byte <(SpriteData + 42 + 2 * 4 * 64), <(SpriteData + 45 + 2 * 4 * 64), <(SpriteData + 48 + 2 * 4 * 64), <(SpriteData + 51 + 2 * 4 * 64), <(SpriteData + 54 + 2 * 4 * 64), <(SpriteData + 57 + 2 * 4 * 64), <(SpriteData + 60 + 2 * 4 * 64)
		.byte <(SpriteData +  0 + 3 * 4 * 64), <(SpriteData +  3 + 3 * 4 * 64), <(SpriteData +  6 + 3 * 4 * 64), <(SpriteData +  9 + 3 * 4 * 64), <(SpriteData + 12 + 3 * 4 * 64), <(SpriteData + 15 + 3 * 4 * 64), <(SpriteData + 18 + 3 * 4 * 64)
		.byte <(SpriteData + 21 + 3 * 4 * 64), <(SpriteData + 24 + 3 * 4 * 64), <(SpriteData + 27 + 3 * 4 * 64), <(SpriteData + 30 + 3 * 4 * 64), <(SpriteData + 33 + 3 * 4 * 64), <(SpriteData + 36 + 3 * 4 * 64), <(SpriteData + 39 + 3 * 4 * 64)
		.byte <(SpriteData + 42 + 3 * 4 * 64), <(SpriteData + 45 + 3 * 4 * 64), <(SpriteData + 48 + 3 * 4 * 64), <(SpriteData + 51 + 3 * 4 * 64), <(SpriteData + 54 + 3 * 4 * 64), <(SpriteData + 57 + 3 * 4 * 64), <(SpriteData + 60 + 3 * 4 * 64)
		.byte <(SpriteData +  0 + 4 * 4 * 64), <(SpriteData +  3 + 4 * 4 * 64), <(SpriteData +  6 + 4 * 4 * 64), <(SpriteData +  9 + 4 * 4 * 64), <(SpriteData + 12 + 4 * 4 * 64), <(SpriteData + 15 + 4 * 4 * 64), <(SpriteData + 18 + 4 * 4 * 64)
		.byte <(SpriteData + 21 + 4 * 4 * 64), <(SpriteData + 24 + 4 * 4 * 64), <(SpriteData + 27 + 4 * 4 * 64), <(SpriteData + 30 + 4 * 4 * 64), <(SpriteData + 33 + 4 * 4 * 64), <(SpriteData + 36 + 4 * 4 * 64), <(SpriteData + 39 + 4 * 4 * 64)
		.byte <(SpriteData + 42 + 4 * 4 * 64), <(SpriteData + 45 + 4 * 4 * 64), <(SpriteData + 48 + 4 * 4 * 64), <(SpriteData + 51 + 4 * 4 * 64), <(SpriteData + 54 + 4 * 4 * 64), <(SpriteData + 57 + 4 * 4 * 64), <(SpriteData + 60 + 4 * 4 * 64)
		.byte <(SpriteData +  0 + 5 * 4 * 64), <(SpriteData +  3 + 5 * 4 * 64), <(SpriteData +  6 + 5 * 4 * 64), <(SpriteData +  9 + 5 * 4 * 64), <(SpriteData + 12 + 5 * 4 * 64), <(SpriteData + 15 + 5 * 4 * 64), <(SpriteData + 18 + 5 * 4 * 64)
		.byte <(SpriteData + 21 + 5 * 4 * 64), <(SpriteData + 24 + 5 * 4 * 64), <(SpriteData + 27 + 5 * 4 * 64), <(SpriteData + 30 + 5 * 4 * 64), <(SpriteData + 33 + 5 * 4 * 64), <(SpriteData + 36 + 5 * 4 * 64), <(SpriteData + 39 + 5 * 4 * 64)
		.byte <(SpriteData + 42 + 5 * 4 * 64), <(SpriteData + 45 + 5 * 4 * 64), <(SpriteData + 48 + 5 * 4 * 64), <(SpriteData + 51 + 5 * 4 * 64), <(SpriteData + 54 + 5 * 4 * 64), <(SpriteData + 57 + 5 * 4 * 64), <(SpriteData + 60 + 5 * 4 * 64)
		.byte <(SpriteData +  0 + 6 * 4 * 64), <(SpriteData +  3 + 6 * 4 * 64), <(SpriteData +  6 + 6 * 4 * 64), <(SpriteData +  9 + 6 * 4 * 64), <(SpriteData + 12 + 6 * 4 * 64), <(SpriteData + 15 + 6 * 4 * 64), <(SpriteData + 18 + 6 * 4 * 64)
		.byte <(SpriteData + 21 + 6 * 4 * 64), <(SpriteData + 24 + 6 * 4 * 64), <(SpriteData + 27 + 6 * 4 * 64), <(SpriteData + 30 + 6 * 4 * 64), <(SpriteData + 33 + 6 * 4 * 64), <(SpriteData + 36 + 6 * 4 * 64), <(SpriteData + 39 + 6 * 4 * 64)
		.byte <(SpriteData + 42 + 6 * 4 * 64), <(SpriteData + 45 + 6 * 4 * 64), <(SpriteData + 48 + 6 * 4 * 64), <(SpriteData + 51 + 6 * 4 * 64), <(SpriteData + 54 + 6 * 4 * 64), <(SpriteData + 57 + 6 * 4 * 64), <(SpriteData + 60 + 6 * 4 * 64)
		.byte <(SpriteData +  0 + 7 * 4 * 64), <(SpriteData +  3 + 7 * 4 * 64), <(SpriteData +  6 + 7 * 4 * 64), <(SpriteData +  9 + 7 * 4 * 64), <(SpriteData + 12 + 7 * 4 * 64), <(SpriteData + 15 + 7 * 4 * 64), <(SpriteData + 18 + 7 * 4 * 64)
		.byte <(SpriteData + 21 + 7 * 4 * 64), <(SpriteData + 24 + 7 * 4 * 64), <(SpriteData + 27 + 7 * 4 * 64), <(SpriteData + 30 + 7 * 4 * 64), <(SpriteData + 33 + 7 * 4 * 64), <(SpriteData + 36 + 7 * 4 * 64), <(SpriteData + 39 + 7 * 4 * 64)
		.byte <(SpriteData + 42 + 7 * 4 * 64), <(SpriteData + 45 + 7 * 4 * 64), <(SpriteData + 48 + 7 * 4 * 64), <(SpriteData + 51 + 7 * 4 * 64), <(SpriteData + 54 + 7 * 4 * 64), <(SpriteData + 57 + 7 * 4 * 64), <(SpriteData + 60 + 7 * 4 * 64)
	SpriteDataOffsetHi:
		.byte >(SpriteData +  0 + 0 * 4 * 64), >(SpriteData +  3 + 0 * 4 * 64), >(SpriteData +  6 + 0 * 4 * 64), >(SpriteData +  9 + 0 * 4 * 64), >(SpriteData + 12 + 0 * 4 * 64), >(SpriteData + 15 + 0 * 4 * 64), >(SpriteData + 18 + 0 * 4 * 64)
		.byte >(SpriteData + 21 + 0 * 4 * 64), >(SpriteData + 24 + 0 * 4 * 64), >(SpriteData + 27 + 0 * 4 * 64), >(SpriteData + 30 + 0 * 4 * 64), >(SpriteData + 33 + 0 * 4 * 64), >(SpriteData + 36 + 0 * 4 * 64), >(SpriteData + 39 + 0 * 4 * 64)
		.byte >(SpriteData + 42 + 0 * 4 * 64), >(SpriteData + 45 + 0 * 4 * 64), >(SpriteData + 48 + 0 * 4 * 64), >(SpriteData + 51 + 0 * 4 * 64), >(SpriteData + 54 + 0 * 4 * 64), >(SpriteData + 57 + 0 * 4 * 64), >(SpriteData + 60 + 0 * 4 * 64)
		.byte >(SpriteData +  0 + 1 * 4 * 64), >(SpriteData +  3 + 1 * 4 * 64), >(SpriteData +  6 + 1 * 4 * 64), >(SpriteData +  9 + 1 * 4 * 64), >(SpriteData + 12 + 1 * 4 * 64), >(SpriteData + 15 + 1 * 4 * 64), >(SpriteData + 18 + 1 * 4 * 64)
		.byte >(SpriteData + 21 + 1 * 4 * 64), >(SpriteData + 24 + 1 * 4 * 64), >(SpriteData + 27 + 1 * 4 * 64), >(SpriteData + 30 + 1 * 4 * 64), >(SpriteData + 33 + 1 * 4 * 64), >(SpriteData + 36 + 1 * 4 * 64), >(SpriteData + 39 + 1 * 4 * 64)
		.byte >(SpriteData + 42 + 1 * 4 * 64), >(SpriteData + 45 + 1 * 4 * 64), >(SpriteData + 48 + 1 * 4 * 64), >(SpriteData + 51 + 1 * 4 * 64), >(SpriteData + 54 + 1 * 4 * 64), >(SpriteData + 57 + 1 * 4 * 64), >(SpriteData + 60 + 1 * 4 * 64)
		.byte >(SpriteData +  0 + 2 * 4 * 64), >(SpriteData +  3 + 2 * 4 * 64), >(SpriteData +  6 + 2 * 4 * 64), >(SpriteData +  9 + 2 * 4 * 64), >(SpriteData + 12 + 2 * 4 * 64), >(SpriteData + 15 + 2 * 4 * 64), >(SpriteData + 18 + 2 * 4 * 64)
		.byte >(SpriteData + 21 + 2 * 4 * 64), >(SpriteData + 24 + 2 * 4 * 64), >(SpriteData + 27 + 2 * 4 * 64), >(SpriteData + 30 + 2 * 4 * 64), >(SpriteData + 33 + 2 * 4 * 64), >(SpriteData + 36 + 2 * 4 * 64), >(SpriteData + 39 + 2 * 4 * 64)
		.byte >(SpriteData + 42 + 2 * 4 * 64), >(SpriteData + 45 + 2 * 4 * 64), >(SpriteData + 48 + 2 * 4 * 64), >(SpriteData + 51 + 2 * 4 * 64), >(SpriteData + 54 + 2 * 4 * 64), >(SpriteData + 57 + 2 * 4 * 64), >(SpriteData + 60 + 2 * 4 * 64)
		.byte >(SpriteData +  0 + 3 * 4 * 64), >(SpriteData +  3 + 3 * 4 * 64), >(SpriteData +  6 + 3 * 4 * 64), >(SpriteData +  9 + 3 * 4 * 64), >(SpriteData + 12 + 3 * 4 * 64), >(SpriteData + 15 + 3 * 4 * 64), >(SpriteData + 18 + 3 * 4 * 64)
		.byte >(SpriteData + 21 + 3 * 4 * 64), >(SpriteData + 24 + 3 * 4 * 64), >(SpriteData + 27 + 3 * 4 * 64), >(SpriteData + 30 + 3 * 4 * 64), >(SpriteData + 33 + 3 * 4 * 64), >(SpriteData + 36 + 3 * 4 * 64), >(SpriteData + 39 + 3 * 4 * 64)
		.byte >(SpriteData + 42 + 3 * 4 * 64), >(SpriteData + 45 + 3 * 4 * 64), >(SpriteData + 48 + 3 * 4 * 64), >(SpriteData + 51 + 3 * 4 * 64), >(SpriteData + 54 + 3 * 4 * 64), >(SpriteData + 57 + 3 * 4 * 64), >(SpriteData + 60 + 3 * 4 * 64)
		.byte >(SpriteData +  0 + 4 * 4 * 64), >(SpriteData +  3 + 4 * 4 * 64), >(SpriteData +  6 + 4 * 4 * 64), >(SpriteData +  9 + 4 * 4 * 64), >(SpriteData + 12 + 4 * 4 * 64), >(SpriteData + 15 + 4 * 4 * 64), >(SpriteData + 18 + 4 * 4 * 64)
		.byte >(SpriteData + 21 + 4 * 4 * 64), >(SpriteData + 24 + 4 * 4 * 64), >(SpriteData + 27 + 4 * 4 * 64), >(SpriteData + 30 + 4 * 4 * 64), >(SpriteData + 33 + 4 * 4 * 64), >(SpriteData + 36 + 4 * 4 * 64), >(SpriteData + 39 + 4 * 4 * 64)
		.byte >(SpriteData + 42 + 4 * 4 * 64), >(SpriteData + 45 + 4 * 4 * 64), >(SpriteData + 48 + 4 * 4 * 64), >(SpriteData + 51 + 4 * 4 * 64), >(SpriteData + 54 + 4 * 4 * 64), >(SpriteData + 57 + 4 * 4 * 64), >(SpriteData + 60 + 4 * 4 * 64)
		.byte >(SpriteData +  0 + 5 * 4 * 64), >(SpriteData +  3 + 5 * 4 * 64), >(SpriteData +  6 + 5 * 4 * 64), >(SpriteData +  9 + 5 * 4 * 64), >(SpriteData + 12 + 5 * 4 * 64), >(SpriteData + 15 + 5 * 4 * 64), >(SpriteData + 18 + 5 * 4 * 64)
		.byte >(SpriteData + 21 + 5 * 4 * 64), >(SpriteData + 24 + 5 * 4 * 64), >(SpriteData + 27 + 5 * 4 * 64), >(SpriteData + 30 + 5 * 4 * 64), >(SpriteData + 33 + 5 * 4 * 64), >(SpriteData + 36 + 5 * 4 * 64), >(SpriteData + 39 + 5 * 4 * 64)
		.byte >(SpriteData + 42 + 5 * 4 * 64), >(SpriteData + 45 + 5 * 4 * 64), >(SpriteData + 48 + 5 * 4 * 64), >(SpriteData + 51 + 5 * 4 * 64), >(SpriteData + 54 + 5 * 4 * 64), >(SpriteData + 57 + 5 * 4 * 64), >(SpriteData + 60 + 5 * 4 * 64)
		.byte >(SpriteData +  0 + 6 * 4 * 64), >(SpriteData +  3 + 6 * 4 * 64), >(SpriteData +  6 + 6 * 4 * 64), >(SpriteData +  9 + 6 * 4 * 64), >(SpriteData + 12 + 6 * 4 * 64), >(SpriteData + 15 + 6 * 4 * 64), >(SpriteData + 18 + 6 * 4 * 64)
		.byte >(SpriteData + 21 + 6 * 4 * 64), >(SpriteData + 24 + 6 * 4 * 64), >(SpriteData + 27 + 6 * 4 * 64), >(SpriteData + 30 + 6 * 4 * 64), >(SpriteData + 33 + 6 * 4 * 64), >(SpriteData + 36 + 6 * 4 * 64), >(SpriteData + 39 + 6 * 4 * 64)
		.byte >(SpriteData + 42 + 6 * 4 * 64), >(SpriteData + 45 + 6 * 4 * 64), >(SpriteData + 48 + 6 * 4 * 64), >(SpriteData + 51 + 6 * 4 * 64), >(SpriteData + 54 + 6 * 4 * 64), >(SpriteData + 57 + 6 * 4 * 64), >(SpriteData + 60 + 6 * 4 * 64)
		.byte >(SpriteData +  0 + 7 * 4 * 64), >(SpriteData +  3 + 7 * 4 * 64), >(SpriteData +  6 + 7 * 4 * 64), >(SpriteData +  9 + 7 * 4 * 64), >(SpriteData + 12 + 7 * 4 * 64), >(SpriteData + 15 + 7 * 4 * 64), >(SpriteData + 18 + 7 * 4 * 64)
		.byte >(SpriteData + 21 + 7 * 4 * 64), >(SpriteData + 24 + 7 * 4 * 64), >(SpriteData + 27 + 7 * 4 * 64), >(SpriteData + 30 + 7 * 4 * 64), >(SpriteData + 33 + 7 * 4 * 64), >(SpriteData + 36 + 7 * 4 * 64), >(SpriteData + 39 + 7 * 4 * 64)
		.byte >(SpriteData + 42 + 7 * 4 * 64), >(SpriteData + 45 + 7 * 4 * 64), >(SpriteData + 48 + 7 * 4 * 64), >(SpriteData + 51 + 7 * 4 * 64), >(SpriteData + 54 + 7 * 4 * 64), >(SpriteData + 57 + 7 * 4 * 64), >(SpriteData + 60 + 7 * 4 * 64)

	.print "* $" + toHexString(SC_LocalData) + "-$" + toHexString(EndSC_LocalData - 1) + " SC_LocalData"
	
EndSC_LocalData:

//; SC_Init() -------------------------------------------------------------------------------------------------------
SC_Init:

		lda #$00
		ldy #$00
	SC_ClearSpriteData:
		sta BaseBankAddress + SpriteData + 256 * 0,y
		sta BaseBankAddress + SpriteData + 256 * 1,y
		sta BaseBankAddress + SpriteData + 256 * 2,y
		sta BaseBankAddress + SpriteData + 256 * 3,y
		sta BaseBankAddress + SpriteData + 256 * 4,y
		sta BaseBankAddress + SpriteData + 256 * 5,y
		sta BaseBankAddress + SpriteData + 256 * 6,y
		sta BaseBankAddress + SpriteData + 256 * 7,y
		iny
		bne SC_ClearSpriteData
		
		lda #$00
		sta BaseBankAddress + $3fff
		
		lda #$f0
	SC_WaitForF0:
		cmp $d012
		bne SC_WaitForF0

		sei
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta spriteDoubleWidth	//; make no sprites double-width
		sta spriteDoubleHeight	//; make no sprites double-height
		sta spriteMulticolorMode
		sta spriteDrawPriority
		sta spriteXMSB
		lda #$00
		sta ValueD016
		lda #$3e
		sta ValueDD02
		lda #$0f
		sta SPRITE0_Color
		sta SPRITE1_Color
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		sta SPRITE5_Color
		sta SPRITE6_Color
		sta SPRITE7_Color
		lda #$0b
		sta $d021

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(SC_Init) + "-$" + toHexString(EndSC_Init - 1) + " SC_Init"
EndSC_Init:

//; SC_IRQ_EnableSprites() -------------------------------------------------------------------------------------------------------
SC_IRQ_EnableSprites:
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

		.print "* $" + toHexString(SC_IRQ_EnableSprites) + "-$" + toHexString(EndSC_IRQ_EnableSprites - 1) + " SC_IRQ_EnableSprites"
EndSC_IRQ_EnableSprites:

//; SC_IRQ_SpriteSection0() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions0:
		lda SC_SpritePositions + (8 * 2), x
		sta $d000,x
		dex
		bpl SC_SetSpritePositions0
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 2)
		tax
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection0) + "-$" + toHexString(EndSC_IRQ_SpriteSection0 - 1) + " SC_IRQ_SpriteSection0"
EndSC_IRQ_SpriteSection0:
		
//; SC_IRQ_SpriteSection1() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions1:
		lda SC_SpritePositions + (8 * 3), x
		sta $d008,x
		dex
		bpl SC_SetSpritePositions1
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 3)
		tax
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection1) + "-$" + toHexString(EndSC_IRQ_SpriteSection1 - 1) + " SC_IRQ_SpriteSection1"
EndSC_IRQ_SpriteSection1:
		
//; SC_IRQ_SpriteSection2() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions2:
		lda SC_SpritePositions + (8 * 4), x
		sta $d000,x
		dex
		bpl SC_SetSpritePositions2
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 4)
		tax
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection2) + "-$" + toHexString(EndSC_IRQ_SpriteSection2 - 1) + " SC_IRQ_SpriteSection2"
EndSC_IRQ_SpriteSection2:
		
//; SC_IRQ_SpriteSection3() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection3:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions3:
		lda SC_SpritePositions + (8 * 5), x
		sta $d008,x
		dex
		bpl SC_SetSpritePositions3
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 5)
		tax
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection3) + "-$" + toHexString(EndSC_IRQ_SpriteSection3 - 1) + " SC_IRQ_SpriteSection3"
EndSC_IRQ_SpriteSection3:
		
//; SC_IRQ_SpriteSection4() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection4:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions4:
		lda SC_SpritePositions + (8 * 6), x
		sta $d000,x
		dex
		bpl SC_SetSpritePositions4
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 6)
		tax
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection4) + "-$" + toHexString(EndSC_IRQ_SpriteSection4 - 1) + " SC_IRQ_SpriteSection4"
EndSC_IRQ_SpriteSection4:
		
//; SC_IRQ_SpriteSection5() -------------------------------------------------------------------------------------------------------
SC_IRQ_SpriteSection5:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		ldx #$07
	SC_SetSpritePositions5:
		lda SC_SpritePositions + (8 * 7), x
		sta $d008,x
		dex
		bpl SC_SetSpritePositions5
		
		lda SC_FirstSpriteValue
		clc
		adc #(4 * 7)
		tax
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_SpriteSection5) + "-$" + toHexString(EndSC_IRQ_SpriteSection5 - 1) + " SC_IRQ_SpriteSection5"
EndSC_IRQ_SpriteSection5:
		
//; SC_IRQ_BottomBorder() -------------------------------------------------------------------------------------------------------
SC_IRQ_BottomBorder:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		lda #$f9
	SC_VBWaitF9:
		cmp $d012
		bne SC_VBWaitF9
		
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

		.print "* $" + toHexString(SC_IRQ_BottomBorder) + "-$" + toHexString(EndSC_IRQ_BottomBorder - 1) + " SC_IRQ_BottomBorder"
EndSC_IRQ_BottomBorder:
		
//; SC_IRQ_BottomBorder2() -------------------------------------------------------------------------------------------------------
SC_IRQ_BottomBorder2:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #$ff
	SC_VBWaitFF:
		cmp $d012
		bne SC_VBWaitFF
		
		lda #$1b
 		sta $d011

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_BottomBorder2) + "-$" + toHexString(EndSC_IRQ_BottomBorder2 - 1) + " SC_IRQ_BottomBorder2"
EndSC_IRQ_BottomBorder2:

//; SC_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SC_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda #((ScreenBank0 * 16) + (CharBank * 2))
 		sta $d018
 		lda ValueD016
 		sta $d016
		lda ValueDD02
		sta $dd02

		lda #$00
		sta spriteEnable
		
		jsr SC_SetSpritePositions

		ldx #$0f
	SC_SetSpritePositionsVB:
		lda SC_SpritePositions + (8 * 0), x
		sta $d000,x
		dex
		bpl SC_SetSpritePositionsVB
		
		ldx SC_FirstSpriteValue
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		
		inc FrameOf256
		lda FrameOf256
		cmp SC_LastFrameOf256
		bne Skip256Counter
		lda #$00
		sta FrameOf256
		sta SC_LastFrameOf256
		inc Frame_256Counter
		lda Frame_256Counter
		and #$01
		beq Skip256Counter
		
		inc SC_ReadyForSpindle
		lda #$c0
		sta SC_LastFrameOf256
	Skip256Counter:
	
		lda Frame_256Counter
		cmp #(SC_NumCreditScreens * 2)
		bne SC_NotFinishedDemoPart

		inc Signal_CurrentEffectIsFinished
	SC_NotFinishedDemoPart:
	
		jsr Music_Play
		
		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SC_IRQ_VBlank) + "-$" + toHexString(EndSC_IRQ_VBlank - 1) + " SC_IRQ_VBlank"
EndSC_IRQ_VBlank:


//; SC_SetSpritePositions() -------------------------------------------------------------------------------------------------------
SC_SetSpritePositions:

		lda FrameOf256
		cmp #40
		bcs SC_DontUpdateColors
		
		lsr
		sta SC_ReloadFrameValue + 1
		
		tay
		ldx Frame_256Counter
		lda SC_Frame_Colours,x
		sta SC_ReloadAValue + 1
		jsr SC_FillColorLine
		
		lda #39
		sec
	SC_ReloadFrameValue:
		sbc #$00
		tay
	SC_ReloadAValue:
		lda #$00
		jsr SC_FillColorLine
	SC_DontUpdateColors:

		lda SC_ReadyForSpindle
		beq SC_DontSpindleLoad
		lda FrameOf256
		cmp #40
		bne SC_DontSpindleLoad
		
		inc Signal_SpindleLoadNextFile
		dec SC_ReadyForSpindle
	SC_DontSpindleLoad:
	
	//; Space
		ldy FrameOf256
		cpy #(( 21 * 8) / 2 + 1)
		bcs SC_SSP_Part1
		lda #((21 * 8) - 1)
		sec
		sbc FrameOf256
		tax

		jsr SC_ClearNextCredit
		
	//; Full Line
	SC_SSP_Part1:
		ldy FrameOf256
		dey
		cpy #((21 * 8) / 2 + 1)
		bcs SC_SSP_Part2
		sty SC_SSP_Y0 + 1
		lda #((21 * 8) - 1)
		sec
	SC_SSP_Y0:
		sbc #$ff
		tax

		lda #$88
		jsr SC_DrawNextCredit
		
	//; Space
	SC_SSP_Part2:
		ldy FrameOf256
		dey
		dey
		bmi SC_SSP_SpritePositions
		cpy #((21 * 8) / 2 + 1)
		bcs SC_SSP_SpritePositions
		sty SC_SSP_Y1 + 1
		lda #((21 * 8) - 1)
		sec
	SC_SSP_Y1:
		sbc #$ff
		tax
		jsr SC_ClearNextCredit

	//; Space or New Data
	SC_SSP_Part3:
		ldy FrameOf256
		dey
		dey
		dey
		bmi SC_SSP_SpritePositions
		cpy #((21 * 8) / 2 + 1)
		bcs SC_SSP_SpritePositions
		sty SC_SSP_Y2 + 1
		lda #((21 * 8) - 1)
		sec
	SC_SSP_Y2:
		sbc #$ff
		tax

		lda Frame_256Counter
		and #$01
		beq SC_SSP_NewDataLine
		
		jsr SC_ClearNextCredit
		jmp SC_SSP_SpritePositions
	
	SC_SSP_NewDataLine:
		lda Frame_256Counter
		lsr
		and #$01
		asl
		asl
		asl
		adc #$90
		jsr SC_DrawNextCredit

	SC_SSP_SpritePositions:
		ldy #$00
		lda $3f00,y
		clc
		adc #$1d
		sta IRQList_Sprites0 + 1
		clc
		adc #$01
		sta SC_SpritePositions + 1 + (0 * 8)
		sta SC_SpritePositions + 3 + (0 * 8)
		sta SC_SpritePositions + 5 + (0 * 8)
		sta SC_SpritePositions + 7 + (0 * 8)
		clc
		adc #$15
		sta IRQList_Sprites1 + 1
		sta SC_SpritePositions + 1 + (1 * 8)
		sta SC_SpritePositions + 3 + (1 * 8)
		sta SC_SpritePositions + 5 + (1 * 8)
		sta SC_SpritePositions + 7 + (1 * 8)
		clc
		adc #$15
		sta IRQList_Sprites2 + 1
		sta SC_SpritePositions + 1 + (2 * 8)
		sta SC_SpritePositions + 3 + (2 * 8)
		sta SC_SpritePositions + 5 + (2 * 8)
		sta SC_SpritePositions + 7 + (2 * 8)
		clc
		adc #$15
		sta IRQList_Sprites3 + 1
		sta SC_SpritePositions + 1 + (3 * 8)
		sta SC_SpritePositions + 3 + (3 * 8)
		sta SC_SpritePositions + 5 + (3 * 8)
		sta SC_SpritePositions + 7 + (3 * 8)
		clc
		adc #$15
		sta IRQList_Sprites4 + 1
		sta SC_SpritePositions + 1 + (4 * 8)
		sta SC_SpritePositions + 3 + (4 * 8)
		sta SC_SpritePositions + 5 + (4 * 8)
		sta SC_SpritePositions + 7 + (4 * 8)
		clc
		adc #$15
		sta IRQList_Sprites5 + 1
		sta SC_SpritePositions + 1 + (5 * 8)
		sta SC_SpritePositions + 3 + (5 * 8)
		sta SC_SpritePositions + 5 + (5 * 8)
		sta SC_SpritePositions + 7 + (5 * 8)
		clc
		adc #$15
		sta IRQList_Sprites6 + 1
		sta SC_SpritePositions + 1 + (6 * 8)
		sta SC_SpritePositions + 3 + (6 * 8)
		sta SC_SpritePositions + 5 + (6 * 8)
		sta SC_SpritePositions + 7 + (6 * 8)
		clc
		adc #$15
		sta SC_SpritePositions + 1 + (7 * 8)
		sta SC_SpritePositions + 3 + (7 * 8)
		sta SC_SpritePositions + 5 + (7 * 8)
		sta SC_SpritePositions + 7 + (7 * 8)
		
	SC_SSP_SpritePositions2:
		ldy #$18
		lda $3e00,y
		
		.for(var SpriteIndex = 0; SpriteIndex < 32; SpriteIndex ++)
		{		
			.if((SpriteIndex & 3) != 0)
			{
				clc
				adc #24
			}
			sta SC_SpritePositions + (SpriteIndex * 2)
			.if(((SpriteIndex & 3) == 3) && (SpriteIndex != 31))
			{
				sec
				sbc #((24 * 3) - 21)
			}
		}
		
		lda SC_SSP_SpritePositions + 1
		clc
		adc #$02
		sta SC_SSP_SpritePositions + 1

		lda SC_SSP_SpritePositions2 + 1
		clc
		adc #$02
		sta SC_SSP_SpritePositions2 + 1
		
		rts

		.print "* $" + toHexString(SC_SetSpritePositions) + "-$" + toHexString(EndSC_SetSpritePositions - 1) + " SC_SetSpritePositions"
EndSC_SetSpritePositions:

SC_DrawNextCredit:
		sta SC_DNC_Src1 + 1
		sta SC_DNC_Src2 + 1

		lda SpriteDataOffsetLo,y
		sta SC_DNC_In + 1
		sta SC_DNC_Out + 1
		lda SpriteDataOffsetHi,y
		clc
	SC_DNC_Src1:
		adc #$ff
		sta SC_DNC_In + 2
		lda SpriteDataOffsetHi,y
		clc
		adc #$80
		sta SC_DNC_Out + 2

		lda SpriteDataOffsetLo,x
		sta SC_DNC_In2 + 1
		sta SC_DNC_Out2 + 1
		lda SpriteDataOffsetHi,x
		clc
	SC_DNC_Src2:
		adc #$ff
		sta SC_DNC_In2 + 2
		lda SpriteDataOffsetHi,x
		clc
		adc #$80
		sta SC_DNC_Out2 + 2

		ldy #$00
	SC_DNC_Loop:
		ldx SpriteLineOffset,y
	SC_DNC_In:
		lda $ffff,x
	SC_DNC_Out:
		sta $ffff,x
	SC_DNC_In2:
		lda $ffff,x
	SC_DNC_Out2:
		sta $ffff,x
		iny
		cpy #SC_NumBytesPerLine
		bne SC_DNC_Loop
	
		rts

		.print "* $" + toHexString(SC_DrawNextCredit) + "-$" + toHexString(EndSC_DrawNextCredit - 1) + " SC_DrawNextCredit"
EndSC_DrawNextCredit:

SC_ClearNextCredit:
		lda SpriteDataOffsetLo,y
		sta SC_CNC_Out + 1
		lda SpriteDataOffsetHi,y
		clc
		adc #$80
		sta SC_CNC_Out + 2

		lda SpriteDataOffsetLo,x
		sta SC_CNC_Out2 + 1
		lda SpriteDataOffsetHi,x
		clc
		adc #$80
		sta SC_CNC_Out2 + 2

		ldy #$00
		lda #$00
	SC_CNC_Loop:
		ldx SpriteLineOffset,y
	SC_CNC_Out:
		sta $ffff,x
	SC_CNC_Out2:
		sta $ffff,x
		iny
		cpy #SC_NumBytesPerLine
		bne SC_CNC_Loop
	
		rts

		.print "* $" + toHexString(SC_ClearNextCredit) + "-$" + toHexString(EndSC_ClearNextCredit - 1) + " SC_ClearNextCredit"
EndSC_ClearNextCredit:

SC_FillColorLine:
		.for(var YPos = 0; YPos < 25; YPos++)
		{		
			sta $d800 + YPos * 40,y
		}
		rts

		.print "* $" + toHexString(SC_FillColorLine) + "-$" + toHexString(EndSC_FillColorLine - 1) + " SC_FillColorLine"
EndSC_FillColorLine:
		