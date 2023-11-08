//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 2 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
//;	.var CharBank = 0 //; 0=Bank+[0000,07ff]
	.var ScreenBank0 = 0 //; 0=Bank+[0000,03ff]
	.var BitmapBank0 = 1 //; 1=Bank+[2000,3fff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)
	
* = BedIntro_BASE "Bed Intro"

	JumpTable:
		jmp BI_Init
		jmp BI_End
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; BI_LocalData -------------------------------------------------------------------------------------------------------
BI_LocalData:
	.var IRQNum = 2
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$f7,			<BI_IRQ_VBlank,				>BI_IRQ_VBlank
		.byte	$00,			$c4,			<BI_IRQ_DrawYears,			>BI_IRQ_DrawYears
	
	.var BI_AlarmClockSinTable = $5fc0

	.var StartSpriteIndex = 32
	BI_SpriteValues:
		.byte	1, 9, 9, 2

	.var SpriteAnimFirst = StartSpriteIndex + 20
	.var SpriteXOffset = 24
	.var SpriteYOffset = 50
	BI_SpriteAnims:	//; Val, Colour, X-Val, Y-Val
		.byte SpriteAnimFirst + 1, 13, 181 + SpriteXOffset, 68 + SpriteYOffset	//; Clock Display
		.byte SpriteAnimFirst + 2, 11, 183 + SpriteXOffset, 68 + SpriteYOffset	//; Clock Front
		.byte SpriteAnimFirst + 0,  0, 183 + SpriteXOffset, 68 + SpriteYOffset	//; Clock Black
		.byte SpriteAnimFirst + 3,  6, 186 + SpriteXOffset, 70 + SpriteYOffset	//; Clock Shadow
		.byte SpriteAnimFirst + 4, 10, 133 + SpriteXOffset, 59 + SpriteYOffset	//; Eyes: Closed
		.byte SpriteAnimFirst + 5,  1, 133 + SpriteXOffset, 59 + SpriteYOffset	//; Eyes: Open
		.byte SpriteAnimFirst + 6,  1, 182 + SpriteXOffset, 60 + SpriteYOffset	//; Alarm Sound
		.byte SpriteAnimFirst + 7, 12, 133 + SpriteXOffset, 30 + SpriteYOffset	//; Zz
		.byte SpriteAnimFirst + 8, 12, 133 + SpriteXOffset, 30 + SpriteYOffset	//; Zzz
		
	BI_EyesOpen:
		.byte $00
		
	.print "* $" + toHexString(BI_LocalData) + "-$" + toHexString(EndBI_LocalData - 1) + " BI_LocalData"
	
EndBI_LocalData:

//; BI_Init() -------------------------------------------------------------------------------------------------------
BI_Init:
		lda #$00
		sta ValueD011
		sta Signal_VBlank
	BI_WaitForVBlank:
		lda Signal_VBlank
		beq BI_WaitForVBlank

		ldx #$00
	KP_SetColourScreen:
		lda $4400,x
		sta $d800,x
		lda $4500,x
		sta $d900,x
		lda $4600,x
		sta $da00,x
		lda $46e8,x
		sta $dae8,x
		inx
		bne KP_SetColourScreen
		
		jsr BI_DisplaySprites

		lda #$00
		sta spriteEnable
		sta spriteMulticolorMode
		sta spriteDoubleWidth
		sta spriteDoubleHeight
		sta spriteXMSB
		sta spriteDrawPriority
		
		lda #$0c
		sta $d021
		lda #$3d
		sta $dd02
		lda #((ScreenBank0 * 16) + (BitmapBank0 * 8))
        sta $d018
        lda #$18
        sta $d016	

		sei
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		lda #$3b
		sta $d011

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(BI_Init) + "-$" + toHexString(EndBI_Init - 1) + " BI_Init"
EndBI_Init:

//; BI_End() -------------------------------------------------------------------------------------------------------
BI_End:
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(BI_End) + "-$" + toHexString(EndBI_End - 1) + " BI_End"
EndBI_End:

//; BI_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
BI_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		jsr BI_DisplaySprites
		
		inc FrameOf256
		bne BI_Skip256Counter
		inc Frame_256Counter
	BI_Skip256Counter:
	
		lda Frame_256Counter
		cmp #$04
		bne BI_NotFinishedYet
		lda FrameOf256
		cmp #$40
		bne BI_NotFinishedYet
		
		inc Signal_CurrentEffectIsFinished

	BI_NotFinishedYet:
		jsr Music_Play

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(BI_IRQ_VBlank) + "-$" + toHexString(EndBI_IRQ_VBlank - 1) + " BI_IRQ_VBlank"
EndBI_IRQ_VBlank:

//; BI_IRQ_DrawYears() -------------------------------------------------------------------------------------------------------
BI_IRQ_DrawYears:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda BI_SpriteValues + 0
		clc
		adc #StartSpriteIndex
		sta SPRITE0_Val_Bank0
		clc
		adc #10
		sta SPRITE4_Val_Bank0
		lda BI_SpriteValues + 1
		clc
		adc #StartSpriteIndex
		sta SPRITE1_Val_Bank0
		clc
		adc #10
		sta SPRITE5_Val_Bank0
		lda BI_SpriteValues + 2
		clc
		adc #StartSpriteIndex
		sta SPRITE2_Val_Bank0
		clc
		adc #10
		sta SPRITE6_Val_Bank0
		lda BI_SpriteValues + 3
		clc
		adc #StartSpriteIndex
		sta SPRITE3_Val_Bank0
		clc
		adc #10
		sta SPRITE7_Val_Bank0

		lda #$82
		sta spriteX + (0 * 2)
		sta spriteX + (4 * 2)
		lda #$97
		sta spriteX + (1 * 2)
		sta spriteX + (5 * 2)
		lda #$ac
		sta spriteX + (2 * 2)
		sta spriteX + (6 * 2)
		lda #$c1
		sta spriteX + (3 * 2)
		sta spriteX + (7 * 2)
		
		ldx #$00
		ldy #$00
	KP_SetupSpriteData:
		lda #$d4
		sta spriteY + (0 * 2),x
		sta spriteY + (4 * 2),x
		lda #$01
		sta SPRITE0_Color,y
		lda #$0c
		sta SPRITE4_Color,y
		inx
		inx
		iny
		cpy #$04
		bne KP_SetupSpriteData
		
 		lda #$ff
 		sta spriteEnable

		lda Frame_256Counter
		cmp #$00
		beq BI_JumpDontAdvanceClock
		cmp #$02
		bcs BI_AdvanceClock
		lda FrameOf256
		cmp #$70
		bcs BI_AdvanceClock
	BI_JumpDontAdvanceClock:
		jmp BI_DontAdvanceClock
		
	BI_AdvanceClock:
		lda #$00
		clc
		adc #$01
		cmp #$0c
		bne BI_DontChangeClockYears
		
/*		
		lda FrameOf256
		and #$0f
		bne BI_DontAdvanceClock
*/		
		lda BI_SpriteValues + 3
		clc
		adc #$01
		cmp #$0a
		bne BI_DontAdvance3
		
		lda BI_SpriteValues + 2
		clc
		adc #$01
		cmp #$0a
		bne BI_DontAdvance2
		
		lda BI_SpriteValues + 1
		clc
		adc #$01
		cmp #$0a
		bne BI_DontAdvance1
		
		lda BI_SpriteValues + 0
		clc
		adc #$01
		sta BI_SpriteValues + 0
		
		lda #$00
	BI_DontAdvance1:
		sta BI_SpriteValues + 1
		lda #$00
	BI_DontAdvance2:
		sta BI_SpriteValues + 2
		lda #$00
	BI_DontAdvance3:
		sta BI_SpriteValues + 3
		
		lda BI_SpriteValues + 0
		cmp #2
		bne BI_DontOpenEyes
		lda BI_SpriteValues + 1
		cmp #0
		bne BI_DontOpenEyes
		lda BI_SpriteValues + 2
		cmp #1
		bne BI_DontOpenEyes
		lda BI_SpriteValues + 3
		cmp #9
		bne BI_DontOpenEyes
		lda #8
		sta BI_SpriteValues + 3

		lda #$01	//; Eyes open in 2018
		sta BI_EyesOpen
		
	BI_DontOpenEyes:
		
		lda #$00

	BI_DontChangeClockYears:
		sta BI_AdvanceClock + 1
		
	BI_DontAdvanceClock:

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(BI_IRQ_DrawYears) + "-$" + toHexString(EndBI_IRQ_DrawYears - 1) + " BI_IRQ_DrawYears"
EndBI_IRQ_DrawYears:

BI_ClockPositionMove:
		.byte $00

//; BI_DisplaySprites() -------------------------------------------------------------------------------------------------------
BI_DisplaySprites:

		//; Clock Display
		lda BI_SpriteAnims + (0 * 4) + 0
		sta SPRITE0_Val_Bank0
		lda BI_SpriteAnims + (0 * 4) + 1
		sta SPRITE0_Color
		lda BI_SpriteAnims + (0 * 4) + 2
		sta $d000
		lda BI_SpriteAnims + (0 * 4) + 3
		sec
		sbc BI_ClockPositionMove
		sta $d001
		
		//; Clock Front
		lda BI_SpriteAnims + (1 * 4) + 00
		sta SPRITE1_Val_Bank0
		lda BI_SpriteAnims + (1 * 4) + 1
		sta SPRITE1_Color
		lda BI_SpriteAnims + (1 * 4) + 2
		sta $d002
		lda BI_SpriteAnims + (1 * 4) + 3
		sec
		sbc BI_ClockPositionMove
		sta $d003
		
		//; Clock Black
		lda BI_SpriteAnims + (2 * 4) + 0
		sta SPRITE2_Val_Bank0
		lda BI_SpriteAnims + (2 * 4) + 1
		sta SPRITE2_Color
		lda BI_SpriteAnims + (2 * 4) + 2
		sta $d004
		lda BI_SpriteAnims + (2 * 4) + 3
		sec
		sbc BI_ClockPositionMove
		sta $d005
		
		//; Clock Shadow
		lda BI_SpriteAnims + (3 * 4) + 0
		sta SPRITE3_Val_Bank0
		lda BI_SpriteAnims + (3 * 4) + 1
		sta SPRITE3_Color
		lda BI_ClockPositionMove
		lsr
		clc
		adc BI_SpriteAnims + (3 * 4) + 2
		sta $d006
		lda BI_SpriteAnims + (3 * 4) + 3
		sta $d007
		
		//; Eyes Open/Closed
		lda BI_EyesOpen
		asl
		asl
		tax
		
		lda BI_SpriteAnims + (4 * 4) + 0,x
		sta SPRITE4_Val_Bank0
		lda BI_SpriteAnims + (4 * 4) + 1,x
		sta SPRITE4_Color
		lda BI_SpriteAnims + (4 * 4) + 2,x
		sta $d008
		lda BI_SpriteAnims + (4 * 4) + 3,x
		sta $d009
		
		//; Zzz
		lda FrameOf256
		and #$1f
		cmp #$10
		bcc BI_ZZZ
	BI_ZZ:
		ldx BI_SpriteAnims + (7 * 4) + 0
		jmp BI_ChosenZZZs
	BI_ZZZ:
		ldx BI_SpriteAnims + (8 * 4) + 0
	BI_ChosenZZZs:
		stx SPRITE5_Val_Bank0
		lda BI_SpriteAnims + (8 * 4) + 1
		sta SPRITE5_Color
		lda BI_SpriteAnims + (8 * 4) + 2
		sta $d00a
		lda BI_SpriteAnims + (8 * 4) + 3
		sta $d00b
		
		//; Alarm Sound
		lda BI_SpriteAnims + (6 * 4) + 0
		sta SPRITE6_Val_Bank0
		lda #$01
		sta SPRITE6_Color
		lda BI_SpriteAnims + (6 * 4) + 2
		sta $d00c
		lda BI_SpriteAnims + (6 * 4) + 3
		sec
		sbc BI_ClockPositionMove
		sta $d00d
		
		//; Disable 6 (alarm), enable 5 (Zzz)
		ldx #$3f
		lda BI_EyesOpen
		beq BI_EyesClosed

	BI_ClockSin:
		ldx #$00
		lda BI_AlarmClockSinTable,x
		sta BI_ClockPositionMove
		lda BI_ClockSin + 1
		clc
		adc #$03
		and #$3f
		sta BI_ClockSin + 1

		ldx #$5f

		lda FrameOf256
		and #$0f
		bne BI_EyesClosed
		
		// flash the clock face
		lda BI_SpriteAnims + (0 * 4) + 1
		eor #$0f //; alternate between light green and red
		sta BI_SpriteAnims + (0 * 4) + 1
	BI_EyesClosed:
		stx spriteEnable
	
		rts

		.print "* $" + toHexString(BI_DisplaySprites) + "-$" + toHexString(EndBI_DisplaySprites - 1) + " BI_DisplaySprites"
EndBI_DisplaySprites:

