//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 1 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 7 //; 6=Bank+[3800,3fff]
	.var ScreenBank0 = 13 //; 15=Bank+[3400,37ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)

	.var sinSpacing = 4
		
	.var XSpriteCircleMovement = $e0
	.var XDiskLogoMovementBytes = $e1
	.var XDiskLogoMovementBits = $e2
	.var SpriteMSBValue = $e4
	.var SpriteCircleBaseSprite0 = 128
	.var SpriteCircleBaseSprite1 = 160
	.var CircleSpriteWriteAddress0 = BaseBankAddress + (SpriteCircleBaseSprite0 * 64)
	.var CircleSpriteWriteAddress1 = BaseBankAddress + (SpriteCircleBaseSprite1 * 64)

* = SpriteBobs_BASE "Sprite Bobs"

	JumpTable:
		jmp SB_Init
		jmp IRQManager_RestoreDefaultIRQ
		jmp SB_MainThread
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
		
//; SB_LocalData -------------------------------------------------------------------------------------------------------
SB_LocalData:
	.var IRQNum = 7
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$47,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$5A,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$76,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$9A,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$BF,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$E0,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$EC,			<SB_IRQ_VBlank,				>SB_IRQ_VBlank

	SB_LogoColorTable:
		.byte $0b, $0c, $08, $07, $04, $0a, $06, $0e 

	SB_ColorLines_Lo:
		.byte <(ColorMemory +  0 * 40)
		.byte <(ColorMemory +  1 * 40)
		.byte <(ColorMemory +  2 * 40)
		.byte <(ColorMemory +  3 * 40)
		.byte <(ColorMemory +  4 * 40)
		.byte <(ColorMemory +  5 * 40)
		.byte <(ColorMemory +  6 * 40)
		.byte <(ColorMemory +  7 * 40)
		.byte <(ColorMemory +  8 * 40)
		.byte <(ColorMemory +  9 * 40)
		.byte <(ColorMemory +  10 * 40)
		.byte <(ColorMemory +  11 * 40)
		.byte <(ColorMemory +  12 * 40)
		.byte <(ColorMemory +  13 * 40)
		.byte <(ColorMemory +  14 * 40)
		.byte <(ColorMemory +  15 * 40)
		.byte <(ColorMemory +  16 * 40)
		.byte <(ColorMemory +  17 * 40)
		.byte <(ColorMemory +  18 * 40)
		.byte <(ColorMemory +  19 * 40)
		.byte <(ColorMemory +  20 * 40)
		.byte <(ColorMemory +  21 * 40)
		.byte <(ColorMemory +  22 * 40)
		.byte <(ColorMemory +  23 * 40)
		.byte <(ColorMemory +  24 * 40)

	SB_ColorLines_Hi:
		.byte >(ColorMemory +  0 * 40)
		.byte >(ColorMemory +  1 * 40)
		.byte >(ColorMemory +  2 * 40)
		.byte >(ColorMemory +  3 * 40)
		.byte >(ColorMemory +  4 * 40)
		.byte >(ColorMemory +  5 * 40)
		.byte >(ColorMemory +  6 * 40)
		.byte >(ColorMemory +  7 * 40)
		.byte >(ColorMemory +  8 * 40)
		.byte >(ColorMemory +  9 * 40)
		.byte >(ColorMemory +  10 * 40)
		.byte >(ColorMemory +  11 * 40)
		.byte >(ColorMemory +  12 * 40)
		.byte >(ColorMemory +  13 * 40)
		.byte >(ColorMemory +  14 * 40)
		.byte >(ColorMemory +  15 * 40)
		.byte >(ColorMemory +  16 * 40)
		.byte >(ColorMemory +  17 * 40)
		.byte >(ColorMemory +  18 * 40)
		.byte >(ColorMemory +  19 * 40)
		.byte >(ColorMemory +  20 * 40)
		.byte >(ColorMemory +  21 * 40)
		.byte >(ColorMemory +  22 * 40)
		.byte >(ColorMemory +  23 * 40)
		.byte >(ColorMemory +  24 * 40)

	SB_InvertedFrameOf4:	//; we invert the standard FrameOf4
		.byte $00
		
	SB_IsInWinddownPhase:
		.byte $00
		
	ScrollText:
		.import binary "\Intermediate\Built\SpriteBobs-ScrollText.bin"

	sintableXSpriteMovement_128:
		.import binary "\Intermediate\Built\SpriteBobs-SinTable-XSpriteMovement128.bin"

	DrawSpriteJumpTable_Lo:
		.byte <DrawSprites_Frame3, <DrawSprites_Frame0, <DrawSprites_Frame1, <DrawSprites_Frame2
	
	DrawSpriteJumpTable_Hi:
		.byte >DrawSprites_Frame3, >DrawSprites_Frame0, >DrawSprites_Frame1, >DrawSprites_Frame2
	
	SpriteMultiplexJumpTable_Lo:
    	.byte <SpriteMultiplex_Frame0_Section0, <SpriteMultiplex_Frame1_Section0, <SpriteMultiplex_Frame2_Section0, <SpriteMultiplex_Frame3_Section0
    	.byte <SpriteMultiplex_Frame0_Section1, <SpriteMultiplex_Frame1_Section1, <SpriteMultiplex_Frame2_Section1, <SpriteMultiplex_Frame3_Section1
    	.byte <SpriteMultiplex_Frame0_Section2, <SpriteMultiplex_Frame1_Section2, <SpriteMultiplex_Frame2_Section2, <SpriteMultiplex_Frame3_Section2
    	.byte <SpriteMultiplex_Frame0_Section3, <SpriteMultiplex_Frame1_Section3, <SpriteMultiplex_Frame2_Section3, <SpriteMultiplex_Frame3_Section3
    	.byte <SpriteMultiplex_Frame0_Section4, <SpriteMultiplex_Frame1_Section4, <SpriteMultiplex_Frame2_Section4, <SpriteMultiplex_Frame3_Section4
    	.byte <SpriteMultiplex_Frame0_Section5, <SpriteMultiplex_Frame1_Section5, <SpriteMultiplex_Frame2_Section5, <SpriteMultiplex_Frame3_Section5
    	.byte <SpriteMultiplex_Frame0_Section6, <SpriteMultiplex_Frame1_Section6, <SpriteMultiplex_Frame2_Section6, <SpriteMultiplex_Frame3_Section6
	
	SpriteMultiplexJumpTable_Hi:
    	.byte >SpriteMultiplex_Frame0_Section0, >SpriteMultiplex_Frame1_Section0, >SpriteMultiplex_Frame2_Section0, >SpriteMultiplex_Frame3_Section0
    	.byte >SpriteMultiplex_Frame0_Section1, >SpriteMultiplex_Frame1_Section1, >SpriteMultiplex_Frame2_Section1, >SpriteMultiplex_Frame3_Section1
    	.byte >SpriteMultiplex_Frame0_Section2, >SpriteMultiplex_Frame1_Section2, >SpriteMultiplex_Frame2_Section2, >SpriteMultiplex_Frame3_Section2
    	.byte >SpriteMultiplex_Frame0_Section3, >SpriteMultiplex_Frame1_Section3, >SpriteMultiplex_Frame2_Section3, >SpriteMultiplex_Frame3_Section3
    	.byte >SpriteMultiplex_Frame0_Section4, >SpriteMultiplex_Frame1_Section4, >SpriteMultiplex_Frame2_Section4, >SpriteMultiplex_Frame3_Section4
    	.byte >SpriteMultiplex_Frame0_Section5, >SpriteMultiplex_Frame1_Section5, >SpriteMultiplex_Frame2_Section5, >SpriteMultiplex_Frame3_Section5
    	.byte >SpriteMultiplex_Frame0_Section6, >SpriteMultiplex_Frame1_Section6, >SpriteMultiplex_Frame2_Section6, >SpriteMultiplex_Frame3_Section6

	DrawSprite_ShouldColorScroll:
		.byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4
		 
	DrawSprite_ColorScroll_JumpTable_Lo:    
		.byte <DrawSprite_ColorScroll_Frame0, <DrawSprite_ColorScroll_Frame1, <DrawSprite_ColorScroll_Frame2, <DrawSprite_ColorScroll_Frame3 

	DrawSprite_ColorScroll_JumpTable_Hi:    
		.byte >DrawSprite_ColorScroll_Frame0, >DrawSprite_ColorScroll_Frame1, >DrawSprite_ColorScroll_Frame2, >DrawSprite_ColorScroll_Frame3 

	.print "* $" + toHexString(SB_LocalData) + "-$" + toHexString(EndSB_LocalData - 1) + " SB_LocalData"

EndSB_LocalData:

//; SB_Init() -------------------------------------------------------------------------------------------------------
SB_Init:

		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta ValueSpriteEnable
		sta spriteDoubleWidth	//; make no sprites double-width
		sta spriteDoubleHeight	//; make no sprites double-height
		sta spriteMulticolorMode
		
		lda #$f0
		sta spriteDrawPriority
		
		ldx #$00
	
	//; Clear out the sprite colors and setup
	SetSpriteLoop:
		lda #$00
		sta SPRITE0_Color,x
		lda #SpriteCircleBaseSprite0
		sta SPRITE0_Val_Bank0,x
		inx
		cpx #$08
		bne SetSpriteLoop

		//; clear out the initial sprite data
		lda #<(BaseBankAddress+SpriteCircleBaseSprite0*64)
		sta ClearSpritesLoop+1
		lda #>(BaseBankAddress+SpriteCircleBaseSprite0*64)
		sta ClearSpritesLoop+2
		ldx #$00
		ldy #$00
		lda #$00
	ClearSpritesLoop:
		sta $0000,y
		iny
		bne ClearSpritesLoop
		inc ClearSpritesLoop+2
		inx
		cpx #$10
		bne ClearSpritesLoop
		
		lda #$00
		tay
	ML_FillScreenLoop:
		sta ScreenAddress0 + 0,y
		sta ScreenAddress0 + 256,y
		sta ScreenAddress0 + 512,y
		sta ScreenAddress0 + 744,y
		sta ColorMemory + 0,y
		sta ColorMemory + 256,y
		sta ColorMemory + 512,y
		sta ColorMemory + 744,y
		iny
		bne ML_FillScreenLoop

		ldy #$00
	SB_CentreLine:
		lda #$02
		sta ScreenAddress0 + (12 * 40),y
		lda #$02
		sta ColorMemory + (12 * 40),y
		iny
		cpy #$28
		bne SB_CentreLine

		lda #$ff
		sta ValueSpriteEnable //; make all sprites visible
 		sta spriteEnable

		lda #$00
		sta ValueD021
 		sta $d021
		
		lda #$1b
 		sta $d011
		lda #((ScreenBank0 * 16) + (CharBank * 2))
 		sta $d018
		lda ValueDD02
		sta $dd02

		sei
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(SB_Init) + "-$" + toHexString(EndSB_Init - 1) + " SB_Init"
EndSB_Init:

//; SB_IRQ_SpriteSection() -------------------------------------------------------------------------------------------------------
SB_IRQ_SpriteSection:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		jsr SB_Multiplex
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SB_IRQ_SpriteSection) + "-$" + toHexString(EndSB_IRQ_SpriteSection - 1) + " SB_IRQ_SpriteSection"
EndSB_IRQ_SpriteSection:
		
//; SB_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SB_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:
		lda FrameOf256
		and #$7f
		sta FrameOf128
		and #$03
		sta FrameOf4
		eor #$03
		sta SB_InvertedFrameOf4
		cmp #$00
		bne DontScroll
		jsr AdvanceCircleText
	DontScroll:

		ldx FrameOf128
		lda sintableXSpriteMovement_128,x
		sta XSpriteCircleMovement

		jsr Music_Play
	
 		lda ValueD016
 		sta $d016

		lda #$00
		sta SB_Multiplex + 1
		jsr SB_Multiplex

		jsr SB_Draw
		
		jsr SB_DoLogoColorUpdates

		//; Tell the main thread that the VBlank has run
		inc Signal_VBlank

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SB_IRQ_VBlank) + "-$" + toHexString(EndSB_IRQ_VBlank - 1) + " SB_IRQ_VBlank"
EndSB_IRQ_VBlank:

//; SB_Draw() -------------------------------------------------------------------------------------------------------
SB_Draw:
	SpriteBobsDrawIndex:
		lda #$00
		clc
		adc #$01
		cmp #12
		bne WithinRange
		lda #$00
	WithinRange:
		sta SpriteBobsDrawIndex + 1
		tax
		lda DrawSprite_ShouldColorScroll,x
		beq NoColorScroll
		tay
		lda DrawSprite_ColorScroll_JumpTable_Lo - 1,y	
		sta Sprite_ColorScroll_SelfModifiedJump+1	
		lda DrawSprite_ColorScroll_JumpTable_Hi - 1,y	
		sta Sprite_ColorScroll_SelfModifiedJump+2	
	Sprite_ColorScroll_SelfModifiedJump:	
		jsr $ffff
		
	NoColorScroll:	
		ldy SB_InvertedFrameOf4
		lda DrawSpriteJumpTable_Lo,y
		sta Sprite_SelfModifiedJump+1
		lda DrawSpriteJumpTable_Hi,y
		sta Sprite_SelfModifiedJump+2
	Sprite_SelfModifiedJump:
		jmp $FFFF

		.print "* $" + toHexString(SB_Draw) + "-$" + toHexString(EndSB_Draw - 1) + " SB_Draw"
EndSB_Draw:
   
//; SB_Multiplex() -------------------------------------------------------------------------------------------------------
SB_Multiplex:
		lda #$01
		clc
		rol
		rol
		adc SB_InvertedFrameOf4
		tay
		lda SpriteMultiplexJumpTable_Lo,y
		sta SpriteMultiplex_SelfModifiedJump+1
		lda SpriteMultiplexJumpTable_Hi,y
		sta SpriteMultiplex_SelfModifiedJump+2
		inc SB_Multiplex + 1
	SpriteMultiplex_SelfModifiedJump:
		jmp $FFFF

		.print "* $" + toHexString(SB_Multiplex) + "-$" + toHexString(EndSB_Multiplex - 1) + " SB_Multiplex"
EndSB_Multiplex:

//; SB_FillColorLine() -------------------------------------------------------------------------------------------------------
SB_FillColorLine:
		ldx SB_ColorLines_Lo,y
		stx FillColorAddress + 1
		inx
		stx FillColorAddress + 4
		inx
		stx FillColorAddress + 7
		inx
		stx FillColorAddress + 10
		ldx SB_ColorLines_Hi,y
		stx FillColorAddress + 2
		stx FillColorAddress + 5
		stx FillColorAddress + 8
		stx FillColorAddress + 11

		ldy #$24
	FillColorAddress:	
		sta $ffff,y	
		sta $ffff,y	
		sta $ffff,y	
		sta $ffff,y
		dey
		dey
		dey
		dey
		bpl FillColorAddress
		rts	

		.print "* $" + toHexString(SB_FillColorLine) + "-$" + toHexString(EndSB_FillColorLine - 1) + " SB_FillColorLine"
EndSB_FillColorLine:

//; SB_DoLogoColorUpdates() -------------------------------------------------------------------------------------------------------
SB_DoLogoColorUpdates:

		lda SB_IsInWinddownPhase
		bne SB_InitTimer
		
		lda Signal_ScrollerIsFinished
		beq SB_InitTimer
		
		lda #$01
		sta SB_IsInWinddownPhase
		
		lda #$00
		ldy #$07
	SB_SetAllColorsToBlack:
		sta SB_LogoColorTable,y
		dey
		bpl SB_SetAllColorsToBlack
		
		lda #$00
		sta SB_InitTimer + 1
		
	SB_InitTimer:
		ldy #$00
		inc SB_InitTimer + 1
		cpy #25
		bcc SB_ShouldUpdateColors

		lda SB_IsInWinddownPhase
		beq SB_FinishedColorUpdate
		
		lda #$01
		sta Signal_CurrentEffectIsFinished
		
		rts
		
	SB_ShouldUpdateColors:
		cpy #12
		bne SB_ColorLookup
		
		inc SB_ColorLookup + 1
		rts
		
	SB_ColorLookup:
		lda #$00
		and #$07
		tax
		lda SB_LogoColorTable,x
		jsr SB_FillColorLine
		
		lda SB_InitTimer + 1
		cmp #25
		bne SB_FinishedColorUpdate
		inc SB_ColorLookup + 1

	SB_FinishedColorUpdate:
		rts
	

		.print "* $" + toHexString(SB_DoLogoColorUpdates) + "-$" + toHexString(EndSB_DoLogoColorUpdates - 1) + " SB_DoLogoColorUpdates"
EndSB_DoLogoColorUpdates:
		
//; SB_MainThread() -------------------------------------------------------------------------------------------------------
SB_MainThread:
		.if(ShowTimings)
		{
			inc $d020
		}

		ldy FrameOf256
		lda $ce00,y
		eor #$07
		sta ML_SmoothScroll0+1
		lda $cf00,y
		sta ML_LoadX1 + 1
		clc
		adc #$27
		sta ML_LoadY1 + 1
		
		lda FrameOf256
		clc
		adc #$54
		tay
		lda $ce00,y
		eor #$07
		sta ML_SmoothScroll1+1
		lda $cf00,y
		tax
		clc
		adc #$27
		tay

	ML_SmoothScroll0:
		lda #$00
		sta ValueD016
		
		jsr MassiveLogo_Draw_BottomLogo
			
		.if(ShowTimings)
		{
			dec $d020
		}

		lda #$92
	WaitForMidScreen:
		cmp $d012
		bcs WaitForMidScreen

		.if(ShowTimings)
		{
			inc $d020
		}

	ML_SmoothScroll1:
		lda #$00
		sta $d016

	ML_LoadX1:
		ldx #$00
	ML_LoadY1:
		ldy #$00

		jsr MassiveLogo_Draw_TopLogo

		.if(ShowTimings)
		{
			dec $d020
		}

		rts

		.print "* $" + toHexString(SB_MainThread) + "-$" + toHexString(EndSB_MainThread - 1) + " SB_MainThread"
EndSB_MainThread:

SpriteBobsMultiplexASM:
		.import source "\Intermediate\Built\SpriteBobs-Multiplex.asm"
		.print "* $" + toHexString(SpriteBobsMultiplexASM) + "-$" + toHexString(EndSpriteBobsMultiplexASM - 1) + " SpriteBobsMultiplexASM"
EndSpriteBobsMultiplexASM:
	
SpriteBobsDrawASM:
		.import source "\Intermediate\Built\SpriteBobs-Draw.asm"
		.print "* $" + toHexString(SpriteBobsDrawASM) + "-$" + toHexString(EndSpriteBobsDrawASM - 1) + " SpriteBobsDrawASM"
EndSpriteBobsDrawASM:
	
SpriteBobsFontsDataASM:
		.import source "\Intermediate\Built\SpriteBobs-FontsData.asm"
		.print "* $" + toHexString(SpriteBobsFontsDataASM) + "-$" + toHexString(EndSpriteBobsFontsDataASM - 1) + " SpriteBobsFontsDataASM"
EndSpriteBobsFontsDataASM:

