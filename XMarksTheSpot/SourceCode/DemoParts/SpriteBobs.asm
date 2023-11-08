//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = SpriteBobs_BASE "Sprite Bobs"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; - $3000-9f3f Code+Data
//; ---- $c000-c7ff Sprites (Frame 0)
//; ---- $c800-cfff Sprites (Frame 1)
//; - $e000-ff3f Bitmap

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp SB_Init							//; Init
		jmp	SB_MainThread					//; MainThreadFunc
		jmp SB_Exit							//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var Base_BankAddress = (BaseBank * $4000)
	.var CharBank = 6 //; Bank+[3000,37ff]
	.var ScreenBank = 12 //; Bank+[3000,33ff]
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var SpriteCircleBaseSprite0 = 128
	.var SpriteCircleBaseSprite1 = 160
	.var SpriteCircleBaseSprite2 = 128
	.var SpriteCircleBaseSprite3 = 160
	.var CircleSpriteWriteAddress0 = Base_BankAddress + (SpriteCircleBaseSprite0 * 64)
	.var CircleSpriteWriteAddress1 = Base_BankAddress + (SpriteCircleBaseSprite1 * 64)
	.var CircleSpriteWriteAddress2 = Base_BankAddress + (SpriteCircleBaseSprite2 * 64)
	.var CircleSpriteWriteAddress3 = Base_BankAddress + (SpriteCircleBaseSprite3 * 64)

//; SB_LocalData -------------------------------------------------------------------------------------------------------
SB_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$fc,			<SB_IRQ_VBlank,				>SB_IRQ_VBlank
		.byte	$00,			$47,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$5A,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$76,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$9A,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$BF,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$00,			$E0,			<SB_IRQ_SpriteSection,		>SB_IRQ_SpriteSection
		.byte	$ff

	SB_InvertedFrameOf4:	//; we invert the standard FrameOf4
		.byte $00
	XSpriteCircleMovement:
		.byte $00
	XDiskLogoMovementBytes:
		.byte $00
	XDiskLogoMovementBits:
		.byte $00
	SpriteMSBValue:
		.byte $00
		
	ScrollText:
		.import binary "..\..\Intermediate\Built\SpriteBobs\ScrollText.bin"

	sintableXSpriteMovement_128:
		.import binary "..\..\Intermediate\Built\SpriteBobs\SinTable-XSpriteMovement128.bin"

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

	DrawSprite_ShouldColourScroll:
		.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4
		 
	DrawSprite_ColourScroll_JumpTable_Lo:    
		.byte <DrawSprite_ColourScroll_Frame0, <DrawSprite_ColourScroll_Frame1, <DrawSprite_ColourScroll_Frame2, <DrawSprite_ColourScroll_Frame3 
	DrawSprite_ColourScroll_JumpTable_Hi:    
		.byte >DrawSprite_ColourScroll_Frame0, >DrawSprite_ColourScroll_Frame1, >DrawSprite_ColourScroll_Frame2, >DrawSprite_ColourScroll_Frame3 

	.print "* $" + toHexString(SB_LocalData) + "-$" + toHexString(EndSB_LocalData - 1) + " SB_LocalData"

EndSB_LocalData:

//; SB_Init() -------------------------------------------------------------------------------------------------------
SB_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleWidth
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteDrawPriority
		
	//; Clear out the sprite colours and setup
		ldx #$00
	SetSpriteLoop:
		lda #$00
		sta VIC_Sprite0Colour, x
		lda #SpriteCircleBaseSprite0
		sta Bank_SpriteVals, x
		inx
		cpx #$08
		bne SetSpriteLoop

		//; clear out the initial sprite data
		lda #<CircleSpriteWriteAddress0
		sta ClearSpritesLoop0+1
		sta ClearSpritesLoop1+1
		sta ClearSpritesLoop2+1
		sta ClearSpritesLoop3+1
		lda #>CircleSpriteWriteAddress0
		sta ClearSpritesLoop0+2
		lda #>CircleSpriteWriteAddress1
		sta ClearSpritesLoop1+2
		lda #>CircleSpriteWriteAddress2
		sta ClearSpritesLoop2+2
		lda #>CircleSpriteWriteAddress3
		sta ClearSpritesLoop3+2

		ldx #$08
		ldy #$00
	ClearSpritesLoop:
		lda #$00
	ClearSpritesLoop0:
		sta $0000, y
	ClearSpritesLoop1:
		sta $0000, y
	ClearSpritesLoop2:
		sta $0000, y
	ClearSpritesLoop3:
		sta $0000, y
		iny
		bne ClearSpritesLoop0
		inc ClearSpritesLoop0+2
		inc ClearSpritesLoop1+2
		inc ClearSpritesLoop2+2
		inc ClearSpritesLoop3+2
		dex
		bne ClearSpritesLoop
		
		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(SB_Init) + "-$" + toHexString(EndSB_Init - 1) + " SB_Init"
EndSB_Init:

//; SB_Exit() -------------------------------------------------------------------------------------------------------
SB_Exit:
		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(SB_Exit) + "-$" + toHexString(EndSB_Exit - 1) + " SB_Exit"
EndSB_Exit:

//; SB_IRQ_SpriteSection() -------------------------------------------------------------------------------------------------------
SB_IRQ_SpriteSection:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)
		
		jsr SB_Multiplex
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(SB_IRQ_SpriteSection) + "-$" + toHexString(EndSB_IRQ_SpriteSection - 1) + " SB_IRQ_SpriteSection"
EndSB_IRQ_SpriteSection:
		
//; SB_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SB_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)

		:Start_ShowTiming(0)
		
		lda #$3b
		sta VIC_D011

		lda #$ff
 		sta VIC_SpriteEnable

		inc FrameOf256
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
		lda Signal_ScrollerIsFinished
		sta Signal_CurrentEffectIsFinished
	DontScroll:

		ldx FrameOf128
		lda sintableXSpriteMovement_128, x
		sta XSpriteCircleMovement

		jsr Music_Play
	
		lda #$00
		sta SB_Multiplex + 1
		jsr SB_Multiplex

		inc Signal_VBlank //; Tell the main thread that the VBlank has run

		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(SB_IRQ_VBlank) + "-$" + toHexString(EndSB_IRQ_VBlank - 1) + " SB_IRQ_VBlank"
EndSB_IRQ_VBlank:

//; SB_Draw() -------------------------------------------------------------------------------------------------------
SB_Draw:
	SpriteBobsDrawIndex:
		lda #$00
		clc
		adc #$01
		cmp #16
		bne WithinRange
		lda #$00
	WithinRange:
		sta SpriteBobsDrawIndex + 1
		tax
		lda DrawSprite_ShouldColourScroll, x
		beq NoColourScroll
		tay
		lda DrawSprite_ColourScroll_JumpTable_Lo - 1, y	
		sta Sprite_ColourScroll_SelfModifiedJump+1	
		lda DrawSprite_ColourScroll_JumpTable_Hi - 1, y	
		sta Sprite_ColourScroll_SelfModifiedJump+2	
	Sprite_ColourScroll_SelfModifiedJump:	
		jsr $ffff
		
	NoColourScroll:	
		ldy SB_InvertedFrameOf4
		lda DrawSpriteJumpTable_Lo, y
		sta Sprite_SelfModifiedJump+1
		lda DrawSpriteJumpTable_Hi, y
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
		lda SpriteMultiplexJumpTable_Lo, y
		sta SpriteMultiplex_SelfModifiedJump+1
		lda SpriteMultiplexJumpTable_Hi, y
		sta SpriteMultiplex_SelfModifiedJump+2
		inc SB_Multiplex + 1
	SpriteMultiplex_SelfModifiedJump:
		jmp $FFFF

		.print "* $" + toHexString(SB_Multiplex) + "-$" + toHexString(EndSB_Multiplex - 1) + " SB_Multiplex"
EndSB_Multiplex:

//; SB_MainThread() -------------------------------------------------------------------------------------------------------
SB_MainThread:

		:Start_ShowTiming(0)
		
		jsr SB_Draw

		:Stop_ShowTiming(0)

		rts

		.print "* $" + toHexString(SB_MainThread) + "-$" + toHexString(EndSB_MainThread - 1) + " SB_MainThread"
EndSB_MainThread:

SpriteBobsMultiplexASM:
		.import source "..\..\Intermediate\Built\SpriteBobs\Multiplex.asm"
		.print "* $" + toHexString(SpriteBobsMultiplexASM) + "-$" + toHexString(EndSpriteBobsMultiplexASM - 1) + " SpriteBobsMultiplexASM"
EndSpriteBobsMultiplexASM:
	
SpriteBobsDrawASM:
		.import source "..\..\Intermediate\Built\SpriteBobs\Draw.asm"
		.print "* $" + toHexString(SpriteBobsDrawASM) + "-$" + toHexString(EndSpriteBobsDrawASM - 1) + " SpriteBobsDrawASM"
EndSpriteBobsDrawASM:
	
SpriteBobsFontsDataASM:
		.import source "..\..\Intermediate\Built\SpriteBobs\FontsData.asm"
		.print "* $" + toHexString(SpriteBobsFontsDataASM) + "-$" + toHexString(EndSpriteBobsFontsDataASM - 1) + " SpriteBobsFontsDataASM"
EndSpriteBobsFontsDataASM:

